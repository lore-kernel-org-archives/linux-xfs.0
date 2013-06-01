Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 642497F52
	for <xfs@oss.sgi.com>; Sat,  1 Jun 2013 10:51:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F1BF2AC002
	for <xfs@oss.sgi.com>; Sat,  1 Jun 2013 08:51:16 -0700 (PDT)
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id S5tx3MgpK6XQrBz9
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 01 Jun 2013 08:51:16 -0700 (PDT)
Received: by mail-pb0-f53.google.com with SMTP id un4so3728796pbc.12
	for <xfs@oss.sgi.com>; Sat, 01 Jun 2013 08:51:15 -0700 (PDT)
References: <51A8C59B.3030308@redhat.com> <20130531172456.GB6915@gmail.com>
	<51A8DACB.2030806@redhat.com> <51A8F3CE.4030801@sgi.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <51A8F3CE.4030801@sgi.com>
Message-Id: <FB8B98A4-3B44-482F-95A3-ACEDCD7FF6B5@gmail.com>
From: "gnehzuil.liu" <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] xfstests: fix seek_sanity_test for fs w/o fallocate
Date: Sat, 1 Jun 2013 23:51:11 +0800
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Rich Johnston <rjohnston@sgi.com>
Cc: Eric Sandeen <sandeen@redhat.com>, ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

1NogMjAxMy02LTGjrMnPzuczOjAyo6xSaWNoIEpvaG5zdG9uIDxyam9obnN0b25Ac2dpLmNvbT4g
0LS1wKO6Cgo+IE9uIDA1LzMxLzIwMTMgMTI6MTUgUE0sIEVyaWMgU2FuZGVlbiB3cm90ZToKPj4g
T24gNS8zMS8xMyAxMjoyNCBQTSwgWmhlbmcgTGl1IHdyb3RlOgo+Pj4gT24gRnJpLCBNYXkgMzEs
IDIwMTMgYXQgMTA6NDU6MzFBTSAtMDUwMCwgRXJpYyBTYW5kZWVuIHdyb3RlOgo+Pj4+IGN1cnJl
bnRseSB0aGUgc2Vla19zYW5pdHlfdGVzdCAoZ2VuZXJpYy8yODUpIGZhaWxzIG9uIGV4dDMKPj4+
PiBvciBleHQyIGR1ZSB0byBmYWxsb2NhdGUoKSBmYWlsdXJlcy4gIEp1c3QgaWdub3JlIHRoYXQg
dGVzdAo+Pj4+IGlmIHRoZSBmcyBkb2Vzbid0IHN1cHBvcnQgZmFsbG9jYXRlLgo+Pj4gCj4+PiBI
aSBFcmljLAo+Pj4gCj4+PiBJIHJlbWVtYmVyIHRoYXQgbXkgcGF0Y2ggaGFkIGJlZW4gYXBwbGll
ZCBbMV0uICBCdXQgc3RyYW5nZXIgSSBjb3VsZG4ndAo+Pj4gZmluZCBpdCBpbiB4ZnN0ZXN0cyB0
cmVlLiAgSG93ZXZlciwgSSB0aGluayB0aGF0IHlvdXIgcGF0Y2ggaXMgYmV0dGVyLgo+Pj4gCj4+
PiAxLiBodHRwOi8vb3NzLnNnaS5jb20vYXJjaGl2ZXMveGZzLzIwMTMtMDUvbXNnMDA1MzQuaHRt
bAo+PiAKPj4gT2gsIHJpZ2h0LCBJIGhhZCBmb3Jnb3R0ZW4gYWJvdXQgdGhhdC4gIFJpY2gsIGFu
eSBpZGVhPwo+IAo+IE5vIG90aGVyIHRoYW4gaXQgd2FzIGEgRnJpZGF5LiAgTXkgYXBvbG9naWVz
IFpoZW5nLgo+IFpoZW5nIGFzIHlvdXIncyBzaG91bGQgaGF2ZSBiZWVuIGNvbW1pdHRlZCwgd2hh
dCBkbyB5b3Ugd2FudCBtZSB0byBkbz8KCkhpIFJpY2gsCgpTb3JyeSBmb3IgbXkgbGF0ZSByZXBs
eS4gIEFzIEVyaWMgc2FpZCwgcGxlYXNlIGFwcGx5IGhpcyBwYXRjaCBiZWNhdXNlIGl0IGlzIGJl
dHRlci4KClRoYW5rcywKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgLSBaaGVuZwpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20v
bWFpbG1hbi9saXN0aW5mby94ZnMK
