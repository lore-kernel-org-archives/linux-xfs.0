Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2N1lxoA071385 for <xfs@oss.sgi.com>; Thu, 22 Mar 2012 20:47:59 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	EeRLte9wRoGyz8TI for <xfs@oss.sgi.com>;
	Thu, 22 Mar 2012 18:47:57 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SAtbe-0005K3-F9
	for xfs@oss.sgi.com; Fri, 23 Mar 2012 12:47:54 +1100
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SAtbW-0003OS-BP
	for xfs@oss.sgi.com; Fri, 23 Mar 2012 12:47:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: fix a class of shutdown hangs
Date: Fri, 23 Mar 2012 12:47:41 +1100
Message-Id: <1332467263-12985-1-git-send-email-david@fromorbit.com>
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

The shutdown hang these two patches fix was tripped over by RH QA
when some other (unknown) problem resulting in trying to remove an
EFI log item from the AIL when it was not in the AIL at all. The
shutdown was triggered from log IO completion context, and hung
trying to wait for log IO completion.

IOWs, the patches will allow the shutdown to finish and the
filesystem to be unmounted, but do nothing to fix the unknown
problem that caused the shutdown to be triggered.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
