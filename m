Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:47730 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752997AbeCFTRB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Mar 2018 14:17:01 -0500
Subject: Re: [PATCH 07/16] xfs_db: print transaction reservation type
 information
References: <151993157539.22223.6269629008244777191.stgit@magnolia>
 <151993161907.22223.2470790760502530047.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <16edb54d-209f-79f1-774e-b5d21b0f4ae3@sandeen.net>
Date: Tue, 6 Mar 2018 13:16:56 -0600
MIME-Version: 1.0
In-Reply-To: <151993161907.22223.2470790760502530047.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org

On 3/1/18 1:13 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a new xfs_db command to print the transaction reservation info for
> a given filesystem.  This will make it easier to compare the calculations
> made by the kernel and xfsprogs in case there is a discrepancy.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  db/command.c             |    1 +
>  db/logformat.c           |   59 ++++++++++++++++++++++++++++++++++++++++++++++
>  db/logformat.h           |    1 +
>  libxfs/libxfs_api_defs.h |    2 +-
>  man/man8/xfs_db.8        |    6 +++++
>  5 files changed, 68 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/db/command.c b/db/command.c
> index 5ff3c4f..12ae5b7 100644
> --- a/db/command.c
> +++ b/db/command.c
> @@ -138,6 +138,7 @@ init_commands(void)
>  	hash_init();
>  	inode_init();
>  	input_init();
> +	logres_init();
>  	logformat_init();
>  	io_init();
>  	metadump_init();
> diff --git a/db/logformat.c b/db/logformat.c
> index 70097bc..b290bd3 100644
> --- a/db/logformat.c
> +++ b/db/logformat.c
> @@ -147,3 +147,62 @@ logformat_init(void)
>  
>  	add_command(&logformat_cmd);
>  }
> +
> +static void
> +print_logres(
> +	int			i,
> +	struct xfs_trans_res	*res)
> +{
> +	dbprintf(_("type %d logres %u logcount %d flags 0x%x\n"),
> +		i, res->tr_logres, res->tr_logcount, res->tr_logflags);
> +}
> +
> +int
> +logres_f(
> +	int			argc,
> +	char			**argv)
> +{
> +	struct xfs_trans_res	resv;
> +	struct xfs_trans_res	*res;
> +	struct xfs_trans_res	*end_res;
> +	int			i;
> +
> +	res = (struct xfs_trans_res *)M_RES(mp);
> +	end_res = (struct xfs_trans_res *)(M_RES(mp) + 1);
> +	for (i = 0; res < end_res; i++, res++)
> +		print_logres(i, res);
> +	libxfs_log_get_max_trans_res(mp, &resv);
> +	print_logres(-1, &resv);
> +
> +	return 0;
> +}
> +
> +static void
> +logres_help(void)
> +{
> +	dbprintf(_(
> +"\n"
> +" The 'logres' command prints information about all log reservation types.\n"
> +" This includes the reservation space, the intended transaction roll count,\n"
> +" and the reservation flags, if any.\n"
> +"\n"
> +	));
> +}
> +
> +static const struct cmdinfo logres_cmd = {
> +	.name =		"logres",
> +	.altname =	NULL,
> +	.cfunc =	logres_f,
> +	.argmin =	0,
> +	.argmax =	0,
> +	.canpush =	0,
> +	.args =		NULL,
> +	.oneline =	N_("dump log reservations"),
> +	.help =		logres_help,
> +};
> +
> +void
> +logres_init(void)
> +{
> +	add_command(&logres_cmd);
> +}
> diff --git a/db/logformat.h b/db/logformat.h
> index f9763ee..60396c0 100644
> --- a/db/logformat.h
> +++ b/db/logformat.h
> @@ -17,3 +17,4 @@
>   */
>  
>  void logformat_init(void);
> +void logres_init(void);
> diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
> index d2ab02a..5d56340 100644
> --- a/libxfs/libxfs_api_defs.h
> +++ b/libxfs/libxfs_api_defs.h
> @@ -60,7 +60,7 @@
>  #define xfs_trans_roll			libxfs_trans_roll
>  #define xfs_trans_get_buf_map		libxfs_trans_get_buf_map
>  #define xfs_trans_resv_calc		libxfs_trans_resv_calc
> -
> +#define xfs_log_get_max_trans_res	libxfs_log_get_max_trans_res
>  #define xfs_attr_get			libxfs_attr_get
>  #define xfs_attr_set			libxfs_attr_set
>  #define xfs_attr_remove			libxfs_attr_remove
> diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
> index 37018a7..524b1ef 100644
> --- a/man/man8/xfs_db.8
> +++ b/man/man8/xfs_db.8
> @@ -690,6 +690,12 @@ Start logging output to
>  .IR filename ,
>  stop logging, or print the current logging status.
>  .TP
> +.B logres
> +Print transaction reservation size information for each transaction type.
> +This makes it easier to find discrepancies in the reservation calculations
> +between xfsprogs and the kernel, which will help when diagnosing minimum
> +log size calculation errors.
> +.TP
>  .BI "metadump [\-egow] " filename
>  Dumps metadata to a file. See
>  .BR xfs_metadump (8)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
