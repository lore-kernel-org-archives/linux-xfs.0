Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F9A37F319
	for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 13:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791811430; cv=none; b=fQg3wa0kyPQbHmtIPeMpLw8SJAyA2u/rfReOAlMe/al/i9ugy5VeWW4VAxNsGlkFal4z7yUR/8w+38f7GFQLO4zqg2rAliVdOuJpPEV3EKeQIEd5GldAibqfLB1cENBxgkiO0OQG8bTDo4zmkBs+bHNDrFw6vbk6JJm3nhpDUzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791811430; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lnKDSxAzRiLe6vaBSgdG+ywRt7ugynoDbPekj0OIK8SBoSEfy9PQPC7RSsH2F0nA78h1TIuc689xI7P+uVDjrFUym1rRwLZVhd3IX7k+CHNyDl9zya4tsbVjE/aH6Fn813l+4kIH0kVMFplU2fFeACEhxRqKM46NnP87Af2HAzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=W1Wo7lpk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="W1Wo7lpk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=W1Wo7lpkc1c2e+9Y4NLujFh2lh
	SvnLX554ZguzELE7kb/HLyko9MLXMxK6sYnDBHF8BVu2pVyD8tHarsTuGeuxT1cii2jaDSv9aeX4U
	PIS0mKi9PwH0wArNCGizzZR7hTbyh7AJt5I2dJtdlVg0GP9xtdXmlRzq4RAQxYR2kxbE3E1EJkOfc
	DQVC5/m53Xg5jmI5GBuRBTsFxq5LKjq0WkRYHtJ++/Kdv5dQ0QSLiv2i9KBmEDO2AdNggOPkJB21/
	VmjDIsN6vxw2Yorc80URBdshjiLsK6t6ywWPvH535qtijQDPUXBTmCt7SFH/WFQUMq+c+PSQgu5Eb
	DKfGck9w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGG0K-0000000AYfY-40qN;
	Mon, 12 Oct 2026 13:23:48 +0000
Date: Mon, 12 Oct 2026 06:23:48 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] misc: convert as many xfsquotactl callsites to
 xfrog_quotactl as possible
Message-ID: <aszfZC4oT7ILbaIg@infradead.org>
References: <179158948034.3720791.6624320009127284341.stgit@frogsfrogsfrogs>
 <179158948059.3720791.17480133735576395572.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179158948059.3720791.17480133735576395572.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

