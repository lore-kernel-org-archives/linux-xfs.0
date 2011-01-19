Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0J4TJjZ179277 for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 22:29:19 -0600
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A8D8519E531D
	for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 20:31:36 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	dW6HQpCAY1gTxLWI for <xfs@oss.sgi.com>;
	Tue, 18 Jan 2011 20:31:36 -0800 (PST)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PfPhm-0007Es-I7
	for xfs@oss.sgi.com; Wed, 19 Jan 2011 15:31:34 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PfPgJ-000453-Ah
	for xfs@oss.sgi.com; Wed, 19 Jan 2011 15:30:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/5] xfs: limit extsize to size of AGs and/or MAXEXTLEN
Date: Wed, 19 Jan 2011 15:29:59 +1100
Message-Id: <1295411400-15614-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1295411400-15614-1-git-send-email-david@fromorbit.com>
References: <1295411400-15614-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

RnJvbTogRGF2ZSBDaGlubmVyIDxkY2hpbm5lckByZWRoYXQuY29tPgoKVGhlIGV4dGVudCBzaXpl
IGhpbnQgY2FuIGJlIHNldCB0byBsYXJnZXIgdGhhbiBhbiBBRy4gVGhpcyBtZWFucwp0aGF0IHRo
ZSBhbGlnbm1lbnQgcHJvY2VzcyBjYW4gcHVzaCB0aGUgcmFuZ2UgdG8gYmUgYWxsb2NhdGVkCm91
dHNpZGUgdGhlIGJvdW5kcyBvZiB0aGUgQUcsIHJlc3VsdGluZyBpbiBhc3NlcnQgZmFpbHVyZXMg
b3IKY29ycnVwdGVkIGJtYnQgcmVjb3Jkcy4gU2ltaWxhcmx5LCBpZiB0aGUgZXh0c2l6ZSBpcyBs
YXJnZXIgdGhhbiB0aGUKbWF4aW11bSBleHRlbnQgc2l6ZSBzdXBwb3J0ZWQsIHRoZSBhbGlnbm1l
bnQgcHJvY2VzcyB3aWxsIHByb2R1Y2UKZXh0ZW50cyB0aGF0IGFyZSB0b28gbGFyZ2UgdG8gZml0
IGludG8gdGhlIGJtYnQgcmVjb3JkcywgcmVzdWx0aW5nCmluIGEgZGlmZmVyZW50IHR5cGUgb2Yg
YXNzZXJ0L2NvcnJ1cHRpb24gZmFpbHVyZS4KCkZpeCB0aGlzIGJ5IGxpbWl0aW5nIGV4dHNpemUg
YXQgdGhlIHRpbWUg0ZZ0IGlzIHNldCBmaXJzdGx5IHRvIGJlCmxlc3MgdGhhbiBNQVhFWFRMRU4s
IHRoZW4gdG8gYmUgYSBtYXhpbXVtIG9mIGhhbGYgdGhlIHNpemUgb2YgdGhlCkFHcyBpbiB0aGUg
ZmlsZXN5c3RlbSBmb3Igbm9uLXJlYWx0aW1lIGlub2Rlcy4gUmVhbHRpbWUgaW5vZGVzIGRvCm5v
dCBhbGxvY2F0ZSBvdXQgb2YgQUdzLCBzbyBkb24ndCBoYXZlIHRvIGJlIHJlc3RyaWN0ZWQgYnkg
dGhlIHNpemUKb2YgQUdzLgoKU2lnbmVkLW9mZi1ieTogRGF2ZSBDaGlubmVyIDxkY2hpbm5lckBy
ZWRoYXQuY29tPgotLS0KIGZzL3hmcy9saW51eC0yLjYveGZzX2lvY3RsLmMgfCAgIDIwICsrKysr
KysrKysrKysrKysrKy0tCiAxIGZpbGVzIGNoYW5nZWQsIDE4IGluc2VydGlvbnMoKyksIDIgZGVs
ZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMveGZzL2xpbnV4LTIuNi94ZnNfaW9jdGwuYyBiL2Zz
L3hmcy9saW51eC0yLjYveGZzX2lvY3RsLmMKaW5kZXggYjA2ZWRlMS4uZjVlMmExOSAxMDA2NDQK
LS0tIGEvZnMveGZzL2xpbnV4LTIuNi94ZnNfaW9jdGwuYworKysgYi9mcy94ZnMvbGludXgtMi42
L3hmc19pb2N0bC5jCkBAIC05ODUsMTAgKzk4NSwyMiBAQCB4ZnNfaW9jdGxfc2V0YXR0cigKIAog
CQkvKgogCQkgKiBFeHRlbnQgc2l6ZSBtdXN0IGJlIGEgbXVsdGlwbGUgb2YgdGhlIGFwcHJvcHJp
YXRlIGJsb2NrCi0JCSAqIHNpemUsIGlmIHNldCBhdCBhbGwuCisJCSAqIHNpemUsIGlmIHNldCBh
dCBhbGwuIEl0IG11c3QgYWxzbyBiZSBzbWFsbGVyIHRoYW4gdGhlCisJCSAqIG1heGltdW0gZXh0
ZW50IHNpemUgc3VwcG9ydGVkIGJ5IHRoZSBmaWxlc3lzdGVtLgorCQkgKgorCQkgKiBBbHNvLCBm
b3Igbm9uLXJlYWx0aW1lIGZpbGVzLCBsaW1pdCB0aGUgZXh0ZW50IHNpemUgaGludCB0bworCQkg
KiBoYWxmIHRoZSBzaXplIG9mIHRoZSBBR3MgaW4gdGhlIGZpbGVzeXN0ZW0gc28gYWxpZ25tZW50
CisJCSAqIGRvZXNuJ3QgcmVzdWx0IGluIGV4dGVudHMgbGFyZ2VyIHRoYW4gYW4gQUcuCiAJCSAq
LwogCQlpZiAoZmEtPmZzeF9leHRzaXplICE9IDApIHsKLQkJCXhmc19leHRsZW5fdAlzaXplOwor
CQkJeGZzX2V4dGxlbl90ICAgIHNpemU7CisJCQl4ZnNfZnNibG9ja190ICAgZXh0c2l6ZV9mc2I7
CisKKwkJCWV4dHNpemVfZnNiID0gWEZTX0JfVE9fRlNCKG1wLCBmYS0+ZnN4X2V4dHNpemUpOwor
CQkJaWYgKGV4dHNpemVfZnNiID4gTUFYRVhUTEVOKSB7CisJCQkJY29kZSA9IFhGU19FUlJPUihF
SU5WQUwpOworCQkJCWdvdG8gZXJyb3JfcmV0dXJuOworCQkJfQogCiAJCQlpZiAoWEZTX0lTX1JF
QUxUSU1FX0lOT0RFKGlwKSB8fAogCQkJICAgICgobWFzayAmIEZTWF9YRkxBR1MpICYmCkBAIC05
OTcsNiArMTAwOSwxMCBAQCB4ZnNfaW9jdGxfc2V0YXR0cigKIAkJCQkgICAgICAgbXAtPm1fc2Iu
c2JfYmxvY2tsb2c7CiAJCQl9IGVsc2UgewogCQkJCXNpemUgPSBtcC0+bV9zYi5zYl9ibG9ja3Np
emU7CisJCQkJaWYgKGV4dHNpemVfZnNiID4gbXAtPm1fc2Iuc2JfYWdibG9ja3MgLyAyKSB7CisJ
CQkJCWNvZGUgPSBYRlNfRVJST1IoRUlOVkFMKTsKKwkJCQkJZ290byBlcnJvcl9yZXR1cm47CisJ
CQkJfQogCQkJfQogCiAJCQlpZiAoZmEtPmZzeF9leHRzaXplICUgc2l6ZSkgewotLSAKMS43LjIu
MwoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1h
aWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlz
dGluZm8veGZzCg==
