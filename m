Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBF5ZqHR206708 for <xfs@oss.sgi.com>; Mon, 14 Dec 2009 23:35:52 -0600
Received: from mail-pz0-f173.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F17C7F64D0
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2009 21:36:30 -0800 (PST)
Received: from mail-pz0-f173.google.com (mail-pz0-f173.google.com
	[209.85.222.173]) by cuda.sgi.com with ESMTP id
	FVD3ZUYp7bbDbDdX for <xfs@oss.sgi.com>;
	Mon, 14 Dec 2009 21:36:30 -0800 (PST)
Received: by pzk3 with SMTP id 3so2627460pzk.20
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2009 21:36:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091215012640.GA4850@discord.disaster>
References: <4B1F1211.90607@sandeen.net> <4B1F18C4.3060704@sandeen.net>
	<389deec70912082053v4310057dg479f6d4b6c4b46f7@mail.gmail.com>
	<4B1F31FD.3020705@sandeen.net>
	<389deec70912082220pcb3b5d1q516ac197d31502c5@mail.gmail.com>
	<389deec70912082230g38987576pc48d7699f23844c5@mail.gmail.com>
	<389deec70912140119q40ed91cao62fe9c9ebdf13601@mail.gmail.com>
	<4B26604B.3060901@sandeen.net>
	<389deec70912141649g767a1540hdeae66707c4c68fd@mail.gmail.com>
	<20091215012640.GA4850@discord.disaster>
Date: Tue, 15 Dec 2009 13:36:29 +0800
Message-ID: <389deec70912142136o129e4174m776408c732ac3bb3@mail.gmail.com>
Subject: Re: [BUG report]xfs_btree_make_block_unfull generated an OOPS
From: hank peng <pengxihan@gmail.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

MjAwOS8xMi8xNSBEYXZlIENoaW5uZXIgPGRhdmlkQGZyb21vcmJpdC5jb20+Ogo+IE9uIFR1ZSwg
RGVjIDE1LCAyMDA5IGF0IDA4OjQ5OjM3QU0gKzA4MDAsIGhhbmsgcGVuZyB3cm90ZToKPj4gSGks
IEVyaWM6Cj4+IEkgYWRkIHNvbWUgY29kZSBsaWtlIHRoaXM6Cj4+IGlmICgqc3RhdCkgewo+PiDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBwcmludGsoIipzdGF0ID0gMHglMDh4LCBvaW5kZXggPSAl
cCwgaW5kZXggPSAlcFxuIiwKPj4gwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgKnN0YXQsIG9pbmRleCwgaW5kZXgpOwo+PiDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCBpZiAob2luZGV4ID09IE5VTEwgfHwgaW5kZXggPT0gTlVMTCkgewo+Cj4gVGhpcyB3b24n
dCBjYXRjaCBiYWQgbm9uLU5VTEwgcG9pbnRlcnMgbGlrZSB5b3UgYXJlIHNlZWluZy4KPgo+PiDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBwcmludGsoIkJVRyBvY2N1cmVkIVxu
Iik7Cj4+IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHByaW50aygib2luZGV4
ID0gJXAsIGluZGV4ID0gJXBcbiIsIG9pbmRleCwgaW5kZXgpOwo+PiDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCBCVUcoKTsKPj4gwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgfQo+
PiDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAqb2luZGV4ID0gKmluZGV4ID0gY3VyLT5iY19wdHJz
W2xldmVsXTsKPj4gwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgcmV0dXJuIDA7Cj4+IMKgIMKgIMKg
IMKgIH0KPj4KPj4gQW5kIHRoZSBzYW1lIE9PUFMgaGFwcGVuZWQgYWdhaW4gYnV0IGEgbGl0dGxl
IGRpZmZlcmVudCwga2VybmVsIG1lc3NhZ2VzIGFyZToKPj4KPj4gPHNuaXA+Cj4+ICpzdGF0ID0g
MHgwMDAwMDAwMSwgb2luZGV4ID0gZTg3ZDdiZjgsIGluZGV4ID0gZTg3ZDdiZmMKPj4gKnN0YXQg
PSAweDAwMDAwMDAxLCBvaW5kZXggPSBlODdkN2JmOCwgaW5kZXggPSBlODdkN2JmYwo+PiAqc3Rh
dCA9IDB4MDAwMDAwMDEsIG9pbmRleCA9IGU4N2Q3YmY4LCBpbmRleCA9IGU4N2Q3YmZjCj4+ICpz
dGF0ID0gMHgwMDAwMDAwMSwgb2luZGV4ID0gZTg3ZDdiZjgsIGluZGV4ID0gZTg3ZDdiZmMKPj4g
KnN0YXQgPSAweDAwMDAwMDAxLCBvaW5kZXggPSAwMDAwMDUwMSwgaW5kZXggPSAyMjAwODQyNAo+
PiBVbmFibGUgdG8gaGFuZGxlIGtlcm5lbCBwYWdpbmcgcmVxdWVzdCBmb3IgZGF0YSBhdCBhZGRy
ZXNzIDB4MjIwMDg0MjQKPgo+IEdpdmVuIHRoYXQgb2luZGV4IGFuZCBpbmRleCBhcmUgc3RhY2sg
dmFyaWJsZXMsIHRoaXMgaW5kaWNhdGVzIHNvbWUKCkluIHhmc19idHJlZV9tYWtlX2Jsb2NrX3Vu
ZnVsbCwgaXQgc2VlbXMgdGhhdCBvaW5kZXggYW5kIGluZGV4IGFyZQpvcHRpbWlzZWQgdG8gcmVn
aXN0ZXIgdmFyaWFibGVzLiBTbywgaXQgYmVjb21lIG1vcmUgb2RkLgoKPiB0aGluZyBpcyBwcm9i
YWJseSBzbWFzaGluZyB0aGUgc3RhY2suIFBvc3NpYmx5IGEgYnVmZmVyIG92ZXJydW4uIFRvCj4g
bmFycm93IGRvd24gdGhlIHBvc3NpYmxlIGNhdXNlLCBjYW4geW91IGFkZCB0aGUgZGVidWc6Cj4K
PiDCoCDCoCDCoCDCoHByaW50aygiJXM6JXM6IG9pbmRleCA9ICVwLCBpbmRleCA9ICVwXG4iLAo+
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgX19mdW5jX18sIF9fTElORV9fLCBv
aW5kZXgsIGluZGV4KTsKPgo+IHRocm91Z2hvdXQgdGhlIHhmc19idHJlZV9tYWtlX2Jsb2NrX3Vu
ZnVsbCgpIGZ1bmN0aW9uPyBpLmUuIGF0Cj4gZmlyc3QgZW50cnksIGJlZm9yZSB0aGUgeGZzX2J0
cmVlX3JzaGlmdCgpIGNhbGwsIGJlZm9yZSB0aGUKPiB4ZnNfYnRyZWVfbHNoaWZ0KCkgY2FsbCwg
ZXRjLCB0byBzZWUgaWYgYW55IG9mIHRoZSBwYXJhbWV0ZXJzCj4gYXJlIGJlaW5nIG1vZGlmaWVk
IGR1cmluZyBleGVjdXRpb24gb2YgdGhlIGZ1bmN0aW9uPwo+Cj4gSWYgdGhlIHZhcmlhYmxlcyBi
ZWluZyBwYXNzZWQgaW50byB4ZnNfYnRyZWVfbWFrZV9ibG9ja191bmZ1bGwoKSBhcmUKPiBhbHJl
YWR5IGJhZCwgdGhlbiBkbyB0aGUgc2FtZSB0aGluZyBmb3IgdGhlIGNhbGxlcgo+IHhmc19idHJl
ZV9pbnNlcnQoKS4gVGhpcyBtYXkgaGVscCBuYXJyb3cgZG93biB3aGVyZSB0aGUgcHJvYmxlbQo+
IGlzIGNvbWluZyBmcm9tLi4uLgo+Cj4gQ2hlZXJzLAo+Cj4gRGF2ZS4KPiAtLQo+IERhdmUgQ2hp
bm5lcgo+IGRhdmlkQGZyb21vcmJpdC5jb20KPgoKCgotLSAKVGhlIHNpbXBsZXN0IGlzIG5vdCBh
bGwgYmVzdCBidXQgdGhlIGJlc3QgaXMgc3VyZWx5IHRoZSBzaW1wbGVzdCEKCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZz
QG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
