Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0ANa2Cu052964 for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 17:36:03 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 304ED153D00F
	for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 15:38:14 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	2Aw9EeCf9dPwFSGg for <xfs@oss.sgi.com>;
	Mon, 10 Jan 2011 15:38:14 -0800 (PST)
Received: from dastard (unverified [121.44.222.102])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	52542244-1927428
	for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 10:08:11 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PcRJH-0006VK-T4
	for xfs@oss.sgi.com; Tue, 11 Jan 2011 10:37:59 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PcRJ9-0003yK-Kx
	for xfs@oss.sgi.com; Tue, 11 Jan 2011 10:37:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/8] xfs: prevent corruption due to overlapping AIO DIO V4
Date: Tue, 11 Jan 2011 10:37:40 +1100
Message-Id: <1294702668-15216-1-git-send-email-david@fromorbit.com>
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

Version 4 addresses the splice write locking problem Christoph
pointed out. It reverts the splice write locking change and adds a
comment explaining why and the problems that need fixing. This
version passes the recently posted splice sanity test for xfsqa.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
