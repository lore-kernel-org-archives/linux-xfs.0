Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 941CDC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:09:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A8876120C
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:09:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236452AbhIPKKa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 06:10:30 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:2158 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236417AbhIPKKa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 06:10:30 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18G8xvbB011041;
        Thu, 16 Sep 2021 10:09:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=pX5Fo5RtgryUfoollX7Jtou+9OSuBCRy4i8EohB0Suc=;
 b=AflMH8ot59BmOgoVTQ2h589i9mfkxsxWotHkwSM7uD2ycQVYhHTtxKBIAZDTxSrI/4ia
 P0uJOFlg2S9n0phxc2LNSFqTg07GKfu9OxwNy/vUQ8+h2LTlBqbui5TW5JSV5WtpL/tf
 BIcyPOaqLLrNgzfJ/KSXddjNcNvVtTj+bJSn/G5W8wfbpPsLmrKpH9FDrA0+WfT/LX+d
 LI/h8q1R8lu+pYxJU61VELNH053xb6RbYN2twv10mAHu5u9MODywKRjCUxKfb1aXWKJW
 eW5/nPU46L6yG3CS4YG12fupU93wrZ8+BH1t6MT0DFeIg1WKPl7R44N4wRPgkRfabj3q 5A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=pX5Fo5RtgryUfoollX7Jtou+9OSuBCRy4i8EohB0Suc=;
 b=qKFb+SfWjflC2cOLaRwQYUguqFz++AdRA9H1EXQ3jN7FudZbHdT6zLpOVPx+qrxU2czl
 u1NrSa+yO50k/mzKxL9jnNDApu46d6oAFXz7EJq8iSxtRyJhIUkWP1uNrXOvdtbpzLVC
 bCpWBThUs9KedF0FBKSigQxvFYd+gEiGnMRnVVBmaVY3FrqzFHQvPqfjU+Qk8CmVVGj5
 5OiNzTNHXKKE8h6Yl/TboUgOngRHeXyB7/uUdjcqhVHUdhywTmKEb+gcva7yPPaXNgfs
 8LHpyetT4XP95uDyPxygIglSmUElMfgo/FnnszfvNipr0d8i4DBu1uqA5rRAsSP6x0We VA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b3jysjve2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:09:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18GA5jFe171666;
        Thu, 16 Sep 2021 10:09:08 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by userp3020.oracle.com with ESMTP id 3b167uxq9k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:09:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DO20eAx+DzKhfJCb4CIPjBZLj2IOUIjhk3PepgYK6YHSOTRa72Geu6nrz2iK0yIKfH3ihojOvEDo0fJnXVpsJYHkNfsjfM2xmZveqFSe5jO1Zxw2OGf2RuEfKTfwjBzS92s1D9xdDMKErotV67SspTl+lU0WzIOd4++ywsRbP2WcRyEBWzH0Hy3R9eAoCpNUpA2VWx9AkYdR+oQ9BZzrl7k1fhE2lzqkeVklcZ0Ag/Wrt2Vq0qlxN9SM4t6wbjIWJWnjMjwHztmBtlcJ/nGuep+1Ey86YP918e2XfNJKp5tQN4OMq/XbP+W/t7gY6rvvJy/SCJhCWLdChXawrjqIzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=pX5Fo5RtgryUfoollX7Jtou+9OSuBCRy4i8EohB0Suc=;
 b=N7viAESzrAQOAYKdVh/iGeTj+REiUQoXk2qSf8AnYhjHxOe7wepzD9571Vu8iMpr8Ml0TNjKbmvTAiooY184eJwcuu6AuqTKpcazsRWnjojvg0cVwguI5iZRSvju+1SOohROJrWNtamz2WzBANbBtgG+Oxyex1RUReUvJFQC0ACIyZYPqs3tZMBmhgsnHaNsY26q3or32OqkaGXlO1f4aGxEow5dJxmTWuf9VOb2OqbzPzdfSx01WCKzp5gj1nTPBFKLwdsHNEpWMC6RPMHxtZ2EwQDgANQAcV2ONdB45WQXCpIJthVZyF/25JKczk2KUhHQcwSduiZTUA6yzYBT7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pX5Fo5RtgryUfoollX7Jtou+9OSuBCRy4i8EohB0Suc=;
 b=i1xKOA9KuXbtkZRyKw1DMqnauqklEnmyEBM71i0K+cTNpBv+w6No9FRFB3YcuGynJrnNovSvDWf52TSSECG3vzRb10AiuY+pfEDx1V7KFXXcmgOBRJmVTOFcsk03Nr6lMskzZgDdlatMF7mxL1CnB7l8NuOxfWiEEBSNqEQ+j6E=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4748.namprd10.prod.outlook.com (2603:10b6:806:112::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Thu, 16 Sep
 2021 10:09:06 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 10:09:06 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org
Subject: [PATCH V3 07/16] xfsprogs: xfs_dfork_nextents: Return extent count via an out argument
Date:   Thu, 16 Sep 2021 15:38:13 +0530
Message-Id: <20210916100822.176306-8-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210916100822.176306-1-chandan.babu@oracle.com>
References: <20210916100822.176306-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0158.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::28) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from localhost.localdomain (122.171.167.196) by MA1PR01CA0158.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021 10:09:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2df51d6f-8e10-4f01-42b4-08d978fa03f3
X-MS-TrafficTypeDiagnostic: SA2PR10MB4748:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR10MB47483116EB9283448F5DD7A1F6DC9@SA2PR10MB4748.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j9/SrG7d7yZ2eAea2hrGKHWjNrCYmgYuNOPMKkvjXvIHvk50T33bRXsdMyXFTZ7m9VsueZpIfW+VjpKNjI5o+F6oQZiT8acShhPWfgAVzjTpUBVViB1jcMzzQVe2j46ryS7ujOybQr5FC1jsJRf2lD64FkeX8fy336Kh2fZQKh7HV680PDcsM4SDXKQ8HJas2RoyfKRxWd9V/07Nbw1T4l21RoS89OaEGL/NusOZDXqlVCedKYVSIu9QpiRcpw0o8xA3Y37VBUul21zsNzFGTqzU382jz7kCGIzNSIQYs3KJXBiqdNuvoMdprh6DdhHTS1h3Ng4VwZY9+biYy1dk5WmxLa1Vw1qyB8co4J0wdpmvh/oLZyqTuK7KIXzPfcDP4CIKzImJhJATRGUq9lmDM6uk+vzkXqBMewirbUHoo9o+OR9H9DJ2D9jfTT2L7sQHSlzKchE/iCamc0EWIkyJBak60COScYh/8oNSKdEA8pND+/mo9nIXXX59nHOEsPbzsDNUezKa88Dr3yH70e5DBGCVUL2izvcSHRBKpsNR1boq+JLt67Ku3R6yamygXg697SJZx9rCtqMunkhuiorJH13GT8FYzuWkJRBTt7MPheVd1XgGpV931GCNiKysPwuLPxAOYbecPOOhWRMBLTicpoSaPgavDlDy5fQ6qvcZHH73e1/n3FaFqjuEnA7UsfDm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(366004)(136003)(346002)(66476007)(2616005)(66556008)(66946007)(6916009)(2906002)(1076003)(4326008)(956004)(6506007)(83380400001)(316002)(8676002)(30864003)(36756003)(478600001)(38100700002)(38350700002)(6666004)(52116002)(6486002)(8936002)(5660300002)(26005)(86362001)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0H5ZZDrqa1XT77K1/xU8SOcdKpsXQeOlO949B9fIpGLj2F7UWaoDV/rA6N8X?=
 =?us-ascii?Q?cDQZQ7dSD7XW1beirdZYjoPThbKetprd9w0xB4ht/6vxBl/IAeKzw/rJZeLt?=
 =?us-ascii?Q?o/D8hkXR0QjhlC8Pvvh9xZ31JNqOYKHuBF1Su61BwbEqkPpbR7qpGKaXhRMK?=
 =?us-ascii?Q?ddQCFxlestQn9nQ9folvRFVUuC1ksfr8FGv8YSUC/XA0bUMmk96I2fCLGJrg?=
 =?us-ascii?Q?hX2xg+HWXYOhp6e1jbfKeS+YnMIpVF2cMEoEVH9eJqxq/ZpQE9KPMoAuN1Aa?=
 =?us-ascii?Q?sBqS82pyNx2zdPo/hn31POFy1Pp8DQiSSty30aRvjiTeGiEvZ54TICKQxyJI?=
 =?us-ascii?Q?M00tBaHC2bpytMSq0bHvV7xyFSYDTH9L487rd4Iqr1L8g+u6reP9RfCwGLAe?=
 =?us-ascii?Q?8bxpfarhwfxz/kByMowRxrBUW1Tmototx33UBf6fEfXsyIQVONEp6FtetGZT?=
 =?us-ascii?Q?bUSkAwNER3FmZ4fjjk7VJSZhVOuKOYr6riSkA+p0TacaBpgasfOnsrCuilh7?=
 =?us-ascii?Q?cc0YJ1WwQ5RPtKUvRCfRJHfoPf2s0QiH5USgu8dBccClZlSup/PXM9o1O6YZ?=
 =?us-ascii?Q?ek8SHvGUa9EZ/2KwLWT9hwbzYtYeLI2EQnUV4Fh9LmCSxddnzx2jrKoKm7t5?=
 =?us-ascii?Q?059fnOkxNCG8QvxsnUnjaSwwIMth/ycUhlegNg5s/l22fwRuj80gCT7QtaPM?=
 =?us-ascii?Q?x1JPIq0SijRyDByQVLnDJY5jrh8d7lLg9nIk6vIh5J6dVfcNKebBwB88NWIs?=
 =?us-ascii?Q?5L38pDtazCp5sfkCnmY3vLJJls/EA4JTATYMODSwpXwZUMkEbOKRvjs488LL?=
 =?us-ascii?Q?C5oBcBYHWSPD8gikqGXxT2Q+Secl1J/e1grCtzlpcrFRkuJCMe/Q3FTC2wYL?=
 =?us-ascii?Q?JRgsFB4Nw3XBiySyKQmko8Vnvi/sqwtjYk75jf/V/6GocpE3voHcKlaObBX3?=
 =?us-ascii?Q?8JHeKJWTcWERSadHoa1Y+ol4/xJJoqwzuETntDIjzCV6AARmg+8+FOp5z3u/?=
 =?us-ascii?Q?tR8Mh77ufXOLJrIJzIXLTN5wDiAPnqM6OCMezBP5I+wMmlTmp9Z3mtp1fMsO?=
 =?us-ascii?Q?rkZ93vEq6X7OCQg/kY1lINDTXQedao0rgFKe8PW0B+Vk4tcSDT7zxOFr77ZZ?=
 =?us-ascii?Q?PL0UHxE5kodZQvVlm23oLOEJZIswwGkHggL7N1wX1Mxikxn3sDdXwa07mFl9?=
 =?us-ascii?Q?fNT1iNm0nGDNTDLwqhVUggxiYE/QQ1LNB2UOeEBu6k9qRW5sr9SwnxXjsE2L?=
 =?us-ascii?Q?4mp+fmRp6K2UDinchgBdqq6hAhQu1AtRdIp2PxaLJuL2Z63qh4Cw4Uc+ZTXy?=
 =?us-ascii?Q?FyCRsaQa2FAY3hzsXjmp7/5U?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2df51d6f-8e10-4f01-42b4-08d978fa03f3
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 10:09:05.9538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d6mkPCvFtfeRv9FCTxL7olG5IQ1Hvdli5ThIlbWO3DldveiYWfdrazdBWHKtyyR43rjavfuexS1r0zs2P6g/2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4748
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10108 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109160064
X-Proofpoint-GUID: tetdrNRaItPU02dpYEaOtRpARgDtfKTh
X-Proofpoint-ORIG-GUID: tetdrNRaItPU02dpYEaOtRpARgDtfKTh
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit changes xfs_dfork_nextents() to return an error code. The extent
count itself is now returned through an out argument. This facility will be
used by a future commit to indicate an inconsistent ondisk extent count.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/bmap.c               | 19 ++++++++------
 db/btdump.c             | 11 +++++---
 db/check.c              | 23 ++++++++++++++---
 db/frag.c               |  7 +++---
 db/inode.c              | 26 +++++++++++++------
 db/metadump.c           | 12 +++++++--
 libxfs/xfs_format.h     | 14 ++++++-----
 libxfs/xfs_inode_buf.c  | 16 +++++++++---
 libxfs/xfs_inode_fork.c | 23 +++++++++++++----
 repair/attr_repair.c    | 11 +++++---
 repair/bmap_repair.c    | 11 ++++++--
 repair/dinode.c         | 56 ++++++++++++++++++++++++++++++++---------
 repair/prefetch.c       |  7 ++++--
 13 files changed, 175 insertions(+), 61 deletions(-)

diff --git a/db/bmap.c b/db/bmap.c
index a33815fe..fca01f3c 100644
--- a/db/bmap.c
+++ b/db/bmap.c
@@ -68,11 +68,13 @@ bmap(
 	ASSERT(fmt == XFS_DINODE_FMT_LOCAL || fmt == XFS_DINODE_FMT_EXTENTS ||
 		fmt == XFS_DINODE_FMT_BTREE);
 	if (fmt == XFS_DINODE_FMT_EXTENTS) {
-		nextents = xfs_dfork_nextents(dip, whichfork);
-		xp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
-		for (ep = xp; ep < &xp[nextents] && n < nex; ep++) {
-			if (!bmap_one_extent(ep, &curoffset, eoffset, &n, bep))
-				break;
+		if (!xfs_dfork_nextents(dip, whichfork, &nextents)) {
+			xp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
+			for (ep = xp; ep < &xp[nextents] && n < nex; ep++) {
+				if (!bmap_one_extent(ep, &curoffset, eoffset,
+						&n, bep))
+					break;
+			}
 		}
 	} else if (fmt == XFS_DINODE_FMT_BTREE) {
 		push_cur();
@@ -155,12 +157,15 @@ bmap_f(
 		}
 	}
 	if (afork + dfork == 0) {
+		xfs_extnum_t nextents;
 		push_cur();
 		set_cur_inode(iocur_top->ino);
 		dip = iocur_top->data;
-		if (xfs_dfork_nextents(dip, XFS_DATA_FORK))
+		if (!xfs_dfork_nextents(dip, XFS_DATA_FORK, &nextents) &&
+		    nextents)
 			dfork = 1;
-		if (xfs_dfork_nextents(dip, XFS_ATTR_FORK))
+		if (!xfs_dfork_nextents(dip, XFS_ATTR_FORK, &nextents) &&
+		    nextents)
 			afork = 1;
 		pop_cur();
 	}
diff --git a/db/btdump.c b/db/btdump.c
index d48ce6ca..b2ab7e28 100644
--- a/db/btdump.c
+++ b/db/btdump.c
@@ -153,6 +153,7 @@ dump_inode(
 	bool			dump_node_blocks,
 	bool			attrfork)
 {
+	xfs_extnum_t		nextents;
 	char			*prefix;
 	struct xfs_dinode	*dip;
 	int			ret = 0;
@@ -166,14 +167,16 @@ dump_inode(
 
 	dip = iocur_top->data;
 	if (attrfork) {
-		if (!xfs_dfork_nextents(dip, XFS_ATTR_FORK) ||
-		    dip->di_aformat != XFS_DINODE_FMT_BTREE) {
+		if (xfs_dfork_nextents(dip, XFS_ATTR_FORK, &nextents))
+			return -1;
+		if (!nextents || dip->di_aformat != XFS_DINODE_FMT_BTREE) {
 			dbprintf(_("attr fork not in btree format\n"));
 			return 0;
 		}
 	} else {
-		if (!xfs_dfork_nextents(dip, XFS_DATA_FORK) ||
-		    dip->di_format != XFS_DINODE_FMT_BTREE) {
+		if (xfs_dfork_nextents(dip, XFS_DATA_FORK, &nextents))
+			return -1;
+		if (!nextents || dip->di_format != XFS_DINODE_FMT_BTREE) {
 			dbprintf(_("data fork not in btree format\n"));
 			return 0;
 		}
diff --git a/db/check.c b/db/check.c
index eb736ab7..79e7978e 100644
--- a/db/check.c
+++ b/db/check.c
@@ -2718,10 +2718,17 @@ process_exinode(
 	int			whichfork)
 {
 	xfs_bmbt_rec_t		*rp;
+	int			ret;
 
 	rp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
-	*nex = xfs_dfork_nextents(dip, whichfork);
-	if (*nex < 0 || *nex > XFS_DFORK_SIZE(dip, mp, whichfork) /
+	ret = xfs_dfork_nextents(dip, whichfork, nex);
+	if (ret) {
+		if (!sflag || id->ilist)
+			dbprintf(_("Corrupt extent count for inode %lld\n"),
+				id->ino);
+		error++;
+		return;
+	} else if (*nex < 0 || *nex > XFS_DFORK_SIZE(dip, mp, whichfork) /
 						sizeof(xfs_bmbt_rec_t)) {
 		if (!sflag || id->ilist)
 			dbprintf(_("bad number of extents %d for inode %lld\n"),
@@ -2881,8 +2888,16 @@ process_inode(
 		return;
 	}
 
-	dnextents = xfs_dfork_nextents(dip, XFS_DATA_FORK);
-	danextents = xfs_dfork_nextents(dip, XFS_ATTR_FORK);
+	if (xfs_dfork_nextents(dip, XFS_DATA_FORK, &dnextents)) {
+		if (v)
+			dbprintf(_("Corrupt extent count for inode %lld\n"),
+				id->ino);
+		error++;
+		return;
+	}
+
+	if (xfs_dfork_nextents(dip, XFS_ATTR_FORK, &danextents))
+		ASSERT(0);
 
 	if (verbose || (id && id->ilist) || CHECK_BLIST(bno))
 		dbprintf(_("inode %lld mode %#o fmt %s "
diff --git a/db/frag.c b/db/frag.c
index 4105960d..f60d2ec4 100644
--- a/db/frag.c
+++ b/db/frag.c
@@ -263,9 +263,11 @@ process_exinode(
 {
 	xfs_bmbt_rec_t		*rp;
 	xfs_extnum_t		nextents;
+	int			error;
 
 	rp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
-	nextents = xfs_dfork_nextents(dip, whichfork);
+	error = xfs_dfork_nextents(dip, whichfork, &nextents);
+	ASSERT(error == 0);
 	process_bmbt_reclist(rp, nextents, extmapp);
 }
 
@@ -277,8 +279,7 @@ process_fork(
 	extmap_t	*extmap;
 	xfs_extnum_t	nex;
 
-	nex = xfs_dfork_nextents(dip, whichfork);
-	if (!nex)
+	if (xfs_dfork_nextents(dip, whichfork, &nex) || !nex)
 		return;
 	extmap = extmap_alloc(nex);
 	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
diff --git a/db/inode.c b/db/inode.c
index b09f9386..c45ec1f7 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -269,6 +269,7 @@ inode_a_bmx_count(
 	void		*obj,
 	int		startoff)
 {
+	xfs_extnum_t	nextents;
 	xfs_dinode_t	*dip;
 
 	ASSERT(bitoffs(startoff) == 0);
@@ -277,8 +278,12 @@ inode_a_bmx_count(
 	if (!dip->di_forkoff)
 		return 0;
 	ASSERT((char *)XFS_DFORK_APTR(dip) - (char *)dip == byteize(startoff));
-	return dip->di_aformat == XFS_DINODE_FMT_EXTENTS ?
-		xfs_dfork_nextents(dip, XFS_ATTR_FORK) : 0;
+	if (dip->di_aformat != XFS_DINODE_FMT_EXTENTS ||
+	    xfs_dfork_nextents(dip, XFS_ATTR_FORK, &nextents)) {
+			nextents = 0;
+	}
+
+	return nextents;
 }
 
 static int
@@ -342,7 +347,8 @@ inode_a_size(
 		asf = (struct xfs_attr_shortform *)XFS_DFORK_APTR(dip);
 		return bitize(be16_to_cpu(asf->hdr.totsize));
 	case XFS_DINODE_FMT_EXTENTS:
-		nextents = xfs_dfork_nextents(dip, XFS_ATTR_FORK);
+		if (xfs_dfork_nextents(dip, XFS_ATTR_FORK, &nextents))
+			nextents = 0;
 		return nextents * bitsz(struct xfs_bmbt_rec);
 	case XFS_DINODE_FMT_BTREE:
 		return bitize((int)XFS_DFORK_ASIZE(dip, mp));
@@ -497,14 +503,19 @@ inode_u_bmx_count(
 	void		*obj,
 	int		startoff)
 {
+	xfs_extnum_t	nextents;
 	xfs_dinode_t	*dip;
 
 	ASSERT(bitoffs(startoff) == 0);
 	ASSERT(obj == iocur_top->data);
 	dip = obj;
 	ASSERT((char *)XFS_DFORK_DPTR(dip) - (char *)dip == byteize(startoff));
-	return dip->di_format == XFS_DINODE_FMT_EXTENTS ?
-		xfs_dfork_nextents(dip, XFS_DATA_FORK) : 0;
+	if (dip->di_format != XFS_DINODE_FMT_EXTENTS ||
+		xfs_dfork_nextents(dip, XFS_DATA_FORK, &nextents)) {
+		nextents = 0;
+	}
+
+	return nextents;
 }
 
 static int
@@ -590,7 +601,7 @@ inode_u_size(
 	int		idx)
 {
 	xfs_dinode_t	*dip;
-	xfs_extnum_t	nextents;
+	xfs_extnum_t	nextents = 0;
 
 	ASSERT(startoff == 0);
 	ASSERT(idx == 0);
@@ -601,7 +612,8 @@ inode_u_size(
 	case XFS_DINODE_FMT_LOCAL:
 		return bitize((int)be64_to_cpu(dip->di_size));
 	case XFS_DINODE_FMT_EXTENTS:
-		nextents = xfs_dfork_nextents(dip, XFS_DATA_FORK);
+		if (xfs_dfork_nextents(dip, XFS_DATA_FORK, &nextents))
+			nextents = 0;
 		return nextents * bitsz(struct xfs_bmbt_rec);
 	case XFS_DINODE_FMT_BTREE:
 		return bitize((int)XFS_DFORK_DSIZE(dip, mp));
diff --git a/db/metadump.c b/db/metadump.c
index 891de80d..3e3e05c7 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2314,7 +2314,13 @@ process_exinode(
 
 	whichfork = (itype == TYP_ATTR) ? XFS_ATTR_FORK : XFS_DATA_FORK;
 
-	nex = xfs_dfork_nextents(dip, whichfork);
+	if (xfs_dfork_nextents(dip, whichfork, &nex)) {
+		if (show_warnings)
+			print_warning("Corrupt extent count for inode %lld\n",
+				(long long)cur_ino);
+		return 1;
+	}
+
 	used = nex * sizeof(xfs_bmbt_rec_t);
 	if (nex < 0 || used > XFS_DFORK_SIZE(dip, mp, whichfork)) {
 		if (show_warnings)
@@ -2369,7 +2375,9 @@ static int
 process_dev_inode(
 	xfs_dinode_t		*dip)
 {
-	if (xfs_dfork_nextents(dip, XFS_DATA_FORK)) {
+	xfs_extnum_t		nextents;
+
+	if (xfs_dfork_nextents(dip, XFS_DATA_FORK, &nextents) || nextents) {
 		if (show_warnings)
 			print_warning("inode %llu has unexpected extents",
 				      (unsigned long long)cur_ino);
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index e9af506d..49e627ad 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -930,28 +930,30 @@ enum xfs_dinode_fmt {
 		(dip)->di_format : \
 		(dip)->di_aformat)
 
-static inline xfs_extnum_t
+static inline int
 xfs_dfork_nextents(
 	struct xfs_dinode	*dip,
-	int			whichfork)
+	int			whichfork,
+	xfs_extnum_t		*nextents)
 {
-	xfs_extnum_t		nextents = 0;
+	int			error = 0;
 
 	switch (whichfork) {
 	case XFS_DATA_FORK:
-		nextents = be32_to_cpu(dip->di_nextents);
+		*nextents = be32_to_cpu(dip->di_nextents);
 		break;
 
 	case XFS_ATTR_FORK:
-		nextents = be16_to_cpu(dip->di_anextents);
+		*nextents = be16_to_cpu(dip->di_anextents);
 		break;
 
 	default:
 		ASSERT(0);
+		error = -EFSCORRUPTED;
 		break;
 	}
 
-	return nextents;
+	return error;
 }
 
 /*
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 63ec5794..5ed923ae 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -342,7 +342,8 @@ xfs_dinode_verify_fork(
 	xfs_extnum_t		di_nextents;
 	xfs_extnum_t		max_extents;
 
-	di_nextents = xfs_dfork_nextents(dip, whichfork);
+	if (xfs_dfork_nextents(dip, whichfork, &di_nextents))
+		return __this_address;
 
 	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
 	case XFS_DINODE_FMT_LOCAL:
@@ -475,6 +476,7 @@ xfs_dinode_verify(
 	uint64_t		di_size;
 	xfs_rfsblock_t		nblocks;
 	xfs_extnum_t            nextents;
+	xfs_extnum_t            naextents;
 
 	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
 		return __this_address;
@@ -505,8 +507,13 @@ xfs_dinode_verify(
 	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
 		return __this_address;
 
-	nextents = xfs_dfork_nextents(dip, XFS_DATA_FORK);
-	nextents += xfs_dfork_nextents(dip, XFS_ATTR_FORK);
+	if (xfs_dfork_nextents(dip, XFS_DATA_FORK, &nextents))
+		return __this_address;
+
+	if (xfs_dfork_nextents(dip, XFS_ATTR_FORK, &naextents))
+		return __this_address;
+
+	nextents += naextents;
 	nblocks = be64_to_cpu(dip->di_nblocks);
 
 	/* Fork checks carried over from xfs_iformat_fork */
@@ -567,7 +574,8 @@ xfs_dinode_verify(
 		default:
 			return __this_address;
 		}
-		if (xfs_dfork_nextents(dip, XFS_ATTR_FORK))
+
+		if (naextents)
 			return __this_address;
 	}
 
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 4aa9b7d3..6b69d34e 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -105,12 +105,19 @@ xfs_iformat_extents(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	int			state = xfs_bmap_fork_to_state(whichfork);
-	xfs_extnum_t		nex = xfs_dfork_nextents(dip, whichfork);
-	int			size = nex * sizeof(xfs_bmbt_rec_t);
+	xfs_extnum_t		nex;
+	int			size;
 	struct xfs_iext_cursor	icur;
 	struct xfs_bmbt_rec	*dp;
 	struct xfs_bmbt_irec	new;
 	int			i;
+	int			error;
+
+	error = xfs_dfork_nextents(dip, whichfork, &nex);
+	if (error)
+		return error;
+
+	size = nex * sizeof(struct xfs_bmbt_rec);
 
 	/*
 	 * If the number of extents is unreasonable, then something is wrong and
@@ -232,7 +239,10 @@ xfs_iformat_data_fork(
 	 * depend on it.
 	 */
 	ip->i_df.if_format = dip->di_format;
-	ip->i_df.if_nextents = xfs_dfork_nextents(dip, XFS_DATA_FORK);
+	error = xfs_dfork_nextents(dip, XFS_DATA_FORK,
+		&ip->i_df.if_nextents);
+	if (error)
+		return error;
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFIFO:
@@ -300,13 +310,16 @@ xfs_iformat_attr_fork(
 	struct xfs_dinode	*dip)
 {
 	xfs_extnum_t		naextents;
-	int			error = 0;
+	int			error;
+
+	error = xfs_dfork_nextents(dip, XFS_ATTR_FORK, &naextents);
+	if (error)
+		return error;
 
 	/*
 	 * Initialize the extent count early, as the per-format routines may
 	 * depend on it.
 	 */
-	naextents = xfs_dfork_nextents(dip, XFS_ATTR_FORK);
 	ip->i_afp = xfs_ifork_alloc(dip->di_aformat, naextents);
 
 	switch (ip->i_afp->if_format) {
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index e842db3c..c026b4fc 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -1073,6 +1073,7 @@ process_longform_attr(
 	struct blkmap		*blkmap,
 	int			*repair) /* out - 1 if something was fixed */
 {
+	xfs_extnum_t		anextents;
 	xfs_fsblock_t		bno;
 	struct xfs_buf		*bp;
 	struct xfs_da_blkinfo	*info;
@@ -1082,9 +1083,13 @@ process_longform_attr(
 
 	bno = blkmap_get(blkmap, 0);
 	if (bno == NULLFSBLOCK) {
-		if (dip->di_aformat == XFS_DINODE_FMT_EXTENTS &&
-			xfs_dfork_nextents(dip, XFS_ATTR_FORK) == 0)
-			return(0); /* the kernel can handle this state */
+		if (dip->di_aformat == XFS_DINODE_FMT_EXTENTS) {
+			error = xfs_dfork_nextents(dip, XFS_ATTR_FORK,
+					&anextents);
+			ASSERT(error == 0);
+			if (anextents == 0)
+				return(0); /* the kernel can handle this state */
+		}
 		do_warn(
 	_("block 0 of inode %" PRIu64 " attribute fork is missing\n"),
 			ino);
diff --git a/repair/bmap_repair.c b/repair/bmap_repair.c
index 25f02882..adb798f7 100644
--- a/repair/bmap_repair.c
+++ b/repair/bmap_repair.c
@@ -560,6 +560,7 @@ rebuild_bmap(
 	struct xfs_buf		*bp;
 	unsigned long long	resblks;
 	xfs_daddr_t		bp_bn;
+	xfs_extnum_t		nextents;
 	int			bp_length;
 	int			error;
 
@@ -572,7 +573,10 @@ rebuild_bmap(
 	 */
 	switch (whichfork) {
 	case XFS_DATA_FORK:
-		if (!xfs_dfork_nextents(*dinop, XFS_DATA_FORK))
+		error = xfs_dfork_nextents(*dinop, whichfork, &nextents);
+		if (error)
+			return error;
+		if (nextents == 0)
 			return 0;
 		(*dinop)->di_format = XFS_DINODE_FMT_EXTENTS;
 		(*dinop)->di_nextents = 0;
@@ -580,7 +584,10 @@ rebuild_bmap(
 		*dirty = 1;
 		break;
 	case XFS_ATTR_FORK:
-		if (!xfs_dfork_nextents(*dinop, XFS_ATTR_FORK))
+		error = xfs_dfork_nextents(*dinop, whichfork, &nextents);
+		if (error)
+			return error;
+		if (nextents == 0)
 			return 0;
 		(*dinop)->di_aformat = XFS_DINODE_FMT_EXTENTS;
 		(*dinop)->di_anextents = 0;
diff --git a/repair/dinode.c b/repair/dinode.c
index dc6adb4c..46f82f64 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -60,6 +60,9 @@ get_forkname(int whichfork)
 static int
 clear_dinode_attr(xfs_mount_t *mp, xfs_dinode_t *dino, xfs_ino_t ino_num)
 {
+	xfs_extnum_t anextents;
+	int err;
+
 	ASSERT(dino->di_forkoff != 0);
 
 	if (!no_modify)
@@ -69,7 +72,10 @@ _("clearing inode %" PRIu64 " attributes\n"), ino_num);
 		fprintf(stderr,
 _("would have cleared inode %" PRIu64 " attributes\n"), ino_num);
 
-	if (xfs_dfork_nextents(dino, XFS_ATTR_FORK) != 0) {
+	err = xfs_dfork_nextents(dino, XFS_ATTR_FORK, &anextents);
+	ASSERT(err == 0);
+
+	if (anextents != 0) {
 		if (no_modify)
 			return(1);
 		dino->di_anextents = cpu_to_be16(0);
@@ -973,7 +979,9 @@ process_exinode(
 	lino = XFS_AGINO_TO_INO(mp, agno, ino);
 	rp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
 	*tot = 0;
-	numrecs = xfs_dfork_nextents(dip, whichfork);
+
+	ret = xfs_dfork_nextents(dip, whichfork, &numrecs);
+	ASSERT(ret == 0);
 
 	/*
 	 * We've already decided on the maximum number of extents on the inode,
@@ -1053,6 +1061,7 @@ process_symlink_extlist(xfs_mount_t *mp, xfs_ino_t lino, xfs_dinode_t *dino)
 	xfs_extnum_t		numrecs;
 	int			i;
 	int			max_blocks;
+	int			ret;
 
 	if (be64_to_cpu(dino->di_size) <= XFS_DFORK_DSIZE(dino, mp)) {
 		if (dino->di_format == XFS_DINODE_FMT_LOCAL)
@@ -1072,7 +1081,9 @@ _("mismatch between format (%d) and size (%" PRId64 ") in symlink inode %" PRIu6
 	}
 
 	rp = (xfs_bmbt_rec_t *)XFS_DFORK_DPTR(dino);
-	numrecs = xfs_dfork_nextents(dino, XFS_DATA_FORK);
+
+	ret = xfs_dfork_nextents(dino, XFS_DATA_FORK, &numrecs);
+	ASSERT(ret == 0);
 
 	/*
 	 * the max # of extents in a symlink inode is equal to the
@@ -1579,6 +1590,7 @@ process_check_sb_inodes(
 	int		*dirty)
 {
 	xfs_extnum_t	nextents;
+	int		ret;
 
 	if (lino == mp->m_sb.sb_rootino) {
 		if (*type != XR_INO_DIR)  {
@@ -1635,7 +1647,9 @@ _("realtime summary inode %" PRIu64 " has bad type 0x%x, "),
 			}
 		}
 
-		nextents = xfs_dfork_nextents(dinoc, XFS_DATA_FORK);
+		ret = xfs_dfork_nextents(dinoc, XFS_DATA_FORK, &nextents);
+		ASSERT(ret == 0);
+
 		if (mp->m_sb.sb_rblocks == 0 && nextents != 0)  {
 			do_warn(
 _("bad # of extents (%d) for realtime summary inode %" PRIu64 "\n"),
@@ -1658,8 +1672,10 @@ _("realtime bitmap inode %" PRIu64 " has bad type 0x%x, "),
 			}
 		}
 
-		nextents = xfs_dfork_nextents(dinoc, XFS_DATA_FORK);
-		if (mp->m_sb.sb_rblocks == 0 && nextents != 0)  {
+		ret = xfs_dfork_nextents(dinoc, XFS_DATA_FORK, &nextents);
+		ASSERT(ret == 0);
+
+		if (mp->m_sb.sb_rblocks == 0 && nextents != 0)	{
 			do_warn(
 _("bad # of extents (%d) for realtime bitmap inode %" PRIu64 "\n"),
 				nextents, lino);
@@ -1823,6 +1839,7 @@ process_inode_blocks_and_extents(
 	int		*dirty)
 {
 	xfs_extnum_t		dnextents;
+	int			ret;
 
 	if (nblocks != be64_to_cpu(dino->di_nblocks))  {
 		if (!no_modify)  {
@@ -1847,7 +1864,9 @@ _("too many data fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 		return 1;
 	}
 
-	dnextents = xfs_dfork_nextents(dino, XFS_DATA_FORK);
+	ret = xfs_dfork_nextents(dino, XFS_DATA_FORK, &dnextents);
+	ASSERT(ret == 0);
+
 	if (nextents != dnextents)  {
 		if (!no_modify)  {
 			do_warn(
@@ -1869,7 +1888,9 @@ _("too many attr fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 		return 1;
 	}
 
-	dnextents = xfs_dfork_nextents(dino, XFS_ATTR_FORK);
+	ret = xfs_dfork_nextents(dino, XFS_ATTR_FORK, &dnextents);
+	ASSERT(ret == 0);
+
 	if (anextents != dnextents)  {
 		if (!no_modify)  {
 			do_warn(
@@ -1920,6 +1941,7 @@ process_inode_data_fork(
 	xfs_extnum_t		nex;
 	int			err = 0;
 	int			try_rebuild = -1; /* don't know yet */
+	int			ret;
 
 retry:
 	/*
@@ -1927,7 +1949,9 @@ retry:
 	 * uses negative values in memory. hence if we see negative numbers
 	 * here, trash it!
 	 */
-	nex = xfs_dfork_nextents(dino, XFS_DATA_FORK);
+	ret = xfs_dfork_nextents(dino, XFS_DATA_FORK, &nex);
+	ASSERT(ret == 0);
+
 	if (nex < 0)
 		*nextents = 1;
 	else
@@ -2076,7 +2100,10 @@ retry:
 		return 0;
 	}
 
-	*anextents = xfs_dfork_nextents(dino, XFS_ATTR_FORK);
+	err = xfs_dfork_nextents(dino, XFS_ATTR_FORK,
+			(xfs_extnum_t *)anextents);
+	ASSERT(err == 0);
+
 	if (*anextents > be64_to_cpu(dino->di_nblocks))
 		*anextents = 1;
 
@@ -2126,8 +2153,10 @@ retry:
 			if (try_rebuild == 1) {
 				xfs_extnum_t danextents;
 
-				danextents = xfs_dfork_nextents(dino,
-						XFS_ATTR_FORK);
+				err = xfs_dfork_nextents(dino, XFS_ATTR_FORK,
+						&danextents);
+				ASSERT(err == 0);
+
 				do_warn(
 _("rebuilding inode %"PRIu64" attr fork\n"),
 					lino);
@@ -2859,6 +2888,9 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 		goto clear_bad_out;
 	}
 
+	if (xfs_dfork_nextents(dino, XFS_DATA_FORK, (xfs_extnum_t *)&nextents))
+		goto clear_bad_out;
+
 	/*
 	 * type checks for superblock inodes
 	 */
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 19eaf16c..247438d1 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -392,8 +392,11 @@ pf_read_exinode(
 	prefetch_args_t		*args,
 	xfs_dinode_t		*dino)
 {
-	pf_read_bmbt_reclist(args, (xfs_bmbt_rec_t *)XFS_DFORK_DPTR(dino),
-			xfs_dfork_nextents(dino, XFS_DATA_FORK));
+	xfs_extnum_t		nextents;
+
+	if (!xfs_dfork_nextents(dino, XFS_DATA_FORK, &nextents))
+		pf_read_bmbt_reclist(args,
+			(xfs_bmbt_rec_t *)XFS_DFORK_DPTR(dino), nextents);
 }
 
 static void
-- 
2.30.2

