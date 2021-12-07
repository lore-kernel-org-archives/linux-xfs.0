Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD50DC433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Dec 2021 00:01:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378043AbhLGAFX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Dec 2021 19:05:23 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:11542 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377888AbhLGAFW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Dec 2021 19:05:22 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B6M5Ce8004493
        for <linux-xfs@vger.kernel.org>; Tue, 7 Dec 2021 00:01:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=RBFRgnUZ7OuvjpCopZLAdyUbb0Z90yNIz56EY2GDDDo=;
 b=IGYZbM5vmb6kfiJJlKjZTwxdEDbyfu7W7xzzCa/RR2whoL6nMunmUzK+j1AYcqEb2pv8
 M3wxKlY0k1qYcSsSLqpUgmPtuDJ7bB1aVNs476CvWhzZjNb1BbVxEpTUYcjFYPhYhYQC
 /mUCN7DGZ4iCQ7iU6K9+OiHpOQfX7QfZsIl2+EFmVC54qHkky9EZIzI0hJsCbw6B2SIC
 lcyD9H5tZ4dggsLuU0AvuQnjhvdyIHbFD3f1PZt1P1jWEvAhKvXwcga9ti/SZExOCHjk
 52TRvoOOAyKVBM5YjUYll3FG65y7lbHL2YUYp7FImBqk6ZSuiNSxhS8RfCxG5Q69LQk6 zw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3csdfjbpsh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Dec 2021 00:01:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B6Nv8rG169164
        for <linux-xfs@vger.kernel.org>; Tue, 7 Dec 2021 00:01:51 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by userp3030.oracle.com with ESMTP id 3cqwewtb25-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Dec 2021 00:01:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n8OqONAt663n7z1gzRC3ptdjRykFO4XpYqdd5s5ofRlLOqNaqdPUWO7Xl+JegvD2VDNymjN/hA9HjN1P7+Gx/ZhbWTTpkqbICHk4JI0tDuB6Q+Ae25kIVnYtUaK6/Qdi3OGO9xEgCRDhr1u/hqW82GagMWoHEaNquklBirPfVbAqVs9mrKYWIlNgqt0NCxII24h9CiVMp4dure09vOAKeK+BDszzI/SwMUfl9octRr3VVmoQjQSuCkj2LOuUP0CUj+acD3a03GtlMQJtBLcaXrYtEs9j9H0pJ68JwYRGNJ4vXur4coDJZlZb+yGO8NnnQHanwXHt7kjw5KMjqtEiRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RBFRgnUZ7OuvjpCopZLAdyUbb0Z90yNIz56EY2GDDDo=;
 b=M1MILVtlqXBjOQF4VufDUH1QnvlM8sbB40O2aRNACMT25RRD6Zpu+dA/E/lPPighgONRJiCy9fKMA9YGDUns3npEzh644JxP1X/VL0tYEv5DRZmR7ZBmrb1/KQI5Q+au89xOAJCkVmFp/mGNB/wh3bnST9xrJ8qIGi3+gPZzhiyeAbAZovZ7e5+LbndzoTkUR7KYx255IkR2iWUu+rsHvd2wt5uwMxNT50zlJ6x9ihrV2lROk/mqfla2fyx3KGyKGmHeX/WMUkvPHmnSrz1IEgiSpaOzumdQq82frXODrlNZvhATCrknquhSATpTrciouctg3S6nJUthsNPoTyuKVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RBFRgnUZ7OuvjpCopZLAdyUbb0Z90yNIz56EY2GDDDo=;
 b=ofIx/6YSOpbkqBXX82Hx3DiCtLcT22GeMxZqkSXeC6KHvcQl/gn/iqG1uwYdS4Zovlm+yi2ZwywAxkuaGNkOL/KMCWwc76VbdJhhcOT6g0nNahYJNp3B0qWNxAXDk40RU3Flm/BGoOQr28CnLDDmcHCi/PFUMiO58x68zBOFefQ=
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 DM5PR1001MB2250.namprd10.prod.outlook.com (2603:10b6:4:2b::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.22; Tue, 7 Dec 2021 00:01:49 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::ad2b:bc5:20b:ee97]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::ad2b:bc5:20b:ee97%4]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 00:01:49 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC PATCH v2 2/2] xfsprogs: add leaf to node error tag
Date:   Tue,  7 Dec 2021 00:01:36 +0000
Message-Id: <20211207000136.65748-3-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211207000136.65748-1-catherine.hoang@oracle.com>
References: <20211207000136.65748-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0036.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::49) To DM6PR10MB2795.namprd10.prod.outlook.com
 (2603:10b6:5:70::21)
MIME-Version: 1.0
Received: from instance-20210819-1300.osdevelopmeniad.oraclevcn.com (209.17.40.39) by BYAPR07CA0036.namprd07.prod.outlook.com (2603:10b6:a02:bc::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16 via Frontend Transport; Tue, 7 Dec 2021 00:01:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8be19c27-d936-4a1b-ce78-08d9b914c193
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2250:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2250A1730332D3C4C7025E6D896E9@DM5PR1001MB2250.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T+R0EOHUu1+Fcui/+xxX4ad06FbXGJvMN1UkSK9brLBp/UZLj6YE0IqZZn1TPxZyMYFq5FtIACjw9zVjFTVI2ClzrRnTiVtnV5gYVbA+x/tBf2t+rHe4h5GFv6FGLTaTLA3+Z/KiLUnhRBZE1JxFw1YHxAytEYQEs6kjA1NdFcAkrRhjgexAmBjlOC7DEKpQVpiK8ELw2gOqRp7bQ93GigxHaQ5q0ZOk/7JpmRgUpNk843Cm9bW9P2TvrMZAqeKIYByOu8I8wMZBdFFMjnkLyfdysUBTo4CYbr4tOQ17nf0BSGPgh/z7ipOEh/uYtQEJi67cYmoD+BT6eTKQK2+21uWB3lCW7VacapBRXO5WMiwKaGUUk9llPsCYf5GlVC6pqE6NcJLjjdJfgLYwoaTcQauqZhOg8FwE1qf4PWrxb/4SPzkkIsVOWN3V5isevTf6QuBPKAXUdN/ex00TtxbMwgUz2IKliED/TYGGHABG0i0WxNAigLFSkm8X4wnIVxUHjlKLbIqfOzgg+y1Q1KXJdBicr6ZRHxhiSqFy3hfAVlK6AIkUP/yppiDl+3MDkw+g71QCL9NkKNck1NTKkVUuBvqOx2wuPaqQ5seCT+hXbp/LTtZKD9ha5nU+wHeZsFF5Rf7RtLVaD2w05PMcc9YlxsXOR5Dm0CsEFMIePwvuI7SklFFMSM5a4erl1RaYRuRO+aHqWskf4LfaAqU2aoqRyQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38350700002)(38100700002)(66556008)(66476007)(6916009)(66946007)(2906002)(6666004)(36756003)(8936002)(8676002)(52116002)(186003)(956004)(5660300002)(44832011)(2616005)(6486002)(316002)(1076003)(508600001)(83380400001)(86362001)(6512007)(6506007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bQQTsrmsESLbPkMtP+phPvRlYoAddHT+8Di2i9s2daaX/Ize+KyKBqNIQAmS?=
 =?us-ascii?Q?JXslQI/dcors5XtSdNzYIf7XbYPpccvlOrPe4raywnexvTgd36nCeRBdM6WV?=
 =?us-ascii?Q?EPkDnarhoFz4UlKG/2lwEzrN6VhEIVb06SKlKLlY5bb/EJj6lHaqeejdMC4C?=
 =?us-ascii?Q?nn1TRrb0XOhJe7Xmn8ukmnEzmDdgn8sZDSO72ZiV6FVTqFMb5UAonQsASJLP?=
 =?us-ascii?Q?RVYh15nD9juwO22LdVtX31N0GCrwlG1B61xmdNUOCecYpEXYOTMUJiEldwQN?=
 =?us-ascii?Q?10J8EvxBpaukWHUa56qFkQADuVc2rkcsw0TqokUVQvhW0XYApiflsPovxOAD?=
 =?us-ascii?Q?YfD/8cIq3Y7HDbZpRFqYnX1YTbIgTb+oQhDkw2VWaUHEWlE2NB8F87h7P505?=
 =?us-ascii?Q?0VIdldySRCk8EbsTf7rdyBHKzzNxo4eeUpvzpFJ8D+bFMlf3bxy4NeKHnAKb?=
 =?us-ascii?Q?5SnWBrvoWVIpL6LC+wiRF3Pz7GEr+KFaoxKxhfm1gEs21gDU4S6JkIf4Fzf7?=
 =?us-ascii?Q?ZgKnHGY3DlrctafJbgnywr0izhpxmE2dave4MVhMl6KGTVPNyAxbXpTFxEWn?=
 =?us-ascii?Q?DehkLdjAv3DC5z+OkQ6raijrR7fKE53Xqpam1joNRG/sGEeMgBAkI9TD+J4P?=
 =?us-ascii?Q?t6MZzDHXLAa5+ZKnm+UBTTUzct2UHaaGpHSHYDnZ3PFrAavriCdihc227wX5?=
 =?us-ascii?Q?l+0VzVe4lbvrTVCEuzpOrQyyvpnbc1tBmB8Ef17wElf6ZSmWrEM7tIhYdfqG?=
 =?us-ascii?Q?VLQGr8wtz4OAWbfUmNZSsWvTr4afSzpeyOMfMDr7E5AnkG3wlUsY0dgPFEVH?=
 =?us-ascii?Q?xCoJykJg7SKlJsPJBE+2khgY8JREPlmVCPsBRlrzqr0mfA6h8VOxQ+DJg3/M?=
 =?us-ascii?Q?rfSHfNglR9ijQgx7pGV88yR+gFKLWGVkvdzN48ardNbBQFREEyCD3fP1w6qD?=
 =?us-ascii?Q?/Dz9pmGq1eL2AejYtdwIt4kKn2HchSyMBELU6Mz9gxP6XRPCRPRZE4SdACnN?=
 =?us-ascii?Q?3EQmwZWe3fpPwe3xgotjivYToCatyDXIWtG/g1LbesdRnpFHSYQwxwmFEpJE?=
 =?us-ascii?Q?2ib1aEXDs4NVvcZSS8dw3jdqEYOa+DqOvmfr2DTzM5GTSeb7wDNvph3pGtI0?=
 =?us-ascii?Q?NsAozfOaViLiZ36+3Y2uv8ksMWXq2XnWARyNrMlnz4ZvTR5Z/5CgVp+iTgOx?=
 =?us-ascii?Q?yjyx3yLm5iVKUmmQL/gpl0aYLZHiyhmFNqNMBcmsuJkskbNsMBNOa8Gy0638?=
 =?us-ascii?Q?z13FwmTRPklSjy22MB6LUp/shwScuD6Du0heQinc7jOW8iaCEQWTyNt2nia6?=
 =?us-ascii?Q?XP0WjW7Smm2LFaTRgUfRAldJCl2GNbN+1Hko9Rf8lGn2IfkG4Q/HADz4Uh6K?=
 =?us-ascii?Q?/AMIc4uq8nCeVN39RyLwbTGjgLiTLPIVtX89mtzNoM6r2exGGgAICyJXYVFT?=
 =?us-ascii?Q?7chrqFgilkM6QOTScAmtzW9+u2/GfYm70aPqeMgmW1J9ldt/gn9bU4Tn24HV?=
 =?us-ascii?Q?tDSnShRbU5pnWu0mIeQSB5dboWs6Tiae3x6vWLbQa3hqMknk6cLnx19B4B08?=
 =?us-ascii?Q?tznDdkO++FqOGJHwpuQtdPhTPnNSSnxFdYVilgHgazYuJ5ThTTvnWJL0762G?=
 =?us-ascii?Q?HJeOfX/aKyTPjmXR28QgDm0Vx+UdsuFJ49Eh5GeRhb8tdISRh1hpvB74JfR4?=
 =?us-ascii?Q?coIiSQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8be19c27-d936-4a1b-ce78-08d9b914c193
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 00:01:44.9238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rGjsRguGgQ2mL19b6zR7CWDIfTXJ0woB1KM0saiL8nOm1X990IYyM/VrhnrkP6jrlfvtS52iuSzjfc3pK3/aIovKW6lHwYAC5bT3Cxvr2Ho=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2250
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10190 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112060144
X-Proofpoint-GUID: Dho2Bbp76xzX4rjF8tdoZLRRNzM3doR6
X-Proofpoint-ORIG-GUID: Dho2Bbp76xzX4rjF8tdoZLRRNzM3doR6
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add an error tag on xfs_attr3_leaf_to_node to test log attribute
recovery and replay.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 io/inject.c            | 1 +
 libxfs/xfs_attr_leaf.c | 5 +++++
 libxfs/xfs_errortag.h  | 4 +++-
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/io/inject.c b/io/inject.c
index 51f3e2da..4fc5dec9 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -60,6 +60,7 @@ error_tag(char *name)
 		{ XFS_ERRTAG_AG_RESV_FAIL,		"ag_resv_fail" },
 		{ XFS_ERRTAG_LARP,			"larp" },
 		{ XFS_ERRTAG_LARP_LEAF_SPLIT,		"larp_leaf_split" },
+		{ XFS_ERRTAG_LARP_LEAF_TO_NODE,		"larp_leaf_to_node" },
 		{ XFS_ERRTAG_MAX,			NULL }
 	};
 	int	count;
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 6c0997c5..0f40a1ec 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -1181,6 +1181,11 @@ xfs_attr3_leaf_to_node(
 
 	trace_xfs_attr_leaf_to_node(args);
 
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_LARP_LEAF_TO_NODE)) {
+		error = -EIO;
+		goto out;
+	}
+
 	error = xfs_da_grow_inode(args, &blkno);
 	if (error)
 		goto out;
diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
index 970f3a3f..6d90f064 100644
--- a/libxfs/xfs_errortag.h
+++ b/libxfs/xfs_errortag.h
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
-- 
2.25.1

