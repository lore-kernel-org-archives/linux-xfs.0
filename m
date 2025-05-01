Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5124257443
	for <linux-xfs@vger.kernel.org>; Thu,  1 May 2025 22:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746137911; cv=none; b=h9Svl4RCd9RNrtcJMOnFrKFjPBYNORKCh1FYAaiqucWyeITit5dDSf7+FXzCXnH1HRvtMVkynoTXdFNyrU0xuK6Drlpfzui/yAgJ9QerhjH0WyqdDHEXacT+BdVIjMcmkXHcaIQ2VRP6BttU3/JRMQsXyQ8TbMoGrOlU/tdARVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746137911; c=relaxed/simple;
	bh=cP0pvN5+ZnKTZv0UANgfUxOMkBlulN9T69m8Xdv+HM8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HqW2zpWKo5N+gEOPUdrVjfs3ZfMaCaHBrmDaF0ErtGwkwl6iCNS5XSHJiO+2eJuFKoFdlEKdNvuCNuB8XSjD6hOth80k3XZPo/gIj4fptQK8QcahhIthydgMrV0ltzKr8KHeF25o1PO4ZOGc0TtbsVsGWAo/LHWQku08v85y888=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X3B3fcHG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X3B3fcHG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691DFC4CEE3;
	Thu,  1 May 2025 22:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746137910;
	bh=cP0pvN5+ZnKTZv0UANgfUxOMkBlulN9T69m8Xdv+HM8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X3B3fcHGwW5VZUbrqMiH0qpGfWH3S0Obdr0qZvM1xbdIHQxE1g/lX/4Zvq2hc5KO6
	 rSm0I4t7TNA1/Ztfb8R4vOJDuO/kU6RzAz6wC9jY57rdoXF0aYI3gnC95JVZrinr7s
	 5p/5Z/OMy8cBUraFALKW32fFYkcHjz2J2r0LdKRvAQlycifTf1bHpdlJMsTTB1mnkL
	 uKghtuMHw0pRnZL0iGBwa71h7GNZdmxw5quR9YuAiOn8fj7PBPU4svk+xvBfoTGYKP
	 xFXnwu99IbE8CtwEpySB/cBgq9Eb0KUPRZo0bae9x/ZQUCVxfd+rUxt74ayfwL+JeO
	 JZ0H+gXgwTz8g==
Date: Thu, 1 May 2025 15:18:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Luca Di Maio <luca.dimaio1@gmail.com>
Cc: linux-xfs@vger.kernel.org, dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev, hch@infradead.org
Subject: Re: [PATCH v8 2/2] mkfs: modify -p flag to populate a filesystem
 from a directory
Message-ID: <20250501221829.GK25675@frogsfrogsfrogs>
References: <20250501081552.1328703-1-luca.dimaio1@gmail.com>
 <20250501081552.1328703-3-luca.dimaio1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250501081552.1328703-3-luca.dimaio1@gmail.com>

On Thu, May 01, 2025 at 10:15:52AM +0200, Luca Di Maio wrote:
> right now the `-p` flag only supports a file input.
> this patch will add support to input a directory.
> on directory input, the populate functionality to copy files into
> the root filesystem.
> 
> add `atime` flag to popts, that will let the user choose if copy the
> atime timestamps from source directory.
> 
> add documentation for new functionalities in man pages.
> 
> Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
> ---
>  man/man8/mkfs.xfs.8.in | 41 +++++++++++++++++++++++++++++------------
>  mkfs/xfs_mkfs.c        | 23 +++++++++++++++++++----
>  2 files changed, 48 insertions(+), 16 deletions(-)
> 
> diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
> index 37e3a88e..bb38c148 100644
> --- a/man/man8/mkfs.xfs.8.in
> +++ b/man/man8/mkfs.xfs.8.in
> @@ -28,7 +28,7 @@ mkfs.xfs \- construct an XFS filesystem
>  .I naming_options
>  ] [
>  .B \-p
> -.I protofile_options
> +.I prototype_options
>  ] [
>  .B \-q
>  ] [
> @@ -977,30 +977,39 @@ option set.
>  .PP
>  .PD 0
>  .TP
> -.BI \-p " protofile_options"
> +.BI \-p " prototype_options"
>  .TP
>  .BI "Section Name: " [proto]
>  .PD
> -These options specify the protofile parameters for populating the filesystem.
> +These options specify the prototype parameters for populating the filesystem.
>  The valid
> -.I protofile_options
> +.I prototype_options
>  are:
>  .RS 1.2i
>  .TP
> -.BI [file=] protofile
> +.BI [file=]
>  The
>  .B file=
>  prefix is not required for this CLI argument for legacy reasons.
>  If specified as a config file directive, the prefix is required.
> -
> +.TP
> +.BI [file=] directory
>  If the optional
>  .PD
> -.I protofile
> -argument is given,
> +.I prototype
> +argument is given, and it's a directory,
>  .B mkfs.xfs
> -uses
> -.I protofile
> -as a prototype file and takes its directions from that file.
> +will populate the root file system with the contents of the given directory.
> +Content, timestamps (atime, mtime), attributes and extended attributes are preserved
> +for all file types.
> +.TP
> +.BI [file=] protofile
> +If the optional
> +.PD
> +.I prototype
> +argument is given, and points to a regular file,
> +.B mkfs.xfs
> +uses it as a prototype file and takes its directions from that file.

This ought to be in the previous patch.

>  The blocks and inodes specifiers in the
>  .I protofile
>  are provided for backwards compatibility, but are otherwise unused.
> @@ -1136,8 +1145,16 @@ always terminated with the dollar (
>  .B $
>  ) token.
>  .TP
> +.BI atime= value
> +If set to 1, when we're populating the root filesystem from a directory (
> +.B file=directory
> +option)
> +access times are going to be preserved and are copied from the source files.
> +Set to 0 to set access times to the current time instead.
> +By default, this is set to 0.
> +.TP
>  .BI slashes_are_spaces= value
> -If set to 1, slashes ("/") in the first token of each line of the protofile
> +If set to 1, slashes ("/") in the first token of each line of the prototype file
>  are converted to spaces.
>  This enables the creation of a filesystem containing filenames with spaces.
>  By default, this is set to 0.
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 3f4455d4..e4d82d48 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -121,6 +121,7 @@ enum {
> 
>  enum {
>  	P_FILE = 0,
> +	P_ATIME,
>  	P_SLASHES,
>  	P_MAX_OPTS,
>  };
> @@ -709,6 +710,7 @@ static struct opt_params popts = {
>  	.ini_section = "proto",
>  	.subopts = {
>  		[P_FILE] = "file",
> +		[P_ATIME] = "atime",
>  		[P_SLASHES] = "slashes_are_spaces",
>  		[P_MAX_OPTS] = NULL,
>  	},
> @@ -717,6 +719,12 @@ static struct opt_params popts = {
>  		  .conflicts = { { NULL, LAST_CONFLICT } },
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
> +		{ .index = P_ATIME,
> +		  .conflicts = { { NULL, LAST_CONFLICT } },
> +		  .minval = 0,
> +		  .maxval = 1,
> +		  .defaultval = 1,
> +		},
>  		{ .index = P_SLASHES,
>  		  .conflicts = { { NULL, LAST_CONFLICT } },
>  		  .minval = 0,
> @@ -1045,6 +1053,7 @@ struct cli_params {
>  	int	lsunit;
>  	int	is_supported;
>  	int	proto_slashes_are_spaces;
> +	int	proto_atime;
>  	int	data_concurrency;
>  	int	log_concurrency;
>  	int	rtvol_concurrency;
> @@ -1170,6 +1179,7 @@ usage( void )
>  /* naming */		[-n size=num,version=2|ci,ftype=0|1,parent=0|1]]\n\
>  /* no-op info only */	[-N]\n\
>  /* prototype file */	[-p fname]\n\
> +/* populate from directory */	[-p dirname,atime=0|1]\n\
>  /* quiet */		[-q]\n\
>  /* realtime subvol */	[-r extsize=num,size=num,rtdev=xxx,rgcount=n,rgsize=n,\n\
>  			    concurrency=num]\n\
> @@ -2067,6 +2077,9 @@ proto_opts_parser(
>  	case P_SLASHES:
>  		cli->proto_slashes_are_spaces = getnum(value, opts, subopt);
>  		break;
> +	case P_ATIME:
> +		cli->proto_atime = getnum(value, opts, subopt);
> +		break;
>  	case P_FILE:
>  		fallthrough;
>  	default:
> @@ -5162,7 +5175,7 @@ main(
>  	int			discard = 1;
>  	int			force_overwrite = 0;
>  	int			quiet = 0;
> -	char			*protostring = NULL;
> +	struct	xfs_proto_source	protosource;
>  	int			worst_freelist = 0;
> 
>  	struct libxfs_init	xi = {
> @@ -5311,8 +5324,6 @@ main(
>  	 */
>  	cfgfile_parse(&cli);
> 
> -	protostring = setup_proto(cli.protofile);
> -
>  	/*
>  	 * Extract as much of the valid config as we can from the CLI input
>  	 * before opening the libxfs devices.
> @@ -5480,7 +5491,11 @@ main(
>  	/*
>  	 * Allocate the root inode and anything else in the proto file.
>  	 */
> -	parse_proto(mp, &cli.fsx, &protostring, cli.proto_slashes_are_spaces);
> +	protosource = setup_proto(cli.protofile);

Not sure why this is being moved in this patch?

--D

> +	parse_proto(mp, &cli.fsx,
> +			&protosource,
> +			cli.proto_slashes_are_spaces,
> +			cli.proto_atime);
> 
>  	/*
>  	 * Protect ourselves against possible stupidity
> --
> 2.49.0
> 
