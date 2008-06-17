Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 17 Jun 2008 00:33:04 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5H7X06r028418
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2008 00:33:01 -0700
Received: from web34506.mail.mud.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id CAFEACD2914
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2008 00:33:58 -0700 (PDT)
Received: from web34506.mail.mud.yahoo.com (web34506.mail.mud.yahoo.com [66.163.178.172]) by cuda.sgi.com with SMTP id BMytHpoKSqocM4o8 for <xfs@oss.sgi.com>; Tue, 17 Jun 2008 00:33:58 -0700 (PDT)
Date: Tue, 17 Jun 2008 00:33:57 -0700 (PDT)
From: Mark <musicman529@yahoo.com>
Reply-To: MusicMan529@yahoo.com
Subject: XFS mkfs/mount options
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <881489.19090.qm@web34506.mail.mud.yahoo.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I have been doing some experiments with XFS on my "hot new desktop system," and I have turned up an interesting bit of info. (Note: My system is an AMD64 X2 2.5GHz running Linux.)

When I mount an XFS volume (thus loading the xfs kernel module), the kernel spawns two CPU-bound threads for "xfslogd" and "xfsdatad". However, it appears that only one of each of these kernel processes is getting any load, as indicated by "ps ax":

 3700 ?        S<     0:00 [xfslogd/0]
 3701 ?        S<     0:19 [xfslogd/1]
 3702 ?        S<     0:00 [xfsdatad/0]
 3703 ?        D<     0:05 [xfsdatad/1]

For each of these kernel threads, only those on CPU #2 are actually pulling notable load. Why is this?

I understand that I may have overlooked some critical tidbit of info in the man pages, or perhaps I have not yet found something online that could explain a default limitation. If so, I would very much enjoy new information about using XFS on a desktop system.

TYIA for your answer(s).

-- 
Mark

"What better place to find oneself than
 on the streets of one's home village?"
      --Capt. Jean-Luc Picard, "Family"
