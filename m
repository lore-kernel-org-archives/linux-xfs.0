Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5K0rPSb095750 for <xfs@oss.sgi.com>; Sun, 19 Jun 2011 19:53:25 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 743C451EBFA
	for <xfs@oss.sgi.com>; Sun, 19 Jun 2011 17:53:23 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	dKRLJQqULRLGvZj6 for <xfs@oss.sgi.com>;
	Sun, 19 Jun 2011 17:53:23 -0700 (PDT)
Date: Mon, 20 Jun 2011 10:53:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/12] vmscan: add shrink_slab tracepoints
Message-ID: <20110620005321.GM561@dastard>
References: <1306998067-27659-1-git-send-email-david@fromorbit.com>
	<1306998067-27659-2-git-send-email-david@fromorbit.com>
	<4DFE97F1.2030206@jp.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4DFE97F1.2030206@jp.fujitsu.com>
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
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

T24gTW9uLCBKdW4gMjAsIDIwMTEgYXQgMDk6NDQ6MzNBTSArMDkwMCwgS09TQUtJIE1vdG9oaXJv
IHdyb3RlOgo+ICgyMDExLzA2LzAyIDE2OjAwKSwgRGF2ZSBDaGlubmVyIHdyb3RlOgo+ID4gRnJv
bTogRGF2ZSBDaGlubmVyIDxkY2hpbm5lckByZWRoYXQuY29tPgo+ID4gCj4gPiDQhnQgaXMgaW1w
b3NzaWJsZSB0byB1bmRlcnN0YW5kIHdoYXQgdGhlIHNocmlua2VycyBhcmUgYWN0dWFsbHkgZG9p
bmcKPiA+IHdpdGhvdXQgaW5zdHJ1bWVudGluZyB0aGUgY29kZSwgc28gYWRkIGEgc29tZSB0cmFj
ZXBvaW50cyB0byBhbGxvdwo+ID4gaW5zaWdodCB0byBiZSBnYWluZWQuCj4gPiAKPiA+IFNpZ25l
ZC1vZmYtYnk6IERhdmUgQ2hpbm5lciA8ZGNoaW5uZXJAcmVkaGF0LmNvbT4KPiA+IC0tLQo+ID4g
IGluY2x1ZGUvdHJhY2UvZXZlbnRzL3Ztc2Nhbi5oIHwgICA2NyArKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKwo+ID4gIG1tL3Ztc2Nhbi5jICAgICAgICAgICAgICAgICAg
IHwgICAgNiArKystCj4gPiAgMiBmaWxlcyBjaGFuZ2VkLCA3MiBpbnNlcnRpb25zKCspLCAxIGRl
bGV0aW9ucygtKQo+IAo+IFRoaXMgbG9vayBnb29kIHRvIG1lLiBJIGhhdmUgdHdvIG1pbm9yIHJl
cXVlc3QuIDEpIHBsZWFzZSBjaGFuZ2UgcGF0Y2ggb3JkZXIsCj4gbW92ZSB0aGlzIHBhdGNoIGFm
dGVyIHNocmlua2VyIGNoYW5nZXMuIGlvdywgbm93IGJvdGggdGhpcyBhbmQgWzIvMTJdIGhhdmUK
PiB0cmFjZXBvaW50IGNoYW5nZS4gSSBkb24ndCBsaWtlIGl0LgoKTm8gYmlnIGRlYWwgLSBJJ2xs
IGp1c3QgZm9sZCB0aGUgc2Vjb25kIGNoYW5nZSAoaG93IHNocmlua2VyLT5uciBpcwpwYXNzZWQg
aW50byB0aGUgdHJhY2Vwb2ludCkgaW50byB0aGUgZmlyc3QuIFRyYWNlcG9pbnRzIHNob3VsZCBi
ZQpmaXJzdCBpbiB0aGUgc2VyaWVzLCBhbnl3YXksIG90aGVyd2lzZSB0aGVyZSBpcyBubyB3YXkg
dG8gdmFsaWRhdGUKdGhlIGJlZm9yZS9hZnRlciBlZmZlY3Qgb2YgdGhlIGJ1ZyBmaXhlcy4uLi4K
Cj4gMikgcGxlYXNlIGF2b2lkIGNyeXB0aWMgYWJicmV2aWF0ZWQgdmFyaWFibGUKPiBuYW1lcy4g
SW5zdGVhZCwgcGxlYXNlIGp1c3QgdXNlIHRoZSBzYW1lIHZhcmlhYmxlIG5hbWUgd2l0aAo+IHZt
c2Nhbi5jIHNvdXJjZSBjb2RlLgoKU28gcmVwbGFjZSBjcnlwdGljIGFiYnJldmlhdGVkIG5hbWVz
IHdpdGggc2xpZ2h0bHkgZGlmZmVyZW50CmNyeXB0aWMgYWJicmV2aWF0ZWQgbmFtZXM/IDspCgpT
dXJlLCBJIGNhbiBkbyB0aGF0Li4uCgpDaGVlcnMsCgpEYXZlLgotLSAKRGF2ZSBDaGlubmVyCmRh
dmlkQGZyb21vcmJpdC5jb20KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dp
LmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
