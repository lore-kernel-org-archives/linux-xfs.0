Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5E13B0AED;
	Wed,  2 Sep 2026 07:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788334179; cv=none; b=UJUn2N8e3SrSNlfhaj76PP4N1D6SlE4wiCk3JJ/3DMoM/c8u5dhC+/ZUlBqp5ggqJAPPc/+9JHLgNZKkewAu7iwt13OUsMisEsG7jtuZZOz0BaMYRt7k0ri7HyOWeOFZB79mKhQW/Gn4000FYJO9dRYJlT2fwiZ5PGIJvFBt9Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788334179; c=relaxed/simple;
	bh=ZgHxAnbPfBxIe8ealqIlfLPNcF6MmNY7I1Lhps1qnGw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i5RT/vGprDuPhPnb6SmorNCNw0AwOFyF2lV72J/HkwHs+VbPmsIvQ56bgkpb5ZAr7imWYPMP1nEJrRyMp6YifNak9WDriiiJhviRkOOz7+8v3qai+xp+V+3pjc7PjLWKPsaUbeZFC5CYlSYTiGPWv457k2oKrwGtmeu0LOIHOio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0BDA468B05; Wed,  2 Sep 2026 09:29:34 +0200 (CEST)
Date: Wed, 2 Sep 2026 09:29:33 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zorro Lang <zlang@kernel.org>, fstests <fstests@vger.kernel.org>,
	xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: basic functional testing of media verification
 command
Message-ID: <20260902072933.GA26979@lst.de>
References: <20260826183105.GX839663@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826183105.GX839663@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

> diff --git a/common/xfs b/common/xfs
> index 81add2086866c8..8dec3475579e40 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -1786,6 +1786,9 @@ _xfs_filter_mkfs()
>  	}
>  	if (/^\s+=\s+rgcount=(\d+)\s+rgsize=(\d+) extents/) {
>  		print STDERR "rgcount=$1\nrgextents=$2\n";
> +	}
> +	if (/^\s+=\s+zoned=(\d+)\s+start=(\d+) reserved=(\d+)/) {
> +		print STDERR "zoned=$1\nrtstart=$2\nrtreserved=$3\n";
>  	}'

How is this related?  Maybe split it out into a well-doumented patch?

Also does the ' after the } break the usage?

> +
> +# Make the data and rt volumes small enough that this won't take forever
> +# on large slow devices.
> +_scratch_mkfs_sized $((600 * 1024 * 1024)) | _filter_mkfs 2>$tmp.mkfs >> $seqres.full

Split the overly long line?

Otherwise this looks good to me.
