Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BDFC279910
	for <linux-xfs@vger.kernel.org>; Mon, 28 Apr 2025 17:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745861036; cv=none; b=mo8tly5jr0wy5lcCrHPmQDEwJon4Wi3gS4rJNSaH+f15Xk5qjWbUxxOUSwFdC/cyuxO51ej6Gky3Gz1atb+v+EIDaK43kQY+CY0kxjae4i4CQ4mIoFXpBsvx1OdFXn7fAb011MQXzRGA5KQtO99ZiywK5l4wL15HSeBiEfN97F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745861036; c=relaxed/simple;
	bh=Veti/m2Kb4dYZNcIN8ztw29PqtguCIBWNiCTYENN3pw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fo+3nqe6TUClSv0EzUEMSF7FZ1u8YfrNOZA7ai1hpMem5pX22LpC+PbIZHrnrUYnwDjA6oU2fvy6SV+A02EVYxnXIr9CubriP/Notf7ivA1rcUMA9C3FEdfaa3IPTUc1Na25t9XwZGXYrXaUn87yR1TQtXZ6yVsDrK60JFHmL+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hrOS9X38; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hrOS9X38"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB631C4CEE4;
	Mon, 28 Apr 2025 17:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745861035;
	bh=Veti/m2Kb4dYZNcIN8ztw29PqtguCIBWNiCTYENN3pw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hrOS9X38lV0WCfSHcFG4wOkY9GrMHsR1xjhhygIzhUESOhgO6NGoCJxOMCJW9yXYT
	 CzW84ntRQ/KoYYMlXr3yji71RhjJCVba774B7j/XvS60XunLLydIa8TR37KuGh2eCw
	 RoPPMpVu0hthf8FRXPqmVe8t+3kHsy/LJ89jxpINKEJ6w6LHhAcmhGj5Z3HTWZPLdL
	 XeVvpV1gFH7x3+SijaI1ydkuhqtOQNXMuInAJtzU1p7Gx7XJbz8nkgRaOzUcY1sqRF
	 KFvqymGpHqa8MQOOihwQRjQAM34HG7Xwtuh3gSoQ+YG1jN5NJTU/VahDn8AHEe+WNb
	 ZQnmzBa/WvoYA==
Date: Mon, 28 Apr 2025 10:23:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Luca Di Maio <luca.dimaio1@gmail.com>
Cc: linux-xfs@vger.kernel.org, dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev, hch@infradead.org
Subject: Re: [PATCH v7 2/2] mkfs: modify -p flag to populate a filesystem
 from a directory
Message-ID: <20250428172355.GT25675@frogsfrogsfrogs>
References: <20250426135535.1904972-1-luca.dimaio1@gmail.com>
 <20250426135535.1904972-3-luca.dimaio1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250426135535.1904972-3-luca.dimaio1@gmail.com>

On Sat, Apr 26, 2025 at 03:55:35PM +0200, Luca Di Maio wrote:
> right now the `-p` flag only supports a file input.
> this patch will add support to input a directory.
> on directory input, the populate functionality to copy files into
> the root filesystem.
> 
> add `noatime` flag to popts, that will let the user choose if copy the
> atime timestamps from source directory.
> 
> add documentation for new functionalities in man pages.
> 
> Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
> ---
>  man/man8/mkfs.xfs.8.in | 41 +++++++++++++++++++++++++++++------------
>  mkfs/xfs_mkfs.c        | 19 +++++++++++++++++--
>  2 files changed, 46 insertions(+), 14 deletions(-)
> 
> diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
> index 37e3a88e..f06a3c9c 100644
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
> +Content, timestamps, attributes and extended attributes are preserved

I thought this only preserved the atime and mtime timestamps?

> +for all file types.
> +.TP
> +.BI [file=] protofile
> +If the optional
> +.PD
> +.I prototype
> +argument is given, and it's a file,

"If the optional prototype argument is given and points to a regular
file..."

(I think, technically speaking, you store a protofile on a block device
and pass that in, but let's not encourage that kind of absurdity)

> +.B mkfs.xfs
> +uses it as a prototype file and takes its directions from that file.
>  The blocks and inodes specifiers in the
>  .I protofile
>  are provided for backwards compatibility, but are otherwise unused.
> @@ -1136,8 +1145,16 @@ always terminated with the dollar (
>  .B $
>  ) token.
>  .TP
> +.BI noatime= value
> +If set to 1, when we're populating the root filesystem from a directory (
> +.B file=directory
> +option)
> +access times are NOT preserved and are set to the current time instead.
> +Set to 0 to preserve access times from source files.

I would say "Set to 0 to copy access timestamps from source files".

Though if the default is going to be "do not copy atime from sourcev
file" then the option to enable copying of atime ought to be named
"atime".

> +By default, this is set to 1.
> +.TP
>  .BI slashes_are_spaces= value
> -If set to 1, slashes ("/") in the first token of each line of the protofile
> +If set to 1, slashes ("/") in the first token of each line of the prototype file
>  are converted to spaces.
>  This enables the creation of a filesystem containing filenames with spaces.
>  By default, this is set to 0.
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 3f4455d4..1715e3fb 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -121,6 +121,7 @@ enum {
> 
>  enum {
>  	P_FILE = 0,
> +	P_NOATIME,
>  	P_SLASHES,
>  	P_MAX_OPTS,
>  };
> @@ -709,6 +710,7 @@ static struct opt_params popts = {
>  	.ini_section = "proto",
>  	.subopts = {
>  		[P_FILE] = "file",
> +		[P_NOATIME] = "noatime",
>  		[P_SLASHES] = "slashes_are_spaces",
>  		[P_MAX_OPTS] = NULL,
>  	},
> @@ -717,6 +719,12 @@ static struct opt_params popts = {
>  		  .conflicts = { { NULL, LAST_CONFLICT } },
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
> +		{ .index = P_NOATIME,
> +		  .conflicts = { { NULL, LAST_CONFLICT } },
> +		  .minval = 0,
> +		  .maxval = 1,
> +		  .defaultval = 1,
> +		},
>  		{ .index = P_SLASHES,
>  		  .conflicts = { { NULL, LAST_CONFLICT } },
>  		  .minval = 0,
> @@ -1022,7 +1030,6 @@ struct cli_params {
> 
>  	char	*cfgfile;
>  	char	*protofile;
> -

Extraneous change?

>  	enum fsprop_autofsck autofsck;
> 
>  	/* parameters that depend on sector/block size being validated. */
> @@ -1045,6 +1052,7 @@ struct cli_params {
>  	int	lsunit;
>  	int	is_supported;
>  	int	proto_slashes_are_spaces;
> +	int	proto_noatime;
>  	int	data_concurrency;
>  	int	log_concurrency;
>  	int	rtvol_concurrency;
> @@ -1170,6 +1178,7 @@ usage( void )
>  /* naming */		[-n size=num,version=2|ci,ftype=0|1,parent=0|1]]\n\
>  /* no-op info only */	[-N]\n\
>  /* prototype file */	[-p fname]\n\
> +/* populate from directory */	[-p dirname]\n\

/* populate from directory */		[-p dirname,noatime=0|1]

--D

>  /* quiet */		[-q]\n\
>  /* realtime subvol */	[-r extsize=num,size=num,rtdev=xxx,rgcount=n,rgsize=n,\n\
>  			    concurrency=num]\n\
> @@ -2067,6 +2076,9 @@ proto_opts_parser(
>  	case P_SLASHES:
>  		cli->proto_slashes_are_spaces = getnum(value, opts, subopt);
>  		break;
> +	case P_NOATIME:
> +		cli->proto_noatime = getnum(value, opts, subopt);
> +		break;
>  	case P_FILE:
>  		fallthrough;
>  	default:
> @@ -5181,6 +5193,7 @@ main(
>  		.log_concurrency = -1, /* auto detect non-mechanical ddev */
>  		.rtvol_concurrency = -1, /* auto detect non-mechanical rtdev */
>  		.autofsck = FSPROP_AUTOFSCK_UNSET,
> +		.proto_noatime = 1,
>  	};
>  	struct mkfs_params	cfg = {};
> 
> @@ -5480,7 +5493,9 @@ main(
>  	/*
>  	 * Allocate the root inode and anything else in the proto file.
>  	 */
> -	parse_proto(mp, &cli.fsx, &protostring, cli.proto_slashes_are_spaces);
> +	parse_proto(mp, &cli.fsx, &protostring,
> +			cli.proto_slashes_are_spaces,
> +			cli.proto_noatime);
> 
>  	/*
>  	 * Protect ourselves against possible stupidity
> --
> 2.49.0
> 
