Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 692CF7CA6
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 11:33:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DC712AC007
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 09:33:25 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id lFlg7ykOLcNkqvTf for <xfs@oss.sgi.com>;
	Wed, 11 May 2016 09:33:23 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id B9643873
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 11:33:23 -0500 (CDT)
Subject: Re: [PATCH] xfs: remove unused variable warning in
	xfs_finish_page_writeback
References: <1462983266-15235-1-git-send-email-cmaiolino@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <17ff69fb-360c-8c44-9431-564dcd54aef9@sandeen.net>
Date: Wed, 11 May 2016 11:33:21 -0500
MIME-Version: 1.0
In-Reply-To: <1462983266-15235-1-git-send-email-cmaiolino@redhat.com>
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

CgpPbiA1LzExLzE2IDExOjE0IEFNLCBDYXJsb3MgTWFpb2xpbm8gd3JvdGU6Cj4gRnJvbTogQ2Fy
bG9zIE1haW9saW5vIDxjbWFpb2xpbm9AcmVkaGF0LmNvbT4KPiAKPiBEdWUgdGhlIGluaXRpYWxp
emF0aW9uIG9mIGJsb2NrbWFzayB2YXJpYWJsZSB3aXRoIGl0cyBkZWZpbml0aW9uLCBnY2MgaXNz
dWVzIHRoZQo+IGZvbGxvd2luZyB3YXJuaW5nIGR1ZSBhbiB1bnVzZWQgdmFyaWFibGUgZHVyaW5n
IGNvbXBpbGF0aW9uIHRpbWUuCj4gCj4gZnMveGZzLy94ZnNfYW9wcy5jOiBJbiBmdW5jdGlvbiDi
gJh4ZnNfZmluaXNoX3BhZ2Vfd3JpdGViYWNr4oCZOgo+IGZzL3hmcy8veGZzX2FvcHMuYzo5Nzox
NTogd2FybmluZzogdW51c2VkIHZhcmlhYmxlIOKAmGJsb2NrbWFza+KAmQo+IFstV3VudXNlZC12
YXJpYWJsZV0KPiAgIHVuc2lnbmVkIGludCAgYmxvY2ttYXNrID0gKDEgPDwgaW5vZGUtPmlfYmxr
Yml0cykgLSAxOwo+ICAgICAgICAgICAgICAgIF4KPiBSZW1vdmUgdGhpcyB3YXJuaW5nIGJ5IGlu
aXRpYWxpemluZyB0aGUgdmFyaWFibGUgYWZ0ZXIgaXRzIGRlZmluaXRpb24uCj4gCj4gVGhpcyBj
aGFuZ2UgY2F1c2VzIG5vIGRpZmZlcmVuY2UgaW4gdGhlIGdlbmVyYXRlZCBhc3NlbWJseSBjb2Rl
CgpPaCwgSSBzZWUuICBJdCdzIHVudXNlZCBvbiBub24tZGVidWcgYnVpbGRzIGJlY2F1c2UgaXQn
cyBvbmx5IHVzZWQKdW5kZXIgQVNTRVJULgoKT2ssIHRoYXQncyBhIGdvb2Qgd2F5IHRvIGZpeCBp
dCwgYWx0aG91Z2ggdGhlcmUgYXJlIHNvbWUgc2Nhbm5lcnMKb3V0IHRoZXJlIChjbGFuZz8gIHNv
bWUgZ2NjPyAgSSBkb24ndCByZWNhbGwpIHdoaWNoIHdpbGwgYWxzbyBmbGFnCndyaXRlLW9ubHkg
dmFyaWFibGVzLiAgSXQnZCBiZSB1Z2x5IGJ1dCBzb21ldGltZXMgSSB3b25kZXIgaWYgYW4KQVNT
RVJUX0RFQ0woKSBtYWNybyB3b3VsZCBtYWtlIHNvbWUgc2Vuc2UuCgpPciBhIE1BU0soKSBtYWNy
byBzbyB3ZSBjb3VsZCBqdXN0IGRvOgoKI2RlZmluZSBNQVNLKG5iaXRzKSAoKDFVTCA8PCAobmJp
dHMpKSAtIDEpIC8qIG1hc2sgd2l0aCBOQklUUyBiaXRzIHNldCAqLwoKQVNTRVJUKChidmVjLT5i
dl9vZmZzZXQgJiBNQVNLKGlub2RlLT5pX2Jsa2JpdHMpKSA9PSAwKTsKCkJ1dCBmb3Igbm93LCB0
aGlzIGlzIGJldHRlciwgYW5kIGZpeGVzIHdoYXQgbW9zdCBwZW9wbGUgd2lsbCBzZWUsCnNvIGZp
bmUgYnkgbWU6CgpSZXZpZXdlZC1ieTogRXJpYyBTYW5kZWVuIDxzYW5kZWVuQHJlZGhhdC5jb20+
Cgo+IFNpZ25lZC1vZmYtYnk6IENhcmxvcyBNYWlvbGlubyA8Y21haW9saW5vQHJlZGhhdC5jb20+
Cj4gLS0tCj4gIGZzL3hmcy94ZnNfYW9wcy5jIHwgMyArKy0KPiAgMSBmaWxlIGNoYW5nZWQsIDIg
aW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQo+IAo+IGRpZmYgLS1naXQgYS9mcy94ZnMveGZz
X2FvcHMuYyBiL2ZzL3hmcy94ZnNfYW9wcy5jCj4gaW5kZXggNDA2NDVhNC4uZjRlMmQzYiAxMDA2
NDQKPiAtLS0gYS9mcy94ZnMveGZzX2FvcHMuYwo+ICsrKyBiL2ZzL3hmcy94ZnNfYW9wcy5jCj4g
QEAgLTk0LDExICs5NCwxMiBAQCB4ZnNfZmluaXNoX3BhZ2Vfd3JpdGViYWNrKAo+ICAJc3RydWN0
IGJpb192ZWMJCSpidmVjLAo+ICAJaW50CQkJZXJyb3IpCj4gIHsKPiAtCXVuc2lnbmVkIGludAkJ
YmxvY2ttYXNrID0gKDEgPDwgaW5vZGUtPmlfYmxrYml0cykgLSAxOwo+ICsJdW5zaWduZWQgaW50
CQlibG9ja21hc2s7Cj4gIAl1bnNpZ25lZCBpbnQJCWVuZCA9IGJ2ZWMtPmJ2X29mZnNldCArIGJ2
ZWMtPmJ2X2xlbiAtIDE7Cj4gIAlzdHJ1Y3QgYnVmZmVyX2hlYWQJKmhlYWQsICpiaDsKPiAgCXVu
c2lnbmVkIGludAkJb2ZmID0gMDsKPiAgCj4gKwlibG9ja21hc2sgPSAoMSA8PCBpbm9kZS0+aV9i
bGtiaXRzKSAtIDE7Cj4gIAlBU1NFUlQoYnZlYy0+YnZfb2Zmc2V0IDwgUEFHRV9TSVpFKTsKPiAg
CUFTU0VSVCgoYnZlYy0+YnZfb2Zmc2V0ICYgYmxvY2ttYXNrKSA9PSAwKTsKPiAgCUFTU0VSVChl
bmQgPCBQQUdFX1NJWkUpOwo+IAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5z
Z2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
