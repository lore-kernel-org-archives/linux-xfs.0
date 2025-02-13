Received: from fhigh-b2-smtp.messagingengine.com (fhigh-b2-smtp.messagingengine.com [202.12.124.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5ED820CCE3
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 09:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739439576; cv=none; b=N6Y5r1LndGeZKIWY5k0ZI9qAQ59vmyd0OvHX07AvDe3MQdTK5Yt8rbnuHFkC6H9+E8EI2Z1Vdy+euwP4yIyVHaL8LXTODpp0sf8HHwn2GE0H/ZW2zy0jRMF7qmFv1ZEP4/zrhvHhp0OGmYr0GneivKRwmz2ONtPMSdND/+S9Rgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739439576; c=relaxed/simple;
	bh=RKRelYBNL2VJmlRIekvsp+NOn32b4s+tByiibepJWgY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=PxwnKYQYmEC0YrPPMTSzIcb10W8y4Bg7g8TbkHCGIg5CkfWQ0bI234xaGFeZUUM+mKtlDeIkDnc3QJVw5UzV7RVd/9reMw+gOrsuoZZ6npmyznclXI+KPhwGsInfYRm08TPMH5H6YU3vpQUu/RDbPKY6ZMWBKPid3jDKTiS3PwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alyssa.is; spf=pass smtp.mailfrom=alyssa.is; dkim=pass (2048-bit key) header.d=alyssa.is header.i=@alyssa.is header.b=FpydGxW8; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=nMtUAKs8; arc=none smtp.client-ip=202.12.124.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alyssa.is
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alyssa.is
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=alyssa.is header.i=@alyssa.is header.b="FpydGxW8";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="nMtUAKs8"
Received: from phl-compute-02.internal (phl-compute-02.phl.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id A27C425401A8;
	Thu, 13 Feb 2025 04:39:32 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Thu, 13 Feb 2025 04:39:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alyssa.is; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1739439572; x=1739525972; bh=BTfguNd4+R
	epbvqVBMWubzsyYNKDoJg1Xye8D+/naRo=; b=FpydGxW870lZdeJWsi9OU5X6kZ
	iRDFnLHuYJCE4HR/vktKkWv1jdJ0a0Akaz7hPIfWxWk6zh+welGmqZWfLP4K6eqa
	kz4AqHuodGMX6h0GIEATDcYXsb7wLntcJZKKPXBE9vJMlJ65OliDvCVTi2R9Mjkq
	+8Pz01CIBJw5OWUG/Ho8Bzm3o7iYhTjrA/QfY9Q8FLTYkQksJFD8q8ugDDkGAC4r
	qGTCOmwEif6eJGt3/ftWZfGbbYvhphHupRQZeba/M4ytTqU4toW8XfDKvjlwxJBe
	ySK9RJJ9xQnyPxxd0tThn8Kl/gxNxKUOPi0XStH+I9o1ze2IdsWIXWo1pp7A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1739439572; x=1739525972; bh=BTfguNd4+RepbvqVBMWubzsyYNKDoJg1Xye
	8D+/naRo=; b=nMtUAKs8EQEweM2a/Xaw0Hzr+6X+P8l2hMa8bWeo2c/qg6gXhA4
	dS4D+x6bQp7Y9AlsnFTsxDsn8hhVGRDSfbu3bH01jfdfbhEFZ0t0AxL7gqWaU5IU
	RKG+uE7YJTUKyqGQOp8efj3EVpuSeWxjgoaiCjZsEZVC0nHD+5ywJN2A/XznwvHS
	sqsp+p0ow7meK7NB9dWISO7KoYy28oCqefaH3ZHLciBA84ldfk5GBQUl7RsOVj7l
	A7ArLMbMWASK1o8mbEBOwu+XSUIlZjoyYqz+i9DAf7dsS65obBHNYxG8FBWhLOCG
	q7/BVN2CLmovYe8ThF6AsBq+2KTdquACbrw==
X-ME-Sender: <xms:1L2tZ8laQnbqvyQLNC5ypvNTjeayHNjRyN3afax8CgMwVXLAEBXZXA>
    <xme:1L2tZ71ZEz-Cy8szVqtY4dQSrtNzkpiFe8ruM4uFj3Octu3_dGIEn_hikah7K2uZ0
    Iv5NmhSSlMR_5EGZw>
X-ME-Received: <xmr:1L2tZ6pbedWsXGABtWdAgQo6pZnPCd09BlXny34yfseZLnsOsyIGTNRyI0PEQVL0EVGkgeE_iQRSr3-2kcdhwJMSTZI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgdegieeggecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefhvfevufgjfhffkfggtgesghdtreertddttden
    ucfhrhhomheptehlhihsshgrucftohhsshcuoehhihesrghlhihsshgrrdhisheqnecugg
    ftrfgrthhtvghrnhepkefgtddvudeikeeuudelgefhhfejudfgteeigffgtddvgfdutddt
    gfejueduteeinecuffhomhgrihhnpehfvgguohhrrghprhhojhgvtghtrdhorhhgnecuve
    hluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhephhhisegrlhih
    shhsrgdrihhspdhnsggprhgtphhtthhopedvpdhmohguvgepshhmthhpohhuthdprhgtph
    htthhopegujhifohhngheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidq
    gihfshesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:1L2tZ4kvoh47jm35lLXSVSvz3Mu3tAlJXP4kxBRjhH5WbUNOQlq27g>
    <xmx:1L2tZ60XU565s-5P23OiGfepuP50p9rRkQ7B3cUMW8hY1-5zvT5KSw>
    <xmx:1L2tZ_seCWvGBWSifbXoaYuZsPDYxjKMuU9xp7bUKsOoA3HDRP14xw>
    <xmx:1L2tZ2VEuXBu5CB2NeUwfddvxjJiq-2s2ncdEGTtIJ0Cr8_ZWH8J4g>
    <xmx:1L2tZ4CNNqB0eQkCTtsiDl3ynGxUZ_X3TfmkZVXRkFxZM0fBh1VIkKmX>
Feedback-ID: i12284293:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 13 Feb 2025 04:39:31 -0500 (EST)
Received: by sf.qyliss.net (Postfix, from userid 1000)
	id E051A4E0D50E; Thu, 13 Feb 2025 10:39:30 +0100 (CET)
From: Alyssa Ross <hi@alyssa.is>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH xfsprogs] configure: additionally get icu-uc from
 pkg-config
In-Reply-To: <877c5u6vdu.fsf@alyssa.is>
References: <20250212081649.3502717-1-hi@alyssa.is>
 <20250212212017.GK21808@frogsfrogsfrogs> <877c5u6vdu.fsf@alyssa.is>
Date: Thu, 13 Feb 2025 10:39:29 +0100
Message-ID: <8734gi6v5a.fsf@alyssa.is>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Alyssa Ross <hi@alyssa.is> writes:

> "Darrick J. Wong" <djwong@kernel.org> writes:
>
>> On Wed, Feb 12, 2025 at 09:16:49AM +0100, Alyssa Ross wrote:
>>> This fixes the following build error with icu 76, also seen by
>>> Fedora[1]:
>>>=20
>>> 	/nix/store/9g4gsby96w4cx1i338kplaap0x37apdf-binutils-2.43.1/bin/ld: un=
icrash.o: undefined reference to symbol 'uiter_setString_76'
>>> 	/nix/store/9g4gsby96w4cx1i338kplaap0x37apdf-binutils-2.43.1/bin/ld: /n=
ix/store/jbnm36wq89c7iws6xx6xvv75h0drv48x-icu4c-76.1/lib/libicuuc.so.76: er=
ror adding symbols: DSO missing from command line
>>> 	collect2: error: ld returned 1 exit status
>>> 	make[2]: *** [../include/buildrules:65: xfs_scrub] Error 1
>>> 	make[1]: *** [include/buildrules:35: scrub] Error 2
>>>=20
>>> Link: https://src.fedoraproject.org/rpms/xfsprogs/c/624b0fdf7b2a31c1a34=
787b04e791eee47c97340 [1]
>>> Signed-off-by: Alyssa Ross <hi@alyssa.is>
>>
>> Interesting that this pulls in libicuuc just fine without including
>> icu-uc.pc, at least on Debian 12:
>>
>> $ grep LIBICU_LIBS build-x86_64/
>> build-x86_64/include/builddefs:222:LIBICU_LIBS =3D -licui18n -licuuc -li=
cudata
>>
>> Debian sid has the same icu 76 and (AFAICT) it still pulls in the
>> dependency:
>>
>> Name: icu-i18n
>> Requires: icu-uc
>
> I don't know too much about Debian, so I might be doing something wrong,
> but when I looked in a fresh Debian Sid container I see a libicu-dev
> package that's still on 72.1-6, a libicu76 package, but no libicu76
> package.  I'm not sure there's currently a package that installs the
> icu-i18n.pc from ICU 76?

Here I meant "no libicu75-dev package".

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQRV/neXydHjZma5XLJbRZGEIw/wogUCZ6290QAKCRBbRZGEIw/w
oj1kAP9owutT+weWUXLVNn22YGPFXpMEMUTQRuSsrZ73IYoDLwEAo5q4QdNRzbK4
f6WbHUA1Bx4p2Y0oa9CnaIPXBTpzFgA=
=ceaU
-----END PGP SIGNATURE-----
--=-=-=--
