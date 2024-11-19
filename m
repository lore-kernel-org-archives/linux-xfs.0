Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB8B142E7C;
	Tue, 19 Nov 2024 05:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731995241; cv=none; b=DMBIe60urX7r6FexIYkSWEXemc4mtznnrUj6gexxoX+1ki8C4Ilq7vuqKQsLLfv8zWQ3C+U8zWcd6NUyfeERXys7tpT17EeHT4IkIOId16TWtwJbFqo4SVb0iiXQSqfTMv+lmwhM4j3ap5UjVgkSNJaGigxEK6pbZ62iPFPTjkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731995241; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lW4Z9ZPFXXVjQCCnN5jqaqNJ3gpmMwVVfdvW8aPDTfbpJmq4I2Jo4cYHWTL6l5xOi33MINmjFU9xUpgwEpZS8PMtxKXOuzUmNCIgYsdf1LBbHSLLeIOoGIz/GnD63+BNkx9Xgv78xvPb4A/9i5splyWnjbhUuyumHFg79IllwaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Vz+6/TJP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Vz+6/TJP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Vz+6/TJPxr558ohfFtT2V6lb4a
	t+klIiLlWaNCYL3aIfPlJ6In1Pf7A4JRFqC3K+qfvb3UL4GVIctEJsxq4DES+F4u3lInUNqS3oUm8
	0gHhOuCa/OmyOODKgDGcJ7tifxqHIoxFs3+C2aAgs1CrTyZTxnR27hU5nIKihX50K8r3qSueqA5np
	gmxub56wB1F97dKa5Jtxrih47QZp592Pzer6WO7uHpVXmeTOA9k+pviz/YKx8V6USg7qNzb2wTVqH
	wJpHOanbLSSqvg7MUL4yasispq+/Htb1OJHseO7IaoPT7wvjsuUbz/Rc2WWb0h4fj48cigWkvtqCR
	uwx9D1iQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tDH55-0000000BSFC-2vqq;
	Tue, 19 Nov 2024 05:47:19 +0000
Date: Mon, 18 Nov 2024 21:47:19 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/10] xfs: separate healthy clearing mask during repair
Message-ID: <ZzwmZ1iAFUH5UVk_@infradead.org>
References: <173197084388.911325.10473700839283408918.stgit@frogsfrogsfrogs>
 <173197084515.911325.13396294816751205852.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173197084515.911325.13396294816751205852.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

