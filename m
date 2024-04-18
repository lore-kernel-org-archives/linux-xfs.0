Received: from relayout04-q02.e.movistar.es (relayout04-q02.e.movistar.es [86.109.101.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28FB15FD07
	for <linux-xfs@vger.kernel.org>; Thu, 18 Apr 2024 18:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=86.109.101.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713464292; cv=none; b=p6LlLeOdTgj+Lv2is78e2293vzU0MWAIWgGVoIxhG1S1qAppM3SaM558u4DLj4K9+Q1rGODgoN5a388K7AhobL4ZwXqH5D4sD2Zs8nf0egemaAQ07JXHZi99MdXCx96rg6OTu0qkHerC4fT3ejMQGYiNoRFUmgKq/M1E7Dw2Tyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713464292; c=relaxed/simple;
	bh=WYV3BcvVx2V+ASbJmcGQRFHPUGvKIcskOGe/iXTkcqI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=oNW6N9r4rY8DJ778PbGveL1aipP1Vm59QEHCbejxXENuyYzfnflWSXOOtaRKaQbkI+FCX/lFwP8DWb4t5GSAFH+pAgndqQ1MiOIfZczKlibrHKSYoEnSL5IZQ9nUYN//ZWl8ApSHQkL9IxK3TI30jdTqO2pyiL+/9fG8JlbTMW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=telefonica.net; spf=pass smtp.mailfrom=telefonica.net; arc=none smtp.client-ip=86.109.101.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=telefonica.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=telefonica.net
Received: from relayout04-redir.e.movistar.es (relayout04-redir.e.movistar.es [86.109.101.204])
	by relayout04-out.e.movistar.es (Postfix) with ESMTP id 4VL5Fv3rZgz1CDvT
	for <linux-xfs@vger.kernel.org>; Thu, 18 Apr 2024 20:02:11 +0200 (CEST)
Received: from Telcontar.valinor (236.red-79-151-89.dynamicip.rima-tde.net [79.151.89.236])
	(using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: robin.listas2@telefonica.net)
	by relayout04.e.movistar.es (Postfix) with ESMTPSA id 4VL5Ft320Xz16L5N
	for <linux-xfs@vger.kernel.org>; Thu, 18 Apr 2024 20:02:10 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id DA73D32456F
	for <linux-xfs@vger.kernel.org>; Thu, 18 Apr 2024 20:02:09 +0200 (CEST)
X-Virus-Scanned: amavisd-new at valinor
Received: from Telcontar.valinor ([127.0.0.1])
	by localhost (telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id gtCPyiu3oI8h for <linux-xfs@vger.kernel.org>;
	Thu, 18 Apr 2024 20:02:09 +0200 (CEST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id C41E83208FB
	for <linux-xfs@vger.kernel.org>; Thu, 18 Apr 2024 20:02:09 +0200 (CEST)
Message-ID: <3b60a114-762e-4139-9e78-8c8378454c7a@telefonica.net>
Date: Thu, 18 Apr 2024 20:02:09 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ANNOUNCE] GPG key update
To: Linux-XFS mailing list <linux-xfs@vger.kernel.org>
References: <akavzwaevicl2agsucc4salxjtxmmg74htvtiswzf2ortw2rud@fstpc2o5ywlo>
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
In-Reply-To: <akavzwaevicl2agsucc4salxjtxmmg74htvtiswzf2ortw2rud@fstpc2o5ywlo>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------1L2yQuKOhE9hcFD5ruOHde02"
X-TnetOut-Country: IP: 79.151.89.236 | Country: ES
X-TnetOut-Information: AntiSPAM and AntiVIRUS on relayout04
X-TnetOut-MsgID: 4VL5Ft320Xz16L5N.A892A
X-TnetOut-SpamCheck: no es spam (whitelisted), clean
X-TnetOut-From: robin.listas@telefonica.net
X-TnetOut-Watermark: 1714068130.95227@iLgBmJQZVVkK1I+UKWbdvw

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------1L2yQuKOhE9hcFD5ruOHde02
Content-Type: multipart/mixed; boundary="------------bRvgGe8rveK92Rv3j1ebAiQH";
 protected-headers="v1"
From: "Carlos E. R." <robin.listas@telefonica.net>
To: Linux-XFS mailing list <linux-xfs@vger.kernel.org>
Message-ID: <3b60a114-762e-4139-9e78-8c8378454c7a@telefonica.net>
Subject: Re: [ANNOUNCE] GPG key update
References: <akavzwaevicl2agsucc4salxjtxmmg74htvtiswzf2ortw2rud@fstpc2o5ywlo>
In-Reply-To: <akavzwaevicl2agsucc4salxjtxmmg74htvtiswzf2ortw2rud@fstpc2o5ywlo>

--------------bRvgGe8rveK92Rv3j1ebAiQH
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjAyNC0wNC0xOCAxMDoyMywgQ2FybG9zIE1haW9saW5vIHdyb3RlOg0KPiBIaSwNCj4g
SSBkaWRuJ3QgbWVhbiB0byBzZW5kIHN1Y2ggZW1haWwsIGJ1dCBtb3JlIHRoYW4gb25lIHBl
cnNvbiBhbHJlYWR5IGFza2VkIG1lIGFib3V0IGl0LCBzbywgc2hhcmluZyBpdA0KPiBmb3Ig
YSBicm9hZGVyIGF1ZGllbmNlLg0KPiANCj4gDQo+IFRMO0RSOw0KPiANCj4gSSBzdGFydGVk
IHRvIHVzZSBhIG5ldyBrZXkgdG8gc2lnbiBzdHVmZiB0d28gbW9udGhzIGFnbywgaWYgeW91
IGhhZCBhbnkga2V5IG1pc21hdGNoIHByb2JsZW0sIHVwZGF0ZQ0KPiB5b3VyIGtleXJpbmcu
IE15IGFwb2xvZ2llcyBmb3IgYW55IHRyb3VibGUuDQo+IA0KPiANCj4gPT0gTG9uZyBWZXJz
aW9uID09DQoNCi4uLg0KDQo+IE15IGNlcnRpZnkgKG9yIG1hc3RlciBrZXkpIGlzIHN0aWxs
IHRoZSBzYW1lOiA0MDIwNDU5RTU4QzFBNTI1MTFGNTM5OTExM0Y3MDNFNkMxMUNGNkYwDQo+
IFdpdGggYSBuZXcgZXh0cmEgc3Via2V5IGFkZGVkIHVuZGVyIGl0OiAwQzFEODkxQzUwQTcz
MkUwNjgwRjdCNjQ0Njc1QTExMUU1MEI1RkE2DQoNCkkgb25seSB3YW50ZWQgdG8gcG9pbnQg
b3V0IHRoYXQgdGhlIG5ldHdvcmsgb2YgR1BHIGtleXNlcnZlcnMgaXMgYnJva2VuLCANCnNp
bmNlIHRoZSBhdHRhY2sgdGhleSBzdWZmZXJlZCBhIGZldyB5ZWFycyBiYWNrLg0KDQpGb3Ig
aW5zdGFuY2UsIFRodW5kZXJiaXJkIGludGVybmFsIGtleSBtYW5hZ2VyIGZpbmRzIHlvdXIg
a2V5cyBJRCBhYm92ZSwgDQphcHBhcmVudGx5IHVzaW5nICJ2a3M6Ly9rZXlzLm9wZW5wZ3Au
b3JnLCBoa3BzOi8va2V5cy5tYWlsdmVsb3BlLmNvbSIuDQoNCkhvd2V2ZXIsIGtsZW9wYXRy
YSAoUGxhc21hIGtleSBtYW5hZ2VyKSBkb2Vzbid0ICh1c2luZyANCmhrcDovL2tleXMuZ251
cGcubmV0IG9yIGhrcHM6Ly9oa3BzLnBvb2wuc2tzLWtleXNlcnZlcnMubmV0LCBub3QgY2xl
YXIgDQp3aGljaCkuDQoNCg0KVGhhdCBpcywga2V5cyBhcmUgbm90IHByb3BhZ2F0ZWQgdGhy
b3VnaCBhbGwgdGhlIHNlcnZlcnMgYXMgdGhleSB3ZXJlIGluIA0KdGhlIHBhc3QuDQo+IEFu
ZCBkaXJlY3RseSBmcm9tIHRoZSBrZXJuZWwub3JnJ3MgZGF0YWJhc2U6DQo+IA0KPiBwZ3Br
ZXlzICQgbWFuIGdwIC0td2l0aC1zdWJrZXktZmluZ2VycHJpbnQga2V5cy8xM0Y3MDNFNkMx
MUNGNkYwLmFzYw0KPiBwdWIgICBlZDI1NTE5IDIwMjItMDUtMjcgW0NdDQo+ICAgICAgICA0
MDIwNDU5RTU4QzFBNTI1MTFGNTM5OTExM0Y3MDNFNkMxMUNGNkYwDQo+IHVpZCAgICAgICAg
ICAgICAgICAgICAgICBDYXJsb3MgRWR1YXJkbyBNYWlvbGlubyA8Y2FybG9zQG1haW9saW5v
Lm1lPg0KPiB1aWQgICAgICAgICAgICAgICAgICAgICAgQ2FybG9zIEVkdWFyZG8gTWFpb2xp
bm8gPGNtYWlvbGlub0ByZWRoYXQuY29tPg0KPiB1aWQgICAgICAgICAgICAgICAgICAgICAg
Q2FybG9zIEVkdWFyZG8gTWFpb2xpbm8gPGNlbUBrZXJuZWwub3JnPg0KPiBzdWIgICBlZDI1
NTE5IDIwMjItMDUtMjcgW0FdDQo+ICAgICAgICAzNkM1REZFMUVDQTc5RDFENDQ0RkREOTA0
RTU2MjFBNTY2OTU5NTk5DQo+IHN1YiAgIGVkMjU1MTkgMjAyMi0wNS0yNyBbU10NCj4gICAg
ICAgIEZBNDA2RTIwNkFGRjc4NzM4OTdDNjg2NEI0NTYxOEMzNkEyNEZEMjMgPC0tIE9sZCBr
ZXkgc3RpbGwgdmFsaWQNCj4gc3ViICAgY3YyNTUxOSAyMDIyLTA1LTI3IFtFXQ0KPiAgICAg
ICAgNUFFOThEMDlCMjFBRkJERTYyRUU1NzFFRTAxRTA1RUE4MUIxMEQ1Qw0KPiBzdWIgICBu
aXN0cDM4NCAyMDI0LTAyLTE1IFtBXQ0KPiAgICAgICAgRDNERjFFMzE1REJDQjRFREYzOTJE
NkVEMkJFOEI1MDc2OEM5OUYwMA0KPiBzdWIgICBuaXN0cDM4NCAyMDI0LTAyLTE1IFtTXQ0K
PiAgICAgICAgMEMxRDg5MUM1MEE3MzJFMDY4MEY3QjY0NDY3NUExMTFFNTBCNUZBNiAgPC0t
IE5ldyBrZXkNCj4gc3ViICAgbmlzdHAzODQgMjAyNC0wMi0xNSBbRV0NCj4gICAgICAgIEM3
OTkyMkVFNDVERUEzRjU4Qjk5QjQ3MDEyMDFGNEZBMjM0RUVGRDgNCg0KDQpJbmZvcm1hdGlv
biBvYnRhaW5lZCBvbmNlIEkgY2hhbmdlZCB0aGUga2V5c2VydmVyOg0KDQpjZXJAVGVsY29u
dGFyOn4+IGdwZyAtLWxpc3Qta2V5cyBcDQogICAgNDAyMDQ1OUU1OEMxQTUyNTExRjUzOTkx
MTNGNzAzRTZDMTFDRjZGMA0KcHViICAgZWQyNTUxOSAyMDIyLTA1LTI3IFtDXQ0KICAgICAg
IDQwMjA0NTlFNThDMUE1MjUxMUY1Mzk5MTEzRjcwM0U2QzExQ0Y2RjANCnVpZCAgICAgICAg
ICAgWyAgZnVsbCAgXSBDYXJsb3MgRWR1YXJkbyBNYWlvbGlubyA8Y2FybG9zQG1haW9saW5v
Lm1lPg0KdWlkICAgICAgICAgICBbICBmdWxsICBdIENhcmxvcyBFZHVhcmRvIE1haW9saW5v
IDxjZW1Aa2VybmVsLm9yZz4NCnVpZCAgICAgICAgICAgWyAgZnVsbCAgXSBDYXJsb3MgRWR1
YXJkbyBNYWlvbGlubyA8Y21haW9saW5vQHJlZGhhdC5jb20+DQpzdWIgICBlZDI1NTE5IDIw
MjItMDUtMjcgW0FdDQpzdWIgICBlZDI1NTE5IDIwMjItMDUtMjcgW1NdDQpzdWIgICBuaXN0
cDM4NCAyMDI0LTAyLTE1IFtBXQ0Kc3ViICAgbmlzdHAzODQgMjAyNC0wMi0xNSBbU10NCnN1
YiAgIG5pc3RwMzg0IDIwMjQtMDItMTUgW0VdDQpzdWIgICBjdjI1NTE5IDIwMjItMDUtMjcg
W0VdDQoNCg0KDQotLSANCkNoZWVycyAvIFNhbHVkb3MsDQoNCgkJQ2FybG9zIEUuIFIuDQoJ
CShmcm9tIDE1LjUgeDg2XzY0IGF0IFRlbGNvbnRhcikNCg0K

--------------bRvgGe8rveK92Rv3j1ebAiQH--

--------------1L2yQuKOhE9hcFD5ruOHde02
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wmMEABEIACMWIQQZEb51mJKK1KpcU/W1MxgcbY1H1QUCZiFgIQUDAAAAAAAKCRC1MxgcbY1H1Ron
AJ4t+o1XWrfTHN6fDRPeq1JG+AcLJQCfcwGr1fOGjfo5FzdBETFA+7B6ACw=
=kbIt
-----END PGP SIGNATURE-----

--------------1L2yQuKOhE9hcFD5ruOHde02--
