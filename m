Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AAA4BA41
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 04:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712724137; cv=none; b=QN0iZ5x4dncCC3sUy4xNOgkTxtfP455aFotGz38mXmeMoK/Bub74iQxd80Fpl3keOnBGC49j/Fyvuc79ylwKY1Anx2ZPx3q1B9sZ08aWOmD0+zcBgiBFqTEQdR/NcqQECgFRYUOWVds4eDLNcf8jpE4Ds3Mn+G7yV6f6/kZ0MX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712724137; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XlKArNQrtoGz7GnX8nts92RODi/1KPP+OWDnajY9kvNPuXAzNB5IxWAo0jLkRenrhUuVsDEMxk4WBiycJXLHMQ9867Wzy8HH9W7KzLrp6n7JmbvBSIt1BtKXrQa7FGPOOVCKGwtgrljoexxN1JFxCqPS4LL4UbjiwTF+RUFQZDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lYMDLGNy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lYMDLGNy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=lYMDLGNyEx0Wo4i4E55DHQmssO
	oUpLkm9Dvaqfa56V6ql35H1sWdrCUBP/+RHJqS8qO8/oSarlmMeUtvFeCsUAM3YIKY1Pf9urze7a9
	sEKtNNh1Aywy9DrfsUjS5TZPVlcHRuxhFCKGKPKoNN540xt37WJhhXx9om1AHp1oMsYlwzIL3K+ez
	R+a7A7iv+P2SCg4hCxsCErV8byCH7u9GGH/DIVN0Pmq7yeZxQaMTzpSRUwXM/Sf1yvF3SZB4eFGbo
	Sv7gPqcKLV2ffRfcjgbn+TcbLQzoAjSq/QjAKLE/w7IwLSqP0sxUsZyhswopdva/rdfiAichPZ6I/
	xik3C5HA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruPmp-000000053pX-3SRW;
	Wed, 10 Apr 2024 04:42:15 +0000
Date: Tue, 9 Apr 2024 21:42:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Allison Henderson <allison.henderson@oracle.com>,
	Catherine Hoang <catherine.hoang@oracle.com>, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: Hold inode locks in xfs_rename
Message-ID: <ZhYYpxD28r70y6FF@infradead.org>
References: <171270967888.3631167.1528096915093261854.stgit@frogsfrogsfrogs>
 <171270967988.3631167.14801470316616286607.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270967988.3631167.14801470316616286607.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
