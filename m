Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C6B948004
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 08:08:48 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B540A8F8054
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 06:08:48 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id TWADyBli6W6BxZfA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Feb 2015 06:08:47 -0800 (PST)
Date: Thu, 5 Feb 2015 09:08:40 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 0/7 V2] xfs: use generic percpu counters for icsb
Message-ID: <20150205140840.GB31625@laptop.bfoster>
References: <1423083249-27493-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1423083249-27493-1-git-send-email-david@fromorbit.com>
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

On Thu, Feb 05, 2015 at 07:54:02AM +1100, Dave Chinner wrote:
> Hi folks,
> 
> This is the second version of the generic per-cpu counter rework
> patch series. The first version can be found here:
> 
> http://oss.sgi.com/archives/xfs/2015-02/msg00000.html
> 
> New in V2:
> 
> - drop the moving of the struct xfs_sb to xfs_super.h
> - fixed all the little things that Christoph and Brian noted.
> - keep the per-cpu counters in the struct xfs_mount and keep the
>   functions to sync them with the struct xfs_sb values when read
>   from disk or written to disk.
> - integrated Christoph Hellwig's additional cleanup patch. This was
>   done by:
> 	- intergating xfs_mod_XXX factoring into the relevant percpu
> 	  counter conversion patch
> 	- separating out xfs_mod_frextents into it's won patch
> 	- separating out the replacement of
> 	  xfs_mod_incore_sb_batched
> 	- doing all the now unused API removal in a separate patch
> 
> The series passes xfstests without regressions, and no scalability
> issues have been seen in my performance tests on a 16p VM. SGI - you
> still need to test this, though. :)
> 
> Thoughts, comments?
> 

All in all this looks pretty good to me save a couple notes pointed out
in the patches. In a quick test, this handles the imaxct overshoot
problem Eric noted much better than the current implementation. That
said, it's still not precise.

My understanding is that's fine, but I wonder if we want to tack on a
variant of Eric's original patch as well so when we still do overshoot
imaxpct (albeit by much less than before: I reproduce an overshoot of
<100 inodes vs several thousand) we at least report an accurate inode
count. Thoughts?

Brian

> -Dave.
> 
> PS: diffstat of the series is now:
> 
>  fs/xfs/libxfs/xfs_bmap.c   |  40 +--
>  fs/xfs/libxfs/xfs_format.h |  62 ----
>  fs/xfs/libxfs/xfs_ialloc.c |   6 +-
>  fs/xfs/libxfs/xfs_sb.c     |  12 +-
>  fs/xfs/xfs_fsops.c         |  20 +-
>  fs/xfs/xfs_iomap.c         |   3 +-
>  fs/xfs/xfs_linux.h         |   9 -
>  fs/xfs/xfs_log_recover.c   |   4 +-
>  fs/xfs/xfs_mount.c         | 919 ++++++-----------------------------------------
>  fs/xfs/xfs_mount.h         |  95 +----
>  fs/xfs/xfs_super.c         | 103 ++++--
>  fs/xfs/xfs_super.h         |   2 +
>  fs/xfs/xfs_trans.c         | 234 +++++++-----
>  13 files changed, 381 insertions(+), 1128 deletions(-)
> 
> So we have a net reduction of roughly 750 lines of code.  When
> combined with the changes to the superblock logging that has already
> been committed, we have reduced the superblock modification code by
> close to 1000 lines compared to 3.19...
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
