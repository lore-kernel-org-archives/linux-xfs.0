Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0245D7CA3
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2016 17:44:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C8A528F8066
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2016 15:44:01 -0700 (PDT)
Received: from mail02.iobjects.de (mail02.iobjects.de [188.40.134.68]) by
	cuda.sgi.com with ESMTP id Ns3zqlB0BmNWMFGC (version=TLSv1.2
	cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 02 Jun 2016 15:43:58 -0700 (PDT)
Received: from tux.wizards.de (p4FF5801B.dip0.t-ipconnect.de [79.245.128.27])
	by mail02.iobjects.de (Postfix) with ESMTPSA id 97D55416014D
	for <xfs@oss.sgi.com>; Fri,  3 Jun 2016 00:43:57 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok [192.168.100.223])
	by tux.wizards.de (Postfix) with ESMTP id 2715211C01CF
	for <xfs@oss.sgi.com>; Fri,  3 Jun 2016 00:43:57 +0200 (CEST)
Subject: Re: _xfs_buf_ioapply: no ops on block 0x188e78/0x8 on vanilla 4.4.11
References: <57503353.2050402@profihost.ag>
	<57503D33.6010000@applied-asynchrony.com>
	<575040D8.8070903@applied-asynchrony.com>
	<20160602222545.GO12670@dastard>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <5750B6AD.2050308@applied-asynchrony.com>
Date: Fri, 3 Jun 2016 00:43:57 +0200
MIME-Version: 1.0
In-Reply-To: <20160602222545.GO12670@dastard>
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

T24gMDYvMDMvMTYgMDA6MjUsIERhdmUgQ2hpbm5lciB3cm90ZToKPiBPbiBUaHUsIEp1biAwMiwg
MjAxNiBhdCAwNDoyMToxMlBNICswMjAwLCBIb2xnZXIgSG9mZnN0w6R0dGUgd3JvdGU6Cj4+IE9u
IDA2LzAyLzE2IDE2OjA1LCBIb2xnZXIgSG9mZnN0w6R0dGUgd3JvdGU6Cj4+PiBPbiAwNi8wMi8x
NiAxNToyMywgU3RlZmFuIFByaWViZSAtIFByb2ZpaG9zdCBBRyB3cm90ZToKPj4+PiBJIGZvdW5k
IGEgYnVnIHJlcG9ydCBmcm9tIHJlZGhhdCBoZXJlCj4+Pj4gaHR0cHM6Ly9idWd6aWxsYS5yZWRo
YXQuY29tL3Nob3dfYnVnLmNnaT9pZD0xMjM0NTg2IHBvaW50aW5nIHRvIHRoaXMgY29tbWl0Ogo+
Pj4+IHhmczogaGFuZGxlIGRxdW90IGJ1ZmZlciByZWFkYWhlYWQgaW4gbG9nIHJlY292ZXJ5IGNv
cnJlY3RseQo+Pj4+Cj4+Pj4gd2hpY2ggaXNuJ3QgcGFydCBvZiA0LjQuIElzIGl0IG1pc3Npbmcg
ZnJvbSBsaW51eC1zdGFibGU/Cj4+Pgo+Pj4gWWVzLCBtYWlubGluZSA3ZDZhMTNmMDIzNTYgaXMg
bWlzc2luZyBmcm9tIDQuNC1zdGFibGUgYmVjYXVzZSBpdCBhcHBsaWVzLAo+Pj4gYnV0IGRvZXNu
J3QgY29tcGlsZS4gOikKPj4+Cj4+PiBJJ2xsIGxvb2sgaW50byBhIGZpeC4KPj4KPj4gV2VsbCwg
dGhhdCB3YXMgZWFzeS4gSXQgYWxzbyBuZWVkcyAyMzMxMzViNzYzICgieGZzOiBwcmludCBuYW1l
IG9mIHZlcmlmaWVyCj4+IGlmIGl0IGZhaWxzIikgd2hpY2ggYWRkZWQgYSAubmFtZSB0byB0aGUg
dmFyaW91cyB4ZnNfYnVmX29wcyB0eXBlcy4KPj4gQ2FuIHNvbWVvbmUgY29uZmlybSB0aGF0IHRo
ZXNlIGNhbiBib3RoIGdvIGludG8gNC40LXN0YWJsZT8KPiAKPiBZb3UgY291bGQganVzdCByZW1v
dmUgdGhlIGxpbmU6Cj4gCj4gKyAgICAgICAubmFtZSA9ICJ4ZnNfZHF1b3RfcmEiLAo+IAo+IGZy
b20gN2Q2YTEzZjAyMzU2IGFuZCB0aGF0IHdpbGwgZml4IHRoZSBiYWNrcG9ydCBwcm9ibGVtIGFu
ZCBub3QKPiByZXF1aXJlIGFueSBvdGhlciBjb21taXRzIHRvIGJlIGJhY2twb3J0ZWQuIEknbSBm
aW5lIHdpdGggZWl0aGVyCj4gc29sdXRpb24uCgpIYS4udGhhdCB0b3RhbGx5IGRpZG4ndCBvY2N1
ciB0byBtZS4udG9vIHNpbXBsZS4gOn0KVGhlIC5uYW1lIHBhdGNoIGFwcGxpZXMgY2xlYW5seSBh
bmQgY2FuJ3QgaHVydCBlaXRoZXIsIHNvIEkgdGhpbmsKc2VuZGluZyBib3RoIGNvbW1pdHMgdG8g
R3JlZyBpcyBlYXNpZXN0IGZvciBldmVyeW9uZS4KCnRoYW5rcyEKSG9sZ2VyCgpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhm
c0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
