Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986B5244694
	for <linux-xfs@vger.kernel.org>; Wed, 10 Dec 2025 05:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765344540; cv=none; b=Udfkso9jNckzeohxTO/n6I+nel+Hs9lfNL86WlvqGEdSw6GLYc+/B/025eb0j6AbX2Wwi9SUJix4jeciBu3chMtqN8WHfdSPwipdka33sWWQk7OK9w9EAeaHOvL8Ry49CV9JLIjEvkJoqfj+JLniUn4AgHPt3NHlLCf6dFhNSco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765344540; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DeDD1Z4XsEvC6jbh31Drs8vb7T9uLMbXYcpiQj5osIpYp6XWMmvkGGUKkjQHImXyQliHKK+brH4s8uJnNG8PKO4JwZLiQLQXv3p+z3XPmK9nLrGrn1IZKGcuGuO1iMzaK/hFhDePgVwGchOEh9RdS4CCg2FaIknAQcYrHHEvotw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sO4Meo6z; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sO4Meo6z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=sO4Meo6zb8UjNEKPt+6mWeN9Y3
	R0ra7UDcZSzQyzpl8G+CZaHkM+jM68p+DO+tySC22CbwjuyPLQh1SsVzZCzJrZ9JJ49oQDK1FnnlK
	x0zTdfeiBf4UVWh4WFywqAsdxYCwVZWXrfzjhy7FnXVM2HFX7f7MhiCqT38bbF7+xSeosHPw0blAJ
	R8/yBnhuq0ddxL/TcQ7jXM1hEylEc7V1rzADcZeegUgDZSjibwNtrGmIvNqgBzbq3m2gR0OUJ9Jle
	SxHyG38UoSHi3LnCgmpbv34AbYsh0s1ECBPzESoySjzgvlh//NgdhI9vevVLb4GplinBBpCoD5n+S
	1rPxHdsQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vTCl0-0000000F8Pe-0qg3;
	Wed, 10 Dec 2025 05:28:58 +0000
Date: Tue, 9 Dec 2025 21:28:58 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Reichl <preichl@redhat.com>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, chandanbabu@kernel.org,
	aalbersh@redhat.com
Subject: Re: [PATCH v2 1/1] mdrestore: fix restore_v2() superblock length
 check
Message-ID: <aTkFGhTrkgwZcw0e@infradead.org>
References: <20251209225852.1536714-1-preichl@redhat.com>
 <20251209225852.1536714-2-preichl@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251209225852.1536714-2-preichl@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

