Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 254417F3F
	for <xfs@oss.sgi.com>; Mon, 16 Dec 2013 17:39:44 -0600 (CST)
Date: Mon, 16 Dec 2013 17:39:40 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [RFC] Handling of reviewed patch series
Message-ID: <20131216233940.GR1935@sgi.com>
References: <20131213053611.GQ10988@dastard> <20131213185618.GJ1935@sgi.com>
	<20131213231401.GZ10988@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131213231401.GZ10988@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi Dave,

On Sat, Dec 14, 2013 at 10:14:01AM +1100, Dave Chinner wrote:
> On Fri, Dec 13, 2013 at 12:56:18PM -0600, Ben Myers wrote:
> > On Fri, Dec 13, 2013 at 04:36:11PM +1100, Dave Chinner wrote:
> > > Lines of development that overlap will generate conflicts at the
> > > for-next branch merge, and at that point we can decide how to
> > > deal with the problem. e.g. turn the conflicting topic branches
> > > into a single, larger topic branch, live with it, etc.
> > > 
> > > When it comes to sending code upstream to Linus, we can either
> > > send a pull request per topic branch - Linus often likes to do
> > > merges himself - or we can merge them all into a single branch
> > > and ask Linus to pull that. The deciding factor may well be
> > > Linus himself...
> > 
> > If you take a look at merges into mainline using gitweb they look
> > like this:
> > 
> > Merge branch 'for-linus' of git://git./linux/kernel... 
> > 
> > I suggest that the topic branches start with xfs.
> > 
> > e.g. 'xfs-refactor-icluster-macros' would be better than
> > 'tip-icluster-factor'.
> 
> I used the "tip" prefix simply because that is what is used in other
> trees for branches of this purpose. It's good to be able to just
> look at the branch and know from the prefix that it is a feature
> branch pending for the next merge window, as opposed to some
> development branch we are using to stage other work....
> 
> I'm open to other suggestions - having an "xfs-" prefix of
> some kind is definitely a good idea. Perhaps something like
> "xfs-14-..." where the 14 is an indicator of the merge window we are
> queuing it for (i.e. 3.14)? That way we end up with "xfs-13-rc6-*"
> as the branch prefix for bug fixes that need to be sent to linus in
> the 3.13-rc6 cycle....
> 
> Any other ideas?

Just 'xfs-' is good enough IMO.  I think that the various topic branches don't
have to stay around forever after they have been merged.

> > Lets see if I understand correctly (and I'll take some of my own
> > advice from above).  I'll pull 'tip-icluster-factor' into a local
> > branch named 'xfs-refactor-icluster-macros', and merge it into our
> > for-next branch along with the other series.  This will get them
> > into -next, and we can still toss it later if it's not what you
> > had in mind.
> 
> Well, ideally when one of us pushes out or appends to a topic
> branch, we merge it into for-next at the same time. If we need to
> rebase the for-next branch, then we need to discuss it first and
> take appropriate actions...

Sounds fine.  As you pointed out elsewhere in this thread, we probably don't
need to rebase for-next very often.

> > > Anyway, have a think and discuss - I'm going to push the
> > > branches I mentioned above....
> > 
> > I've been tracking message id and patchwork id in git notes along
> > with commits for awhile.  I'm hoping this will become useful later
> > for cross referencing the list, patchworks, and test results.  If
> > you wouldn't mind also doing so I'd appreciate it.  Maybe it could
> > be done with a post-commit script or something.
> 
> There's no notes in the repo of oss.sgi.com, so I'm not sure what
> you are doing here.

I'm just trying to track the message id along with patchwork id.  Maybe later I
can script it up so that test results are cross referenced with the list archives.

commit c91c46c12768daac8486dff0f74bc52c2ec974cd
Author: Christoph Hellwig <hch@infradead.org>
Date:   Mon Nov 18 05:10:52 2013 -0800

    xfs: add xfs_setattr_time
    
    Split out a xfs_setattr_time helper to share code between truncate and
    regular setattr similar to xfs_setattr_mode.  I might also have another
    caller growing for this in the near future.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

Notes:
    X-Patchwork-ID: 6941
    
    Message-Id: <20131118131052.GB21649@infradead.org>

> As it is, patchworks is not something I use or want to use. I
> capture and track patches with procmail and mutt - I really don't
> want to have to use patchworks just to find some arbitrary ID number
> that some 3rd party tool generates and add it to notes attached to a
> commit.

I'm a mutt user as well.  I'm not necessarily the biggest fan of patchwork
either, but it does turn out to be helpful sometimes.  I don't know what your
workflow is like.  Is there any chance you can get the message id in there?

messageid=$(formail -X Message-Id: < $patch | awk '{print $2}')
git notes append -m "Message-Id: $messageid"

Thanks,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
