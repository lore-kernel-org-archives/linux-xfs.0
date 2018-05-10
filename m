Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:58809 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751273AbeEJXzF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 May 2018 19:55:05 -0400
Date: Fri, 11 May 2018 09:55:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3] fs: don't scan the inode cache before SB_BORN is set
Message-ID: <20180510235502.GU10363@dastard>
References: <20180510042132.GS23861@dastard>
 <20180510190916.GQ30522@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180510190916.GQ30522@ZenIV.linux.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, May 10, 2018 at 08:09:16PM +0100, Al Viro wrote:
> On Thu, May 10, 2018 at 02:21:33PM +1000, Dave Chinner wrote:
> 
> > Setting sb->s_fs_info to NULL on xfs_mount setup failure only solves
> > the use-after-free part of the problem - it doesn't solve the
> > use-before-initialisation part. To solve that we need to check the
> > SB_BORN flag in super_cache_count().
> > 
> > The SB_BORN flag is not set until ->fs_mount() completes
> > successfully and trylock_super() won't succeed until it is set.
> > Hence super_cache_scan() will not run until SB_BORN is set, so it
> > makes sense to not allow super_cache_scan to run and enter the
> > filesystem until it is set, too. This prevents the superblock
> > shrinker from entering the filesystem while it is being set up and
> > so avoids the use-before-initialisation issue.
> 
> I'm fine with the first part of that (fs/super.c, that is), but
> I don't understand why do you need the xfs side of the patch with
> that.  Confused...

Well, the zeroing of s_fs_info is necessary to prevent
use-after-free on the ->put_super side when ->fill_super fails. The
shrinker counter check for a null s_fs_info is paranoia -
historically we've had so many problems over time with superblock
shrinkers being run when they shouldn't be, and I'm certain that
someone will get it wrong again in the future.

That said, I got no idea what I was thinking with the s_op change;
that should just go bang on a mount failure because
generic_shutdown_super() calls ops->put_super() unconditionally.
I'll respin and remove the sop changes, and replace it with an
actual check in xfs_fs_put_super() for a null s_fs_info....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
