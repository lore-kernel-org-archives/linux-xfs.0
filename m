Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B274A2A1BB
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 09:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734081488; cv=none; b=eGr1CzFG+3rWVCZFLv/EB01LivZhIEC9Ez50WseRmmMBzmw2Mafi9Iot02aJ63ENhyNdHn0vTQvl7EZP7+wWlHfVYzallvschCFVaZCMXJuF2vBWs80V8WAiPFs/vcFsx2YVH7GMbwjM8rWwKZOZv6sB38A22+0cKbeLj9h3pTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734081488; c=relaxed/simple;
	bh=vx18p9Ot4i24rwUHHwiPgko591C79u1EmwUcH4hhiF4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t2be6wYKU479Ay30FKDscPpV/3vAVjP+H2jVz08flvyjRvnK4SNBjJYpxNsu+/7pYvO7UcDlu5kWX31Lwo+K1wk3UisQaZjKRMmvr+bdInfs/rMqdZ42MpLeD2L+j+OhJ13pvr/w7SLNxR82mUgABkzRMfZ7QmI1BHArNvdIXw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LZ5awyh0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LZ5awyh0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JpQvxVDKpyUTdnwCpBAoTmVbylAyvpQ1b2JB53XaVkE=; b=LZ5awyh0j+NWxQ3KL1I0XClshj
	hb25Ae+CvYtlUFUN3UmmiREMnY07aYcWcdhDcQMZhsmGcdj2AbqpGjQF4vBM/uypAoTTQ/SrdGhad
	7X7xchDsEzP0W3jo0sUl589kKzGINnhOLoOlyrkcBmLH7XMn8pC1FcFkWm1SgS9QYW1/XJSw20OdW
	Sv03u9VNioD+N/nu+LNR6EhJLFY/QNHcN99ufu4sNoLciO2MjgAAUGA3rcxMJLuzLwSjlWwxPRYUz
	D5QYWpX14rVkhuByj3SQ0HAMqAmeUiSImd5B1N8NDWwizD26DWk3P+q15JV/tH14raBlv+vRVwbDo
	/+B49z3Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM1oE-00000003DfX-1nEI;
	Fri, 13 Dec 2024 09:18:06 +0000
Date: Fri, 13 Dec 2024 01:18:06 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 28/43] xfs: scrub the realtime refcount btree
Message-ID: <Z1v7zpBiiZ-G_sB0@infradead.org>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405125046.1182620.123195236500556349.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405125046.1182620.123195236500556349.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Dec 12, 2024 at 05:17:32PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add code to scrub realtime refcount btrees.

Please explain what that actually means here.

