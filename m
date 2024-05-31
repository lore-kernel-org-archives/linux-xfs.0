Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E58A77F2F
	for <linux-xfs@vger.kernel.org>; Fri, 31 May 2024 07:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717141773; cv=none; b=IuoSdVk8fd6SgxWbArg3biDcwQ6Zk4xKnsUW+DPl27VXHIgZCY/CSRBminaPEA22vl+ihiVq3Hee0y1we53Ne1WD3yAg66oKUulAliOmbKMyjoagossxCIcqu5yLRv+9tDB4wdOfwOWUxl6nIiSScu2+TmH4suMtlL7QLgMGEWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717141773; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ivLgO71J+cyh3hDlxzGG4SLulkzdj66NfcwRv78AjL+fkNI44R0rLdmkUAcghBXNessb2CsbH6R3FKkuKHCJtBRMl7XmTnCVa7b2ldmb4OSivwzrA5bosPETAudy9P6d328CjvRZJ7RzjEuD3CPlkrCrxgNirjITho+f42BIYFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MNeBDiV2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MNeBDiV2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=MNeBDiV23o3NZDaDa+MfqdLG4q
	40M+TtCTS81h+4lu0kEGliFQA8q21hfBCh84nwyVlG/5IXMy95GAhGNKZwBWM0LwVtNNLnWtEqH4H
	B36poDOkZ80bz18N1E/SW813cP1DPxLFpQvvZy0Z8M3xoOf9jfGTwBSZaF6FY6bPjhNZkaOgnOQVX
	fTaWFjwUzzwkefoO70Rba91TM7/TcT/xUGWqN5TeXI1QPQkweH7tAshfbRokLH0KwuPJoqBQF4FdP
	a2OX1x58NqlIZsD49cMl1pmBNIeha+PDN3FPbL1WQQflByK9w+tjXKHD1frgw6VG+8He0SmyhBtLF
	LgzO3VhQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sCx11-00000009Xtw-2gJC;
	Fri, 31 May 2024 07:49:31 +0000
Date: Fri, 31 May 2024 00:49:31 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Reichl <preichl@redhat.com>
Cc: linux-xfs@vger.kernel.org, cem@redhat.com
Subject: Re: [PATCH 1/2] xfs_db: Fix uninicialized error variable
Message-ID: <ZlmBCxzm1XCbdlgJ@infradead.org>
References: <20240530223819.135697-1-preichl@redhat.com>
 <20240530223819.135697-2-preichl@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240530223819.135697-2-preichl@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

