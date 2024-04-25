Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B9B1BF40
	for <linux-xfs@vger.kernel.org>; Thu, 25 Apr 2024 12:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714047516; cv=none; b=utyr9aPcm8L28XnKKAN5utGnAhJqnEiabrSxibL9PCgt8TjlxTcQVGAQTaoKwoArLaV2lezl55HBR7gC8jC6qGfXIF0TwXNxHUHTRJK8f1vn+FJQQ85uzM4ipldTC2ByGico3vVPh3sDLraAXyhbm1qX6ifDfK04lCnTTPn9wvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714047516; c=relaxed/simple;
	bh=cvg2u/V2pPfdHsDSQQJK8Wvbd9QnS57Vi97QZwX0KD8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hGSaa3EEWmmGfGbBamCUAmLk18VL9ekRE4sOt1qfWs/Dubbw1BM6Iunl/HX1difxjY/QZV8aiZECg25gocaXDtT5vXB1y94EcN5TI4aMaQIo5ttuFbEV6E0Krsz/Sk3vPBdF78U4dlaa0pgPD8heeecsLQAR9sB0q4G7Y80Uo7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rl4D7qKj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rl4D7qKj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=cvg2u/V2pPfdHsDSQQJK8Wvbd9QnS57Vi97QZwX0KD8=; b=rl4D7qKjuBe5pcQUsn0u1W3ywt
	RdsH2zc8UZkzRR37F+5L+ju3BnKUFgnQDCpSp/k4ZF32pw9li+xlBzwpuHQHiYTsa6hRgSEL209XP
	d++ePof7QkhOoX5IvcTtnfXvC4HBl0iGpqnclF/UszOIbxJdVR0DjyYMCDK1G0Q6A8DPuOLDGTzVO
	oE/7Ipvs1vIkmTWtlgDKinnvT8qwPLE6jeS8u/t3zNuKgVavC6xblmW2yJ1Y63w3+plheLfUNlr+j
	HcDhHSqPBuHDoNqi1qqOzTB+bECzo0on79tAcvu5o7vDwPO/oa32K9NAnpB9jfty6TP7V+Tzj6ynY
	c+1adEUw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rzy3e-00000008BSp-3ZUJ;
	Thu, 25 Apr 2024 12:18:34 +0000
Date: Thu, 25 Apr 2024 05:18:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>
Subject: Re: [PATCHv2 1/1] xfs: Add cond_resched in xfs_bunmapi_range loop
Message-ID: <ZipKGsb0X9yoJ-hQ@infradead.org>
References: <cover.1714033516.git.ritesh.list@gmail.com>
 <f7d3db235a2c7e16681a323a99bb0ce50a92296a.1714033516.git.ritesh.list@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7d3db235a2c7e16681a323a99bb0ce50a92296a.1714033516.git.ritesh.list@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

(and I can't wait for the day that preempt models are consolidated and
cond_resched() is gone..)

