Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39FCE2E7F3E
	for <linux-xfs@vger.kernel.org>; Tue,  9 Dec 2025 16:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765297374; cv=none; b=he9j2R8+2dhOxiyuSbN4q35W0HLA3aqf+8jwNLYYGSfu3nOrzyY/al3IQGM50NU0x0j8JeTh5kcEzh5XJ0z72PYZSTOB3yyH9u9D6KQrF/G/T1DKR86kDuMw1qJqrVaKGRkHPGfxtJdtVtlxrRiE6sGdDt7fc0r6Y4OiKbDW8oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765297374; c=relaxed/simple;
	bh=LJD6F5qlNgwrVtou4NOKPINO9kZwA7CxKPsz1C3Wqj0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fyiL/GDCRG6Bc7XPmp70hZPjqV+rmYqFZYOI4IHGkIYpbzPLdoWB3HFtjadlMXGUqHkCT8V3tmKK9QOCTuhxx0Ph9vKMJuWwUw2CVwPqAGky1jPSr8YpWgYGkkn6P7AYzIOjOyy/J+1xTb0mHe7b4tlzp0ENVCrooI+fKPtHz+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=l8ceEOJh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="l8ceEOJh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4digs40Uaus0YPCBnJ6MDKJzoum2RyTSgHTLFKzWOzE=; b=l8ceEOJh/sJsB3kAccQstux/qq
	ctsmgPhJ+TUin8DCY7Rv2XDQ7/wtXNwH1daWgO1BmXCQdpEJ8huSlM+U6jq9eCKet38fD6nShsLn3
	1DzCwP2drOC/NAk6cyL2tslXDPnS/D7YAHLDdBGr62gMMjZgHQglnTJLKrlIRV2+zOolWExlEPvPK
	hdwTkLsLo9jIn5uWNjY1WylNooSWn2nspUkkFF3CdpRczx65A/4E6eWUFqxcbi2iyX1a4MqPIqgNh
	dJRlwHG+Kkjpntyh2TKmVKwt9h87Orp3JUaABkMrg3QwfyCaCbGUikgBRvq8zOCbixnW9NpfLUYjs
	ALLvOIQg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vT0UE-0000000EVvY-1ZsU;
	Tue, 09 Dec 2025 16:22:50 +0000
Date: Tue, 9 Dec 2025 08:22:50 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] mkfs: enable new features by default
Message-ID: <aThM2vS1QGeHdLnz@infradead.org>
References: <176529676119.3974899.4941979844964370861.stgit@frogsfrogsfrogs>
 <176529676146.3974899.6119777261763784206.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176529676146.3974899.6119777261763784206.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Dec 09, 2025 at 08:16:08AM -0800, Darrick J. Wong wrote:
> Almost no difference here.  If I then actually write to the regular
> files by adding:
> 
> -f write=1

..

> So that's about a 2% difference.

Let's hope no one complains given that the parent points are useful:

Reviewed-by: Christoph Hellwig <hch@lst.de>

