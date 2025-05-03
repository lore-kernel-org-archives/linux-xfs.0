Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D370481B1
	for <linux-xfs@vger.kernel.org>; Sat,  3 May 2025 21:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746306777; cv=none; b=fX42bQOsQGzp+4Rls8Y8LeWyvVvlLLOgn0xAyO/yhdX6t9CQ5or7MYXdnL6tsFx3DY+BJG8YlM+jSYHhKfalrOVVCfZe51lNBsYRerQ0cOezd89vRU/YgsPTPjw4Krp/Np7FjYTlkCY+dblC27S2XEZO8nCC+2X6cG848RRvc2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746306777; c=relaxed/simple;
	bh=Zw4evVVInB0pAGaTLoHFIf47wVT0Trr7IcXUl/4JjVY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=GAmPv/GKb6lsRW76yTV4M9ZJ6qrsDd38YgJ36Nysc6sRKymcQEoUrekE/MmZqDQYciT8LnAmXyALOn/0GGQV75dX3DgBhu+2u4NGJ+0Ax30RZz+Did46OmRNa5Hg61q8y4VaQkgO16zJ9KNljBs0RlsKqWZuAljijtGYxuomTwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=mQF9jPo9; arc=none smtp.client-ip=185.67.36.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="mQF9jPo9"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout01.posteo.de (Postfix) with ESMTPS id 7D7EE240027
	for <linux-xfs@vger.kernel.org>; Sat,  3 May 2025 23:12:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
	t=1746306767; bh=Zw4evVVInB0pAGaTLoHFIf47wVT0Trr7IcXUl/4JjVY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 From;
	b=mQF9jPo9KOtEXjW6dzgTri5bvCOYxI/aA+M71zqBJQVvj+4YBsLHZxFdtMdTNO/M+
	 UmWki9KA6Eq1h5350r/4Cg2AmWacQbzWHfMjWc1LdYLypiTOwY8Pfq6VNp5ooSx5y/
	 QCVoU/axepDAt1wbmZa3LJVJ9Ou9UwBXVm1j+MPAXW1qUmHNfvJMzZpVmuISq159aP
	 S09figPYO2MrQ1LMYF3HrWvdxR9JEbiYdHthVeE1acH2pZsPV/xDZfMCDt/3Ya4kKJ
	 ZuNjb1HIXzKLGjLHbw7mAyngJnziGvwL1XKLbMwYyn9B4TNGjR73U35DAH+CYCLHVW
	 VOIgZgaeRm2Qw==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4ZqgVQ3jcSz9rxL;
	Sat,  3 May 2025 23:12:46 +0200 (CEST)
From: Charalampos Mitrodimas <charmitro@posteo.net>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>,  linux-xfs@vger.kernel.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Verify DA node btree hash order
In-Reply-To: <20250501141249.GA25675@frogsfrogsfrogs>
References: <6Fo_nCBU7RijxC1Kg6qD573hCAQBTcddQlb7i0E9C7tbpPIycSQ8Vt3BeW-1DqdayPO9EzyJLyNgxpH6rfts4g==@protonmail.internalid>
	<20250412-xfs-hash-check-v1-1-fec1fef5d006@posteo.net>
	<dyo3cdnqg3zocge2ygspovdlrjjo2dbwefbvq6w5mcbjgs3bdj@diwkyidcrpjg>
	<20250501141249.GA25675@frogsfrogsfrogs>
Date: Sat, 03 May 2025 21:12:31 +0000
Message-ID: <875xihwg8w.fsf@posteo.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

"Darrick J. Wong" <djwong@kernel.org> writes:

> On Wed, Apr 30, 2025 at 11:23:57AM +0200, Carlos Maiolino wrote:
>> On Sat, Apr 12, 2025 at 08:03:57PM +0000, Charalampos Mitrodimas wrote:
>> > The xfs_da3_node_verify() function checks the integrity of directory
>> > and attribute B-tree node blocks. However, it was missing a check to
>> > ensure that the hash values of the btree entries within the node are
>> > strictly increasing, as required by the B-tree structure.
>> > 
>> > Add a loop to iterate through the btree entries and verify that each
>> > entry's hash value is greater than the previous one. If an
>> > out-of-order hash value is detected, return failure to indicate
>> > corruption.
>> > 
>> > This addresses the "XXX: hash order check?" comment and improves
>> > corruption detection for DA node blocks.
>> > 
>> > Signed-off-by: Charalampos Mitrodimas <charmitro@posteo.net>
>> > ---
>> >  fs/xfs/libxfs/xfs_da_btree.c | 11 ++++++++++-
>> >  1 file changed, 10 insertions(+), 1 deletion(-)
>> > 
>> > diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
>> > index 17d9e6154f1978ce5a5cb82176eea4d6b9cd768d..6c748911e54619c3ceae9b81f55cf61da6735f01 100644
>> > --- a/fs/xfs/libxfs/xfs_da_btree.c
>> > +++ b/fs/xfs/libxfs/xfs_da_btree.c
>> > @@ -247,7 +247,16 @@ xfs_da3_node_verify(
>> >  	    ichdr.count > mp->m_attr_geo->node_ents)
>> >  		return __this_address;
>> > 
>> > -	/* XXX: hash order check? */
>> > +	/* Check hash order */
>> > +	uint32_t prev_hash = be32_to_cpu(ichdr.btree[0].hashval);
>> > +
>> > +	for (int i = 1; i < ichdr.count; i++) {
>> > +		uint32_t curr_hash = be32_to_cpu(ichdr.btree[i].hashval);
>> > +
>> > +		if (curr_hash <= prev_hash)
>> > +			return __this_address;
>> > +		prev_hash = curr_hash;
>> > +	}
>> 
>> Hmmm. Do you have any numbers related to the performance impact of this patch?
>> 
>> IIRC for very populated directories we can end up having many entries here. It's
>> not uncommon to have filesystems with millions of entries in a single directory.
>> Now we'll be looping over all those entries here during verification, which could
>> scale to many interactions on this loop.
>> I'm not sure if I'm right here, but this seems to add a big performance penalty
>> for directory writes, so I'm curious about the performance implications of this
>> patch.
>
> It's only a single dabtree block, which will likely be warm in cache
> due to the crc32c validation.

I ran a 60-second fio test that creates directories. Performance was not
significantly changed:

Before: read: IOPS=4809k, BW=18.3GiB/s (19.7GB/s)(1101GiB/60001msec)
After: read: IOPS=5121k, BW=19.5GiB/s (20.0GB/s)(1172GiB/60000msec)

But I'd welcome input on more targeted benchmarks if these aren't
representative.

>
> But if memory serves, one can create a large enough dir (or xattr)
> structure such that a dabtree node gets written out with a bunch of
> entries with the same hashval.  That was the subject of the correction
> made in commit b7b81f336ac02f ("xfs_repair: fix incorrect dabtree
> hashval comparison") so I've been wondering if this passes the xfs/599
> test?  Or am I just being dumb?

I've tested the patch with xfs/599 as you suggested, and found the
issue. The test fails with:

  if (curr_hash <= prev_hash)
      return __this_address;

But passes with:

  if (curr_hash < prev_hash)
      return __this_address;

XFS supports entries with identical hash values. This aligns with commit
b7b81f336ac02f ("xfs_repair: fix incorrect dabtree hashval comparison").

I'll send a v2 that checks for non-decreasing hash values (allowing
equality), rather than strictly increasing ones.

>
> --D
>
>> > 
>> >  	return NULL;
>> >  }
>> > 
>> > ---
>> > base-commit: ecd5d67ad602c2c12e8709762717112ef0958767
>> > change-id: 20250412-xfs-hash-check-be7397881a2c
>> > 
>> > Best regards,
>> > --
>> > Charalampos Mitrodimas <charmitro@posteo.net>
>> > 
>> 
