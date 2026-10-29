Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793276415;
	b=yJMi+jvoujFoNqMvN1mXvFP9EeoaOaOlZ5DDOeHhqBEp1/3pK6StcrOFLsxIerB8MECG
	 NiA9gx1ovMifUy5Xey4mmVGbjAOhJh+TwbFR+TUucphDhUmGfPPEzHaAbrPimEjSPtkr3
	 S1QAma/P5oHLNbnCm2l3Wv+XGDey2L7iSZ00eT9bK6pbfkTJDmmB3tH6NYAcILsjwewEG
	 xqhl4eiAF25rQeQdVLEGcSIhr+h+3NvnKxAWH/zQZCVwCLMdsVt3arRCKMHEVJK7apRu6
	 AOffJ8F+Uq9HxmaCfaIuNcxP15UYrWyKzuIWJN2KTehUG5ZnIWigaSNG8+oHFZgfpsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793276415;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=qMtT0hncc9Q1ychxFx/zwvrpS9xQCZbuqBhjwAgBRlw=;
	b=pzle7MaR+YLqtj27WdHlX2AakI8zS96lnsyiYrBoYLWHXRrm7sE2twqjR7WLOUjJ1a85
	 +5LVEavFsl2M7x5xvUZO99iwvHiHwRJQgfId7ActgxgL2jdSJnPY4X354/OZk0U3KkQkk
	 THn+8BbGn/fiRbetbFmjs/+d5jJjnHiVrgVAIsywzkWnYiaoxYMihwaYdrTds09vkvS+M
	 lea/XN5xGJDCcxThwQTjJ8r4avZdqTgbJuRFepWAKrHXjW7GCJIQ6oeG5tX19VQuyWvtH
	 k+GuozkUYbq0YWDOcmsKmnyMUepfFLKCsy+ridGCSXhAz4FAxjyyY8uqCUA0MJgwFJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="i/7NbY9N";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040B1606A31A;
	Thu, 29 Oct 2026 12:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i/7NbY9N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F06441F01829;
	Thu, 29 Oct 2026 12:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793276414;
	bh=qMtT0hncc9Q1ychxFx/zwvrpS9xQCZbuqBhjwAgBRlw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i/7NbY9NJ81EBiiAqx21L/fdvYVtsfb97+nBOY+AD2fxOUGcNlmq3lFwJeS3V+8MO
	 pwo7u8X+dqag04Z8ajy7KmnAwjQCItpNoDQ6Drqqv1TiSCDzNJtdkNuv4FNfPLMeOJ
	 IgE+SKcZOV+Yjh5p8i3MFC69fLNwo52PCQ7uwEaEmf9HC86G3GsEiMAzaRp+MmnXE5
	 TBMbqjpZG+gFx0s1grxAbcT/h948yunGYN/DiWNNnn57IFz/vN2sN34cBZysthA3O4
	 COtRvww1t17Cr/Zk+JmSQU7exSZItWb/WE/QYJ/hyBQy8HhCD+bqsGJAkTvgaGiZ+2
	 Z7WSZHF6rjGDw==
Date: Thu, 29 Oct 2026 13:20:09 +0100
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, Chris Mason <clm@meta.com>, 
	Josef Bacik <josef@toxicpanda.com>, Matthew Wilcox <willy@infradead.org>, 
	Zhang Yi <yi.zhang@huaweicloud.com>, Joanne Koong <joannelkoong@gmail.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH 1/2] iomap: don't mark unwritten parts of a folio uptodate
Message-ID: <20261029-betuchte-unzeit-heimcomputer-392ff6bd4772@brauner>
References: <20261029-work-iomap-ai-fixes-v1-0-7eda63bc1b13@kernel.org>
 <20261029-work-iomap-ai-fixes-v1-1-7eda63bc1b13@kernel.org>
 <20261029121220.GA24197@lst.de>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261029121220.GA24197@lst.de>

On Thu, Oct 29, 2026 at 01:12:20PM +0100, Christoph Hellwig wrote:
> On Thu, Oct 29, 2026 at 11:34:48AM +0100, Christian Brauner wrote:
> > on disk. A source buffer that ends in an unmapped page is enough:
> > 
> >         ftruncate(fd, 4096);
> >         pwrite(fd, p, 3000, 100);    /* 16 bytes at p, then PROT_NONE */
> >         pread(fd, buf, 4096, 0);
> 
> Can we wire this up to xfstests, please?

I have an endless queue of additional bugs to go through so I can say
yes but I can't commit to any timeframe nor the ability to remember.

> > Willy reported this back in 2024 (cf. [1]) and Zhang Yi posted the same
> > fix (cf. [2]) but it never got merged.
> 
> Should we credit the original submission then?

It's references in the commit message already. Tell me what you think we
need to see there and I'll amend in-tree.
