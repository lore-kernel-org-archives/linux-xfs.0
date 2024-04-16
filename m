Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDF311720
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 05:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713245517; cv=none; b=nORzGC/6D/EVDEPTIJqOuKkzb1HhCfNfb3EJf/kGSUCYw9djDRpNqDQfscPs7Vo3BRGZvugsIJml63+8m8Wawf/3EZbGbnwv4fUu6ats8+MW4pDcHFi71Q+tFhWt2Qbpswof1kE/0V1hSQ09hQcK5gMbQopef6VYq6ts5ELsLXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713245517; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C8Sj/42P5D/AbUSP/dk/2nxgyqA6TxHrkdPXu8TfrGbt7OsnFrd87Q1/jqKpIpiqqyq2hcULKQ1oWwbB34nGC/oPckm3SlZ5ASZ43WRPAoOClBk0GXgFycNdwCqoVtin+tTxgyi5z25KLuzfLWojO6nXf4vrAt9RbrLGa8ScIUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bReCxQnG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bReCxQnG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=bReCxQnG0qe/0iRNTfaBQpCK78
	Iam+0qe2GjiKbQeZRqjNIMGEVcmFRnEMB9uSPDL2Zr1mkz/5HENI9jGzllrIjZmjhMvG3150Zf0WW
	rcXozN+eBAWlA/qcoWJ2gulgt4bTz6r7IPVwpFL6QCWGY91E4qvurUoFMt2VqKT060WzSA/06xlCN
	8fXA+tYZSPRnpiFAsY6wRYBF9D4WfMW0Kha63drCYQUF1+6aFxqzOIer6yEscrfXCx6S16YdK6DQz
	mRXM+o8pQuk3/Y/9X8X1tQHskKBcUiUKWZYM++uEW/Rn/D8HCg4IYXnTMvsZMXbwWxkBMSIu/9hPX
	2yS4cT3g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwbQA-0000000AwUD-3utB;
	Tue, 16 Apr 2024 05:31:54 +0000
Date: Mon, 15 Apr 2024 22:31:54 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de, hch@infradead.org
Subject: Re: [PATCH 2/4] xfs: move xfs_ioc_scrub_metadata to scrub.c
Message-ID: <Zh4NSln_DOZTTGMJ@infradead.org>
References: <171323030233.253873.6726826444851242926.stgit@frogsfrogsfrogs>
 <171323030277.253873.12950334854150989191.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171323030277.253873.12950334854150989191.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
