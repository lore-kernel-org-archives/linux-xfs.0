Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01DC8262A8
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 06:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712730262; cv=none; b=idae5qTCnHi93MJPB6IIIM0CPD0ARdmQZDhMOEFlYlFnxRk/n3vsKYze+fxA/fFDIYN6s6Dj+21yHha0x1ASshTTUh8iDNPmsgaUyyTbXe09+htZqJLiv65sqZf25VaX8tj5C32Hs2MMzCGTGrQwCQ0LtSBuUYdGxIbi+MkKnmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712730262; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iMIQ/roQrRRR6I9UwqMSMpbE9zCpLbQX1ZWor6buva5ETClBEkMc9vkf3O15r8vt/pVfsHgAVzBWp/bdXrF51DSaX3msHgSTbFflDEl7OisXpiwtxhJ6EBr5fFsdL8wpN5IPrbW/+hjTJRvm6KiuVXqMinWR/eLm1gTDxWTtezc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HmqQY1fr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HmqQY1fr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=HmqQY1frTlVDn2g7rkjJ9n2vBQ
	8NGrhaHEReyAleYlwpLp1/bzYtFEgQ8/rO79CHDtHv8/dKDS3yBbnZw1f1ghIWih/AA7rIy/YH42Z
	jB/4cKAu/Dfi0slqTweeREzub6MS1v8aTo/zRtQXLXStMdQ7oZMxAZumDWPT5YM0C+q1KeVC7GTR0
	bDkI9RV0rG1QCsvCAFIIyL38TGpfZAJ0RrpvRsR/PR1GWdDoSjsJclKrAKRvcwOkFkt3qzzDD/Qzw
	WdoBo9jPVfmuMRY2AUjqb1T/+wZUW67IG/rUZvAnvtZXjF5tz8IRexPczV+GJYSGZhkLdsficASJl
	BrZ2/G0w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruRNc-00000005NPO-2LdV;
	Wed, 10 Apr 2024 06:24:20 +0000
Date: Tue, 9 Apr 2024 23:24:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/14] xfs: inode repair should ensure there's an attr
 fork to store parent pointers
Message-ID: <ZhYwlKy5GM2abV0d@infradead.org>
References: <171270970952.3632937.3716036526502072405.stgit@frogsfrogsfrogs>
 <171270971220.3632937.18307837789023273828.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270971220.3632937.18307837789023273828.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

