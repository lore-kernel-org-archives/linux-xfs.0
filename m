Received: from pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.35.192.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56068329E44;
	Wed,  6 May 2026 12:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.35.192.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778070848; cv=none; b=pXakcvbegyx9dQ18ROoBfTHHtzU++VOjicC/jdiHtqYA5DwZ6m9F+LL571Jm/WUTqiEX5bdPmHpE/ToAOb+aksQ4nf69ZgxZmBDiuEaeRfA7c9nOuHxkPsl8Q9kcLNvrE+40fiemPp6Ke9jorw8cXUrNBqh5NsKbDSSC1NcHFTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778070848; c=relaxed/simple;
	bh=h/5kufV2plp3HwPkO+4lStch1YgUSQRacJ+gaSCrLxU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RU7jKOMuJl6L1O245crlS9qQ2eUt6Z9dQo3FjERtKLQore8Y2+uRZQ0Ldy7eac+Lu8QCQ/diS0F0K0jpW4VgSUvN/yvKX+MwiGT+lIb1lE+VPQBRCQv5IzvgwAAw1JMoJ5UJVcFLZLEgXotq4mtXQVweNhfid7+I8hzUkIlBWkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.it; spf=pass smtp.mailfrom=amazon.it; dkim=pass (2048-bit key) header.d=amazon.it header.i=@amazon.it header.b=RjiRr9pf; arc=none smtp.client-ip=52.35.192.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.it header.i=@amazon.it header.b="RjiRr9pf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1778070847; x=1809606847;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=h/5kufV2plp3HwPkO+4lStch1YgUSQRacJ+gaSCrLxU=;
  b=RjiRr9pfdYRbH0ojdV+ZvlnbAmVDlmhD6lVZQ4y0mreQpDjrX/Z5x24p
   GHrZzkW7wNWVJFC+xmlCwcqnCLnJr8U6UBR0YMGoAaJXpzx90wGidgZ1X
   97OuKklta32A43LAVLtqtPtq9xGmIg3uUQ1a2cP3fk9U0W/csBI5639al
   gPZVllQWga51DWU4QXI7Tknb3P5AAoYNm4oMYQdayNuATG+rSOy57vuCW
   KhuezhGMSMM1beA4I03PfBzmFJIft8P+Quvc44uGjFIuxGnbjZNC8iSHW
   C2heKaE41FQkegiRxJTVToZdu5JyAWslnwBPRdBVXg6HtxiQM/YCQ0lb5
   w==;
X-CSE-ConnectionGUID: ddMf54vISQuDF+tIVZgPrg==
X-CSE-MsgGUID: E6X8bLUXT82YBcfM5C04vA==
X-IronPort-AV: E=Sophos;i="6.23,219,1770595200"; 
   d="scan'208";a="18769960"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2026 12:33:55 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:22494]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.20.153:2525] with esmtp (Farcaster)
 id a1329851-5807-47c2-84ec-22c078ca4c8e; Wed, 6 May 2026 12:33:55 +0000 (UTC)
X-Farcaster-Flow-ID: a1329851-5807-47c2-84ec-22c078ca4c8e
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 6 May 2026 12:33:54 +0000
Received: from dev-dsk-dipiets-2b-fa1865ee.us-west-2.amazon.com
 (172.22.139.101) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Wed, 6 May 2026
 12:33:54 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <willy@infradead.org>
CC: <abuehaze@amazon.com>, <akpm@linux-foundation.org>, <alisaidi@amazon.com>,
	<blakgeof@amazon.com>, <brauner@kernel.org>, <dipietro.salvatore@gmail.com>,
	<dipiets@amazon.it>, <djwong@kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-xfs@vger.kernel.org>, <ritesh.list@gmail.com>,
	<stable@vger.kernel.org>, <vbabka@suse.com>
Subject: Re: [PATCH 1/1] iomap: avoid compaction for costly folio order allocation
Date: Wed, 6 May 2026 12:33:18 +0000
Message-ID: <20260506123326.17293-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <afc3xFgKogxF5Lbq@casper.infradead.org>
References: <afc3xFgKogxF5Lbq@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D039UWB001.ant.amazon.com (10.13.138.119) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

Ck9uIDUvMDMvMjYgMDU6NTIsIFJpdGVzaCBIYXJqYW5pIHdyb3RlOgo+IEFsc28gYXMgcGVyIHRo
ZSBkb2N1bWVudGF0aW9uIFsxXSwgaHVnZV9wYWdlcz10cnkgb3B0aW9uIGlzIHRoZSBkZWZhdWx0
Cj4gc2V0dGluZy4gU28gSSBhbSBhc3N1bWluZyBpbiBwcm9kdWN0aW9uIHdlIGF0IGxlYXN0IHdv
bid0IHN1ZmZlciBmcm9tCj4gdGhpcyBtZW1vcnkgZnJhZ21lbnRhdGlvbiwgY29ycmVjdD8KClll
cywgaHVnZV9wYWdlcz10cnkgaXMgdGhlIGRlZmF1bHQgb3B0aW9uLCBidXQgd2l0aG91dCBwcmUt
YWxsb2NhdGluZyB0aGUKZW50aXJlIHNoYXJlZF9idWZmZXIgc2l6ZSBpbiBtZW1vcnkgdmlhICJ2
bS5ucl9odWdlcGFnZXMiIOKAlCB3aGljaCBpcyBub3QKZG9uZSBhdXRvbWF0aWNhbGx5IOKAlCBo
dWdlIHBhZ2VzIHdpbGwgbm90IGJlIHVzZWQgYW5kIHRoZSBzeXN0ZW0gZmFsbHMgaW50bwp0aGUg
aHVnZV9wYWdlcz1vZmYgY2F0ZWdvcnkuIEV2ZW4gd2l0aCBhIHBhcnRpYWwgcHJlLWFsbG9jYXRp
b24sIFBvc3RncmVTUUwKd2lsbCBub3QgYmUgYWJsZSB0byB1c2UgaHVnZXBhZ2VzLgoKCk9uIDUv
MDMvMjYgMTE6NTUsIE1hdHRoZXcgV2lsY294IHdyb3RlOgo+IG9yIHdlIG5lZWQgbW9yZSB1bmRl
cnN0YW5kYWJsZSBHRlAgZmxhZ3MuICBPciB0aGUgcGFnZSBhbGxvY2F0b3IgY291bGQKPiB1c2Ug
dGhlIF9fR0ZQX05PUkVUUlkgZmxhZyB0byBzYXkgIm9oIHdlbGwsIHRoaXMgYWxsb2NhdGlvbiBo
YXMgYSBmYWxsYmFjaywKPiBJJ2xsIGtpY2sga2NvbXBhY3RkIHRvIHRyeSB0byBjb21wYWN0IHNv
bWUgbW9yZSBtZW1vcnksIGJ1dCBJJ2xsIGZhaWwKPiB0aGUgYWxsb2NhdGlvbiIuCgpXZSBhbHNv
IHRlc3RlZCBraWNraW5nIG9mZiBrY29tcGFjdGQgaW4gdGhlIGJhY2tncm91bmQgd2hlbiBfX0dG
UF9OT1JFVFJZIGlzCnBhc3NlZCwgcmV0dXJuaW5nICJub3BhZ2UiIHRvIGF2b2lkIGJsb2NraW5n
IHRoZSBmb2xpbyBhbGxvY2F0aW9uIHJlcXVlc3QuIApIZXJlIGlzIHRoZSBwYXRjaCB0ZXN0ZWQg
YXMgdGhlIG90aGVyIHdpdGggUFJFRU1QVF9OT05FIHBhdGNoIFsxXToKCgpkaWZmIC0tZ2l0IGEv
bW0vcGFnZV9hbGxvYy5jIGIvbW0vcGFnZV9hbGxvYy5jCmluZGV4IDY1ZTIwNTExMTU1My4uZDRm
MzIyOTEwOTkyIDEwMDY0NAotLS0gYS9tbS9wYWdlX2FsbG9jLmMKKysrIGIvbW0vcGFnZV9hbGxv
Yy5jCkBAIC00ODE4LDYgKzQ4MTgsMjYgQEAgX19hbGxvY19wYWdlc19zbG93cGF0aChnZnBfdCBn
ZnBfbWFzaywgdW5zaWduZWQgaW50IG9yZGVyLAogCWlmIChjdXJyZW50LT5mbGFncyAmIFBGX01F
TUFMTE9DKQogCQlnb3RvIG5vcGFnZTsKIAorCS8qCisJICogQ29zdGx5IGFsbG9jYXRpb25zIHdp
dGggX19HRlBfTk9SRVRSWSBhcmUgb3Bwb3J0dW5pc3RpYyAtIERvbid0CisJICogc3RhbGwgb24g
ZGlyZWN0IGNvbXBhY3Rpb24gb3IgcmVjbGFpbTsgaW5zdGVhZCwga2ljaworCSAqIGtjb21wYWN0
ZCBvbiB0aGUgcHJlZmVycmVkIG5vZGUgc28gbGFyZ2UgcGFnZXMgbWF5IGJlY29tZQorCSAqIGF2
YWlsYWJsZSBmb3IgZnV0dXJlIGFsbG9jYXRpb25zIGFuZCBsZXQgdGhlIGNhbGxlciBmYWxsIGJh
Y2sgbm93LgorCSAqCisJICogRGlyZWN0IGNvbXBhY3Rpb24gaXMgd2F5IHRvbyBjb3N0bHkgZm9y
IGhvdCBhbGxvY2F0aW9uIHBhdGhzIG9uCisJICogbGFyZ2Ugc3lzdGVtczogZWFjaCBhdHRlbXB0
IGNhbGxzIGRyYWluX2FsbF9wYWdlcygpIHdoaWNoIElQSXMKKwkgKiBldmVyeSBDUFUuICBPbmx5
IHdha2Uga2NvbXBhY3RkIG9uIHRoZSBsb2NhbCBub2RlIHRvIGF2b2lkCisJICogY3Jvc3MtTlVN
QSBpbnRlcmZlcmVuY2Ugd2l0aCB1bnJlbGF0ZWQgd29ya2xvYWRzLgorCSAqLworCWlmIChjb3N0
bHlfb3JkZXIgJiYgKGdmcF9tYXNrICYgX19HRlBfTk9SRVRSWSkpIHsKKwkJc3RydWN0IHpvbmUg
KnByZWZlcnJlZF96b25lID0gYWMtPnByZWZlcnJlZF96b25lcmVmLT56b25lOworCisJCWlmIChw
cmVmZXJyZWRfem9uZSkKKwkJCXdha2V1cF9rY29tcGFjdGQocHJlZmVycmVkX3pvbmUtPnpvbmVf
cGdkYXQsIG9yZGVyLAorCQkJCQkgYWMtPmhpZ2hlc3Rfem9uZWlkeCk7CisJCWdvdG8gbm9wYWdl
OworCX0KKwogCS8qIFRyeSBkaXJlY3QgcmVjbGFpbSBhbmQgdGhlbiBhbGxvY2F0aW5nICovCiAJ
aWYgKCFjb21wYWN0X2ZpcnN0KSB7CiAJCXBhZ2UgPSBfX2FsbG9jX3BhZ2VzX2RpcmVjdF9yZWNs
YWltKGdmcF9tYXNrLCBvcmRlciwgYWxsb2NfZmxhZ3MsCgoKCkhlcmUgYXJlIHRoZSByZXN1bHRz
IHdlIGNvbGxlY3RlZCAoa2NvbXBhY3RkIGJhY2tncm91bmQpOgoKfCBQYXRjaCAgICAgICAgICAg
ICAgICB8ICAgIFJ1biAxICAgfCAgICBSdW4gMiAgIHwgICAgUnVuIDMgICB8ICAgQXZlcmFnZSAg
IHwgJSB2cyBCYXNlbGluZSB8CnwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tfC0tLS0tLS0tLS0tOnwt
LS0tLS0tLS0tLTp8LS0tLS0tLS0tLS06fC0tLS0tLS0tLS0tLTp8Oi0tLS0tLS0tLS0tLS06fAp8
IEJhc2VsaW5lICAgICAgICAgICAgIHwgMTA3LDA2NC42MSB8ICA5NywwNDMuODYgfCAxMDEsODMw
Ljc4IHwgMTAxLDk3OS43NSAgfCAgICAgICDigJQgICAgICAgfAp8IFByb3Bvc2VkIHBhdGNoICAg
ICAgIHwgMTQ2LDAxMi4yMyB8IDEzNiwzOTIuMzYgfCAxNDEsMTc4LjAwIHwgMTQxLDE5NC4yMCAg
fCAgICArMzguNDUlICAgIHwKfCBSaXRlc2gncyBzdWdnZXN0aW9uICB8IDE0Nyw0ODEuNTAgfCAx
MzMsMDY5LjAzIHwgMTM3LDA1MS4zMCB8IDEzOSwyMDAuNjEgIHwgICAgKzM2LjUwJSAgICB8Cnwg
TWF0dGhldydzIHN1Z2dlc3Rpb24gfCAxNDUsNjUzLjkxIHwgMTQ0LDE2OS4yNCB8IDE0MSw3Njgu
MzEgfCAxNDMsODYzLjgyICB8ICAgICs0MS4wNyUgICAgfAp8IGtjb21wYWN0ZCBiYWNrZ3JvdW5k
IHwgMTQ2LDc2MC43NSB8IDEyOCwwOTQuOTIgfCAxMjcsOTc5Ljc0IHwgMTM0LDI3OC40NyAgfCAg
ICArMzEuNjclICAgIHwKCiAgClsxXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyNjA0
MDMxOTE5NDIuMjE0MTAtMS1kaXBpZXRzQGFtYXpvbi5pdC9ULyNtOGJhZWVhZjQ4YWE3YWU1MzQy
YzhjMmRiOGY0ZTFjMjdlMDNjMTM2OAoKCgoKCkFNQVpPTiBERVZFTE9QTUVOVCBDRU5URVIgSVRB
TFkgU1JMLCB2aWFsZSBNb250ZSBHcmFwcGEgMy81LCAyMDEyNCBNaWxhbm8sIEl0YWxpYSwgUmVn
aXN0cm8gZGVsbGUgSW1wcmVzZSBkaSBNaWxhbm8gTW9uemEgQnJpYW56YSBMb2RpIFJFQSBuLiAy
NTA0ODU5LCBDYXBpdGFsZSBTb2NpYWxlOiAxMC4wMDAgRVVSIGkudi4sIENvZC4gRmlzYy4gZSBQ
LklWQSAxMDEwMDA1MDk2MSwgU29jaWV0YSBjb24gU29jaW8gVW5pY28KCgo=

