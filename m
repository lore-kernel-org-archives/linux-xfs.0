Received: from prime.voidband.net (prime.voidband.net [199.247.17.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0C525F78F;
	Mon, 13 Oct 2025 19:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.247.17.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760383114; cv=none; b=QzCe9OO4M9CVM2b/yavvb+vT7BoMWA0ITAmnIQR0B8RtC3Mgy3UsVoE2Tm8/GoG3/738n+Sqx1ACChHSl7UnoV+RpK1TQ8qHiHaNMIKNCZavg4CekVfAiGK9WrQtWTPU9jtRdbtgCYQa+pGRmj5gPGlxYoV0WIE7EluLZIxpH60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760383114; c=relaxed/simple;
	bh=YAr0GnSopKj79+L6J6LlxDhhP7XeesQLCHrPk01uctQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TjhB8XAPKXRwU1h5SwCAlAjnCrv62FHZG5hK4pPy4BsiPIjU5L56OqshWc3oahR8xWMPCw6UFEd+oSWKc1v1Xckm7N8zCZaNtqLIQyOMBgtGSAKRBfx3v/ZiqrLOBEja4yhAU91Xw5NhiP9hdhSvU2xDO4z7um3l4VQjeJIBElI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=natalenko.name; spf=pass smtp.mailfrom=natalenko.name; dkim=pass (1024-bit key) header.d=natalenko.name header.i=@natalenko.name header.b=wyy1/gyJ; arc=none smtp.client-ip=199.247.17.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=natalenko.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=natalenko.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=natalenko.name header.i=@natalenko.name header.b="wyy1/gyJ"
Received: from spock.localnet (unknown [212.20.115.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by prime.voidband.net (Postfix) with ESMTPSA id 79A14635B045;
	Mon, 13 Oct 2025 21:08:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
	s=dkim-20170712; t=1760382532;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=hWDaP/sYXgodO6ibobWEGOJClFcvhDTYB+sevTJgK0c=;
	b=wyy1/gyJnBoGR03czEQ5VwChqIRVliMbmOjJi9fwIPDbu61fQ6cX7tBAEyXazrDULGIEEz
	vT0u7oTAlwmM20/eVI29XIrHiEVAxOzSbMbqxfLmClpzmjG0T2iA1DzU1ftfXRGsNHMTHn
	4yeKHhUTC23NHHB/bJo7K7ONpD0mWzM=
From: Oleksandr Natalenko <oleksandr@natalenko.name>
To: linux-kernel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>, Pavel Reichl <preichl@redhat.com>,
 Vlastimil Babka <vbabka@suse.cz>, Thorsten Leemhuis <linux@leemhuis.info>
Subject: XFS attr2 mount option removal may break system boot
Date: Mon, 13 Oct 2025 21:08:38 +0200
Message-ID: <3654080.iIbC2pHGDl@natalenko.name>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart9517416.CDJkKcVGEf";
 micalg="pgp-sha512"; protocol="application/pgp-signature"

--nextPart9517416.CDJkKcVGEf
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"; protected-headers="v1"
From: Oleksandr Natalenko <oleksandr@natalenko.name>
To: linux-kernel@vger.kernel.org
Subject: XFS attr2 mount option removal may break system boot
Date: Mon, 13 Oct 2025 21:08:38 +0200
Message-ID: <3654080.iIbC2pHGDl@natalenko.name>
MIME-Version: 1.0

Hello.

In v6.18, the attr2 XFS mount option is removed. This may silently break system boot if the attr2 option is still present in /etc/fstab for rootfs.

Consider Arch Linux that is being set up from scratch with / being formatted as XFS. The genfstab command that is used to generate /etc/fstab produces something like this by default:

/dev/sda2 on / type xfs (rw,relatime,attr2,discard,inode64,logbufs=8,logbsize=32k,noquota)

Once the system is set up and rebooted, there's no deprecation warning seen in the kernel log:

# cat /proc/cmdline
root=UUID=77b42de2-397e-47ee-a1ef-4dfd430e47e9 rootflags=discard rd.luks.options=discard quiet

# dmesg | grep -i xfs
[    2.409818] SGI XFS with ACLs, security attributes, realtime, scrub, repair, quota, no debug enabled
[    2.415341] XFS (sda2): Mounting V5 Filesystem 77b42de2-397e-47ee-a1ef-4dfd430e47e9
[    2.442546] XFS (sda2): Ending clean mount

Although as per the deprecation intention, it should be there.

Vlastimil (in Cc) suggests this is because xfs_fs_warn_deprecated() doesn't produce any warning by design if the XFS FS is set to be rootfs and gets remounted read-write during boot. This imposes two problems:

1) a user doesn't see the deprecation warning; and
2) with v6.18 kernel, the read-write remount fails because of unknown attr2 option rendering system unusable:

systemd[1]: Switching root.
systemd-remount-fs[225]: /usr/bin/mount for / exited with exit status 32.

# mount -o rw /
mount: /: fsconfig() failed: xfs: Unknown parameter 'attr2'.

Thorsten (in Cc) suggested reporting this as a user-visible regression.

From my PoV, although the deprecation is in place for 5 years already, it may not be visible enough as the warning is not emitted for rootfs. Considering the amount of systems set up with XFS on /, this may impose a mass problem for users.

Vlastimil suggested making attr2 option a complete noop instead of removing it.

Please check.

Thank you.

-- 
Oleksandr Natalenko, MSE
--nextPart9517416.CDJkKcVGEf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZUOOw5ESFLHZZtOKil/iNcg8M0sFAmjtTjYACgkQil/iNcg8
M0siaRAAupLobI5q2MbYzJmln7lj1j8jOWj9xAK+lmrlb85yroTW1q6nc4Tk8xjZ
yzxF/0VCx2zcHR0aienmRjumAvwdXadgLT6sorIa1OLWg98Y/rO1pc0pKxQJQlrp
9AvXEbbMX7mZkBmmZ/wfvvxfM0Q9McKLXnU5uIb2SxyM0gTpJele2TdJ2hR71EL+
Wepo18b6YbLWNFVj2oRWUCb/AHSEbhD+UbwJlM1Y/ggvXo+ViK6tNk6j7QE7RfIe
Gvb4j+ZfzKJ0lm8qXlqrcdD6uJxHv5EN2V8+bSw7CYJAa2WKKWJWPCYBd7PfMgQP
P+PRfczXIUipKfWYQSM9GGqMot37TdF/6pimlQs7PvWfxay/WT+dYcg0SXG/TnoG
LdG89x9QtJVI8igX/RAUxBuC2SDnyB7vD/hHOER6m11WC57oahINoNhj8sS8Bsh4
6Xj2xPU/aKasclfA/+6lWY5Z6Y2v1s2vRJmEAWxAq274xF5soCYYG3Itaa/ihutZ
T5q5RuAzWq3dZ7uPTWbfhKaVCfwUQYa1FXFVGWCb4KGfPorRwP7z6QJCjwrwWBTE
yth2JSfM7WY3VEN+fytBXMZAzYj5ZzNzsARh0m4FIVekQKHw3dVKgCdQ0A2nmiPo
N+2rEUbXSMUMqbtiAGUDftWisFT/ZUlxzMIplqOdie4Mw8hF6ZM=
=AQnF
-----END PGP SIGNATURE-----

--nextPart9517416.CDJkKcVGEf--



