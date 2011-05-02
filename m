Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p425bdxF214267 for <xfs@oss.sgi.com>; Mon, 2 May 2011 00:37:39 -0500
Received: from mail-vw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 80332164739B
	for <xfs@oss.sgi.com>; Sun,  1 May 2011 22:41:15 -0700 (PDT)
Received: from mail-vw0-f53.google.com (mail-vw0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id 9AIlRBKo64NFIT9M
	for <xfs@oss.sgi.com>; Sun, 01 May 2011 22:41:15 -0700 (PDT)
Received: by vws13 with SMTP id 13so4433232vws.26
	for <xfs@oss.sgi.com>; Sun, 01 May 2011 22:41:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=xpSa2x4vaD4zQjrz3_JSLkC-hgg@mail.gmail.com>
References: <BANLkTimAXUtO=oxmLUaHLaRBnGafGP-9kg@mail.gmail.com>
	<20110427171107.GA29196@infradead.org>
	<BANLkTi=xpSa2x4vaD4zQjrz3_JSLkC-hgg@mail.gmail.com>
Date: Mon, 2 May 2011 11:11:14 +0530
Message-ID: <BANLkTimgyWZP_1O_pwm+GXqHsMwhxz1d=A@mail.gmail.com>
Subject: Re: xfstests 013 - 2.6.35.11 - hang
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

SXMgdGhlcmUgYW55IHRoaW5nIEkgbGVmdCBvdXQgaW4geGZzIHJlbGF0ZWQgdG8gY2FjaGUgY29o
ZXJlbmN5LgoKT24gVGh1LCBBcHIgMjgsIDIwMTEgYXQgMTI6NTkgUE0sIEFqZWV0IFlhZGF2IDxh
amVldC55YWRhdi43N0BnbWFpbC5jb20+IHdyb3RlOgo+IE1JUFMzMsKuIDM0S+KEoiBDb3JlCj4g
SXQgZG9lcyBub3QgcHJvdmlkZSDCoGludmFsaWRhdGVfa2VybmVsX3ZtYXBfcmFuZ2UoKSAvCj4g
Zmx1c2hfa2VybmVsX3ZtYXBfcmFuZ2UoKSB0byBkZWFsIHdpdGggY2FjaGUgY29oZXJlbmN5IHBy
b2JsZW0KPiBUaGVyZWZvcmUgd2UgcHJvdmlkZWQgZG1hX2NhY2hlX2ludigpIC8gZG1hX2NhY2hl
X3diYWNrX2ludigpICwgYWZ0ZXIKPiB0aGF0IHdlIGRpZCBub3QgaGFkIGFueSBjb2hlcmVuY3kg
cHJvYmxlbQo+IEJ1dCBhcyB5b3Ugc2F5aW5nIGl0IHN0aWxsIGhhcyBjYWNoZSBjb2hlcmVuY3kg
cHJvYmxlbSwgd3J0IHhmc3Rlc3RzIDAwMSA/Cj4KPiBkaWZmIC1OdXJwIC1YIGxpbnV4LTIuNi4z
NS4xMS9Eb2N1bWVudGF0aW9uL2RvbnRkaWZmCj4gbGludXgtMi42LjM1LjExL2ZzL3hmcy9saW51
eC0yLjYveGZzX2J1Zi5jCj4gbGludXgtMi42LjM1LjExLWRpcnR5L2ZzL3hmcy9saW51eC0yLjYv
eGZzX2J1Zi5jCj4gLS0tIGxpbnV4LTIuNi4zNS4xMS9mcy94ZnMvbGludXgtMi42L3hmc19idWYu
YyDCoDIwMTEtMDItMDcKPiAwNDowNDowNy4wMDAwMDAwMDAgKzA5MDAKPiArKysgbGludXgtMi42
LjM1LjExLWRpcnR5L2ZzL3hmcy9saW51eC0yLjYveGZzX2J1Zi5jIMKgIMKgMjAxMS0wMy0yMgo+
IDE4OjI5OjA5LjAwMDAwMDAwMCArMDkwMAo+IEBAIC0xMTkyLDcgKzExOTIsNyBAQCB4ZnNfYnVm
X2Jpb19lbmRfaW8oCj4gwqAgwqAgwqAgwqB4ZnNfYnVmX2lvZXJyb3IoYnAsIC1lcnJvcik7Cj4K
PiDCoCDCoCDCoCDCoGlmICghZXJyb3IgJiYgeGZzX2J1Zl9pc192bWFwcGVkKGJwKSAmJiAoYnAt
PmJfZmxhZ3MgJiBYQkZfUkVBRCkpCj4gLSDCoCDCoCDCoCDCoCDCoCDCoCDCoCBpbnZhbGlkYXRl
X2tlcm5lbF92bWFwX3JhbmdlKGJwLT5iX2FkZHIsIHhmc19idWZfdm1hcF9sZW4oYnApKTsKPiAr
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIGRtYV9jYWNoZV9pbnYoKHVuc2lnbmVkIGxvbmcpYnAtPmJf
YWRkciwgeGZzX2J1Zl92bWFwX2xlbihicCkpOwo+Cj4gwqAgwqAgwqAgwqBkbyB7Cj4gwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqBzdHJ1Y3QgcGFnZSDCoCDCoCAqcGFnZSA9IGJ2ZWMtPmJ2X3BhZ2U7
Cj4gQEAgLTEzMDQsNyArMTMwNCw3IEBAIG5leHRfY2h1bms6Cj4gwqBzdWJtaXRfaW86Cj4gwqAg
wqAgwqAgwqBpZiAobGlrZWx5KGJpby0+Ymlfc2l6ZSkpIHsKPiDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoGlmICh4ZnNfYnVmX2lzX3ZtYXBwZWQoYnApKSB7Cj4gLSDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCBmbHVzaF9rZXJuZWxfdm1hcF9yYW5nZShicC0+Yl9hZGRyLAo+ICsgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgZG1hX2NhY2hlX3diYWNrX2ludigodW5zaWdu
ZWQgbG9uZylicC0+Yl9hZGRyLAo+IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgeGZzX2J1Zl92bWFwX2xlbihicCkp
Owo+IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgfQo+IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgc3Vi
bWl0X2JpbyhydywgYmlvKTsKPgo+IE9uIFdlZCwgQXByIDI3LCAyMDExIGF0IDEwOjQxIFBNLCBD
aHJpc3RvcGggSGVsbHdpZyA8aGNoQGluZnJhZGVhZC5vcmc+IHdyb3RlOgo+PiBEb2VzIDAwMSBh
bHNvIGZhaWwgZm9yIHNheSBleHQyIGFuZCBleHQzPwo+Pgo+Pgo+CgpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Mu
c2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
