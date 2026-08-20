Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6511F8AC5;
	Thu, 20 Aug 2026 05:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787204359; cv=none; b=dErZucNzzOSs7N9FVWiNgO1rowKW6e4uqdL3YH+0dxmVLAPxif6Y5OVMwXSw491MMrujvpXFpobitV/AJCiWOtFFO7cPiIZ04qZp5cXB7YQeXSDTcxOHI5wn3mhZTHz6ZIJJg6PmHkqKadAXPNZuNHyRPSubpvc1krR1rbEQUqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787204359; c=relaxed/simple;
	bh=wdM6rudT+Mf+zmXsIbpXQkgCmO5rtQtUBmik6lEas1Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=plV/6Coqdrcb0X0ehbNkvuZCBwMPpxKINyN5VoTImVEfRTf509p4zEP+OWqi+geJI3Qmc/bFQBMgm9M8dbT1xAbkCSAaEHqGhM1jM0LvClkA86KrReonptNrO0QRanj4OhVTBq70pu5Udkc8kW7fznc686+cCgGTY0QXjBtZQ9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dj5q2W6N; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dj5q2W6N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=toYdR63KTyoC1HRAs/UIJm8XidXJ6L6vNjUl+tllJqg=; b=dj5q2W6NfAVl2mcZIiNMVN0WTK
	6SqC2nmb8Oz1fnmQnABt28G4UB3MLb6HSl3zXtygSdXS+4oXpCggo1wzzvmq3s/g20NG+2cG5g1F1
	Rr71o+EEKb8vJsQs7Gfma+X+2k0rf7D1mdPPacz7yE691Ke3SGRyjxNHrwUQsqhvTXqHKjo5dM5P/
	jKoVCXTUWpqFEPi82oYp38cF1yMs6pBrrmUqR6R4Ts/8OYVJGNcwBma8xErGF1LuIIkm0B6083zYd
	t6QtwxIkNJ0gSPCxGlcbLZOPhQcLSFdd97DUlcmRizsAvuyFGr/Pi0GUDm5zMu3ZZj5JCYat00d1U
	FOGyPO/w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wwvUh-0000000Ar4A-43Ln;
	Thu, 20 Aug 2026 05:39:15 +0000
Date: Wed, 19 Aug 2026 22:39:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, hch@lst.de, cem@kernel.org,
	stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: fix xfs_rtrmapbt_mem_cursor for non-rmap
 filesystems
Message-ID: <aoaTA8AASaqKykLe@infradead.org>
References: <178659861838.833922.2269351780488724470.stgit@frogsfrogsfrogs>
 <178659861897.833922.17703139818760252058.stgit@frogsfrogsfrogs>
 <aoVKR4HmS3Hi7WBg@infradead.org>
 <20260819231943.GD6072@frogsfrogsfrogs>
 <20260819233025.GF6072@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260819233025.GF6072@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Aug 19, 2026 at 04:30:25PM -0700, Darrick J. Wong wrote:
> On second thought ... the slab cache that we use to create rtrmapbt
> cursors always makes them big enough for xfs_rtrmap_maxlevels_ondisk()
> levels, so we always consume that much memory no matter what we set
> bc_nlevels to in xfs_rtrmapbt_mem_cursor().

Make sense.  Maybe add that to the commit message?

With that:

Reviewed-by: Christoph Hellwig <hch@lst.de>

for the original patch.

