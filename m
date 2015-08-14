Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CDB9529DF6
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 19:07:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B91CE304043
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 17:07:37 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	MxZPYOkPcbQgCipE for <xfs@oss.sgi.com>;
	Thu, 13 Aug 2015 17:07:35 -0700 (PDT)
Date: Fri, 14 Aug 2015 10:03:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Looking to confirm issue and seek advice on fix for inode btree
	fragmentation
Message-ID: <20150814000303.GR3902@dastard>
References: <CA+muJ0thea8xOJB8c2CJj1GAVa48EUvRYf7-3oS_zYc+T5R6yg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+muJ0thea8xOJB8c2CJj1GAVa48EUvRYf7-3oS_zYc+T5R6yg@mail.gmail.com>
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
To: Pippin Wallace <nippip@gmail.com>
Cc: xfs@oss.sgi.com

T24gVGh1LCBBdWcgMTMsIDIwMTUgYXQgMDU6MzU6MzFQTSAtMDYwMCwgUGlwcGluIFdhbGxhY2Ug
d3JvdGU6Cj4gSSBhbSB3cml0aW5nIHRvIGNvbmZpcm0gdGhlIGlzc3VlIEkgdGhpbmsgSSBoYXZl
IGFuZCBnZXQgYWR2aWNlIG9uIHRoZSBiZXN0Cj4gc2hvcnQgdGVybSBhbmQgbG9uZyB0ZXJtIOKA
nGZpeGVz4oCdLgo+IAo+IAo+IAo+IEluIHJlYWRpbmcgdGhlIGZvbGxvd2luZyB0aHJlYWRzIGFu
ZCBvdGhlcnMgSSBhbSBwcmV0dHkgc3VyZSBJIGhhdmUgaW5vZGUKPiBidHJlZSBmcmFnbWVudGF0
aW9uIGFuZCBJIGhhdmUgaW5jbHVkZWQgZGV0YWlsZWQgb3V0cHV0IGJlbG93IHRvIGhlbHAKPiBj
b25maXJtIHRoaXMuCgpNYWtlIGEgbmV3IGZpbGVzeXN0ZW0gd2l0aCBhIGN1cnJlbnQgeGZzcHJv
Z3MgMy4yLjQsIGFuZCBpdCB3aWxsIHVzZQp0aGUgbmV3IGZyZWUgaW5vZGUgYnRyZWUgZm9yIGFs
bG9jYXRpb24gdGhhdCB3YXMgZGVzaWduZWQgdG8gYXZvaWQKdGhpcyBwcm9ibGVtLgoKPiBMb25n
IHRlcm0gZml4IGlzIHVwZ3JhZGUga2VybmVsIHRvID49IDMuMTYsIHhmc3Byb2dzID49My4yLjEg
YW5kIHJlYnVpbGQgZnMKPiB3aXRoIG5ldyBmaW5vYnQgc3RydWN0dXJlLgo+IAo+ICAgICAgICAg
IyBta2ZzLnhmcyAtbSBjcmM9MSxmaW5vYnQ9MSA8ZGV2PgoKaS5lLiB0aGVyZSBhcmUgdGhlIGRl
ZmF1bHQgbWtmcyBvcHRpb25zIGluIHhmc3Byb2dzID49IDMuMi4zLgoKSXQncyByZWFsbHkgdGhl
IG9ubHkgdmlhYmxlIGZpeCwgZXNwZWNpYWxseSBnaXZlbiB0aGF0IHlvdSBjYW4ndCB1c2UKaW5v
ZGU2NC4gQW5kLCByZWFsaXN0aWNhbGx5LCBpdCdzIHN0aWxsIGdvaW5nIHRvIGNhdXNlIHByb2Js
ZW1zCnVubGVzcyB5b3UgZW5zdXJlIHRoYXQgeW91IGhhdmUgc21hbGxlci10aGFuLWRlZmF1bHQg
QUdzIChlLmcuIDI1MEdCCkFHcykgc28gdGhhdCB0aGVyZSBhcmUgbXVsdGlwbGUgaW5vZGUgYnRy
ZWVzIGluIHRoZSAzMi1iaXQgaW5vZGUKbnVtYmVyIHJlZ2lvbiBvZiB0aGUgZmlsZXN5c3RlbS4o
KikKCigqKSB3aGljaCBpcyBhY3R1YWxseSB0aGUgZmlyc3QgMlRCIG9mIHRoZSBmaWxlc3lzdGVt
IHdpdGggQ1JDCmVuYWJsZWQgZmlsZXN5c3RlbXMgYmVjYXVzZSB0aGUgaW5vZGUgc2l6ZSBpcyA1
MTIgYnl0ZXMuLi4KCj4gKktFUk5FTCBPUFRJT05TOiBXaGljaCBvZiB0aGVzZSBrZXJuZWxzIHNo
b3VsZCBJIGNob29zZSBmb3IgdGhlIGJlc3QgWEZTCj4gc3VwcG9ydCBmb3IgdGhpcyBpc3N1ZT8q
CgpPbmUgeW91ciBkaXN0cm8gdmVuZG9yIHN1cHBvcnRzOyB0aGUgbmV3ZXIgdGhlIGJldHRlci4K
CkNoZWVycywKCkRhdmUuCi0tIApEYXZlIENoaW5uZXIKZGF2aWRAZnJvbW9yYml0LmNvbQoKX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcg
bGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8v
eGZzCg==
