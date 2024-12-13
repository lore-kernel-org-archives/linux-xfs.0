Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE971372
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 07:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734074452; cv=none; b=i5Qe5yHS0YWaNRkGUa0K9W6fIcBuMSSwh2r4dPgbYpZJzqoAkhbeYy/cYe53sMSqvLABUpqYWAfKis+ATO/267ubbEEc0HGD8fdYdg/+ZtQ33TJg7yEGV5rd6DcAs0D/4L/icgQcwwmnYy+TQMEni+h4cQWlWsIeAZybbcB2x+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734074452; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IVpZeBXSqBd8E5rSZgfDAF3P+dBh5Ie/w1535tDKDwhwzmOZlMtmQV4ggP0x7lHTQbv3oEiXWwrEhT4oybwbshpXM/h/v60TEbKsv2F/8Ij7NLooNkfSQhHXu8Mc/m13nfuxR8i62xuwh37M94TBj35CPNUoqJfL7RobMaV7tNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rI0OysUW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rI0OysUW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=rI0OysUWEv6oLd86erEcP3aEd5
	G0YN8dmVUpSIbgE9Tlt4aYw8dnd/810FP0+RFNVPP7S5sPByLBx+jHUspr8Iby3QCIWkjYPKyS2Gn
	fF3r/Pths1SFVtAnxf56P1fJpLKLxtkyDtqbPo7T2uUnWfsBkWkMRCPLGvAeWhhBTaUtpauOtg0ri
	AJjZil2EGgUEnEMfh9gI2Gl4jI2N9DXGxp1errY4MSo1EBuTkTTzzm8vqJ8Bx1xRDIKczt9rSuxSu
	jYoqNiLgRX4qbzv1U3gfSNC/HCVe9qQMdj5miH+Y57O/a3HqMyxEs/t7WRhrq1WXlUaH7Kebzh8Fn
	Y19WX+UA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLzyk-00000002x6W-2rKK;
	Fri, 13 Dec 2024 07:20:50 +0000
Date: Thu, 12 Dec 2024 23:20:50 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 30/37] xfs: online repair of realtime bitmaps for a
 realtime group
Message-ID: <Z1vgUi7fnqEFzFhM@infradead.org>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
 <173405123829.1181370.623591226923572341.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405123829.1181370.623591226923572341.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

