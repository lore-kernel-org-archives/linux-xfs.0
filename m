Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AD75026A
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 06:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710831361; cv=none; b=bPRIDVL8Mo9s48TnO3pItc1tzUwYef5Uoaf+l8j92QV4NUHrImHD0M40H4WLYwqxiH0hghg1f06OoNCqzbUvKPGzzZ1AS87LR0LTTdv+f1Gxj9JEKAYRn532L4GAC6XCoPxoIX6dKSLoaTYt02yW3Oy8TA7varuTXYlGNNwwmTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710831361; c=relaxed/simple;
	bh=ZFkhz7bOiOue+nVvskCpF+hYZSSOTmPxyAKmmvc2YO0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g8heSLsrrU+3i0p7aTdXtHR8jJ35C2ta0GooYvsrUXOUg1HzHS00tHN+x3zoJXkNshjxMiYwvORXIj5mMy7wyhGA/T64YRnCLU/hnyug/YDIsydm3JFV6sclt3oRb8hXdh3DV8EFgBsIe7dUwGH4Oe2rohi9OKgEs7pN1WARSPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=miNqn527; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="miNqn527"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=b2ivHjIAJBXm/q/NO44Vu5sBpByI0zAVPUlGKdL4hco=; b=miNqn527uWDy8o5ACH1FfUzkAq
	g7RMS2vlp6hCASSQyToZuLiqw/LelLDQ3lvx+tolMRDGN/TqoQ1TgZ0ZcZ//XSLNlinPXf0En5NmA
	LYKXJeDYZlkvUriaAWcqqSrVkdAvtSviLmMe32hIsPbmC5RAnWr367USwl87yWY98pmbmR0DYy2sc
	eRudBWkOchOFoCkgZmo7CrGmebRQ4O8e9LTRDgHPWbZ3QyWouoRhpm03/Yc6kFxKArgrU9T6iBAym
	ztn1J72rBHK14ubxMRLvhkI86xGjaXs8pADW7t9S4WDNNz71bIANFfqks4M8QruuD+7K4Rd4aQikd
	aDffWH+Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rmTOB-0000000BaoY-1ImG;
	Tue, 19 Mar 2024 06:55:59 +0000
Date: Mon, 18 Mar 2024 23:55:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: convert buffer cache to use high order folios
Message-ID: <Zfk2_waswczeJcTS@infradead.org>
References: <20240318224715.3367463-1-david@fromorbit.com>
 <20240318224715.3367463-4-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240318224715.3367463-4-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This looks mostly good to me.  One question:
xfs_buf_free passes the folio count to mm_account_reclaimed_pages.
The name and implementation suggest it actually wants a count of
page size units, though.

