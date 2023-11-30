Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aXGZGW2m"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE645BC
	for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2023 23:54:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=aXGZGW2mVnDxLaGI8M9dQcpuAR
	ej/SUVYtoazelr385mg3uGRPWVlAHCMzVNMEZmaU5P5YA6sNzySZ5xWEsaznJQRFRFoT0g0Ci9e8E
	Fhuom6dXNa2COHftlEU4N6MYokhi0Uxzsm8Wu1yf3vCEBk7JeU3G4s2RWa3vss1phXzkdYrfDZ9uA
	FEyMtg5gr7tUwkWOUXadkUrFMR8osVZyvzTU1+xnAq9gcYvYAkfLnuzFPIEOnIFmFQLJs6ja/URBS
	pS7zzbXUU242EnGPVK7K8VSKlNwmPnap+tcLTXhQ8e/fpi8JPzH4hTcMRE3Up+HvZqZW1UiLq/hOK
	F0EFUaqA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r8bry-00A8pP-37;
	Thu, 30 Nov 2023 07:53:58 +0000
Date: Wed, 29 Nov 2023 23:53:58 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: leo.lilong@huawei.com, chandanbabu@kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs: pass the xfs_defer_pending object to iop_recover
Message-ID: <ZWg/luDz/gKBC/gT@infradead.org>
References: <170120318847.13206.17051442307252477333.stgit@frogsfrogsfrogs>
 <170120320584.13206.4218262549563803966.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170120320584.13206.4218262549563803966.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

