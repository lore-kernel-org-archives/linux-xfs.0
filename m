Return-Path: <cmaiolino@redhat.com>
Resent-Message-ID: <20170227145923.3f4cbl7brq5ffipw@eorzea.usersys.redhat.com>
Resent-To: sandeen@sandeen.net
Received: from userp1040.oracle.com ([156.151.31.81]:21949 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751291AbdBYBMu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Feb 2017 20:12:50 -0500
Subject: [PATCH 1/4] xfs/348: classify this as a fuzzer test
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 24 Feb 2017 17:12:45 -0800
Message-ID: <148798516558.25833.17088165790220083654.stgit@birch.djwong.org>
In-Reply-To: <148798515933.25833.2842247083803775089.stgit@birch.djwong.org>
References: <148798515933.25833.2842247083803775089.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

xfs/348 is a fuzzer test since it calls xfs_db to break the scratch fs,
so put it in the fuzzers group.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/group |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/xfs/group b/tests/xfs/group
index e2dfae2..eaa65b1 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -337,7 +337,7 @@
 345 auto quick clone
 346 auto quick clone
 347 auto quick clone
-348 auto quick repair
+348 auto quick fuzzers repair
 349 dangerous_fuzzers scrub
 350 dangerous_fuzzers dangerous_scrub dangerous_repair
 351 dangerous_fuzzers dangerous_scrub dangerous_online_repair

