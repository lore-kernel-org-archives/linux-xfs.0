Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7176E7CB4
	for <xfs@oss.sgi.com>; Sun, 21 Feb 2016 17:38:48 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 412288F80B6
	for <xfs@oss.sgi.com>; Sun, 21 Feb 2016 15:38:42 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	nH7OPCuBzbgN7tHb for <xfs@oss.sgi.com>;
	Sun, 21 Feb 2016 15:18:29 -0800 (PST)
Date: Mon, 22 Feb 2016 10:18:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: What is the meaning of XLOG_MIN_RECORD_BSIZE? (Missing a check?)
Message-ID: <20160221231815.GD25832@dastard>
References: <CACj3i70osVyt=QTTqoqKGttwNC8w7Gtq479-Nk-icQrDn83hCA@mail.gmail.com>
	<20160219154347.GA27263@bfoster.bfoster>
	<CACj3i72wijiApA0gD0mRrMvPomDC5pEAr1Mvv6e3vi4HU1S_sw@mail.gmail.com>
	<20160219162913.GC27263@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160219162913.GC27263@bfoster.bfoster>
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
Cc: xfs-oss <xfs@oss.sgi.com>, Jan Tulak <jtulak@redhat.com>

T24gRnJpLCBGZWIgMTksIDIwMTYgYXQgMTE6Mjk6MTNBTSAtMDUwMCwgQnJpYW4gRm9zdGVyIHdy
b3RlOgo+IE9uIEZyaSwgRmViIDE5LCAyMDE2IGF0IDA1OjE2OjI4UE0gKzAxMDAsIEphbiBUdWxh
ayB3cm90ZToKPiA+IE9uIEZyaSwgRmViIDE5LCAyMDE2IGF0IDQ6NDMgUE0sIEJyaWFuIEZvc3Rl
ciA8YmZvc3RlckByZWRoYXQuY29tPiB3cm90ZToKPiA+ID4gT24gRnJpLCBGZWIgMTksIDIwMTYg
YXQgMDI6MzQ6NTJQTSArMDEwMCwgSmFuIFR1bGFrIHdyb3RlOgo+ID4gPiA+IFRoZXJlIGlzIG5v
IGNoZWNrIGZvciBhIG1pbmltYWwgdmFsdWUsIHNvIEkgY2FuIGRvIC1sIHN1PTEgKG9yIHN1PTAp
LiBBcmUKPiA+ID4gPiB0aGVyZSBzb21lIGNhdmVhdOKAi3MgKG90aGVyIHRoYW4gcGVyZm9ybWFu
Y2UpIHdpdGggc3VjaCBhIHNtYWxsIHZhbHVlPyBDYW4KPiA+ID4gPiBpdCBiZSB0aGF0IHdlIGFy
ZSBtaXNzaW5nIGEgY2hlY2s/IEJlY2F1c2UKPiA+ID4gPiBYTE9HX0JJR19SRUNPUkRfQlNJWkUK
PiA+ID4gPiDigIsgYW5kIFhMT0dfTUFYX1JFQ09SRF9CU0laRSBhcmUgdXNlZCBhbmQgdGhlIHVw
cGVyIGJvdW5kIGlzIGxpbWl0ZWQu4oCLLi4KPiA+ID4gPgo+ID4gPgo+ID4gPiBPbiBhIHF1aWNr
IHRlc3QsIGl0IGxvb2tzIGxpa2UgbWtmcyBqdXN0IGlnbm9yZXMgY2VydGFpbiBsb2cgc3RyaXBl
IHVuaXQKPiA+ID4gdmFsdWVzIHRoYXQgYXJlbid0IGJsb2NrIGFsaWduZWQuIEknZCBwcm9iYWJs
eSBleHBlY3QgdGhpcyB0byBiZWhhdmUKPiA+ID4gc2ltaWxhciB0byB0aGUgJy1kIHN1JyBvcHRp
b24gYW5kIGNvbXBsYWluIGFib3V0IGludmFsaWQgaW5wdXQuLj8KPiA+IAo+ID4g4oCLU291bmRz
IGxvZ2ljYWwgYW5kIGxpa2Ugd2hhdCBJIGV4cGVjdGVkIGFuZCBkaWRuJ3QgZm91bmQuIEkgd2ls
bCBzZW5kIGEKPiA+IHBhdGNoIGFkZGluZyB0aGlzIGNoZWNrLi4uIHRoZSBvbmx5IHF1ZXN0aW9u
IGlzLCB3aGF0IHNob3VsZCBiZSB0aGUgbWluaW1hbAo+ID4gdmFsdWU/IFNob3VsZCBJIGNoZWNr
IGl0IGFnYWluc3QgYmxvY2sgc2l6ZSBhbmQgZm9yYmlkIHNtYWxsZXIgc2l6ZXM/Cj4gPiBBbGln
bmluZyBhIHN0cmlwZSB1bml0IHdpdGggbGVuZ3RoIDEwMjQgb24gNDA5NiBibG9ja3MgZG9lc24n
dCBsb29rcyBsaWtlIGEKPiA+IG5pY2UgdGhpbmcuIDotKQo+ID4gKEFuZCBvbiBhIHF1aWNrIGNo
ZWNrLCBpdCBzZWVtcyB0aGF0IC1kIHN1IGlzIGRvaW5nIGp1c3QgdGhhdC4pCj4gCj4gVGhlIG1h
biBwYWdlIHNheXMgaXQgbXVzdCBiZSBhIG11bHRpcGxlIG9mIHRoZSBmc2Igc2l6ZS4gSW5kZWVk
LCAnLWQgc3UnCj4gY29tcGxhaW5zIGFib3V0IGFueXRoaW5nIHRoYXQgaXMgbGVzcyB0aGFuIDEg
RlNCLCBzbyBJIHdvdWxkIGp1c3QgZ28KPiB3aXRoIHRoYXQuIDopCgpLZWVwIGluIG1pbmQgdGhh
dCBhIHZhbHVlIG9mIDAgaW4gdGhlIHN1cGVyYmxvY2sgaXMgY29tcGxldGVseQphY2NlcHRpYmxl
LCBpbiB3aGljaCBjYXNlIHRoZSBrZXJuZWwgdHJlYXRzIHRoZSBsb2cgc3RyaXBlIHVuaXQgYXMK
YmVpbmcgYSBzaW5nbGUgc2VjdG9yIChpLmUuIHNhbWUgYXMgYSB2MSBsb2cpLiBTZWUsIGZvciBl
eGFtcGxlLAp4bG9nX3N5bmMoKSB3aGVyZSBpdCB3b3JrcyBvdXQgdGhlIHBhZGRpbmcgdG8gdXNl
IGZvciB0aGUgbG9nIGJ1ZmZlcgp3cml0ZS4KCkNoZWVycywKCkRhdmUuCi0tIApEYXZlIENoaW5u
ZXIKZGF2aWRAZnJvbW9yYml0LmNvbQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29z
cy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
