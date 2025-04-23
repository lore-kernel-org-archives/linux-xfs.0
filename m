Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56DA121FF4F
	for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 08:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745398417; cv=none; b=fpJKSAPvzNKRiZCCkbIStxihMWsvmwKkizUGz9eRnL42TNBLHzn1a5phlwNdSCbYlxklKKC+mSJdFPTej7EQ39PSrtaBbYEWcH8X3cZTZ6Mv2YZBSYtnNf4usDYt7nDLk25zOwXoOuUZDLg7iVgsBz6uupJL5vTXtSslsjqTh7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745398417; c=relaxed/simple;
	bh=joiS6hgmpXC8vS2aB+wOQQ/Q7LeErOkEEetmXRZ41rU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bz9oghfppCQIcRLPNlOyHEXz+GoSY8ax7m9E7IYT6VAf+WjseEHN4oM7+9RVkl2zgAB3/kc+pI3dbLchOVoQ7p/R0eFOJDD6R0ovO19TXCy8QXXev1EEHbBiZ6Yj6DeXXpZaQZbfEOGLmw6iEOEotN9O/lp2vk1FqRegxlEFqFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yg5DfFyS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yg5DfFyS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=IRvy2TS96Lk6u/OP7FgD/qyGIZh0AIRiyjk3WSGGv4Q=; b=yg5DfFySbalqq+sOtPApFIND5T
	h3gLRcGfNfLnqrrS+Xldm0xG8anqZEQmXiu4GeBUNbXazOdI5LXqNi3Td6faf5bWbXcY9CCCH6NSZ
	BWmWfZtvIdH1pxaByNx39/8U47A6Tf7ExN6YrpgwIuJDCC0kXbaJyeKZa53QqP6lOr8uP7In4BLz2
	frOatMb7/yyel8zQrmCwCGRN2Er5cku5xht1f0Knh3G4h0ZDBDLJTc0vFmnTspEUoXBiMbtjAi0gY
	xrBdPYM1e0rBYZBklHOUXRLXb8Nm8Dne3/ZUk1JKXfJ1TZdohn2aLXjeocp+qq99p5x4o4GO6a2Pc
	/Z0r+QQg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u7VrL-00000009pgy-2mqB;
	Wed, 23 Apr 2025 08:53:35 +0000
Date: Wed, 23 Apr 2025 01:53:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Luca Di Maio <luca.dimaio1@gmail.com>
Cc: linux-xfs@vger.kernel.org, dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev, djwong@kernel.org
Subject: Re: [PATCH v4 2/4] mkfs: add -P flag to populate a filesystem from a
 directory
Message-ID: <aAiqj5p1nhwqDc-x@infradead.org>
References: <20250423082246.572483-1-luca.dimaio1@gmail.com>
 <20250423082246.572483-3-luca.dimaio1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250423082246.572483-3-luca.dimaio1@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Apr 23, 2025 at 10:22:44AM +0200, Luca Di Maio wrote:
>  					long_options, &option_index)) != EOF) {
>  		switch (c) {
>  		case 0:
> @@ -5136,6 +5138,11 @@ main(
>  				illegal(optarg, "L");
>  			cfg.label = optarg;
>  			break;
> +		case 'P':
> +			if (strlen(optarg) > sizeof(sbp->sb_fname))

This check looks weird.  sb_fname is a 12-byte legacy file system name
in the superblock that is rarely used and looks unrelated to this new
feature.

> +	if (cli.protofile && cli.directory) {
> +		fprintf(stderr, "%s: error: specifying both -P and -p is not supported.\n", progname);
> +		exit(1);

The usual XFS style is to keep very long log message on a line od their
own.  Also this needs to use the _() macro so that the string is
included in the localization database:

		fprintf(stderr,
	_("%s: error: specifying both -P and -p is not supported.\n"),
			progname);

> +	if (!cli.directory)
> +		parse_proto(mp, &cli.fsx, &protostring, cli.proto_slashes_are_spaces);
> +	else
> +		populate_from_dir(mp, NULL, &cli.fsx, cli.directory);

Please keep the line length to 80 characters in the source code.

populate_from_dir is not added in this patch, did you forget to add
newly added source files to the git repository?  If so they are also
missing from the makefile.
