Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7P8jMGW230763 for <xfs@oss.sgi.com>; Wed, 25 Aug 2010 03:45:22 -0500
Received: from smtp-relay.maven.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2F7195C7A
	for <xfs@oss.sgi.com>; Wed, 25 Aug 2010 01:45:55 -0700 (PDT)
Received: from smtp-relay.maven.pl (smtp-relay.maven.pl [193.239.45.138]) by
	cuda.sgi.com with ESMTP id ffvJuYBKd38AwEhG for
	<xfs@oss.sgi.com>; Wed, 25 Aug 2010 01:45:55 -0700 (PDT)
Received: from [83.238.65.58] (port=37150 helo=tarm.maven.pl ident=matrix157)
	by smtp-relay.maven.pl with esmtpsa (TLSv1:DHE-RSA-AES256-SHA:256)
	(Exim 4.72) (envelope-from <arekm@maven.pl>) id 1OoBcJ-00070Q-CQ
	for xfs@oss.sgi.com; Wed, 25 Aug 2010 10:45:55 +0200
Received: from arekm by tarm.maven.pl with local (Exim 4.72)
	(envelope-from <arekm@maven.pl>) id 1OoBcI-0005U5-Ua
	for xfs@oss.sgi.com; Wed, 25 Aug 2010 10:45:55 +0200
From: Arkadiusz Miskiewicz <arekm@maven.pl>
Subject: Re: [PATCH] Validate string -> number conversion.
Date: Wed, 25 Aug 2010 10:45:54 +0200
References: <1282724556-19456-1-git-send-email-arekm@maven.pl>
In-Reply-To: <1282724556-19456-1-git-send-email-arekm@maven.pl>
MIME-Version: 1.0
Message-Id: <201008251045.54899.arekm@maven.pl>
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

T24gV2VkbmVzZGF5IDI1IG9mIEF1Z3VzdCAyMDEwLCBBcmthZGl1c3ogTWnFm2tpZXdpY3ogd3Jv
dGU6Cj4gTWFrZSBzdXJlIHRoYXQgbnVtYmVycyBwYXNzZWQgYXMgc3RyaW5nIHdpbGwgZml0IGlu
dG8gcHJvcGVyCj4gdHlwZXMgd2hlbiBkb2luZyBzdHJpbmctPnVpZF90L2dpZF90L3ByaWRfdCBj
b252ZXJzaW9uLgo+IAo+IFNpZ25lZC1vZmYtYnk6IEFya2FkaXVzeiBNacWba2lld2ljeiA8YXJl
a21AbWF2ZW4ucGw+Cj4gLS0tCj4gIGxpYnhjbWQvaW5wdXQuYyB8ICAgMTggKysrKysrKysrKysr
KysrLS0tCj4gIHF1b3RhL3Byb2plY3QuYyB8ICAgIDIgKy0KPiAgMiBmaWxlcyBjaGFuZ2VkLCAx
NiBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQoKT24gdGhlIGtlcm5lbCBzaWRlIHNvbWV0
aGluZyBsaWtlIGJlbG93IGlzIG5lZWRlZCAoY29tcGlsZSB0ZXN0ZWQgb25seSkuClRoZSB0cnVl
IGZpeCBpcyB0byBleHRlbmQgb24gZGlzayBkaV9wcm9qaWQgdG8gMzJiaXQgKHRoZXJlIGlzIHJv
b20gZm9yIHRoYXQpLgoKZGlmZiAtLWdpdCBhL2ZzL3hmcy9saW51eC0yLjYveGZzX2lvY3RsLmMg
Yi9mcy94ZnMvbGludXgtMi42L3hmc19pb2N0bC5jCmluZGV4IDIzN2Y1ZmYuLjFkOWNmNGYgMTAw
NjQ0Ci0tLSBhL2ZzL3hmcy9saW51eC0yLjYveGZzX2lvY3RsLmMKKysrIGIvZnMveGZzL2xpbnV4
LTIuNi94ZnNfaW9jdGwuYwpAQCAtOTA2LDYgKzkwNiwxMSBAQCB4ZnNfaW9jdGxfc2V0YXR0cigK
IAlpZiAoWEZTX0ZPUkNFRF9TSFVURE9XTihtcCkpCiAJCXJldHVybiBYRlNfRVJST1IoRUlPKTsK
IAorCS8qIE1ha2Ugc3VyZSBhIHVzZXJzcGFjZSBwYXNzZWQgcHJvamlkICgzMmJpdCkgd2lsbCBm
aXQgb24gZGlzayAoMTZiaXQpICovCisJaWYgKGZhLT5mc3hfcHJvamlkID4gKF9fdWludDE2X3Qp
LTEpIHsKKwkJY29kZSA9IFhGU19FUlJPUihFSU5WQUwpOyAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAKKwkJZ290byBlcnJvcl9yZXR1cm47IAorCX0KIAkvKgogCSAq
IElmIGRpc2sgcXVvdGFzIGlzIG9uLCB3ZSBtYWtlIHN1cmUgdGhhdCB0aGUgZHF1b3RzIGRvIGV4
aXN0IG9uIGRpc2ssCiAJICogYmVmb3JlIHdlIHN0YXJ0IGFueSBvdGhlciB0cmFuc2FjdGlvbnMu
IFRyeWluZyB0byBkbyB0aGlzIGxhdGVyCgoKLS0gCkFya2FkaXVzeiBNacWba2lld2ljeiAgICAg
ICAgUExEL0xpbnV4IFRlYW0KYXJla20gLyBtYXZlbi5wbCAgICAgICAgICAgIGh0dHA6Ly9mdHAu
cGxkLWxpbnV4Lm9yZy8KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNv
bS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
