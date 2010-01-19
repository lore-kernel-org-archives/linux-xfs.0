Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0J0exTV142603 for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 18:40:59 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2F0AD1C5C819
	for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 16:41:57 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	E1pBLfPUrfvSZdzc for <xfs@oss.sgi.com>;
	Mon, 18 Jan 2010 16:41:57 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11645766-1927428
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 11:11:56 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NX2AN-0003Fy-Ip
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 11:41:55 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NX2AM-0003cp-TW
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 11:41:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: warning fixes needed for libxfs
Date: Tue, 19 Jan 2010 11:41:49 +1100
Message-Id: <1263861711-13900-1-git-send-email-david@fromorbit.com>
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

These two patches are needed to suppress warnings in libxfs. The
changes are being made to the kernel code so that a resync of the
kernel code to the userspace libxfs will fix these warnings.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
