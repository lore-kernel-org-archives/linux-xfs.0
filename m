Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368AC38D401;
	Thu,  8 Oct 2026 15:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791472657; cv=none; b=FFYhj/wpF3hF79lINw6bXVR2EL3530xcx5T0fholhKsQup3MMHwak6cwFZR+CpGtOMJyh84uEGYnbHp7Si9qor4ssSTqHjIcsPetHOLkRQxmKkcfK7y+FcAKnitJIY+jnlcUI/5YAdG44NZz86+T4PTMZnWH+d9ibBgOPhC1ki8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791472657; c=relaxed/simple;
	bh=qIlQImlPtEwA2AQpBZMWspWqmPYwn7vDtp1w5u29PTY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mpez5uQhGrSkhOIruwyJaTvi2QIvxbifTSE4E/vqsHVfltgme1bcBaDRDrSQ+f+rV1m3gmB1sQKYh5AEX/E7YeaJxbYPgi0YmFh1/TDqPVfEsrzuWoCOCliCd5IhULaz/R8avK3AuJjnxxRqieUxPCVMoytGsjqOj6YLvNaLBjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hb1BQdsk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hb1BQdsk"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 93DB81F000FF;
	Thu,  8 Oct 2026 15:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791472651;
	bh=UJc7WsmWyAXsQtpa2UsM/mLW1e5WhzmbNnUzvUDyqVI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Hb1BQdskgYgUACJJdW/fHoJKHZ+PUj2ktXWFY89IMPaV0IF+Dyc37hKwNJrBX8IUz
	 XZBSAl8j5+P1PnSaCLOm+n115YQLBZoGn3YuxQ42kM0FoJdwoYuz5UfU4SzVn9Bt4G
	 6SD1HZU/zaRYO+bE2DXa7qbwoTmo7hBNE8odpLXN8cF+pE9YdWHSYzTxiu828wBv4e
	 L//ztOksaa1q+7eTwd6qpFoCfJyo2AvIFZPeClnt5vZp0DiU2XOwo66dgUFR5pqN+6
	 HYfioyCampjNj7NCNHw9YzWCZhpN/KKG/Yor+yhbKD9kIkPRKu5aAuyhVaEUgmyLGE
	 2Pzri9ifVOakg==
Date: Thu, 8 Oct 2026 08:17:31 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: zlang@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH 1/1] lib/random.c fix undefined behavior on signed
 integer overflow.
Message-ID: <20261008151731.GN2705364@frogsfrogsfrogs>
References: <20261006135205.400485-1-lukas@herbolt.com>
 <20261006135205.400485-2-lukas@herbolt.com>
 <20261007170058.GG2705364@frogsfrogsfrogs>
 <d000ae8abba884b0a58be93e6e63f486@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d000ae8abba884b0a58be93e6e63f486@herbolt.com>

On Thu, Oct 08, 2026 at 10:23:59AM +0200, Lukas Herbolt wrote:
> On 2026-10-07 19:00, Darrick J. Wong wrote:
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
> > > +	if (apply_mask) it ^= MASK;
> > 
> > Doesn't _random suffer the same flaw?
> > 
> > Oh.  It's dead code, maybe it should go away?
> Good point.
> > 
> > Also, what about converting all the variables to unsigned?
> 
> It would break two signed checks: `it <= 0` (LFSR feedback -
> only fires at zero instead of when MSB set) and `leh < 0`
> (output folding — never fires). The `it` register degenerates
> to 33 repeating values after 64 calls. Reducing the pool of
> random numbers.

Ah.  Well in that case I'm satisfied, so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D
