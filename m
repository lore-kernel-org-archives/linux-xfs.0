Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CCFA314D1F
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 03:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789962005; cv=none; b=blwWW5PIg7swmJH+izq6pG2O0zF92skaxBP85vEDzCbPS8sXgt56fxLhk5CGaZ8teLJ3YsFnGa46wGyoMa40hcKRBf2PnCGqRPE6/mtC4nll3W59is/Vlapwg8dGwkhdq20uGW9gAX03vm7iqX5QXVcJd+gRhly2tICSemxT6nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789962005; c=relaxed/simple;
	bh=GAowq/dBINUACDh+u5duCNjeV+bFKzZCHtTzi2UqqYA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EBHz/IHaOcK9asQ2GWdM39UJKrSg0DgzTirxkyo4KoIcrar/S8bnf+lk6SgbNDYo7JnSgCu12Nkhc6P1Ns8/q0Sz7bZziZM1nLATSVSBgY8oNbXIBJk7Y8KjdSXqWinPnfXpU0+T6CrpXBaF7M3Z3mluhaNsfXdv43GqCFcfX3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=imumJcAe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="imumJcAe"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A09801F000FF;
	Mon, 21 Sep 2026 03:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789962003;
	bh=TGTri38YrU1R3YIU910egb/w+F9YO9QlPRyi2gCidFc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=imumJcAeUg1rbVgF6eHc6n/FQfefrQ1Q6JfJXTnx8EaToNreEJea1mASjDGiv7h2c
	 hPJ7tbFjiws8KEcIIxPJ4GdNs/VEMkJGPDdJw5LvB+S+RoQfOE/ffAPl0NH0XY+qvm
	 qNb47pICEs7kSMUrtXj5uohsJ5j/9dLEO9rj0xFjaeM7BYFvvFJ5ceOUil9pIMxXio
	 JR2S1kbB5zt56lUNY586wpaeDIIZhyc+s5iNbQTEUfyD/u0hQHvXknAZcvx7jaboPD
	 ZdKalVOAxDirK23ZR4S+CVwb+cKhOiPrKlVjRccyJS+8r2LTsDYC10V897SsaIzuVH
	 Xk29tOR2jE4Ew==
Date: Sun, 20 Sep 2026 20:40:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH 0/2] xfs: dedupe realtime rmap btree code
Message-ID: <20260921034003.GG2705364@frogsfrogsfrogs>
References: <20260918181324.2472127-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918181324.2472127-1-sandeen@redhat.com>

On Fri, Sep 18, 2026 at 01:01:31PM -0500, Eric Sandeen wrote:
> xfs_rmap_btree.c and xfs_rtrmap_btree.c have a large amount of
> duplicated code, differing only in function names which add "rt"
> in the latter case. This can all be shared to reduce the cut & paste.
> 
> Tested with an auto xfstests run as well as the rmap group with
> rtdev & rmap enabled.
> 
>  xfs_rmap_btree.c   |   16 +--
>  xfs_rmap_btree.h   |   26 ++++++
>  xfs_rtrmap_btree.c |  230 +++------------------------------------------------
>  3 files changed, 51 insertions(+), 221 deletions(-)

In general this looks good to me, though I'll add that the same sort of
code deduplication could likely be done to the refcount btree code too.
;)

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> 
> [root@fedora-rawhide xfstests-dev]# ./check -g rmap
> FSTYP         -- xfs (non-debug)
> PLATFORM      -- Linux/x86_64 fedora-rawhide 7.3.0-rc3+ #330 SMP
> PREEMPT_DYNAMIC Fri Sep 18 10:23:43 CDT 2026
> MKFS_OPTIONS  -- -f -rrtdev=/dev/loop0 -m rmapbt=1,reflink=1 /dev/vdb2
> MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0
> -ortdev=/dev/loop0 /dev/vdb2 /mnt/scratch
> 
> generic/365  2s ...  2s
> xfs/114      3s ...  2s
> xfs/233      1s ...  1s
> xfs/234      5s ...  5s
> xfs/235      1s ...  1s
> xfs/236      6s ...  6s
> xfs/271      2s ...  2s
> xfs/272      2s ...  2s
> xfs/273      4s ...  5s
> xfs/274      3s ...  3s
> xfs/275            [not run] This test requires a valid $SCRATCH_LOGDEV
> xfs/276      3s ...  3s
> xfs/277      2s ...  2s
> xfs/310      0s ...  1s
> xfs/317            [not run] XFS error injection requires
> CONFIG_XFS_DEBUG
> xfs/331      2s ...  2s
> xfs/332      1s ...  1s
> xfs/334      1s ...  1s
> xfs/335      4s ...  3s
> xfs/336      5s ...  5s
> xfs/337      5s ...  5s
> xfs/338      2s ...  2s
> xfs/339      2s ...  2s
> xfs/340      2s ...  2s
> xfs/341      1s ...  1s
> xfs/342      2s ...  2s
> xfs/343      2s ...  2s
> xfs/450      1s ...  2s
> Ran: generic/365 xfs/114 xfs/233 xfs/234 xfs/235 xfs/236 xfs/271 xfs/272
> xfs/273 xfs/274 xfs/275 xfs/276 xfs/277 xfs/310 xfs/317 xfs/331 xfs/332
> xfs/334 xfs/335 xfs/336 xfs/337 xfs/338 xfs/339 xfs/340 xfs/341 xfs/342
> xfs/343 xfs/450
> Not run: xfs/275 xfs/317
> Passed all 28 tests
> 
> 
> 
