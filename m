Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826726;
	b=bL2kV/woxYkMfmZLJ0eNUUZoUbEqH4FwXQUHWCIAHBC1zgoUKg0/dCIYjyZxxJ584Oph
	 j9L22UFXLt8AoKJ31eCiFc99lj2iyBl4o1iSeuNT0/2TnOEmEvTHHGUiC8daz5XuflHOC
	 E3T2KjR8tn26VlnqsSSPx/hJw9Q1K+dH5nO/JpnkhbKEfX8BULiJU+9xJmp8g8OmJZdJ9
	 MiTMA1Sb6Jz+0W4ZhZ17A6uuUTfFfF2jUZEhja5rqHxpYKggdF1DUE7xln49GsMhuO9CQ
	 Y8WRzho02tve/jPEHNIau7kdYa04KI97DcIip+nbzWMXC4RV+T2mIMQOTj08ayDW9Tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826726;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=cIEShrT0jFeuA5ogvweS7WqvQc7l2e9mZFD56ht6fXE=;
	b=ZG10SnjBgoHzmMiG3PsHEVrrN/S5MYDnZLZK25wiSsv2PAudVUnoAFSo3R8RW9K26hLW
	 4dve1Mlk5kawMc3lhBH4S1ohYBlUnBFFOUNtlR4TkIt5MDTjiLJYWEkpFAHxl+l+TG3dz
	 tef8wJU3jkm8zUGJscuKoSbbMoosiVuGAK91rMT5MpItJzMN+chX6sNGAWs661tAIVvrA
	 yZSG2F3jjUDo83agRkWmphlH/YB1YqkAp3vcJcxST9jEje5NhPZ8JYrRRJcIpmDtdPrTL
	 2ASKFjzKZWWcyuJWfjjCNEcee0YAsmXrRH1PtY3/opKkLBm7FWB0AylOV0VVh9gguAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ezglBNM+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFB7606D81F
	for <linux-xfs@vger.kernel.org>; Wed,  4 Nov 2026 21:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ezglBNM+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C55DB1F0093A;
	Wed,  4 Nov 2026 21:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793826725;
	bh=cIEShrT0jFeuA5ogvweS7WqvQc7l2e9mZFD56ht6fXE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ezglBNM+XAuRrn4u0EIiw3ADvuAOu5P0HrFDjp8B5rzy4dQ7ftfPUgBjdbdh2h2et
	 s4z/mHhwnhqCOHdxutrutmziVp0ANaup/tcHN7KheCjqVAFYoIEbazKY9UtAbQ0XNF
	 5RVckW55yBAHGHauszz4X/0ZTVYzRkPoPjD3vmiFPknvEDPW7Al7SghKi5ujxH3Did
	 W5XiU40mP1jIm5BUcpQPtkRXJ74rgJNwgBQODq48JcoL2zabBCQj8jm6c0VxjV/j4g
	 P7wyNpDuSxnWwcXTbquGvKksEfPRbZpD1+38cqoiUch978py3krMZ6LAb5hboWg9DC
	 mvGL0vsEfJTmg==
Date: Thu, 5 Nov 2026 08:11:57 +1100
From: Dave Chinner <dgc@kernel.org>
To: Lauri Gates <lauri.gates@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Subject: Re: Concurrent FIEMAP on reflinked files serialises on the AGF
 buffer lock
Message-ID: <auufnV0S2g7mUtQG@dread>
References: <aulwLCnibXfaMzR_@infradead.org>
 <20261104124118.34200-1-lauri.gates@gmail.com>
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
In-Reply-To: <20261104124118.34200-1-lauri.gates@gmail.com>

On Wed, Nov 04, 2026 at 02:41:16PM +0200, Lauri Gates wrote:
> On Mon, Nov 02, 2026 at 09:25:00PM -0800, Christoph Hellwig wrote:
> > FIEMAP is purely a debug interface for file system developers.  So
> > running it in parallel for lots of files is highly unexpected and
> > suggests a misuse of the interface.
> 
> Understood, and that is why I am looking at the alternatives below.
> 
> > It needs to protect against agf_refcount_level changing, so yes.
> > In theory it would be fine with a shared lock on the AGF buffer if
> > we had a shared/exclusive lock on the buffers (which is something
> > I've wondered about a few times before), or some other high-level
> > synchronization against adding more reflinks.
> 
> Thanks, that answers it. If shared buffer locks are ever tried, I can
> run the reproducer against the patches.
> 
> > The more efficient way to do this
> > would be to subtract the multiple mapped extents based on the
> > refcount btree, i.e.
> >
> >	for each AG (and RTG with rtreflink):
> >		for each entry in the (rt)refcountbt:
> >			subtract rc_blockcount * (rc_refcount - 1);
> >
> > We'd need a new ioctl for that, but it should be pretty easy.
> > The major downside is that this only works for whole-device du,
> > but then also any other version would have a really hard time figuring
> > out what to do with reflinks the span the reported/not reported
> > boundary.
> 
> A whole-device total would be useful on its own, but du tools mostly
> report per directory. dust handles the boundary by counting each
> shared extent once within the scanned tree, so a block shared with a
> file outside the scan is charged to the scan in full. That is a policy
> choice, and it needs to know which files own which shared blocks.
> 
> GETFSMAP already returns that: with rmapbt, each shared range comes
> back once per owning inode. On a test image with 100,000 reflinked
> pairs (7.2.12, arm64 VM, xfsprogs 6.6.0 defaults, which enable rmapbt),
> a whole-device fsmap walk took about 120 ms, against 387 ms for a
> single-threaded FIEMAP walk of the same 200,000 files. But it returns
> owners only with CAP_SYS_ADMIN, as ioctl_fsmap(2) documents, so it
> covers a du tool run as root and not one run as an ordinary user.

fsmap() takes an arbitrary open fd on the filesystem being queried.
We could allow owner-based queries if the owner in the filter key
matches the inode backing the fd that is passed into the query. If
the task already has a file open for that inode, then it's already
been given permission to access/read metadata for that file (same as
FIEMAP).

Cheers,

Dave.
-- 
Dave Chinner
dgc@kernel.org
