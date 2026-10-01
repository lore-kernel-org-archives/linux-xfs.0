Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C183A8722
	for <linux-xfs@vger.kernel.org>; Thu,  1 Oct 2026 16:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790872237; cv=none; b=tvyZ3cUmWnaUBt2B+LklmZSXCcW43vzrt+eI/vBKW3RNtm/ePlL4EdqV98HxVETnJZn9JjqzlhQYUHDWt2c6q0dhfl/hSk9jZWBFQ68F3aRy46Kl/84rfqFwe+zCgozcwdC9640Jl94sAZWqjq+wOa4FjJjWp1zb/gMzPsBGF3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790872237; c=relaxed/simple;
	bh=W0wBQYV+n5v4Eq/Co9uR4LVavPwZZkEbmIq3ZsXoP0g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q2RGL4dDJqPKt7VMZIyT2X89duKOzKAftwrZfLLLkgwgn7jaIHwC9p7/daEeBu0mfF83lutvjuaM/jPZJH93vaiGZEb84G3l8cPz2ZtzkCO3XEnHftf59rj6tKstvesS3q0YO42c23ObhVVvg++a/9qxV5ws3ZwfZ39l/ERVJ3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=MgJOEKlT; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="MgJOEKlT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=W0wBQYV+n5v4Eq/Co9uR4LVavPwZZkEbmIq3ZsXoP0g=; b=MgJOEKlTvCkM5REHUix2OciqP3
	JysTT1xzQS2Faxf4JFFC49+90b3U0eQ/7KyV7fTgwWCG53PXCt0gWK7NNvLAMAZAOb02jj/F0VrVd
	1sQI8Tsp6YzCOW9yFH+L3ETFSAnxYy0E2UCGS05ITcIxxuTWnLilypFhslN5mRy1NrFQFN8/5BP96
	WkBVc0HeHCkk4KTrqZVkLLiQZXHwhSp9qPIVmE1Lq3RzPw6xi6QKUXwhUcMoJHuP16vljKQFmIOzr
	zzyD1+YvZTrSMTaAEYElEQCvsI+8RvC/ExFCCtyYUAVf+vsTG5PMjggWxtVZzcwg9HlzS4mhwLzkk
	jYImXT4g==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128)
	(Exim 4.96)
	(envelope-from <biebl@debian.org>)
	id 1xCJfr-000Dov-2Z;
	Thu, 01 Oct 2026 16:30:23 +0000
Message-ID: <e2331da5-fbc4-4f59-8806-2474bd1e0044@debian.org>
Date: Thu, 1 Oct 2026 18:30:17 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs_healer: fail earlier on non-xfs filesystems
To: "Darrick J. Wong" <djwong@kernel.org>,
 Andrey Albershteyn <aalbersh@redhat.com>
Cc: 1149571@bugs.debian.org, Christoph Hellwig <hch@infradead.org>,
 xfs <linux-xfs@vger.kernel.org>
References: <20261001062338.GV2705364@frogsfrogsfrogs>
Content-Language: en-US
From: Michael Biebl <biebl@debian.org>
Autocrypt: addr=biebl@debian.org; keydata=
 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
In-Reply-To: <20261001062338.GV2705364@frogsfrogsfrogs>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------m8jfOLowfC1lmh0kF39tNpe7"
X-Debian-User: biebl

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------m8jfOLowfC1lmh0kF39tNpe7
Content-Type: multipart/mixed; boundary="------------0QIQ0wSMfOiXB6yOELdcfO0m";
 protected-headers="v1"; hp="clear"
Message-ID: <e2331da5-fbc4-4f59-8806-2474bd1e0044@debian.org>
Date: Thu, 1 Oct 2026 18:30:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs_healer: fail earlier on non-xfs filesystems
To: "Darrick J. Wong" <djwong@kernel.org>,
 Andrey Albershteyn <aalbersh@redhat.com>
Cc: 1149571@bugs.debian.org, Christoph Hellwig <hch@infradead.org>,
 xfs <linux-xfs@vger.kernel.org>
References: <20261001062338.GV2705364@frogsfrogsfrogs>
Content-Language: en-US
From: Michael Biebl <biebl@debian.org>
Autocrypt: addr=biebl@debian.org; keydata=
 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
In-Reply-To: <20261001062338.GV2705364@frogsfrogsfrogs>

--------------0QIQ0wSMfOiXB6yOELdcfO0m
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

QW0gMDEuMTAuMjYgdW0gMDg6MjMgc2NocmllYiBEYXJyaWNrIEouIFdvbmc6DQo+IEZyb206
IERhcnJpY2sgSi4gV29uZyA8ZGp3b25nQGtlcm5lbC5vcmc+DQo+IA0KPiBBIERlYmlhbiB1
c2VyIHJlcG9ydGVkIHRoYXQgdGhlIHJvb3QgZmlsZXN5c3RlbSBzZXJ2aWNlIGZhaWxzIHdp
dGg6DQo+IA0KPiAgIHN5c3RlbWRbMV06IFN0YXJ0aW5nIHhmc19oZWFsZXJALS5zZXJ2aWNl
IC0gU2VsZiBIZWFsaW5nIG9mIFhGUyBNZXRhZGF0YSBmb3IgLy4uLg0KPiAgIHhmc19oZWFs
ZXJALVs5NzZdOiAvOiBJbmFwcHJvcHJpYXRlIGlvY3RsIGZvciBkZXZpY2UNCj4gICBzeXN0
ZW1kWzFdOiB4ZnNfaGVhbGVyQC0uc2VydmljZTogQ29uZGl0aW9uIGNoZWNrIHByb2Nlc3Mg
ZXhpdGVkLCBjb2RlPWV4aXRlZCwgc3RhdHVzPTI1NS9FWENFUFRJT04NCj4gICBzeXN0ZW1k
WzFdOiB4ZnNfaGVhbGVyQC0uc2VydmljZTogRmFpbGVkIHdpdGggcmVzdWx0ICdleGl0LWNv
ZGUnLg0KPiAgIHN5c3RlbWRbMV06IEZhaWxlZCB0byBzdGFydCB4ZnNfaGVhbGVyQC0uc2Vy
dmljZSAtIFNlbGYgSGVhbGluZyBvZiBYRlMgTWV0YWRhdGEgZm9yIC8uDQo+IA0KPiB3aGVu
IHRoZSByb290IGZpbGVzeXN0ZW0gaXMgbm90IFhGUy4gIEl0J3MgbW9zdCBsaWtlbHkgZXh0
NCBnaXZlbg0KPiBEZWJpYW4ncyBkZWZhdWx0cy4gIA0KDQpGd2l3LCB0aGlzIGFzc3VtcHRp
b24gaXMgY29ycmVjdC4gTXkgLyBpcyB1c2luZyBleHQ0Lg0KDQpSZWdhcmRzLA0KTWljaGFl
bA0KDQo=

--------------0QIQ0wSMfOiXB6yOELdcfO0m--

--------------m8jfOLowfC1lmh0kF39tNpe7
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEECbOsLssWnJBDRcxUauHfDWCPItwFAmq+ipkFAwAAAAAACgkQauHfDWCPItyb
FQ//bthKXDvPSnyT7xvMiAQPL2iuKSxAVPObP44Q6uu1M7s83Dnqg8rB1FaU5HkocsF21WzD9jX8
p9C2YJLlNXid/pHjdLMMAkP6dAGMt/LTktJoprtdPXpnh2MXYlcHn1jbhGCIE3QEHZinu8kEyJi2
uogdhAu7b4XKC2HJ7I8M9HtP5EDNbPoNyNyfbQzAAGBMCY+ag6pbqsP4Rm30mRAbA27RstakVf3N
5Ex+V6Ajk4vsGVm7w7U42dYn3nxYFFt9+FtlU2yS5+Ipod4pd5TLCmNHCq8iDykoHCHAs2OncXEk
/SN//mixpknqfQwf927si8JKSSGQ2weZLWT5ke/5PXksadR5FCzC5rdmf1I0zej6FGnJHLYidV9h
qudNVzntm+5bZdeazkF1+TEeZ3K5KXN54YL27Uw0hlrZ6X+dzsHjaNNaDCeIutk7dAfl1TcPanzU
ONdlWY5Xg8XRwge8mmJnI4kL7VbNuD/r3bU44yefRokGSXGrmsVxRCB90fzrznU7RDq5lztDVgfi
6odcSPy8abzNTv4ktuReLWis+XZyg0TG/oBRfcckIrqLBjTd/140leh5H+4vy9KzE4GxyqIJuuO/
sJjqXPGIrjkkKffVjwAeO/tLcSLfb0OXz3m2shNIVHJqxR8vR99mKPsCRufNDEeFY/RRWSTUiccf
RCg=
=YE+0
-----END PGP SIGNATURE-----

--------------m8jfOLowfC1lmh0kF39tNpe7--
