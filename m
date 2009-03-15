Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2FE83OG015745 for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 09:08:23 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DF1751C43AAE
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 07:07:19 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail05.adl2.internode.on.net
	[203.16.214.69]) by cuda.sgi.com with ESMTP id vSCACkWcA4z5Y97H
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 07:07:19 -0700 (PDT)
Received: from destruction.internal (unverified [203.206.165.193])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	43728152-1927428
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 21:19:52 +1030 (CDT)
Received: from dave by destruction.internal with local (Exim 4.69)
	(envelope-from <dave@destruction>) id 1LinuX-0004nl-Fn
	for xfs@oss.sgi.com; Sun, 15 Mar 2009 21:49:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3] [XFSQA] Optimisations and ENOSPC tests
Date: Sun, 15 Mar 2009 21:49:38 +1100
Message-Id: <1237114181-18431-1-git-send-email-david@fromorbit.com>
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

The first patch reduces the number of forks required by some
qa tests by using shell builtins. Tests run faster on UML
if they fork less.

The other two patches introduce tests that trip over
spurious ENOSPC errors. A followup patch series will fix
these test failures.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
