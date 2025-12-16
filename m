Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79EA333750;
	Tue, 16 Dec 2025 05:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765862323; cv=none; b=fLex2k8Wu148cYLmXBkCqW5T4bMGC96DO6U0TjhUlnU53/zhMvSQe0CBVB+5tzeBep89rraMnSjAXCq3KwD3veauiGT8RyZPm11GMvv8CAPBy7FThanposvYxsDlIBR0J2OxAM1bo2HLZZC4VrRVz0xJV7nMH2AQY3/iVbF6WQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765862323; c=relaxed/simple;
	bh=ie/dAP2vSxyUypNyqwbPenj8vlG7eJDf1SvMYeaD6tU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=r2hFdPbLgLFktlpR8Xcmboq62nipck7pqFdM2YGt4O1Xt4WcF3kpeKOuhQVToiRnVAxYZZvtaXnRQkOEN93ctR0bO5ioDolPwemBlvbWLTx43ElcYrrguVwmuMXsgBJeUCOAb5FU2VR4fwIuYbO8SYP43CAHDw/DnXPSS3z8K54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=u5p4/Imh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="u5p4/Imh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
	:Content-ID:Content-Description:References;
	bh=i7kcAGFIMdwm+ifemQukojlEG7GE8Z0FP+IV/+ttZfk=; b=u5p4/ImhwKqO+p6zApsBAmR5H5
	nTfl9oSUeSDVauPi+gv6Y+LMJa2yxl8m4LMIrIYvqSXN6WiqBLzWBthHLCgD06GN04uIKV5BCxNwY
	TsTo+40lpX8op/jU2QQwe3nLAw0izRWuU2PzAZzFKsWhWkRLiV5k+odW00qbWgRuvLV5gfLOudBc7
	NCBySHjyfIj5v7pQeejmKFEBJegTMTlaMDXABLQcVSYUvBb3vyG7SAXk/13KsAcPtAdC4N5BtoVmn
	j9XNSJACncsOBi8TFtwqITrYs8y0iEidcaSdii8MQ7sgB9NVMCKvtNgUIc11IHR8d4Z2tWZLcc/X+
	obMmViCQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vVNS6-00000004i6E-3R2G;
	Tue, 16 Dec 2025 05:18:26 +0000
Date: Mon, 15 Dec 2025 21:18:26 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Luca Di Maio <luca.dimaio1@gmail.com>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v4] xfs: test reproducible builds
Message-ID: <aUDrohDpd-QqxwXS@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215193313.2098088-1-luca.dimaio1@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

[adding the fstests list where this really should be sent.  Sorry for
not noticing earlier.]

On Mon, Dec 15, 2025 at 08:33:13PM +0100, Luca Di Maio wrote:
> With the addition of the `-p` populate option, SOURCE_DATE_EPOCH and
> DETERMINISTIC_SEED support, it is possible to create fully reproducible
> pre-populated filesystems. We should test them here.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

