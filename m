Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QHh8ZF7s"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2CF31720
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 21:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=QHh8ZF7skp9S2BskWqCWVSKwqt
	2oDcvxGXXQ7qjxWeLsuz8cOgcQdZXO0f0PHlbGzv31rX784j/5s1HC01xhI3QgosYvZIPOIup/pyn
	V67NOUcIEYIqehp2AP+GZTKqfjymQfPfvvEUPguG3JfJL0sZbd3RH9adRIGvFsLgG3q+7pnlxTIDI
	uogJ9ozUm7XJE6KVwPnTmXvvjocb29WD3i/huyrfaahZK0/0VVXamUp/PAm6Vj5s+NOEJNHDvg+vz
	5PORRP8qtzRbAAu1bIz2IvMqUPESpJ0pGnBjjI0fu7fsuM+xneFh60bySxos2O0Oy9ytn1g4jwh4I
	CMfRAIhw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r6krG-008ZwF-2B;
	Sat, 25 Nov 2023 05:05:34 +0000
Date: Fri, 24 Nov 2023 21:05:34 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs: remove __xfs_free_extent_later
Message-ID: <ZWGAnlfHhW/JsBlp@infradead.org>
References: <170086926113.2768790.10021834422326302654.stgit@frogsfrogsfrogs>
 <170086926175.2768790.12526519062399034942.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086926175.2768790.12526519062399034942.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
