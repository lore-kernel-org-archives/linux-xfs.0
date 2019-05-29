Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-eopbgr740114.outbound.protection.outlook.com ([40.107.74.114]:40592
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725956AbfE2UDj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 29 May 2019 16:03:39 -0400
From: Trond Myklebust <trondmy@hammerspace.com>
Subject: Re: [PATCH v3 12/13] nfs: copy_file_range needs to strip setuid bits
 and update timestamps
Date: Wed, 29 May 2019 20:02:54 +0000
Message-ID: <c32af433639b451419d36382a05edabfcb742294.camel@hammerspace.com>
References: <20190529174318.22424-1-amir73il@gmail.com>
         <20190529174318.22424-13-amir73il@gmail.com>
         <CAOQ4uxgYM_eM==uqGQuKiGb+f08qs53=E+DONMMzW=N-Ab5YZA@mail.gmail.com>
In-Reply-To: <CAOQ4uxgYM_eM==uqGQuKiGb+f08qs53=E+DONMMzW=N-Ab5YZA@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <005480E3B17E7241ABE3D1CD6DA0576F@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Anna.Schumaker@netapp.com" <Anna.Schumaker@netapp.com>, "amir73il@gmail.com" <amir73il@gmail.com>, "olga.kornievskaia@gmail.com" <olga.kornievskaia@gmail.com>
Cc: "hch@lst.de" <hch@lst.de>, "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, "david@fromorbit.com" <david@fromorbit.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "lhenriques@suse.com" <lhenriques@suse.com>, "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>

T24gV2VkLCAyMDE5LTA1LTI5IGF0IDIyOjM0ICswMzAwLCBBbWlyIEdvbGRzdGVpbiB3cm90ZToN
Cj4gSGkgT2xnYSxBbm5hLFRyb25kDQo+IA0KPiBDb3VsZCB3ZSBnZXQgYW4gQUNLIG9uIHRoaXMg
cGF0Y2guDQo+IEl0IGlzIGEgcHJlcmVxdWlzaXRlIGZvciBtZXJnaW5nIHRoZSBjcm9zcy1kZXZp
Y2UgY29weV9maWxlX3JhbmdlDQo+IHdvcmsuDQo+IA0KPiBJdCBkZXBlbmRzIG9uIGEgbmV3IGhl
bHBlciBpbnRyb2R1Y2VkIGhlcmU6DQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LWZz
ZGV2ZWwvQ0FPUTR1eGpiY1NXWDFoVWN1WGJuOGhGSDNRWUIrNWJBQzlaMXlDd0pkUj1ULUdHdENn
QG1haWwuZ21haWwuY29tL1QvI20xNTY5ODc4YzQxZjM5ZmFjM2FhZGIzODMyYTMwNjU5YzMyM2I1
ODJhDQo+IA0KPiBUaGFua3MsDQo+IEFtaXIsDQo+IA0KPiBPbiBXZWQsIE1heSAyOSwgMjAxOSBh
dCA4OjQzIFBNIEFtaXIgR29sZHN0ZWluIDxhbWlyNzNpbEBnbWFpbC5jb20+DQo+IHdyb3RlOg0K
PiA+IExpa2UgLT53cml0ZV9pdGVyKCksIHdlIHVwZGF0ZSBtdGltZSBhbmQgc3RyaXAgc2V0dWlk
IG9mIGRzdCBmaWxlDQo+ID4gYmVmb3JlDQo+ID4gY29weSBhbmQgbGlrZSAtPnJlYWRfaXRlcigp
LCB3ZSB1cGRhdGUgYXRpbWUgb2Ygc3JjIGZpbGUgYWZ0ZXINCj4gPiBjb3B5Lg0KPiA+IA0KPiA+
IFNpZ25lZC1vZmYtYnk6IEFtaXIgR29sZHN0ZWluIDxhbWlyNzNpbEBnbWFpbC5jb20+DQo+ID4g
LS0tDQo+ID4gIGZzL25mcy9uZnM0MnByb2MuYyB8IDkgKysrKysrLS0tDQo+ID4gIDEgZmlsZSBj
aGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+ID4gDQo+ID4gZGlmZiAt
LWdpdCBhL2ZzL25mcy9uZnM0MnByb2MuYyBiL2ZzL25mcy9uZnM0MnByb2MuYw0KPiA+IGluZGV4
IDUxOTZiZmE3ODk0ZC4uYzM3YThlNTExNmM2IDEwMDY0NA0KPiA+IC0tLSBhL2ZzL25mcy9uZnM0
MnByb2MuYw0KPiA+ICsrKyBiL2ZzL25mcy9uZnM0MnByb2MuYw0KPiA+IEBAIC0zNDUsMTAgKzM0
NSwxMyBAQCBzc2l6ZV90IG5mczQyX3Byb2NfY29weShzdHJ1Y3QgZmlsZSAqc3JjLA0KPiA+IGxv
ZmZfdCBwb3Nfc3JjLA0KPiA+IA0KPiA+ICAgICAgICAgZG8gew0KPiA+ICAgICAgICAgICAgICAg
ICBpbm9kZV9sb2NrKGZpbGVfaW5vZGUoZHN0KSk7DQo+ID4gLSAgICAgICAgICAgICAgIGVyciA9
IF9uZnM0Ml9wcm9jX2NvcHkoc3JjLCBzcmNfbG9jaywNCj4gPiAtICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIGRzdCwgZHN0X2xvY2ssDQo+ID4gLSAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAmYXJncywgJnJlcyk7DQo+ID4gKyAgICAgICAgICAgICAgIGVyciA9IGZpbGVfbW9k
aWZpZWQoZHN0KTsNCj4gPiArICAgICAgICAgICAgICAgaWYgKCFlcnIpDQo+ID4gKyAgICAgICAg
ICAgICAgICAgICAgICAgZXJyID0gX25mczQyX3Byb2NfY29weShzcmMsIHNyY19sb2NrLA0KPiA+
ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZHN0LCBkc3Rf
bG9jaywNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICZhcmdzLCAmcmVzKTsNCj4gPiAgICAgICAgICAgICAgICAgaW5vZGVfdW5sb2NrKGZpbGVfaW5v
ZGUoZHN0KSk7DQo+ID4gKyAgICAgICAgICAgICAgIGZpbGVfYWNjZXNzZWQoc3JjKTsNCj4gPiAN
Cj4gPiAgICAgICAgICAgICAgICAgaWYgKGVyciA+PSAwKQ0KPiA+ICAgICAgICAgICAgICAgICAg
ICAgICAgIGJyZWFrOw0KPiA+IC0tDQo+ID4gMi4xNy4xDQo+ID4gDQoNClBsZWFzZSBkcm9wIHRo
aXMgcGF0Y2guIEluIHRoZSBORlMgcHJvdG9jb2wsIHRoZSBjbGllbnQgaXMgbm90IGV4cGVjdGVk
DQp0byBtZXNzIHdpdGggYXRpbWUgb3IgbXRpbWUgb3RoZXIgdGhhbiB3aGVuIHRoZSB1c2VyIGV4
cGxpY2l0bHkgc2V0cyBpdA0KdGhyb3VnaCBhIGNhbGwgdG8gdXRpbWVuc2F0KCkgb3Igc2ltaWxh
ci4gVGhlIHNlcnZlciB0YWtlcyBjYXJlIG9mIGFueQ0KYS9tdGltZSB1cGRhdGVzIGFzIGFuZCB3
aGVuIHRoZSBmaWxlIGlzIHJlYWQvd3JpdHRlbiB0by4gDQoNCkRpdHRvIGZvciBzdWlkL3NnaWQg
Y2xlYXJpbmcuDQoNCk1vdHRvOiAiTm8gZmlsZV9hY2Nlc3NlZCgpIG9yIGZpbGVfcmVtb3ZlX3By
aXZzKCkgY2FsbHMsIHBsZWFzZS4gV2UncmUNCk5GUy4iDQoNCi0tIA0KVHJvbmQgTXlrbGVidXN0
DQpMaW51eCBORlMgY2xpZW50IG1haW50YWluZXIsIEhhbW1lcnNwYWNlDQp0cm9uZC5teWtsZWJ1
c3RAaGFtbWVyc3BhY2UuY29tDQoNCg0K
