Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C95F52F88
	for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 20:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745438955; cv=none; b=BbB7QY+JCa9KTnEWWs5qvAEVSE/Ct3bQ6v/9hSJ1Ovrj7i7Xk53hP5AzrgPd8BpGdKV18ojUIQA69Svf0o68noY+X/MkXioWbmOzYO2DO6Ouxy2HhAXS+AWvCx5N5aDNRlpCG7FfsziJrIcF8Gh0y9ZTx0rdMCi4aYqx2L3+L3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745438955; c=relaxed/simple;
	bh=oyALTokjd2MvPWeZqD34EqwiwAVuQZzTwfwscicfI1w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=er9QDjbZvWTytI//pofno5nOUfhCFEPU9+bVJRZtw9SXANHBYCMMuKwTWnmkkQuePbObLoSAuG/1w6ceRccpWgaRg5Kcwi8OApLSPblH5TGF7qFhv137J3YY/5qTcw+Tlgyj8Wd9ZTlGum/yF2v5sfnETNToy1vyG7UX9dorwVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gJtDRRJ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gJtDRRJ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BABA7C4CEE8;
	Wed, 23 Apr 2025 20:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745438954;
	bh=oyALTokjd2MvPWeZqD34EqwiwAVuQZzTwfwscicfI1w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gJtDRRJ3ejti3FpiaDcExq/WOMmJrIs1quewCnHUOACFu9mS+/2lhzXg+/LnUfBc3
	 KiiS/Ink9Oy1CojWr+Z5Ofik9f/YCKQ/01+QhGBUOzY3oVsIZtaCWTNqa5AA8LVgzp
	 KGFNzTHVD/YW+jrc0lIP4k9i5CRgCjtV6iwIvj7SbWBPBHok5Pekop0NctGv85kg75
	 57UN8JGKsIVB4ARzHwAxQrHxqk72QtnjT4KwBtYHS9xAtvg2DjjI3uz93qUXnTG+xC
	 slI/zlgs9j82XDnml7uo4S+8bBUB36YvYinUz7Zt3G2oPrdSQXcdLMdfyItObvjrAz
	 aIUKoin0mEIxg==
Date: Wed, 23 Apr 2025 13:09:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Luca Di Maio <luca.dimaio1@gmail.com>
Cc: linux-xfs@vger.kernel.org, dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev, hch@infradead.org
Subject: Re: [PATCH v6 3/4] mkfs: add -P flag to populate a filesystem from a
 directory
Message-ID: <20250423200914.GH25675@frogsfrogsfrogs>
References: <20250423160319.810025-1-luca.dimaio1@gmail.com>
 <20250423160319.810025-4-luca.dimaio1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250423160319.810025-4-luca.dimaio1@gmail.com>

On Wed, Apr 23, 2025 at 06:03:18PM +0200, Luca Di Maio wrote:
> Add a `-P` flag to populate a newly created filesystem from a directory.
> This flag will be mutually exclusive with the `-p` prototype flag.
> 
> Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
> ---
>  mkfs/xfs_mkfs.c | 23 ++++++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 3f4455d..57dbeba 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -14,6 +14,7 @@
>  #include "libfrog/dahashselftest.h"
>  #include "libfrog/fsproperties.h"
>  #include "proto.h"
> +#include "populate.h"
>  #include <ini.h>
> 
>  #define TERABYTES(count, blog)	((uint64_t)(count) << (40 - (blog)))
> @@ -1022,6 +1023,7 @@ struct cli_params {
> 
>  	char	*cfgfile;
>  	char	*protofile;
> +	char	*directory;
> 
>  	enum fsprop_autofsck autofsck;
> 
> @@ -1170,6 +1172,7 @@ usage( void )
>  /* naming */		[-n size=num,version=2|ci,ftype=0|1,parent=0|1]]\n\
>  /* no-op info only */	[-N]\n\
>  /* prototype file */	[-p fname]\n\
> +/* populate */		[-P directory]\n\
>  /* quiet */		[-q]\n\
>  /* realtime subvol */	[-r extsize=num,size=num,rtdev=xxx,rgcount=n,rgsize=n,\n\
>  			    concurrency=num]\n\
> @@ -5254,7 +5257,7 @@ main(
>  	memcpy(&cli.sb_feat, &dft.sb_feat, sizeof(cli.sb_feat));
>  	memcpy(&cli.fsx, &dft.fsx, sizeof(cli.fsx));
> 
> -	while ((c = getopt_long(argc, argv, "b:c:d:i:l:L:m:n:KNp:qr:s:CfV",
> +	while ((c = getopt_long(argc, argv, "b:c:d:i:l:L:P:m:n:KNp:qr:s:CfV",
>  					long_options, &option_index)) != EOF) {
>  		switch (c) {
>  		case 0:
> @@ -5280,6 +5283,9 @@ main(
>  				illegal(optarg, "L");
>  			cfg.label = optarg;
>  			break;
> +		case 'P':
> +			cli.directory = optarg;
> +			break;

Uh... why not modify setup_proto to check the mode of the opened fd, and
call populate_from_dir if it's a directory?  Then you don't need all the
extra option parsing code.  It's not as if -p <path> has ever worked on
a directory.

--D

>  		case 'N':
>  			dry_run = 1;
>  			break;
> @@ -5478,9 +5484,20 @@ main(
>  		initialise_ag_freespace(mp, agno, worst_freelist);
> 
>  	/*
> -	 * Allocate the root inode and anything else in the proto file.
> +	 * Allocate the root inode and anything else in the proto file or source
> +	 * directory.
> +	 * Both functions will allocate the root inode, so we use them mutually.
>  	 */
> -	parse_proto(mp, &cli.fsx, &protostring, cli.proto_slashes_are_spaces);
> +	if (cli.protofile && cli.directory) {
> +		fprintf(stderr,
> +			_("%s: error: specifying both -P and -p is not supported\n"),
> +			progname);
> +		exit(1);
> +	}
> +	if (!cli.directory)
> +		parse_proto(mp, &cli.fsx, &protostring, cli.proto_slashes_are_spaces);
> +	else
> +		populate_from_dir(mp, NULL, &cli.fsx, cli.directory);
> 
>  	/*
>  	 * Protect ourselves against possible stupidity
> --
> 2.49.0
> 
