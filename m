Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EFBE2F7EF5;
	Tue,  2 Jun 2026 07:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780383716; cv=none; b=oVwF/1phQFYX9dyJwrCHT77ICcHZMClb7BQNVqJ5C82dyq87KKYInT5PCx7CGI2J30Sik3Np5gGGt1f7oKZR3f3jOJPukwj0+RaUJIC0K00eGWC4201wpD3h1AIhhyBsjOMRovzAdfrkyJCKxgczz1mvPgievfwRzZkgNpSD9M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780383716; c=relaxed/simple;
	bh=e8LkO+yKbu9jFD8awj1QU/6WypQ7wB3Qj/oHubsRTbc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t+8qMxW1PVhb4fp+cypMg0QZwB+f6parEOFuf6h2Pnsiiesactv65SZBCV+duT5AdBiy4tBPzxzwbvv+MR8WdmIeF9I0sx2AKfJ1sh50a7lY3DV9X27XKFgvpLHKTaD/piomcgEI+jkFrUNoQUu/ztxYdZv+Yq8bFCD587Dj/1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=S0uQqDl5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="S0uQqDl5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BYFvv0WL2nD26pmCw2XdTthm82oeti8G0FwCMxb/xgc=; b=S0uQqDl5pjNooTBgME6c6uChu3
	w39UtnWzBsfadMXigQ8UXJ0ln+yqwbVO5NKAbUICH/87bszqL7AsYndOsjhXo29tuCRcFFngE34Hx
	Np3yHPA8zjPT7Abo2xIgMEKiIMaFPMLF2znXPYPmeBKWh9yLNIL4NR/nc0VJeYVjBwttT6KmugXYT
	+BKhEtNqc9oVt48RmRUWQfjHcn1BBHXjb8iDNxNe5rCPWczyCLCPkXLeohZA910R5+GlfumnVXT5/
	spR9inkS9mCEveKxF1Lrar5zUg7FFVPweThq2NNmZaR++wWnNPNtzFwTbA2KM84f3RESuzwoK0FGh
	WYSBZ2bw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wUJ8J-0000000CQCj-0aSJ;
	Tue, 02 Jun 2026 07:01:51 +0000
Date: Tue, 2 Jun 2026 00:01:51 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Cen Zhang <rollkingzzc@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	zerocling0077@gmail.com, 2045gemini@gmail.com
Subject: Re: [PATCH] xfs: drain inodegc before quota teardown on mount failure
Message-ID: <ah5_31tVIHX1RD7y@infradead.org>
References: <agwh6darf9q52za7@infradead.org>
 <20260528053128.3036120-1-rollkingzzc@gmail.com>
 <ahf9j4G0sdSx0Ti5@infradead.org>
 <CAB7XQsFyZgJqraMaDbpR-nPpZNkvbAscjp6qGjSPOAtUPBET1Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB7XQsFyZgJqraMaDbpR-nPpZNkvbAscjp6qGjSPOAtUPBET1Q@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, May 28, 2026 at 09:28:02PM +0800, Cen Zhang wrote:
> In my local attempts, a mount-failure errortag after
> xfs_qm_mount_quotas() was not enough by itself, because ordinary test
> setup did not reliably leave an inodegc item that would enter the
> dqattach/eofblocks path during the mount-failure unwind.
> 
> The draft I have locally uses two DEBUG-only errortags:
> 
>   - mount_fail_after_qm_mount_quotas
> 
>     This injects -EIO immediately after xfs_qm_mount_quotas().
> 
>   - force_inodegc_eofblocks
> 
>     This makes a regular inode released after quotacheck scanning go
>     through inodegc/eofblocks cleanup, and delays that inodegc work so
>     the mount-failure unwind can reach quota teardown first.

This sounds pretty useful, but I actually have a different
question:

>   Workqueue: xfs-inodegc/vdc xfs_inodegc_worker
>   xfs_qm_dqget_cache_lookup()
>   xfs_qm_dqget_inode()
>   xfs_qm_dqattach_locked()
>   xfs_qm_dqattach()
>   xfs_free_eofblocks()
>   xfs_inactive()
>   xfs_inodegc_worker()

What kind of inode do we actually get here?  I guess your test
case reproduces an unclean shutdown and this processes inodes
that otherwise would have been processed on unmount?

I'm kinda tempted to just make xfs_can_free_eofblocks return false
during early mount (or rather during mount failure), as trying
to fix all the corner cases here seems like an uphill battle (
also see the sashiko review)

