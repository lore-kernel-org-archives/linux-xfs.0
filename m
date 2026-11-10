Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.189.121.228
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794299631;
	b=zhhv7neP+tYEW9UF8ZOjwLzZXDC9pBBwEuEZHl7YdM8TyDOcPwtG+8SeX8EmK55LtQsg
	 Po63OytKBtsI1uZbk285xGy631K4gJniDc9obKi3e8lRuY6wBZgRL4PjLAiimNDXeFbkr
	 b1Fln4WvoNQttXYgfOQkalK5oSzHdu7PU39h+bN9dcntMldBzaaVoMD5ZSO//ER+zLKgl
	 a2wu+2pQsJasXPCfAqtYpkSq8V67nATSpb+h0coebgJGxrUDLEb/v49+CFC2f9xaKfWHx
	 PLw/pR7HJPrtlvPDyn5Hs29TUMf6mICHCrDVqbOnKZBgFZHzVsOI9Zle2SYz5NFHUpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794299631;
	h=DMARC-Filter:Message-ID:DKIM-Signature:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Content-Type:MIME-Version;
	bh=Ah7DRRGif0ihNqUB0G/kpe9gLj4SKfyuQtnDg8TbPpA=;
	b=R8mocjBULuHRWTTGvTyow14ze1j3bibZQcET/Nw/Vre+CSMHBsYo11EGpLrb3+axQP+u
	 05nzmGjyhrcfn7R5MhEtd3QpLmE/wxOkQ4iMadoI+HasCsNKLIS4Axbj+sJpkEx3Lcxae
	 GNWMcNikYhhzG2HbM1UdHDIMTlxLU55R2ssKNZkvRzHyqHNG4Tu03nzsJmV1+pLkawaMu
	 rLlGKUQdxM63EAq4aLMVhkKqcA49pr6PC6QW07xD59u0jXwMj7M/MxnRXRqAr7LpHJ43u
	 cwTKa4WxYu0VPGQ8FA88sHvKJ2jOZipPUVCwgvzXxJGC1P16fDMNyg/0EgZp08V9Lkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=itx.no;
	spf=pass smtp.mailfrom=itx.no;
	dkim=pass header.d=itx.no header.i=@itx.no header.a=rsa-sha256 header.s=mx.itx.no header.b="D/5GVdff";
	arc=none smtp.remote-ip=91.189.121.228
Received: from mx.itxnorge.no (itx-kvm-14.itxnorge.no [91.189.121.228])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89141606A33F;
	Tue, 10 Nov 2026 08:33:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 89141606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=itx.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=itx.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=itx.no header.i=@itx.no header.a=rsa-sha256 header.s=mx.itx.no header.b=D/5GVdff
Message-ID: <a69cd8605f2011f348c895a8d892463879f76823.camel@itx.no>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=itx.no; s=mx.itx.no;
	t=1794299628;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ah7DRRGif0ihNqUB0G/kpe9gLj4SKfyuQtnDg8TbPpA=;
	b=D/5GVdffs4M+bd8nulnh4HMbJLDt2bagv+uLLG6+Qw1eNfYp9jVepe0T29uuGtXcCR0SC4
	NqzpMoOqADzG9kznELEyijM3WE5+S7JLJaJGYVQ2ToHzhzaInoaNKWnAwSZWsmWe9NzNjH
	RGBxZlC/pWHLNzvpZgGxW19zK9l/t/8=
Subject: Re: [PATCH] xfs: read rmapbt high key offsets with get_unaligned()
 in scrub
From: Stian Halseth <stian@itx.no>
To: Dave Chinner <dgc@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, "Darrick J
 . Wong" <djwong@kernel.org>, sparclinux@vger.kernel.org, Jan Engelhardt
 <jengelh@inai.de>,  stable@vger.kernel.org
Date: Tue, 10 Nov 2026 09:33:46 +0100
In-Reply-To: <avI9zGQRG_kh0l2w@dread>
References: <20261109134853.1659991-1-stian@itx.no> <avI9zGQRG_kh0l2w@dread>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-8W9Nb+LbcswGxvghoGqD"
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0


--=-8W9Nb+LbcswGxvghoGqD
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Tue, 2026-11-10 at 08:40 +1100, Dave Chinner wrote:
>=20
> That just looks wrong to begin with. Decoding an on-disk structure
> without using be64_to_cpu() to get it in the correct endian order
> first?
>=20
> Oh... the code plays "I'm too smart for my own good" micro-
> optimisation games by endian swapping the badflag variable to avoid
> needing to endian swap the rm_offset field.
>=20
> It seems to me that the correct fix here is to stop endian swapping
> the badflag variable, and endian swap the rmap.rm_offset fetches for
> both the low key and high keys, like all the other places that
> dereference rmap.rm_offset direct from pointers returned by
> xfs_btree_key_addr()/xfs_btree_high_key_addr().
>=20

Thanks, I've looked a bit deeper than my one-line fix, based on your
feedback.

Yes, we can remove badflag. be64_to_cpu() alone doesn't fix the
trap, though, since it's a no-op on big-endian. gcc still reads
hkey->rmap.rm_offset with the same 8-byte ldx. I tried it on my
T4-1 and the fault count didn't change.

The other places get away with it because they go through a
struct xfs_rmap_key pointer first (kp =3D &key->rmap in
xfs_rmapbt_cmp_key_with_cur() and xfs_rmapbt_cmp_two_keys()), and since
that struct is packed gcc uses byte loads.

I suggest we do the the same here, with be64_to_cpu() and no badflag.
That gets the faults to zero on=A0the T4-1. Can send that as a v2 later,
if no one disagree with that approach.

/Stian

--=-8W9Nb+LbcswGxvghoGqD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTK1ph9OaYoND1R57zoeAEuJe36VgUCavLW6gAKCRDoeAEuJe36
VpqIAQDwM38Ng2/+nJXWA1tqhydtdItszJQ5hauH3V4CYrtPMAEAtZQzI8evZy4n
rg5ct3pDU1mwLbG4+LHtEOachYBVHgg=
=Sgji
-----END PGP SIGNATURE-----

--=-8W9Nb+LbcswGxvghoGqD--
