Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1866F7F80
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 22:57:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DA0948F8035
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 20:57:44 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	j56vHygNv0WkBh1O for <xfs@oss.sgi.com>;
	Mon, 29 Jun 2015 20:57:42 -0700 (PDT)
Date: Tue, 30 Jun 2015 13:57:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 13/17] mkfs: encode conflicts into parsing table
Message-ID: <20150630035736.GJ7943@dastard>
References: <1434711726-13092-1-git-send-email-jtulak@redhat.com>
	<1434711726-13092-14-git-send-email-jtulak@redhat.com>
	<20150626171730.GI40750@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150626171730.GI40750@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>, Jan =?utf-8?B?xaR1bMOhaw==?= <jtulak@redhat.com>

T24gRnJpLCBKdW4gMjYsIDIwMTUgYXQgMDE6MTc6MzFQTSAtMDQwMCwgQnJpYW4gRm9zdGVyIHdy
b3RlOgo+IE9uIEZyaSwgSnVuIDE5LCAyMDE1IGF0IDAxOjAyOjAyUE0gKzAyMDAsIEphbiDFpHVs
w6FrIHdyb3RlOgo+ID4gRnJvbTogRGF2ZSBDaGlubmVyIDxkY2hpbm5lckByZWRoYXQuY29tPgo+
ID4gCj4gPiBNYW55IG9wdGlvbnMgY29uZmxpY3QsIHNvIHdlIG5lZWQgdG8gc3BlY2lmeSB3aGlj
aCBvcHRpb25zIGNvbmZsaWN0Cj4gPiB3aXRoIGVhY2ggb3RoZXIgaW4gYSBnZW5lcmljIG1hbm5l
ci4gV2UgYWxyZWFkeSBoYXZlIGEgInNlZW4iCj4gPiB2YXJpYWJsZSB1c2VkIGZvciByZXNwZWNp
ZmljYXRpb24gZGV0ZWN0aW9uLCBzbyB3ZSBjYW4gYWxzbyB1c2UgdGhpcwo+ID4gY29kZSBjb25m
bGljdCBkZXRlY3Rpb24uIEhlbmNlIGFkZCBhICJjb25mbGljdHMiIGFycmF5IHRvIHRoZSBzdWIK
PiA+IG9wdGlvbnMgcGFyYW1ldGVyIGRlZmluaXRpb24uCi4uLi4uCj4gPiBAQCAtMjAyMCw3ICsy
MDI3LDcgQEAgXygiY2Fubm90IHNwZWNpZnkgYm90aCAtbSBjcmM9MSBhbmQgLW4gZnR5cGVcbiIp
KTsKPiA+ICAJCQkJCQkgICZ2YWx1ZSkpIHsKPiA+ICAJCQkJY2FzZSBTX0xPRzoKPiA+ICAJCQkJ
Y2FzZSBTX1NFQ1RMT0c6Cj4gPiAtCQkJCQlpZiAoc3NmbGFnIHx8IGxzc2ZsYWcpCj4gPiArCQkJ
CQlpZiAobHNzZmxhZykKPiA+ICAJCQkJCQljb25mbGljdCgncycsIHN1Ym9wdHMsCj4gPiAgCQkJ
CQkJCSBTX1NFQ1RTSVpFLCBTX1NFQ1RMT0cpOwo+ID4gIAkJCQkJc2VjdG9ybG9nID0gZ2V0bnVt
KHZhbHVlLCAmc29wdHMsCj4gPiBAQCAtMjAzMiw3ICsyMDM5LDcgQEAgXygiY2Fubm90IHNwZWNp
ZnkgYm90aCAtbSBjcmM9MSBhbmQgLW4gZnR5cGVcbiIpKTsKPiA+ICAJCQkJCWJyZWFrOwo+ID4g
IAkJCQljYXNlIFNfU0laRToKPiA+ICAJCQkJY2FzZSBTX1NFQ1RTSVpFOgo+ID4gLQkJCQkJaWYg
KHNsZmxhZyB8fCBsc2xmbGFnKQo+ID4gKwkJCQkJaWYgKGxzbGZsYWcpCj4gPiAgCQkJCQkJY29u
ZmxpY3QoJ3MnLCBzdWJvcHRzLCBTX1NFQ1RMT0csCj4gPiAgCQkJCQkJCSBTX1NFQ1RTSVpFKTsK
PiAKPiBIbW0uLiBzbyBpcyB0aGUgbGltaXRhdGlvbiBoZXJlIHRoYXQgd2UgY2FuJ3QgZG8gZ2Vu
ZXJpYyBjb25mbGljdAo+IGRldGVjdGlvbiBhY3Jvc3MgZGlmZmVyZW50IG9wdGlvbiBzdHJ1Y3Rz
PyBJZiBzbywgSSBzdXBwb3NlIHRoYXQncyBub3QKPiB0aGUgZW5kIG9mIHRoZSB3b3JsZC4gVGhl
IGNsZWFudXAgaXMgc3RpbGwgd2VsbCB3b3J0aCBpdC4KCkkganVzdCBuZXZlciBnb3QgYXJvdW5k
IHRvIGNvZGluZyBpdCBpbiBhIGdlbmVyaWMgZmFzaGlvbiAtIEkgZGlkbid0CmZpbmlzaCB0aGUg
ZW50aXJlIHBhdGNoc2V0IGJhY2sgd2hlbiBJIG9yaWdpbmFsbHkgd3JvdGUgaXQuLi4uCgo+IEkg
d29uZGVyIGlmIHdlCj4gc3RpbGwgbmVlZCB0byBzZXQgbHNsZmxhZy9sc3NmbGFnIGluIGVpdGhl
ciBvZiB0aGUgYWJvdmUgY2FzZXMsIHRob3VnaC4KPiBJdCBzZWVtcyBsaWtlIHRoZSBnZW5lcmlj
IGRldGVjdGlvbiBzaG91bGQgaGFuZGxlIGl0Li4/CgpJbiB0aGUgZW5kIGl0IHdvdWxkIGxvb2sg
YXQgdGhlIHJlbGV2YW50IC0+c2VlbiBmbGFnIHRvIGRldGVybWluZQppZiB0aGVyZSB3YXMgYSBj
cm9zcy1vcHRpb24tc3RydWN0IGNvbmZsaWN0LiBFc3NlbnRpYWxseSwgdGhlCmNvbmZsaWN0IGRl
ZmluaXRpb24gbmVlZHMgdG8gZGVmaW5lIGNvbmZsaWN0cyB2aWEgYSB7Z3JvdXAsIG9wdGlvbn0K
dHVwbGUgcmF0aGVyIHRoYW4ganVzdCB0aGUge29wdGlvbn0gaXQgdXNlcyBub3cuLi4KCi1EYXZl
LgotLSAKRGF2ZSBDaGlubmVyCmRhdmlkQGZyb21vcmJpdC5jb20KCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5z
Z2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
