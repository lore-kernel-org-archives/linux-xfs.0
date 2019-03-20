Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:52248 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbfCTAp0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Mar 2019 20:45:26 -0400
Subject: [PATCH 06/12] ext4/023: don't require scrub for ext4 populated
 image creation
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 19 Mar 2019 17:45:22 -0700
Message-ID: <155304272254.31707.3761494827323670805.stgit@magnolia>
In-Reply-To: <155304267647.31707.14180452399822113095.stgit@magnolia>
References: <155304267647.31707.14180452399822113095.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Don't require scrub for ext4's populated fs creation test because there
is no general online scrub program for ext*.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/ext4/023 |    1 -
 1 file changed, 1 deletion(-)


diff --git a/tests/ext4/023 b/tests/ext4/023
index a598e2b4..1dadb29f 100755
--- a/tests/ext4/023
+++ b/tests/ext4/023
@@ -33,7 +33,6 @@ _cleanup()
 _supported_os Linux
 _supported_fs ext4
 _require_scratch
-_require_scrub
 
 echo "Format and populate"
 _scratch_populate_cached > $seqres.full 2>&1
