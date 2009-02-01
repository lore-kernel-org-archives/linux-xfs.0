Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n110gnRM139687 for <xfs@oss.sgi.com>; Sat, 31 Jan 2009 18:42:50 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BCDA818A03ED
	for <xfs@oss.sgi.com>; Sat, 31 Jan 2009 16:42:08 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	4kgvaeDY7pFXBDop for <xfs@oss.sgi.com>;
	Sat, 31 Jan 2009 16:42:08 -0800 (PST)
Date: Sun, 1 Feb 2009 11:37:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS Kernel 2.6.27.7 oopses
Message-ID: <20090201003744.GB24173@disturbed>
References: <20090130222359.GB32142@theco.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090130222359.GB32142@theco.de>
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
To: Ralf Liebenow <ralf@theco.de>
Cc: xfs@oss.sgi.com

T24gRnJpLCBKYW4gMzAsIDIwMDkgYXQgMTE6MjM6NTlQTSArMDEwMCwgUmFsZiBMaWViZW5vdyB3
cm90ZToKPiBIZWxsbyAhCj4gCj4gSSBoZWF2aWx5IHVzZSBYRlMgZm9yIGFuIGluY3JlbWVudGFs
IGJhY2t1cCBzZXJ2ZXIgKGJ5IHVzaW5nIHJzeW5jIC0tbGluay1kZXN0IG9wdGlvbgo+IHRvIGNy
ZWF0ZSBoYXJkbGlua3MgdG8gdW5jaGFuZ2VkIGZpbGVzKSwgYW5kIHRoZXJlZm9yZSBoYXZlIGFi
b3V0IDEwIG1pbGxpb24gZmlsZXMKPiBvbiBteSBUQiBIYXJkZGlzay4gVG8gcmVtb3ZlIG9sZCB2
ZXJzaW9ucyBuaWdodGx5IGFuICJybSAtcmYiIHdpbGwgcmVtb3ZlIGEgbWlsbGlvbgo+IGhhcmRs
aW5rcy9maWxlcyBldmVyeSBuaWdodC4KPiAKPiBBZnRlciBhIHdoaWxlIEkgaGFkIHJlZ3VsYXIg
b29wc2VzIGFuZCBzbyBJIHVwZGF0ZWQgdGhlIHN5c3RlbSB0byBtYWtlIHN1cmUgaXRzCj4gb24g
YSBjdXJyZW50IHZlcnNpb24uCj4gCj4gSXQgaXMgbm93IGEgU3VTRSAxMS4xIDY0Qml0IHdpdGgg
U3VTRSdzIEtlcm5lbCAyLjYuMjcuNy05LWRlZmF1bHQKCldoYXQga2VybmVsIGRpZCB5b3Ugb3Jp
Z2luYWxseSBzZWUgdGhpcyBwcm9ibGVtIG9uPwoKPiA8ND5DYWxsIFRyYWNlOgo+IDw0PiBbPGZm
ZmZmZmZmODAyMzIxOWE+XSBjb21wbGV0ZSsweDM4LzB4NGIKPiA8ND4gWzxmZmZmZmZmZmEwMGY1
MzE2Pl0geGZzX2lmbHVzaCsweDczLzB4MmFiIFt4ZnNdCj4gPDQ+IFs8ZmZmZmZmZmZhMDEwYTdh
Mj5dIHhmc19maW5pc2hfcmVjbGFpbSsweDEyYS8weDE2OCBbeGZzXQo+IDw0PiBbPGZmZmZmZmZm
YTAxMGE4NzE+XSB4ZnNfZmluaXNoX3JlY2xhaW1fYWxsKzB4OTEvMHhjYiBbeGZzXQo+IDw0PiBb
PGZmZmZmZmZmYTAxMDkyNWM+XSB4ZnNfc3luY3N1YisweDUwLzB4MjJiIFt4ZnNdCj4gPDQ+IFs8
ZmZmZmZmZmZhMDExOGEzYT5dIHhmc19zeW5jX3dvcmtlcisweDE3LzB4MzYgW3hmc10KPiA8ND4g
WzxmZmZmZmZmZmEwMTE4OWQ0Pl0geGZzc3luY2QrMHgxNWQvMHgxYWMgW3hmc10KPiA8ND4gWzxm
ZmZmZmZmZjgwMjU0MzRkPl0ga3RocmVhZCsweDQ3LzB4NzMKPiA8ND4gWzxmZmZmZmZmZjgwMjBk
N2I5Pl0gY2hpbGRfcmlwKzB4YS8weDExCgpUaGF0IG1heSBiZSBhIHVzZSBhZnRlciBmcmVlLiBJ
IGtub3cgbGFjaGxhbiBmaXhlZCBhIGZldyBpbiB0aGlzCmFyZWEsIGJ1dCBJJ20gbm90IHN1cmUg
d2hhdCByZWxlYXNlIHRob3NlIGZpeGXRlSBlbmRlZCB1cCBpbi4uLi4KCj4gV2hhdCBkbyB5b3Ug
cmVjb21tZW5kID8gSGFzIHRoaXMgYnVnIGFscmVhZHkgYmVlbiBhZGRyZXNzZWQgd2l0aGluIHRo
ZQo+IGh1bmRyZXRzIG9mIGZpeGVzIEkndmUgc2VlbiBvbiB0aGUgbWFpbGluZyBsaXN0ID8gU2hh
bGwgSSB0cnkgYSBzdG9jayAyLjYuMjgKPiBrZXJuZWwgPwoKVHJ5IHRoZSBsYXN0ZXN0IDIuNi4y
OC54IHN0YWJsZSBrZXJuZWwgKCpub3QqIHRoZSBzdHJhaWdodCAyLjYuMjggcmVsZWFzZQphcyB0
aGVyZSdzIGEgZGlyZWN0b3J5IHRyYXZlcnNhbCBidWcgdGhhdCBpcyBmaXhlZCBpbiAyLjYuMjgu
MSkgYW5kCnNlZSBpZiB0aGUgcHJvYmxlbSBwZXJzaXN0cy4KCkNoZWVycywKCkRhdmUuCi0tIApE
YXZlIENoaW5uZXIKZGF2aWRAZnJvbW9yYml0LmNvbQoKX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20K
aHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
