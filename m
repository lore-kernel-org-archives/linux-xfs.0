Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A50423DE
	for <linux-xfs@vger.kernel.org>; Thu,  8 May 2025 04:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746677745; cv=none; b=OT60oZWkkqtsgG0RIaJqdGR0wwuim1WYYp+AzxNaoR7yjMsSA+k9udC3TYwGgaT5sNI14LlHgzi28TLVed+BDKSbELp7mIi31paQtdRI2RQtmOpSdl4psNkbgqYthLQ5JENDtewkhOUAEpsVXHzmGBOtL38oXwDMYubcUcolCtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746677745; c=relaxed/simple;
	bh=PNXOgoGyoK6BpBNvz6FDQXJV6DBNUdefjQx/ZxZa37Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u9HqhU3J2UtfUz5Mf+rc/BPpKln+5FBdeU1sMjnUQPjhzZGMz0JoXpAyeIx2a2ySLjHJ4cGO3JySjhP59MuhHr4o4y6IRS57YPWdwjn7VdElYRaAtguNyW3J2xdz1GLemStPRFV9Kk5Sy8JZmAiM5yJkWnSYEiaKut9G77xQ6As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=U9ulxSN5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="U9ulxSN5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=PNXOgoGyoK6BpBNvz6FDQXJV6DBNUdefjQx/ZxZa37Q=; b=U9ulxSN5p+fsSXhkFunjl9e6rU
	IN2PTmeIOID/p9RYUAhZirZNhp3zISTuiN/InLnb0h+FTc/lsyMNkha4wMME6v8TrQbGA1jGWD7T3
	NCEqBZOYZtxefwPEICM6vZ/UcPYX0vFVlSeJyeILi2iB4GxdDag6lPa1Q3YRfp4F5X4cF+UHguSaF
	mtO+zLHM/+bp6ckua3dosoUHjStNkjQJZbxyhl2fXpm+DY2NQeBCHT6jbUPThxHF2ceZZ6BJFzQ/T
	fjP/o2DVHJ0zZthXdHosKtqiMeF6aT8J8eb+Ok0Uq1XdXnQDrkxm6UGBMVLhNEgl9XpxYUk6/3m1y
	06DQ91Lg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uCsfc-0000000HGxg-1MVg;
	Thu, 08 May 2025 04:15:40 +0000
Date: Wed, 7 May 2025 21:15:40 -0700
From: Christoph Hellwig <hch@infradead.org>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Fix comment on xfs_ail_delete
Message-ID: <aBwv7BRl41AsM0ji@infradead.org>
References: <20250507095239.477105-1-cem@kernel.org>
 <20250507095239.477105-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250507095239.477105-2-cem@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The sibject line should be something like:

xfs: fix comment on xfs_ail_delete

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
