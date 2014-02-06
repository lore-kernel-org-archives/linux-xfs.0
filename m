Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 812F87F51
	for <xfs@oss.sgi.com>; Thu,  6 Feb 2014 16:49:12 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 272C3AC005
	for <xfs@oss.sgi.com>; Thu,  6 Feb 2014 14:49:11 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	OdZ1QXhL9PEhp9qm for <xfs@oss.sgi.com>;
	Thu, 06 Feb 2014 14:49:10 -0800 (PST)
Date: Fri, 7 Feb 2014 09:49:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Btrfs: add regression test for running snapshot and send
	concurrently
Message-ID: <20140206224908.GD13647@dastard>
References: <1391440956-31924-1-git-send-email-wangshilong1991@gmail.com>
	<20140203234212.GW13997@dastard>
	<9BC2AB41-F187-4A1A-89D6-743C72446293@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <9BC2AB41-F187-4A1A-89D6-743C72446293@gmail.com>
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
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: jbacik@fb.com, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

T24gVGh1LCBGZWIgMDYsIDIwMTQgYXQgMDk6MTI6NTFQTSArMDgwMCwgV2FuZyBTaGlsb25nIHdy
b3RlOgo+IEhpIERhdmUsCj4gCj4gPiBPbiBNb24sIEZlYiAwMywgMjAxNCBhdCAxMToyMjozNlBN
ICswODAwLCBXYW5nIFNoaWxvbmcgd3JvdGU6Cj4gPj4gRnJvbTogV2FuZyBTaGlsb25nIDx3YW5n
c2wuZm5zdEBjbi5mdWppdHN1LmNvbT4KPiA+PiAKPiA+PiBCdHJmcyB3b3VsZCBmYWlsIHRvIHNl
bmQgaWYgc25hcHNob3QgcnVuIGNvbmN1cnJlbnRseSwgdGhpcyB0ZXN0IGlzIHRvIG1ha2UKPiA+
PiBzdXJlIHdlIGhhdmUgZml4ZWQgdGhlIGJ1Zy4KPiA+PiAKPiA+IENvdXBsZSBvZiBjb21tZW50
cyBiZWxvdy4KPiA+IAo+ID4+ICtfc2NyYXRjaF9ta2ZzID4gL2Rldi9udWxsIDI+JjEKPiA+PiAr
X3NjcmF0Y2hfbW91bnQKPiA+PiArCj4gPj4gKwo+ID4+ICt0b3VjaCAkU0NSQVRDSF9NTlQvZm9v
Cj4gPj4gKwo+ID4+ICsjIGdldCBmaWxlIHdpdGggZnJhZ21lbnRzIGJ5IHVzaW5nIGJhY2t3YXJk
cyB3cml0ZXMuCj4gPj4gK2ZvciBpIGluIGBzZXEgMTAyNDAgLTEgMWA7IGRvCj4gPj4gKwkkWEZT
X0lPX1BST0cgLWYgLWQgLWMgInB3cml0ZSAkKCgkaSAqIDQwOTYpKSA0MDk2IiBcCj4gPj4gKwkk
U0NSQVRDSF9NTlQvZm9vID4gL2Rldi9udWxsIHwgX2ZpbHRlcl94ZnNfaW8KPiA+IAo+ID4gSW5k
ZW50YXRpb24uCj4gPiAKPiA+PiArZG9uZQo+ID4+ICsKPiA+PiArJEJUUkZTX1VUSUxfUFJPRyBz
dWJ2b2x1bWUgc25hcHNob3QgLXIgJFNDUkFUQ0hfTU5UIFwKPiA+PiArCSRTQ1JBVENIX01OVC9z
bmFwXzEgPj4gJHNlcXJlcy5mdWxsIDI+JjEKPiA+PiArCj4gPj4gKyRCVFJGU19VVElMX1BST0cg
c2VuZCAtZiAkU0NSQVRDSF9NTlQvc2VuZF9maWxlIFwKPiA+PiArCSRTQ1JBVENIX01OVC9zbmFw
XzEgPj4gJHNlcXJlcy5mdWxsIDI+JjEgJgo+ID4+ICsKPiA+PiArcGlkPSQhCj4gPj4gKwo+ID4+
ICskQlRSRlNfVVRJTF9QUk9HIHN1YnZvbHVtZSBzbmFwc2hvdCAtciAkU0NSQVRDSF9NTlQvc25h
cF8xIFwKPiA+PiArCSRTQ1JBVENIX01OVC9zbmFwXzIgPj4gJHNlcXJlcy5mdWxsIDI+JjEKPiA+
PiArCj4gPj4gK3dhaXQgJHBpZCB8fCBlY2hvICJGYWlsZWQgdG8gc2VuZCwgc2VlIGRtZXNnIgo+
ID4gCj4gPiBUaGlzIHNlZW1zIGtpbmQgb2YgcmFjeS4gSXQgYXNzdW1lcyB0aGF0IHRoZSBzZW5k
IGNvbW1hbmQKPiA+IGRvZXNuJ3QgY29tcGxldGUgYmVmb3JlIHRoZSB3YWl0ICRwaWQgY2FsbCBp
cyBtYWRlLiBJZiAkcGlkIGRvZXNuJ3QKPiA+IGV4aXN0IGF0IHRoaXMgdGltZSBiZWNhdXNlIGl0
IGhhcyBjb21wbGV0ZWQsIHdhaXQgd2lsbCByZXR1cm4gMTI3Cj4gPiBhbmQgdGhlIHRlc3Qgd2ls
bCBmYWls4oCmLgo+IAo+IFNvcnJ5IGZvciBkZWxheSByZXBseSEKPiAKPiBNYXliZSBhIGJldHRl
ciBpZGVhIGZvciB0aGlzIHdpbGwgYmU6Cj4gCj4gT3Bwb3NpdGUgdG8gcHJldmlvdXMgd2F5LCB3
ZSBkbyBzbmFwc2hvdHMgYmFja2dyb3VuZCB3aGlsZSBhdCB0aGUKPiBzYW1lIHRpbWUgd2UgZG8g
c2VuZGluZy4KPiAKPiBBbmQgYnRyZnMtcHJvZ3Mgc2hvdWxkIG91dHB1dCBtZWFuaW5nZnVsIGlu
Zm9ybWF0aW9uIG9uIHNlbmQgZmFpbHVyZSwgaSB3aWxsCj4gbWFrZSBhIHRpbnkgcGF0Y2ggdG8g
YWRkcmVzcyB0aGlzIGlzc3VlLiBidXQgdG8gbWFrZSB0aGlzIHRlc3QgbW9yZSBmcmllbmRseSwg
aQo+IHRoaW5rIHdlIGNhbiBzdGlsbCBkbyBzb21ldGhpbmcgbGlrZToKPiAKPiBidHJmcyBzZW5k
IDwuLj4gIHx8IGVjaG8gIkZhaWxlZCB0byBzZW5kIgoKSWYgc2VuZCBpcyBlbWl0dGluZyBlcnJv
ciBtZXNzYWdlcyBvbiBmYWlsdXJlcywgdGhlbiB0aGUKInx8IGVjaG8uLi4iIGlzIHJlZHVuZGFu
dCBhbmQgbm90IG5lY2Vzc2FyeSB0byBjYXVzZSBhIGdvbGRlbiBpbWFnZQptaXNtYXRjaC4gSWYg
c2VuZCBpcyBub3QgZW1pdHRpbmcgZXJyb3IgbWVzc2FnZXMgb24gZmFpbHVyZSwgdGhlbiBpdApu
ZWVkcyBmaXhpbmcgYmVjYXVzZSB1c2VycyBhcmUgZ29pbmcgdG8gaGF0ZSB5b3UgZm9yIHNpbGVu
dGx5CmZhaWxpbmcgdG8gc2VuZCB0aGUgZGF0YSB0aGV5IGFza2VkIHRvIGJlIHNlbnQuCgpFaXRo
ZXIgd2F5LCB0aGUgZWNobyBjb21tYW5kIG9uIGVycm9yIGluIHRoZSB0ZXN0IGlzIG5vdCBuZWVk
ZWQuCgpDaGVlcnMsCgpEYXZlLgotLSAKRGF2ZSBDaGlubmVyCmRhdmlkQGZyb21vcmJpdC5jb20K
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWls
aW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3Rp
bmZvL3hmcwo=
