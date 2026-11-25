Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.102
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795628290;
	b=gSG+SV2ZDMPtPp1RJYHjT9w54wb04HxcYqqORdetFqlK5mt+n8BvI/5wVyBezsMuOgWy
	 xbuOe7LGMDOzhnlmDza0hBmy5n1//yi5zx3KFkWJNIhf2B7Spf1VnThwS56knp9nqAWQQ
	 QA1qg/SiqEqQyxHRSNCnpzqnHiS/UcjpnvZmqBR9f2n4zBlfR2qD4KaNKGHVMLCx8BiYj
	 xNUHmCb9l+OxQL65Fp4koKvt+DoDeZ3sy1L0N4q4TC4ki2TECoPFHgE2yRPqF+ACvIeuM
	 fNpa3QxumpaMVN9O40L2sFzVC1pqyRHyF5/molEKzqvb04GnfXcoxHdVZ+OmwOlPm5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795628290;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=gAcavlN73Ya35kPG8jV5KeGYcjZOWAaF1oYlQD8iN5w=;
	b=W/iYmPitJZJbXW821mrRIfysttzesz4kMjwgpAKBslozDJWFn0o0UfeS6QH4pttpWtgE
	 85r8kmNJPlxPlmFTsTly9Yw5hj7wBQLt4WT5qxyeB7E0UtgKI5FeNUQq/obKT29WCi2fL
	 Oo5gUI/fHV5lDJj7yNZ3M90QCGEXZPNlb6H63YXaok8PjFSbCKaPALXlncMGjsUv/6mjQ
	 0435xbCcAxfFKspunsStEACFALFtvXUnjDuQQqsBub+G4tXkn040v0jDsac8EKVQjEccZ
	 O6ZfSu3zXPadDAnqZgCC+bnw/5JoIrqPnMuBKwdBAss1KfFbGi9isDk2EbKw4Y55Pgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=proton.me;
	spf=pass smtp.mailfrom=proton.me;
	dkim=pass header.d=proton.me header.i=@proton.me header.a=rsa-sha256 header.s=protonmail2 header.b="f8RE/aLu";
	arc=none smtp.remote-ip=79.135.106.102
Received: from mail-106102.protonmail.ch (mail-106102.protonmail.ch [79.135.106.102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF194606A331;
	Wed, 25 Nov 2026 17:38:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF194606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=proton.me header.i=@proton.me header.a=rsa-sha256 header.s=protonmail2 header.b=f8RE/aLu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail2; t=1795628280; x=1795887480;
	bh=gAcavlN73Ya35kPG8jV5KeGYcjZOWAaF1oYlQD8iN5w=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=f8RE/aLuMO7y6xfH6FYf9K2lVlTw6JA66iLH5dzXM/MikPcfj6UyoOONQqQMBDQxi
	 9n8NX6KASD3e7fEEMowcp/Bb64dxxubWm09DjJvoNFOGcbBSRzte+f9RMiBwVbLRmW
	 SV54BACFWgl0RNBUM+aNJB32SAK/M9LR125Q/BQbHhl86qhOzLoqYplZlgisCoPddd
	 +3MMhOhRpDNwXbJPzMvKXDieMLyMC8HMZjsX5h9r0wCpGdtEypGLorKsXAzyZmNcPN
	 ql947HEFM7GP2TMT8VSq1xo76AQFtN+zrTSEBFX8E0yfixHdTR3KzEusKbJujXcnOP
	 xd8BlnvoSUuSg==
Date: Wed, 25 Nov 2026 17:37:54 +0000
To: Christoph Hellwig <hch@lst.de>
From: Ernest Borowski <ernest.borowski.git@proton.me>
Cc: ernest.borowski.git@proton.me, Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, Baolin Liu <liubaolin12138@163.com>, Christian Brauner <brauner@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, ntfs@lists.linux.dev, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Zhan Xusheng <zhanxusheng1024@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 02/11] iomap: add a helper to mark a range of a folio dirty
Message-ID: <179562827127.336908.5205349169070022087.b4-reply@b4>
In-Reply-To: <20261125055016.GB20604@lst.de>
References: <20261124-b4-ntfs-delalloc-fixes-v2-0-f394c800ec03@proton.me> <20261124-b4-ntfs-delalloc-fixes-v2-2-f394c800ec03@proton.me> <20261125055016.GB20604@lst.de>
Feedback-ID: 236360163:user:proton
X-Pm-Message-ID: 4839e5da1363b7916307013b17874d66462b3b46
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 25, 2026 at 06:50:16AM +0100, Christoph Hellwig wrote:
> If we end up with this, iomap_dirty_folio should be rewritten
> to call this instead of duplicating the logic.

Done for v3. Both now share a static helper, and iomap_dirty_folio()
keeps passing the mapping it is given rather than folio->mapping, as
->dirty_folio can be called without the folio lock.

> But I'm a little sceptical the use of this can be correct.  I'll try
> to look into it, but it might take some time to understand the ntfs
> code.

To save you some of that time: the user is ntfs_dirty_cluster_tail() in
patch 10.

ntfs reserves delalloc space in clusters, which can be larger than a
block and larger or smaller than a folio, and it has no unwritten
extents. If the copy of a buffered write into a hole stops early (an
unmapped source page, a fatal signal), the rest of the cluster it
stopped in is never written. Writeback then allocates the whole cluster
and writes only the copied blocks, so a read of the rest after
drop_caches returns stale disk data.

Before the unused delalloc clusters are punched out, ntfs walks the rest
of that cluster under the invalidate lock:

- in an uptodate folio in the page cache, it locks the folio and uses
  this helper to dirty only the blocks in that range. Those blocks
  already hold the right contents: zeroes, or data a write through mmap
  added since;
- otherwise (no folio, or not uptodate), if the cluster is still
  delalloc, it zeroes the range with iomap_zero_range().

It cannot zero an uptodate folio without overwriting such mmap data,
and it cannot use folio_mark_dirty(), because that dirties the whole
folio. When clusters are smaller than the folio (1k and 2k clusters, or
a large folio), the other blocks can be holes or delalloc clusters the
write never reached: the punch would then keep those clusters reserved,
and writeback would allocate clusters that hold only zeroes.

The alternative needs no iomap change: when writeback allocates a
cluster, zero on the disk the part the write does not cover, before the
cluster goes into the runlist. A later series of mine already does this
for clusters allocated by a write fault. Doing it in writeback costs
extra zeroing I/O for every partly written cluster, but it also closes
the race where writeback allocates the cluster before
ntfs_dirty_cluster_tail() runs, which patch 10 leaves to that later
series. If you think that is the better way, I can rework patch 10 like
that and drop this patch.

