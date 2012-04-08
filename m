Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q38Lk7XM206123 for <xfs@oss.sgi.com>; Sun, 8 Apr 2012 16:46:07 -0500
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id jMoPTK6TspEGGBF7 for
	<xfs@oss.sgi.com>; Sun, 08 Apr 2012 14:46:04 -0700 (PDT)
Date: Sun, 8 Apr 2012 23:45:55 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS: Abysmal write performance because of excessive seeking
	(allocation groups to blame?)
Message-ID: <20120408234555.695e291f@galadriel.home>
In-Reply-To: <4F81F5FD.1090809@hardwarefreak.com>
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<20350.9643.379841.771496@tree.ty.sabi.co.UK>
	<20350.13616.901974.523140@tree.ty.sabi.co.UK>
	<CAAxjCEzkemiYin4KYZX62Ei6QLUFbgZESdwS8krBy0dSqOn6aA@mail.gmail.com>
	<4F7F7C25.8040605@hardwarefreak.com>
	<20120407104912.44881be3@galadriel.home>
	<4F81F5FD.1090809@hardwarefreak.com>
Mime-Version: 1.0
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
To: stan@hardwarefreak.com
Cc: Stefan Ring <stefanrin@gmail.com>, Linux fs XFS <xfs@oss.sgi.com>

TGUgU3VuLCAwOCBBcHIgMjAxMiAxNTozMzowMSAtMDUwMCB2b3VzIMOpY3JpdmllejoKCj4gPiAK
PiA+IEZyb20gbXkgZXhwZXJpZW5jZSwgd2l0aCBtb2Rlcm4gYXJyYXlzIGRvbid0IG1ha2UgbXVj
aCBvZiBhCj4gPiBkaWZmZXJlbmNlLiBJJ3ZlIHJlYWNoZWQgZGVjZW50IElPUFMgKGkuIGUuIGFi
b3V0IDQwMDAgSU9QUykgb24KPiA+IGxhcmdlIGFycmF5cyBvZiB1cCB0byA0NiBkcml2ZXMgcHJv
dmlkZWQgdGhlcmUgYXJlIGVub3VnaCB0aHJlYWRzCj4gPiAtLSBtb3JlIHRocmVhZHMgdGhhbiBz
cGluZGxlcywgcHJlZmVyYWJseS4gIAo+IAo+IEFyZSB5b3Ugc3BlYWtpbmcgb2YgYSBtaXhlZCBt
ZXRhZGF0YS9kYXRhIGhlYXZ5IElPUFMgd29ya2xvYWQgc2ltaWxhcgo+IHRvIHRoYXQgd2hpY2gg
aXMgdGhlIGZvY3VzIG9mIHRoaXMgdGhyZWFkLCBvciBhbm90aGVyIHR5cGUgb2YKPiB3b3JrbG9h
ZD8gIElzIHRoaXMgNDYgZHJpdmUgYXJyYXkgUkFJRDEwIG9yIFJBSUQ2PwoKUHVyZSByYW5kb20g
YWNjZXNzLCA4SyBJTyBiZW5jaG1hcmsgKGRhdGFiYXNlIHNpbXVsYXRpb24pLiBSQUlELTYKcGVy
Zm9ybXMgYWJvdXQgdGhlIHNhbWUgaW4gcHVyZSByZWFkaW5nIHRlc3RzLCBidXQgc3RpbmtzIHRl
cnJpYmx5IGF0CndyaXRpbmcgb2YgY291cnNlLgoKLS0gCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpFbW1hbnVl
bCBGbG9yYWMgICAgIHwgICBEaXJlY3Rpb24gdGVjaG5pcXVlCiAgICAgICAgICAgICAgICAgICAg
fCAgIEludGVsbGlxdWUKICAgICAgICAgICAgICAgICAgICB8CTxlZmxvcmFjQGludGVsbGlxdWUu
Y29tPgogICAgICAgICAgICAgICAgICAgIHwgICArMzMgMSA3OCA5NCA4NCAwMgotLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhm
cyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFu
L2xpc3RpbmZvL3hmcwo=
