Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1642B7CA0
	for <xfs@oss.sgi.com>; Fri,  3 Jun 2016 14:30:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CF31B8F80B9
	for <xfs@oss.sgi.com>; Fri,  3 Jun 2016 12:30:01 -0700 (PDT)
Received: from mail02.iobjects.de (mail02.iobjects.de [188.40.134.68]) by
	cuda.sgi.com with ESMTP id yWKBWgA6LeqkAEhm (version=TLSv1.2
	cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 03 Jun 2016 12:29:58 -0700 (PDT)
Received: from tux.wizards.de (p4FF5801B.dip0.t-ipconnect.de [79.245.128.27])
	by mail02.iobjects.de (Postfix) with ESMTPSA id 44E2A416014D
	for <xfs@oss.sgi.com>; Fri,  3 Jun 2016 21:29:57 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok [192.168.100.223])
	by tux.wizards.de (Postfix) with ESMTP id 65EEA11C01CF
	for <xfs@oss.sgi.com>; Fri,  3 Jun 2016 21:29:56 +0200 (CEST)
Subject: Re: _xfs_buf_ioapply: no ops on block 0x188e78/0x8 on vanilla 4.4.11
References: <57503353.2050402@profihost.ag>
	<57503D33.6010000@applied-asynchrony.com>
	<575040D8.8070903@applied-asynchrony.com>
	<20160602222545.GO12670@dastard> <5751C1B9.90709@profihost.ag>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <5751DAB4.40406@applied-asynchrony.com>
Date: Fri, 3 Jun 2016 21:29:56 +0200
MIME-Version: 1.0
In-Reply-To: <5751C1B9.90709@profihost.ag>
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

T24gMDYvMDMvMTYgMTk6NDMsIFN0ZWZhbiBQcmllYmUgLSBQcm9maWhvc3QgQUcgd3JvdGU6Cj4g
QW0gMDMuMDYuMjAxNiB1bSAwMDoyNSBzY2hyaWViIERhdmUgQ2hpbm5lcjoKPj4gT24gVGh1LCBK
dW4gMDIsIDIwMTYgYXQgMDQ6MjE6MTJQTSArMDIwMCwgSG9sZ2VyIEhvZmZzdMOkdHRlIHdyb3Rl
Ogo+Pj4gT24gMDYvMDIvMTYgMTY6MDUsIEhvbGdlciBIb2Zmc3TDpHR0ZSB3cm90ZToKPj4+PiBP
biAwNi8wMi8xNiAxNToyMywgU3RlZmFuIFByaWViZSAtIFByb2ZpaG9zdCBBRyB3cm90ZToKPj4+
Pj4gSSBmb3VuZCBhIGJ1ZyByZXBvcnQgZnJvbSByZWRoYXQgaGVyZQo+Pj4+PiBodHRwczovL2J1
Z3ppbGxhLnJlZGhhdC5jb20vc2hvd19idWcuY2dpP2lkPTEyMzQ1ODYgcG9pbnRpbmcgdG8gdGhp
cyBjb21taXQ6Cj4+Pj4+IHhmczogaGFuZGxlIGRxdW90IGJ1ZmZlciByZWFkYWhlYWQgaW4gbG9n
IHJlY292ZXJ5IGNvcnJlY3RseQo+Pj4+Pgo+Pj4+PiB3aGljaCBpc24ndCBwYXJ0IG9mIDQuNC4g
SXMgaXQgbWlzc2luZyBmcm9tIGxpbnV4LXN0YWJsZT8KPj4+Pgo+Pj4+IFllcywgbWFpbmxpbmUg
N2Q2YTEzZjAyMzU2IGlzIG1pc3NpbmcgZnJvbSA0LjQtc3RhYmxlIGJlY2F1c2UgaXQgYXBwbGll
cywKPj4+PiBidXQgZG9lc24ndCBjb21waWxlLiA6KQo+Pj4+Cj4+Pj4gSSdsbCBsb29rIGludG8g
YSBmaXguCj4+Pgo+Pj4gV2VsbCwgdGhhdCB3YXMgZWFzeS4gSXQgYWxzbyBuZWVkcyAyMzMxMzVi
NzYzICgieGZzOiBwcmludCBuYW1lIG9mIHZlcmlmaWVyCj4+PiBpZiBpdCBmYWlscyIpIHdoaWNo
IGFkZGVkIGEgLm5hbWUgdG8gdGhlIHZhcmlvdXMgeGZzX2J1Zl9vcHMgdHlwZXMuCj4+PiBDYW4g
c29tZW9uZSBjb25maXJtIHRoYXQgdGhlc2UgY2FuIGJvdGggZ28gaW50byA0LjQtc3RhYmxlPwo+
Pgo+PiBZb3UgY291bGQganVzdCByZW1vdmUgdGhlIGxpbmU6Cj4+Cj4+ICsgICAgICAgLm5hbWUg
PSAieGZzX2RxdW90X3JhIiwKPj4KPj4gZnJvbSA3ZDZhMTNmMDIzNTYgYW5kIHRoYXQgd2lsbCBm
aXggdGhlIGJhY2twb3J0IHByb2JsZW0gYW5kIG5vdAo+PiByZXF1aXJlIGFueSBvdGhlciBjb21t
aXRzIHRvIGJlIGJhY2twb3J0ZWQuIEknbSBmaW5lIHdpdGggZWl0aGVyCj4+IHNvbHV0aW9uLgo+
Pgo+IAo+IEdyZWF0LiBTaG91bGQgYmUgcHVzaCB0aGF0IG9uZSB0byBncmVnPwoKWW91J3JlIHRv
byBzbG93IDstKQoKaHR0cDovL3d3dy5zcGluaWNzLm5ldC9saXN0cy9zdGFibGUvbXNnMTM0NTQ5
Lmh0bWwKCi4ub3Igc3RlYWwgdGhlbSBmcm9tIG15IHBhdGNoIHF1ZXVlLgoKLWgKCl9fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QK
eGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
