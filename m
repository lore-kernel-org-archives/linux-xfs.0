Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4247FC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:09:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24D9260EB6
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:09:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236091AbhIPKLF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 06:11:05 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:26144 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236062AbhIPKLF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 06:11:05 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18G8xsgL004749;
        Thu, 16 Sep 2021 10:09:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=yN8Q1xZ0ZPROO2JckAKfVSvZh3SL2kPN6P/mxXXVk8o=;
 b=se/rTRPxBSDCpM3Hyp3PTI/L2UW10sLuqoMB9EkZpVJ3aP95CmOqwN4HkbUfBkGkJtDg
 RQzfQgNfJ071ePChDKnJLG+s5FEZPhEMIewu4WM2YgJGagRS1D6ARMJxoaqD5oSp6mCq
 yH8/wb8PEjXekl8VgxTJcMQkk5S50mzmhlxQJ8gjTEooWOFF9neT9pIl/fg3BddtUCdH
 1Cm/FSnuCiYthLCBUBsq9bUfnitBYmn5ZLXO2V9H4wBspjvaMrEyc+7/EPvTXNQnRhF1
 GjGVGakCGPKcWWyQRYGCLEKd35aSCOK+UMvbTcmvQ5b4LnjUHbHVw1A+4iuGBFsC6sWr rQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=yN8Q1xZ0ZPROO2JckAKfVSvZh3SL2kPN6P/mxXXVk8o=;
 b=qgaqkaOsTxNDj5AZJEFXJA6sdbFjW4a3pY1zlQZUaZdIiaf8FyGc0+MTNEfs3oKfG2QD
 5eIylGe7fMLz3u2srmoS5skryH21+WKrrVaK1tU5OsjTNTN1Im1FrAZh++7zLD6EuLiK
 TWgj19kOzeJz6n6gjnUT7sV3HWb0In7D+YGQnKeI69Fi8tjPgL61PU36D+c3ZFfbyps5
 D7zfkg0RnCYBA6OqHtfD8I7IRB0wnMHZltOY+IRsNDBzSxCN5oVVOG/9KTO3mtQiqPiS
 eFRaORIfb8ql6Rh7vokl1v04afiU7mKSBJTKv8003/+ELZHmVFbnmaAeP49VCCmz0q2J og== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b3jy7jraf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:09:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18GA9flQ183829;
        Thu, 16 Sep 2021 10:09:42 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by userp3020.oracle.com with ESMTP id 3b167uxqhe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:09:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f4y9o/cRgFK+JKJ6diNCDvUWIl0cRSSP80wGtx8deKYMscZ/TO+F+BQjAWqPTVnZ0jlASY3KQoTBy9N+lVRE6Pd2cTCMx4acP/5vuAP+JOyeXVx4Vty+sj8r/DAQOvYfs0/OFnESc0YDNS4Hk1nJapchc2W6qffJ4cZiPnUt4wTz0ggfBc5UmDdnQuBSnJEgXACAyTmsN4BFqNETsD5pVYO/wBLECvtupShOcdr4yLwzE4rvRBIjMjqobdZj6F3HrI/qb+Bnbueh4QJX3cEQCB1LsMClDFvpi3bRr781eXMVKJ9Kk4OTyj4O3DfXhGdJcbBjlGszXIKj2hTneUR//w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=yN8Q1xZ0ZPROO2JckAKfVSvZh3SL2kPN6P/mxXXVk8o=;
 b=h0J3Lt3qtc1IeEr75x9tTJJ5zpaghthwWuHp848gChiJDiDQI5tf1pLZ+OGr0/KlhIgtuszTxcCi08E0oMF+pKTGZcgIFeTF1QXvS8ETRsEBgydQpF9Df/RvsEJGYHRYuD7SiHXJgHM4CkGbLNIvJgfHQ3IHubgo5mys/WUDTw6QG3wpB4GS44Rj7Pk42FbNXfDFXhEOK+oCWBTOnDmhTobMD3bq1eecNqmqVuPveatmV9AqVasscgHweg0JE683NzEE40efmRh0Ve6T0t+pKZyaVhaKD23Cda4sjNmRkOW8L11b/Y8ErFWIPgANT5j3jkSdDU45BsRO9kCLm9Et7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yN8Q1xZ0ZPROO2JckAKfVSvZh3SL2kPN6P/mxXXVk8o=;
 b=QAHaQ+N0EMJHj9EZhJhmpDGtooYaifg3h6uMcR1NxcWrbDlxYIpI9yV6Q2+gQmtk5RYKCR6rad7WAVWeTfhLS4R+o+k+C9B5qTZ7wga45ixFImVm+2Z1j6LvJs5zPYnQF+bTs07QE9qU0mMnA6SPMd4Yy9tntkzUhFZhjOF2Ozo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4748.namprd10.prod.outlook.com (2603:10b6:806:112::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Thu, 16 Sep
 2021 10:09:26 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 10:09:26 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org
Subject: [PATCH V3 16/16] xfsprogs: Define max extent length based on on-disk format definition
Date:   Thu, 16 Sep 2021 15:38:22 +0530
Message-Id: <20210916100822.176306-17-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210916100822.176306-1-chandan.babu@oracle.com>
References: <20210916100822.176306-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0158.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::28) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from localhost.localdomain (122.171.167.196) by MA1PR01CA0158.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021 10:09:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 521285b6-e8ce-4552-8d4e-08d978fa0fb0
X-MS-TrafficTypeDiagnostic: SA2PR10MB4748:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR10MB47484207373FC2A0D184FC6BF6DC9@SA2PR10MB4748.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9im5+CvPazdhtKJ9n4TwaE+H21h991tnQntoZaxx1rAc700yALSJi7eCn0PdKrb9tMZbHMtJGFRlOZiiFofTXf3vsrnFVsKr8gh88jhsEs9pD+7uavejhXTpQuM2036g1ihfiULCTlCHw1p4ISNwJqLbhywjFfRDXaBiLwGv4roAUccc9NL0GZ56QFSTbaznm3es4jPyfVlNFgJcHg7NaxMMXC/Cj5OsT/1fBZvKXc/eXKnug+rXIAuZ/TdTRFU6iMtn/8sICGKtD9+ktzA794EbQRfoBSVeycYAk1sU52HFdhEDTVQAtGQvx5DH5JuC/xqH4gz3Fas/HMThH45j69LYdnQ8ppe1R6vWreNzy/vfEK7bvsbON5uDFvTafWwuMyVPAoZl94oQYQfsw/qobnhDbtQZ2s/QxWOhZLN3f4Z/3y6ji1VpnVWJPs2kyO5sfUmtH3u10W5I6T/Z41ZIJwimWlIbjBZwByre6SnykEsnrDOIZTz/A1lVJYn08Cr0sb+qlXFkaqJ/+AF37YGPIQ5JysQJWl3HZZXIRP+go6clVy3Wb5iZD8J0OUTCL0xUcX00PxKRKewTwpeilxe62FQoGXPW18jGxwQ7Iv9OJDVWSaScghcE9gS36VyQMXYbapRhlxn2S+Ha7LCTar5GyptqzM5lVB3G8N88KUxJGF4mPr5IGAIVe0VskFMFU/dT6mcTOJkVw2tYGZ/U0PFhug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(366004)(136003)(346002)(66476007)(2616005)(66556008)(66946007)(6916009)(2906002)(1076003)(4326008)(956004)(6506007)(83380400001)(316002)(8676002)(30864003)(36756003)(478600001)(38100700002)(38350700002)(52116002)(6486002)(8936002)(5660300002)(26005)(86362001)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GwcTFQ2v1MCsciTeHB2Qws7zvB2bQ34nGzPtaFKFStXisevmnujcqCVgs3Io?=
 =?us-ascii?Q?LD9julDA8alVfCV5sExu2no9G2oh29HIpfnnN4gxFg/QJrh6UgDS/BjVxU1p?=
 =?us-ascii?Q?sAlaVEhXoiTfHGSWO+hzDbW62GtiXvBXKTGMmElWymn33rsrxgQnFZqbuzC5?=
 =?us-ascii?Q?V8xP9OxSOPCehChB8rMEsIUcynkcWBFx59UgB/uTYH8K7ZOSnfUsFWxaM2Ea?=
 =?us-ascii?Q?aBY9rWvgYffODrhMjg0unYh5ugmClIlDYOQ+sEVDddgNbZKmuO244ynKrclk?=
 =?us-ascii?Q?tnTijVyOdb+A2+Ko1h7wQEjiZ+vK5vgNxO3k0f1LU97w7SVtIumdpmO8cQjZ?=
 =?us-ascii?Q?89RqF4cA6K+ixO9e2qFA3NXhzK5s09XnFpR1WuHTLeZbTQwoELO2YqiqB2c2?=
 =?us-ascii?Q?snmG+hmZKJy8BGKU+1VEPati5WP5w+TO8BYjq3Y2gvYG7i7gxPlJSVCPE6Ci?=
 =?us-ascii?Q?g+OY+HeXuTxgki2jXxDYIcwT9YAcBysYlPFK05EB8JA0ZSiqId76EgJ7o/gR?=
 =?us-ascii?Q?B8y7kunq6xKrgDwGVrm+jIPp85gGkVkjm9r40yqUohvUwJe2eZKgcu4pZzoC?=
 =?us-ascii?Q?UkC1fnlob9bzg0DcvOeWqZryKjfFqNGbKiVZf1Pe53S0Vs/y0LGwckAWyiu8?=
 =?us-ascii?Q?fl/cRbA9SCAj/Ehe0tqtXnIFtXYDVRicGXZZEHmZD7d4sfORhtGdHs6fTs0M?=
 =?us-ascii?Q?eFTzI+11CzVonUw2uPBbWPmGjw5mpiV921ywcXJjGpk37Qp4GtfdbpY0jIkD?=
 =?us-ascii?Q?6ey+m+T0+e77aSEYiELh8Jr0H8W1/nDpgWJQR39uzVyZ59vJjG/hzx8gzYt7?=
 =?us-ascii?Q?o9AjVd3iIxOumdCof7Us1bowMi9EllBmRBcZ7980MfpDK+n7o4fjM7kjVZqx?=
 =?us-ascii?Q?2P4omHMVbPycM62Bt/X6OQyB4AUjOyZ0gTwhD0PzuUrrylhpJO1EF0d7KCms?=
 =?us-ascii?Q?CQvTY0PDA3irWYMEY+G4f26JkFsSH58l712ZZWjHNvQYCgDB00f+tdOTvNTe?=
 =?us-ascii?Q?Nsc9+X7/p4p2Jf1COnl+4bjenTcxMyUun4myjMaTI5OwRowz2FNShFbRP5qv?=
 =?us-ascii?Q?3QjCoqYQNXFKS4Me2R4sE1AMJXEg3AzzeT+3XwBOv2/wIoQFCNrxWZcQaS9E?=
 =?us-ascii?Q?VMLs19HZTB8jTcM1xk+vQXE2QMXFGQQnxAIytQ//8lUpYLR22BIUZVlgUpXx?=
 =?us-ascii?Q?cFi/oftJA3a4RWRZspkT8ubFfuLzLhewtF46NOfy5Xd1vyvbLgYxlClZQIeK?=
 =?us-ascii?Q?JlXoDoTRFzOcwNVO9oReyntQ+76wNr7QbkC1S5Nbcq34a0sx3JfAJij23L2R?=
 =?us-ascii?Q?PXDYzCBevM7Aot3e767dZxS4?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 521285b6-e8ce-4552-8d4e-08d978fa0fb0
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 10:09:26.7216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +7mLfT+SqYfKGBatG1crf+yq0COrPCvFq33oW29KUTZCibn7gBrn2bdtkTIGpfVuZWM7lymSk1Rx0YiZWJRS/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4748
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10108 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109160065
X-Proofpoint-GUID: 7ave891NwvkUXv99VOGYD_onfP_yej50
X-Proofpoint-ORIG-GUID: 7ave891NwvkUXv99VOGYD_onfP_yej50
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The maximum extent length depends on maximum block count that can be stored in
a BMBT record. Hence this commit defines MAXEXTLEN based on
BMBT_BLOCKCOUNT_BITLEN.

While at it, the commit also renames MAXEXTLEN to XFS_MAX_EXTLEN.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c           |  2 +-
 libxfs/xfs_bmap.c       | 53 +++++++++++++++++++++--------------------
 libxfs/xfs_format.h     | 20 +++++++---------
 libxfs/xfs_inode_buf.c  |  4 ++--
 libxfs/xfs_rtbitmap.c   |  4 ++--
 libxfs/xfs_swapext.c    |  6 ++---
 libxfs/xfs_trans_resv.c | 10 ++++----
 mkfs/xfs_mkfs.c         |  6 ++---
 repair/bmap_repair.c    |  2 +-
 repair/phase4.c         |  2 +-
 10 files changed, 54 insertions(+), 55 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 3e3e05c7..77a27707 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -20,7 +20,7 @@
 #include "field.h"
 #include "dir2.h"
 
-#define DEFAULT_MAX_EXT_SIZE	MAXEXTLEN
+#define DEFAULT_MAX_EXT_SIZE	XFS_MAX_EXTLEN
 
 /* copy all metadata structures to/from a file */
 
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 8a1b94bb..fa7b4a2a 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -541,7 +541,7 @@ __xfs_bmap_add_free(
 
 	ASSERT(bno != NULLFSBLOCK);
 	ASSERT(len > 0);
-	ASSERT(len <= MAXEXTLEN);
+	ASSERT(len <= XFS_MAX_EXTLEN);
 	ASSERT(!isnullstartblock(bno));
 	agno = XFS_FSB_TO_AGNO(mp, bno);
 	agbno = XFS_FSB_TO_AGBNO(mp, bno);
@@ -1497,7 +1497,7 @@ xfs_bmap_add_extent_delay_real(
 	    LEFT.br_startoff + LEFT.br_blockcount == new->br_startoff &&
 	    LEFT.br_startblock + LEFT.br_blockcount == new->br_startblock &&
 	    LEFT.br_state == new->br_state &&
-	    LEFT.br_blockcount + new->br_blockcount <= MAXEXTLEN)
+	    LEFT.br_blockcount + new->br_blockcount <= XFS_MAX_EXTLEN)
 		state |= BMAP_LEFT_CONTIG;
 
 	/*
@@ -1515,13 +1515,13 @@ xfs_bmap_add_extent_delay_real(
 	    new_endoff == RIGHT.br_startoff &&
 	    new->br_startblock + new->br_blockcount == RIGHT.br_startblock &&
 	    new->br_state == RIGHT.br_state &&
-	    new->br_blockcount + RIGHT.br_blockcount <= MAXEXTLEN &&
+	    new->br_blockcount + RIGHT.br_blockcount <= XFS_MAX_EXTLEN &&
 	    ((state & (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
 		       BMAP_RIGHT_FILLING)) !=
 		      (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
 		       BMAP_RIGHT_FILLING) ||
 	     LEFT.br_blockcount + new->br_blockcount + RIGHT.br_blockcount
-			<= MAXEXTLEN))
+			<= XFS_MAX_EXTLEN))
 		state |= BMAP_RIGHT_CONTIG;
 
 	error = 0;
@@ -2060,7 +2060,7 @@ xfs_bmap_add_extent_unwritten_real(
 	    LEFT.br_startoff + LEFT.br_blockcount == new->br_startoff &&
 	    LEFT.br_startblock + LEFT.br_blockcount == new->br_startblock &&
 	    LEFT.br_state == new->br_state &&
-	    LEFT.br_blockcount + new->br_blockcount <= MAXEXTLEN)
+	    LEFT.br_blockcount + new->br_blockcount <= XFS_MAX_EXTLEN)
 		state |= BMAP_LEFT_CONTIG;
 
 	/*
@@ -2078,13 +2078,13 @@ xfs_bmap_add_extent_unwritten_real(
 	    new_endoff == RIGHT.br_startoff &&
 	    new->br_startblock + new->br_blockcount == RIGHT.br_startblock &&
 	    new->br_state == RIGHT.br_state &&
-	    new->br_blockcount + RIGHT.br_blockcount <= MAXEXTLEN &&
+	    new->br_blockcount + RIGHT.br_blockcount <= XFS_MAX_EXTLEN &&
 	    ((state & (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
 		       BMAP_RIGHT_FILLING)) !=
 		      (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
 		       BMAP_RIGHT_FILLING) ||
 	     LEFT.br_blockcount + new->br_blockcount + RIGHT.br_blockcount
-			<= MAXEXTLEN))
+			<= XFS_MAX_EXTLEN))
 		state |= BMAP_RIGHT_CONTIG;
 
 	/*
@@ -2593,15 +2593,15 @@ xfs_bmap_add_extent_hole_delay(
 	 */
 	if ((state & BMAP_LEFT_VALID) && (state & BMAP_LEFT_DELAY) &&
 	    left.br_startoff + left.br_blockcount == new->br_startoff &&
-	    left.br_blockcount + new->br_blockcount <= MAXEXTLEN)
+	    left.br_blockcount + new->br_blockcount <= XFS_MAX_EXTLEN)
 		state |= BMAP_LEFT_CONTIG;
 
 	if ((state & BMAP_RIGHT_VALID) && (state & BMAP_RIGHT_DELAY) &&
 	    new->br_startoff + new->br_blockcount == right.br_startoff &&
-	    new->br_blockcount + right.br_blockcount <= MAXEXTLEN &&
+	    new->br_blockcount + right.br_blockcount <= XFS_MAX_EXTLEN &&
 	    (!(state & BMAP_LEFT_CONTIG) ||
 	     (left.br_blockcount + new->br_blockcount +
-	      right.br_blockcount <= MAXEXTLEN)))
+	      right.br_blockcount <= XFS_MAX_EXTLEN)))
 		state |= BMAP_RIGHT_CONTIG;
 
 	/*
@@ -2744,17 +2744,17 @@ xfs_bmap_add_extent_hole_real(
 	    left.br_startoff + left.br_blockcount == new->br_startoff &&
 	    left.br_startblock + left.br_blockcount == new->br_startblock &&
 	    left.br_state == new->br_state &&
-	    left.br_blockcount + new->br_blockcount <= MAXEXTLEN)
+	    left.br_blockcount + new->br_blockcount <= XFS_MAX_EXTLEN)
 		state |= BMAP_LEFT_CONTIG;
 
 	if ((state & BMAP_RIGHT_VALID) && !(state & BMAP_RIGHT_DELAY) &&
 	    new->br_startoff + new->br_blockcount == right.br_startoff &&
 	    new->br_startblock + new->br_blockcount == right.br_startblock &&
 	    new->br_state == right.br_state &&
-	    new->br_blockcount + right.br_blockcount <= MAXEXTLEN &&
+	    new->br_blockcount + right.br_blockcount <= XFS_MAX_EXTLEN &&
 	    (!(state & BMAP_LEFT_CONTIG) ||
 	     left.br_blockcount + new->br_blockcount +
-	     right.br_blockcount <= MAXEXTLEN))
+	     right.br_blockcount <= XFS_MAX_EXTLEN))
 		state |= BMAP_RIGHT_CONTIG;
 
 	error = 0;
@@ -2996,15 +2996,15 @@ xfs_bmap_extsize_align(
 
 	/*
 	 * For large extent hint sizes, the aligned extent might be larger than
-	 * MAXEXTLEN. In that case, reduce the size by an extsz so that it pulls
-	 * the length back under MAXEXTLEN. The outer allocation loops handle
+	 * XFS_MAX_EXTLEN. In that case, reduce the size by an extsz so that it pulls
+	 * the length back under XFS_MAX_EXTLEN. The outer allocation loops handle
 	 * short allocation just fine, so it is safe to do this. We only want to
 	 * do it when we are forced to, though, because it means more allocation
 	 * operations are required.
 	 */
-	while (align_alen > MAXEXTLEN)
+	while (align_alen > XFS_MAX_EXTLEN)
 		align_alen -= extsz;
-	ASSERT(align_alen <= MAXEXTLEN);
+	ASSERT(align_alen <= XFS_MAX_EXTLEN);
 
 	/*
 	 * If the previous block overlaps with this proposed allocation
@@ -3094,9 +3094,9 @@ xfs_bmap_extsize_align(
 			return -EINVAL;
 	} else {
 		ASSERT(orig_off >= align_off);
-		/* see MAXEXTLEN handling above */
+		/* see XFS_MAX_EXTLEN handling above */
 		ASSERT(orig_end <= align_off + align_alen ||
-		       align_alen + extsz > MAXEXTLEN);
+		       align_alen + extsz > XFS_MAX_EXTLEN);
 	}
 
 #ifdef DEBUG
@@ -4063,7 +4063,7 @@ xfs_bmapi_reserve_delalloc(
 	 * Cap the alloc length. Keep track of prealloc so we know whether to
 	 * tag the inode before we return.
 	 */
-	alen = XFS_FILBLKS_MIN(len + prealloc, MAXEXTLEN);
+	alen = XFS_FILBLKS_MIN(len + prealloc, XFS_MAX_EXTLEN);
 	if (!eof)
 		alen = XFS_FILBLKS_MIN(alen, got->br_startoff - aoff);
 	if (prealloc && alen >= len)
@@ -4196,7 +4196,7 @@ xfs_bmapi_allocate(
 		if (!xfs_iext_peek_prev_extent(ifp, &bma->icur, &bma->prev))
 			bma->prev.br_startoff = NULLFILEOFF;
 	} else {
-		bma->length = XFS_FILBLKS_MIN(bma->length, MAXEXTLEN);
+		bma->length = XFS_FILBLKS_MIN(bma->length, XFS_MAX_EXTLEN);
 		if (!bma->eof)
 			bma->length = XFS_FILBLKS_MIN(bma->length,
 					bma->got.br_startoff - bma->offset);
@@ -4517,8 +4517,8 @@ xfs_bmapi_write(
 			 * xfs_extlen_t and therefore 32 bits. Hence we have to
 			 * check for 32-bit overflows and handle them here.
 			 */
-			if (len > (xfs_filblks_t)MAXEXTLEN)
-				bma.length = MAXEXTLEN;
+			if (len > (xfs_filblks_t)XFS_MAX_EXTLEN)
+				bma.length = XFS_MAX_EXTLEN;
 			else
 				bma.length = len;
 
@@ -4653,7 +4653,8 @@ xfs_bmapi_convert_delalloc(
 	bma.ip = ip;
 	bma.wasdel = true;
 	bma.offset = bma.got.br_startoff;
-	bma.length = max_t(xfs_filblks_t, bma.got.br_blockcount, MAXEXTLEN);
+	bma.length = max_t(xfs_filblks_t, bma.got.br_blockcount,
+			XFS_MAX_EXTLEN);
 	bma.minleft = xfs_bmapi_minleft(tp, ip, whichfork);
 
 	/*
@@ -4736,7 +4737,7 @@ xfs_bmapi_remap(
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	ASSERT(len > 0);
-	ASSERT(len <= (xfs_filblks_t)MAXEXTLEN);
+	ASSERT(len <= (xfs_filblks_t)XFS_MAX_EXTLEN);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK | XFS_BMAPI_PREALLOC |
 			   XFS_BMAPI_NORMAP)));
@@ -5709,7 +5710,7 @@ xfs_bmse_can_merge(
 	if ((left->br_startoff + left->br_blockcount != startoff) ||
 	    (left->br_startblock + left->br_blockcount != got->br_startblock) ||
 	    (left->br_state != got->br_state) ||
-	    (left->br_blockcount + got->br_blockcount > MAXEXTLEN))
+	    (left->br_blockcount + got->br_blockcount > XFS_MAX_EXTLEN))
 		return false;
 
 	return true;
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index a97abc4a..c9af8c04 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -884,17 +884,6 @@ enum xfs_dinode_fmt {
 	{ XFS_DINODE_FMT_BTREE,		"btree" }, \
 	{ XFS_DINODE_FMT_UUID,		"uuid" }
 
-/*
- * Max values for extlen, disk inode's extent counters.
- */
-
-#define	MAXEXTLEN		((xfs_extlen_t)0x1fffff) /* 21 bits */
-#define XFS_IFORK_EXTCNT_MAXU48 ((xfs_extnum_t)0xffffffffffff) /* Unsigned 48-bits */
-#define XFS_IFORK_EXTCNT_MAXU32 ((xfs_aextnum_t)0xffffffff) /* Unsigned 32-bits */
-#define XFS_IFORK_EXTCNT_MAXS32 ((xfs_extnum_t)0x7fffffff) /* Signed 32-bits */
-#define XFS_IFORK_EXTCNT_MAXS16 ((xfs_aextnum_t)0x7fff) /* Signed 16-bits */
-
-
 /*
  * Inode minimum and maximum sizes.
  */
@@ -1700,6 +1689,15 @@ typedef struct xfs_bmbt_rec {
 typedef uint64_t	xfs_bmbt_rec_base_t;	/* use this for casts */
 typedef xfs_bmbt_rec_t xfs_bmdr_rec_t;
 
+/*
+ * Max values for extlen, disk inode's extent counters.
+ */
+#define XFS_MAX_EXTLEN		((xfs_extlen_t)(1 << BMBT_BLOCKCOUNT_BITLEN) - 1)
+#define XFS_IFORK_EXTCNT_MAXU48 ((xfs_extnum_t)0xffffffffffff) /* Unsigned 48-bits */
+#define XFS_IFORK_EXTCNT_MAXU32 ((xfs_aextnum_t)0xffffffff) /* Unsigned 32-bits */
+#define XFS_IFORK_EXTCNT_MAXS32 ((xfs_extnum_t)0x7fffffff) /* Signed 32-bits */
+#define XFS_IFORK_EXTCNT_MAXS16 ((xfs_aextnum_t)0x7fff) /* Signed 16-bits */
+
 /*
  * Values and macros for delayed-allocation startblock fields.
  */
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 15690f7f..77288b82 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -744,7 +744,7 @@ xfs_inode_validate_extsize(
 	if (extsize_bytes % blocksize_bytes)
 		return __this_address;
 
-	if (extsize > MAXEXTLEN)
+	if (extsize > XFS_MAX_EXTLEN)
 		return __this_address;
 
 	if (!rt_flag && extsize > mp->m_sb.sb_agblocks / 2)
@@ -801,7 +801,7 @@ xfs_inode_validate_cowextsize(
 	if (cowextsize_bytes % mp->m_sb.sb_blocksize)
 		return __this_address;
 
-	if (cowextsize > MAXEXTLEN)
+	if (cowextsize > XFS_MAX_EXTLEN)
 		return __this_address;
 
 	if (cowextsize > mp->m_sb.sb_agblocks / 2)
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index a8a71adc..c87c9d0b 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -1013,7 +1013,7 @@ xfs_rtfree_extent(
 /*
  * Free some blocks in the realtime subvolume.  rtbno and rtlen are in units of
  * rt blocks, not rt extents; must be aligned to the rt extent size; and rtlen
- * cannot exceed MAXEXTLEN.
+ * cannot exceed XFS_MAX_EXTLEN.
  */
 int
 xfs_rtfree_blocks(
@@ -1026,7 +1026,7 @@ xfs_rtfree_blocks(
 	xfs_filblks_t		len;
 	xfs_extlen_t		mod;
 
-	ASSERT(rtlen <= MAXEXTLEN);
+	ASSERT(rtlen <= XFS_MAX_EXTLEN);
 
 	len = div_u64_rem(rtlen, mp->m_sb.sb_rextsize, &mod);
 	if (mod) {
diff --git a/libxfs/xfs_swapext.c b/libxfs/xfs_swapext.c
index 2fb0ac76..f8facf1d 100644
--- a/libxfs/xfs_swapext.c
+++ b/libxfs/xfs_swapext.c
@@ -755,7 +755,7 @@ can_merge(
 	if (b1->br_startoff   + b1->br_blockcount == b2->br_startoff &&
 	    b1->br_startblock + b1->br_blockcount == b2->br_startblock &&
 	    b1->br_state			  == b2->br_state &&
-	    b1->br_blockcount + b2->br_blockcount <= MAXEXTLEN)
+	    b1->br_blockcount + b2->br_blockcount <= XFS_MAX_EXTLEN)
 		return true;
 
 	return false;
@@ -797,7 +797,7 @@ delta_nextents_step(
 		state |= CRIGHT_CONTIG;
 	if ((state & CBOTH_CONTIG) == CBOTH_CONTIG &&
 	    left->br_startblock + curr->br_startblock +
-					right->br_startblock > MAXEXTLEN)
+					right->br_startblock > XFS_MAX_EXTLEN)
 		state &= ~CRIGHT_CONTIG;
 
 	if (nhole)
@@ -808,7 +808,7 @@ delta_nextents_step(
 		state |= NRIGHT_CONTIG;
 	if ((state & NBOTH_CONTIG) == NBOTH_CONTIG &&
 	    left->br_startblock + new->br_startblock +
-					right->br_startblock > MAXEXTLEN)
+					right->br_startblock > XFS_MAX_EXTLEN)
 		state &= ~NRIGHT_CONTIG;
 
 	switch (state & (CLEFT_CONTIG | CRIGHT_CONTIG | CHOLE)) {
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index f153e021..6566012d 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -208,8 +208,8 @@ xfs_calc_inode_chunk_res(
 /*
  * Per-extent log reservation for the btree changes involved in freeing or
  * allocating a realtime extent.  We have to be able to log as many rtbitmap
- * blocks as needed to mark inuse MAXEXTLEN blocks' worth of realtime extents,
- * as well as the realtime summary block.
+ * blocks as needed to mark inuse XFS_MAX_EXTLEN blocks' worth of realtime
+ * extents, as well as the realtime summary block.
  */
 static unsigned int
 xfs_rtalloc_log_count(
@@ -219,7 +219,7 @@ xfs_rtalloc_log_count(
 	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
 	unsigned int		rtbmp_bytes;
 
-	rtbmp_bytes = (MAXEXTLEN / mp->m_sb.sb_rextsize) / NBBY;
+	rtbmp_bytes = (XFS_MAX_EXTLEN / mp->m_sb.sb_rextsize) / NBBY;
 	return (howmany(rtbmp_bytes, blksz) + 1) * num_ops;
 }
 
@@ -278,7 +278,7 @@ xfs_refcount_log_reservation(
  *    the inode's bmap btree: max depth * block size
  *    the agfs of the ags from which the extents are allocated: 2 * sector
  *    the superblock free block counter: sector size
- *    the realtime bitmap: ((MAXEXTLEN / rtextsize) / NBBY) bytes
+ *    the realtime bitmap: ((XFS_MAX_EXTLEN / rtextsize) / NBBY) bytes
  *    the realtime summary: 1 block
  *    the allocation btrees: 2 trees * (2 * max depth - 1) * block size
  * And the bmap_finish transaction can free bmap blocks in a join (t3):
@@ -333,7 +333,7 @@ xfs_calc_write_reservation(
  *    the agf for each of the ags: 2 * sector size
  *    the agfl for each of the ags: 2 * sector size
  *    the super block to reflect the freed blocks: sector size
- *    the realtime bitmap: 2 exts * ((MAXEXTLEN / rtextsize) / NBBY) bytes
+ *    the realtime bitmap: 2 exts * ((XFS_MAX_EXTLEN / rtextsize) / NBBY) bytes
  *    the realtime summary: 2 exts * 1 block
  *    worst case split in allocation btrees per extent assuming 2 extents:
  *		2 exts * 2 trees * (2 * max depth - 1) * block size
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 37c22277..49a450e0 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2427,7 +2427,7 @@ validate_extsize_hint(
 		fprintf(stderr,
 _("illegal extent size hint %lld, must be less than %u.\n"),
 				(long long)cli->fsx.fsx_extsize,
-				min(MAXEXTLEN, mp->m_sb.sb_agblocks / 2));
+				min(XFS_MAX_EXTLEN, mp->m_sb.sb_agblocks / 2));
 		usage();
 	}
 
@@ -2450,7 +2450,7 @@ _("illegal extent size hint %lld, must be less than %u.\n"),
 		fprintf(stderr,
 _("illegal extent size hint %lld, must be less than %u and a multiple of %u.\n"),
 				(long long)cli->fsx.fsx_extsize,
-				min(MAXEXTLEN, mp->m_sb.sb_agblocks / 2),
+				min(XFS_MAX_EXTLEN, mp->m_sb.sb_agblocks / 2),
 				mp->m_sb.sb_rextsize);
 		usage();
 	}
@@ -2479,7 +2479,7 @@ validate_cowextsize_hint(
 		fprintf(stderr,
 _("illegal CoW extent size hint %lld, must be less than %u.\n"),
 				(long long)cli->fsx.fsx_cowextsize,
-				min(MAXEXTLEN, mp->m_sb.sb_agblocks / 2));
+				min(XFS_MAX_EXTLEN, mp->m_sb.sb_agblocks / 2));
 		usage();
 	}
 }
diff --git a/repair/bmap_repair.c b/repair/bmap_repair.c
index 7d3bb330..811b16dc 100644
--- a/repair/bmap_repair.c
+++ b/repair/bmap_repair.c
@@ -64,7 +64,7 @@ xrep_bmap_from_rmap(
 
 	do {
 		irec.br_blockcount = min_t(xfs_filblks_t, blockcount,
-				MAXEXTLEN);
+				XFS_MAX_EXTLEN);
 		libxfs_bmbt_disk_set_all(&rbe, &irec);
 
 		error = slab_add(rb->bmap_records, &rbe);
diff --git a/repair/phase4.c b/repair/phase4.c
index b752b07c..880cd313 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -393,7 +393,7 @@ phase4(xfs_mount_t *mp)
 			if (rt_start == 0)  {
 				rt_start = bno;
 				rt_len = 1;
-			} else if (rt_len == MAXEXTLEN)  {
+			} else if (rt_len == XFS_MAX_EXTLEN)  {
 				/*
 				 * large extent case
 				 */
-- 
2.30.2

