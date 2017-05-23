Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42606 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758664AbdEWPqJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2017 11:46:09 -0400
Date: Tue, 23 May 2017 08:46:03 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_metadump: tag metadump image with attribute flags
Message-ID: <20170523154603.GR4519@birch.djwong.org>
References: <402504cb-1632-85b6-a745-1334ccf0ee8f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <402504cb-1632-85b6-a745-1334ccf0ee8f@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Mon, May 22, 2017 at 07:33:35PM -0500, Eric Sandeen wrote:
> After the long discussion about warning the user and/or consumer
> of xfs_metadumps about dirty logs, it crossed my mind that we
> could use the reserved slot in the metadump header to tag the
> file with attributes, so the consumer of the metadump knows how
> it was created.
> 
> This patch adds 3 flags to describe the metadump: dirty log,
> obfuscated, and full blocks (unused portions of metadata blocks
> are not zeroed out).
> 
> It then adds a new option to xfs_mdrestore, "-i" to show info,
> which can be used with or without a target file:
> 
> # xfs_mdrestore -i metadumpfile
> metadumpfile: not obfuscated, clean log, full metadata blocks
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index fe068ef..2062415 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -2820,6 +2820,27 @@ metadump_f(
>  	metablock->mb_blocklog = BBSHIFT;
>  	metablock->mb_magic = cpu_to_be32(XFS_MD_MAGIC);
>  
> +	/* Set flags indicating state of metadump */
> +	if (obfuscate)
> +		metablock->mb_flags = XFS_METADUMP_OBFUSCATED;
> +	if (!zero_stale_data)
> +		metablock->mb_flags |= XFS_METADUMP_FULLBLOCKS;
> +
> +	/* If we'll copy the log, see if the log is dirty */
> +	if (mp->m_sb.sb_logstart) {
> +		push_cur();
> +		set_cur(&typtab[TYP_LOG],
> +			XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
> +			mp->m_sb.sb_logblocks * blkbb, DB_RING_IGN, NULL);
> +		if (iocur_top->data) {	/* best effort */
> +			struct xlog	log;
> +
> +			if (xlog_is_dirty(mp, &log, &x, 0))
> +				metablock->mb_flags |= XFS_METADUMP_DIRTYLOG;
> +		}
> +		pop_cur();
> +	}
> +
>  	block_index = (__be64 *)((char *)metablock + sizeof(xfs_metablock_t));
>  	block_buffer = (char *)metablock + BBSIZE;
>  	num_indices = (BBSIZE - sizeof(xfs_metablock_t)) / sizeof(__be64);
> diff --git a/include/xfs_metadump.h b/include/xfs_metadump.h
> index f4be51b..dfe804c 100644
> --- a/include/xfs_metadump.h
> +++ b/include/xfs_metadump.h
> @@ -25,8 +25,13 @@ typedef struct xfs_metablock {
>  	__be32		mb_magic;
>  	__be16		mb_count;
>  	__uint8_t	mb_blocklog;
> -	__uint8_t	mb_reserved;
> +	__uint8_t	mb_flags;
>  	/* followed by an array of xfs_daddr_t */
>  } xfs_metablock_t;
>  
> +/* mb_flags */
> +#define XFS_METADUMP_OBFUSCATED	(1 << 0)
> +#define XFS_METADUMP_FULLBLOCKS	(1 << 1)
> +#define XFS_METADUMP_DIRTYLOG	(1 << 2)

If we always wrote zero for mb_reserved previously, how do we
distinguish between a non-obfuscated partial-block clean-log metadump
and an old metadump?  Do we care?

I imagine metadumps are fairly transitory in nature, so it might not be
a big deal, and probably not worth burning 1/8 of our flag-space over
since AFAICT we don't use the(se) flags for any serious behavioral
changes.

--D

> +
>  #endif /* _XFS_METADUMP_H_ */
> diff --git a/man/man8/xfs_mdrestore.8 b/man/man8/xfs_mdrestore.8
> index 2095f15..10c00b2 100644
> --- a/man/man8/xfs_mdrestore.8
> +++ b/man/man8/xfs_mdrestore.8
> @@ -4,11 +4,15 @@ xfs_mdrestore \- restores an XFS metadump image to a filesystem image
>  .SH SYNOPSIS
>  .B xfs_mdrestore
>  [
> -.B \-g
> +.B \-gi
>  ]
>  .I source
>  .I target
>  .br
> +.B xfs_mdrestore
> +.B \-i
> +.I source
> +.br
>  .B xfs_mdrestore \-V
>  .SH DESCRIPTION
>  .B xfs_mdrestore
> @@ -39,6 +43,11 @@ can be destroyed.
>  .B \-g
>  Shows restore progress on stdout.
>  .TP
> +.B \-i
> +Shows metadump information on stdout.  If no
> +.I target
> +is specified, exits after displaying information.
> +.TP
>  .B \-V
>  Prints the version number and exits.
>  .SH DIAGNOSTICS
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index 0d399f1..1fbb1e6 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -21,6 +21,7 @@
>  
>  char 		*progname;
>  int		show_progress = 0;
> +int		show_info = 0;
>  int		progress_since_warning = 0;
>  
>  static void
> @@ -213,11 +214,14 @@ main(
>  
>  	progname = basename(argv[0]);
>  
> -	while ((c = getopt(argc, argv, "gV")) != EOF) {
> +	while ((c = getopt(argc, argv, "giV")) != EOF) {
>  		switch (c) {
>  			case 'g':
>  				show_progress = 1;
>  				break;
> +			case 'i':
> +				show_info = 1;
> +				break;
>  			case 'V':
>  				printf("%s version %s\n", progname, VERSION);
>  				exit(0);
> @@ -226,7 +230,11 @@ main(
>  		}
>  	}
>  
> -	if (argc - optind != 2)
> +	if (argc - optind < 1 || argc - optind > 2)
> +		usage();
> +
> +	/* show_info without a target is ok */
> +	if (!show_info && argc - optind != 2)
>  		usage();
>  
>  	/* open source */
> @@ -239,6 +247,29 @@ main(
>  		if (src_f == NULL)
>  			fatal("cannot open source dump file\n");
>  	}
> +
> +	if (show_info) {
> +		xfs_metablock_t		mb;
> +
> +		if (fread(&mb, sizeof(mb), 1, src_f) != 1)
> +			fatal("error reading from file: %s\n", strerror(errno));
> +
> +		if (be32_to_cpu(mb.mb_magic) != XFS_MD_MAGIC)
> +			fatal("specified file is not a metadata dump\n");
> +
> +		printf("%s: %sobfuscated, %s log, %s metadata blocks\n",
> +			argv[optind],
> +			mb.mb_flags & XFS_METADUMP_OBFUSCATED ? "" : "not ",
> +			mb.mb_flags & XFS_METADUMP_DIRTYLOG ? "dirty" : "clean",
> +			mb.mb_flags & XFS_METADUMP_FULLBLOCKS ? "full" : "zeroed");
> +
> +		if (argc - optind == 1)
> +			exit(0);
> +
> +		/* Go back to the beginning for the restore function */
> +		fseek(src_f, 0L, SEEK_SET);
> +	}
> +
>  	optind++;
>  
>  	/* check and open target */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
