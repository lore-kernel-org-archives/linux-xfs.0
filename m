Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C97567F87
	for <xfs@oss.sgi.com>; Tue,  7 Apr 2015 23:50:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 43C36AC003
	for <xfs@oss.sgi.com>; Tue,  7 Apr 2015 21:50:00 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	DMXBBfBunyoOyogC for <xfs@oss.sgi.com>;
	Tue, 07 Apr 2015 21:49:58 -0700 (PDT)
Date: Wed, 8 Apr 2015 14:49:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS direct IO problem
Message-ID: <20150408044955.GE15810@dastard>
References: <tencent_316A3DE769544D99766FE3F1@qq.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <tencent_316A3DE769544D99766FE3F1@qq.com>
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
To: YeYin <eyniy@qq.com>
Cc: xfs <xfs@oss.sgi.com>

T24gV2VkLCBBcHIgMDgsIDIwMTUgYXQgMTI6MjE6NDVQTSArMDgwMCwgWWVZaW4gd3JvdGU6Cj4g
SGksIEFib3V0IDIgbW9udGhzIGFnbywgSSBhc2tlZCBvbmUgcHJvYmxlbSBpbiBYRlMsIHNlZQo+
IGhlcmUoaHR0cDovL29zcy5zZ2kuY29tL2FyY2hpdmVzL3hmcy8yMDE1LTAyL21zZzAwMTk3Lmh0
bWwpLgo+IAo+IAo+IEFmdGVyIHRoYXQsIEkgdXNlIGRpcmVjdCBJTyBpbiBNeVNRTCwgc2VlCj4g
aGVyZShodHRwczovL2Rldi5teXNxbC5jb20vZG9jL3JlZm1hbi81LjUvZW4vaW5ub2RiLXBhcmFt
ZXRlcnMuaHRtbCNzeXN2YXJfaW5ub2RiX2ZsdXNoX21ldGhvZCku4oCNCj4gCj4gCj4gSG93ZXZl
ciwgSSBmb3VuZCB0aGF0IE15U1FMIHBlcmZvcm1hbmNlIGlzIHN0aWxsIHBvb3Igc29tZXRpbWVz
LiBJCj4gdXNlIHNvbWUgdG9vbHMoaHR0cHM6Ly9naXRodWIuY29tL2JyZW5kYW5ncmVnZy9wZXJm
LXRvb2xz4oCNKSB0bwo+IHRyYWNlIHRoZSBrZXJuZWwsIEkgZm91bmQgc29tZSBwcm9ibGVtczoK
CjxzbmlwPgoKPiBUaGlzIHdpbGwgY2F1c2UgYmFkIHBlcmZvcm1hbmNlLCBldmVuIGRpcmVjdCBJ
Ty4gSSBzdGlsbCBkb24ndAo+IHVuZGVyc3RhbmQgd2h5IG5vdCB0cnVuY2F0ZV9pbm9kZV9wYWdl
IGNhbGxlZD8KCkJlY2F1c2UgdGhlIGNhY2hlZCBwYWdlIG11c3QgYmUgb3V0c2lkZSB0aGUgcmFu
Z2Ugb2YgdGhlIGRpcmVjdCBJTwp0aGF0IGlzIGluIHByb2dyZXNzIC0gZGlyZWN0IElPIG9ubHkg
dHJpZXMgdG8gZmx1c2ggcGFnZXMgb3ZlciB0aGUKcmFuZ2UgaXQgaXMgZG9pbmcgdGhlIElPIG92
ZXIuCgo+IEV2ZXJ5IHRpbWUsIGFmdGVyIEkgcnVuIHRoaXM6IGVjaG8gMSA+IC9wcm9jL3N5cy92
bS9kcm9wX2NhY2hlcwo+IAo+IEltbWVkaWF0ZWx5IGVuaGFuY2UgcGVyZm9ybWFuY2UuCgpCZWNh
dXNlIHRoYXQgZmx1c2hlcyB3aGF0ZXZlciBwYWdlIGlzIGluIHRoZSBjYWNoZS4gQ2FuIHlvdSBp
ZGVudGlmeQp3aGF0IG9mZnNldCB0aGF0IGNhY2hlZCBwYWdlIGlzIGF0PyBUcmFjaW5nIHRoZSB4
ZnMgZXZlbnRzIHdpbGwgdGVsbAp5b3Ugd2hhdCBwYWdlcyB0aGF0IG9wZXJhdGlvbiBpbnZhbGlk
YXRlcyBvbiBlYWNoIGlub2RlLCBhbmQga25vd2luZwp0aGUgb2Zmc2V0IG1heSB0ZWxsIHVzIHdo
eSB0aGF0IHBhZ2UgaXMgbm90IGdldHRpbmcgZmx1c2hlZC4KCkFsdGVybmF0aXZlbHksIHdyaXRl
IGEgc2ltcGxlIEMgcHJvZ3JhbSB0aGF0IGRlb21uc3RyYXRlcyB0aGUgc2FtZQpwcm9ibGVtIHNv
IHdlIGNhbiByZXByb2R1Y2UgaXQgZWFzaWx5LCBmaXggdGhlIHByb2JsZW0gYW5kIHR1cm4gaXQK
aW50byBhIHJlZ3Jlc3Npb24gdGVzdC4uLi4KCkNoZWVycywKCkRhdmUuCi0tIApEYXZlIENoaW5u
ZXIKZGF2aWRAZnJvbW9yYml0LmNvbQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29z
cy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
