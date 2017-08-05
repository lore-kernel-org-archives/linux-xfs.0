Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44494 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751226AbdHEQL1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 5 Aug 2017 12:11:27 -0400
Date: Sat, 5 Aug 2017 09:11:22 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs_db: free field list when failing out of fuzz
Message-ID: <20170805161122.GK24087@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

Fix a missed opportunity to free the field list when we fail out of the
fuzz command by refactoring the error clauses to use a common cleanup
clause.

Fixes-coverity-id: 1416141
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/fuzz.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/db/fuzz.c b/db/fuzz.c
index a9b1577..76dbf94 100644
--- a/db/fuzz.c
+++ b/db/fuzz.c
@@ -400,7 +400,7 @@ fuzz_struct(
 			break;
 	if (fc->fn == NULL) {
 		dbprintf(_("Unknown fuzz command '%s'.\n"), argv[1]);
-		return;
+		goto out_free;
 	}
 
 	/* if we're a root field type, go down 1 layer to get field list */
@@ -412,9 +412,8 @@ fuzz_struct(
 
 	/* run down the field list and set offsets into the data */
 	if (!flist_parse(fields, fl, iocur_top->data, 0)) {
-		flist_free(fl);
 		dbprintf(_("parsing error\n"));
-		return;
+		goto out_free;
 	}
 
 	sfl = fl;
@@ -447,8 +446,7 @@ fuzz_struct(
 	success = fc->fn(iocur_top->data, sfl->offset, bit_length);
 	if (!success) {
 		dbprintf(_("unable to fuzz field '%s'\n"), argv[0]);
-		flist_free(fl);
-		return;
+		goto out_free;
 	}
 
 	/* Write the fuzzed value back */
@@ -456,5 +454,6 @@ fuzz_struct(
 
 	flist_print(fl);
 	print_flist(fl);
+out_free:
 	flist_free(fl);
 }
