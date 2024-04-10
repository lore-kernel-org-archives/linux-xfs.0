Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675EF1C0DE0
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 05:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712725889; cv=none; b=qIiEGSdbHrDpt2SYdpF/7cCciHqEU3o1Yp2EQkqEGMBrURoKOP3eTJ7X7qAU3Qg6VWZkKyizHHkHUxEnWusU1caGcn5A9Os3RG944cj9Bxue1d5lrcSWal7Z2mGZo+S9wKe6F35HaWLQIsGzW7+8KOvmf+fRbi57ZaYwVdmk5to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712725889; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HP/Rv6epbSehq4vWo2ej5YH2znG33HZ71hV0KdEdIPt9vMQ2Gxj3GfAjwBMnK1zbZfl0DtYEIW7fbA4b3wbiBo7ufsMTgN5i1LJqJwEeYTE0HmbXGNlTmUFv9EgAS7WaNiRDVjovTpW2XC0yCgIlKT3+n5f41t2s+FpAnRbMmYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cQxM2qhl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cQxM2qhl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=cQxM2qhlY680crJnhU+pyb1srS
	lOAfqinQiWv/KKHdaXaTlGU17IibQCoJ3hfBRtSC/u5BdMsSAP555e4EWlzUUv+lKT99LT0ezJ1Ck
	Xw6fKxb1m3dW6HJypxY7mPWBX6ll77cMTdJG0c0pjuGYBLxyF8MIbTMJaZfo9ZWXiL5G5T1Lflufv
	QtPUV8uuTCVlry8S+JGzTRjX+ayHSTxVXLFWrK6G1X+wivznzk4FBB//Y5WVxRd90k7WaOstuc0C3
	045jny24IhY++zSbokJOK9bf840qBhiyENqz11OkONh28QU8W6s0uuKammLvrQian2AuHsXbbW6ul
	hBWRwjOw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruQF5-000000058CU-2upk;
	Wed, 10 Apr 2024 05:11:27 +0000
Date: Tue, 9 Apr 2024 22:11:27 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/32] xfs: create a separate hashname function for
 extended attributes
Message-ID: <ZhYff-126MZ9usS_@infradead.org>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270969624.3631889.1427903658559985496.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270969624.3631889.1427903658559985496.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
