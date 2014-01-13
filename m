Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6ABC37F3F
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 13:27:41 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EF9F3AC001
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 11:27:37 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	8J019n6JwwWGdwef for <xfs@oss.sgi.com>;
	Mon, 13 Jan 2014 11:27:36 -0800 (PST)
Date: Tue, 14 Jan 2014 06:27:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Files with non-ASCII names inaccessible after xfs_repair
Message-ID: <20140113192732.GI3469@dastard>
References: <A40DF90D-5F6B-4595-AA30-B91D8F7972D0@kotlarek.com>
	<52D2E358.6070106@hardwarefreak.com>
	<CF41F386-E86A-4745-B28D-0DAA8D3CA1DD@kotlarek.com>
	<20140113015007.GC3469@dastard>
	<EDB09149-717F-4089-9C21-1D342CF77A7D@kotlarek.com>
	<20140113031947.GG3469@dastard>
	<E2EE0AEA-ED22-4D3B-8550-88F2ED1F8314@kotlarek.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <E2EE0AEA-ED22-4D3B-8550-88F2ED1F8314@kotlarek.com>
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
To: Zachary Kotlarek <zach@kotlarek.com>
Cc: xfs@oss.sgi.com

T24gU3VuLCBKYW4gMTIsIDIwMTQgYXQgMDc6NDc6MjlQTSAtMDgwMCwgWmFjaGFyeSBLb3RsYXJl
ayB3cm90ZToKPiAKPiBPbiBKYW4gMTIsIDIwMTQsIGF0IDc6MTkgUE0sIERhdmUgQ2hpbm5lciA8
ZGF2aWRAZnJvbW9yYml0LmNvbT4KPiB3cm90ZToKPiAKPiA+IElPV3MsIHhmcy1yZXBhaXIgd3Jv
dGUgbmV3IGNvbnRlbnRzIHRvIHRob3NlIGJsb2NrcywgYW5kIG5vdyB0aGUKPiA+IGtlcm5lbCBj
YW5ub3QgcmVhZCB0aGVtIGZyb20gZGlzay4KPiAKPiAKPiBTdXJlLCBidXQgSSBkb27igJl0IHVu
ZGVyc3RhbmQgd2h5IGl0IHdvdWxkIGhhdmUgcmUtd3JpdHRlbiB0aGVtCj4gaW4gdGhlIGZpcnN0
IHBsYWNlLiBJIGtub3cgY29ycnVwdGlvbiBoYXBwZW5zLCBidXQgdGhpcyBzZWVtcwo+IGF3ZnVs
bHkgcGF0dGVybi10YXN0aWMgdG8gYmUgcmFuZG9tIGVycm9ycy4KCk5laXRoZXIgZG8gSSwgYnV0
IEknbSB0cnlpbmcgdG8gZmluZCBvdXQuCgo+ID4gVHJ5IHVzaW5nIHhmc19kYiB0byByZWFkIGFu
ZCBwYXJzZSB0aGUgYmxvY2tzIHRoYXQgdGhlCj4gPiBmaWVsc3lzdGVtIGlzIGNob2tpbmcgb24u
IElmIGl0IGNhbid0IHJlYWQgdGhlbSBmcm9tIHhmc19kYiwKPiA+IHRoZW4gdGhlcmUncyBzb21l
dGhpbmcgZ29uZSB3cm9uZyBiZWxvdyBYRlMuIElmIHlvdSBjYW4gcmVhZAo+ID4gdGhlbSwgdXNl
IHhmc19kYiB0byBwYXJzZSB0aGUgYmxvY2sgYXMgYSBkaXJlY3RvcnkgYmxvY2sgYW5kIHNlZQo+
ID4gd2hhdCB0aGUgcmF3IGRpcmVjdG9yeSBlbnRyaWVzIGFyZSB0aGUgYmxvY2sgY29udGFpbnMu
Li4uCgpCYXNlZCBvbiB0aGUgeGZzLWRiIG91dHB1dCwgdGhlc2Ugd2FybmluZ3MgYXJlIG5vdCBy
ZWxhdGVkIHRvIHRoZQpwcm9ibGVtIHlvdSBhcmUgc2VlaW5nLiBJdCdzIGxpa2VseSBqdXN0IGEg
cmVzdWx0IG9mIHJlYWRhaGVhZCBiZWluZwpjYW5jZWxsZWQgZHVlIHRvIGxvYWQsIGFuZCB0aGUg
ZXJyb3Igc2V0IGJ5IHRoZSBETSBsYXllciBub3QgYmVpbmcKaGFuZGxlZCBwcm9wZXJseS4KClNv
LCB5b3UgbmVlZCB0byBmaW5kIHRoZSBpbm9kZSBudW1iZXIgb2YgYSBkaXJlY3Rvcnkgd2l0aCBh
IGNvcnJ1cHQKZW50cnksIGFuZCBkdW1wIHRoZSBpbm9kZSBhbmQgYW55IGRhdGEgZm9yayBibG9j
a3MgdGhhdCBpdCBiZWxvbmdzCnRvIHdpdGggeGZzX2RiIHNpbWlsYXIgdG8gd2hhdCB5b3UgaGF2
ZSBqdXN0IGRvbmUuIAoKQ2hlZXJzLAoKRGF2ZS4KLS0gCkRhdmUgQ2hpbm5lcgpkYXZpZEBmcm9t
b3JiaXQuY29tCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Xwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFp
bG1hbi9saXN0aW5mby94ZnMK
