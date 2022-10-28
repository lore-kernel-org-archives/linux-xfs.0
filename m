Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54F47FA3743
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Oct 2022 21:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbiJ1V4S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Oct 2022 17:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiJ1V4P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Oct 2022 17:56:15 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6F91DB24D;
        Fri, 28 Oct 2022 14:56:14 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29SKxbjD025354;
        Fri, 28 Oct 2022 21:56:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=zYWE7ALpy9/jPDFvB54YNuR+kKeJ769eQtnUCseYFtU=;
 b=iBjrmyjjsJtgHuLK20tyEbM1G19VU8Wfattwz/EAfc6bpFxf74/9PH+WnyNLnUmnlYnK
 aKrnMoJg83WfcOBlGeapNGjbzp+2mN1QixZRPFW0JYpC0660lRwv43EARWI/vbqa8S+1
 A0pRVbdJNxZNij3WBbFoJboI3xJeviecTYxJYO3pJDbHvsaYAbB0UI+E+YQmygJdTyPR
 EJ2rsi2IiMvZ6AuonVS/jcRlGUY+6AVV2Snj0It5dxYZYILveLQAdyal30RHP3qUecKF
 7JpfKk6kNrhNYD/Ey8QAofvRAdVXtQonqhtBHx7254e1K4DHK9MqVmPimLE5V21UXmAm 3g== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfb0ap7h9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Oct 2022 21:56:13 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29SIV8OO011610;
        Fri, 28 Oct 2022 21:56:12 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kfagsge7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Oct 2022 21:56:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oVVoV/oks1GoY5V5kS8vQ6f0QFKOmhwt4cJroXy7RHxg3MnwiiXMeOve5iy3U76M1lWOq33wfaVScqnSfKPrEFTl3CKw9Oq3MVh4P73Gi4B//t8tVhoVsT0fhNQbDzxhmPPhI25vJfsO2OcHcbttkU/cEejY/Hct6rbH58+oekla9kKBMhk4TIglVINBQN6KwfKQCxUqtbRKqR8NNFEmp0G8nV8VnWzyjmESEyBIBLRohsvCGRjlffNHlw7uahEn/MFOdFK79AjlhZoTOtZfcQjoco40oVHGq3o9Aiz6pWEZ35BIMPargfqdF6bcwbZbGUAnhgkSrCY5Z72rUjhz6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zYWE7ALpy9/jPDFvB54YNuR+kKeJ769eQtnUCseYFtU=;
 b=DoiUIVgz9+zqUxMTEjwWsKIOqRlWomIrZ2B8Kn+/TcxXOkzLIhqhD3o5tKVfS10OxI39BS8/ZyJVUbRjrDlQtpXt+MX/85NgZO3AH0km+gKxbmFHNAowq5s9dU1S8RzmTdtEfgaYET1TLYbbyAybqWUXMHDwPE4ksl3wUsyCkGkG3oCvZPAnAhOsmuYXSzF625k1M5xCyuA915GN4LgFlQB6di21iQJqSk+xHsrMetPYa3odbQc83L6m+fVxEOyjGX+V58Vr60gRFdQeBj6v3faYKIOTaFWbXX2lX4aJeB0AkYjGaHn6MiCvIjoyt8rOG8+s6IABA/T/DEvwEVgFbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zYWE7ALpy9/jPDFvB54YNuR+kKeJ769eQtnUCseYFtU=;
 b=xfjA9HEpmU1JADAR/vEwS484pTALgimzJND9kGNhjJAqpEXIZrzZdoHfzEipj04Hnit9d926X21FriItlKTvxvHmm9UaEPbpxvcP7a/BvsfhpxVkPImSHVsPnOxTU2JuUQXChl3/ctnpdK4xPq9nlMTw2cFrl6M4jDXgfaLWTbc=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by MW4PR10MB5702.namprd10.prod.outlook.com (2603:10b6:303:18c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Fri, 28 Oct
 2022 21:56:10 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::17e5:a392:97fb:39e9]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::17e5:a392:97fb:39e9%6]) with mapi id 15.20.5769.015; Fri, 28 Oct 2022
 21:56:10 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v3 1/4] common: add helpers for parent pointer tests
Date:   Fri, 28 Oct 2022 14:56:02 -0700
Message-Id: <20221028215605.17973-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20221028215605.17973-1-catherine.hoang@oracle.com>
References: <20221028215605.17973-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR20CA0001.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::14) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|MW4PR10MB5702:EE_
X-MS-Office365-Filtering-Correlation-Id: db6b565e-d819-493b-a140-08dab92f3969
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0mmtt5+2wANhaq1mEVAJd4BAU6Ii837+kYTDudbtykfSRxxUayhIxC6F1I5fwACTmef1+CJiwOSrPqLZR82c5rq/0f/JQJD1HbBh+ZiuXE9tSe6fxQZNCeVh49gbjEz+MgQTEXDedf3bkMgYWZC491p3pQrGubS2dLSfr1Ua2rglnnK6dHFfYS79pocl2SYidEWC5YsXEjGrvmWYAtJCg18oGGKIea/bVgP+8oJUmEkbAq7McWOD/EMolbuSjIK93pvSGgD4k6NOgbv42YdfFsI+7gZx6alSHUzs+EbmIwdy0DeS4VOUCV3fE/w2ck9VpcQvqBQEsYOr6slWKZD6NkiZHJYNGBrgdSrt3L5vAcRlT7PO7NNIuHDJITo7TXoRZX9in5tFe2q0yyJ9doqGeWZnyd5q3UfBwob+eVA2jY4enmlJytESJy1gy3gIg0AysGMGbuTqLZU0FcN5oEU0cYThslGSOH+5GeWBuV9G9+8NK1IlDye+B8l2eSS0r31yZ3jVcxQZIAqNGM9EIQNimc84faBEB1deEUfWbyqmw8FN4wWB2KJwqV3rxHkX0EU/m8E6DnV/jDzSJZWDgrNGIj8E90ahxNBX3uGsO5dNOKeZTKLi0Z6A0pGBquAfw2g2CfXs/803S1BGEUXRRCieV+lBlv7LdDABrOOBMTTihDYdoXvbOIqMLcPKy4b0s1veUitgNzLiV93jTpQRT6WnCFxaIUEbwBT0HZdRzIQgUw5kt+UcWzZ9utkfDitruMp1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(346002)(366004)(136003)(39860400002)(451199015)(66946007)(66556008)(66476007)(86362001)(316002)(450100002)(44832011)(8936002)(8676002)(41300700001)(5660300002)(6512007)(478600001)(6666004)(6506007)(1076003)(36756003)(83380400001)(2616005)(38100700002)(186003)(6486002)(2906002)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5dRd9t+vXHczas45X8tj4VTRX4/o+koOa2fUOwISi+okgG/iSZ7chTd8MZCz?=
 =?us-ascii?Q?0CT0K+09muPrRGAW6wcxthWUfM1plFcKLp0+hPlgdikwSSk1M7CWU+Zw90Hm?=
 =?us-ascii?Q?Sppi89oaEslvG2cHwd3x4+jO9miVNQeKKyHTp2gabG6hSeBchl5X+0NUzFGK?=
 =?us-ascii?Q?a/0hv1B+F/FMLbDYg5JzaCuKO/qxyxCmRJ7eMP4vDZ3qy3BZbbiK4qnRrp+V?=
 =?us-ascii?Q?tYK9P7ZV41V8jaQwOzfXwlmKRshSzgVJdtP3m3is73Bp/t4mYp26kwDUsoec?=
 =?us-ascii?Q?1az+u/026EYPUIC3Am8nNHPdYqnI38gJ/G0gRnNIBicwMOhpyQb7YATH7FNs?=
 =?us-ascii?Q?sSgf//VQQ1v5saKwpWcNgAmnaTI3O13CXvsM3i3CZQrQaYc6OCK4QQMJtXPN?=
 =?us-ascii?Q?pLA2ubSv/3xuSbgHrlfXi/VkwzpdP4wojJr2WvnM3/V+z0cX9T6H535DBEzK?=
 =?us-ascii?Q?iqskoVPcH07Wu7C5NIoo+ayeG0NUj7so5n6TSiFSa2N3ROnsrpiBdP4E/+VB?=
 =?us-ascii?Q?JCYUY5SUzgLAM6Dq6AroYP17Q/HvGqaeNYFaEgZWOww3g0ZKZTbiIEgkwK1o?=
 =?us-ascii?Q?f+QjCIjWGawA2KX7idnzxyZ+cSeRQxZFdom6ZoNoP6SuYq7VfmbxySkyHIsw?=
 =?us-ascii?Q?pzXi2u5R7YgAgn7q3wmb9uA1dbgPm4sqnHCZIuntFUAuYyvCWHrhgx1+r/i5?=
 =?us-ascii?Q?ukF6hGjfwvOZlpoN1POBwtiVi3shubn/+DTeXETXuVnjtBSEfOaBgwc4Itl7?=
 =?us-ascii?Q?VH85QZ0q88I+sHpbtj9qzOo316RzWT128i/E+VilZOfVxFJr7uJKtMTwS72X?=
 =?us-ascii?Q?h7npr22XLe9qQ0ToYFK7Wi3qFfFP2C8zenbrx/iaFW3RO8C8M0umZM4PO66h?=
 =?us-ascii?Q?BY1cVsOQaRX5w8zEhAi1Lsa6OZ59wLFWLjRamrIz6icQTk5lzExwzAZDRGly?=
 =?us-ascii?Q?BiSPduYjSYbytKLOlPhpiX6ToHQ2rWtlK9AT6pLJBl3JrtLD8CmQ7bQmxFRx?=
 =?us-ascii?Q?9EAd98RQgABRrAPQ3RznlMNeAyroo5AX4YfHVRLFAjsw4NxA+VvkWXiy7wLF?=
 =?us-ascii?Q?9dJ5qnNkHRqcfX3VTPDof3/P9p8rNwBmD85Kxh//2Ilv8+EiBu0Mb1+Q5VvE?=
 =?us-ascii?Q?YU/SslPTCjVqqd755JeJXn6L6t4mr9rnjj3HJEFpzNrRKiJVSixDOGVhIaSE?=
 =?us-ascii?Q?fHNkV3kDlq9PAQYNiXf/T0Z5H4XrF2FGPKN/A6eXvVPNRyz/lJdtcAAWzVeC?=
 =?us-ascii?Q?e0N9S57T9Ut0LiqCGIjjqx2Z5w2HPkaAkHHWHUo6DayZmswHTPig+ayt2VQ0?=
 =?us-ascii?Q?gCkqgX+QKNuJoxXla/A9eAzNCAJ9qNgaxkLUDaV7MbQPWsNoabChGTkK8F2P?=
 =?us-ascii?Q?r4gIqVhnz4lFfT5IYji8NtzoO08cYEfgMWj5F+sde6lMjyYv8g08aF6Wtg0X?=
 =?us-ascii?Q?PY4ZiGdvYpQb9KVHlwP/kC46TbGJesK+GPffqkJq+HgrHJtb3qVdbzI0kQ2h?=
 =?us-ascii?Q?9Bm38Lg4KXuBpXagJiUHFfjqXJn1z0eg2GIN64D9oKmTvvNJPVa932ix0BeX?=
 =?us-ascii?Q?iv9WRrBUN3AL6u1QvOA7RVIH1dxHqPTeFtVZ7JWjQE1vvr9ZTUw5hIYMOiG+?=
 =?us-ascii?Q?mcDG9Us7AKF2nT3Tl5oBl5qjWxHVSxt2/+MMMX4/cHaQIZrMTboX9BSI5Njd?=
 =?us-ascii?Q?RB9vcg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db6b565e-d819-493b-a140-08dab92f3969
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2022 21:56:10.5890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OZzcFqaRtmBnavOOFNCH/691j961mMI86G6CHZrTY5p9hpBtUEqQqEH4dA5WYwNd/Zx12WrSYF+LCrwPsIhT1+mfbj1X7IDdFL+YDMjzVrM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5702
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-28_10,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 mlxscore=0 suspectscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210280138
X-Proofpoint-GUID: 12SCyM_I__wKtwAbrLiKonvWfZt1YwQV
X-Proofpoint-ORIG-GUID: 12SCyM_I__wKtwAbrLiKonvWfZt1YwQV
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Add helper functions in common/parent to parse and verify parent
pointers. Also add functions to check that mkfs, kernel, and xfs_io
support parent pointers.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 common/parent | 198 ++++++++++++++++++++++++++++++++++++++++++++++++++
 common/rc     |   3 +
 common/xfs    |  12 +++
 3 files changed, 213 insertions(+)
 create mode 100644 common/parent

diff --git a/common/parent b/common/parent
new file mode 100644
index 00000000..a0ba7d92
--- /dev/null
+++ b/common/parent
@@ -0,0 +1,198 @@
+#
+# Parent pointer common functions
+#
+
+#
+# parse_parent_pointer parents parent_inode parent_pointer_name
+#
+# Given a list of parent pointers, find the record that matches
+# the given inode and filename
+#
+# inputs:
+# parents	: A list of parent pointers in the format of:
+#		  inode/generation/name_length/name
+# parent_inode	: The parent inode to search for
+# parent_name	: The parent name to search for
+#
+# outputs:
+# PPINO         : Parent pointer inode
+# PPGEN         : Parent pointer generation
+# PPNAME        : Parent pointer name
+# PPNAME_LEN    : Parent pointer name length
+#
+_parse_parent_pointer()
+{
+	local parents=$1
+	local pino=$2
+	local parent_pointer_name=$3
+
+	local found=0
+
+	# Find the entry that has the same inode as the parent
+	# and parse out the entry info
+	while IFS=\/ read PPINO PPGEN PPNAME_LEN PPNAME; do
+		if [ "$PPINO" != "$pino" ]; then
+			continue
+		fi
+
+		if [ "$PPNAME" != "$parent_pointer_name" ]; then
+			continue
+		fi
+
+		found=1
+		break
+	done <<< $(echo "$parents")
+
+	# Check to see if we found anything
+	# We do not fail the test because we also use this
+	# routine to verify when parent pointers should
+	# be removed or updated  (ie a rename or a move
+	# operation changes your parent pointer)
+	if [ $found -eq "0" ]; then
+		return 1
+	fi
+
+	# Verify the parent pointer name length is correct
+	if [ "$PPNAME_LEN" -ne "${#parent_pointer_name}" ]
+	then
+		echo "*** Bad parent pointer:"\
+			"name:$PPNAME, namelen:$PPNAME_LEN"
+	fi
+
+	#return sucess
+	return 0
+}
+
+#
+# _verify_parent parent_path parent_pointer_name child_path
+#
+# Verify that the given child path lists the given parent as a parent pointer
+# and that the parent pointer name matches the given name
+#
+# Examples:
+#
+# #simple example
+# mkdir testfolder1
+# touch testfolder1/file1
+# verify_parent testfolder1 file1 testfolder1/file1
+#
+# # In this above example, we want to verify that "testfolder1"
+# # appears as a parent pointer of "testfolder1/file1".  Additionally
+# # we verify that the name record of the parent pointer is "file1"
+#
+#
+# #hardlink example
+# mkdir testfolder1
+# mkdir testfolder2
+# touch testfolder1/file1
+# ln testfolder1/file1 testfolder2/file1_ln
+# verify_parent testfolder2 file1_ln testfolder1/file1
+#
+# # In this above example, we want to verify that "testfolder2"
+# # appears as a parent pointer of "testfolder1/file1".  Additionally
+# # we verify that the name record of the parent pointer is "file1_ln"
+#
+_verify_parent()
+{
+	local parent_path=$1
+	local parent_pointer_name=$2
+	local child_path=$3
+
+	local parent_ppath="$parent_path/$parent_pointer_name"
+
+	# Verify parent exists
+	if [ ! -d $SCRATCH_MNT/$parent_path ]; then
+		_fail "$SCRATCH_MNT/$parent_path not found"
+	else
+		echo "*** $parent_path OK"
+	fi
+
+	# Verify child exists
+	if [ ! -f $SCRATCH_MNT/$child_path ]; then
+		_fail "$SCRATCH_MNT/$child_path not found"
+	else
+		echo "*** $child_path OK"
+	fi
+
+	# Verify the parent pointer name exists as a child of the parent
+	if [ ! -f $SCRATCH_MNT/$parent_ppath ]; then
+		_fail "$SCRATCH_MNT/$parent_ppath not found"
+	else
+		echo "*** $parent_ppath OK"
+	fi
+
+	# Get the inodes of both parent and child
+	pino="$(stat -c '%i' $SCRATCH_MNT/$parent_path)"
+	cino="$(stat -c '%i' $SCRATCH_MNT/$child_path)"
+
+	# Get all the parent pointers of the child
+	parents=($($XFS_IO_PROG -x -c \
+	 "parent -f -i $pino -n $parent_pointer_name" $SCRATCH_MNT/$child_path))
+	if [[ $? != 0 ]]; then
+		 _fail "No parent pointers found for $child_path"
+	fi
+
+	# Parse parent pointer output.
+	# This sets PPINO PPGEN PPNAME PPNAME_LEN
+	_parse_parent_pointer $parents $pino $parent_pointer_name
+
+	# If we didnt find one, bail out
+	if [ $? -ne 0 ]; then
+		_fail "No parent pointer record found for $parent_path"\
+			"in $child_path"
+	fi
+
+	# Verify the inode generated by the parent pointer name is
+	# the same as the child inode
+	pppino="$(stat -c '%i' $SCRATCH_MNT/$parent_ppath)"
+	if [ $cino -ne $pppino ]
+	then
+		_fail "Bad parent pointer name value for $child_path."\
+			"$SCRATCH_MNT/$parent_ppath belongs to inode $PPPINO,"\
+			"but should be $cino"
+	fi
+
+	echo "*** Verified parent pointer:"\
+			"name:$PPNAME, namelen:$PPNAME_LEN"
+	echo "*** Parent pointer OK for child $child_path"
+}
+
+#
+# _verify_parent parent_pointer_name pino child_path
+#
+# Verify that the given child path contains no parent pointer entry
+# for the given inode and file name
+#
+_verify_no_parent()
+{
+	local parent_pname=$1
+	local pino=$2
+	local child_path=$3
+
+	# Verify child exists
+	if [ ! -f $SCRATCH_MNT/$child_path ]; then
+		_fail "$SCRATCH_MNT/$child_path not found"
+	else
+		echo "*** $child_path OK"
+	fi
+
+	# Get all the parent pointers of the child
+	local parents=($($XFS_IO_PROG -x -c \
+	 "parent -f -i $pino -n $parent_pname" $SCRATCH_MNT/$child_path))
+	if [[ $? != 0 ]]; then
+		return 0
+	fi
+
+	# Parse parent pointer output.
+	# This sets PPINO PPGEN PPNAME PPNAME_LEN
+	_parse_parent_pointer $parents $pino $parent_pname
+
+	# If we didnt find one, return sucess
+	if [ $? -ne 0 ]; then
+		return 0
+	fi
+
+	_fail "Parent pointer entry found where none should:"\
+			"inode:$PPINO, gen:$PPGEN,"
+			"name:$PPNAME, namelen:$PPNAME_LEN"
+}
diff --git a/common/rc b/common/rc
index d1f3d56b..9fc0a785 100644
--- a/common/rc
+++ b/common/rc
@@ -2539,6 +2539,9 @@ _require_xfs_io_command()
 		echo $testio | grep -q "invalid option" && \
 			_notrun "xfs_io $command support is missing"
 		;;
+	"parent")
+		testio=`$XFS_IO_PROG -x -c "parent" $TEST_DIR 2>&1`
+		;;
 	"pwrite")
 		# -N (RWF_NOWAIT) only works with direct vectored I/O writes
 		local pwrite_opts=" "
diff --git a/common/xfs b/common/xfs
index 170dd621..7233a2db 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1399,3 +1399,15 @@ _xfs_filter_mkfs()
 		print STDOUT "realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX\n";
 	}'
 }
+
+# this test requires the xfs parent pointers feature
+#
+_require_xfs_parent()
+{
+	_scratch_mkfs_xfs_supported -n parent > /dev/null 2>&1 \
+		|| _notrun "mkfs.xfs does not support parent pointers"
+	_scratch_mkfs_xfs -n parent > /dev/null 2>&1
+	_try_scratch_mount >/dev/null 2>&1 \
+		|| _notrun "kernel does not support parent pointers"
+	_scratch_unmount
+}
-- 
2.25.1

