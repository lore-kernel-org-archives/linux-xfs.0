Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3AIDLch189173 for <xfs@oss.sgi.com>; Tue, 10 Apr 2012 13:13:21 -0500
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id aLvRX4sVFaU17Z9x for
	<xfs@oss.sgi.com>; Tue, 10 Apr 2012 11:13:19 -0700 (PDT)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: XFS: Abysmal write performance because of excessive seeking
	(allocation groups to blame?)
Date: Tue, 10 Apr 2012 20:13:15 +0200
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<201204072057.38286.Martin@lichtvoll.de>
	<CAAxjCEzRa7CpbA9iESEDjmWQMsJTjkWHJj69ADOXDa4CiRpx3w@mail.gmail.com>
	(sfid-20120410_161029_715945_ACEF67F7)
In-Reply-To: <CAAxjCEzRa7CpbA9iESEDjmWQMsJTjkWHJj69ADOXDa4CiRpx3w@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <201204102013.15734.Martin@lichtvoll.de>
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
To: Stefan Ring <stefanrin@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

QW0gRGllbnN0YWcsIDEwLiBBcHJpbCAyMDEyIHNjaHJpZWIgU3RlZmFuIFJpbmc6Cj4gPiBBbmQg
aXMgWEZTIGFsaWduZWQgdG8gdGhlIFJBSUQgNj8KPiA+IAo+ID4gV2hhdCBkb2VzIHhmc19pbmZv
IGRpc3BsYXkgb24gaXQ/Cj4gCj4gWWVzLCBpdOKAmXMgYWxpZ25lZC4KPiAKPiBtZXRhLWRhdGE9
L2Rldi9tYXBwZXIvdmdfZGF0YS1sdmhvbWUgaXNpemU9MjU2ICAgIGFnY291bnQ9NCwKPiBhZ3Np
emU9NzMyMzM2NTYgYmxrcwo+ICAgICAgICAgID0gICAgICAgICAgICAgICAgICAgICAgIHNlY3Rz
ej01MTIgICBhdHRyPTIKPiBkYXRhICAgICA9ICAgICAgICAgICAgICAgICAgICAgICBic2l6ZT00
MDk2ICAgYmxvY2tzPTI5MjkzNDYyNCwKPiBpbWF4cGN0PTUgPSAgICAgICAgICAgICAgICAgICAg
ICAgc3VuaXQ9OCAgICAgIHN3aWR0aD0zMiBibGtzCj4gbmFtaW5nICAgPXZlcnNpb24gMiAgICAg
ICAgICAgICAgYnNpemU9NDA5NiAgIGFzY2lpLWNpPTAKPiBsb2cgICAgICA9aW50ZXJuYWwgICAg
ICAgICAgICAgICBic2l6ZT00MDk2ICAgYmxvY2tzPTE0MzA0MCwgdmVyc2lvbj0yCj4gICAgICAg
ICAgPSAgICAgICAgICAgICAgICAgICAgICAgc2VjdHN6PTUxMiAgIHN1bml0PTggYmxrcywKPiBs
YXp5LWNvdW50PTEgcmVhbHRpbWUgPW5vbmUgICAgICAgICAgICAgICAgICAgZXh0c3o9NDA5NiAg
IGJsb2Nrcz0wLAo+IHJ0ZXh0ZW50cz0wCgpIbW1tLCBzbyBpdHMgbm90IHRoZSBhbGlnbm1lbnQu
IHhmc19pbmZvIG91dHB1dCBsb29rcyBzYW5lIG90aGVyd2lzZS4KCkkgaGF2ZSBubyBmdXJ0aGVy
IGlkZWFzIGZvciBub3cuIEJ1dCBvdGhlcnMgaGFkIGl0IHNlZW1zLiAoUmVhZGluZyByZXN0IG9m
IApuZXcgbWVzc2FnZXMgaW4gdGhyZWFkLikKCkNpYW8sCi0tIApNYXJ0aW4gJ0hlbGlvcycgU3Rl
aWdlcndhbGQgLSBodHRwOi8vd3d3LkxpY2h0dm9sbC5kZQpHUEc6IDAzQjAgMEQ2QyAwMDQwIDA3
MTAgNEFGQSAgQjgyRiA5OTFCIEVBQUMgQTU5OSA4NEM3CgpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNv
bQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
