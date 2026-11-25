Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795591981;
	b=kwKusT983CaOgsI58jPz/PwPTExucgkNNtuNMEbqj2r2U3LK1ZQAtdBTm1BIzkUF8Up2
	 DgSCEj9y3dyoz412OpzdDQmOI/CJJYs4P3eiFhLsHayP0htT6XzduGDxN/zceEhwqji00
	 57nEtXuBvYH/jyjArRL3eLDdVfHMyoFPi2HYXHMzd+oEMI4RpDJ5+jDho8p7hWf7iKr6h
	 T1GlIv7hD7RdGfCRFiLSDMztvXTgYKfGnNmQ+t0XODJC2I+jYfapXDFKGVJelRUnbBtDR
	 HH7GWfWYQgXEakNsuLR17pAsWTbyH4elu0T0nbib4p97cUPIJGJeQagPVfhzVd591Dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795591981;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=HRfXrjy4cFvSqBw76P9cqoRaoe+61N3iyVA9tyup4k8=;
	b=P4f8WmXcmc5aMELFg/18nG72IOsEJNuLoEPtAMLNzKF4LZSTypOqtUm0NkNBeSDoAy7W
	 CISfyJ5Cv2y0fe66eNEJmmTKF5aY45ySpLpZUr9Dx4oV0pTJ8ZYsp0haBdC1LHwzO7qqZ
	 /lkOz8P22GnY1JsDjz6I+uIVZ6okF9dEBXYT99h0fCaOPtSc8OJY8a/acL4GVeASrE3ms
	 WfOaVdyN+AqWUckDfGMfBWg62QVVmTjXEVfiyCiTGyb7AjnrVm3xk/C3vEWcdZPtEx0aj
	 qX2JqJJM0HL4vCP+9rIOf2X+yjDghL1JTuYdo/hwAQCGUrMTc+hKyF6RxtLbr9oGSug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=G0NiytEL;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F95606A31E;
	Wed, 25 Nov 2026 07:33:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 62F95606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=G0NiytEL
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HRfXrjy4cFvSqBw76P9cqoRaoe+61N3iyVA9tyup4k8=; b=G0NiytELAkdrALWzOqdeOgUj4q
	Xkl1X8tKNpo7ZAhw0TCzZdozdTr5jgMpOTFlqQ9bc713KtW/n+2mjU4xCs82WbLoapFsX4YdYq2yZ
	LAYRlVbaNSrgmFgps3gRYM+qw+DnmGsZlmo/d9j9MVCBU8K5o24akD9+H8lzeiDaaHaR4CtONGDjn
	UedilHQ3hfdjzVblrR6+PWuhwk4upJrRfnC0taVjThQFEvtIIaO1XK/QgW3gluIyEYOJg6ITHCRpW
	m3tIdX1KWFkwJ9vCc/IlbbHMZKVdz+1VJe9StOIldg9O3H2YznocCu4UDoELYYGBE/5UemZCrwAO6
	DTTmFfmg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xW7Us-00000008uBv-150Y;
	Wed, 25 Nov 2026 07:32:54 +0000
Date: Tue, 24 Nov 2026 23:32:54 -0800
From: Christoph Hellwig <hch@infradead.org>
To: NeilBrown <neil@brown.name>
Cc: Christoph Hellwig <hch@infradead.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
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
Message-ID: <awaPJqPMezCU5LKD@infradead.org>
References: <20261117000115.1433875-1-neilb@ownmail.net>
 <20261117000115.1433875-2-neilb@ownmail.net>
 <awB5mAWm9h1ksRFI@infradead.org>
 <179540759290.1728055.6042791276963817025@noble.neil.brown.name>
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
In-Reply-To: <179540759290.1728055.6042791276963817025@noble.neil.brown.name>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Nov 23, 2026 at 03:19:52PM +1100, NeilBrown wrote:
> On Sat, 21 Nov 2026, Christoph Hellwig wrote:
> > On Tue, Nov 17, 2026 at 10:54:58AM +1100, NeilBrown wrote:
> > >  					  const struct dentry_operations *);
> > > -extern struct dentry * d_add_ci(struct dentry *, struct inode *, struct qstr *);
> > > +extern struct dentry * d_add_ci(struct dentry *, struct inode *, struct qstr *,
> > 
> > Please drop the extern and fix up the formatting if you touch the code.
> > Bonus points for spelling out the arguments to actually make it
> > readable.
> 
> I think inconsistent formatting is not much better than bad formatting.
> Maybe I'll insert a patch which tidies up the whole stanza.

Well, if you keep this mess it will never get fixed.  So please fix
it up on the go as we do in most places, which makes a final cleanup
pass easier and more likely to actually happen.

