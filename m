Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q378oC2s213552 for <xfs@oss.sgi.com>; Sat, 7 Apr 2012 03:50:13 -0500
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id 9MeJUQV3RGp8lBEo for
	<xfs@oss.sgi.com>; Sat, 07 Apr 2012 01:49:39 -0700 (PDT)
Date: Sat, 7 Apr 2012 10:49:12 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS: Abysmal write performance because of excessive seeking
	(allocation groups to blame?)
Message-ID: <20120407104912.44881be3@galadriel.home>
In-Reply-To: <4F7F7C25.8040605@hardwarefreak.com>
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<20350.9643.379841.771496@tree.ty.sabi.co.UK>
	<20350.13616.901974.523140@tree.ty.sabi.co.UK>
	<CAAxjCEzkemiYin4KYZX62Ei6QLUFbgZESdwS8krBy0dSqOn6aA@mail.gmail.com>
	<4F7F7C25.8040605@hardwarefreak.com>
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

TGUgRnJpLCAwNiBBcHIgMjAxMiAxODoyODozNyAtMDUwMCB2b3VzIMOpY3JpdmllejoKCj4gQ3Jl
YXRpbmcgZm91ciA2MCBkcml2ZSBSQUlEMTAgYXJyYXlzLCBsZXQgYWxvbmUgNjAgZHJpdmUgUkFJ
RDYKPiBhcnJheXMsIHdvdWxkIGJlIHNpbGx5LgoKRnJvbSBteSBleHBlcmllbmNlLCB3aXRoIG1v
ZGVybiBhcnJheXMgZG9uJ3QgbWFrZSBtdWNoIG9mIGEgZGlmZmVyZW5jZS4KSSd2ZSByZWFjaGVk
IGRlY2VudCBJT1BTIChpLiBlLiBhYm91dCA0MDAwIElPUFMpIG9uIGxhcmdlIGFycmF5cyBvZiB1
cAp0byA0NiBkcml2ZXMgcHJvdmlkZWQgdGhlcmUgYXJlIGVub3VnaCB0aHJlYWRzIC0tIG1vcmUg
dGhyZWFkcyB0aGFuCnNwaW5kbGVzLCBwcmVmZXJhYmx5LgoKLS0gCi0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpF
bW1hbnVlbCBGbG9yYWMgICAgIHwgICBEaXJlY3Rpb24gdGVjaG5pcXVlCiAgICAgICAgICAgICAg
ICAgICAgfCAgIEludGVsbGlxdWUKICAgICAgICAgICAgICAgICAgICB8CTxlZmxvcmFjQGludGVs
bGlxdWUuY29tPgogICAgICAgICAgICAgICAgICAgIHwgICArMzMgMSA3OCA5NCA4NCAwMgotLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9t
YWlsbWFuL2xpc3RpbmZvL3hmcwo=
