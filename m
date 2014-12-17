Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CD55E7F3F
	for <xfs@oss.sgi.com>; Wed, 17 Dec 2014 05:22:05 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AD1538F809C
	for <xfs@oss.sgi.com>; Wed, 17 Dec 2014 03:22:02 -0800 (PST)
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5]) by
	cuda.sgi.com with ESMTP id a4oK2BfYVQDfVeeJ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 17 Dec 2014 03:21:58 -0800 (PST)
Date: Wed, 17 Dec 2014 12:21:59 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: easily reproducible filesystem crash on rebuilding array
Message-ID: <20141217122159.284411fa@harpe.intellique.com>
In-Reply-To: <20141216195815.GB15665@dastard>
References: <20141211123936.1f3d713d@harpe.intellique.com>
	<20141215130715.4dfaaa8e@harpe.intellique.com>
	<20141215132500.13210fdb@harpe.intellique.com>
	<20141215201036.GQ24183@dastard>
	<20141216123405.111c7ac0@harpe.intellique.com>
	<20141216195815.GB15665@dastard>
MIME-Version: 1.0
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
Cc: xfs@oss.sgi.com

TGUgV2VkLCAxNyBEZWMgMjAxNCAwNjo1ODoxNSArMTEwMApEYXZlIENoaW5uZXIgPGRhdmlkQGZy
b21vcmJpdC5jb20+IMOpY3JpdmFpdDoKCj4gT24gVHVlLCBEZWMgMTYsIDIwMTQgYXQgMTI6MzQ6
MDVQTSArMDEwMCwgRW1tYW51ZWwgRmxvcmFjIHdyb3RlOgo+ID4gVGhlIFJBSUQgaGFyZHdhcmUg
aXMgYW4gYWRhcHRlYyA3MTY4NSBydW5uaW5nIHRoZSBsYXRlc3QgZmlybXdhcmUKPiA+ICggMzIw
MzMgKS4gVGhpcyBpcyBhIDE2IGRyaXZlcyBSQUlELTYgYXJyYXkgb2YgNCBUQiBIR1NUIGRyaXZl
cy4gVGhlCj4gPiBwcm9ibGVtIG9jY3VycyByZXBlYXRseSB3aXRoIGFueSBjb21iaW5hdGlvbiBv
ZiA3eHg1IGNvbnRyb2xsZXJzCj4gPiBhbmQgMyBvciA0IFRCIEhHU1QgZHJpdmVzIGluIFJBSUQt
NiBvZiB2YXJpb3VzIHR5cGVzLCB3aXRoIFhGUyBvcgo+ID4gSkZTIChpdCBuZXZlciBvY2N1cnMg
d2l0aCBlaXRoZXIgZXh0NCBvciByZWlzZXJmcykuCj4gCj4gRG8geW91IGhhdmUgc3lzdGVtcyB3
aXRoIGFueSBvdGhlciB0eXBlIG9mIDMvNFRCIGRyaXZlcyBpbiB0aGVtPwoKTm8sIG9ubHkgSEdT
VCBkcml2ZXMuCiAKPiA+IEFzIEkgbWVudGlvbmVkLCB3aGVuIHRoZSBkaXNrIGRyaXZlcyBjYWNo
ZSBpcyBvbiB0aGUgY29ycnVwdGlvbiBpcwo+ID4gc2VyaW91cy4gV2l0aCBkaXNrIGNhY2hlIG9m
ZiwgdGhlIGNvcnJ1cHRpb24gaXMgbWluaW1hbCwgaG93ZXZlciB0aGUKPiA+IGZpbGVzeXN0ZW0g
c2h1dHMgZG93bi4KPiAKPiBUaGF0IHJlYWxseSBzb3VuZHMgbGlrZSBhIGhhcmR3YXJlIHByb2Js
ZW0gLSBtYXliZSB3aXRoIHRoZSBkaXNrCj4gZHJpdmVzIHRoZW1zZWx2ZXMsIG5vdCBuZWNlc3Nh
cmlseSB0aGUgY29udHJvbGxlci4KCkFjdHVhbGx5IHRoZSBwcm9ibGVtIG9jY3VycyB3aXRob3V0
IGFueSBlcnJvciBpbiB0aGUgY29udHJvbGxlciBsb2csIG5vCklPIGVycm9yLCBubyBkaXNrIHRp
bWUgb3V0LCBubyBiYWQgYmxvY2ssIG5vdGhpbmcuIFNvIGZhciBJIHdhcyBwcmV0dHkKY29uZmlk
ZW50IGFib3V0IHRoZSBBZGFwdGVjIGZpcm13YXJlIGJlaW5nIHRoZSBjdWxwcml0LCBJJ20gbm90
IHNvIHN1cmUKbm93LgoKCj4gPiA+IEknZCBzdGFydCB3aXRoIHVwZ3JhZGluZyB0aGUgZmlybXdh
cmUgb24geW91ciBSQUlEIGNvbnRyb2xsZXIgYW5kCj4gPiA+IHR1cm5pbmcgdGhlIFhGUyBlcnJv
ciBsZXZlbCB1cCB0byAxMS4uLi4KPiA+IAo+ID4gVGhlIGZpcm13YXJlIGlzIHRoZSBsYXRlc3Qg
YXZhaWxhYmxlLiBIb3cgZG8gSSB0dXJuIGxvZ2dpbmcgdG8gMTEKPiA+IHBsZWFzZSA/Cj4gCj4g
IyBlY2hvIDExID4gL3Byb2Mvc3lzL2ZzL3hmcy9lcnJvcl9sZXZlbAo+IAoKVGhhbmtzIGRvbmUs
IHdoaWxlIHJ1bm5pbmcgYWdhaW4gYnV0ICp3aXRob3V0IHVzaW5nIGx2bSogdGhpcyB0aW1lLiBJ
J20KY2hhbmdpbmcgb25lIHBhcmFtZXRlciBhdCBhIHRpbWUuLi4KCi0tIAotLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0KRW1tYW51ZWwgRmxvcmFjICAgICB8ICAgRGlyZWN0aW9uIHRlY2huaXF1ZQogICAgICAgICAg
ICAgICAgICAgIHwgICBJbnRlbGxpcXVlCiAgICAgICAgICAgICAgICAgICAgfAk8ZWZsb3JhY0Bp
bnRlbGxpcXVlLmNvbT4KICAgICAgICAgICAgICAgICAgICB8ICAgKzMzIDEgNzggOTQgODQgMDIK
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5j
b20vbWFpbG1hbi9saXN0aW5mby94ZnMK
