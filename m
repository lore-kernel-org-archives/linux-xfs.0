Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F0B25765
	for <linux-xfs@vger.kernel.org>; Fri, 20 Dec 2024 06:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734676931; cv=none; b=BcfaqZ4EzssoXsMtfHRd7BSxyO66CL6OgrhJ1aeE+Il5U9zXvh8mjodPEwTbB1aFYXA+/IPHLop4fUf3y/HsI0r9BIhCBQL6Rlkq40Ff5d01RCy9Y88soc4J+PefpeM6ZmgA3kflYzAmxze3gbMlN/5ir9BFEbmanOeRTTfWyIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734676931; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l2zljvaAeLV86A4TN276yB2CR69GomExaqkmRwBzStBGHZK1JEUgUwG4wRCTjQAllP+ZQ9RcixwZUj3jBf7LiK6Hn/K32EgZA3nm9wwKMGrQFyJdbBQTbLc9kytLR2li/iJmY0hDmKhWZVOrUG3zkLZKCssLRzHV75QCDsvTcs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=s1YcgwMW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="s1YcgwMW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=s1YcgwMWRHX2GZeojNARUFUDh/
	VavaumJHS7oT920HkAWf01iMnYJ3vOwsymwPRgW2guYMy2j6EbA1p+UehEGHyN8K1M7kHLFGM+lcs
	x3jIwfHnQfdapfQ6316/e2e8tWI+UtKG/ZqAzctqHoLEInkqTx9HRXTY7QDaAh3+fiAf7LctMHZL/
	hrD8eCtPiRyWqMQo6i/bZzBZe/Oqtu53ZmbPQyclTr24be1eyUAjpocrBM0FAm43pUudIPoim3JDn
	t6oNbTUPBmwLJ2LI6eH9NfhbzRuLZNQTfmGiYeQoltn2mtgdta8pC3kjNKUsFOLEkghtSVE0eiUgX
	LReJ4mtA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tOWi9-0000000472T-3Hla;
	Fri, 20 Dec 2024 06:42:09 +0000
Date: Thu, 19 Dec 2024 22:42:09 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 37/37] xfs: enable realtime rmap btree
Message-ID: <Z2URwWKVbgHqS6BE@infradead.org>
References: <173463579653.1571512.7862891421559358642.stgit@frogsfrogsfrogs>
 <173463580394.1571512.11770786654773758153.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173463580394.1571512.11770786654773758153.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

