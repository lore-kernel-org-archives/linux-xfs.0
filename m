Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A6A6CE7B1F
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Sep 2023 09:54:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232818AbjI2Jyb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 29 Sep 2023 05:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232746AbjI2Jyb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Sep 2023 05:54:31 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E1AD199
        for <linux-xfs@vger.kernel.org>; Fri, 29 Sep 2023 02:54:29 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38SK9aHK023061;
        Fri, 29 Sep 2023 09:54:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=d7LJ1P+6FhAWXlMfhnJYPM8n0kwzGFrbDFqiilwP6NI=;
 b=V0x5HsxpxTcA3FnBlJdr1bFKhrpoyJCMcTTXtiIgYUo3N6KftL94teZORBwVRbv/Ert0
 mpDa/r+dEQobwMhgIVIz2hHO7T6oHBXaT8hGuMKgiybxJXHQ211l9gQrTUzxpROXkcPB
 pLa9fQS4e3x4pp8MOhPT3ySIcU2tAOYRU6+ugJIjKL5qj9lUF1E3efwRgUWrqPC8A0C4
 1ORzqwLJGSM0ciFvoXDZuYL1b7G5GHiAQzyGF2bbu8XuSqfHncI/O3IWRc9eYg6jmf5O
 cpEQqkZXDuLK0bphufZziH99a8LXUX3Tw8+almeelrYRGXJ+NOy7/2UUHIOImd1kZ8s3 +g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t9pxc6hmw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Sep 2023 09:54:22 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38T7tjd7040667;
        Fri, 29 Sep 2023 09:54:20 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2176.outbound.protection.outlook.com [104.47.73.176])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t9pfhbtjq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Sep 2023 09:54:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LW7Z0MQhrd88nwysZSBMd0X3+RlqjTR/FIQxYByIYIrbxDYP+QdwWN8a/OcnKEafXTeVBt6UC5nYW9eomB/6hryJUuv6Q9i/uKgGRz5i5++ymTWw6at+B7BQDax2nlwMezN538K4+oKrNj0W4K32bMD+VXTCE/3lWul9yj6EoT6xhYkjwUE2lKEJMIE//DATZNo+HjYkjUrQWU64LGBvY2/RGOyi7zEDIpwY9xyN7MAiypWo4Eh/VFGUZZTxtwNi8j32guDuqRmxgTkcDrGiqWnaPiXg8TFtNxhmquGuJd4DrCzTOi3Y54vWNfP/BcxdxCI3y8OwpdAsN6YYy8QFhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d7LJ1P+6FhAWXlMfhnJYPM8n0kwzGFrbDFqiilwP6NI=;
 b=AG+OVht1cAM3/p2JL4JXZkbMml4l71DZGzTpylwEV83JMOPuQg5/U7X8OG66zOCMEmssv4oZRoKSlQS0uY6s1rXzHcXFiT/6WG9RKYi3a7eZP3Db9aqZcJFrY7oV5hn/eY0doTHhpHgCi4lo5WemzkBvnK5rNBWWHGVNtZKlaa9Mf5z0+UItxVkBl95yZxkc2VEP67OB8Pn8qmtoAIXPU+EWAm09YaLs145YzpuJNgrvo52hOIJjH4v8yauAxYPvD2FxAKf0ZPS+IAp4zdPlH6VEm7lEn4G4NdUGhzl0flMOGcK0Zwaqb09KcZ3y1hA5/c/a0/UzmWH/MQ1g7MCVEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d7LJ1P+6FhAWXlMfhnJYPM8n0kwzGFrbDFqiilwP6NI=;
 b=IYd/jAiB9lAsHcHNpApcxKCT5QUndLTHiA04hmx1tadWDrs0LzXO2YDfPzLGx62taJr0y74Eb7IZWghuvQAoi/AW0Lfch0EN+cFfZ+apMm9F9zgODSU6GJfuiQDcxY8DEQtwICNkzIiN9Muzmn+B29PO0SIrqmR4xuFZXa242UI=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB5742.namprd10.prod.outlook.com (2603:10b6:a03:3ed::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.21; Fri, 29 Sep
 2023 09:54:18 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce%7]) with mapi id 15.20.6813.027; Fri, 29 Sep 2023
 09:54:18 +0000
From:   John Garry <john.g.garry@oracle.com>
To:     djwong@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
        chandanbabu@kernel.org, cem@kernel.org
Cc:     martin.petersen@oracle.com, John Garry <john.g.garry@oracle.com>
Subject: [PATCH 5/7] xfs_repair: check the force-align flag
Date:   Fri, 29 Sep 2023 09:53:40 +0000
Message-Id: <20230929095342.2976587-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230929095342.2976587-1-john.g.garry@oracle.com>
References: <20230929095342.2976587-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0194.namprd05.prod.outlook.com
 (2603:10b6:a03:330::19) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB5742:EE_
X-MS-Office365-Filtering-Correlation-Id: b913e536-9252-477d-85ca-08dbc0d20c57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g/nxd6frMUkjQm9yzLlucv6k9bFZMkJxf5RD4c/jxkzWfCfIgAhixOIX6S7ClbJk1N61RhYbVo5qoTgneCVzAjGz58DuXtQvlu8eHHeKrqRBJhjDufWg495BIJJtvEwsFc6k6Ljsne6+as5T9+RWy5OKUmb8cXB92jr6F1sx4Y970olIGx7eLFMEa8r2xoHPyV9HD8WH4PntYMw3hVPV9hUll/AuD/ACiv5KeNu19FKsUpj52RvZTkL+aOxW902PmbwqzMaQFgWVGukEI1yuKzbFKcZQ5dk1PJliB72qLoPhuu+uPk8KbeQhA3uo0JL9DBjBrS1Zkzbsbhe53yf4iTHIcbnIrP/RZLtaeBCe0EaogmzlWcusK4/8wbtZ2taVPa84N0wWNwnR9qg1bwxF4WdGB9TzesnabhyPn+xZTXB8OLgQEJTQTwWQZDLtmALZPrR7Fsh5O9mDec5r1gCCYlk9cmTdmYmUxNtvkVmzCQgGQNqwwzwvH6kmoUOHX2vDw/vqQBV+2/LMm4H774JAVv2nKIMS2IFl/43rkKUzMZLwQ+idK0lxsTIyEuvgwJRj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(376002)(366004)(39860400002)(346002)(230922051799003)(451199024)(1800799009)(186009)(64100799003)(2616005)(5660300002)(107886003)(4326008)(8936002)(8676002)(6512007)(41300700001)(26005)(6506007)(1076003)(83380400001)(38100700002)(6666004)(478600001)(316002)(66946007)(66556008)(66476007)(36756003)(86362001)(103116003)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sotKm8sLm0k5bzUZxdvXAaE7SbyR7ihe+FzMmEqUG5rNdQmowJGztDzcl4/F?=
 =?us-ascii?Q?jm2e4PXHFlmKE0mLAr+cxhdZXkddrUkig5IdYjHMsuW7VLGivgM+S9UDc7O8?=
 =?us-ascii?Q?1+qIefanIogHCSeOYAXj9OCbqkv95Hl2mY/Hyk6ncEaWH0Kr1ofth2EmyeAh?=
 =?us-ascii?Q?riNMVkEPNdQyH0JG30alf6bm2SOXNYEYaoHMG97HVFwERcJIE0Wmn4AFswEX?=
 =?us-ascii?Q?2sSifhzSmIq0nZU3nBJM7dxSTFdsmKyyltKXu8fPqpkzDPngE7ynbscH9P9/?=
 =?us-ascii?Q?wdZa3ILS0hUwSS7siUzT3P/ncr7xCKbeF28BfhVwMDPQb6+pZFSWZG6dg7OB?=
 =?us-ascii?Q?qgy9OD9c+CQeoJrFASP5qe8D/ruTZwy5gHMzCftnjoT51n03sCpJKnkzTFzh?=
 =?us-ascii?Q?0c53m0eQ10amt4TMFwjDQAcWNolJhmioY0oEFpV+9b1szAGjiSyikvhMNjVw?=
 =?us-ascii?Q?e+J8sNNyBMRqy2BlRrls0cHn6+ydqw47voydqwvLrT45GGigqLrP33WS2TK2?=
 =?us-ascii?Q?qMmff6/8BmdIN8wK/FxPsoY2QsM3saIXC7F/FH4uGsxwmZqWDg5G8563a16l?=
 =?us-ascii?Q?6dHufAHGPGgd4zb7kP/dwPFE3txWw7gxt6MwigtFVe1I1L8NW6e1qQZ9Ted7?=
 =?us-ascii?Q?9SMMBCMJb0VqjZg6mUjPKZ3WaulL6dxt5gviletjTkwVbEs7E9T6Q60DCtNg?=
 =?us-ascii?Q?bb4a5sFfuJR8SK8QdBKupG9c+LqJ4QQixYadodkIVNeSH3IDSweol7Ch6Qhv?=
 =?us-ascii?Q?7VxqFk61HdbOwIgJvtuukMHs6ixmDa1DNPVgKth7gP9p6Td55MqCk3P7blQh?=
 =?us-ascii?Q?R0dwcXyB+wUksFx9vgKfc8VDuyrOqLnvp6HdVs2qQiXTSO2BJVXpLFZJwjOF?=
 =?us-ascii?Q?ckcg7g+EbnWvIAwgsiJPt80PRB99VJZDS+LhlU2y83BHZVBNLb764AbEFF30?=
 =?us-ascii?Q?3pAQdRCWS42hDgzx1L0PCKdzdCzcdC08SAasRbEuJgS/G0m3Xwty/Hyc8VtB?=
 =?us-ascii?Q?S8SCi4SS/Td9lfnaIjWEPm4HuARwNfWVxFGqV3kAqyY85+ddhwHaD6DDQLMr?=
 =?us-ascii?Q?hbk3dVnDq9/TvGtvr9s9jJ+LguQyulWZzSMKKx9kGk9DyAnbxCnjTkyxQA85?=
 =?us-ascii?Q?qn89pXLCOR6b7pHtLvU0CbYD/SqSV5tmgBMrod+aW+ksMqO9LaYQPfz4LRM/?=
 =?us-ascii?Q?WoWk37guFyIxE0aM8VD9b0XTMTrPeHBKGioHsGHDJUTUd3mXUhF7QktY3WK1?=
 =?us-ascii?Q?BefcgQt048FdOw4TXkCX9beidyspGSCa8jyzsXoWlIfYBQUQgJrQypgn7vym?=
 =?us-ascii?Q?u6KnvqObE8UoQhg0kaFp9loa27zQMBm8/GGcueGbL8lxTosfeeb2Xb2azfuY?=
 =?us-ascii?Q?rVL3pUHug5iBuBb/1Y0et149cTN7RwPjIzMCaQdWhN3bsR7U7P/YdKsMP0fn?=
 =?us-ascii?Q?FTgf2ajCKgDQOu7W8AJnI/H9qqdCxtOMnRPnnuP4BmbHNcaIzGren4ma+YV7?=
 =?us-ascii?Q?BJtlKy0nUlH0tKmk8h7WYtGvqd7WwRbiyOHqlbu2ojqWBKyx+lSimL+Nm05+?=
 =?us-ascii?Q?ZDnMkUqIW/ZjtBbN4dZQ7z4f5Zrv4wMCALLSuRAtZG20A8FQpMjDdEJdqTTQ?=
 =?us-ascii?Q?PA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: pKhO7UcaKRSHw6Y5Tti57gn2FTWRXmB23w38WHUwGOg5VM7TB+hSKcJeglV03ArI8bqhytEtliuuu94Z91p3ibRxMxYG+rTpFCm6xEf52ycY6hGixVWR3p8bgAVoqeqCzhEFccA9b3WYcPgJrz4CdhCa9b74ZETn8Vhw5/cQJ8pzCWYIHgI50sdx3mzVQo+k82bkwUpJ/DId0ccd6VptUFIofFEBR+VNFZHNZVtuQE6A7mYJC/Q5Bg8lRhMUZ9vTGh5rQ46mjbCNy+6XDIji+2edVjpC6Zy7Ia6fTIJKVUHzKxXKqSUs0JPH1NUu5IXCeCY/l5lwtG/Fj1vKukmbGcVyAhq6eJgO7gsbRDEv4fE0bVOIqZfpoi8a57zSFRufWxiSxjAnRTSUWDZVCyBg4+9IgFK/NJn2lhQmEzbXayIhAXPAZ4JXwPVafC10h4quRcGCmGDCfG8LX0AFJQJD/997ev/AWQ44Ygo56Vg6oCVCLB/btqchHzuL3w4Nh5yyFCNonvn4/UCbYcvFxVreKLZYjZqwi1QNmFiNVn8sjF5va0oBRjRP8C/YRiqXzb1OhKZNryucfPH/MJIsF+KrrRmwYSGpV54D7F7WU76wWcqiAD37UJpT+vhUPoUEmy1InvFC7mMmcajxmlusso+YNxIe9LoKRiKtepxkItr6GNnBf9hOgC+RNMOQLiaSYApilv5kW/cvAQyBivOjDd7qvgbngKZUvOtcRuqi5ZDqzRBP123ZYWyFMNGxbETwguYSqHHR8GjiRVZIpYjFSvYTzh3m6bHuHM4fu9CwkgqO1EO493bUxcqzij6KwzWcUXJ665LlmmvXM5SM24P1Lv2K4Q==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b913e536-9252-477d-85ca-08dbc0d20c57
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2023 09:54:18.6731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6GjQrFkbVOojnb2jlPPDHJUphPdCnFBaeASzYJvTTyrG45KrHAibsNftnpeiANN1dkvTtDJPiWG7EsWgx9jDDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5742
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-29_07,2023-09-28_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2309290085
X-Proofpoint-GUID: GsHNL3cpLbmz2lipyD50PXdQnLc0JGEM
X-Proofpoint-ORIG-GUID: GsHNL3cpLbmz2lipyD50PXdQnLc0JGEM
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

Make sure the flag isn't set incorrectly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 repair/dinode.c | 66 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/repair/dinode.c b/repair/dinode.c
index e534a01b5009..a9de2ee73ef4 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2262,6 +2262,69 @@ _("Bad extent size hint %u on inode %" PRIu64 ", "),
 	}
 }
 
+static void
+validate_forcealign(
+	struct xfs_mount	*mp,
+	struct xfs_dinode	*dino,
+	xfs_ino_t		lino,
+	int			*dirty)
+{
+	uint16_t		mode;
+	uint16_t		flags;
+	uint64_t		flags2;
+	
+	mode = be16_to_cpu(dino->di_mode);
+	flags = be16_to_cpu(dino->di_flags);
+	flags2 = be64_to_cpu(dino->di_flags2);
+
+	if (!(flags2 & XFS_DIFLAG2_FORCEALIGN))
+		return;
+
+	if (!xfs_has_forcealign(mp)) {
+		do_warn(
+ _("Filesystem does not support forcealign flag set on inode %" PRIu64 ", "),
+					lino);
+		goto zap;
+	}
+
+	if (!S_ISDIR(mode) && !S_ISREG(mode)) {
+		do_warn(
+ _("Cannot have forcealign inode flag set on non-dir non-regular file inode %" PRIu64 "\n"),
+					lino);
+		goto zap;
+	}
+
+	if (flags & XFS_DIFLAG_REALTIME) {
+		do_warn(
+ _("Cannot have forcealign inode flag set on realtime inode %" PRIu64 "\n"),
+					lino);
+		goto zap;
+	}
+
+	if (dino->di_extsize == 0) {
+		do_warn(
+ _("Cannot have forcealign inode flag set without an extent size hint on inode %" PRIu64 "\n"),
+					lino);
+		goto zap;
+	}
+
+	if (dino->di_cowextsize != 0) {
+		do_warn(
+ _("Cannot have forcealign inode flag set with nonzero CoW extent size hint on inode %" PRIu64 "\n"),
+					lino);
+		goto zap;
+	}
+
+	return;
+zap:
+	if (!no_modify) {
+		do_warn(_("clearing flag\n"));
+		dino->di_flags2 &= ~cpu_to_be64(XFS_DIFLAG2_FORCEALIGN);
+		*dirty = 1;
+	} else
+		do_warn(_("would clear flag\n"));
+}
+
 /*
  * returns 0 if the inode is ok, 1 if the inode is corrupt
  * check_dups can be set to 1 *only* when called by the
@@ -2833,6 +2896,9 @@ _("Bad CoW extent size %u on inode %" PRIu64 ", "),
 			do_warn(_("would reset to zero\n"));
 	}
 
+	if (dino->di_version >= 3)
+		validate_forcealign(mp, dino, lino, dirty);
+
 	/* nsec fields cannot be larger than 1 billion */
 	check_nsec("atime", lino, dino, &dino->di_atime, dirty);
 	check_nsec("mtime", lino, dino, &dino->di_mtime, dirty);
-- 
2.34.1

