Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A99447CA0
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 17:42:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7CA4D304039
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 15:42:44 -0700 (PDT)
Received: from mga11.intel.com ([192.55.52.93]) by cuda.sgi.com with ESMTP id
	KB0TyclWtN2YNDib for <xfs@oss.sgi.com>;
	Wed, 11 May 2016 15:42:43 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: iomap infrastructure and multipage writes V4
Date: Wed, 11 May 2016 22:42:37 +0000
Message-ID: <1463006545.29294.32.camel@intel.com>
References: <1462783638-4968-1-git-send-email-hch@lst.de>
In-Reply-To: <1462783638-4968-1-git-send-email-hch@lst.de>
Content-Language: en-US
Content-ID: <AA02B8B69C3FC24A9F15891A73BBA518@intel.com>
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
To: "hch@lst.de" <hch@lst.de>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Cc: "rpeterso@redhat.com" <rpeterso@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>

T24gTW9uLCAyMDE2LTA1LTA5IGF0IDEwOjQ3ICswMjAwLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90
ZToNCj4gVGhpcyBzZXJpZXMgYWRkIGEgbmV3IGZpbGUgc3lzdGVtIEkvTyBwYXRoIHRoYXQgdXNl
cyB0aGUgaW9tYXANCj4gc3RydWN0dXJlDQo+IGludHJvZHVjZWQgZm9yIHRoZSBwTkZTIHN1cHBv
cnQgYW5kIHN1cHBvcnQgbXVsdGktcGFnZSBidWZmZXJlZA0KPiB3cml0ZXMuDQo+IA0KPiBUaGlz
IHdhcyBmaXJzdCBzdGFydGVkIGJ5IERhdmUgQ2hpbm5lciBhIGxvbmcgdGltZSBhZ28sIHRoZW4g
SSBkaWQNCj4gYmVhdA0KPiBpdCBpbnRvIHNoYXBlIGZvciBwcm9kdWN0aW9uIHJ1bnMgaW4gYSB2
ZXJ5IGNvbnN0cmFpbmVkIEFSTSBOQVMNCj4gZW52aXJvbWVudCBmb3IgVHV4ZXJhIGFsbW9zdCBh
cyBsb25nIGFnbywgYW5kIG5vdyBoYWxmIGEgZG96ZW4NCj4gcmV3cml0ZXMNCj4gbGF0ZXIgaXQn
cyBiYWNrLg0KPiANCj4gVGhlIGJhc2ljIGlkZWEgaXMgdG8gYXZvaWQgdGhlIHBlci1ibG9jayBn
ZXRfYmxvY2tzIG92ZXJoZWFkDQo+IGFuZCBtYWtlIHVzZSBvZiBleHRlbnRzIGluIHRoZSBidWZm
ZXJlZCB3cml0ZSBwYXRoIGJ5IGl0ZXJhdGluZyBvdmVyDQo+IHRoZW0gaW5zdGVhZC4NCj4gDQo+
IE5vdGUgdGhhdCBwYXRjaCAxIGNvbmZsaWN0cyB3aXRoIFZpc2hhbHMgZGF4IGVycm9yIGhhbmRs
aW5nIHNlcmllcy4NCj4gSXQgd291bGQgYmUgZ3JlYXQgdG8gaGF2ZSBhIHN0YWJsZSBicmFuY2gg
d2l0aCBpdCBzbyB0aGF0IGJvdGggdGhlDQo+IFhGUyBhbmQgbnZkaW1tIHRyZWUgY291bGQgcHVs
bCBpdCBpbiBiZWZvcmUgdGhlIG90aGVyIGNoYW5nZXMgaW4gdGhpcw0KPiBhcmVhLg0KDQpJJ20g
bG9va2luZyB0byBwb3N0IGEgc3RhYmxlIGJyYW5jaCB3aXRoIG15IHBhdGNoZXMgc29vbi4gTXkg
cGF0Y2hlcw0KZGVwZW5kIG9uIEphbidzIGZpeGVzIGZvciBleHQ0IGFuZCBEQVgsIGFuZCBhcyBz
b29uIGFzIHRoZXkgbGFuZCBpbiBhDQpzdGFibGUgZXh0NCBicmFuY2gsIEknbGwgY3JlYXRlIG9u
ZSBmb3IgZGF4IGVycm9yIGhhbmRsaW5nLiBJbiB0aGUNCm1lYW53aGlsZSwgdjcgb2YgbXkgcGF0
Y2hlcyBpbmNsdWRlcyB5b3VyIHBhdGNoIDEgdXBkYXRlZCBmb3IgdGhlIGVycm9yDQpoYW5kbGlu
ZyBzZXJpZXMuDQoNCj4gDQo+IENoYW5nZXMgc2luY2UgVjM6DQo+IMKgLSBmaXggREFYIGJhc2Vk
IHplcm9pbmcNCj4gwqAtIFJldmlld3MgYW5kIHRyaXZpYWwgZml4ZXMgZnJvbSBCb2INCj4gDQo+
IENoYW5nZXMgc2luY2UgVjI6DQo+IMKgLSBmaXggdGhlIHJhbmdlIGZvciBkZWxhbGxvYyBwdW5j
aGVzIGFmdGVyIGZhaWxlZCB3cml0ZXMNCj4gwqAtIHVwZGF0ZWQgc29tZSBjaGFuZ2Vsb2dzDQo+
IA0KPiBDaGFuY2VzIHNpbmNlIFYxOg0KPiDCoC0gYWRkIHN1cHBvcnQgZm9yIGZpZW1hcA0KPiDC
oC0gZml4IGEgdGVzdCBmYWlsIG9uIDFrIGJsb2NrIHNpemVzDQo+IMKgLSBwcmVwYXJlIGZvciA2
NC1iaXQgbGVuZ3RoLCB0aGlzIHdpbGwgYmUgdXNlZCBpbiBhIGZvbGxvdyBvbg0KPiBwYXRjaHNl
dA0KPiAKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZz
IG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4v
bGlzdGluZm8veGZzCg==
