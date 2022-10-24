Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A968AC3A59D
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 04:53:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbiJXExn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 00:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbiJXExl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 00:53:41 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F7279A5D
        for <linux-xfs@vger.kernel.org>; Sun, 23 Oct 2022 21:53:40 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29O2UPTv019443;
        Mon, 24 Oct 2022 04:53:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=4nIN4GNyNyMN4ox3VjhjWmN8YNkDlUkjC+H1Krqzvmw=;
 b=BR5S/9zmLu6BlFAdf2NJ/3jEZJGagFjFXFHZ7BwAGnZEKFUM0G5HNwr3eMyusIQu8Wl4
 ov6cBxNBq0fFjfWCnJWtEppIMVWZZUWREKBuDStYzWh2+aLJiT4flodvUlw8dRr0loqE
 iEyrv4Fd32Ho4VtE3bgpW6ShR3OUgY23ljAVIDsUjB84sAT9OaqQfSZCfjHL6Oc7wWmU
 uYLEpic8a/N6kNofQm+KYpHOkW4a+shq3WZbMlRAK2uzsrp3vtSmsGLJQNqD9VuS5QDw
 azHpTK09diG93EiKVyGTx091gIRaVlv0fSqqwEf/xSbYnutjGTX3ByrJDxfPod2c1fEW Mw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc9392y0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:53:31 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29NN3l8r000972;
        Mon, 24 Oct 2022 04:53:29 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y944k9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:53:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EkqpH7wp7L5eIpYHmvbOLQmic5325Bx8y8/APVjenffvcJK9mI9Ul4USpczw6mD8Jb19zHVpu/laTt05rYL99yyo6dBAr1RNAW23/AwMgPNHzcNcpYalFLia7Y+oletCjyWx/h1voWvpC+phcNU3cz00Q89dZBFnfnZeophOFyBTHxsJ8EGfmWVWCYIbfJVvDyumLUsIQJCpMHqiNilh897SjtkuNsVJQalfaSXWgRx4EeVvPOO2qXt9tigWOCU0sOJPyS1hXxG9PJhu3rOnbbA3eGavEGamchBwyNih48jvQytdxu8LTa/O3g0W+hnuK+w+MGOvnbRwNeqQAG1w5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4nIN4GNyNyMN4ox3VjhjWmN8YNkDlUkjC+H1Krqzvmw=;
 b=hrJqzUhiH9Cbeelb0GUuomxjMZzqzkWRK6DScZu0UFNIpnTsf5BvcZIkJl1zYbRSnEvMrOFqj6VnqOruZVUSNZ3eqC47wBfjX2ZjEnPdhVkRDiM0RPSOHHFP/slVaGPwUbotKA1kN8279+27AYAMjL5A9eDAZ0ASq2O9DPgmBjcj/hKgdsLwZr7AJLLJeZ799p/4OJvkdMQwH7/DfsSV8RyFel0k5LYQ2xYLrKPHdthzYvPtgjdZLWps6oKg/OtIb17JSR8XoONGhnqKZ2PtqTNbOyhMgEJAHRp0yFICj3bAKSZZhS2+9upDPFScxvArcM1KAQznFA5dWPjboceoJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4nIN4GNyNyMN4ox3VjhjWmN8YNkDlUkjC+H1Krqzvmw=;
 b=CWQZ6jrdHbbRxXToOiS8VBLuVtF42A6Uz3dM67cTygcxYn2cltHBlatdiAYYwFDvR6PloNlieaoXkn7CT43LZ/qxwL6l8hxwpBQOEtS4IF/swb+/z+pjsk6hkdYimF5fdV1IpRqdVUWbqW0km8XObVM5kFCYzGBThEfe94UO9Z8=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB5374.namprd10.prod.outlook.com (2603:10b6:5:3aa::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Mon, 24 Oct
 2022 04:53:28 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Mon, 24 Oct 2022
 04:53:28 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 01/26] xfs: open code insert range extent split helper
Date:   Mon, 24 Oct 2022 10:22:49 +0530
Message-Id: <20221024045314.110453-2-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221024045314.110453-1-chandan.babu@oracle.com>
References: <20221024045314.110453-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR06CA0042.apcprd06.prod.outlook.com
 (2603:1096:404:2e::30) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB5374:EE_
X-MS-Office365-Filtering-Correlation-Id: d9742de4-637e-4752-9125-08dab57bb10a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rd54BUpJZMZ7fpoDwJEr8hqisTLqhHBkIUlbqq+015geH3x/XVmE9YpDtOiQgPiGw59qPXSUTZK8dsfu4Mxkoo5IlNCnF0AuUO0I7cnVm3Mmt9FPjs+bxJ/pfwRR3xt3EIjGwGhaimSNLUgA3vzKcxQoXCvOhkFt1P44UZYE37QzEzhDsDm8o+R7dobMuDE5P/cjFlghp+npCVkUoK3isyN4MA13YOZselJN7uZfpIwDp6k0E4HP9viNZ6vdPb0DMPjpkXojWXG6QOW88OIs9M9nKR0oP+zArsM9VotrXbe3UEVsTVrre7tgaJEmUq4gQNdtrwzD5wcNBHG2oJL65KHcR8e3du7sZPwKf4CN4kDuVlUvXiJkf4SzddeED8jJ0SerSqS3T+jYaX7cvyuoJONwb0A5gRFOMuBy8P8zxZkkYFDUEAUQipFEZm912Yz/iLXAZP7wOvBLj/7Dt0hgYG1GVHqWCbOjT2v4BGtEl6qhakhicD8BgzixsKmASvPEHMjZLhINZCtCZWqdrwT4PVzWLbYIOAuqcYsdNVTRT42k8lFkiPMtvNBIR3BXTuqkTjKYrxCceqcC6eJDCOKzwUtkskFnQeHVZKEeeZx5I1HGYJ+fSgKqAh7HJt4289nj3JCXW5fyu5utwJo73mFxcqhWeGmGwdg6rRWo8E0BzWhhJzgpv2zLoiAB4BcFhpxz6818vWZoMQs6CzVBBj3Blg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199015)(6916009)(83380400001)(2906002)(5660300002)(6512007)(26005)(6486002)(4326008)(8676002)(8936002)(86362001)(66556008)(66946007)(36756003)(66476007)(2616005)(316002)(1076003)(186003)(478600001)(38100700002)(6506007)(41300700001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pvbYbwocRT1eZkPeYm8XActOA8UXHJt+pDGSwrAzMT5tTXf4llVd/Pn1+icI?=
 =?us-ascii?Q?zTsKCN1vXvLUDD3pH21MfOeHnocYThTFVLkBFeXycwZMumiPKLX1DSdumONA?=
 =?us-ascii?Q?eph2J8fszyAg7Dt6VoQ546y0ftq3qemqztsjSVmhI/h1YkFTTntxYRyLDu+0?=
 =?us-ascii?Q?ZdactlZ4PxO39PRi4Zn5VgWsbEkwfjPRwBs5f3dGR15ot/YxCRSnNWCVTGkW?=
 =?us-ascii?Q?/0oeZQVySteN+JI1QyvA3Q+x1yHXed3rbMibYMXJJnJMG+PXrUO6C5f5E9Gg?=
 =?us-ascii?Q?21n6vhnmTGjYpamd6MWljs/4qyx8dAvlefFW4D+gxchqIsKTYx1Mx0rJFdaW?=
 =?us-ascii?Q?Kcw7wQA0M+DgMz3QbtTA7z1Ca8FZ83JXXsYYmWm62UKOvAhT6dLGmALbKHTN?=
 =?us-ascii?Q?ClPdikVTSRbhu4B2BSH1HSYbX0PBZ5ZyEdVBnHSrJ0Hsn3LCMvsFALR7v5rC?=
 =?us-ascii?Q?pOqqF6O0XYttq/WqjKAmkFKukVchr+jeamJAmg/SoAefCCkZFBS7MbnvKw/L?=
 =?us-ascii?Q?l1lyEehA6uSMams+iMzpfOKfEGn6dzBfnfuSDYu7VXq0+xn4P48CHxA0Ieqe?=
 =?us-ascii?Q?CcdWRbOnd10jGHjuHot8zMJpWND1r+qDtAcIyfXzmd80MqiOPfn4mEVB/JnT?=
 =?us-ascii?Q?W06Y6OJuW93Fe3KAjVLO/p4Q+ZLtmI5wfBFjAEddJpoC2sS1bN4lUx4JcyON?=
 =?us-ascii?Q?omA5iRLyGZNhCXKsUhZ4yNd3xG/S+Trtv95pjxJdkFrSDsfaFww47lyBTrqD?=
 =?us-ascii?Q?iLOgCjGJC7hKUSi7kkJorzYHZTdy2ibyrUVC3ZGmBcUa5KMZF02PxtSJ6Ul5?=
 =?us-ascii?Q?89A0uDbofNjpdD1TwXULO8nB5SLOQidXHk6LoJtgmyp8L1gHQjwwz9k8Eq7r?=
 =?us-ascii?Q?kVqBadf4MUDg5kGYohuGsQoxXcj1liCn+sX1neg8Fe6LACRRDgcBODfq5T8p?=
 =?us-ascii?Q?mdZBZPjXz7I0sQgSAMToc8LdSzQlAPPcPv220VxY/Sm9qUM908+aG2mz0hif?=
 =?us-ascii?Q?JBqSvsOKHaAC/F0vWBZ4jz+ZihVS3eaSrTp9egTzhaljkJ2iz0pPbB/UW630?=
 =?us-ascii?Q?MGM8DsfJ14rxYqUD1nnvtsPQHfhUVPmjJC/9xF6q8gGLDACi9Pa6t5Vxm44o?=
 =?us-ascii?Q?lXJMHa2CaZ3CpMip95Z1x7czQlOXv8nqjG2CSSYGcySbaLB/UwEZ8OwRqRHA?=
 =?us-ascii?Q?u5ikIn6txz5uDnZqZTeNxptqV13BJMlaKNkEkzG95ghDn/onSf1MLe4omKp3?=
 =?us-ascii?Q?vVzAueG/NeO03hnHhM7dGdRSZAdKujOXza0GmLFa0afpr6ix8WRKWy2AsM3V?=
 =?us-ascii?Q?fxgasfo5Ea4XUkeCJ/3aXgshvAuLjUrbiNwXtSX1O68mf5kNF0zyWfNuAYr9?=
 =?us-ascii?Q?60df8W9zw2yee1cedpt2aIkRrUeyGRpZEqXyy4G2Gr0OWkuM9WGMvGe+p4jw?=
 =?us-ascii?Q?AN+XZOcX55OSWoU5y8Wkv9nxedsrrGcoujlvXOkn18AHVKA8ALr0+4AIZRdA?=
 =?us-ascii?Q?PwTaVh+TRoaQ8aBGEOVdvHX5Q90GzeStictMixJyWVgbnIUFZEDTnPGbYo9f?=
 =?us-ascii?Q?+G05k7Un2B2aF+O81g4lqFbg0pdHxAh+obA5+LiC?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9742de4-637e-4752-9125-08dab57bb10a
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 04:53:28.4397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 95cCIKC7eEpqGzYOXYfLVDv4xK2LBy1UWqer23cm5e7K+dpIIYP6uism8Fx4ljuzciHkTGEo84E5ablj6yIELQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5374
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-23_02,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210240031
X-Proofpoint-GUID: cUQ6x0eVN_Xh5KAE039yBynsT95yWVjz
X-Proofpoint-ORIG-GUID: cUQ6x0eVN_Xh5KAE039yBynsT95yWVjz
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit b73df17e4c5ba977205253fb7ef54267717a3cba upstream.

The insert range operation currently splits the extent at the target
offset in a separate transaction and lock cycle from the one that
shifts extents. In preparation for reworking insert range into an
atomic operation, lift the code into the caller so it can be easily
condensed to a single rolling transaction and lock cycle and
eliminate the helper. No functional changes.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 32 ++------------------------------
 fs/xfs/libxfs/xfs_bmap.h |  3 ++-
 fs/xfs/xfs_bmap_util.c   | 14 +++++++++++++-
 3 files changed, 17 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 8d035842fe51..d900e3e6c933 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5925,8 +5925,8 @@ xfs_bmap_insert_extents(
  * @split_fsb is a block where the extents is split.  If split_fsb lies in a
  * hole or the first block of extents, just return 0.
  */
-STATIC int
-xfs_bmap_split_extent_at(
+int
+xfs_bmap_split_extent(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
 	xfs_fileoff_t		split_fsb)
@@ -6037,34 +6037,6 @@ xfs_bmap_split_extent_at(
 	return error;
 }
 
-int
-xfs_bmap_split_extent(
-	struct xfs_inode        *ip,
-	xfs_fileoff_t           split_fsb)
-{
-	struct xfs_mount        *mp = ip->i_mount;
-	struct xfs_trans        *tp;
-	int                     error;
-
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write,
-			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0, 0, &tp);
-	if (error)
-		return error;
-
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-
-	error = xfs_bmap_split_extent_at(tp, ip, split_fsb);
-	if (error)
-		goto out;
-
-	return xfs_trans_commit(tp);
-
-out:
-	xfs_trans_cancel(tp);
-	return error;
-}
-
 /* Deferred mapping is only for real extents in the data fork. */
 static bool
 xfs_bmap_is_update_needed(
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 093716a074fb..640dcc036ea9 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -222,7 +222,8 @@ int	xfs_bmap_can_insert_extents(struct xfs_inode *ip, xfs_fileoff_t off,
 int	xfs_bmap_insert_extents(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t *next_fsb, xfs_fileoff_t offset_shift_fsb,
 		bool *done, xfs_fileoff_t stop_fsb);
-int	xfs_bmap_split_extent(struct xfs_inode *ip, xfs_fileoff_t split_offset);
+int	xfs_bmap_split_extent(struct xfs_trans *tp, struct xfs_inode *ip,
+		xfs_fileoff_t split_offset);
 int	xfs_bmapi_reserve_delalloc(struct xfs_inode *ip, int whichfork,
 		xfs_fileoff_t off, xfs_filblks_t len, xfs_filblks_t prealloc,
 		struct xfs_bmbt_irec *got, struct xfs_iext_cursor *cur,
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 113bed28bc31..e52ecc5f12c1 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1326,7 +1326,19 @@ xfs_insert_file_space(
 	 * is not the starting block of extent, we need to split the extent at
 	 * stop_fsb.
 	 */
-	error = xfs_bmap_split_extent(ip, stop_fsb);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write,
+			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0, 0, &tp);
+	if (error)
+		return error;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+
+	error = xfs_bmap_split_extent(tp, ip, stop_fsb);
+	if (error)
+		goto out_trans_cancel;
+
+	error = xfs_trans_commit(tp);
 	if (error)
 		return error;
 
-- 
2.35.1

