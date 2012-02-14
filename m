Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1E5ZpVG068748 for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 23:35:51 -0600
Received: from mail-ey0-f181.google.com (mail-ey0-f181.google.com
	[209.85.215.181]) by cuda.sgi.com with ESMTP id
	sTd1RV2245Vu3DUP (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 Feb 2012 21:35:49 -0800 (PST)
Received: by eaak14 with SMTP id k14so2911217eaa.26
	for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 21:35:47 -0800 (PST)
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: Re: quotacheck speed
Date: Tue, 14 Feb 2012 06:35:45 +0100
References: <201202122201.07649.arekm@maven.pl>
	<201202131909.50605.arekm@maven.pl>
	<20120213234235.GE14132@dastard>
In-Reply-To: <20120213234235.GE14132@dastard>
MIME-Version: 1.0
Message-Id: <201202140635.45902.arekm@maven.pl>
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

T24gVHVlc2RheSAxNCBvZiBGZWJydWFyeSAyMDEyLCBEYXZlIENoaW5uZXIgd3JvdGU6Cj4gT24g
TW9uLCBGZWIgMTMsIDIwMTIgYXQgMDc6MDk6NTBQTSArMDEwMCwgQXJrYWRpdXN6IE1pxZtraWV3
aWN6IHdyb3RlOgo+ID4gT24gTW9uZGF5IDEzIG9mIEZlYnJ1YXJ5IDIwMTIsIENocmlzdG9waCBI
ZWxsd2lnIHdyb3RlOgo+ID4gPiBPbiBTdW4sIEZlYiAxMiwgMjAxMiBhdCAxMDowMTowN1BNICsw
MTAwLCBBcmthZGl1c3ogTWk/P2tpZXdpY3ogd3JvdGU6Cj4gPiA+ID4gSGksCj4gPiA+ID4gCj4g
PiA+ID4gV2hlbiBtb3VudGluZyA4MDBHQiBmaWxlc3lzdGVtIChhZnRlciByZXBhaXIgZm9yIGV4
YW1wbGUpIGhlcmUKPiA+ID4gPiBxdW90YWNoZWNrIHRha2VzIDEwIG1pbnV0ZXMuIFF1aXRlIGxv
bmcgdGltZSB0aGF0IGFkZHMgdG8gd2hvbGUgdGltZQo+ID4gPiA+IG9mIGZpbGVzeXN0ZW0gZG93
bnRpbWUgKHJlcGFpciArIHF1b3RhY2hlY2spLgo+ID4gPiA+IAo+ID4gPiA+IEkgd29uZGVyIGlm
IHF1b3RhY2hlY2sgY2FuIGJlIHNvbWVob3cgaW1wcm92ZWQgb3IgZG9uZSBkaWZmZXJlbnRseQo+
ID4gPiA+IGxpa2UgZG9pbmcgaXQgaW4gcGFyYWxsZWwgd2l0aCBub3JtYWwgZnMgdXNhZ2UgKHNv
IHRoZXJlIHdpbGwgYmUgbm8KPiA+ID4gPiBkb3dudGltZSkgPwo+ID4gPiAKPiA+ID4gSSB0aGlu
ayB0aGUgYmVzdCBpZGVhIHRvIGltcHJvdmUgdGhlIHBlcmZvcm1hbmNlIGluIGNhc2UgeW91IGRp
ZCBhCj4gPiA+IHJlcGFpciBpcyB0byBpbnRlZ3JhdGUgdGhlIHF1b3RhY2hlY2sgY29kZSBpbnRv
IHJlcGFpci4gIEl0J3MgZmFpcmx5Cj4gPiA+IHNpbXBsZSBnaXZlbiB0aGF0IHF1b3RhY2hlY2sg
c2ltcGx5IHdhbGtzIGFsbCBpbm9kZXMgYW5kIGFkZHMgdGhlaXIKPiA+ID4gc3BhY2UgdXNhZ2Ug
dG8gdGhlIGNvcnJlY3QgdXNlci9ncm91cC9wcm9qZWN0LCBhbmQgZ2l2ZW4gdGhhdCByZXBhaXIK
PiA+ID4gYWxyZWFkeSB3YWxrcyBhbGwgaW5vZGVzLCBhbmQgY2hlY2tzIHRoZWlyIGJsb2NrIG1h
cHMgaXQgZG9lcyBtb3N0IG9mCj4gPiA+IHRoYXQgd29yayBhbHJlYWR5Lgo+ID4gCj4gPiBUaGF0
IHdvdWxkIGJlIGludGVyZXN0aW5nIGFuZCBwcm9iYWJseSBtYWtlCj4gPiAKPiA+ID4gVGhlIG9u
bHkgZG93bnNpZGUgd291bGQgYmUgdGhhdCB0aGUgbWVtb3J5IHVzYWdlCj4gPiA+IG9mIHJlcGFp
ciBpbmNyZWFzZXMgYSBiaXQgYnkga2VlcGluZyB0aGUgZHF1b3RzIGluIG1lbW9yeWIsIGJ1dCBl
dmVuCj4gPiA+IGZvciB5b3VyIDEzMDAwMCBkcXVvdCBzZXR1cCB0aGF0IHdvdWxkIGFkZCBhYm91
dCAxMDAgYnl0ZXMgKiAxMzAwMDAKPiA+ID4gcGxlYXNlIGEgYml0IG9mIGluLW1lbW9yeSBtZXRh
ZGF0YSAobGVzcyB0aGFuIDIwTUIgdG90YWwpIG9mIG1lbW9yeQo+ID4gPiB1c2FnZSwgc28gaXQg
cHJvYmFibHkgaXMgYSBnb29kIHRyYWRlb2ZmLgo+ID4gPiAKPiA+ID4gCj4gPiA+IEluIHdoYXQg
Y2FzZXMgZG8geW91IHJlZ3VsYXJseSBydW4gcXVvdGFjaGVjayB3aGVuIHlvdSBkaWQgbm90IGRv
Cj4gPiA+IGEgcmVwYWlyIGZpcnN0Pwo+ID4gCj4gPiBJIGRvbid0IGluaXRpYXRlIHF1b3RhY2hl
Y2sgbWFudWFsbHkuIEFGQUlLIGludGVybmFsIHhmcyBxdW90YWNoZWNrCj4gPiBoYXBwZW5zIGlu
IHR3byBjYXNlcyBoZXJlOgo+ID4gMSkgcmVwYWlyLT5tb3VudAo+ID4gMikgZmlsZXN5c3RlbSBo
YXMgcXVvdGFjaGVjayBkb25lIHByb3Blcmx5IHNvbWUgdGltZSBhZ28gLT4gdW1vdW50IC0+Cj4g
PiBtb3VudC0KPiA+IAo+ID4gPm9vcHMvcmVzZXQvc29tZXRoaW5nIGxpa2UgdGhhdCBoYXBwZW5z
IHdoaWxlIG1vdW50aW5nIC0+IG5ldyBtb3VudAo+IAo+IFNvIHlvdSdkIGxpa2UgYm90aCBxdW90
YWNoZWNrIHRvIGJlIHNwZWQgdXAgYW5kIHJlcGFpcgo+IHRvIGRvIGl0IGFzIHdlbGw/IDspCgpX
ZWxsLCAxKSBpcyBoYXBwZW5pbmcgbXVjaCBtb3JlIG9mdGVuIHRoYW4gMikgOi0pCgotLSAKQXJr
YWRpdXN6IE1pxZtraWV3aWN6ICAgICAgICBQTEQvTGludXggVGVhbQphcmVrbSAvIG1hdmVuLnBs
ICAgICAgICAgICAgaHR0cDovL2Z0cC5wbGQtbGludXgub3JnLwoKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNn
aS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
