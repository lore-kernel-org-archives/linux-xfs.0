Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6975D20DDB
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 06:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712729986; cv=none; b=qU+DOwP9jqJvfyRNDWyiaQzeeVkkzq0sEWe6t+4adPqFbJr201Eu7X+74F82caqiVs/XPC2eEzKkoJAUiT1CU0DE/x+yTMfN8hiO6N27inqtanTxKNNnsCaNssg64VQ2OFtcw3dw2ir6q3jdhHNIWFwWJ3vLxNnrQMXJ6twXETI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712729986; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SzLjPqFJVrfj5qak/jpCOoz8NKox7vMnoSsRRfDmczca0artQ4l2gBAKWjYKIXXFXF8prHTV72tjcsmuiQGl7H+YWPqRyJycOq9uO2dZon1z3+ukBOFzKYZNCXZVfDmMkdJtR9voXhCIDqr7kxiEkSMnPuabUEbQKXjR3WxroXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xF4neXQf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xF4neXQf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=xF4neXQfoCduWHoJYlYnYdlMFa
	vHV7aHomp99FXoX5h0Q+kHG0lIqCvVzVpzP4h5xoO0R/jhVNalJC+oZNgCDcxGL1zcjr4eLiVNMoa
	JGaab/6LtClvvNOSVxZQPIYE9uFC8TLyDrNZT+uluU1f1UEIv8E67OBshGDiESOw22TdScuahpMQP
	y40n+dSvGL5xR1ee+ETTrqnA84TvCmN4P6X8JBEWkgDxMabmbw4Vy0dOf969qHgKHgpiDKW5U9iRn
	ahWWjFn2TRAnK5leUUoEpF85Qxu+3hzlJPLzZhJppQCbchbF/r8nBOIBOvfi7b484xqIisk7m+wdG
	lzph+mpw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruRJB-00000005LxZ-0LmS;
	Wed, 10 Apr 2024 06:19:45 +0000
Date: Tue, 9 Apr 2024 23:19:45 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/14] xfs: replay unlocked parent pointer updates that
 accrue during xattr repair
Message-ID: <ZhYvgcgz_JxZPyem@infradead.org>
References: <171270970952.3632937.3716036526502072405.stgit@frogsfrogsfrogs>
 <171270971070.3632937.813943653610271681.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270971070.3632937.813943653610271681.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

