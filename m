Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7DCD35E1CB;
	Tue, 15 Sep 2026 06:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789453836; cv=none; b=By+OphNrE7tWpN2Xq2j9uvFO2xS5ynkA2LkfyAnK6yy61Xm2hFoPxA0z5fkLuzsvKItaXCdbNwNAHdHc69wvwo2RhbgGMBbzR4DJx8d1tjHX25MWV9RWQWmlvp9quyGV8NGgGKCDVJyAGqsKHqpknyjTeVNP2eSW+GqXDXBIyqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789453836; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZgZE6EeVeBqkI+EV51mTS24UfjmXGpiQvrwkw+zage4O9XlP9/iRoM6wCbXxnxvWCWUhexXXTBHoULaaOadv+764FyEbtF260BeXuUIMQBMcsoQsJ0zKEIuSu8yvwUVNY26LPmkvbyvV9n1yZKvIxdSHNYCiOf3Hzw+i+fJRAbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Hie77EOH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Hie77EOH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Hie77EOH0SDU7z2GV1P8kmBqt/
	sldI9y2v2narqSpwOYbr/qjBwGXYOp0ijz2eXsiQWxLDpd/HzGUyKxeQKt4UckbTfjQ/hfmKG8ldM
	IXCTlUqvWnVQjvpbzBb8SRFfB901b+18jLmGzks+V6qJTFs1Ejh1naRGoARBfamNGYDNMfMbC1QI5
	EmUJiy9W7WlU36rlRyyxP8yG/2zUcAeLcRUM57GZPGr0GR5bhBopJxo5Q58eGebQNf4DTYF9q8z3K
	GnE661zGlhkxMB2WRWNG8CKDiC+6BXvkS7RRSPU8ohUhun6watoJHkMgCEs2JJeKEgjKaLdn3+rts
	5sq0ShdQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x6MgZ-00000005LaA-1MIz;
	Tue, 15 Sep 2026 06:30:31 +0000
Date: Mon, 14 Sep 2026 23:30:31 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/11] xfs: don't merge different file IO error types
Message-ID: <aqjmB4d1d_CzbAaY@infradead.org>
References: <178945048435.3061055.16384804993810925544.stgit@frogsfrogsfrogs>
 <178945048627.3061055.646177261017605740.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178945048627.3061055.646177261017605740.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

