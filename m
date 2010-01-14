Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0E1bOhC208879 for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 19:37:24 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D51361C4D8DE
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 17:38:19 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	FFi8Q9ogrCD5AYpG for <xfs@oss.sgi.com>;
	Wed, 13 Jan 2010 17:38:19 -0800 (PST)
Received: from discord (unverified [121.44.236.168])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11630448-1927428
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 12:08:18 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NVEf8-0007MW-QP
	for xfs@oss.sgi.com; Thu, 14 Jan 2010 12:38:14 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NVEb5-0003UG-GF
	for xfs@oss.sgi.com; Thu, 14 Jan 2010 12:34:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3] Split version of xfs_swap_extents bug fix
Date: Thu, 14 Jan 2010 12:33:53 +1100
Message-Id: <1263432836-13368-1-git-send-email-david@fromorbit.com>
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

This splits the swap extents bug fix into three patches as requested
the bug fix, the tracing code and the variable name cleanup. Apart from
splitting the patch, the only change is in the cleanup patch which makes
xfs_swap_extents() static.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
