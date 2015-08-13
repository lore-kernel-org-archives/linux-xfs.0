Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 202CB7F88
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 11:54:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9C834AC003
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 09:54:33 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id QVDoX9waHtyzWUvf for <xfs@oss.sgi.com>;
	Thu, 13 Aug 2015 09:54:31 -0700 (PDT)
Message-ID: <55CCCBC3.6040404@sandeen.net>
Date: Thu, 13 Aug 2015 11:54:27 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH][RFC] xfs_copy: don't use DIRECT IO to copy 4k sector
	device
References: <1439478465-14072-1-git-send-email-zlang@redhat.com>
	<55CCC47A.5030706@sandeen.net>
	<510394920.8151266.1439484022770.JavaMail.zimbra@redhat.com>
In-Reply-To: <510394920.8151266.1439484022770.JavaMail.zimbra@redhat.com>
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
To: Zirong Lang <zlang@redhat.com>
Cc: xfs@oss.sgi.com

T24gOC8xMy8xNSAxMTo0MCBBTSwgWmlyb25nIExhbmcgd3JvdGU6Cj4gCj4gCj4gLS0tLS0g5Y6f
5aeL6YKu5Lu2IC0tLS0tCj4+IOWPkeS7tuS6ujogIkVyaWMgU2FuZGVlbiIgPHNhbmRlZW5Ac2Fu
ZGVlbi5uZXQ+Cj4+IOaUtuS7tuS6ujogIlpvcnJvIExhbmciIDx6bGFuZ0ByZWRoYXQuY29tPiwg
eGZzQG9zcy5zZ2kuY29tCj4+IOWPkemAgeaXtumXtDog5pif5pyf5LqULCAyMDE15bm0IDgg5pyI
IDE05pelIOS4iuWNiCAxMjoyMzoyMgo+PiDkuLvpopg6IFJlOiBbUEFUQ0hdW1JGQ10geGZzX2Nv
cHk6IGRvbid0IHVzZSBESVJFQ1QgSU8gdG8gY29weSA0ayBzZWN0b3IgZGV2aWNlCj4+Cj4+IE9u
IDgvMTMvMTUgMTA6MDcgQU0sIFpvcnJvIExhbmcgd3JvdGU6Cj4+PiBXaGVuIEkgcnVuIHhmc3Rl
c3RzIHhmcy8wMzIgaW4gcHBjNjRsZSwgSSBoaXQgYSBmYWlsdXJlOgo+Pj4KPj4+ICAgICAgeGZz
X2NvcHk6IHJlYWQgZmFpbGVkOiBJbnZhbGlkIGFyZ3VtZW50Cj4+PiAgICAgIHhmc19jb3B5OiBz
aXplIGNoZWNrIGZhaWxlZAo+Pj4gICAgICB4ZnNfY29weTogL2Rldi9zZGE1IGZpbGVzeXN0ZW0g
ZmFpbGVkIHRvIGluaXRpYWxpemUKPj4+ICAgICAgeGZzX2NvcHk6IEFib3J0aW5nLgo+Pj4gICAg
ICBDb3B5IGZhaWxlZCBmb3IgU2VjdG9yIHNpemUgNDA5NiBCbG9jayBzaXplIDQwOTYKPj4+Cj4+
PiBJIHRyeSB0byB1c2UgZ2RiIHRyYWNlIHhmc19jb3B5LiBJIGZpbmQgaXQgdHJ5IHRvIG9wZW4g
dGhlCj4+PiBzb3VyY2UgZGV2aWNlIHdpdGggRElSRUNUIGZsYWcsIHRoZW4gcmVhZCB0aGUgZGV2
aWNlIHdpdGgKPj4+ICgoMTw8QkJTSElGVCkpPTUxMiBieXRlcyBsZW5ndGguIElmIHRoZSBzb3Vy
Y2UgZGV2aWNlIGlzCj4+PiA0ayBzZWN0b3IsIGRpcmVjdGx5IHJlYWQgNTEyIGJ5dGVzIHdpbGwg
YmUgZmFpbGVkLgo+Pj4KPj4+IHhmc19jb3B5ICctYicgb3B0aW9uIG9ubHkgd29yayBmb3IgdGFy
Z2V0IGZpbGUvZGV2aWNlLCB0bwo+Pj4gc3VyZSBpdCB3aWxsIG9wZW4gdGhlIHRhcmdldCB3aXRo
b3V0IERJUkVDVCBmbGFnLiBCdXQgdXNlbGVzcwo+Pj4gZm9yIHNvdXJjZSBkZXZpY2Ugb3Blbi4K
Pj4+Cj4+PiBTbyBJIG1ha2UgRElSRUNUIGZsYWcgb25seSBiZSBlbmFibGVkIHdoZW4gc291cmNl
IGRldmljZQo+Pj4gc2VjdG9yIHNpemUgZXF1YWwgQkJTSVpFLgo+Pgo+PiBXaGljaCB2ZXJzaW9u
IG9mIHhmc3Byb2dzIGRpZCB5b3UgdGVzdD8gIFRoaXMgaXMgcmVjZW50bHkgdXBzdHJlYW06Cj4g
Cj4gU29ycnkgSSBkaWRuJ3Qgbm90aWNlIHRoYXQgeW91IGhhdmUgZml4IHRoaXMgcHJvYmxlbS4g
SSB0ZXN0IG9uIHRoZQo+IG5ld2VzdCB2ZXJzaW9uIGZyb20gZ2l0Oi8vb3NzLnNnaS5jb20veGZz
L2NtZHMveGZzcHJvZ3MsIGl0IGhhdmVuJ3QKPiBmaXggdGhpcyBwcm9ibGVtLiBJIHRlc3QgdGhp
cyBwYXRjaCBvbiBpdCBhdCBmaXJzdC4gVGhlbiBJIGZpbmQKPiB0aGVyZSBpcyBhbm90aGVyIHZl
cnNpb24gaW4gZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9mcy94ZnMveGZzcHJvZ3MtZGV2
LmdpdAo+IAo+IEkgZG9uJ3Qga25vdyB0aGV5IGFyZSB0b28gZGlmZmVyZW50LCBzbyBJIGRpZG4n
dCBjaGVjayBpZiB0aGlzIHhmc3Byb2dzLWRldiBoYXMKPiAgZml4ZWQgaXQsIGFuZCBqdXN0IGRp
ZCB0aGlzIHBhdGNoIG9uIGl0IGFuZCBzZW5kIG91dC4KPiAKPiBTb3JyeSBmb3IgdGhpcyBtaXN0
YWtlLCBhbmQgeW91ciBwYXRjaCBpcyByZWFsbHkgYmV0dGVyOikKCk5vIHByb2JsZW0sIHRoYW5r
cyBmb3IgbG9va2luZyBpbnRvIGl0ISAgSSdtIG5vdCBzdXJlIHdoeSB0aGUgc2dpIGdpdCB0cmVl
CmlzIGEgYml0IGJlaGluZCByaWdodCBub3cuCgotRXJpYwoKX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5j
b20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
