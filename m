Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lOv9vFaQ"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04D0BC
	for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2023 23:55:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=lOv9vFaQxkSHTvtSQSxCSiIlaq
	BLPu46qSEhMyP9F0u0sQlV9X1QouhtyOcLPtEDvV9meGWYgZmQa+ehJOIwuWBWCexLqsNL+rJaUJZ
	gdpRR3lIQ4dMWic/6l7jz+DAsBOt6G/0ugMFNQZrZzgfniD5MqZpS9fuEMNo/CRaW7QFAATHYNc1+
	WuX4mzwktcO3RFXc0lbrC9LhLnzajhE5HBFQZ2WgsCjdNenvzNkwCxjk2ynI7qpG1ADY8Ep0gGnjt
	UxGlaJKz5CHvxtzTxHoULlaGUShHHLMaDzK6rvL1C2NU9kBrD2+jcO91j0ltARY+rki+QXE4LxBpc
	KmT9Pp7A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r8btI-00A8tG-0M;
	Thu, 30 Nov 2023 07:55:20 +0000
Date: Wed, 29 Nov 2023 23:55:20 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: leo.lilong@huawei.com, chandanbabu@kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: transfer recovered intent item ownership in
 ->iop_recover
Message-ID: <ZWg/6Jbbzue4zUMl@infradead.org>
References: <170120318847.13206.17051442307252477333.stgit@frogsfrogsfrogs>
 <170120321160.13206.7660824666867423745.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170120321160.13206.7660824666867423745.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
