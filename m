Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:37481 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751111AbdJCIVh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2017 04:21:37 -0400
Date: Tue, 3 Oct 2017 19:21:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: fstests: update mkfs.xfs filters for new refactoring
Message-ID: <20171003082134.GJ3666@dastard>
References: <20171003080607.GM15067@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171003080607.GM15067@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

fstests: update mkfs.xfs filters for new refactoring

From: Dave Chinner <dchinner@redhat.com>

The new mkfs code adds some output to indicate where the defaults
were sourced from, so filter that out so it doesn't contaminate
tests unnecessarily.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 common/xfs    | 3 ++-
 tests/xfs/206 | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/common/xfs b/common/xfs
index def28bfc7309..603792092060 100644
--- a/common/xfs
+++ b/common/xfs
@@ -81,7 +81,8 @@ _scratch_mkfs_xfs()
 {
 	local mkfs_cmd="`_scratch_mkfs_xfs_opts`"
 	local mkfs_filter="sed -e '/less than device physical sector/d' \
-			       -e '/switching to logical sector/d'"
+			       -e '/switching to logical sector/d' \
+			       -e '/Default configuration/d'"
 	local tmp=`mktemp -u`
 	local mkfs_status
 
diff --git a/tests/xfs/206 b/tests/xfs/206
index 70997e3fe83e..01782b7b93a9 100755
--- a/tests/xfs/206
+++ b/tests/xfs/206
@@ -84,7 +84,8 @@ mkfs_filter()
 	    -e "s/\(sectsz\)\(=[0-9]* *\)/\1=512   /" \
 	    -e "s/\(sunit=\)\([0-9]* blks,\)/\10 blks,/" \
 	    -e "s/, lazy-count=[0-9]//" \
-	    -e "/.*crc=/d"
+	    -e "/.*crc=/d" \
+	    -e "/^Default configuration/d"
 }
 
 # mkfs slightly smaller than that, small log for speed.
