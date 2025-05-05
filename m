Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4B11FFC77;
	Mon,  5 May 2025 10:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746442564; cv=none; b=JsiPQMbDOm1KTAoaH4kalg4inYu7082iaVD4pHXkAdUBNh6w9acRH2YEADT0/YF3yAlmcdyn5Kbth4SxOkkFf6zZDtS94kAaw1txh+q7Z9xNc7DxEhbvPspUX0U+gBq0wCnS3nmKY2qxz/hW3P3sBNZmKmpu8pagAnHhy29xmZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746442564; c=relaxed/simple;
	bh=CAZkqTrf3vuwVVZ8Yi7oZF4/3gVK/FVyrNM7VkCn8JQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tol2G8YsA7JN+66y1cMttTmJAWwpBHhuG+AqaAr2KjMMVCUUYif4O9+wih9J2IUdBs+oN9/DdIkNdkB8wbbHmI51mJJzqRt8HbU+hcP/1l41Mp4gO+lRCHPrnFbxc9XCja/oDY8zsWhMSfq/24ORYl9riYYU4De6e+voLRpXsiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=krBvQ8Yz; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="krBvQ8Yz"
Received: from localhost (unknown [10.10.165.20])
	by mail.ispras.ru (Postfix) with ESMTPSA id 335955275411;
	Mon,  5 May 2025 10:47:20 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 335955275411
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1746442040;
	bh=DKvKJquAe6MHxZhbf2CyR/75h4tUXGMGTF6XDeIHYfQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=krBvQ8YzuWbbmzTHYZkutLugMRFD+sB/PJo70cdTwJ/kIrFq+K0nx1I4seAZAqnCB
	 gjzsCxaM7yrqHvjgtoOjNXyRLWAoMuP4vUuEC7UalRI0eLbYoYZuqF8PqzKfYvBgnb
	 kxr+V9nZnkSjOJXF5aauOHnVAqLqpdZwaVUEWUF8=
Date: Mon, 5 May 2025 13:47:20 +0300
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, 
	Chandan Babu R <chandanbabu@kernel.org>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org, Alexey Nepomnyashih <sdl@nppct.ru>, 
	stable@vger.kernel.org
Subject: Re: [PATCH] xfs: fix diff_two_keys calculation for cnt btree
Message-ID: <hy6ulcxbyvxh6nfx66gzmgzvzwpqvnkmp4hxlyie2bceucfxgb@ifrsvgrpjqro>
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

No need to apply this one as a fix (e.g. for further inclusion into stable
releases) ?

I'll send out the refactoring patches for review when the cmp_int()-moving
one hits Linus' tree - it's currently in mm-nonmm-unstable branch of
akpm/mm.git and in linux-next repo. Though I'm not aware of how xfs trees
interact with linux-next.
