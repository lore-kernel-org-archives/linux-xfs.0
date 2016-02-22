Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7BE487F74
	for <xfs@oss.sgi.com>; Mon, 22 Feb 2016 15:20:46 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 349E18F8050
	for <xfs@oss.sgi.com>; Mon, 22 Feb 2016 13:20:40 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	OqjLxIImxjzvJuhc for <xfs@oss.sgi.com>;
	Mon, 22 Feb 2016 13:20:31 -0800 (PST)
Date: Tue, 23 Feb 2016 08:20:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs resize: primary superblock is not updated immediately
Message-ID: <20160222212019.GI25832@dastard>
References: <3685DFAD20214109878873CF81232704@alyakaslap>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3685DFAD20214109878873CF81232704@alyakaslap>
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
To: Alex Lyakas <alex@zadarastorage.com>
Cc: hch@infradead.org, Danny Shavit <danny@zadarastorage.com>, xfs@oss.sgi.com

T24gTW9uLCBGZWIgMjIsIDIwMTYgYXQgMDk6MDg6MDZQTSArMDIwMCwgQWxleCBMeWFrYXMgd3Jv
dGU6Cj4gR3JlZXRpbmdzIFhGUyBkZXZlbG9wZXJzLAo+IAo+IEkgYW0gc2VlaW5nIHRoZSBmb2xs
b3dpbmcgaXNzdWUgd2l0aCBYRlMgb24ga2VybmVsIDMuMTguMTkuCj4gCj4gV2hlbiByZXNpemlu
ZywgWEZTIGFkZHMgbmV3IEFHcyBhbmQgZXZlbnR1YWxseSB1cGRhdGVzIHRoZSBwcmltYXJ5Cj4g
c3VwZXJibG9jayB3aXRoIHRoZSBuZXcg4oCcc2JfYWdjb3VudOKAnSB2YWx1ZS4gSG93ZXZlciwg
aXQgaGFwcGVucyBmZXcKPiBzZWNvbmRzIGFmdGVyIHRoZSByZXNpemUgb3BlcmF0aW9uIGNvbXBs
ZXRlcyBiYWNrIHRvIHVzZXItc3BhY2UuIEFzCj4gYSByZXN1bHQsIGlmIGEgYmxvY2stbGV2ZWwg
c25hcHNob3QgaXMgdGFrZW4gb2ZmIHRoZSB1bmRlcmx5aW5nCj4gYmxvY2sgZGV2aWNlLCB3aGls
ZSDigJxzYl9hZ2NvdW504oCdIHN0aWxsIGhhcyB0aGUgb2xkIHZhbHVlLCB0aGVuCj4gc3Vic2Vx
dWVudCBYRlMgbW91bnQgY3Jhc2hlcyB3aXRoIHN0YWNrIGxpa2VbMV0uCgpUaGUgcHJpbWFyeSBz
dXBlcmJsb2NrIGNoYW5nZSBpcyBsb2dnZWQsIHNvIGl0IGRvZXNuJ3QgbmVlZCB0byBiZQp3cml0
dGVuIGJhY2sgaW1tZWRpYXRlbHkuIFRoYXQgbWVhbnMgaXQgaXMgaW4gdGhlIGpvdXJuYWwuLi4K
Cj4gU29tZSBkZWJ1Z2dpbmcgc2hvd3MgdGhhdCBfeGZzX2J1Zl9maW5kIGlzIGNhbGxlZCB3aXRo
IGFnbm8gdGhhdCBoYXMKPiBiZWVuIGFkZGVkIGR1cmluZyB0aGUgcmVzaXplLCBidXQgYXBwcm9w
cmlhdGUgInBhZyIgaGFzIG5vdCBiZWVuCj4gY3JlYXRlZCBmb3IgdGhpcyBhZ25vIGR1cmluZyBt
b3VudC4KClRoZSBuZXcgcGVyLWFnIHN0cnVjdHVyZXMgYXJlIGNyZWF0ZWQgZHVyaW5nIGdyb3dm
cywgYWZ0ZXIgdGhlCmdyb3dmcyB0cmFuc2FjdGlvbiBoYXMgY29tbWl0dGVkLiBpZiB5b3UgYXJl
IG1vdW50aW5nIGEgc25hcHNob3QKdGhhdCBoYXMgdGhlIHdyb25nIGFnY291bnQgaW4gaXQsIHRo
ZW4gbG90cyBvZiB0aGluZ3Mgd2lsbCBnbyB3cm9uZwppZiB0aGVyZSBpcyBtZXRhZGF0YSB0aGF0
IGFscmVhZHkgdXNlcyB0aGUgZXhwYW5kZWQgc3BhY2UuCgo+IEkgaGF2ZSBmb3VuZCB0aGUgcGF0
Y2ggYnkgQ2hyaXN0b3BoIEhlbGx3aWc6Cj4gaHR0cDovL29zcy5zZ2kuY29tL2FyY2hpdmVzL3hm
cy8yMDE1LTAxL21zZzAwMzkxLmh0bWwKPiB3aGljaCBzZXRzIHRoZSByZXNpemUgdHJhbnNhY3Rp
b24gdG8gYmUgc3luY2hyb25vdXMsIGFuZCBhcHBsaWVkIGl0LAo+IGJ1dCBpdCBzdGlsbCBkb2Vz
buKAmXQgaGVscC4KPiAKPiBSaWdodCBhZnRlciB0aGUgcmVzaXplIGNvbXBsZXRlcywgSSBhbSBp
c3N1aW5nOgo+IHhmc19kYiAtciAtYyAic2IgMCIgLWMgInAiICAgPGRldmljZT4KPiBhbmQgZm9y
IGEgZmV3IHNlY29uZHMgc3RpbGwgZ2V0IHRoZSBvbGQgdmFsdWUgb2Yg4oCcc2JfYWdjb3VudOKA
nS4KPiAKPiBDYW4gYW55Ym9keSBhZHZpc2Ugd2hhdCBhbSBJIG1pc3Npbmc/IFdoYXQgbmVlZHMg
dG8gYmUgZG9uZSBzbyB0aGF0Cj4gdGhlIHByaW1hcnkgc3VwZXJibG9jayB3aWxsIGdldCB0aGUg
bmV3IHZhbHVlIG9mIOKAnHNiX2Fnb3VudOKAnQo+IHByb21wdGx5PwoKQXJlIHlvdSBmcmVlemlu
ZyB0aGUgZmlsZXN5c3RlbSBiZWZvcmUgdGFraW5nIGEgYmxvY2sgbGV2ZWwKc25hcHNob3Q/CgpD
aGVlcnMsCgpEYXZlLgotLSAKRGF2ZSBDaGlubmVyCmRhdmlkQGZyb21vcmJpdC5jb20KCl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxp
c3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hm
cwo=
