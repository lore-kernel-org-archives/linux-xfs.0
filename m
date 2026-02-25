Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3F93D3482;
	Wed, 25 Feb 2026 14:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772029477; cv=none; b=DPzXhz48HI1XIxClSZQGF4BOB5MuZVHq/i3rCysaR+6iDxkDAL+0rKopxIuOPuQWyoCJVGYWWeJ446nZEdF31GAoy+diDf0OugyYpo9+bk3cOuWhNc1fJuvG6gorB4TsWWO5vO49CCgidGo/e+dhnYF8kI5I0KuqxTM+aurlUD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772029477; c=relaxed/simple;
	bh=qsZY4iro4DPK6is1C/op7lHvrZw4o2fFLRWzHj7oD/g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uNfUJHlZtvwgqma2rpB4RqkK3Umdnl7VKPvqrbdNBuDmigmCQ0Et+1Vv2+Nm0OrBisjfnJYhgS56ClN/LRoVRjCXy8/qPU50sVnhgoQICx915vSDcF3Z/rb3YFnyyob/z6Fdz1j7lxgBOET+aPmPzACWLZSMorrvJTK9tG5rr+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XQ8pJ0ac; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XQ8pJ0ac"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9Sx6U9jamIBNlMfB6t0LAl4D4ql9zLLDo3L42wIR0WA=; b=XQ8pJ0aczDrvcAuJY6UrRBlMYZ
	t6hJLJ0PXx5FJohgDrNfxJAbIVA31DKrBhsoA1GJaIjqEsQlIP/IAdv9nB2L4IZvB4ijmTaYq5ZVA
	l7PpHHOFpdAtn/RON6EQj/STO2rbaF5bLM40SGhza1SLEYoKCRA4rV9hyXcsfe8dfZQ/VkY+zv+Os
	T15pBVH5Fx1t4x8NoXrulXsYZAYgEwcvFeCHUBu3IQaSoP4/YDnDfyy4an3AQicOkinbZSuL+jU0Y
	BXIs2xJvjEGuYB+VKb35St1dzAs6DRgKnjaoXRjX2NlysUA3uUR1HXgIAekLo7XKDvYXKS1uwVXk0
	fuk3OYDg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vvFoa-00000004BxY-0MT0;
	Wed, 25 Feb 2026 14:24:36 +0000
Date: Wed, 25 Feb 2026 06:24:36 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, djwong@kernel.org,
	cem@kernel.org, david@fromorbit.com, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com, hsiangkao@linux.alibaba.com
Subject: Re: [RFC v1 4/4] xfs: Add support to shrink multiple empty realtime
 groups
Message-ID: <aZ8GJGpEwp3Ihclh@infradead.org>
References: <cover.1771418537.git.nirjhar.roy.lists@gmail.com>
 <1a3d14a03083b031ec831a3e748d9002fab23504.1771418537.git.nirjhar.roy.lists@gmail.com>
 <aZasXfB-GUiGT4yc@infradead.org>
 <d7853e26511631b9ca9a28bb691bbe82765640c0.camel@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7853e26511631b9ca9a28bb691bbe82765640c0.camel@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Feb 25, 2026 at 10:47:40AM +0530, Nirjhar Roy (IBM) wrote:
> > Highlevel note:  this seems to only cover classic bitmap based RTGs,
> > and not zoned ones.  You might want to look into the latter because
> 
> Okay. So are you suggesting to add the shrink support only for the
> zoned devices or extend this patch set to cover shrink for the zoned
> devices too?

We should support all devices.  But what I'm trying to say is the
zoned version is both simpler, and will actually allow you to get
to an actually useful fully feature shink much more easily.

> > they're actually much simpler, and with the zoned GC code we actually
> > have a super nice way to move data out of the RTG.  I'd be happy to
> > supple you a code sniplet for the latter.
> 
> Sure, that would be super useful. Also, since I don't have much
> experience in zoned devices, can you please point to some relevant
> resources and recent zoned device related patchsets that can help me
> get started with?

You don't actually need a zoned device, you can just mkfs with
"-r zoned=1" and get a internal rtdevice configuration.  If you are
interested in the actual hardware and ecosystem take a look at:
https://zonedstorage.io/

If at some point you're interested in hardware samples contact me
offlist and I'll connect you to the right people.

