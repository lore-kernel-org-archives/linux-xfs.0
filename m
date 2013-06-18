Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E3E1829DF8
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 20:23:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C4FC68F8037
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 18:23:04 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	xpl6a1wqqI8orvNQ for <xfs@oss.sgi.com>;
	Mon, 17 Jun 2013 18:23:02 -0700 (PDT)
Date: Tue, 18 Jun 2013 11:22:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: don't shutdown log recovery on validation errors
Message-ID: <20130618012256.GN29376@dastard>
References: <20130613020827.GG29338@dastard> <20130613220903.GA20932@sgi.com>
	<20130614001306.GM29338@dastard> <20130614160940.GA32736@sgi.com>
	<51BB41AD.4050303@sandeen.net> <20130614190850.GB20932@sgi.com>
	<51BB6C7C.6050300@sandeen.net> <20130614194453.GC20932@sgi.com>
	<20130615005639.GZ29338@dastard> <20130617145357.GC32736@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130617145357.GC32736@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: Dave Jones <davej@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Mon, Jun 17, 2013 at 09:53:57AM -0500, Ben Myers wrote:
> Hey Dave,
> 
> On Sat, Jun 15, 2013 at 10:56:39AM +1000, Dave Chinner wrote:
> > On Fri, Jun 14, 2013 at 02:44:53PM -0500, Ben Myers wrote:
> > > Unfortunately log replay is broken.  The verifier has detected this and stopped
> > > replay.  Ideally the solution would be to fix log replay, but that is going to
> > > take some time.  So, in the near term we're just going to disable the verifier
> > > to allow replay to complete.
> > > 
> > > I'm suggesting that this disabling be done conditionally on CONFIG_XFS_DEBUG so
> > > that developers still have a chance at hitting the log replay problem, and a
> > > comment should be added explaining that we've disabled the verifier due to a
> > > specific bug as a temporary workaround and we'll re-enable the verifier once
> > > it's fixed.  I'll update the patch and repost.
> > > 
> > > Are you guys arguing that the log replay bug should not be fixed?
> > 
> > I'm not arguing that it should not be fixed,
>       
> Good.
> 
> > I'm *stating* that it
> > *can't be fixed* for non-CRC filesystems. That is, the best we can
> > do is work around this deficiency in log recovery with some kind of
> > self-defusing warning....
> 
> I think you're mistaken here.  In order to prevent this from happening on
> non-crc filesystems we need only ensure that all of the buffer modifications in
> the log for a given buffer are played back onto the buffer before we write it
> out to disk.  My impression is that the final state of the buffer is always the
> correct one, so it's a matter of preventing any intermediate states from being
> written.

Sure. That's theoretically possible to do, but in practice it's
extremely problematic.

First of all, the log can be larger than system RAM, so you can't
hold all the changes in memory to replay the completely before
allowing writeback. So, we have to have writeback in some form. And
if we have to have writeback, that means we need to ensure we are
writing checkpoints as a whole unit of change....

If we don't write back checkpoints as a whole, then as a result of
omitting certain metadata we end up with an inconsistent state on
disk - exactly the problem we are trying to avoid. i.e. not writing
back metadata that changed in future checkpoints *guarantees* the
filesystem goes through inconsistent intermediate states.

And then we have to track every item in the log to determine if it
is used in multiple checkpoints. This is basically the same as the
cancelled buffer tracking, which now means every object requires
another ~32 bytes of RAM to track and a new scalable index mechanism
to that can track several hundred thousand objects in a scalable
fashion and has low overhead random insert, lookup and delete
behaviour.

> > To fix it properly, you need to know the age of the object being
> > overwritten relative to the age of overwrite data. For non-CRC
> > filesystems we don't have that information in the metadata object
> > being overwritten.
> 
> Only if you take the tack that you are not going to write intermediate state
> into the buffer.  I agree this is one way to fix the problem, but I'm not sure
> that it's the only option.
> 
> > We can't even correctly identify the object being
> > overwritten.
> 
> Can you be more specific about what you mean there?

Not all metadata that is logged contains self describing information
in non-CRC filesystems. If we can't identify metadata reliably, we
can't make any decisions base don the contents....

> > Indeed, the LSN stamp is a far more effective method than what used
> > to be in the inode core to try to avoid the problem for unlogged
> > inode size updates to try to prevent log recovery from replaying
> > inode core updates over more recently written inodes - the
> > di_flushiter field.  Note the comment in xfs_flush_int():
> > 
> >         /*
> >          * bump the flush iteration count, used to detect flushes which
> >          * postdate a log record during recovery. This is redundant as we now
> >          * log every change and hence this can't happen. Still, it doesn't hurt.
> >          */
> >         ip->i_d.di_flushiter++;
> > 
> > And this in xlog_recover_inode_pass2():
> > 
> >         /* Skip replay when the on disk inode is newer than the log one */
> >         if (dicp->di_flushiter < be16_to_cpu(dip->di_flushiter)) {
> 
> Why is using the lsn more effective than the counter?  Seems like the counter
> would be adequate as is.

The counter is only valid within the life of a single inode. It
doesn't track the inode across allocation and freeing....

> > We could probably also avoid the problem by modifying the way we do
> > writeback from the AIL to limit it only to objects at the tail LSN,
> > but that has a horrific performance penalty associated with it for
> > many common workloads because of the way relogging works. And for a
> > problem that I've suspected has occurred maybe 5 times in 10 years,
> > modifying metadata writeback to avoid this problem is a bad tradeoff
> > to make for just about everyone...
> 
> How would limiting writeback from the AIL to only structures at the tail
> resolve the issue of playback of intermediate states onto newer buffers during
> recovery? I don't understand what you're getting at here.

The source of the problem is that we write back metadata
with too-recent information in it. What determines "too recent"? The
LSN of the log item which determines it's position in the AIL. If we
want to avoid writing back something that is "too recent", then
we've got to stop newer objects on the AIL from being written to
disk before the older modifications are cleared from the log.

i.e. we can avoid the recovery problem by serialising metadata
flushing to a single checkpoint at a time. i.e. we flush the objects
from the tail LSN only and wait for them to complete and move the
tail of the log forwards before we write the next set of objects
that are now at the tail LSN....

> I think there may be some creative ways to resolve this problem for older
> filesystems which are worth looking into.

Good luck, but I think you are embarking on a fool's errand.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
