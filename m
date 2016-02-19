Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 72B047CA5
	for <xfs@oss.sgi.com>; Fri, 19 Feb 2016 10:29:29 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 641518F8052
	for <xfs@oss.sgi.com>; Fri, 19 Feb 2016 08:29:23 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id D3uA7vYMo9Wx1WkF (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 19 Feb 2016 08:29:15 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 111FB2DC36C
	for <xfs@oss.sgi.com>; Fri, 19 Feb 2016 16:29:15 +0000 (UTC)
Date: Fri, 19 Feb 2016 11:29:13 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: What is the meaning of XLOG_MIN_RECORD_BSIZE? (Missing a check?)
Message-ID: <20160219162913.GC27263@bfoster.bfoster>
References: <CACj3i70osVyt=QTTqoqKGttwNC8w7Gtq479-Nk-icQrDn83hCA@mail.gmail.com>
	<20160219154347.GA27263@bfoster.bfoster>
	<CACj3i72wijiApA0gD0mRrMvPomDC5pEAr1Mvv6e3vi4HU1S_sw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CACj3i72wijiApA0gD0mRrMvPomDC5pEAr1Mvv6e3vi4HU1S_sw@mail.gmail.com>
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
To: Jan Tulak <jtulak@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

T24gRnJpLCBGZWIgMTksIDIwMTYgYXQgMDU6MTY6MjhQTSArMDEwMCwgSmFuIFR1bGFrIHdyb3Rl
Ogo+IE9uIEZyaSwgRmViIDE5LCAyMDE2IGF0IDQ6NDMgUE0sIEJyaWFuIEZvc3RlciA8YmZvc3Rl
ckByZWRoYXQuY29tPiB3cm90ZToKPiAKPiA+IE9uIEZyaSwgRmViIDE5LCAyMDE2IGF0IDAyOjM0
OjUyUE0gKzAxMDAsIEphbiBUdWxhayB3cm90ZToKPiA+ID4gSGkgZ3V5cywKPiA+ID4KPiA+ID4g
d2hhdCBpcyB0aGUgbWVhbmluZyBvZiBYTE9HX01JTl9SRUNPUkRfQlNJWkUgaW4gbGlieGZzL3hm
c19sb2dfZm9ybWF0Lmg/Cj4gPiA+IEl0IGlzIG5vdCB1c2VkIGFueXdoZXJlLiBJIHRob3VnaHQg
aXQgbWlnaHQgYmUgcmVsYXRlZCB0byAtbCBzdS9zdW5pdAo+ID4gPiBvcHRpb24sIGJ1dCBzZWVp
bmcgdGVzdHMgd2l0aCAtbCBzdT00MDk2ICh0aGUgbWFjcm8gaXMgc2V0IHRvIDE2ayksIGl0Cj4g
PiA+IGxvb2tzIG1vcmUgbGlrZSBhIGZvcmdvdHRlbiB2YWx1ZS4KPiA+ID4KPiA+Cj4gPiBJdCdz
IHRoZSBtaW5pbXVtIGxvZyBidWZmZXIgc2l6ZSBhbGxvd2VkIGluIHRoZSBrZXJuZWwuIEl0J3Mg
dXNlZCBpbgo+ID4geGZzX3N1cGVyLmMgYXQgbW91bnQgdGltZSB0byB2YWxpZGF0ZSB0aGUgbG9n
YnNpemUgb3B0aW9uOgo+ID4KPiA+ICAgICAgICAgaWYgKG1wLT5tX2xvZ2JzaXplICE9IC0xICYm
Cj4gPiAgICAgICAgICAgICBtcC0+bV9sb2dic2l6ZSAhPSAgMCAmJgo+ID4gICAgICAgICAgICAg
KG1wLT5tX2xvZ2JzaXplIDwgWExPR19NSU5fUkVDT1JEX0JTSVpFIHx8Cj4gPiAgICAgICAgICAg
ICAgbXAtPm1fbG9nYnNpemUgPiBYTE9HX01BWF9SRUNPUkRfQlNJWkUgfHwKPiA+ICAgICAgICAg
ICAgICAhaXNfcG93ZXJfb2ZfMihtcC0+bV9sb2dic2l6ZSkpKSB7Cj4gPiAgICAgICAgICAgICAg
ICAgeGZzX3dhcm4obXAsCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAiaW52YWxpZCBsb2di
dWZzaXplOiAlZCBbbm90IDE2aywzMmssNjRrLDEyOGsgb3IKPiA+IDI1NmtdIiwKPiA+ICAgICAg
ICAgICAgICAgICAgICAgICAgIG1wLT5tX2xvZ2JzaXplKTsKPiA+ICAgICAgICAgICAgICAgICBy
ZXR1cm4gLUVJTlZBTDsKPiA+ICAgICAgICAgfQo+ID4KPiA+IEkgc3VzcGVjdCBpdCdzIG5vdCBy
ZWxldmFudCBpbiB1c2Vyc3BhY2UuCj4gPgo+IAo+IFRoaXMgaXMgb2ssIHRoZW4uIFRoYW5rIHlv
dSBmb3IgcG9pbnRpbmcgbWUgdG8ga2VybmVsIHNwYWNlLCBJIGRpZG4ndAo+IHJlYWxpc2VkIEkg
c2hvdWxkIGNoZWNrIGl0IHRoZXJlIHRvby4gOi0pCj4g4oCLCj4gCj4gCj4gPgo+ID4gPiBUaGVy
ZSBpcyBubyBjaGVjayBmb3IgYSBtaW5pbWFsIHZhbHVlLCBzbyBJIGNhbiBkbyAtbCBzdT0xIChv
ciBzdT0wKS4gQXJlCj4gPiA+IHRoZXJlIHNvbWUgY2F2ZWF04oCLcyAob3RoZXIgdGhhbiBwZXJm
b3JtYW5jZSkgd2l0aCBzdWNoIGEgc21hbGwgdmFsdWU/IENhbgo+ID4gPiBpdCBiZSB0aGF0IHdl
IGFyZSBtaXNzaW5nIGEgY2hlY2s/IEJlY2F1c2UKPiA+ID4gWExPR19CSUdfUkVDT1JEX0JTSVpF
Cj4gPiA+IOKAiyBhbmQgWExPR19NQVhfUkVDT1JEX0JTSVpFIGFyZSB1c2VkIGFuZCB0aGUgdXBw
ZXIgYm91bmQgaXMgbGltaXRlZC7igIsuLgo+ID4gPgo+ID4KPiA+IE9uIGEgcXVpY2sgdGVzdCwg
aXQgbG9va3MgbGlrZSBta2ZzIGp1c3QgaWdub3JlcyBjZXJ0YWluIGxvZyBzdHJpcGUgdW5pdAo+
ID4gdmFsdWVzIHRoYXQgYXJlbid0IGJsb2NrIGFsaWduZWQuIEknZCBwcm9iYWJseSBleHBlY3Qg
dGhpcyB0byBiZWhhdmUKPiA+IHNpbWlsYXIgdG8gdGhlICctZCBzdScgb3B0aW9uIGFuZCBjb21w
bGFpbiBhYm91dCBpbnZhbGlkIGlucHV0Li4/Cj4gPgo+IAo+IOKAi1NvdW5kcyBsb2dpY2FsIGFu
ZCBsaWtlIHdoYXQgSSBleHBlY3RlZCBhbmQgZGlkbid0IGZvdW5kLiBJIHdpbGwgc2VuZCBhCj4g
cGF0Y2ggYWRkaW5nIHRoaXMgY2hlY2suLi4gdGhlIG9ubHkgcXVlc3Rpb24gaXMsIHdoYXQgc2hv
dWxkIGJlIHRoZSBtaW5pbWFsCj4gdmFsdWU/IFNob3VsZCBJIGNoZWNrIGl0IGFnYWluc3QgYmxv
Y2sgc2l6ZSBhbmQgZm9yYmlkIHNtYWxsZXIgc2l6ZXM/Cj4gQWxpZ25pbmcgYSBzdHJpcGUgdW5p
dCB3aXRoIGxlbmd0aCAxMDI0IG9uIDQwOTYgYmxvY2tzIGRvZXNuJ3QgbG9va3MgbGlrZSBhCj4g
bmljZSB0aGluZy4gOi0pCj4gKEFuZCBvbiBhIHF1aWNrIGNoZWNrLCBpdCBzZWVtcyB0aGF0IC1k
IHN1IGlzIGRvaW5nIGp1c3QgdGhhdC4pCj4gCgpUaGUgbWFuIHBhZ2Ugc2F5cyBpdCBtdXN0IGJl
IGEgbXVsdGlwbGUgb2YgdGhlIGZzYiBzaXplLiBJbmRlZWQsICctZCBzdScKY29tcGxhaW5zIGFi
b3V0IGFueXRoaW5nIHRoYXQgaXMgbGVzcyB0aGFuIDEgRlNCLCBzbyBJIHdvdWxkIGp1c3QgZ28K
d2l0aCB0aGF0LiA6KQoKQnJpYW4KCj4gVGhhbmtzLAo+IEphbgo+IAo+IC0tIAo+IEphbiBUdWxh
awo+IGp0dWxha0ByZWRoYXQuY29tIC8gamFuQHR1bGFrLm1lCgo+IF9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCj4geGZzIG1haWxpbmcgbGlzdAo+IHhmc0Bv
c3Muc2dpLmNvbQo+IGh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwoKX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcg
bGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8v
eGZzCg==
