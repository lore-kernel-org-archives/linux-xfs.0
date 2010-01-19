Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0J0aHPm142351 for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 18:36:17 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3EEC911F797F
	for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 16:37:15 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	QJMRQpMxw8OjNqJb for <xfs@oss.sgi.com>;
	Mon, 18 Jan 2010 16:37:15 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11543019-1927428
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 11:07:13 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NX25d-0003EV-Uq
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 11:37:01 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NX25d-0003aN-9R
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 11:37:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/7] xfsprogs: fix missing error check in xfs_rtfree_range in
	libxfs
Date: Tue, 19 Jan 2010 11:36:47 +1100
Message-Id: <1263861413-13729-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1263861413-13729-1-git-send-email-david@fromorbit.com>
References: <1263861413-13729-1-git-send-email-david@fromorbit.com>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
