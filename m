Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5F93B7F61
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 08:19:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4F50A304032
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 06:19:49 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id jt0xLLUhouJK8WVC (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 19 Jun 2015 06:19:48 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id 9DB492D9246
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 13:19:47 +0000 (UTC)
Date: Fri, 19 Jun 2015 09:19:46 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs_copy: fix copy of hard 4k devices
Message-ID: <20150619131945.GB12833@bfoster.bfoster>
References: <5581C962.7020200@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5581C962.7020200@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Wed, Jun 17, 2015 at 02:24:18PM -0500, Eric Sandeen wrote:
> If we have a pure 4k device with no 512 emulation, xfs_copy
> fails straightaway because it tries to do a 512-byte direct
> IO read of the superblock.
> 
> Do like we do in xfs_db, and read in the max possible sector size,
> because we don't yet know what the filesystem's sector size is.
> 
> This fixes a failure in xfs/032 on a hard 4k device.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
> index 279527c..b39c84d 100644
> --- a/copy/xfs_copy.c
> +++ b/copy/xfs_copy.c
> @@ -654,8 +654,9 @@ main(int argc, char **argv)
>  
>  	memset(&mbuf, 0, sizeof(xfs_mount_t));
>  	libxfs_buftarg_init(&mbuf, xargs.ddev, xargs.logdev, xargs.rtdev);
> -	sbp = libxfs_readbuf(mbuf.m_ddev_targp, XFS_SB_DADDR, 1, 0,
> -							&xfs_sb_buf_ops);
> +	sbp = libxfs_readbuf(mbuf.m_ddev_targp, XFS_SB_DADDR,
> +			     1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT),
> +			     0, &xfs_sb_buf_ops);
>  	sb = &mbuf.m_sb;
>  	libxfs_sb_from_disk(sb, XFS_BUF_TO_SBP(sbp));
>  
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
