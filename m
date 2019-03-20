Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:57686 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbfCTTey (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Mar 2019 15:34:54 -0400
Date: Wed, 20 Mar 2019 12:34:44 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 38/36] xfs_io: don't read garbage stack contents if INUMBERS
 goes nuts
Message-ID: <20190320193444.GB1183@magnolia>
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155259742281.31886.17157720770696604377.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In theory INUMBERS will never return an ocount of zero, but on the off
chance it ever does we'll negative index the igroup array and return
stack contents for an inode number.  Don't do that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/open.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/io/open.c b/io/open.c
index f5fbd2c4..a406ea54 100644
--- a/io/open.c
+++ b/io/open.c
@@ -698,6 +698,9 @@ get_last_inode(void)
 		lastgrp = ocount;
 	}
 
+	if (lastgrp == 0)
+		return 0;
+
 	lastgrp--;
 
 	/* The last inode number in use */
