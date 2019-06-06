Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:43132 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727915AbfFFVPL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Jun 2019 17:15:11 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x56L8Vs9065498
        for <linux-xfs@vger.kernel.org>; Thu, 6 Jun 2019 21:15:09 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 2suevdu8pv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 06 Jun 2019 21:15:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x56LF6K4069326
        for <linux-xfs@vger.kernel.org>; Thu, 6 Jun 2019 21:15:08 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2swngmr6qb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 06 Jun 2019 21:15:08 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x56LF85J019193
        for <linux-xfs@vger.kernel.org>; Thu, 6 Jun 2019 21:15:08 GMT
Date: Thu, 6 Jun 2019 14:15:06 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 9/9] xfs: allow bulkstat_single of special inodes
Message-ID: <20190606211506.GC1871505@magnolia>
References: <155916885106.758159.3471602893858635007.stgit@magnolia>
 <155916890871.758159.15869425204728307163.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155916890871.758159.15869425204728307163.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Wed, May 29, 2019 at 03:28:28PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a new ireq flag (for single bulkstats) that enables userspace to
> ask us for a special inode number instead of interpreting @ino as a
> literal inode number.  This enables us to query the root inode easily.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_fs.h |   11 ++++++++++-
>  fs/xfs/xfs_ioctl.c     |   10 ++++++++++
>  2 files changed, 20 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 77c06850ac52..1826aa11b585 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -482,7 +482,16 @@ struct xfs_ireq {
>  	uint64_t	reserved[2];	/* must be zero			*/
>  };
>  
> -#define XFS_IREQ_FLAGS_ALL	(0)
> +/*
> + * The @ino value is a special value, not a literal inode number.  See the
> + * XFS_IREQ_SPECIAL_* values below.
> + */
> +#define XFS_IREQ_SPECIAL	(1 << 0)
> +
> +#define XFS_IREQ_FLAGS_ALL	(XFS_IREQ_SPECIAL)
> +
> +/* Return the root directory inode. */
> +#define XFS_IREQ_SPECIAL_ROOT	(1)
>  
>  /*
>   * ioctl structures for v5 bulkstat and inumbers requests
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index cf48a2bad325..605bfff3011f 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -959,6 +959,16 @@ xfs_ireq_setup(
>  	    memchr_inv(hdr->reserved, 0, sizeof(hdr->reserved)))
>  		return -EINVAL;
>  
> +	if (hdr->flags & XFS_IREQ_SPECIAL) {
> +		switch (hdr->ino) {
> +		case XFS_IREQ_SPECIAL_ROOT:

Hmmm sooo... this doesn't solve Eric's immediate problem where xfsdump
needs to be fed the root inode.  We assumed for years that the first
inode returned by bulkstat would always be the root dir, but it turned
out that mkfs puts the root dir at the start of the first possible inode
chunk past the end of the (AG headers + AG btree roots + AGFL blocks).
If all those blocks get freed then inodes can sneak into AG 0 before the
"first" inode chunk, invalidating the assumption.

IOWS, do we need to retrofit SPECIAL_ROOT into the old FSBULKSTAT_SINGLE
somehow?  Maybe if you pass in bulkreq.lastip == NULL then you get root?

--D

> +			hdr->ino = mp->m_sb.sb_rootino;
> +			break;
> +		default:
> +			return -EINVAL;
> +		}
> +	}
> +
>  	if (XFS_INO_TO_AGNO(mp, hdr->ino) >= mp->m_sb.sb_agcount)
>  		return -EINVAL;
>  
> 
