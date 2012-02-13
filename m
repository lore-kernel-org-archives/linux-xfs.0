Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1DNgcDo051714 for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 17:42:38 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	107B5tYC1TbA5tGh for <xfs@oss.sgi.com>;
	Mon, 13 Feb 2012 15:42:36 -0800 (PST)
Date: Tue, 14 Feb 2012 10:42:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: quotacheck speed
Message-ID: <20120213234235.GE14132@dastard>
References: <201202122201.07649.arekm@maven.pl>
	<20120212234425.GA23625@infradead.org>
	<201202131909.50605.arekm@maven.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201202131909.50605.arekm@maven.pl>
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

T24gTW9uLCBGZWIgMTMsIDIwMTIgYXQgMDc6MDk6NTBQTSArMDEwMCwgQXJrYWRpdXN6IE1pxZtr
aWV3aWN6IHdyb3RlOgo+IE9uIE1vbmRheSAxMyBvZiBGZWJydWFyeSAyMDEyLCBDaHJpc3RvcGgg
SGVsbHdpZyB3cm90ZToKPiA+IE9uIFN1biwgRmViIDEyLCAyMDEyIGF0IDEwOjAxOjA3UE0gKzAx
MDAsIEFya2FkaXVzeiBNaT8/a2lld2ljeiB3cm90ZToKPiA+ID4gSGksCj4gPiA+IAo+ID4gPiBX
aGVuIG1vdW50aW5nIDgwMEdCIGZpbGVzeXN0ZW0gKGFmdGVyIHJlcGFpciBmb3IgZXhhbXBsZSkg
aGVyZSBxdW90YWNoZWNrCj4gPiA+IHRha2VzIDEwIG1pbnV0ZXMuIFF1aXRlIGxvbmcgdGltZSB0
aGF0IGFkZHMgdG8gd2hvbGUgdGltZSBvZiBmaWxlc3lzdGVtCj4gPiA+IGRvd250aW1lIChyZXBh
aXIgKyBxdW90YWNoZWNrKS4KPiA+ID4gCj4gPiA+IEkgd29uZGVyIGlmIHF1b3RhY2hlY2sgY2Fu
IGJlIHNvbWVob3cgaW1wcm92ZWQgb3IgZG9uZSBkaWZmZXJlbnRseSBsaWtlCj4gPiA+IGRvaW5n
IGl0IGluIHBhcmFsbGVsIHdpdGggbm9ybWFsIGZzIHVzYWdlIChzbyB0aGVyZSB3aWxsIGJlIG5v
IGRvd250aW1lKQo+ID4gPiA/Cj4gPiAKPiA+IEkgdGhpbmsgdGhlIGJlc3QgaWRlYSB0byBpbXBy
b3ZlIHRoZSBwZXJmb3JtYW5jZSBpbiBjYXNlIHlvdSBkaWQgYQo+ID4gcmVwYWlyIGlzIHRvIGlu
dGVncmF0ZSB0aGUgcXVvdGFjaGVjayBjb2RlIGludG8gcmVwYWlyLiAgSXQncyBmYWlybHkKPiA+
IHNpbXBsZSBnaXZlbiB0aGF0IHF1b3RhY2hlY2sgc2ltcGx5IHdhbGtzIGFsbCBpbm9kZXMgYW5k
IGFkZHMgdGhlaXIKPiA+IHNwYWNlIHVzYWdlIHRvIHRoZSBjb3JyZWN0IHVzZXIvZ3JvdXAvcHJv
amVjdCwgYW5kIGdpdmVuIHRoYXQgcmVwYWlyCj4gPiBhbHJlYWR5IHdhbGtzIGFsbCBpbm9kZXMs
IGFuZCBjaGVja3MgdGhlaXIgYmxvY2sgbWFwcyBpdCBkb2VzIG1vc3Qgb2YKPiA+IHRoYXQgd29y
ayBhbHJlYWR5Lgo+IAo+IFRoYXQgd291bGQgYmUgaW50ZXJlc3RpbmcgYW5kIHByb2JhYmx5IG1h
a2UgCj4gCj4gPiBUaGUgb25seSBkb3duc2lkZSB3b3VsZCBiZSB0aGF0IHRoZSBtZW1vcnkgdXNh
Z2UKPiA+IG9mIHJlcGFpciBpbmNyZWFzZXMgYSBiaXQgYnkga2VlcGluZyB0aGUgZHF1b3RzIGlu
IG1lbW9yeWIsIGJ1dCBldmVuCj4gPiBmb3IgeW91ciAxMzAwMDAgZHF1b3Qgc2V0dXAgdGhhdCB3
b3VsZCBhZGQgYWJvdXQgMTAwIGJ5dGVzICogMTMwMDAwCj4gPiBwbGVhc2UgYSBiaXQgb2YgaW4t
bWVtb3J5IG1ldGFkYXRhIChsZXNzIHRoYW4gMjBNQiB0b3RhbCkgb2YgbWVtb3J5Cj4gPiB1c2Fn
ZSwgc28gaXQgcHJvYmFibHkgaXMgYSBnb29kIHRyYWRlb2ZmLgo+IAo+ID4gCj4gPiBJbiB3aGF0
IGNhc2VzIGRvIHlvdSByZWd1bGFybHkgcnVuIHF1b3RhY2hlY2sgd2hlbiB5b3UgZGlkIG5vdCBk
bwo+ID4gYSByZXBhaXIgZmlyc3Q/Cj4gCj4gSSBkb24ndCBpbml0aWF0ZSBxdW90YWNoZWNrIG1h
bnVhbGx5LiBBRkFJSyBpbnRlcm5hbCB4ZnMgcXVvdGFjaGVjayBoYXBwZW5zIGluIAo+IHR3byBj
YXNlcyBoZXJlOgo+IDEpIHJlcGFpci0+bW91bnQKPiAyKSBmaWxlc3lzdGVtIGhhcyBxdW90YWNo
ZWNrIGRvbmUgcHJvcGVybHkgc29tZSB0aW1lIGFnbyAtPiB1bW91bnQgLT4gbW91bnQtCj4gPm9v
cHMvcmVzZXQvc29tZXRoaW5nIGxpa2UgdGhhdCBoYXBwZW5zIHdoaWxlIG1vdW50aW5nIC0+IG5l
dyBtb3VudAoKU28geW91J2QgbGlrZSBib3RoIHF1b3RhY2hlY2sgdG8gYmUgc3BlZCB1cCBhbmQg
cmVwYWlyCnRvIGRvIGl0IGFzIHdlbGw/IDspCgpDaGVlcnMsCgpEYXZlLgotLSAKRGF2ZSBDaGlu
bmVyCmRhdmlkQGZyb21vcmJpdC5jb20KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9v
c3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
