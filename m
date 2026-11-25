Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795590873;
	b=OwCmaOO/7pZJuK+avCtFT3N5i+1laGLqAwem4ehKXJsCC+vuOSNS94tAnC3uFtMfRL4U
	 Bx4uG443TKl4hM1C812mRebxPjpi0w3kd6IjIRwiRTiGKmsmpgaG4BTeLIBJWxYOqPB9o
	 79Fph5i20Fv/aVIaU8YpFCFuZTu2k0aUg2Ev1BPtXJHKGb8HcPjz3EEels0RwRh+3LhQQ
	 Qt1MUadkMtqieDh8ZkZ3KQN8q9aH935mxaeawOkoqCpx0q2LLWp37jTjGR0TLBZls/gv9
	 q0hFXGahqUIzJPv7srrvwH29/mnH+iJtw581Ta/ouCXUAutYh+P4Y1/14lNF9z2zGQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795590873;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Subject:Message-ID:
	 MIME-Version:Content-Type:Content-Disposition:X-SRS-Rewrite;
	bh=9EEcVcZVuStp8meLy0BJ5xORrU8yy+LBVAnGNFuotMk=;
	b=HyqXvjMltixsyy+pI9Ajwl9jEgNeyxhwBMwIyEGCtrk2xJ6Npo90pXw2BML18PCbsxCP
	 P+121oGrOERLrzV9cstIi9AduknR1EvgT6J6l1azjnsNfwRnY7RE2TAdv9Ib09oLWsZq0
	 m/WUh6nL2lTHOJr7JVvYrE3d5MLEVgNznJrjRjVvnKU/4Qc3WsdY4EcksZz8YFr6jhy5f
	 ZynQvBOHKS+iDEhi6aH/Iy9GzmDN2WarhiXeE2Vgs/OcRJ2DWfqkMq8GdodBH0jcbsJh7
	 l1P4/hE9WVXEawXTmR+0916+5bBRA9M3AGxHGjDkMOO/jJiY0Oq8BlbAuZgsfpUvVxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=f5pjfJ3M;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C17606A685;
	Wed, 25 Nov 2026 07:14:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 05C17606A685
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=f5pjfJ3M
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Type:MIME-Version:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=9EEcVcZVuStp8meLy0BJ5xORrU8yy+LBVAnGNFuotMk=; b=f5pjfJ3MZr4Nyw4tlVJLhw6QHR
	XPcqq2R0A37IdKuEeAkLG+WKCMYpQYt78y460cgxxA3zFaWZQLDGfhHhpuGUFAdz8NWVmziSH8rOW
	dT3oknJSYEfnpQCqh3t1mYGVZ/cOG1gxP6YnYpPzW3MQi5jxUv+b8pu/nbodmQSCKoNYj+JV5JsvS
	9xq/1wNvOWQ49uhVatxz37sptrKzEOApXSho0hJT97n9ySmJBEMQncDsK8Q+sSR081h76OHjTvyqf
	F5dpSm6Bu0gzdvFx0+z4iFL7P2w7XPJ1lkl4KKBvjpalmweiuv01nTdoRWS1wuxf48RjR0jQShNyy
	/VrZfe/Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xW7D6-00000008pXt-1vWs;
	Wed, 25 Nov 2026 07:14:32 +0000
Date: Tue, 24 Nov 2026 23:14:32 -0800
From: Christoph Hellwig <hch@infradead.org>
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: what should we do about xfs/136?
Message-ID: <awaK2LnBPb8f36Ig@infradead.org>
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
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

I stumbled upong xfs/136 because it is the only test in the attr2 group.
It also isn't in any other group, and takes more than 25 minutes and to
run in my usual test setup, and then the output doesn't match the
expected one at all and it fails.

It goes back to:

commit 7dcf3ce6f95603965b51c53d0a48864b0c6e8268
Author: Tim Shimmin <tes@sgi.com>
Date:   Tue Oct 17 06:10:19 2006 +0000

and apparently wasn't run much at all for a long time.

Should we just kill it?
