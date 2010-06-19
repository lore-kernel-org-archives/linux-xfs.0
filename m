Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5JCwiwh008825 for <xfs@oss.sgi.com>; Sat, 19 Jun 2010 07:58:45 -0500
Received: from mail.gmx.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 0BF773E7D83
	for <xfs@oss.sgi.com>; Sat, 19 Jun 2010 06:01:23 -0700 (PDT)
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20]) by cuda.sgi.com
	with SMTP id 6NyJrbUuCHH2S0zp for <xfs@oss.sgi.com>;
	Sat, 19 Jun 2010 06:01:23 -0700 (PDT)
Received: from x2.grafnetz ([192.168.0.4])
	by server.grafnetz with esmtps (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72) (envelope-from <grafgrimm77@gmx.de>) id 1OPxfk-0000cT-Gh
	for xfs@oss.sgi.com; Sat, 19 Jun 2010 15:01:20 +0200
Date: Sat, 19 Jun 2010 15:01:19 +0200
From: Mario Bachmann <grafgrimm77@gmx.de>
Subject: vmalloc, xfs_buf_get: failed to map pages
Message-ID: <20100619150119.3ce64102@x2.grafnetz>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello, 

on a 32bit machine, I have big problems with Linux 2.6.34. 
With Linux 2.6.33.4 everything runs fine. 

I do not know where to search for known bugs in xfs.

/var/log/messages shows a lot of lines:

Jun 19 11:43:15 amd2000 kernel: vmap allocation for size 4194304 failed: use vmalloc=<size> to increase size.
Jun 19 11:43:15 amd2000 kernel: xfs_buf_get: failed to map pages

What to to?

Mario

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
