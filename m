Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0zE438tW"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D54EB1B4
	for <linux-xfs@vger.kernel.org>; Wed,  6 Dec 2023 21:31:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=0zE438tW/Le30IKXaxZITcLtM5
	HVM4eO82B1mp1V2RdpIge0aahSW5XpLkb1uQIUupnIlRwxVkAD6ApjEk/OPg73PnWWiBH/7MnCfxJ
	LchkgMkk5ydNhaclCiAAQWVchM2MX7/nDUZzVmgLRLzbJFPyPv1SJWsvgOdEH/4RHTcC9sE6P7XT5
	6GkcpSVDG054VjusXxmTXgiuTuHtFtoeWLtCwNy9kX8bf3dttI55MWWpLiSNDPa/ajsn9Y7ROvymR
	1Pdbw78SRBqN8GfufXltATJXz9RbOnrp27eRhatwgRzBQ8Fu/SlCMWqkWUUJ50utcKgEBNuuVNpgs
	rkF+y38A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rB6yi-00Bu76-1n;
	Thu, 07 Dec 2023 05:31:16 +0000
Date: Wed, 6 Dec 2023 21:31:16 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: add missing nrext64 inode flag check to scrub
Message-ID: <ZXFYpL20a5OQwpsM@infradead.org>
References: <170191666087.1182270.4104947285831369542.stgit@frogsfrogsfrogs>
 <170191666156.1182270.4515850685074017228.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170191666156.1182270.4515850685074017228.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

