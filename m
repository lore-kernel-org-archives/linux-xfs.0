Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806263438A7;
	Tue, 19 May 2026 17:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779213487; cv=none; b=N/MprGAJ8AILufHMlL/L6uAXpf2Z8ccUgg6IMa4SPufRty7pLCfC6YH4RsGpE97S0kzNttWcAr4+3S+pThj8i816UWI/ndBNPr5NFeovt9PSR067KMw+tLD2M31b91wm050/SYZJ83eG2At6B84pIBc1oDESFMdSDVQJv4e6fqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779213487; c=relaxed/simple;
	bh=3If0TDMD8JQ7Q4SNEMQ9CCs/awwZxgs/+1f0vyFJ2tk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oh7Wydym8wWD1lebzzWhK6c4RV004IwBDMgNkzVJUvS5RokAdTKYh+m/ai/NTSTW22timdrxP+BNJgBg1Ddsiy98USTdZV5V5+5qj9xm7tGaVdDIWqNi1p+Sf0l8A10ngkQcbibeSJt8U2Tmd8fYoHWPnRAV2AWr6OhcGRTz82M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WxVkSSY4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WxVkSSY4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E233C2BCB3;
	Tue, 19 May 2026 17:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779213487;
	bh=3If0TDMD8JQ7Q4SNEMQ9CCs/awwZxgs/+1f0vyFJ2tk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WxVkSSY42SVGVHPzta6/0T37RyBOXYgWV7RurVGzR0XNGZzsLvtlLuvcc6z1O++Ji
	 OTgDAxA/ptG+zj29vb4ioOGLjEqeaRTrP7ZsXFZLyAwPCsDOJ/5PYALs6/wV2zjNvj
	 oLQ1GmmuWFpXsnxWAJe/veGJNNST8NyzKeAezgYlAP05ONGdBdrTVa/3eGbidY/rPV
	 kbVQ7AdiobYsXA/9XaarF68OBTaLhNhM4hyLwSOWRqsSb/ZMYq4VI8cuu5gov4ffAS
	 punm0gjIeBbI5rbsM5e+LNRkERPxLPL+m/ABDUxmhAF47RqONKX2FNdFw/ZPNBcbdg
	 Jso39rwlSo8Kg==
Date: Tue, 19 May 2026 17:58:05 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] generic: add a test that stresses metadata eviction
Message-ID: <20260519175805.GA1875993@google.com>
References: <20260518062514.506071-1-hch@lst.de>
 <agsEQ9TjHelfbWXr@nidhogg.toxiclabs.cc>
 <agtbqjAxUsCsLwyr@zlang-mailbox>
 <20260519083758.GA15916@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260519083758.GA15916@lst.de>

On Tue, May 19, 2026 at 10:37:58AM +0200, Christoph Hellwig wrote:
> On Tue, May 19, 2026 at 03:03:37AM +0800, Zorro Lang wrote:
> > On Mon, May 18, 2026 at 02:27:42PM +0200, Carlos Maiolino wrote:
> > > On Mon, May 18, 2026 at 08:24:53AM +0200, Christoph Hellwig wrote:
> > > > The fsverity test generic/759 could be used to reproduce a regression in
> >                               ^^^
> >                               579
> 
> Yeah.
> 
> > Hmm... Generally, we state which case was copied/forked from in the introductory
> > comments of the case and in the commit log. If you want to specifically mention
> > the original author, I think we can add a dedicated line in the commit log, for
> > example:
> 
> If Eric is fine with that I can stick to the normal rule.
> 
> > What do you and others think?
> 
> I don't really care at all.  I just want to make sure I don't smub
> everyone involved with this the wrong way :)

The patch looks fine as-is (other than the typo already pointed out).
It already preserves the original copyright line and has a comment
"# Based on generic/579 with the fsverity bits stripped out".  I don't
need any additional credit.  Thanks,

- Eric
