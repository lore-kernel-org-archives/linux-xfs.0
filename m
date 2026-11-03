Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793743435;
	b=N1S6OKLxWxmsSQHhXTHrnpiI8T8yDtcMpX0weOaaJd5yFb/VovpSyFLs/l6X/OFogTY+
	 IuOJTeNRixLm9abhqFSQOwE//CCNU1Mj/zW22CwoW9CFiq9C1a4MXHpNOjwBZ03kBI8LA
	 ggqcDvPl7RU26YdVYtk4DWN5gXH8l+oHQb9ku6svKT9kjcUazV8nVckVUer1peDWJluuK
	 8NeYYzQ9/x80BJve/d1b1a8DVfgWcMDUL4WZcWrQ1d9TlWxvxiZUXiWUUoiCTSDvHiWSd
	 pD192cP06SmJO5n3TwdeGuzZPjEDcygxL1tTviur3QrEi+6Kmmm/1mNTBxoUbqqTIYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793743435;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=zNY1o5gKld28qZUNYF5vx8GzLX3Du11VLZBCNqbzRCs=;
	b=F2IzYhP+H7o861O5ME1bzXvk/gEEpRII0jpfPIULNaeaMlGxi/gHSCJ267N3sUxQlc9v
	 ScoFqq158nKzkCrKd/jSWIXvwbdZbGqhbcUlTqeCUhC1A7FzWZZoF/ZadOqhsp1bVO7n2
	 2f7UphDzDGXnwBwh1jMido1wx55wOcm7KkGVywpXzgKk3E8sr6XgNVu3Ldh4OUNmK76Cx
	 NG5+3l4Cqt4yG762ExuGCqr0rNLmeO8uXdpwCBshE4lDDLPbxQJd39shs4QRoXxgDOlrO
	 Jp6f+N+o21PX5LYEFZuDa04CC4BhBtC6TqrB7iZ5NBjhg3PYFCqKJGjgqElnYA5gPqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nJpCi3XT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223F0608363A;
	Tue,  3 Nov 2026 22:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nJpCi3XT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E87F1F000C1;
	Tue,  3 Nov 2026 22:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793743434;
	bh=zNY1o5gKld28qZUNYF5vx8GzLX3Du11VLZBCNqbzRCs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nJpCi3XTqqrS8GqmganeqaUkJpYGHb0/M+m606qwT2Wt6G38M5cT40t8l6XB1oZh6
	 OYg/4vgeBzFUeHoypbIozT2BWZabdzEEq1nyJWtSKfVhePyZCIzeBRWRWlddGCwKbp
	 qelWtdvuOVxLexD4tQV8gWgWFOMekZ5ODIg453T59hCOM1oy9OvyZroczILOiiPqee
	 dTu2dZ/ighVGWYUGC4yI0sMg0oDMx2JKjgV71seTSRDlj4sRYbaRwUdQdh+Iy3vbfs
	 qeETvU6cd8yxzoWS+HY3+rbJq8s0I8zMRvKMzxqSwZPueM6BP4ZBgwkvyuSfEixb5M
	 g3ERbv/IomB2A==
Date: Tue, 3 Nov 2026 14:03:53 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, hch@lst.de,
	Carlos Maiolino <cem@kernel.org>, fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	david@fromorbit.com, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH v18 05/15] xfs: handle fsverity I/O in write/read path
Message-ID: <20261103220353.GA2281@quark>
References: <20261102144147.2393369-1-aalbersh@kernel.org>
 <20261102144147.2393369-6-aalbersh@kernel.org>
 <aumrai1iWxj97svo@infradead.org>
 <aunQUzz7AV-qvys-@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
 <aun1e6gedSrVDuRQ@infradead.org>
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
In-Reply-To: <aun1e6gedSrVDuRQ@infradead.org>

On Tue, Nov 03, 2026 at 06:53:47AM -0800, Christoph Hellwig wrote:
> > > Sashiko complained about this, but I also really don't understand
> > > how setting ctx->iomap.flags before we even get a mapping to start
> > > with make much sense.  This should be set together with filling the
> > > iomap either way.
> > 
> > The problem here is that when we found a dirty folio to writeback,
> > and we know it's beyond EOF, how to find out that's it's fsverity
> > folio. We don't have any fsverity metadata attach to an inode yet as
> > we are in the process of creating it.
> > 
> > This is not a nice workaround here, but I use stale iomap.flags
> > here. So, every next folio in that iomap has the stale flags from a
> > previous one, which has fsverity set. This should be fine as the
> > only folios written, at this point, are fsverity metadata.
> > 
> > Here I set it for the first folio in the iomap, to get it started.
> > Otherwise, writeback will just will not continue on folios post EOF.
> > 
> > This could be probably done by elevating "verity in construction"
> > into inode_state_flags *shrug*
> 
> Lifting the flag to the VFS feels like a good and nicer than finding
> backways communicaton channels through iomap.  And once we have more
> file systems supporting fsverity a common flag vs one in each
> file system might be worth it even without that.

I don't feel great about reserving space in 'struct inode' just for
temporary state of the FS_IOC_ENABLE_VERITY ioctl.  However, i_state is
currently using only 20 of its 32 available bits anyway, so it actually
would make no difference in the size and there are still plenty of bits
to go.  So sure, if adding I_VERITY_IN_PROGRESS makes things easier for
now, it sounds okay to me.

- Eric
