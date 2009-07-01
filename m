Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n61GKoEA021715 for <xfs@oss.sgi.com>; Wed, 1 Jul 2009 11:20:50 -0500
Received: from mail-bw0-f214.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4A779337BAD
	for <xfs@oss.sgi.com>; Wed,  1 Jul 2009 09:21:21 -0700 (PDT)
Received: from mail-bw0-f214.google.com (mail-bw0-f214.google.com
	[209.85.218.214]) by cuda.sgi.com with ESMTP id
	NSU20wdj3pVBoWo7 for <xfs@oss.sgi.com>;
	Wed, 01 Jul 2009 09:21:21 -0700 (PDT)
Received: by bwz10 with SMTP id 10so888416bwz.20
	for <xfs@oss.sgi.com>; Wed, 01 Jul 2009 09:21:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a4423d670906050223p4e72ceaaqa1dd942a2e52d1a3@mail.gmail.com>
References: <a4423d670906010822l6e8e112dl3d6f7de9e2179850@mail.gmail.com>
	<20090604092330.GT16929@discord.disaster>
	<a4423d670906050223p4e72ceaaqa1dd942a2e52d1a3@mail.gmail.com>
Date: Wed, 1 Jul 2009 20:21:20 +0400
Message-ID: <a4423d670907010921h7f5a7448x7575836586d7aee7@mail.gmail.com>
Subject: Re: 2.6.30-rc6: BUG at fs/xfs/support/debug.c:109!
From: Alexander Beregalov <a.beregalov@gmail.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>, xfs@oss.sgi.com

MjAwOS82LzUgQWxleGFuZGVyIEJlcmVnYWxvdiA8YS5iZXJlZ2Fsb3ZAZ21haWwuY29tPjoKPiAy
MDA5LzYvNCBEYXZlIENoaW5uZXIgPGRhdmlkQGZyb21vcmJpdC5jb20+Ogo+PiBPbiBNb24sIEp1
biAwMSwgMjAwOSBhdCAwNzoyMjo1NlBNICswNDAwLCBBbGV4YW5kZXIgQmVyZWdhbG92IHdyb3Rl
Ogo+Pj4gSGkKPj4+Cj4+PiBBc3NlcnRpb24gZmFpbGVkOiAqbm1hcCA+PSAxLCBmaWxlOiBmcy94
ZnMveGZzX2JtYXAuYywgbGluZTogNDg0Ngo+PiAuLi4uLgo+Pj4gQ2FsbCBUcmFjZToKPj4+IMKg
WzxmZmZmZmZmZjgwM2Q2YmFkPl0geGZzX2JtYXBpKzB4YWQvMHgxYWQwCj4+PiDCoFs8ZmZmZmZm
ZmY4MDNlZTVjMD5dIHhmc19kaXIyX2xlYWZfZ2V0ZGVudHMrMHg2NDAvMHg3YjAKPj4+IMKgWzxm
ZmZmZmZmZjgwM2U5NzVjPl0geGZzX3JlYWRkaXIrMHgxMmMvMHgxNDAKPj4+IMKgWzxmZmZmZmZm
ZjgwNDMwYjU3Pl0geGZzX2ZpbGVfcmVhZGRpcisweDQ3LzB4NzAKPj4+IMKgWzxmZmZmZmZmZjgw
MmVjNTAwPl0gdmZzX3JlYWRkaXIrMHhkMC8weGYwCj4+PiDCoFs8ZmZmZmZmZmY4MDJlYzZiNj5d
IHN5c19nZXRkZW50cysweDk2LzB4MTEwCj4+PiDCoFs8ZmZmZmZmZmY4MDIwYmE2Yj5dIHN5c3Rl
bV9jYWxsX2Zhc3RwYXRoKzB4MTYvMHgxYgo+Pgo+PiBJJ2Qgc2F5IHRoaXMgaW5kaWNhdGVzIGEg
Y29ycnVwdGVkIGRpcmVjdG9yeS4gwqBDYW4geW91IHJ1bgo+PiAneGZzX3JlcGFpciAtbicgb3Zl
ciB0aGUgZmlsZXN5c3RlbSBhbmQgc2VlIGlmIGl0IGZpbmRzIGEgYmFkCj4+IGRpcmVjdG9yeT8K
ClN0aWxsIGNhbm5vdCBmaXggdGhlIGZpbGVzeXN0ZW0uIEFmdGVyIHJlcGFpcmluZyBhbGwgY29y
cnVwdGlvbnMgZnJvbQpMaXZlQ0QgaXQgc3RpbGwgZmFpbHMgb24gdGhlIHNhbWUgd29ya2xvYWQu
CgpEbyB5b3UgbmVlZCBtZXRhZHVtcCBvciBhbnl0aGluZyBlbHNlPwoKX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3Nz
LnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
