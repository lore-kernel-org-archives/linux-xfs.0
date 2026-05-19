Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2543DD532
	for <linux-xfs@vger.kernel.org>; Tue, 19 May 2026 08:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779180210; cv=none; b=Gps4G3lbLRrgdcRPgGtmUgXJ++gh9jcjetSR5DKxAHN/yOI1YOcX+bF0RJuSc2n6KlW2tIpZZ0mKx9qYiCyTBjAafkhR5eMnRUwd/RrUYL1cHf5ZaunkDI8vfN8/P23Sjxx2jGszytXcitgRCCDJnoCS03j5cz6jaT3SDJoBDo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779180210; c=relaxed/simple;
	bh=6fijCFSkMekD+/Ssbh7PKT2Ltp0na3PNashFXWID96c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LUn9mzpY5D/QDDWTlWd+vblSmyQ2Rq5PA/AK+sBca8Q0W5EiIZ9rHexgdh8YzEqD53dw8PfxZzxIzbwofAQtpkw/j7Ke0k9YyrReg8l/ULTMkpRxbZqW6DtmHe5j/zkkr4u9kxyheCS7ENAlVxQDzlwWYZZQySYXAcd2jbej/n8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fQYrIFrn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fQYrIFrn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=iIZJyQhblcWQvmg5ugRlQqKRV+S7Vv0hoLsTkPVlVzg=; b=fQYrIFrnzai3RGqkkNN5YZO44F
	u+tfQd+yAECjH9dHDYH/vFdjnNsdEKqUu8siqrb6Ei7bpP/H1qX2B96nbrrYKU1v3EiODS6WoxZrL
	LkjvZZVeabCYTaE5+7Gmwk3hZsNAUV95ELm7d4EAOoVgMSYyasGVycANQmDKwg1lkWsbZEr3h2RfW
	p3hhqBjIEFgD39PJlLJoPfBc+DfNh+CFEWpjP6YPw/nDHVy75x1MOvnfn+0Y61gwkhWi5a3O1E0+n
	I1wrijaBLjQtynMIgD7LAdCDTsw3o3CET3eRAMBQXlFMo9V0YXkrNNKeWR7BOOaGO6/g/8n9enht4
	RyUVVBuw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wPG2y-00000000id2-1uvb;
	Tue, 19 May 2026 08:43:28 +0000
Date: Tue, 19 May 2026 01:43:28 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Lukas Herbolt <lukas@herbolt.com>, sandeen@sandeen.net,
	aalbersh@kernel.org, linux-xfs@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC PATCH] mkfs: allow specification of default options via
 configuration file
Message-ID: <agwisMUPPeYa5qDM@infradead.org>
References: <20260514150653.GW9555@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514150653.GW9555@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, May 14, 2026 at 08:06:53AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Ted asked for the ability to set default mkfs options, but to retain the
> ability respecify options via a separate configuration file or cli
> options.  This would be useful for running fstests with the default
> featureset of (say) Linux 5.15 LTS, while still allowing individual
> testcases to provide their own overrides.  It's certainly less messy
> than what Ted does today, which is a bash script that copies the desired
> config file and changes things.

Looks reasonable, do you have a test for it as well?

> +static inline int
> +getopt_mkfs(

I don't think there's much of a point in the inline here.

> +	int			argc,
> +	char *const		argv[],
> +	const struct option	*longopts,
> +	int			*longindex)
> +{
> +	return getopt_long(argc, argv, "b:c:d:i:l:L:m:n:KNp:qr:s:CfV",
> +			longopts, longindex);
> +}

Why does this hardcode the short options, but requires the caller to
pass in the long options (which are the same for both callers)?

> +	while ((c = getopt_mkfs(argc, argv, long_options, &option_index)) != EOF) {

Killing the long_opts would also avoid the overly long line here and in
the other call site.

> +		if (c == 'c') {
> +			parse_subopts(c, optarg, defcfg_subopt_tab, &cli);
> +		}

Spurious braces.

