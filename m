Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from g2t1383g.austin.hpe.com ([15.233.16.89]:7226 "EHLO
        g2t1383g.austin.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935186AbeF1Rmv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jun 2018 13:42:51 -0400
From: "Kani, Toshi" <toshi.kani@hpe.com>
Subject: Re: [PATCH v3 1/3] pmem: only set QUEUE_FLAG_DAX for fsdax mode
Date: Thu, 28 Jun 2018 17:42:34 +0000
Message-ID: <1530207635.14039.308.camel@hpe.com>
References: <CAPcyv4iWgPnHmBKhUvhManC6UL9CkLqN_d8vBo6KmcPJdPzuUw@mail.gmail.com>
         <20180626185830.GA7171@redhat.com>
         <CAPcyv4h6HO6fs6k7QMD77jkz2djCeWCtWomCdNb0-1Q4VKanqw@mail.gmail.com>
         <20180626191346.GA7233@redhat.com> <1530046327.14039.273.camel@hpe.com>
         <CAPcyv4hP_Y3xdyCa-UkYCMJ5OtnjnkwPZDS2Z2Ge8+5ymBONwQ@mail.gmail.com>
         <1530048093.14039.286.camel@hpe.com>
         <CAPcyv4gXAC7imJs5qfsDNLeN545Rqyd2b1M9s5kr4f9y48LXgQ@mail.gmail.com>
         <1530048545.14039.288.camel@hpe.com>
         <CAPcyv4ifHX95fCM9Xj87CugwNWzgq=y-4LxPQ5L6RdjX0jdctQ@mail.gmail.com>
         <20180626220430.GA4269@linux.intel.com>
In-Reply-To: <20180626220430.GA4269@linux.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <21D4734DB95C3E49B2DAE47C2C3EA83D@NAMPRD84.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>

T24gVHVlLCAyMDE4LTA2LTI2IGF0IDE2OjA0IC0wNjAwLCBSb3NzIFp3aXNsZXIgd3JvdGU6DQo+
IE9uIFR1ZSwgSnVuIDI2LCAyMDE4IGF0IDAyOjUxOjUyUE0gLTA3MDAsIERhbiBXaWxsaWFtcyB3
cm90ZToNCj4gPiBPbiBUdWUsIEp1biAyNiwgMjAxOCBhdCAyOjMxIFBNLCBLYW5pLCBUb3NoaSA8
dG9zaGkua2FuaUBocGUuY29tPiB3cm90ZToNCj4gPiA+IE9uIFR1ZSwgMjAxOC0wNi0yNiBhdCAx
NDoyOCAtMDcwMCwgRGFuIFdpbGxpYW1zIHdyb3RlOg0KPiA+ID4gPiBPbiBUdWUsIEp1biAyNiwg
MjAxOCBhdCAyOjIzIFBNLCBLYW5pLCBUb3NoaSA8dG9zaGkua2FuaUBocGUuY29tPiB3cm90ZToN
Cj4gPiA+ID4gPiBPbiBUdWUsIDIwMTgtMDYtMjYgYXQgMTQ6MDIgLTA3MDAsIERhbiBXaWxsaWFt
cyB3cm90ZToNCj4gPiA+ID4gPiA+IE9uIFR1ZSwgSnVuIDI2LCAyMDE4IGF0IDE6NTQgUE0sIEth
bmksIFRvc2hpIDx0b3NoaS5rYW5pQGhwZS5jb20+IHdyb3RlOg0KPiA+ID4gPiANCj4gPiA+ID4g
Wy4uXQ0KPiA+ID4gPiA+ID4gPiBXaGVuIHRoaXMgZG0gY2hhbmdlIHdhcyBtYWRlLCB0aGUgcG1l
bSBkcml2ZXIgc3VwcG9ydGVkIERBWCBmb3IgYm90aCByYXcNCj4gPiA+ID4gPiA+ID4gYW5kIG1l
bW9yeSBtb2RlcyAobm90ZTogc2VjdG9yIG1vZGUgZG9lcyBub3QgdXNlIHRoZSBwbWVtIGRyaXZl
cikuICBJDQo+ID4gPiA+ID4gPiA+IHRoaW5rIHRoZSBpc3N1ZSB3YXMgaW50cm9kdWNlZCB3aGVu
IHdlIGRyb3BwZWQgREFYIHN1cHBvcnQgZnJvbSByYXcNCj4gPiA+ID4gPiA+ID4gbW9kZS4NCj4g
PiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gU3RpbGwgREFYIHdpdGggcmF3IG1vZGUgbmV2ZXIgcmVh
bGx5IHdvcmtlZCBhbnkgd2F5LiBJdCB3YXMgYWxzbw0KPiA+ID4gPiA+ID4gc29tZXRoaW5nIHRo
YXQgd2FzIGJyb2tlbiBmcm9tIGRheSBvbmUuIFNvIHdoYXQgaGFwcGVucyB0byBzb21lb25lIHdo
bw0KPiA+ID4gPiA+ID4gaGFwcGVuZWQgdG8gYXZvaWQgYWxsIHRoZSBwcm9ibGVtcyB3aXRoIHBh
Z2UtbGVzcyBEQVggYW5kIGVuYWJsZWQNCj4gPiA+ID4gPiA+IGRldmljZS1tYXBwZXIgb24gdG9w
PyBUaGF0IGZhaWx1cmUgbW9kZSBkZXRhaWwgbmVlZHMgdG8gYmUgYWRkZWQgdG8NCj4gPiA+ID4g
PiA+IHRoaXMgY2hhbmdlbG9nIGlmIHdlIHdhbnQgdG8gcHJvcG9zZSB0aGlzIGZvciAtc3RhYmxl
Lg0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IE15IHBvaW50IGlzIHRoYXQgdGhlIGJlaGF2aW9yIHNo
b3VsZCBiZSBjb25zaXN0ZW50IGJldHdlZW4gcG1lbSBhbmQNCj4gPiA+ID4gPiBkZXZpY2UtbWFw
cGVyLiAgV2hlbiAtbyBkYXggc3VjY2VlZHMgb24gYSBwbWVtLCB0aGVuIGl0IHNob3VsZCBzdWNj
ZWVkDQo+ID4gPiA+ID4gb24gYSBkZXZpY2UtbWFwcGVyIG9uIHRvcCBvZiB0aGF0IHBtZW0uDQo+
ID4gPiA+ID4gDQo+ID4gPiA+ID4gSGFzIHRoZSBkcm9wIG9mIGRheCBzdXBwb3J0IGZyb20gcmF3
IG1vZGUgbWFkZSB0byAtc3RhYmxlIGJhY2sgdG8gdGhlDQo+ID4gPiA+ID4gYmFzZWxpbmUgYWNj
ZXB0ZWQgNTQ1ZWQyMGU2ZGY2PyAgSXQgd2lsbCBpbnRyb2R1Y2UgaW5jb25zaXN0ZW5jeSwNCj4g
PiA+ID4gPiBvdGhlcndpc2UuDQo+ID4gPiA+IA0KPiA+ID4gPiBUaGF0IGNvbW1pdCwgNTY5ZDAz
NjVmNTcxICJkYXg6IHJlcXVpcmUgJ3N0cnVjdCBwYWdlJyBieSBkZWZhdWx0IGZvcg0KPiA+ID4g
PiBmaWxlc3lzdGVtIGRheCIsIGhhcyBub3QgYmVlbiB0YWdnZWQgZm9yIC1zdGFibGUuDQo+ID4g
PiANCj4gPiA+IFRoZW4sIEZpeGVzIHRhZyBzaG91bGQgYmUgc2V0IHRvIDU2OWQwMzY1ZjU3MSB0
byBrZWVwIHRoZSBiZWhhdmlvcg0KPiA+ID4gY29uc2lzdGVudC4NCj4gPiANCj4gPiBTdXJlLCBh
bmQgdGhlIGZhaWx1cmUgbW9kZSBpcy4uLj8gSSdtIHRoaW5raW5nIHRoZSBjb21taXQgbG9nIHNo
b3VsZCBzYXk6DQo+ID4gDQo+ID4gIlN0YXJ0aW5nIHdpdGggY29tbWl0IDU2OWQwMzY1ZjU3MSAi
ZGF4OiByZXF1aXJlICdzdHJ1Y3QgcGFnZScgYnkNCj4gPiBkZWZhdWx0IGZvciBmaWxlc3lzdGVt
IGRheCIsIGRheCBpcyBubyBsb25nZXIgc3VwcG9ydGVkIGZvciBwYWdlLWxlc3MNCj4gPiBjb25m
aWd1cmF0aW9ucy4gSG93ZXZlciwgZGV2aWNlLW1hcHBlciBzZWVzIHRoZSBRVUVVRV9GTEFHX0RB
WCBzdGlsbA0KPiA+IGJlaW5nIHNldCBhbmQgZmFsc2VseSBhc3N1bWVzIHRoYXQgREFYIGlzIGVu
YWJsZWQsIHRoaXMgbGVhZHMgdG8NCj4gPiA8aW5zZXJ0IHVzZXIgdmlzaWJsZSBmYWlsdXJlIG1v
ZGUgZGV0YWlscyBoZXJlPiINCj4gDQo+IERhbiBpcyBjb3JyZWN0IHRoYXQgdGhlcmUgaXMgbm8g
dXNlciB2aXNpYmxlIGNoYW5nZSBmb3IgdGhpcy4gIEl0IGlzIHRoZSByaWdodA0KPiB0aGluZyB0
byBkbyBmb3IgY29uc2lzdGVuY3kgYW5kIHNhbml0eSwgYnV0IGl0IGRvZXNuJ3QgYWN0dWFsbHkg
aGF2ZSB1c2VyDQo+IHZpc2libGUgYmVoYXZpb3IgdGhhdCBuZWVkcyB0byBiZSBiYWNrcG9ydGVk
IHRvIHN0YWJsZS4NCj4gDQo+IFRvc2hpIGlzIGNvcnJlY3QgdGhhdCB0aGlzIGNoYW5nZSBpcyBv
bmx5IGZvciByYXcgbW9kZSBuYW1lc3BhY2VzLCBub3QgYnR0DQo+IG5hbWVzcGFjZXMuDQo+IA0K
PiBJJ2xsIGFkanVzdCB0aGUgY2hhbmdlbG9nIGFuZCByZW1vdmUgdGhlIHN0YWJsZSBmbGFnIGZv
ciB2NSwgYW5kIEknbGwgYWRkIGENCj4gRml4ZXM6IHRhZyBmb3IgcGF0Y2ggMi4NCg0KSGkgUm9z
cywNCg0KWW91ciBwYXRjaGVzIGxvb2sgZ29vZC4gIEJ1dCBJIGFtIHN0aWxsIG5vdCBjbGVhciBh
Ym91dCB0aGUgRml4ZXMgJg0Kc3RhYmxlIGhhbmRsaW5nLiAgVGFsa2luZyBhYm91dCB1c2VyIHZp
c2libGUgYmVoYXZpb3IsIEkgZG8gbm90IHRoaW5rIHdlDQpoYWQgYW55IGlzc3VlIHVudGlsIGRh
eCBzdXBwb3J0IHdhcyBkcm9wcGVkIGZyb20gcmF3IG1vZGUuICBVbnRpbCB0aGVuLA0KdGhlIHBt
ZW0gZHJpdmVyIHN1cHBvcnRlZCBkYXggZm9yIGFsbCBtb2RlcywgYW5kIHRoZSBjaGVjayBmb3IN
CmRpcmVjdF9hY2Nlc3Mgd29ya2VkLiAgICANCg0KVGhhbmtzLA0KLVRvc2hpDQoNCg==
