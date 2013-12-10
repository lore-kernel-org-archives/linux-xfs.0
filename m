Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EC3447FB1
	for <xfs@oss.sgi.com>; Mon,  9 Dec 2013 23:52:21 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 96B0DAC002
	for <xfs@oss.sgi.com>; Mon,  9 Dec 2013 21:52:21 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	xENZajzEOH8KJNdb for <xfs@oss.sgi.com>;
	Mon, 09 Dec 2013 21:52:16 -0800 (PST)
Date: Tue, 10 Dec 2013 16:52:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: where/how is 'xattr' type=security enforced? (security attr
	stripped?)
Message-ID: <20131210055213.GD31386@dastard>
References: <52A65AD5.9070705@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52A65AD5.9070705@tlinx.org>
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
To: Linda Walsh <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

T24gTW9uLCBEZWMgMDksIDIwMTMgYXQgMDQ6MDU6NDFQTSAtMDgwMCwgTGluZGEgV2Fsc2ggd3Jv
dGU6Cj4gSSBnb3QgYSB3ZWlyZCBtZXNzYWdlIHRoYXQgSSd2ZSBuZXZlciBzZWVuIGJlZm9yZSAt
LSBub3RoaW5nCj4gbGlmZSBzaGF0dGVyaW5nLCBqdXN0IGEgY3VyaW9zaXR5IHRoYXQgSSB0aG91
Z2h0IHNob3VsZG4ndCBoYXBwZW4uCj4gCj4gCj4gSSBzdG9yZWQgYSBmaWxlIGluIG15IC9ob21l
IHBhcnRpdGlvbiBGUk9NIGEgV2luNyBjbGllbnQKPiB2aWEgc2FtYmEgMy42LjE2Lgo+IAo+IFdp
dGggdGhhdCBmaWxlIHdlcmUgYWxzbyBzdG9yZWQgeGF0dHJzOgo+IAo+IERPU0FUVFJJQiwgU0FN
QkFfUEFJIGFuZCBOVEFDTC4gIFNpbmNlIGxpbnV4IGlzIHRoZSAnc2VydmVyJywKPiBUaGVzZSBh
cmUgYWxsIGxpa2VseSBzZXQgdmlhIHNhbWJhLgo+IAo+IFRvIHdvcmsgb24gdGhlIGZpbGUgbW9y
ZSwgSSB3YW50ZWQgdG8gbW92ZSBpdAo+IHRvIC90bXAuCj4gCj4gSSB1c2UgbXY6Cj4gPm12ICAv
aG9tZS9sYXcvdG1wL29WYXJzLnBtIC90bXAKPiBtdjogc2V0dGluZyBhdHRyaWJ1dGUg4oCYc2Vj
dXJpdHkuTlRBQ0zigJkgZm9yIOKAmHNlY3VyaXR5Lk5UQUNM4oCZOiBPcGVyYXRpb24gbm90IHBl
cm1pdHRlZAoKWW91IG5lZWQgcm9vdCBwZXJtaXNzaW9ucyB0byBzZXQgc2VjdXJpdHkgbmFtZXNw
YWNlIGF0dHJpYnV0ZXMuCgokc2V0ZmF0dHIgLW4gc2VjdXJpdHkuTlRBQ0wgLXYgZm9vYmFyY2h1
Y2t5IC9tbnQvdGVzdC9mb28Kc2V0ZmF0dHI6IC9tbnQvdGVzdC9mb286IE9wZXJhdGlvbiBub3Qg
cGVybWl0dGVkCiQgc3VkbyBzZXRmYXR0ciAtbiBzZWN1cml0eS5OVEFDTCAtdiBmb29iYXJjaHVj
a3kKL21udC90ZXN0L2ZvbwokIGdldGZhdHRyIC1uIHNlY3VyaXR5Lk5UQUNMIC9tbnQvdGVzdC9m
b28KZ2V0ZmF0dHI6IFJlbW92aW5nIGxlYWRpbmcgJy8nIGZyb20gYWJzb2x1dGUgcGF0aCBuYW1l
cwojIGZpbGU6IG1udC90ZXN0L2ZvbwpzZWN1cml0eS5OVEFDTD0iZm9vYmFyY2h1Y2t5IgoKJAoK
WyBPbiBhIHNpZGUgbm90ZSwgdGhlcmUncyBzb21lIHNvb3BlciBzZWVrcml0IHZvb2RvbyB0aGVy
ZSBpbgpnZXRmYXR0ci4gIEkgZmVlbCB0aGF0IG15IHN5c3RlbXMgYXJlIHNvIG11Y2ggbW9yZSBz
ZWN1cmUga25vd2luZwp0aGF0IGdldGZhdHRyIGlzIHByb3RlY3RpbmcgbWUgZnJvbSBcc29tZXRo
aW5nLyBzbyBkYW5nZXJvdXMgaXQKY2FuJ3QgcG9zc2libHkgYmUgd29ya2VkIGFyb3VuZCB3aXRo
IHNlZCBvciAtLWFic29sdXRlLW5hbWVzLiBdCgpDaGVlcnMsCgpEYXZlLgotLSAKRGF2ZSBDaGlu
bmVyCmRhdmlkQGZyb21vcmJpdC5jb20KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9v
c3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
