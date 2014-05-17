Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5885F7F3F
	for <xfs@oss.sgi.com>; Sat, 17 May 2014 06:54:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 20EC28F80FB
	for <xfs@oss.sgi.com>; Sat, 17 May 2014 04:54:28 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id V0dF7hemTrbS36cZ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 17 May 2014 04:54:26 -0700 (PDT)
Date: Sat, 17 May 2014 04:54:25 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/5] xfs: turn NLINK feature on by default
Message-ID: <20140517115425.GA10470@infradead.org>
References: <1400281252-29638-1-git-send-email-david@fromorbit.com>
	<1400281252-29638-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1400281252-29638-4-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 944f3d9..3f09782 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -697,6 +697,12 @@ xfs_mountfs(
>  			mp->m_update_flags |= XFS_SB_VERSIONNUM;
>  	}
>  
> +	/* always use v2 inodes by default now */
> +	if (!(mp->m_sb.sb_versionnum & XFS_SB_VERSION_NLINKBIT)) {
> +		mp->m_sb.sb_versionnum |= XFS_SB_VERSION_NLINKBIT;
> +		mp->m_update_flags |= XFS_SB_VERSIONNUM;
> +	}

This probably should print a message for the user.

Otherwise looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
