Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8Q04oYU259152 for <xfs@oss.sgi.com>; Sat, 25 Sep 2010 19:04:50 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2561F9E688
	for <xfs@oss.sgi.com>; Sat, 25 Sep 2010 17:05:47 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id BrQE9CmaXkLc0obY for
	<xfs@oss.sgi.com>; Sat, 25 Sep 2010 17:05:47 -0700 (PDT)
Date: Sat, 25 Sep 2010 20:05:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH VER 5] Extend project quotas to support 32bit project
	identifiers.
Message-ID: <20100926000546.GA18984@infradead.org>
References: <1285332677-13490-1-git-send-email-arekm@maven.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1285332677-13490-1-git-send-email-arekm@maven.pl>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Arkadiusz Mi??kiewicz <arekm@maven.pl>
Cc: xfs@oss.sgi.com

> -	if ((mask & FSX_PROJID) && (fa->fsx_projid > (__uint16_t)-1))
> +	if ((mask & FSX_PROJID) && (fa->fsx_projid > (__uint16_t)-1)
> +			&& !xfs_sb_version_hasprojid32bit(&ip->i_mount->m_sb))

I hate to nipick now that this is basically ready, but the normal kernel
and XFS style is to keep the operators at the end of the previous line,
e.g.

	if ((mask & FSX_PROJID) && (fa->fsx_projid > (__uint16_t)-1) &&
	    !xfs_sb_version_hasprojid32bit(&ip->i_mount->m_sb))

> --- a/fs/xfs/xfs_sb.h
> +++ b/fs/xfs/xfs_sb.h
> @@ -80,10 +80,12 @@ struct xfs_mount;
>  #define XFS_SB_VERSION2_RESERVED4BIT	0x00000004
>  #define XFS_SB_VERSION2_ATTR2BIT	0x00000008	/* Inline attr rework */
>  #define XFS_SB_VERSION2_PARENTBIT	0x00000010	/* parent pointers */
> +#define XFS_SB_VERSION2_PROJID32BIT	0x00000020	/* 32 bit project id */

0x00000020 is already used by patches to make use inocode for the CI
dir hash, and 0x00000040 is used by the NFSv4 ACL patches.  Can you take
0x00000080 instead?

I'll submit a patch to get the other two into the header so that they
won't conflict.

Except for these minor bits this looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
