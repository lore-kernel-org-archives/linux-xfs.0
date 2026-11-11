Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.189.121.228
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794392312;
	b=lfcONc0CxmYgOa9UlWfdrp4qgJka/85gjnYRKQwr8bt7YZe50r2v3AFpF+8/6Zb5xUQK
	 gg08lIuhOGjenvpnU9NQS5vQ6LJNAy/8/1Yz1qu1Vs3HrYTC4XBVCqtU+bgbGmT41DoD6
	 1goHIftwUWcFkP+KuAKPdaFpMWuYzILetwF/M+PjgiIJJojF0dCodvBuSB1ygi6YlT6LT
	 KriE3Z/j2FsXYplTm7SAslkV2uLkb099sGyy0CuQ5duGNDfcIFR/irtddKDJyjJGZ2vOD
	 nwjG3uZU97QqZPnQPL/npHvNXDYxKZHfE8mE6JiaZR3/Vi7XpF3Z4JpziYVl6ygCy3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794392312;
	h=DMARC-Filter:Message-ID:DKIM-Signature:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Content-Type:MIME-Version;
	bh=D+zu2oiVtRmIf2nAVSAmSfdUc9+LCT7/meWcA9xNLkU=;
	b=AcfUig8e5H1gfQmjwnGkX82YmXF1w8a2LR+3Ax72qlzuH3S3rgmlBA274vn2bBjlB4QO
	 k+XJwZomTckWjxWcDxA4zhBUxFfHMVoaWSlsIUsiB7WxnVIxjjtgVEWuw1mASfpD3lEjK
	 FBof9dF4++o1snsRbYb03+OyZMOL4nqLMpxuCjS6GlcDILQlAYUJ4m9gYFKT9zqLWk+5J
	 qU2V3CBFpM38odJZgUQsegY5Mjrwhz88LOHaBqrbw7V0iHgCu/mPWhRyokDYP7gs/AQ+K
	 KXXMGPP+6sLPT4npnbNTw46fS6O2AO8+njVqMHJ5K4L7bbvwrN12zSzwBTVjOrbKMqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=itx.no;
	spf=pass smtp.mailfrom=itx.no;
	dkim=pass header.d=itx.no header.i=@itx.no header.a=rsa-sha256 header.s=mx.itx.no header.b=QALbZyI5;
	arc=none smtp.remote-ip=91.189.121.228
Received: from mx.itxnorge.no (itx-kvm-14.itxnorge.no [91.189.121.228])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B52606A321;
	Wed, 11 Nov 2026 10:18:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E7B52606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=itx.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=itx.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=itx.no header.i=@itx.no header.a=rsa-sha256 header.s=mx.itx.no header.b=QALbZyI5
Message-ID: <3afda478775bd7382c26e333ee9ca723043ba44b.camel@itx.no>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=itx.no; s=mx.itx.no;
	t=1794392309;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D+zu2oiVtRmIf2nAVSAmSfdUc9+LCT7/meWcA9xNLkU=;
	b=QALbZyI5x15FKJdP5gTZgYtHqgxLzdlPI28N4vKGNcWm24k7hUzx3Mlcf037Gq/Oc4zO54
	32tS/uJ1nnCnyI3b6jUl+PmLpBsZj2dDSGIqdLarXuAtDkdcl4Bp3UipK0rYduSRTrblCx
	j0ImVZZBzLlhmx82GxnW6rh4qyR5cPE=
Subject: Re: [PATCH v2] xfs: fix unaligned access to rmapbt high keys in
 scrub
From: Stian Halseth <stian@itx.no>
To: Dave Chinner <dgc@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, "Darrick J
 . Wong" <djwong@kernel.org>, sparclinux@vger.kernel.org, Jan Engelhardt
 <jengelh@inai.de>,  stable@vger.kernel.org
Date: Wed, 11 Nov 2026 11:18:28 +0100
In-Reply-To: <avQBA_7WKwIobKKC@dread>
References: <20261110223927.558557-1-stian@itx.no> <avQBA_7WKwIobKKC@dread>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-s/JxVdnwzfGSlOKt9enO"
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0


--=-s/JxVdnwzfGSlOKt9enO
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Wed, 2026-11-11 at 16:45 +1100, Dave Chinner wrote:
> On Tue, Nov 10, 2026 at 11:39:27PM +0100, Stian Halseth wrote:
> > An rmapbt node stores each key as a low/high pair of packed 20-byte
> > struct xfs_rmap_key, so every high key is only 4-byte aligned.
> > xchk_rmapbt_check_unwritten_in_keyflags() reads rm_offset through
> > union xfs_btree_key, which is 8-byte aligned, so the compiler may use
> > an 8-byte load.
>=20
> Ok, this trips my 'written by an LLM' filter. i.e. long
> run-on sentences, strung together with commas and "so ...". I
> mention this because....

The changelog was drafted with LLM help, and I'll rewrite it for v3.

>=20
> > diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
> > index 68e2847c962bb..29609c5967fe3 100644
> > --- a/fs/xfs/scrub/rmap.c
> > +++ b/fs/xfs/scrub/rmap.c
> > @@ -149,8 +149,7 @@ xchk_rmapbt_check_unwritten_in_keyflags(
> > =A0	struct xfs_scrub	*sc =3D bs->sc;
> > =A0	struct xfs_btree_cur	*cur =3D bs->cur;
> > =A0	struct xfs_btree_block	*keyblock;
> > -	union xfs_btree_key	*lkey, *hkey;
> > -	__be64			badflag =3D
> > cpu_to_be64(XFS_RMAP_OFF_UNWRITTEN);
> > +	const struct xfs_rmap_key *lkey, *hkey;
> > =A0	unsigned int		level;
> > =A0
> > =A0	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_PREEN)
> > @@ -166,15 +165,15 @@ xchk_rmapbt_check_unwritten_in_keyflags(
> > =A0
> > =A0		keyblock =3D xfs_btree_get_block(cur, level, &bp);
> > =A0		for (ptr =3D 1; ptr <=3D be16_to_cpu(keyblock->bb_numrecs);
> > ptr++) {
> > -			lkey =3D xfs_btree_key_addr(cur, ptr, keyblock);
> > +			lkey =3D &xfs_btree_key_addr(cur, ptr, keyblock)-
> > >rmap;
>=20
> The code fix smells of LLM, too: technically correct, but unreadable
> and unmaintainable.
>=20
> Regardless of where it came from, it's objectively -poor code-
> because:
>=20
> - it uses a pattern that is not found anywhere else in the XFS code.
> - it costs nothing to use two variables here which would make the
> =A0 code much more readable for a maintainer.
> - no comment to explain the issue the code has to avoid.
>=20
> At minimum, a comment explaining why the code needs to be structured
> this way is needed. Humans like me are going to forget why the code
> needed to be structured this way in short order. Hence a comment is
> needed to remind me why the code was written this way next time I
> look at it.

Thank you for the feedback, and no argument from me on those three points.

You're correct in your assumption that LLM assistance was used for the fina=
l
code. Earlier iterations were more readable, and I should have kept them.
I try to keep my patches small, and this time it came at the cost of
readability.=A0I stand by the correctness and testing, but will send a v3
following your suggestion, which reads much better.

I take this feedback to heart, and it's truly useful for my personal
development. My goal is to learn and improve. I will pay closer attention
to the existing code patterns, and try to adhere more closely to them.
I'm very sceptical of the output I get from the LLM models, so I test
everything to the best of my abilities before posting.


/Stian

--=-s/JxVdnwzfGSlOKt9enO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTK1ph9OaYoND1R57zoeAEuJe36VgUCavRA9AAKCRDoeAEuJe36
VrO1AQCxUjRiezxVBNnLnM621Hesi7rglcrCOI0tDzuyq1eLowD/c+ZSaEX+fQ0J
vGU1m1LpmKZPn9RXpdie/T8EE0bh0Qo=
=RY6I
-----END PGP SIGNATURE-----

--=-s/JxVdnwzfGSlOKt9enO--
