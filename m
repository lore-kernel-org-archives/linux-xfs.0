Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA4314265;
	Wed,  6 Mar 2024 22:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709763402; cv=none; b=T7g+6Na5cHsvIoqNu2zQgTVSx1JuXUW49VPa1O4agt01Xmtp9vlqEZxQwG1UA+CYQPGfj56RbPeGYm2kfe9EmLb5GmKnlpkwKCdU4x98dZgHaBJWwdruYBE64z8PApWRDm+WgLVL/yTebCu/A0Yg6tJP/mMH1CvaZXjBuS6oBkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709763402; c=relaxed/simple;
	bh=mEsHmfioU7YFUNRDdp7uzT1NPi4KCUrCHsomdtKI1PI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SyIa0gD58qh79JqLEr4OikYoVeFkap/EdXF5/yayN2waFCEmEBVhr0I9gFFKT2jSpnW5TJ1FgjivJdWQlWaFs4dFhjtZzIpC/d5584AhlIwpzNUtCLwUxrBr1PltVc76J0Vhx+fIzTP5EvM6+McEi4Fjz2n1nZ10eqrXlqwvAzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=px0+GhWR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="px0+GhWR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4tFlqO+nz+vyD7AtEYeD6vF7kcf1yOgIiulP3wg93hA=; b=px0+GhWRfk7f1OvAjLSOL5uWlB
	nI7q08XsdLWWH8pUbg6BNETTyYq1PZc+ZzayPM3Re1mJc4L/rF7ztMYaBp0Uc1au8k3Bi1+pjcLgF
	5gJQCna07qvliThIDugaKjVd+yWnfQZo3i7fG+PwiJvPMYA5hOvjcco+tMuP6itSr/78hFM0JIKjK
	D3f3dMym2rcKxQFnYXP7W2KT3udJ7vqRgz98D5NjxNTI5+2BZldc5xQcl4SGZF+vEpsru9pMV5xbo
	9P7D6gX6UtShRSid2oDJCIB8tBde5Nqs40sdWFArL0wEYsx8NmNCfoX3EdhBOR/F8S8rx+hgVjyjx
	UlZFMbyQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rhzZ1-000000023Ps-3RYb;
	Wed, 06 Mar 2024 22:16:39 +0000
Date: Wed, 6 Mar 2024 14:16:39 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Keith Busch <kbusch@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	linux-block@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [BUG REPORT] General protection fault while discarding extents
 on XFS on next-20240305
Message-ID: <ZejrR3-aLJy3ere7@infradead.org>
References: <87y1avlsmw.fsf@debian-BULLSEYE-live-builder-AMD64>
 <Zehi_bLuwz9PcbN9@infradead.org>
 <Zeh_e2tUpx-HzCed@kbusch-mbp>
 <ZeiAQv6ACQgIrsA-@kbusch-mbp>
 <ZeiBmGXgxNmgyjs4@infradead.org>
 <ZeiJKmWQoE6ttn6L@infradead.org>
 <ZejXV1ll+sbgBP48@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZejXV1ll+sbgBP48@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Mar 07, 2024 at 07:51:35AM +1100, Dave Chinner wrote:
> On Wed, Mar 06, 2024 at 07:18:02AM -0800, Christoph Hellwig wrote:
> > Lookings at this a bit more I'm not sure my fix is enough as the error
> > handling is really complex.  Also given that some discard callers are
> > from kernel threads messing with interruptibility I'm not entirely
> > sure that having this check in the common helper is a good idea.
> 
> Yeah, this seems like a problem. The only places that userspace
> should be issuing discards directly and hence be interruptible from
> are FITRIM, BLKDISCARD and fallocate() on block devices.

Yes.

> Filesystems already handle fatal signals in FITRIM (e.g. see
> xfs_trim_should_stop(), ext4_trim_interrupted(),
> btrfs_trim_free_extents(), etc), so it seems to me that the only
> non-interruptible call from userspace are operations directly on
> block devices which have no higher level iteration over the range to
> discard and the user controls the range directly.

Yeah.

> Perhaps the solution is to change BLKDISCARD/fallocate() on bdev to
> look more like xfs_discard_extents() where it breaks the range up
> into smaller chunks and intersperses bio chaining with signal
> checks.

Well, xfs_discard_extents has different extents from the higher
layers.  __blkdev_issue_discard than breaks it up based on what
fits into the bio (and does some alignment against our normal
rule of leaving that to the splitting code).  But I suspect moving
the loop in __blkdev_issue_discard into the callers could really
help with this.

> 
> I suspect the same solution is necessary for blkdev_issue_zeroout()
> and blkdev_issue_secure_erase(), because both of them have user
> controlled lengths...

Yes.  (or rather two sub cases of the former and the latter)
