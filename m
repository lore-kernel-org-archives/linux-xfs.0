Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D02D77F93
	for <xfs@oss.sgi.com>; Tue,  1 Jul 2014 08:41:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B29378F8033
	for <xfs@oss.sgi.com>; Tue,  1 Jul 2014 06:41:05 -0700 (PDT)
Received: from mail-we0-f169.google.com (mail-we0-f169.google.com
	[74.125.82.169]) by cuda.sgi.com with ESMTP id 8HHE6vklwj9SrtB2
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 01 Jul 2014 06:41:03 -0700 (PDT)
Received: by mail-we0-f169.google.com with SMTP id t60so9766537wes.14
	for <xfs@oss.sgi.com>; Tue, 01 Jul 2014 06:41:02 -0700 (PDT)
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: Re: [PATCH 0/4] repair: fixes for 3.2
Date: Tue, 1 Jul 2014 15:40:56 +0200
References: <1404219296-29302-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1404219296-29302-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Message-Id: <201407011540.57511.arekm@maven.pl>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

T24gVHVlc2RheSAwMSBvZiBKdWx5IDIwMTQsIERhdmUgQ2hpbm5lciB3cm90ZToKPiBIaSBBcmth
ZGl1c3osCj4gCj4gVGhlc2UgYXJlIHRoZSBmaXhlcyBJIGhhdmUgc28gZmFyIGZyb20gd29ya2lu
ZyB0aHJvdWdoIHRoZSBtZXRhZHVtcHMKPiB5b3Ugc3VwcGxpZWQgbWUgd2l0aC4gVGhlIHVub2Jm
dXNjYXRlZCBtZXRhZHVtcCByZXBhaXJzIGNsZWFubHkgd2l0aAo+IHRoZXNlIHBhdGNoZXMsIGJ1
dCB0aGUgb2JmdXNjYXRlZCBvbmUgc3RpbGwgaGFzIGEgZGlyZWN0b3J5IHJlYnVpbGQKPiBpc3N1
ZSB0aGF0IEkgaGF2ZW4ndCBnb3QgdG8gdGhlIGJvdHRvbSBvZiB5ZXQuIFRoYXQgcmVzdWx0cyBp
bgo+IGFuIGVycm9yIGluIHBoYXNlIDYgbGlrZToKPiAKPiBNZXRhZGF0YSBjb3JydXB0aW9uIGRl
dGVjdGVkIGF0IGJsb2NrIDB4MmFmODQ3NzAvMHgxMDAwCj4gbmFtZSBjcmVhdGUgZmFpbGVkIGlu
IGlubyAyMzA2OTEyMzU0ICgxMTcpLCBmaWxlc3lzdGVtIG1heSBiZSBvdXQgb2Ygc3BhY2UKPiAK
PiBJdCBhcHBlYXJzIHRoYXQgYSByZWFkIHZlcmlmaWVyIGlzIG9uIGEgcmVjZW50bHkgY3JlYXRl
ZAo+IGRpcmVjdG9yeSBsZWFmIGJsb2NrIGFuZCB0aGF0IGlzIGZhaWxpbmcuIEknbSBub3QgeWV0
IHN1cmUgd2h5IHRoZQo+IGxlYWYgYmxvY2sgaXMgY29ycnVwdCwgbm9yIHdoeSB0aGUgdmVyaWZp
ZXIgaXMgZXZlbiBiZWluZyBydW4gb24gaXQKPiBzZWVpbmcgYXMgaXQgd2FzIG9ubHkgYWxsb2Nh
dGVkIGFuZCBpbml0aWFsaXNlZCBkdXJpbmcgdGhlIGRpcmVjdG9yeQo+IHJlYnVpbGQuIFRoYXQg
ZGlyZWN0b3J5IHJlYnVpbCBkZmFpbHVyZSBpcyB0aGUgcmVhc29uIGZvciBhbGwgdGhlCj4gZGlz
Y29uZWN0ZWQgaW5vZGUgdGhhdCBlbmQgdXAgaW4gbG9zdCtmb3VuZCwgYW5kIEkgdGhpbmsgaXQn
cyB0aGUKPiBvbmx5IHJlbWFpbmluZyBpc3N1ZSB0aGF0IEkgbmVlZCB0byBzb2x2ZS4KPiAKPiBD
YW4geW91IHRlc3QgdGhlIHBhdGNoZXMgb24geW91IG1hY2hpbmUgYW5kIHNlZSBpZiB5b3UgZ2V0
IHRoZSBzYW1lCj4gcmVzdWx0cz8KClRlc3Rpbmcgb24gbm9uIG9iZnVzY2F0ZWQgaW1hZ2UgaGVy
ZS4KCk1vc3Qgb2YgaXNzdWVzIGdvdCBmaXhlZCwgZmlyc3QgeGZzX3JlcGFpciBydW46Cmh0dHA6
Ly9peGlvbi5wbGQtbGludXgub3JnL35hcmVrbS9wMi94MS9yZXBhaXItMy4yLWRjaGlubmVyMS00
cGF0Y2hlcy1ydW4xLnR4dCAKCnNlY29uZCB4ZnNfcmVwYWlyIHJ1biAocmVwb3J0cyBubyBwcm9i
bGVtcyk6Cmh0dHA6Ly9peGlvbi5wbGQtbGludXgub3JnL35hcmVrbS9wMi94MS9yZXBhaXItMy4y
LWRjaGlubmVyMS00cGF0Y2hlcy1ydW4yLnR4dAoKV2hlbiB0cnlpbmcgdG8gbW91bnQKIlhGUyAo
bG9vcDApOiBGYWlsZWQgdG8gaW5pdGlhbGl6ZSBkaXNrIHF1b3Rhcy4iCnNvIHRoaXMgaXNzdWUg
bGVmdC4KCgpRdWVzdGlvbjoKClBoYXNlIDIgLSB1c2luZyBpbnRlcm5hbCBsb2cKICAgICAgICAt
IHplcm8gbG9nLi4uCnplcm9fbG9nOiBoZWFkIGJsb2NrIDIgdGFpbCBibG9jayAyCiAgICAgICAg
LSBzY2FuIGZpbGVzeXN0ZW0gZnJlZXNwYWNlIGFuZCBpbm9kZSBtYXBzLi4uCk1ldGFkYXRhIENS
QyBlcnJvciBkZXRlY3RlZCBhdCBibG9jayAweDAvMHgyMDAKCklzICJNZXRhZGF0YSBDUkMgZXJy
b3IgZGV0ZWN0ZWQgYXQgYmxvY2siIGV4cGVjdGVkIGhlcmU/IEkgbWVhbiB2NCBmcywgc28gbm8g
CkNSQy4KClRoYW5rcyBhIGxvdCBmb3IgdGhlIGZpeGVzLgoKPiBDaGVlcnMsCj4gCj4gRGF2ZS4K
CgotLSAKQXJrYWRpdXN6IE1pxZtraWV3aWN6LCBhcmVrbSAvIG1hdmVuLnBsCgpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhm
c0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
