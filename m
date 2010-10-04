Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o947nbka051960 for <xfs@oss.sgi.com>; Mon, 4 Oct 2010 02:49:37 -0500
Received: from smtp-relay.maven.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CA27E18A0735
	for <xfs@oss.sgi.com>; Mon,  4 Oct 2010 00:50:38 -0700 (PDT)
Received: from smtp-relay.maven.pl (smtp-relay.maven.pl [193.239.45.138]) by
	cuda.sgi.com with ESMTP id dbB2wEWhELgPVEGZ for
	<xfs@oss.sgi.com>; Mon, 04 Oct 2010 00:50:38 -0700 (PDT)
Received: from [83.238.65.58] (port=54996 helo=tarm.maven.pl ident=matrix157)
	by smtp-relay.maven.pl with esmtpsa (TLSv1:DHE-RSA-AES256-SHA:256)
	(Exim 4.72) (envelope-from <arekm@maven.pl>) id 1P2foi-0002Dj-OZ
	for xfs@oss.sgi.com; Mon, 04 Oct 2010 09:50:36 +0200
Received: from arekm by tarm.maven.pl with local (Exim 4.72)
	(envelope-from <arekm@maven.pl>) id 1P2fog-0004Ux-Ft
	for xfs@oss.sgi.com; Mon, 04 Oct 2010 09:50:34 +0200
From: Arkadiusz Miskiewicz <arekm@maven.pl>
Subject: Re: [PATCH VER 7] xfsprogs: projid32bit handling
Date: Mon, 4 Oct 2010 09:50:33 +0200
References: <1286005222-16423-1-git-send-email-arekm@maven.pl>
In-Reply-To: <1286005222-16423-1-git-send-email-arekm@maven.pl>
MIME-Version: 1.0
Message-Id: <201010040950.34290.arekm@maven.pl>
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

T24gU2F0dXJkYXkgMDIgb2YgT2N0b2JlciAyMDEwLCB5b3Ugd3JvdGU6Cj4gQWRkIHByb2ppZDMy
Yml0IGhhbmRsaW5nIHRvIHVzZXJzcGFjZS4gbWtmcy54ZnMgaXMgYWJsZSB0byBlbmFibGUgdGhp
cwo+IGZlYXR1cmUgZm9yIG5ldyBmaWxlc3lzdGVtcy4geGZzX2RiIGtub3dzIHdoYXQgcHJvamlk
X2xvL2hpIGFyZS4KCkFuZCBhIG11Y2ggYmV0dGVyIGFuZCBzaW1wbGVyIHhmc19hZG1pbi5zaCBw
YXRjaC4KCmRpZmYgLS1naXQgYS9kYi94ZnNfYWRtaW4uc2ggYi9kYi94ZnNfYWRtaW4uc2gKaW5k
ZXggYTdhM2ZkYi4uZDQyNDQ2YiAxMDA3NTUKLS0tIGEvZGIveGZzX2FkbWluLnNoCisrKyBiL2Ri
L3hmc19hZG1pbi5zaApAQCAtNiw5ICs2LDkgQEAKIHN0YXR1cz0wCiBEQl9PUFRTPSIiCiBSRVBB
SVJfT1BUUz0iIgotVVNBR0U9IlVzYWdlOiB4ZnNfYWRtaW4gWy1lZmpsdVZdIFstYyAwfDFdIFst
TCBsYWJlbF0gWy1VIHV1aWRdIGRldmljZSIKK1VTQUdFPSJVc2FnZTogeGZzX2FkbWluIFstZWZq
bHB1Vl0gWy1jIDB8MV0gWy1MIGxhYmVsXSBbLVUgdXVpZF0gZGV2aWNlIgogCi13aGlsZSBnZXRv
cHRzICJlZmpsdWM6TDpVOlYiIGMKK3doaWxlIGdldG9wdHMgImVmamxwdWM6TDpVOlYiIGMKIGRv
CiAJY2FzZSAkYyBpbgogCWMpCVJFUEFJUl9PUFRTPSRSRVBBSVJfT1BUUyIgLWMgbGF6eWNvdW50
PSIkT1BUQVJHOzsKQEAgLTE3LDYgKzE3LDcgQEAgZG8KIAlqKQlEQl9PUFRTPSREQl9PUFRTIiAt
YyAndmVyc2lvbiBsb2cyJyI7OwogCWwpCURCX09QVFM9JERCX09QVFMiIC1yIC1jIGxhYmVsIjs7
CiAJTCkJREJfT1BUUz0kREJfT1BUUyIgLWMgJ2xhYmVsICIkT1BUQVJHIiciOzsKKwlwKQlEQl9P
UFRTPSREQl9PUFRTIiAtYyAndmVyc2lvbiBwcm9qaWQzMmJpdCciOzsKIAl1KQlEQl9PUFRTPSRE
Ql9PUFRTIiAtciAtYyB1dWlkIjs7CiAJVSkJREJfT1BUUz0kREJfT1BUUyIgLWMgJ3V1aWQgIiRP
UFRBUkciJyI7OwogCVYpCXhmc19kYiAtcCB4ZnNfYWRtaW4gLVYKCgotLSAKQXJrYWRpdXN6IE1p
xZtraWV3aWN6ICAgICAgICBQTEQvTGludXggVGVhbQphcmVrbSAvIG1hdmVuLnBsICAgICAgICAg
ICAgaHR0cDovL2Z0cC5wbGQtbGludXgub3JnLwoKX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0
cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
