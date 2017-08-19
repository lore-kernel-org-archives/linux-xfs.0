Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19134 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751438AbdHSPcS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 19 Aug 2017 11:32:18 -0400
Date: Sat, 19 Aug 2017 08:32:11 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs_db: bit fuzzing should read the right bit when flipping
Message-ID: <20170819153210.GR4796@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

The middle and last bit flip fuzz verbs need to read the same bit that
they're trying to set.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/fuzz.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/db/fuzz.c b/db/fuzz.c
index 53cedbc..d0d78a9 100644
--- a/db/fuzz.c
+++ b/db/fuzz.c
@@ -226,7 +226,7 @@ fuzz_lastbit(
 	int		nbits)
 {
 	setbit_l((char *)buf, bitoff + nbits - 1,
-			!getbit_l((char *)buf, bitoff));
+			!getbit_l((char *)buf, bitoff + nbits - 1));
 	return true;
 }
 
@@ -238,7 +238,7 @@ fuzz_middlebit(
 	int		nbits)
 {
 	setbit_l((char *)buf, bitoff + nbits / 2,
-			!getbit_l((char *)buf, bitoff));
+			!getbit_l((char *)buf, bitoff + nbits / 2));
 	return true;
 }
 
