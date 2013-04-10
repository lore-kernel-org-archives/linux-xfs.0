Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 08EDE7F83
	for <xfs@oss.sgi.com>; Wed, 10 Apr 2013 05:10:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E958A304067
	for <xfs@oss.sgi.com>; Wed, 10 Apr 2013 03:10:32 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id XjgLXGSLU27mfRAG for
	<xfs@oss.sgi.com>; Wed, 10 Apr 2013 03:10:30 -0700 (PDT)
Date: Wed, 10 Apr 2013 12:10:25 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: need help how to debug xfs crash issue xfs_iunlink_remove:
	xfs_inotobp() returned error 22
Message-ID: <20130410121025.78a42b22@harpe.intellique.com>
In-Reply-To: <CADFMGu+TdyjTjMTWMwpdHqmszhpCU162UA4Y-njARwSEjM1xNw@mail.gmail.com>
References: <CADFMGuJm5bPPwbbUtYwrCVDL23KExJTw_-VRX2UEEdZjo+i5oA@mail.gmail.com>
	<CADFMGu+=MM2yc=_peboV7JTNJ8F05TJfexmEErzcf0D8mAWFRg@mail.gmail.com>
	<CADFMGuKqkPbpcU=taqjTR4sA3o=w1LLAnKoEuj=OhJqEbQVijw@mail.gmail.com>
	<20130409145238.GE22182@sgi.com>
	<CADFMGuJaiH0wuxOHrDjDn7qRVH+vQkLOOSPUyqSdXnLcS47t3w@mail.gmail.com>
	<CADFMGu+TdyjTjMTWMwpdHqmszhpCU162UA4Y-njARwSEjM1xNw@mail.gmail.com>
Mime-Version: 1.0
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
To: =?GB2312?Q?=B7=FB=D3=C0=CC=CE?= <yongtaofu@gmail.com>
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

TGUgVHVlLCA5IEFwciAyMDEzIDIzOjEwOjAzICswODAwCrf708DMziA8eW9uZ3Rhb2Z1QGdtYWls
LmNvbT4gqKZjcml2YWl0OgoKPiA+IEFwciAgOSAxMTowMTozMCBjcWR4IGtlcm5lbDogWEZTIChz
ZGIpOiBJL08gRXJyb3IgRGV0ZWN0ZWQuCj4gPiBTaHV0dGluZyBkb3duIGZpbGVzeXN0ZW0KClRo
aXMuIEkvTyBlcnJvciBkZXRlY3RlZC4gVGhhdCBtZWFucyB0aGF0IGF0IHNvbWUgcG9pbnQgdGhl
IHVuZGVybHlpbmcKZGV2aWNlIChkaXNrLCBSQUlEIGFycmF5LCBTQU4gdm9sdW1lKSBjb3VsZG4n
dCBiZSByZWFjaGVkLiBTbyB0aGlzCmNvdWxkIHZlcnkgd2VsbCBiZSBhIGNhc2Ugb2YgYSBmbGFr
ZXkgZHJpdmUsIGFycmF5LCBjYWJsZSBvciBTQ1NJCmRyaXZlci4KCldoYXQncyB0aGUgc3RvcmFn
ZSBzZXR1cCBoZXJlPwoKLS0gCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpFbW1hbnVlbCBGbG9yYWMgICAgIHwg
ICBEaXJlY3Rpb24gdGVjaG5pcXVlCiAgICAgICAgICAgICAgICAgICAgfCAgIEludGVsbGlxdWUK
ICAgICAgICAgICAgICAgICAgICB8CTxlZmxvcmFjQGludGVsbGlxdWUuY29tPgogICAgICAgICAg
ICAgICAgICAgIHwgICArMzMgMSA3OCA5NCA4NCAwMgotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KCl9fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QK
eGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
