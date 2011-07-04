Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p645RvEt115606 for <xfs@oss.sgi.com>; Mon, 4 Jul 2011 00:27:57 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6D68E524109
	for <xfs@oss.sgi.com>; Sun,  3 Jul 2011 22:27:56 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	ro8vHaVygDf1Lfua for <xfs@oss.sgi.com>;
	Sun, 03 Jul 2011 22:27:56 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1Qdbh8-0002yB-VJ
	for xfs@oss.sgi.com; Mon, 04 Jul 2011 15:27:42 +1000
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1Qdbh8-0001RE-Eu
	for xfs@oss.sgi.com; Mon, 04 Jul 2011 15:27:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/5] xfs: fix AIL bulk insert issues and cleanups
Date: Mon,  4 Jul 2011 15:27:35 +1000
Message-Id: <1309757260-5484-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
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

VGhlIGZpcnN0IHR3byBwYXRjaGVzIGZpeCB0aGUgcmVjZW50bHkgcmVwb3J0ZWQgcm0gLXJmIHBl
cmZvcm1hbmNlCmFuZCBpbnRlcmFjdGl2aXR5IHByb2JsZW1zIHdoZW4gdXNpbmcgZGVsYXnFk2Qg
bG9nZ2luZy4gVGhlc2Ugc2hvdWxkCnByb2JhYmx5IGJlIGNvbnNpZGVyZWQgZm9yIDMuMC1yYzUu
CgpUaGUgbGFzdCB0aHJlZSBwYXRjaGVzIGFyZSBjbGVhbnVwcyBhbmQgdHJhY2Vwb2ludHMgdGhh
dCBJIGNhbWUKYWNyb3NzIHdoaWxlIGZpbmRpbmcgYW5kIGZpeGluZyB0aGUgYWJvdmUgYnVncy4g
VGhleSBjYW4gcHJvYmFibHkKd2FpdCB1bnRpbCAzLjEuCgpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNv
bQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
