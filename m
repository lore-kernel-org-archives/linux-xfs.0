Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:36809 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725781AbfEOF4t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 May 2019 01:56:49 -0400
Date: Wed, 15 May 2019 15:56:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/11 V2] libxfs: remove unused cruft
Message-ID: <20190515055646.GW29573@dread.disaster.area>
References: <1557519510-10602-1-git-send-email-sandeen@redhat.com>
 <1557519510-10602-4-git-send-email-sandeen@redhat.com>
 <7b7e0bb3-3fac-6602-cff0-c868d6d0540c@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b7e0bb3-3fac-6602-cff0-c868d6d0540c@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org

On Tue, May 14, 2019 at 07:17:44PM -0500, Eric Sandeen wrote:
> Remove many unused #defines and functions.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
....
>  /* miscellaneous kernel routines not in user space */
> -#define down_read(a)		((void) 0)
> -#define up_read(a)		((void) 0)
>  #define spin_lock_init(a)	((void) 0)
>  #define spin_lock(a)		((void) 0)
>  #define spin_unlock(a)		((void) 0)

The lack of locking in the userspace code scares me somewhat :P

> @@ -400,7 +397,6 @@ roundup_64(uint64_t x, uint32_t y)
>  
>  #define XBRW_READ			LIBXFS_BREAD
>  #define XBRW_WRITE			LIBXFS_BWRITE
> -#define xfs_buf_iomove(bp,off,len,data,f)	libxfs_iomove(bp,off,len,data,f)
>  #define xfs_buf_zero(bp,off,len)     libxfs_iomove(bp,off,len,NULL,LIBXFS_BZERO)
>  
>  /* mount stuff */
> @@ -436,8 +432,6 @@ roundup_64(uint64_t x, uint32_t y)
>  #define xfs_sort					qsort
>  
>  #define xfs_ilock(ip,mode)				((void) 0)
> -#define xfs_ilock_nowait(ip,mode)			((void) 0)
> -#define xfs_ilock_demote(ip,mode)			((void) 0)

Especially that we have transactions that run without inode locks.

But that's not a problem this patch solves, so may as well get rid
of the unused interfaces...

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
