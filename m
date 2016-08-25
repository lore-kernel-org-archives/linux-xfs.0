Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 488047CBE
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:28:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0C4A18F8033
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:28:43 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id C7TyxMCUQABc3QIO (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:28:42 -0700 (PDT)
Subject: [PATCH 03/13] xfs/{130,235}: deal with an unreplayable dirty log
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:28:38 -0700
Message-ID: <147216771851.32641.12882618561173838572.stgit@birch.djwong.org>
In-Reply-To: <147216769914.32641.55434969009554013.stgit@birch.djwong.org>
References: <147216769914.32641.55434969009554013.stgit@birch.djwong.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com

Now that we have log replay items, an FS shutdown due to a corrupt
btree results in a log that can't be replayed.  The only solution here
is to zap the log when we're fixing the corrupt fs, so do that here.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/130 |    3 ++-
 tests/xfs/235 |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)


diff --git a/tests/xfs/130 b/tests/xfs/130
index 7d8ea2a..554d078 100755
--- a/tests/xfs/130
+++ b/tests/xfs/130
@@ -87,7 +87,8 @@ _cp_reflink "${SCRATCH_MNT}/file1" "${SCRATCH_MNT}/file4" 2> /dev/null && \
 umount "${SCRATCH_MNT}"
 
 echo "+ repair fs"
-_scratch_xfs_repair >> "$seqres.full" 2>&1
+_disable_dmesg_check
+_repair_scratch_fs >> "$seqres.full" 2>&1
 _scratch_xfs_repair >> "$seqres.full" 2>&1
 
 echo "+ mount image (2)"
diff --git a/tests/xfs/235 b/tests/xfs/235
index c2e0340..ef51d22 100755
--- a/tests/xfs/235
+++ b/tests/xfs/235
@@ -85,7 +85,8 @@ test -s ${SCRATCH_MNT}/file4 && _fail "should not be able to copy with busted rm
 umount ${SCRATCH_MNT}
 
 echo "+ repair fs"
-_scratch_xfs_repair >> $seqres.full 2>&1
+_disable_dmesg_check
+_repair_scratch_fs >> "$seqres.full" 2>&1
 _scratch_xfs_repair >> $seqres.full 2>&1
 
 echo "+ mount image (2)"

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
