Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7J1o5oG141890 for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 20:50:06 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5FDC7CE7376
	for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 18:59:55 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	6OMyqd4icN27ykmg for <xfs@oss.sgi.com>;
	Wed, 18 Aug 2010 18:59:55 -0700 (PDT)
Date: Thu, 19 Aug 2010 11:50:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: kernel bug in xfs_lrw.c (centos v5.5, directio, aio)
Message-ID: <20100819015029.GQ7362@dastard>
References: <alpine.LNX.2.00.1008171906220.21398@mahi.cmie.ernet.in>
	<20100818114305.GR10429@dastard>
	<341C002D-C57C-4F73-8B36-5D12B0B91CD5@sandeen.net>
	<20100819013433.GP7362@dastard>
	<040DE437-1D0C-45F1-8CC7-CD11D49B6E53@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <040DE437-1D0C-45F1-8CC7-CD11D49B6E53@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Nohez <nohez@cmie.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

T24gV2VkLCBBdWcgMTgsIDIwMTAgYXQgMDg6Mzg6MzNQTSAtMDUwMCwgRXJpYyBTYW5kZWVuIHdy
b3RlOgo+IE9uIEF1ZyAxOCwgMjAxMCwgYXQgODozNCBQTSwgRGF2ZSBDaGlubmVyIDxkYXZpZEBm
cm9tb3JiaXQuY29tPiB3cm90ZToKPiAKPiA+IE9uIFdlZCwgQXVnIDE4LCAyMDEwIGF0IDA3OjQ3
OjA5UE0gLTA1MDAsIEVyaWMgU2FuZGVlbiB3cm90ZToKPiA+PiBPbiBBdWcgMTgsIDIwMTAsIGF0
IDY6NDMgQU0sIERhdmUgQ2hpbm5lciA8ZGF2aWRAZnJvbW9yYml0LmNvbT4gd3JvdGU6Cj4gPj4g
Cj4gPj4+IE9uIFR1ZSwgQXVnIDE3LCAyMDEwIGF0IDA3OjEyOjEyUE0gKzA1MzAsIE5vaGV6IHdy
b3RlOgo+ID4+Pj4gCj4gPj4+PiBIaSwKPiA+Pj4+IAo+ID4+Pj4gSSBoYWQgYSBrZXJuZWwgYnVn
IHRvZGF5IHdoZW4gcnVubmluZyB4ZnMgb24gQ2VudE9TIHY1LjUuIEkgbW92ZWQgdG8KPiA+Pj4+
IHhmcyBmcm9tIGV4dDMgdG9kYXkuCj4gPj4+PiAKPiA+Pj4+IFRoZSBvbmx5IGFwcGxpY2F0aW9u
IGFjY2Vzc2luZyB0aGUgeGZzIGZpbGVzeXN0ZW0gaXMgU3liYXNlIEFTRSB2MTUueC4KPiA+Pj4+
IERhdGFiYXNlIGhhcyBiZWVuIGNvbmZpZ3VyZWQgdG8gdXNlIGRpcmVjdGlvIHdpdGggbmF0aXZl
IGtlcm5lbAo+ID4+Pj4gYXN5bmNocm9ub3VzIGRpc2sgaS9vIGVuYWJsZWQuCj4gPj4+IAo+ID4+
PiBUaGUgd2FybmluZyBpcyBiZWluZyBpc3N1ZWQgYmVjYXVzZSB0aGUgYXBwbGljYXRpb24gaXMg
bWl4aW5nCj4gPj4+IGJ1ZmZlcmVkIElPIHdpdGggZGlyZWN0IElPIG9uIHRoZSBzYW1lIGZpbGUu
IGkuZS4gZGF0YSBjb3JydXB0aW9uCj4gPj4+IHdhaXRpbmcgdG8gaGFwcGVuLiBUaGlzIGlzIGFu
IGFwcGxpY2F0aW9uIGJ1ZyAtIHRoZSByZXNwb25zaWJpbGl0eQo+ID4+PiBmb3IgZW5zdXJpbmcg
ZGF0YSBjb2hlcmVuY3kgYW5kIGludGVncml0eSBpcyBhc3N1bWVkIGJ5IHRoZQo+ID4+PiBhcHBs
aWNhdGlvbiBpc3N1aW5nIHRoZSBkaXJlY3QgSU8uCj4gPj4+IAo+ID4+IFlvdSBrbm93Li4uIEEg
Y2xlYXJlciBrZXJuZWwgbWVzc2FnZSBtaWdodCBoZWxwIGEgbG90IGhlcmUuLi4KPiA+IAo+ID4g
WWVhaCwgcHJvYmFibHkgd291bGQgZ2l2ZW4gd2UndmUgaGFkIG1vcmUgcmVwb3J0cyBvZiB0aGlz
IGluIHRoZQo+ID4gbGFzdCBtb250aCBvciB0d28gdGhhbiB3ZSd2ZSBoYWQgaW4gdGhlIGxhc3Qg
Zml2ZSB5ZWFycy4gV2hhdCBzb3J0Cj4gPiBvZiB0ZXh0IGRvIHlvdSB0aGluayB3ZSBzaG91bGQg
YWRkPyBJJ2QgYXJndWUgb24gdGhlIHNjYXJ5IHNpZGUsCj4gPiBzYXk6Cj4gPiAKPiA+ICJYRlM6
IGZpbGVzeXN0ZW0g4oypYmxhaD46IGRldGVjdGVkIHBvdGVudGlhbCBkYXRhIGNvcnJ1cHRpb24g
aXNzdWUKPiA+IGNhdXNlZCBieSBhcHBsaWNhdGlvbihzKSBtaXhpbmcgY29uY3VycmVudCBidWZm
ZXJlZCBhbmQgZGlyZWN0IElPIHRvCj4gPiB0aGUgc2FtZSBpbm9kZS4gSW5vZGUgIzEyMzQ1LCBw
aWQgNjc4OS4gUGxlYXNlIHJlcG9ydCB0aGlzIGlzc3VlCj4gPiB0byB5b3VyIGFwcGxpY2F0aW9u
IHZlbmRvci4iCj4gPiAKPiA+IFdoYXQgZG8geW91IHRoaW5rPwo+ID4gCj4gUGxlbnR5IHZlcmJv
c2UsIG1pZ2h0IHdhbnQgdG8gbGltaXQvdGhyb3R0bGUgaXQsIGJ1dCBzdXJlLgoKUmF0ZSBsaW1p
dGluZyBpdCBpcyBhIGdvb2QgaWRlYSwgYW55d2F5LiBIb3cgYWJvdXQgdGhpczoKCiJYRlM6IDxk
ZXY+OiBpbm9kZSA8Iz46IHBpZCA8Iz4gPG5hbWU+OiBkZXRlY3RlZCBwb3RlbnRpYWwgZGF0YQpj
b3JydXB0aW9uIGlzc3VlIGR1ZSB0byBjb25jdXJyZW50IGJ1ZmZlcmVkIGFuZCBkaXJlY3QgSU8g
dG8gdGhlCnNhbWUgaW5vZGUuIFBsZWFzZSByZXBvcnQgdGhpcyBpc3N1ZSB0byB5b3VyIGFwcGxp
Y2F0aW9uIHZlbmRvci4iCgo+IE1heWJlIGluY2x1ZGUgY3VycmVudC0+Y29tbT8KClllcywgSSB0
aG91Z2h0IGFib3V0IHRoYXQgYnV0IGhhZG4ndCBnb25lIGxvb2tpbmcgdG8gZmluZCBvdXQgaG93
CmVhc3kgaXQgd2FzIHRvIGdldCB0aGUgcHJvY2VzcyBuYW1lLgoKQ2hlZXJzLAoKRGF2ZS4KLS0g
CkRhdmUgQ2hpbm5lcgpkYXZpZEBmcm9tb3JiaXQuY29tCgpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNv
bQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
