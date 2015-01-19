Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 87EF67F56
	for <xfs@oss.sgi.com>; Mon, 19 Jan 2015 03:07:25 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 736E98F8033
	for <xfs@oss.sgi.com>; Mon, 19 Jan 2015 01:07:25 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 4mWThcCtqFMipFz8 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 19 Jan 2015 01:07:21 -0800 (PST)
Date: Mon, 19 Jan 2015 01:07:20 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/17] quota: Switch ->get_dqblk() and ->set_dqblk() to
	use bytes as space units
Message-ID: <20150119090720.GG27474@infradead.org>
References: <1421412471-4747-1-git-send-email-jack@suse.cz>
	<1421412471-4747-8-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1421412471-4747-8-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com

> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 18dc721ca19f..f718ba1f2ccb 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -559,18 +559,4 @@ typedef struct xfs_swapext
>  /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
>  
>  
> -#ifndef HAVE_BBMACROS
> -/*
> - * Block I/O parameterization.	A basic block (BB) is the lowest size of
> - * filesystem allocation, and must equal 512.  Length units given to bio
> - * routines are in BB's.
> - */
> -#define BBSHIFT		9
> -#define BBSIZE		(1<<BBSHIFT)
> -#define BBMASK		(BBSIZE-1)
> -#define BTOBB(bytes)	(((__u64)(bytes) + BBSIZE - 1) >> BBSHIFT)
> -#define BTOBBT(bytes)	((__u64)(bytes) >> BBSHIFT)
> -#define BBTOB(bbs)	((bbs) << BBSHIFT)
> -#endif

Please don't move these defintions around and just opencode them in
the quota code.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
