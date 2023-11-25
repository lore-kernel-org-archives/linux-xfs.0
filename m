Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Zzvv7K0s"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C161723
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 22:14:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Zzvv7K0sPJEcpE5zWNYwP5YF4M
	jhXsd9R5MRXMj2qkhDTTVlhjwYJHHxTa3L+2i3VYqO1uwePrHuR1uLza64nNh38yr75F3KGbvKA11
	q5fzNp2oM718F9hLvV9kqOylOnLECIeCGhcQsjIWhv8wCRfzcos5gfba+KXNhnrjT0lEN1zas912J
	d3fHGfwYucyOLQdhW0BfvL215jAqSrYmhuin+EcYm+vVppnPPn3TyF8NX/CkTo2kCiaFVCDbyzGpu
	twkxVehB+BRybCDmQjVNKy+R5dquknlRLuXvMBnes2c9BaCS8Pkt12RVzFj3v5TxZzDewZ0a+d8Na
	eBE67OlA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r6lvg-008f6r-0k;
	Sat, 25 Nov 2023 06:14:12 +0000
Date: Fri, 24 Nov 2023 22:14:12 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: try to attach dquots to files before repairing
 them
Message-ID: <ZWGQtJf0IPIsECTw@infradead.org>
References: <170086927425.2771142.14267390365805527105.stgit@frogsfrogsfrogs>
 <170086927472.2771142.3254084672776828738.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086927472.2771142.3254084672776828738.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
