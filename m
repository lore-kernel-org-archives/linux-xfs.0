Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 732847CA4
	for <xfs@oss.sgi.com>; Sun,  8 May 2016 13:42:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 45ACD8F8033
	for <xfs@oss.sgi.com>; Sun,  8 May 2016 11:42:41 -0700 (PDT)
Received: from mga01.intel.com ([192.55.52.88]) by cuda.sgi.com with ESMTP id
	DTWjf3pW9hQw2FMg for <xfs@oss.sgi.com>;
	Sun, 08 May 2016 11:42:40 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v4 5/7] fs: prioritize and separate direct_io from dax_io
Date: Sun, 8 May 2016 18:42:37 +0000
Message-ID: <1462732956.3006.4.camel@intel.com>
References: <1461878218-3844-1-git-send-email-vishal.l.verma@intel.com>
	<1461878218-3844-6-git-send-email-vishal.l.verma@intel.com>
	<5727753F.6090104@plexistor.com> <20160505142433.GA4557@infradead.org>
	<CAPcyv4gdmo5m=Arf5sp5izJfNaaAkaaMbOzud8KRcBEC8RRu1Q@mail.gmail.com>
	<20160505152230.GA3994@infradead.org>
	<1462484695.29294.7.camel@intel.com>
	<20160508090115.GE15458@infradead.org>
In-Reply-To: <20160508090115.GE15458@infradead.org>
Content-Language: en-US
Content-ID: <B6594FF11BB2934CB392E1BB62812FC5@intel.com>
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
Cc: "axboe@fb.com" <axboe@fb.com>, "jack@suse.cz" <jack@suse.cz>, "matthew@wil.cx" <matthew@wil.cx>, "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>

T24gU3VuLCAyMDE2LTA1LTA4IGF0IDAyOjAxIC0wNzAwLCBoY2hAaW5mcmFkZWFkLm9yZyB3cm90
ZToNCj4gT24gVGh1LCBNYXkgMDUsIDIwMTYgYXQgMDk6NDU6MDdQTSArMDAwMCwgVmVybWEsIFZp
c2hhbCBMIHdyb3RlOg0KPiA+IA0KPiA+IEknbSBub3Qgc3VyZSBJIGNvbXBsZXRlbHkgdW5kZXJz
dGFuZCBob3cgdGhpcyB3aWxsIHdvcms/IENhbiB5b3UNCj4gPiBleHBsYWluDQo+ID4gYSBiaXQ/
IFdvdWxkIHdlIGhhdmUgdG8gZXhwb3J0IHJ3X2J5dGVzIHVwIHRvIGxheWVycyBhYm92ZSB0aGUg
cG1lbQ0KPiA+IGRyaXZlcj8gV2hlcmUgZG9lcyBnZXRfdXNlcl9wYWdlcyBjb21lIGluPw0KPiBB
IERBWCBmaWxlc3lzdGVtIGNhbiBkaXJlY3RseSB1c2UgdGhlIG52ZGltbSBsYXllciB0aGUgc2Ft
ZSB3YXkgYnR0DQo+IGRvZSxzIHdoYXQncyB0aGUgcHJvYmxlbT8NCg0KVGhlIEJUVCBkb2VzIHJ3
X2J5dGVzIHRocm91Z2ggYW4gaW50ZXJuYWwtdG8tbGlibnZkaW1tIG1lY2hhbmlzbSwgYnV0DQpy
d19ieXRlcyBpc24ndCBleHBvcnRlZCB0byB0aGUgZmlsZXN5c3RlbSwgY3VycmVudGx5Li4gVG8g
ZG8gdGhpcyB3ZSdkDQpoYXZlIHRvIGVpdGhlciBhZGQgYW4gcndfYnl0ZXMgdG8gYmxvY2sgZGV2
aWNlIG9wZXJhdGlvbnMuLi5vcg0Kc29tZXRoaW5nLg0KDQpBbm90aGVyIHRoaW5nIGlzIHJ3X2J5
dGVzIGN1cnJlbnRseSBkb2Vzbid0IGRvIGVycm9yIGNsZWFyaW5nIGVpdGhlci4NCldlIHN0b3Jl
IGJhZGJsb2NrcyBhdCBzZWN0b3IgZ3JhbnVsYXJpdHksIGFuZCBsaWtlIERhbiBzYWlkIGVhcmxp
ZXIsDQp0aGF0IGhpZGVzIHRoZSBjbGVhcl9lcnJvciBhbGlnbm1lbnQgcmVxdWlyZW1lbnRzIGFu
ZCB1cHBlciBsYXllcnMNCmRvbid0IGhhdmUgdG8gYmUgYXdhcmUgb2YgaXQuIFRvIG1ha2Ugcndf
Ynl0ZXMgY2xlYXIgc3ViLXNlY3RvciBlcnJvcnMsDQp3ZSdkIGhhdmUgdG8gY2hhbmdlIHRoZSBn
cmFudWxhcml0eSBvZiBiYWQtYmxvY2tzLCBhbmQgbWFrZSB1cHBlcg0KbGF5ZXJzIGF3YXJlIG9m
IHRoZSBjbGVhcmluZyBhbGlnbm1lbnQgcmVxdWlyZW1lbnRzLg0KDQpVc2luZyBhIGJsb2NrLXdy
aXRlIHNlbWFudGljIGZvciBjbGVhcmluZyBoaWRlcyBhbGwgdGhpcyBhd2F5Lg0KDQo+IA0KPiBS
ZSBnZXRfdXNlcl9wYWdlcyBteSBpZGVhIHdhcyB0byBzaW1wbHkgdXNlIHRoYXQgdG8gbG9jayBk
b3duIHRoZQ0KPiB1c2VyDQo+IHBhZ2VzIHNvIHRoYXQgd2UgY2FuIGNhbGwgcndfYnl0ZXMgb24g
aXQuwqDCoEhvdyBlbHNlIHdvdWxkIHlvdSBkbw0KPiBpdD/CoMKgRG8NCj4gYSBrbWFsbG9jLCBj
b3B5X2Zyb21fdXNlciBhbmQgdGhlbiBhbm90aGVyIG1lbWNweT8KX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNn
aS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
