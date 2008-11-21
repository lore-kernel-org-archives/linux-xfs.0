Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mALINBxg031018 for <xfs@oss.sgi.com>; Fri, 21 Nov 2008 12:23:12 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1672515BEF62
	for <xfs@oss.sgi.com>; Fri, 21 Nov 2008 10:23:09 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id 6WhjeYsli2riPawJ for <xfs@oss.sgi.com>;
	Fri, 21 Nov 2008 10:23:09 -0800 (PST)
Message-ID: <4926FC89.60607@sandeen.net>
Date: Fri, 21 Nov 2008 12:23:05 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] fix NULL pointer dereference in xfs_log_force_umount
References: <20081121162829.GA17277@infradead.org>
In-Reply-To: <20081121162829.GA17277@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Christoph Hellwig <hch@infradead.org>
Cc: aluno3@poczta.onet.pl, xfs@oss.sgi.com

Christoph Hellwig wrote:
> xfs_log_force_umount may be called very early during log recovery where
> 
> If we fail a buffer read in xlog_recover_do_inode_trans we abort the mount.
> But at that point log recovery has started delayed writeback of inode
> buffers.   As part of the aborted mount we try to flush out all delwri
> buffers, but at that point we have already freed the superblock, and set
> mp->m_sb_bp to NULL, and xfs_log_force_umount which gets called after
> the inode buffer writeback trips over it.
> 
> Make xfs_log_force_umounr a little more careful when accessing mp->m_sb_bp
> to avoid this.

Seems fine (btw:  s/unmounr/unmount/)  ;)

-eric

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs-2.6/fs/xfs/xfs_log.c
> ===================================================================
> --- xfs-2.6.orig/fs/xfs/xfs_log.c	2008-11-21 17:07:30.000000000 +0100
> +++ xfs-2.6/fs/xfs/xfs_log.c	2008-11-21 17:13:02.000000000 +0100
> @@ -3525,7 +3525,8 @@ xfs_log_force_umount(
>  	if (!log ||
>  	    log->l_flags & XLOG_ACTIVE_RECOVERY) {
>  		mp->m_flags |= XFS_MOUNT_FS_SHUTDOWN;
> -		XFS_BUF_DONE(mp->m_sb_bp);
> +		if (mp->m_sb_bp)
> +			XFS_BUF_DONE(mp->m_sb_bp);
>  		return 0;
>  	}
>  
> @@ -3546,7 +3547,9 @@ xfs_log_force_umount(
>  	spin_lock(&log->l_icloglock);
>  	spin_lock(&log->l_grant_lock);
>  	mp->m_flags |= XFS_MOUNT_FS_SHUTDOWN;
> -	XFS_BUF_DONE(mp->m_sb_bp);
> +	if (mp->m_sb_bp)
> +		XFS_BUF_DONE(mp->m_sb_bp);
> +
>  	/*
>  	 * This flag is sort of redundant because of the mount flag, but
>  	 * it's good to maintain the separation between the log and the rest
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
