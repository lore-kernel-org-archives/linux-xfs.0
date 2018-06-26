Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from g2t1383g.austin.hpe.com ([15.233.16.89]:5979 "EHLO
        g2t1383g.austin.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752203AbeFZVbF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jun 2018 17:31:05 -0400
From: "Kani, Toshi" <toshi.kani@hpe.com>
Subject: Re: [PATCH v3 1/3] pmem: only set QUEUE_FLAG_DAX for fsdax mode
Date: Tue, 26 Jun 2018 21:31:01 +0000
Message-ID: <1530048545.14039.288.camel@hpe.com>
References: <20180626175932.8899-1-ross.zwisler@linux.intel.com>
         <20180626175932.8899-2-ross.zwisler@linux.intel.com>
         <CAPcyv4iWgPnHmBKhUvhManC6UL9CkLqN_d8vBo6KmcPJdPzuUw@mail.gmail.com>
         <20180626185830.GA7171@redhat.com>
         <CAPcyv4h6HO6fs6k7QMD77jkz2djCeWCtWomCdNb0-1Q4VKanqw@mail.gmail.com>
         <20180626191346.GA7233@redhat.com> <1530046327.14039.273.camel@hpe.com>
         <CAPcyv4hP_Y3xdyCa-UkYCMJ5OtnjnkwPZDS2Z2Ge8+5ymBONwQ@mail.gmail.com>
         <1530048093.14039.286.camel@hpe.com>
         <CAPcyv4gXAC7imJs5qfsDNLeN545Rqyd2b1M9s5kr4f9y48LXgQ@mail.gmail.com>
In-Reply-To: <CAPcyv4gXAC7imJs5qfsDNLeN545Rqyd2b1M9s5kr4f9y48LXgQ@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <E691B1B6B1F6B641A12FEB7DF2ED0153@NAMPRD84.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>

T24gVHVlLCAyMDE4LTA2LTI2IGF0IDE0OjI4IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFR1ZSwgSnVuIDI2LCAyMDE4IGF0IDI6MjMgUE0sIEthbmksIFRvc2hpIDx0b3NoaS5rYW5p
QGhwZS5jb20+IHdyb3RlOg0KPiA+IE9uIFR1ZSwgMjAxOC0wNi0yNiBhdCAxNDowMiAtMDcwMCwg
RGFuIFdpbGxpYW1zIHdyb3RlOg0KPiA+ID4gT24gVHVlLCBKdW4gMjYsIDIwMTggYXQgMTo1NCBQ
TSwgS2FuaSwgVG9zaGkgPHRvc2hpLmthbmlAaHBlLmNvbT4gd3JvdGU6DQo+IA0KPiBbLi5dDQo+
ID4gPiA+IFdoZW4gdGhpcyBkbSBjaGFuZ2Ugd2FzIG1hZGUsIHRoZSBwbWVtIGRyaXZlciBzdXBw
b3J0ZWQgREFYIGZvciBib3RoIHJhdw0KPiA+ID4gPiBhbmQgbWVtb3J5IG1vZGVzIChub3RlOiBz
ZWN0b3IgbW9kZSBkb2VzIG5vdCB1c2UgdGhlIHBtZW0gZHJpdmVyKS4gIEkNCj4gPiA+ID4gdGhp
bmsgdGhlIGlzc3VlIHdhcyBpbnRyb2R1Y2VkIHdoZW4gd2UgZHJvcHBlZCBEQVggc3VwcG9ydCBm
cm9tIHJhdw0KPiA+ID4gPiBtb2RlLg0KPiA+ID4gDQo+ID4gPiBTdGlsbCBEQVggd2l0aCByYXcg
bW9kZSBuZXZlciByZWFsbHkgd29ya2VkIGFueSB3YXkuIEl0IHdhcyBhbHNvDQo+ID4gPiBzb21l
dGhpbmcgdGhhdCB3YXMgYnJva2VuIGZyb20gZGF5IG9uZS4gU28gd2hhdCBoYXBwZW5zIHRvIHNv
bWVvbmUgd2hvDQo+ID4gPiBoYXBwZW5lZCB0byBhdm9pZCBhbGwgdGhlIHByb2JsZW1zIHdpdGgg
cGFnZS1sZXNzIERBWCBhbmQgZW5hYmxlZA0KPiA+ID4gZGV2aWNlLW1hcHBlciBvbiB0b3A/IFRo
YXQgZmFpbHVyZSBtb2RlIGRldGFpbCBuZWVkcyB0byBiZSBhZGRlZCB0bw0KPiA+ID4gdGhpcyBj
aGFuZ2Vsb2cgaWYgd2Ugd2FudCB0byBwcm9wb3NlIHRoaXMgZm9yIC1zdGFibGUuDQo+ID4gDQo+
ID4gTXkgcG9pbnQgaXMgdGhhdCB0aGUgYmVoYXZpb3Igc2hvdWxkIGJlIGNvbnNpc3RlbnQgYmV0
d2VlbiBwbWVtIGFuZA0KPiA+IGRldmljZS1tYXBwZXIuICBXaGVuIC1vIGRheCBzdWNjZWVkcyBv
biBhIHBtZW0sIHRoZW4gaXQgc2hvdWxkIHN1Y2NlZWQNCj4gPiBvbiBhIGRldmljZS1tYXBwZXIg
b24gdG9wIG9mIHRoYXQgcG1lbS4NCj4gPiANCj4gPiBIYXMgdGhlIGRyb3Agb2YgZGF4IHN1cHBv
cnQgZnJvbSByYXcgbW9kZSBtYWRlIHRvIC1zdGFibGUgYmFjayB0byB0aGUNCj4gPiBiYXNlbGlu
ZSBhY2NlcHRlZCA1NDVlZDIwZTZkZjY/ICBJdCB3aWxsIGludHJvZHVjZSBpbmNvbnNpc3RlbmN5
LA0KPiA+IG90aGVyd2lzZS4NCj4gDQo+IFRoYXQgY29tbWl0LCA1NjlkMDM2NWY1NzEgImRheDog
cmVxdWlyZSAnc3RydWN0IHBhZ2UnIGJ5IGRlZmF1bHQgZm9yDQo+IGZpbGVzeXN0ZW0gZGF4Iiwg
aGFzIG5vdCBiZWVuIHRhZ2dlZCBmb3IgLXN0YWJsZS4NCg0KVGhlbiwgRml4ZXMgdGFnIHNob3Vs
ZCBiZSBzZXQgdG8gNTY5ZDAzNjVmNTcxIHRvIGtlZXAgdGhlIGJlaGF2aW9yDQpjb25zaXN0ZW50
Lg0KDQotVG9zaGk=
