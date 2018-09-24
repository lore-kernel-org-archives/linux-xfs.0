Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44564 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729102AbeIXVVV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Sep 2018 17:21:21 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w8OFEd6o086568
        for <linux-xfs@vger.kernel.org>; Mon, 24 Sep 2018 11:18:40 -0400
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2mq0mw5ydr-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 24 Sep 2018 11:18:40 -0400
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Mon, 24 Sep 2018 09:18:39 -0600
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH V5 14/20] Filter fiemap output by FS block size
Date: Mon, 24 Sep 2018 20:49:36 +0530
In-Reply-To: <20180924151942.8220-1-chandan@linux.vnet.ibm.com>
References: <20180924151942.8220-1-chandan@linux.vnet.ibm.com>
Message-Id: <20180924151942.8220-15-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, guaneryu@gmail.com, darrick.wong@oracle.com, zlang@redhat.com, linux-xfs@vger.kernel.org

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
