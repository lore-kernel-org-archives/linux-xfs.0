Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CB50029DFA
	for <xfs@oss.sgi.com>; Wed, 10 Apr 2013 07:52:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4915DAC002
	for <xfs@oss.sgi.com>; Wed, 10 Apr 2013 05:52:47 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	oXZ6NNCTNBC7DRye for <xfs@oss.sgi.com>;
	Wed, 10 Apr 2013 05:52:45 -0700 (PDT)
Date: Wed, 10 Apr 2013 22:52:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: need help how to debug xfs crash issue xfs_iunlink_remove:
	xfs_inotobp() returned error 22
Message-ID: <20130410125242.GB10481@dastard>
References: <CADFMGuJm5bPPwbbUtYwrCVDL23KExJTw_-VRX2UEEdZjo+i5oA@mail.gmail.com>
	<CADFMGu+=MM2yc=_peboV7JTNJ8F05TJfexmEErzcf0D8mAWFRg@mail.gmail.com>
	<CADFMGuKqkPbpcU=taqjTR4sA3o=w1LLAnKoEuj=OhJqEbQVijw@mail.gmail.com>
	<20130409145238.GE22182@sgi.com>
	<CADFMGuJaiH0wuxOHrDjDn7qRVH+vQkLOOSPUyqSdXnLcS47t3w@mail.gmail.com>
	<CADFMGu+TdyjTjMTWMwpdHqmszhpCU162UA4Y-njARwSEjM1xNw@mail.gmail.com>
	<20130410121025.78a42b22@harpe.intellique.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130410121025.78a42b22@harpe.intellique.com>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Ben Myers <bpm@sgi.com>, =?utf-8?B?56ym5rC45rab?= <yongtaofu@gmail.com>, xfs@oss.sgi.com

T24gV2VkLCBBcHIgMTAsIDIwMTMgYXQgMTI6MTA6MjVQTSArMDIwMCwgRW1tYW51ZWwgRmxvcmFj
IHdyb3RlOgo+IExlIFR1ZSwgOSBBcHIgMjAxMyAyMzoxMDowMyArMDgwMAo+IOespuawuOa2myA8
eW9uZ3Rhb2Z1QGdtYWlsLmNvbT4gw6ljcml2YWl0Ogo+IAo+ID4gPiBBcHIgIDkgMTE6MDE6MzAg
Y3FkeCBrZXJuZWw6IFhGUyAoc2RiKTogSS9PIEVycm9yIERldGVjdGVkLgo+ID4gPiBTaHV0dGlu
ZyBkb3duIGZpbGVzeXN0ZW0KPiAKPiBUaGlzLiBJL08gZXJyb3IgZGV0ZWN0ZWQuIFRoYXQgbWVh
bnMgdGhhdCBhdCBzb21lIHBvaW50IHRoZSB1bmRlcmx5aW5nCj4gZGV2aWNlIChkaXNrLCBSQUlE
IGFycmF5LCBTQU4gdm9sdW1lKSBjb3VsZG4ndCBiZSByZWFjaGVkLiBTbyB0aGlzCj4gY291bGQg
dmVyeSB3ZWxsIGJlIGEgY2FzZSBvZiBhIGZsYWtleSBkcml2ZSwgYXJyYXksIGNhYmxlIG9yIFND
U0kKPiBkcml2ZXIuCgpZb3UgY2FuJ3QgdGFrZSB0aGF0IG9uZSBsaW5lIG9mIG91dHB1dCBvdXQg
b2YgY29udGV4dCBhbmQgdGhlbiBzYXkKaXQncyBhIGhhcmR3YXJlIHByb2JsZW0gLSB0aGF0J3Mg
YSBnZW5lcmljIElPLWVycm9yLWNhdXNlcy1zaHV0ZG93bgptZXNzYWdlLCBub3QgYW4gRUlPIGZy
b20gdGhlIHN0b3JhZ2Ugc3RhY2suCgpUaGUgRUlOVkFMIGVycm9yIHRoYXQgaXMgcmVwb3J0ZWQg
YmVmb3JlIHRoaXMgaXMgdGhlIGNhdXNlIG9mIHRoZQpzaHV0ZG93biwgYW5kIHRoYXQgaXMgZnJv
bSBhIGNvcnJ1cHRlZCB1bmxpbmtlZCBsaXN0LiBFSU5WQUwKaW5kaWNhdGVzIHRoYXQgd2UgYXJl
IGZhbGxpbmcgb2ZmIHRoZSBlbmQgb2YgdGhlIHVubGlua2VkIGxpc3QKd2l0aG91dCBmaW5kaW5n
IHRoZSBpbm9kZSB0aGF0IHdlIGFyZSB0cnlpbmcgdG8gcmVtb3ZlIGZyb20gdGhlCnVubGlua2Vk
IGxpc3QuIERlYnVnIGtlcm5lbHMgd2lsbCBhc3NlcnQgZmFpbCBhdCB0aGlzIHBvaW50LgoKV2hh
dCBjYXVzZXMgdGhhdCBwcm9ibGVtIGlzIHN0aWxsIHVua25vd24uIE5vYm9keSBoYXMgYmVlbiBh
YmxlIHRvCmlzb2xhdGUgdGhlIHJlcHJvZHVjZXIsIHNvIHByb2dyZXNzIGlzIHNsb3cuIElmIHNv
bWVvbmUgY2FuIGdpdmUgbWUKYSBzY3JpcHQgdGhhdCByZXByb2RjdWVzIGl0IGRpcmVjdGx5IG9u
IFhGUyAoaS5lIG5vIGdsdXN0ZXIpLCB0aGVuCml0IHdvbid0IHRha2UgbG9uZyB0byBmaW5kIHRo
ZSBidWcuLi4uCgpDaGVlcnMsCgpEYXZlLgotLSAKRGF2ZSBDaGlubmVyCmRhdmlkQGZyb21vcmJp
dC5jb20KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhm
cyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFu
L2xpc3RpbmZvL3hmcwo=
