Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B88147F47
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2014 11:40:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A25A0304032
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2014 09:40:12 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id K1aIY9a5CwydVsU1 for <xfs@oss.sgi.com>;
	Thu, 10 Jul 2014 09:40:07 -0700 (PDT)
Message-ID: <53BEC1E7.1070904@sandeen.net>
Date: Thu, 10 Jul 2014 11:40:07 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: symlink loop for /lib64/libhandle.so
References: <1404898212.7231.12.camel@jtulak>	<20140709132836.GA65226@bfoster.bfoster>	<20140710134851.GA26652@infradead.org>
	<1405009872.31068.22.camel@jtulak>
In-Reply-To: <1405009872.31068.22.camel@jtulak>
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
To: =?UTF-8?B?SmFuIMWkdWzDoWs=?= <jan@tulak.me>, Christoph Hellwig <hch@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>, XFS mail list <xfs@oss.sgi.com>

T24gNy8xMC8xNCwgMTE6MzEgQU0sIEphbiDFpHVsw6FrIHdyb3RlOgo+IAo+PiBPbiAxMCBKdWwg
MjAxNCwgYXQgMTU6NDgsIENocmlzdG9waCBIZWxsd2lnIDxoY2hAaW5mcmFkZWFkLm9yZz4gd3Jv
dGU6Cj4+Cj4+IE9uIFdlZCwgSnVsIDA5LCAyMDE0IGF0IDA5OjI4OjM2QU0gLTA0MDAsIEJyaWFu
IEZvc3RlciB3cm90ZToKPj4+PiBJZiBpdCBub3QgYW4gaW50ZW5kZWQgYmVoYXZpb3IsIEkgY2Fu
IHRyeSB0byBmaW5kIHRoZSBzb3VyY2Ugb2YgdGhlIGJ1Zwo+Pj4+IGFuZCBtYWtlIGEgcGF0Y2gg
KEknbSBuZXcgaGVyZSA6LSkuCj4+Pgo+Pj4gSSBjYW4gcmVwcm9kdWNlIHRoaXMgb24gZmVkb3Jh
IHJhd2hpZGUgdmlhICdtYWtlIGluc3RhbGwtcWEuJyBUaGlzIGlzCj4+PiBub3QgaW50ZW5kZWQg
YmVoYXZpb3IuIEkgY291bGRuJ3QgdGVsbCB5b3Ugd2hhdCB0aGUgcHJvYmxlbSBpcywgYnV0Cj4+
PiBwYXRjaGVzIGFyZSBjZXJ0YWlubHkgd2VsY29tZS4gOikKPj4KPj4gVGhpcyBzb3VuZHMgbGlr
ZSBhbiBmYWxsb3V0IGZyb20gdGhlIC9saWIgLT4gL3Vzci9saWIgc3ltbGluayBtZXNzIGluCj4+
IEZlZG9yYS4gIE1pZ2h0IGJlIHdvcnRoIHRha2luZyBhIGxvb2sgYXQgdGhlIHNwZWNmaWxlIGhv
dyBFcmljIHdvcmtlZAo+PiBhcm91bmQgdGhhdCBmb3IgdGhlIFJQTS4uCgpJJ20gcHJldHR5IHN1
cmUgSSB1c2VkIGEgdGVycmlibGUgaGFjayBpbiB0aGUgc3BlY2ZpbGUuLi4gOykKIAo+IFllcy4g
SSdtIHRyeWluZyB0byBmaW5kIG91dCB3aGF0IGV4YWN0bHkgaXMgY2F1c2luZyB0aGUgZGlmZmVy
ZW5jZS4gSQo+IGhhdmUgdHJpZWQgdG8gdXNlIHRoZSBzYW1lIHRhcmJhbGwgd2hpY2ggaXMgdXNl
ZCBpbiBFcmljJ3MgUlBNIGFuZCBpdAo+IGRpZCB0aGUgc2FtZSB0aGluZyBhcyB0aGUgZ2l0IHZl
cnNpb24sIHNvIGl0IGlzIG5vdCBzb21ldGhpbmcgdGhhdAo+IHdvdWxkIGNoYW5nZSBzaW5jZSBo
aXMgbGFzdCBidWlsZC4KClRoZSB0YXJiYWxsIEkgdXNlIGluIHRoZSBSUE0gaXMgZXhhY3RseSB3
aGF0IGlzIHByb3ZpZGVkIG9uIG9zcy5zZ2kuY29tLAp0aGVyZSdzIG5vdGhpbmcgZGlmZmVyZW50
IGluIHRoZXJlIGZvciBGZWRvcmEuCgo+IFNvIGZhciBJdCBzZWVtcyB0aGF0IGlmIEkgYWRkIERJ
U1RfUk9PVCwgUEtHX1JPT1RfU0JJTl9ESVIgYW5kCj4gUEtHX1JPT1RfTElCX0RJUiBhcmd1bWVu
dHMgdG8gdGhlICJtYWtlIGluc3RhbGwtcWEiIGNvbW1hbmRtIGl0IHdvcmtzIE9LIGFuZAo+IHRo
ZSBsaWJoYW5kbGUuc28gcGxhY2VkIGluIFBLR19ST09UX0xJQl9ESVIgcG9pbnRzIGNvcnJlY3Rs
eSB0bwo+IGxpYmFuZGxlLnNvLjEuCj4gCj4gRG9lcyB0aGlzIG1ha2VzIHNvbWUgc2Vuc2UgdG8g
eW91PwoKSGVyZSdzIHdoYXQgdGhlIGN1cnJlbnQgUlBNIGJ1aWxkIGRvZXM7IEkgZG9uJ3QgY2xh
aW0gdGhhdCBpdCdzIGVsZWdhbnQgb3IKYmVhdXRpZnVsOgoKJWluc3RhbGwKcm0gLXJmICRSUE1f
QlVJTERfUk9PVAptYWtlIFY9MSBESVNUX1JPT1Q9JFJQTV9CVUlMRF9ST09UIGluc3RhbGwgaW5z
dGFsbC1kZXYgaW5zdGFsbC1xYSBcCiAgICAgICAgUEtHX1JPT1RfU0JJTl9ESVI9JXtfc2JpbmRp
cn0gUEtHX1JPT1RfTElCX0RJUj0le19saWJkaXJ9CgpzbyB0aGF0IHNvdW5kcyBsaWtlIHdoYXQg
eW91J3JlIGRvaW5nLCB0b28uCgpGV0lXLCB0aGF0IGFib3ZlIGNoYW5nZSBhbHNvIHJlbW92ZWQg
dGhpcyBvbGQgY3J1ZnQsIGFuZCBJIGRvbid0IHJlbWVtYmVyIHdoYXQKaXQgd2FzIGZvcjoKCi0j
IGZpeCB1cCBzeW1saW5rIHRvIGJlIGNvcnJlY3QKLXJtIC1mICRSUE1fQlVJTERfUk9PVC8le19s
aWJkaXJ9L2xpYmhhbmRsZS5zbwotbG4gLXMgLi4vLi4vJXtfbGlifS9saWJoYW5kbGUuc28uMSAk
UlBNX0JVSUxEX1JPT1QvJXtfbGliZGlyfS9saWJoYW5kbGUuc28KCnNvIEknbSBwcm9iYWJseSBn
dWlsdHkgb2YgaGFja2luZyBzdHVmZiB1cCB0b28gbXVjaCBmb3IgRmVkb3JhLCB2cyBmaXhpbmcK
aXQgdXBzdHJlYW0uLi4gOigKCi1FcmljCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8v
b3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
