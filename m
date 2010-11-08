Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA8Nhpxl124723 for <xfs@oss.sgi.com>; Mon, 8 Nov 2010 17:43:51 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4A235CCF0DB
	for <xfs@oss.sgi.com>; Mon,  8 Nov 2010 15:45:16 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	falwEf4uo2Af2Z0p for <xfs@oss.sgi.com>;
	Mon, 08 Nov 2010 15:45:16 -0800 (PST)
Date: Tue, 9 Nov 2010 10:45:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 10/16] xfs: add a lru to the XFS buffer cache
Message-ID: <20101108234512.GT2715@dastard>
References: <1289206519-18377-1-git-send-email-david@fromorbit.com>
	<1289206519-18377-11-git-send-email-david@fromorbit.com>
	<20101108231928.GA20647@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101108231928.GA20647@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

T24gTW9uLCBOb3YgMDgsIDIwMTAgYXQgMDY6MTk6MjhQTSAtMDUwMCwgQ2hyaXN0b3BoIEhlbGx3
aWcgd3JvdGU6Cj4gPiBAQCAtNDcxLDYgKzU0Niw4IEBAIF94ZnNfYnVmX2ZpbmQoCj4gPiAgCQkv
KiB0aGUgYnVmZmVyIGtlZXBzIHRoZSBwZXJhZyByZWZlcmVuY2UgdW50aWwgaXQgaXMgZnJlZWQg
Ki8KPiA+ICAJCW5ld19icC0+Yl9wYWcgPSBwYWc7Cj4gPiAgCQlzcGluX3VubG9jaygmcGFnLT5w
YWdfYnVmX2xvY2spOwo+ID4gKwo+ID4gKwkJeGZzX2J1Zl9scnVfYWRkKG5ld19icCk7Cj4gCj4g
V2h5IGRvIHdlIGFkZCB0aGUgYnVmZmVyIHRvIHRoZSBscnUgd2hlbiB3ZSBmaW5kIGl0PyAgTm9y
bWFsbHkgd2UKPiB3b3VsZCByZW1vdmUgaXQgaGVyZSAodW5sZXNzIHdlIHdhbnQgYSBsYXp5IGxy
dSBzY2hlbWUpLAoKT2gsIEkgZm9yZ290IHRvIHJlbW92ZSB0aGF0IGZyb20gdGhlIHBhdGNoIHdo
ZW4gcmV3cml0aW5nIGl0IHRvIHVzZQpsYXp5IHVwZGF0ZdGVLiBHb29kIGNhdGNoISAoKikKCj4K
PiBhbmQgcG90ZW50aWFsbHkgaW5jcmVtZW50IGJfbHJ1X3JlZiAtIGFsdGhvdWdoIHRoYXQgc2Vl
bXMgdG8gYmUKPiBkb25lIGJ5IHRoZSBjYWxsZXJzIGluIHRoZSBuZXh0IHBhdGNoLgoKYl9scnVf
cmVmIGlzIGluaXRpYWxpc2VkIHRvIDEgd2hlbiB0aGUgYnVmZmVyIGlzIGZpcnN0IGluaXRpYWxp
c2VkLApzbyBpdCBkb2Vzbid0IG5lZWQgdG8gYmUgZG9uZSBoZXJlLiBBbmQgeWVzLCB0aGUgbmV4
dCBwYXRjaCBhbGxvd3MKdGhlIHVzZXJzIG9mIHRoZSBidWZmZXJzIHRvIHNldCB0aGUgcmVjbGFp
bSByZWZlcmVuY2UgY291bnQKdGhlbXNlbHZlcyB3aGVuIHRoZSBidWZmZXIgaXMgcmVhZCBmb3Ig
cHJpb3JpdGlzYXRpb24uIGlkZWFsbHkgSQpkb24ndCB3YW50IHRvIGhhdmUgdG8gdG91Y2ggdGhl
IHJlY2xhaW0gc3RhdGUgb2YgdGhlIGJ1ZmZlciBkdXJpbmcKeGZzX2J1Zl9maW5kLi4uLgoKQ2hl
ZXJzLAoKRGF2ZS4KCigqKSBDYXRjaGluZyB0aGlzIHNvcnQgb2YgYnVnIGlzIGV4YWN0bHkgd2h5
IEkgcG9zdGVkIHRoZSBzZXJpZXMKZWFybHkuIExpdHRsZSBkZXRhaWxzIGFyZSBlYXN5IHRvIG1p
c3MgaW4gYSBmb3Jlc3Qgb2YgY2hhbmdlcyB0aGlzCmxhcmdlLi4uLgotLSAKRGF2ZSBDaGlubmVy
CmRhdmlkQGZyb21vcmJpdC5jb20KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Mu
c2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
