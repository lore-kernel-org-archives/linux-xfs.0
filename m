Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o99Lclbi163671 for <xfs@oss.sgi.com>; Sat, 9 Oct 2010 16:38:47 -0500
Subject: Re: [PATCH VER 8] xfsprogs: projid32bit handling
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1286179438-18282-1-git-send-email-arekm@maven.pl>
References: <1286179438-18282-1-git-send-email-arekm@maven.pl>
Date: Sat, 09 Oct 2010 16:33:18 -0500
Message-ID: <1286659998.5392.4.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Arkadiusz =?UTF-8?Q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Cc: xfs@oss.sgi.com

T24gTW9uLCAyMDEwLTEwLTA0IGF0IDEwOjAzICswMjAwLCBBcmthZGl1c3ogTWnFm2tpZXdpY3og
d3JvdGU6Cj4gQWRkIHByb2ppZDMyYml0IGhhbmRsaW5nIHRvIHVzZXJzcGFjZS4gbWtmcy54ZnMg
aXMgYWJsZSB0byBlbmFibGUgdGhpcwo+IGZlYXR1cmUgZm9yIG5ldyBmaWxlc3lzdGVtcy4geGZz
X2RiIGtub3dzIHdoYXQgcHJvamlkX2xvL2hpIGFyZS4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBBcmth
ZGl1c3ogTWnFm2tpZXdpY3ogPGFyZWttQG1hdmVuLnBsPgoKVGhpcyBsb29rcyBnb29kLiAgSSB0
ZXN0ZWQgaXQgd2l0aCB5b3VyIHVwZGF0ZSBmb3IgeGZzdGVzdHMKYW5kIG15IGVhcmxpZXIgY29u
Y2VybnMgc2VlbSB0byBoYXZlIGJlZW4gYWRkcmVzc2VkLgoKSSd2ZSBhbHJlYWR5IGNvbW1pdHRl
ZCB0aGlzIGNoYW5nZSwgSSBqdXN0IHdhbnRlZCB0bwptYWtlIHN1cmUgeW91IGtuZXcgaXQncyAo
ZmluYWxseSkgaW4uCgpSZXZpZXdlZC1ieTogQWxleCBFbGRlciA8YWVsZGVyQHNnaS5jb20+Cgo+
IC0tLQo+IAo+IHZlcnNpb24gNyBuZXdzOgo+IC0geGZzX2FkbWluIGNhbiBub3cgZWFzaWx5IGVu
YWJsZSBwcm9qaWQzMmJpdCBzdXBwb3J0Cj4gCj4gdmVyc2lvbiA4IG5ld3M6Cj4gLSB4ZnNfbG9n
cHJpbnQgbm93IHByaW50cyBzaW5nbGUgMzJiaXQgcHJvamlkIGluc3RlYWQgb2YgdHdvCj4gICAx
NmJpdCBwcm9qaWRfe2xvLGhpfS4gVGh1cyB3ZSBnZXQgdGhlIHNhbWUgb3V0cHV0IGZvcm1hdAo+
ICAgYXMgYmVmb3JlLgo+IC0gdXNlICV1IGZvciBkaXNwbGF5aW5nIHByb2ppZCAoaW5zdGVhZCBv
ZiAlZCkKPiAtIHByb2ppZDMyYml0IGZsYWcgaW4gbWtmcy54ZnMgb3V0cHV0IHNlcGFyYXRlZCBi
eSBjb21hCj4gLSBic19wcm9qaWQgaXMgYmFjayBhcyBic19wcm9qaWRfbG8gKyBkZWZpbmUgZm9y
IGNvbXBhdGliaWxpdHkKPiAtIG1hbiBwYWdlIGZvcm1hdHRpbmcgZml4Cj4gCj4gIGRiL2NoZWNr
LmMgICAgICAgICAgICAgICB8ICAgIDIgKy0KPiAgZGIvaW5vZGUuYyAgICAgICAgICAgICAgIHwg
ICAgNiArKysrLS0KPiAgZGIvc2IuYyAgICAgICAgICAgICAgICAgIHwgICAgNiArKysrKysKPiAg
ZGIveGZzX2FkbWluLnNoICAgICAgICAgIHwgICAgNSArKystLQo+ICBpbmNsdWRlL3hmc19kaW5v
ZGUuaCAgICAgfCAgICA1ICsrKy0tCj4gIGluY2x1ZGUveGZzX2ZzLmggICAgICAgICB8ICAgMTcg
KysrKysrKysrKysrKysrLS0KPiAgaW5jbHVkZS94ZnNfaW5vZGUuaCAgICAgIHwgICAyNSArKysr
KysrKysrKysrKysrKysrKysrLS0tCj4gIGluY2x1ZGUveGZzX3NiLmggICAgICAgICB8ICAgMTcg
KysrKysrKysrKysrKysrKy0KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dp
LmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
