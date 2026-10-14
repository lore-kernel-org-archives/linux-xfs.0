Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EBA054DAEA;
	Wed, 14 Oct 2026 15:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791992091; cv=none; b=W5WAKYHo4MClROsb3D0nDlcVvzsk2JrW67hWL9u9qZ/CS7buxj7P8MDFWBnefHkqFxBNV4K45556FzdHjdqaDj2v69MLxdW8kpFS5KiLKCB+eGQiC9wsEJhtjaftRr8J81KmEUEUhim5rv9KYC9x3lN5ch7VN1oETQJI5aA4XQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791992091; c=relaxed/simple;
	bh=QVw94DICeFyC2xFsRiOFGK5vrj7tH1BO1uhcpUjIgBE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F1jMXUb0BSdPWUTf01XQxhFfQUSWbHVWahPx4XRZ+Nr4o4AUPMJfzuAa9zoLF2x8wKWEhMd4Yp4RK6XZsO1WjNavXYYCJlwTQdIGURm8LPrFYWxfKTYxr9xRA974D2PEhwUlSvEeRNFYZoPkCAOi/rrEHsy9X7YbTUuJZ/sDPzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j7MwfB/4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j7MwfB/4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BC6E1F000C4;
	Wed, 14 Oct 2026 15:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791992089;
	bh=O+5znhSPiipPrRWgy32YkBDEsxNZJVDdYNHwagLw2uo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=j7MwfB/4VcxjkCnoJgUWx/QjimTN6LxHXvttqmBsfmU0Sx5K5L/qIaj3z3zTOFfJT
	 RugP1J7SZDWRkSoZTOL3FnqxmiRxh+DQOdDxxCOvs8i7RZQx9Mwb9MfhgiJhcb2NDh
	 KOGjzoBKyT/m+6w8itDA/1tRo7uaBJHrVwRbKk1DlVnZ54cy5awgJB0YUBiu1NTKn0
	 SFBojITY0S/lOkYnaNnnjdnbpVtDbQd1VKOfJaGj25FO8S+HC5Qd4B3ELbz4LB5OcJ
	 hNKkPmq+g+4I/45Dmdml/Bcji7AyKJcwTJ5KWP6azqZbnrhRW0DMUNEBqoHVb/1Ndk
	 wyZQCSSoR/6rw==
Date: Wed, 14 Oct 2026 23:34:44 +0800
From: Zorro Lang <zlang@kernel.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH 1/1] lib/random.c fix undefined behavior on signed
 integer overflow.
Message-ID: <as-gn2UbAkwzn__7@zlang-mailbox>
Mail-Followup-To: Lukas Herbolt <lukas@herbolt.com>, 
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org
References: <20261006135205.400485-1-lukas@herbolt.com>
 <20261006135205.400485-2-lukas@herbolt.com>
 <asziOW5xK-ALJC2T@zlang-mailbox>
 <77a91ff8f43794433376c3af4362bbdd@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <77a91ff8f43794433376c3af4362bbdd@herbolt.com>

On Mon, Oct 12, 2026 at 04:38:26PM +0200, Lukas Herbolt wrote:
> On 2026-10-12 15:44, Zorro Lang wrote:
> > On Tue, Oct 06, 2026 at 03:51:52PM +0200, Lukas Herbolt wrote:
> > > The random.c now expects that signed integer to overflow and
> > > triggers the  ^MASK branch. But signed int overflow is undefined
> > > behavior and GCC can optimize this branch out with certain
> > > CFLAGS/LDFLAGS.
> > > 
> > > Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> > > ---
> > >  lib/random.c | 13 +++++++------
> > >  1 file changed, 7 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/lib/random.c b/lib/random.c
> > > index d5c81be817c8..f767ed1d1337 100644
> > > --- a/lib/random.c
> > > +++ b/lib/random.c
> > > @@ -186,14 +186,15 @@ _random (int32_t is [2])
> > >  int32_t
> > >  _irandm (int32_t is [2])
> > >  {
> > > -	int32_t it, leh, nit;
> > > -
> > > +	int32_t it, leh, nit, apply_mask;
> > >  	it = is [0];
> > >  	leh = is [1];
> > > -	if (it <= 0)
> > > -		it = (it + it) ^ MASK;
> > > -	else
> > > -		it = it + it;
> > > +
> > > +/* 	evaluate on original value — no UB here */
> > > +	apply_mask = (it <= 0);
> > > +/*	double via unsigned shift — well-defined */
> > > +	it = (unsigned)it << 1;
> > 
> > I'll explicitly change it to unsigned int when applying the patch.
> > 
> > Reviewed-by: Zorro Lang <zlang@kernel.org>
> > 
> > > +	if (apply_mask) it ^= MASK;
> > 
> > Ahaha, this .c program is quite legacy. I'm not sure it's worth pulling
> > in
> > <stdint.h> and <stdbool.h> just to use *bool apply_mask* and
> > *(uint32_t)*.
> > 
> Yeah, I did't want to pull anything else into it.

Makes sense :)

> I will send v2 cleaning up the dead code.

OK, If you plan to send a v2, I'll hold off on merging this one and wait for
your next version.

> 
> -- 
> -lhe
> 
