Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DF52C7F3F
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 16:36:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BE61B304077
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 14:36:50 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	R8M9c9WODZ3SgDah for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 14:36:48 -0700 (PDT)
Date: Wed, 16 Apr 2014 07:36:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] fs: Prevent doing FALLOC_FL_ZERO_RANGE on append
	only file
Message-ID: <20140415213635.GM15995@dastard>
References: <1397242665-2183-1-git-send-email-lczerner@redhat.com>
	<1397242665-2183-2-git-send-email-lczerner@redhat.com>
	<20140412151935.GA18047@infradead.org>
	<alpine.LFD.2.00.1404151457550.2146@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1404151457550.2146@localhost.localdomain>
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
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

T24gVHVlLCBBcHIgMTUsIDIwMTQgYXQgMDM6MDk6NDJQTSArMDIwMCwgTHVrw6HFoSBDemVybmVy
IHdyb3RlOgo+IE9uIFNhdCwgMTIgQXByIDIwMTQsIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOgo+
IAo+ID4gRGF0ZTogU2F0LCAxMiBBcHIgMjAxNCAwODoxOTozNSAtMDcwMAo+ID4gRnJvbTogQ2hy
aXN0b3BoIEhlbGx3aWcgPGhjaEBpbmZyYWRlYWQub3JnPgo+ID4gVG86IEx1a2FzIEN6ZXJuZXIg
PGxjemVybmVyQHJlZGhhdC5jb20+Cj4gPiBDYzogbGludXgtZnNkZXZlbEB2Z2VyLmtlcm5lbC5v
cmcsIGNlcGgtZGV2ZWxAdmdlci5rZXJuZWwub3JnLAo+ID4gICAgIGxpbnV4LWV4dDRAdmdlci5r
ZXJuZWwub3JnLCB4ZnNAb3NzLnNnaS5jb20KPiA+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMi80XSBm
czogUHJldmVudCBkb2luZyBGQUxMT0NfRkxfWkVST19SQU5HRSBvbiBhcHBlbmQgb25seQo+ID4g
ICAgICBmaWxlCj4gPiAKPiA+IE9uIEZyaSwgQXByIDExLCAyMDE0IGF0IDA4OjU3OjQzUE0gKzAy
MDAsIEx1a2FzIEN6ZXJuZXIgd3JvdGU6Cj4gPiA+ICAJLyoKPiA+ID4gLQkgKiBJdCdzIG5vdCBw
b3NzaWJsZSB0byBwdW5jaCBob2xlIG9yIHBlcmZvcm0gY29sbGFwc2UgcmFuZ2UKPiA+ID4gLQkg
KiBvbiBhcHBlbmQgb25seSBmaWxlCj4gPiA+ICsJICogSXQncyBub3QgcG9zc2libGUgdG8gcHVu
Y2ggaG9sZSwgcGVyZm9ybSBjb2xsYXBzZSByYW5nZQo+ID4gPiArCSAqIG9yIHplcm8gcmFuZ2Ug
b24gYXBwZW5kIG9ubHkgZmlsZQo+ID4gPiAgCSAqLwo+ID4gPiAtCWlmIChtb2RlICYgKEZBTExP
Q19GTF9QVU5DSF9IT0xFIHwgRkFMTE9DX0ZMX0NPTExBUFNFX1JBTkdFKQo+ID4gPiArCWlmICht
b2RlICYgKEZBTExPQ19GTF9QVU5DSF9IT0xFIHwgRkFMTE9DX0ZMX0NPTExBUFNFX1JBTkdFIHwK
PiA+ID4gKwkJICAgIEZBTExPQ19GTF9aRVJPX1JBTkdFKQo+ID4gCj4gPiBNaWdodCBiZSBiZXR0
ZXIgdG8gbWFrZSB0aGlzIGEgbmVnYXRpdmUgdGVzdCBmbyB0aGUgb3BlcmF0aW9uIHRoYXQgaXMK
PiA+IGFsbG93ZWQgb24gYW4gYXBwZW4gb25seSBmaWxlLiAgVGhhdCdzIGFsc28gbXVjaCBiZXR0
ZXIgZnV0dXJlIHByb29mLgo+ID4gCj4gCj4gVHJ1ZSwgaXQgbWlnaHQgYmUgYmV0dGVyIHRvIGRv
IGl0IHRoaXMgd2F5Ogo+IAo+IGlmIChtb2RlICYgfkZBTExPQ19GTF9LRUVQX1NJWkUgJiYgSVNf
QVBQRU5EKGlub2RlKSkKCmlmICgobW9kZSAmIH5GQUxMT0NfRkxfS0VFUF9TSVpFKSAmJiBJU19B
UFBFTkQoaW5vZGUpKQoKOikKCkNoZWVycywKCkRhdmUuCi0tIApEYXZlIENoaW5uZXIKZGF2aWRA
ZnJvbW9yYml0LmNvbQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29t
L21haWxtYW4vbGlzdGluZm8veGZzCg==
