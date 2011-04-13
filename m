Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p3DMoBFv215340 for <xfs@oss.sgi.com>; Wed, 13 Apr 2011 17:50:11 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 713803D3399
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2011 15:53:31 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	yhwQiKIycKznavQT for <xfs@oss.sgi.com>;
	Wed, 13 Apr 2011 15:53:31 -0700 (PDT)
Date: Thu, 14 Apr 2011 08:53:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH, v2] xfs: cleanup duplicate initializations
Message-ID: <20110413225327.GM31057@dastard>
References: <1301332373-24914-1-git-send-email-dsterba@suse.cz>
	<1301338370.2622.10.camel@doink> <1302732208.2023.146.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1302732208.2023.146.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: David Sterba <dsterba@suse.cz>, xfs@oss.sgi.com

T24gV2VkLCBBcHIgMTMsIDIwMTEgYXQgMDU6MDM6MjhQTSAtMDUwMCwgQWxleCBFbGRlciB3cm90
ZToKPiBPbiBNb24sIDIwMTEtMDMtMjggYXQgMTM6NTIgLTA1MDAsIEFsZXggRWxkZXIgd3JvdGU6
Cj4gPiBPbiBNb24sIDIwMTEtMDMtMjggYXQgMTk6MTIgKzAyMDAsIERhdmlkIFN0ZXJiYSB3cm90
ZToKPiA+ID4gZm9sbG93IHRoZXNlIGd1aWRlbGluZXM6Cj4gPiA+IC0gbGVhdmUgaW5pdGlhbGl6
YXRpb24gaW4gdGhlIGRlY2xhcmF0aW9uIGJsb2NrIGlmIGl0IGZpdHMgdGhlIGxpbmUKPiA+ID4g
LSBtb3ZlIHRvIHRoZSBjb2RlIHdoZXJlIGl0J3MgbW9yZSBzdWl0YWJsZSAoJ2ZvcicgaW5pdCBi
bG9jaykKPiA+ID4gCj4gPiA+IFNpZ25lZC1vZmYtYnk6IERhdmlkIFN0ZXJiYSA8ZHN0ZXJiYUBz
dXNlLmN6Pgo+ID4gCj4gPiBMb29rcyBnb29kLgo+ID4gCj4gPiBSZXZpZXdlZC1ieTogQWxleCBF
bGRlciA8YWVsZGVyQHNnaS5jb20+Cj4gCj4gSSByZXRyYWN0IHRoaXMuICBUaGUgbGFzdCBjaHVu
ayBpbiB0aGUgcGF0Y2ggaXMgZXJyb25lb3VzLgo+IAo+IEJlbG93IGlzIHRoZSBvcmlnaW5hbCBw
cm9wb3NlZCBwYXRjaCwgZXhjZXB0IEkgaGF2ZQo+IG1vZGlmaWVkIHRoZSBsYXN0IGNodW5rIHRv
IGJlIGEgY29ycmVjdCBmaXggZm9yIHdoYXQKPiBhcHBlYXJzIHRvIGJlIGEgZHVwbGljYXRlIGlu
aXRpYWxpemF0aW9uLiAgKEl0IHdhcyBub3QsCj4gcmVhbGx5LCBidXQgSSd2ZSBjaGFuZ2VkIGl0
IHNvIG9ubHkgb25lIGFzc2lnbm1lbnQgaXMKPiBtYWRlLCBhbmQgdGhlIHJlc3VsdCBtYWtlcyBp
dCBtb3JlIG9idmlvdXMgd2hhdCdzCj4gZ29pbmcgb24uKQo+IAo+IERhdmlkLCBwZXJoYXBzIHlv
dSBjb3VsZCBzaWduIG9mZiBvbiB0aGlzIHZlcnNpb24uCj4gTWVhbndoaWxlLCBhbm90aGVyIHJl
dmlld2VyIG1pZ2h0IG1ha2Ugc2Vuc2UuCgpTZWVpbmcgYXMgeW91IG9ubHkgYWRkZWQgYSBodW5r
LCBJJ2Qgc2F5IHRoYXQga2VlcGluZyBoaXMgb2xkCnPRlmdub2ZmIGlzIGp1c3QgZmluZS4KCj4g
Cj4gCQkJCQktQWxleAo+IAo+IGZvbGxvdyB0aGVzZSBndWlkZWxpbmVzOgo+IC0gbGVhdmUgaW5p
dGlhbGl6YXRpb24gaW4gdGhlIGRlY2xhcmF0aW9uIGJsb2NrIGlmIGl0IGZpdHMgdGhlIGxpbmUK
PiAtIG1vdmUgdG8gdGhlIGNvZGUgd2hlcmUgaXQncyBtb3JlIHN1aXRhYmxlICgnZm9yJyBpbml0
IGJsb2NrKQo+IAo+IE9yaWdpbmFsbHkgcHJvcG9zZWQgYnkgRGF2aWQgU3RlcmJhIDxkc3RlcmJh
QHN1c2UuY3o+CgpUaGF0IGlzIHdoYXQgdGhlICJGcm9tOiIgdGFnIGlzIGZvciB3aGVuIHlvdSBw
b3N0IHNvbWVvbmUgZWxzZSdzCnBhdGNoLiA7KQoKQW55d2F5LCBsb29rcyBnb29kIG5vdy4KClJl
dmlld2VkLWJ5OiBEYXZlIENoaW5uZXIgPGRjaGlubmVyQHJlZGhhdC5jb20+CgpDaGVlcnMsCgpE
YXZlLgotLSAKRGF2ZSBDaGlubmVyCmRhdmlkQGZyb21vcmJpdC5jb20KCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9z
cy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
