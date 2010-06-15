Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5F1Z7O8065186 for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 20:35:07 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 64CB13C7E90
	for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 18:37:40 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	kXocAB1z4u7zdS6K for <xfs@oss.sgi.com>;
	Mon, 14 Jun 2010 18:37:40 -0700 (PDT)
Date: Tue, 15 Jun 2010 11:37:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] xfs: simplify xfs_vm_releasepage
Message-ID: <20100615013737.GN6590@dastard>
References: <20100611161312.446670249@bombadil.infradead.org>
	<20100611161511.791495868@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100611161511.791495868@bombadil.infradead.org>
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

T24gRnJpLCBKdW4gMTEsIDIwMTAgYXQgMTI6MTM6MTRQTSAtMDQwMCwgQ2hyaXN0b3BoIEhlbGx3
aWcgd3JvdGU6Cj4gQ3VycmVudGx5IHRoZSB4ZnMgcmVsZWFzZXBhZ2UgaW1wbGVtZW50YXRpb24g
aGFzIGNvZGUgdG8gZGVhbCB3aXRoIGNvbnZlcnRpbmcKPiBkZWxheWVkIGFsbG9jYXRlZCBhbmQg
dW53cml0dGVuIHNwYWNlLiAgQnV0IHdlIG5ldmVyIGdldCBjYWxsZWQgZm9yIHRob3NlIGFzCj4g
d2UgYWx3YXlzIGNvbnZlcnQgZGVsYXllZCBhbmQgdW53cml0dGVuIHNwYWNlIHdoZW4gY2xlYW5p
bmcgYSBwYWdlLCBvciBkcm9wCj4gdGhlIHN0YXRlIGZyb20gdGhlIGJ1ZmZlcnMgaW4gYmxvY2tf
aW52YWxpZGF0ZXBhZ2UuICBXZSBzdGlsbCBrZWVwIGEgV0FSTl9PTgo+IG9uIHRob3NlIGNhc2Vz
IGZvciBub3csIGJ1dCByZW1vdmUgYWxsIHRoZSBjYXNlIGRlYWxpbmcgd2l0aCBpdCwgd2hpY2gg
YWxsb3dzCj4gdG8gZm9sZCB4ZnNfcGFnZV9zdGF0ZV9jb252ZXJ0IGludG8geGZzX3ZtX3dyaXRl
cGFnZSBhbmQgcmVtb3ZlIHRoZSAhc3RhcnRpbwo+IGNhc2UgZnJvbSB0aGUgd2hvbGUgd3JpdGVi
YWNrIHBhdGguCj4gCj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3Qu
ZGU+CgpMb29rcyBnb29kLiBDb3VwbGUgb2YgdGhpbmdzOgoKPiArCj4gKwkvKgo+ICsJICogVk0g
Y2FsY3VsYXRpb24gZm9yIG5yX3RvX3dyaXRlIHNlZW1zIG9mZi4gIEJ1bXAgaXQgd2F5Cj4gKwkg
KiB1cCwgdGhpcyBnZXRzIHNpbXBsZSBzdHJlYW1pbmcgd3JpdGVzIHppcHB5IGFnYWluLgo+ICsJ
ICogVG8gYmUgcmV2aWV3ZWQgYWdhaW4gYWZ0ZXIgSmVucycgd3JpdGViYWNrIGNoYW5nZXMuCj4g
KwkgKi8KPiArCXdiYy0+bnJfdG9fd3JpdGUgKj0gNDsKPiArCgpUaGF0J3MgZ29uZSBpbiBtYWlu
bGluZSBhcyBvZiBhcyBvZiAuMzUtcmMzLiBXZSBuZWVkIHRvIGdldCB0aGUKeGZzLWRldiB0cmVl
IHVwZGF0ZWQuCgpPdGhlcndpc2UsIGNvbtGVaWRlciBpdDoKClJldmlld2VkLWJ5OiBEYXZlIENo
aW5uZXIgPGRjaGlubmVyQHJlZGhhdC5jb20+CgpDaGVlcnMsCgpEYXZlLgotLSAKRGF2ZSBDaGlu
bmVyCmRhdmlkQGZyb21vcmJpdC5jb20KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9v
c3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
