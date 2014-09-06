Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B69767F3F
	for <xfs@oss.sgi.com>; Sat,  6 Sep 2014 18:00:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 96F5D304048
	for <xfs@oss.sgi.com>; Sat,  6 Sep 2014 16:00:27 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	6cB7j09490RZCntr for <xfs@oss.sgi.com>;
	Sat, 06 Sep 2014 16:00:25 -0700 (PDT)
Date: Sun, 7 Sep 2014 09:00:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs_db: fix inode CRC validity state, and warn on
	read if invalid
Message-ID: <20140906230008.GC9955@dastard>
References: <540B4399.4020804@sandeen.net>
 <540B485F.8070502@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <540B485F.8070502@sandeen.net>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On Sat, Sep 06, 2014 at 12:46:07PM -0500, Eric Sandeen wrote:
> Currently, the "ino_crc_ok" field on the io cursor
> reflects overall inode validity, not CRC correctness.
> Because it is only used when printing CRC validity,
> change it to reflect only that.
> 
> In addition, when reading an inode, print the current
> CRC state.
> 
> Note, if specifying an inode which doesn't actually
> exist, this will claim corruption; I'm not sure if
> that's good or bad.  Today, it already issues corruption
> errors on the way; this adds a new message as well ;)
> 
> xfs_db> inode 129
> Metadata corruption detected at block 0x80/0x2000
> Metadata corruption detected at block 0x80/0x2000
> ...
> Metadata CRC error detected for ino 129
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/db/inode.c b/db/inode.c
> index 24170ba..244d03b 100644
> --- a/db/inode.c
> +++ b/db/inode.c
> @@ -684,13 +684,18 @@ set_cur_inode(
>  		numblks, DB_RING_IGN, NULL);
>  	off_cur(offset << mp->m_sb.sb_inodelog, mp->m_sb.sb_inodesize);
>  	dip = iocur_top->data;
> -	iocur_top->ino_crc_ok = libxfs_dinode_verify(mp, ino, dip);
> +	iocur_top->ino_crc_ok = xfs_verify_cksum((char *)dip,
> +						 mp->m_sb.sb_inodesize,
> +						 XFS_DINODE_CRC_OFF);

that needs to be "libxfs_verify_cksum".

>  	iocur_top->ino_buf = 1;
>  	iocur_top->ino = ino;
>  	iocur_top->mode = be16_to_cpu(dip->di_mode);
>  	if ((iocur_top->mode & S_IFMT) == S_IFDIR)
>  		iocur_top->dirino = ino;
> +	if (xfs_sb_version_hascrc(&mp->m_sb) && !iocur_top->ino_crc_ok)
> +		dbprintf(_("Metadata CRC error detected for ino %lld\n"), ino);
> +

and we probably shoul dbe looking at making all those sb version
checks "libxfs_sb_version_has...." as well.

>  	/* track updated info in ring */
>  	ring_add();
>  }
> diff --git a/db/io.c b/db/io.c
> index 7f1b76a..93ebf5c 100644
> --- a/db/io.c
> +++ b/db/io.c
> @@ -473,6 +473,17 @@ write_cur(void)
>  		write_cur_bbs();
>  	else
>  		write_cur_buf();
> +
> +	if (iocur_top->ino_buf) {
> +		xfs_dinode_t    *dip;
> +		xfs_ino_t       ino;
> +
> +		dip = iocur_top->data;
> +		ino = iocur_top->ino;
> +		iocur_top->ino_crc_ok = xfs_verify_cksum((char *)dip,
> +						 mp->m_sb.sb_inodesize,
> +						 XFS_DINODE_CRC_OFF);
> +	}

Needs a comment explaining why we are reverifying the inode crc.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
