Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793614210;
	b=zxVFXuXdmR+n3VwXNE7E4N0T85LKIQYvpHOnYznKTShyNHOUqqyTyYJI1GcB0S7x6P69
	 iQdcy5aLQuIQXY60xvvIlwjJ7ogR4jtnRpkNh8mn20M+Al5AUr0OuaUu27gznS0iY7BCn
	 GiiyidEQ7EUo3uJIGc64aLFczXAwv5tGfe2BATecyU4Tk9jNls1rUdONHTPjmCEoHAL6e
	 w1QB7yxj2VaQHZYpp87q+T5XT+OpKIoiT1DfytOJcuc07M7S0ONMyHJD6Daj6TbItRk0I
	 1gKXF5z6xe2+Ldn6ybAbd0umo+Z7snZYgb0MeLDoL9/OE0AFqmtMVRzkMHUX2JSU8vA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793614210;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=2Og0Q1VOJHkTmMnFzes6Fs3Mlg11CKsB+9W7RmnajRY=;
	b=SaNIkNcZZJddW3564lPIfjp4dMD6tx+7S999RUkEZZ5dJziVTCMJrG2QlJTgP759cRml
	 fm/rl0B4uh/t920SAKfyPHBPBzuh6dsK5CxQngU3BADhGexsndzRLUfv7tNux5YdgWAs/
	 vGba4e/aTSijxI5PhxLqf4nrzJEtAQbtzT2VXYY5z9URGKATJDD85XqmvFTv7GxveaeCE
	 cqCRhvIeqv0JIXh6OLcNGYbSParPr4ep61t+BGqRKgcnV82JDndmYoiuAO3PY0UYSZORq
	 PiOay3Pq/1RFLA9dTxi9AJPYEM0yHzWUNxcahPML6UMjRITBuz//r0woVZvyA1bLUDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GOSTae2Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3474D606A326
	for <linux-xfs@vger.kernel.org>; Mon,  2 Nov 2026 10:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GOSTae2Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A95E1F000C1;
	Mon,  2 Nov 2026 10:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793614209;
	bh=2Og0Q1VOJHkTmMnFzes6Fs3Mlg11CKsB+9W7RmnajRY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GOSTae2Yg2oDO0HmKwWczivHqqvnDLG4GRWbzUGrkb8zifya8SQSM6kBJwqn7Xab8
	 k1G3/ICg7u0IAAHeCxYlOdtYAbktLDsGq9b0IWcIMvLbWUQHcPxEfaFHYatabd/JvY
	 wGCW44kOqf6wOMjvNuclVLzu9g2nQh734TfobrP1JfUvGnXU2Z0aHjqRbY5Pu2M7E5
	 Vl2rxVNPYd7V9aJTsxxe8Et3bAVHoOryA7mePauSR/kyGZ/6FMMnOxS/lMy/kOfr26
	 EQcnACSeSKn9PjR2/56w/VjAOx4YJBMkt3WLZSmLOWJKrSkXBHszjb24FldS4yzddj
	 9i62boSa3zjlA==
Date: Mon, 2 Nov 2026 11:10:05 +0100
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Wilfred Mallawa <wilfred.mallawa@wdc.com>
Cc: "cem@kernel.org" <cem@kernel.org>, 
	"djwong@kernel.org" <djwong@kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [xfsprogs] mkfs: fixup memory leak on exit
Message-ID: <auhhUx9TNM4i1YoA@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20261006101232.357124-2-wilfred.opensource@gmail.com>
 <asTQdEMkpzc7_tSd@cronus.toxiclabs.cc>
 <75bc883c4d45a514aaad949dfe301c3f2a79112a.camel@wdc.com>
 <20261006144851.GX2705364@frogsfrogsfrogs>
 <asd7554UisFwlOsc@cronus.toxiclabs.cc>
 <e042c937a34eb92afdc0208a2f6571076f096ba6.camel@wdc.com>
 <ass13wWEOO9woOOw@cronus.toxiclabs.cc>
 <d74e85022834ec1c39c79931d64b4c805001e7cd.camel@wdc.com>
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
In-Reply-To: <d74e85022834ec1c39c79931d64b4c805001e7cd.camel@wdc.com>

On 2026-10-12 00:43:28, Wilfred Mallawa wrote:
> On Sun, 2026-10-11 at 09:09 +0200, Carlos Maiolino wrote:
> > > > 
> > > 
> > > Just to clarify, should I can spin up a V2 that frees all of the
> > > getstr() allocations in xfs_mkfs? or shall we drop this for now?
> > 
> > I'm happy getting rid of leaks even if they are just before we
> > exit().
> > Final decision is from the maintainer thought. Andrey has been OOO
> > past
> > few days, so perhaps wait for him to come back and decide?!
> > 
> > Cheers.
> 
> Okay, sounds good!

Sound good to me, to have it freed.

-- 
- Andrey
