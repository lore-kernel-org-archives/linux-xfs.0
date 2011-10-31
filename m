Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9VAuxrN031376 for <xfs@oss.sgi.com>; Mon, 31 Oct 2011 05:56:59 -0500
Received: from smtp-relay.maven.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 66403210F95
	for <xfs@oss.sgi.com>; Mon, 31 Oct 2011 03:56:52 -0700 (PDT)
Received: from smtp-relay.maven.pl (smtp-relay.maven.pl [193.239.45.138]) by
	cuda.sgi.com with ESMTP id EtNvOm8a0FF9etzP for
	<xfs@oss.sgi.com>; Mon, 31 Oct 2011 03:56:52 -0700 (PDT)
Received: from 89-69-21-174.dynamic.chello.pl ([89.69.21.174]:56021
	helo=t400.localnet)
	by smtp-relay.maven.pl with esmtpsa (TLSv1:DHE-RSA-AES256-SHA:256)
	(Exim 4.76) (envelope-from <arekm@maven.pl>) id 1RKpXv-0005B4-6M
	for xfs@oss.sgi.com; Mon, 31 Oct 2011 11:56:51 +0100
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: xfs_repair fails with corrupt dinode 17491441757, extent total = 1,
	nblocks = 0.  This is a bug.
Date: Mon, 31 Oct 2011 11:56:20 +0100
MIME-Version: 1.0
Message-Id: <201110311156.20421.arekm@maven.pl>
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

Cnhmc19yZXBhaXIgdmVyc2lvbiAzLjEuNgoKZGlzY29ubmVjdGVkIGlub2RlIDE3NDkxNDQxNzU0
LCBtb3ZpbmcgdG8gbG9zdCtmb3VuZApkaXNjb25uZWN0ZWQgaW5vZGUgMTc0OTE0NDE3NTUsIG1v
dmluZyB0byBsb3N0K2ZvdW5kCmRpc2Nvbm5lY3RlZCBpbm9kZSAxNzQ5MTQ0MTc1NiwgbW92aW5n
IHRvIGxvc3QrZm91bmQKZGlzY29ubmVjdGVkIGlub2RlIDE3NDkxNDQxNzU3LCBtb3ZpbmcgdG8g
bG9zdCtmb3VuZApjb3JydXB0IGRpbm9kZSAxNzQ5MTQ0MTc1NywgZXh0ZW50IHRvdGFsID0gMSwg
bmJsb2NrcyA9IDAuICBUaGlzIGlzIGEgYnVnLgpQbGVhc2UgY2FwdHVyZSB0aGUgZmlsZXN5c3Rl
bSBtZXRhZGF0YSB3aXRoIHhmc19tZXRhZHVtcCBhbmQKcmVwb3J0IGl0IHRvIHhmc0Bvc3Muc2dp
LmNvbS4KY2FjaGVfbm9kZV9wdXJnZTogcmVmY291bnQgd2FzIDEsIG5vdCB6ZXJvIChub2RlPTB4
MjE0NTBjOTApCgpmYXRhbCBlcnJvciAtLSAxMTcgLSBjb3VsZG4ndCBpZ2V0IGRpc2Nvbm5lY3Rl
ZCBpbm9kZQoKMzBHQiBtZXRhZHVtcCBpbWFnZSwgNi4xR0IgY29tcHJlc3NlZCBvZiB+N1RCIHJl
YWwgcGFydGl0aW9uCmh0dHA6Ly9peGlvbi5wbGQtbGludXgub3JnL35hcmVrbS9sdl9zdG9yYWdl
MS5tZXRhZHVtcC54egoKWW91IG5lZWQgfjgtMTJHQiBvZiBtZW1vcnkgZm9yIHhmc19yZXBhaXIg
b24gdGhpcy4KCkkgY2FuIGFsc28gcHJvdmlkZSBzc2ggYWNjZXNzIHRvIHRoZSBzeXN0ZW0gd2l0
aCB0aGlzIGltYWdlIGFuZCBhbGwgbmVlZGVkIApzdHVmZiwgc28geW91IGRvbid0IG5lZWQgdG8g
ZG93bmxvYWQgaXQgb3Igd2FzdGUgb3duIHJlc291cmNlcy4KCkluIG1lYW50aW1lIEknbGwgcHJv
YmFibHkgbWFrZSB1Z2x5IGhhY2sgYnkgbWFraW5nICJjb3VsZG4ndCBpZ2V0IGRpc2Nvbm5lY3Rl
ZCAKaW5vZGUiIG5vbiBmYXRhbCwgc28gcmVwYWlyIHdpbGwgYmUgYWJsZSB0byBmaW5pc2guCi0t
IApBcmthZGl1c3ogTWnFm2tpZXdpY3ogICAgICAgIFBMRC9MaW51eCBUZWFtCmFyZWttIC8gbWF2
ZW4ucGwgICAgICAgICAgICBodHRwOi8vZnRwLnBsZC1saW51eC5vcmcvCgpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bv
c3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
