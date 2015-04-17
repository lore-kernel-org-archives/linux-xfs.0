Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4F2867F3F
	for <xfs@oss.sgi.com>; Fri, 17 Apr 2015 03:15:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 44B44304032
	for <xfs@oss.sgi.com>; Fri, 17 Apr 2015 01:15:54 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	jWucwfVVjb8FftSf for <xfs@oss.sgi.com>;
	Fri, 17 Apr 2015 01:15:51 -0700 (PDT)
Date: Fri, 17 Apr 2015 18:15:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: use percpu_counter_compare instead of naive comparing
Message-ID: <20150417081549.GG15810@dastard>
References: <1429237344-5668-1-git-send-email-xuw2015@gmail.com>
	<20150417040605.GE15810@dastard>
	<CAPBX1xK85i8x3h1XmGsYi=0YvRiWqvKhFTOY-QJ3-XDtmm7BVg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPBX1xK85i8x3h1XmGsYi=0YvRiWqvKhFTOY-QJ3-XDtmm7BVg@mail.gmail.com>
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
To: =?utf-8?B?546L5pet?= <xuw2015@gmail.com>
Cc: xfs@oss.sgi.com

T24gRnJpLCBBcHIgMTcsIDIwMTUgYXQgMDM6MTU6MjFQTSArMDgwMCwg546L5petIHdyb3RlOgo+
IE9uIEZyaSwgQXByIDE3LCAyMDE1IGF0IDEyOjA2IFBNLCBEYXZlIENoaW5uZXIgPGRhdmlkQGZy
b21vcmJpdC5jb20+IHdyb3RlOgo+ID4gT24gRnJpLCBBcHIgMTcsIDIwMTUgYXQgMTA6MjI6MjRB
TSArMDgwMCwgeHV3MjAxNUBnbWFpbC5jb20gd3JvdGU6Cj4gPj4gRnJvbTogR2VvcmdlIFdhbmcg
PHh1dzIwMTVAZ21haWwuY29tPgo+ID4+Cj4gPj4gRnVuY3Rpb24gcGVyY3B1X2NvdW50ZXJfcmVh
ZCBqdXN0IHJldHVybiB0aGUgY3VycmVudCBjb3VudGVyLCByZWdhcmRsZXNzIG9mCj4gPj4gZXZl
cnkgY3B1J3MgY291bnQuIFRoaXMgY291bnRlciBjYW4gYmUgbmVnYXRpdmUgdmFsdWUsIHdoaWNo
IHdpbGwgY2F1c2UgdGhlCj4gPj4gY2hlY2tpbmcgb2YgImFsbG9jYXRlZCBpbm9kZSBjb3VudHMg
PD0gbV9tYXhpY291bnQiIGZhbHNlIHBvc2l0aXZlLgo+ID4KPiA+IEhhdmUgeW91IGFjdHVhbGx5
IHNlZW4gdGhpcywgb3IgaXMgaXQganVzdCB0aGVvcmV0aWNhbD8KPiAKPiBJIHByb2R1Y2VkIGl0
IGJ5IHJ1bm5pbmcgdW5pb25tb3VudC10ZXN0c3VpdGVzIGZvciBvdmVybGF5LCBiYXNlZCB4ZnMg
YXMgdXBwZXIKPiBhbmQgbG93ZXJkaXIuIEkgdGhpbmsgSSBjYW4gZXh0cmFjdCB0aGUgcHJvY2Vk
dXJlIHRvIHJlcHJvZHVjZSBpdC4KCkludGVlc3RpbmcuIEkndmUgbmV2ZXIgYmVlbiBhYmxlIHRv
IGdldCB0aGUgdW5pb25tb3VudC10ZXN0c3VpdCB0bwphY3R1YWxseSBiZSBhYmxlIHRvIHJ1biwg
bGV0IGFsb25lIGhhZCBpdCBmaW5kIHByb2JsZW1zLgoKPiA+PiBDb21taXQgNTAxYWIzMjM4NzUz
ICJ4ZnM6IHVzZSBnZW5lcmljIHBlcmNwdSBjb3VudGVycyBmb3IgaW5vZGUgY291bnRlcgo+IDxz
bmlwPgo+ID4gVGhlIGNvcnJlY3QgZml4IGlzIHRvIHVzZSBwZXJjcHVfY291bnRlcl9yZWFkX3Bv
c2l0aXZlKCksIGJlY2F1c2UgaW4KPiA+IHRoZSBtYWpvcml0eSBvZiBjYXNlcyBhcmdzLm1wLT5t
X21heGljb3VudCBpcyBvcmRlcnMgb2YgbWFnbml0dWRlCj4gPiBsYXJnZXIgKDIwIG1pbGxpb24g
aW5vZGVzIHBlciAxMDBHQiBvZiBmcyBzcGFjZSBmb3Igc21hbGwgZmlsZXN5c3RlbXMpCj4gPiB0
aGFuIHRoZSB1bmFnZ3JlZ2F0ZWQgcGVyLWNwdSBjb3VudHMgY2FuIGNhdXNlIHRoZSBzdW0gdG8g
Z28KPiA+IG5lZ2F0aXZlLiBIZW5jZSBpZiBpdCBpcyBuZWdhdGl2ZSwgaXQgbWF5IGFzIHdlbGwg
YmUgemVybyBiZWNhdXNlIGl0Cj4gPiBtYWtlcyBubyBkaWZmZXJlbmNlIHRvIHRoZSBkZWZhdWx0
IHRocmVzaG9sZCBjb25maWd1cmF0aW9ucy4KPiAKPiBUaGFua3MgZm9yIHRoZSBleHBsYW5hdGlv
biwgYW5kIEkgYWdyZWUgdGhhdCB0b3RhbGx5Lgo+IEJlc2lkZXMsIHNoYWxsIHdlIHVzZSB0aGUg
ZXhhY3QgY291bnQgaW4geGZzX2ZzX2NvdW50cz8gQmVjYXVzZSBpdCdzIGEgaW9jdGwKPiBmdW5j
dGlvbiwgbm90IHNvIG11Y2ggc2Vuc2l0aXZlIHBlcmZvcm1hbmNlLgoKUmlnaHQsIGJ1dCB0aGF0
IG1ha2VzIHBlcmNwdV9jb3VudGVyX3JlYWRfcG9zaXRpdmUgaXMgcGVyZmVjdCBmb3IKaW9jdGxz
IGxpa2UgdGhpczogd2hhdCBpcyByZXBvcnRlZCB0byB1c2Vyc3BhY2UgaXMgbmV2ZXIKcGVyZmVj
dGx5IGFjY3VyYXRlIG9uIGEgYnVzeSBmaWxlc3lzdGVtLiBBbHNvLCB3ZSBkb24ndCB3aGF0IHNv
bWVvbmUKcmVwZWF0ZWRseSBydW5uaW5nIHRoYXQgaW9jdGwgdG8gYWR2ZXJzZWx5IGFmZmVjdCB0
aGUgcGVyZm9ybWFuY2Ugb2YKdGhlIGZpbGVzeXN0ZW0sIHdoaWNoIGlzIHdoYXQgd291bGQgaGFw
cGVuIGlmIGl0IHdhcyBhbiBhY2N1cmF0ZQpzdW0uLi4uLgoKQ2hlZXJzLAoKRGF2ZS4KLS0gCkRh
dmUgQ2hpbm5lcgpkYXZpZEBmcm9tb3JiaXQuY29tCgpfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpo
dHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
