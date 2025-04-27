Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE5533991;
	Sun, 27 Apr 2025 11:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745755006; cv=none; b=HpW2wrbi4lx2a8LOqDex+gy1gu1V75NZvp+saXtPiAPp8/FaGIUPvEjQXTiaflppr9KGEUnksU+Ffgdf2OrbSG6UvAq3FH+LVzCNu88pJj/FF6T9ssTdEJxanlILmhsv/B1jQKHhzQk3ZeUE+R1yJyzfYymbuEwkfPLxgzLVASs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745755006; c=relaxed/simple;
	bh=KfSCwSPKSyiYR+s5s/KODZu0ZUy3G3uMK4Swk+Hd9Yk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dC5lP/HAsBM5GXk7k+jvESYzxQCYpdJhLGYY4608mbdiGO0VuNwxzdn0CEsxs6Vwtn29QSm5ncuehBlXjdeqAAVakRHzRwY07xr5T5A5DVbrfWzEk7ZMthRhELXQTdDM3wMLyQES+/3CTw6oL3j2FzdAuJgnt4XFK1G/M1eWib8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=CvwVsTCo; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="CvwVsTCo"
Received: from localhost (unknown [10.10.165.8])
	by mail.ispras.ru (Postfix) with ESMTPSA id DF8CE5275402;
	Sun, 27 Apr 2025 11:56:39 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru DF8CE5275402
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1745754999;
	bh=aBhjtzPKuRcQIwa9oNeuv//8wZdbjOT8VqZkshDuJ5o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CvwVsTCopgyl6sQZCBUPvWwjpDD1EsnZZSa8oxrDktG889xrrZdxstkRpaX9Tv9Pw
	 0CwTSjXiBnSqPPOX+3ZQDuNlG45453A5rtC7Z664+IA2i/HOOkYE3mkHd+5z42eWQj
	 Tnj8bl52tC17a9mLBAjAbeCOd6W55MtXOZjCZOaw=
Date: Sun, 27 Apr 2025 14:56:39 +0300
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: "Darrick J. Wong" <djwong@kernel.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>
Cc: Carlos Maiolino <cem@kernel.org>, 
	Chandan Babu R <chandanbabu@kernel.org>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org, Alexey Nepomnyashih <sdl@nppct.ru>, 
	stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: fix diff_two_keys calculation for cnt btree
Message-ID: <vx6bowvzlqixc4ap7vvj4mwarsuqm7y65cejg6yoc5wgpeh4j6@74rej3wf6uqq>
References: <20250426134232.128864-1-pchelkin@ispras.ru>
 <20250426150359.GQ25675@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250426150359.GQ25675@frogsfrogsfrogs>

Hi,

On Sat, 26. Apr 08:03, Darrick J. Wong wrote:
> On Sat, Apr 26, 2025 at 04:42:31PM +0300, Fedor Pchelkin wrote:
> > Currently the difference is computed on 32-bit unsigned values although
> > eventually it is stored in a variable of int64_t type. This gives awkward
> > results, e.g. when the diff _should_ be negative, it is represented as
> > some large positive int64_t value.
> > 
> > Perform the calculations directly in int64_t as all other diff_two_keys
> > routines actually do.
> > 
> > Found by Linux Verification Center (linuxtesting.org) with Svace static
> > analysis tool.
> > 
> > Fixes: 08438b1e386b ("xfs: plumb in needed functions for range querying of the freespace btrees")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> > ---
> >  fs/xfs/libxfs/xfs_alloc_btree.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> > index a4ac37ba5d51..b3c54ae90e25 100644
> > --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> > +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> > @@ -238,13 +238,13 @@ xfs_cntbt_diff_two_keys(
> >  	ASSERT(!mask || (mask->alloc.ar_blockcount &&
> >  			 mask->alloc.ar_startblock));
> >  
> > -	diff =  be32_to_cpu(k1->alloc.ar_blockcount) -
> > -		be32_to_cpu(k2->alloc.ar_blockcount);
> > +	diff = (int64_t)be32_to_cpu(k1->alloc.ar_blockcount) -
> > +			be32_to_cpu(k2->alloc.ar_blockcount);
> 
> Perhaps it's time to hoist cmp_int to include/ and refactor all these
> things to use it?
> 
> #define cmp_int(l, r)          ((l > r) - (l < r))
> 
> --D
> 

Thanks, that would be worth it, I think. Though the current xfs
***diff_two_keys() implementations try to compute and return the actual
difference between two values, not the result of their comparison. Now
looking at diff_two_keys() use cases, I see only the latter one is needed
anyway so a good bit to refactor.


The thing I'm pondering over now is whether the macro in its current
form is okay to move up to include/. There is no argument restrictions and
typechecking intended to catch up obviously misleading usage patterns
though we'd need some if this is hoisted to a generic header and exported
for potential use by others?

There are four places where cmp_int is defined at the moment:
- bcachefs
- md/bcache
- xfs_zone_gc
- pipe.c

bcachefs is the largest user having all kinds of different arguments
providing to the macro, bitfields included. It also has several rather
generic wrappers, like u64_cmp, unsigned_cmp, u8_cmp, cmp_le32 and
others..

AF_UNIX code even has

	#define cmp_ptr(l, r)	(((l) > (r)) - ((l) < (r)))

for pointer comparisons.


So in my opinion we'd probably need to come up with something like a new
include/linux/cmp.h header where all this stuff will be gathered in a
generic way.

Any objections/suggestions on that? Or just moving

	#define cmp_int(l, r)          ((l > r) - (l < r))

to a generic header and dropping the corresponding defines from the
separate in-kernel users would be enough in this case?

--
Thanks,
Fedor

> >  	if (diff)
> >  		return diff;
> >  
> > -	return  be32_to_cpu(k1->alloc.ar_startblock) -
> > -		be32_to_cpu(k2->alloc.ar_startblock);
> > +	return (int64_t)be32_to_cpu(k1->alloc.ar_startblock) -
> > +			be32_to_cpu(k2->alloc.ar_startblock);
> >  }
> >  
> >  static xfs_failaddr_t
> > -- 
> > 2.49.0
> > 
> > 
