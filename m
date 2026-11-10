Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794342524;
	b=io13Cj7pQhD60QXDBgnv3Ch9CXzzt+QWs2oC48q1mVJsXZXQ3VoMvYeEgDKY5eDatIcz
	 EB64WGjxd04OHBEKmyh2OPzCiiXHX7nk/F4xvRp7A1WqBDUPW3kc+Carjb0ScjG5sNbMG
	 2zxg1qmdM6cl4DShzB/0OF/e2uAgnKzC7/L+BMrYdp9VtMVxHFELrw2j2MPj94ErmbgPX
	 gxhk6gxv6ogyS6o9KVdvWRXssXsS3M54gZQnUJ5wp44QXziOAQgf9ZTXcbvk4t9yzH0Jw
	 pam5X/pxavWHPF7OIth393MbRY3BMJTnAFbEyz9bS4NhXxE6DcqCNqbvbuVnOvIAVFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794342524;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=O9+07kQ5qMDcMJJwDIRuYbfPBV95MmmanwGcaycIOCI=;
	b=gYYZwaezc1TD7eErtoyrmx3I9hdnh9FOiJaqbFvHcc1Y+wIPxHOGtg1J67mQyxCEFIFF
	 cFGWIeSXjXv8Vb1Kdj1vNAt9Vjei7Cq4S+dNcZbQIm1efeXP8PjJ2imQdrmHghfjvF5KH
	 2yIiqfrMhrMo+ErAb4X1OA4W4OuEp4pwTFdtVJfChxj3vPH2jGUwpznV9nEPYE/RbrMnQ
	 QCRrH/kOvVa2+eFJj3pqIvdCODpgY5QlgLtJuuqTiiVlFrOR6y3mlFxF8QpQ7pV5UQXPR
	 rvjUqVy1YGm8nJQ5XEKlJ5sA5W4za80t03lQyPKUUDDiBrXEkGQ6HRCI3DWu0CAMU7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QHGesRXl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78932606A31C;
	Tue, 10 Nov 2026 20:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QHGesRXl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 702D41F0089F;
	Tue, 10 Nov 2026 20:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794342524;
	bh=O9+07kQ5qMDcMJJwDIRuYbfPBV95MmmanwGcaycIOCI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QHGesRXlG6F6bPtprtn7q92Ptm3oVG9KKpU+TmXM8ZMqt0OVGChOvCvMwH9IM/bnF
	 bMLWk2MR+BTPpcJAUpw1eklVsv2ZABw39haSewYv74D93sZSWefdpWRmWGfmrYH2tg
	 dR5OBG/JyccESjv3pJtzxdXhKiXAhWmNW5ahMyBPP2im0r8YWckA682WKF8MSGmGYz
	 ty4M7j+4ckNf/C/SPG/rCg3BbRxAafmFQtTP+7m5BSz07sjMqZ0Wn8XOkHmjgC2LmL
	 YSWaESImoDLaqcCNqWl3hAWuC8G/cJ0klFY6x6aPw1d/qm9eudGlZMsIL9VJGpzsKN
	 js6ofCoxAT94g==
Date: Wed, 11 Nov 2026 07:28:35 +1100
From: Dave Chinner <dgc@kernel.org>
To: Stian Halseth <stian@itx.no>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>, sparclinux@vger.kernel.org,
	Jan Engelhardt <jengelh@inai.de>, stable@vger.kernel.org
Subject: Re: [PATCH] xfs: read rmapbt high key offsets with get_unaligned()
 in scrub
Message-ID: <avN-c2otlYfqEQ--@dread>
References: <20261109134853.1659991-1-stian@itx.no>
 <avI9zGQRG_kh0l2w@dread>
 <a69cd8605f2011f348c895a8d892463879f76823.camel@itx.no>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a69cd8605f2011f348c895a8d892463879f76823.camel@itx.no>

On Tue, Nov 10, 2026 at 09:33:46AM +0100, Stian Halseth wrote:
> Hi Dave,
> 
> On Tue, 2026-11-10 at 08:40 +1100, Dave Chinner wrote:
> > 
> > That just looks wrong to begin with. Decoding an on-disk structure
> > without using be64_to_cpu() to get it in the correct endian order
> > first?
> > 
> > Oh... the code plays "I'm too smart for my own good" micro-
> > optimisation games by endian swapping the badflag variable to avoid
> > needing to endian swap the rm_offset field.
> > 
> > It seems to me that the correct fix here is to stop endian swapping
> > the badflag variable, and endian swap the rmap.rm_offset fetches for
> > both the low key and high keys, like all the other places that
> > dereference rmap.rm_offset direct from pointers returned by
> > xfs_btree_key_addr()/xfs_btree_high_key_addr().
> > 
> 
> Thanks, I've looked a bit deeper than my one-line fix, based on your
> feedback.
> 
> Yes, we can remove badflag. be64_to_cpu() alone doesn't fix the
> trap, though, since it's a no-op on big-endian. gcc still reads
> hkey->rmap.rm_offset with the same 8-byte ldx. I tried it on my
> T4-1 and the fault count didn't change.
> 
> The other places get away with it because they go through a
> struct xfs_rmap_key pointer first (kp = &key->rmap in
> xfs_rmapbt_cmp_key_with_cur() and xfs_rmapbt_cmp_two_keys()), and since
> that struct is packed gcc uses byte loads.

Ah, that explains why those work without issue - that's the bit I
missed.

> I suggest we do the the same here, with be64_to_cpu() and no badflag.
> That gets the faults to zero on the T4-1. Can send that as a v2 later,
> if no one disagree with that approach.

It sounds like the right approach to me.

-Dave.
-- 
Dave Chinner
dgc@kernel.org
