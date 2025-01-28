Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BCC919047F;
	Tue, 28 Jan 2025 05:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738040891; cv=none; b=JtHXqGTJPlQnHqThX0+kSn3jtyjHuxflEvILUzg+litGViD8ttWxvqZdmApKLNGY8tbdOUM1fPW7D/3IAYrHyM49120CqkqBikDkHz5jl+J/Vc3lVswFJcykhtXwdN69xJlZvZWkqwrDsKhZ5Sf95HutaC/pQaPFuCLHU/vhxTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738040891; c=relaxed/simple;
	bh=5YpGWpE7rv9+ysdy0rq+9aFHwUwQ2My09pogT/g1N1s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qwi0JTL2f3RBl2A5Ks5AtnDmBOQNNRUjgO+wwhdS9G/oNBoIDjoLGhAzpga8ItsTBIVSKrelX39rnO0+MNVYH4rB5rJ5cNCyjiihB5+C1jg3hC+rG7FaNWnk1KLHe3OGHsjm4uoT4HMO+eSGCIrtC8w2I10/+vujnV7Kzgq0Lzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wzJlJOnd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wzJlJOnd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5YpGWpE7rv9+ysdy0rq+9aFHwUwQ2My09pogT/g1N1s=; b=wzJlJOnd0McKxd+gMjm5+LMW0j
	orhFDb+0GT2DPpcdyzmD1ZEx7dCRAZtF+02wLT8YsRc3sgFDQUH7u0UfqMeTSEy3MkhJy0zymCHrr
	HbuienBIdmA7KRRx8yynOr1qrOUks05vrW45rMe82BaOBO6h+/DxUEiSrs7JdP0KY3/yerSXAYKtM
	xPTqa76BxwHUgseWf32M/vWg4kPIc2KB9yQMWzY5MSZf8IKWJtJNss6LbVvVwNWIRUMeMxTQ+PrZV
	UyuMCOiICsjziJD8OWPuIGKNwRn183tsubLRnzcC7Xt8A4LijVHDtcDvKmUtg7l+ofa3NiVwvDtbS
	ygSSPvvQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tcdpV-0000000471n-3VL6;
	Tue, 28 Jan 2025 05:08:05 +0000
Date: Mon, 27 Jan 2025 21:08:05 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Sebastian Ott <sebott@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: xfs lockup
Message-ID: <Z5hmNUbdcmXSCmzc@infradead.org>
References: <9b091e22-3599-973f-d740-c804f43c71ca@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b091e22-3599-973f-d740-c804f43c71ca@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi Sebastian,

this patch:

https://lore.kernel.org/linux-xfs/20250127150539.601009-1-hch@lst.de/

should fix this issue.

