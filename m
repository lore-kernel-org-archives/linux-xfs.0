Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0R3rnH3184597 for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 21:53:49 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8393C2922D0
	for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 19:56:12 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	WasPg5ZzaSDeUfFE for <xfs@oss.sgi.com>;
	Wed, 26 Jan 2011 19:56:12 -0800 (PST)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PiIxs-0008Fa-2L
	for xfs@oss.sgi.com; Thu, 27 Jan 2011 14:56:08 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PiIvF-0004TF-LJ
	for xfs@oss.sgi.com; Thu, 27 Jan 2011 14:53:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/8] xfs: limit extsize to size of AGs and/or MAXEXTLEN
Date: Thu, 27 Jan 2011 14:53:19 +1100
Message-Id: <1296100401-17135-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1296100401-17135-1-git-send-email-david@fromorbit.com>
References: <1296100401-17135-1-git-send-email-david@fromorbit.com>
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
ZWRoYXQuY29tPgpSZXZpZXdlZC1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+ClJl
dmlld2VkLWJ5OiBBbGV4IEVsZGVyIDxhZWxkZXJAc2dpLmNvbT4KLS0tCiBmcy94ZnMvbGludXgt
Mi42L3hmc19pb2N0bC5jIHwgICAyMCArKysrKysrKysrKysrKysrKystLQogMSBmaWxlcyBjaGFu
Z2VkLCAxOCBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL3hm
cy9saW51eC0yLjYveGZzX2lvY3RsLmMgYi9mcy94ZnMvbGludXgtMi42L3hmc19pb2N0bC5jCmlu
ZGV4IGIwNmVkZTEuLmY1ZTJhMTkgMTAwNjQ0Ci0tLSBhL2ZzL3hmcy9saW51eC0yLjYveGZzX2lv
Y3RsLmMKKysrIGIvZnMveGZzL2xpbnV4LTIuNi94ZnNfaW9jdGwuYwpAQCAtOTg1LDEwICs5ODUs
MjIgQEAgeGZzX2lvY3RsX3NldGF0dHIoCiAKIAkJLyoKIAkJICogRXh0ZW50IHNpemUgbXVzdCBi
ZSBhIG11bHRpcGxlIG9mIHRoZSBhcHByb3ByaWF0ZSBibG9jawotCQkgKiBzaXplLCBpZiBzZXQg
YXQgYWxsLgorCQkgKiBzaXplLCBpZiBzZXQgYXQgYWxsLiBJdCBtdXN0IGFsc28gYmUgc21hbGxl
ciB0aGFuIHRoZQorCQkgKiBtYXhpbXVtIGV4dGVudCBzaXplIHN1cHBvcnRlZCBieSB0aGUgZmls
ZXN5c3RlbS4KKwkJICoKKwkJICogQWxzbywgZm9yIG5vbi1yZWFsdGltZSBmaWxlcywgbGltaXQg
dGhlIGV4dGVudCBzaXplIGhpbnQgdG8KKwkJICogaGFsZiB0aGUgc2l6ZSBvZiB0aGUgQUdzIGlu
IHRoZSBmaWxlc3lzdGVtIHNvIGFsaWdubWVudAorCQkgKiBkb2Vzbid0IHJlc3VsdCBpbiBleHRl
bnRzIGxhcmdlciB0aGFuIGFuIEFHLgogCQkgKi8KIAkJaWYgKGZhLT5mc3hfZXh0c2l6ZSAhPSAw
KSB7Ci0JCQl4ZnNfZXh0bGVuX3QJc2l6ZTsKKwkJCXhmc19leHRsZW5fdCAgICBzaXplOworCQkJ
eGZzX2ZzYmxvY2tfdCAgIGV4dHNpemVfZnNiOworCisJCQlleHRzaXplX2ZzYiA9IFhGU19CX1RP
X0ZTQihtcCwgZmEtPmZzeF9leHRzaXplKTsKKwkJCWlmIChleHRzaXplX2ZzYiA+IE1BWEVYVExF
TikgeworCQkJCWNvZGUgPSBYRlNfRVJST1IoRUlOVkFMKTsKKwkJCQlnb3RvIGVycm9yX3JldHVy
bjsKKwkJCX0KIAogCQkJaWYgKFhGU19JU19SRUFMVElNRV9JTk9ERShpcCkgfHwKIAkJCSAgICAo
KG1hc2sgJiBGU1hfWEZMQUdTKSAmJgpAQCAtOTk3LDYgKzEwMDksMTAgQEAgeGZzX2lvY3RsX3Nl
dGF0dHIoCiAJCQkJICAgICAgIG1wLT5tX3NiLnNiX2Jsb2NrbG9nOwogCQkJfSBlbHNlIHsKIAkJ
CQlzaXplID0gbXAtPm1fc2Iuc2JfYmxvY2tzaXplOworCQkJCWlmIChleHRzaXplX2ZzYiA+IG1w
LT5tX3NiLnNiX2FnYmxvY2tzIC8gMikgeworCQkJCQljb2RlID0gWEZTX0VSUk9SKEVJTlZBTCk7
CisJCQkJCWdvdG8gZXJyb3JfcmV0dXJuOworCQkJCX0KIAkJCX0KIAogCQkJaWYgKGZhLT5mc3hf
ZXh0c2l6ZSAlIHNpemUpIHsKLS0gCjEuNy4yLjMKCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0
dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
