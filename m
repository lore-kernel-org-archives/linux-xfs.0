Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q39D3KJT128601 for <xfs@oss.sgi.com>; Mon, 9 Apr 2012 08:03:20 -0500
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id 65bUFRXu96Ykk8vi for
	<xfs@oss.sgi.com>; Mon, 09 Apr 2012 06:03:17 -0700 (PDT)
Date: Mon, 9 Apr 2012 15:03:06 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS: Abysmal write performance because of excessive seeking
	(allocation groups to blame?)
Message-ID: <20120409150306.4644f98d@galadriel.home>
In-Reply-To: <CAAxjCEzKtQ+7yrQf1x-wyTMjp1tS1Vy6Rei2xLwTbBzOhEZ6YA@mail.gmail.com>
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<20350.9643.379841.771496@tree.ty.sabi.co.UK>
	<20350.13616.901974.523140@tree.ty.sabi.co.UK>
	<CAAxjCEzkemiYin4KYZX62Ei6QLUFbgZESdwS8krBy0dSqOn6aA@mail.gmail.com>
	<4F7F7C25.8040605@hardwarefreak.com>
	<CAAxjCEyJW1b4dbKctbrgdWjykQt8Hb4Sw1RKdys3oUsehNHCcQ@mail.gmail.com>
	<4F8055E4.1000808@hardwarefreak.com>
	<CAAxjCEz8TpRvjvbuYPp1xf9X2HwskN5AuPak62R5Jhkg+mmFHA@mail.gmail.com>
	<20120409144847.117b42b5@galadriel.home>
	<CAAxjCEzKtQ+7yrQf1x-wyTMjp1tS1Vy6Rei2xLwTbBzOhEZ6YA@mail.gmail.com>
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

TGUgTW9uLCA5IEFwciAyMDEyIDE0OjUzOjE0ICswMjAwIHZvdXMgw6ljcml2aWV6OgoKPiBJbiB0
aGlzIGNhc2UgaXQgd2FzIGEgMi1kaXNrIFJBSUQgMSwgc28gaXTigJlzIDE1MCBNQi9zIHBlciBk
aXNrLiBTZWVtcwo+IHF1aXRlIHJpZ2h0IHRvIG1lLgoKWWVzIHNvcnJ5LCBJIHRob3VnaCBpdCB0
byBiZSB0aGUgNiBkcml2ZXMgYXJyYXkgc3BlZWQuIFNlZW4gaXQganVzdAphZnRlciBoaXR0aW5n
ICJzZW5kIiwgYnV0IHRoZXJlIGlzIG5vICJzdXBlcnNlZGUiIGluIG1haWxpbmcgbGlzdHMgOi0p
CgotLSAKLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tCkVtbWFudWVsIEZsb3JhYyAgICAgfCAgIERpcmVjdGlvbiB0
ZWNobmlxdWUKICAgICAgICAgICAgICAgICAgICB8ICAgSW50ZWxsaXF1ZQogICAgICAgICAgICAg
ICAgICAgIHwJPGVmbG9yYWNAaW50ZWxsaXF1ZS5jb20+CiAgICAgICAgICAgICAgICAgICAgfCAg
ICszMyAxIDc4IDk0IDg0IDAyCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQoKX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5j
b20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
