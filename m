Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4820D7F56
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 10:03:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 36F438F8040
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 08:03:08 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id 1N3bIndv96ZeKH8E (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Jun 2014 08:03:06 -0700 (PDT)
Date: Mon, 2 Jun 2014 11:02:58 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 0/10] fs: Introduce FALLOC_FL_INSERT_RANGE for fallocate
Message-ID: <20140602150258.GG30598@thunk.org>
References: <003601cf6aa7$883103b0$98930b10$@samsung.com>
	<alpine.LFD.2.00.1405301238190.2009@localhost.localdomain>
	<000d01cf7ca3$98335c50$c89a14f0$@samsung.com>
	<alpine.LFD.2.00.1406021204540.2231@localhost.localdomain>
	<002201cf7e59$2e684c10$8b38e430$@samsung.com>
	<alpine.LFD.2.00.1406021450541.2231@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1406021450541.2231@localhost.localdomain>
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
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Cc: Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, 'Ashish Sangwan' <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, 'linux-ext4' <linux-ext4@vger.kernel.org>

T24gTW9uLCBKdW4gMDIsIDIwMTQgYXQgMDM6MDY6MTNQTSArMDIwMCwgTHVrw6HFoSBDemVybmVy
IHdyb3RlOgo+ID4gPiBTbyB3aGF0IHdpbGwgaGFwcGVuIHdoZW4gdGhlcmUgaXMgbm90IGVub3Vn
aCBzcGFjZSB3aGVuICJpbnNlcnRpbmcgYQo+ID4gPiByYW5nZSIgPyBBbmQgaG93IHNob3VsZCB1
c2VyIHByb2NlZWQgZnJvbSB0aGVyZSA/Cj4gPiBJZiBpbnNlcnQgcmFuZ2UgZmFpbHMgd2l0aCBh
biBFTk9TUEMgZXJyb3IsIHVzZXIgY291bGQgdXNlIGNvbGxhcHNlCj4gPiByYW5nZSBvbiB0aGUg
c2FtZSByYW5nZSB0byByZW1vdmUgdGhlIGhvbGUuCj4gPiBBbmQgYWZ0ZXIgZnJlZWluZyBtb3Jl
IHNwYWNlLCBoZSBjYW4gYWdhaW4gdHJ5IGluc2VydGluZyByYW5nZS4KPiA+IE9mY291cnNlLCB0
aGlzIHR5cGUgb2YgZ3VpZGFuY2Ugc2hvdWxkIGJlIHByb3Blcmx5IGRvY3VtZW50ZWQgaW4KPiA+
IG1hbnBhZ2UuIFdoZW4gdXBkYXRpbmcgZmFsbG9jYXRlKDIpIG1hbnBhZ2UsIEkgd2lsbCBrZWVw
ICBpbiBtaW5kIHRvCj4gPiBkZXNjcmliZSBFTk9TUEMgaGFuZGxpbmcuCj4gCj4gV2h5IGNvbGxh
cHNlID8gVGhlIGhvbGUgaXMgYWxyZWFkeSB0aGVyZSByaWdodCA/IFdoeSBub3QganVzdCB1c2UK
PiBmYWxsb2NhdGUgdG8gYWxsb2NhdGUgdGhlIHNwYWNlIGZvciB0aGUgaG9sZS4gQW5kIHRoYXQn
cyBteSBwb2ludAo+IGFjdHVhbGx5LiBXaHkgbm90IGRvIGl0IHRoaXMgd2F5IGluIHRoZSBmaXJz
dCBwbGFjZSwgYmVjYXVzZSB0aGlzIGlzCj4gcmVhbGx5IGNvdW50ZXJpbnR1aXRpdmUuCgpJdCdz
IHdvcnNlIHRoYW4gdGhhdC4gIEl0J3MgcG9zc2libGUgdGhhdCB0aGUgcmVhc29uIHdoeSB5b3Ug
Z290IHRoZQpFTk9TUEMgd2FybmluZyB3YXMgYmVjYXVzZSB0aGUgb3BlcmF0aW9uIHRvIG1vdmUg
dGhlIGV4dGVudHMgZG93bgpyZXF1aXJlZCBhbGxvY2F0aW5nIGEgYmxvY2ssIGFuZCBpdCB3YXMg
KnRoYXQqIGJsb2NrIGFsbG9jYXRpb24gd2hpY2gKZmFpbGVkLiAgU28gaXQncyBub3QgZGV0ZXJt
aW5pc3RpYyB3aGV0aGVyIG9yIG5vdCB0aGUgZmlsZSdzIGV4dGVudAptYXBwaW5ncyB3ZXJlIG1v
ZGlmaWVkIGFmdGVyIGEgRU5PU1BDIGVycm9yLCBhbmQgc28gaXQncyBub3QgY2xlYXIKd2hldGhl
ciBvciBub3QgYSBjb2xsYXBzZV9yYW5nZSBmdW5jdGlvbiB3aWxsIHVuZG8gdGhlIHJhbmdlIHRo
YXQgaGFkCmJlZW4gaW5zZXJ0ZWQgLS0tIG9yIHdoZXRoZXIgaXQgZW5kcyB1cCBkZWxldGluZyBl
eGlzdGluZyBkYXRhIGJsb2Nrcy4KCkluIGdlbmVyYWxseSwgeW91IHJlYWxseSB3YW50IHN5c3Rl
bSBjYWxscyB0byBoYXZlIGFsbC1vci1ub3RoaW5nCmVmZmVjdHMsIHdoZXJlIGlmIHRoZSBzeXN0
ZW0gY2FsbCByZXR1cm5zIGFuIGVycm9yLCB0aGUgc3RhdGUgb2YgdGhlCmZpbGUgaGFzIG5vdCBi
ZWVuIGNoYW5nZWQuICBBbmQgZm9yIHRoYXQgcmVhc29uLCBJIGFncmVlIHdpdGggTHVrw6HFoQp0
aGF0IGl0IGlzIHJlYWxseSBhIGdvb2QgaWRlYSB0byBkZWNvdXBsZSBtb3ZpbmcgdGhlIGJsb2Nr
cyBkb3duLCBhbmQKYWxsb2NhdGluZyBzcGFjZSAtLS0gYW5kIHRvIG1ha2Ugc3VyZSB0aGF0IGlm
IHRoZXJlIGlzIGFueSBmYWlsdXJlCndoaWxlIGluc2VydGluZyB0aGUgcmFuZ2UsIHRoZSBzdGF0
ZSBvZiB0aGUgZmlsZSBpcyBub3QgbW9kaWZpZWQgYXQgYWxsLgoKQ2hlZXJzLAoKCQkJCQktIFRl
ZAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1h
aWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlz
dGluZm8veGZzCg==
