Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3C26A7F51
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 07:07:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F0C57304032
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 05:07:36 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id eBQYi4dm50bDQ2QQ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Mar 2015 05:07:35 -0700 (PDT)
Date: Tue, 24 Mar 2015 08:07:34 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 02/13 V2] xfs_db: fix inode CRC validity state, and warn
	on read if invalid
Message-ID: <20150324120733.GB21657@bfoster.bfoster>
References: <1426624395-8258-1-git-send-email-sandeen@redhat.com>
	<1426624395-8258-3-git-send-email-sandeen@redhat.com>
	<5510736D.8020307@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5510736D.8020307@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

On Mon, Mar 23, 2015 at 03:11:25PM -0500, Eric Sandeen wrote:
> Currently, the "ino_crc_ok" field on the io cursor reflects
> overall inode validity, not CRC correctness.  Because it is
> only used when printing CRC validity, change it to reflect
> only that state - and update it whenever we re-write the
> inode (thus updating the CRC).
> 
> In addition, when reading an inode, warn if the CRC is bad.
> 
> Note, when specifying an inode which doesn't actually exist,
> this will claim corruption; I'm not sure if that's good or
> bad. Today, it already issues corruption errors on the way;
> this adds a new message as well:
> 
> xfs_db> inode 129
> Metadata corruption detected at block 0x80/0x2000
> Metadata corruption detected at block 0x80/0x2000
> ...
> Metadata CRC error detected for ino 129
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> V2: move ino_crc_ok calculations under "if (xfs_sb_version_hascrc())"
> 
> diff --git a/db/inode.c b/db/inode.c
> index 24170ba..4f9c65d 100644
> --- a/db/inode.c
> +++ b/db/inode.c
> @@ -684,13 +684,22 @@ set_cur_inode(
>  		numblks, DB_RING_IGN, NULL);
>  	off_cur(offset << mp->m_sb.sb_inodelog, mp->m_sb.sb_inodesize);
>  	dip = iocur_top->data;
> -	iocur_top->ino_crc_ok = libxfs_dinode_verify(mp, ino, dip);
>  	iocur_top->ino_buf = 1;
>  	iocur_top->ino = ino;
>  	iocur_top->mode = be16_to_cpu(dip->di_mode);
>  	if ((iocur_top->mode & S_IFMT) == S_IFDIR)
>  		iocur_top->dirino = ino;
>  
> +	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +		iocur_top->ino_crc_ok = libxfs_verify_cksum((char *)dip,
> +						    mp->m_sb.sb_inodesize,
> +						    XFS_DINODE_CRC_OFF);
> +		if (!iocur_top->ino_crc_ok)
> +			dbprintf(
> +_("Metadata CRC error detected for ino %lld\n"),
> +				ino);
> +	}
> +
>  	/* track updated info in ring */
>  	ring_add();
>  }
> diff --git a/db/io.c b/db/io.c
> index c5898f1..d906123 100644
> --- a/db/io.c
> +++ b/db/io.c
> @@ -471,8 +471,10 @@ write_cur(void)
>  		return;
>  	}
>  
> -	if (iocur_top->ino_buf)
> +	if (xfs_sb_version_hascrc(&mp->m_sb) && iocur_top->ino_buf) {
>  		libxfs_dinode_calc_crc(mp, iocur_top->data);
> +		iocur_top->ino_crc_ok = 1;
> +	}
>  	if (iocur_top->dquot_buf)
>  		xfs_update_cksum(iocur_top->data, sizeof(struct xfs_dqblk),
>  				 XFS_DQUOT_CRC_OFF);
> diff --git a/include/libxfs.h b/include/libxfs.h
> index 45a924f..962e319 100644
> --- a/include/libxfs.h
> +++ b/include/libxfs.h
> @@ -782,6 +782,8 @@ extern uint32_t crc32c_le(uint32_t crc, unsigned char const *p, size_t len);
>  
>  #include <xfs/xfs_cksum.h>
>  
> +#define libxfs_verify_cksum	xfs_verify_cksum
> +
>  static inline int
>  xfs_buf_verify_cksum(struct xfs_buf *bp, unsigned long cksum_offset)
>  {
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
