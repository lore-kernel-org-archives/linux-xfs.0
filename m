Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C751AD3E0
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 09:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734081240; cv=none; b=swo+m0V/OTf41Tqk8+VfSrqjaUIrm2/Q8ViDdC2ig8sDPmLmM23W3fUut9RaSb6qmhlqBhM9W256g81l/oZam8fUTUbCZEcHhtrIMz7FtwVrE72SJyuHxBGp6KskfWrKhHFDgloL9ulYH/7XClS91vvaN2tCwAVD/Wo5tEQoyIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734081240; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CpJX6fthqL80Q32VfytDWXPxdvkNEMP5/bAtS6HlcXvjUX3e7i12+LIl4jPyBz10D7D4SeqYreY8Qpnu0ubwxUsLLzjM9qyjwzskForu6Ry9YHLeB52zmJTB+r5P5eExbIUi2qVJZaLKsnN1uFka/3KPNOCRppsnm6FyoGivS6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=weJV2Ej9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="weJV2Ej9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=weJV2Ej94+6rFMSEg25fvfPoUs
	+gXpIE1rv/LxMXVCY3vJeZHxQ2Juulwv8vaBk/E5farYPOP3URKLO4TEAR2x99by+H3X7CzbtDaLd
	77BgDc6ICzgd/7MljVkyl2id/9bUqsuhIMO+0dz8mf9rect9Xl8Qaki3vRxdoXddQjIjcxQIWixU3
	ZTF2+aasrWAGKCc7jgEpSJZouy+xMWrLuiBwFPvUq40jIrQ0rqFTGD96mis0/la7mkOWv+fLyP7xZ
	stifvjlurRkFJbAImuA0G693bH7c7Ew2WDavoh/WwUBvogGnn6vH5hfhFj3gnwg4XuaiIehxP3Oyc
	IN28ozwQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM1kF-00000003CsA-1nzI;
	Fri, 13 Dec 2024 09:13:59 +0000
Date: Fri, 13 Dec 2024 01:13:59 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/43] xfs: refactor reflink quota updates
Message-ID: <Z1v61xRLpqEKrMbN@infradead.org>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405124876.1182620.15851016747005345273.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405124876.1182620.15851016747005345273.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

