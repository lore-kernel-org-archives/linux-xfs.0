Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o022kQXR052107 for <xfs@oss.sgi.com>; Fri, 1 Jan 2010 20:46:26 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B99FF1DAB3F6
	for <xfs@oss.sgi.com>; Fri,  1 Jan 2010 18:47:14 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	FJIost45KmspaA07 for <xfs@oss.sgi.com>;
	Fri, 01 Jan 2010 18:47:14 -0800 (PST)
Received: from discord (unverified [121.44.238.220])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11047660-1927428
	for <xfs@oss.sgi.com>; Sat, 02 Jan 2010 13:17:12 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NQu1G-0007xC-69
	for xfs@oss.sgi.com; Sat, 02 Jan 2010 13:47:10 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NQtxr-00054H-Cg
	for xfs@oss.sgi.com; Sat, 02 Jan 2010 13:43:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] XFS: Run kernel threads on demand
Date: Sat,  2 Jan 2010 13:43:33 +1100
Message-Id: <1262400215-19443-1-git-send-email-david@fromorbit.com>
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

We run the xfsbufd and the xfsaild once a second even when there is
no work to do. Make them demand driven so that we don't needlessly
wake idle CPUs to do nothing. This should make power misers with XFS
filesystems happy.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
