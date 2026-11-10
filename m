Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794330047;
	b=VsrnNn2tlP57RTqY8q0eET6wV4K0Sqq9I+MPPLo+N+Cm1v49SLTd8WWpscvbmECYosei
	 nUwF9Ba19jm4Ks5szQOTxpVjrivdZ+tgl2LBbV/6dfd2Jt2yUATIs/fhkyjPEGTJ4sqv8
	 idQUiaTFuy+EqM9RxlHeerO+5ODRsDK4GUCKSGk5oUMYUrBa8gtw1mZpsoaht7pALAouK
	 yKfXhY5+9Xju9KiO9p8B3irL1YyKDnraXXwuiCS1p75JqAiJtfgkAItL6afj5RZkiO5RG
	 6Xdek6p5OIpJy4AwUwMd0Q4W9hSvOxxngQq+xDL8DqqIZUzGNf1c0x8XRpec4zKHOZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794330047;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=KP1IHAnBftL3owoHtCP33JL7OGcqfPbJ6nUyvwz3tSI=;
	b=DszEzI7Y39BA1wTscTVu/genCwiluLKMkfflQIDkiRWERpGwaHogr5GAhtUbS4OBaTgr
	 D5e0Gn4pltLVSwsGgExp37zFLXwx6OC+rN+l6ew9bwIXmOVL3r2toryHAxP/z+SMoRPrI
	 BARKHsogoHqQ87P9LGnm3syOzvPFeKkjG87JhdB+zA5RDIW0BDkx2lsqTn/vAsCd/uVsZ
	 Sy7Zoy7aW8Iosji5S3rn2CkhyS2UET7bAIpDPpgpRYOLlJWW8Yq3aOXI7PjPlDD3yGpbU
	 Sah19wS91pEKSbyRk5VVTmhqbNRPJwZXv9oCKfO06l+G3e4sOYl8TrMnJdXF+oP0okQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l7QyNobZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA53606A9DC;
	Tue, 10 Nov 2026 17:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l7QyNobZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 899B61F008A1;
	Tue, 10 Nov 2026 17:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794330046;
	bh=KP1IHAnBftL3owoHtCP33JL7OGcqfPbJ6nUyvwz3tSI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=l7QyNobZD3dsdFBF8Uk/xweFPhYxLJ1q++IdpnUtL9tLIZIUqU/qid62Y+3xXL3HW
	 71ugnsRtfax1eGiLiQMpSDXhFc66KimrDX0tWx2clrl38yzeLFmFXqaWlxdLMsEgPf
	 RM5pAZ70BHuG+yXxOFPzR4rKFKi0G8kyMln2B8PBuFuDgQ1r4yxXQp63rcm1Itjnww
	 LtyuYYuwpkCKMk4dANG2Dfaz2ZTpyKxYNhsQePreBZgq0WbA/RNJJHsRfKVEKZt0Mh
	 FRQQw+fNV9+G1yK87YNyOgqoPCa5zvWtjPTk3DjpPpc5sfKFS2bgtS/cf+0LK78791
	 8804g1yaFIQZw==
Date: Tue, 10 Nov 2026 18:00:39 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Chris Mason <mason@kernel.org>
Cc: Theodore Tso <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>, 
	Jan Kara <jack@suse.cz>, "Darrick J. Wong" <djwong@kernel.org>, 
	Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v6 00/10] reflink and atomic write bugs
Message-ID: <avNNrl6K87v3-Czo@nidhogg.toxiclabs.cc>
References: <20261109235111.14129-1-mason@kernel.org>
 <avLnU46F6YZckcbo@nidhogg.toxiclabs.cc>
 <d17350c0-0b93-4421-8bab-8266419fbd77@app.fastmail.com>
 <avNEiPY9D2ItmEMu@nidhogg.toxiclabs.cc>
 <5bf88df7-a231-4013-9127-156b58241094@app.fastmail.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5bf88df7-a231-4013-9127-156b58241094@app.fastmail.com>

On Tue, Nov 10, 2026 at 11:32:51AM -0500, Chris Mason wrote:
> On Tue, Nov 10, 2026, at 11:22 AM, Carlos Maiolino wrote:
> > On Tue, Nov 10, 2026 at 10:56:34AM -0500, Chris Mason wrote:
> >> On Tue, Nov 10, 2026, at 4:45 AM, Carlos Maiolino wrote:
> >> > On Mon, Nov 09, 2026 at 06:51:11PM -0500, Chris Mason wrote:
> >> >> Hi everyone,
> >> >> 
> >> >> This series did a few rounds privately, but looks ready for the list
> >> >> now.  Except for Christoph's patch, these were all found and fixed
> >> >> by an LLM.
> >> >> 
> >> >> The meat of the series is fixing reflink corner cases that incorrectly
> >> >> let you write into the source of a reflink.  LLMs also tripped over a
> >> >> few ways to use atomic writes to expose stale blocks on the drive, and a
> >> >> few races with realtime flag manipulations.
> >> >> 
> >> >> Carlos and Christoph ran these through fstests (thanks guys).
> >> >> 
> >> >> Chris Mason (9):
> >> >>   xfs: don't skip the flush before shifting extents
> >> >>   xfs: flush the shifted range before changing the file
> >> >>   xfs: don't change the block map under a dirty folio
> >> >>   iomap: don't punch delalloc under a dirty EOF block
> >> >>   fs: validate atomic writes after O_APPEND and limits
> >> >>   xfs: recheck direct write alignment after write checks
> >> >>   xfs: test for reflink after the dio write checks
> >> >>   xfs: refuse fallocate racing with realtime flag changes
> >> >>   xfs: restart faults racing with realtime flag changes
> >> >> 
> >> >> Christoph Hellwig (1):
> >> >>   xfs: refuse writes to files racing with realtime inode flag changes
> >> >
> >> > Sashiko found a few issues that I believe are worth looking at. If there
> >> > are no objections though, I'll pull in the first 4 patches which are the
> >> > most critical ones so far until we figure out the other ones. If there
> >> > are objections please let me know and I'll revert them back.
> >> 
> >> I'm generating fixes for the rest of sashiko's comments.  Looks like they
> >> all existed before the series, but might as well fix them while we're here.
> >> 
> >> For sashiko's complaint about patch 6, the patch intentionally creates
> >> the behavior sashiko mentioned.  We were inconsistently falling back
> >> to buffered before so the behavior is new but the writes are correct.
> >
> > FWIW, I pushed the initial 4 patches to xfs-linux/xfs-7.4-fixes, of
> > course I didn't push them yet to for-next as it depends on you if you
> > are ok with me pulling them first before you deal with Sashiko failures.
> 
> Thanks, taking the first 4 for now works for me.  I'll keep them unchanged
> in the next version just so things keep applying, but will assume they are
> all set.

Sounds good :)

> 
> -chris
> 
