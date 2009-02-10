Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1AJvBjU071861 for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 13:57:12 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D8AE2304092
	for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 11:56:32 -0800 (PST)
Message-Id: <A482AB92-6E29-43EA-A671-43D86E041335@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090210194515.509547000@bombadil.infradead.org>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH 1/2] xfs: fix error handling in xfs_log_mount
Date: Tue, 10 Feb 2009 13:56:31 -0600
References: <20090210194422.767988000@bombadil.infradead.org>
	<20090210194515.509547000@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Isn't it a reworked Lachlan's patch:

http://oss.sgi.com/archives/xfs/2009-02/msg00175.html

Otherwise, looks good.

Felix

On Feb 10, 2009, at 1:44 PM, Christoph Hellwig wrote:

> We can't just call xfs_log_unmount_dealloc on any failure because the
> ail thread which is torn down by xfs_log_unmount_dealloc might not
> be initialized yet.
>
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> Index: xfs/fs/xfs/xfs_log.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_log.c	2009-02-10 19:16:18.761945594 +0100
> +++ xfs/fs/xfs/xfs_log.c	2009-02-10 19:18:54.177068965 +0100
> @@ -574,7 +574,7 @@ xfs_log_mount(
> 	error = xfs_trans_ail_init(mp);
> 	if (error) {
> 		cmn_err(CE_WARN, "XFS: AIL initialisation failed: error %d", error);
> -		goto error;
> +		goto out_free_log;
> 	}
> 	mp->m_log->l_ailp = mp->m_ail;
>
> @@ -594,20 +594,22 @@ xfs_log_mount(
> 			mp->m_flags |= XFS_MOUNT_RDONLY;
> 		if (error) {
> 			cmn_err(CE_WARN, "XFS: log mount/recovery failed: error %d",  
> error);
> -			goto error;
> +			goto out_destroy_ail;
> 		}
> 	}
>
> 	/* Normal transactions can now occur */
> 	mp->m_log->l_flags &= ~XLOG_ACTIVE_RECOVERY;
>
> -	/* End mounting message in xfs_log_mount_finish */
> 	return 0;
> -error:
> -	xfs_log_unmount_dealloc(mp);
> +
> +out_destroy_ail:
> +	xfs_trans_ail_destroy(mp);
> +out_free_log:
> +	xlog_dealloc_log(mp->m_log);
> out:
> 	return error;
> -}	/* xfs_log_mount */
> +}
>
> /*
>  * Finish the recovery of the file system.  This is separate from
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
