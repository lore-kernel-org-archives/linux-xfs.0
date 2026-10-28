Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793226394;
	b=CC44MiFUJWEQrdcGuQKKrzZ0y9Zvimgw4Rb/UA8amdDAixPJ6E2dsjmhAR0C/mcVHbST
	 jbiEf55H35+/pyxdKlTkB8/XkTY53UOsZ3H+VEjZ5dTf05lEaqntIcndC2MUn8YoSWgFJ
	 YJ7dJKNkbn1a9FWt+24K6rA3z6nyE1kM7XwYI/tKwGPIJ99pCqWrd6wj1Zd/rL25QzECH
	 apbJA3Y8BEHQWX+a+hhAQSXu4PpVcVdrZ0HTo27GTcvih9FeOvHV9HFttMK+YLTYOgQCJ
	 o/OWPWNHE3b1ksbEdI2crayT8d2cCx2BlRPEF/kRy0DkYwiREtAPATLQJxhWfLM8C7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793226394;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=nMPhte1V9YDQtllfchPqLN25ThaUkzGItwYpG1ED2aE=;
	b=I5TkMniKWTstnm81sO+qkbdDOKDD7DELi7kM7oZ9AOnB2J2bDM1b3jHEPZ0g0D9LLqEr
	 UJb0n6aGLh+WRs2oB4qyaFlCBXfU9dpiciQLQt66xvNFSFz+Mye1MjIuc6jxGs9RjDnwr
	 5Zfs4tEhiU7yWl2V4CvjsYM9Lg6+zpWeCYMt8J4Zh4z/CmWJdRJBKWa+I64KdOsxR69jP
	 OhW8WKTrIvg7yA8ZSO/254xR6hB7k7912164I2AQGmu6nbHSABKGmlS2mpwdDBKiHaQfZ
	 /qH/g4OTWvlxb8X62zlbjnQhAudEL0r1oDY7o9mm0lcP76r20BJiVucDGIYEPlAR3DQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WSoS9fTc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF13606A31A;
	Wed, 28 Oct 2026 22:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WSoS9fTc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE221F01825;
	Wed, 28 Oct 2026 22:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793226393;
	bh=nMPhte1V9YDQtllfchPqLN25ThaUkzGItwYpG1ED2aE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WSoS9fTcZWTUdX1Jv4krn0w92s84+hoC3Yc3vhHnAA96vRdtODwAPLPsqjzaqF+G6
	 QIaWaYTWAPrZDWsN7nIqD3QVeW40znyEkDkzS5K6ZV+bY66wPnHcB0JVA6PyVwHrqm
	 Tn4Fab9v4LRmOFCnCxFNEK+lQ+77eRmbHCLonttVz03p20IIAaQDz3XlTgHpxHPb3u
	 l/xZ4Yip8G8bvZ1BJvmkeobY5WvqgnrNJLYfVi6okYcuEvDSxz8M5b2F5A4BD7Cmw+
	 7D1XPuF1R859EphtoQay7l/ipulNN9nqhsw8uW84ZB/ehykXNZK5wFYM66yQnrelhW
	 CSOqU5WU6jHJQ==
Date: Thu, 29 Oct 2026 09:26:22 +1100
From: Dave Chinner <dgc@kernel.org>
To: Henry Martin <bsdhenrymartin@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	David Hildenbrand <david@kernel.org>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Kairui Song <kasong@tencent.com>, Myeonghun Pak <mhun512@gmail.com>,
	Rafal Ostrowski <rafal.ostrowski@amd.com>,
	Likun Gao <Likun.Gao@amd.com>, James Clark <james.clark@linaro.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] xfs: fix out-of-bounds write from crafted btree root
 numrecs during log recovery
Message-ID: <auJ2jgIIh8e_JJwn@dread>
References: <20261027151703.973392-1-bsdhenrymartin@gmail.com>
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
In-Reply-To: <20261027151703.973392-1-bsdhenrymartin@gmail.com>

On Tue, Oct 27, 2026 at 11:17:03PM +0800, Henry Martin wrote:
> xfs_bmbt_to_bmdr() converts a logged in-memory bmap btree root block
> into its on-disk short form, and it trusts the source block's record
> count for the copy sizes:
> 
> 	dblock->bb_level = rblock->bb_level;
> 	dblock->bb_numrecs = rblock->bb_numrecs;
> 	dmxr = xfs_bmdr_maxrecs(dblocklen, 0);
> 	...
> 	dmxr = be16_to_cpu(dblock->bb_numrecs);
> 	memcpy(tkp, fkp, sizeof(*fkp) * dmxr);
> 	memcpy(tpp, fpp, sizeof(*fpp) * dmxr);
> 
> The capacity bound (dmxr from xfs_bmdr_maxrecs) is computed and then
> immediately overwritten with the attacker-controlled numrecs from the
> source block.  During log recovery, xlog_recover_inode_dbroot() and
> the XFS_ILOG_DBROOT/XFS_ILOG_ABROOT paths pass a raw log iovec as the
> source block, so a crafted log item with numrecs up to 0xffff makes the
> two memcpy calls copy up to 512KB each (8 * 65535) out of the log
> buffer and into the inode fork area (a few hundred bytes) and past the
> end of the inode buffer page: a page-granularity out-of-bounds write
> with fully attacker-controlled length and content, before any dinode
> verification runs (xfs_dinode_verify() only sees the result
> afterwards).
> 
> The same pattern exists in xfs_rtrmapbt_to_disk() and
> xfs_rtrefcountbt_to_disk(), which convert rt rmap and refcount btree
> roots from log blocks using the source numrecs unbounded.
> 
> Validate that the source numrecs fits within the destination capacity
> before converting, in all three conversion helpers.
> 
> This issue was discovered by Tencent CodeBuddy Security.

No it wasn't. 

I've already proposed journal recovery validation infrastructure to
knock out all these 'llm plays whack-a-mole-with-corrupted-logs"
bugs once and for all. The first version of that was posted a couple
of weeks ago:

https://lore.kernel.org/linux-xfs/20261013060204.3138690-1-dgc@kernel.org/T/#t

Sashiko flagged this specific bb_numrecs issue in review top the
"[PATCH 41/48] xfs: validate logged btree fork roots during recovery"
two weeks ago:

| The comment above mentions that the region size has already been bounds
| checked against the inode fork size. However, looking at the callers in
| xlog_dinode_verify_dfork() and xlog_dinode_verify_afork(), is this check
| actually performed for the XFS_DINODE_FMT_BTREE case?
|
| If a malicious log provides a large ilfp->ilf_dsize and bb_numrecs, this
| could pass the validation here (since numrecs will match the expanded size),
| but exceed the on-disk fork size.
|
| Could this later result in an out-of-bounds memcpy in xfs_bmbt_to_bmdr()
| when the replayed bb_numrecs exceeds the maximum allowed records for the
| on-disk fork?

So, known issue, and I've already fixed this in my current working
tree. As such, fuzzed garbage like this is rejected before any btree
root is recovered now.

Also:

> Fixes: 658fa68b6f34 ("xfs: refactor log recovery inode item dispatch for pass2 commit functions")
> Cc: stable@vger.kernel.org
> Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_bmap_btree.c       | 13 ++++++++++++-
>  fs/xfs/libxfs/xfs_rtrefcount_btree.c | 13 +++++++++++++
>  fs/xfs/libxfs/xfs_rtrmap_btree.c     | 12 ++++++++++++
>  3 files changed, 37 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index 758a4b1ccf5bb..118e8ab35f1d1 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -148,6 +148,7 @@ xfs_bmbt_to_bmdr(
>  	xfs_bmdr_block_t	*dblock,
>  	int			dblocklen)
>  {
> +	int			maxrecs;
>  	int			dmxr;
>  	xfs_bmbt_key_t		*fkp;
>  	__be64			*fpp;
> @@ -167,7 +168,17 @@ xfs_bmbt_to_bmdr(
>  	ASSERT(rblock->bb_level != 0);
>  	dblock->bb_level = rblock->bb_level;
>  	dblock->bb_numrecs = rblock->bb_numrecs;
> -	dmxr = xfs_bmdr_maxrecs(dblocklen, 0);
> +	maxrecs = xfs_bmdr_maxrecs(dblocklen, 0);
> +	if (be16_to_cpu(dblock->bb_numrecs) > maxrecs) {
> +		/* Corrupted log block: refuse the conversion instead of
> +		 * copying past the end of the inode fork area.
> +		 */
> +		xfs_warn(mp, "bmbt log recovery: numrecs %d > max %d",
> +			 be16_to_cpu(dblock->bb_numrecs), maxrecs);
> +		memset(dblock, 0, dblocklen);
> +		return;
> +	}
> +	dmxr = maxrecs;

This is typical of poorly directed LLM code fixes. i.e. Slap a
bandaid on the symptom without understanding how the problem should
be fixed, so it actually makes the problem -worse- rather than
better. But we fixed the out-of-bounds copy, so it must be good!

Unless you know how to fix the discovered problem correctly, don't
send what your LLM proposed for review. It will be garbage, and all
that will do is annoy whoever has to review it. Just report the bug,
let the subsystem developers fix it.

-Dave.
-- 
Dave Chinner
dgc@kernel.org
