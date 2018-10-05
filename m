Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:53414 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbeJEHPo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 03:15:44 -0400
Subject: [PATCH 5/6] xfs/288: shut up verifier error
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 04 Oct 2018 17:19:39 -0700
Message-ID: <153869877948.26648.4238107405182797711.stgit@magnolia>
In-Reply-To: <153869874763.26648.516233620615833277.stgit@magnolia>
References: <153869874763.26648.516233620615833277.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Ignore the verifier errors when we fuzz hdr.count to zero.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/288 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/xfs/288 b/tests/xfs/288
index c6821909..13ba3057 100755
--- a/tests/xfs/288
+++ b/tests/xfs/288
@@ -62,7 +62,7 @@ _scratch_xfs_set_metadata_field "hdr.count" "0" \
 # verify current xfs_db write command can set hdr.count to 0. Old xfsprogs
 # can't do that on v5 filesystems.
 count=$(_scratch_xfs_get_metadata_field "hdr.count" \
-					"inode $inum" "ablock 0")
+					"inode $inum" "ablock 0" 2> /dev/null)
 if [ "$count" != "0" ]; then
 	_notrun "xfs_db can't set attr hdr.count to 0"
 fi
