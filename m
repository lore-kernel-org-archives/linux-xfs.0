Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o989P2dn019123 for <xfs@oss.sgi.com>; Fri, 8 Oct 2010 04:25:02 -0500
Received: from mx01.instandbesetzt.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8BBBFED92BE
	for <xfs@oss.sgi.com>; Fri,  8 Oct 2010 02:39:59 -0700 (PDT)
Received: from mx01.instandbesetzt.net (cache.dhh-3.de [62.89.186.8]) by
	cuda.sgi.com with ESMTP id Jxp3wbEygTGw9D63 for
	<xfs@oss.sgi.com>; Fri, 08 Oct 2010 02:39:59 -0700 (PDT)
Date: Fri, 8 Oct 2010 11:26:01 +0200
From: Andreas Wiese <aw-lkml@meterriblecrew.net>
Subject: Re: fallocate() on XFS clobbers S*ID-bits
Message-ID: <20101008092600.GA12718@incendiary.meterriblecrew.net>
References: <20101007183418.GC5621@incendiary.meterriblecrew.net>
	<20101007232451.GO4681@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101007232451.GO4681@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ciaran McCreesh <ciaran.mccreesh@googlemail.com>

RGF2ZSBDaGlubmVyIHdyb3RlOgo+IFsgYWRkZWQgeGZzIGxpc3Qgb24gY2MgXQo+IAoKVGhhbmtz
LiA7KQoKPiBPbiBUaHUsIE9jdCAwNywgMjAxMCBhdCAwODozNDoxOVBNICswMjAwLCBBbmRyZWFz
IFdpZXNlIHdyb3RlOgo+ID4gSGVsbG8uCj4gPiAKPiA+IEkgKHdpdGggc3VwcG9ydCBmcm9tIENj
J2VkIENpYXJhbikganVzdCBub3RpY2VkIHNvbWUgb2RkIGJlaGF2aW91ciB3aXRoCj4gPiBmYWxs
b2NhdGUoKSBvbiBYRlMuICBBZnRlciBvcGVuKClpbmcgc29tZSBmaWxlIGFuZCBzZXR0aW5nIGl0
IFMqSUQgdmlhCj4gPiBmY2htb2QoKSwgUypJRCBiaXRzIHZhbmlzaCBhZnRlciBjYWxsaW5nIGZh
bGxvY2F0ZSgpIOKAlCBhcyBzdXBwb3NlZCB0bwo+ID4gZm9yIG5vbi1yb290IHVzZXJzLCBidXQg
aXQgYWxzbyBoYXBwZW5zIGZvciByb290Lgo+ID4gCj4gPiBJcyB0aGlzIGludGVuZGVkIGJlaGF2
aW91ciBvciBkaWQgd2Ugc3BvdCBhIGJ1ZyBoZXJlPwo+ID4gCj4gPiBBdCBsZWFzdCBvbiBleHQy
IGl0IHdvcmtzIGFzIGV4cGVjdGVkLCB0aHVzIEkgZ3Vlc3MgaXQncyB0aGUgbGF0dGVyIG9uZS4K
PiAKPiBleHQyIGRvZXMgbm90IHN1cHBvcnQgdGhlIGZhbGxvY2F0ZSBzeXNjYWxsLiBIb3cgZG9l
cyBleHQ0IGJlaGF2ZT8KPiAKCk9oLCBjcmFwLiAgSSBmaXJzdCB0ZXN0ZWQgb24gdG1wZnMgKHdo
aWNoIGRvZXNuJ3Qgc3VwcG9ydCBmYWxsb2NhdGUsCnRvbykgYW5kIGhhZCBhIMK7ICYmIGVycm5v
ICE9IEVOT1RTVVDCqyB0byBhdm9pZCBiYWlsaW5nIG91dCBidXQgZm9yZ290IHRvCndhcm4uIDov
CgpCdXQgSSBkaWQgbm93IGFuZCBleHQ0IGRvZXMgX25vdF8gdG91Y2ggdGhlIHBlcm1pc3Npb25z
IGFueSBmdXJ0aGVyLgoKPiA+IEknbSBydW5uaW5nIHYyLjYuMzUuNyB2YW5pbGxhLWtlcm5lbCwg
YnV0IGRpZmZpbmcgZnMveGZzIHRvIG1hc3Rlcgo+ID4gZG9lc24ndCBzZWVtIHRvIGFkZHJlc3Mg
dGhpcyBpc3N1ZS4KPiAKPiBYRlMgaGFzIGFsd2F5cyBjbGVhcmVkIFNVSUQvU0dJRCBiaXRzIHdo
ZW4gZG9pbmcgcHJlYWxsb2NhdGlvbiAodmlhCj4gWEZTX0lPQ19SRVNWU1ApLiBHaXZlbiB0aGF0
IHRoYXQgWEZTIGlvY3RsIGZvcm1lZCB0aGUgbW9kZWwgZm9yCj4gZmFsbG9jYXRlLCBJJ2QgYXJn
dWUgdGhhdCB0aGUgWEZTIGJlaGF2aW91ciBpcyB0aGUgb24gdGhhdCBzaG91bGQgYmUKPiBmb2xs
b3dlZC4KPiAKCklmIHRoYXQncyBjb25zZW5zZSwgd2UgYXQgbGVhc3QgZm91bmQgYSBidWcgaW4g
ZXh0NOKApgoKPiBJdCdkIGJlIGEgYml0IHNpbGx5IGZvciB0d28gZGlmZmVyZW50IHByZWFsbG9j
YXRpb24gaW50ZXJmYWNlcyB0bwo+IGhhdmUgZGlmZmVyZW50IGJlaGF2aW91ciB3LnIudC4gU1VJ
RCBiaXRzLCBidXQgaXQncyBub3QgY2xlYXIgdG8gbWUKPiB3aGljaCBiZWhhdmlvdXIgaXMgY29y
cmVjdC4gSSdtIGhhcHB5IHRvIGRlZmVyIHRvIHdob2V2ZXIgY2FuIHNheQo+IHdoYXQgdGhlIGJl
aGF2aW91ciBpcyBzdXBwb3NlZCB0byBiZSBoZXJlLi4uCj4gCgpJIHdvdWxkIGFwcHJlY2lhdGUg
dGhhdCwgdG9vLgoKQW5kIHdoaWxlIG9uIGl04oCmIGp1c3QgdGVzdGVkIEJUUkZTLCB3aGljaCBi
ZWhhdmVzIGxpa2UgZXh0NCAobm90CmFsdGVyaW5nIHBlcm1pc3Npb25zKS4gIENJRlMgYW5kIE9D
RlMgYXJlIG5vdCB0ZXN0YWJsZSBoZXJlIGR1ZSB0byBsYWNrCm9mIGFjY29yZGluZyBzZXJ2ZXJz
LgoKW3NuaXDigKZdCgpIQU5EICYgTEcgLS0gYXcKbnA6IEpvaG5vc3NpIChKb2hub3NzaSkg4oCU
IDA4LiBIYXBwaW5lc3MgYSBMYSBNb2RlCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8v
b3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
