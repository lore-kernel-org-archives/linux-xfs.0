Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1FAdGN3167600 for <xfs@oss.sgi.com>; Wed, 15 Feb 2012 04:39:16 -0600
Received: from mail-bk0-f53.google.com (mail-bk0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id qEBtIAZk81z92nI6
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 15 Feb 2012 02:39:13 -0800 (PST)
Received: by bkcit16 with SMTP id it16so851838bkc.26
	for <xfs@oss.sgi.com>; Wed, 15 Feb 2012 02:39:12 -0800 (PST)
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: Re: quotacheck speed
Date: Wed, 15 Feb 2012 11:39:10 +0100
References: <201202122201.07649.arekm@maven.pl>
	<20120213234235.GE14132@dastard>
	<201202140635.45902.arekm@maven.pl>
In-Reply-To: <201202140635.45902.arekm@maven.pl>
MIME-Version: 1.0
Message-Id: <201202151139.10612.arekm@maven.pl>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

T24gVHVlc2RheSAxNCBvZiBGZWJydWFyeSAyMDEyLCBBcmthZGl1c3ogTWnFm2tpZXdpY3ogd3Jv
dGU6Cj4gT24gVHVlc2RheSAxNCBvZiBGZWJydWFyeSAyMDEyLCBEYXZlIENoaW5uZXIgd3JvdGU6
Cj4gPiBPbiBNb24sIEZlYiAxMywgMjAxMiBhdCAwNzowOTo1MFBNICswMTAwLCBBcmthZGl1c3og
TWnFm2tpZXdpY3ogd3JvdGU6Cj4gPiA+IE9uIE1vbmRheSAxMyBvZiBGZWJydWFyeSAyMDEyLCBD
aHJpc3RvcGggSGVsbHdpZyB3cm90ZToKPiA+ID4gPiBPbiBTdW4sIEZlYiAxMiwgMjAxMiBhdCAx
MDowMTowN1BNICswMTAwLCBBcmthZGl1c3ogTWk/P2tpZXdpY3ogd3JvdGU6Cj4gPiA+ID4gPiBI
aSwKPiA+ID4gPiA+IAo+ID4gPiA+ID4gV2hlbiBtb3VudGluZyA4MDBHQiBmaWxlc3lzdGVtIChh
ZnRlciByZXBhaXIgZm9yIGV4YW1wbGUpIGhlcmUKPiA+ID4gPiA+IHF1b3RhY2hlY2sgdGFrZXMg
MTAgbWludXRlcy4gUXVpdGUgbG9uZyB0aW1lIHRoYXQgYWRkcyB0byB3aG9sZQo+ID4gPiA+ID4g
dGltZSBvZiBmaWxlc3lzdGVtIGRvd250aW1lIChyZXBhaXIgKyBxdW90YWNoZWNrKS4KPiA+ID4g
PiA+IAo+ID4gPiA+ID4gSSB3b25kZXIgaWYgcXVvdGFjaGVjayBjYW4gYmUgc29tZWhvdyBpbXBy
b3ZlZCBvciBkb25lIGRpZmZlcmVudGx5Cj4gPiA+ID4gPiBsaWtlIGRvaW5nIGl0IGluIHBhcmFs
bGVsIHdpdGggbm9ybWFsIGZzIHVzYWdlIChzbyB0aGVyZSB3aWxsIGJlIG5vCj4gPiA+ID4gPiBk
b3dudGltZSkgPwo+ID4gPiA+IAo+ID4gPiA+IEkgdGhpbmsgdGhlIGJlc3QgaWRlYSB0byBpbXBy
b3ZlIHRoZSBwZXJmb3JtYW5jZSBpbiBjYXNlIHlvdSBkaWQgYQo+ID4gPiA+IHJlcGFpciBpcyB0
byBpbnRlZ3JhdGUgdGhlIHF1b3RhY2hlY2sgY29kZSBpbnRvIHJlcGFpci4gIEl0J3MgZmFpcmx5
Cj4gPiA+ID4gc2ltcGxlIGdpdmVuIHRoYXQgcXVvdGFjaGVjayBzaW1wbHkgd2Fsa3MgYWxsIGlu
b2RlcyBhbmQgYWRkcyB0aGVpcgo+ID4gPiA+IHNwYWNlIHVzYWdlIHRvIHRoZSBjb3JyZWN0IHVz
ZXIvZ3JvdXAvcHJvamVjdCwgYW5kIGdpdmVuIHRoYXQgcmVwYWlyCj4gPiA+ID4gYWxyZWFkeSB3
YWxrcyBhbGwgaW5vZGVzLCBhbmQgY2hlY2tzIHRoZWlyIGJsb2NrIG1hcHMgaXQgZG9lcyBtb3N0
IG9mCj4gPiA+ID4gdGhhdCB3b3JrIGFscmVhZHkuCj4gPiA+IAo+ID4gPiBUaGF0IHdvdWxkIGJl
IGludGVyZXN0aW5nIGFuZCBwcm9iYWJseSBtYWtlCj4gPiA+IAo+ID4gPiA+IFRoZSBvbmx5IGRv
d25zaWRlIHdvdWxkIGJlIHRoYXQgdGhlIG1lbW9yeSB1c2FnZQo+ID4gPiA+IG9mIHJlcGFpciBp
bmNyZWFzZXMgYSBiaXQgYnkga2VlcGluZyB0aGUgZHF1b3RzIGluIG1lbW9yeWIsIGJ1dCBldmVu
Cj4gPiA+ID4gZm9yIHlvdXIgMTMwMDAwIGRxdW90IHNldHVwIHRoYXQgd291bGQgYWRkIGFib3V0
IDEwMCBieXRlcyAqIDEzMDAwMAo+ID4gPiA+IHBsZWFzZSBhIGJpdCBvZiBpbi1tZW1vcnkgbWV0
YWRhdGEgKGxlc3MgdGhhbiAyME1CIHRvdGFsKSBvZiBtZW1vcnkKPiA+ID4gPiB1c2FnZSwgc28g
aXQgcHJvYmFibHkgaXMgYSBnb29kIHRyYWRlb2ZmLgo+ID4gPiA+IAo+ID4gPiA+IAo+ID4gPiA+
IEluIHdoYXQgY2FzZXMgZG8geW91IHJlZ3VsYXJseSBydW4gcXVvdGFjaGVjayB3aGVuIHlvdSBk
aWQgbm90IGRvCj4gPiA+ID4gYSByZXBhaXIgZmlyc3Q/Cj4gPiA+IAo+ID4gPiBJIGRvbid0IGlu
aXRpYXRlIHF1b3RhY2hlY2sgbWFudWFsbHkuIEFGQUlLIGludGVybmFsIHhmcyBxdW90YWNoZWNr
Cj4gPiA+IGhhcHBlbnMgaW4gdHdvIGNhc2VzIGhlcmU6Cj4gPiA+IDEpIHJlcGFpci0+bW91bnQK
PiA+ID4gMikgZmlsZXN5c3RlbSBoYXMgcXVvdGFjaGVjayBkb25lIHByb3Blcmx5IHNvbWUgdGlt
ZSBhZ28gLT4gdW1vdW50IC0+Cj4gPiA+IG1vdW50LQo+ID4gPiAKPiA+ID4gPm9vcHMvcmVzZXQv
c29tZXRoaW5nIGxpa2UgdGhhdCBoYXBwZW5zIHdoaWxlIG1vdW50aW5nIC0+IG5ldyBtb3VudAo+
ID4gCj4gPiBTbyB5b3UnZCBsaWtlIGJvdGggcXVvdGFjaGVjayB0byBiZSBzcGVkIHVwIGFuZCBy
ZXBhaXIKPiA+IHRvIGRvIGl0IGFzIHdlbGw/IDspCj4gCj4gV2VsbCwgMSkgaXMgaGFwcGVuaW5n
IG11Y2ggbW9yZSBvZnRlbiB0aGFuIDIpIDotKQoKT2gsIGFuZCBvbmUgbW9yZSBzY2VuYXJpby4g
UnVubmluZyBzeXN0ZW0sIHN5c3JxIHUsIHMsIGIgLT4gbmV3IGJvb3QsIG1vdW50IC0+IApxdW90
YWNoZWNrIHJ1bnMuCgpEb2VzIGl0IG5lZWQgdG8gcnVuIGluIHN1Y2ggY2FzZT8KCi0tIApBcmth
ZGl1c3ogTWnFm2tpZXdpY3ogICAgICAgIFBMRC9MaW51eCBUZWFtCmFyZWttIC8gbWF2ZW4ucGwg
ICAgICAgICAgICBodHRwOi8vZnRwLnBsZC1saW51eC5vcmcvCgpfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dp
LmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
