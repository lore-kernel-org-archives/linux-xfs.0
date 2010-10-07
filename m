Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o97NNrvM234719 for <xfs@oss.sgi.com>; Thu, 7 Oct 2010 18:23:54 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E190718D7729
	for <xfs@oss.sgi.com>; Thu,  7 Oct 2010 16:24:55 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	doLJ9qCkz3jvVyGH for <xfs@oss.sgi.com>;
	Thu, 07 Oct 2010 16:24:55 -0700 (PDT)
Date: Fri, 8 Oct 2010 10:24:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: fallocate() on XFS clobbers S*ID-bits
Message-ID: <20101007232451.GO4681@dastard>
References: <20101007183418.GC5621@incendiary.meterriblecrew.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101007183418.GC5621@incendiary.meterriblecrew.net>
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
To: Andreas Wiese <aw-lkml@meterriblecrew.net>
Cc: xfs@oss.sgi.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ciaran McCreesh <ciaran.mccreesh@googlemail.com>

WyBhZGRlZCB4ZnMgbGlzdCBvbiBjYyBdCgpPbiBUaHUsIE9jdCAwNywgMjAxMCBhdCAwODozNDox
OVBNICswMjAwLCBBbmRyZWFzIFdpZXNlIHdyb3RlOgo+IEhlbGxvLgo+IAo+IEkgKHdpdGggc3Vw
cG9ydCBmcm9tIENjJ2VkIENpYXJhbikganVzdCBub3RpY2VkIHNvbWUgb2RkIGJlaGF2aW91ciB3
aXRoCj4gZmFsbG9jYXRlKCkgb24gWEZTLiAgQWZ0ZXIgb3BlbigpaW5nIHNvbWUgZmlsZSBhbmQg
c2V0dGluZyBpdCBTKklEIHZpYQo+IGZjaG1vZCgpLCBTKklEIGJpdHMgdmFuaXNoIGFmdGVyIGNh
bGxpbmcgZmFsbG9jYXRlKCkg4oCUIGFzIHN1cHBvc2VkIHRvCj4gZm9yIG5vbi1yb290IHVzZXJz
LCBidXQgaXQgYWxzbyBoYXBwZW5zIGZvciByb290Lgo+IAo+IElzIHRoaXMgaW50ZW5kZWQgYmVo
YXZpb3VyIG9yIGRpZCB3ZSBzcG90IGEgYnVnIGhlcmU/Cj4gCj4gQXQgbGVhc3Qgb24gZXh0MiBp
dCB3b3JrcyBhcyBleHBlY3RlZCwgdGh1cyBJIGd1ZXNzIGl0J3MgdGhlIGxhdHRlciBvbmUuCgpl
eHQyIGRvZXMgbm90IHN1cHBvcnQgdGhlIGZhbGxvY2F0ZSBzeXNjYWxsLiBIb3cgZG9lcyBleHQ0
IGJlaGF2ZT8KCj4gSSdtIHJ1bm5pbmcgdjIuNi4zNS43IHZhbmlsbGEta2VybmVsLCBidXQgZGlm
ZmluZyBmcy94ZnMgdG8gbWFzdGVyCj4gZG9lc24ndCBzZWVtIHRvIGFkZHJlc3MgdGhpcyBpc3N1
ZS4KClhGUyBoYXMgYWx3YXlzIGNsZWFyZWQgU1VJRC9TR0lEIGJpdHMgd2hlbiBkb2luZyBwcmVh
bGxvY2F0aW9uICh2aWEKWEZTX0lPQ19SRVNWU1ApLiBHaXZlbiB0aGF0IHRoYXQgWEZTIGlvY3Rs
IGZvcm1lZCB0aGUgbW9kZWwgZm9yCmZhbGxvY2F0ZSwgSSdkIGFyZ3VlIHRoYXQgdGhlIFhGUyBi
ZWhhdmlvdXIgaXMgdGhlIG9uIHRoYXQgc2hvdWxkIGJlCmZvbGxvd2VkLgoKSXQnZCBiZSBhIGJp
dCBzaWxseSBmb3IgdHdvIGRpZmZlcmVudCBwcmVhbGxvY2F0aW9uIGludGVyZmFjZXMgdG8KaGF2
ZSBkaWZmZXJlbnQgYmVoYXZpb3VyIHcuci50LiBTVUlEIGJpdHMsIGJ1dCBpdCdzIG5vdCBjbGVh
ciB0byBtZQp3aGljaCBiZWhhdmlvdXIgaXMgY29ycmVjdC4gSSdtIGhhcHB5IHRvIGRlZmVyIHRv
IHdob2V2ZXIgY2FuIHNheQp3aGF0IHRoZSBiZWhhdmlvdXIgaXMgc3VwcG9zZWQgdG8gYmUgaGVy
ZS4uLgoKQ2hlZXJzLAoKRGF2ZS4KLS0gCkRhdmUgQ2hpbm5lcgpkYXZpZEBmcm9tb3JiaXQuY29t
CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFp
bGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0
aW5mby94ZnMK
