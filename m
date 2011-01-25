Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0P8otDp224468 for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 02:50:56 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BC5C41DC15C2
	for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 00:53:17 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	YDnORpJ5CjFJAfHi for <xfs@oss.sgi.com>;
	Tue, 25 Jan 2011 00:53:17 -0800 (PST)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1Phee9-0003xU-18
	for xfs@oss.sgi.com; Tue, 25 Jan 2011 19:53:05 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1Phebw-0007gW-PW
	for xfs@oss.sgi.com; Tue, 25 Jan 2011 19:50:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/8] xfs: limit extsize to size of AGs and/or MAXEXTLEN
Date: Tue, 25 Jan 2011 19:50:42 +1100
Message-Id: <1295945444-29488-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1295945444-29488-1-git-send-email-david@fromorbit.com>
References: <1295945444-29488-1-git-send-email-david@fromorbit.com>
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
ZWRoYXQuY29tPgpSZXZpZXdlZC1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+Ci0t
LQogZnMveGZzL2xpbnV4LTIuNi94ZnNfaW9jdGwuYyB8ICAgMjAgKysrKysrKysrKysrKysrKysr
LS0KIDEgZmlsZXMgY2hhbmdlZCwgMTggaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRp
ZmYgLS1naXQgYS9mcy94ZnMvbGludXgtMi42L3hmc19pb2N0bC5jIGIvZnMveGZzL2xpbnV4LTIu
Ni94ZnNfaW9jdGwuYwppbmRleCBiMDZlZGUxLi5mNWUyYTE5IDEwMDY0NAotLS0gYS9mcy94ZnMv
bGludXgtMi42L3hmc19pb2N0bC5jCisrKyBiL2ZzL3hmcy9saW51eC0yLjYveGZzX2lvY3RsLmMK
QEAgLTk4NSwxMCArOTg1LDIyIEBAIHhmc19pb2N0bF9zZXRhdHRyKAogCiAJCS8qCiAJCSAqIEV4
dGVudCBzaXplIG11c3QgYmUgYSBtdWx0aXBsZSBvZiB0aGUgYXBwcm9wcmlhdGUgYmxvY2sKLQkJ
ICogc2l6ZSwgaWYgc2V0IGF0IGFsbC4KKwkJICogc2l6ZSwgaWYgc2V0IGF0IGFsbC4gSXQgbXVz
dCBhbHNvIGJlIHNtYWxsZXIgdGhhbiB0aGUKKwkJICogbWF4aW11bSBleHRlbnQgc2l6ZSBzdXBw
b3J0ZWQgYnkgdGhlIGZpbGVzeXN0ZW0uCisJCSAqCisJCSAqIEFsc28sIGZvciBub24tcmVhbHRp
bWUgZmlsZXMsIGxpbWl0IHRoZSBleHRlbnQgc2l6ZSBoaW50IHRvCisJCSAqIGhhbGYgdGhlIHNp
emUgb2YgdGhlIEFHcyBpbiB0aGUgZmlsZXN5c3RlbSBzbyBhbGlnbm1lbnQKKwkJICogZG9lc24n
dCByZXN1bHQgaW4gZXh0ZW50cyBsYXJnZXIgdGhhbiBhbiBBRy4KIAkJICovCiAJCWlmIChmYS0+
ZnN4X2V4dHNpemUgIT0gMCkgewotCQkJeGZzX2V4dGxlbl90CXNpemU7CisJCQl4ZnNfZXh0bGVu
X3QgICAgc2l6ZTsKKwkJCXhmc19mc2Jsb2NrX3QgICBleHRzaXplX2ZzYjsKKworCQkJZXh0c2l6
ZV9mc2IgPSBYRlNfQl9UT19GU0IobXAsIGZhLT5mc3hfZXh0c2l6ZSk7CisJCQlpZiAoZXh0c2l6
ZV9mc2IgPiBNQVhFWFRMRU4pIHsKKwkJCQljb2RlID0gWEZTX0VSUk9SKEVJTlZBTCk7CisJCQkJ
Z290byBlcnJvcl9yZXR1cm47CisJCQl9CiAKIAkJCWlmIChYRlNfSVNfUkVBTFRJTUVfSU5PREUo
aXApIHx8CiAJCQkgICAgKChtYXNrICYgRlNYX1hGTEFHUykgJiYKQEAgLTk5Nyw2ICsxMDA5LDEw
IEBAIHhmc19pb2N0bF9zZXRhdHRyKAogCQkJCSAgICAgICBtcC0+bV9zYi5zYl9ibG9ja2xvZzsK
IAkJCX0gZWxzZSB7CiAJCQkJc2l6ZSA9IG1wLT5tX3NiLnNiX2Jsb2Nrc2l6ZTsKKwkJCQlpZiAo
ZXh0c2l6ZV9mc2IgPiBtcC0+bV9zYi5zYl9hZ2Jsb2NrcyAvIDIpIHsKKwkJCQkJY29kZSA9IFhG
U19FUlJPUihFSU5WQUwpOworCQkJCQlnb3RvIGVycm9yX3JldHVybjsKKwkJCQl9CiAJCQl9CiAK
IAkJCWlmIChmYS0+ZnN4X2V4dHNpemUgJSBzaXplKSB7Ci0tIAoxLjcuMi4zCgpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhm
c0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
