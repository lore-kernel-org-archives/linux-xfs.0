Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9947529E0D
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 19:16:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7A62F8F8050
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 17:16:06 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	op1450eLee0gTOlW for <xfs@oss.sgi.com>;
	Tue, 21 May 2013 17:16:05 -0700 (PDT)
Date: Wed, 22 May 2013 10:16:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS assertion from truncate. (3.10-rc2)
Message-ID: <20130522001603.GZ29466@dastard>
References: <20130521225257.GA12713@redhat.com>
	<20130521233429.GW29466@dastard>
	<20130521234016.GB14347@redhat.com>
	<20130521235410.GY29466@dastard>
	<20130522000803.GA19891@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130522000803.GA19891@redhat.com>
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
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

T24gVHVlLCBNYXkgMjEsIDIwMTMgYXQgMDg6MDg6MDNQTSAtMDQwMCwgRGF2ZSBKb25lcyB3cm90
ZToKPiBPbiBXZWQsIE1heSAyMiwgMjAxMyBhdCAwOTo1NDoxMEFNICsxMDAwLCBEYXZlIENoaW5u
ZXIgd3JvdGU6Cj4gID4gT24gVHVlLCBNYXkgMjEsIDIwMTMgYXQgMDc6NDA6MTZQTSAtMDQwMCwg
RGF2ZSBKb25lcyB3cm90ZToKPiAgPiA+IE9uIFdlZCwgTWF5IDIyLCAyMDEzIGF0IDA5OjM0OjI5
QU0gKzEwMDAsIERhdmUgQ2hpbm5lciB3cm90ZToKPiAgPiA+ICA+IE9uIFR1ZSwgTWF5IDIxLCAy
MDEzIGF0IDA2OjUyOjU3UE0gLTA0MDAsIERhdmUgSm9uZXMgd3JvdGU6Cj4gID4gPiAgPiA+IFsg
IDQ2NC4yMTA1OThdIFhGUzogQXNzZXJ0aW9uIGZhaWxlZDogKG1hc2sgJiAoQVRUUl9NT0RFfEFU
VFJfVUlEfEFUVFJfR0lEfEFUVFJfQVRJTUV8QVRUUl9BVElNRV9TRVR8IEFUVFJfTVRJTUVfU0VU
fEFUVFJfS0lMTF9TVUlEfEFUVFJfS0lMTF9TR0lEfCBBVFRSX0tJTExfUFJJVnxBVFRSX1RJTUVT
X1NFVCkpID09IDAsIGZpbGU6IGZzL3hmcy94ZnNfaW9wcy5jLCBsaW5lOiA3MTkKPiAgPiA+ICA+
IAo+ICA+ID4gID4gTmV2ZXIgc2VlbiB0aGF0IGZpcmUgYmVmb3JlLCBidXQgdGhpcyBpcyB3aHkg
d2UgaGF2ZSBBU1NFUlQoKXMgbGlrZQo+ICA+ID4gID4gdGhpcyAtIHdlJ3JlIGJlaW5nIGhhbmRl
ZCBzb21ldGhpbmcgYnkgdGhlIFZGUyB3ZSBkb24ndCBleHBlY3QuLi4KPiAgPiA+ICA+IAo+ICA+
ID4gID4gQ2FuIHlvdSBnaXZlIG1lIHNvbWUgY29udGV4dCBvZiB0aGUgZmlsZSBwZXJtaXNzaW9u
cyBiZWZvcmUgdGhlCj4gID4gPiAgPiBzeXNjYWxsIGFuZCB3aGF0IHRoZSBzeXNjYWxsIHBhcmFt
ZXRlcnMgYXJlPyBpLmUuIGlzIHRoaXMgbGlrZWx5IHRvCj4gID4gPiAgPiBiZSB0cnlpbmcgdG8g
c3RyaXAgU1VJRC9TR0lEIGR1cmluZyB0aGUgdHJ1bmNhdGUgb3BlcmF0aW9uPwo+ICA+ID4gCj4g
ID4gPiBubyBpZGVhIHRiaC4gSXMgdGhlcmUgc29tZXRoaW5nIEkgY2FuIGFkZCB0byB0aGF0IGFz
c2VydCB0byBkdW1wCj4gID4gPiB3aGljaCBmaWxlIGl0IHdhcyB0cmlnZ2VyZWQgYnkgPwo+ICA+
IAo+ICA+IENvbnZlcnQgdGhlIGFzc2VydCB0byBhIGlmICgpLCBhbmQgdGhlbiBpbiB0aGUgYm9k
eSBkbyBzb21ldGhpbmcKPiAgPiBsaWtlOgo+ICA+IAo+ICA+IAlpZiAobWFzayAmICguLi4pIHsK
PiAgPiAJCWNoYXIgYnVmW01BWF9QQVRITEVOXTsKPiAgPiAKPiAgPiAJCWRfcGF0aChWRlNfSShp
cCktPmlfZGVudHJ5LCBidWYsIE1BWFBBVEhMRU4pOwo+ICA+IAkJeGZzX3dhcm4obXAsICIlczog
bWFzayAweCV4IG1pc21hdGNoIG9uIGZpbGUgJXNcbiIsCj4gID4gCQkJIF9fZnVuY19fLCBtYXNr
LCBidWYpOwo+ICA+IAkJQVNTRVJUKDApOwo+ICA+IAl9Cj4gCj4gZnMveGZzL3hmc19pb3BzLmM6
IEluIGZ1bmN0aW9uIOKAmHhmc19zZXRhdHRyX3NpemXigJk6Cj4gZnMveGZzL3hmc19pb3BzLmM6
NzIzOjE3OiBlcnJvcjogaW5jb21wYXRpYmxlIHR5cGUgZm9yIGFyZ3VtZW50IDEgb2Yg4oCYZF9w
YXRo4oCZCj4gICAgICAgICAgICAgICAgICBkX3BhdGgoVkZTX0koaXApLT5pX2RlbnRyeSwgYnVm
LCBNQVhQQVRITEVOKTsKPiAgICAgICAgICAgICAgICAgIF4KCk9oLCBzb3JyeSwgZGVudHJ5X3Bh
dGgoKSBpcyB0aGUgdmVyc2lvbiB0aGF0IHRha2VzIGEgZGVudHJ5IGFzIHRoZQpmaXJzdCBwYXJh
bWV0ZXIuIEkgYWx3YXlzIGdldCB0aGUgdHdvIGNvbmZ1c2VkLi4uCgpDaGVlcnMsCgpEYXZlLgot
LSAKRGF2ZSBDaGlubmVyCmRhdmlkQGZyb21vcmJpdC5jb20KCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2ku
Y29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
