Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8EMlOaf151927 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 17:47:25 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BF6D415E48BA
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 15:59:58 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	yc8QLmWuaYZMaO3f for <xfs@oss.sgi.com>;
	Tue, 14 Sep 2010 15:59:58 -0700 (PDT)
Date: Wed, 15 Sep 2010 08:48:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/18] xfs: single thread inode cache shrinking.
Message-ID: <20100914224808.GD15695@dastard>
References: <1284461777-1496-1-git-send-email-david@fromorbit.com>
	<1284461777-1496-2-git-send-email-david@fromorbit.com>
	<1284490106.2098.161.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1284490106.2098.161.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

T24gVHVlLCBTZXAgMTQsIDIwMTAgYXQgMDE6NDg6MjZQTSAtMDUwMCwgQWxleCBFbGRlciB3cm90
ZToKPiBPbiBUdWUsIDIwMTAtMDktMTQgYXQgMjA6NTYgKzEwMDAsIERhdmUgQ2hpbm5lciB3cm90
ZToKPiA+IEZyb206IERhdmUgQ2hpbm5lciA8ZGNoaW5uZXJAcmVkaGF0LmNvbT4KPiA+IAo+ID4g
SGF2aW5nIG11bHRpcGxlIENQVXMgdHJ5aW5nIHRvIGRvIHRoZSBzYW1lIGNhY2hlIHNocmlua2lu
ZyB3b3JrIGNhbgo+ID4gYmUgYWN0aXZlbHkgaGFybWZ1bCB0byBwZXJmb3JhbW5jZSB3aGVuIHRo
ZSBzaHJpbmtlcnMgbGFuZCBpbiB0aGUKPiA+IHNhbWUgQUdzLiAgVGhleSB0aGVuIGxvY2tzdGVw
IG9uIHBlcmFnIGxvY2tzLCBjYXVzaW5nIGNvbnRlbnRpb24gYW5kCj4gPiBzbG93aW5nIGVhY2gg
b3RoZXIgZG93bi4gUmVjbGFpbSB3YWxraW5nIGlzIHN1ZmZpY2llbnRseSBlZmZpY2llbnQKPiA+
IHRoYXQgd2UgZG8gbm8gbmVlZCBwYXJhbGxlbGlzbSB0byBtYWtlIHNpZ25pZmljYW50IHByb2dy
ZXNzLCBzbyBzdG9wCj4gPiBwYXJhbGxlbCBhY2Nlc3MgYXQgdGhlIGRvb3IuCj4gPiAKPiA+IElu
c3RlYWQsIGtlZXAgdHJhY2sgb2YgdGhlIG51bWJlciBvZiBvYmplY3RzIHRoZSBzaHJpbmtlcnMg
d2FudAo+ID4gY2xlYW5lZCBhbmQgbWFrZSBzdXJlIHRoZSBzaW5nbGUgcnVubmluZyBzaHJpbmtl
ciBkb2VzIG5vdCBzdG9wCj4gPiB1bnRpbCBpdCBoYXMgaGl0IHRoZSB0aHJlc2hvbGQgdGhhdCB0
aGUgb3RoZXIgc2hyaW5rZXIgY2FsbHMgaGF2ZQo+ID4gYnVpbHQgdXAuCj4gPiAKPiA+IFRoaXMg
aW5jcmVhc2VzIHRoZSBjb2xkLWNhY2hlIHVubGluayByYXRlIG9mIGEgOC13YXkgcGFyYWxsZWwg
dW5saW5rCj4gPiB3b3JrbG9hZCBmcm9tIGFib3V0IDE1LDAwMCB1bmxpbmtzL3MgdG8gNjAtNzAs
MDAwIHVubGlua3MvcyBmb3IgdGhlCj4gPiBzYW1lIENQVSB1c2FnZSAofjcwMCUpLCByZXN1bHRp
bmcgaW4gdGhlIHJ1bnRpbWUgZm9yIGEgMjAwTSBpbm9kZQo+ID4gdW5saW5rIHdvcmtsb2FkIGRy
b3BwaW5nIGZyb20gNGg1MG0gdG8ganVzdCB1bmRlciAxIGhvdXIuCj4gCj4gVGhpcyBpcyBhbiBh
c2lkZSwgYnV0Li4uCj4gCj4gU2hyaW5raW5nIHN0aWxsIGhpdHMgdGhlIGZpcnN0IEFHJ3MgbW9y
ZSB0aGFuIHRoZSByZXN0LAo+IHJpZ2h0PyAgSS5lLiBpZiBBRyAwIGhhcyBucl90b19zY2FuIHJl
Y2xhaW1hYmxlIGlub2Rlcywgbm8KPiBvdGhlciBBRydzIGdldCB0aGVpciBpbm9kZXMgcmVjbGFp
bWVkPwoKSXQgYWdncmVnYXRlcyBhY3Jvc3MgYWxsIEFHcywgc28gaWYgQUcgemVybyBoYXMgbm9u
ZSwgdGhlbiBpdCBtb3Zlcwp0byBBRyAxLi4uCgpJJ20gYWN0dWFsbHkgY29uc2lkZXJpbmcgcmVz
cGlubmluZyB0aGlzIHBhdGNoIHRvIGJlIGEgbGl0dGxlCmRpZmZlcmVudC4gSSd2ZSBnb3QgYSBw
cm90b3R5cGUgdGhhdCBqdXN0IGRvZXMgYSBmdWxsIG5vbi1ibG9ja2luZwpyZWNsYWltIHJ1biBp
ZiBucl90b19zY2FuICE9IDAgYW5kIHRoZW4gcmV0dXJucyAtMS4gSXQgc2VlbXMgdG8KcmVzdWx0
IGluIG11Y2ggYmV0dGVyIGRlbnRyeS9pbm9kZS94ZnNfY2FjaGUgYmFsYW5jZSwga3N3YXBkIENQ
VQp0aW1lIGRyb3BzIGRyYW1hdGljYWxseSwgaXQgZG9lc24ndCBhZmZlY3QgY3JlYXRlIHBlcmZy
b21hbmNlIGF0IGFsbAphbmQgdW5saW5rIHBlcmZvcm1hbmNlIGJlY29tZXMgbXVjaCxtdWNoIG1v
cmUgY29uc2lzdGVudCBhbmQgZHJvcHMKZnJvbSB+MTRtMzBzIGRvd24gdG8gfjExbTMwcyBmb3Ig
NTBNIGlub2Rlcy4KCkkgb25seSBtYWRlIHRo44GXcyBjaGFuZ2UgbGF0ZSBsYXN0IG5pZ2h0LCBz
byBJJ2xsIGRvIHNvbWUgbW9yZQp0ZXN0aW5nIGJlZm9yZSBnb2luZyBhbnkgZnVydGhlciB3aXRo
IGl0LgoKQ2hlZXJzLAoKRGF2ZS4KLS0gCkRhdmUgQ2hpbm5lcgpkYXZpZEBmcm9tb3JiaXQuY29t
CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFp
bGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0
aW5mby94ZnMK
