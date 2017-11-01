Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43328 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934228AbdKAVrR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Nov 2017 17:47:17 -0400
Subject: [PATCH 07/14] generic/459: explicitly require thin_check
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 01 Nov 2017 14:47:11 -0700
Message-ID: <150957283171.18388.10837345130257598513.stgit@magnolia>
In-Reply-To: <150957278824.18388.17975162441125293654.stgit@magnolia>
References: <150957278824.18388.17975162441125293654.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The lvm command can invoke the thin pool utilities as part of managing
a thin volume.  It'll fail if the thin provisioning utilities are not
installed, so we need to check for its presence before running a test.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/config     |    1 +
 tests/generic/459 |    1 +
 2 files changed, 2 insertions(+)


diff --git a/common/config b/common/config
index 96503c6..eea8669 100644
--- a/common/config
+++ b/common/config
@@ -196,6 +196,7 @@ export MAN_PROG="`set_prog_path man`"
 export NFS4_SETFACL_PROG="`set_prog_path nfs4_setfacl`"
 export NFS4_GETFACL_PROG="`set_prog_path nfs4_getfacl`"
 export UBIUPDATEVOL_PROG="`set_prog_path ubiupdatevol`"
+THIN_CHECK_PROG="$(set_prog_path thin_check)"
 
 # use 'udevadm settle' or 'udevsettle' to wait for lv to be settled.
 # newer systems have udevadm command but older systems like RHEL5 don't.
diff --git a/tests/generic/459 b/tests/generic/459
index 7c10c2a..d1ad372 100755
--- a/tests/generic/459
+++ b/tests/generic/459
@@ -63,6 +63,7 @@ _supported_os Linux
 _require_scratch_nocheck
 _require_dm_target thin-pool
 _require_command $LVM_PROG lvm
+_require_command "$THIN_CHECK_PROG" thin_check
 _require_freeze
 
 # remove previous $seqres.full before test

