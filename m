Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6A4EF7F78
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 20:32:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4A631304051
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 18:32:44 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	KwBCQsTQxiwbRPEk for <xfs@oss.sgi.com>;
	Mon, 29 Jun 2015 18:32:38 -0700 (PDT)
Date: Tue, 30 Jun 2015 11:32:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/17] mkfs: getbool is redundant
Message-ID: <20150630013217.GI7943@dastard>
References: <1434711726-13092-1-git-send-email-jtulak@redhat.com>
	<1434711726-13092-9-git-send-email-jtulak@redhat.com>
	<20150626171701.GD40750@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150626171701.GD40750@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>, Jan =?utf-8?B?xaR1bMOhaw==?= <jtulak@redhat.com>

T24gRnJpLCBKdW4gMjYsIDIwMTUgYXQgMDE6MTc6MDFQTSAtMDQwMCwgQnJpYW4gRm9zdGVyIHdy
b3RlOgo+IE9uIEZyaSwgSnVuIDE5LCAyMDE1IGF0IDAxOjAxOjU3UE0gKzAyMDAsIEphbiDFpHVs
w6FrIHdyb3RlOgo+ID4gRnJvbTogRGF2ZSBDaGlubmVyIDxkY2hpbm5lckByZWRoYXQuY29tPgo+
ID4gCj4gPiBnZXRib29sKCkgY2FuIGJlIHJlcGxhY2VkIHdpdGggZ2V0bnVtX2NoZWNrZWQgd2l0
aCBhcHByb3ByaWF0ZQo+ID4gbWluL21heCB2YWx1ZXMgc2V0IGZvciB0aGUgYm9vbGVhbiB2YXJp
YWJsZXMuCj4gPiAKPiA+IFNpZ25lZC1vZmYtYnk6IERhdmUgQ2hpbm5lciA8ZGNoaW5uZXJAcmVk
aGF0LmNvbT4KPiA+IFNpZ25lZC1vZmYtYnk6IEphbiDFpHVsw6FrIDxqdHVsYWtAcmVkaGF0LmNv
bT4KLi4uLgo+ID4gIAkJfSwKPiA+ICAJCXsgLmluZGV4ID0gUl9OQU1FLAo+ID4gKwkJICAuZGVm
YXVsdHZhbCA9IFNVQk9QVF9ORUVEU19WQUwsCj4gPiAgCQl9LAo+ID4gIAkJeyAuaW5kZXggPSBS
X05PQUxJR04sCj4gPiArCQkgIC5kZWZhdWx0dmFsID0gU1VCT1BUX05FRURTX1ZBTCwKPiAKPiBO
b3Qgc3VyZSBhYm91dCB0aGlzIG9uZSwgZWl0aGVyLiBUaGVyZSdzIG5vIHZhbHVlIGFjY29yZGlu
ZyB0byB0aGUgbWFuCj4gcGFnZS4KCktlZXAgaW4gbWluZCBvbmUgb2YgdGhlIHJlYXNvbnMgZm9y
IGRvaW5nIHRoaXMgY2xlYW51cCBpcyB0byBtYWtlCmFsbCB0aGUgb3B0aW9ucyBjb25zaXN0ZW50
IGluIHRoZWlyIGhhbmRsaW5nLiBpLmUuIGFsbCBib29sZWFuCm9wdGlvbnMgd2lsbCB0YWtlIGEg
MCBvciAxIHZhbHVlLCByZWdhcmRsZXNzIG9mIHdoZXRoZXIgdGhleQpjdXJyZW50bHkgcmVxdWly
ZSBpdCBvciBub3QuCgppLmUuIHRoaXMgcGF0Y2hzZXQgY2hhbmdlcyB0aGUgbWtmcyBDTEkgaW50
ZXJmYWNlIHRvIGZpeAppbmNvbnNpc3RlbmNpZXMgdGhhdCBoYXZlIGNyZXB0IGluIG92ZXIgdGhl
IHllYXJzLi4uLgoKQ2hlZXJzLAoKRGF2ZS4KLS0gCkRhdmUgQ2hpbm5lcgpkYXZpZEBmcm9tb3Ji
aXQuY29tCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4
ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1h
bi9saXN0aW5mby94ZnMK
