Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o58FI5tZ010771 for <xfs@oss.sgi.com>; Tue, 8 Jun 2010 10:18:05 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4A07B11B0528
	for <xfs@oss.sgi.com>; Thu, 29 Jul 2010 16:03:30 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	r6XLCT6q94Lzqodi for <xfs@oss.sgi.com>;
	Thu, 29 Jul 2010 16:03:30 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: fix bugs uncovered by dbench testing
Date: Fri, 30 Jul 2010 08:55:44 +1000
Message-Id: <1280444146-14540-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
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
To: xfs@oss.sgi.com
Cc: npiggin@kernel.de

VGhlIHJlcHJvZHVjZXIgTmljayBmb3VuZCB0aGF0IGh1bmcgdGhlIFhGUyBmaWxlc3lzdGVtIGhh
cyB0d28KZGlmZmVyZW50IGNhdXNlcy4gQm90aCBtYW5pZmVzdCBpbiB0aGUgc2FtZSB3YXksIHNv
IGl0IHdhcyBkaWZmaWN1bHQgdG8gdGVsbAp0aGVtIGFwYXLhuasgLSB0aGV5IGxlZnQgYW4gaXRl
bSB0aGF0IGNvdWxkIG5vdGJlIGZsdXNoZWQgc3R1Y2sgaW4gdGhlIEFJTCBhbmQKaGVuY2UgcHJl
dmVudGluZyB0aGUgdGFpbCBvZiB0aGUgbG9nIGZyb20gYmVpbmcgbW92ZWQgZm9yd2FyZC4KClRo
ZSBtb3N0IGZyZXF1ZW50bHkgdHJpcHBlZCBwcm9ibGVtIChnZW5lcmFsbHkgd2l0aGluIDUgbWlu
dXRlcykgd2FzIHRoZSBDSUwKY29tbWl0IHJhY2Ugd2hlbiB0aGUgY2hlY2twb2l0biBjb3VsZCBj
b21taXQgYmVmb3JlIHRoZSB0cmFuc2FjdGlvbiBpdGVtcyB3ZXJlCnVubG9ja2VkLCByZXN1bHRp
bmcgaW4gc3RhbGUgaW5mb3JtYXRpb24gaW4gbG9nIGl0ZW1zIGFuZCBpbmNvcnJlY3QgcHJvY2Vz
c2luZwpvZiBzdGFsZSBidWZmZXJzLiBJIGNvdWwgZG5vdCByZXByb2R1Y2UgdGhpcyByYWNlIGNv
bmRpdGlvbiB3aXRoIGEgZGVidWcKa2VybmVsLCB3aGljaCBleHBsYWluIHdoeSBteSBwcmV2aW91
cyBkYmVuY2ggdGVzdGluZyBkaWQgbm90IHVuY292ZXIgaXQuCgpMZXNzIGZyZXF1ZW50bHkgdHJp
cHBlZCB3YXMgdGhlIGlub2RlIGNsdXN0ZXIgZnJlZWluZyBwcm9ibGVtIC0gaXQgd291bGQgdGFr
ZQphcm91bmQgMiBob3VycyBvbiBhdmVyYWdlIHRvIHRyaXAgdGhpcyBvbmUsIGFuZCBpdCBkb2Vz
IG5vdCByZXF1aXJlIGRlbGF5ZWQKbG9nZ2luZyB0byBoaXQuCgpOaWNrLCB5b3UnbGwgbmVlZCBi
b3RoIHBhdGNoZXMgdG8gYXZvaWQgdGhlIHRoZSBoYW5ncyB5b3UgcmVwb3J0ZWQgLSBJJ3ZlIGhh
ZAp5b3VyIHRlc3QgY2FzZSBydW5uaW5nIG5vdyBmb3IganVzdCBvdmVyIHRlbiBob3VycyB3aXRo
b3V0IGFueSBpc3N1ZXMgc28gZmFyLgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29z
cy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
