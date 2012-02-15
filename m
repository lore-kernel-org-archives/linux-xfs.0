Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1FLjMgA205289 for <xfs@oss.sgi.com>; Wed, 15 Feb 2012 15:45:22 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	rESSAlkthSmVCClw for <xfs@oss.sgi.com>;
	Wed, 15 Feb 2012 13:45:20 -0800 (PST)
Date: Thu, 16 Feb 2012 08:45:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: quotacheck speed
Message-ID: <20120215214517.GL14132@dastard>
References: <201202122201.07649.arekm@maven.pl>
	<20120213234235.GE14132@dastard>
	<201202140635.45902.arekm@maven.pl>
	<201202151139.10612.arekm@maven.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201202151139.10612.arekm@maven.pl>
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
To: Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

T24gV2VkLCBGZWIgMTUsIDIwMTIgYXQgMTE6Mzk6MTBBTSArMDEwMCwgQXJrYWRpdXN6IE1pxZtr
aWV3aWN6IHdyb3RlOgo+IE9uIFR1ZXNkYXkgMTQgb2YgRmVicnVhcnkgMjAxMiwgQXJrYWRpdXN6
IE1pxZtraWV3aWN6IHdyb3RlOgo+ID4gT24gVHVlc2RheSAxNCBvZiBGZWJydWFyeSAyMDEyLCBE
YXZlIENoaW5uZXIgd3JvdGU6Cj4gPiA+IE9uIE1vbiwgRmViIDEzLCAyMDEyIGF0IDA3OjA5OjUw
UE0gKzAxMDAsIEFya2FkaXVzeiBNacWba2lld2ljeiB3cm90ZToKPiA+ID4gPiBPbiBNb25kYXkg
MTMgb2YgRmVicnVhcnkgMjAxMiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gPiA+ID4gPiBJ
biB3aGF0IGNhc2VzIGRvIHlvdSByZWd1bGFybHkgcnVuIHF1b3RhY2hlY2sgd2hlbiB5b3UgZGlk
IG5vdCBkbwo+ID4gPiA+ID4gYSByZXBhaXIgZmlyc3Q/Cj4gPiA+ID4gCj4gPiA+ID4gSSBkb24n
dCBpbml0aWF0ZSBxdW90YWNoZWNrIG1hbnVhbGx5LiBBRkFJSyBpbnRlcm5hbCB4ZnMgcXVvdGFj
aGVjawo+ID4gPiA+IGhhcHBlbnMgaW4gdHdvIGNhc2VzIGhlcmU6Cj4gPiA+ID4gMSkgcmVwYWly
LT5tb3VudAo+ID4gPiA+IDIpIGZpbGVzeXN0ZW0gaGFzIHF1b3RhY2hlY2sgZG9uZSBwcm9wZXJs
eSBzb21lIHRpbWUgYWdvIC0+IHVtb3VudCAtPgo+ID4gPiA+IG1vdW50LQo+ID4gPiA+IAo+ID4g
PiA+ID5vb3BzL3Jlc2V0L3NvbWV0aGluZyBsaWtlIHRoYXQgaGFwcGVucyB3aGlsZSBtb3VudGlu
ZyAtPiBuZXcgbW91bnQKPiA+ID4gCj4gPiA+IFNvIHlvdSdkIGxpa2UgYm90aCBxdW90YWNoZWNr
IHRvIGJlIHNwZWQgdXAgYW5kIHJlcGFpcgo+ID4gPiB0byBkbyBpdCBhcyB3ZWxsPyA7KQo+ID4g
Cj4gPiBXZWxsLCAxKSBpcyBoYXBwZW5pbmcgbXVjaCBtb3JlIG9mdGVuIHRoYW4gMikgOi0pCj4g
Cj4gT2gsIGFuZCBvbmUgbW9yZSBzY2VuYXJpby4gUnVubmluZyBzeXN0ZW0sIHN5c3JxIHUsIHMs
IGIgLT4gbmV3IGJvb3QsIG1vdW50IC0+IAo+IHF1b3RhY2hlY2sgcnVucy4KPiAKPiBEb2VzIGl0
IG5lZWQgdG8gcnVuIGluIHN1Y2ggY2FzZT8KClRoYXQncyBubyBkaWZmZXJlbnQgdG8gYW4gdW5j
bGVhbiBzaHV0ZG93bi4gSSdtIG5vdCBzdXJlIHdoeSB0aGF0CndvdWxkIHRyaWdnZXIgYSBxdW90
YWNoZWNrLiBBbnl0aGluZyBpbnRoZSBsb2cgdGhhdCBtaWdodCBpbmRpY2F0ZQp3aHkgaXQgc3Rh
cnRlZCBhIHF1b3RhY2hlY2s/CgpDaGVlcnMsCgpEYXZlLgotLSAKRGF2ZSBDaGlubmVyCmRhdmlk
QGZyb21vcmJpdC5jb20KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNv
bS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
