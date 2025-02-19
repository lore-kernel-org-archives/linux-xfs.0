Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C20179BC;
	Wed, 19 Feb 2025 07:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739949485; cv=none; b=K/XehUJbJM3P8ZSsbhsylue1rr+F5u5IgndUOFlwmipxIrZItcoVL6JwZp1i2kb/4yxA6WHQjch6/Tx91iUsrCcSRta0pmTmKTn4Cj5NCqrwAJq3YY7k/v2isHDhAS4Hk7wgcTBWH5eB/ttXJM99yowCS6E/3AwTHiTXC5WF2xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739949485; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A0lAoZI9qfQUDb3KJ+BsmuTqcYc+cyJ3XRVX+q4ScrvS1QSQpvmZNYulXBu9Wp+7kexz0aJF2EtoXit9nYxljfmcBJ2ZPYXYuveNLKch8b7zz9CHukkg3ethWtz8twZq7h8Kp3Z0Xa/+UDzksIG/IZp4Mxx0hRH2J/Cr05QkCo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4Wve84c/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4Wve84c/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=4Wve84c/JsOilP9i8LOvLkT8pb
	djOYrDzElLhEc/BbM6pjWMjRd5f0aSmmUJ1s9MF83eNPwC0Uj1EQFmTCGceRZUxU/CB7dRXRQAiN2
	vXQtzbOeOi5IFRzJmVJrpsPAfYLy7aJNBnd5wS5wdNTDGvn0In4VqczIrZet0z8AiOv/lvR1jv8wM
	4xDGcRwY2IrEKa3m3ePyUuDh8IMYaFUPtNRb9wVHuP6p7OuVfEAITJ+sIPMV4dbdjKBTMQiyiwE6j
	k5a6ch+RPjPgP9wxbKiRKtpU7G9cAUPB0hNjcV3Sk+XsSHDb5FnEVyRkfr6Zk4YBHOupg/qJxEzh+
	JQ+hPQyA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkeLM-0000000BCYb-1VGu;
	Wed, 19 Feb 2025 07:18:04 +0000
Date: Tue, 18 Feb 2025 23:18:04 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 15/15] xfs: fix fuzz tests of rtgroups bitmap and summary
 files
Message-ID: <Z7WFrAcw7pFMFM0M@infradead.org>
References: <173992589108.4079457.2534756062525120761.stgit@frogsfrogsfrogs>
 <173992589456.4079457.14720380754325984212.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992589456.4079457.14720380754325984212.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

