Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3T1fBFt026123 for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 20:41:12 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 64A671D48DED
	for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 18:43:15 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	y8QbAGrVqL9g3XlE for <xfs@oss.sgi.com>;
	Wed, 28 Apr 2010 18:43:15 -0700 (PDT)
Date: Thu, 29 Apr 2010 11:43:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Enabling lazy counters damages filesystem
Message-ID: <20100429014312.GA2512@dastard>
References: <4BD84771.4030804@mejor.pl>
 <20100428230447.GJ9783@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100428230447.GJ9783@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Marcin =?utf-8?B?TWlyb3PFgmF3?= <marcin@mejor.pl>
Cc: xfs@oss.sgi.com

T24gVGh1LCBBcHIgMjksIDIwMTAgYXQgMDk6MDQ6NDdBTSArMTAwMCwgRGF2ZSBDaGlubmVyIHdy
b3RlOgo+IE9uIFdlZCwgQXByIDI4LCAyMDEwIGF0IDA0OjM0OjI1UE0gKzAyMDAsIE1hcmNpbiBN
aXJvc8WCYXcgd3JvdGU6Cj4gPiBIZWxsbywKPiA+IFBsZWFzZSBsb29rIGF0IHRoaXM6Cj4gPiAj
IG1rZnMueGZzIC1mIC9kZXYvbWFsb3dhem5lL3Rlc3QKPiA+IG1ldGEtZGF0YT0vZGV2L21hbG93
YXpuZS90ZXN0ICAgIGlzaXplPTI1NiAgICBhZ2NvdW50PTQsIGFnc2l6ZT01MjQyODggYmxrcwo+
ID4gICAgICAgICAgPSAgICAgICAgICAgICAgICAgICAgICAgc2VjdHN6PTUxMiAgIGF0dHI9Mgo+
ID4gZGF0YSAgICAgPSAgICAgICAgICAgICAgICAgICAgICAgYnNpemU9NDA5NiAgIGJsb2Nrcz0y
MDk3MTUyLCBpbWF4cGN0PTI1Cj4gPiAgICAgICAgICA9ICAgICAgICAgICAgICAgICAgICAgICBz
dW5pdD0wICAgICAgc3dpZHRoPTAgYmxrcwo+ID4gbmFtaW5nICAgPXZlcnNpb24gMiAgICAgICAg
ICAgICAgYnNpemU9NDA5NiAgIGFzY2lpLWNpPTAKPiA+IGxvZyAgICAgID1pbnRlcm5hbCBsb2cg
ICAgICAgICAgIGJzaXplPTQwOTYgICBibG9ja3M9MjU2MCwgdmVyc2lvbj0yCj4gPiAgICAgICAg
ICA9ICAgICAgICAgICAgICAgICAgICAgICBzZWN0c3o9NTEyICAgc3VuaXQ9MCBibGtzLCBsYXp5
LWNvdW50PTAKPiA+IHJlYWx0aW1lID1ub25lICAgICAgICAgICAgICAgICAgIGV4dHN6PTQwOTYg
ICBibG9ja3M9MCwgcnRleHRlbnRzPTAKPiA+IAo+ID4gIyB4ZnNfY2hlY2sgL2Rldi9tYWxvd2F6
bmUvdGVzdAo+ID4gIyB4ZnNfY2hlY2sgL2Rldi9tYWxvd2F6bmUvdGVzdAo+ID4gCj4gPiBJdCdz
IHN0aWxsIGNsZWFuLgo+ID4gCj4gPiAjIHhmc19hZG1pbiAtYyAxIC9kZXYvbWFsb3dhem5lL3Rl
c3QKPiA+IEVuYWJsaW5nIGxhenktY291bnRlcnMKPiA+ICMgeGZzX2NoZWNrIC9kZXYvbWFsb3dh
em5lL3Rlc3QKPiA+IHNiX2ZlYXR1cmVzMiAoMHhhKSBub3Qgc2FtZSBhcyBzYl9iYWRfZmVhdHVy
ZXMyICgweDgpCj4gLi4uLgo+IAo+ID4gU28gYXMgeW91IGNhbiBzZWUgbGF6eSBjb250ZXJzIGFy
ZSBzdGlsbCB0dXJuIG9uLgo+ID4gSSdtIHVzaW5nOgo+ID4gIyBta2ZzLnhmcyAtVgo+ID4gbWtm
cy54ZnMgdmVyc2lvbiAzLjAuMwo+IAo+IFRoaXMgd2FzIGZpeGVkIGluIDMuMC41LCBJSVJDLiBQ
bGVhc2UgdXBncmFkZS4KCkFjdHVhbGx5LCAzLjEuMCB3YXMgdGhlIGZpcnN0IHJlbGVhc2Ugd2l0
aCB0aGUgZml4IHRvIHhmc19kYiB0aGF0CnByZXZlbnRzIHRoaXMgcHJvYmxlbS4KCkNoZWVycywK
CkRhdmUuCi0tIApEYXZlIENoaW5uZXIKZGF2aWRAZnJvbW9yYml0LmNvbQoKX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNA
b3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
