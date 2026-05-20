Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0AE3CFF66;
	Wed, 20 May 2026 09:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779271191; cv=none; b=FmvQa5VSwc3ZSItYDsyWJZnQShqSxWSaBrNAlUv6uvMIpAXm/kINHAdK7EiEsiIkyEGCJ219KIT76ZzgFkFqsp/+r/t5xGT5Gfz6tjS1Aut/bBlvuSgeB3PRXJH9My5hThmChE1T/nKN5nVoFdVCb0fb+dCvhZrB6r0XESwmMcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779271191; c=relaxed/simple;
	bh=LdH3tczlmQY6o715SbPZNGIDmfnRCEDAEpMx8qY5KlI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JfX/Q5YWFn3MuJicTbkFcZX2oPbsgXKjWuUkUtdXHE/cgnoUtCCw1mJgY/+lp3hshr0okBBM2pzkIvsADX5e8IfSefBBEOJSLY6RyHT19zuhobJMfyFJZjTRP0TDsdXNLc4qiSPFunYulHGMSEF7Flbpux2B26xC6s0hGAU8rpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jy6ZQnZ/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jy6ZQnZ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D4F1F000E9;
	Wed, 20 May 2026 09:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779271190;
	bh=sc4mvbz246dfZBCGithnIuNNBospnINSIgtOQ7dj8qY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jy6ZQnZ/cgghVUSKUPf8PWM0eGRHwSAp61bxLuj2d7j7Xme151eVEz9aFTPRYniKO
	 r6pM+1trt6iQw2URXw35NBN6nknAyBUM2bNIS1YpRhycuP1k/GwDY5TdegHhIxgM2E
	 MtN4Hckp4qAuBOEQjTsxoTAoHGEW74U3hyKB9khtac8wBOuP37hClNMdJCIVsxZsv6
	 Q+Tqmy8NNCLjNZsYGfMblhbj6Td1vSFGXAS0FU6tdZT4jSgm8aw854gAfQBhbiYKSt
	 aTpcBUGt83mTMJxNUrRwVwLOxgwJouz04IF5h9AH8+LHuRl58Ipe+Kmho/g1QrYKpM
	 PopZo4mbSe4Kg==
Date: Wed, 20 May 2026 17:59:45 +0800
From: Zorro Lang <zlang@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: fstests@vger.kernel.org, Dave Chinner <david@fromorbit.com>, 
	xfs-list <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 0/2] align the "# FS QA Test" format
Message-ID: <ag2EiThgxdOXCzIw@zlang-mailbox>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>, 
	fstests@vger.kernel.org, Dave Chinner <david@fromorbit.com>, 
	xfs-list <linux-xfs@vger.kernel.org>
References: <20260520074954.1877984-1-zlang@kernel.org>
 <ag1u28zXxrpkaCfG@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ag1u28zXxrpkaCfG@infradead.org>

On Wed, May 20, 2026 at 01:20:43AM -0700, Christoph Hellwig wrote:
> On Wed, May 20, 2026 at 03:49:50PM +0800, Zorro Lang wrote:
> > The intent of this patchset is straightforward, to reduce maintenance
> > overhead by unifying the format of the '# FS QA Test' line. This also
> > standardizes the output format of related maintenance tools.
> 
> Stupid question, but could we just kill the line?  It doesn't really
> add much value, but causes all kinds of issues.

No, I think that's an excellent question! I was too caught up in the issue
itself, but after looking closer at the code, I realized nothing actually
depends on this line. Moreover, it doesn't seem to add much value and instead
introduces unnecessary maintenance overhead.

I'm not sure what the historical reasons are for having this line, if anyone
has more context, please feel free to share. If there are no external
dependencies relying on it either, I agree we can remove it.

Thanks,
Zorro

> 
