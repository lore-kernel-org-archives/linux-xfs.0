Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2186F7CA0
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 15:14:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 90807AC007
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 13:14:00 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id PseG3cJdTDFMNmWO for <xfs@oss.sgi.com>;
	Thu, 21 Apr 2016 13:13:56 -0700 (PDT)
Received: from Liberator.local (unknown [74.203.127.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 04E6C9F
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 15:13:55 -0500 (CDT)
Subject: Re: [PATCH 15/19] mkfs: don't treat files as though they are block
	devices
References: <1461231593-31294-1-git-send-email-jtulak@redhat.com>
	<1461231593-31294-16-git-send-email-jtulak@redhat.com>
	<CACj3i73aW53YyEsZERZnSWHJ3y9cW85sA15KdoesCbx9wKsbPg@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <57193483.8000700@sandeen.net>
Date: Thu, 21 Apr 2016 16:13:55 -0400
MIME-Version: 1.0
In-Reply-To: <CACj3i73aW53YyEsZERZnSWHJ3y9cW85sA15KdoesCbx9wKsbPg@mail.gmail.com>
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

CgpPbiA0LzIxLzE2IDg6NDMgQU0sIEphbiBUdWxhayB3cm90ZToKPiBPbiBUaHUsIEFwciAyMSwg
MjAxNiBhdCAxMTozOSBBTSwgSmFuIFR1bGFrIDxqdHVsYWtAcmVkaGF0LmNvbSA8bWFpbHRvOmp0
dWxha0ByZWRoYXQuY29tPj53cm90ZToKPiAKPiAgICAgRnJvbTogRGF2ZSBDaGlubmVyIDxkY2hp
bm5lckByZWRoYXQuY29tIDxtYWlsdG86ZGNoaW5uZXJAcmVkaGF0LmNvbT4+Cj4gCj4gICAgIFRI
SVMgUEFUQ0ggSEFTIEtOT1dOIElTU1VFUyAtIGl0IGZhaWxzIHhmcy8yMDYgYW5kIHhmcy8yMTYg
dGVzdHMsIGFzIGl0Cj4gICAgIHNocmlua3MgYSBmaWxlIGluc3RlYWQganVzdCBub3QgdXNpbmcg
aXQgZW50aXJlbHksIHdoZW4gLWQgc2l6ZSBpcyB1c2VkLgo+IAo+IAo+IOKAi1NvIHRoZSBzaHJp
bmtpbmcgaXMgaGFwcGVuaW5nIGhlcmU6Cj4gMzEyNyAgICAgICAgLyoKPiAzMTI4ICAgICAgICAg
KiBJZiB0aGUgZGF0YSBhcmVhIGlzIGEgZmlsZSwgdGhlbiBncm93IGl0IG91dCB0byBpdHMgZmlu
YWwgc2l6ZQo+IDMxMjkgICAgICAgICAqIHNvIHRoYXQgdGhlIHJlYWRzIGZvciB0aGUgZW5kIG9m
IHRoZSBkZXZpY2UgaW4gdGhlIG1vdW50IGNvZGUKPiAzMTMwICAgICAgICAgKiB3aWxsIHN1Y2Nl
ZWQuCj4gMzEzMSAgICAgICAgICovCj4gMzEzMiAgICAgICAgaWYgKHhpLmRpc2ZpbGUgJiYgZnRy
dW5jYXRlNjQoeGkuZGZkLCBkYmxvY2tzICogYmxvY2tzaXplKSA8IDApIHvigIsKPiAgCj4gCj4g
QmVmb3JlIHRoZSBwYXRjaCwgeGkuZGlzZmlsZSB3YXMgMCBhbmQgc28gaXQgZGlkbid0IHNocmlu
ayB0aGUgZmlsZQo+IHRvIHRoZSBzaXplIG9mIHRoZSBuZXcgRlMuIE5vdywgd2hhdCBpcyB0aGUg
Y29ycmVjdCBzb2x2ZSB0byB0aGlzPwo+IFRlc3RzIGFyZSB3cml0dGVuIGZvciB0aGUgb2xkIGJl
aGF2aW91ciwgYnV0IHRoaXMgc2hyaW5raW5nIHNlZW1zIHRvCj4gYmUgYW4gaW50ZW50aW9uYWwg
dGhpbmcuIEl0IHNlZW1zIHRoYXQgdGhlIEZTIHdvcmtzIG9rIGV2ZW4gd2hlbiB0aGlzCj4gdHJ1
bmNhdGluZyBpcyBub3QgYXBwbGllZCwgc28gSSB0aGluayB0aGF0IEkgc2hvdWxkIHJlbW92ZSB0
aGlzIGNodW5rCj4gKG9yIGNoYW5nZSBpdCB0byB4aS5kY3JlYXRlPTEgb25seSksIGFuZCBrZWVw
IHRoZSBvbGQgYmVoYXZpb3VyLgo+IAo+IFdoYXQgZG8geW91IHRoaW5rIGFib3V0IGl0LCBndXlz
PwoKQ2FuJ3QgcmVtb3ZlIGl0OyB0aGF0IHdvdWxkIGJyZWFrIHRoZSBvdGhlciBzaWRlIG9mIHRo
aW5ncywgaWYgeW91IHRyeQp0byBta2ZzLnhmcyAtZCBzaXplPTJnIG9uIGFuIGV4aXN0aW5nIDFn
IGZpbGUuLi4gbW91bnQgdHJpZXMgdG8gZG8KSU8gdG8gdGhlIGxhc3QgYmxvY2ssIGFuZCBpZiBp
dCdzIG5vdCB0cnVuY2F0ZWQgb3V0LCB0aGF0IHdpbGwgZmFpbAooYXMgdGhlIGNvbW1lbnQgc2F5
cykuCgpJIHN1cHBvc2UgdGhlIHNpbXBsZSB3YXkgdG8gZml4IGl0IGlzIHRvIG9ubHkgdHJ1bmNh
dGUgdXAsIG5ldmVyIGRvd24uCgppLmUuIHRydW5jYXRlIHRvIG1heChkYmxvY2tzICogYmxvY2tz
aXplLCBzdF9zaXplKSBvcgppZiAoeGkuZGlzZmlsZSAmJiBzdF9zaXplIDwgIGRibG9ja3MgKiBi
bG9ja3NpemUpIHsgdHJ1bmNhdGUgLi4uIH0KCi1FcmljCgoKCj4gQ2hlZXJzLAo+IEphbgo+IAo+
IAo+IAo+IC0tIAo+IEphbiBUdWxhawo+IGp0dWxha0ByZWRoYXQuY29tIDxtYWlsdG86anR1bGFr
QHJlZGhhdC5jb20+IC8gamFuQHR1bGFrLm1lIDxtYWlsdG86amFuQHR1bGFrLm1lPgo+IAo+IAo+
IF9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCj4geGZzIG1h
aWxpbmcgbGlzdAo+IHhmc0Bvc3Muc2dpLmNvbQo+IGh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFu
L2xpc3RpbmZvL3hmcwo+IAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2ku
Y29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
