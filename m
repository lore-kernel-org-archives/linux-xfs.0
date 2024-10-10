Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6011CF29D;
	Thu, 10 Oct 2024 08:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728547300; cv=none; b=jpFZlz1kXSlmsw79/W643lgJafpBJPFv3zCGdbpTIyVaj/hpAt6SxnvtPCpE6o5eqSexuLY8uDO0L8zRPmQxGKtQP7cYEZteaor6dcxLv2SwJpH37ZWcR/AE5RINx2Miq9SjCSTyYtorTbeF+ThBjRCmuMnjdLtqhN9ZCetYW2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728547300; c=relaxed/simple;
	bh=SPNWE67wljUpgDt6cdCP1UZ5g+mrt3I94xuS2flkUjw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zz+/MQz+F7wq5DSsLk8j0MN0HLmpgJviH+fMuQj6U6caEL21wUbRxWR/S9zam6Q+KVvUNh31oLUk10k1znjEIIcPjSh+bQGPviG+PlY/sMfw6PQzfcXdRB0d6WxIzsZft7NGrANlhHlphKabAZeZet/mu+nsCMELp/Y22WsT7lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ODlnf31z; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ODlnf31z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3M9KdA8DamcHX+t4Rs6QLSY8A6xBoeXjIByTZaRvvrw=; b=ODlnf31zkBA60pAMsLKUz4NwQA
	0d1+qf2OpwXb5xM7RrOyWLDPmzgckueE+AckkkbX9AeLzNNKH9DDQ20L3tNKen95IQxJ4AaT1NaDk
	2rt9oonqWGhcxNDoPLDPP3VzdqkNfjEiI2U9f7Hq+xSMWHk2PfvhbyqeEYvcmasG3J7l7Rxr46mcv
	lpM0TA1sM5LlScvxNz87yz3ey/jdIwfJh7YL7E1yumpCqhm//sWjUujlYuKyb6xyScH/hQD9Z9H/w
	E7hZ09vvysbAVWRm1tkP+SLzPEm544ZxZ82wA5c4jRZLGqPSkMMvLItACcRiBNMUyNY6nDlkpN83W
	H3CaLIVg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1syo77-0000000BtRj-1dcm;
	Thu, 10 Oct 2024 08:01:37 +0000
Date: Thu, 10 Oct 2024 01:01:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Marco Elver <elver@google.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	syzbot <syzbot+8a8170685a482c92e86a@syzkaller.appspotmail.com>,
	chandan.babu@oracle.com, djwong@kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
	Vlastimil Babka <vbabka@suse.cz>, Feng Tang <feng.tang@intel.com>
Subject: Re: [syzbot] [xfs?] KFENCE: memory corruption in xfs_idata_realloc
Message-ID: <ZweJ4UiFpOtxyeB-@infradead.org>
References: <6705c39b.050a0220.22840d.000a.GAE@google.com>
 <Zwd4vxcqoGi6Resh@infradead.org>
 <CANpmjNMV+KfJqwTgV9vZ_JSwfZfdt7oBeGUmv3+fAttxXvRXhg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNMV+KfJqwTgV9vZ_JSwfZfdt7oBeGUmv3+fAttxXvRXhg@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Oct 10, 2024 at 09:50:06AM +0200, Marco Elver wrote:
> > I've tried to make sense of this report and failed.
> >
> > Documentation/dev-tools/kfence.rst explains these messages as:
> >
> > KFENCE also uses pattern-based redzones on the other side of an object's guard
> > page, to detect out-of-bounds writes on the unprotected side of the object.
> > These are reported on frees::
> >
> > But doesn't explain what "the other side of an object's guard page" is.
> 
> Every kfence object has a guard page right next to where it's allocated:
> 
>   [ GUARD | OBJECT + "wasted space" ]
> 
> or
> 
>   [ "wasted space" + OBJECT | GUARD ]
> 
> The GUARD is randomly on the left or right. If an OOB access straddles
> into the GUARD, we get a page fault. For objects smaller than
> page-size, there'll be some "wasted space" on the object page, which
> is on "the other side" vs. where the guard page is. If a OOB write or
> other random memory corruption doesn't hit the GUARD, but the "wasted
> space" portion next to an object that would be detected as "Corrupted
> memory" on free because the redzone pattern was likely stomped on.

Thanks!  Searching kfence.txt for random I find that explaination in
the intro now.  Can you maybe expand the section I quoted to make
this more clear, by saying something like:

KFENCE also uses pattern-based redzones on the side of the object that
is not covered by the GUARD (which is randomly allocated to either the
left or the right), to detect out-of-bounds writes there as well.
These are reported on frees::


> 
> > Either way this is in the common krealloc code, which is a bit special
> > as it uses ksize to figure out what the actual underlying allocation
> > size of an object is to make use of that.  Without understanding the
> > actual error I wonder if that's something kfence can't cope with?
> 
> krealloc + KFENCE broke in next-20241003:
> https://lore.kernel.org/all/CANpmjNM5XjwwSc8WrDE9=FGmSScftYrbsvC+db+82GaMPiQqvQ@mail.gmail.com/T/#u
> It's been removed from -next since then.
> 
> It's safe to ignore.

Thanks!

