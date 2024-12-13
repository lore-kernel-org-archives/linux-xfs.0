Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C272015383B
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 06:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734071425; cv=none; b=EjwAKwfzRrb0RByHCp/Zke4BIAj6oPUy29YTX1ytRT4uhRnBLKBVhOuBVcCGW64k6kWEQgci0otLCXikivbWEPC7zSqyDOQ3nvxbpk++I49Dp6QomG5tfUXbO0gzmR8CsHFFQ9B9weXy0GSFeMbhrkbT7KmdomHxX5AKAHAZRF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734071425; c=relaxed/simple;
	bh=P5/uuUHVv3Lir02pSTiu5s2+ttmkZSD5kdtaJJcUIWc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g/NX5N3XWyjFS9lE8H7ubLDgCoM4QFWFW+Lz2PLXG+6k1sid4/i4lP4bk4CefGYD/KsCB4/hGwhRVakFczwwFYapraQGPTUQ3aRyUzBuQB5qmr4mQ1fN5lXs/iKx/9KWSqceUorXgC8A5ULQtZKs/8Nm3+h+7qgMvIIK51LnJvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tMMDBbRr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tMMDBbRr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=KDdku/piOptVaG9qgBUnF1qVwOA3eBGt2Q7EOBSmXTo=; b=tMMDBbRrDopiD/mi+F7V5fwaM4
	4bF00VDG5/mecUtvBivtengHOvm1AJHGHfQYw+ETQDMosZoH6Zkk1AWUWxaGVHe8mmn0U7U2rS4pA
	luCiYntfHEZyoT701yo0SsnuUi7Soaxf1jvQtAOZZkV1LaNYlA6a+y7Rp5XH3EjKUHUFEXfp67SV3
	ZjTyZ7HNqXUYxqegK80xCRaL7OdUo5RLXqEfk8R8HnddVTnOWAzPvyn/5Glu8k8EkhIRtjzLAxhYJ
	N7FVTxMAoPcH4JjJAb3RW8zvYiL5al05pY3A8guj66DJDM0Y0pgUUMD6uBFNZ3K9JKy/bTnz9GEAE
	E2QYozHw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLzBv-00000002s4F-1EX0;
	Fri, 13 Dec 2024 06:30:23 +0000
Date: Thu, 12 Dec 2024 22:30:23 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/37] xfs: pretty print metadata file types in error
 messages
Message-ID: <Z1vUf5fuyMJk346p@infradead.org>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
 <173405123485.1181370.4679130203707005497.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <173405123485.1181370.4679130203707005497.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Dec 12, 2024 at 05:03:11PM -0800, Darrick J. Wong wrote:
> +static inline const char *
> +xfs_metafile_type_str(enum xfs_metafile_type metatype)
> +{
> +	static const struct {
> +		enum xfs_metafile_type	mtype;
> +		const char		*name;
> +	} strings[] = { XFS_METAFILE_TYPE_STR };
> +	unsigned int	i;
> +
> +	for (i = 0; i < ARRAY_SIZE(strings); i++) {
> +		if (strings[i].mtype == metatype)
> +			return strings[i].name;
> +	}
> +
> +	return NULL;
> +}

Having this as an inline helpers means not just the code, but also
the string array is duplicated in every caller.  While there are only
two with your entire series that's still a lіttle suboptimal.  Maybe
move it out of line to xfs_metafile.c?

And make the array file scope to be a little more readable.
