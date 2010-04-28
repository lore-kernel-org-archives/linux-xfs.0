Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3SN2lGH015974 for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 18:02:48 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A961B2FC2F5
	for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 16:04:49 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	1LwXY90EBdGf2haR for <xfs@oss.sgi.com>;
	Wed, 28 Apr 2010 16:04:49 -0700 (PDT)
Date: Thu, 29 Apr 2010 09:04:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Enabling lazy counters damages filesystem
Message-ID: <20100428230447.GJ9783@dastard>
References: <4BD84771.4030804@mejor.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4BD84771.4030804@mejor.pl>
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

T24gV2VkLCBBcHIgMjgsIDIwMTAgYXQgMDQ6MzQ6MjVQTSArMDIwMCwgTWFyY2luIE1pcm9zxYJh
dyB3cm90ZToKPiBIZWxsbywKPiBQbGVhc2UgbG9vayBhdCB0aGlzOgo+ICMgbWtmcy54ZnMgLWYg
L2Rldi9tYWxvd2F6bmUvdGVzdAo+IG1ldGEtZGF0YT0vZGV2L21hbG93YXpuZS90ZXN0ICAgIGlz
aXplPTI1NiAgICBhZ2NvdW50PTQsIGFnc2l6ZT01MjQyODggYmxrcwo+ICAgICAgICAgID0gICAg
ICAgICAgICAgICAgICAgICAgIHNlY3Rzej01MTIgICBhdHRyPTIKPiBkYXRhICAgICA9ICAgICAg
ICAgICAgICAgICAgICAgICBic2l6ZT00MDk2ICAgYmxvY2tzPTIwOTcxNTIsIGltYXhwY3Q9MjUK
PiAgICAgICAgICA9ICAgICAgICAgICAgICAgICAgICAgICBzdW5pdD0wICAgICAgc3dpZHRoPTAg
Ymxrcwo+IG5hbWluZyAgID12ZXJzaW9uIDIgICAgICAgICAgICAgIGJzaXplPTQwOTYgICBhc2Np
aS1jaT0wCj4gbG9nICAgICAgPWludGVybmFsIGxvZyAgICAgICAgICAgYnNpemU9NDA5NiAgIGJs
b2Nrcz0yNTYwLCB2ZXJzaW9uPTIKPiAgICAgICAgICA9ICAgICAgICAgICAgICAgICAgICAgICBz
ZWN0c3o9NTEyICAgc3VuaXQ9MCBibGtzLCBsYXp5LWNvdW50PTAKPiByZWFsdGltZSA9bm9uZSAg
ICAgICAgICAgICAgICAgICBleHRzej00MDk2ICAgYmxvY2tzPTAsIHJ0ZXh0ZW50cz0wCj4gCj4g
IyB4ZnNfY2hlY2sgL2Rldi9tYWxvd2F6bmUvdGVzdAo+ICMgeGZzX2NoZWNrIC9kZXYvbWFsb3dh
em5lL3Rlc3QKPiAKPiBJdCdzIHN0aWxsIGNsZWFuLgo+IAo+ICMgeGZzX2FkbWluIC1jIDEgL2Rl
di9tYWxvd2F6bmUvdGVzdAo+IEVuYWJsaW5nIGxhenktY291bnRlcnMKPiAjIHhmc19jaGVjayAv
ZGV2L21hbG93YXpuZS90ZXN0Cj4gc2JfZmVhdHVyZXMyICgweGEpIG5vdCBzYW1lIGFzIHNiX2Jh
ZF9mZWF0dXJlczIgKDB4OCkKLi4uLgoKPiBTbyBhcyB5b3UgY2FuIHNlZSBsYXp5IGNvbnRlcnMg
YXJlIHN0aWxsIHR1cm4gb24uCj4gSSdtIHVzaW5nOgo+ICMgbWtmcy54ZnMgLVYKPiBta2ZzLnhm
cyB2ZXJzaW9uIDMuMC4zCgpUaGlzIHdhcyBmaXhlZCBpbiAzLjAuNSwgSUlSQy4gUGxlYXNlIHVw
Z3JhZGUuCgpDaGVlcnMsCgpEYXZlLgotLSAKRGF2ZSBDaGlubmVyCmRhdmlkQGZyb21vcmJpdC5j
b20KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBt
YWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xp
c3RpbmZvL3hmcwo=
