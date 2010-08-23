Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7N0Fd8b102060 for <xfs@oss.sgi.com>; Sun, 22 Aug 2010 19:15:39 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4F8171522D
	for <xfs@oss.sgi.com>; Sun, 22 Aug 2010 17:16:11 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	JNeZ70ksTe93fljD for <xfs@oss.sgi.com>;
	Sun, 22 Aug 2010 17:16:11 -0700 (PDT)
Received: from dastard (unverified [121.44.216.100])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	24591266-1927428
	for <xfs@oss.sgi.com>; Mon, 23 Aug 2010 09:46:10 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OnKhi-0003Uu-Vg
	for xfs@oss.sgi.com; Mon, 23 Aug 2010 10:15:58 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1OnKha-00023x-Ox
	for xfs@oss.sgi.com; Mon, 23 Aug 2010 10:15:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: Fix issues found doing large inode count testing
Date: Mon, 23 Aug 2010 10:15:44 +1000
Message-Id: <1282522546-7892-1-git-send-email-david@fromorbit.com>
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

Two fixes - one that prevents stalls in the CIl commit subsystem when memory is
low, one that brings CPu usage of the buffer cache hash down to something more
sensible.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
