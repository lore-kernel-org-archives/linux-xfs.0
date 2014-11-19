Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4F60E7F3F
	for <xfs@oss.sgi.com>; Tue, 18 Nov 2014 18:19:58 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2D8DE8F8035
	for <xfs@oss.sgi.com>; Tue, 18 Nov 2014 16:19:55 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id v0nsteM9J527uwzP (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 18 Nov 2014 16:19:54 -0800 (PST)
Date: Tue, 18 Nov 2014 19:19:41 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: How to determine the reserved blocks in xfs filesystem ?
Message-ID: <20141119001941.GA37095@bfoster.bfoster>
References: <CAJtCNH0tgtCw0F7322b_qvbM9-uGGSsLLiPQj6jk1yyvWDQMYg@mail.gmail.com>
	<20141118133206.GA5226@bfoster.bfoster>
	<20141118223518.GR23575@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141118223518.GR23575@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Mukul Malhotra <smilemukul2005@gmail.com>, xfs@oss.sgi.com

T24gV2VkLCBOb3YgMTksIDIwMTQgYXQgMDk6MzU6MThBTSArMTEwMCwgRGF2ZSBDaGlubmVyIHdy
b3RlOgo+IE9uIFR1ZSwgTm92IDE4LCAyMDE0IGF0IDA4OjMyOjA3QU0gLTA1MDAsIEJyaWFuIEZv
c3RlciB3cm90ZToKPiA+IE9uIFR1ZSwgTm92IDE4LCAyMDE0IGF0IDA2OjA1OjU4UE0gKzA1MzAs
IE11a3VsIE1hbGhvdHJhIHdyb3RlOgo+ID4gPiDigItIZWxsbywKPiA+ID4gCj4gPiA+IERvZXMg
eGZzIGhhdmUgcmVzZXJ2ZWQgYmxvY2tzIHRvbywgbGlrZSBleHQqID8gaWYgeWVzLCBob3cgY2Fu
IHRoZXkgYmUKPiA+ID4gZGV0ZXJtaW5lZCA/4oCLCj4gPiA+IAo+ID4gCj4gPiBYRlMgcmVzZXJ2
ZXMgYmxvY2tzIGludGVybmFsbHkgc3VjaCB0aGF0IGl0IGNhbiBwZXJmb3JtIG9wZXJhdGlvbnMg
d2hlbgo+ID4gYWxsIGZyZWUgc3BhY2UgaXMgY29uc3VtZWQsIGV0Yy4gSXQgbG9va3MgbGlrZSA1
JSBpcyB0aGUgZGVmYXVsdC4KPiAKPiBOb3QgcXVpdGUuCj4gCj4gICAgICAgICAvKgo+ICAgICAg
ICAgICogV2UgZGVmYXVsdCB0byA1JSBvciA4MTkyIGZzYnMgb2Ygc3BhY2UgcmVzZXJ2ZWQsIHdo
aWNoZXZlciBpcwo+ICAgICAgICAgICogc21hbGxlci4gIFRoaXMgaXMgaW50ZW5kZWQgdG8gY292
ZXIgY29uY3VycmVudCBhbGxvY2F0aW9uCj4gICAgICAgICAgKiB0cmFuc2FjdGlvbnMgd2hlbiB3
ZSBpbml0aWFsbHkgaGl0IGVub3NwYy4gVGhlc2UgZWFjaCByZXF1aXJlIGEgNAo+ICAgICAgICAg
ICogYmxvY2sgcmVzZXJ2YXRpb24uIEhlbmNlIGJ5IGRlZmF1bHQgd2UgY292ZXIgcm91Z2hseSAy
MDAwIGNvbmN1cnJlbnQKPiAgICAgICAgICAqIGFsbG9jYXRpb24gcmVzZXJ2YXRpb25zLgo+ICAg
ICAgICAgICovCj4gCj4gU28sIGluIG1vc3QgY2FzZXMsIHRoZXJlIGFyZSAzMk1CIG9mIHJlc2Vy
dmVkIGJsb2NrcyBhdmFpbGFibGUgZm9yCj4gaW50ZXJuYWwgZW1lcmdlbmN5IHVzZS4KPiAKClll
cCwgSSBnbG9zc2VkIHJpZ2h0IG92ZXIgdGhlIGhhcmQgY2FwLi4uIHRoYW5rcy4gOykKCkJyaWFu
Cgo+ID4gSSBkb24ndCB0aGluayBpdCdzICJsaWtlIGV4dDQsIiBob3dldmVyLCB3aGljaCByZXNl
cnZlcyBibG9ja3MgZm9yIHRoZQo+ID4gcm9vdCB1c2VyLiBJIGRvbid0IGJlbGlldmUgdGhlIHJl
c2VydmVkIGJsb2NrcyBpbiBYRlMgYXJlIGFjY2Vzc2libGUgZm9yCj4gPiBmaWxlIGFsbG9jYXRp
b24gYnkgYW55IHVzZXIgdW5sZXNzIHRoZSByZXNlcnZlIHBvb2wgaXMgbW9kaWZpZWQgYXMgc3Vj
aC4KPiAKPiBNb3N0IGRlZmluaXRlbHkgbm90ICJsaWtlIGV4dDQiLiBUaGUgcmVzZXJ2ZWQgYmxv
Y2tzIGFyZSBjb25zaWRlcmVkCj4gInVzZWQgc3BhY2UiIChpLmUuIG5vdCBhdmFpbGFibGUgdG8g
YW55IHVzZXIpIGFuZCBhcmUgcmVwb3J0ZWQgYXMKPiBzdWNoIGluIHN0YXRmcygpIG91dHB1dCAo
ZS5nLiB2aWEgZGYpLgo+IAo+IENoZWVycywKPiAKPiBEYXZlLgo+IC0tIAo+IERhdmUgQ2hpbm5l
cgo+IGRhdmlkQGZyb21vcmJpdC5jb20KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9v
c3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
