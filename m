Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAOBPm9j101215 for <xfs@oss.sgi.com>; Wed, 24 Nov 2010 05:25:49 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1261D1C6DAF2
	for <xfs@oss.sgi.com>; Wed, 24 Nov 2010 03:27:25 -0800 (PST)
Received: from mail.internode.on.net (bld-mail20.adl6.internode.on.net
	[150.101.137.105]) by cuda.sgi.com with ESMTP id
	eEuMFJKUAq3EUu1D for <xfs@oss.sgi.com>;
	Wed, 24 Nov 2010 03:27:25 -0800 (PST)
Received: from dastard (unverified [121.44.7.57])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	2283060-1927428
	for <xfs@oss.sgi.com>; Wed, 24 Nov 2010 21:57:24 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1PLDVT-0002H6-1h
	for xfs@oss.sgi.com; Wed, 24 Nov 2010 22:27:23 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PLDSn-0001WX-O2
	for xfs@oss.sgi.com; Wed, 24 Nov 2010 22:24:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs; fixes for 2.7.37-rc4
Date: Wed, 24 Nov 2010 22:24:31 +1100
Message-Id: <1290597873-5807-1-git-send-email-david@fromorbit.com>
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

The following two patches are bugs fixes needed for 2.6.37. The first fixes the
write truncation problem, and has been updated to pass blocks rather than byte
ranges  into the punch function. The second fixes a log hang triggered by AIL
pushing being unable to move a locked, pinned and stale buffer from the tail of
the log and hence free up log space. Both of these fixes are candidates for a
2.6.36.y stable release.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
