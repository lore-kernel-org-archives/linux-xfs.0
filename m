Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n437FQTL089052 for <xfs@oss.sgi.com>; Sun, 3 May 2009 02:15:26 -0500
Received: from mail-fx0-f177.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6BE0D1D06CFB
	for <xfs@oss.sgi.com>; Sun,  3 May 2009 00:15:26 -0700 (PDT)
Received: from mail-fx0-f177.google.com (mail-fx0-f177.google.com
	[209.85.220.177]) by cuda.sgi.com with ESMTP id
	rUvUAVeCoa95pMgl for <xfs@oss.sgi.com>;
	Sun, 03 May 2009 00:15:26 -0700 (PDT)
Received: by fxm25 with SMTP id 25so3034645fxm.20
	for <xfs@oss.sgi.com>; Sun, 03 May 2009 00:15:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49FD2488.70503@sandeen.net>
References: <a4423d670905011333s664115bdh1d72392897567c1d@mail.gmail.com>
	<20090502101405.GA6145@fancy-poultry.org>
	<a4423d670905021135s4fdbea82t20cf75b61c59dc75@mail.gmail.com>
	<49FC9762.6010109@sandeen.net>
	<a4423d670905021159k51e91b12h96189005980b5e73@mail.gmail.com>
	<49FD2488.70503@sandeen.net>
Date: Sun, 3 May 2009 11:15:25 +0400
Message-ID: <a4423d670905030015h59038741of55bae686ef923f0@mail.gmail.com>
Subject: Re: 2.6.30-rc4: xfs_fsr hangs
From: Alexander Beregalov <a.beregalov@gmail.com>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

MjAwOS81LzMgRXJpYyBTYW5kZWVuIDxzYW5kZWVuQHNhbmRlZW4ubmV0PjoKPiBBbGV4YW5kZXIg
QmVyZWdhbG92IHdyb3RlOgo+PiAyMDA5LzUvMiBFcmljIFNhbmRlZW4gPHNhbmRlZW5Ac2FuZGVl
bi5uZXQ+Ogo+Pj4gQWxleGFuZGVyIEJlcmVnYWxvdiB3cm90ZToKPj4+PiAyMDA5LzUvMiBIZWlu
eiBEaWVobCA8aHRkQGZhbmN5LXBvdWx0cnkub3JnPjoKPj4+Pj4gT24gMDEuMDUuMjAwOSwgQWxl
eGFuZGVyIEJlcmVnYWxvdiB3cm90ZToKPj4+Pj4KPj4+Pj4+ICMgeGZzX2RiIC1yIC9kZXYvc2Rj
MQo+Pj4+Pj4geGZzX2RiPiBmcmFnCj4+Pj4+PiBhY3R1YWwgMjM4MDUsIGlkZWFsIDIyODkwLCBm
cmFnbWVudGF0aW9uIGZhY3RvciAzLjg0JQo+Pj4+Pj4gIyB4ZnNfZnNyIC12IC9kZXYvc2RjMQo+
Pj4+Pj4gL21udC9jIHN0YXJ0IGlub2RlPTAKPj4+Pj4+IGlubz0xNTgKPj4+Pj4+IGV4dGVudHMg
YmVmb3JlOjMgYWZ0ZXI6MSBET05FIGlubz0xNTgKPj4+Pj4+Cj4+Pj4+PiDCoHRoZW4gaXQgaGFu
Z3MKPj4+Pj4gSSBjYW4ndCBjb25maXJtIHRoaXMgaGVyZSBvbiBteSBzeXN0ZW1zOgo+Pj4+Pgo+
Pj4+PiBsaWVzZWw6fiAjIHVuYW1lIC1hCj4+Pj4+IExpbnV4IGxpZXNlbCAyLjYuMzAtcmM0ICMx
IFNNUCBQUkVFTVBUIFNhdCBNYXkgMiAxMTo0OToxMyBDRVNUIDIwMDkgeDg2XzY0IHg4Nl82NCB4
ODZfNjQgR05VL0xpbnV4Cj4+Pj4gSSBoYXZlIHRoaXMgcHJvYmxlbSBvbiB0d28geDg2XzMyIGhv
c3RzLgo+Pj4+IEl0IHJ1bnMgZm9yIGFib3V0IGEgbWludXRlIGFuZCB0aGVuIGhhbmdzLgo+Pj4g
ZWNobyB3ID4gL3Byb2Mvc3lzcnEtdHJpZ2dlcgo+Pj4gZG1lc2cKPj4+Cj4+PiB3b3VsZCBzaG93
IGFsbCB0aGUgc2xlZXBpbmcgcHJvY2Vzc2VzLi4uCj4+IEl0IGlzIHRoZSBzYW1lIGFzIEkgcG9z
dGVkIGFscmVhZHk6Cj4KPiAodHJpbW1pbmcgY2MncykKPgo+IERvZXMgdGhpcyBoYXBwZW4gaWYg
eW91IHRyeSB0byBkZWZyYWcgYSBzaW5nbGUgZmlsZT8gwqBpLmUuIHNvbWV0aGluZyBsaWtlOgpZ
ZXMsIGl0IGRvZXMuCj4KPiAjIGZvciBJIGluIGBzZXEgMTAgLTEgMGA7IGRvCj4gwqBkZCBpZj0v
ZGV2L3plcm8gb2Y9ZnJhZ2ZpbGUgYnM9NGsgY291bnQ9MSBzZWVrPSRJIGNvbnY9bm90cnVuYyBv
ZmxhZz1zeW5jCj4gZG9uZQo+Cj4gIyB4ZnNfZnNyIGZyYWdmaWxlCj4KPiBJJ20gZ3Vlc3Npbmcg
aXQgcmVxdWlyZXMgc29tZSBhY3Rpdml0eSBvbiB0aGUgZmlsZXMgdGhhdCBhcmUgYmVpbmcKPiBk
ZWZyYWdtZW50ZWQsIGJ1dCBtYXliZSB3b3J0aCBhIHRlc3QgKHRoZSB0ZXN0IHBhc3NlcyBmaW5l
IGZvciBtZSwgdGhvdWdoKS4KPgo+IC1FcmljCj4KPgoKX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20K
aHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
