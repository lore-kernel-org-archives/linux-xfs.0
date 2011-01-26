Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0QLKcP4165864 for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 15:20:38 -0600
Subject: Re: [PATCH 6/8] xfs: limit extsize to size of AGs and/or MAXEXTLEN
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1295945444-29488-7-git-send-email-david@fromorbit.com>
References: <1295945444-29488-1-git-send-email-david@fromorbit.com>
	<1295945444-29488-7-git-send-email-david@fromorbit.com>
Date: Wed, 26 Jan 2011 15:23:02 -0600
Message-ID: <1296076982.1980.943.camel@doink>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

T24gVHVlLCAyMDExLTAxLTI1IGF0IDE5OjUwICsxMTAwLCBEYXZlIENoaW5uZXIgd3JvdGU6Cj4g
RnJvbTogRGF2ZSBDaGlubmVyIDxkY2hpbm5lckByZWRoYXQuY29tPgo+IAo+IFRoZSBleHRlbnQg
c2l6ZSBoaW50IGNhbiBiZSBzZXQgdG8gbGFyZ2VyIHRoYW4gYW4gQUcuIFRoaXMgbWVhbnMKPiB0
aGF0IHRoZSBhbGlnbm1lbnQgcHJvY2VzcyBjYW4gcHVzaCB0aGUgcmFuZ2UgdG8gYmUgYWxsb2Nh
dGVkCj4gb3V0c2lkZSB0aGUgYm91bmRzIG9mIHRoZSBBRywgcmVzdWx0aW5nIGluIGFzc2VydCBm
YWlsdXJlcyBvcgo+IGNvcnJ1cHRlZCBibWJ0IHJlY29yZHMuIFNpbWlsYXJseSwgaWYgdGhlIGV4
dHNpemUgaXMgbGFyZ2VyIHRoYW4gdGhlCj4gbWF4aW11bSBleHRlbnQgc2l6ZSBzdXBwb3J0ZWQs
IHRoZSBhbGlnbm1lbnQgcHJvY2VzcyB3aWxsIHByb2R1Y2UKPiBleHRlbnRzIHRoYXQgYXJlIHRv
byBsYXJnZSB0byBmaXQgaW50byB0aGUgYm1idCByZWNvcmRzLCByZXN1bHRpbmcKPiBpbiBhIGRp
ZmZlcmVudCB0eXBlIG9mIGFzc2VydC9jb3JydXB0aW9uIGZhaWx1cmUuCj4gCj4gRml4IHRoaXMg
YnkgbGltaXRpbmcgZXh0c2l6ZSBhdCB0aGUgdGltZSDRlnQgaXMgc2V0IGZpcnN0bHkgdG8gYmUK
PiBsZXNzIHRoYW4gTUFYRVhUTEVOLCB0aGVuIHRvIGJlIGEgbWF4aW11bSBvZiBoYWxmIHRoZSBz
aXplIG9mIHRoZQo+IEFHcyBpbiB0aGUgZmlsZXN5c3RlbSBmb3Igbm9uLXJlYWx0aW1lIGlub2Rl
cy4gUmVhbHRpbWUgaW5vZGVzIGRvCj4gbm90IGFsbG9jYXRlIG91dCBvZiBBR3MsIHNvIGRvbid0
IGhhdmUgdG8gYmUgcmVzdHJpY3RlZCBieSB0aGUgc2l6ZQo+IG9mIEFHcy4KCkxvb2tzIGdvb2Qu
CgpSZXZpZXdlZC1ieTogQWxleCBFbGRlciA8YWVsZGVyQHNnaS5jb20+Cgo+IFNpZ25lZC1vZmYt
Ynk6IERhdmUgQ2hpbm5lciA8ZGNoaW5uZXJAcmVkaGF0LmNvbT4KPiBSZXZpZXdlZC1ieTogQ2hy
aXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+CgoKX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0
cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
