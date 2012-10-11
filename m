Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9B51mVc032005 for <xfs@oss.sgi.com>; Thu, 11 Oct 2012 00:01:48 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	cv57JaMgfu8sO6Fk for <xfs@oss.sgi.com>;
	Wed, 10 Oct 2012 22:03:17 -0700 (PDT)
Date: Thu, 11 Oct 2012 16:03:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/14 V5]: xfs: remove the xfssyncd mess
Message-ID: <20121011050314.GA2739@dastard>
References: <1349693772-8064-1-git-send-email-david@fromorbit.com>
	<20121008223921.GS13214@sgi.com> <20121011023155.GX13214@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121011023155.GX13214@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Oct 10, 2012 at 09:31:55PM -0500, Ben Myers wrote:
> Hey Dave,
> 
> On Mon, Oct 08, 2012 at 05:39:21PM -0500, Ben Myers wrote:
> > On Mon, Oct 08, 2012 at 09:55:58PM +1100, Dave Chinner wrote:
> > > Hopefully the final version.
> > 
> > I am testing this new rev now... My v4 run over the weekend crashed but
> > unfortunately I wasn't able to get a stack trace.  We'll see what shakes out.
> 
> I'm still not sure what happened with the v4 run I mentioned.  Subsequent
> testing has shown this series to be solid with the new changes.  It is ready to
> go.
> 
> However, pulling this in right now will result in a merge commit from the
> upstream tree to ours later in the rc1 merge.  My understanding is that if
> Linus were to subsequently pull from our tree, the merge commit would cause
> some ugliness in upstream commit history.  See:
> 
> http://oss.sgi.com/archives/xfs/2009-04/msg00014.html


I'm not sure that's relevant. The problem ther was this sort of
behaviour:

	- merge mainline into XFS tree.
	- commit XFS stuff
	- merge mainline into XFS tree
	- commit XFS stuff
	.....
	- merge mainline into XFS tree
	- commit XFS stuff
	- pull request
	- merge mainline into XFS tree
	- commit XFS stuff
	<loop>

And so the changes in the XFS tree where not easy to discern from
the changes pull in from mainline. Indeed, look at the pull request
to see exactly waht Linus was complaining about:

http://oss.sgi.com/archives/xfs/2009-04/msg00009.html

Felix Blyakher (25):
     Merge branch 'master' of git+ssh://oss.sgi.com/oss/git/xfs/xfs
     [XFS] Warn on transaction in flight on read-only remount
     Merge branch 'master' of git://git.kernel.org/.../torvalds/ linux-2.6
     Merge branch 'master' of git://git.kernel.org/.../torvalds/ linux-2.6
     Merge branch 'master' of git://git.kernel.org/.../torvalds/ linux-2.6 
     xfs: Update maintainers
     Merge branch 'master' of git://git.kernel.org/.../torvalds/ linux-2.6 
     Merge branch 'master' of git://git.kernel.org/pub/scm/fs/xfs/xfs
     Merge branch 'master' of git://git.kernel.org/pub/scm/fs/xfs/xfs
     Merge branch 'master' of git://git.kernel.org/.../torvalds/ linux-2.6 
     Merge branch 'master' of git://git.kernel.org/pub/scm/fs/xfs/xfs
     Merge branch 'master' of git://git.kernel.org/.../torvalds/ linux-2.6 
     Revert "[XFS] use scalable vmap API"
     Revert "[XFS] remove old vmap cache"
     Merge branch 'master' of git://git.kernel.org/.../torvalds/ linux-2.6
     Merge branch 'master' of git://git.kernel.org/.../torvalds/ linux-2.6
     Merge branch 'master' of git://git.kernel.org/.../torvalds/ linux-2.6 
     Fix xfs debug build breakage by pushing xfs_error.h after
     Merge branch 'master' of git://git.kernel.org/.../torvalds/ linux-2.6 
     Merge branch 'master' of git://git.kernel.org/pub/scm/fs/xfs/xfs
     Merge branch 'master' of git://git.kernel.org/.../torvalds/ linux-2.6 
     xfs: increase the maximum number of supported ACL entries
     Merge branch 'master' of git://git.kernel.org/.../torvalds/ linux-2.6 
     Merge branch 'master' of git://git.kernel.org/pub/scm/fs/xfs/xfs
     Revert "xfs: increase the maximum number of supported ACL entries"

This is the mess that Linus was complaining about - not about a
single merge per release that is used to keep the tree tracking
mainlinei having a conflict in it.

Having a dev tree history something like:

	- commit XFS stuff
	- commit XFS stuff
	- merge -rc1 from mainline
	- commit XFS stuff
	- commit XFS stuff
	- commit XFS stuff
	......
	- commit XFS stuff
	- pull request
	- commit XFS stuff
	- commit XFS stuff
	<loop per release>

Isn't really the problem that Linus was talking about. Indeed, one
mainline merge per release is pretty much as expected, especially if
you have a tree that you do not rebase that is consistently
committed to....

> I haven't found a way around this, so that's why we're waiting until after the
> -rc1 fast-forward to pull this in.

Merges by themselves aren't bad - it's excessive, unnecessary
use of them that causes problems. :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
