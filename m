Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0FDEE7CA0
	for <xfs@oss.sgi.com>; Thu, 12 May 2016 03:34:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D46028F8049
	for <xfs@oss.sgi.com>; Thu, 12 May 2016 01:34:41 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id vgQUvHvjIbwhSy3M (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 12 May 2016 01:34:40 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 0A92978222
	for <xfs@oss.sgi.com>; Thu, 12 May 2016 08:34:40 +0000 (UTC)
Received: from redhat.com (unused [10.10.50.52] (may be forged))
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u4C8Ya8W020857
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>; Thu, 12 May 2016 04:34:39 -0400
Date: Thu, 12 May 2016 10:34:36 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: remove unused variable warning in
	xfs_finish_page_writeback
Message-ID: <20160512083436.GA28780@redhat.com>
References: <1462983266-15235-1-git-send-email-cmaiolino@redhat.com>
	<17ff69fb-360c-8c44-9431-564dcd54aef9@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <17ff69fb-360c-8c44-9431-564dcd54aef9@sandeen.net>
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
To: xfs@oss.sgi.com

T24gV2VkLCBNYXkgMTEsIDIwMTYgYXQgMTE6MzM6MjFBTSAtMDUwMCwgRXJpYyBTYW5kZWVuIHdy
b3RlOgo+IAo+IAo+IE9uIDUvMTEvMTYgMTE6MTQgQU0sIENhcmxvcyBNYWlvbGlubyB3cm90ZToK
PiA+IEZyb206IENhcmxvcyBNYWlvbGlubyA8Y21haW9saW5vQHJlZGhhdC5jb20+Cj4gPiAKPiA+
IER1ZSB0aGUgaW5pdGlhbGl6YXRpb24gb2YgYmxvY2ttYXNrIHZhcmlhYmxlIHdpdGggaXRzIGRl
ZmluaXRpb24sIGdjYyBpc3N1ZXMgdGhlCj4gPiBmb2xsb3dpbmcgd2FybmluZyBkdWUgYW4gdW51
c2VkIHZhcmlhYmxlIGR1cmluZyBjb21waWxhdGlvbiB0aW1lLgo+ID4gCj4gPiBmcy94ZnMvL3hm
c19hb3BzLmM6IEluIGZ1bmN0aW9uIOKAmHhmc19maW5pc2hfcGFnZV93cml0ZWJhY2vigJk6Cj4g
PiBmcy94ZnMvL3hmc19hb3BzLmM6OTc6MTU6IHdhcm5pbmc6IHVudXNlZCB2YXJpYWJsZSDigJhi
bG9ja21hc2vigJkKPiA+IFstV3VudXNlZC12YXJpYWJsZV0KPiA+ICAgdW5zaWduZWQgaW50ICBi
bG9ja21hc2sgPSAoMSA8PCBpbm9kZS0+aV9ibGtiaXRzKSAtIDE7Cj4gPiAgICAgICAgICAgICAg
ICBeCj4gPiBSZW1vdmUgdGhpcyB3YXJuaW5nIGJ5IGluaXRpYWxpemluZyB0aGUgdmFyaWFibGUg
YWZ0ZXIgaXRzIGRlZmluaXRpb24uCj4gPiAKPiA+IFRoaXMgY2hhbmdlIGNhdXNlcyBubyBkaWZm
ZXJlbmNlIGluIHRoZSBnZW5lcmF0ZWQgYXNzZW1ibHkgY29kZQo+IAo+IE9oLCBJIHNlZS4gIEl0
J3MgdW51c2VkIG9uIG5vbi1kZWJ1ZyBidWlsZHMgYmVjYXVzZSBpdCdzIG9ubHkgdXNlZAo+IHVu
ZGVyIEFTU0VSVC4KPiAKPiBPaywgdGhhdCdzIGEgZ29vZCB3YXkgdG8gZml4IGl0LCBhbHRob3Vn
aCB0aGVyZSBhcmUgc29tZSBzY2FubmVycwo+IG91dCB0aGVyZSAoY2xhbmc/ICBzb21lIGdjYz8g
IEkgZG9uJ3QgcmVjYWxsKSB3aGljaCB3aWxsIGFsc28gZmxhZwo+IHdyaXRlLW9ubHkgdmFyaWFi
bGVzLiAgSXQnZCBiZSB1Z2x5IGJ1dCBzb21ldGltZXMgSSB3b25kZXIgaWYgYW4KPiBBU1NFUlRf
REVDTCgpIG1hY3JvIHdvdWxkIG1ha2Ugc29tZSBzZW5zZS4KPiAKPiBPciBhIE1BU0soKSBtYWNy
byBzbyB3ZSBjb3VsZCBqdXN0IGRvOgo+IAo+ICNkZWZpbmUgTUFTSyhuYml0cykgKCgxVUwgPDwg
KG5iaXRzKSkgLSAxKSAvKiBtYXNrIHdpdGggTkJJVFMgYml0cyBzZXQgKi8KPiAKPiBBU1NFUlQo
KGJ2ZWMtPmJ2X29mZnNldCAmIE1BU0soaW5vZGUtPmlfYmxrYml0cykpID09IDApOwo+IAoKSSB3
YXMgd29uZGVyaW5nIGlmIHdlIGNvdWxkIHVzZSBzb21ldGhpbmcgbGlrZSB1bmluaXRpYWxpemVk
X3ZhcigpIGZvciBzdWNoCmNhc2VzLCBidXQsIEkgdGhpbmsgaXQncyBhIHNvcnQgb2YgdG9vIGV4
dHJhIGNvbXBsZXhpdHkgdG8ganVzdCBoaWRlIGEgdmFyaWFibGUKaW5pdGlhbGl6YXRpb24gaW4g
YSBkaWZmZXJlbnQgcGxhY2UgdGhhbiB0b2dldGhlciB3aXRoIGl0cyBkZWZpbml0aW9uLiBJIHJl
YWxseQpkb24ndCB0aGluayBpdCdzIHdvcnRoLgoKRXZlbiBpbiB0aGUgY2FzZSB5b3UgbWVudGlv
bmVkIGFib3ZlLCBJTUhPLCBNQVNLIGlzIGdvaW5nIHRvIGhpZGUgc29tZXRoaW5nIHRoYXQKZG9l
cyBub3QgbmVlZCB0byBiZSBoaWRkZW4sIG9ubHkgYWRkaW5nIHNvbWUgZXh0cmEganVtcHMgaW4g
bXkgY3Njb3BlIHRvCnVuZGVyc3RhbmQgd2hhdCBNQVNLIGlzIGRvaW5nLiBBbHRob3VnaCwgaXQg
bWlnaHQgb25seSBiZSBteSBsYXp5IHNpZGUgc2F5aW5nCml0IDopCgo+IEJ1dCBmb3Igbm93LCB0
aGlzIGlzIGJldHRlciwgYW5kIGZpeGVzIHdoYXQgbW9zdCBwZW9wbGUgd2lsbCBzZWUsCj4gc28g
ZmluZSBieSBtZToKPiAKPiBSZXZpZXdlZC1ieTogRXJpYyBTYW5kZWVuIDxzYW5kZWVuQHJlZGhh
dC5jb20+Cj4gCj4gPiBTaWduZWQtb2ZmLWJ5OiBDYXJsb3MgTWFpb2xpbm8gPGNtYWlvbGlub0By
ZWRoYXQuY29tPgo+ID4gLS0tCj4gPiAgZnMveGZzL3hmc19hb3BzLmMgfCAzICsrLQo+ID4gIDEg
ZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKPiA+IAo+ID4gZGlm
ZiAtLWdpdCBhL2ZzL3hmcy94ZnNfYW9wcy5jIGIvZnMveGZzL3hmc19hb3BzLmMKPiA+IGluZGV4
IDQwNjQ1YTQuLmY0ZTJkM2IgMTAwNjQ0Cj4gPiAtLS0gYS9mcy94ZnMveGZzX2FvcHMuYwo+ID4g
KysrIGIvZnMveGZzL3hmc19hb3BzLmMKPiA+IEBAIC05NCwxMSArOTQsMTIgQEAgeGZzX2Zpbmlz
aF9wYWdlX3dyaXRlYmFjaygKPiA+ICAJc3RydWN0IGJpb192ZWMJCSpidmVjLAo+ID4gIAlpbnQJ
CQllcnJvcikKPiA+ICB7Cj4gPiAtCXVuc2lnbmVkIGludAkJYmxvY2ttYXNrID0gKDEgPDwgaW5v
ZGUtPmlfYmxrYml0cykgLSAxOwo+ID4gKwl1bnNpZ25lZCBpbnQJCWJsb2NrbWFzazsKPiA+ICAJ
dW5zaWduZWQgaW50CQllbmQgPSBidmVjLT5idl9vZmZzZXQgKyBidmVjLT5idl9sZW4gLSAxOwo+
ID4gIAlzdHJ1Y3QgYnVmZmVyX2hlYWQJKmhlYWQsICpiaDsKPiA+ICAJdW5zaWduZWQgaW50CQlv
ZmYgPSAwOwo+ID4gIAo+ID4gKwlibG9ja21hc2sgPSAoMSA8PCBpbm9kZS0+aV9ibGtiaXRzKSAt
IDE7Cj4gPiAgCUFTU0VSVChidmVjLT5idl9vZmZzZXQgPCBQQUdFX1NJWkUpOwo+ID4gIAlBU1NF
UlQoKGJ2ZWMtPmJ2X29mZnNldCAmIGJsb2NrbWFzaykgPT0gMCk7Cj4gPiAgCUFTU0VSVChlbmQg
PCBQQUdFX1NJWkUpOwo+ID4gCj4gCj4gX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KPiB4ZnMgbWFpbGluZyBsaXN0Cj4geGZzQG9zcy5zZ2kuY29tCj4gaHR0
cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCgotLSAKQ2FybG9zCgpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0
Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
