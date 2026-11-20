Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795193250;
	b=YhOW4+bTTMZwmmQOD0GhYqLYRdKJgzDqz2xDXYTCZUUIDoVblWKSEVj8GlEG+e2IEv6k
	 93/wwY4Ok5j83CkTd19NXb87bILzH3Ky5sdgvlPQQ4VmtHyTQU9KpNO/b30xiUxl8pAmy
	 9WhcqN/VqUya9c7KbwjhjKmzmZWrE89TgQyE3OXzv1a6eDq5t7XsdGSS0sg34xzBWpJDG
	 Ir9+Sf3x/KC306sYrRZSWAAwqRd4uU/BsC0uccnV0ulxIAOjfb2DaLjoRe0JWA+n4VlHZ
	 HlX3nCLpK+vUirljRJvmhVJNN2xS++xBii0TRnkY1yvpjO3AvLMT9Oe7P8VDc+/fVAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795193250;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=aHGMMibfTK3B84l7c2TFfwJFc+Ej1l9rQZD53EE9TDc=;
	b=uLe3s9WpMDNeOPa1MXcFs1LeJhzPTFExJ58ynecLEEGaa4IFifqTMk9QwzGFpnCkO3X9
	 KE9c/jPdnaY9Ff+RhRwSTwb8yH7AYD3ULFM8Tt/svo9Ruf5FqgZY7/D/jphrIDdH1qIk5
	 NXqOY2TU8ZPHEFhj5v5W/Tv2zplNjWR7p05VjGjNyaq9ZAPr8jinpeO2rfZSu1bzpnZs9
	 ADOiJmCDIGXWl3Bp9xcJ/yKwEVdLGT758ub7LaLuE0yNlhj0r8ErQWF2yzPMVbL3E54YX
	 XBLUVVWoDoQGj7SebVr7+KrTwctD1LzCWm6SE/8fCrdIZ/K/VorHIOY7Md0vMCoSRYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=rHXDFNV+;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17012606A325;
	Fri, 20 Nov 2026 16:47:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17012606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=rHXDFNV+
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=aHGMMibfTK3B84l7c2TFfwJFc+Ej1l9rQZD53EE9TDc=; b=rHXDFNV+eK+JiP8QYJDc3TQZYU
	jPLq+AlFkeEL4XXv1xtjfkB7sCeLCFD9e35oFzVxWKTIZHn/hWcp1M77tE0Jil9ufkzz7/eTKP6vL
	afUamsFU7/ddP/NekWhhcg+y5dYEcAsnvGgZAr4r41lazc2yb2UyQXB5YXOWMDeSTQWisAb3b+BOX
	5XkxNxtFp4hsunzPEvh8WPJk1dFCH3caxa3+JyFI1aP6RGG4I/hqPGGZS6GbhKRSQqzf7FPyhSZ/J
	3uQa3kjsEUEjBHvSC3EwhW+GNuV0nZVMt2jbO1hMqW6w9DRsgWHulgTVGOaeETkXlv5RGsxYszx8B
	QhtPZzyQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xURlg-0000000FaOf-1Kar;
	Fri, 20 Nov 2026 16:47:22 +0000
Date: Fri, 20 Nov 2026 08:47:20 -0800
From: Christoph Hellwig <hch@infradead.org>
To: NeilBrown <neil@brown.name>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
	Jan Kara <jack@suse.cz>, Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>, Carlos Maiolino <cem@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>, linux-kernel@vger.kernel.org,
	codalist@coda.cs.cmu.edu, linux-fsdevel@vger.kernel.org,
	linux-um@lists.infradead.org, ntfs@lists.linux.dev,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 1/4] VFS/xfs/ntfs: drop parent lock across
 d_alloc_parallel() in d_add_ci()
Message-ID: <awB5mAWm9h1ksRFI@infradead.org>
References: <20261117000115.1433875-1-neilb@ownmail.net>
 <20261117000115.1433875-2-neilb@ownmail.net>
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
In-Reply-To: <20261117000115.1433875-2-neilb@ownmail.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Nov 17, 2026 at 10:54:58AM +1100, NeilBrown wrote:
>  					  const struct dentry_operations *);
> -extern struct dentry * d_add_ci(struct dentry *, struct inode *, struct qstr *);
> +extern struct dentry * d_add_ci(struct dentry *, struct inode *, struct qstr *,

Please drop the extern and fix up the formatting if you touch the code.
Bonus points for spelling out the arguments to actually make it
readable.

