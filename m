Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1DI9vxt029903 for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 12:09:58 -0600
Received: from mail-ee0-f53.google.com (mail-ee0-f53.google.com
	[74.125.83.53]) by cuda.sgi.com with ESMTP id ka0a5xwkBLuhH6Cg
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 13 Feb 2012 10:09:55 -0800 (PST)
Received: by eeke51 with SMTP id e51so2802744eek.26
	for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 10:09:54 -0800 (PST)
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: Re: quotacheck speed
Date: Mon, 13 Feb 2012 19:09:50 +0100
References: <201202122201.07649.arekm@maven.pl>
	<20120212234425.GA23625@infradead.org>
In-Reply-To: <20120212234425.GA23625@infradead.org>
MIME-Version: 1.0
Message-Id: <201202131909.50605.arekm@maven.pl>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

T24gTW9uZGF5IDEzIG9mIEZlYnJ1YXJ5IDIwMTIsIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOgo+
IE9uIFN1biwgRmViIDEyLCAyMDEyIGF0IDEwOjAxOjA3UE0gKzAxMDAsIEFya2FkaXVzeiBNaT8/
a2lld2ljeiB3cm90ZToKPiA+IEhpLAo+ID4gCj4gPiBXaGVuIG1vdW50aW5nIDgwMEdCIGZpbGVz
eXN0ZW0gKGFmdGVyIHJlcGFpciBmb3IgZXhhbXBsZSkgaGVyZSBxdW90YWNoZWNrCj4gPiB0YWtl
cyAxMCBtaW51dGVzLiBRdWl0ZSBsb25nIHRpbWUgdGhhdCBhZGRzIHRvIHdob2xlIHRpbWUgb2Yg
ZmlsZXN5c3RlbQo+ID4gZG93bnRpbWUgKHJlcGFpciArIHF1b3RhY2hlY2spLgo+ID4gCj4gPiBJ
IHdvbmRlciBpZiBxdW90YWNoZWNrIGNhbiBiZSBzb21laG93IGltcHJvdmVkIG9yIGRvbmUgZGlm
ZmVyZW50bHkgbGlrZQo+ID4gZG9pbmcgaXQgaW4gcGFyYWxsZWwgd2l0aCBub3JtYWwgZnMgdXNh
Z2UgKHNvIHRoZXJlIHdpbGwgYmUgbm8gZG93bnRpbWUpCj4gPiA/Cj4gCj4gSSB0aGluayB0aGUg
YmVzdCBpZGVhIHRvIGltcHJvdmUgdGhlIHBlcmZvcm1hbmNlIGluIGNhc2UgeW91IGRpZCBhCj4g
cmVwYWlyIGlzIHRvIGludGVncmF0ZSB0aGUgcXVvdGFjaGVjayBjb2RlIGludG8gcmVwYWlyLiAg
SXQncyBmYWlybHkKPiBzaW1wbGUgZ2l2ZW4gdGhhdCBxdW90YWNoZWNrIHNpbXBseSB3YWxrcyBh
bGwgaW5vZGVzIGFuZCBhZGRzIHRoZWlyCj4gc3BhY2UgdXNhZ2UgdG8gdGhlIGNvcnJlY3QgdXNl
ci9ncm91cC9wcm9qZWN0LCBhbmQgZ2l2ZW4gdGhhdCByZXBhaXIKPiBhbHJlYWR5IHdhbGtzIGFs
bCBpbm9kZXMsIGFuZCBjaGVja3MgdGhlaXIgYmxvY2sgbWFwcyBpdCBkb2VzIG1vc3Qgb2YKPiB0
aGF0IHdvcmsgYWxyZWFkeS4KClRoYXQgd291bGQgYmUgaW50ZXJlc3RpbmcgYW5kIHByb2JhYmx5
IG1ha2UgCgo+IFRoZSBvbmx5IGRvd25zaWRlIHdvdWxkIGJlIHRoYXQgdGhlIG1lbW9yeSB1c2Fn
ZQo+IG9mIHJlcGFpciBpbmNyZWFzZXMgYSBiaXQgYnkga2VlcGluZyB0aGUgZHF1b3RzIGluIG1l
bW9yeWIsIGJ1dCBldmVuCj4gZm9yIHlvdXIgMTMwMDAwIGRxdW90IHNldHVwIHRoYXQgd291bGQg
YWRkIGFib3V0IDEwMCBieXRlcyAqIDEzMDAwMAo+IHBsZWFzZSBhIGJpdCBvZiBpbi1tZW1vcnkg
bWV0YWRhdGEgKGxlc3MgdGhhbiAyME1CIHRvdGFsKSBvZiBtZW1vcnkKPiB1c2FnZSwgc28gaXQg
cHJvYmFibHkgaXMgYSBnb29kIHRyYWRlb2ZmLgoKPiAKPiBJbiB3aGF0IGNhc2VzIGRvIHlvdSBy
ZWd1bGFybHkgcnVuIHF1b3RhY2hlY2sgd2hlbiB5b3UgZGlkIG5vdCBkbwo+IGEgcmVwYWlyIGZp
cnN0PwoKSSBkb24ndCBpbml0aWF0ZSBxdW90YWNoZWNrIG1hbnVhbGx5LiBBRkFJSyBpbnRlcm5h
bCB4ZnMgcXVvdGFjaGVjayBoYXBwZW5zIGluIAp0d28gY2FzZXMgaGVyZToKMSkgcmVwYWlyLT5t
b3VudAoyKSBmaWxlc3lzdGVtIGhhcyBxdW90YWNoZWNrIGRvbmUgcHJvcGVybHkgc29tZSB0aW1l
IGFnbyAtPiB1bW91bnQgLT4gbW91bnQtCj5vb3BzL3Jlc2V0L3NvbWV0aGluZyBsaWtlIHRoYXQg
aGFwcGVucyB3aGlsZSBtb3VudGluZyAtPiBuZXcgbW91bnQKCi0tIApBcmthZGl1c3ogTWnFm2tp
ZXdpY3ogICAgICAgIFBMRC9MaW51eCBUZWFtCmFyZWttIC8gbWF2ZW4ucGwgICAgICAgICAgICBo
dHRwOi8vZnRwLnBsZC1saW51eC5vcmcvCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8v
b3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
