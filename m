Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25528 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727108AbfDDMu7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Apr 2019 08:50:59 -0400
Date: Thu, 4 Apr 2019 08:50:54 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/4] xfs: force writes to delalloc regions to unwritten
Message-ID: <20190404125054.GA38253@bfoster>
References: <20190318203506.GQ23020@dastard>
 <20190318215014.GA21231@bfoster>
 <20190319180249.GS4929@magnolia>
 <20190319202537.GR23020@dastard>
 <20190320120204.GA28268@bfoster>
 <20190320211019.GS23020@dastard>
 <20190321122740.GB33001@bfoster>
 <20190322015240.GX23020@dastard>
 <20190322124615.GB37888@bfoster>
 <20190403223809.GL5147@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190403223809.GL5147@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Wed, Apr 03, 2019 at 03:38:09PM -0700, Darrick J. Wong wrote:
> On Fri, Mar 22, 2019 at 08:46:15AM -0400, Brian Foster wrote:
> > On Fri, Mar 22, 2019 at 12:52:40PM +1100, Dave Chinner wrote:
> > > On Thu, Mar 21, 2019 at 08:27:40AM -0400, Brian Foster wrote:
> > > > On Thu, Mar 21, 2019 at 08:10:19AM +1100, Dave Chinner wrote:
> > > > > On Wed, Mar 20, 2019 at 08:02:05AM -0400, Brian Foster wrote:
> > > > > > On Wed, Mar 20, 2019 at 07:25:37AM +1100, Dave Chinner wrote:
> > > > > > > > > The broader point is that by controlling writeback ordering, we can
> > > > > > > > > explicitly demonstrate stale data exposure. If fixed properly, we should
> > > > > > > > > never expect stale data exposure even in the event of out of order
> > > > > > > > > writeback completion, regardless of the cause.
> > > > > > > > 
> > > > > > > > Agree.  Even if s_f_r is a giant trash fire, if we're exposing stale
> > > > > > > > disk contents it's game over anyway and we ought to fix it.
> > > > > > > 
> > > > > > > Well, that's exactly the problem with SFR, isn't it? The dirty data
> > > > > > > is outside the range the user asks to sync and the implementation
> > > > > > > doesn't go anywhere near the filesystem so we can't actually do the
> > > > > > > right thing here. So we are left to either hack fixes around a
> > > > > > > shitty, broken interface and everyone pays the penalty, or we ignore
> > > > > > > it. We've simply ignored it for the past 10+ years because it really
> > > > > > > can't be used safely for it's intended purposes (as everyone who
> > > > > > > tries to use it finds out eventually)...
> > > > > > > 
> > > > > > 
> > > > > > Just to make this abundantly clear, there is nothing unique, magic or
> > > > > > special required of sync_file_range() to reproduce this stale data
> > > > > > exposure. See the following variation of a command sequence from the
> > > > > > fstest I posted the other day:
> > > > > > 
> > > > > > ...
> > > > > > # xfs_io -fc "pwrite 0 68k" -c fsync -c "pwrite 96k 4k" \
> > > > > > 	-c "fpunch 96k 4k" <file>
> > > > > > ...
> > > > > > # hexdump <file>
> > > > > > 0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
> > > > > > *
> > > > > > 0011000 abab abab abab abab abab abab abab abab
> > > > > > *
> > > > > > 0018000 0000 0000 0000 0000 0000 0000 0000 0000
> > > > > > *
> > > > > > 0019000
> > > > > > 
> > > > > > Same problem, and it can be reproduced just as easily with a reflink or
> > > > > > even an overlapping direct I/O.
> > > > > 
> > > > > How does overlapping direct IO cause stale data exposure given that
> > > > > it uses unwritten extent allocation? That, of course, is ignoring
> > > > > the fact that the result of overlapping concurent direct IO is, by
> > > > > definition, undefined and an application bug if it occurs....
> > > > > 
> > > > 
> > > > It's overlapping a buffered write and so starts with a flush instead of
> > > 
> > > Ok, but that's not the normal usage of the phrase "overlapping
> > > direct IO".  Overlapping direct IO means two concurrent direct IOs
> > > to the same LBA range in the device underlying the filesystem. i.e.
> > > they overlap in both the temporal and physical (device LBA) domains.
> > > 
> > > Subtle difference, yes, but a very important one.
> > > 
> > 
> > Yeah, I just referenced it in passing and was unclear. The point is just
> > that there are multiple vectors to the problem, some of which are sane
> > sequences and some apparently not, and I'd rather not get caught up in
> > the minutiae of why some of those sequences are not sane. I'm trying to
> > see if we can find a solution to the fundamental data exposure problem.
> 
> Is there a way to increase the amount of writeback?  Say for example
> that we have a delalloc reservation for blocks 0-9, and writeback asks
> us to write back block 7.  If we succeed at converting the entire
> 10-block reservation into a real extent, why can't we come back and say
> "Hey, we also need to flush the pages for blocks 0-6,8-9"?  Are we going
> to need something like that for blocksize > pagesize filesystems too?
> 

That might be possible in various places. In fact, I think we used to do
something like this in XFS (perhaps not for this purpose). I just jumped
back to v2.6.32 and see that the xfs_cluster_write() mechanism still
exists at that point down in the ->writepage() path.

I'm not sure if doing that alone is worth the effort if you consider
it's more of a mitigation than a solution to the underlying problem.
Once we convert the associated delalloc extent, we're open to stale data
exposure (assuming we're not protected by on-disk EOF and whatnot) until
all of the remaining pages over the extent are written back, whether
that occurs in the current writeback cycle or a subsequent one.

I suppose it might make sense in service to another solution, such as
writing back everything preceding a page that is going to update on-disk
EOF (which is something I think Dave suggested earlier as an incremental
improvement, I've kind of lost track). We'd probably just have to make
sure that the on-disk eof can never get ahead of the lower index
writeback pages by I/O reordering or whatever..

> > 
> > > > an unwritten allocation (so even a dio read is sufficient). Also, the
> > > > target of the dio isn't where stale data is exposed, so even if there
> > > > was an existing underlying unwritten block before the initial buffered
> > > > write it wouldn't change anything.
> > > > 
> > > > Yes, this is technically usage with undefined behavior, but that still
> > > > misses the forest from the trees.
> > > 
> > > No, I'm not missing the forest for the trees.
> > > 
> > > > I'm not claiming this is good or
> > > > supported practice just as I'm not not claiming sync_file_range() should
> > > > be used for anything in practice. I'm just pointing out it's one of
> > > > several possible, obvious data exposure vectors. I suspect there are
> > > > others; these were just the easy variants to reproduce.
> > > 
> > > I'm aware that we have these problems - we've known about them for
> > > 20+ years and the many ways they can be exposed. Indeed, We've been
> > > talking about using unwritten extents for delalloc for as long as I
> > > can remember, but never done it because the actual occurrence of
> > > these problems in production systems is /extremely/ rare and the
> > > cost of using unwritten extents everywhere will affect /everyone/.
> > > 
> > > i.e. It's always been easy to create test conditions to expose stale
> > > data, but reported cases of stale data exposure after a production
> > > system crash are pretty much non-existent. This just isn't a common
> > > problem that users are experiencing, but solving it with "unwritten
> > > extents for everyone" comes at a substantial cost for /everyone/,
> > > /all the time/.
> > > 
> > 
> > I know you're aware. I'm pretty sure we've discussed this directly in
> > the past (with regard to how buffer heads were an impediment to a
> > solution) and that you made me aware of the issue in the first place. ;)
> > 
> > > That's why a) it hasn't been done yet; and b) any discussion about
> > > "use unwritten extents everywhere" always ends up in trying to find
> > > a solution that isn't just applying the "big hammer" and ignoring
> > > the problems that causes.
> > > 
> > 
> > Right..
> > 
> > > > If you prefer to
> > > > reason about reproducer patterns that don't use operations with quirks
> > > > or undefined behaviors, that's fine, just use the reflink or hole punch
> > > > example posted above that produce the same behavior.
> > > 
> > > Well, yes. But it does go both ways - if you don't want people to
> > > say "that's undefined" or "that makes no sense", then don't use
> > > those quirky examples if you can use better, unambiguous examples.
> > > 
> > 
> > The sync_file_range() reproducer was a poor example in that regard. I'm
> 
> (I don't want to stir this up again but just so we're all clear I had
> figured the s_f_r call was really just a way to simulate random drive-by
> scattershot background writeback for testing purposes.)
> 

Ack.

> > not concerned over that being pointed out, but I've explained several
> > times subsequently that we can replace the sync_file_range() calls with
> > a sane command (hole punch) to reproduce the same general behavior and
> > resulting data exposure problem and thus the quirks of the former are
> > not a primary factor. Despite that, this discussion has somehow turned
> > into an appraisal of sync_file_range(). Moving on..
> > 
> > I posted some comments/questions around your log item suggestion for
> > extent zeroing during recovery in my previous reply and that part
> > apparently got completely snipped out and ignored. :/ Any feedback on
> > that?
> 
> A(nother) big downside of adding a new "write intent": now we need to
> add a log incompat flag which will occasionally generate "I wrote
> something, crashed, and this old knoppix cd won't recover the fs for
> some reason" reports.
> 

Yeah, though I think it's not really recommended to process an fs with a
dirty log across kernels like that. We already have some recovery
restrictions that prevent this, such on-disk order for example. Of
course that's different from just going back to an older kernel version
on the same hardware and getting stuck that way because of a feature bit
or something.

> > > For example, that's exactly how I phrased this extension flushing
> > > mechanism trigger:
> > > 
> > > > > Eseentially, what this says to me is we need to track when we
> > > > > extended the file via a write beyond EOF via an inode flag. Then if we need to
> > > > > flush a data range from the file for integrity reasons (such as a
> > > > > fpnuch) and this flag is set, we ignore the "start" parameter of the
> > > 
> > > See? Entirely generic trigger description, uses hole punch as an
> > > example, but also covers all the quirky cases such as direct IO
> > > range flushing without having to mention them explicitly.
> > > 
> > > > > range and flush from the start of the file instead. i.e. we
> > > > > guarantee that any dirty zeroed pages between the start of the file
> > > > > and the end of the range we are operating on gets written back. This
> > > > > will capture all these "didn't flush regions zeroed on file
> > > > > extension" problems in one go, without needing to change the way we
> > > > > do allocation or EOF zeroing.
> > > > > 
> > > > 
> > > > I don't think that would prevent the problem outside of the common write
> > > > extension case.
> > > 
> > > I feel like we're going around in circles now, Brian. :/
> > > 
> > 
> > Yes, let's try to reset here...
> > 
> > > I didn't propose this as the "only solution we need". I've proposed
> > > it in the context that we use "only use unwritten extents for
> > > allocations within EOF" to solve the common "write within EOF" case.
> > > This, however, doesn't solve this common write extension case where
> > > we don't want to use unwritten extents because of the performance
> > > cost.
> > > 
> > > And now you're saying that "well, this extending write thing
> > > doesn't solve the inside EOF problem"......
> > > 
> > 
> > Ok, I lost that context. As I said above, I can see how this could be
> > useful in combination with another approach to handle inside eof
> > allocations. There are still some loose ends (in my mind) to consider
> > with this technique, however...
> > 
> > This requires that we always guarantee in-order writeback, right? I can
> > see how we can do that in the cases we control based on the flag based
> > approach you suggested. But do we really have enough control within the
> > fs to always prevent out of order writeback? What about non-integrity
> > background writeback? AFAICT it's technically possible to writeback out
> > of expected order (the cyclic range logic looks particularly suspicious
> > to me if you consider a mapping can be truncated and repopulated many
> > times over without resetting the cycle index). What about memory
> > reclaim? Is it not possible to hit the ->writepage() path via reclaim
> > for an arbitrary page in a mapping? It's not clear to me if page
> > migration is a factor for us as well, but it also looks like it has some
> > specific page writeback hooks.
> > 
> > I suppose there are technically ways around these things. We could skip
> > writeback of certain pages in some cases (but that may have unacceptable
> > consequences) or make the decision to use one exposure preventation
> > approach or another dynamically at writepage time based on the state of
> > the inode, mapping and associated page. I'd think background writeback
> > is the common case as opposed to things like hole punch and whatnot,
> > however, so a dynamic solution leaves the effectiveness of this approach
> > somewhat open ended unless we characterize how all possible writeback
> > scenarios behave.
> > 
> > Given that, it seems more useful to me to work through the inside eof
> > extent allocation scenario first and work back from there. Then we can
> > at least try to establish potential performance impact and determine if
> > we should try to work around it in certain cases, etc.
> 
> <nod> I'll get back to working on two parts of fixing this:
> 
> a) adapting the "convert delalloc to unwritten" patch that started this
> thread so that it only does that for conversions that start within eof,
> 
> b) fixing your punch case by extending the range that xfs_flush_unmap_range
> asks to flush if the caller is trying to flush a range past the ondisk
> eof.
> 
> Though I think (b) is unnecessary if we had the ability to flush all the
> pages fronting a delalloc reservation that we just converted to a real
> extent, as I muttered above.
> 

I think it's more that we have to order all such page writebacks against
the on-disk size update so the latter protects us from exposure in the
event of a crash, but otherwise this sounds like a reasonable next step
to me..

Brian

> > On that note,
> > please see the part that was snipped out of my earlier reply[1], in
> > particular the part that ended with "Am I following the high level idea
> > correctly?" :P Thanks.
> 
> I thought your take at least matched my interpretation of Dave's
> comments.
> 
> Thoughts?
> 
> --D
> 
> > 
> > Brian
> > 
> > [1] https://marc.info/?l=linux-xfs&m=155308332901975&w=2
> > 
> > > > It may be possible to selectively (i.e. as an optimization) use an
> > > > XFS_ITRUNCATED like algorithm as you propose here to always force in
> > > > order writeback in the cases where writeback extends the on-disk isize
> > > > (and thus isize protects from stale exposure), but I think we'd still
> > > > need something tied to extent allocation one way or another in addition
> > > > (like Darrick's original unwritten extent patch or your proposed
> > > > intent/done idea in the previous reply) to address the fundamental
> > > > problem. The question is what is the ideal solution..
> > > 
> > > The solution will be a combination of things that work together, not
> > > one big hammer. The more we can avoid exposure vectors by
> > > operational ordering rather than transactional state changes, the
> > > better the solution will perform.
> > > 
> > > Cheers,
> > > 
> > > Dave.
> > > -- 
> > > Dave Chinner
> > > david@fromorbit.com
