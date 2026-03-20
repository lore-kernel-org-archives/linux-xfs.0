Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E38A62472A6
	for <linux-xfs@vger.kernel.org>; Fri, 20 Mar 2026 07:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773991160; cv=none; b=TV+s/m3opxZrGM2ZaNzJFQHePJkBCSaLphsGW0hEQ55lxdQngXBVND4XQ3UK5dnVMZ7qeuYAkFYr/CWScG0hj498mv3TOFnW/xL0D4/mSQzQaWVSbIdNkdFiw0NaUFhA7W5hz3vWxk8IPwguHzOsTC0VgQfGJt1Qgy7/RBcaUYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773991160; c=relaxed/simple;
	bh=GGQTKLkyR5yJZEVWKEwVfwIMY3cS5e1j5dtDyHjgPsA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JQAGx+aeCkxUVuoAmRsm3Z2BdhleuUg8Ug2gfkrPSXvdzP99TozRREP1ASPBkEriC/Rpd0wRhAy4GBlQuGzyIPv37nwKgUyF9kdSodl1IlOcNdj5ItJEMpEGioqG38Lq7p2kT91coijerLIbF2QjAZcOrgAhkij50mhZL9tAJZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Du1dbV1/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Du1dbV1/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xU/qOUTSSy2RP0a4b5aDKSVGnZwQBey/7LDI4lNmKys=; b=Du1dbV1/sZyazJUeMQ0mssqd7D
	SNd0Y2qrn+BYG5+IjeICdTebUD+QcRPTR3Yrr+SYg9SifnHXy6FXbH5Fcdkuvqw2SURJvcGdYTH26
	erEjX9MKww6j3j4YCtvGogXFjxSn5qUampUhvSGLMSoczL+CaLl4QRUX0j0mJZOvhEwKtZYo+6AHV
	YkIMRqSy7NCYYOHiLBZYzCUp7Vd4OHeURPHsLW7vcJK/xyOYasxEkrZw+6++07Nf+UL2GFdkKbFlH
	RDYmwaltnNxddujbwNAkqdjR2H4Y/+Mcf74qgtaqps1asP97jAMK3zYTCxawhkOZ89Cubohmy1oSw
	vrdTkxmg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w3U8d-0000000CEX7-20eu;
	Fri, 20 Mar 2026 07:19:19 +0000
Date: Fri, 20 Mar 2026 00:19:19 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Long Li <leo.lilong@huawei.com>, cem@kernel.org,
	linux-xfs@vger.kernel.org, david@fromorbit.com, yi.zhang@huawei.com,
	houtao1@huawei.com, yangerkun@huawei.com, lonuxli.64@gmail.com
Subject: Re: [PATCH 1/2] xfs: don't allow UAF in xlog_recover_iget
Message-ID: <abz098auEFKW0D-m@infradead.org>
References: <20260319170938.GS1770774@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319170938.GS1770774@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

"Don't allow UAF" reads rally giberrish.

On Thu, Mar 19, 2026 at 10:09:38AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Fix this function to avoid touching the passed in ipp argument until
> we're 100% certain that we're returning zero.  This avoids creating a
> dangling pointer in the caller.

Why does this matter?  The caller need to check the return value.

> The xfs_irele call in
> xfs_attri_recover_work was never correct and should go away.

No idea what this is supposed to say, seem unrelated to this patch.

