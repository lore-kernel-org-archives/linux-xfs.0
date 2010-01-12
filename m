Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0C4ik9T217454 for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 22:44:46 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3FF061C44455
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 20:45:41 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	dbnw2f29u56MkrTd for <xfs@oss.sgi.com>;
	Mon, 11 Jan 2010 20:45:41 -0800 (PST)
Received: from discord (unverified [121.44.168.156])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11326443-1927428
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2010 15:15:38 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NUYdL-0004g4-Ky
	for xfs@oss.sgi.com; Tue, 12 Jan 2010 15:45:35 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NUYZJ-0005zV-3t
	for xfs@oss.sgi.com; Tue, 12 Jan 2010 15:41:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/4] xfsqa: make some tests work again, add xfs_fsr test
Date: Tue, 12 Jan 2010 15:41:05 +1100
Message-Id: <1263271269-18997-1-git-send-email-david@fromorbit.com>
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

Enable the growfs test 104 and filter out the useless output, remove
hacks from 073 to do with loop devices and filter the log size out
in 206 to prevent failures with new mkfs binaries that allow large
logs.

Also, add a simple xfs_fsr test to improve coverage in the test
suite.  That's not hard given we have only one test (042) that
defragments only one file.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
