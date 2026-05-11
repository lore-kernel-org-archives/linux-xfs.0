Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A053290A9;
	Mon, 11 May 2026 12:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778502052; cv=none; b=Ltx2wyV4Xn+mCGoLWUfdJ3Y6cwPJkv3vEvrnY/Nbf+zLd++fqKHItWm/zTg37cZ9CJF18QfmZht5NkTq+MLrMSt4h+spq7+2mAHWD3ICdQrSjKJV9+k9tSEBMIEDnBVVMh/9UMQ8cXvUmk74+ZAl+RJxZ2G+WtUqIHAKiFbpiX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778502052; c=relaxed/simple;
	bh=TJgCyGjRP7Cd1B0AgdYU3HzVRQl07T0gvx/RLIXfjCU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A1uXy769uiNa2c9dbvsOiRfUUwnOQnpTAaudDEkvw2f4S5bwP/SpL8DmvxvofZV9wdIIqnqFAvKB/iB0L/ZnZoNIFEO/+ZUnZATZpthw/TirPRUWywjFXSzhhWawmIFgLLXXoGVZISCLbDN5ZZe4XxRaWItnWZ5zWBv4x5weojw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tL8K+JDb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tL8K+JDb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=aTya8XkyZ2UJhqML1s9qHapx4jQeioYW8TaotHw2q4Y=; b=tL8K+JDbpUaryLgwRwxHNwM6Kn
	T3KzcvFFYprZIOdtP+c93npC2TloZ3DS9r28BJOLaShN+sQ0R1gtd9fGTXK6WYsK0v50oDd4+4iN+
	0JU2kyc+KLU7lfkBkzEbq9O0r3jkQsRc4TgLwgLxuyl0gZ27Ofm2CtMus36XRInQ/aV0sB1pg26qC
	U2qWKpRqvsN51rfWOZlSkdVNH1tMaxaPOYqtTRji7QmHISyNpy1/Hq6e9WUn/xtFf+xBDvpCA1CtZ
	C/NVuMcqtGmrn8amdh/khHgcTgZh9N7MY1SBbW6KvxgdwncokP88q+PqiHjIIQM8UTIPK23CHr08X
	w3XetS9A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wMPcu-0000000DVgB-1u8H;
	Mon, 11 May 2026 12:20:48 +0000
Date: Mon, 11 May 2026 05:20:48 -0700
From: Christoph Hellwig <hch@infradead.org>
To: changfengnan <changfengnan@bytedance.com>
Cc: brauner@kernel.org, djwong@kernel.org, hch@infradead.org,
	ojaswin@linux.ibm.com, dgc@kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, lidiangang@bytedance.com
Subject: Re: [PATCH v2] iomap: add simple read path for small direct I/O
Message-ID: <agHJoGlwx4MxTQbr@infradead.org>
References: <20260428114730.14384-1-changfengnan@bytedance.com>
 <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.4a56b91c.8a12.4668.b740.76ff3633f48f@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.4a56b91c.8a12.4668.b740.76ff3633f48f@bytedance.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, May 11, 2026 at 08:09:51PM +0800, changfengnan wrote:
> Ping.

Assisted-by: AI slop is at the end of my todo list sorry.

If you take all responsibily for it and understand what you are doing,
please drop it.  If not it'll need to wait until everyone else is
served.
