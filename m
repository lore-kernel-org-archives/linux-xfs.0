Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2FHk9ZQ027787 for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 12:46:30 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 589771C43DEE
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 10:45:25 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail02.adl2.internode.on.net
	[203.16.214.66]) by cuda.sgi.com with ESMTP id W7Rh1NAEtEUQuFfj
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 10:45:25 -0700 (PDT)
Received: from destruction.internal (unverified [203.206.165.193])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	354574612-1927428
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 21:55:52 +1030 (CDT)
Received: from dave by destruction.internal with local (Exim 4.69)
	(envelope-from <dave@destruction>) id 1LioTO-0006h6-B9
	for xfs@oss.sgi.com; Sun, 15 Mar 2009 22:25:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2, RESEND] [XFS] a couple of fixes
Date: Sun, 15 Mar 2009 22:25:40 +1100
Message-Id: <1237116342-25701-1-git-send-email-david@fromorbit.com>
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

The first fixes a fuzzer log corruption crash, and second is
a null pointer dereference I found by inspection.

These should now have the correct sign-off on them.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
