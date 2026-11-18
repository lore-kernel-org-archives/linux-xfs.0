Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794993734;
	b=GvaxGtRm9IWM5xtSCfQK+DQy+XBhEv16a0mIVtqSdPM5XuGxUS/f/zNJFOWVBQbO4y5I
	 RUizCqI8RVdjgoO9rROn23nHRZ8Ol4AHuYiRxdjtELoG+KfQv0EG6XIZ+yUSLnm3Sfut3
	 /Qg/F699/2tVcCipOqC9bRKBqJaf32+zH5sEfhu5qmHekW4RkPwlYlINJwrVQCK5Q7aD6
	 CQPANTbJT4clopU4SuyaRd1Gk0w6X0fdsY7nVE7u6/+APXBtj8Fxql5P1CK7P9dE17tb7
	 WULlF3lik1+/HMzKf+PKNQcPZFqDB81WtN+QLCsBAp6sqOvYuh/F8MP0lv+ZOrORtBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794993734;
	h=Received:DKIM-Signature:Date:From:To:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=+eRM7RCxKkjUM1SLXVJaR+ztORC3O6DdbU7dKPK3eLA=;
	b=1IlG0X2j7KVia0/Lknl4thFlOOQNkqW1o6ZzHFUy4U07OflP15Eh36cimU7GkbnbeUNl
	 lKiRH+R/6bDg6JOcMPmoG8awAztJsxiWkKub32OdNOqah4vGgdPuJg71QAMgDbe4Iw7uv
	 /LZKaDJmOxZOF2K5OzM/1jD2M3aNzz55Qaft6chtotqqrvnm5Qg5iT+23dzxRnJ5prXKd
	 SFLmvZVk0oVhUEUUhvqo3Vr3/knplJXBJ5+urVhYT/AnNNIVVWADT34FRZGoH31EwNoNN
	 waDJgh6InHrCUgydZE76xyOUt7l9dKqK9tzWmeGt/ul0kuwcOx5iKee/bgrnkF3gWSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="OSe3oD3/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999D0606A320;
	Wed, 18 Nov 2026 09:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OSe3oD3/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD8D1F000C4;
	Wed, 18 Nov 2026 09:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794993734;
	bh=+eRM7RCxKkjUM1SLXVJaR+ztORC3O6DdbU7dKPK3eLA=;
	h=Date:From:To:Subject:References:In-Reply-To;
	b=OSe3oD3/Du+96FBmnQRQAzAqUg/m60SZdQA2eyCHhhPyP5Hbv/o94vUn16fWHYziR
	 6q1dzjS5Qd/8fAOPm5ZsHUxi/qENZiYcakksIu+yyy4of8iwbh97G+qLJbEV1hPn5S
	 lFA8Cb+CA6wdOYuHT4tE3nCKxfKoDGcnntmNY1fhiymEjVM8awnYvVbmBmK2CcPI3Y
	 hwe7Jq2b3Mhe7VjoxExeMtBp1+M85wkX6nKqpuL3D6A+7Ba93bPJ/xgUrUuARnb65U
	 ZBHAYJU/axV25NzfUoejoDMdR08I+02GjY8JmkGmN2Tqbou0pkEJ0Ky2uAAfdRlUDM
	 V7Q2FE7Tp6VdQ==
Date: Wed, 18 Nov 2026 10:22:08 +0100
From: Carlos Maiolino <cem@kernel.org>
To: tytso@mit.edu, david@fromorbit.com, jack@suse.cz, djwong@kernel.org, 
	josef@toxicpanda.com, hch@lst.de, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, tz2294@columbia.edu, 
	brauner@kernel.org, Chris Mason <mason@kernel.org>
Subject: Re: [PATCH v8 00/15] reflink and atomic write bugs
Message-ID: <av1t_kTHq6CMHcCF@nidhogg.toxiclabs.cc>
References: <20261112010229.51029-1-mason@kernel.org>
 <179499232752.5574.398287961322700808.b4-ty@kernel.org>
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
In-Reply-To: <179499232752.5574.398287961322700808.b4-ty@kernel.org>

On Wed, Nov 18, 2026 at 09:58:47AM +0100, Carlos Maiolino wrote:
> On Wed, 11 Nov 2026 20:02:29 -0500, Chris Mason wrote:
> > [ the send command got interrupted apologies for the two dups ]
> > 
> > This series did a few rounds privately, but looks ready for the list
> > now.  Carlos has accepted patches 1-4, but I've kept them here so the
> > whole series can still be tested.
> > 
> > Except for Christoph's patch, these were all found and fixed
> > by an LLM.
> > 
> > [...]

FWIW seems like B4 didn't realize not all patches were pulled.
Specifically patches 5 and 6 were left out.

Just explicitly mentioning it so somebody do not get confused.

> 
> Applied to for-next, thanks!
> 
> [01/15] xfs: don't skip the flush before shifting extents
>         (no commit info)
> [02/15] xfs: flush the shifted range before changing the file
>         (no commit info)
> [03/15] xfs: don't change the block map under a dirty folio
>         (no commit info)
> [04/15] iomap: don't punch delalloc under a dirty EOF block
>         (no commit info)
> [05/15] fs: validate atomic writes after O_APPEND and limits
>         (no commit info)
> [06/15] xfs: recheck direct write alignment after write checks
>         (no commit info)
> [07/15] xfs: test for reflink after the dio write checks
>         commit: 3b6942b132033cbc3f6566f698709d9038daf7b2
> [08/15] xfs: refuse writes to files racing with realtime inode flag changes
>         commit: 7b2438af4d91dcb8fe3de99e55beb06f3c168309
> [09/15] xfs: test for always COW after the dio write checks
>         commit: bdc3ee45df55d8aa478d8a5d6a7e9b1186f511ba
> [10/15] xfs: refuse fallocate racing with realtime flag changes
>         commit: f01f70e00770c6d21b468f80b488e6407a6947dc
> [11/15] xfs: restart faults racing with realtime flag changes
>         commit: 03cbbd80a3e7070e8ab63996a94a7815722c2578
> [12/15] xfs: test for an extsize hint again under the ILOCK
>         (no commit info)
> [13/15] xfs: resample the extsize hint after taking the ILOCK
>         (no commit info)
> [14/15] xfs: resample the COW extsize hint after cycling ILOCK
>         (no commit info)
> [15/15] xfs: don't enable DAX on zoned inodes
>         commit: 44e555acd77a839110f3b1e02a75f9165baaaeec
> 
> Best regards,
> -- 
> Carlos Maiolino <cem@kernel.org>
> 
> 
