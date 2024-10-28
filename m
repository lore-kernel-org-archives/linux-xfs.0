Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1431CF2A6;
	Mon, 28 Oct 2024 09:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730108468; cv=none; b=gNoEtGrfET+/r9ZUZFNmAHMLfRN5KHLhBaSv3Q29P04g62tXKR1kA1y2HQDBIbqSTDPeD9AkM7LIveIdnHSeErUGoJDyTE1UGD1aEqeAUDOo9dlmjOrZ+L+7hJ20qxxm/LySsrNCe/H7BR8g7Omy94l8B6emWX0FYJ0W04NCFuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730108468; c=relaxed/simple;
	bh=PgN3FoMV2yhqrHjwM2a0JQC60aF6IwgH9fl7sFo/184=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fzu2peekAVmNTiWwXG8LuMbmaIHwMWA3EZ+N8JGU9vBpnIcmbMQ0iVzSaKqpQBohgQPu8DP7QIdsH8QddxWUpZy+xbOzSFPONvFZA4zJmR3RVQjwSoXmmm+zmOe60V2KLBZhZNt0PNFrds49B0ck9CAOrjhxPWY0WUn+bDw9IBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0VeZYyUS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0VeZYyUS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tR/jpmNIGcMlJBzOyKoyXGyOgQ9HZQhj1sUhbEZiwoE=; b=0VeZYyUSgeAU3ujx53IQyM5gQR
	RdriJfJuX7ln+ri+wHHzWD1rx28zKU0vVGsvIPk/V3Hr1ytpPZbnkJBgJNr6XqmSZeyOXsGD0VdnP
	77ZzVvkB169E3wNYLM9xl+BA4B4M7jiHBiHPfxaK/t1Wsykb/rwv8QT8lm98vi+serKEQ129R4XwV
	6Ypni/InGGKTsuMdsox+n4WYSuB9ZfanRO1rmW7zrmjXRijXn5m1UexEp61tf20XTGPsxjltLFDTG
	cu7pMy9vmYtzISlrpsicdWvXldhfipRVFSWdgj7rdnTJjy4jZ7wn5eliUCBrW6srPgrmDB+G1maOy
	gGIqmc4A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t5MFB-0000000AGW4-0MhT;
	Mon, 28 Oct 2024 09:41:01 +0000
Date: Mon, 28 Oct 2024 02:41:01 -0700
From: Christoph Hellwig <hch@infradead.org>
To: alexjlzheng@gmail.com
Cc: cem@kernel.org, djwong@kernel.org, chandanbabu@kernel.org,
	dchinner@redhat.com, zhangjiachen.jaycee@bytedance.com,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jinliang Zheng <alexjlzheng@tencent.com>
Subject: Re: [PATCH] xfs: fix the judgment of whether the file already has
 extents
Message-ID: <Zx9cLakpnJBAV1am@infradead.org>
References: <20241026180116.10536-1-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241026180116.10536-1-alexjlzheng@tencent.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Oct 27, 2024 at 02:01:16AM +0800, alexjlzheng@gmail.com wrote:
> From: Jinliang Zheng <alexjlzheng@tencent.com>
> 
> When we call create(), lseek() and write() sequentially, offset != 0
> cannot be used as a judgment condition for whether the file already
> has extents.
> 
> This patch uses prev.br_startoff instead of offset != 0.

This changed the predicate from "are we at offset 0" to "are there
any allocations before that".  That's a pretty big semantic change.
Maybe a good one, maybe not.  Can you explain what workload it helps
you with?

