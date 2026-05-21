Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6AA3BD228
	for <linux-xfs@vger.kernel.org>; Thu, 21 May 2026 11:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779363545; cv=none; b=ll7aIGMMRfp+FA72se7X3jqKbkNQMt7+HcSzAPzfQetnfHFiDMT/KsOZMSgd+IuEEmtzgNUAr1bnrn5EPBiU7TKoI9zdXWnXNDOZT4I/UxIhq75f+dtxV6z4yaVRoQrOOWiqolCar5yruH/yj24lU8rFka/iiIf/O58NbLnWwVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779363545; c=relaxed/simple;
	bh=YWJMefyku+qqIZYZouZfqygVq46kf9MKHSZ0pb9rDxA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vAIDuum4w+uXqdOoCaUVpZJtQNWA2u/aDwEncn1cKECg7Q+XrALOzudtc+SsiuZU7HHAvZyYVhKHPzoDaaxePiPXC6NMJb57f0vrAZi99/vwiuFpj5wEEg66IIKDzOextyAnEH6GR1VZHrA/zc6s0gvzIaShSv3kaV3Etq90qEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JFqDKpxX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JFqDKpxX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E441F000E9;
	Thu, 21 May 2026 11:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779363544;
	bh=pD9w9xt+JsFMRSqyI0+5p6LeEdezelxTgKzB8Jt+aHs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JFqDKpxXVuZjbFf/pq+Uthrsw94FHLV/XodA3FaKEsh2ZkWiwrQz+E8t8jJyLXb1T
	 ga9K6XUAdw4sQXpbyzHj6S4BG+XzO7p7jNiA/8/8V6JyEUUFROIvqOGUQzh/fjGNt7
	 uxJK/z1Dmr2asFcpXqPlT1R4vWjIUxLXJx49FvP5neGCYl3dUoXmX+6xt9BRMcLVVD
	 YAbSVm7apxaHej+CBfJG+uYdqj/paFYSkdr4QnXnBi8Nap8I99WRat1f8pREolTqaH
	 SWEl71qOsOiLBBiHywxATSJy4xToROt9WLXDZNb2/bBgm1C4E1E/I50wnwb3aWBUkj
	 YOxir1UyAqAtQ==
Date: Thu, 21 May 2026 13:38:59 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, 
	Andrey Albershteyn <aalbersh@redhat.com>, Dave Chinner <dgc@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix a buffer lookup against removal race
Message-ID: <5b6af6ilr7w2rlreoeqaz2j2mhxa2fbo7glyzcxa72zfe4h2tg@hjlyt7tvknna>
References: <20260518060209.502179-1-hch@lst.de>
 <20260518060209.502179-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260518060209.502179-2-hch@lst.de>

On 2026-05-18 08:02:05, Christoph Hellwig wrote:
> When a buffer is freed either by LRU eviction or because it is unset,
> the lockref is marked as dead instantly, which prevents the buffer from
> being used after finding it in the buffer hash in xfs_buf_lookup and
> xfs_buf_find_insert.  But the latter will then not add the new buffer to
> the hash because it already found an existing buffer.
> 
> Fix this using in two places:  Remove the buffer from the hash before
> marking the lockref dead so that that no buffer with a dead lockref can
> be found in the hash, but if we find one in xfs_buf_find_insert due to
> store reordering, handle this case correctly instead of returning an
> unhashed buffer.
> 
> Fixes: 67fe4303972e ("xfs: don't keep a reference for buffers on the LRU")
> Reported-by: Andrey Albershteyn <aalbersh@redhat.com>
> Reported-by: Carlos Maiolino <cem@kernel.org>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
