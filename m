Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:57096 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726969AbfCTAow (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Mar 2019 20:44:52 -0400
Subject: [PATCH 02/12] check: really improve test list randomization
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 19 Mar 2019 17:44:49 -0700
Message-ID: <155304268908.31707.9639554348139720057.stgit@magnolia>
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

coreutils provides the shuf(1) utility that randomizes the order of a
list and seeds its random number generator with /dev/urandom.  It's a
bit speedier than awk, so use it if available.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 check |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)


diff --git a/check b/check
index ecd1d39a..a2c5ba21 100755
--- a/check
+++ b/check
@@ -243,7 +243,11 @@ _prepare_test_list()
 
 	# sort the list of tests into numeric order
 	if $randomize; then
-		sorter="awk -v seed=$RANDOM -f randomize.awk"
+		if type shuf >& /dev/null; then
+			sorter="shuf"
+		else
+			sorter="awk -v seed=$RANDOM -f randomize.awk"
+		fi
 	else
 		sorter="cat"
 	fi
