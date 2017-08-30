Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20381 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751110AbdH3WbO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 18:31:14 -0400
Date: Wed, 30 Aug 2017 15:31:10 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 5/4] generic/173: don't dump core when mwrite fails
Message-ID: <20170830223110.GA4754@magnolia>
References: <150406805060.31349.16766271336969357123.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150406805060.31349.16766271336969357123.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

In generic/173, we try to force a CoW to a mmap'd region to fail if
there's no space to actually stage the CoW operation.  That failure
comes in the form of a SIGBUS to xfs_io.  If the tester just happens to
have a nonzero coresize ulimit set, a core dump is generated and the
test is marked as having failed, even though the dump generation is
exactly the correct behavior.

Therefore, set the coresize ulimit to zero while calling _mwrite_byte.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/173 |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/tests/generic/173 b/tests/generic/173
index ad4e5da..526590b 100755
--- a/tests/generic/173
+++ b/tests/generic/173
@@ -81,6 +81,8 @@ _fill_fs $((blksz * nr_free)) $testdir/space $blksz 0 >> $seqres.full 2>&1
 sync
 
 echo "mmap CoW the big file"
+core_ulimit="$(ulimit -c)"
+ulimit -c 0
 out="$(_mwrite_byte 0x62 0 $((blksz * nr_blks)) $((blksz * nr_blks)) $testdir/bigfile 2>&1)"
 err="$?"
 if [ $err -lt 128 ]; then
@@ -95,6 +97,7 @@ err="$?"
 if [ $err -lt 128 ]; then
 	echo "mmap CoW should have failed with SIGBUS, got SIG$(kill -l $err)"
 fi
+ulimit -c "${core_ulimit}"
 
 # success, all done
 status=0
