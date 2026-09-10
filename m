Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5A4492E30;
	Thu, 10 Sep 2026 16:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789057185; cv=none; b=QPaNzJkfcfGGmN4wJVWlijBvFQwp8OSqkC2YClW9bidnygns0SpxtZATYLDqm44g6BBcRBRwSYNwq83t7xsGsFBRG7spOG7+EAWswpjU8Tc2WNSNuNOhKR785fpn98rR6GLFyhtzulCHeoOsg/U33e8jYLAEZJoMPn5zOH5fkBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789057185; c=relaxed/simple;
	bh=poOs0EsCyT8eVkYc+CgmQkC4j2SUob4C7e3WjBWCRKw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=slH7LPWO6UXlWkmV/66gj8p+0JAC1RtDuFHCk2hXbZFSGPm9ZoC6z7yTTKJ3ZN1r6wc7N8gFiajiTSA43KhSVX3YPgCesfSQummr5y1Yn4oDu2Ek5nLNv6Vt+F/nFZwOlHiqDhYO6ktMs6TLYjL4elFLG/dsphq/Cjfuh84Pzb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Raq5idn/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Raq5idn/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B03D01F000FF;
	Thu, 10 Sep 2026 16:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789057183;
	bh=9tji9TvjK3FbQlpwIl+uFXlbCmOsJLs/G2leRQOj0JY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Raq5idn/4MDHLO8OssV7+WfcPDWY4iUOQlWvtgAdPrfD4E3g5waLWTwXyAf/wHAKJ
	 ntNtPZSyy0DgazdRq94EqHbKQZ9iSfA7oN7JTBxvFN0bR4mnoNPnG+gFL3kjkV8eaK
	 OOsQ0DKGzFCH5cgQTrZf/smYaHT6nlTtDwttUBFErQDQ/xkeIt0kZfqz501Pr9zw6l
	 8fcC+4EoEbrYnndB0dSxVctpDKDK91nrX7NZjBwaN30eW6RzjsplKkXQw/xEhi3E+2
	 /GA5HS8qk918JPOJKuaSW6eEOQcIwoNhzprgP6Bm2Hk9XadkGxf5EHWwgFYw6r217G
	 nOzGMO8zyqZ0g==
Date: Thu, 10 Sep 2026 18:19:37 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Jeffin Philip <jeffinphilip14@gmail.com>
Cc: dgc@kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, syzbot+a4fde844548510369112@syzkaller.appspotmail.com, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [xfs?] KASAN: slab-use-after-free Write in
 xlog_cil_ail_insert
Message-ID: <aqLYgFQlF5EM8KIH@andromeda.toxiclabs.cc>
References: <aqI6v-_dc2DDSbgB@dread>
 <20260910154725.18960-1-jeffinphilip14@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910154725.18960-1-jeffinphilip14@gmail.com>

On Thu, Sep 10, 2026 at 09:17:25PM +0530, Jeffin Philip wrote:
> On Wed, Sep 09, 2026, Dave Chinner wrote:
> 
> >The short term fix is to slap a bandaid on xfs_buf_submit() to wait
> >for unpin before erroring out a pinned buffer on shutdown. That,
> >however, doesn't fix the underlying lack of full lifecycle reference
> >counts for log items.
> >
> >The long term fix is have the AIL require a reference count to be
> >held on log items it tracks, and only have that refcount removed
> >when the item is removed from the AIL. That's a much bigger rework
> >of the code. 
> >
> >FYI, I've attached two document below - the design for
> >generic full lifecycle log item reference counting, and the design
> >for converting the inode log item to be dynamic similar to the buf
> >log item so we don't end up with millions of ILIs that are never
> >used left sitting around in memory until it's owner inode is
> >reclaimed.
> 
> I read the documents and have started writing the wrappers. Is anyone
> else working on it?
> 

I was going to as it clashes with some work I've been doing on this
area, but if you already started go for it.

> Thanks,
> Jeffin.
> 
