Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49810 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750749AbdH3ElB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 00:41:01 -0400
Subject: [PATCH 2/4] xfs/013: exit cleaner thread if fsstress dies
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 29 Aug 2017 21:40:56 -0700
Message-ID: <150406805679.31349.8203006933430835354.stgit@magnolia>
In-Reply-To: <150406805060.31349.16766271336969357123.stgit@magnolia>
References: <150406805060.31349.16766271336969357123.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In this test, the cleaner thread deletes the directory trees created by
fsstress in order to exercise the free inode btree code.  However, if
fsstress dies, the cleaner can end up waiting forever for a directory
that will never be created, which hangs up the test run.  Therefore,
abort if fsstress has ended.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/013 |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/tests/xfs/013 b/tests/xfs/013
index 817558f..4e49e4b 100755
--- a/tests/xfs/013
+++ b/tests/xfs/013
@@ -88,6 +88,10 @@ _cleaner()
 		while [ ! -e $need ]
 		do
 			sleep 3
+			if ! pgrep fsstress > /dev/null 2>&1; then
+				echo "fsstress died?"
+				return
+			fi
 		done
 
 		rm -rf $dir/dir$i

