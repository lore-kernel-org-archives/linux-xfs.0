Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E28C1CD06
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 05:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713244422; cv=none; b=YVFbGsSzMLaB4Ww+gMpHWQc6EC1XRHmKvrKPsFbYvKjCT/wNedOjNFiCCN+zDRrxZlob9bWaElJoVk8XAVqzwX6JEPTfvdxJsjSqnLGwxQ0qrQjvioMqtGg3JHmm6rBYp/ApyreRzntGxUofC5SIyPkAM10YodmmnaGLThO0VkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713244422; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Uag41BVYRCSuJGf09iXZ/ZneycAFOJ7wOCOdFykyW1HgADr+M2oZTG3JgTFyfd/Nux2xpE+adfk7jAj673zlcAYjS3KBl/YRvVgM/6U3x71BlThSHL5nUrpDFLSqCvsOI6JjtWJFVBmmssRaaIaRXDEIx8NZ/Ia+3bUJ+tQRimg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NgSiTZHj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NgSiTZHj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=NgSiTZHjM1oxyPhJG5NpZKCrQv
	krMNKEUT0gf6ed559TU8yISV1+1UmBniJHPQ3VZ7WjikbKuguJGSXFez9GShSX9q3LovzOVBANw8T
	de/qD68bq6LKKGCSlG4WDfvFxXZDQ0h7GReZfwVVxvEAPK7rucEqzb/NoSZfc6A23gt0SrjJiRVAA
	/0sS1nwld9DtYC+ww11Fp8jXud7BzTkPdaaKlxrHpDtl813zHgZWmqyFd3AuKyB43xeT62JOuIzF4
	HWIirQSugD+kwag638bFlyE5raeJM8PjJK2RwPDijRfd41sWd+cGlXnByvoLSW1K0Nkn7QS8b1hm5
	Oh0MwxAg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwb8W-0000000Aug3-3nxC;
	Tue, 16 Apr 2024 05:13:40 +0000
Date: Mon, 15 Apr 2024 22:13:40 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de, hch@infradead.org
Subject: Re: [PATCH 06/14] xfs: check shortform attr entry flags specifically
Message-ID: <Zh4JBOyZQGJlB9_8@infradead.org>
References: <171323027037.251201.2636888245172247449.stgit@frogsfrogsfrogs>
 <171323027170.251201.11533427139433278808.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171323027170.251201.11533427139433278808.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

