Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795192691;
	b=5mdzvHQBQ25HLtu1UueWukiifP1R7lBo7Me4caHUKey/KPggfMMMdmhvnQhu8K4X+Uk/
	 rX9xsnrhorhOZbA67PrEYnRmm4yOwxYaHM2IrDtB24ECwiz7j8pjaPCouDF66CRYHZ/qh
	 axloI38IQewr3J9N1U6lAP4Z+kirZtLLBuGWtPiXU+Bazxg2Y6feZfZCSif3V0iLxtqn9
	 4exl4SQQrGwdO4JusI5XTssX6wWde+diaik7ohAM6k0FAMLvtn6Urcsj1xjW5puLisIcG
	 TPHm0vHmoQVMSWgADWux09VNfdd3YV2KHoObxlENj41/evt/B36YznMe+IvMv5/X61A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795192691;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=4QTRcICLrduFU/T9ImV5LWu8IPqrV1Nh3ec8xsIiVhY=;
	b=L77QgwVVEz28qlOLypjr8Cq+DoA4etsdaP2cN1MJEdI/i8AQG9sZpr8HrXVCCmQj0xXU
	 DQ4+gcygao4Khk4f0RxkLfvVpGfi+HfhfXeiYmuYyStwxnL+rLU0/pSLhPC8wngkRBkXz
	 Q/h5UrFsKxm9TiyGpotZxfCy68N1A1/4Y0tFecc5/ZGsJrjSW6s+1unQhEEL/iHFme0n8
	 owaHlsbcq6wE40dNXzT3W+a2mue4obau8r9B7XQ17FoFb26MgXPhaCHc3En8Wt8m1bM1H
	 DEaMIKMzQvQe1gf0060fsUWYMm9obQjtUzd/U3jyGKFitmP6w7ees5BYsXIVwLBu0zA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=ciuJXH89;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE99606A335
	for <linux-xfs@vger.kernel.org>; Fri, 20 Nov 2026 16:38:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CCE99606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=ciuJXH89
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4QTRcICLrduFU/T9ImV5LWu8IPqrV1Nh3ec8xsIiVhY=; b=ciuJXH89vlAzr5pyyY5oTv+aRW
	JD79FDqiVGxGh7WEOqpCaSiAMVoxM54zRFD/sosecUy8eqxKshx76DCh6kXnuGQwKHxmj85shhtao
	0Sg7b+lIAr4weq4K+8qDDFqsraKSWutGxieXVTdN2hHCyKtaCumcrj3RStHctIzoQYSubtymf/FpJ
	Vpg58tJfl7UA/OW76QSeLRqCjuJ85ouqLacCS54f98eiuELPdvbHqZcn2Ml/oTSCxUAiH+1YKPTXc
	Fsb+WobGpqyHBZmBQEtHLPymPpL4NymdJl0JX+KDE8U9bNpmw4pA+C6hVQczy+LHZIc9SPy9MABGZ
	m9KSSjWA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xURco-0000000FZZ0-1eCV;
	Fri, 20 Nov 2026 16:38:10 +0000
Date: Fri, 20 Nov 2026 08:38:10 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <dgc@kernel.org>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH 10/59] xfs: check the atomic write reservation against
 the current log size
Message-ID: <awB3cl3D4MKNfXak@infradead.org>
References: <20261116231707.3625263-1-dgc@kernel.org>
 <20261116231707.3625263-11-dgc@kernel.org>
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
In-Reply-To: <20261116231707.3625263-11-dgc@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Please split this out to a standalone patch and include John and
the folks have the other atomic reservation patches out right now.

