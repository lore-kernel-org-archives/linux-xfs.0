Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:47338 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750751AbdLMGJX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Dec 2017 01:09:23 -0500
Subject: [PATCH 8/8] xfs/068: fix variability problems in file/dir count
 output
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 12 Dec 2017 22:04:11 -0800
Message-ID: <151314505158.18893.11894289091110903029.stgit@magnolia>
In-Reply-To: <151314499003.18893.8687182548758898133.stgit@magnolia>
References: <151314499003.18893.8687182548758898133.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In this test we use fsstress to create some number of files and then
exercise xfsdump/xfsrestore on them.  Depending on the fsstress config
we may end up with a different number of files than is hardcoded in the
golden output (particularly after adding reflink support to fsstress)
and thereby fail the test.  Since we're not really testing how many
files fsstress can create, just turn the counts into XXX/YYY.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/068     |    4 +++-
 tests/xfs/068.out |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)


diff --git a/tests/xfs/068 b/tests/xfs/068
index 7151e28..119b204 100755
--- a/tests/xfs/068
+++ b/tests/xfs/068
@@ -44,7 +44,9 @@ _supported_fs xfs
 _supported_os Linux
 
 _create_dumpdir_stress_num 4096
-_do_dump_restore
+# Fancy filtering here because fsstress doesn't always create the
+# same number of files (depending on the fs geometry)
+_do_dump_restore | sed -e 's/xfsrestore: [0-9]* directories and [0-9]* entries/xfsrestore: XXX directories and YYY entries/g'
 
 # success, all done
 exit
diff --git a/tests/xfs/068.out b/tests/xfs/068.out
index fa3a552..f53c555 100644
--- a/tests/xfs/068.out
+++ b/tests/xfs/068.out
@@ -22,7 +22,7 @@ xfsrestore: session id: ID
 xfsrestore: media ID: ID
 xfsrestore: searching media for directory dump
 xfsrestore: reading directories
-xfsrestore: 383 directories and 1335 entries processed
+xfsrestore: XXX directories and YYY entries processed
 xfsrestore: directory post-processing
 xfsrestore: restoring non-directory files
 xfsrestore: restore complete: SECS seconds elapsed

