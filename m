Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340E5367B74;
	Mon, 12 Oct 2026 13:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791812014; cv=none; b=QvDwBJpzqDTsXibjjXf9/rhzgbd/9cJhrtgy1wz+fHqoLLyVXhlNC8ErDDShdwyiXUjiyP6DPb6jH27IkfvMzTuAJMxrhsQ+jFF+OLg9TnCbzUiwy+eSXaAyazzquuHT9edDn1R4zgOzNZuBXeTVz+18L1CjXxK23jIPwMthR6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791812014; c=relaxed/simple;
	bh=oXpJJmU8Anjiy26i2WZNuQR7aGU9DdaxZCT+al9Dn5Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=geE49uBcRoABfAawCliW8SxWA1BHYhWalaoA5WXljDV5Of4OGTu9aOOcw7zlr6Hj7fa+DmF3cs5Y8xrrP+w4ldtAM/7qYGrFF9MqMZHuvXJxVZef6xCWWc3oB4TNtnAXXF5XGee2wjyTQ/o5GRPTpPoEVbE01TwRGo3NU5BWrJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gRaCDE7U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gRaCDE7U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D84451F0089B;
	Mon, 12 Oct 2026 13:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791812012;
	bh=Jk2ATHm1+7IqzHKNOh4AeA3ysPCL06HNzU14JeuVcR8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gRaCDE7U/awcfYEVienAoxa/9eTTQRTBlBYpsawt15BWLYvoVWH+0KHrLLGYloRxL
	 BrAho/k3tF8CXLNQ2kNWhLXIUBXlQDHKxEAZVYqWvn9F8b+9xwog1oidU2XAAICDRy
	 QiR6WsgW+0n/MF5qknYkaXT31bwrlZtk1NjAPYk2HLCjypWnh1e9Wig1A9HBzUDY7l
	 VWkhEYKTAZ2sn3MagsGaFaYY1Ak5AhSsIzvccV3me1jO/0wGo6hsgk3zF2xKx3o3cE
	 R11RAI/aoV6aT/mHhLsaM2bwjvMehDGseRrH3KOpiXNhe973nW8/h4GF2ihOk4i08J
	 PcwksjDDRS9QQ==
Date: Mon, 12 Oct 2026 21:33:24 +0800
From: Zorro Lang <zlang@kernel.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, fstests@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 1/1] lib/random.c fix undefined behavior on signed
 integer overflow.
Message-ID: <aszhaYx_x1LrEKmc@zlang-mailbox>
Mail-Followup-To: Lukas Herbolt <lukas@herbolt.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org
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

If you'd like to do this in another patch, I'll merge this one at first (or
I'll wait your V2).

> > 
> > Also, what about converting all the variables to unsigned?
> 
> It would break two signed checks: `it <= 0` (LFSR feedback -
> only fires at zero instead of when MSB set) and `leh < 0`
> (output folding — never fires). The `it` register degenerates
> to 33 repeating values after 64 calls. Reducing the pool of
> random numbers.
> 
> -- 
> -lhe
