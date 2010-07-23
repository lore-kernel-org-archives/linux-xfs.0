Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6NAcXf7195616 for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 05:38:33 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E256046B9DA
	for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 03:41:34 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	Uv9v1UenVBDKALLe for <xfs@oss.sgi.com>;
	Fri, 23 Jul 2010 03:41:34 -0700 (PDT)
Received: from dastard (unverified [121.44.18.238])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	32402274-1927428
	for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 20:11:33 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OcFgx-0007Qt-0x
	for xfs@oss.sgi.com; Fri, 23 Jul 2010 20:41:23 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1OcFgv-0000RQ-Ft
	for xfs@oss.sgi.com; Fri, 23 Jul 2010 20:41:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC, PATCH 0/3] serialise concurrent direct IO sub-block zeroing
Date: Fri, 23 Jul 2010 20:41:15 +1000
Message-Id: <1279881678-1660-1-git-send-email-david@fromorbit.com>
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

Patches for discussion seeing as git.kernel.org is being slow to update.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
