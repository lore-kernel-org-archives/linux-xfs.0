Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D8F407F6F
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2015 19:51:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C93E98F8068
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2015 17:51:52 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	VDGuDS8BENIkIaEB for <xfs@oss.sgi.com>;
	Thu, 20 Aug 2015 17:51:50 -0700 (PDT)
Date: Fri, 21 Aug 2015 10:43:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/11] xfsprogs: missing and dummy calls for OS X support
Message-ID: <20150821004326.GW714@dastard>
References: <1439828606-7886-1-git-send-email-jtulak@redhat.com>
	<1439828606-7886-6-git-send-email-jtulak@redhat.com>
	<20150818214557.GC3902@dastard>
	<20150819080940.GA13130@infradead.org>
	<20150819102623.GK3902@dastard> <20150820002251.GN3902@dastard>
	<CACj3i70p4mfqs9HZbxzbnJaGXB=vxNHPUggx183Z_yLYHdP9PA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CACj3i70p4mfqs9HZbxzbnJaGXB=vxNHPUggx183Z_yLYHdP9PA@mail.gmail.com>
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
To: Jan Tulak <jtulak@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

T24gVGh1LCBBdWcgMjAsIDIwMTUgYXQgMDk6MzM6MzNBTSArMDIwMCwgSmFuIFR1bGFrIHdyb3Rl
Ogo+IE9uIFRodSwgQXVnIDIwLCAyMDE1IGF0IDI6MjIgQU0sIERhdmUgQ2hpbm5lciA8ZGF2aWRA
ZnJvbW9yYml0LmNvbT4gd3JvdGU6Cj4gCj4gPiBPbiBXZWQsIEF1ZyAxOSwgMjAxNSBhdCAwODoy
NjoyM1BNICsxMDAwLCBEYXZlIENoaW5uZXIgd3JvdGU6Cj4gPiA+IE9uIFdlZCwgQXVnIDE5LCAy
MDE1IGF0IDAxOjA5OjQwQU0gLTA3MDAsIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOgo+ID4gPiA+
IE9uIFdlZCwgQXVnIDE5LCAyMDE1IGF0IDA3OjQ1OjU3QU0gKzEwMDAsIERhdmUgQ2hpbm5lciB3
cm90ZToKPiA+ID4gPiA+IEhtbW0sIGxvb2tzIGxpa2UgSSBhY2NpZGVudGFsbHkgY29taXR0ZWQg
YW4gZWFybGllciB2ZXJzaW9uIG9mIHRoaXMKPiA+ID4gPiA+IHBhdGNoIHllc3RlcmRheS4gSmFu
LCBjYW4geW91IHNlbmQgZGVsdGEgcGF0Y2hlcyB0byB3aGF0IEkgY29tbWl0dGVkCj4gPiA+ID4g
PiB0byBhZGRyZXNzIG1vcmUgcmVjZW50IHJldmlldyBjb21tZW50cz8gU29ycnksIG15IGJhZC4K
PiA+ID4gPgo+ID4gPiA+IENhbiB5b3UgcmV2ZXJ0IGl0IGZvciBub3c/IEkgdGhpbmsgbW9zdCBv
ZiB0aGVzZSBjaGFuZ2VzIGFyZSBpbmNvcnJlY3QKPiA+ID4gPiBhbmQgc2hvdWxkIGVpdGhlciBi
ZSBkcm9wcGVkIGZvciBub3cgYnkgZGlzYWJsaW5nIGZzeCBvciB3aWxsIG5lZWQKPiA+ID4gPiBh
IG1ham9yIHJld29yay4KPiA+ID4KPiA+ID4gSSdsbCBqdXN0IHJlYmFzZSB0aGUgZm9yLW5leHQg
YnJhbmNoLCBJIGd1ZXNzLCBhbmQgcmVtb3ZlIGl0Cj4gPiA+IGNvbXBsZXRlbHkgZnJvbSB0aGUg
aGlzdG9yeS4gSSd2ZSBnb3QgYW5vdGhlciBsb2NrZGVwIGZpeCB0aGF0IG5lZWRzCj4gPiA+IHRv
IGJlIHB1c2hlZCBiZWZvcmUgaXQgYWxsIGhpdHMgdG9tb3Jyb3cncyBsaW51eC1uZXh0IGJ1aWxk
LCBhbnl3YXkuCj4gPgo+ID4gR2V0dGluZyBteSB0cmVlcyBtaXhlZCB1cC4gSSdsbCByZXZlcnQg
dGhlIHBhdGNoIG9uIHRoZSBuZXh0IHB1c2guCj4gCj4gCj4g4oCLQW5kIGFzIEkgbm90aWNlZCwg
Jwo+IHhmc3Byb2dzOiBBZGQgaW5jbHVkZXMgcmVxdWlyZWQgZm9yIE9TIFggYnVpbGRzCj4g4oCL
JyB3YXMg4oCLYWxzbwo+IHNlbGVjdGVkIGluIGFuIG9sZGVyIHZlcnNpb24uIE90aGVyIHBhdGNo
ZXMgbG9va3MgT0ssIHRob3VnaC4gOi0pCj4gU2hvdWxkIEkgc2VuZCBkZWx0YSBwYXRjaCBmb3Ig
dGhhdCBvbmU/IEl0IGlzIGp1c3QgYWJvdXQgdGhyZWUgI2luY2x1ZGVzLgoKWWVzLgoKQ2hlZXJz
LAoKRGF2ZS4KLS0gCkRhdmUgQ2hpbm5lcgpkYXZpZEBmcm9tb3JiaXQuY29tCgpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhm
c0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
