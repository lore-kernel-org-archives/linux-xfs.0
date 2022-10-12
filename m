Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E974C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Oct 2022 01:38:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbiJLBie (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Oct 2022 21:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiJLBid (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Oct 2022 21:38:33 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B876857F2;
        Tue, 11 Oct 2022 18:38:32 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29BLiDMp009813;
        Wed, 12 Oct 2022 01:38:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=W7iz8uy/xmveH5KOkog2gTgXVHRBWzV0lNShkBs7g74=;
 b=MwcXjXGDB+1RxmpS3vDckmKYVu5L4o+eXhlhhgniN0ZidgIiQUCgCA02jKT7rYwnij3q
 XyklHAB2x9X4wmDRPnLGDil6mprV0kd368QZdc/TFFoqz2c8uuDUAoqjOydCO37b8RNn
 DxzZtVw7hoYjEf24DkB51Y5uzQrLYO1K/LUHkjKPB/Q9YkRxPahS1+ymBDTL0ldzDRn3
 beuN5NWBd0k5zERpKM29QmNGh5MM8fWGPw10byiY4fCqOdadWNxZu2sEMlL2R941iOhP
 Y9hnumXffiyNMi/aAgE3VLq5fVkVV69JGkQrliq12XeaY+C8nGUmnnRzleaGctzjAgcn xQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k31rtgj7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Oct 2022 01:38:31 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29BMWw54008701;
        Wed, 12 Oct 2022 01:38:31 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k2yn4db3c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Oct 2022 01:38:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AWLCGqCVYM4meVQtkd8f2MNLHII82Tjj2KgNYd6qCHD+QSYnTgeWzvQiZzElYljzxY5rDGEdHywZlQ6lqfy5K7VNlPSnfw+tSDtt8eWYVUmPJ3f2F3+8oEn1etkg58Xymezt3Y5gjbxKhF4hnqHJj+YUGry5MYV+sVQX9BwuaFqsun7oeMqYnlhTDnyhGlWym4wEzkU8izF1UJSRUA1Mm5asSxsZjnKXeTCCkowMAxPC2TAHvalTp4MVjYUnCKNRdoyAjVQ+K1sSMx/E0rvL+dRZmVrZ9sWQ+ATbIY/i7Ug+X8iM+9JdBVDrqRX7s1Yjq1kERIZs7rxhPxcaqHcluQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W7iz8uy/xmveH5KOkog2gTgXVHRBWzV0lNShkBs7g74=;
 b=D2QxdQnMdNCHgVtf1zU9d9NIli5+5VAenzDE0Ee9uM247JYm3CddP+6jFkar+ftl9dlPjVkaX8I03D28It7pMKxze60L54gOhGi+k/E0vJPJmgd3+mbhZtboQ4vH4+xt+KpGzlID7Mz965YsXfXVaKXMNfQK7+LTsaX9dm2tmMmdSuYMG/fl21gY8QpAAwwMqh3mVSMpJpavYA1RDO4L83hdVn7PPe+0UaK77G0BGMVxCPAKtR/ueyvz3REmptQy6IvRN6jlqLianY9SsHTaJ/UiZHo2mu2af1j1kRA3oh8NXvXaiBYiMi4sgNCGHHQEYHzdNWA7p7iEqpsjBgZvTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W7iz8uy/xmveH5KOkog2gTgXVHRBWzV0lNShkBs7g74=;
 b=JN8aB2t7aLy8cWDLBGC12n2MZHnjz8l7RqgEVJ6d8zGIt+PCmWeNDfJVbXyG1dgeDE+Ud7WXiOmV0XTPWtBG69UkniVGTs+fYoAIS2HwDnZnPECsACM71qLKUrkn+4nxY6OgBeb9p9ss1t3bfnHlpRV2XACZ9uc9hbbn4xTNm/8=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by SA1PR10MB5686.namprd10.prod.outlook.com (2603:10b6:806:236::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Wed, 12 Oct
 2022 01:38:29 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::bf88:77e2:717f:8b9a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::bf88:77e2:717f:8b9a%9]) with mapi id 15.20.5709.021; Wed, 12 Oct 2022
 01:38:29 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v2 1/4] common: add helpers for parent pointer tests
Date:   Tue, 11 Oct 2022 18:38:09 -0700
Message-Id: <20221012013812.82161-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20221012013812.82161-1-catherine.hoang@oracle.com>
References: <20221012013812.82161-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0002.namprd21.prod.outlook.com
 (2603:10b6:a03:114::12) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|SA1PR10MB5686:EE_
X-MS-Office365-Filtering-Correlation-Id: c67bc105-d6cb-4db6-ddfc-08daabf276a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k+5ixC6iijjQo4LfNwEM6xJUifEz2CtGTbCdMEZ61x90Ov+PbnHJWEMP4du2ePtIzT06sVqdzF80F5OmN4AQDJ4TiG4sDLM8LqW68a1qkuh4DmSSk7FFPBwALfbU9zOE1CSZOCdpi4hTmbDPA+ZNqpC8o1KTsSqav8AdmT2BmtqOywZ775DsVBFEkQTrJmSGoQ9drGBp9iOKB88WIugSR4pLnF/q32YVLES1YOEQsS8IpitRBBimU4GOJHmb9qULr+gh2FxuHVXt8urnkChqCJmHVaHY4mWKnd/tLp36gXJKK5ECipTtWv1sJidq/a9iZ9T4Op1AYTDdkE7s05UfG5iR3w1Gb63BNZCt5SSJhF5y5YyaLOQDtsoCxnK2hKdN1ZtBl39BLOjkXn1pf9g+TkEGfydWRe42ZbpztazN94ndtgknPr/jFWM6d48vMqmnkuGvLHm0ZxZf3s/+cZkod0bq0zyzticLXu8cx+lyw0W65r2p5OObjGuN4jU/lbVV5niGEuPOi82/tHTnjr+teliRgoJJZ9PJEjACzE/8OLcFizYAShy1WX+12lR+ahk0Yeir2FBVTGFrBAfQDm2vTmuhEdhT/JVnYAP0xBnUvH3u4Mmfq+NRucOu7XsUsdCCNSc3xSMjCjD3S8pm/RpVa13sapwEhqc1LeZU7CeALPv2PzWmZ08gwNPNfL24F6ARdc+78KeX7IWHr6NNmeHgUXm3f2c+k20ZHKrz92eomMZtPCw5EWAx9mk+KksOWCkb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(346002)(136003)(39860400002)(451199015)(6666004)(1076003)(41300700001)(5660300002)(44832011)(478600001)(6512007)(6486002)(450100002)(66946007)(86362001)(316002)(36756003)(66556008)(8676002)(8936002)(6506007)(2616005)(66476007)(83380400001)(38100700002)(186003)(2906002)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Tmwc57fXFb2SeEmdkglPkdf0Ct0fSY3eVsX7VA3zeMa6IKU/8/H25XY2bCqB?=
 =?us-ascii?Q?Q3ybMwY4fExtPkBRqPD0vOqwBLIMOG1GDqMg+WfapsgIt0k1SkcfJ8ewP35e?=
 =?us-ascii?Q?SCMGNOK+eE3crMdr+th6mc7CR/JgrA/h9HRJnEaM7JkVokwCLyeLNzGoN3hS?=
 =?us-ascii?Q?9tc7SI5a/yHUhZ+HBtBqIXsJM0TV7X70VUz8jW9f21Z81cKlP2TyYyR4gA1O?=
 =?us-ascii?Q?dKm9unTFNDPQlZKAsZcNdYGPVld+PpeQZTCqfjOUW8KREKaWyqASjLZWZG/0?=
 =?us-ascii?Q?PNyjP6zCtFZS34qnheY/aShvuZw9T3Ot0sHuWywLcJ+L4A5jI+e6zmUtEGoZ?=
 =?us-ascii?Q?wH3mmOaR9hA6NjFnVqKd4KdlK6ELzqHJEdz6vRIRWOhwXk1bN492izJtsMmz?=
 =?us-ascii?Q?GysmVAdUik1A5dbERS/OKi52gAsD6G3XMNq+u2gVMVP0OaDoDFmEzDJKNs2z?=
 =?us-ascii?Q?WTwvAjWCUiPEho/cc0mFlmchqz30IZsQ+SPx819zVHLhrk/0ZQAVLGZ1tf9/?=
 =?us-ascii?Q?3eZuFb7habB787tZQAdadove0v4WXaTSalx6g1pL1DwURvkgZq7aLfVv1S5B?=
 =?us-ascii?Q?GMKEEalO2gGkLnbrj9kLy//D5jCY4t2bxLFeYFupzOdb9W/oae01Z3Mceopc?=
 =?us-ascii?Q?GApOU6F5M0CSW3ZHqynyvROXN6H09iPG4CRSjNC5TsicL51Tr1fCLDTqV5FV?=
 =?us-ascii?Q?fUlwYuCoOrTyMRpMPt8m7Q+pykGtwXtJZquogYauF2qVA3iUMkwo4ynnQKwe?=
 =?us-ascii?Q?5UYqlWu1K742j5HBpmDu4+KbtgiVs1+D3nUN2mmoIe3BXDe+dwpGQ3/WAiET?=
 =?us-ascii?Q?HjLrgd1C8e78qy0pzoG52DLgAPEfDBNou7Q0KrvuDENaW/M0QLADGpZGsEOz?=
 =?us-ascii?Q?aimmvpYq6IKix1hN0UITg6yRnpkMeiDAweh1Eg/5QW3adgkhaJ0Q/LAXevbG?=
 =?us-ascii?Q?j2LSReA+DCBtH0t4GwoxY2TtLCOOQnaGGRCupib6q5Ouq/rgZ9QIj8+FbXBb?=
 =?us-ascii?Q?au4PumChp3M3kI1HO3jAYCZmk841spEVU3prlHVEn4o8kZ+JncoksJOZG6Bj?=
 =?us-ascii?Q?iUHmw60ZWI2Slc9EYGZbawvK3+fhAl+J+yJaewox+9aSbwpvA1TIilwhCi1b?=
 =?us-ascii?Q?QciMjUXTbne0Ya8Vwz0vPzIyGWZzJ/t6geF4VisiYrVrfI0BKxAKeMtB41hM?=
 =?us-ascii?Q?PRbxEKPElKVTFhCE0RCPQ9GOk8J40I8on2HNj7KSS6EMLq57z+Hoo3Ck1OIH?=
 =?us-ascii?Q?3hldsEkyuiU7nJ9dJ3HhGgwVcIT//wzpwDOgltjSef8IZxtglexi1Gc4dxQj?=
 =?us-ascii?Q?AQm/z7W/Vosiu2PXrV7LHiySfUV1RogzgTB4u4qR/Pd+34KZJYnXudhSHn3g?=
 =?us-ascii?Q?00+53TXkK+HketqELjfdwJoFgKbN0Jut+RM1z/vVqbbj+Gibz20eqUJjOtYN?=
 =?us-ascii?Q?5kSjGQQSjmflPPVhxOTK5diu4GTqQmGbsPjcjjsD28Z1053DmCZWa7CG9BP7?=
 =?us-ascii?Q?YLYfSYyzFMzuDe8sBpHJBtQMDtl404nAeLOGU4SsFURuFHOW3yehjaYPmxcv?=
 =?us-ascii?Q?XcWvmInZosxIDGBL6mOhtOkrfTgHaHA7nMZhLDHZFi4E8rjheJUQZgk7Ch/P?=
 =?us-ascii?Q?jD6GBPQJXcPsFmGReLu97YHdXQmy60xKdgCf1+7kW3XI3URXtOi14MFLycRG?=
 =?us-ascii?Q?261jFg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c67bc105-d6cb-4db6-ddfc-08daabf276a0
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2022 01:38:28.9066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YJbEUda0xB0A/COuTRj5NkSfBaykQnmRspzgsBo+DlcVUrQbxyzlIF6HYydKBetl0kyiOoeLFFTh7VkedbRxZRfwXcwNbPdEnt2H1A3Mlow=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5686
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-12_01,2022-10-11_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210120009
X-Proofpoint-GUID: W_YulvgjVv5VC4kClsOlRLuN4jHnzorI
X-Proofpoint-ORIG-GUID: W_YulvgjVv5VC4kClsOlRLuN4jHnzorI
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
index a25cbcd0..91b70a76 100644
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
index ae81b3fe..7fd7cc7a 100644
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

