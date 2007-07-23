Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 22 Jul 2007 17:24:43 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6N0Ocbm023679
	for <xfs@oss.sgi.com>; Sun, 22 Jul 2007 17:24:39 -0700
Date: Mon, 23 Jul 2007 10:24:32 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] superblock endianess annotations
Message-ID: <20070723002432.GL31489@sgi.com>
References: <20070720163303.GB6902@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070720163303.GB6902@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Fri, Jul 20, 2007 at 06:33:03PM +0200, Christoph Hellwig wrote:
> Creates a new xfs_dsb_t that is __be annotated and keeps xfs_sb_t for
> the incore one.  xfs_xlatesb is renamed to xfs_sb_to_disk and only
> handles the incore -> disk conversion.  A new helper xfs_sb_from_disk
> handles the other direction and doesn't need the slightly hacky
> table-driven approach because we only ever read the full sb from disk.

Nice. There's some good cleanups in this patch....

> The handling of shared r/o filesystems has been buggy on little endian
> system and fixing this required shuffling around of some code in that
> area.

*nod*

>  
>  /*
> + * Superblock - on disk version.  Must match the in core version below.
> + */
> +typedef struct xfs_dsb {
> +	__be32		sb_magicnum;	/* magic number == XFS_SB_MAGIC */
.....
> +	__be16		sb_logsectsize;	/* sector size for the log, bytes */
> +	__be32		sb_logsunit;	/* stripe unit size for the log */
> +	__be32		sb_features2;	/* additional feature bits */
> +} xfs_dsb_t;

Should this be packed so we don't reintroduce have the problem we currently
do with 32-vs-64-bit alignment of the last field(s) in the structure?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
