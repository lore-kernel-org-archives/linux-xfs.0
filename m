Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 015127CA0
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 11:54:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9D9F8304059
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 09:54:52 -0700 (PDT)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20]) by
	cuda.sgi.com with ESMTP id sYuXlanxq8a8aDQF for
	<xfs@oss.sgi.com>; Fri, 15 Apr 2016 09:54:51 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v2 5/5] dax: handle media errors in dax_do_io
Date: Fri, 15 Apr 2016 16:54:48 +0000
Message-ID: <1460739288.3012.3.camel@intel.com>
References: <1459303190-20072-1-git-send-email-vishal.l.verma@intel.com>
	<1459303190-20072-6-git-send-email-vishal.l.verma@intel.com>
	<x49twj26edj.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49twj26edj.fsf@segfault.boston.devel.redhat.com>
Content-Language: en-US
Content-ID: <16063EC031B1C2489B91594D65C22F50@intel.com>
MIME-Version: 1.0
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
To: "jmoyer@redhat.com" <jmoyer@redhat.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "jack@suse.cz" <jack@suse.cz>, "axboe@fb.com" <axboe@fb.com>, "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "Wilcox,
	Matthew R" <matthew.r.wilcox@intel.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>

T24gRnJpLCAyMDE2LTA0LTE1IGF0IDEyOjExIC0wNDAwLCBKZWZmIE1veWVyIHdyb3RlOg0KPiBW
aXNoYWwgVmVybWEgPHZpc2hhbC5sLnZlcm1hQGludGVsLmNvbT4gd3JpdGVzOg0KPiANCj4gPiAN
Cj4gPiBkYXhfZG9faW8gKGNhbGxlZCBmb3IgcmVhZCgpIG9yIHdyaXRlKCkgZm9yIGEgZGF4IGZp
bGUgc3lzdGVtKSBtYXkNCj4gPiBmYWlsDQo+ID4gaW4gdGhlIHByZXNlbmNlIG9mIGJhZCBibG9j
a3Mgb3IgbWVkaWEgZXJyb3JzLiBTaW5jZSB3ZSBleHBlY3QgdGhhdA0KPiA+IGENCj4gPiB3cml0
ZSBzaG91bGQgY2xlYXIgbWVkaWEgZXJyb3JzIG9uIG52ZGltbXMsIG1ha2UgZGF4X2RvX2lvIGZh
bGwNCj4gPiBiYWNrIHRvDQo+ID4gdGhlIGRpcmVjdF9JTyBwYXRoLCB3aGljaCB3aWxsIHNlbmQg
ZG93biBhIGJpbyB0byB0aGUgZHJpdmVyLCB3aGljaA0KPiA+IGNhbg0KPiA+IHRoZW4gYXR0ZW1w
dCB0byBjbGVhciB0aGUgZXJyb3IuDQo+IFtzbmlwXQ0KPiANCj4gPiANCj4gPiArCWlmIChJU19E
QVgoaW5vZGUpKSB7DQo+ID4gKwkJcmV0ID0gZGF4X2RvX2lvKGlvY2IsIGlub2RlLCBpdGVyLCBv
ZmZzZXQsDQo+ID4gYmxrZGV2X2dldF9ibG9jaywNCj4gPiDCoAkJCQlOVUxMLCBESU9fU0tJUF9E
SU9fQ09VTlQpOw0KPiA+IC0JcmV0dXJuIF9fYmxvY2tkZXZfZGlyZWN0X0lPKGlvY2IsIGlub2Rl
LCBJX0JERVYoaW5vZGUpLA0KPiA+IGl0ZXIsIG9mZnNldCwNCj4gPiArCQlpZiAocmV0ID09IC1F
SU8gJiYgKGlvdl9pdGVyX3J3KGl0ZXIpID09IFdSSVRFKSkNCj4gPiArCQkJcmV0X3NhdmVkID0g
cmV0Ow0KPiA+ICsJCWVsc2UNCj4gPiArCQkJcmV0dXJuIHJldDsNCj4gPiArCX0NCj4gPiArDQo+
ID4gKwlyZXQgPSBfX2Jsb2NrZGV2X2RpcmVjdF9JTyhpb2NiLCBpbm9kZSwgSV9CREVWKGlub2Rl
KSwNCj4gPiBpdGVyLCBvZmZzZXQsDQo+ID4gwqAJCQkJwqDCoMKgwqBibGtkZXZfZ2V0X2Jsb2Nr
LCBOVUxMLCBOVUxMLA0KPiA+IMKgCQkJCcKgwqDCoMKgRElPX1NLSVBfRElPX0NPVU5UKTsNCj4g
PiArCWlmIChyZXQgPCAwICYmIHJldF9zYXZlZCkNCj4gPiArCQlyZXR1cm4gcmV0X3NhdmVkOw0K
PiA+ICsNCj4gSG1tLCBkaWQgeW91IGp1c3QgYnJlYWsgYXN5bmMgRElPP8KgwqBJIHRoaW5rIHlv
dSBkaWQhwqDCoDopDQo+IF9fYmxvY2tkZXZfZGlyZWN0X0lPIGNhbiByZXR1cm4gLUVJT0NCUVVF
VUVELCBhbmQgeW91J3ZlIG5vdyB0dXJuZWQNCj4gdGhhdA0KPiBpbnRvIC1FSU8uwqDCoFJlYWxs
eSwgSSBkb24ndCBzZWUgYSByZWFzb24gdG8gc2F2ZSB0aGF0IGZpcnN0DQo+IC1FSU8uwqDCoFRo
ZQ0KPiBzYW1lIGFwcGxpZXMgdG8gYWxsIGluc3RhbmNlcyBpbiB0aGlzIHBhdGNoLg0KDQpUaGUg
cmVhc29uIEkgc2F2ZWQgaXQgd2FzIGlmIF9fYmxvY2tkZXZfZGlyZWN0X0lPIGZhaWxzIGZvciBz
b21lDQpyZWFzb24sIHdlIHNob3VsZCByZXR1cm4gdGhlIG9yaWdpbmFsIGNhdXNlIG8gdGhlIGVy
cm9yLCB3aGljaCB3YXMgYW4NCkVJTy4uIGkuZS4gd2Ugc2hvdWxkbid0IGJlIGhpZGluZyB0aGUg
RUlPIGlmIHRoZSBkaXJlY3RfSU8gZmFpbHMgd2l0aA0Kc29tZXRoaW5nIGVsc2UuLg0KQnV0LCBo
b3cgZG9lcyBfRUlPQ0JRVUVVRUQgd29yaz8gTWF5YmUgd2UgbmVlZCBhbiBleGNlcHRpb24gZm9y
IGl0P8KgDQoNClRoYW5rcywNCgktVmlzaGFsCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6
Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
