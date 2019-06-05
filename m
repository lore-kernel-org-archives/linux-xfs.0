Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:36882 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbfFEWbI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jun 2019 18:31:08 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x55MTFs9001801
        for <linux-xfs@vger.kernel.org>; Wed, 5 Jun 2019 22:31:07 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 2suevdnj4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 05 Jun 2019 22:31:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x55MV5bR143993
        for <linux-xfs@vger.kernel.org>; Wed, 5 Jun 2019 22:31:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2swngm6esj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 05 Jun 2019 22:31:05 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x55MV5Fl018952
        for <linux-xfs@vger.kernel.org>; Wed, 5 Jun 2019 22:31:05 GMT
Subject: Re: [PATCH 9/9] xfs: allow bulkstat_single of special inodes
References: <155916885106.758159.3471602893858635007.stgit@magnolia>
 <155916890871.758159.15869425204728307163.stgit@magnolia>
From: Allison Collins <allison.henderson@oracle.com>
Message-ID: <4868205d-0eed-0fc9-9405-4d2188492b80@oracle.com>
Date: Wed, 5 Jun 2019 15:31:04 -0700
MIME-Version: 1.0
In-Reply-To: <155916890871.758159.15869425204728307163.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 5/29/19 3:28 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a new ireq flag (for single bulkstats) that enables userspace to
> ask us for a special inode number instead of interpreting @ino as a
> literal inode number.  This enables us to query the root inode easily.
> 
Looks good.  You can add my review:
Reviewed-by: Allison Collins <allison.henderson@oracle.com>


> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   fs/xfs/libxfs/xfs_fs.h |   11 ++++++++++-
>   fs/xfs/xfs_ioctl.c     |   10 ++++++++++
>   2 files changed, 20 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 77c06850ac52..1826aa11b585 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -482,7 +482,16 @@ struct xfs_ireq {
>   	uint64_t	reserved[2];	/* must be zero			*/
>   };
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
>   /*
>    * ioctl structures for v5 bulkstat and inumbers requests
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index cf48a2bad325..605bfff3011f 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -959,6 +959,16 @@ xfs_ireq_setup(
>   	    memchr_inv(hdr->reserved, 0, sizeof(hdr->reserved)))
>   		return -EINVAL;
>   
> +	if (hdr->flags & XFS_IREQ_SPECIAL) {
> +		switch (hdr->ino) {
> +		case XFS_IREQ_SPECIAL_ROOT:
> +			hdr->ino = mp->m_sb.sb_rootino;
> +			break;
> +		default:
> +			return -EINVAL;
> +		}
> +	}
> +
>   	if (XFS_INO_TO_AGNO(mp, hdr->ino) >= mp->m_sb.sb_agcount)
>   		return -EINVAL;
>   
> 
