Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qnDEcjKg"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D35AD7F
	for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2023 21:12:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=qnDEcjKgs4r1dfl9TJW9rEjP9L
	0f5kPLFoRPMGCRUMRP+v7lENaDAad8DnKAtB20Eq8X03Uh75xxCymr4qXT2XQMBGCvdr/Mo3vy5XU
	F3t9PstJM2FKZmXhSFZ0RYSso1kEcdoX3vDO52RQkEFEF2UvSPPXcU0QTLW5cM2Ig5JFq5Bt5ZDpI
	Ajl3ogNUNDpnap4YUXQOstQPGqUHOCdB/etx6sX9A6vtgXGxtUzVPf2S/IY7axd3NEObVsTWOptzz
	EKn6d9RnaT1SjplcKBZLSLrOPUS/AMI5GRJkxUVQ/VYTcAhjtEhbAnmK5g1hxvMnruwcBTA7lEhV9
	OigjOTVQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r8ZLL-009xAN-3C;
	Thu, 30 Nov 2023 05:12:07 +0000
Date: Wed, 29 Nov 2023 21:12:07 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: repair the inode core and forks of a metadata
 inode
Message-ID: <ZWgZpzqZB5ZfP+CB@infradead.org>
References: <170086928333.2771542.10506226721850199807.stgit@frogsfrogsfrogs>
 <170086928407.2771542.9456327157299550315.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086928407.2771542.9456327157299550315.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
