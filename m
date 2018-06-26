Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from g9t1613g.houston.hpe.com ([15.241.32.99]:39096 "EHLO
        g9t1613g.houston.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751989AbeFZUy2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jun 2018 16:54:28 -0400
From: "Kani, Toshi" <toshi.kani@hpe.com>
Subject: Re: [PATCH v3 1/3] pmem: only set QUEUE_FLAG_DAX for fsdax mode
Date: Tue, 26 Jun 2018 20:54:03 +0000
Message-ID: <1530046327.14039.273.camel@hpe.com>
References: <20180626175932.8899-1-ross.zwisler@linux.intel.com>
         <20180626175932.8899-2-ross.zwisler@linux.intel.com>
         <CAPcyv4iWgPnHmBKhUvhManC6UL9CkLqN_d8vBo6KmcPJdPzuUw@mail.gmail.com>
         <20180626185830.GA7171@redhat.com>
         <CAPcyv4h6HO6fs6k7QMD77jkz2djCeWCtWomCdNb0-1Q4VKanqw@mail.gmail.com>
         <20180626191346.GA7233@redhat.com>
In-Reply-To: <20180626191346.GA7233@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <3D1889CB4901114A9FD8D1212F7DAD23@NAMPRD84.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

T24gVHVlLCAyMDE4LTA2LTI2IGF0IDE1OjEzIC0wNDAwLCBNaWtlIFNuaXR6ZXIgd3JvdGU6DQo+
IE9uIFR1ZSwgSnVuIDI2IDIwMTggYXQgIDM6MDdwbSAtMDQwMCwNCj4gRGFuIFdpbGxpYW1zIDxk
YW4uai53aWxsaWFtc0BpbnRlbC5jb20+IHdyb3RlOg0KPiANCj4gPiBPbiBUdWUsIEp1biAyNiwg
MjAxOCBhdCAxMTo1OCBBTSwgTWlrZSBTbml0emVyIDxzbml0emVyQHJlZGhhdC5jb20+IHdyb3Rl
Og0KPiA+ID4gT24gVHVlLCBKdW4gMjYgMjAxOCBhdCAgMjo1MnBtIC0wNDAwLA0KPiA+ID4gRGFu
IFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+IHdyb3RlOg0KPiA+ID4gDQo+ID4g
PiA+IE9uIFR1ZSwgSnVuIDI2LCAyMDE4IGF0IDEwOjU5IEFNLCBSb3NzIFp3aXNsZXINCj4gPiA+
ID4gPHJvc3Muendpc2xlckBsaW51eC5pbnRlbC5jb20+IHdyb3RlOg0KPiA+ID4gPiA+IFFVRVVF
X0ZMQUdfREFYIGlzIGFuIGluZGljYXRpb24gdGhhdCBhIGdpdmVuIGJsb2NrIGRldmljZSBzdXBw
b3J0cw0KPiA+ID4gPiA+IGZpbGVzeXN0ZW0gREFYIGFuZCBzaG91bGQgbm90IGJlIHNldCBmb3Ig
UE1FTSBuYW1lc3BhY2VzIHdoaWNoIGFyZSBpbiAicmF3Ig0KPiA+ID4gPiA+IG9yICJzZWN0b3Ii
IG1vZGVzLiAgVGhlc2UgbmFtZXNwYWNlcyBsYWNrIHN0cnVjdCBwYWdlIGFuZCBhcmUgcHJldmVu
dGVkDQo+ID4gPiA+ID4gZnJvbSBwYXJ0aWNpcGF0aW5nIGluIGZpbGVzeXN0ZW0gREFYLg0KPiA+
ID4gPiA+IA0KPiA+ID4gPiA+IFNpZ25lZC1vZmYtYnk6IFJvc3MgWndpc2xlciA8cm9zcy56d2lz
bGVyQGxpbnV4LmludGVsLmNvbT4NCj4gPiA+ID4gPiBTdWdnZXN0ZWQtYnk6IE1pa2UgU25pdHpl
ciA8c25pdHplckByZWRoYXQuY29tPg0KPiA+ID4gPiA+IENjOiBzdGFibGVAdmdlci5rZXJuZWwu
b3JnDQo+ID4gPiA+IA0KPiA+ID4gPiBXaHkgaXMgdGhpcyBjYzogc3RhYmxlPyBXaGF0IGlzIHRo
ZSB1c2VyIHZpc2libGUgaW1wYWN0IG9mIHRoaXMgY2hhbmdlDQo+ID4gPiA+IGVzcGVjaWFsbHkg
Z2l2ZW4gdGhlIHJlcXVpcmVtZW50IHRvIHZhbGlkYXRlIFFVRVVFX0ZMQUdfREFYIHdpdGgNCj4g
PiA+ID4gYmRldl9kYXhfc3VwcG9ydGVkKCk/IFBhdGNoIGxvb2tzIGdvb2QsIGJ1dCBpdCdzIGp1
c3QgYSBjb3NtZXRpYyBmaXh1cA0KPiA+ID4gPiBhZmFpY3MuDQo+ID4gPiANCj4gPiA+IFRoaXMg
aXNuJ3QgY29zbWV0aWMgd2hlbiB5b3UgY29uc2lkZXIgdGhhdCBzdGFja2luZyB1cCBhIERNIGRl
dmljZSBpcw0KPiA+ID4gbG9va2luZyBhdCB0aGlzIGZsYWcgdG8gZGV0ZXJtaW5lIHdoZXRoZXIg
YSB0YWJsZSBkb2VzIG9yIGRvZXMgX25vdF8NCj4gPiA+IHN1cHBvcnQgREFYLg0KPiA+ID4gDQo+
ID4gPiBTbyB0aGlzIHBhdGNoLCBpbiBjb25qdW5jdGlvbiB3aXRoIHRoZSBvdGhlciBjaGFuZ2Vz
IGluIHRoZSBzZXJpZXMsIGlzDQo+ID4gPiBjZXJ0YWlubHkgc29tZXRoaW5nIEknZCBjb25zaWRl
ciBhcHByb3ByaWF0ZSBmb3Igc3RhYmxlLg0KPiA+IA0KPiA+IEkgdGhpbmsgdGhpcyBjbGFzc2lm
aWVzIGFzIHNvbWV0aGluZyB0aGF0IG5ldmVyIHdvcmtlZCBjb3JyZWN0bHkgYW5kDQo+ID4gaXMg
bm90IGEgcmVncmVzc2lvbi4gSXQgZG9lcyBub3QgaWRlbnRpZnkgd2hpY2ggY29tbWl0IGl0IGlz
IHJlcGFpcmluZw0KPiA+IG9yIHRoZSB1c2VyIHZpc2libGUgZmFpbHVyZSBtb2RlLg0KPiANCj4g
U28geW91J3JlIHRha2luZyBpc3N1ZSB3aXRoIG1ha2luZyBzdGFja2VkIGRheCBjb25maWdzIHdv
cmsgaW4gb2xkZXINCj4ga2VybmVscz8gIFRoYXQncyBmaW5lLiAgV2UgY2FuIGRyb3AgdGhlIHN0
YWJsZSBjYyBpZiB5b3UgbGlrZS4NCj4gDQo+IEJ1dCBJIG1lYW4gd2UgaW50ZW5kZWQgZm9yIHRo
aXMgdG8gd29yay4uIHNvIHRoZSBGaXhlcyBjb21taXQgcmVmZXJlbmNlcw0KPiBjYW4gZWFzaWx5
IGJlIGFkZGVkLCBlLmcuOiA1NDVlZDIwZTZkZjY4YTRkMjU4NGEyOWEyYTI4ZWU4YjJmN2U5NTQ3
DQo+ICgiZG06IGFkZCBpbmZyYXN0cnVjdHVyZSBmb3IgREFYIHN1cHBvcnQiKQ0KDQpXaGVuIHRo
aXMgZG0gY2hhbmdlIHdhcyBtYWRlLCB0aGUgcG1lbSBkcml2ZXIgc3VwcG9ydGVkIERBWCBmb3Ig
Ym90aCByYXcNCmFuZCBtZW1vcnkgbW9kZXMgKG5vdGU6IHNlY3RvciBtb2RlIGRvZXMgbm90IHVz
ZSB0aGUgcG1lbSBkcml2ZXIpLiAgSQ0KdGhpbmsgdGhlIGlzc3VlIHdhcyBpbnRyb2R1Y2VkIHdo
ZW4gd2UgZHJvcHBlZCBEQVggc3VwcG9ydCBmcm9tIHJhdw0KbW9kZS4NCg0KVGhhbmtzLA0KLVRv
c2hpDQoNCg==
