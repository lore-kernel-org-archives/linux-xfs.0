Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vtwDxb4j"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87C0A3
	for <linux-xfs@vger.kernel.org>; Thu, 30 Nov 2023 00:11:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=vtwDxb4jKM7/NcIwSlIz24xprI
	bSlB5LjnS/8pICdGN9tEIK5eTQgvs9bDMDjkTB4LeA7SEG249X0skMxwG4V8mh8eKDSgFt8shhhDN
	iRJr0MKGsbPQ4XEwCoutWKdwZUjkwQEwNXcdcZF9Zum9cJ+nHSJkY7qLAl8pzn6jBt0gwSb/bLmIo
	NqEhyYZmFSv+b4kHpI9ap9F/IE3PazWYEoY16A5lbXq09R14YBWMLI0aDTbvpKrpM9Z5Mzx2JFXoH
	6vvBsuQSNsfhYAbgKH8GfmRgYt1LGz87CK2aTJv9pvTSn1nDa1EDQ+5TzlKo5o7I2FwU3MXPmN+IR
	d0QeyCMQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r8c8h-00ABHQ-1T;
	Thu, 30 Nov 2023 08:11:15 +0000
Date: Thu, 30 Nov 2023 00:11:15 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: leo.lilong@huawei.com, chandanbabu@kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: move ->iop_recover to xfs_defer_op_type
Message-ID: <ZWhDo0jOPA2+R32I@infradead.org>
References: <170120318847.13206.17051442307252477333.stgit@frogsfrogsfrogs>
 <170120322874.13206.13311055647910298715.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170120322874.13206.13311055647910298715.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

