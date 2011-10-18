Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9I5GxjQ054717 for <xfs@oss.sgi.com>; Tue, 18 Oct 2011 00:17:00 -0500
Received: from smtp-relay.maven.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 766FD1D4FB9
	for <xfs@oss.sgi.com>; Mon, 17 Oct 2011 22:16:53 -0700 (PDT)
Received: from smtp-relay.maven.pl (smtp-relay.maven.pl [193.239.45.138]) by
	cuda.sgi.com with ESMTP id hM5WLxzJ1jvkMfYg for
	<xfs@oss.sgi.com>; Mon, 17 Oct 2011 22:16:53 -0700 (PDT)
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: Re: [RFC PATCH 1/3] Remove in core use of XFS_OQUOTA_ENFD and
	XFS_OQUOTA_CHKD
Date: Tue, 18 Oct 2011 07:16:14 +0200
References: <20111018000932.14942.11597.sendpatchset@chandra-lucid.austin.ibm.com>
	<20111018000938.14942.44199.sendpatchset@chandra-lucid.austin.ibm.com>
In-Reply-To: <20111018000938.14942.44199.sendpatchset@chandra-lucid.austin.ibm.com>
MIME-Version: 1.0
Message-Id: <201110180716.14756.arekm@maven.pl>
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
Cc: Chandra Seetharaman <sekharan@us.ibm.com>

T24gVHVlc2RheSAxOCBvZiBPY3RvYmVyIDIwMTEsIENoYW5kcmEgU2VldGhhcmFtYW4gd3JvdGU6
CgpRdWljayBsb29rIGZvciBkaWZmIGJldHdlZW4geW91ciBhbmQgbWluZSBwYXRjaCB3aGVuIEkg
d2FzIHBsYXlpbmcgd2l0aCAKc2VwYXJhdGUgcHJvamVjdCBxdW90YSBzb21lIHRpbWUgYWdvIGFu
ZDoKCj4gZGlmZiAtLWdpdCBhL2ZzL3hmcy94ZnNfcW1fc3lzY2FsbHMuYyBiL2ZzL3hmcy94ZnNf
cW1fc3lzY2FsbHMuYwo+IGluZGV4IDVjYzNkZGUuLjNhNjc4MDUgMTAwNjQ0Cj4gLS0tIGEvZnMv
eGZzL3hmc19xbV9zeXNjYWxscy5jCj4gKysrIGIvZnMveGZzL3hmc19xbV9zeXNjYWxscy5jCj4g
QEAgLTEyMCwxMSArMTIwLDExIEBAIHhmc19xbV9zY2FsbF9xdW90YW9mZigKPiAgCX0KPiAgCWlm
IChmbGFncyAmIFhGU19HUVVPVEFfQUNDVCkgewo+ICAJCWRxdHlwZSB8PSBYRlNfUU1PUFRfR1FV
T1RBOwo+IC0JCWZsYWdzIHw9IChYRlNfT1FVT1RBX0NIS0QgfCBYRlNfT1FVT1RBX0VORkQpOwo+
ICsJCWZsYWdzIHw9IChYRlNfR1FVT1RBX0NIS0QgfCBYRlNfR1FVT1RBX0VORkQpOwo+ICAJCWlu
YWN0aXZhdGVfZmxhZ3MgfD0gWEZTX0dRVU9UQV9BQ1RJVkU7Cj4gIAl9IGVsc2UgaWYgKGZsYWdz
ICYgWEZTX1BRVU9UQV9BQ0NUKSB7CgpUaGVzZSBjYW4gYmUgc2VwYXJhdGUgc28sIG5vIGVsc2Ug
aWYgYnV0IGp1c3Qgc2VwYXJhdGUgaWYuCgoKPiBkaWZmIC0tZ2l0IGEvZnMveGZzL3hmc19zdXBl
ci5jIGIvZnMveGZzL3hmc19zdXBlci5jCj4gaW5kZXggYmExNjI0OC4uYjFjOGQ1YiAxMDA2NDQK
PiAtLS0gYS9mcy94ZnMveGZzX3N1cGVyLmMKPiArKysgYi9mcy94ZnMveGZzX3N1cGVyLmMKCj4g
QEAgLTU1MiwxMiArNTUzLDEyIEBAIHhmc19zaG93YXJncygKPiAgCS8qIEVpdGhlciBwcm9qZWN0
IG9yIGdyb3VwIHF1b3RhcyBjYW4gYmUgYWN0aXZlLCBub3QgYm90aCAqLwoKTm8gbG9uZ2VyIHRy
dWUuCgo+IAo+ICAJaWYgKG1wLT5tX3FmbGFncyAmIFhGU19QUVVPVEFfQUNDVCkgewo+IC0JCWlm
IChtcC0+bV9xZmxhZ3MgJiBYRlNfT1FVT1RBX0VORkQpCj4gKwkJaWYgKG1wLT5tX3FmbGFncyAm
IFhGU19QUVVPVEFfRU5GRCkKPiAgCQkJc2VxX3B1dHMobSwgIiwiIE1OVE9QVF9QUkpRVU9UQSk7
Cj4gIAkJZWxzZQo+ICAJCQlzZXFfcHV0cyhtLCAiLCIgTU5UT1BUX1BRVU9UQU5PRU5GKTsKPiAg
CX0gZWxzZSBpZiAobXAtPm1fcWZsYWdzICYgWEZTX0dRVU9UQV9BQ0NUKSB7CgpBbHNvIG5vdCBl
bHNlIGlmIC0ganVzdCBpZi4KCj4gLQkJaWYgKG1wLT5tX3FmbGFncyAmIFhGU19PUVVPVEFfRU5G
RCkKPiArCQlpZiAobXAtPm1fcWZsYWdzICYgWEZTX0dRVU9UQV9FTkZEKQoKLS0gCkFya2FkaXVz
eiBNacWba2lld2ljeiAgICAgICAgUExEL0xpbnV4IFRlYW0KYXJla20gLyBtYXZlbi5wbCAgICAg
ICAgICAgIGh0dHA6Ly9mdHAucGxkLWxpbnV4Lm9yZy8KCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29t
Cmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
