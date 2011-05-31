Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4V4LEtj024962 for <xfs@oss.sgi.com>; Mon, 30 May 2011 23:21:14 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0ABF311CBFFE
	for <xfs@oss.sgi.com>; Mon, 30 May 2011 21:21:13 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	FXrlUJ49QLrqBsWj for <xfs@oss.sgi.com>;
	Mon, 30 May 2011 21:21:13 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1QRGS4-0002AD-O1
	for xfs@oss.sgi.com; Tue, 31 May 2011 14:21:08 +1000
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1QRGRy-000659-Qh
	for xfs@oss.sgi.com; Tue, 31 May 2011 14:21:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: couple of fixes for 3.0-rc2
Date: Tue, 31 May 2011 14:20:57 +1000
Message-Id: <1306815659-23346-1-git-send-email-david@fromorbit.com>
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

These are a couple of fixes for bugs that are candidates for
3.0-rc2.  The first addresses a regression introduced by the dynamic
speculative allocation changes in 2.6.38, and the second is a fix
for a debug-only assert failure I recently discovered while testing
on a selinux enabled system.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
