Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5A417567
	for <linux-xfs@vger.kernel.org>; Fri,  2 Feb 2024 06:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706854697; cv=none; b=bCHoDf7vFbVXSZCnSEmhvtLTJDVXqkTWzM4Lumb+i46rvuVjlIV51uui2xuCCavyWmEv9jLsUkDSl6NQ6zmkCN3+rCtAmc0Wc/oT2fpTuplwMWGOwUmhiwxfxwGVa7K0EyGXSgTTJHLqOlSnS/ELE4/WikwV5Wqf731U07f6fPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706854697; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FpE9bnuOK/JU7vI/GDbl0V2b/Qr59vZL7WyXL/iUibO7YfQmbksGNOkF/+QnBErMno4tgUwM3ZZsqaucF12p1lXoo+fJHVDPYg2wMJI8ysXvSxhSUJ54fnTh0Mh3UDagMgSIz7f6ewa3VqNSsKe+XRzftFaYkJVWcNn+/w+qs+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Hfl46SJr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Hfl46SJr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Hfl46SJrPmHytfrkD+3lDcr+3x
	yQ25DI7+lsmL3YrAxgWIjRnfdUtu7CLH8uLH8EVSu3ejOu6RDejKwOqsERUo1dtLtLxrklTByzPsU
	P0F/mX7vb0rDUX2FTsWOT/T3Ypfi/ETylvYfI4EbwfeJRnwdXzRhtcZogu2JbadUbkMi0uYh3Jdmo
	Lzv84Ib2nSE+jGUt73h5IYr0l8e1YjvXV83WMigv/E0fPbHE4APDkYhVQyK/LSX4m+bGZF7YsCKj1
	dszJEuhyZB41ogH/bnlvHbAm5jIK56QJA+0PS16yBFmRjvVsjhcMRlMOTGkpxBBlNeMSlKQTuh6lq
	wBA01srw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rVmsP-0000000AOEA-2reU;
	Fri, 02 Feb 2024 06:18:13 +0000
Date: Thu, 1 Feb 2024 22:18:13 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/23] xfs: consolidate btree block freeing tracepoints
Message-ID: <ZbyJJX7VU7WUgw8e@infradead.org>
References: <170681333879.1604831.1274408743361215078.stgit@frogsfrogsfrogs>
 <170681333951.1604831.13726435982237623887.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170681333951.1604831.13726435982237623887.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
