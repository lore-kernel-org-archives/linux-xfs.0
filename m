Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F04057F66
	for <xfs@oss.sgi.com>; Fri, 30 May 2014 19:37:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E6FC6304043
	for <xfs@oss.sgi.com>; Fri, 30 May 2014 17:37:17 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	A5K1JLbQkXuQHHos for <xfs@oss.sgi.com>;
	Fri, 30 May 2014 17:37:15 -0700 (PDT)
Date: Sat, 31 May 2014 10:37:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
Message-ID: <20140531003712.GH14410@dastard>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<1401480116-1973111-12-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1401480116-1973111-12-git-send-email-arnd@arndb.de>
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
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, john.stultz@linaro.org, lftan@altera.com, linux-fsdevel@vger.kernel.org, geert@linux-m68k.org, tglx@linutronix.de, joseph@codesourcery.com

On Fri, May 30, 2014 at 10:01:35PM +0200, Arnd Bergmann wrote:
> xfs uses unsigned 32-bit seconds for inode timestamps, which will work
> for the next 92 years, but the VFS uses struct timespec for timestamps,
> which is only good until 2038 on 32-bit CPUs.
> 
> This gets us one small step closer to lifting the VFS limit by using
> struct inode_time in XFS.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: xfs@oss.sgi.com
> ---
>  fs/xfs/time.h            | 4 ++--
>  fs/xfs/xfs_inode.c       | 2 +-
>  fs/xfs/xfs_iops.c        | 2 +-
>  fs/xfs/xfs_trans_inode.c | 6 +++---
>  4 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/time.h b/fs/xfs/time.h
> index 387e695..a490f1b 100644
> --- a/fs/xfs/time.h
> +++ b/fs/xfs/time.h
> @@ -21,14 +21,14 @@
>  #include <linux/sched.h>
>  #include <linux/time.h>
>  
> -typedef struct timespec timespec_t;
> +typedef struct inode_time timespec_t;
>  
>  static inline void delay(long ticks)
>  {
>  	schedule_timeout_uninterruptible(ticks);
>  }
>  
> -static inline void nanotime(struct timespec *tvp)
> +static inline void nanotime(struct inode_time *tvp)
>  {
>  	*tvp = CURRENT_TIME;
>  }
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index a6115fe..16d5392 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -654,7 +654,7 @@ xfs_ialloc(
>  	xfs_inode_t	*ip;
>  	uint		flags;
>  	int		error;
> -	timespec_t	tv;
> +	struct inode_time tv;
>  
>  	/*
>  	 * Call the space management code to pick
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 205613a..092ee7c 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -956,7 +956,7 @@ xfs_vn_setattr(
>  STATIC int
>  xfs_vn_update_time(
>  	struct inode		*inode,
> -	struct timespec		*now,
> +	struct inode_time	*now,
>  	int			flags)
>  {
>  	struct xfs_inode	*ip = XFS_I(inode);
> diff --git a/fs/xfs/xfs_trans_inode.c b/fs/xfs/xfs_trans_inode.c
> index 50c3f56..bae2520 100644
> --- a/fs/xfs/xfs_trans_inode.c
> +++ b/fs/xfs/xfs_trans_inode.c
> @@ -70,7 +70,7 @@ xfs_trans_ichgtime(
>  	int			flags)
>  {
>  	struct inode		*inode = VFS_I(ip);
> -	timespec_t		tv;
> +	struct inode_time	tv;
>  
>  	ASSERT(tp);
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> @@ -78,13 +78,13 @@ xfs_trans_ichgtime(
>  	tv = current_fs_time(inode->i_sb);
>  
>  	if ((flags & XFS_ICHGTIME_MOD) &&
> -	    !timespec_equal(&inode->i_mtime, &tv)) {
> +	    !inode_time_equal(&inode->i_mtime, &tv)) {
>  		inode->i_mtime = tv;
>  		ip->i_d.di_mtime.t_sec = tv.tv_sec;
>  		ip->i_d.di_mtime.t_nsec = tv.tv_nsec;
>  	}

The problem I see here is that the code is now potentially stuffing
a variable that is larger than 32 bits into on on-disk structure
that is only 32 bits in size.  You can't just change the in-memory
representation of inode timestamps and expect the problem to be
fixed - this just pushes the problem down a layer without any
intrastructure allowing filesystems to handle storage of the new
timestamp format sanely.

IOWs, the filesystem has to be able to reject any attempt to set a
timestamp that is can't represent on disk otherwise Bad Stuff will
happen, and filesystems have to be able to specify in their on
disk format what timestamp encoding is being used. The solution will
be different for every filesystem that needs to support time beyond
2038.

Hence I think you are going to need superblock flags and/or
variables to indicate the epoch range the fielsystem can support.
Then the fileystems need conversion functions from whatever the
internal VFS timestamp representation is to whatever their on-disk
format is, and only then can we switch the VFS to using a new
timestamp format.

At that point, filesystem developers can make the changes they need
to the on-disk format to support timestamps beyond 2038, and all
they need to do at the VFS layer is set the "supported range" fields
appropriately in the VFS superblock...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
