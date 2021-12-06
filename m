Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCBE1C433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Dec 2021 23:55:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377746AbhLFX7O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Dec 2021 18:59:14 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:25046 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377826AbhLFX7K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Dec 2021 18:59:10 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B6M5M7s016268
        for <linux-xfs@vger.kernel.org>; Mon, 6 Dec 2021 23:55:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=p1xjLYJXipUsei0fiJcwDobHYIv1oruEvUn1O/3j5dA=;
 b=tSkckelby3l1S8zPOOOi23Hz7YqEuMeB/cZSpnMdhc/KiTy9mrVWFiu9du9Iuz+MQIa1
 M8Os3CHlynASLSfIeV1L4hvaThK+U5FdcXA8Kw9sHGR8zjCdiyb5qpzat5jhTC8h5rM0
 LFP/2AJf3m0tESw4GilvxAqOZyNFy9ywOgrFsdrePXF8Ajcy0xqNo2JpLz07dC7sqcy3
 +pd2KI6j5bfsu2pjUvRV67v5mzePh/zv8mDB+17yIf9qQDswKaO14vZW1mWaWeULhgTn
 LmefygRLS1GPDLWgl1Wl4kXiERtFa2hDG7WHhDKMk/UHQz2x5qZs+s6NbB6EpCyhuBYC OQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3csctwkv7r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 06 Dec 2021 23:55:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B6Nk4oS068205
        for <linux-xfs@vger.kernel.org>; Mon, 6 Dec 2021 23:55:40 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by aserp3020.oracle.com with ESMTP id 3cr05459d2-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 06 Dec 2021 23:55:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QU+BnLrnVp/hw016pvIgtvpCw5FvJ1OlLuFil7mMIBMzM8HBdKnP2cexoHB51ddd76+NIA1Ou5T4tNVyeIOvEB6NvNaNRO83fiBn+g8aRIaYwQjGmUdIl8dzHYR1P2fZ/2msmTt7FenXdAZlegN9hhSRDETxKrKdKnZVUN2qCIXhDRnyvlTSIYxp3vkKtMSRvH0WMeQtxQBX0Lk6JE8VwcyM06ohfEdp4Ww/gcUiVCDxS513Z0f8QO+W8ckVaaRmg0x27YYybVZLRj4NWsXcVFbhp3tK8v5DcYAotgRNECkqtManxsye4OrF9dDIAzXdtCwkxK26IFtLJhHzbxMFMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p1xjLYJXipUsei0fiJcwDobHYIv1oruEvUn1O/3j5dA=;
 b=QiQj7l4+GEsW6lWPxr/eEgbuEGtj+O0aKS/cjKuCGwLMxs2t9Z9Bv/Hv0QjriQiqRAAe8kHj/tOeZib87pbDbGVK5u3eLPHJvURd8ucRs44pltYXprT97+tryMuZuEQRKmxAuA0xrFUZljUtXhMLZsAmBkCWQlmxPOZIxA2T1jTUbsADqW4vGY8yfNTEBsfez2p1HLDYXOt8SO1muacxKsDdDiVD8Fh2mVn4EcyJcDwnSn6iQIJhK60Lbz97TOHds7dT2pkf8nKIAH2RJV5B/BX5ZNzjIqZuDqAN5OTs9093yRtmMcUEGSgCfoGV437iWt3NQmC1b7l0qluhFVC1KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p1xjLYJXipUsei0fiJcwDobHYIv1oruEvUn1O/3j5dA=;
 b=FOCvFHp8og2ToSUIvCas9JL9F6JQzXIdeLnDeHchTIX6iau300PSdgDMRb2GWB+FFr7hI1LFOmj5a30ThB4dH/WdaOgkQeV7z/dfflstNvN7rRjO32FtyY5Hazda6BJuDfYkvs28bgPYn4erXoR6xaScTjUyCNKf/0hew4bz2WM=
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 DM5PR1001MB2250.namprd10.prod.outlook.com (2603:10b6:4:2b::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.22; Mon, 6 Dec 2021 23:55:38 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::ad2b:bc5:20b:ee97]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::ad2b:bc5:20b:ee97%4]) with mapi id 15.20.4755.022; Mon, 6 Dec 2021
 23:55:38 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC PATCH v2 2/2] xfs: add leaf to node error tag
Date:   Mon,  6 Dec 2021 23:55:29 +0000
Message-Id: <20211206235529.65673-3-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211206235529.65673-1-catherine.hoang@oracle.com>
References: <20211206235529.65673-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0169.namprd03.prod.outlook.com
 (2603:10b6:a03:338::24) To DM6PR10MB2795.namprd10.prod.outlook.com
 (2603:10b6:5:70::21)
MIME-Version: 1.0
Received: from instance-20210819-1300.osdevelopmeniad.oraclevcn.com (209.17.40.39) by SJ0PR03CA0169.namprd03.prod.outlook.com (2603:10b6:a03:338::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20 via Frontend Transport; Mon, 6 Dec 2021 23:55:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 702889d5-2276-4448-bd53-08d9b913e75d
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2250:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB225094B8FDEB1F204B1170D2896D9@DM5PR1001MB2250.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vur7NrnV4fvNHHCK8diU/YhFCq2CQkFIl4Cyi7oBcanX+aBWuUHpqLV97WWA7it0rCFp31QIDVgOrvOkuKhlU8KGL4rmCmmyBsptLjSrDEbGbjJx4fPVpwnZ4g9UqFmbILaxWL+rEAZHy99Tf/iwbXLH4GUSxty5PuzrHi+FPXEtHgZ7rl44Re/qz1XwUG3iKO8bp06zD0BW8Q364rrlAKp6KFNfJdPFZL6X/22woGurXAX/ZGrr8bhtE+OWblOwxURqaNcbJeHyrbcCboVJX5RPWfWWxvQrCqP2FxFtQC1n29Eeo+dH0pasMQszZDD1S/4FoBQx0op75rpjdB5QvycieWhu3e42FuXTh/y8snZWijBUx88uN2R9l55JYyu4ytrVH88GLXhYV20eoIoaz2po5+xEV0M1a9TUTxtoMTGOk7JzFKO86Ywl8OruZHQJsyYVgHeogCOXdj0AuLCl+iMxnIX/nQ8j/qCpJmnHkJuwfdibjDkiHDoXPW2KizUOAYfxXaJ79n20OTCMlC5ThSozXMc6EKqn3H7amIzbqDdGgc65LOw2GTQLs+LtmHMUNAtUNr8EXqNSaeF0IOCC/C8dhiHSco7wlPa6UCH393aLUKIYarjxAra7IsHESi9SYESpmrRfFptz8O93oUjLAMv4OQinve50JXf0inVfSioiR6M/VdC6H9DSPbcR7hB5WSPf7j7Ub+QVxpE6oYyiIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38350700002)(38100700002)(66556008)(66476007)(6916009)(66946007)(2906002)(6666004)(36756003)(8936002)(8676002)(52116002)(186003)(956004)(5660300002)(44832011)(2616005)(6486002)(316002)(1076003)(508600001)(83380400001)(86362001)(6512007)(6506007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nY91FwOos0o53iv9MiKLXjdLGG+DhT1LWQIOBlz7SaxxV2p2Syxf9ZL06yy3?=
 =?us-ascii?Q?A0PAE/0gypHHcSAcwOBcRxCzbDCUoFyV38nDwcsvD7eaMASYZgNDBAZqIsU9?=
 =?us-ascii?Q?gBAHOLvoPeMmucv0XCNOArOo3GQcYw9W3jccKw/3pqsngJBcuipNUKxo7dqt?=
 =?us-ascii?Q?FjVl/Zo/b7VygTUMlHFHtJAso5WaNtqJ2plsU5qtm/pfdRsjzSJ4lLE0aS1A?=
 =?us-ascii?Q?veXEiuInLNOO+B9by9vmDpIU0Xa1ZE20pT7jA49Rn6ESGHWu7x8fpaQHIS8b?=
 =?us-ascii?Q?EKeF/cN7wLboC9a78XfeuBg1sGHTfLpNSc79zeoIoHJNZkMTggl1x9BKwVNY?=
 =?us-ascii?Q?1Az91ydXX0Pi7oS+T+z4TKLf0yCEyWt1+TNVE/u91f3aCG4/KoIpI9jmrdmx?=
 =?us-ascii?Q?+riYEWoTMbyKsskO0QdWUCSwSyPBskS4Zljmhsu2IMhuccJnoFGbTjaKt8Fa?=
 =?us-ascii?Q?y5dCH0nt8E7SxNoBzURkiXwCLsitvK5e/shH2OLhCvivpRnYFF+1RYO3xtWD?=
 =?us-ascii?Q?zorvBNEVyPA9ZRcU+kOwq6n/pbkeMT5n1UVGaj7dbjzodXyp5sLABwpNt30U?=
 =?us-ascii?Q?Yo67W9uNtxZY9YeqJQ6UBS9d6cFhC5R8ek3VkWRUQcgKVEipTkHJfjbx831J?=
 =?us-ascii?Q?MFERlvtvbjbZpWvwYPt5LMmI8jr9cvzJhjFORNTK4/ZZm9Ityl51aDxICsPZ?=
 =?us-ascii?Q?DSu58zL7oDmWtKju6opvKXc7bvmrAwvfxNkH/SJk2mmbYbxAhoDC5fSN9UTG?=
 =?us-ascii?Q?D5S1Ah8wHaIYeaedkbhb49ARglttNumla3EYrX2ihpCytMzsKdPKtUo4zKUz?=
 =?us-ascii?Q?wDcgNZnQq54T97dLq8joXnd6e/ja4J325msHA9aizrG7lKYSMFedKFiymIer?=
 =?us-ascii?Q?ZRaE7x8h4ibCQZ70wucJ8tGrFVZf1cEA+TQSHE8jMB0NNQklZxRkN72goC8K?=
 =?us-ascii?Q?7CQxD+6PKWaNU8Bz+DcsBqt3X5Wth3CoQSjLAE7Ltqep9O2SWs9NABPBbavE?=
 =?us-ascii?Q?8t4nEPYTZhUvXwCoR4+DW6EhVcbZFfVkYd9BEL/paKFdRmbg9P8E8+UAfiaP?=
 =?us-ascii?Q?L+lQmdGHueYfi/zGJf5b5O0AsfwV8n2HwzJt2JTeUu0cWW5xzyNZ8t5L49CP?=
 =?us-ascii?Q?eG8fiAwOE4/1f+ichroTdU1TS+2SrFY+SU5jMJmr8H+kzHU3o8/n3Zh0haH1?=
 =?us-ascii?Q?rFka0iPRBA4rG3r3OqTzadJ73NybcLxq6TzZhmapv5HL4/XjOhVf4fjeQi1z?=
 =?us-ascii?Q?qMLC013gNlt3/lV6xEJG54tVWb7t5JW5W4/rKTKBy3imgZoaru99oEUkyOLF?=
 =?us-ascii?Q?Lqy8VKGEPcy39n2Z2I+j82bfEkqA03hNku1jgdh7W/jzQgcW7iHzldKavOdc?=
 =?us-ascii?Q?z5qJA7rO29tnWTrbuEJwGKJnlpaS7bvl6aNhGwqeSoOcRHvzJSk0Q1ncmm0I?=
 =?us-ascii?Q?aHDKFL42ih3pvod2aN6kvna6QA88Sb6a9b9frucX+jCokCNwm9BpNVhB2fSN?=
 =?us-ascii?Q?rgkCTUEtyy00TimmxPPkWybMiPDhIkZi5ilkOf1MOHFKt/6yARDpnI2V/oU5?=
 =?us-ascii?Q?SzxDlmYytJgBTRUK1kDWIf968sKaGfN5XWMDMRGYAJ6+Xisbk/dqm7XyTxl1?=
 =?us-ascii?Q?qdPdH8RP2HsDTYkHb9DU5Kz/AkH+Dq5RRTR3n95NnMWr3bZk45a3dnno7fwC?=
 =?us-ascii?Q?DQpriw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 702889d5-2276-4448-bd53-08d9b913e75d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 23:55:38.8212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: te+56VC0TLEuLx1rYjpgXo3oyZX7NM1egsiXtRig1ZTcumpl2kBO7Jw6KlNWXb+vt40PcD4wZ6P/7m5S8pi20YAjKIrzOHUMG5XO2JpHGws=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2250
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10190 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112060143
X-Proofpoint-ORIG-GUID: TwnqTT7Iqnr0-s1ZhoSdRHfBdfkn6u6j
X-Proofpoint-GUID: TwnqTT7Iqnr0-s1ZhoSdRHfBdfkn6u6j
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add an error tag on xfs_attr3_leaf_to_node to test log attribute
recovery and replay.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 6 ++++++
 fs/xfs/libxfs/xfs_errortag.h  | 4 +++-
 fs/xfs/xfs_error.c            | 3 +++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 74b76b09509f..0fe028d95c77 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -28,6 +28,7 @@
 #include "xfs_dir2.h"
 #include "xfs_log.h"
 #include "xfs_ag.h"
+#include "xfs_errortag.h"
 
 
 /*
@@ -1189,6 +1190,11 @@ xfs_attr3_leaf_to_node(
 
 	trace_xfs_attr_leaf_to_node(args);
 
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_LARP_LEAF_TO_NODE)) {
+		error = -EIO;
+		goto out;
+	}
+
 	error = xfs_da_grow_inode(args, &blkno);
 	if (error)
 		goto out;
diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index 970f3a3f3750..6d90f06442e8 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -61,7 +61,8 @@
 #define XFS_ERRTAG_AG_RESV_FAIL				38
 #define XFS_ERRTAG_LARP					39
 #define XFS_ERRTAG_LARP_LEAF_SPLIT			40
-#define XFS_ERRTAG_MAX					41
+#define XFS_ERRTAG_LARP_LEAF_TO_NODE			41
+#define XFS_ERRTAG_MAX					42
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -107,5 +108,6 @@
 #define XFS_RANDOM_AG_RESV_FAIL				1
 #define XFS_RANDOM_LARP					1
 #define XFS_RANDOM_LARP_LEAF_SPLIT			1
+#define XFS_RANDOM_LARP_LEAF_TO_NODE			1
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 9cb6743a5ae3..ae2003a95324 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -59,6 +59,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_AG_RESV_FAIL,
 	XFS_RANDOM_LARP,
 	XFS_RANDOM_LARP_LEAF_SPLIT,
+	XFS_RANDOM_LARP_LEAF_TO_NODE,
 };
 
 struct xfs_errortag_attr {
@@ -174,6 +175,7 @@ XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTE
 XFS_ERRORTAG_ATTR_RW(ag_resv_fail, XFS_ERRTAG_AG_RESV_FAIL);
 XFS_ERRORTAG_ATTR_RW(larp,		XFS_ERRTAG_LARP);
 XFS_ERRORTAG_ATTR_RW(larp_leaf_split,	XFS_ERRTAG_LARP_LEAF_SPLIT);
+XFS_ERRORTAG_ATTR_RW(larp_leaf_to_node,	XFS_ERRTAG_LARP_LEAF_TO_NODE);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -217,6 +219,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(ag_resv_fail),
 	XFS_ERRORTAG_ATTR_LIST(larp),
 	XFS_ERRORTAG_ATTR_LIST(larp_leaf_split),
+	XFS_ERRORTAG_ATTR_LIST(larp_leaf_to_node),
 	NULL,
 };
 
-- 
2.25.1

