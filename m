Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:15837 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389527AbfHBQJt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Aug 2019 12:09:49 -0400
From: "Weiny, Ira" <ira.weiny@intel.com>
Subject: RE: [PATCH 20/34] xen: convert put_page() to put_user_page*()
Date: Fri, 2 Aug 2019 16:09:44 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E79E66216@CRSMSX101.amr.corp.intel.com>
References: <20190802022005.5117-1-jhubbard@nvidia.com>
 <20190802022005.5117-21-jhubbard@nvidia.com>
 <4471e9dc-a315-42c1-0c3c-55ba4eeeb106@suse.com>
 <d5140833-e9ee-beb5-ff0a-2d13a4fe819f@nvidia.com>
 <d4931311-db01-e8c3-0f8c-d64685dc2143@suse.com>
In-Reply-To: <d4931311-db01-e8c3-0f8c-d64685dc2143@suse.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Juergen Gross <jgross@suse.com>, John Hubbard <jhubbard@nvidia.com>, "john.hubbard@gmail.com" <john.hubbard@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "x86@kernel.org" <x86@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Dave Hansen <dave.hansen@linux.intel.com>, "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-rpi-kernel@lists.infradead.org" <linux-rpi-kernel@lists.infradead.org>, "devel@lists.orangefs.org" <devel@lists.orangefs.org>, "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>, =?utf-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jan Kara <jack@suse.cz>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>, "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>

PiANCj4gT24gMDIuMDguMTkgMDc6NDgsIEpvaG4gSHViYmFyZCB3cm90ZToNCj4gPiBPbiA4LzEv
MTkgOTozNiBQTSwgSnVlcmdlbiBHcm9zcyB3cm90ZToNCj4gPj4gT24gMDIuMDguMTkgMDQ6MTks
IGpvaG4uaHViYmFyZEBnbWFpbC5jb20gd3JvdGU6DQo+ID4+PiBGcm9tOiBKb2huIEh1YmJhcmQg
PGpodWJiYXJkQG52aWRpYS5jb20+DQo+ID4gLi4uDQo+ID4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy94ZW4vcHJpdmNtZC5jIGIvZHJpdmVycy94ZW4vcHJpdmNtZC5jIGluZGV4DQo+ID4+PiAyZjVj
ZTcyMzBhNDMuLjI5ZTQ2MWRiZWUyZCAxMDA2NDQNCj4gPj4+IC0tLSBhL2RyaXZlcnMveGVuL3By
aXZjbWQuYw0KPiA+Pj4gKysrIGIvZHJpdmVycy94ZW4vcHJpdmNtZC5jDQo+ID4+PiBAQCAtNjEx
LDE1ICs2MTEsMTAgQEAgc3RhdGljIGludCBsb2NrX3BhZ2VzKA0KPiA+Pj4gwqAgc3RhdGljIHZv
aWQgdW5sb2NrX3BhZ2VzKHN0cnVjdCBwYWdlICpwYWdlc1tdLCB1bnNpZ25lZCBpbnQNCj4gPj4+
IG5yX3BhZ2VzKQ0KPiA+Pj4gwqAgew0KPiA+Pj4gLcKgwqDCoCB1bnNpZ25lZCBpbnQgaTsNCj4g
Pj4+IC0NCj4gPj4+IMKgwqDCoMKgwqAgaWYgKCFwYWdlcykNCj4gPj4+IMKgwqDCoMKgwqDCoMKg
wqDCoCByZXR1cm47DQo+ID4+PiAtwqDCoMKgIGZvciAoaSA9IDA7IGkgPCBucl9wYWdlczsgaSsr
KSB7DQo+ID4+PiAtwqDCoMKgwqDCoMKgwqAgaWYgKHBhZ2VzW2ldKQ0KPiA+Pj4gLcKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgcHV0X3BhZ2UocGFnZXNbaV0pOw0KPiA+Pj4gLcKgwqDCoCB9DQo+ID4+
PiArwqDCoMKgIHB1dF91c2VyX3BhZ2VzKHBhZ2VzLCBucl9wYWdlcyk7DQo+ID4+DQo+ID4+IFlv
dSBhcmUgbm90IGhhbmRsaW5nIHRoZSBjYXNlIHdoZXJlIHBhZ2VzW2ldIGlzIE5VTEwgaGVyZS4g
T3IgYW0gSQ0KPiA+PiBtaXNzaW5nIGEgcGVuZGluZyBwYXRjaCB0byBwdXRfdXNlcl9wYWdlcygp
IGhlcmU/DQo+ID4+DQo+ID4NCj4gPiBIaSBKdWVyZ2VuLA0KPiA+DQo+ID4gWW91IGFyZSBjb3Jy
ZWN0LS10aGlzIG5vIGxvbmdlciBoYW5kbGVzIHRoZSBjYXNlcyB3aGVyZSBwYWdlc1tpXSBpcw0K
PiA+IE5VTEwuIEl0J3MgaW50ZW50aW9uYWwsIHRob3VnaCBwb3NzaWJseSB3cm9uZy4gOikNCj4g
Pg0KPiA+IEkgc2VlIHRoYXQgSSBzaG91bGQgaGF2ZSBhZGRlZCBteSBzdGFuZGFyZCBibHVyYiB0
byB0aGlzIGNvbW1pdA0KPiA+IGRlc2NyaXB0aW9uLiBJIG1pc3NlZCB0aGlzIG9uZSwgYnV0IHNv
bWUgb2YgdGhlIG90aGVyIHBhdGNoZXMgaGF2ZSBpdC4NCj4gPiBJdCBtYWtlcyB0aGUgZm9sbG93
aW5nLCBwb3NzaWJseSBpbmNvcnJlY3QgY2xhaW06DQo+ID4NCj4gPiAiVGhpcyBjaGFuZ2VzIHRo
ZSByZWxlYXNlIGNvZGUgc2xpZ2h0bHksIGJlY2F1c2UgZWFjaCBwYWdlIHNsb3QgaW4gdGhlDQo+
ID4gcGFnZV9saXN0W10gYXJyYXkgaXMgbm8gbG9uZ2VyIGNoZWNrZWQgZm9yIE5VTEwuIEhvd2V2
ZXIsIHRoYXQgY2hlY2sNCj4gPiB3YXMgd3JvbmcgYW55d2F5LCBiZWNhdXNlIHRoZSBnZXRfdXNl
cl9wYWdlcygpIHBhdHRlcm4gb2YgdXNhZ2UgaGVyZQ0KPiA+IG5ldmVyIGFsbG93ZWQgZm9yIE5V
TEwgZW50cmllcyB3aXRoaW4gYSByYW5nZSBvZiBwaW5uZWQgcGFnZXMuIg0KPiA+DQo+ID4gVGhl
IHdheSBJJ3ZlIHNlZW4gdGhlc2UgcGFnZSBhcnJheXMgdXNlZCB3aXRoIGdldF91c2VyX3BhZ2Vz
KCksIHRoaW5ncw0KPiA+IGFyZSBlaXRoZXIgZG9uZSBzaW5nbGUgcGFnZSwgb3Igd2l0aCBhIGNv
bnRpZ3VvdXMgcmFuZ2UuIFNvIHVubGVzcyBJJ20NCj4gPiBtaXNzaW5nIGEgY2FzZSB3aGVyZSBz
b21lb25lIGlzIGVpdGhlcg0KPiA+DQo+ID4gYSkgcmVsZWFzaW5nIGluZGl2aWR1YWwgcGFnZXMg
d2l0aGluIGEgcmFuZ2UgKGFuZCB0aHVzIGxpa2VseSBtZXNzaW5nDQo+ID4gdXAgdGhlaXIgY291
bnQgb2YgcGFnZXMgdGhleSBoYXZlKSwgb3INCj4gPg0KPiA+IGIpIGFsbG9jYXRpbmcgdHdvIGd1
cCByYW5nZXMgd2l0aGluIHRoZSBzYW1lIHBhZ2VzW10gYXJyYXksIHdpdGggYSBnYXANCj4gPiBi
ZXR3ZWVuIHRoZSBhbGxvY2F0aW9ucywNCj4gPg0KPiA+IC4uLnRoZW4gaXQgc2hvdWxkIGJlIGNv
cnJlY3QuIElmIHNvLCB0aGVuIEknbGwgYWRkIHRoZSBhYm92ZSBibHVyYiB0bw0KPiA+IHRoaXMg
cGF0Y2gncyBjb21taXQgZGVzY3JpcHRpb24uDQo+ID4NCj4gPiBJZiB0aGF0J3Mgbm90IHRoZSBj
YXNlIChib3RoIGhlcmUsIGFuZCBpbiAzIG9yIDQgb3RoZXIgcGF0Y2hlcyBpbiB0aGlzDQo+ID4g
c2VyaWVzLCB0aGVuIGFzIHlvdSBzYWlkLCBJIHNob3VsZCBhZGQgTlVMTCBjaGVja3MgdG8gcHV0
X3VzZXJfcGFnZXMoKQ0KPiA+IGFuZCBwdXRfdXNlcl9wYWdlc19kaXJ0eV9sb2NrKCkuDQo+IA0K
PiBJbiB0aGlzIGNhc2UgaXQgaXMgbm90IGNvcnJlY3QsIGJ1dCBjYW4gZWFzaWx5IGJlIGhhbmRs
ZWQuIFRoZSBOVUxMIGNhc2UgY2FuDQo+IG9jY3VyIG9ubHkgaW4gYW4gZXJyb3IgY2FzZSB3aXRo
IHRoZSBwYWdlcyBhcnJheSBmaWxsZWQgcGFydGlhbGx5IG9yIG5vdCBhdCBhbGwuDQo+IA0KPiBJ
J2QgcHJlZmVyIHNvbWV0aGluZyBsaWtlIHRoZSBhdHRhY2hlZCBwYXRjaCBoZXJlLg0KDQpJJ20g
bm90IGFuIGV4cGVydCBpbiB0aGlzIGNvZGUgYW5kIGhhdmUgbm90IGxvb2tlZCBhdCBpdCBjYXJl
ZnVsbHkgYnV0IHRoYXQgcGF0Y2ggZG9lcyBzZWVtIHRvIGJlIHRoZSBiZXR0ZXIgZml4IHRoYW4g
Zm9yY2luZyBOVUxMIGNoZWNrcyBvbiBldmVyeW9uZS4NCg0KSXJhDQoNCg==
