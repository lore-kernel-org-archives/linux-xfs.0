Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 42D597F3F
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 13:35:41 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 15F48304053
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 11:35:37 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	pXWoWWkehGq8iPzW for <xfs@oss.sgi.com>;
	Thu, 27 Feb 2014 11:35:35 -0800 (PST)
Date: Fri, 28 Feb 2014 06:35:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] ext4/242: Add ext4 specific test for fallocate zero
	range
Message-ID: <20140227193533.GB30131@dastard>
References: <1393355728-12056-1-git-send-email-lczerner@redhat.com>
	<1393355728-12056-6-git-send-email-lczerner@redhat.com>
	<20140225205349.GD13647@dastard>
	<alpine.LFD.2.00.1402252156290.12444@localhost.localdomain>
	<20140225215011.GF13647@dastard>
	<alpine.LFD.2.00.1402261520070.2243@localhost.localdomain>
	<20140226220106.GC29907@dastard>
	<alpine.LFD.2.00.1402271257590.2247@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1402271257590.2247@localhost.localdomain>
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
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

T24gVGh1LCBGZWIgMjcsIDIwMTQgYXQgMDE6MDM6MDlQTSArMDEwMCwgTHVrw6HFoSBDemVybmVy
IHdyb3RlOgo+IE9uIFRodSwgMjcgRmViIDIwMTQsIERhdmUgQ2hpbm5lciB3cm90ZToKPiA+ID4g
eGZzLzI0MiBmYWlscyBvbiBwcGM2NCB3aXRoIGxhdGVzdCBsaW51cyB0cmVlCj4gPiAKPiA+IE9L
LCB0aGF0J3MgYSBkaWZmZXJlbnQga2V0dGxlIG9mIGZpc2guIEl0J3MgdXNpbmcgNjRrIHBhZ2Vz
LCByaWdodD8KPiAKPiA2NGsgcGFnZXMsIHllcy4KLi4uLgo+ID4gWWVhaCwgb2ssIHRoZSBkYXRh
IGluIGFsbCB0aGUgZmlsZXMgaXMgY29ycmVjdCAtIHRoZSBtZDVzdW1zIGFsbAo+ID4gbWF0Y2gu
IFdoYXQncyBkaWZmZXJlbnQ/IEp1c3QgYWJvdXQgYWxsIHVud3JpdHRlbiBleHRlbnRzIGFyZSBu
b3cKPiA+IHdyaXR0ZW4gKGkuZS4gZGF0YSkgb3IgY29udGFpbiBzb21lIHBvcnRpb24gb2Ygd3Jp
dHRlbiBleHRlbnRzLgo+ID4gCj4gPiBTbywgWkVST19SQU5HRSBoYXMgdGhlIGZvbGxvd2luZyBz
aXplIHRocmVzaG9sZCBmb3IgY29udmVydGluZwo+ID4gYmxvY2tzIHRvIHVud3JpdHRlbiBleHRl
bnRzIHZzIGp1c3QgemVyb2luZyB0aGVtOgo+ID4gCj4gPiAJZ3JhbnVsYXJpdHkgPSBtYXhfdCh1
aW50LCAxIDw8IG1wLT5tX3NiLnNiX2Jsb2NrbG9nLCBQQUdFX0NBQ0hFX1NJWkUpOwo+ID4gCj4g
PiBTbyBpZiB0aGlzIGlzIGEgNjRrIHBhZ2Ugc2l6ZSBtYWNoaW5lLCBpdCdzIGdvaW5nIHRvIGhh
dmUgZGlmZmVyZW50Cj4gPiBleHRlbnQgbGF5b3V0IGNvbXBhcmVkIHRvIGEgNGsgcGFnZSBzaXpl
IG1hY2hpbmUuIFRoZSBmaWxlIGRhdGEgd2lsbAo+ID4gc3RpbGwgYmUgdGhlIHNhbWUsIHRoZSBk
aWZmZXJlbmNlIHdpbGwgYmUgemVyb2VkIGJsb2NrcyBpbnN0ZWFkIG9mCj4gPiB1bndyaXR0ZW4g
YmxvY2tzLCBhbmQgdGhhdCdzIGV4YWN0bHkgd2hhdCB3ZSBzZWUuCj4gPiAKPiA+IElPV3MsIHRo
ZSByZXN1bHQgaW4gdGVybXMgb2YgZGF0YSB0aGUgYXBwbGljYXRpb24gc2VlcyBpcyBjb3JyZWN0
LAo+ID4ganVzdCB0aGUgZXh0ZW50IGxheW91dCByZXByZXNlbnRpbmcgdGhhdCB6ZXJvZWQgZGF0
YSBpcyBkaWZmZXJlbnQuCj4gCj4gT2ssIHNvIHRoYXQncyB5ZXQgYW5vdGhlciBkaWZmZXJlbmNl
IGJldHdlZW4geGZzIGFuZCBleHQ0IGNvZGUgd2hpY2gKPiBtYWtlcyBoYXZpbmcgZ2VuZXJpYyB0
ZXN0IGV2ZW4gbW9yZSBjb21wbGljYXRlZC4KCkl0IGFjdHVhbGx5IG1ha2VzIHRoZSBuZWVkIGZv
ciBhIGdlbmVyaWMgdGVzdCBtb3JlIGltcG9ydGFudC4gQQpnZW5lcmljIHRlc3Qgc2hvdWxkIGhh
bmRsZSB0aGUgZGlmZmVyZW5jZXMgYmV0d2VlbiBibG9jay9wYWdlIHNpemUKYmVoYXZpb3VycyAt
IHRoZSBpc3N1ZSBpcyB0aGF0IHhmcy8yNDIgd2FzIHdyaXR0ZW4gYW5kIHRlc3RlZCBvbiA0awpw
YWdlIG1hY2hpbmVzLCBub3QgNjRrIHBhZ2UgbWFjaGluZXMuCgpXZSd2ZSBhbHJlYWR5IGdvdCB0
aGUgIm11bHRpcGxlIiBjb2RlIGluIF9nZW5lcmljX3Rlc3RfcHVuY2ggdG8KaW5jcmVhc2UgdGhl
IHNpemUgb2YgdGhlIHJlZ2lvbnMgYmVpbmcgd29ya2VkIG9uLCBzbyB0aGUgc2ltcGxlIGZpeApo
ZXJlIGlzIHRvIGluY3JlYXNlIHRoZSBzaXplcyBzbyB0aGF0IDY0ayBwYWdlIGFuZCA0ayBwYWdl
IGJlaGF2aW91cgppcyB0aGUgc2FtZSBhbmQgcmVzdWx0cyBpbiB0aGUgc2FtZSBleHRlbnQgbGF5
b3V0LiBUaGlzIGlzIHRoZQpub3JtYWwgd2F5IHRlc3RzIGV2b2x2ZSBhcyBwZW9wbGUgcnVuIHRo
ZW0gb24gZGlmZmVyZW50IGhhcmR3YXJlIGFuZApjb25maWd1cmF0aW9ucy4uLi4KCj4gU28gYXMg
SSBzYWlkIGJlZm9yZQo+IEknbGwgbWFrZSB0aGUgZ2VuZXJpYyB0ZXN0ICh1c2luZyBfZmlsdGVy
X2hvbGVfZmllbWFwKSBhbmQgdGhlbiBleHQ0Cj4gc3BlY2lmaWMgdGVzdCBhcyB3ZWxsIHRvIHJl
YWxseSBtYWtlIHN1cmUgdGhhdCB0aGUgZXh0ZW50Cj4gbWFuaXB1bGF0aW9uIGlzIHJpZ2h0LgoK
V2hpY2ggaWdub3JlcyB0aGUgZmFjdCB0aGF0IGlmIHlvdSB0dXJuIG9mZiB6ZXJvb3V0IG9uIGV4
dDQgdGhlbiBhCmdlbmVyaWMgdGVzdCBjYW4gYWxzbyBkZXRlcm1pbmUgdGhhdCB0aGUgZXh0ZW50
IG1hbmlwdWxhdGlvbiBpcwpjb3JyZWN0LiBJIHJlYWxseSBkb24ndCBzZWUgdGhlIG5lZWQgZm9y
IGFuIGV4dDQgc3BlY2lmaWMgdGVzdApoZXJlLi4uCgpDaGVlcnMsCgpEYXZlLgotLSAKRGF2ZSBD
aGlubmVyCmRhdmlkQGZyb21vcmJpdC5jb20KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6
Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
