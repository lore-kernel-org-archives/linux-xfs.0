Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F3E0E7F3F
	for <xfs@oss.sgi.com>; Tue, 23 Dec 2014 10:48:07 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7CAB2AC004
	for <xfs@oss.sgi.com>; Tue, 23 Dec 2014 08:48:04 -0800 (PST)
Received: from nihrelayxway6.hub.nih.gov (nihrelayxway6.hub.nih.gov
	[128.231.90.100]) by cuda.sgi.com with ESMTP id
	UBcX78FVp7a1b8do for <xfs@oss.sgi.com>;
	Tue, 23 Dec 2014 08:48:02 -0800 (PST)
MIME-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: weird quota issue
From: "Weber, Charles (NIH/NIA/IRP) [C]" <weberc@grc.nia.nih.gov>
In-Reply-To: <20141223024248.GC4521@dastard>
Date: Tue, 23 Dec 2014 11:31:58 -0500
Message-ID: <111BC0EC-AC0B-4ABC-BC78-C5BB7DD9C7F4@grc.nia.nih.gov>
References: <3BD1EE39-8C26-4C5B-94B5-492422EECEDA@mail.nih.gov>
	<20141222204857.GK24183@dastard>
	<6F43BF63-A44E-43F6-A184-9AAC10DDDFDF@grc.nia.nih.gov>
	<20141222223540.GS15665@dastard>
	<2F3F57BB-59EA-4FF9-9254-6A598DE7AC46@grc.nia.nih.gov>
	<20141223003237.GA4521@dastard>
	<258BE536A650F646814BA46CC06568980F6A8AD7@msgb01.nih.gov>
	<20141223024248.GC4521@dastard>
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

aGVyZSB5b3UgZ28KCm5vIHF1b3RhIG1vdW50CnZlcnkgcXVpY2sgdG8gbW91bnQKZG1lc2cgClhG
UyAoZG0tNyk6IGRlbGF5bG9nIGlzIHRoZSBkZWZhdWx0IG5vdywgb3B0aW9uIGlzIGRlcHJlY2F0
ZWQuClhGUyAoZG0tNyk6IE1vdW50aW5nIEZpbGVzeXN0ZW0KCgp1cXVvdGEgbW91bnQKaGFuZ3Mg
Zm9yIGxvbmcgdGltZSBhZnRlciBtb3VudCBjb21tYW5kClhGUyAoZG0tNyk6IE1vdW50aW5nIEZp
bGVzeXN0ZW0KWEZTIChkbS03KTogRW5kaW5nIGNsZWFuIG1vdW50ClhGUyAoZG0tNyk6IFF1b3Rh
Y2hlY2sgbmVlZGVkOiBQbGVhc2Ugd2FpdC4KWEZTIChkbS03KTogUXVvdGFjaGVjazogRG9uZS4K
CnVxdW90YS9wcmpxdW90YSBtb3VudApxdWljayBtb3VudCB0aW1lClhGUyAoZG0tNyk6IE1vdW50
aW5nIEZpbGVzeXN0ZW0KWEZTIChkbS03KTogRW5kaW5nIGNsZWFuIG1vdW50ClhGUyAoZG0tNyk6
IEZhaWxlZCB0byBpbml0aWFsaXplIGRpc2sgcXVvdGFzLgoKcHJqcXVvdGEgbW50ClhGUyAoZG0t
Nyk6IEZhaWxlZCB0byBpbml0aWFsaXplIGRpc2sgcXVvdGFzLgoKSeKAmWxsIGxvb2sgaW50byB0
aGUgdHJhY2VjbWQgc3R1ZmYgYWZ0ZXIgbHVuY2guCkNodWNrCj4gT24gRGVjIDIyLCAyMDE0LCBh
dCA5OjQyIFBNLCBEYXZlIENoaW5uZXIgPGRhdmlkQGZyb21vcmJpdC5jb20+IHdyb3RlOgo+IAo+
IE9uIFR1ZSwgRGVjIDIzLCAyMDE0IGF0IDAyOjEyOjE1QU0gKzAwMDAsIFdlYmVyLCBDaGFybGVz
IChOSUgvTklBL0lSUCkgW0VdIHdyb3RlOgo+PiBoZXJlIHlvdSBnbwo+PiAKPj4gIyB4ZnNfZGIg
LWMgImlub2RlIDEzMSIgLWMgcCAvZGV2L2RtLTcKPiAKPiBOb3RoaW5nIG9idmlvdXNseSB3cm9u
ZyB0aGVyZSwgc28gdGhlcmUncyBubyBjbGVhciBpbmRpY2F0aW9uIG9mIHdoeQo+IHRoZSBxdW90
YSBpbml0aWFsaXNhdGlvbiBmYWlsZWQuIElmIGhhc24ndCBnb3QgdG8gcXVvdGFjaGVjaywKPiBi
ZWNhdXNlIHRoZWF0IHRocm93cyB2ZXJib3MgZXJyb3JzIHdoZW4gaXQgZmFpbHMsIHNvIGl0J3Mg
c29tZXRoaW5nCj4gZ29pbmcgd3JvbmcgZHVyaW5nIGluaXRpYWxpc2F0aW9uLgo+IAo+IEp1c3Qg
dG8gbmFycm93IGl0IGRvd24sIGlmIHlvdSBtb3VudCB3aXRoIGp1c3QgdXF1b3RhIGRvZXMgdGhl
Cj4gbW91bnQgc3VjY2VlZD8gUGxlYXNlIHBvc3QgdGhlIGRtZXNnIG91dHB1dCB3aGF0ZXZlciB0
aGUgb3V0Y29tZS4KPiBEb2VzIG1vdW50aW5nIHdpdGgganVzdCBwcXVvdGEgc3VjY2VlZD8gSWYg
bmVpdGhlciBzdWNjZWVkLCB3aGF0Cj4gaGFwcGVucyBpZiB5b3UgbW91bnQgd2l0aCBubyBxdW90
YXMsIHRoZW4gdW5tb3VudCBhbmQgbW91bnQgYWdhaW4KPiB3aXRoIHF1b3RhcyBlbmFibGVkPwo+
IAo+IElmIGl0IHN0aWxsIGRvZXNuJ3Qgd29yaywgSSdtIGdvaW5nIHRvIG5lZWQgYW4gZXZlbnQg
dHJhY2Ugb2YgYQo+IGZhaWxlZCBtb3VudCAoaW5zdGFsbCB0cmFjZS1jbWQgYW5kIHJ1bjoKPiAK
PiAjIHRyYWNlLWNtZCByZWNvcmQgLWUgeGZzXCogbW91bnQgLW8gdXF1b3RhLHBxdW90YSAvZGV2
L2RtLTcgL21udC9wdAo+IDxzb21lIG91dHB1dD4KPiAjIHRyYWNlLWNtZCByZXBvcnQgPiB0cmFj
ZS5vdXQKPiAKPiBBbmQgdGhlbiBjb21wcmVzcyB0aGUgdHJhY2Uub3V0IGZpbGUgYW5kIGF0dGFj
aCBpdC4KPiAKPiBDaGVlcnMsCj4gCj4gRGF2ZS4KPiAtLSAKPiBEYXZlIENoaW5uZXIKPiBkYXZp
ZEBmcm9tb3JiaXQuY29tCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5j
b20vbWFpbG1hbi9saXN0aW5mby94ZnMK
