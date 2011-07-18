Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6I3nuKI078324 for <xfs@oss.sgi.com>; Sun, 17 Jul 2011 22:49:56 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 974FDECC578
	for <xfs@oss.sgi.com>; Sun, 17 Jul 2011 20:49:54 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	11gsITLO9YVU466F for <xfs@oss.sgi.com>;
	Sun, 17 Jul 2011 20:49:54 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1Qieq8-0008Cv-VK
	for xfs@oss.sgi.com; Mon, 18 Jul 2011 13:49:52 +1000
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1Qieq8-0002hT-NN
	for xfs@oss.sgi.com; Mon, 18 Jul 2011 13:49:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3] xfs: convert more code to use workqueues
Date: Mon, 18 Jul 2011 13:49:46 +1000
Message-Id: <1310960989-10284-1-git-send-email-david@fromorbit.com>
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

The three patces convert code to use workqueues for different
reasons.

The first patch splits the allocation path into a new stack as
writeback from the bdi-flusher threads is in danger of overrunning
the stack in worst case XFS stack usage on complex storage
subsystems. I've been running this patch locally for the past couple
of months and I haven't encountered any issues, performance or
otherwise with it.

The second patch converts the xfsbufd to a workqueue, continuing the
process of replacing per-fs threads with workqueues (as per xfsaild
and xfssyncd). This removes the last per-fs thread and cleans up the
code around it.

The last patch convert the CIL flush to use a workqueue to move all
the processing out of the direct transaction commit processing. This
prevents random operation from a user application taking the hit
(CPU and latency) for committing the last 10,000 modifications to
the journal.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
