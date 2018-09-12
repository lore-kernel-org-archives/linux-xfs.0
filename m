Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59468 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727409AbeILL1i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Sep 2018 07:27:38 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w8C6JfaI022644
        for <linux-xfs@vger.kernel.org>; Wed, 12 Sep 2018 02:24:38 -0400
Received: from e15.ny.us.ibm.com (e15.ny.us.ibm.com [129.33.205.205])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2meqxfk4tq-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 12 Sep 2018 02:24:38 -0400
Received: from localhost
        by e15.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Wed, 12 Sep 2018 02:24:38 -0400
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH V3 13/19] Filter fiemap output by FS block size
Date: Wed, 12 Sep 2018 11:56:20 +0530
In-Reply-To: <20180912062626.14349-1-chandan@linux.vnet.ibm.com>
References: <20180912062626.14349-1-chandan@linux.vnet.ibm.com>
Message-Id: <20180912062626.14349-14-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, guaneryu@gmail.com, darrick.wong@oracle.com, linux-xfs@vger.kernel.org

When testing FS instances of block size other than 4k, the output of
fiemap command will not match those in *.out files. This commit adds
an optional "block size" argument to _filter_fiemap() which prints
fiemap output in units of block size.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 common/punch | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/common/punch b/common/punch
index 8088b01..0fc7729 100644
--- a/common/punch
+++ b/common/punch
@@ -165,7 +165,11 @@ _test_punch() {
 
 _coalesce_extents()
 {
-	awk -F: '
+	block_size=$1
+
+	[[ -z $block_size ]] && block_size=512
+
+	awk -v block_size="$block_size" -F: '
 	{
 		range = $2;
 		type = $3;
@@ -176,19 +180,24 @@ _coalesce_extents()
 
 		if (type != prev_type) {
 			if (prev_type != "")
-				printf("%u]:%s\n", low - 1, prev_type);
-			printf("%u: [%u..", out_count++, low);
+				printf("%u]:%s\n", (low * 512 / block_size) - 1,
+					prev_type);
+			printf("%u: [%u..", out_count++,
+				(low * 512) / block_size);
 			prev_type = type;
 		}
 	}
 	END {
 		if (prev_type != "")
-			printf("%u]:%s\n", high, prev_type);
+			printf("%u]:%s\n", ((high + 1) * 512 / block_size) - 1,
+				prev_type);
 	}'
 }
 
 _filter_fiemap()
 {
+	block_size=$1
+
 	$AWK_PROG '
 		$3 ~ /hole/ {
 			print $1, $2, $3;
@@ -201,7 +210,7 @@ _filter_fiemap()
 		$5 ~ /0x[[:xdigit:]]+/ {
 			print $1, $2, "data";
 		}' |
-	_coalesce_extents
+	_coalesce_extents $block_size
 }
 
 _filter_fiemap_flags()
-- 
2.9.5
