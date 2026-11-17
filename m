Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794916487;
	b=5RYlkWAZ2xU/DNT/IMKvQ0URK/u+CiZBUcsf6x9TNq+0YKEtHGbQ01qQAsPRCzG3Lnpi
	 R5zxBKLLU93Xlp8GgQzEZhd782Wg3jtzLBaGwq7RdIaSZNun21L3oH5LtBsE8ApnNPZAq
	 PoZ6Py+2mcE2vFVSVHHQfSf9qRWQoju3p5gSqrDjK/j+V4ZlVMFFRsc6EYTcvJMxnfJwF
	 j60YZX1swA9ankhrTVUhOMaDpRv1Y8/ZN0fbu17X7Mc91dq7xrXi25S0sfyG8dM51rYvx
	 tp+J+dDA4iUg89QucmhgdzgDFteCIRF6Wfr8LbG8n5h8Zg+1cbXPRx3BuT1PdVvfflQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794916487;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 MIME-Version:Content-Type:Content-Disposition;
	bh=n9HR0jteZ7i3l47CGbAAeoGccO/M6Cb8YzdaapwoXGw=;
	b=JvT4Wg3uJK5oEXOEMpbXhVY1M6cMOfzS/Je7O7X7YhU717Tvsv0rruiq1nIgRL/XE4D7
	 Cyhe42UGakNQ9n2g54nP2S+4fSRnKdXPL93vhSUXcKoejEdTBMAtDoaC5/Iak6FyWBqWb
	 utJn7rFRSn5SsyWMKEKFKQlZ/j3M/V2FFA3XczjzdkBZ/G3nJSzUT6VUA7amG3c3z8oRM
	 VlY/AOSmojAn78IRli2JPrYd+Q9s30n8VOzRDoeUuEZc8yCx/A3PuI1C944rrdlKoRZla
	 Uv1TMIDiQvq0STMNkRyE3gh8rtNdZyx0+lbYbrtyadZmEn3WtzFNNlR+F83ZPvr979g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OpRgQvSl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44112606A330;
	Tue, 17 Nov 2026 11:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OpRgQvSl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 381281F000C4;
	Tue, 17 Nov 2026 11:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794916486;
	bh=n9HR0jteZ7i3l47CGbAAeoGccO/M6Cb8YzdaapwoXGw=;
	h=Date:From:To:Cc:Subject;
	b=OpRgQvSlXTSaSMjmxAFnas5BF1gXYcb77pO3YOboprkAVyMcVsSZ218Wc5dj5sav2
	 vflQKPJckNGgGjt1pQAcK4ssPgTo3X5r3itqdaLitWm9tPbFuyznS2jzqR+VWw5ilI
	 7Zbru7m/Xoj2TcMg5vnLBqDGvQiND5chH0Kvzu9pr7fGfEID3r5j8MJJPoESeYqwXa
	 Cizu6lX5OTr7Yjzs0gG36zTsFxjdDPCx0O/QzuixKxdhyxOHZ+1LSP6+yoR08VV8YO
	 GrfbNyioR+EyXOMmcY+bQkJR0dGS8Q2MSMhdSx/3Z5ri1Au/vu+t0GSA530AS0YpVW
	 LSRfeesYYHMCA==
Date: Tue, 17 Nov 2026 11:54:42 +0000
From: Mark Brown <broonie@kernel.org>
To: David Chinner <david@fromorbit.com>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Cc: Chris Mason <mason@kernel.org>, Christian Brauner <brauner@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the xfs tree with the origin tree
Message-ID: <avxAggF2dYl8eMSx@sirena.org.uk>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2MrhXHFioS1OTaqV"
Content-Disposition: inline


--2MrhXHFioS1OTaqV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the xfs tree got a conflict in:

  fs/xfs/xfs_file.c

between commit:

  9e8fc16dc6b47 ("iomap: pass iomap_iter_next_fn directly instead of struct=
 iomap_ops")

=66rom the origin tree and commit:

  03cbbd80a3e70 ("xfs: restart faults racing with realtime flag changes")

=66rom the xfs tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

diff --cc fs/xfs/xfs_file.c
index d61ea8e2c8e40,8070a07e601f5..0000000000000
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@@ -1980,11 -2039,22 +2040,22 @@@ __xfs_write_fault
  		lock_mode =3D XFS_MMAPLOCK_EXCL;
  	}
 =20
- 	if (IS_DAX(inode))
+ 	/*
+ 	 * The caller picked the zoned or the regular path with no lock held.
+ 	 * The realtime flag cannot change under the MMAPLOCK, so look at it
+ 	 * again, and start over if it has changed.
+ 	 */
+ 	if (xfs_is_zoned_inode(ip) !=3D !!ac) {
+ 		xfs_warn_ratelimited(ip->i_mount,
+ 			"RT flag modifying during page fault for inode 0x%llx.",
+ 			inode->i_ino);
+ 		ret =3D VM_FAULT_NOPAGE;
+ 	} else if (IS_DAX(inode)) {
  		ret =3D xfs_dax_fault_locked(vmf, order, true);
- 	else
+ 	} else {
 -		ret =3D iomap_page_mkwrite(vmf, &xfs_buffered_write_iomap_ops,
 +		ret =3D iomap_page_mkwrite(vmf, xfs_buffered_write_iomap_next,
  				ac);
+ 	}
  	xfs_iunlock(ip, lock_mode);
 =20
  	sb_end_pagefault(inode->i_sb);

--2MrhXHFioS1OTaqV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEyBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmr8QIEACgkQJNaLcl1U
h9CSbQf3QB4RrbZT+Eo+3S5JndWSXTiha+TRbQ9Y3ftMgqAskjcWjjR0WFAi1+Q0
x+huY6ndgJVRNrdE5dFx3/Q07H73A+++RPyECs+SDOP0sSOOQeBxst+CS9VM3Bi+
gLdM26dEgbQNuv41H3WmByazoKzCF61VUGPeRmMiSEE+SmscXxeplF9DdTV/zfCh
VcZnhODwAOnwDRKA5Yt1uoqdrq8j2qp3/CRNFcImcE1oqI5PGsBJ4Di1Gu7XRTGf
yXNcWMVtcfSLu3YJZMpB0t0WOZg1XfNrL4GUmKn6SiepdlRffUTIE6im1PIjZrNs
39xN1ZixR72em8pIxzy8313nKOAV
=V56E
-----END PGP SIGNATURE-----

--2MrhXHFioS1OTaqV--
