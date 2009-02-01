Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n11M62A3207606 for <xfs@oss.sgi.com>; Sun, 1 Feb 2009 16:06:02 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 84AD3D6547
	for <xfs@oss.sgi.com>; Sun,  1 Feb 2009 14:05:22 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id x33HvMsYLwdnlgji for <xfs@oss.sgi.com>;
	Sun, 01 Feb 2009 14:05:22 -0800 (PST)
Message-ID: <49861C91.2080106@sandeen.net>
Date: Sun, 01 Feb 2009 16:05:05 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] build: Explict libtool tag. Preserve CFLAGS/CPPFLAGS.
References: <1233523650-203120-1-git-send-email-arekm@maven.pl>
In-Reply-To: <1233523650-203120-1-git-send-email-arekm@maven.pl>
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
To: =?UTF-8?B?QXJrYWRpdXN6IE1pxZtraWV3aWN6?= <arekm@maven.pl>
Cc: xfs@oss.sgi.com

QXJrYWRpdXN6IE1pxZtraWV3aWN6IHdyb3RlOgo+IFVzZSBleHBsaWN0IGxpYnRvb2wgQ0MgdGFn
IChzb21ldGltZXMgbGlidG9vbCBjYW4ndCBkZWNpZGUgd2hhdCB0YWcgaXMKPiBjb3JyZWN0IG9u
ZSBpZiBvbWl0ZWQpLgoKU2VlbXMgZ29vZCB0byBtZS4gIEknbGwgcHVzaCB0aGlzIG9uIHRoZSBr
ZXJuZWwub3JnIHJlcG8sIHRoYW5rcy4KCihUaGlzIGlzIGFnYWluc3QgeGZzdGVzdHMsIGJhc2Vk
IG9uIGlyYyBjb252ZXJzYXRpb24pIDopCgotRXJpYwoKPiBQcmVzZXJ2ZSBDRkxBR1MvQ1BQRkxB
R1MgdG8gYWxsb3c6Cj4gQ1BQRkxBR1M9Ii1JJEhPTUUvaGVyZS1pcy14ZnNwcm9ncy1pbnN0YWxs
ZWQvaW5jbHVkZSIgXAo+IExERkxBR1M9Ii1MJEhPTUUvaGVyZS1pcy14ZnNwcm9ncy1pbnN0YWxs
ZWQvbGliIiBcCj4gLi9jb25maWd1cmUgIC4uLgo+IAo+IFNpZ25lZC1vZmYtYnk6IEFya2FkaXVz
eiBNacWba2lld2ljeiA8YXJla21AbWF2ZW4ucGw+Cj4gLS0tCj4gIGluY2x1ZGUvYnVpbGRkZWZz
LmluIHwgICAgNCArKystCj4gIGluY2x1ZGUvYnVpbGRtYWNyb3MgIHwgICAgNCArKy0tCj4gIDIg
ZmlsZXMgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQo+IAo+IGRpZmYg
LS1naXQgYS9pbmNsdWRlL2J1aWxkZGVmcy5pbiBiL2luY2x1ZGUvYnVpbGRkZWZzLmluCj4gaW5k
ZXggZDg1NWM4OS4uNjM2ZjYzMiAxMDA2NDQKPiAtLS0gYS9pbmNsdWRlL2J1aWxkZGVmcy5pbgo+
ICsrKyBiL2luY2x1ZGUvYnVpbGRkZWZzLmluCj4gQEAgLTExLDYgKzExLDggQEAgREVCVUcgPSBA
ZGVidWdfYnVpbGRACj4gIE9QVElNSVpFUiA9IEBvcHRfYnVpbGRACj4gIE1BTExPQ0xJQiA9IEBt
YWxsb2NfbGliQAo+ICBMT0FERVJGTEFHUyA9IEBMREZMQUdTQAo+ICtDRkxBR1MgPSBAQ0ZMQUdT
QAo+ICtDUFBGTEFHUyA9IEBDUFBGTEFHU0AKPiAgCj4gIExJQlhGUyA9IEBsaWJ4ZnNACj4gIExJ
QkFDTCA9IEBsaWJhY2xACj4gQEAgLTc1LDcgKzc3LDcgQEAgaWZlcSAoJChQS0dfUExBVEZPUk0p
LGZyZWVic2QpCj4gIERFUEVOREZMQUdTID0gLURfX0ZyZWVCU0RfXwo+ICBlbmRpZgo+ICAKPiAt
R0NGTEFHUyA9ICQoT1BUSU1JWkVSKSAkKERFQlVHKSBcCj4gK0dDRkxBR1MgPSAkKE9QVElNSVpF
UikgJChERUJVRykgJChDUFBGTEFHUykgXAo+ICAJLUkkKFRPUERJUikvaW5jbHVkZSAtRFZFUlNJ
T049XCIkKFBLR19WRVJTSU9OKVwiCj4gIAo+ICAjIEdsb2JhbCwgUGxhdGZvcm0sIExvY2FsIENG
TEFHUwo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2J1aWxkbWFjcm9zIGIvaW5jbHVkZS9idWlsZG1h
Y3Jvcwo+IGluZGV4IDgwMWJjYjYuLjI3NmQyYzggMTAwNjQ0Cj4gLS0tIGEvaW5jbHVkZS9idWls
ZG1hY3Jvcwo+ICsrKyBiL2luY2x1ZGUvYnVpbGRtYWNyb3MKPiBAQCAtNDEsMTAgKzQxLDEwIEBA
IExJQk5BTUUgPSAkKGJhc2VuYW1lICQoTFRMSUJSQVJZKSkKPiAgTFRPQkpFQ1RTID0gJChPQkpF
Q1RTOi5vPS5sbykKPiAgTFRWRVJTSU9OID0gJChMVF9DVVJSRU5UKTokKExUX1JFVklTSU9OKTok
KExUX0FHRSkKPiAgCj4gLUxUTElOSyA9ICQoTElCVE9PTCkgLS1tb2RlPWxpbmsgJChDQykKPiAr
TFRMSU5LID0gJChMSUJUT09MKSAtLXRhZz1DQyAtLW1vZGU9bGluayAkKENDKQo+ICBMVEVYRUMg
PSAkKExJQlRPT0wpIC0tbW9kZT1leGVjdXRlCj4gIExUSU5TVEFMTCA9ICQoTElCVE9PTCkgLS1t
b2RlPWluc3RhbGwgJChJTlNUQUxMKQo+IC1MVENPTVBJTEUgPSAkKExJQlRPT0wpIC0tbW9kZT1j
b21waWxlICQoQ0NGKQo+ICtMVENPTVBJTEUgPSAkKExJQlRPT0wpIC0tdGFnPUNDIC0tbW9kZT1j
b21waWxlICQoQ0NGKQo+ICAKPiAgaWZlcSAoJChFTkFCTEVfU0hBUkVEKSx5ZXMpCj4gIExUTERG
TEFHUyArPSAtcnBhdGggJChQS0dfTElCX0RJUikKCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0
dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
