Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E9827EFEE;
	Wed, 18 Mar 2026 15:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773847217; cv=none; b=kBNcyTQZ3Hwt9yIEw//fx/02QNYhwDIoptFMcqUINBlSAFkwbrluynG2978LnJoweJv2m5w3v8x3NRTUWuHtNm+UydSzvatNvzyAVKwjnTNRnSIVfmy26VulvELLOXSd/t4lnDYuL+5xS25jmagJykox/4q0F7y3qlbuncuR2jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773847217; c=relaxed/simple;
	bh=jjOZ5Ix/C05VCaQzYTiTMYxFjIXuLb+lb6mt9KewbEM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HPXr2BdQUN9nEq1K+1Ny+N+fefIVwqHxDanz8JgC3AGepbQRshUtWr0i1jVE9Qo7uhrSaWwMpvaAF3ZzyjqwrtniMUvjY/1qbvS/1q2CUcyrVelQrj/8CM/ZNutRyRPQCuGAleOqO6XXwWVgSEAHICupyDn9Tpv6bqqIyFVKnwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yb4zyfT5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yb4zyfT5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=X2ytg4EAJWYHSjXHnrIQJRt6TcKvRbsXR8fx9K5EsRw=; b=yb4zyfT5zYnu0KCd2OrgF/aIli
	qMdM0w4DGbLVQGxv4SUXeutZhtoYMxoIBhwnDJrggqHo7j970QrMZnmUD+e2aZl9bKTbkyMmoG5jI
	S9xUYVVI/vMYw1xvWlWObAdZOxmYuRwIlJKvieb2PhlQmAWKh8SYIw/W0+4l4jYjfDyj0cqaBx8Av
	ouoMN3HWH07kmR8grouxORyhSnS6AUq7YaN7ohd56qJCYp4VAoB1xy0sCdFHyI1MvZWsqC4nh3h+y
	Bb5gA2xwRog0RtMdebqSNJu0gJrjNf1Dxvhooi59MGNE0JYN6oBivRfegRWXXAH7MMCLum8n8Us6a
	9mcgVPFQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w2sgu-00000008gwc-1POl;
	Wed, 18 Mar 2026 15:20:12 +0000
Date: Wed, 18 Mar 2026 08:20:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>, djwong@kernel.org,
	hch@infradead.org, cem@kernel.org, david@fromorbit.com,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
	ritesh.list@gmail.com, ojaswin@linux.ibm.com,
	hsiangkao@linux.alibaba.com
Subject: Re: [RFC v1 0/4] xfs: Add support to shrink multiple empty rtgroups
Message-ID: <abrCrFogLZ_MWTIb@infradead.org>
References: <20260219055737.769860-1-nirjhar@linux.ibm.com>
 <cover.1771418537.git.nirjhar.roy.lists@gmail.com>
 <0e20766d-5855-4514-a6bd-49e32261c162@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0e20766d-5855-4514-a6bd-49e32261c162@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Mar 18, 2026 at 08:13:28PM +0530, Nirjhar Roy (IBM) wrote:
> I am preparing a v2 incorporating all the initial review feedback received
> so far. In parallel, I am looking into adding shrinkfs support for zoned
> XFS  -  however, it would be great if we can discuss the current design and
> get a full review of the changes so far to get this work (shrinkfs for
> non-zoned realtime groups) into proper shape for the upcoming merge window
> first and submit zoned XFS shrinkfs support separately afterward. Do you
> think that make sense?

What is your plan for actually migrating data out of the to be shrunk
region, which is really the deal breaker to make this useful.  Outside
of that zone support should be really trivial as it just means doing a
little less work.

