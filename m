Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2FArBNw004036 for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 05:53:31 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7C2F3199FD6
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 03:52:49 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail09.adl2.internode.on.net
	[203.16.214.73]) by cuda.sgi.com with ESMTP id I8VR5wOyfMSAsS6W
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 03:52:49 -0700 (PDT)
Received: from destruction.internal (unverified [203.206.165.193])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	58259140-1927428
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 21:22:46 +1030 (CDT)
Received: from dave by destruction.internal with local (Exim 4.69)
	(envelope-from <dave@destruction>) id 1LinxL-0004rG-Dk
	for xfs@oss.sgi.com; Sun, 15 Mar 2009 21:52:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] [XFS] a couple of fixes
Date: Sun, 15 Mar 2009 21:52:33 +1100
Message-Id: <1237114355-18647-1-git-send-email-david@fromorbit.com>
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
