Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4536E29DF8
	for <xfs@oss.sgi.com>; Tue,  4 Jun 2013 17:40:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C430CAC001
	for <xfs@oss.sgi.com>; Tue,  4 Jun 2013 15:40:23 -0700 (PDT)
Received: from e7.ny.us.ibm.com (e7.ny.us.ibm.com [32.97.182.137]) by
	cuda.sgi.com with ESMTP id JAgLGDztLoG1i6h0 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Jun 2013 15:40:22 -0700 (PDT)
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Tue, 4 Jun 2013 18:40:21 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 4DDC36E8039
	for <xfs@oss.sgi.com>; Tue,  4 Jun 2013 18:40:14 -0400 (EDT)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r54MeHbZ263180 for <xfs@oss.sgi.com>; Tue, 4 Jun 2013 18:40:17 -0400
Received: from d01av05.pok.ibm.com (loopback [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	r54MeHSf003250 for <xfs@oss.sgi.com>; Tue, 4 Jun 2013 18:40:17 -0400
Subject: Re: Debunking myths about metadata CRC overhead
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20130604220849.GK29466@dastard>
References: <20130603074452.GZ29466@dastard>
	<20130603111011.461d10b5@galadriel.home>	<20130604025307.GB29466@dastard>
	<1370371109.3898.10.camel@chandra-dt.ibm.com>
	<20130604220849.GK29466@dastard>
Date: Tue, 04 Jun 2013 17:40:16 -0500
Message-ID: <1370385616.22504.7.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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

T24gV2VkLCAyMDEzLTA2LTA1IGF0IDA4OjA4ICsxMDAwLCBEYXZlIENoaW5uZXIgd3JvdGU6Cj4g
T24gVHVlLCBKdW4gMDQsIDIwMTMgYXQgMDE6Mzg6MjlQTSAtMDUwMCwgQ2hhbmRyYSBTZWV0aGFy
YW1hbiB3cm90ZToKPiA+IE9uIFR1ZSwgMjAxMy0wNi0wNCBhdCAxMjo1MyArMTAwMCwgRGF2ZSBD
aGlubmVyIHdyb3RlOgo+ID4gPiBPbiBNb24sIEp1biAwMywgMjAxMyBhdCAxMToxMDoxMUFNICsw
MjAwLCBFbW1hbnVlbCBGbG9yYWMgd3JvdGU6Cj4gPiA+ID4gTGUgTW9uLCAzIEp1biAyMDEzIDE3
OjQ0OjUyICsxMDAwIHZvdXMgw6ljcml2aWV6Ogo+ID4gPiA+IAo+ID4gPiA+ID4gVGhlcmUgaGFz
IGJlZW4gc29tZSBhc3NlcnRpb25zIG1hZGUgcmVjZW50bHkgdGhhdCBtZXRhZGF0YSBDUkNzIGhh
dmUKPiA+ID4gPiA+IHRvbyBtdWNoIG92ZXJoZWFkIHRvIGFsd2F5cyBiZSBlbmFibGVkLiAgU28g
SSdsbCBydW4gc29tZSBxdWljawo+ID4gPiA+ID4gYmVuY2htYXJrcyB0byBkZW1vbnN0cmF0ZSB0
aGUgInRvbyBtdWNoIG92ZXJoZWFkIiBhc3NlcnRpb25zIGFyZQo+ID4gPiA+ID4gY29tcGxldGVs
eSB1bmZvdW5kZWQuCj4gPiA+ID4gCj4gPiA+ID4gSnVzdCBhIHF1aWNrIHF1ZXN0aW9uOiB3aGF0
IGlzIHRoZSBtaW5pbWFsIGtlcm5lbCB2ZXJzaW9uIGFuZCB4ZnNwcm9ncwo+ID4gPiA+IHZlcnNp
b24gbmVlZGVkIHRvIHJ1biB4ZnMgd2l0aCBtZXRhZGF0YSBDUkM/IEknZCBoYXBwaWx5IHRlc3Qg
aXQgb24KPiA+ID4gPiByZWFsIGhhcmR3YXJlLCBJIGhhdmUgYSBjb3VwbGUgb2Ygc3RvcmFnZSBz
ZXJ2ZXJzIGluIHRlc3QgaW4gdGhlIDQwIHRvCj4gPiA+ID4gMTA4IFRCIHJhbmdlLgo+ID4gPiAK
PiA+ID4gSWYgdGhlIG1haW50YWluZXJzIG1lcmdlIGFsbCB0aGUgcGF0Y2hlcyBJIHNlbmQgZm9y
IHRoZSAzLjEwLXJjCj4gPiA+IHNlcmllcywgdGhlbiB0aGUgMy4xMCByZWxlYXNlIHNob3VsZCBi
ZSBzdGFibGUgZW5vdWdoIHRvIHVzZSBmb3IKPiA+ID4gdGVzdGluZyB3aXRoIGRhdGEgeW91IGRv
bid0IGNhcmUgaWYgeW91IGxvc2UuCj4gPiA+IAo+ID4gPiBBcyBmb3IgdGhlIHVzZXJzcGFjZSBj
b2RlIC0gdGhhdCBpcyBzdGlsbCBqdXN0IGEgcGF0Y2hzZXQuIEkgaGF2ZW4ndAo+ID4gPiBoYWQg
YW55IGZlZWRiYWNrIGZyb20gdGhlIG1haW50YWluZXJzIGFib3V0IGl0IGluIHRoZSBwYXN0IG1v
bnRoLCBzbwo+ID4gPiBJJ3ZlIGdvdCBubyBpZGVhIHdoYXQgdGhleSBhcmUgZG9pbmcgd2l0aCBp
dC4gSSdsbCBwb3N0IG91dCBhIG5ldwo+ID4gPiB2ZXJzaW9uIGluIHRoZSBuZXh0IGNvdXBsZSBv
ZiBkYXlzIC0gaXQncyA1MC1vZGQgcGF0Y2hlcyBieSBub3csIHNvCj4gPiA+IGl0J2QgYmUgbmlj
ZSB0byBoYXZlIGl0IGluIHRoZSB4ZnNwcm9ncyBnaXQgdHJlZSBzbyBwZW9wbGUgY291bGQKPiA+
ID4ganVzdCBwdWxsIGl0IGFuZCBidWlsZCBpdCBmb3IgdGVzdGluZyBwdXJwb3NlcyBieSB0aGUg
dGltZSB0aGF0IDMuMTAKPiA+ID4gcmVsZWFzZXMuLi4uCj4gPiAKPiA+IERhdmUsCj4gPiAKPiA+
IEkgd2FzIG9mIHRoZSBpbXByZXNzaW9uIHRoYXQgdGhlIHVzZXIgc3BhY2UgY2hhbmdlcyB3aWxs
IGJlIHJlbGVhc2VkCj4gPiBzb21ldGltZSBsYXRlciAoaS5lIHdoZW4gQ1JDIGNvbWVzIG91dCBv
ZiBleHBlcmltZW50YWwpLiBJZiB3ZSBtYWtlIHRoZQo+ID4gdXNlciBzcGFjZSBjaGFuZ2VzIHRv
IGNyZWF0ZSBWNSBmaWxlc3lzdGVtIG5vdywgaXQgd2lsbCBiZSBhbiBhbm5veWFuY2UKPiA+IGZv
ciBwZW9wbGUgdGhhdCBjcmVhdGVkIFY1IHN1cGVyIGJsb2NrcyB3aXRob3V0IG15IGNoYW5nZXMg
KGdldHRpbmcgcmlkCj4gPiBvZiBPUVVPVEEuKiBmbGFncykuIAo+IAo+IFBlb3BsZSBzdGlsbCBu
ZWVkIGFjY2VzcyB0byB0aGUgY29kZSB0byB0ZXN0IGl0LiBJJ20gbm90IHRhbGtpbmcKPiBhYm91
dCBhbiBvZmZpY2lhbCByZWxlYXNlIGhlcmUgYXQgYWxsLCBqdXN0IGdldHRpbmcgaXQgY29tbWl0
dGVkIHRvCj4gdGhlIGdpdCB0cmVlIHRvIG1ha2UgaXQgZWFzeSBmb3IgcGVvcGxlIHRvIGdldCB0
aGUgY29kZSBhbmQgZm9yCj4gZGV2ZWxvcGVycyB0byBidWlsZCBvbiB0b3Agb2YgaXQgYW5kIGZp
eCBidWdzLgo+IAoKT2gsIEkgc2VlLiBJdCBpcyBjbGVhciBub3cuCgpBbHNvLCBpcyB0aGVyZSBh
IGdpdCB0cmVlIHdoZXJlIEkgY2FuIHB1bGwgeW91ciB4ZnNwcm9ncyBjaGFuZ2VzIGZyb20gPwpJ
IHRyaWVkIHRvIGFwcGx5IHhmc3Byb2dzLWtlcm4tc3luYy1wYXRjaHNldC12Mi50YXIuZ3ogb24g
dG9wIG9mCnhmc3Byb2dzIGdpdCB0cmVlLCBpdCBzZWVtcyB0byBoYXZlIHNvbWUgcHJvYmxlbXMu
CgpPciBpcyB0aGVyZSBhIGxhdGVyIHZlcnNpb24gPwoKPiA+IEJUVywgSSBhbSB3YWl0aW5nIGZv
ciB5b3VyIHJlc3BvbnNlIHRvIGRvIGEgZmluYWwgcmUtcG9zdCBvbiB0aGUga2VybmVsCj4gPiBj
aGFuZ2VzLCBhZnRlciB3aGljaCBJIHdpbGwgcG9zdCBteSB1c2VyIHNwYWNlIGNoYW5nZXMuCj4g
Cj4gSSBtdXN0IGhhdmUgbWlzc2VkIHlvdXIgcXVlc3Rpb24sIEknbGwgZ28gYmFjayBhbmQgaGF2
ZSBhIGxvb2sgZm9yCj4gaXQuCj4gCgpUaGFua3MuCj4gQ2hlZXJzLAo+IAo+IERhdmUuCgoKX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcg
bGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8v
eGZzCg==
