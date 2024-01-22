Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDFEFBE1
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2024 07:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705908347; cv=none; b=lL8Coo0Y1ThLr273gGtoGcnizsw2gb0YNl+7BYTJv2CEl34fbLw3L7dZZWJqTFfnQJXsTwDRZFvo4LAjn3lRGYPoZljeAobDDZkCsGjoUSey+g9yq54qovMroopukoT4XVTRdyyZQJEyhfqJcmVqMxHqAVGdf39InJlXbQA13ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705908347; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BymqQ/VIOEVpL/0cvMGmE3swQZwiMX+nUkWZJmdIo/HSfyaLZekbIPZNZOPd1MtjE9FAgk1vcZSpTDGAiLdC4DmtpAtG/yL/zAM1A9/AWifXjCd/GM9f5NVeLil5IEz25WE7Wkx1DsfoI9x+O11T+VXJFUFbFdN/cv1StRzL+RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ISghxbc7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ISghxbc7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ISghxbc7gRE9aero21HRHUBa01
	LPdfGtU4MPrX6v3970TljrGxUuwfpF259JWLCYZugkLs14nOl8Gm95FlxcyqPKGYB8gS7uCjbSFYK
	6I6SW4qjN8YEfqTYlRoR8cMLI986P7hzQHW9etlbD/Ym1CT9xIZBcRfuERGvGX7nffa45wuebhCKn
	DNi+HGMUSR8RAzgSGGcc5HwgPzZLX7GcXLO/bEKL9TfwMUb/zVkJU0ETpGp26z9o3hdeeY8yMvUcX
	5WfGGHeLRj3bRnwPamM9rLaWpAlxFApSUfT8lyWzRQ32C9JlN4/q09G/VumDuzIIlqPC76JXtT4bu
	fiAF87yA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rRogj-00Aqgr-21;
	Mon, 22 Jan 2024 07:25:45 +0000
Date: Sun, 21 Jan 2024 23:25:45 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Sam James <sam@gentoo.org>
Cc: linux-xfs@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCH v4 2/3] build: Request 64-bit time_t where possible
Message-ID: <Za4YeWfvfjNBZIQc@infradead.org>
References: <20240122072351.3036242-1-sam@gentoo.org>
 <20240122072351.3036242-2-sam@gentoo.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240122072351.3036242-2-sam@gentoo.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

