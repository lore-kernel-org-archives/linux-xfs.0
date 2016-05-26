Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 919BD7CA0
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 06:34:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2B9CB304053
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 04:34:25 -0700 (PDT)
Received: from mail1.g1.pair.com (mail1.g1.pair.com [66.39.3.162]) by
	cuda.sgi.com with ESMTP id n2QRXdges8P98K5z (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 26 May 2016 04:34:22 -0700 (PDT)
Date: Thu, 26 May 2016 13:34:22 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: LVM snapshot and log record CRC mismatch
Message-ID: <20160526133422.32f65920@harpe.intellique.com>
In-Reply-To: <5746DB30.5040006@assyoma.it>
References: <ab81e19cd6fce41f9d63cdd3695c80f7@assyoma.it>
	<20160524221205.GM21200@dastard> <57455645.5040608@assyoma.it>
	<20160526122315.4112f713@harpe.intellique.com>
	<5746DB30.5040006@assyoma.it>
MIME-Version: 1.0
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
To: Gionatan Danti <g.danti@assyoma.it>
Cc: xfs@oss.sgi.com

TGUgVGh1LCAyNiBNYXkgMjAxNiAxMzoxNzowNCArMDIwMApHaW9uYXRhbiBEYW50aSA8Zy5kYW50
aUBhc3N5b21hLml0PiDDqWNyaXZhaXQ6Cgo+ID4KPiA+IFlvdSBuZWVkIHRvIHVzZSB4ZnNfZnJl
ZXplIHRvIG1ha2UgdGhlIGZpbGVzeXN0ZW0gY29oZXJlbnQgYmVmb3JlCj4gPiBzbmFwc2hvdDoK
PiA+Cj4gPiB4ZnNfZnJlZXplIC9kZXYvaHlwZXJ2aXNvci9LVk1fU3RvcmFnZQo+ID4gbHZjcmVh
dGUgLXMgaHlwZXJ2aXNvci9LVk1fU3RvcmFnZSAtLW5hbWUgQmFja3VwX1NOQVAKPiA+IHhmc19m
cmVlemUgLXUgL2Rldi9oeXBlcnZpc29yL0tWTV9TdG9yYWdlCj4gPiBsdmNoYW5nZSAtYXkgLUsg
aHlwZXJ2aXNvci9CYWNrdXBfU05BUAo+ID4gIAo+IAo+IEl0IHdhcyBteSB1bmRlcnN0YW5kaW5n
IHRoYXQgZmlsZXN5c3RlbSBmcmVlemluZyB3YXMgYXV0b21hdGljYWxseSAKPiBtYW5hZ2VkIGJ5
IExWTSwgYW5kIGludGVncmF0ZWQgaW50byBWRlMgbG9uZyBhZ28uCj4gCj4gSSBhbSBtaXNzaW5n
IHNvbWV0aGluZz8KClllcywgSSB0aG91Z2h0IHRoYXQgdG9vLCBob3dldmVyIGl0IGRvZXNuJ3Qg
c2VlbSB0byBiZSB3b3JraW5nIGluIHlvdXIKY2FzZSwgYW5kIGZyZWV6aW5nIHR3aWNlIGNhbid0
IGRvIGFueSBoYXJtIGFueXdheSA6KQoKLS0gCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpFbW1hbnVlbCBGbG9y
YWMgICAgIHwgICBEaXJlY3Rpb24gdGVjaG5pcXVlCiAgICAgICAgICAgICAgICAgICAgfCAgIElu
dGVsbGlxdWUKICAgICAgICAgICAgICAgICAgICB8CTxlZmxvcmFjQGludGVsbGlxdWUuY29tPgog
ICAgICAgICAgICAgICAgICAgIHwgICArMzMgMSA3OCA5NCA4NCAwMgotLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0K
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWls
aW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3Rp
bmZvL3hmcwo=
