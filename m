Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5830423EA87
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 06:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771483319; cv=none; b=Bo5nJ61FvjsDRG4ruwwQFkyRhHNCRKPiQBj1oEMb0BcdBZBk1tp67ZN5fbTCe69kEiCGyznbU5lp5/+qmL/HLCnTrvRW7G5yoegtr3jmyr4qe5eHA875TUKGum5+VTgGlAOWkGonAwtT7MXzhhESk3KPXGSvlHJ6rQSbfSJrZZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771483319; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FaZcT1mGJK4beDVBBDWQe5/g9cl8zWHXIGDSh11nCCgt81+d4MeFCjDdzv25SQ7yF5+D6rPGQvW5rqHH0eMQKIKqKWwuHKZDXL901R08m00zivl70XSnxrnfZ+l0giwTzYKO5Yh1zg2b0KhL9zkYD8G5b9cFXudi/eiRjYnF3HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NbrATT4H; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NbrATT4H"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=NbrATT4H/UmSXGAB+QDq2FQA1i
	iXIkaXFScNdKYo663HUzghQwnPsSkXiIKahDWKu6kcp+aWRQ2fdDIkxmwSXk2KO0I4XjvCi2XWMR7
	5k+ga8eZ6QXC6lKD+AjERL8G5hrqgCVQ1vBMj/tFFl2kXSI2Fhb9tqISR8ycH4SYccUmu/iPHbG7d
	Z7uBoxJgtqpWFK+6AY2/OECCApM8RKYSZ80CaU3rDdn7NNwYPF/5ND6Tta9ymG2BzUW24CT1pxR/U
	VQr9u2WFaPEF/HNIpd37Pw+vhxthCURaTIiY23K9IkAX4tI9Emdxb8XjU+o78/NdKUxit1xsRd9Nq
	SvytoT6Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsxjZ-0000000Ayq1-42rS;
	Thu, 19 Feb 2026 06:41:57 +0000
Date: Wed, 18 Feb 2026 22:41:57 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, clm@meta.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: fix xfs_group release bug in
 xfs_verify_report_losses
Message-ID: <aZawtcJH1YtTIthl@infradead.org>
References: <177145925377.401799.10773940743454980308.stgit@frogsfrogsfrogs>
 <177145925451.401799.12258119310555841656.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177145925451.401799.12258119310555841656.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

