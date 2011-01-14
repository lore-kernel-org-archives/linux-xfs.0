Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0ED5hMZ024086 for <xfs@oss.sgi.com>; Fri, 14 Jan 2011 07:05:44 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A9B1C12FD3E3
	for <xfs@oss.sgi.com>; Fri, 14 Jan 2011 05:07:57 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	mcsc8ZH23yRRg3q9 for <xfs@oss.sgi.com>;
	Fri, 14 Jan 2011 05:07:57 -0800 (PST)
Received: from dastard (unverified [121.44.222.102])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	52858334-1927428
	for <xfs@oss.sgi.com>; Fri, 14 Jan 2011 23:37:55 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PdjNh-00065s-Ay
	for xfs@oss.sgi.com; Sat, 15 Jan 2011 00:07:53 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PdjN2-0003G8-Qv
	for xfs@oss.sgi.com; Sat, 15 Jan 2011 00:07:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: fix memory leaks on shutdown w/ delayed logging.
Date: Sat, 15 Jan 2011 00:07:08 +1100
Message-Id: <1295010430-12495-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

These two patches fix memory leaks that can occur when a log write
aborts during a CIL flush. xfstest 139 triggers these leaks reliably.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
