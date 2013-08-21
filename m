Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0F8DB7CBF
	for <linux-xfs@oss.sgi.com>; Tue, 20 Aug 2013 19:07:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 80467AC002
	for <linux-xfs@oss.sgi.com>; Tue, 20 Aug 2013 17:07:10 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	N3IvszEAky7U9wYR for <linux-xfs@oss.sgi.com>;
	Tue, 20 Aug 2013 17:07:08 -0700 (PDT)
Date: Wed, 21 Aug 2013 10:07:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_repair: add prototype for alloc_ex_data()
Message-ID: <20130821000704.GP6023@dastard>
References: <5213F849.7080308@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5213F849.7080308@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>, Mark Tinguely <tinguely@sgi.com>

T24gVHVlLCBBdWcgMjAsIDIwMTMgYXQgMDY6MTQ6MTdQTSAtMDUwMCwgRXJpYyBTYW5kZWVuIHdy
b3RlOgo+IDNhYzg3ZmJmIHhmc3Byb2dzOiBmaXggaW5vZGUgY3Jhc2ggaW4geGZzX3JlcGFpcgo+
IAo+IHVuLXN0YXRpYydkIGFsbG9jX2V4X2RhdGEgYW5kIHVzZWQgaXQgaW4gcGhhc2U2LmMsCj4g
YnV0IGRpZG4ndCBwdXQgYSBwcm90b3R5cGUgaW4gYSBoZWFkZXIsIHNvOgo+IAo+ICBwaGFzZTYu
YzogSW4gZnVuY3Rpb24g4oCYbWtfb3JwaGFuYWdl4oCZOgo+ICBwaGFzZTYuYzo5NDM6IHdhcm5p
bmc6IGltcGxpY2l0IGRlY2xhcmF0aW9uIG9mIGZ1bmN0aW9uIOKAmGFsbG9jX2V4X2RhdGHigJkK
PiAKPiBGaXggaXQuLi4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBFcmljIFNhbmRlZW4gPHNhbmRlZW5A
cmVkaGF0LmNvbT4KPiAtLS0KPiAKPiBkaWZmIC0tZ2l0IGEvcmVwYWlyL2luY29yZS5oIGIvcmVw
YWlyL2luY29yZS5oCj4gaW5kZXggOGE1NzhiNS4uMzhjYWE2ZCAxMDA2NDQKPiAtLS0gYS9yZXBh
aXIvaW5jb3JlLmgKPiArKysgYi9yZXBhaXIvaW5jb3JlLmgKPiBAQCAtNDgzLDYgKzQ4MywxMSBA
QCB2b2lkCQlzZXRfaW5vZGVfcGFyZW50KGlub190cmVlX25vZGVfdCAqaXJlYywgaW50IGlub19v
ZmZzZXQsCj4gIHhmc19pbm9fdAlnZXRfaW5vZGVfcGFyZW50KGlub190cmVlX25vZGVfdCAqaXJl
YywgaW50IGlub19vZmZzZXQpOwo+ICAKPiAgLyoKPiArICogQWxsb2NhdGUgZXh0cmEgaW5vZGUg
ZGF0YQo+ICsgKi8KPiArdm9pZAkJYWxsb2NfZXhfZGF0YShpbm9fdHJlZV9ub2RlX3QgKmlyZWMp
Owo+ICsKPiArLyoKPiAgICogYm1hcCBjdXJzb3IgZm9yIHRyYWNraW5nIGFuZCBmaXhpbmcgYm1h
cCBidHJlZXMuICBBbGwgeGZzIGJ0cmVlcyBudW1iZXIKPiAgICogdGhlIGxldmVscyB3aXRoIDAg
YmVpbmcgdGhlIGxlYWYgYW5kIGV2ZXJ5IGxldmVsIHVwIGJlaW5nIDEgZ3JlYXRlci4KPiAgICov
CgpMb29rcyBnb29kLgoKUmV2aWV3ZWQtYnk6IERhdmUgQ2hpbm5lciA8ZGNoaW5uZXJAcmVkaGF0
LmNvbT4KCi0tIApEYXZlIENoaW5uZXIKZGF2aWRAZnJvbW9yYml0LmNvbQoKX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNA
b3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
