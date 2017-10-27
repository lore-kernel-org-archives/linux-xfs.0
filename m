Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23627 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932402AbdJ0AnQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Oct 2017 20:43:16 -0400
Date: Thu, 26 Oct 2017 17:43:12 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 7/6] common/fuzzy: online re-scrub should not preen
Message-ID: <20171027004312.GE5486@magnolia>
References: <150899709935.18389.17266737014565285073.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150899709935.18389.17266737014565285073.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

When we're doing the second online scrub (to figure out if the repair
did any good) we shouldn't let that second scrub preen the filesystem in
any way.  If scrub finds things it can't/won't preen that turns into a
nonzero return code which gets reported (incorrectly) as a failure.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/fuzzy |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/common/fuzzy b/common/fuzzy
index 7a4b03a..87f7acc 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -275,7 +275,7 @@ __scratch_xfs_fuzz_field_test() {
 		# which scrub doesn't know how to fix.
 		echo "++ Online scrub"
 		if [ "$1" != "sb 0" ]; then
-			_scratch_scrub -e continue 2>&1
+			_scratch_scrub -n -e continue 2>&1
 			res=$?
 			test $res -ne 0 && \
 				(>&2 echo "online re-scrub ($res) with ${field} = ${fuzzverb}.")
