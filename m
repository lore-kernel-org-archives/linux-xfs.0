Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04232750FE;
	Tue, 25 Nov 2025 06:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764052298; cv=none; b=K1MymNXYrXYvaDMZtKnHGSm39CZc67WZGNQgy8Py7kBxSkSSQ4mu4Ew9nFHzLHnOJSfay1eEdzy9SQIgop21w5j1F1ghsfaXyxQ2Xmt7NmOKQMAzGYWV6XnKN+os+Tr+Xcy4ivCBH9rP3BpjYc46P7NN3a+HXlu370xwjHTZdzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764052298; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AZu+4JOmMtFfmq3CkCBl+xEeLL9GQE57at1xYENKFb0cMC74kx0yjYSZGSSDwkLIHAsgHuQA3wuiy7Qdb/skPoIjyaBjWxDNpDMjv71SgQvc9+ToOXAk96uW+m3Mgo7ACUjiIBBRCUJV1SJFe+AVnh2qM/y88uACzX4kdccfErA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KVzeqjL/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KVzeqjL/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=KVzeqjL/a2tSKd7v1tInVt4VUA
	BwuU4avoSUXo3ppvXktNz5CwcsEud0qtjjBCsicG3DPqdc0XczXuzuDfmTts9Lhc3pjH6HQxVOHgL
	Sq1rJc7Zj58TNwVCzjte/6t1DSGIPChhUDcERYIwRfm78++2xSo84b6Kog3LUIxcDvOGFFyj30fpv
	9ZyIBpAD/SMiMPmIMtctDYP9Zl/vgsR0FbhoLZB22fHPrkeu6YolpoydA5bLeR4ddTsKtICubp3Ca
	5CCxjUo/dCrrTRkSc09C5PYTGmaPPoRWgvMp9zW0lIgky1lgrg+zffo/p5Nf0aOaf20QozQ7L5RgQ
	kdQn8mHQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vNmaN-0000000CpLu-3Fgz;
	Tue, 25 Nov 2025 06:31:35 +0000
Date: Mon, 24 Nov 2025 22:31:35 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
Cc: cem@kernel.org, chandanbabu@kernel.org, djwong@kernel.org,
	bfoster@redhat.com, david@fromorbit.com, hch@infradead.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev,
	syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com
Subject: Re: [PATCH v5] xfs: validate log record version against superblock
 log version
Message-ID: <aSVNR2_oLp-dCLRo@infradead.org>
References: <aR67xfAFjuVdbgqq@infradead.org>
 <20251124174658.59275-3-rpthibeault@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124174658.59275-3-rpthibeault@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

