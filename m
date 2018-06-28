Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from g2t2353.austin.hpe.com ([15.233.44.26]:51127 "EHLO
        g2t2353.austin.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752170AbeF1TkW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jun 2018 15:40:22 -0400
From: "Kani, Toshi" <toshi.kani@hpe.com>
Subject: Re: [PATCH v3 1/3] pmem: only set QUEUE_FLAG_DAX for fsdax mode
Date: Thu, 28 Jun 2018 19:40:14 +0000
Message-ID: <1530214695.14039.316.camel@hpe.com>
References: <CAPcyv4h6HO6fs6k7QMD77jkz2djCeWCtWomCdNb0-1Q4VKanqw@mail.gmail.com>
         <20180626191346.GA7233@redhat.com> <1530046327.14039.273.camel@hpe.com>
         <CAPcyv4hP_Y3xdyCa-UkYCMJ5OtnjnkwPZDS2Z2Ge8+5ymBONwQ@mail.gmail.com>
         <1530048093.14039.286.camel@hpe.com>
         <CAPcyv4gXAC7imJs5qfsDNLeN545Rqyd2b1M9s5kr4f9y48LXgQ@mail.gmail.com>
         <1530048545.14039.288.camel@hpe.com>
         <CAPcyv4ifHX95fCM9Xj87CugwNWzgq=y-4LxPQ5L6RdjX0jdctQ@mail.gmail.com>
         <20180626220430.GA4269@linux.intel.com>
         <1530207635.14039.308.camel@hpe.com>
         <20180628190424.GC17758@linux.intel.com>
In-Reply-To: <20180628190424.GC17758@linux.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <BD982B3FCD049F479B5BFD2D4008C2C0@NAMPRD84.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>

T24gVGh1LCAyMDE4LTA2LTI4IGF0IDEzOjA0IC0wNjAwLCBSb3NzIFp3aXNsZXIgd3JvdGU6DQo+
IE9uIFRodSwgSnVuIDI4LCAyMDE4IGF0IDA1OjQyOjM0UE0gKzAwMDAsIEthbmksIFRvc2hpIHdy
b3RlOg0KPiA+IE9uIFR1ZSwgMjAxOC0wNi0yNiBhdCAxNjowNCAtMDYwMCwgUm9zcyBad2lzbGVy
IHdyb3RlOg0KPiA+ID4gT24gVHVlLCBKdW4gMjYsIDIwMTggYXQgMDI6NTE6NTJQTSAtMDcwMCwg
RGFuIFdpbGxpYW1zIHdyb3RlOg0KPiA+ID4gPiBPbiBUdWUsIEp1biAyNiwgMjAxOCBhdCAyOjMx
IFBNLCBLYW5pLCBUb3NoaSA8dG9zaGkua2FuaUBocGUuY29tPiB3cm90ZToNCiA6DQo+ID4gWW91
ciBwYXRjaGVzIGxvb2sgZ29vZC4gIEJ1dCBJIGFtIHN0aWxsIG5vdCBjbGVhciBhYm91dCB0aGUg
Rml4ZXMgJg0KPiA+IHN0YWJsZSBoYW5kbGluZy4gIFRhbGtpbmcgYWJvdXQgdXNlciB2aXNpYmxl
IGJlaGF2aW9yLCBJIGRvIG5vdCB0aGluayB3ZQ0KPiA+IGhhZCBhbnkgaXNzdWUgdW50aWwgZGF4
IHN1cHBvcnQgd2FzIGRyb3BwZWQgZnJvbSByYXcgbW9kZS4gIFVudGlsIHRoZW4sDQo+ID4gdGhl
IHBtZW0gZHJpdmVyIHN1cHBvcnRlZCBkYXggZm9yIGFsbCBtb2RlcywgYW5kIHRoZSBjaGVjayBm
b3INCj4gPiBkaXJlY3RfYWNjZXNzIHdvcmtlZC4gICAgDQo+IA0KPiBJIGFncmVlIHRoYXQgdGhl
IGZzZGF4ICsgcmF3IG1vZGUgZmFpbHVyZSBtb2RlIEkgbWVudGlvbmVkIGluIG15IGNvdmVyIGxl
dHRlcg0KPiBvbmx5IHN0YXJ0ZWQgd2hlbiB3ZSByZXN0cmljdGVkIGZpbGVzeXN0ZW0gREFYIHRv
IGhhdmluZyBzdHJ1Y3QgcGFnZSwgYnV0IEkNCj4gdGhpbmsgdGhhdCB0aGUgb3RoZXIgZmFpbHVy
ZSBtb2RlLCBmc2RheCArIHNvbWUgcmFuZG9tIGJsb2NrIGRyaXZlciAoSSB1c2VkDQo+IGJyZCkg
d2FzIHByZXNlbnQgaW4gRE0gZnJvbSB0aGUgYmVnaW5uaW5nLg0KDQpBaCwgSSBzZWUuDQoNCj4g
SW4gYW55IGNhc2UsIEkgdGhpbmsgYm90aCBhcmUgZml4ZWQgd2l0aCB0aGUgcGF0Y2hlcywgYW5k
IEkgdGhpbmsgaXQncyBmaW5lDQo+IHRoYXQgYWxsIDMgZ2V0IHRocm93biBhdCBzdGFibGUuICBU
aGFua3MsIE1pa2UsIGZvciB0aGUgaGVscC4NCg0KWXVwLCBhZ3JlZWQuIA0KDQpUaGFua3MhDQot
VG9zaGk=
