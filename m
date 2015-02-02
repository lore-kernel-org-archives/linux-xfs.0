Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 721027FA9
	for <xfs@oss.sgi.com>; Mon,  2 Feb 2015 02:41:07 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 506968F8033
	for <xfs@oss.sgi.com>; Mon,  2 Feb 2015 00:41:07 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id sCy5mBFTlytMymN0 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Feb 2015 00:41:02 -0800 (PST)
Date: Mon, 2 Feb 2015 00:41:02 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] xfs: struct xfs_sb is no longer tied to the on-disk
	format
Message-ID: <20150202084102.GA28121@infradead.org>
References: <1422826983-29570-1-git-send-email-david@fromorbit.com>
	<1422826983-29570-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1422826983-29570-2-git-send-email-david@fromorbit.com>
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

>  /*
> - * Superblock - in core version.  Must match the ondisk version below.
> - * Must be padded to 64 bit alignment.
> - */
> -typedef struct xfs_sb {
> -	__uint32_t	sb_magicnum;	/* magic number == XFS_SB_MAGIC */
> -	__uint32_t	sb_blocksize;	/* logical block size, bytes */

> -static inline int xfs_sb_version_hasfinobt(xfs_sb_t *sbp)
> +static inline int xfs_sb_version_hasfinobt(struct xfs_sb *sbp)

So xfs_format.h now requires struct xfs_sb to be defined before it
can be included?  I guess we need to move these macros around as well.

> diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
> index 2b830c2..a02236b 100644
> --- a/fs/xfs/xfs_super.h
> +++ b/fs/xfs/xfs_super.h
> @@ -61,6 +61,87 @@ struct xfs_mount;
>  struct xfs_buftarg;
>  struct block_device;
>  
> +/*
> + * Superblock - in core version.  This does not have ot match the size and shape
> + * of the on-disk superblock, but must contain all the fields that we use in the
> + * on-disk superblock.
> + */
> +struct xfs_sb {

Is this really the right header?  xfs_super.h only really is for bits
related to linux super block operastions.

I'd expect to move it close to stuct xfs_mount, and maybe even merge
it into that in the long run.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
