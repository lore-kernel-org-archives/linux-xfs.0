Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CE61E7CA0
	for <xfs@oss.sgi.com>; Sun, 24 Jul 2016 07:38:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 79C388F8037
	for <xfs@oss.sgi.com>; Sun, 24 Jul 2016 05:38:20 -0700 (PDT)
Received: from mail-lf0-f66.google.com (mail-lf0-f66.google.com
	[209.85.215.66]) by cuda.sgi.com with ESMTP id IpKL8S3EHLAM0AlA
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 24 Jul 2016 05:38:14 -0700 (PDT)
Received: by mail-lf0-f66.google.com with SMTP id f93so9863517lfi.0
	for <xfs@oss.sgi.com>; Sun, 24 Jul 2016 05:38:14 -0700 (PDT)
Received: from xps.localnet (89-75-168-105.dynamic.chello.pl. [89.75.168.105])
	by smtp.gmail.com with ESMTPSA id
	s4sm4693423lfs.33.2016.07.24.05.38.10 for <xfs@oss.sgi.com>
	(version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Sun, 24 Jul 2016 05:38:11 -0700 (PDT)
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: hardlinking and deleting milions of small files
Date: Sun, 24 Jul 2016 14:38:10 +0200
MIME-Version: 1.0
Message-Id: <201607241438.10035.arekm@maven.pl>
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

CkhlbGxvLgoKSSdtIHVzaW5nIHJzbmFwc2hvdCB0byBiYWNrdXAgYmlnIHNlcnZlcnMgKGxpa2Ug
NVRCIGZzLCAyNSAwMDAgMDAwIGlub2RlcywgCnNtYWxsIGZpbGVzIC0gbWFpbGJveGVzIGluIGZv
cm0gb2YgbWFpbGRpcnMsIHNvIGVhY2ggbWFpbCBpcyBhIHNlcGFyYXRlIGZpbGUpLiAKQmFja3Vw
IHNlcnZlciAtIGtlcm5lbCA0LjYuMywgVjQgeGZzIGZpbGVzeXN0ZW1zLgoKY3AgLWFsIGZvciB0
aGF0IGFtb3VudCB0YWtlcyBhYm91dCAxLjUgZGF5LgpybSAtcmYgb2YgaGFyZGxpbmtlZCBjb3B5
IHRha2VzIGFub3RoZXIgMS41IGRheQoKKGFuZCB0b29ucyBvZiByYW0gZm9yIHRoZXNlIG9wZXJh
dGlvbnM7IGNhdXNpbmcgT09NIHVudGlsIHJlY2VudCBrZXJuZWxzIG1hZGUgCnJlY2xhaW0gYmV0
dGVyLCBzbyBubyBtb3JlIE9PTSkKCgpOb3cgdGhlIHdlaXJkIHBhcnQgLSBzaW1pbGFyIG9wZXJh
dGlvbnMgb24gZXh0NCBmaW5pc2ggaW4gbWF0dGVyIG9mIGhvdXJzLgoKCkFyZSB0aGVyZSBhbnkg
cG9zc2liaWxpdGllcyBmb3IgeGZzIHRvIGltcHJvdmUgaW4gdGhlc2UgYXJlYXM/IAoKRnJvbSBp
cmMgI3hmcyBmcm9tIGZldyBtb250aHMgYWdvIHRoZSBjb25jbHVzaW9uIHdhcyB0aGF0IHhmcyBp
c24ndCBiZXN0IGluIApzdWNoIG9wZXJhdGlvbnMuCgpwcy4gRGlkbid0IGRvIHNjaWVudGlmaWMg
Y29tcGFyaXNvbiAoSSdtIGp1c3Qgdmlld2luZyBiYWNrdXAgbG9ncyBvZiB0d28gCnNpbWlsYXIg
bWFpbCBzZXJ2ZXJzIChzaW1pbGFyIGhhcmR3YXJlLCBzaW1pbGFyIHN0b3JhZ2Ugc2l6ZSkgYmVp
bmcgYmFja2VkIHVwIAp0byBzaW5nbGUgYmFja3VwIHNlcnZlciBvbnRvIHR3byBwYXJ0aXRpb25z
IC0gb25lIHdpdGggeGZzIGFuZCBvbmUgd2l0aCBleHQ0IApvbiBpdCkpCi0tIApBcmthZGl1c3og
TWnFm2tpZXdpY3osIGFyZWttIC8gKCBtYXZlbi5wbCB8IHBsZC1saW51eC5vcmcgKQoKX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlz
dAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZz
Cg==
