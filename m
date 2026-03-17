Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32A334B186
	for <linux-xfs@vger.kernel.org>; Tue, 17 Mar 2026 22:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773785208; cv=none; b=fMxYWxvs48f1dF70CCjtCBYZ+yq02x7+sAvTLiDz317Wt5/Chz10yfKcKHel374Ctb1XhTXTLsfYEWl5OgrXKOJBdfvPLzVMr0E7UgqQDXhQCedaQca2pAyH3DsRPxBm4SDavHGOW2DjU1L4hme3QQGV79k80KxKCL/Rx8G0laU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773785208; c=relaxed/simple;
	bh=lHQFXVA6+9MPwLkn06DzX+K9eVSIPLz46w1Zkvg4LUk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rXgX1MxzAhQK1DqsHSSylPCMEc/2boKrDNOe40ChjT/7Bzl+WTkp9qoSr4UzRtYt0fKEXSDRA/J9RkGvE29v1jNYQZ+Fl0tTBFtU9ecehkC7Jaa6OAJajBFBXMXVmHcRCCq1r8DhsvbnRRmITKNknTc7rCjl6tA8UQzIfhBXuGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GVCWXMUL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GVCWXMUL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B95F9C4CEF7;
	Tue, 17 Mar 2026 22:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773785207;
	bh=lHQFXVA6+9MPwLkn06DzX+K9eVSIPLz46w1Zkvg4LUk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GVCWXMUL0Uc9CUl3tUr1uZ0Zk9ue342w208OEVg1GOQYCR3H8FILzwZsL2BPPCUDt
	 9YJjObE0oInRwAcIvyW5N1V2gBxG/4ilje2ZK584U6vUXxFDf+9yADVo/CXJzeGvDF
	 pcwYzv2ipFkNO4wXyfOkB0R9h8bNTUDcGvRTFtFw4n+U16s1uygvVA/fLOqjWjP598
	 SREbGYRiQ0yqNfQ0AGYpVrroPjproeISiAzFVxlXsiFPRBsPxIuSiFYgUWwsJhQeKx
	 LZZcbrfeZIuj1+Fexv9Em1o8POHWf0K8OWwJHuKlozTa2rGhvHoiinbVAneDKohmog
	 1zHob5DdW388g==
Date: Wed, 18 Mar 2026 09:06:42 +1100
From: Dave Chinner <dgc@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 4/4] xfs: don't decrement the buffer LRU count for in-use
 buffers
Message-ID: <abnQcrRk55SEqPu0@dread>
References: <20260317134110.1691097-1-hch@lst.de>
 <20260317134110.1691097-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317134110.1691097-5-hch@lst.de>

On Tue, Mar 17, 2026 at 02:40:55PM +0100, Christoph Hellwig wrote:
> XFS buffers are added to the LRU when they are unused, but are only
> removed from the LRU lazily when the LRU list scan finds a used buffer.
> So far this only happen when the LRU counter hits 0, which is suboptimal
> as buffers that were added to the LRU, but are in use again still consume
> LRU scanning resources and are aged while actually in use.
> 
> Fix this by checking for in-use buffers and removing the from the LRU
> before decrementing the LRU counter.

So I wondered why you put the "in use" check where you did a couple
of patches ago - it didn't make a lot of sense to me because 'in use
buffers' typically reset the lru count to their maximum at the same
time they lookup, lock and take a reference to the buffer. The the
lock and reference are dropped at the same time when we are done
with the buffer, so it never made sense to decrement the LRU count
whilst buffers are locked and referenced...

Can you just fold this back into the original patch that introduces
this check?

-Dave.
-- 
Dave Chinner
dgc@kernel.org
