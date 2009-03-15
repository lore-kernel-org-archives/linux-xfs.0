Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2FBv5V2009208 for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 06:57:25 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9EF521C437E1
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 04:56:42 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail05.adl2.internode.on.net
	[203.16.214.69]) by cuda.sgi.com with ESMTP id hc0F0FPGxfvHvTlb
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 04:56:42 -0700 (PDT)
Received: from destruction.internal (unverified [203.206.165.193])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	43730838-1927428
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 22:10:54 +1030 (CDT)
Received: from dave by destruction.internal with local (Exim 4.69)
	(envelope-from <dave@destruction>) id 1Liohv-0006kw-PH
	for xfs@oss.sgi.com; Sun, 15 Mar 2009 22:40:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] Fix a couple of random hangs.
Date: Sun, 15 Mar 2009 22:40:41 +1100
Message-Id: <1237117243-25940-1-git-send-email-david@fromorbit.com>
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

The first patch fixes a low memory hang where I/O completion
processing triggers memory reclaim which hangs waiting for
I/O completion. The trigger is unwritten extent conversion
blocking completion of normal writes.

The second fixes a log hang which results from excessive load;
we update the push target after we go to sleep so if we are
unlucky enough not to have a current push target far enough
advanced we'll hang.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
