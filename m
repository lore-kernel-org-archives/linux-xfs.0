Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9FE1C6FD19
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Mar 2023 22:38:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbjCHWia (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Mar 2023 17:38:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbjCHWiZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2023 17:38:25 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF1D61893
        for <linux-xfs@vger.kernel.org>; Wed,  8 Mar 2023 14:38:24 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328JxugW026671
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=6GP8mJBw+M/AN5gzsRzuXZkkeJob7qVdrYUi7TC2yiA=;
 b=k90hd/NtWcWB9nlDe8/hXPudKEDDpGY1RfovADfx6kZdVBetrowSwf0b502fNiIxgM82
 GyhlsizfYBgFWvqUO3gJ461Z65XO5cf31pEIFSXVleKsvqhf12LaptpgD1fhj3WY8TWD
 eB5kSuXz+SvC56Um5Ku1YKwovoh7wOFDxxXBPCGQvKFddwrsgSPb5ZycMl0a/e4EEdTw
 aBC8fI7PNWukusPQnuTagiEuGvyUOOIO2S1m9Czb93lwXy9BAkV+zKvO7xvwJml1Auja
 8ooskRhRGBHSoG1No77bHHGFG4SluBbpkH6l61E/Y2OejQQIRK4THeNffjHXMiT6GJnJ HQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p5nn95qen-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:23 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 328LnwIR021718
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:22 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6fr9dwug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b+cuI+zwY082daLhnYlNVEnEXJJHIO2HUphhXOiSxCCK1uCxzF0LvDfFIZgeH8YuuRzq2zvAszs+P+NZyRP+N6L+YZKHje60rZpQXXIi9vy1h+GHKtkBgbLugDO2D58vjtUW67mmZTNo5mAE9yKyUYh8mOLFzJoOH4s4vMxVB8Lgsyk3S/q0wmEBIK0RBuqrcdWZMzNHTkj1e3FV3OcMPExPZxEaoFwuc6b2U9XHAEUP91VwdMBDULxh2/dwr7wo3HYKYQ1gQLB7znwQ1jCk7KB1x8A6jlYzYe7FnFP+dRKA7m2W7kna0X6JjVJU2wZIJ5sr8wV2XFUuAuLFRwFQRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6GP8mJBw+M/AN5gzsRzuXZkkeJob7qVdrYUi7TC2yiA=;
 b=jdqDNhTrhCSEeB9TpeqwK3suA6LDOFgM/pVqs1NQsds0mUY//nALkU3LRQjv/JELqLrMzuwXYJiNzbzQ7lxmQVx7hih27nLVdmFCm95kD76L8cuYwmZutLFz0g3QQ31vhDI2kVPuqH0CRVwk7JuTGHncnPO5GAflmprkxbK7Ucgi62EHGqOr6bYNfrlrTsriOShvG2NcSpLoFAoZeEPZ2tCmIchDVMlMaBdEQ/uvP0qFvwM961tBSTrsTpOmicSnkejmnX94VLehTjNSoAbQRHqCUa7n3a5UmgNj0BJqpJirD6YscpG7AdZn5hrrOZX3Drd5tNqnu/mdrE+YZwQZhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6GP8mJBw+M/AN5gzsRzuXZkkeJob7qVdrYUi7TC2yiA=;
 b=BtVZjXmSGCPNQ+VsgXhC5a1myJYyjUYOpMvvOgVmcA3O1CJl1gAemeAI4XtBidqblwPCPEr1wZBD3caMYxswbpaZbXUKF87GS0miNM3pGFZMEHgmPuH3MgF+XWoGa/eINptTkdnOFmO6J/odVNtP7rMPdnK4y/oOw/3nO6ijjNk=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB5708.namprd10.prod.outlook.com (2603:10b6:510:146::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.27; Wed, 8 Mar
 2023 22:38:20 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06%8]) with mapi id 15.20.6178.017; Wed, 8 Mar 2023
 22:38:20 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 13/32] xfs: Add xfs_verify_pptr
Date:   Wed,  8 Mar 2023 15:37:35 -0700
Message-Id: <20230308223754.1455051-14-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230308223754.1455051-1-allison.henderson@oracle.com>
References: <20230308223754.1455051-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0006.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::11) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB5708:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c119925-fec1-4a69-5fc9-08db2025d198
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X8QS0t8tP6318bSppMq1E13V9uDYhbBW5zFCRO8Mk+/2u6b7SgBaroCbvyw/NcyQPGV3rv0hgXE3iiDfRDcGx8nt07/8Lu4JOUo8RpAubGK1sR4UUfTI4aAINK5L5UiLZiSOfEbss/+MY9x3hP8LjXeEGcqwwXicxTC/vnKCIY0W0I+Xzaa5pSn+jfqCYoHVGCYd09xmPKECf1Quhh5GpCEGYc+l1I12SwR4NWkHp0t9vW0VSfl2mB8hL18X+Ci5x3nijVi3IfHKAOjMiMy/4uHcu4dHO3MDk4mcAXjA8D6EzkHMtRRA05gqISzvuSbAtWopgap6kPY/Y0Jds6f6RCvbGuLUUVOy8DYP75VyFkTVG9NyOBa+WTfohnkhPUAMkC73iDTWJPuaadnEeVvwtFIp4n2ogsCqoryEg1WNksvjYeU/JYjYDpbxQAnfVfi3EEm4uVhL6S+d5BFiwE9PLRrYjTM2QvoT9E13Ia4ucEaXAXhLgWpjmMKP5+nbcSLQAGQG13LsjKGxrL7e4AbUHanCNVHIsBrBH/NAmOiY4IdLzPVhF2fy0prNBBsxpR9fnQk131W9ZlU80y2g2W6yjhug/L3Wxk0E1xFCdbEIBOJwy8ubahsS36FGMp/Xxl3WPeGFrQVdQnFEAAGEfVEHug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(136003)(39860400002)(376002)(451199018)(36756003)(6666004)(478600001)(83380400001)(6486002)(6506007)(186003)(9686003)(1076003)(2616005)(6916009)(6512007)(8936002)(66476007)(66946007)(2906002)(66556008)(41300700001)(8676002)(86362001)(5660300002)(26005)(316002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aSJwbf6w5lotUQMmPgGJSqk0axHrXz63cuSg37JSZ4AJcoPXeXlFZkquMyGY?=
 =?us-ascii?Q?OVegLE2We7bDgiwwuyG5gSRgrLI0TpvV6JS5r29acM0tiiiw5SRNkcW0gEW2?=
 =?us-ascii?Q?7l6AF2z63AgNTYBVVZILb8YGsy0O4PuMrE1SRByLjeoRgpuYmJJg7ukANTE0?=
 =?us-ascii?Q?5wtNDj1PhwTo8HN3X1rrlxWJZb21MNP/R1BZingctpUgY44wDasIe/E6udKS?=
 =?us-ascii?Q?CGtyOgBqXGutYf7gVUG8r8YXQ5KB2cx5/9CsMctsNPwhddxoQ/lVC/l4qIVV?=
 =?us-ascii?Q?Isxw8Kehx9Lrk73pSiBmXJxOY6ebt/0nsFwEvBzyAsrPILNrYxei5fftSwNx?=
 =?us-ascii?Q?XKRS6VknGlA6No48EmZWSBBbSEleGs4sL/+go8hMahwtW7Rh39WOkuaNdtwS?=
 =?us-ascii?Q?//4aOOzddfeXcAHDzDcs3SuKV0qAUqfz8MMZRpdKlfcu1J/exZEcPQRN//D8?=
 =?us-ascii?Q?rZChF0gPtj6byn8/+4XKWiGT2Vx7C5bVZjompf6ke3xiWWrzllbGADYpB1H5?=
 =?us-ascii?Q?4F5eqHXpsKuiSDj0939P+0lYyilPErahZ36jKdjecyuN1rHswadDIYnLXaLD?=
 =?us-ascii?Q?KI+x1KSAhWchTIcykP1/js9oKANQSaZl1ucQNsEPP3ziKJie/6vbd1HKxgTz?=
 =?us-ascii?Q?UDJ4yNuxNarV/sV3ifwmMuGOg2e5qEcSsv8Nyi2UIT38xiYnPPeS+gLiD/76?=
 =?us-ascii?Q?SDftt8bX5W3XK1VuzvbDSmWzRjgGczPN94xB4jN6WBqxeFuJEvDBKVv+hD30?=
 =?us-ascii?Q?BGIgHqOqjN/wjTxkeahWlWE8BwN4HnStBADGZFGSGcrX5rvnBprB85tnsw55?=
 =?us-ascii?Q?xfTblYIPMPPjVlBNPQ/WH42D2Ggg7vlRAhcv2OtxUclEsSsHqUDD1PH0JHRV?=
 =?us-ascii?Q?jVKJb+m3/aJgGdVwzWaX/wBmT1fPP0/aCdPzIbdWTqsOHlP3n4W2rvpm12Cd?=
 =?us-ascii?Q?vQfgyr0Inx/3zhgNrzjhEOp+4cM7Po4J3TsFVnT1KLiaRY4jB3EMNYR8cSRv?=
 =?us-ascii?Q?TVz97lcFDkdvZB/A07VH4+adxS5+ienFn6JCKIpmMlJYoPIci4jAitBWKhpz?=
 =?us-ascii?Q?T0jgfM24pSAptB5W1QfpIamDK94JAusE3CxCYEq3DbqCvRFqg5hw06aOZ+EJ?=
 =?us-ascii?Q?F6/tz23RiRLZqa0AkrhCdMmqBt2MdcgqStnUIZNbVSMEzdtJGEqeqy5VuInz?=
 =?us-ascii?Q?HGzG15tcIhTA+LHIDdvbNSnE5vu8RMZPDPyO5CCMLaOqnyw1rHQ9l7vi5GQn?=
 =?us-ascii?Q?+PyWIbgYcVvr9KNMIZh82yUlLuKyXdbZ+mudKDaO4lEtldBK4zl09xo2GgC8?=
 =?us-ascii?Q?9y1BvMyl0CPQpCBjmZin/mi1jZzJLVL/sadEqS576Bqwd3nH8JrN9nHWfMnv?=
 =?us-ascii?Q?9HSFHZmfwKbYFJT8qDVVFSY+Rkc3xVpxNViQa50umqEImtWTo/zga1+3KSHO?=
 =?us-ascii?Q?kb7ok6Me+8IIIBWtAcco4eSM2R0yY2hd5l5F5SWwL8fEu2kmPlrUNyERK/sC?=
 =?us-ascii?Q?RjUWyKIOUJJ+7Mm8u5L3dHL4K/N2NfE5PhrayJZes7NuH4gIK8vIqpP1QU4l?=
 =?us-ascii?Q?oxpPvwDpEt+AhP5Owp/EoMxXP1RG873WgT6ZLJqz8EhYKim98XGmqwXoeWwF?=
 =?us-ascii?Q?Hg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: cowvsy3ojr/hnkt0Msc+N+42gCCefxuV8knKeLyQcLfNaMc1XC5k99VtQVjpnGWwtyM8itiWJ5887Z3ssOqVk1BFCf5UmwACBY0D1kZkR4Jwylveqa9wOot+YqMdVEezbPyXO3bybji9pxlLgBZhomClYKqxlayEftqfd+m40IQvMXGckWfBr+elk9AbkCDnZhPXy2u+qb5YBEaJlDIUCyfC1PzAWNs5ghpbJyE2k7SGC0Cu4RHgbL1gUZ5OWQRmz9xU1Ah1vKmjmUWD0klPUn8U1Ux3GBHO7UMgpDGk79mWALubiLDUakAP1BausSH6ZRVSuL9lieWTJKOzAOgF0oNkRgnc/3YQT915nm2yZarTUKMD5iVVBb0lAneSQ2DlM1bvYLMD5TRNqbg87cK63WGOhrmtAV7NS0z7L9PbQZ8o7CHgII9P6+fty4q6R1fGj93GfP7CCoTg0HDDlPk2HgUhlBXw8u2kdW6iEiFPsMC+PFQDO9s5BqehuFYqfnxtxqprcZMUxXEmLlUI6BODZCB811fAGQeGJ5f919C96aA/WSWvMFGt3AHrm/B2xWQVWCfYzp+iQg0BGzolD0ITAUqFJl2jvHK1leS4hQU0U4JPM/g93B/sCB4eXtIgio2V3EzJkyPLflVlEFfA0Qw+8B3xB47nPjNYPKI7ChXy8zDQGtKqyLzOP1wQgHYCw0g/5Z4UwkK5e/y+XRd/razkOeXf+2j0D1cNdYxtJBumJ2ZP9VnK5sXUL+0llD4g3zUNSR6mrV1QBbBx+Pi+aUJxrQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c119925-fec1-4a69-5fc9-08db2025d198
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 22:38:20.7403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NeebfuGGpgOyg6IcjEju8Sjsx1ezY4/d50zpHzF4JHoZ77CWtCbNftoK8FQSAsXbqVeY5BiNOsQhL0m05BLKTjVTl9w/LAgQTFgMFY6qzb8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5708
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_15,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303080190
X-Proofpoint-GUID: D6rPPy1Bq0tPSJdBT8tom5Zov-DzBnYQ
X-Proofpoint-ORIG-GUID: D6rPPy1Bq0tPSJdBT8tom5Zov-DzBnYQ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Attribute names of parent pointers are not strings.  So we need to modify
attr_namecheck to verify parent pointer records when the XFS_ATTR_PARENT flag is
set.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c      | 47 ++++++++++++++++++++++++++++++++---
 fs/xfs/libxfs/xfs_attr.h      |  3 ++-
 fs/xfs/libxfs/xfs_da_format.h |  8 ++++++
 fs/xfs/scrub/attr.c           |  2 +-
 fs/xfs/xfs_attr_item.c        | 11 +++++---
 fs/xfs/xfs_attr_list.c        | 17 +++++++++----
 6 files changed, 74 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 101823772bf9..711022742e34 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1577,9 +1577,33 @@ xfs_attr_node_get(
 	return error;
 }
 
-/* Returns true if the attribute entry name is valid. */
-bool
-xfs_attr_namecheck(
+/*
+ * Verify parent pointer attribute is valid.
+ * Return true on success or false on failure
+ */
+STATIC bool
+xfs_verify_pptr(
+	struct xfs_mount			*mp,
+	const struct xfs_parent_name_rec	*rec)
+{
+	xfs_ino_t				p_ino;
+	xfs_dir2_dataptr_t			p_diroffset;
+
+	p_ino = be64_to_cpu(rec->p_ino);
+	p_diroffset = be32_to_cpu(rec->p_diroffset);
+
+	if (!xfs_verify_ino(mp, p_ino))
+		return false;
+
+	if (p_diroffset > XFS_DIR2_MAX_DATAPTR)
+		return false;
+
+	return true;
+}
+
+/* Returns true if the string attribute entry name is valid. */
+static bool
+xfs_str_attr_namecheck(
 	const void	*name,
 	size_t		length)
 {
@@ -1594,6 +1618,23 @@ xfs_attr_namecheck(
 	return !memchr(name, 0, length);
 }
 
+/* Returns true if the attribute entry name is valid. */
+bool
+xfs_attr_namecheck(
+	struct xfs_mount	*mp,
+	const void		*name,
+	size_t			length,
+	int			flags)
+{
+	if (flags & XFS_ATTR_PARENT) {
+		if (length != sizeof(struct xfs_parent_name_rec))
+			return false;
+		return xfs_verify_pptr(mp, (struct xfs_parent_name_rec *)name);
+	}
+
+	return xfs_str_attr_namecheck(name, length);
+}
+
 int __init
 xfs_attr_intent_init_cache(void)
 {
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 3e81f3f48560..b79dae788cfb 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -547,7 +547,8 @@ int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
-bool xfs_attr_namecheck(const void *name, size_t length);
+bool xfs_attr_namecheck(struct xfs_mount *mp, const void *name, size_t length,
+			int flags);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
 			 unsigned int *total);
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index b02b67f1999e..75b13807145d 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -731,6 +731,14 @@ xfs_attr3_leaf_name(xfs_attr_leafblock_t *leafp, int idx)
 	return &((char *)leafp)[be16_to_cpu(entries[idx].nameidx)];
 }
 
+static inline int
+xfs_attr3_leaf_flags(xfs_attr_leafblock_t *leafp, int idx)
+{
+	struct xfs_attr_leaf_entry *entries = xfs_attr3_leaf_entryp(leafp);
+
+	return entries[idx].flags;
+}
+
 static inline xfs_attr_leaf_name_remote_t *
 xfs_attr3_leaf_name_remote(xfs_attr_leafblock_t *leafp, int idx)
 {
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 9d2e33743ecd..2a79a13cb600 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -129,7 +129,7 @@ xchk_xattr_listent(
 	}
 
 	/* Does this name make sense? */
-	if (!xfs_attr_namecheck(name, namelen)) {
+	if (!xfs_attr_namecheck(sx->sc->mp, name, namelen, flags)) {
 		xchk_fblock_set_corrupt(sx->sc, XFS_ATTR_FORK, args.blkno);
 		return;
 	}
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 95e9ecbb4a67..da807f286a09 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -593,7 +593,8 @@ xfs_attri_item_recover(
 	 */
 	attrp = &attrip->attri_format;
 	if (!xfs_attri_validate(mp, attrp) ||
-	    !xfs_attr_namecheck(nv->name.i_addr, nv->name.i_len))
+	    !xfs_attr_namecheck(mp, nv->name.i_addr, nv->name.i_len,
+				attrp->alfi_attr_filter))
 		return -EFSCORRUPTED;
 
 	error = xlog_recover_iget(mp,  attrp->alfi_ino, &ip);
@@ -804,7 +805,8 @@ xlog_recover_attri_commit_pass2(
 	}
 
 	attr_name = item->ri_buf[i].i_addr;
-	if (!xfs_attr_namecheck(attr_name, attri_formatp->alfi_name_len)) {
+	if (!xfs_attr_namecheck(mp, attr_name, attri_formatp->alfi_name_len,
+				attri_formatp->alfi_attr_filter)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				item->ri_buf[i].i_addr, item->ri_buf[i].i_len);
 		return -EFSCORRUPTED;
@@ -822,8 +824,9 @@ xlog_recover_attri_commit_pass2(
 		}
 
 		attr_nname = item->ri_buf[i].i_addr;
-		if (!xfs_attr_namecheck(attr_nname,
-				attri_formatp->alfi_nname_len)) {
+		if (!xfs_attr_namecheck(mp, attr_nname,
+				attri_formatp->alfi_nname_len,
+				attri_formatp->alfi_attr_filter)) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					item->ri_buf[i].i_addr,
 					item->ri_buf[i].i_len);
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 99bbbe1a0e44..a51f7f13a352 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -58,9 +58,13 @@ xfs_attr_shortform_list(
 	struct xfs_attr_sf_sort		*sbuf, *sbp;
 	struct xfs_attr_shortform	*sf;
 	struct xfs_attr_sf_entry	*sfe;
+	struct xfs_mount		*mp;
 	int				sbsize, nsbuf, count, i;
 	int				error = 0;
 
+	ASSERT(context != NULL);
+	ASSERT(dp != NULL);
+	mp = dp->i_mount;
 	sf = (struct xfs_attr_shortform *)dp->i_af.if_u1.if_data;
 	ASSERT(sf != NULL);
 	if (!sf->hdr.count)
@@ -82,8 +86,9 @@ xfs_attr_shortform_list(
 	     (dp->i_af.if_bytes + sf->hdr.count * 16) < context->bufsize)) {
 		for (i = 0, sfe = &sf->list[0]; i < sf->hdr.count; i++) {
 			if (XFS_IS_CORRUPT(context->dp->i_mount,
-					   !xfs_attr_namecheck(sfe->nameval,
-							       sfe->namelen)))
+					   !xfs_attr_namecheck(mp, sfe->nameval,
+							       sfe->namelen,
+							       sfe->flags)))
 				return -EFSCORRUPTED;
 			context->put_listent(context,
 					     sfe->flags,
@@ -174,8 +179,9 @@ xfs_attr_shortform_list(
 			cursor->offset = 0;
 		}
 		if (XFS_IS_CORRUPT(context->dp->i_mount,
-				   !xfs_attr_namecheck(sbp->name,
-						       sbp->namelen))) {
+				   !xfs_attr_namecheck(mp, sbp->name,
+						       sbp->namelen,
+						       sbp->flags))) {
 			error = -EFSCORRUPTED;
 			goto out;
 		}
@@ -465,7 +471,8 @@ xfs_attr3_leaf_list_int(
 		}
 
 		if (XFS_IS_CORRUPT(context->dp->i_mount,
-				   !xfs_attr_namecheck(name, namelen)))
+				   !xfs_attr_namecheck(mp, name, namelen,
+						       entry->flags)))
 			return -EFSCORRUPTED;
 		context->put_listent(context, entry->flags,
 					      name, namelen, valuelen);
-- 
2.25.1

