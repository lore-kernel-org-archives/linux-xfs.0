Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="i0jbDNXd"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F579D44
	for <linux-xfs@vger.kernel.org>; Wed,  6 Dec 2023 21:30:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=i0jbDNXd6lJR61mddjuKP1PuDf
	Mgjk+3/OzjC2MFLIzZ6eQMggOxQrj+JP1LDfoo8kpgBK3GuIdgoL4jx2az1xkE24hP0NOHXcoeJv5
	ls4euwJ/c6jyuyIgE8SR2+JrgukmG5kuZ7ynPNEn63M4KPUf3jI3ZAvFwSzW9GUKFAJhIA7D8R69L
	oyUUFau4M8p8V/SJYPeL7OZ8la7CxlwQ15pDZaXIwdhIzxYy+5FKkinICiTbpk8VW45kL384XtXMu
	FTvCcGjfTS7snzeU4z5g0J+2BvbygRIeJ5jqRTUmZT/+uXQGB5cSX1EpW/FBagi1wwM1tLfjE/8uM
	nW+++VFQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rB6yM-00Bu4x-2x;
	Thu, 07 Dec 2023 05:30:54 +0000
Date: Wed, 6 Dec 2023 21:30:54 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs: repair inode btrees
Message-ID: <ZXFYjqg7UikVdZnU@infradead.org>
References: <170191665599.1181880.961660208270950504.stgit@frogsfrogsfrogs>
 <170191665714.1181880.17886548347278537110.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170191665714.1181880.17886548347278537110.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
