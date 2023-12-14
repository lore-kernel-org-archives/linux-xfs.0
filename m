Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YPVfqLth"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E3E1D0
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 20:59:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=YPVfqLthOznY4NNrzYyeoIPOGU
	SfqY7DDWj/MW064j4ThuIeuqurj/Gph1pXV+nFR8QVhgnJ27I7ZnN8lbj/8uG97RRW682V7m6r65F
	BsmPpIkf817zUIi9ktzvE+huby0sRsNRbjWIYaEgzeNpe8WCNOWjCOuWKSY6jI9JGsptAXqQwKskY
	b8h6GQD2F1jtk7HYy+43wyDwJtkvWxvEqXWgbitSXeXbSsVguJ953hZVXnPXWJUtLOn43qZ+y/lfe
	TxGJ62JqciMjdAS+84gCwtFwlCCxN+dBDPGLNK7CeyenqToctlILPEFnxsMUax/Usxo0gEfnLgVKM
	VCvXnWqg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rDdp7-00Gl8a-0K;
	Thu, 14 Dec 2023 04:59:49 +0000
Date: Wed, 13 Dec 2023 20:59:49 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, chandanbabu@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: repair quotas
Message-ID: <ZXqLxbPfIuniQLlW@infradead.org>
References: <170250784331.1399626.6539338084714476832.stgit@frogsfrogsfrogs>
 <170250784403.1399626.13611836698741302258.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170250784403.1399626.13611836698741302258.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
