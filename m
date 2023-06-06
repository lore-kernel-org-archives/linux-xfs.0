Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 300F2C77B7A
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 09:29:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235764AbjFFJ3f (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 05:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235503AbjFFJ3f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 05:29:35 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA9AA126
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 02:29:32 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3566E0tD009966;
        Tue, 6 Jun 2023 09:29:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=Qc5bK7CI9ehwaMRVDUn5JLVZgOF3y8Kt/sSCkHYgUSc=;
 b=LS3wGY/plRAF232uJIajogoaDSWW2FweChIbbi/NU8fhUHmJ4YKcbA326HFzy/uV87n/
 rU7fNAlk5ubOVP1DTFGpnzA+BktsPvlA6Kh4xoh/xxEQKoxjS54Ryg200ezS6Q2eupJa
 kGwD35+PckIu4+Fuz2qZ2ug6SDhrmUC6SX14pVVlOu/hoHzcYaqun9OorNNQFv9AZZWD
 lboJBsj2ubaKVhqcatIo5/0a0Tp1WqMd2yBGn1iIR17Mi21omi8L/gwf+vP+s0TuCw/e
 A/oBg18zKlHuM/+YiuBPRU5lj5OgYueocOKinS8FHsN3EyNZHaWw7tuAsiwluFFfVUNy LA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qyx43vvn7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:29:30 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3569DOt6001871;
        Tue, 6 Jun 2023 09:29:30 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r0tr0c79t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:29:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lOIN9MWQS6T/FV4pEiRFP/qNrMBgeHuuShGuTwEBf1JlbZE+i/xZ6PScdlLCQpXcDsKl49uIrj0gmMe5rDXJDzNoCBduRQSueMmZip3S3ELbmuUFjkiVJCVRfgGo5SZuy/KPWJQpwPdcfYviVdZptfpZ29KpJn04hZJsxjuoNmEXQktsw1vVz5//zHniGbadShNUo6QeVs7wEL6dRwUKSg8+HS5NV0CE35B/T0+TlBwwC8amCy8NHYrZ5t8W+j3JSNh2VJSjs+81ipn53aGtweC2Eezg15Is3R2Gbqer4SdyE9YLN5Y/hh4dgoupPO2h1ZLl7UBrDPceyRlccJg+Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qc5bK7CI9ehwaMRVDUn5JLVZgOF3y8Kt/sSCkHYgUSc=;
 b=VJfWdJQOoyWAXXHnUydx1qQvr7T5zwVfhPAK2k/SJTqk3U/Vd9ZsAskRSnENr1XTnJvF2yN7iRT8JVrLTYGqFwscMXzVWN53fybzUrhR174paW0W+kDW2PFnDq19ZVsv04bpAit+CZF9jR5PHDPkkPM59LiDZZ8VVfjosm/dkpqpte5FZifMugB8WN/ph8cyaXeHwsDuMgYTPcHjJz7piUEJJm3IYeMtxU8pr+Xj/UczkxR1FS2VWB1hnLqMwFh/vNoorM+tM/nLZIGN464Af9l2LeBrNDn/588V5PE7ncqow/HkVZPZwOl1tbL37Zo3X3y14s7g3PxSkmNG67LQFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qc5bK7CI9ehwaMRVDUn5JLVZgOF3y8Kt/sSCkHYgUSc=;
 b=ZOGWw3CEG1JWsoze8GGfXTrhN+Hq5u8MvKX8BcumHk59nNDT97WRMTL/GIg4MPgKoli2cGB4XTORp/VWfEQCsxA06mvS9SNSf6WLf6OG7fIglE5wial6gTpJdIRfBfzstLFE2mWiXxXNEHo2xCiU5zDgpR7+UiqMWVZVwYzFICc=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CO1PR10MB4562.namprd10.prod.outlook.com (2603:10b6:303:93::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 09:29:27 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%7]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 09:29:27 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V2 09/23] metadump: Rename XFS_MD_MAGIC to XFS_MD_MAGIC_V1
Date:   Tue,  6 Jun 2023 14:57:52 +0530
Message-Id: <20230606092806.1604491-10-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230606092806.1604491-1-chandan.babu@oracle.com>
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0153.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::33) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO1PR10MB4562:EE_
X-MS-Office365-Filtering-Correlation-Id: fd72f571-dd95-44aa-a96e-08db66708620
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aejqaJX3L6Rd4+Z6KzlzM6lo3jzaF2i9z9gVwRgcterkA3iunPhcLHMDFHNFe9yYa+y7eGV3qxp3EMz5TX6+zqDjKmwgPlc67Acy3Pq3TjQ3wQel5YC9FvIdVdD66X+4pMZQ/OaJVQCqVcFXD+iid3EESV3xnbor6ttdEkI+4+D4Nh1MyYjgguRrJGcYMGK6OjOfnxf/P+rVhf+0yB00kbdWWee5QiIZNMlO/+D9xUtxCPWAqyxoD8ia5wn0VY5RjXGR9ekU2JTbx9p6vYPA++99NIzXOSoBoEqLXMZXOSjaLZGdZsgQeBsTo5exfabOvfozTEDMu7/xDMQXvEPhm/pHl1/D0+wXhR4gLKKTxPpgPloZdgxZWP2HtaQwId46O1h3d0U7ovroc0Tp7t8wVjvnOt+QlxsDnrlC0EuRo6kJRmnbCxrQseZ4ZgUIWtdqoK5VaCvxoq11RIqMo1DrmpCvFZa50ERJsMRGX8KREcJCWxRYrvjlQWtefd4QYkNNBEIP8TS6QbQFdQA5YmMIUXpwLSCPLmlxTJ3I6euLnGzjZAVaC3q7v1rOg+iHzg3l
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(396003)(136003)(366004)(376002)(451199021)(8676002)(4326008)(66556008)(6916009)(66476007)(66946007)(8936002)(5660300002)(316002)(41300700001)(2906002)(478600001)(38100700002)(6512007)(1076003)(6506007)(26005)(86362001)(186003)(36756003)(6486002)(2616005)(83380400001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gItYBD8HLR+BH9/l7tOEaqYSCkMLC77yu6vkXdO+5BEP/Dfi2LQOPucK3dRi?=
 =?us-ascii?Q?n46qLQpOMKGesmytLs3NiWL0XNurAG6ElBTvCEVyDX6ObXb1bGui2bVRjhxs?=
 =?us-ascii?Q?EiItK0CRMHzibTfTm8DJTIAUPcxKL7lUCfdoLKEo52/jy7uXtcDqzITW/5rq?=
 =?us-ascii?Q?rqFHtd6L/Qq5mKfe1TTlYGLMtjXIMfblUEij1H2woaTHfZ3oQSddCeC3pZzx?=
 =?us-ascii?Q?EShREIjh/GUGBQjQKGMHoiT79YiR2CiQtN3AEunUiFgT2+yZkDgkKTNhqMg8?=
 =?us-ascii?Q?1x4doz7USPA4FZxtlshd23hzDbZRB+M8OmJ2Xfu8wK51YbP6okPc0ksTtKRj?=
 =?us-ascii?Q?rLK8dKjrnmxW98QFILQIzBwTQ/hgJbt7p1IyC0kUHOFc72T4SONt9WTDE+ot?=
 =?us-ascii?Q?/Sp6pTFXRMfTG3mG7InF/8yQpP470tAgoUlsSCl4M3mj2OnI4sobxKx0rIdC?=
 =?us-ascii?Q?UF86vW/CaVXUg71R1R5iMUZ9NNFsv9l8vStLU2LAIuzeAKS2O2D8AA54DrMn?=
 =?us-ascii?Q?wTZs2aFh9oSxm+dlibCzcSDAxQ2mdWtKFBREkYyJ0je7HrSY2b3qqKWUq0m+?=
 =?us-ascii?Q?8NjcB9jg88zAGzoXLAlyvhVbXaCgSJpWzl+wT5MpujuhHxuwxJuyjEjiBW33?=
 =?us-ascii?Q?syZMO7HY+JLPeJ2Rb9BvEHZ4XPjVtVnk7K3r85kV+XY+BvOW7w93nSOcfx0c?=
 =?us-ascii?Q?qArcjfOeOhqQo+H/icv0xF6Hy0r+GAeuNits5Ly9gHYAVCqtu+GT+uuoj2VX?=
 =?us-ascii?Q?c5isdX9YNaiL7n+URSOozkOJdnhY64glLndqjHfIiQbzGg5jKQP0R1P5x+mG?=
 =?us-ascii?Q?VCAjen9ch96o62U/VzWDD4hh4ehugvJFylZhj3SRUXAoVqu8efW3/oBmdsNR?=
 =?us-ascii?Q?XGWByJNGfP58G2zffBjuxLxaBRa2JI685HTgMQZ/G4d+J/PLpurVktBRgD6X?=
 =?us-ascii?Q?jQ3UPH343hr1LrXT/lgw5BMeZqHw7NYLHRj1pxtWgoW4lfvF2QqMTNt0kQtF?=
 =?us-ascii?Q?+H9Dmoo4DpqkkX1+Ikrw2m+DE5E59ua+AMMku+eRQPbfqQEZUgcKH0KRfbgE?=
 =?us-ascii?Q?N2Wdqwx6GzBM3NPhVZBiMfTfCj1fa6oj+Kwuh2sISWZPpiBLCUdfbJq4KKNn?=
 =?us-ascii?Q?H+C2LarwiNSIKZziJDuM3JXdj6ChGrgCtgHhXk6upV26FzAQQ+EYlKhnYkWS?=
 =?us-ascii?Q?zDZJ9ygEtpWVwdfo7VqkW90x/zGH1UIiwMBgPfWGpgp/JZ6FSZfiBZUrAYnZ?=
 =?us-ascii?Q?Fscx+LpDfXmKD8wghKTTtE9KZYgzkGfer+PlgCd3nhygCPSfwEasVgPW3+bj?=
 =?us-ascii?Q?LHJm4V0kfjicF4uAypDcYGSs/dnnDiKdC3DfCXF0Huq/R0xCW1N5g8W2q5bO?=
 =?us-ascii?Q?FSAKWNQVPLPIujorv4HMH30Hkk3jfNuI0bMHX6zwEIWQO2gj8qL/YXHzCH3Y?=
 =?us-ascii?Q?7dxjQ8LeICyyRPaZgXiMA4N25vFNL4cfCMPhFBQVVLvsZjans6DKTJJlbHyx?=
 =?us-ascii?Q?O/6HOGEkWFeMM3XmmNLYXMXRoW3x+/JijQOKagVOlliDC2tAS3ptna/VSBZO?=
 =?us-ascii?Q?0bvayhRTlDPzsQIeA0sroQf5d6F6rhn1s7nM1oNvOvJt5/TiQ86aE7zmxmHW?=
 =?us-ascii?Q?RA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: y5vyPp/8enK6u1IryhFpR6S97ro3pxdmKHv/LWYFP1ArfFtQHRlRmgRM7LeiPhsTYczK77I2FVD5KCrZPfHAwSDapT3UEt7r2vGTRfQgR4BLHFRNW4CDL7vOTxn3odBU7FyC3PP2VrTQOoNQ6280dwqbrSY3MqKJ+xPRkOPz51fqRuO2KXmFYtzxpWyj/Di8t9SXu4FrCDd7Pu/T66MLhMlUIuhdm/qu1JTtxUPr1+Mi8/ejlxmEr6xi5GFD7Z8oRV1ZrvuHxVsJ/BAYTBfRikiG2YKVyIrXUw/e4JNbGQeAU3x63SzGmPdpL+Td34QFK3EMCiptFeZl/mhmdsfY8urHcv2CyxYnaqyfAR+8p+fG3sgFi4OHWHd2zCsVj/O2StJzESN7pfCc0XsqbNFdHBAkcF++Hzy3KcLu0izs0Y3tmzqfVUlHLxrMTm5YAMNpRGumZA4Iu5GuDFDg9QjlSHYXDG1OrGPvIJBsV4M5Bo2rYHVhKLYp89IkPJKPEsdjBfJImueP0LFnvAhFqIYMvDN+0o+ZToHo9T+AlIzCo79j6i3FAiHYq5xUnfImUxf2YpS/BO7VIaqtDU/v9nphZe9IxQL77VXepJncUF/dnECDMUC6fvhZPdsKCoAfRB6TJVnS5Ihec334oXGptmb+ZahH1QofwKdKMj5VjKivkzBDjQhMpJjzLGYr1STaQ1LZpjkc8sTzE1VwITKQVjg9ot9lUewdrd6TXdZxjxQJnncpokadi2MuRzP72ToW8ohD9OD2iNNFqqbk+yDjEMWiHQbUJyjHrF+aEsodvSc1CBM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd72f571-dd95-44aa-a96e-08db66708620
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 09:29:27.8477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8GXWPxAyUOm9SEyKsixcPQPfS7miOIzCOybJ6ApvyeAqQsdP2AUVUUrvE1FW7zLEBKtu8H0udj1kIMMrPK+rmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4562
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-06_06,2023-06-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306060080
X-Proofpoint-ORIG-GUID: CSTd4kr-1Kinw-HUbQerhJRE7IrcJOKL
X-Proofpoint-GUID: CSTd4kr-1Kinw-HUbQerhJRE7IrcJOKL
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c             | 2 +-
 include/xfs_metadump.h    | 2 +-
 mdrestore/xfs_mdrestore.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 287e8f91..b74993c0 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2966,7 +2966,7 @@ init_metadump_v1(void)
 		return -1;
 	}
 	metadump.metablock->mb_blocklog = BBSHIFT;
-	metadump.metablock->mb_magic = cpu_to_be32(XFS_MD_MAGIC);
+	metadump.metablock->mb_magic = cpu_to_be32(XFS_MD_MAGIC_V1);
 
 	/* Set flags about state of metadump */
 	metadump.metablock->mb_info = XFS_METADUMP_INFO_FLAGS;
diff --git a/include/xfs_metadump.h b/include/xfs_metadump.h
index fbd99023..a4dca25c 100644
--- a/include/xfs_metadump.h
+++ b/include/xfs_metadump.h
@@ -7,7 +7,7 @@
 #ifndef _XFS_METADUMP_H_
 #define _XFS_METADUMP_H_
 
-#define	XFS_MD_MAGIC		0x5846534d	/* 'XFSM' */
+#define	XFS_MD_MAGIC_V1		0x5846534d	/* 'XFSM' */
 
 typedef struct xfs_metablock {
 	__be32		mb_magic;
diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 333282ed..481dd00c 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -240,7 +240,7 @@ main(
 
 	if (fread(&mb, sizeof(mb), 1, src_f) != 1)
 		fatal("error reading from metadump file\n");
-	if (mb.mb_magic != cpu_to_be32(XFS_MD_MAGIC))
+	if (mb.mb_magic != cpu_to_be32(XFS_MD_MAGIC_V1))
 		fatal("specified file is not a metadata dump\n");
 
 	if (show_info) {
-- 
2.39.1

