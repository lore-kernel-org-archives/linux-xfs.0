Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 082C07CA0
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 12:39:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CF670304053
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 10:39:37 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id vD6j1rV9spGlXORH for <xfs@oss.sgi.com>;
	Thu, 26 May 2016 10:39:33 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 6901D4A6
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 12:39:33 -0500 (CDT)
Subject: Re: LVM snapshot and log record CRC mismatch
References: <ab81e19cd6fce41f9d63cdd3695c80f7@assyoma.it>
	<20160524221205.GM21200@dastard> <57455645.5040608@assyoma.it>
	<20160526122315.4112f713@harpe.intellique.com>
	<5746DB30.5040006@assyoma.it>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <3d43eb60-ad03-ca17-051f-aef2cf91f2f3@sandeen.net>
Date: Thu, 26 May 2016 12:39:32 -0500
MIME-Version: 1.0
In-Reply-To: <5746DB30.5040006@assyoma.it>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

CgpPbiA1LzI2LzE2IDY6MTcgQU0sIEdpb25hdGFuIERhbnRpIHdyb3RlOgo+IE9uIDI2LzA1LzIw
MTYgMTI6MjMsIEVtbWFudWVsIEZsb3JhYyB3cm90ZToKPj4gTGUgV2VkLCAyNSBNYXkgMjAxNiAw
OTozNzo0MSArMDIwMAo+PiBHaW9uYXRhbiBEYW50aSA8Zy5kYW50aUBhc3N5b21hLml0PiDDqWNy
aXZhaXQ6Cj4+Cj4+PiBUaGUgc25hcHNob3QgaXMgYWNjb21wbGlzaGVkIHVzaW5nIHRoZSBmb2xs
b3dpbmcgY29tbWFuZHM6Cj4+Pgo+Pj4gbHZjcmVhdGUgLXMgaHlwZXJ2aXNvci9LVk1fU3RvcmFn
ZSAtLW5hbWUgQmFja3VwX1NOQVAKPj4+IGx2Y2hhbmdlIC1heSAtSyBoeXBlcnZpc29yL0JhY2t1
cF9TTkFQCj4+PiBtb3VudCAtbyBub3V1aWQgL2Rldi9oeXBlcnZpc29yL0JhY2t1cF9TTkFQIC9t
bnQvbHZtLwo+Pj4KPj4KPj4gWW91IG5lZWQgdG8gdXNlIHhmc19mcmVlemUgdG8gbWFrZSB0aGUg
ZmlsZXN5c3RlbSBjb2hlcmVudCBiZWZvcmUKPj4gc25hcHNob3Q6Cj4+Cj4+IHhmc19mcmVlemUg
L2Rldi9oeXBlcnZpc29yL0tWTV9TdG9yYWdlCj4+IGx2Y3JlYXRlIC1zIGh5cGVydmlzb3IvS1ZN
X1N0b3JhZ2UgLS1uYW1lIEJhY2t1cF9TTkFQCj4+IHhmc19mcmVlemUgLXUgL2Rldi9oeXBlcnZp
c29yL0tWTV9TdG9yYWdlCj4+IGx2Y2hhbmdlIC1heSAtSyBoeXBlcnZpc29yL0JhY2t1cF9TTkFQ
Cj4+Cj4gCj4gSXQgd2FzIG15IHVuZGVyc3RhbmRpbmcgdGhhdCBmaWxlc3lzdGVtIGZyZWV6aW5n
IHdhcyBhdXRvbWF0aWNhbGx5IG1hbmFnZWQgYnkgTFZNLCBhbmQgaW50ZWdyYXRlZCBpbnRvIFZG
UyBsb25nIGFnby4KPiAKPiBJIGFtIG1pc3Npbmcgc29tZXRoaW5nPwoKTm9wZSwgeW91IGFyZSBj
b3JyZWN0LiAgbHZtIHNuYXBzaG90cyBoYW5kbGUgZnMgcXVpZXNjZS4KCi1FcmljCgpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0
Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
