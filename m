Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736143314C4;
	Fri, 18 Sep 2026 11:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730127; cv=none; b=Cwg6352rg40cPPbwCeuDlMqm5upqJ/bET3mV5jAtLRv55iyeB+FOoNe6ViRFJDWdKmz5UkJjjl3aiQzbe5HwhEJAJ4alUr90+uf3/50MX28upkw6EswDNBIGhkASoRVLq7XNwOilyHarefCP/ZMW7ZgG1Ygl6wQ5xOpE7SHmzOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730127; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=soOnx0dABrW76jq/jHTIwCWyORchKbTmXIaY72BRAdDv1KeNuQjaU+L8IYghyOppLvfP1lYqc2vtvLkkHjEvJ/IJrAk69035G8TJ/MOMQRHfiMBDq7Wj5qpf79zerUjoagDPmRsriFsoawpD9SWv8WXESU1t1p7KNIqoOZJaW+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kCHkOZgG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kCHkOZgG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=kCHkOZgGMONYBy4+YJUvx0J47E
	WzhnEbNKkRksB5RnIbXdplTwx7/tlQBbh+1Ix70gpmAo0385U8r0h/Z6O9jFfqJREXMFyx78wgl4q
	CbG0Umlu35uf31ioyTP1tY1NCDb8pvIMLBMnjlCcVF5Lw0rtfxHjTztD741/Y5hpP+buGf9OEb9ns
	JLLlevNjPGIsO3g0j4ITlXznth0QKK32msaNE1XCRfSB7YS7D7DBOPGeaeh6gBFdgdGhrry1SdWwo
	S3B0/MuXPAXTDr9FPKp/h9VVRaZTQ5KtiO62seNZvVOMD8SODmmCShUqHwj25Zy8W02b6Ob/E1+QN
	Km5tL17A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x7WYm-0000000ECXk-3Dij;
	Fri, 18 Sep 2026 11:15:16 +0000
Date: Fri, 18 Sep 2026 04:15:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: move xfs_sync_sb_buf() out of libxfs into
 xfs_ioctl.c
Message-ID: <aq0dRPWGdogLVDb1@infradead.org>
References: <20260916004335.228753-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916004335.228753-1-yun.zhou@windriver.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
