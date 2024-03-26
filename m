Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EAB529D01
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 05:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711431159; cv=none; b=ghc6+dsUVeu1HJCi59mgJLM3g/Y0tag0FwKqJW679LnePWjxzztB/vYgkxxggRtB/+dkt+cesHO1xlVJZr5VP/MbL+5q/aogvH5o1D0GHIMD93W/BQh+VC4/vpP4NiJDspVwiZ/WLcRAoka50tsUYpUHB1ne9TYHcSEN1UHa8dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711431159; c=relaxed/simple;
	bh=5oYrPEq7ePnU7MXOjduKXcZdBvaX6uPw8oZBAHIWECc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HdiH870DVgU0/DDDt/WnRwVhMQSrtCDsqiX8e2T5hryVw/O+U2zEF+DXxr8u02y53bH/Odf5TxJMh51iWVyZ0PFV+Nv9KA4bLXFp5SbSdFErPY/gYD9v2l9BcfP/CX6bumILLGnQPEKlgaS1Ku0ClN4EKGSRQ5LbMTcFZFLXTTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZnPW1uuf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZnPW1uuf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kVIdPQlalSZUu2E3FYlzWfmmqG6wdSgoCpdcTjEkkNM=; b=ZnPW1uufsxNBJbyWqCLnebBD/e
	uEwqkXpr3KiKTabr/PegHmmGG8T4YHYYip2nzhAK52UiMOEaM4Y+/yz+r3sStBi1QbjDp2gPc/x8K
	UsM+IPDXWp6ZS/WrcVxcxJ8Nfy7cNOxVN0aKsTrxgvtNcBC+EBwJ/9iXaNeTCk+k7rn1pdUTsrBTS
	uMiShUzG8mzQ5TDvSGUKhv6S25cc5OrTL60n41pAEq3DoQaykBnDco7e6Y6nyFT3wmERWvM04VBZ/
	nFbIa8pLbGprYvMwPPEPkZ+m5Ms2swFIU3Vm3pSPSLa7HpVW/GFOZ6b50LqZYUZtBn3ZELdmzYjYD
	GgtYVn8Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rozQL-000000039GK-2zDt;
	Tue, 26 Mar 2024 05:32:37 +0000
Date: Mon, 25 Mar 2024 22:32:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 094/110] xfs: support in-memory btrees
Message-ID: <ZgJd9eJ5qbiX0fPY@infradead.org>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
 <171142132733.2215168.1215845331783138642.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171142132733.2215168.1215845331783138642.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

>  /* no readahead, need to avoid set-but-unused var warnings. */
>  #define xfs_buf_readahead(a,d,c,ops)		({	\
> +	void *__a = a;					\
>  	xfs_daddr_t __d = d;				\
> +	__a = __a;					\
>  	__d = __d; /* no set-but-unused warning */	\

What about turning this into an inline function instead of piling
more hacks like this onto the existing ones?
