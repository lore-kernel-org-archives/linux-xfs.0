Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB823CF1F7;
	Tue, 16 Jun 2026 05:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781587343; cv=none; b=gRVTGce9JCjqg5pqX9xWK2G6xTZatP4TAWFwczPF8d7AAiy7lDaEra0ZmsbVx1Z74Kzj0y8+wm6YgOBKZAkCFhl33X84b/XRLb+LjYHaHksZi2WTtIU1s1pcJTqJYCxQPO/9UwGOcsWN3PLwegi3h9sWmMbpRT+ESPxmfI10X1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781587343; c=relaxed/simple;
	bh=AO0R3i73zkoV1h/YRI4gL531pB2V97l0fTNm+wMsYCQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q+pgTYxIMSU1e+99xVveXtipUIHqU9urRmhD+qYXqPCH33ARyIc3aSutn5iQdD2l5GDzc9TiERmtWZmV4qUQbYvdmYewMIDaKPpkJgynmSNYqhiDEGeczeqQhcHR8wuFwmsCSPxC6dBl67izprav+LHFdzFPgIk4CCTi3sBIAX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jisRqxu0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jisRqxu0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6J/wMsQ5PiorzLut2sK4jGjGq5nrbXyLz2y4LXtqPT8=; b=jisRqxu0Oe3yCtxJ35J0WiW4tY
	n6chWTmNBGQurvZY8cvEhh9QNUPLbOPGoUFRxHWQd1dym//edE3uqhfiQBWXZxYmHACwBNs06UO7l
	/XwJptAGYB5Tv9xfdlA4kwYP8yL8w2HGkFhJ6YCYxe6lEx/KWVl+CpmxuURyeVDxFenHXhuT/T9lT
	cRn8wfcF5kwgfNkjDVk4aM/0ntBaa5+D1AuIGUTWbT3OW+ov1bpr/BXUVRXnPeW2MXaJ6emZuLvhU
	z4rirIHle5M+/lVCmut5w4AW3Bdvj1M6I6kciw0efS8xZQNx7qaWI3V8GWx2EyrW43EC5mucfx6gt
	9ocv+FNA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZMFh-0000000FFAC-2K3W;
	Tue, 16 Jun 2026 05:22:21 +0000
Date: Mon, 15 Jun 2026 22:22:21 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Aditya Srivastava <aditya.ansh182@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] xfs: prevent close() from hanging on frozen
 filesystems
Message-ID: <ajDdjR-Y4xwvZ3J4@infradead.org>
References: <20260616033821.2238-1-aditya.ansh182@gmail.com>
 <20260616033821.2238-3-aditya.ansh182@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616033821.2238-3-aditya.ansh182@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jun 16, 2026 at 03:38:20AM +0000, Aditya Srivastava wrote:
> Also, rename the flags parameter in xfs_free_eofblocks() to trans_flags as
> suggested to make its usage stand out, and update existing callers to
> pass 0 to preserve standard blocking paths.

It is only renamed compared to the previous patches, because this
patch actually adds it. 

> -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
> +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, trans_flags, &tp);

Overly long line here.

Otherwise this looks good.
