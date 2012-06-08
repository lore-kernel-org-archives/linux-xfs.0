Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q585j5hY174112 for <xfs@oss.sgi.com>; Fri, 8 Jun 2012 00:45:05 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	QIRd1JMR6JbC10kt for <xfs@oss.sgi.com>;
	Thu, 07 Jun 2012 22:45:04 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Scs0N-0004jp-SJ
	for xfs@oss.sgi.com; Fri, 08 Jun 2012 15:45:03 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1Scs0I-0002yI-Ny
	for xfs@oss.sgi.com; Fri, 08 Jun 2012 15:44:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: kill m_maxioffset
Date: Fri,  8 Jun 2012 15:44:52 +1000
Message-Id: <1339134294-11382-1-git-send-email-david@fromorbit.com>
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

This patchset cleans up the largest supported offset checks. That
information is at the VFS level, so we don't need to keep duplicates
in the struct xfs_mount, nor do we need a macro to access it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
