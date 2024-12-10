Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C070224CC
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733807033; cv=none; b=rMYIkcRDibBLgP4uO3JW8k7JOsaOP76vK4KB9aeYN0zyavS24NigyqAziiMImwEZ/smkou++FA5f6IIbI7yV0vhfDsVgdexOLQ59dQ09SETUV63azWbX+nh23NdS5ZksJD2scKJYXuAT4R/XegZMyAgcFfxx7+HbfJqiHxM0/Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733807033; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FGuP87j4B14wRw5KyaEiY8FU3br2RyqQGPtrUO6kWlEURsRcSF05c96ExjaTz3Dm0Y0W76A52JxydMkXTQ7T2LhHgWGtGJlddlOS7VUTxzgzmgCpfNEnL/sads9DnHI871fKPEDrX/QBfQwgPvOppgtPVJX8uNW1KEj1YQelI5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KUxRoA7c; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KUxRoA7c"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=KUxRoA7ctOv2ViXqoN/PJJo7M+
	gQbqGR191I8QfAOKLeIF+hadWiP/DDhnmiyc2bzPk5UXLFGPHmRpqnZEIRLTIIGidHPTQQqDo3THP
	jKdfi/pQ0TerXQ7wg2tnRPUhxAl8tu1qPJFOOvfpcGbCgaIzTm4dUaITe/eZGS+VhulsiwkTtMvwx
	oXR4rgvZSjncGEDE/kbRkeMXDXuze0WnE8tYXbQz2BUYMDFzxRgYozHex2bGpIiooInQ2/IpRbzso
	7VrBGENT7iulzPHqfS47FeowsopIbjzgflQK7elLIK3Fit0zUKHio++GCrqxJcAedqdvf/NNOEV24
	Cg8lxCjA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsPX-0000000AF9g-42LL;
	Tue, 10 Dec 2024 05:03:51 +0000
Date: Mon, 9 Dec 2024 21:03:51 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/41] xfs_scrub: re-run metafile scrubbers during phase 5
Message-ID: <Z1fLt-UmnEFKursx@infradead.org>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748543.122992.11036013424624729322.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352748543.122992.11036013424624729322.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

