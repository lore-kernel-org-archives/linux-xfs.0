Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 09 Oct 2006 16:37:00 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k99NanaG021117
	for <xfs@oss.sgi.com>; Mon, 9 Oct 2006 16:36:51 -0700
Message-ID: <452ADCE9.2070402@sgi.com>
Date: Tue, 10 Oct 2006 09:36:09 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: Re: xfs vs. lockdep
References: <452A8DE2.4000608@sandeen.net>
In-Reply-To: <452A8DE2.4000608@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Eric Sandeen wrote:
> FC6 kernels are oopsing when lockdep & memory debugging are turned on,
> looks like due to this code:
>
> xfs_ireclaim(xfs_inode_t *ip)
> {
>    ...
>         /*
>          * Here we do a spurious inode lock in order to coordinate with
>          * xfs_sync().  This is because xfs_sync() references the inodes
>          * in the mount list without taking references on the corresponding
>          * vnodes.  We make that OK here by ensuring that we wait until
>          * the inode is unlocked in xfs_sync() before we go ahead and
>          * free it.  We get both the regular lock and the io lock because
>          * the xfs_sync() code may need to drop the regular one but will
>          * still hold the io lock.
>          */
>         xfs_ilock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
> ...
>         /*
>          * Free all memory associated with the inode.
>          */
>         xfs_idestroy(ip);
> }
>
> So, lock & free.  This frees memory that lockdep is still pointing to,
> and tries to use later.
>
> Calling xfs_iunlock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL); just before
> xfs_idestroy seems to solve it, but is this safe...?
>
> -Eric
>
>   
Hi Eric,

Could you please provide some more information. What kernel, test case 
and call stack at the time of the crash.

Thanks,
Vlad
