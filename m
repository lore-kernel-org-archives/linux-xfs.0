Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793202653;
	b=4J6OQYHakoGdwGd01cclCq4PI8Pn7bHmDFKTtZqX84DOTN1OMrXo0FRUC78gwB2N3yFD
	 zUpKjMPz61D9UlYCwx44Uu/Mll2GGwy3fiFhrgQvyoH/T8PyrjvzuresFQ/PK4JzBrtph
	 B3VNnLq6fQX7Af/HRB3MmIQHLfp+2Ny//Mtv5EOsuu+eIAP9MWTJSEIyc1KbxKIf59snl
	 vtxGOQE2PZTX1FL6wGyELygPgHogm3BGGFqKOFRcqALAtKL+ug8oVGmCEDPe0rQhc1eTD
	 ldX/495CECcFPq6am1t7QhmXwbvwdYX8/YoP4UcrS+8uTo/4nxsNDRfQWpuZVcAaXYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793202653;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=ojH56pbLsuYQgzPa5ZrBhp580AgO62JDw7Cn1cR9dtJW19xONKwFbH2zyMlReQWIq/QZ
	 j7mDHWk3HlCRd2CPePsWpz90qkEK8ogTJ07cLL3nxNRz6UsUIff8WE2vdpB+tnuUkZZFS
	 haAI/DRdOxey9VuMwdHOXPqe4gPymdqm6/El3XAh4Q/GQB7MHcTCLsoihq+aDoK6hMa2g
	 4mnjr0Qsw38sq0BODOtm64aGo7t0Vy7nHEkTdIZdrgjvD+8RaGCaAwGK3/IXzTZ9TbJzi
	 4r4eGTaozzGg+fmU8BnI+wDqJySg+gGeDYV/imGW033sEV9LQ+nEQpTJHDSN3P3M1Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=zfX5HmSw;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D841606A31A
	for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2026 15:50:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6D841606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=zfX5HmSw
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=zfX5HmSwA1wg52ysZtwtyfWawX
	amjqw9ebIKgHq7TAIM0/V6/lf8HHpfj5A7QCtJ/cKxh7W2dfgXsh5DRYINqEElasyvwWZicXLo7mm
	5nGOerk+4M7Qm9U2gsJeyenr/2qk6g28f9uqTfqgEB6k8aEk7sLQaZrCpPLnRHiT/2OEh4LfQx5hd
	3VV0HXIFU6ATl71aukfhyQltCqwqoP/d72Y+mGXhfWgYV0Bn7ouUW1NZ9Q2MZmJmp6UhjfZi9Al9o
	l6XBQj9E01qv/B6g2T8oUkPaee3gdw/2wc9Jg0IeIsLXxLY+rR/7Xt42NQn0bzuX+ULAcZGFQCA2Z
	ikfv9law==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xM5vQ-00000007Sxv-3XsA;
	Wed, 28 Oct 2026 15:50:52 +0000
Date: Wed, 28 Oct 2026 08:50:52 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, dgc@kernel.org
Subject: Re: [PATCH 6/8] xfs: add stat check to xfs_btree_delete and remove
 caller checks
Message-ID: <auIZ3JFk3WBjB7ha@infradead.org>
References: <20261016193422.1630907-1-sandeen@redhat.com>
 <20261016193422.1630907-7-sandeen@redhat.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016193422.1630907-7-sandeen@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

