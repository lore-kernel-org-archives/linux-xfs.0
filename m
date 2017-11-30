Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:13708 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752795AbdK3RBU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Nov 2017 12:01:20 -0500
From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 00/11] fs: use freeze_fs on suspend/hibernate
Date: Thu, 30 Nov 2017 17:01:13 +0000
Message-ID: <1512061271.2774.10.camel@wdc.com>
References: <20171129232356.28296-1-mcgrof@kernel.org>
In-Reply-To: <20171129232356.28296-1-mcgrof@kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <F40459AE4CEA404B98C5C89AD42D1429@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "pavel@ucw.cz" <pavel@ucw.cz>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "mcgrof@kernel.org" <mcgrof@kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "jikos@kernel.org" <jikos@kernel.org>, "len.brown@intel.com" <len.brown@intel.com>, "tytso@mit.edu" <tytso@mit.edu>
Cc: "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>, "ONeukum@suse.com" <ONeukum@suse.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "nborisov@suse.com" <nborisov@suse.com>, "oleg.b.antonyan@gmail.com" <oleg.b.antonyan@gmail.com>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "jgross@suse.com" <jgross@suse.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "yu.chen.surf@gmail.com" <yu.chen.surf@gmail.com>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "todd.e.brandt@linux.intel.com" <todd.e.brandt@linux.intel.com>, "jack@suse.cz" <jack@suse.cz>

T24gV2VkLCAyMDE3LTExLTI5IGF0IDE1OjIzIC0wODAwLCBMdWlzIFIuIFJvZHJpZ3VleiB3cm90
ZToNCj4gVGhpcyBpcyBhIGZvbGxvd3VwIGZyb20gdGhlIG9yaWdpbmFsIFJGQyB3aGljaCBwcm9w
b3NlZCB0byBzdGFydA0KPiB0byBraWxsIGt0aHJlYWQgZnJlZXppbmcgYWxsIHRvZ2V0aGVyIFsw
XS4gSW5zdGVhZCBvZiBnb2luZyBzdHJhaWdodA0KPiBvdXQgdG8gdGhlIGp1Z3VsYXIgZm9yIGt0
aHJlYWQgZnJlZXppbmcgdGhpcyBzZXJpZXMgb25seSBhZGRyZXNzZXMNCj4ga2lsbGluZyBmcmVl
emVyIGNhbGxzIG9uIGZpbGVzeXN0ZW1zIHdoaWNoIGltcGxlbWVudCBmcmVlemVfZnMsIGFmdGVy
DQo+IHdlIGxldCB0aGUga2VybmVsIGZyZWV6ZSB0aGVzZSBmaWxlc3lzdGVtcyBmb3IgdXMgb24g
c3VzcGVuZC4NCj4gDQo+IFRoaXMgYXBwcm9hY2ggcHV0cyBvbiBhIHNsb3cgYnV0IHN0ZWFkeSBw
YXRoIHRvd2FyZHMgdGhlIG9yaWdpbmFsIGdvYWwNCj4gdGhvdWdoLiBFYWNoIHN1YnN5c3RlbSBj
b3VsZCBsb29rIGZvciBzaW1pbGFyIHNvbHV0aW9ucy4gRXZlbiB3aXRoDQo+IGZpbGVzeXN0ZW1z
IHdlJ3JlIG5vdCBhbGwgZG9uZSB5ZXQsIGFmdGVyIHRoaXMgd2UnbGwgc3RpbGwgaGF2ZSB0bw0K
PiBkZWNpZGUgd2hhdCB0byBkbyBhYm91dCBmaWxlc3lzdGVtcyB3aGljaCBkbyBub3QgaW1wbGVt
ZW50IGZyZWV6ZV9mcygpLg0KPiANCj4gTW90aXZhdGlvbiBhbmQgcHJvYmxlbToNCj4gDQo+IGt0
aHJlYWRzIGhhdmUgc29tZSBzZW1hbnRpY3MgZm9yIGZyZWV6aW5nLCB3aGljaCBoZWxwcyB0aGUg
a2VybmVsDQo+IGZyZWV6ZSB0aGVtIHdoZW4gYSBzeXN0ZW0gaXMgZ29pbmcgdG8gc3VzcGVuZCBv
ciBoaWJlcm5hdGlvbi4gVGhlc2UNCj4gc2VtYW50aWNzIGFyZSBub3Qgd2VsbCBkZWZpbmVkIHRo
b3VnaCwgYW5kIGl0IGFjdHVhbGx5IHR1cm5zIG91dA0KPiBwcmV0dHkgaGFyZCB0byBnZXQgaXQg
cmlnaHQuDQo+IA0KPiBXaXRob3V0IGEgcHJvcGVyIHNvbHV0aW9uIHN1c3BlbmQgYW5kIGhpYmVy
bmF0aW9uIGFyZSBmcmFnaWxlIG9uIGZpbGVzeXN0ZW1zLA0KPiBpdCBjYW4gZWFzaWx5IGJyZWFr
IHN1c3BlbmQgYW5kIGZpeGluZyBzdWNoIGlzc3VlcyBhcmUgaW4gbm8gd2F5IHRyaXZpYWwgWzFd
DQo+IFsyXS4NCj4gDQo+IFByb3Bvc2VkIHNvbHV0aW9uOg0KPiANCj4gSW5zdGVhZCBvZiBmaXhp
bmcgc3VjaCBzZW1hbnRpY3MgYW5kIHRyeWluZyB0byBnZXQgYWxsIGZpbGVzeXN0ZW1zIHRvIGRv
IGl0DQo+IHJpZ2h0LCB3ZSBjYW4gZWFzaWx5IGRvIGF3YXkgd2l0aCBhbGwgZnJlZXppbmcgY2Fs
bHMgaWYgdGhlIGZpbGVzeXN0ZW0NCj4gaW1wbGVtZW50cyBhIHByb3BlciBmcmVlemVfZnMoKSBj
YWxsYmFjay4gVGhlIGZvbGxvd2luZyA5IGZpbGVzeXN0ZW1zIGhhdmUNCj4gZnJlZXplX2ZzKCkg
aW1wbGVtZW50ZWQgYXMgc3VjaCB3ZSBjYW4gbGV0IHRoZSBrZXJuZWwgaXNzdWUgdGhlIGNhbGxi
YWNrIHVwb24NCj4gc3VzcGVuZCBhbmQgdGhhdyBvbiByZXN1bWUgYXV0b21hdGljYWxseSBvbiBv
dXIgYmVoYWxmLg0KPiANCj4gICBvIHhmcw0KPiAgIG8gcmVpc2VyZnMNCj4gICBvIG5pbGZzMg0K
PiAgIG8gamZzDQo+ICAgbyBmMmZzDQo+ICAgbyBleHQ0DQo+ICAgbyBleHQyDQo+ICAgbyBidHJm
cw0KPiANCj4gT2YgdGhlc2UsIHRoZSBmb2xsb3dpbmcgaGF2ZSBmcmVlemVyIGhlbHBlcnMsIHdo
aWNoIGNhbiB0aGVuIGJlIHJlbW92ZWQNCj4gYWZ0ZXIgdGhlIGtlcm5lbCBhdXRvbWF0aWNhbHkg
Y2FsbHMgZnJlZXplX2ZzIGZvciB1cyBvbiBzdXNwZW5kOg0KPiANCj4gICBvIHhmcw0KPiAgIG8g
bmlsZnMyDQo+ICAgbyBqZnMNCj4gICBvIGYyZnMNCj4gICBvIGV4dDQNCj4gDQo+IEkndmUgdGVz
dGVkIHRoaXMgb24gYSBzeXN0ZW0gd2l0aCBleHQ0IGFuZCBYRlMsIGFuZCBoYXZlIGxldCAwLWRh
eSBnbyBhdA0KPiB3aXRob3V0IGlzc3Vlcy4gSSBoYXZlIGJyYW5jaGVzIGF2YWlsYWJlIGZvciBs
aW51eC1uZXh0IFszXSBhbmQgTGludXMnDQo+IGxhdGVzdCB0cmVlIFs0XS4NCj4gDQo+IEZ1cnRo
ZXIgdGVzdGluZywgdGhvdWdodHMsIHJldmlld3MsIGZsYW1lcyBhcmUgYWxsIGVxdWFsbHkgYXBw
cmVjaWF0ZWQuDQoNCkhlbGxvIEx1aXMsDQoNCkl0J3MgZ3JlYXQgdG8gc2VlIHRoYXQgeW91IGFy
ZSBtYWtpbmcgcHJvZ3Jlc3Mgd2l0aCB0aGlzIHdvcmsgOi0pIEhvd2V2ZXIsDQp3aGF0J3Mgbm90
IGNsZWFyIHRvIG1lIGlzIHdoYXQgeW91ciAobG9uZy10ZXJtKSBwbGFuIGlzIGZvciBmcmVlemlu
Zw0KZmlsZXN5c3RlbXMgdGhhdCBlLmcuIGV4aXN0IG9uIHRvcCBvZiBhIG1kIFJBSUQxIGJsb2Nr
IGRldmljZT8gVGhlIG1kIHJlc3luYw0KdGhyZWFkIG11c3QgYmUgc3RvcHBlZCBiZWZvcmUgYSBz
eXN0ZW0gaXMgZnJvemVuLiBUb2RheSB0aGUgbWQgZHJpdmVyIHVzZXMNCnRoZSBrdGhyZWFkIGZy
ZWV6aW5nIG1lY2hhbmlzbSBmb3IgdGhhdCBwdXJwb3NlLiBEbyB5b3UgaGF2ZSBhIHBsYW4gZm9y
DQpoYW5kbGluZyB0aGUgbW9yZSBjb21wbGljYXRlZCBzY2VuYXJpb3MsIGUuZy4gYSBmaWxlc3lz
dGVtIHRoYXQgZXhpc3RzIG9uIHRvcA0Kb2YgYW4gbWQgZGV2aWNlIHdoZXJlIHRoZSBtZCBkZXZp
Y2UgdXNlcyBvbmUgb3IgbW9yZSBmaWxlcyBhcyBiYWNraW5nIHN0b3JlDQphbmQgd2l0aCB0aGUg
bG9vcCBkcml2ZXIgYmV0d2VlbiB0aGUgbWQgZGV2aWNlIGFuZCB0aGUgZmlsZXM/DQoNCkhvdyBh
Ym91dCBmaWxlc3lzdGVtcyBpbXBsZW1lbnRlZCBpbiB1c2VyIHNwYWNlIHVzaW5nIHRoZSBGVVNF
IGRyaXZlcj8NClBhdGNoIDYvMTEgb2YgdGhpcyBzZXJpZXMgZnJlZXplcyB1c2VyIHNwYWNlIHBy
b2Nlc3NlcyBiZWZvcmUgZnJlZXppbmcNCmZpbGVzeXN0ZW1zLiBXaWxsIHRoYXQgd29yayBmb3Ig
RlVTRSBmaWxlc3lzdGVtcz8NCg0KVGhhbmtzLA0KDQpCYXJ0Lg==
