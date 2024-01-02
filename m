Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94367EACB
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jan 2024 10:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NVOmEzXL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gqJEAlP2fpDenxbVvNhEJzAtwghXrvLuEoIy+8nolfo=; b=NVOmEzXLh3MDg81SUajSP7wUaN
	7g2UTKj/e32htXoO/iVeB2sIiBUNQJGzGGTlModaoo38XWd/JpBBvFCSI5V5Uvn0cybUihQiU6VkO
	VAzkJE1NbkTb1SQb1/VzP0h/L/TwGDGhtXXHPPuRNMN2S7FjEMBgF1OmKQD0Gp8gRr5ZhSYh3gCkB
	Gvt1ceUePUij5dLmA61TpdTEboHrjP68lqhTdG7u2k0MVCYXoRWFTrl/5PehQyIhFS0////a0ApL2
	AQci6VkN77CVtzF+6sW37Ec39gjf4aBk9BmloSyOHgelKIa5CB4nOuCC/1kZOSHWDOXwPpaBoyX0U
	A4C0dbfA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKc8Q-007cAH-0m;
	Tue, 02 Jan 2024 10:36:34 +0000
Date: Tue, 2 Jan 2024 02:36:34 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: export some of the btree ops structures
Message-ID: <ZZPnMi1jcffyMmnW@infradead.org>
References: <170404830490.1749286.17145905891935561298.stgit@frogsfrogsfrogs>
 <170404830559.1749286.9827733797493537806.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404830559.1749286.9827733797493537806.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Dec 31, 2023 at 12:17:44PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Export these btree ops structures so that we can reference them in the
> AG initialization code in the next patch.

Fortunately not export, just not marked static :)  The being said
this would be easier to follow if simple squashed into the next patch.

Otherwise:

Reviewed-by: Christoph Hellwig <hch@lst.de>
