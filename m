Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q39Cn0kb122519 for <xfs@oss.sgi.com>; Mon, 9 Apr 2012 07:49:00 -0500
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id 9JLnR3GkLMRqtVhd for
	<xfs@oss.sgi.com>; Mon, 09 Apr 2012 05:48:58 -0700 (PDT)
Date: Mon, 9 Apr 2012 14:48:47 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS: Abysmal write performance because of excessive seeking
	(allocation groups to blame?)
Message-ID: <20120409144847.117b42b5@galadriel.home>
In-Reply-To: <CAAxjCEz8TpRvjvbuYPp1xf9X2HwskN5AuPak62R5Jhkg+mmFHA@mail.gmail.com>
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<20350.9643.379841.771496@tree.ty.sabi.co.UK>
	<20350.13616.901974.523140@tree.ty.sabi.co.UK>
	<CAAxjCEzkemiYin4KYZX62Ei6QLUFbgZESdwS8krBy0dSqOn6aA@mail.gmail.com>
	<4F7F7C25.8040605@hardwarefreak.com>
	<CAAxjCEyJW1b4dbKctbrgdWjykQt8Hb4Sw1RKdys3oUsehNHCcQ@mail.gmail.com>
	<4F8055E4.1000808@hardwarefreak.com>
	<CAAxjCEz8TpRvjvbuYPp1xf9X2HwskN5AuPak62R5Jhkg+mmFHA@mail.gmail.com>
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
To: Stefan Ring <stefanrin@gmail.com>
Cc: stan@hardwarefreak.com, Linux fs XFS <xfs@oss.sgi.com>

TGUgTW9uLCA5IEFwciAyMDEyIDEzOjAyOjI3ICswMjAwIHZvdXMgw6ljcml2aWV6OgoKPiBTbyAx
NTAgTUIvc2VjIHNlZW1zIHRvIGJlIHRoZQo+IGJlc3QgdGhlc2UgZGlza3MgY2FuIGRvLAoKRGVm
aW5pdGVseSBOT1QgcmlnaHQuIEkgbWVhbiBJJ3ZlIGdvdCByb3V0aW5lbHkgNjAwIE1CL3MgZnJv
bSA4IDcuMksKZHJpdmVzIFJBSUQtNiBhcnJheXMuIFVubGVzcyBjYWNoZSBpcyBvZmYsIHdoaWNo
IFJBSUQtNiBpc24ndCBvYnZpb3VzbHkKdGhvdWdodCBmb3IuCgotLSAKLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
CkVtbWFudWVsIEZsb3JhYyAgICAgfCAgIERpcmVjdGlvbiB0ZWNobmlxdWUKICAgICAgICAgICAg
ICAgICAgICB8ICAgSW50ZWxsaXF1ZQogICAgICAgICAgICAgICAgICAgIHwJPGVmbG9yYWNAaW50
ZWxsaXF1ZS5jb20+CiAgICAgICAgICAgICAgICAgICAgfCAgICszMyAxIDc4IDk0IDg0IDAyCi0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29t
L21haWxtYW4vbGlzdGluZm8veGZzCg==
