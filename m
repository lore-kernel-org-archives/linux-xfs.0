Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751D119D07E
	for <linux-xfs@vger.kernel.org>; Tue, 14 Oct 2025 06:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760424755; cv=none; b=QhixhHhKfot/qGS3zhURgeinJGJgeu1Fs1dNtnjCub9Nlob2P4WGgg1YW+1TWbSmr+jtmhE6yyVxRBPZwSaYD4CUeCD7z/UBqvzJeCZW3L2SRAuVGvIsM5sFRfFnAroT+k0gsgRWJ3zPm080+D3aLlZPTLiRLv2bbNxW5xcVgzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760424755; c=relaxed/simple;
	bh=sWqEGfv4BK8jmc85U91i5eOlcf9fhX4hMKzekCqqel0=;
	h=Content-Type:Message-ID:Date:MIME-Version:From:Subject:To; b=vFx0LjsrmII1jjwIQSaKDTioRebkFG/bi/XGHbhB+eTXalL6Iq2swlZPKDXT8xkTWlWJf6oGrdUByyDnIOXamF9eMa7j9MJn++9PzkJThLNq8F5K7tfE5N5h3SU2s3wtixalAlSuuO+wdbwSva9KLst7ZVBpKO9ilTwHq5ZsNqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net; spf=pass smtp.mailfrom=gmx.net; dkim=pass (2048-bit key) header.d=gmx.net header.i=torsten.rupp@gmx.net header.b=GYHg1wa9; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.net header.i=torsten.rupp@gmx.net header.b="GYHg1wa9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.net;
	s=s31663417; t=1760424750; x=1761029550; i=torsten.rupp@gmx.net;
	bh=sWqEGfv4BK8jmc85U91i5eOlcf9fhX4hMKzekCqqel0=;
	h=X-UI-Sender-Class:Content-Type:Message-ID:Date:MIME-Version:From:
	 Subject:To:cc:content-transfer-encoding:content-type:date:from:
	 message-id:mime-version:reply-to:subject:to;
	b=GYHg1wa9x9rirjLbw0QsqJtBTi3Pi6pUXpMbQtnnvcy2F9EkBV/WNYtsAf1oxbUi
	 4BgsNB+atAp6ZDQKn3q0zknkM7Q58BigNWJwyvYeXXT0wvvsLclp6x17bq4uc3HYr
	 LV2JXylf8nlEMsgKLO8pv4f+32FhLpA6ZBKVnVp9sfxlqhUzTdXzz7hrJtY92O2TD
	 mo9QFigxH97SoArRDMtmcfCiY/ZLuuR6qjCrjli2YsoV9rMlKxdKXL6IiF+BbffWp
	 ytURgDYE7grH4o32x6TTUpPiIAhLeGYEbxPJKG79APi+7ibUm1l6shWwHEB/T2DP3
	 8dzFMUoBlbTeYxHEAg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.22.10] ([2.241.34.66]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N1Obh-1u6o3J1kHT-016CV9 for
 <linux-xfs@vger.kernel.org>; Tue, 14 Oct 2025 08:52:30 +0200
Content-Type: multipart/mixed; boundary="------------4FF0I0TcWnxxETMMBw02YN4A"
Message-ID: <f45c9b48-eb0d-4314-aeb0-6b5e75c54a8e@gmx.net>
Date: Tue, 14 Oct 2025 08:51:12 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Torsten Rupp <torsten.rupp@gmx.net>
Subject: Double alloc/free of cache item
To: linux-xfs@vger.kernel.org
Content-Language: de-DE
Autocrypt: addr=torsten.rupp@gmx.net; keydata=
 xsDiBEO+wNARBAC9bu5L3kkV9iIY94Eihu5wccSTZ8p49M9FnJtgPu6rUvD+szor8e0yyreD
 TiBgf5ZRpWvNZ2zFdpj1+fwKNz/GTZJ7N88F9XfhuvPixFxK7GqfKzgPZT1gQ8FRimUF9eVj
 giELFdTVsAa0ipiAmYZLLZoAF6baJR3plcaE88GEzwCgpH+yfxAQx94gVLM1kDncbPTuUwcD
 /2uoevvNqQWyaoEbczevNDAyZtqj5rc0QmViopJX0mgQCMaDH2W1suVoBA+/jMWDOqsl/Aw+
 34Q/n45LXBsLglV0oKj3lT/UzT5yH3Yp9G1fnRMgKT2EH7d21CYmHKfGUKWmbmYJL9U3bknF
 XwcRwKpj6V8G0+JVODuolsWx6YQwBAC3ovtun+ZlbFeL58/M5qG/uKEejS69cUvpDHUjSNqZ
 yEO0fF7xxFKvX04KWyzUfzV44v1V3o3LYGU78FwMU0pdD8+XHvtDo3w6/POtvEU0H61QuDBC
 NnSJXoQe48dAi9K64HF6T7JYAuOBiEV30LXnTyYto0Op8DB4Z/XF5vJ9t80jVG9yc3RlbiBS
 dXBwIDx0b3JzdGVuLnJ1cHBAZ214Lm5ldD7CWwQTEQIAGwUCQ77A0AYLCQgHAwIDFQIDAxYC
 AQIeAQIXgAAKCRDWdxCwuabC6WlwAJ94+eEN8Gm59F4gZjmvzGUgPqtBRgCdEYK76JO/Dg2b
 SZXqtTqhHt2TAQDOwU0EQ77A6hAIANtZKko/D0jj707/6IqdhFLTBGmD3R6q+aWbciJlVmpX
 I3qXtvUWBaGVegAPUmxecJyIgOfSthWA2KA2KYfkJnmhCEMSbFccqKU/t0qpWbyR9G8tayWb
 W7dFhLrahneln0879jYPmg1+b1SoECCJdx1iUXktXB9WxpSztEmamkZy10S6EGt17HQRFQof
 ysk+8vfhYEv6CIUMQjpjrKEl5hQgdl61aXOYKJdJKgdJbs0XxvVDQ4IuoJrMOb7zKRswKsH+
 0tnzInx5tqvTbLeHlUZqKKTdMdURWQhNw8il+uc4CoqhbUx5Bny3UYVZMX5SU6Ulm0WJzFUU
 tKVX4FiLVOcAAwUH/iP6G63zA03VqweGUZKGgNkscrV9jaDJU1dQrZBkxWSyoBwxHq16lpGL
 XT9ieCevXkT8IqZ/7rXmpBEmI3HrQxN2muRVNV+Pt7CJ0t5317WZfC/YnQGEBGHI/n0gn0Cn
 icClYEciJow9zD5XF4auk48T8aD2qWxcHksON9L0enz8Ku/rz/pio/PSODTDwMtTJcq0Bjn2
 bboCGMDAlZPMfMNulusQFqnXhJI8L8AxZjmX9Xq+wi5TdpZYkQlTCzj+pLizvLWKBC+7OC04
 67YUiT1MekENsWUcdCOVwh4Gq6soCgOu3QHz3jez4R82KxuPbYEbMMGvcwQaMsxYbo2RoY3C
 RgQYEQIABgUCQ77A6gAKCRDWdxCwuabC6UbDAJ9RcXpuMPKWxGVOV8zDpiwV6v26GgCdFU22
 bk1TC0UY69vY5e/YkBX12pM=
X-Provags-ID: V03:K1:BubF3qHo9zMVhsJ0LOzIbpGIJk11CSvwq6/KQRxJpVMMpuQ2lnY
 gSi1mYoctousi55biPRtyxLBHcJMt5rbU6Qt3LuSc+e5srZ4iXtZxAQ66+LZD/zRGijtxq7
 cSJHSMIlxpgvZ9HYJ3Jnl8vU6nSbeJwLNih6xP8GBk6J5WGVPGBEvFESVwM18HeS8U7/Kg+
 fMk9DJ/KBEyc3SDIBOX+A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:uj25jkGFi3E=;oCi73uTYPgVXdZ7rk8f4yEaUmFL
 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
 WLLWiOntSTIeJq0MIb0ACoV75NxyYSti180=

This is a multi-part message in MIME format.
--------------4FF0I0TcWnxxETMMBw02YN4A
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

Dear XFS developers,

there is a double alloc/free of the cache item "xfs_extfree_item_cache"=20
in xfsprogs 6.16.0. If the environment variable LIBXFS_LEAK_CHECK is set=
=20
this also cause a segmenation fault due to a NULL pointer access (the=20
cache item is already freed). Please find attached a patch which fix=20
this issue.

I discussed this issue and the fix already with Darrick.

Thank you for your work on xfsprogs!

Best regards,

Torsten

--------------4FF0I0TcWnxxETMMBw02YN4A
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-Fix-alloc-free-of-cache-item.patch"
Content-Disposition: attachment;
 filename="0001-Fix-alloc-free-of-cache-item.patch"
Content-Transfer-Encoding: base64

RnJvbSA0YzY2OWZkMWRiNzk1NjRkOGI1MjQwYzc0NjRkZDI4ZjNiYzI3YmIxIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBUb3JzdGVuIFJ1cHAgPHRvcnN0ZW4ucnVwcEBnbXgu
bmV0PgpEYXRlOiBTdW4sIDEyIE9jdCAyMDI1IDA5OjIzOjU4ICswMjAwClN1YmplY3Q6IFtQ
QVRDSCAxLzFdIEZpeCBhbGxvYy9mcmVlIG9mIGNhY2hlIGl0ZW0KCnhmc19leHRmcmVlX2l0
ZW1fY2FjaGUgaXMgYWxsb2NhdGVkIGFuZCBmcmVlZCB0d2ljZS4gUmVtb3ZlIHRoZQpvYnNv
bGV0ZSBhbGxvYy9mcmVlLgoKU2lnbmVkLW9mZi1ieTogVG9yc3RlbiBSdXBwIDx0b3JzdGVu
LnJ1cHBAZ214Lm5ldD4KLS0tCiBsaWJ4ZnMvaW5pdC5jIHwgNCAtLS0tCiAxIGZpbGUgY2hh
bmdlZCwgNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9saWJ4ZnMvaW5pdC5jIGIvbGli
eGZzL2luaXQuYwppbmRleCAzOTNhOTQ2Ny4uYTVlODk4NTMgMTAwNjQ0Ci0tLSBhL2xpYnhm
cy9pbml0LmMKKysrIGIvbGlieGZzL2luaXQuYwpAQCAtMjE0LDkgKzIxNCw2IEBAIGluaXRf
Y2FjaGVzKHZvaWQpCiAJCWZwcmludGYoc3RkZXJyLCAiQ291bGQgbm90IGFsbG9jYXRlIGJ0
cmVlIGN1cnNvciBjYWNoZXMuXG4iKTsKIAkJYWJvcnQoKTsKIAl9Ci0JeGZzX2V4dGZyZWVf
aXRlbV9jYWNoZSA9IGttZW1fY2FjaGVfaW5pdCgKLQkJCXNpemVvZihzdHJ1Y3QgeGZzX2V4
dGVudF9mcmVlX2l0ZW0pLAotCQkJInhmc19leHRmcmVlX2l0ZW0iKTsKIAl4ZnNfdHJhbnNf
Y2FjaGUgPSBrbWVtX2NhY2hlX2luaXQoCiAJCQlzaXplb2Yoc3RydWN0IHhmc190cmFucyks
ICJ4ZnNfdHJhbnMiKTsKIAl4ZnNfcGFyZW50X2FyZ3NfY2FjaGUgPSBrbWVtX2NhY2hlX2lu
aXQoCkBAIC0yMzYsNyArMjMzLDYgQEAgZGVzdHJveV9jYWNoZXModm9pZCkKIAlsZWFrZWQg
Kz0ga21lbV9jYWNoZV9kZXN0cm95KHhmc19kYV9zdGF0ZV9jYWNoZSk7CiAJeGZzX2RlZmVy
X2Rlc3Ryb3lfaXRlbV9jYWNoZXMoKTsKIAl4ZnNfYnRyZWVfZGVzdHJveV9jdXJfY2FjaGVz
KCk7Ci0JbGVha2VkICs9IGttZW1fY2FjaGVfZGVzdHJveSh4ZnNfZXh0ZnJlZV9pdGVtX2Nh
Y2hlKTsKIAlsZWFrZWQgKz0ga21lbV9jYWNoZV9kZXN0cm95KHhmc190cmFuc19jYWNoZSk7
CiAJbGVha2VkICs9IGttZW1fY2FjaGVfZGVzdHJveSh4ZnNfcGFyZW50X2FyZ3NfY2FjaGUp
OwogCi0tIAoyLjQzLjAKCg==

--------------4FF0I0TcWnxxETMMBw02YN4A--
