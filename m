Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D77F57CA0
	for <xfs@oss.sgi.com>; Mon, 25 Apr 2016 12:14:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AA99E304032
	for <xfs@oss.sgi.com>; Mon, 25 Apr 2016 10:14:39 -0700 (PDT)
Received: from mga04.intel.com ([192.55.52.120]) by cuda.sgi.com with ESMTP id
	UD9ghjMKB5OCqqr0 for <xfs@oss.sgi.com>;
	Mon, 25 Apr 2016 10:14:38 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v2 5/5] dax: handle media errors in dax_do_io
Date: Mon, 25 Apr 2016 17:14:36 +0000
Message-ID: <1461604476.3106.12.camel@intel.com>
References: <1459303190-20072-1-git-send-email-vishal.l.verma@intel.com>
	<1459303190-20072-6-git-send-email-vishal.l.verma@intel.com>
	<x49twj26edj.fsf@segfault.boston.devel.redhat.com>
	<20160420205923.GA24797@infradead.org>
	<1461434916.3695.7.camel@intel.com>
	<20160425083114.GA27556@infradead.org>
In-Reply-To: <20160425083114.GA27556@infradead.org>
Content-Language: en-US
Content-ID: <80F5C603E926CF47BF71F79A2B125709@intel.com>
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
To: "hch@infradead.org" <hch@infradead.org>
Cc: "axboe@fb.com" <axboe@fb.com>, "jack@suse.cz" <jack@suse.cz>, "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "jmoyer@redhat.com" <jmoyer@redhat.com>, "Wilcox,
	Matthew R" <matthew.r.wilcox@intel.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>

T24gTW9uLCAyMDE2LTA0LTI1IGF0IDAxOjMxIC0wNzAwLCBoY2hAaW5mcmFkZWFkLm9yZyB3cm90
ZToNCj4gT24gU2F0LCBBcHIgMjMsIDIwMTYgYXQgMDY6MDg6MzdQTSArMDAwMCwgVmVybWEsIFZp
c2hhbCBMIHdyb3RlOg0KPiA+IA0KPiA+IGRpcmVjdF9JTyBtaWdodCBmYWlsIHdpdGggLUVJTlZB
TCBkdWUgdG8gbWlzYWxpZ25tZW50LCBvciAtRU5PTUVNDQo+ID4gZHVlDQo+ID4gdG8gc29tZSBh
bGxvY2F0aW9uIGZhaWxpbmcsIGFuZCBJIHRob3VnaHQgd2Ugc2hvdWxkIHJldHVybiB0aGUNCj4g
PiBvcmlnaW5hbA0KPiA+IC1FSU8gaW4gc3VjaCBjYXNlcyBzbyB0aGF0IHRoZSBhcHBsaWNhdGlv
biBkb2Vzbid0IGxvc2UgdGhlDQo+ID4gaW5mb3JtYXRpb24NCj4gPiB0aGF0IHRoZSBiYWQgYmxv
Y2sgaXMgYWN0dWFsbHkgY2F1c2luZyB0aGUgZXJyb3IuDQo+IEVJTlZBTCBpcyBhIGNvbmNlcm4g
aGVyZS7CoMKgTm90IGR1ZSB0byB0aGUgcmlnaHQgZXJyb3IgcmVwb3J0ZWQsIGJ1dA0KPiBiZWNh
dXNlIGl0IG1lYW5zIHlvdXIgY3VycmVudCBzY2hlbWUgaXMgZnVuZGFtZW50YWxseSBicm9rZW4g
LSB3ZQ0KPiBuZWVkIHRvIHN1cHBvcnQgSS9PIGF0IGFueSBhbGlnbm1lbnQgZm9yIERBWCBJL08s
IGFuZCBub3QgZmFpbCBkdWUgdG8NCj4gYWxpZ25ibWVudCBjb25jZXJuZXMgZm9yIGEgaGlnaGx5
IHNwZWNpZmljIGRlZ3JhZGVkIGNhc2UuDQo+IA0KPiBJIHRoaW5rIHRoaXMgd2hvbGUgc2VyaWVz
IG5lZWQgdG8gZ28gYmFjayB0byB0aGUgZHJhd2luZyBib2FyZCBhcyBJDQo+IGRvbid0IHRoaW5r
IGl0IGNhbiBhY3R1YWxseSByZWx5IG9uIHVzaW5nIGRpcmVjdCBJL08gYXMgdGhlIEVJTw0KPiBm
YWxsYmFjay4NCj4gDQpBZ3JlZWQgdGhhdCBEQVggSS9PIGNhbiBoYXBwZW4gd2l0aCBhbnkgc2l6
ZS9hbGlnbm1lbnQsIGJ1dCBob3cgZWxzZSBkbw0Kd2Ugc2VuZCBhbiBJTyB0aHJvdWdoIHRoZSBk
cml2ZXIgd2l0aG91dCBhbGlnbm1lbnQgcmVzdHJpY3Rpb25zPyBBbHNvLA0KdGhlIGdyYW51bGFy
aXR5IGF0IHdoaWNoIHdlIHN0b3JlIGJhZGJsb2NrcyBpcyA1MTJCIHNlY3RvcnMsIHNvIGl0DQpz
ZWVtcyBuYXR1cmFsIHRoYXQgdG8gY2xlYXIgc3VjaCBhIHNlY3RvciwgeW91J2QgZXhwZWN0IHRv
IHNlbmQgYSB3cml0ZQ0KdG8gdGhlIHdob2xlIHNlY3Rvci4NCg0KVGhlIGV4cGVjdGVkIHVzYWdl
IGZsb3cgaXM6DQoNCi0gQXBwbGljYXRpb24gaGl0cyBFSU8gZG9pbmcgZGF4X0lPIG9yIGxvYWQv
c3RvcmUgaW8NCg0KLSBJdCBjaGVja3MgYmFkYmxvY2tzIGFuZCBkaXNjb3ZlcnMgaXQncyBmaWxl
cyBoYXZlIGxvc3QgZGF0YQ0KDQotIEl0IHdyaXRlKClzIHRob3NlIHNlY3RvcnMgKHBvc3NpYmx5
IGNvbnZlcnRlZCB0byBmaWxlIG9mZnNldHMgdXNpbmcNCmZpZW1hcCkNCsKgIMKgICogVGhpcyB0
cmlnZ2VycyB0aGUgZmFsbGJhY2sgcGF0aCwgYnV0IGlmIHRoZSBhcHBsaWNhdGlvbiBpcyBkb2lu
Zw0KdGhpcyBsZXZlbCBvZiByZWNvdmVyeSwgaXQgd2lsbCBrbm93IHRoZSBzZWN0b3IgaXMgYmFk
LCBhbmQgd3JpdGUgdGhlDQplbnRpcmUgc2VjdG9yDQoNCi0gT3IgaXQgcmVwbGFjZXMgdGhlIGVu
dGlyZSBmaWxlIGZyb20gYmFja3VwIGFsc28gdXNpbmcgd3JpdGUoKSAobm90DQptbWFwK3N0b3Jl
cykNCsKgIMKgICogVGhpcyBqdXN0IGZyZWVzIHRoZSBmcyBibG9jaywgYW5kIHRoZSBuZXh0IHRp
bWUgdGhlIGJsb2NrIGlzDQpyZWFsbG9jYXRlZCBieSB0aGUgZnMsIGl0IHdpbGwgbGlrZWx5IGJl
IHplcm9lZCBmaXJzdCwgYW5kIHRoYXQgd2lsbCBiZQ0KZG9uZSB0aHJvdWdoIHRoZSBkcml2ZXIg
YW5kIHdpbGwgY2xlYXIgZXJyb3JzDQoNCg0KSSB0aGluayBpZiB3ZSB3YW50IHRvIGtlZXAgYWxs
b3dpbmcgYXJiaXRyYXJ5IGFsaWdubWVudHMgZm9yIHRoZQ0KZGF4X2RvX2lvIHBhdGgsIHdlJ2Qg
bmVlZDoNCjEuIFRvIHJlcHJlc2VudCBiYWRibG9ja3MgYXQgYSBmaW5lciBncmFudWxhcml0eSAo
bGlrZWx5IGNhY2hlIGxpbmVzKQ0KMi4gVG8gYWxsb3cgdGhlIGRyaXZlciB0byBkbyBJTyB0byBh
ICpibG9jayBkZXZpY2UqIGF0IHN1Yi1zZWN0b3INCmdyYW51bGFyaXR5DQoNCkNhbiB3ZSBkbyB0
aGF0PwpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMg
bWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9s
aXN0aW5mby94ZnMK
