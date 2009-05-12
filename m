Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4CFbwS5081185 for <xfs@oss.sgi.com>; Tue, 12 May 2009 10:37:58 -0500
Received: from yw-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2C31C27D3F2
	for <xfs@oss.sgi.com>; Tue, 12 May 2009 08:38:03 -0700 (PDT)
Received: from yw-out-1718.google.com (yw-out-1718.google.com [74.125.46.153])
	by cuda.sgi.com with ESMTP id BMAicL1NJSBnP7ij for
	<xfs@oss.sgi.com>; Tue, 12 May 2009 08:38:03 -0700 (PDT)
Received: by yw-out-1718.google.com with SMTP id 5so23934ywm.32
	for <xfs@oss.sgi.com>; Tue, 12 May 2009 08:38:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87ljp2v6vt.fsf@tac.ki.iif.hu>
References: <874ovws94s.fsf@tac.ki.iif.hu> <87ljp2v6vt.fsf@tac.ki.iif.hu>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Tue, 12 May 2009 08:37:43 -0700
Message-ID: <2c0942db0905120837g702b457bm52a412293925021a@mail.gmail.com>
Subject: Re: mmap vs mtime in 2.6.26 and up
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
To: Ferenc Wagner <wferi@niif.hu>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org

KEFkZGluZyBDaHJpc3RvcGggSGVsbHdpZywgeGZzIGxpc3QsIEFuZHJldyBNb3J0b24gdG8gY2M6
KQoKT24gVHVlLCBNYXkgMTIsIDIwMDkgYXQgNTozMiBBTSwgRmVyZW5jIFdhZ25lciA8d2ZlcmlA
bmlpZi5odT4gd3JvdGU6Cj4gSGksCj4KPiBJJ3ZlIG5vdGljZWQgdGhhdCB0aGUgbGFzdCBtb2Rp
ZmljYXRpb24gdGltZXMgb2Ygb3VyIFJSRCBmaWxlcyBnb3QKPiBzdHVjayBhZnRlciB1cGdyYWRp
bmcgZnJvbSAyLjYuMjQgdG8gMi42LjI2IChEZWJpYW4gRXRjaCAtPiBMZW5ueTsgSQo+IGFsc28g
dGVzdGVkIHdpdGggMi42LjMwLXJjNSwgdGhleSBhcmUgc3RpbGwgc3R1Y2spLiDCoEl0IGhhcyBz
b21lCj4gbGl0ZXJhdHVyZSwgbW9zdCBub3RhYmx5IGtlcm5lbCBidWcgIzI2NDUsIGJ1dCB0aGF0
J3MgY2xvc2VkIGxvbmcgYWdvCj4gYW5kIHRoZSByZXN1bHRpbmcgcGF0Y2ggaHR0cDovL2xrbWwu
b3JnL2xrbWwvMjAwOC8xLzIyLzM3MCBpcyBwcmVzZW50Cj4gaW4gbXkga2VybmVscy4gwqBTdGls
bCwgdGhlIHRlc3QgcHJvZ3JhbSAodmVyc2lvbiAzIGZyb20gdGhlIGJ1ZyByZXBvcnQpCj4gZ2l2
ZXMgZmFpbHVyZXM6Cj4KPiAkIC4vbW1hcF90ZXN0IGp1bmsKPiBNb2RpZnlpbmcganVuay4uLgo+
IEZsdXNoaW5nIGRhdGEgdXNpbmcgc3luYygpLi4uCj4gRmFpbHVyZTogdGltZSBub3QgY2hhbmdl
ZC4KPiBOb3QgbW9kaWZ5aW5nIGp1bmsuLi4KPiBGbHVzaGluZyBkYXRhIHVzaW5nIG1zeW5jKCku
Li4KPiBTdWNjZXNzOiB0aW1lIG5vdCBjaGFuZ2VkLgo+IE5vdCBtb2RpZnlpbmcganVuay4uLgo+
IEZsdXNoaW5nIGRhdGEgdXNpbmcgZnN5bmMoKS4uLgo+IFN1Y2Nlc3M6IHRpbWUgbm90IGNoYW5n
ZWQuCj4gTW9kaWZ5aW5nIGp1bmsuLi4KPiBGbHVzaGluZyBkYXRhIHVzaW5nIG1zeW5jKCkuLi4K
PiBGYWlsdXJlOiB0aW1lIG5vdCBjaGFuZ2VkLgo+IE1vZGlmeWluZyBqdW5rLi4uCj4gRmx1c2hp
bmcgZGF0YSB1c2luZyBmc3luYygpLi4uCj4gRmFpbHVyZTogdGltZSBub3QgY2hhbmdlZC4KPgo+
IElzIHRoaXMgYXMgZXhwZWN0ZWQ/IMKgSSByZWNrb24gdGhlIGJ1ZyB3YXNuJ3Qgc29sdmVkIGZ1
bGx5LCBidXQgaXQKPiBzZWVtcyB0byBiZSB3b3JzZSB0aGF0IHRoYXQuCgoKSSBkb24ndCB0aGlu
ayB0aGF0J3MgZXhwZWN0ZWQuIEZ1cnRoZXIsIHRoZSB0ZXN0IHByb2dyYW0gKHYzKSBmcm9tCnRo
YXQgYnVnemlsbGEgaHR0cDovL2J1Z3ppbGxhLmtlcm5lbC5vcmcvc2hvd19idWcuY2dpP2lkPTI2
NDUgd29ya3MKZm9yIG1lIHVuZGVyIGV4dDMsIHNvIHBlcmhhcHMgdGhpcyBpcyBhbiB4ZnMtc3Bl
Y2lmaWMgaXNzdWUuCgoKPgo+IEkgZG9uJ3Qga25vdyBpZiBpdCdzIHJlbGF0ZWQgb3Igbm90LCBi
dXQgYW5vdGhlciBhbm9tYWx5IGFwcGVhcmVkCj4gYWZ0ZXIgdGhlIHVwZ3JhZGU6IG1pbnV0ZXMt
bG9uZyByZW1vdW50IHRpbWVzLiDCoFRoZSBtYWNoaW5lIGFsd2F5cyB3YXMKPiB1bmRlciBhIGZh
aXIgbG9hZCAoMTApLCBidXQgbW91bnQgL3VzciAtb3JlbW91bnQscncgbmV2ZXIgdG9vawo+IG5v
dGljZWFibGUgdGltZS4gwqBUaGUgSU8gbG9hZCBwdXNoZXMgdHdvIG90aGVyIGZpbGVzeXN0ZW1z
LiDCoE5vdwo+IHN0cmFjZSAtdHQgc2hvd3M6Cj4KPiBbLi4uXQo+IDAxOjI0OjA4LjQ2MzgxMyBz
dGF0NjQoIi9zYmluL21vdW50LnhmcyIsIDB4YmZhNDBlYjApID0gLTEgRU5PRU5UIChObyBzdWNo
IGZpbGUgb3IgZGlyZWN0b3J5KQo+IDAxOjI0OjA4LjQ2MzkwNCBtb3VudCgiL2Rldi9tYXBwZXIv
bm9jNy11c3IiLCAiL3VzciIsIDB4ODk0YTJjOCwgTVNfTUdDX1ZBTHxNU19OT0RFVnxNU19SRU1P
VU5ULCBOVUxMKSA9IDAKPiAwMToyNjo1OC43MDUzODcgcmVhZGxpbmsoIi9kZXYiLCAweGJmYTNl
ZjNiLCA0MDk2KSA9IC0xIEVJTlZBTCAoSW52YWxpZCBhcmd1bWVudCkKPiBbLi4uXQo+Cj4gQWZ0
ZXIgdGhpcywgcmVtb3VudCBybyBhbmQgcncgYWdhaW4gYXJlIHF1aWNrIGZvciBzb21lIHRpbWUu
Cj4gKEkgY291bGRuJ3QgdGVzdCB0aGlzIHBhcnQgd2l0aCAyLjYuMzAtcmM1LCBidXQgYWdhaW4s
IHRoaXMgbWF5IGJlCj4gdG90YWxseSB1bnJlbGF0ZWQuKQo+Cj4gVGhpcyBidWcgaXMgcXVpdGUg
c2VyaW91cyBpbiBvdXIgZW52aXJvbm1lbnQsIGFzIGl0IHRod2FydHMgdGhlIGJhY2t1cAo+IHNv
ZnR3YXJlLiDCoFRoZSBmaWxlIHN5c3RlbSBpcyB4ZnM7IHJ3LG5vc3VpZCxub2Rldixub2JhcnJp
ZXIsbm9xdW90YS4KPiAtLQo+IFJlZ2FyZHMsCj4gRmVyaS4KCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2ku
Y29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
