Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7018C3563F6
	for <linux-xfs@vger.kernel.org>; Fri, 20 Mar 2026 07:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773990814; cv=none; b=Cj48MNYkmPMQlvG90aWpw8j0gc0LUg3lm2KkDZPgqg+E569DsK81xheQxhz1JkqUZC648xTubAZZjhJbBDtNt1++WUhcpASFKgdxMq3269p7yDAxuAwG4v+gPD+JchoJkj5TI2L/qEyO8igobiNtEPc/FGWEyAtX9/4Q7OnptBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773990814; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eJTyaOxRdrhIPE30PDQh08p875Yp4fJxNltm6ADGnwalwsiG67JZCNylcmqr9vH1U8yUXpbUG1Dhcc/HQjeobxyGMXLBeqAPBnPX+ysiYTrpKnvc9lvdBciDLUdUSrXW4l1mTf/cjEzbZ0B44700RUuj7txpF6XGDjzjESbS2UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1SlgDik6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1SlgDik6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=1SlgDik66l0j5C5+n41fdlhsaO
	GuDfCuaB9KhpFch3NJlVjW5g78J+CE4PAuu7bT+DaTqObJQaLkt41zM3W8lTlWt48D9PniBtlXT4k
	wPdfd4MkNnd77YdBwlEs58SxckOV1Kvzj77xkTnZfal4OrZS4oL0psX8GgFmN7lXIx7oubA008wXx
	mOsErhoUQhtUYbkucXlPlAuOlDhCEO+gITlGIC4wcBgl2Xm1m3oUjoTRmpfNQyO9CV+NMpHq9py91
	T3F252dyE04qlLURiyUEO3mUgmrYZffsfiyBA0rIr2MSqPMnZhDjGhJqAbXpwBitjxwlohOjlq3cF
	ZYCpBpcA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w3U32-0000000CDRF-46t8;
	Fri, 20 Mar 2026 07:13:33 +0000
Date: Fri, 20 Mar 2026 00:13:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/22] xfs_scrub: fix i18n of the decode_special_owner
 return value
Message-ID: <abzznBEmlTF6PaNq@infradead.org>
References: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
 <177389507032.3681140.1351596709774895251.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177389507032.3681140.1351596709774895251.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

