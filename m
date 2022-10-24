Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82CBCC3A59D
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 04:56:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbiJXE4A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 00:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbiJXEz7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 00:55:59 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91776760C6
        for <linux-xfs@vger.kernel.org>; Sun, 23 Oct 2022 21:55:57 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29NMURlQ014578;
        Mon, 24 Oct 2022 04:55:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=9cUZ+dG1uPi+wv5BYRo8b3jvIJzb9GCk1ACQOzey3Po=;
 b=Sue3OuNVgClbCWNpNZ4cvTDw8hlx0Qdh+WGgSuGFRdeLQM3cBiovBp8+KCohY3m7jURP
 g4dlm/2UOrrM00RekDkv2E5H5UzJAkHmnQSudxvTBnxFbOi/ErhbtZCdSFZJ4JHs/8Ea
 wxULmDKUR3Y5rjDJw5SM5r22tNwXlyVydMC5+P3FmOHnbKVp8vpeDwcrdKDxgnjFnYMQ
 a5DmYPmcoUUa8IBllX6n3ztQLdafB14/RLCtHA/yzcHbgeqFXKSkXvmywm3dSK4iH+2g
 6KIqcIvklKt/Hm+/4t6Y1J9zAO/2HDCptpb7j5a8TWW454jZNAWm6lxhG4xjCq5+8D6l nA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc7a2tnrq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:55:53 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29O0lN6F015489;
        Mon, 24 Oct 2022 04:55:52 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y3370n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:55:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J1V1fIRSOINarZgiCWi9m2fm216UjbqG2JDtVd+rGUM5obFqb8+fcuvpjlJKWnWHRFrDb3u6F1wm1ItOLW+kdcEpJmma9SMNATE7xbmtQXtrpRYezAijsFPq3OmjcAEP32W4UwI2sriKsKZoCaly7eOp+eDT6qIKgoco+CP1ahngsuKXO4SG9S11NLaXqB/lY7mwKVA+vSAsjg5/16nNEoupCBu41GyYh/7DkVqn9pG8wdw49qbqiJUbs3CdHMMknT7hx8rHIwV0C9U4oWY45G+WmWeeteEbbcEbUKxYtgYSm95OZT0o+MJ+Y6Oz4VVzIIpip/2GbcaWQ7XZ+v1ARA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9cUZ+dG1uPi+wv5BYRo8b3jvIJzb9GCk1ACQOzey3Po=;
 b=EXe0JikDV8sCol+yZYcNKTbhdZ7xNVFwlrPDynIS8ypm3aD3p0tIkrmAAjhXL0mF4uSywNHHreCgsMryx/BgilVFNdy/kskH0Ymu7YkXdw2PwqntVfvXHJYsswjhnfTVZEijUq9/s7YudCvBkdEspBW+rrTNdxDNHyklMyTl4lF15KHMPVwCK01myOLIibZkkbly1RNfYr9POqZfJdkzsH93tRkhW1833QyD/hB1yYXhJ0aH/DdGRwphr1tRiXh1wYW+ZdCc+ywWbLGciLZhiIcBrJ9FRNMubcMySyunrsSvyB7vfBFl5yjh+TC8IRSuDC+AA7zILcKCtv2Al1Ivnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9cUZ+dG1uPi+wv5BYRo8b3jvIJzb9GCk1ACQOzey3Po=;
 b=iQcciUtdvQsdQ/nhSncfUsbJ4idDlHBbieMB3fhRK5ct4MCVrQteNUEhpUv3KNfPA2lc/IR9VRMvYc0quUm2iIRB4XLW86wyY1ny2Z1yGTCyGmpvolTCEGSkY6dczu7ks6sZKC6FMDfnoeXiV6rlJuGQvqAC8mIhSzM0QhKhupQ=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CH0PR10MB4906.namprd10.prod.outlook.com (2603:10b6:610:c6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Mon, 24 Oct
 2022 04:55:50 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Mon, 24 Oct 2022
 04:55:50 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 20/26] xfs: tail updates only need to occur when LSN changes
Date:   Mon, 24 Oct 2022 10:23:08 +0530
Message-Id: <20221024045314.110453-21-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221024045314.110453-1-chandan.babu@oracle.com>
References: <20221024045314.110453-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR06CA0001.apcprd06.prod.outlook.com
 (2603:1096:4:186::21) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CH0PR10MB4906:EE_
X-MS-Office365-Filtering-Correlation-Id: 83c9e9c9-c797-440a-a2d1-08dab57c0586
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HBN7an89MG2S9/NryJIHX16HdUx+Td0RCQc7PXPLV2nhuvBj2l82UOvirRrguyVCoKgTni3IPktRyfeTawyrwSp/mvk0zGv+TFI0Pn5c3q5V87sAev3tkTr9KkTpc1PhviC/Tc1Q2UOba+m8eVZ6T6+5iytD58KSnvej+jHY22LZ9Icq4qTvcOwoCZAPapl+pr7N41TgG8QhpNuKdb/PFRzQ4GXAKbrABLVdqlEkNHhN2cSGwFyW4orcWy+VDm8tJodj1hFYSR9GlARYMzvFJKr3K2+kC2UZqlu+0VqeLJBry8byxVjuRe95oDKf75HynY+qaUKk+emvrxdBgh8q1EUSTaIAs6b1GlgvX2LNdDaY6XcrM2TKdL6VkkYEVRJxGvDOvWajvLztsp0CC0p7QVI0NhTCDGTDa9+V1iPOJtcxGvq5Z+NueSaIF+2eswS2kMmg32LtXdqlOscex0wyxG7M3rq2j15K9AFwoKceolykdoPMupEaXS1NiQ6z/TuseFVoZtsjk77m/H+8rU84pil3kJ7urlP5H+eZKsMHfadTg83ZotdH18fyhJGrsZ/IORWl//ytiI7ig1hqHspG6AY/SJxTZgWDtsH4o80E2FmNNT+8+PuT2739PdSRPGTe6Rb1O0xktBLLtwG74tE1Z4fNJtOERRmfWzlFDRnyWusVoNhaynA/xfRK0aH1MkukntDuCPAgler7EDNKjdmQNw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(376002)(366004)(451199015)(2616005)(1076003)(66556008)(66946007)(66476007)(5660300002)(6506007)(186003)(6666004)(83380400001)(36756003)(6486002)(4326008)(478600001)(8676002)(38100700002)(86362001)(41300700001)(8936002)(6916009)(2906002)(15650500001)(26005)(6512007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CRswUm34bvzgEe84Xa//1CNgRfhPS0O1VuFR/+2o7dH8eVqZ2qdiu06jt9q7?=
 =?us-ascii?Q?1hK5ZHxZp73Du2pgTHLy+oNMZr1IFtJ0Jio4zj1U+xmj/jcU4sOt/aTDZQf7?=
 =?us-ascii?Q?NSVMCkBItp0J8Q59vSW4eK4IzxW9Jt8Q63JQx2YuhM3aF5g+OdGl8rYA4+0i?=
 =?us-ascii?Q?110a8So7oD0TwoIQCKhqB5oNoE1uHi0nygsp0+AebiEGbEvEbdaaXzkr3JbU?=
 =?us-ascii?Q?E0DiZBPjb1VNFUxVOJVFznSUAgdDXEPbHtxawQ7tjs6pIvGjSO4SftDyXYHk?=
 =?us-ascii?Q?FBkju9Xk8NXeFTmQPGmo4qWNJd3clT8vcihzXku1wtQHo21tFCfvXly+GrfD?=
 =?us-ascii?Q?mmdbZV7ICc4psioMG862e8Ay8N4qb2qe6VIkpk2yze25VXsiLm8EmOzE2n8W?=
 =?us-ascii?Q?JyA9ykJ1uMDDAkPo74tXbvEyIL9uc1sk8yofUrIzBDcAN8XI4+Jknq2M20Nz?=
 =?us-ascii?Q?1xP5a0vIILA7w6FbRlK1LTlZRf5wp6sChqZmykYWlNsBmZXB8rxhQB2b4muC?=
 =?us-ascii?Q?U6lSaSqB1oUWNT+y/BC4RIr4eZ7ssi/6uJaGIHb0IANOwqDpYiiSNwFI2bYx?=
 =?us-ascii?Q?6Rsn07tLJkPLmpDbYH54wCdP3sWRCIjkDciv/5zdgqOB0JeVjYEIs1/e2Tvw?=
 =?us-ascii?Q?QrDw6NLAISiN1AGNuQc3ribtEC83/uC6muzenKo/iVKNOiaHFkgnA7/ze7Ue?=
 =?us-ascii?Q?lzwXv0McRJ+xfjayN0mp6Rr2Cbz6OgNbTJRJ/6a5JBAkaldCRvVtQ1++87QT?=
 =?us-ascii?Q?2RiXbFUFguwwkPnXPeyIdvoctWBerOjVspbLaVonnypnRJrOuWMYnxcwNCBI?=
 =?us-ascii?Q?J3U4gqO7ZE/wOhyQlstxzaTN9XS9oQ0pmhVYPiPD940g8VflnMzaKQtTI0pr?=
 =?us-ascii?Q?nN543PQr2tJOJAfq9z06eQt+iX4YEqsNgsnvTK2/LYWFJMxQp9+sh37jt2/9?=
 =?us-ascii?Q?S7YbHOWb9+4f6sATEb/S7OB68dwkNsh8FqMzkdYS0pZg980yxtlx7VZIcyQN?=
 =?us-ascii?Q?TjLuDiR5mXFsR9/11nAFXNMJndk8F11c5bZrMp8zxYm3fc5qH/V+Thx9vsT2?=
 =?us-ascii?Q?NINfZYq2nsx1nIartT63SiDUlgbPXHhBgbq4zqdiuLwaZblzw7uW3qpS/ho9?=
 =?us-ascii?Q?BrDHfnns8DfHlxt/y2BYucTXsINidZlEg5v8RRrpDIwQ8TGWiCNMm6z+gfrQ?=
 =?us-ascii?Q?mjVmNpc/DHhKJw0YpZ9Ur4bZKgR1+jReMGtH7cZ69p6mCzj/tB6i32BbiK9I?=
 =?us-ascii?Q?C/ZmvM2nRdN1+qID/MgrWaK+kuXqdHlI4aD0j23xHK2beYnC/OyDDoYoIgPm?=
 =?us-ascii?Q?qKv1zh0NJDpw3QqTzpMO3aq1rJiGaWXvmxdmQXz8CYaeGTtBWgT3Xp1QRu2u?=
 =?us-ascii?Q?ofSpLNzEzHVSRFowu+D9JzrBM5QFXnCtT3370BABCkhWkri1bz5VS5vQaBIN?=
 =?us-ascii?Q?p9KEdodiSYOtu2HVXR6otHG8QcftwFAZgyhn5JDdWbecdsv8J4CuK29HVaYh?=
 =?us-ascii?Q?yZE3Qlho3KGVL62Qiq5M4FcBMs5tGU7VIvmhWNEYcm3J4YrBCi3Lt1+XD+Ue?=
 =?us-ascii?Q?TR0XTmgHan7/wyFgKVhmzEpyQk58CTf77XcYy35I3o/ozD0d9B+VOh0J9kug?=
 =?us-ascii?Q?Gw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83c9e9c9-c797-440a-a2d1-08dab57c0586
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 04:55:50.2596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /MNFy5eH5t6cGbsSStyFKaIA4RSb2DbI4KPIslILuU16dMc/NoK/KkO15E1Fh+GyHBbnZ4lr3N/D9Db6PN5PqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4906
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-23_02,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210240031
X-Proofpoint-GUID: UigkQhCVwAb9M_RBzRShvV7PI_fCt4_5
X-Proofpoint-ORIG-GUID: UigkQhCVwAb9M_RBzRShvV7PI_fCt4_5
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit 8eb807bd839938b45bf7a97f0568d2a845ba6929 upstream.

We currently wake anything waiting on the log tail to move whenever
the log item at the tail of the log is removed. Historically this
was fine behaviour because there were very few items at any given
LSN. But with delayed logging, there may be thousands of items at
any given LSN, and we can't move the tail until they are all gone.

Hence if we are removing them in near tail-first order, we might be
waking up processes waiting on the tail LSN to change (e.g. log
space waiters) repeatedly without them being able to make progress.
This also occurs with the new sync push waiters, and can result in
thousands of spurious wakeups every second when under heavy direct
reclaim pressure.

To fix this, check that the tail LSN has actually changed on the
AIL before triggering wakeups. This will reduce the number of
spurious wakeups when doing bulk AIL removal and make this code much
more efficient.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_inode_item.c | 18 ++++++++++----
 fs/xfs/xfs_trans_ail.c  | 52 ++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_trans_priv.h |  4 ++--
 3 files changed, 51 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index a3243a9fa77c..76a60526af94 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -732,19 +732,27 @@ xfs_iflush_done(
 	 * holding the lock before removing the inode from the AIL.
 	 */
 	if (need_ail) {
-		bool			mlip_changed = false;
+		xfs_lsn_t	tail_lsn = 0;
 
 		/* this is an opencoded batch version of xfs_trans_ail_delete */
 		spin_lock(&ailp->ail_lock);
 		list_for_each_entry(blip, &tmp, li_bio_list) {
 			if (INODE_ITEM(blip)->ili_logged &&
-			    blip->li_lsn == INODE_ITEM(blip)->ili_flush_lsn)
-				mlip_changed |= xfs_ail_delete_one(ailp, blip);
-			else {
+			    blip->li_lsn == INODE_ITEM(blip)->ili_flush_lsn) {
+				/*
+				 * xfs_ail_update_finish() only cares about the
+				 * lsn of the first tail item removed, any
+				 * others will be at the same or higher lsn so
+				 * we just ignore them.
+				 */
+				xfs_lsn_t lsn = xfs_ail_delete_one(ailp, blip);
+				if (!tail_lsn && lsn)
+					tail_lsn = lsn;
+			} else {
 				xfs_clear_li_failed(blip);
 			}
 		}
-		xfs_ail_update_finish(ailp, mlip_changed);
+		xfs_ail_update_finish(ailp, tail_lsn);
 	}
 
 	/*
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index effcd0d079b6..af782a7de21a 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -108,17 +108,25 @@ xfs_ail_next(
  * We need the AIL lock in order to get a coherent read of the lsn of the last
  * item in the AIL.
  */
+static xfs_lsn_t
+__xfs_ail_min_lsn(
+	struct xfs_ail		*ailp)
+{
+	struct xfs_log_item	*lip = xfs_ail_min(ailp);
+
+	if (lip)
+		return lip->li_lsn;
+	return 0;
+}
+
 xfs_lsn_t
 xfs_ail_min_lsn(
 	struct xfs_ail		*ailp)
 {
-	xfs_lsn_t		lsn = 0;
-	struct xfs_log_item	*lip;
+	xfs_lsn_t		lsn;
 
 	spin_lock(&ailp->ail_lock);
-	lip = xfs_ail_min(ailp);
-	if (lip)
-		lsn = lip->li_lsn;
+	lsn = __xfs_ail_min_lsn(ailp);
 	spin_unlock(&ailp->ail_lock);
 
 	return lsn;
@@ -683,11 +691,12 @@ xfs_ail_push_all_sync(
 void
 xfs_ail_update_finish(
 	struct xfs_ail		*ailp,
-	bool			do_tail_update) __releases(ailp->ail_lock)
+	xfs_lsn_t		old_lsn) __releases(ailp->ail_lock)
 {
 	struct xfs_mount	*mp = ailp->ail_mount;
 
-	if (!do_tail_update) {
+	/* if the tail lsn hasn't changed, don't do updates or wakeups. */
+	if (!old_lsn || old_lsn == __xfs_ail_min_lsn(ailp)) {
 		spin_unlock(&ailp->ail_lock);
 		return;
 	}
@@ -732,7 +741,7 @@ xfs_trans_ail_update_bulk(
 	xfs_lsn_t		lsn) __releases(ailp->ail_lock)
 {
 	struct xfs_log_item	*mlip;
-	int			mlip_changed = 0;
+	xfs_lsn_t		tail_lsn = 0;
 	int			i;
 	LIST_HEAD(tmp);
 
@@ -747,9 +756,10 @@ xfs_trans_ail_update_bulk(
 				continue;
 
 			trace_xfs_ail_move(lip, lip->li_lsn, lsn);
+			if (mlip == lip && !tail_lsn)
+				tail_lsn = lip->li_lsn;
+
 			xfs_ail_delete(ailp, lip);
-			if (mlip == lip)
-				mlip_changed = 1;
 		} else {
 			trace_xfs_ail_insert(lip, 0, lsn);
 		}
@@ -760,15 +770,23 @@ xfs_trans_ail_update_bulk(
 	if (!list_empty(&tmp))
 		xfs_ail_splice(ailp, cur, &tmp, lsn);
 
-	xfs_ail_update_finish(ailp, mlip_changed);
+	xfs_ail_update_finish(ailp, tail_lsn);
 }
 
-bool
+/*
+ * Delete one log item from the AIL.
+ *
+ * If this item was at the tail of the AIL, return the LSN of the log item so
+ * that we can use it to check if the LSN of the tail of the log has moved
+ * when finishing up the AIL delete process in xfs_ail_update_finish().
+ */
+xfs_lsn_t
 xfs_ail_delete_one(
 	struct xfs_ail		*ailp,
 	struct xfs_log_item	*lip)
 {
 	struct xfs_log_item	*mlip = xfs_ail_min(ailp);
+	xfs_lsn_t		lsn = lip->li_lsn;
 
 	trace_xfs_ail_delete(lip, mlip->li_lsn, lip->li_lsn);
 	xfs_ail_delete(ailp, lip);
@@ -776,7 +794,9 @@ xfs_ail_delete_one(
 	clear_bit(XFS_LI_IN_AIL, &lip->li_flags);
 	lip->li_lsn = 0;
 
-	return mlip == lip;
+	if (mlip == lip)
+		return lsn;
+	return 0;
 }
 
 /**
@@ -807,7 +827,7 @@ xfs_trans_ail_delete(
 	int			shutdown_type)
 {
 	struct xfs_mount	*mp = ailp->ail_mount;
-	bool			need_update;
+	xfs_lsn_t		tail_lsn;
 
 	if (!test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
 		spin_unlock(&ailp->ail_lock);
@@ -820,8 +840,8 @@ xfs_trans_ail_delete(
 		return;
 	}
 
-	need_update = xfs_ail_delete_one(ailp, lip);
-	xfs_ail_update_finish(ailp, need_update);
+	tail_lsn = xfs_ail_delete_one(ailp, lip);
+	xfs_ail_update_finish(ailp, tail_lsn);
 }
 
 int
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 64ffa746730e..35655eac01a6 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -91,8 +91,8 @@ xfs_trans_ail_update(
 	xfs_trans_ail_update_bulk(ailp, NULL, &lip, 1, lsn);
 }
 
-bool xfs_ail_delete_one(struct xfs_ail *ailp, struct xfs_log_item *lip);
-void xfs_ail_update_finish(struct xfs_ail *ailp, bool do_tail_update)
+xfs_lsn_t xfs_ail_delete_one(struct xfs_ail *ailp, struct xfs_log_item *lip);
+void xfs_ail_update_finish(struct xfs_ail *ailp, xfs_lsn_t old_lsn)
 			__releases(ailp->ail_lock);
 void xfs_trans_ail_delete(struct xfs_ail *ailp, struct xfs_log_item *lip,
 		int shutdown_type);
-- 
2.35.1

