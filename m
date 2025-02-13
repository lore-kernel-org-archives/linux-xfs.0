Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1D920C469
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 09:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739439271; cv=none; b=HaCkRIW6OGba/1eYK3rFjOXUNyri+oSPT57Yvj4wl35uEW39zlRzTe0piNQIBJsXvCDWxX7z+vgtutgr6ea3NemKMhrwvDawwllBeh85GfhoUFIIpDuBu9udedcsd9JI5ZKjQ19d3kRjfW4XvXmrp0jDhjp1vi/mDlVvHjZbXAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739439271; c=relaxed/simple;
	bh=CWCHY5IHzsgf9P436t6dy28w2XiWoBpVZxjhhWvEMyk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=pgVxFUMoz+HIvQmVpP+Njra0RM1PdxB49Gk7aekdtJaeKAmw8aDsTFZDH+BdF1D355Ta9ZW5/fhNSOBrTZ/8bOlYG9XZId/g7x2IEVTuF9jiZo2mZi9h/aJY/MgyIlMBzy/Bztb28mKLRaHv6DkgvtiBujvWvKyMaDAOSLI84fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alyssa.is; spf=pass smtp.mailfrom=alyssa.is; dkim=pass (2048-bit key) header.d=alyssa.is header.i=@alyssa.is header.b=fAoBaEZR; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=CqmjnqQw; arc=none smtp.client-ip=202.12.124.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alyssa.is
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alyssa.is
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=alyssa.is header.i=@alyssa.is header.b="fAoBaEZR";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="CqmjnqQw"
Received: from phl-compute-02.internal (phl-compute-02.phl.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id DD0431140100;
	Thu, 13 Feb 2025 04:34:26 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Thu, 13 Feb 2025 04:34:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alyssa.is; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1739439266; x=1739525666; bh=RYXVgXqTx1
	oBd7UwtAVqymRurUA+9OUfC2SjzbQ5OZU=; b=fAoBaEZRn9Hc8jjBaLEM5rEFcB
	kMJTYr8TUb9WOo9l+ZLY13F686barCOwuFICnzhn6bZGeQ7qm/5BFAIPNbwQLlJx
	Pdl0pGUty/40iMqkBQPloWr32kSjAKkBvbfnRqMFp6ux8q4yDHTiIm/d6l0m62vl
	e71gJvHwFjInmgvNFXtR1qIziatENU8pYKcSw3+riVOEXBU/6Qn366qsRpcFvsb4
	gwQiEt+D86R6Mwez5eboB9rCAEWFFPelrLkHKWmT7KnZ5xq7zuGfOqqzNJ3JhqYk
	Lrlo2zJn8LMnVelL1whx5QC37FKBcO9bHwjW7mgfVoxQOM4jxA90yA/DiWow==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1739439266; x=1739525666; bh=RYXVgXqTx1oBd7UwtAVqymRurUA+9OUfC2S
	jzbQ5OZU=; b=CqmjnqQw0lH+MgioxNHNHI56AASo6DRO/h3crnpUY8z8AmJkCns
	qFZNJASsSkPNE62KvsYcfRPdRGCjFx3LycwFpYsiH3mbQX0JuE6/zzXkeIcfICRA
	CCyqIS1l+TEaZLLn53s+mnOuGI5H5UnjbmAzIAI6YscraQ0Gd+JabE2zoYOLqhgz
	HH37RijQT26YNLuwFULUoiOBwpctwmDPoAOeGc7OyNcGeahgUNzEmle9snw9MMG2
	9tyzz7SmqRQUPi6vq7ZCBFLGBVN0Ep1+ZXVDvGAnJLoTrqtPi2kd6PnsGBDvdlWI
	qO0OqyjZg+qS3Y8sJ1pCXLZ0steHB1QdTHg==
X-ME-Sender: <xms:orytZynyQFgKb_WDxTUE_h0AimHaVmQTXYsa-IxqbXt_SS2ptRm8Iw>
    <xme:orytZ50N-gCwYjd-0_IjzQOzjHC5oxdEKm_9wNRoTczXmx0eUrQ9Zd3Fkf9FF5E65
    _IvZIL0o6_jmgi8PA>
X-ME-Received: <xmr:orytZwoyz7y0OudvuWMrWe-9ktV05DZtXW-IHv-Js2cQDXn4hUw7Uxgp3XW5TU6KWWTR09himGeJ2WNiVg8P-PsBscc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgdegieegfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefhvfevufgjfhffkfggtgesghdtreertddtjeen
    ucfhrhhomheptehlhihsshgrucftohhsshcuoehhihesrghlhihsshgrrdhisheqnecugg
    ftrfgrthhtvghrnhepffelueelfeeitefgfeduleefuedvgfeugeejkeegieehteehfedu
    ieeigefgleeunecuffhomhgrihhnpehfvgguohhrrghprhhojhgvtghtrdhorhhgpdhgih
    hthhhusgdrtghomhenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhl
    fhhrohhmpehhihesrghlhihsshgrrdhishdpnhgspghrtghpthhtohepvddpmhhouggvpe
    hsmhhtphhouhhtpdhrtghpthhtohepughjfihonhhgsehkvghrnhgvlhdrohhrghdprhgt
    phhtthhopehlihhnuhigqdigfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:orytZ2m2SJ1oCIMnOPlSH9e2hMzVo7XqckF73dmxLr2Lg_92vBaIog>
    <xmx:orytZw3F576UeUFKoT9S0NE80R91uqWVY-iWZO78v7eYmpSOKmCc8A>
    <xmx:orytZ9swm_I1u51rXWOfay399DNW18H8xdA86swnk6WpmloHW1zZFQ>
    <xmx:orytZ8UgeiBAH5w9_tfi-Uqu0mNHWcHpYYbLWPwDUXH5FPW2H5KCOw>
    <xmx:orytZ-CG79nATRHcealpqi1XNiwxRCkMbG-bI8k5aqOr6sDqzkh1NxdN>
Feedback-ID: i12284293:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 13 Feb 2025 04:34:26 -0500 (EST)
Received: by sf.qyliss.net (Postfix, from userid 1000)
	id B21B54E0CD27; Thu, 13 Feb 2025 10:34:23 +0100 (CET)
From: Alyssa Ross <hi@alyssa.is>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH xfsprogs] configure: additionally get icu-uc from
 pkg-config
In-Reply-To: <20250212212017.GK21808@frogsfrogsfrogs>
References: <20250212081649.3502717-1-hi@alyssa.is>
 <20250212212017.GK21808@frogsfrogsfrogs>
Date: Thu, 13 Feb 2025 10:34:21 +0100
Message-ID: <877c5u6vdu.fsf@alyssa.is>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

"Darrick J. Wong" <djwong@kernel.org> writes:

> On Wed, Feb 12, 2025 at 09:16:49AM +0100, Alyssa Ross wrote:
>> This fixes the following build error with icu 76, also seen by
>> Fedora[1]:
>>=20
>> 	/nix/store/9g4gsby96w4cx1i338kplaap0x37apdf-binutils-2.43.1/bin/ld: uni=
crash.o: undefined reference to symbol 'uiter_setString_76'
>> 	/nix/store/9g4gsby96w4cx1i338kplaap0x37apdf-binutils-2.43.1/bin/ld: /ni=
x/store/jbnm36wq89c7iws6xx6xvv75h0drv48x-icu4c-76.1/lib/libicuuc.so.76: err=
or adding symbols: DSO missing from command line
>> 	collect2: error: ld returned 1 exit status
>> 	make[2]: *** [../include/buildrules:65: xfs_scrub] Error 1
>> 	make[1]: *** [include/buildrules:35: scrub] Error 2
>>=20
>> Link: https://src.fedoraproject.org/rpms/xfsprogs/c/624b0fdf7b2a31c1a347=
87b04e791eee47c97340 [1]
>> Signed-off-by: Alyssa Ross <hi@alyssa.is>
>
> Interesting that this pulls in libicuuc just fine without including
> icu-uc.pc, at least on Debian 12:
>
> $ grep LIBICU_LIBS build-x86_64/
> build-x86_64/include/builddefs:222:LIBICU_LIBS =3D -licui18n -licuuc -lic=
udata
>
> Debian sid has the same icu 76 and (AFAICT) it still pulls in the
> dependency:
>
> Name: icu-i18n
> Requires: icu-uc

I don't know too much about Debian, so I might be doing something wrong,
but when I looked in a fresh Debian Sid container I see a libicu-dev
package that's still on 72.1-6, a libicu76 package, but no libicu76
package.  I'm not sure there's currently a package that installs the
icu-i18n.pc from ICU 76?

> Is there something different in Fedora nowadays?
>
> I'm not opposed to this change, I'm wondering why there's a build
> failure and how adding it explicitly to AC_HAVE_LIBICU fixes it.

I suspect it's the following change:

https://github.com/unicode-org/icu/commit/199bc827021ffdb43b6579d68e5eecf54=
c7f6f56

I don't think there's anything special about Fedora here =E2=80=94 I first =
saw
this when the icu package was upgraded in Nixpkgs.

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQRV/neXydHjZma5XLJbRZGEIw/wogUCZ628ngAKCRBbRZGEIw/w
oiP5AP9ZmO0USa/Ufnz35v9yqbSFX6KolGfBxEh+GE4oVTw3PQD+LZfIzOIuLzv/
AkKMLDHLHF/kUNsxYKUp5rmrxvE66g8=
=S61v
-----END PGP SIGNATURE-----
--=-=-=--
