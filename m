Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F39BB7D27
	for <xfs@oss.sgi.com>; Wed, 27 Apr 2016 13:31:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9B7518F8033
	for <xfs@oss.sgi.com>; Wed, 27 Apr 2016 11:31:47 -0700 (PDT)
Received: from lynxeye.de (ns.lynxeye.de [87.118.118.114]) by cuda.sgi.com
	with ESMTP id HBZfxAfxn7QGSPKL for <xfs@oss.sgi.com>;
	Wed, 27 Apr 2016 11:31:44 -0700 (PDT)
Message-ID: <1461781898.2516.10.camel@lynxeye.de>
Subject: Re: [PATCH] xfs: idle aild if the AIL is pushed up to the target LSN
From: Lucas Stach <dev@lynxeye.de>
Date: Wed, 27 Apr 2016 20:31:38 +0200
In-Reply-To: <20160425230833.GC18496@dastard>
References: <1461570163-4083-1-git-send-email-dev@lynxeye.de>
	<20160425142444.GC33882@bfoster.bfoster>
	<1461607897.2364.27.camel@lynxeye.de> <20160425230833.GC18496@dastard>
Mime-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

QW0gRGllbnN0YWcsIGRlbiAyNi4wNC4yMDE2LCAwOTowOCArMTAwMCBzY2hyaWViIERhdmUgQ2hp
bm5lcjoKWy4uLl0KPiA+IAo+ID4gPiAKPiA+ID4gVGhhdCBzYWlkLCBJJ20gbm90IHN1cmUgd2hl
dGhlciB0aGVyZSdzIGEgbm90YWJsZSBiZW5lZml0IG9mCj4gPiA+IGlkbGluZwo+ID4gPiBmb3IK
PiA+ID4gNTBtcyBvdmVyIGp1c3Qgc2NoZWR1bGluZyBvdXQgd2hlbiB3ZSd2ZSBoaXQgdGhlIHRh
cmdldCBsc24uIEl0Cj4gPiA+IHNlZW1zCj4gPiA+IGxpa2UgdGhhdCBhbnlib2R5IHdobyBwdXNo
ZXMgdGhlIHRhcmdldCBmb3J3YXJkIGFnYWluIGlzIGdvaW5nIHRvCj4gPiA+IHdha2UKPiA+ID4g
dXAgdGhlIHRocmVhZCBhbnl3YXlzLiBPbiB0aGUgb3RoZXIgaGFuZCwgaWYgdGhlIGZzIGlzIGlk
bGUgdGhlCj4gPiA+IHRocmVhZAo+ID4gPiB3aWxsIGV2ZW50dWFsbHkgc2NoZWR1bGUgb3V0IGlu
ZGVmaW5pdGVseS7CoAo+ID4gSXMgdGhpcyBhIHByb2JsZW0/IFRoZSBwYXRjaCB0cmllcyB0byBk
byBleGFjdGx5IHRoYXQ6IHNjaGVkdWxlIG91dAo+ID4gYWlsZCBpbmRlZmluaXRlbHkgd2hlbiB0
aGVyZSBpcyBubyBtb3JlIHdvcmsgdG8gZG8gYXMgbm9ib2R5IGlzCj4gPiBwdXNoaW5nCj4gPiB0
aGUgdGFyZ2V0IExTTiBmb3J3YXJkLgo+IElmIHRoZSBmaWxlc3lzdGVtIGlzIHNsb3dseSBiZWlu
ZyBkaXJ0aWVkLCB0aGVuIHRoZSBhaWxkIHNob3VsZCd0Cj4gcmVhbGx5IGlkbGUgYXQgYWxsLmkK
PiAKPiBLZWVwIGluIG1pbmQgdGhhdCB0aGUgeGZzYWlsZCBoYXMgbXVsdGlwbGUgZnVuY3Rpb25z
LCBvbmUgb2Ygd2hpY2gKPiBpcyBhIHdhdGNoZG9nIHRoYXQgY2F0Y2hlcyBsb2cgc3BhY2Ugc3Rh
bGxzIHRoYXQgd291bGQgb3RoZXJ3aXNlCj4gaGFuZyB0aGUgZmlsZXN5c3RlbS4gRXZlcnkgdGlt
ZSB3ZSd2ZSByZW1vdmVkIHRoZSB3YXRjaGRvZyBmdW5jdGlvbgo+IChpLmUuwqDCoGFncmVzc2l2
ZWx5IGlkbGUgdGhlIGFpbGQpIHdlJ3ZlIGhhZCB1c2VycyByZXBvcnQgcmFuZG9tLAo+IHVucmVw
cm9kdWNhYmxlIGhhbmdzL3N0YWxscyB0aGF0IGhhdmUgZ29uZSBhd2F5IHdoZW4gdGhlIHdhdGNo
ZG9nCj4gZnVuY3Rpb24gKGkuZS4gZG9uJ3QgaWRsZSB1bnRpbCB0aGUgbG9nIGlzIGNvdmVyZWQg
YW5kIGNvbXBsZXRlbHkKPiBpZGxlKSB3YXMgcmUtaW5zdGF0ZWQuLi4KPiAKSSBjYW4gb25seSBz
ZWXCoHhmc2FpbGRfcHVzaCgpIGRvaW5nIGFueSB3b3JrIGFmdGVyIGl0IGhhcyBoaXQgdGhlCnRh
cmdldCBMU04gaWYgc29tZXRoaW5nIG1vdmVzIHRoZSB0YXJnZXQgTFNOIGZvcndhcmQuIFlvdSBz
YXkgdGhhdAphZ2dyZXNzaXZlbHkgaWRsaW5nIGFpbGQgbWlnaHQgcHJvZHVjZSBsb2cgc3RhbGxz
LCB3aGljaCB3b3VsZCBpbXBseQp0aGVyZSBhcmUgcmFjZXMgaW4gdGhlIGNvZGUgd2hlcmUgYSBj
b2RlIHBhdGggdGhhdCBtb3ZlcyB0aGUgdGFyZ2V0IExTTgpmb3J3YXJkIGRvZXNuJ3QgcHJvcGVy
bHkgd2FrZSB1cCBhaWxkLgoKV291bGRuJ3QgdGhpcyBwcm9ibGVtIGFsc28gYmUgcHJlc2VudCB3
aGVuIGRvaW5nIG5vbi1hZ2dyZXNzaXZlIGlkbGUgb2YKYWlsZCwganVzdCB0aGUgcHJvYmFiaWxp
dHkgb2YgaGl0dGluZyB0aGUgaXNzdWUgYmVpbmcgcmVkdWNlZApzaWduaWZpY2FudGx5PyBUaGUg
Y29tbWl0IHRoYXQgcmUtZW5hYmxlZCBub24tYWdncmVzc2l2ZSBhaWxkIGlkbGUKZXNwZWNpYWxs
eSBtZW50aW9ucyBzb21lIHJhY2VzIHRoYXQgaGF2ZSBiZWVuIGZpeGVkIGFuZCBJIHRoaW5rIHRo
b3NlCmZpeGVzIHNob3VsZCBhbGxvdyBmb3IgYWdyZXNzaXZlIGFpbGQgaWRsZS4gSWYgdGhleSBh
cmUgaW5zdWZmaWNpZW50IGl0CndvdWxkbid0IGJlIHNhZmUgdG8gaWRsZSBhaWxkIGF0IGFsbCwg
cmlnaHQ/CgpSZWdhcmRzLApMdWNhcwoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29z
cy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
