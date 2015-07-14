Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2DFA57F67
	for <xfs@oss.sgi.com>; Mon, 13 Jul 2015 20:51:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CBC22AC003
	for <xfs@oss.sgi.com>; Mon, 13 Jul 2015 18:51:11 -0700 (PDT)
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id RYsYhN0URNphVGOQ (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 Jul 2015 18:51:10 -0700 (PDT)
Subject: Bug#792330: xfsprogs: FTBFS on ppc64el: configure: error: cannot
	guess build type; you must specify one
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.792330.B.14368384154788@bugs.debian.org>
MIME-Version: 1.0
From: Cyril Brulebois <kibi@debian.org>
Message-ID: <20150714014646.9724.43365.reportbug@chloe.home.mraw.org>
Date: Tue, 14 Jul 2015 03:46:46 +0200
Reply-To: Cyril Brulebois <kibi@debian.org>, 792330@bugs.debian.org
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
To: Debian Bug Tracking System <submit@bugs.debian.org>

U291cmNlOiB4ZnNwcm9ncwpWZXJzaW9uOiAzLjIuMwpTZXZlcml0eTogc2VyaW91cwpKdXN0aWZp
Y2F0aW9uOiBGVEJGUwoKSGksCgp5b3VyIHBhY2thZ2Ugbm8gbG9uZ2VyIGJ1aWxkcyBvbiBwcGM2
NGVsLCBpdCBmYWlscyB3aXRoOgp8IHVuYW1lIC1tID0gcHBjNjRsZQp8IHVuYW1lIC1yID0gMy4x
Ni4wLTQtcG93ZXJwYzY0bGUKfCB1bmFtZSAtcyA9IExpbnV4CnwgdW5hbWUgLXYgPSAjMSBTTVAg
RGViaWFuIDMuMTYuNy1ja3QxMS0xICgyMDE1LTA1LTI0KQp8IAp8IC91c3IvYmluL3VuYW1lIC1w
ID0gCnwgL2Jpbi91bmFtZSAtWCAgICAgPSAKfCAKfCBob3N0aW5mbyAgICAgICAgICAgICAgID0g
CnwgL2Jpbi91bml2ZXJzZSAgICAgICAgICA9IAp8IC91c3IvYmluL2FyY2ggLWsgICAgICAgPSAK
fCAvYmluL2FyY2ggICAgICAgICAgICAgID0gCnwgL3Vzci9iaW4vb3NsZXZlbCAgICAgICA9IAp8
IC91c3IvY29udmV4L2dldHN5c2luZm8gPSAKfCAKfCBVTkFNRV9NQUNISU5FID0gcHBjNjRsZQp8
IFVOQU1FX1JFTEVBU0UgPSAzLjE2LjAtNC1wb3dlcnBjNjRsZQp8IFVOQU1FX1NZU1RFTSAgPSBM
aW51eAp8IFVOQU1FX1ZFUlNJT04gPSAjMSBTTVAgRGViaWFuIDMuMTYuNy1ja3QxMS0xICgyMDE1
LTA1LTI0KQp8IGNvbmZpZ3VyZTogZXJyb3I6IGNhbm5vdCBndWVzcyBidWlsZCB0eXBlOyB5b3Ug
bXVzdCBzcGVjaWZ5IG9uZQp8IG1ha2VbMV06ICoqKiBbaW5jbHVkZS9idWlsZGRlZnNdIEVycm9y
IDEKfCBjaGVja2luZyBidWlsZCBzeXN0ZW0gdHlwZS4uLiBNYWtlZmlsZTo4OTogcmVjaXBlIGZv
ciB0YXJnZXQgJ2luY2x1ZGUvYnVpbGRkZWZzJyBmYWlsZWQKfCBtYWtlWzFdOiBMZWF2aW5nIGRp
cmVjdG9yeSAnL8KrUEtHQlVJTERESVLCuycKfCBtYWtlOiAqKiogWy5jZW5zdXNdIEVycm9yIDIK
fCBkcGtnLWJ1aWxkcGFja2FnZTogZXJyb3I6IGRlYmlhbi9ydWxlcyBidWlsZCBnYXZlIGVycm9y
IGV4aXQgc3RhdHVzIDIKfCBkZWJpYW4vcnVsZXM6MzY6IHJlY2lwZSBmb3IgdGFyZ2V0ICcuY2Vu
c3VzJyBmYWlsZWQKCkZ1bGwgYnVpbGQgbG9nOgogIGh0dHBzOi8vYnVpbGRkLmRlYmlhbi5vcmcv
c3RhdHVzL2ZldGNoLnBocD9wa2c9eGZzcHJvZ3MmYXJjaD1wcGM2NGVsJnZlcj0zLjIuMyZzdGFt
cD0xNDM0MzMzMzk0CgpNcmF3LApLaUJpLgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDov
L29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
