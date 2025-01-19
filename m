Received: from relayout02-q02.e.movistar.es (relayout02-q02.e.movistar.es [86.109.101.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537D6155345
	for <linux-xfs@vger.kernel.org>; Sun, 19 Jan 2025 21:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=86.109.101.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737321792; cv=none; b=EWZYX8YoQAjHoJ/F4Bex/tBRX7fJCmPYFO2ha9HJydnR0Iul3jT31CF9nTSQbm/IXIfzzY9zHoXkSukmnl9nUxIxxl55sbLf8sPw8GEUktuvo0XXVKfrUsHO9kaRziib4e/lur4cxXlzkJxqbPPydtShzn4/3hovA0U5sV+eo40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737321792; c=relaxed/simple;
	bh=28UMFGPvFlCO5ayaHNicHislrqzL8mAip1JNJjXky9w=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=O5hbj3PcbmabAjxIzdGvEVAX6ffCFE98H8N2UAw7ZE08INezfEIL/8DcjcAepX8QDd9Oom+gKo6BOJWAV5EKRB/Jd42qYL66i3tiqXyxvQynRWydJoMi2OGc//3NwwKIWQknp7jMSG7wuQyY8aaHtHymjSDIGlPy10mcdRH7hNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=telefonica.net; spf=pass smtp.mailfrom=telefonica.net; arc=none smtp.client-ip=86.109.101.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=telefonica.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=telefonica.net
Received: from relayout02-redir.e.movistar.es (unknown [86.109.101.202])
	by relayout02-out.e.movistar.es (Postfix) with ESMTP id 4YbmJG555RzhYYV
	for <linux-xfs@vger.kernel.org>; Sun, 19 Jan 2025 22:07:26 +0100 (CET)
Received: from Telcontar.valinor (7.red-79-150-117.dynamicip.rima-tde.net [79.150.117.7])
	(using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: robin.listas2@telefonica.net)
	by relayout02.e.movistar.es (Postfix) with ESMTPSA id 4YbmJF17BMzdbjS
	for <linux-xfs@vger.kernel.org>; Sun, 19 Jan 2025 22:07:24 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id A076E320EBC
	for <linux-xfs@vger.kernel.org>; Sun, 19 Jan 2025 22:07:24 +0100 (CET)
X-Virus-Scanned: amavisd-new at valinor
Received: from Telcontar.valinor ([127.0.0.1])
	by localhost (telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id m5HoLs10P3Yb for <linux-xfs@vger.kernel.org>;
	Sun, 19 Jan 2025 22:07:24 +0100 (CET)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id 2461C3207E8
	for <linux-xfs@vger.kernel.org>; Sun, 19 Jan 2025 22:07:24 +0100 (CET)
Message-ID: <0dc323c4-4ab0-4aaf-b3dd-37a9e581b395@telefonica.net>
Date: Sun, 19 Jan 2025 22:07:23 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Transparent compression with XFS - especially with zstd
To: Linux-XFS mailing list <linux-xfs@vger.kernel.org>
References: <65266e1f-3f0c-44de-9dd3-565cb75ae54a@wiesinger.com>
Content-Language: es-ES, en-CA
From: "Carlos E. R." <robin.listas@telefonica.net>
Autocrypt: addr=robin.listas@telefonica.net; keydata=
 xsDiBEBfUmURBADiQy6hqnDUs980vU7Pi0qm/JnurLnZUDDEf8k7H10UnKi8E3ySztQuWsPK
 12ccfWCHMKboluffBQA3jf0h1Rl6VZ9brU+rNuqy1eE8bkILhLkoZrsNGXWtzOvRHVSF7dhb
 GBuuFeqdGiRJPSvezQAi3S8dgXugSLZvbyHV97rATwCgmYzZ9mLrTV9RPMJy07K9SY2ZFFkD
 /1rvNuU1teq5hm4naypOFrfO2X4foo9+UjuqZpcPnxD4LEfyrjpx5QVNi3zEDGIAbN7exo4X
 s3VDWnrYZ8lqno4LfTlbuFcgLbAllhW7tYFg4sNW1dWr29VQjghZ8le+Fucx2VJOwv6ILWOr
 O7Qgj61HUvWlR+doKxQBOxFk50IiBACuUBaWimjjbJKvGjMRimJWdGHHxwo+oMA2ZLnsS7wJ
 cSIthF8FC8c1pyJwWcLiYcViy3kypJPloTiQqaZqhVx0ouCYFHBOYLaacCddJ7r6KHZyrjjo
 SegO1vIJn2Y9TolJfuHMNb276A+JPb3gHqm1bfcNHmduKa0gK2NyEkKGWc0wQ2FybG9zIEUu
 IFIuIChjZXIpIDxyb2Jpbi5saXN0YXNAdGVsZWZvbmljYS5uZXQ+wngEExEIADgCGwMGCwkI
 BwMCAxUCAwMWAgECHgECF4ACGQEWIQQZEb51mJKK1KpcU/W1MxgcbY1H1QUCXbLTkAAKCRC1
 MxgcbY1H1eLvAJ4hPAOO6Ru93N7h0tm/ojhT/FxGsQCeNWfR4rMNiONSpySLJp4YvQVWxZnO
 wE0EQF9SZhAEAJYs7Y2YcxT1Uz55O3z3VwgV9e6F0YFejeu1DHphuCHq2B5qDRHOKKPvG2WB
 21bIz4aPZxIrkzvg/cg6I8qn8Aumd5aZgSr/XUTTPJc9YLlM5e7X+QF+tG9HuxPAH9xe2EcR
 KrWP54Q4X//iHSxasIIpZXA17s1HLgRdsDpy6VYLAAMFA/9zgwJ/XhhTWpohCXLv1mA2xJk+
 r9CJUsUj0sbdqytLU52I+yRVLUY3g4MFp504alRwxr+LBptEgsf53eXuU0gG9nXxpFk3zlut
 6r0EKZvQAhiCZmJQvZbl3FeHaBA9qoi8XvK9G4a5jljMLkqonsaWlrbDNnzgh2hYARUxn6P+
 5MJdBBgRCAAdFiEEGRG+dZiSitSqXFP1tTMYHG2NR9UFAl2y05AACgkQtTMYHG2NR9VDmQCe
 IPJ9kY9XUWtaBW9X9F1AfURttC8AnRNz3RmjBY99/W4UZzspOaeMZM6d
In-Reply-To: <65266e1f-3f0c-44de-9dd3-565cb75ae54a@wiesinger.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------VJYZhtbJ5RBktM6tHipmOrnZ"
X-TnetOut-Country: IP: 79.150.117.7 | Country: ES
X-TnetOut-Information: AntiSPAM and AntiVIRUS on relayout02
X-TnetOut-MsgID: 4YbmJF17BMzdbjS.A38CD
X-TnetOut-SpamCheck: no es spam (whitelisted), clean
X-TnetOut-From: robin.listas@telefonica.net
X-TnetOut-Watermark: 1737925646.4484@l8BhkQkmwwaQ8DL75GKd3g

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------VJYZhtbJ5RBktM6tHipmOrnZ
Content-Type: multipart/mixed; boundary="------------LaJlWQ1kB0f7RwuiuQWu92dm";
 protected-headers="v1"
From: "Carlos E. R." <robin.listas@telefonica.net>
To: Linux-XFS mailing list <linux-xfs@vger.kernel.org>
Message-ID: <0dc323c4-4ab0-4aaf-b3dd-37a9e581b395@telefonica.net>
Subject: Re: Transparent compression with XFS - especially with zstd
References: <65266e1f-3f0c-44de-9dd3-565cb75ae54a@wiesinger.com>
In-Reply-To: <65266e1f-3f0c-44de-9dd3-565cb75ae54a@wiesinger.com>

--------------LaJlWQ1kB0f7RwuiuQWu92dm
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjAyNS0wMS0xOSAxMzoxNiwgR2VyaGFyZCBXaWVzaW5nZXIgd3JvdGU6DQo+IEhlbGxv
LA0KPiANCj4gQXJlIHRoZXJlIGFueSBwbGFucyB0byBpbmNsdWRlIHRyYW5zcGFyZW50IGNv
bXByZXNzaW9uIHdpdGggWEZTIA0KPiAoZXNwZWNpYWxseSB3aXRoIHpzdGQpPw0KDQpJIGFt
IGFsc28gY3VyaW91cyBhYm91dCB0aGlzLCBzZWVpbmcgdGhhdCBidHJmcyBoYXMgY29tcHJl
c3Npb24uDQoNCi0tIA0KQ2hlZXJzIC8gU2FsdWRvcywNCg0KCQlDYXJsb3MgRS4gUi4NCgkJ
KGZyb20gTGVhcCAxNS41IHg4Nl82NCBhdCBUZWxjb250YXIpDQo=

--------------LaJlWQ1kB0f7RwuiuQWu92dm--

--------------VJYZhtbJ5RBktM6tHipmOrnZ
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wmMEABEIACMWIQQZEb51mJKK1KpcU/W1MxgcbY1H1QUCZ41pjAUDAAAAAAAKCRC1MxgcbY1H1aoU
AJ9usk1/RFMdAPqIVrNtzZPLh1cImQCeKbt9U5rPvkWIZ8ijy4vydfYYdOs=
=r1L6
-----END PGP SIGNATURE-----

--------------VJYZhtbJ5RBktM6tHipmOrnZ--
