Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B5E358373
	for <linux-xfs@vger.kernel.org>; Thu, 30 Jul 2026 15:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426594; cv=none; b=LgnQW24KRFGqkKvJ/delRGVIZEuZ+PAKURSU/kHzmmnHsXa/hnI7iHVNXsI3BzEBf2ktgoxzT4MhVccebg8kHCirrCNzzY2TwN4w4xTYh8dPCbA5iSaIyKuZ+8PoRgGH2DNS6ZUbcFz3NKsMNvpNbY8t01FblSBrPgKCBF45iPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426594; c=relaxed/simple;
	bh=7tyzPyi0S4BU5K4T6Ih9kW4NbfpKc2HMbCQbFIJPx5g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WCdn03JPR7A4KbjI8Oz4NmN7CmcoqRi8pjJnwM5WKM14GkF55g53PTvP3yiwd6TeyZcLWbhtM37gaUNd6+fwxJjv2ZyJnGclZ8GSKPAfQQCMe9+3zcU5ExMEduLU9TXtKlWYCiWLYYPJVtottEGGYQUtDBVyXSM0JmlCamt7gOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g5SzH9Km; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g5SzH9Km"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A431A1F00A3A;
	Thu, 30 Jul 2026 15:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785426592;
	bh=U7aZLueU/MWQDaNN9SKtzjQIGFX70G9/LHdhJT+aOI0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=g5SzH9Kmw7OfcVdlP72qe+uys71evoQVDlBgBy8FmIowI0kkZMASvKPaiWvScn5jA
	 hFvjD0wUYS7VO25a4iwKPhFIzWtAh35iWPYPdToie7pah7gHiijV4ASCXBaBQi6Vs4
	 aozxF6m39zn9S3obKfhhib5gm5DH7x252OHXRiAjvjL7S0hZPW0zlqEya4gT3ebb3E
	 q0CvOqCgYcb14ZvsqAopmCRglbWwqdSDzxoRsoJY0qqbdw774We3WBwvwJ0TsqVBEs
	 eIvg1U4uy7IF4X42IUkMX8gB+3epyRdcc3mbpedck+FNbBbiXiwnsiRQa0w/60RR0F
	 /SJtIlxGLuNqg==
Date: Thu, 30 Jul 2026 08:49:52 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] growfs: support unit postfixes when specifying sizes
Message-ID: <20260730154952.GD3556460@frogsfrogsfrogs>
References: <20260730122841.2591200-1-hch@lst.de>
 <20260730122841.2591200-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730122841.2591200-2-hch@lst.de>

On Thu, Jul 30, 2026 at 02:28:15PM +0200, Christoph Hellwig wrote:
> Try using cvtnum to parse the sizes for the -D, -L and -R arguments,
> and only fall back to plain integer parsing and interpreting it as
> blocks when that fails.  This matches the mkfs UI and makes specifying
> a size significantly easier.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  growfs/xfs_growfs.c   | 30 +++++++++++++++++++++++++++---
>  man/man8/xfs_growfs.8 | 39 +++++++++++++++++++++++++++++++--------
>  2 files changed, 58 insertions(+), 11 deletions(-)
> 
> diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
> index 0d0b2ae3e739..6e65f037c5cb 100644
> --- a/growfs/xfs_growfs.c
> +++ b/growfs/xfs_growfs.c
> @@ -5,6 +5,7 @@
>   */
>  
>  #include "libxfs.h"
> +#include "libfrog/convert.h"
>  #include "libfrog/paths.h"
>  #include "libfrog/fsgeom.h"
>  
> @@ -31,6 +32,19 @@ Options:\n\
>  	exit(2);
>  }
>  
> +static long long
> +parse_size(
> +	struct xfs_fsop_geom	*geo,
> +	const char		*size_str)
> +{
> +	long long		size;
> +
> +	size = cvtnum(geo->blocksize, geo->sectsize, size_str);
> +	if (size == -1)
> +		return strtoll(size_str, NULL, 10);
> +	return size / geo->blocksize;

Hmmm.  Previously, "-D 12345" meant "grow to 12345 fsblocks", right?
However, cvtnum(, "12345") returns 12345, which is now divided by the
fsblock size and we'll "grow" the filesystem to 3x 4k fsblocks.  So I
don't think this quite works, though the ability to specify "-D 12345M"
is very appealing.

--D

> +}
> +
>  int
>  main(int argc, char **argv)
>  {
> @@ -55,6 +69,9 @@ main(int argc, char **argv)
>  	struct xfs_fsop_geom	ngeo;	/* new fs geometry */
>  	int			rflag;	/* -r flag */
>  	long long		rsize;	/* new rt size in fs blocks */
> +	const char		*dsize_str = NULL;
> +	const char		*lsize_str = NULL;
> +	const char		*rsize_str = NULL;
>  	int			xflag;	/* -x flag */
>  	char			*fname;	/* mount point name */
>  	char			*datadev; /* data device name */
> @@ -77,7 +94,7 @@ main(int argc, char **argv)
>  	while ((c = getopt(argc, argv, "dD:e:ilL:m:np:rR:t:xV")) != EOF) {
>  		switch (c) {
>  		case 'D':
> -			dsize = strtoll(optarg, NULL, 10);
> +			dsize_str = strdup(optarg);
>  			fallthrough;
>  		case 'd':
>  			dflag = 1;
> @@ -90,7 +107,7 @@ main(int argc, char **argv)
>  			lflag = iflag = 1;
>  			break;
>  		case 'L':
> -			lsize = strtoll(optarg, NULL, 10);
> +			lsize_str = strdup(optarg);
>  			fallthrough;
>  		case 'l':
>  			lflag = 1;
> @@ -106,7 +123,7 @@ main(int argc, char **argv)
>  			progname = optarg;
>  			break;
>  		case 'R':
> -			rsize = strtoll(optarg, NULL, 10);
> +			rsize_str = strdup(optarg);
>  			fallthrough;
>  		case 'r':
>  			rflag = 1;
> @@ -211,6 +228,13 @@ main(int argc, char **argv)
>  
>  	xfs_report_geom(&geo, datadev, logdev, rtdev);
>  
> +	if (dsize_str)
> +		dsize = parse_size(&geo, dsize_str);
> +	if (lsize_str)
> +		lsize = parse_size(&geo, lsize_str);
> +	if (rsize_str)
> +		rsize = parse_size(&geo, rsize_str);
> +
>  	if (geo.rtstart) {
>  		xfs_daddr_t rtstart = geo.rtstart * (geo.blocksize / BBSIZE);
>  
> diff --git a/man/man8/xfs_growfs.8 b/man/man8/xfs_growfs.8
> index 2e329fa61758..d6e5fe13e943 100644
> --- a/man/man8/xfs_growfs.8
> +++ b/man/man8/xfs_growfs.8
> @@ -57,6 +57,32 @@ The filesystem must be mounted to be grown (see
>  .BR mount (8)).
>  The existing contents of the filesystem are undisturbed, and the added space
>  becomes available for additional file storage.
> +The following lists possible multiplication suffixes for any argument specifying
> +sizes.
> +.RS
> +.PD 0
> +.HP
> +.BR s "\ \-\ multiply by sector size (default = 512, see " \-s
> +option below).
> +.HP
> +.BR b "\ \-\ multiply by filesystem block size (default = 4K, see " \-b
> +option below).
> +.HP
> +.BR k "\ \-\ multiply by one kilobyte (1,024 bytes)."
> +.HP
> +.BR m "\ \-\ multiply by one megabyte (1,048,576 bytes)."
> +.HP
> +.BR g "\ \-\ multiply by one gigabyte (1,073,741,824 bytes)."
> +.HP
> +.BR t "\ \-\ multiply by one terabyte (1,099,511,627,776 bytes)."
> +.HP
> +.BR p "\ \-\ multiply by one petabyte (1,024 terabytes)."
> +.HP
> +.BR e "\ \-\ multiply by one exabyte (1,048,576 terabytes)."
> +.PD
> +.RE
> +If no suffix is specified, the sizes are in file system blocks.
> +.RE
>  .SH OPTIONS
>  .TP
>  .BI "\-d | \-D " size
> @@ -67,9 +93,8 @@ option is given, the data section is changed to that
>  .IR size ,
>  otherwise the data section is grown to the largest size possible with the
>  .B \-d
> -option. The size is expressed in filesystem blocks. A filesystem with only
> -1 AG cannot be shrunk further, and a filesystem cannot be shrunk to the point
> -where it would only have 1 AG.
> +option. A filesystem with only 1 AG cannot be shrunk further, and a
> +filesystem cannot be shrunk to the point where it would only have 1 AG.
>  .B [NOTE: Only shrinking the last AG without removing it is implemented]
>  .TP
>  .B \-e
> @@ -90,8 +115,7 @@ shrunk, or moved. If the
>  .I size
>  option is given, the log section is changed to be that
>  .IR size ,
> -if possible. The size is expressed in filesystem blocks.
> -The size of an internal log must be smaller than the size
> +if possible. The size of an internal log must be smaller than the size
>  of an allocation group (this value is printed at
>  .BR mkfs (8)
>  time). If neither
> @@ -124,9 +148,8 @@ Specifies that the real-time section of the filesystem should be grown. If the
>  option is given, the real-time section is grown to that size, otherwise
>  the real-time section is grown to the largest size possible with the
>  .B \-r
> -option. The size is expressed in filesystem blocks.
> -The filesystem does not need to have contained a real-time section before
> -the
> +option. The filesystem does not need to have contained a real-time section
> +before the
>  .B xfs_growfs
>  operation.
>  .TP
> -- 
> 2.53.0
> 
> 
