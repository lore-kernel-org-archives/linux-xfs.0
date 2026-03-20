Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA1B285CB6
	for <linux-xfs@vger.kernel.org>; Fri, 20 Mar 2026 15:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774021613; cv=none; b=EGk+yHn1DjFLIky2OGd0YP3cjfDl0JA7HCjYPF+S1kW3fBCBNlFh0GGPd+QLKOC23M5gTiadbddhS7G7B64VhjnImuM/mO3jtDs0c6UGwepkInpf/2fUqzpUtgilptCbC1JDgvgrzTPcv9Ge3Idw9SyC08/8eHjIUKhpFAGPCXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774021613; c=relaxed/simple;
	bh=yx6kx2GRzZqFNkghfr/BNK98g50mH8cHv3wSSvtDmws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SGRPcgOcOepswZSXjI4xkSNiBWi00A+8MbB6VPoJaTUKOZB4AvxR23ygISQJNfjAl5DZxCS+9nntvwwva9QchVV39TyZyOs+vT80NdGAW/unn8+yGna2/q3N+DAbnbhcnwWgLtMbjuBGGuOhY6tbAca+Zyag4n4YGsSflUfE/qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oyr0P/L5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oyr0P/L5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2006EC4CEF7;
	Fri, 20 Mar 2026 15:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774021613;
	bh=yx6kx2GRzZqFNkghfr/BNK98g50mH8cHv3wSSvtDmws=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oyr0P/L536AWNYpJlL7egFZR0npsiI/xvdyIyWMTTN7vqvqlQD1Ls2YKlvQAdvKn4
	 OkiWpe8ghdQf+5IrB8t1MVYi6PncWp9VXlFZmMmqQXVQyfp/H6T0yNweLWxyetafsh
	 7fQBVEZN8M8sw5H0OT6nesn7d0AXromlwaigTL33Z5UNFxxE6aOsWWJ50nH8slKMYX
	 /QPgmr0iwih+PIduWbjBVtU96rCYBBZNH+GBt//uiM2bfsErYVjSBZKZ4Iwtxsq0xX
	 H99pPDC+7XdgSsoUJfgKxezFyYEdfcxPVCFmQPRiNItlLW49vzs6YSH+INYXxbwos2
	 W4eg7AopSJwAA==
Date: Fri, 20 Mar 2026 08:46:52 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/22] xfs_scrub: raise media verification IO limits
Message-ID: <20260320154652.GD6223@frogsfrogsfrogs>
References: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
 <177389507326.3681140.15280052926187020484.stgit@frogsfrogsfrogs>
 <abz0ZjMmmFMk3l5e@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abz0ZjMmmFMk3l5e@infradead.org>

On Fri, Mar 20, 2026 at 12:16:54AM -0700, Christoph Hellwig wrote:
> On Wed, Mar 18, 2026 at 09:51:00PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > To avoid starving other threads of disk IO resources, the read-verify
> > pool limits the size of verification IOs to limit bandwidth consumption,
> > and it is willing to over-verify some amount of unwritten media to
> > reduce the number of verification IO requests sent to the device.
> > 
> > However, these limits were set in 2018 when areal densities were lower
> > and disk bandwidth was more limited.  Increase them now to reduce scan
> > time on the author's system by 10% in foreground and 50% in background
> > mode.
> 
> This looks good for now.  At some point we'll need to return to
> fine-tune this better for different media.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

<nod> Thanks for reviewing and sharing patches! :)

--D
