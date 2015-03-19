Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 239CC7F37
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 10:07:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A8B25AC001
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 08:07:10 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Y8Unxjf9XvGFiyl1 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 19 Mar 2015 08:07:09 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id 3C51BCC086
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 15:07:09 +0000 (UTC)
Date: Thu, 19 Mar 2015 11:07:06 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 01/13] xfs_db: Allow writes of corrupted data by
	optionally skipping write verifiers
Message-ID: <20150319150706.GA11669@laptop.bfoster>
References: <1426624395-8258-1-git-send-email-sandeen@redhat.com>
	<1426624395-8258-2-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1426624395-8258-2-git-send-email-sandeen@redhat.com>
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
Cc: xfs@oss.sgi.com

On Tue, Mar 17, 2015 at 03:33:03PM -0500, Eric Sandeen wrote:
> Being able to write corrupt data is handy if we wish to test
> repair against specific types of corruptions.
> 
> Add a "-c" option to the write command which allows this.
> 
> Note that this also skips CRC updates; it's not currently possible
> to write invalid data with a valid CRC; CRC recalculation is
> intertwined with validation.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  db/io.c           |    7 +++++++
>  db/io.h           |    1 +
>  db/write.c        |   35 +++++++++++++++++++++++++++++++----
>  man/man8/xfs_db.8 |    8 +++++++-
>  4 files changed, 46 insertions(+), 5 deletions(-)
> 
> diff --git a/db/io.c b/db/io.c
> index 7f1b76a..c5898f1 100644
> --- a/db/io.c
> +++ b/db/io.c
> @@ -457,6 +457,13 @@ write_cur_bbs(void)
>  }
>  
>  void
> +xfs_dummy_verify(
> +	struct xfs_buf *bp)
> +{
> +	return;
> +}
> +
> +void
>  write_cur(void)
>  {
>  	if (iocur_sp < 0) {
> diff --git a/db/io.h b/db/io.h
> index 71082e6..31d96b4 100644
> --- a/db/io.h
> +++ b/db/io.h
> @@ -63,6 +63,7 @@ extern void	set_cur(const struct typ *t, __int64_t d, int c, int ring_add,
>  			bbmap_t *bbmap);
>  extern void     ring_add(void);
>  extern void	set_iocur_type(const struct typ *t);
> +extern void	xfs_dummy_verify(struct xfs_buf *bp);
>  
>  /*
>   * returns -1 for unchecked, 0 for bad and 1 for good
> diff --git a/db/write.c b/db/write.c
> index a0f14f4..4511859 100644
> --- a/db/write.c
> +++ b/db/write.c
> @@ -38,7 +38,7 @@ static int	write_f(int argc, char **argv);
>  static void     write_help(void);
>  
>  static const cmdinfo_t	write_cmd =
> -	{ "write", NULL, write_f, 0, -1, 0, N_("[field or value]..."),
> +	{ "write", NULL, write_f, 0, -1, 0, N_("[-c] [field or value]..."),
>  	  N_("write value to disk"), write_help };
>  
>  void
> @@ -79,6 +79,7 @@ write_help(void)
>  "  String mode: 'write \"This_is_a_filename\" - write null terminated string.\n"
>  "\n"
>  " In data mode type 'write' by itself for a list of specific commands.\n\n"
> +" Specifying the -c option will allow writes of invalid (corrupt) data.\n\n"
>  ));
>  
>  }
> @@ -90,6 +91,10 @@ write_f(
>  {
>  	pfunc_t	pf;
>  	extern char *progname;
> +	int c;
> +	int corrupt = 0;		/* Allow write of corrupt data; skip verification */
> +	struct xfs_buf_ops nowrite_ops;
> +	const struct xfs_buf_ops *stashed_ops = NULL; 

Still has whitespace damage on the line above and the if (argc) thing in
the hunk below. Can we kill those? This looks fine to me otherwise:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  
>  	if (x.isreadonly & LIBXFS_ISREADONLY) {
>  		dbprintf(_("%s started in read only mode, writing disabled\n"),
> @@ -109,12 +114,34 @@ write_f(
>  		return 0;
>  	}
>  
> -	/* move past the "write" command */
> -	argc--;
> -	argv++;
> +	if (argc) while ((c = getopt(argc, argv, "c")) != EOF) {
> +		switch (c) {
> +		case 'c':
> +			corrupt = 1;
> +			break;
> +		default:
> +			dbprintf(_("bad option for write command\n"));
> +			return 0;
> +		}
> +	}
> +
> +	argc -= optind;
> +	argv += optind;
> +
> +	if (corrupt) {
> +		/* Temporarily remove write verifier to write bad data */
> +		stashed_ops = iocur_top->bp->b_ops;
> +		nowrite_ops.verify_read = stashed_ops->verify_read;
> +		nowrite_ops.verify_write = xfs_dummy_verify;
> +		iocur_top->bp->b_ops = &nowrite_ops;
> +		dbprintf(_("Allowing write of corrupted data\n"));
> +	}
>  
>  	(*pf)(DB_WRITE, cur_typ->fields, argc, argv);
>  
> +	if (stashed_ops)
> +		iocur_top->bp->b_ops = stashed_ops;
> +
>  	return 0;
>  }
>  
> diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
> index 4d8d4ff..d527230 100644
> --- a/man/man8/xfs_db.8
> +++ b/man/man8/xfs_db.8
> @@ -711,7 +711,7 @@ and
>  bits respectively, and their string equivalent reported
>  (but no modifications are made).
>  .TP
> -.BI "write [" "field value" "] ..."
> +.BI "write [\-c] [" "field value" "] ..."
>  Write a value to disk.
>  Specific fields can be set in structures (struct mode),
>  or a block can be set to data values (data mode),
> @@ -729,6 +729,12 @@ contents of the block can be shifted or rotated left or right, or filled
>  with a sequence, a constant value, or a random value. In this mode
>  .B write
>  with no arguments gives more information on the allowed commands.
> +.RS 1.0i
> +.TP 0.4i
> +.B \-c
> +Skip write verifiers and CRC recalculation; allows invalid data to be written
> +to disk.
> +.RE
>  .SH TYPES
>  This section gives the fields in each structure type and their meanings.
>  Note that some types of block cover multiple actual structures,
> -- 
> 1.7.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
