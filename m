Received: from relayout01-q01.e.movistar.es (relayout01-q01.e.movistar.es [86.109.101.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C394187332
	for <linux-xfs@vger.kernel.org>; Mon,  5 May 2025 20:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=86.109.101.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746478090; cv=none; b=qRYxfjSOjiimkbu0LZbCFkL2sps5Ai2gCKlu6nptW8jb9tYhmT/b8nuqurHk5RAZqsN7firlzNC9RuW/PnSZRV2JIK++ikcOWnaNUiGSdczZ4UlmaDsHpOqUP/+w/7wqAJqNKvarHkL1kPyI79zgobWe626X7nnL0+XnFi+iWFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746478090; c=relaxed/simple;
	bh=N+WH+7ktThBKBm+qMy825XW2bUCp7qb4d6skH65BIR8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=QImB2wR3HHhO8kvnlQ4zyK2FUr4s3Kjad5vrVNwf43dIpw3cw7DTKFp2JGi4QFtvfVTD99dABPeUy3zxPXS3ug2dEzjMSfDZPiNxUDHzZ8mvzYLU5FqQFX5WIsqeFP2pi7BgSIpnxBvgk1ux8goAYAJOeIfMLD20d8oUAJiBJz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=telefonica.net; spf=pass smtp.mailfrom=telefonica.net; arc=none smtp.client-ip=86.109.101.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=telefonica.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=telefonica.net
Received: from relayout01-redir.e.movistar.es (relayout01-redir.e.movistar.es [86.109.101.201])
	by relayout01-out.e.movistar.es (Postfix) with ESMTP id 4Zrtgd39vGzjYt3
	for <linux-xfs@vger.kernel.org>; Mon,  5 May 2025 22:39:57 +0200 (CEST)
Received: from Telcontar.valinor (36.red-79-150-114.dynamicip.rima-tde.net [79.150.114.36])
	(using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: robin.listas2@telefonica.net)
	by relayout01.e.movistar.es (Postfix) with ESMTPSA id 4Zrtgd1FpwzfZ93
	for <linux-xfs@vger.kernel.org>; Mon,  5 May 2025 22:39:56 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id 95B6B3212A0
	for <linux-xfs@vger.kernel.org>; Mon, 05 May 2025 22:39:56 +0200 (CEST)
X-Virus-Scanned: amavis at valinor
Received: from Telcontar.valinor ([127.0.0.1])
 by localhost (telcontar.valinor [127.0.0.1]) (amavis, port 10024) with LMTP
 id dLIc3UJQI9jo for <linux-xfs@vger.kernel.org>;
 Mon,  5 May 2025 22:39:56 +0200 (CEST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id 18C26321207
	for <linux-xfs@vger.kernel.org>; Mon, 05 May 2025 22:39:56 +0200 (CEST)
Message-ID: <2b2b20be-6b9c-4378-a3f2-471785cab9e4@telefonica.net>
Date: Mon, 5 May 2025 22:39:55 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Question: Is it possible to recover deleted files from a healthy
 XFS filesystem?
To: Linux-XFS mailing list <linux-xfs@vger.kernel.org>
References: <18512e-6818b200-1ab-59e10800@49678430>
From: "Carlos E. R." <robin.listas@telefonica.net>
Content-Language: es-ES, en-CA
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
In-Reply-To: <18512e-6818b200-1ab-59e10800@49678430>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------BqKvtSvOdoiLSLTegMrd3nfy"
X-TnetOut-Country: IP: 79.150.114.36 | Country: ES
X-TnetOut-Information: AntiSPAM and AntiVIRUS on relayout01
X-TnetOut-MsgID: 4Zrtgd1FpwzfZ93.AAFA1
X-TnetOut-SpamCheck: no es spam (whitelisted), clean
X-TnetOut-From: robin.listas@telefonica.net
X-TnetOut-Watermark: 1747082397.2948@m2vzApzPeG3fSjjG/y7hCg

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------BqKvtSvOdoiLSLTegMrd3nfy
Content-Type: multipart/mixed; boundary="------------ltrX50LCq0VcZu6SIjOLeem0";
 protected-headers="v1"
From: "Carlos E. R." <robin.listas@telefonica.net>
To: Linux-XFS mailing list <linux-xfs@vger.kernel.org>
Message-ID: <2b2b20be-6b9c-4378-a3f2-471785cab9e4@telefonica.net>
Subject: Re: Question: Is it possible to recover deleted files from a healthy
 XFS filesystem?
References: <18512e-6818b200-1ab-59e10800@49678430>
In-Reply-To: <18512e-6818b200-1ab-59e10800@49678430>

--------------ltrX50LCq0VcZu6SIjOLeem0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjAyNS0wNS0wNSAxNDo0MiwgQmMuIE1hcnRpbiDFoGFmcsOhbmVrIHdyb3RlOg0KPiBI
ZWxsbyBldmVyeW9uZSwNCj4gDQo+IEkgaGF2ZSBhIHF1ZXN0aW9uIHJlZ2FyZGluZyBYRlMg
YW5kIGZpbGUgcmVjb3ZlcnkuDQo+IA0KPiBJcyB0aGVyZSBhbnkgbWV0aG9kIOKAlCBvZmZp
Y2lhbCBvciB1bm9mZmljaWFsIOKAlCB0byByZWNvdmVyIGRlbGV0ZWQgZmlsZXMgZnJvbSBh
IGhlYWx0aHksIHVuY29ycnVwdGVkIFhGUyBmaWxlc3lzdGVtPyBJIHVuZGVyc3RhbmQgdGhh
dCBYRlMgZG9lcyBub3Qgc3VwcG9ydCB1bmRlbGV0aW9uLCBidXQgSSdtIHdvbmRlcmluZyBp
ZiBhbnkgcmVtbmFudHMgb2YgbWV0YWRhdGEgbWlnaHQgc3RpbGwgYWxsb3cgcGFydGlhbCBv
ciBmdWxsIHJlY292ZXJ5LCBwZXJoYXBzIHVuZGVyIHNwZWNpZmljIGNvbmRpdGlvbnMuDQo+
IA0KPiBJZiBhbnlvbmUgaGFzIGluc2lnaHRzLCB0b29scywgb3Igc3VnZ2VzdGlvbnMsIEni
gJlkIGJlIHZlcnkgZ3JhdGVmdWwuDQo+IA0KPiBUaGFuayB5b3UgZm9yIHlvdXIgdGltZS4N
Cg0KVGhlcmUgYXJlIHRvb2xzIHRoYXQgc2VhcmNoIHRoZSBkaXNrIGJsb2NrcyB0cnlpbmcg
dG8gZmluZCBibG9ja3MgdGhhdCANCmJlbG9uZ2VkIHRvIGEgZmlsZSB0aGF0IHdhcyBkZWxl
dGVkLiBUaGUgZmlyc3Qgc3RlcCB3b3VsZCBiZSB0byBzZXQgdGhhdCANCmZpbGVzeXN0ZW0g
dG8gcmVhZCBvbmx5LCBhbmQgaG9wZWZ1bGx5LCBjcmVhdGUgYW4gaW1hZ2UuDQoNCkkgaGF2
ZSBuZXZlciB0cmllZCBvbiBhbiBYRlMgZmlsZXN5c3RlbSwgc28gSSBjYW4ndCByZWNvbW1l
bmQgYW55IHRvb2wuIA0KVG9vbHMgbmVlZCB0byBrbm93IHRoZSB0eXBlIG9mIGZpbGUgeW91
IHdhbnQgdG8gZmluZC4NCg0KLS0gDQpDaGVlcnMgLyBTYWx1ZG9zLA0KDQoJCUNhcmxvcyBF
LiBSLg0KCQkoZnJvbSAxNS42IHg4Nl82NCBhdCBUZWxjb250YXIpDQo=

--------------ltrX50LCq0VcZu6SIjOLeem0--

--------------BqKvtSvOdoiLSLTegMrd3nfy
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wmMEABEIACMWIQQZEb51mJKK1KpcU/W1MxgcbY1H1QUCaBkiHAUDAAAAAAAKCRC1MxgcbY1H1VAL
AKCCjbkIW/7cArxT/GRnCBb3+W86kQCghFWBj5emEp48o1vN80bxpasfUXc=
=pwKW
-----END PGP SIGNATURE-----

--------------BqKvtSvOdoiLSLTegMrd3nfy--
