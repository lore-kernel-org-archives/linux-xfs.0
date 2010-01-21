Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0L62CNp056257 for <xfs@oss.sgi.com>; Thu, 21 Jan 2010 00:02:12 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AEE69F2F535
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2010 22:03:12 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	M0v5FH4B9o8Af7z1 for <xfs@oss.sgi.com>;
	Wed, 20 Jan 2010 22:03:12 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11574636-1927428
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2010 16:33:11 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NXq8B-0006cN-SE
	for xfs@oss.sgi.com; Thu, 21 Jan 2010 17:02:59 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NXq8A-0001aO-8z
	for xfs@oss.sgi.com; Thu, 21 Jan 2010 17:02:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfstests: Automatic build dependencies
Date: Thu, 21 Jan 2010 17:02:51 +1100
Message-Id: <1264053773-6054-1-git-send-email-david@fromorbit.com>
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

This patch series removes the need for 'make depend' by building the
dependencies as part of the normal build.

The first patch is cleaning up the current aclocal.m4 file and it's
generation as the second patch introduces a new configure test that
required regeneration.

The second patch is what changes the dependency calculation to use
gcc rather than makedepend and the makefile changes needed to build
and include those depencies automatically.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
