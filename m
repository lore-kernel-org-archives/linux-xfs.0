Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0EACimn250462 for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 04:12:44 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9904B1DB1138
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 02:13:40 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	06xES5xk5H6oG5Ei for <xfs@oss.sgi.com>;
	Thu, 14 Jan 2010 02:13:40 -0800 (PST)
Received: from discord (unverified [121.44.236.168])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11435816-1927428
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 20:43:39 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NVMht-0007rk-Mo
	for xfs@oss.sgi.com; Thu, 14 Jan 2010 21:13:37 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NVMdg-0001LI-8I
	for xfs@oss.sgi.com; Thu, 14 Jan 2010 21:09:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/9] xfsprogs: fix missing error check in xfs_rtfree_range in
	libxfs
Date: Thu, 14 Jan 2010 21:09:06 +1100
Message-Id: <1263463752-5052-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1263463752-5052-1-git-send-email-david@fromorbit.com>
References: <1263463752-5052-1-git-send-email-david@fromorbit.com>
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

When xfs_rtfind_forw() returns an error, the block is returned
uninitialised.  xfs_rtfree_range() is not checking the error return,
so could be using an uninitialised block number for modifying bitmap
summary info.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 libxfs/xfs_rtalloc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/libxfs/xfs_rtalloc.c b/libxfs/xfs_rtalloc.c
index 6c3da52..4fbdaa9 100644
--- a/libxfs/xfs_rtalloc.c
+++ b/libxfs/xfs_rtalloc.c
@@ -466,6 +466,8 @@ xfs_rtfree_range(
 	 */
 	error = xfs_rtfind_forw(mp, tp, end, mp->m_sb.sb_rextents - 1,
 		&postblock);
+	if (error)
+		return error;
 	/*
 	 * If there are blocks not being freed at the front of the
 	 * old extent, add summary data for them to be allocated.
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
