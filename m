Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7671865EF
	for <linux-xfs@vger.kernel.org>; Mon, 28 Oct 2024 08:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730105016; cv=none; b=iyR2aYPfrQ5Wj4vqubLg29XSiKZSjqTq9SOauFIwb0hEjtN2h7oVPBNFuY+Ih6z1BlFRN3KP94XIxWFOMzEhyt9Mbny/B727gUiWweNIj2uJD6AmT3SmVPN02jtnealrA5ALg5TjNeWuxHTjH/qo6LaCHoHwYRlXIYdDJeXbiSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730105016; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G9cpxYUC2udIJVEcF/mRomARAdh9JCjSSpKOk1bZ9YtmTPI8Vh/yW0LCmDQBlYFWT0lvADQrDsa7bUW7oLmulmdcU00EA2l3BfQRlkbPpPmKNSUKPzn14arlmPntaPCYE/DPWORoXtD2g1U/WxoxxZOjXsSEObbLYwJDNuoztKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EQI8P4j6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EQI8P4j6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=EQI8P4j6Dr0nvJwu4XaqI7RNer
	ybl/Re9pZh/UaN7UTChfKYMkJDOWohbRqRuq5gDutcfS7eO+fue0L47i9q9APKyyDvlfVwrQn2yFg
	rNlMBFvYWS2UChwdha2OwcQMPa8rBR21KiXOjPrypTUrhcUVHFAzJhOUvEE0p0410TmnnWKU6pbqv
	gyyAujyJTWw+QFHbWGxPQYhAAr2zQiEurno3rtKOKlg6hGOBejHDOVjxyN76a9+FmNQKb/DdAjrlH
	ykW44sAnGEN0HCqrhptohtaUhivxn+Ug5VqkDT5WE4U5BeUGHT2mcCOGA3ma5AVBttgdkMrnvofnV
	2dRVsBgQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t5LLb-0000000A89d-0EDa;
	Mon, 28 Oct 2024 08:43:35 +0000
Date: Mon, 28 Oct 2024 01:43:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs_repair: checking rt free space metadata must
 happen during phase 4
Message-ID: <Zx9Ot1MLRNS_r7gH@infradead.org>
References: <172983774433.3041643.7410184047224484972.stgit@frogsfrogsfrogs>
 <172983774454.3041643.14059149217223950457.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172983774454.3041643.14059149217223950457.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

