Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B66B13A25C
	for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 06:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714111799; cv=none; b=mR1EGzVCGSqz7l0QVirG2zzm+UfN0Bz9m/BsGB96cy71xjsV8riFOYzEL5a8p57heLR/JcrbJaO58HIvl7AqZWWpTMTn2SzqRPY4n7C1tfBJdrDUhjyqgA9RgA+sa6UUkakI8RFAoxZwkUpvl0lxrwYJ844Kee4r6EwrTDPsDKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714111799; c=relaxed/simple;
	bh=ZQoMYJlAwr6EOpLWzFADOVECPg+1NDNu/cP+bNWoOPg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pThIg9b9teMwxVkQHLy2ofvakGO85FgtQuvKTX9vzHeCeTGRdXZBpBvRu95faIm1DoAyn9dtxJJmmWlgMwD8IuAbaFEPDlIDXRSyzpyQx8vLYJwFBz5hOOE7ds3skDyX+wiRPSdE9pWdbgcEJHNtcwzohiVEiScs6L3DpbttNt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JtrCaky+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JtrCaky+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=IBzP4s2/Y5phuv4sMsgxT9BmNEWdqCLTmdumd3bsaRQ=; b=JtrCaky+ix2L+voLq6Tm6Iu6Fn
	ZoNej7QMm8C9ixyb9dGsZWd5d3/+8ckT3sMOtQNKKsHIWIhTmah7BBao3zcA+Lekax8zvffoeMmZ8
	usVcg3Ubu1sJQhB9sAjhX2My1A3jPi/KVe/DKgWpLENlZ+Y2tZclkArFDwOu8myWUB9ZD6Cnd3282
	mOzhcRtJP/7xEJFouDmgprNrzQKil9RPqavtDqbq7GDHeJsww7qLPSq+VfMA7iuAchEKno5vGPecQ
	vt3j2pgYj+vHHeJS3ZbrIG0gRSxFkgQZq+etyBOP92d8QEknFopQ6gKoXKxB9AsDTfznQNIc3qEZ2
	fAPp8SZQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s0EmU-0000000BFw5-0BuM;
	Fri, 26 Apr 2024 06:09:58 +0000
Date: Thu, 25 Apr 2024 23:09:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: John Garry <john.g.garry@oracle.com>,
	Christoph Hellwig <hch@infradead.org>, chandan.babu@oracle.com,
	djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: Clear W=1 warning in xfs_iwalk_run_callbacks():
Message-ID: <ZitFNj3Lz7u70TVg@infradead.org>
References: <20240425120846.707829-1-john.g.garry@oracle.com>
 <20240425120846.707829-2-john.g.garry@oracle.com>
 <ZipJ4P7QDK9dZlyn@infradead.org>
 <01b8050a-b564-4843-8fec-dfa40489aaf4@oracle.com>
 <Zipa2CadmKMlERYW@infradead.org>
 <9a0a308d-ecd3-43eb-9ac0-aea111d04e9e@oracle.com>
 <a99a9fa0-e5ab-4bbf-b639-f4364e6b7efe@oracle.com>
 <ZirnfaFFqqyaUdQv@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZirnfaFFqqyaUdQv@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Apr 26, 2024 at 09:30:05AM +1000, Dave Chinner wrote:
> 	ASSERT(xfs_verify_agbno(args->pag, acur->rec_bno + acur->rec_len));
> 
> 	or:
> 
> 	ASSERT(xfs_verify_agbext(args->pag, acur->rec_bno, acur->rec_len));
> 
> The latter is better, as it verifies both the start and the end of
> the extent are within the bounds of the AG and catches overflows...

Yupp.  That's what I mean with my original comment - once you start
thinking a little bigger there is usually a much better option than
these __maybe_unused hacks.

Using perag fields and helpers instead of raw buffer access would
also benefit a few other places in the allocator as well.

