Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:52174 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726875AbfCTApT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Mar 2019 20:45:19 -0400
Subject: [PATCH 05/12] generic/454: stop the test if we run out of space
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 19 Mar 2019 17:45:07 -0700
Message-ID: <155304270779.31707.9419680484243839398.stgit@magnolia>
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

Certain filesystems (ext4 w/ 1k block size) can run out of space while
running this test because they have very limited xattr storage
capabilities.  If we run out of space while setting an attr, don't
bother continuing the test.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/454 |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)


diff --git a/tests/generic/454 b/tests/generic/454
index 4a0936c5..01986d6b 100755
--- a/tests/generic/454
+++ b/tests/generic/454
@@ -48,7 +48,12 @@ setf() {
 	key="$(echo -e "$1")"
 	value="$2"
 
-	$SETFATTR_PROG -n "user.${key}" -v "${value}" "${testfile}"
+	$SETFATTR_PROG -n "user.${key}" -v "${value}" "${testfile}" > $tmp.output 2>&1
+	if [ $? -ne 0 ]; then
+		grep -q 'No space left on device' $tmp.output && \
+			_notrun "ran out of space"
+		cat $tmp.output
+	fi
 	echo "Storing ${key} ($(hexbytes "${key}")) -> ${value}" >> $seqres.full
 }
 
