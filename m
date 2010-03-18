Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2IMq7Hq197939 for <xfs@oss.sgi.com>; Thu, 18 Mar 2010 17:52:07 -0500
Received: from stout.americas.sgi.com (stout.americas.sgi.com [128.162.232.50])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 380AAAC005
	for <xfs@oss.sgi.com>; Thu, 18 Mar 2010 15:53:42 -0700 (PDT)
Received: from stout.americas.sgi.com (localhost6.localdomain6 [127.0.0.1])
	by stout.americas.sgi.com (8.14.3/8.14.2) with ESMTP id o2IMrfWa001829
	for <xfs@oss.sgi.com>; Thu, 18 Mar 2010 17:53:41 -0500
Received: (from aelder@localhost)
	by stout.americas.sgi.com (8.14.3/8.14.3/Submit) id o2IMrfX0001827
	for xfs@oss.sgi.com; Thu, 18 Mar 2010 17:53:41 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201003182253.o2IMrfX0001827@stout.americas.sgi.com>
Date: Thu, 18 Mar 2010 17:53:41 -0500
Subject: [PATCH 0/7] xfs: xfs_log_recover.c cleanups
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This series of patches contains a set of changes primarily in
the file "fs/xfs/xfs_log_recover.c".  They're mostly cleanup
patches, but one of them fixes a bug in two spots.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
