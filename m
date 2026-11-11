Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.189.121.228
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794423706;
	b=IdAW8eo/O8FISHtgq06FidQfvWk89zr+BePRAHpsAjh9/xjqIdJqA6DMnhLH6gMI+Hgb
	 J1bU5Uxso1b1+J2OSlm7ZhYB/yVDtJQCZ8cEf7bzRSWAgDzqGRxC2DjS1a60+noyEgPW1
	 pQJQCOF99o3Wz5CCpQCVnpKl5SzyRlnszZhGbJ44aJnYqk310BPIqegCkwE1I9mnFeVqs
	 t71LGLBnXVo7N/B51dSJkwWNR0Zt3vfAARoESUCYXmzmAgR+In1qef6Qc3LbIWQA+x853
	 HOBdNbDFqVwPKXuV7hwrpGgS5+97C3jN/hJa/9WG9Ksgje3NCFSQYCdo+iP2KzOsvjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794423706;
	h=DMARC-Filter:Message-ID:DKIM-Signature:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Content-Type:MIME-Version;
	bh=fN8BXQdxUtb+cohsNvchlPej4fI46rAjOu/k50nQFVI=;
	b=S/is7LEllhIpcl4M1zV8P4Rdy74hajuntbkiPgUf+lox0ISfctciOwZg76YxrOwpY3Z3
	 rFH0hc9ieBsp807Zhglb+m2kpqxoAy+Lew2t14FTodDTEzOWjpa5Mu1mGm5/szUeOkRtZ
	 CKpdxa6fSSmhijpBsqXykJoZT2kS9RuKe+wB2JbnrR7ybTf833eThvIN1Vvjz/+waD35H
	 zDrkd+mN7xbqonVSTfdyOV+zfx4msY9zjuauAw0k+PXrszxAZji94yYWNXTxq6TgDqBjk
	 CdH5rEjkJXmswVUDdwS/CNVVUHvjvUOOtoaqJxe5KuTIhrJR7EhFwS1fllzegzcVrvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=itx.no;
	spf=pass smtp.mailfrom=itx.no;
	dkim=pass header.d=itx.no header.i=@itx.no header.a=rsa-sha256 header.s=mx.itx.no header.b=NhGL1owW;
	arc=none smtp.remote-ip=91.189.121.228
Received: from mx.itxnorge.no (itx-kvm-14.itxnorge.no [91.189.121.228])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89C7606A327;
	Wed, 11 Nov 2026 19:01:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D89C7606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=itx.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=itx.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=itx.no header.i=@itx.no header.a=rsa-sha256 header.s=mx.itx.no header.b=NhGL1owW
Message-ID: <637ac952837ebabd9fdd1c28bbff09cc5ebb83cb.camel@itx.no>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=itx.no; s=mx.itx.no;
	t=1794423703;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fN8BXQdxUtb+cohsNvchlPej4fI46rAjOu/k50nQFVI=;
	b=NhGL1owWvMhEA3/yqVWzp9nVn/Eu0fHacc1+jJXiq4eOtfWBX9M6gsoM4cWnnyNd+LvOKC
	fgmdhgqUHRzbyC2FXoeAkvFXXAzQsMAxegU+mLoEN9m/riXwvgqaS1gEtgBh2F1SSbhAoB
	P+b3hIErY3PVqkNZwPwQmpRmpCxdpj4=
Subject: Re: [PATCH v3] xfs: fix unaligned access to rmapbt high keys in
 scrub
From: Stian Halseth <stian@itx.no>
To: Christoph Hellwig <hch@infradead.org>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, "Darrick J
 . Wong" <djwong@kernel.org>, sparclinux@vger.kernel.org, Jan Engelhardt
 <jengelh@inai.de>, Dave Chinner <dgc@kernel.org>, stable@vger.kernel.org
Date: Wed, 11 Nov 2026 20:01:42 +0100
In-Reply-To: <avSHkadYwEjnKF87@infradead.org>
References: <20261111103047.604541-1-stian@itx.no>
	 <avSHkadYwEjnKF87@infradead.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-nYs7rKqGPRzzs3b+xQj7"
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0


--=-nYs7rKqGPRzzs3b+xQj7
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi Christoph,

On Wed, 2026-11-11 at 07:19 -0800, Christoph Hellwig wrote:

> > +			key =3D xfs_btree_key_addr(cur, ptr, keyblock);
> > +			rkey =3D &key->rmap;
> > +			if (be64_to_cpu(rkey->rm_offset) & XFS_RMAP_OFF_UNWRITTEN) {
>=20
> Overly long line.

Thanks, will fix.

>=20
> But I wonder if we should simply mark struct xfs_rmap_key as __packed
> to force the compliler to deal with unaligned fields instead of jumping
> through these hoops at every call site.
>=20

In fact struct xfs_rmap_key is already packed in xfs_format.h. The trap
comes from reading it through union xfs_btree_key. The union itself is
8-byte aligned which is why gcc uses an 8-byte load for rm_offset.

I guess we could mark the union __packed. The consequence of that
is that every key access through the union would be turned into byte
loads on strict-alignment arches. If you would like, I could test and
measure exactly what that means on sparc64.

/Stian



--=-nYs7rKqGPRzzs3b+xQj7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTK1ph9OaYoND1R57zoeAEuJe36VgUCavS7lgAKCRDoeAEuJe36
Vo+rAQC2U8p//0TtXdAq0wvUKsH6O2WrlSkHoey217ySv/T9+wD9Ef1z9wL6hx9C
h6SLbVVpNX9rrtWocLkuMHB2ri4S7Q8=
=DUlr
-----END PGP SIGNATURE-----

--=-nYs7rKqGPRzzs3b+xQj7--
