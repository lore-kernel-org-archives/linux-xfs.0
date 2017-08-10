Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mailrelay.collogia.de ([194.8.207.98]:34152 "HELO
        mailrelay.collogia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1752807AbdHJUAE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Aug 2017 16:00:04 -0400
From: Markus Stockhausen <stockhausen@collogia.de>
Subject: AW: Locking problems with Linux 4.9 and 4.11 with NFSD and
 `fs/iomap.c`
Date: Thu, 10 Aug 2017 19:54:51 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD173010E032482@EXCHANGE.collogia.de>
References: <de171adc29600902515d1424fd800678@molgen.mpg.de>
 <20170508131843.GB29840@bfoster.bfoster> <20170509090534.GB2378@lst.de>
 <7ae18b0d-38e3-9b12-0989-ede68956ad43@molgen.mpg.de>
 <358037e8-6784-ebca-9fbb-ec7eef3977d6@molgen.mpg.de>
 <20170510171757.GA10534@localhost.localdomain>
 <f6115b81-918d-ecfe-e3d9-812bccf7c80f@molgen.mpg.de>
 <979473d1-9e8a-51ba-28d9-9ace63f8105b@molgen.mpg.de>
 <20170801225144.GP17762@dastard>
 <92d0933c-f031-f4e7-191e-eb3c9b1260aa@molgen.mpg.de>
In-Reply-To: <92d0933c-f031-f4e7-191e-eb3c9b1260aa@molgen.mpg.de>
Content-Language: de-DE
Content-Type: multipart/mixed;
        boundary="----=_NextPartTM-000-c42412c4-fea1-4a1c-a36f-283f3cc26cc3"
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: 'Paul Menzel' <pmenzel@molgen.mpg.de>, Dave Chinner <david@fromorbit.com>
Cc: "it+linux-nfs@molgen.mpg.de" <it+linux-nfs@molgen.mpg.de>, Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>"it+linux-nfs@molgen.mpg.de" <it+linux-nfs@molgen.mpg.de>, "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>


This is a multi-part message in MIME format.

------=_NextPartTM-000-c42412c4-fea1-4a1c-a36f-283f3cc26cc3
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGkgUGF1bCBldCBhbCwNCg0KPiBEZWFyIERhdmUsDQo+DQo+DQo+IE9uIDA4LzAyLzE3IDAwOjUx
LCBEYXZlIENoaW5uZXIgd3JvdGU6DQo+ID4gT24gVHVlLCBBdWcgMDEsIDIwMTcgYXQgMDc6NDk6
NTBQTSArMDIwMCwgUGF1bCBNZW56ZWwgd3JvdGU6DQo+DQo+ID4+IE9uIDA2LzI3LzE3IDEzOjU5
LCBQYXVsIE1lbnplbCB3cm90ZToNCj4gPj4NCj4gPj4+IEp1c3QgYSBzbWFsbCB1cGRhdGUgdGhh
dCB3ZSB3ZXJlIGhpdCBieSB0aGUgcHJvYmxlbSBvbiBhIGRpZmZlcmVudCANCj4gPj4+IG1hY2hp
bmUgKGlkZW50aWNhbCBtb2RlbCkgd2l0aCBMaW51eCA0LjkuMzIgYW5kIHRoZSBleGFjdCBzYW1l
IA0KPiA+Pj4gc3ltcHRvbXMuDQo+ID4+Pg0KPiA+Pj4gYGBgDQo+ID4+PiAkIHN1ZG8gY2F0IC9w
cm9jLzIwODUvc3RhY2sNCj4gPj4+IFs8ZmZmZmZmZmY4MTFmOTIwYz5dIGlvbWFwX3dyaXRlX2Jl
Z2luKzB4OGMvMHgxMjAgDQo+ID4+PiBbPGZmZmZmZmZmODExZjk4MmI+XSBpb21hcF96ZXJvX3Jh
bmdlX2FjdG9yKzB4ZWIvMHgyMTAgDQo+ID4+PiBbPGZmZmZmZmZmODExZjlhODI+XSBpb21hcF9h
cHBseSsweGEyLzB4MTEwIFs8ZmZmZmZmZmY4MTFmOWM1OD5dIA0KPiA+Pj4gaW9tYXBfemVyb19y
YW5nZSsweDU4LzB4ODAgWzxmZmZmZmZmZjgxMzNjN2RlPl0gDQo+ID4+PiB4ZnNfemVyb19lb2Yr
MHg0ZS8weGIwIFs8ZmZmZmZmZmY4MTMzYzlkZD5dIA0KPiA+Pj4geGZzX2ZpbGVfYWlvX3dyaXRl
X2NoZWNrcysweDE5ZC8weDFjMA0KPiA+Pj4gWzxmZmZmZmZmZjgxMzNjZTg5Pl0geGZzX2ZpbGVf
YnVmZmVyZWRfYWlvX3dyaXRlKzB4NzkvMHgyZDANCj4gPj4+IFs8ZmZmZmZmZmY4MTMzZDE3ZT5d
IHhmc19maWxlX3dyaXRlX2l0ZXIrMHg5ZS8weDE1MCANCj4gPj4+IFs8ZmZmZmZmZmY4MTE5OGRj
MD5dIGRvX2l0ZXJfcmVhZHZfd3JpdGV2KzB4YTAvMHhmMCANCj4gPj4+IFs8ZmZmZmZmZmY4MTE5
OWZiYT5dIGRvX3JlYWR2X3dyaXRldisweDE4YS8weDIzMCANCj4gPj4+IFs8ZmZmZmZmZmY4MTE5
YTJhYz5dIHZmc193cml0ZXYrMHgzYy8weDUwIFs8ZmZmZmZmZmZmZmZmZmZmZj5dIA0KPiA+Pj4g
MHhmZmZmZmZmZmZmZmZmZmZmIGBgYA0KPiA+Pj4NCj4gPj4+IFdlIGhhdmVu4oCZdCBoYWQgdGlt
ZSB0byBzZXQgdXAgYSB0ZXN0IHN5c3RlbSB5ZXQgdG8gYW5hbHl6ZSB0aGF0IGZ1cnRoZXIuDQo+
ID4+DQo+ID4+IFRvZGF5LCB0d28gc3lzdGVtcyB3aXRoIExpbnV4IDQuOS4yMyBleGhpYml0ZWQg
dGhlIHByb2JsZW0gb2YgYHRvcGAgDQo+ID4+IHNob3dpbmcgdGhhdCBgbmZzZGAgaXMgYXQgMTAw
ICUuIFJlc3RhcnRpbmcgb25lIG1hY2hpbmUgaW50byBMaW51eA0KPiA+PiAqNC45LjM4KiBzaG93
ZWQgdGhlIHNhbWUgcHJvYmxlbS4gT25lIG9mIHRoZW0gd2l0aCBhIDEgR0JpdC9zIG5ldHdvcmsg
DQo+ID4+IGRldmljZSBnb3QgdHJhZmZpYyBmcm9tIGEgMTAgR0JpdC9zIHN5c3RlbSwgc28gdGhl
IGNvbm5lY3Rpb24gd2FzIA0KPiA+PiBzYXR1cmF0ZWQuDQo+ID4gDQo+ID4gU28gdGhlIHF1ZXN0
aW9uIGlzIHRoaXM6IGlzIHRoZXJlIElPIGJlaW5nIGlzc3VlZCBoZXJlLCBpcyB0aGUgcGFnZSAN
Cj4gPiBjYWNoZSBncm93aW5nLCBvciBpcyBpdCBpbiBhIHRpZ2h0IGxvb3AgZG9pbmcgbm90aGlu
Zz8gRGV0YWlscyBvZiB5b3VyIA0KPiA+IGhhcmR3YXJlLCBYRlMgY29uZmlnIGFuZCBORlMgc2Vy
dmVyIGNvbmZpZyBpcyBraW5kYSBpbXBvcnRhbnQgaGVyZSwgDQo+ID4gdG9vLg0KDQpMb29raW5n
IGF0IDY0IGJpdCBpbnB1dCBmb3IgdmFyaWFibGUgY291bnQgb2YNCg0KaW9tYXBfemVyb19yYW5n
ZV9hY3RvcihzdHJ1Y3QgaW5vZGUgKmlub2RlLCBsb2ZmX3QgcG9zLCBsb2ZmX3QgY291bnQsDQoJ
CXZvaWQgKmRhdGEsIHN0cnVjdCBpb21hcCAqaW9tYXApDQoNCg0KYW5kIDMyIGJpdCBpbnRlcm5h
bCB2YXJpYWJsZXMNCg0KCQl1bnNpZ25lZCBvZmZzZXQsIGJ5dGVzOw0KDQpjdWxwcml0IGNvdWxk
IGJlDQoNCgkJYnl0ZXMgPSBtaW5fdCh1bnNpZ25lZCwgUEFHRV9TSVpFIC0gb2Zmc2V0LCBjb3Vu
dCk7DQoNCkxldHMgc2F5IHlvdSBhcmUgdHJ5aW5nIHRvIHplcm8gbXVsdGlwbGUgb2YgNEdCIGNo
dW5rcy4gV2l0aCBieXRlcw0KZXZhbHVhdGVkIHRvd2FyZHMgMCB0aGlzIHdpbGwgaGl0IGFuIGVu
ZGxlc3MgbG9vcCB3aXRoaW4gdGhhdCBpb21hcA0KZnVuY3Rpb24uIFRoYXQgbWlnaHQgZXhwbGFp
biB5b3VyIG9ic2VydmF0aW9uLiBJZiB0aGF0IGlzIHJpZ2h0IGEgYnVnZml4DQp3b3VsZCBxdWFs
aWZ5IGZvciBzdGFibGUgNC44Kw0KDQpCZXN0IHJlZ2FyZHMuDQoNCk1hcmt1cw0KDQo+IENvdWxk
IHlvdSBwbGVhc2UgZ3VpZGUgbWUsIHdoZXJlIEkgY2FuIGdldCB0aGUgaW5mb3JtYXRpb24geW91
IHJlcXVlc3Q/DQo+DQo+IFRoZSBoYXJkd2FyZSByYW5nZXMgZnJvbSBzbG93IDEyIHRocmVhZCBz
eXN0ZW1zIHdpdGggOTYgR0IgUkFNIHRvIDgwIHRocmVhZCAxIFRCIFJBTSBtYWNoaW5lcy4gT2Z0
ZW4gYmlnIGZpbGVzICh1cCB0byAxMDAgR0IpIGFyZSB3cml0dGVuLg0KPg0KPiA+IEZvciBleGFt
cGxlLCBpZiB0aGUgTkZTIHNlcnZlciBJTyBwYXR0ZXJucyB0cmlnZ2VyIGEgbGFyZ2Ugc3BlY3Vs
YXRpdmUgDQo+ID4gZGVsYXllZCBhbGxvY2F0aW9uLCB0aGVuIHRoZSBjbGllbnQgZG9lcyBhIHdy
aXRlIGF0IHRoZSBlbmQgb2YgdGhlIA0KPiA+IHNwZWN1bGF0aXZlIGRlbGFsbG9jIHJhbmdlLCB3
ZSB3aWxsIHplcm8gdGhlIGVudGlyZSBzcGVjdWxhdGl2ZSANCj4gPiBkZWxhbGxvYyByYW5nZS4g
VGhhdCBjb3VsZCBiZSBzZXZlcmFsIEdCIG9mIHplcm9zIHRoYXQgbmVlZCB0byBiZSANCj4gPiB3
cml0dGVuIGhlcmUuIEl0J3Mgc3ViLW9wdGltYWwsIHllcywgYW5kIGJ1dCBsYXJnZSB6ZXJvaW5n
IGlzIHJhcmUgDQo+ID4gZW5vdWdoIHRoYXQgd2UgaGF2ZW4ndCBuZWVkZWQgdG8gb3B0aW1pc2Ug
aXQgYnkgYWxsb2NhdGluZyB1bndyaXR0ZW4gDQo+ID4gZXh0ZW50cyBpbnN0ZWFkLiAgSXQgd291
bGQgYmUgcmVhbGx5IGhhbmR5IHRvIGtub3cgd2hhdCBhcHBsaWNhdGlvbiANCj4gPiB0aGUgTkZT
IGNsaWVudCBpcyBydW5uaW5nIGFzIHRoYXQgbWlnaHQgZ2l2ZSBpbnNpZ2h0IGludG8gdGhlIHRy
aWdnZXIgDQo+ID4gYmVoYXZpb3VyIGFuZCB3aGV0aGVyIHlvdSBhcmUgaGl0dGluZyB0aGlzIGNh
c2UuDQo+DQo+IEl0IHJhbmdlcyBmcm9tIHNpbXBsZSBgY3BgIHRvIHNjcmlwdHMgd3JpdGluZyBG
QVNUUSBmaWxlcyB3aXRoIGJpb2xvZ2ljYWwgc2VxdWVuY2VzIGluIGl0Lg0KPg0KPiA+ID4gQWxz
bywgaWYgdGhlIE5GUyBjbGllbnQgaXMgb25seSB3cml0aW5nIHRvIG9uZSBmaWxlLCB0aGVuIGFs
bCB0aGUgDQo+ID4gb3RoZXIgd3JpdGVzIHRoYXQgYXJlIG9uIHRoZSB3aXJlIHdpbGwgZW5kIHVw
IGJlaW5nIHNlcnZpY2VkIGJ5IG5mc2QgDQo+ID4gdGhyZWFkcyB0aGF0IHRoZW4gYmxvY2sgd2Fp
dGluZyBmb3IgdGhlIGlub2RlIGxvY2suIElmIHRoZSBjbGllbnQgDQo+ID4gaXNzdWVzIG1vcmUg
d3JpdGVzIG9uIHRoZSB3aXJlIHRoYW4gdGhlIE5GUyBzZXJ2ZXIgaGFzIHdvcmtlciB0aHJlYWRz
LCANCj4gPiB0aGUgY2xpZW50IHNpZGUgd3JpdGUgd2lsbCBzdGFydmUgdGhlIE5GUyBzZXJ2ZXIg
b2Ygd29ya2VyIHRocmVhZHMgDQo+ID4gdW50aWwgdGhlIHplcm9pbmcgY29tcGxldGVzLiBUaGlz
IGlzIHRoZSBiZWhhdmlvdXIgeW91IGFyZSBzZWVpbmcgLSANCj4gPiBpdCdzIGEgY29tbW9uIHNl
cnZlciBzaWRlIGNvbmZpZyBlcnJvciB0aGF0J3MgYmVlbiBrbm93biBmb3IgYXQgbGVhc3QgDQo+
ID4gMTUgeWVhcnMuLi4NCj4gPiANCj4gPiBGV0lXLCBpdCB1c2VkIHRvIGJlIHRoYXQgYSBsaW51
eCBORlMgY2xpZW50IGNvdWxkIGhhdmUgMTYgY29uY3VycmVudCANCj4gPiBvdXRzdGFuZGluZyBO
RlMgUlBDcyB0byBhIHNlcnZlciBhdCBhIHRpbWUgLSBJIGRvbid0IGtub3cgaWYgdGhhdCANCj4g
PiBsaW1pdCBzdGlsbCBleGlzdHMgb3Igd2hldGhlciBpdCdzIGJlZW4gaW5jcmVhc2VkLiBIb3dl
dmVyLCB0aGUgDQo+ID4gdHlwaWNhbCBrbmZzZCBkZWZhdWx0IGlzIChzdGlsbCkgb25seSA4IHdv
cmtlciB0aHJlYWRzLCBtZWFuaW5nIGEgDQo+ID4gc2luZ2xlIGNsaWVudCBhbmQgc2VydmVyIHVz
aW5nIGRlZmF1bHQgY29uZmlncyBjYW4gY2F1c2UgdGhlIGFib3ZlIA0KPiA+IHNlcnZlciBET1Mg
aXNzdWUuIGUuZyBvbiBhIGJsZWVkaW5nIGVkZ2UgZGViaWFuIGRpc3RybyBpbnN0YWxsOg0KPiA+
IA0KPiA+ICQgaGVhZCAtMiAvZXRjL2RlZmF1bHQvbmZzLWtlcm5lbC1zZXJ2ZXIgIyBOdW1iZXIg
b2Ygc2VydmVycyB0byBzdGFydCANCj4gPiB1cA0KPiA+IFJQQ05GU0RDT1VOVD04DQo+ID4gJA0K
PiA+IA0KPiA+IFNvLCB5ZWFoLCBkaXN0cm9zIHN0aWxsIG9ubHkgY29uZmlndXJlIHRoZSBuZnMg
c2VydmVyIHdpdGggOCB3b3JrZXIgDQo+ID4gdGhyZWFkIGJ5IGRlZmF1bHQuIElmIGl0J3MgYSBk
ZWRpY2F0ZWQgTkZTIHNlcnZlciwgdGhlbiBJJ2QgYmUgdXNpbmcgDQo+ID4gc29tZXdoZXJlIGFy
b3VuZCA2NCBORlNEIHRocmVhZHMgKnBlciBDUFUqIGFzIGEgc3RhcnRpbmcgcG9pbnQgZm9yIHRo
ZSANCj4gPiBzZXJ2ZXIgY29uZmlnLi4uDQo+ID4gDQo+ID4gQXQgbWluaW11bSwgeW91IG5lZWQg
dG8gZW5zdXJlIHRoYXQgdGhlIE5GUyBzZXJ2ZXIgaGFzIGF0IGxlYXN0IGRvdWJsZSANCj4gPiB0
aGUgbnVtYmVyIG9mIHNlcnZlciB0aHJlYWRzIGFzIHRoZSBsYXJnZXN0IGNsaWVudCBzaWRlIGNv
bmN1cnJlbnQgUlBDIA0KPiA+IGNvdW50IHNvIHRoYXQgYSBzaW5nbGUgY2xpZW50IGNhbid0IERP
UyB0aGUgTkZTIHNlcnZlciB3aXRoIGEgc2luZ2xlIA0KPiA+IGJsb2NrZWQgd3JpdGUgc3RyZWFt
Lg0KPg0KPiBUaGF04oCZcyBub3QgdGhlIGlzc3VlIGhlcmUuIEl04oCZcyBzdGFydGVkIHdpdGgg
NjQgdGhyZWFkcyBoZXJlLiBBbHNvIHRoaXMgZG9lc27igJl0IGV4cGxhaW4sIHdoeSBpdCB3b3Jr
cyB3aXRoIHRoZSA0LjQgc2VyaWVzLiANCj4NCj4gVGhlIGRpcmVjdG9yeSBjYW5ub3QgYmUgYWNj
ZXNzZWQgYXQgYWxsLiBgbHMgL21vdW50ZWQvcGF0aGAganVzdCBoYW5ncyBvbiByZW1vdGUgc3lz
dGVtcy4NCj4NCj4NCj4gS2luZCByZWdhcmRzLA0KPg0KPiBQYXVsDQoNCg==
------=_NextPartTM-000-c42412c4-fea1-4a1c-a36f-283f3cc26cc3
Content-Type: text/plain;
	name="InterScan_Disclaimer.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="InterScan_Disclaimer.txt"

****************************************************************************
Diese E-Mail enthält vertrauliche und/oder rechtlich geschützte
Informationen. Wenn Sie nicht der richtige Adressat sind oder diese E-Mail
irrtümlich erhalten haben, informieren Sie bitte sofort den Absender und
vernichten Sie diese Mail. Das unerlaubte Kopieren sowie die unbefugte
Weitergabe dieser Mail ist nicht gestattet.

Über das Internet versandte E-Mails können unter fremden Namen erstellt oder
manipuliert werden. Deshalb ist diese als E-Mail verschickte Nachricht keine
rechtsverbindliche Willenserklärung.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

Vorstand:
Kadir Akin
Dr. Michael Höhnerbach

Vorsitzender des Aufsichtsrates:
Hans Kristian Langva

Registergericht: Amtsgericht Köln
Registernummer: HRB 52 497

This e-mail may contain confidential and/or privileged information. If you
are not the intended recipient (or have received this e-mail in error)
please notify the sender immediately and destroy this e-mail. Any
unauthorized copying, disclosure or distribution of the material in this
e-mail is strictly forbidden.

e-mails sent over the internet may have been written under a wrong name or
been manipulated. That is why this message sent as an e-mail is not a
legally binding declaration of intention.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

executive board:
Kadir Akin
Dr. Michael Höhnerbach

President of the supervisory board:
Hans Kristian Langva

Registry office: district court Cologne
Register number: HRB 52 497

****************************************************************************

------=_NextPartTM-000-c42412c4-fea1-4a1c-a36f-283f3cc26cc3--
