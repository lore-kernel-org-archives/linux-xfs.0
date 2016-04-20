Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 862F97CA0
	for <xfs@oss.sgi.com>; Wed, 20 Apr 2016 11:53:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3E1B8304032
	for <xfs@oss.sgi.com>; Wed, 20 Apr 2016 09:53:21 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id VJ3voyt23tmafQ8D for <xfs@oss.sgi.com>;
	Wed, 20 Apr 2016 09:53:17 -0700 (PDT)
Received: from Liberator.local (unknown [74.203.127.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 57E5D2A80
	for <xfs@oss.sgi.com>; Wed, 20 Apr 2016 11:53:15 -0500 (CDT)
Subject: Re: [PATCH 15/19] mkfs: don't treat files as though they are block
	devices
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-16-git-send-email-jtulak@redhat.com>
	<5706FA7C.7020103@sandeen.net>
	<CACj3i73JEzCj-4kp3=H9mjXCKYgcOUYCOyq-aZSWZFXUih+0MA@mail.gmail.com>
	<CACj3i722h=WVW-637__y6fi4EekAxxB=cwL8y+F1r1LFk-Z5rw@mail.gmail.com>
	<CACj3i71Ff2KS682DRP8zG76ee6rhz3X-NZKst1qsruMZKWaHJA@mail.gmail.com>
	<CACj3i73jk5HjRuRRF7hnX0WoOv0amq-CduAwoHbhoT-=+hTREA@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5717B3F7.2030904@sandeen.net>
Date: Wed, 20 Apr 2016 12:53:11 -0400
MIME-Version: 1.0
In-Reply-To: <CACj3i73jk5HjRuRRF7hnX0WoOv0amq-CduAwoHbhoT-=+hTREA@mail.gmail.com>
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
To: xfs@oss.sgi.com

T24gNC8yMC8xNiA5OjE3IEFNLCBKYW4gVHVsYWsgd3JvdGU6Cj4g4oCLSSdtIHRha2luZyBpdCBi
YWNrLCBvbmUgdGVzdHMgZmFpbHMsIG1vc3QgbGlrZWx5IGl0IGhhcHBlbmVkIHdoZW4gSQo+IHJl
bW92ZWQgcGF0Y2ggMTcgLSB4ZnNwcm9nczogZGlzYWJsZSB0cnVuY2F0aW5nIG9mIGZpbGVzLiBJ
ZiBJIGRvCj4gIm1rZnMueGZzICRmaWxlIiwgaXQgZG9lc24ndCBrbm93IHRoZSBvbGQgc2l6ZSB0
byByZWNyZWF0ZSBpdC4gSSdtCj4gd29ya2luZyBvbiBhIGNoYW5nZSBmb3IgdGhpcyBwYXRjaCB0
byBmaXggdGhpcyBpc3N1ZSwgYnV0IEknbSBub3QKPiBlbnRpcmVseSBjZXJ0YWluIGhvdyB0byBw
cm9jZWVkLiBUaGUgcmlnaHQgcGxhY2UgdG8gZ2V0IHRoZSBzaXplCj4gc2VlbXMgdG8gYmUgZ2V0
X3RvcG9sb2d5KCkuIEkgY291bGQgc2F2ZSBpdCBpbnRvIHhpLmRzaXplLCBidXQgdGhlbgo+IGxp
Ynhmc19pbml0KCkgemVyb2VzIGl0Lgo+IAo+IFNvIEkgdGhpbmsgdGhhdCBJIG1pZ2h0IHJhdGhl
ciBjb252ZXJ0IHRoZSBtZWFzdXJlZCBzaXplIGRvIGNoYXIKPiAqZHNpemUgYW5kIHByZXRlbmQg
dGhhdCBpdCBpcyBhbiB1c2VyLWdpdmVuIHZhbHVlLiBCdXQgdGhpcyBsb29rcyB0bwo+IG1lIG1v
cmUgbGlrZSBhIGhhY2suIE9uIHRoZSBvdGhlciBzaWRlLCBhbnkgb3RoZXIgd2F5IHdvdWxkIHJl
cXVpcmUKPiBmdXJ0aGVyIGNoYW5nZXMgaW4gdGhlIGNvZGUgdG8gY29udmVydCB0aGUgY2hhciog
dG8gaW50IGFzIHNvb24gYXMKPiBwb3NzaWJsZSAtIHdoaWNoIGRvZXMgbm90IGJlbG9uZyB0byB0
aGlzIHBhdGNoLi4uCi4uLgoKPiBTbywgd2hhdCBkbyB5b3UgdGhpbmsgYWJvdXQgdGhpcz8KPiAK
PiDigIsgQW5kIGJlZm9yZSBhbnlvbmUgd2lsbCByZXBseSwgSSBmb3VuZCB0aGF0IHB1dHRpbmcg
YQo+IHBsYXRmb3JtX2ZpbmRzaXplc+KAiyBpbnRvIGxpYnhmc19pbml0IHdpbGwgZml4IGl0IHRv
by4gV2hpY2ggaXMgbmljZSwKPiBlc3BlY2lhbGx5IGJlY2F1c2UgZm9yIGJsb2NrIGRldmljZXMs
IHRoZSBmaW5kc2l6ZXMgaXMgYWxyZWFkeSB1c2VkCj4gdGhlcmUuIFNvIGlnbm9yZSB0aGUgcHJl
dmlvdXMgaGFjay4gOi0pCgpIdWggLSBpZiBJIHRha2UgeW91ciBvcmlnaW5hbCBwYXRjaHNldCBh
bmQgc2ltcGx5IHJlbW92ZSBwYXRjaCAxNywKSSBkb24ndCBnZXQgYW55IHByb2JsZW1zIHdpdGgg
Im1rZnMueGZzIGZpbGUiIGZvciBhbiBleGlzdGluZyBmaWxlLAppdCBzZWVtcyB0byB3b3JrIGZp
bmUgaGVyZS4gIFNvIGl0IG1pZ2h0IGJlIHNvbWV0aGluZyBlbHNlLi4uCgotRXJpYwoKX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlz
dAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZz
Cg==
