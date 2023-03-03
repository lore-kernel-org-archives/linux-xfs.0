Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 181DFC678D4
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Mar 2023 11:17:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbjCCLQ6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Mar 2023 06:16:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbjCCLQ6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Mar 2023 06:16:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C20284FA88
        for <linux-xfs@vger.kernel.org>; Fri,  3 Mar 2023 03:16:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F7F8B817B1
        for <linux-xfs@vger.kernel.org>; Fri,  3 Mar 2023 11:16:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2DAC433D2;
        Fri,  3 Mar 2023 11:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677842214;
        bh=weSFHttTEkCHDT4pZ+AUVid7MJPl1B0IWehe8ay1860=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lcEwgkNot5zw0GkY4P826VjXbU2CEL9GlvXKD/vVf2N8wHWaY0KGSDbn+fBulavlz
         hMQMa19ZZaIeFVZSNFnKzyQ1GgiwhItfVuG//NMJ8C+mmxFE9Z+m5U/zAc04cjyohg
         +DZZqpd9WyJy65TDlOpReVsbUojOsgdX1OPL/3bcPWAEa6zLo9GweDjKVQhuEegcFw
         0KapkCjQVLNf+vCAs/J1VIaDi2lHFEHpqBgYeLMV0eW56lPPnhzOUtoYNAYtMj5hBo
         lTykSV6hQR/lzaTx8KXOnygm919uI+B+E1jZavuVOqIVQdQpqdWbeBZzWIHb9hUyJj
         IoMQ8JekDHLfw==
Date:   Fri, 3 Mar 2023 12:16:50 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, daan.j.demeyer@gmail.com
Subject: Re: [PATCH 2/3] mkfs: use suboption processing for -p
Message-ID: <20230303111650.vflvkmgh7jpwqkc4@andromeda>
References: <167768672841.4130726.1758921319115777334.stgit@magnolia>
 <n8OAN3Mt1Gf3dVp7X3KlnxgF9gNczypwxk4l2qcps7OuFaXFG8TjbHiSa2ZMLFSXlQJRbf9HWbZVlAwcleYqKQ==@protonmail.internalid>
 <167768673971.4130726.11629972047221894699.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167768673971.4130726.11629972047221894699.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 01, 2023 at 08:05:39AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Use suboption processing for -p so that we can add a few behavioral
> variants to protofiles in the next patch.  As a side effect of this
> change, one can now provide the path to a protofile in the config
> file:
> 
> [proto]
> file=/tmp/protofile
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good, thanks for updating this!
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  man/man8/mkfs.xfs.8.in |   26 ++++++++++++++++++----
>  mkfs/xfs_mkfs.c        |   58 ++++++++++++++++++++++++++++++++++++++++++------
>  2 files changed, 73 insertions(+), 11 deletions(-)
> 
> 
> diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
> index 211e7b0c7b8..e1ca40e5da6 100644
> --- a/man/man8/mkfs.xfs.8.in
> +++ b/man/man8/mkfs.xfs.8.in
> @@ -28,7 +28,7 @@ mkfs.xfs \- construct an XFS filesystem
>  .I naming_options
>  ] [
>  .B \-p
> -.I protofile
> +.I protofile_options
>  ] [
>  .B \-q
>  ] [
> @@ -834,12 +834,29 @@ When CRCs are enabled (the default), the ftype functionality is always
>  enabled, and cannot be turned off.
>  .IP
>  In other words, this option is only tunable on the deprecated V4 format.
> -.IP
>  .RE
> +.PP
> +.PD 0
>  .TP
> -.BI \-p " protofile"
> +.BI \-p " protofile_options"
> +.TP
> +.BI "Section Name: " [proto]
> +.PD
> +These options specify the protofile parameters for populating the filesystem.
> +The valid
> +.I protofile_options
> +are:
> +.RS 1.2i
> +.TP
> +.BI [file=] protofile
> +The
> +.B file=
> +prefix is not required for this CLI argument for legacy reasons.
> +If specified as a config file directive, the prefix is required.
> +
>  If the optional
> -.BI \-p " protofile"
> +.PD
> +.I protofile
>  argument is given,
>  .B mkfs.xfs
>  uses
> @@ -979,6 +996,7 @@ in the directory. A scan of the protofile is
>  always terminated with the dollar (
>  .B $
>  ) token.
> +.RE
>  .TP
>  .B \-q
>  Quiet option. Normally
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index e219ec166da..4248e6ec344 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -113,6 +113,11 @@ enum {
>  	N_MAX_OPTS,
>  };
> 
> +enum {
> +	P_FILE = 0,
> +	P_MAX_OPTS,
> +};
> +
>  enum {
>  	R_EXTSIZE = 0,
>  	R_SIZE,
> @@ -641,6 +646,21 @@ static struct opt_params nopts = {
>  	},
>  };
> 
> +static struct opt_params popts = {
> +	.name = 'p',
> +	.ini_section = "proto",
> +	.subopts = {
> +		[P_FILE] = "file",
> +		[P_MAX_OPTS] = NULL,
> +	},
> +	.subopt_params = {
> +		{ .index = P_FILE,
> +		  .conflicts = { { NULL, LAST_CONFLICT } },
> +		  .defaultval = SUBOPT_NEEDS_VAL,
> +		},
> +	},
> +};
> +
>  static struct opt_params ropts = {
>  	.name = 'r',
>  	.ini_section = "realtime",
> @@ -841,6 +861,7 @@ struct cli_params {
>  	int	blocksize;
> 
>  	char	*cfgfile;
> +	char	*protofile;
> 
>  	/* parameters that depend on sector/block size being validated. */
>  	char	*dsize;
> @@ -1750,6 +1771,33 @@ naming_opts_parser(
>  	return 0;
>  }
> 
> +static int
> +proto_opts_parser(
> +	struct opt_params	*opts,
> +	int			subopt,
> +	const char		*value,
> +	struct cli_params	*cli)
> +{
> +	switch (subopt) {
> +	case P_FILE:
> +		fallthrough;
> +	default:
> +		if (cli->protofile) {
> +			if (subopt < 0)
> +				subopt = P_FILE;
> +			respec(opts->name, opts->subopts, subopt);
> +		}
> +		cli->protofile = strdup(value);
> +		if (!cli->protofile) {
> +			fprintf(stderr,
> + _("Out of memory while saving protofile option.\n"));
> +			exit(1);
> +		}
> +		break;
> +	}
> +	return 0;
> +}
> +
>  static int
>  rtdev_opts_parser(
>  	struct opt_params	*opts,
> @@ -1813,6 +1861,7 @@ static struct subopts {
>  	{ &lopts, log_opts_parser },
>  	{ &mopts, meta_opts_parser },
>  	{ &nopts, naming_opts_parser },
> +	{ &popts, proto_opts_parser },
>  	{ &ropts, rtdev_opts_parser },
>  	{ &sopts, sector_opts_parser },
>  	{ NULL, NULL },
> @@ -4013,7 +4062,6 @@ main(
>  	int			discard = 1;
>  	int			force_overwrite = 0;
>  	int			quiet = 0;
> -	char			*protofile = NULL;
>  	char			*protostring = NULL;
>  	int			worst_freelist = 0;
> 
> @@ -4119,6 +4167,7 @@ main(
>  		case 'l':
>  		case 'm':
>  		case 'n':
> +		case 'p':
>  		case 'r':
>  		case 's':
>  			parse_subopts(c, optarg, &cli);
> @@ -4134,11 +4183,6 @@ main(
>  		case 'K':
>  			discard = 0;
>  			break;
> -		case 'p':
> -			if (protofile)
> -				respec('p', NULL, 0);
> -			protofile = optarg;
> -			break;
>  		case 'q':
>  			quiet = 1;
>  			break;
> @@ -4165,7 +4209,7 @@ main(
>  	 */
>  	cfgfile_parse(&cli);
> 
> -	protostring = setup_proto(protofile);
> +	protostring = setup_proto(cli.protofile);
> 
>  	/*
>  	 * Extract as much of the valid config as we can from the CLI input
> 

-- 
Carlos Maiolino
