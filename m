Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCB4CC38A2D
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 04:54:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbiJXEyC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 00:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiJXEyA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 00:54:00 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C6679EEA
        for <linux-xfs@vger.kernel.org>; Sun, 23 Oct 2022 21:53:59 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29NMxxcZ018071;
        Mon, 24 Oct 2022 04:53:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=2MwC21RtgcJGBbqjS2IWar9hjDSfDOHoabMDzgEglzE=;
 b=xCNRwwzRzRiNOGdd/FEv17L6iC4K7CJopKDvaeJY48xRPQ4uE0d3pj8mCe5YT3LAax8c
 wXWbrspzxrhgnqS/662sP7oDpPZyTY4aDLjqKDAAnqAGJrQQ/PIxour940CdeX7n5ICK
 8Q7HBpO4iG18+c8G+ntBSbGmaCFbl5tocBGE64sThFLxmphhXLeUsr33OlQkbAq8EtfU
 i/fxszOHWtr6U7TbcPnZUCVwu4D1ZQ93LDRMLMQbaeP1eJ8Nt5NP+uYRH4NWdyd1M+na
 ywM3Fxmdfp/uxMwqDJbLfiMuUqEWkzIX7YFOXIAuh0b1Ys/peYi3Z75JvSMQEuw3GqSh NQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc741jw5f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:53:55 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29O44AZr032101;
        Mon, 24 Oct 2022 04:53:53 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y3k8au-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:53:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ekXhK8C0jN4rN4n9wkkVScPXMQHmCZRqTMvJ/cSFC+yhjbwd78jIBESps+IsxGdVmssmObpbWz82ABF2vp6Guib24HtNMmCogD0nfYzVtThW59PEaBl++4rBlk76jQVYNL1vVEq3Euc7xGhOIyWC7z1nyuML4NOWzJkQTpg1ZFAhYpoM1XktazvuQ9DaX4RiLYPrnxlU4Zn2/3LiNiq0SriWhDeyc7NQ6P7W89ndCjGvCWW55ezxU+eNobjJrGeTcE5XUzexZEwOc+vTpd5cC27o0Gl4JmphezFzGz1P7F610tbFizyv5yexmi7o+zFDSIWlHsYvz11//dHVDbDFYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2MwC21RtgcJGBbqjS2IWar9hjDSfDOHoabMDzgEglzE=;
 b=K8jEOdxWos9mYtWiKBBK30foa+dAQCboyNkFedNQgAyHV2ptVyJUf6uFKBRLyPIQcNhz5eaAc2Myzq6//NAjt9IuY076U60lAjPfcfYBacGF8MFMFCwC7jDIQQD35Yb/ZPp02p9GDOQ2rrlzEAdZFj6pglf3jJcEwDjko9U4qTmUBlkGHy3c+nK8JHtJIuSwkVmn7x86hQ/wwO7pTSKlh6R69GGvSHLCuRJpgVyms2NHCaefYH3XWAy9+/pzC/wxxI4ys8mC9R8vi2GBNkGBtJIzC1a7Zlq27mO63QZi8ebaL7OntDuVLUseoJWqVd++wfise3GHgLPpsu30ClEVvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2MwC21RtgcJGBbqjS2IWar9hjDSfDOHoabMDzgEglzE=;
 b=K4ovblfKgu1Bn2rArZq0ctFYubQblaJkWWpR0SquX8NtBFnt1V+gN2tL1sTmIV9UsI1q+GbhISQKbkXsKPkc5LV4qxU5tDsNmDetpnK80RLgxmp/SqktXDshOt4R8o0tCggTqdkqlmmxvRCcH5vSFrbAUEcLdFqIPIDLrGlJ+44=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB5374.namprd10.prod.outlook.com (2603:10b6:5:3aa::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Mon, 24 Oct
 2022 04:53:51 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Mon, 24 Oct 2022
 04:53:51 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 04/26] xfs: add a function to deal with corrupt buffers post-verifiers
Date:   Mon, 24 Oct 2022 10:22:52 +0530
Message-Id: <20221024045314.110453-5-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221024045314.110453-1-chandan.babu@oracle.com>
References: <20221024045314.110453-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0119.jpnprd01.prod.outlook.com
 (2603:1096:404:2a::35) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB5374:EE_
X-MS-Office365-Filtering-Correlation-Id: d12e96d0-03b0-45c7-dc60-08dab57bbe80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jbl0Mu3kEaJNbeM8Bl27GXLn17xkEtN/tL6rNk51YkMnWG6Dcu2lPG33soPKqQPyi8rxq2Qd6E/DmPm2uBR7wFrhAZ0tNiKnz6tQ3T3hD/QCsK6CJpU5+t+y5pCqktHNRQrPDOtpNv4VOT/XdABap9kBgbYDzEeSRpJB5MgKPS1K65L7kXL6JcskzncDD8xVixSDFVABQMRCNl4OW9q961gHGvpvdVF9S8XmJ0oePS2Tt+iwYrj1TKJLyQaEasTytjbbeIP2hIaycE8iUN/6Cy+VYIj3BEzcQbhz5PyWAKSDJGqi09Yu8nNX08OEEevqfKF8t7vyx/GqWAWxNifs6rINOXz6rcIL0Hx/+elPqvJCXlJPYEiDfSBKqaepG0K5bvS7TzmCaIvHG/W6N96PjheTfCEKs7/cYSvJe8vWdA3s8FAZf4bKRGD5rfpE+qh2APyOGR6eExXNL/PKt+gDyQx9IEukurcE7U25VeafLr+EUj1cub6R2jdDN4v/+SioHB0Dpkie54SKQPY6MaOmkKLUwLMqAUHiUvTBYstkrfJ3xUyYBLarxMwlOXuDJRan5WylsdRctG5EpO+4SZ9Zk2YTvq/mytuzm1P/tXo0MC8JlUqMRQXM5TtGUa5PGIcnlcFXfzt7WYLrOutPaz3hnNf54LOPL4+an4xCaKW9aT0GnSAqcaSSvHMEpRcmH4hvjNLDaM13KRcw9irUHLqorQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199015)(6916009)(83380400001)(2906002)(5660300002)(6512007)(26005)(6486002)(4326008)(8676002)(8936002)(86362001)(66556008)(66946007)(36756003)(66476007)(2616005)(316002)(1076003)(186003)(478600001)(38100700002)(6506007)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6QVNTAVZiQIVpZu8Y0lqwJ8s2ABc0qRg/r4/qsIC61pO6Hkpl5x35ezrJ00S?=
 =?us-ascii?Q?wyo4e9e1g9VpN7yWMZOGhxKM2U6kq+pAGE5PtqAwCF0QGOeTUtELlXv38N8q?=
 =?us-ascii?Q?MK7JVNLH4aob7+b4/hD3Vbs+hhb9N1qwJCMENUA3mSSY3VnSNFiekQpj0cqh?=
 =?us-ascii?Q?ID5G6FQk4JVg1fxSiktyUMTNoJQ6RkXCuVRDOM0yM0JAqLHNPCROTcJkdNHV?=
 =?us-ascii?Q?+vgbF/SflaGqL4dyBectsI4nk4uZ0fjOjDeA2D5E7jYISlPxa0duHOo34VKw?=
 =?us-ascii?Q?RzkqNTU3f5oUfHJYR+gawim0Q2zHibEmXlpQvD0EtTglKUT5iYOrTJCnUE8o?=
 =?us-ascii?Q?WKwzquRy7RXqLJwmFwRgf6rPgyi3yYQalsHOzY93EcgU7B/y2vh48LXd+mQS?=
 =?us-ascii?Q?6VX5AySmVDLs9fzKtlQYu1ife21jJaxtG5gcm6HZkf/u61YMjMTPI0kdibcz?=
 =?us-ascii?Q?h8GlhxZn1n5SkmiJipII7mxnpEjT/YXGYlLCSkg6RWFdGT2i3hh+a1fMaM0f?=
 =?us-ascii?Q?XC9FpswI1b3GDYeXAZj0RGGBBuARq6UoCNsHRIPwiaOWIj4hqUSFySkUusVH?=
 =?us-ascii?Q?kukDMR/wxKAAnP7I2s95RD6PpJHo9vIiZPBGhHv1U+x4M4KiL21621P7xpbZ?=
 =?us-ascii?Q?4gOkPYdKndSrmV5uLdK472wyXB2OGX3R/XQuwiDtyLkgho4RQ7Vif4KLKUmB?=
 =?us-ascii?Q?zcvcojXyR8mhrJrx4InZYBdQ0lr1vm3lmYEz8CgOUswzoa/WtfRnvj8elHBw?=
 =?us-ascii?Q?oHQ71bQx3t314t5GQart91azwdu5qPqZJRxDXGzpQizBUUkE5nUNyVAliUeW?=
 =?us-ascii?Q?zOLIuFEnYyMe5gYlELOAwg1PeF1fNqJJP/LKCnWAnyPgzv1VO0SBYF4KITXi?=
 =?us-ascii?Q?zquKBqaUO4lBvibaGm+N3zE0UH2C0gyWaBYz2xXPKLUTGdnsfEBT1oJUsUnw?=
 =?us-ascii?Q?W7kbTrvbhq3iQ1PuusSTx8N8eWZd0lWR2WjOV0dzc0vOSeJN/ZBZb6iw9JSr?=
 =?us-ascii?Q?msoStiUaw7NZgNnuU7Zkxk/UzFdFSjwNIm2QKozwVvcLvDBnTiaq6BJYNR37?=
 =?us-ascii?Q?ALYsGLTXZ+TiuJD43wU5hLeeywnIaiHAuz9GEgk6tS8WSfceBELuviL1s+Vq?=
 =?us-ascii?Q?GYsKvU2b+LO5ssZCcl923Z/pzkJQo2x9ITjctLU9qngbEafmblTn2jLbp0ya?=
 =?us-ascii?Q?1ldykjd0s/SB4jlvVxSMvnv88cd984i6Sgn1owICx2mRK1vwUD1Pf7S2SRZ9?=
 =?us-ascii?Q?AkRVWJHnXZPu6KdsrH0CjZkGYc9N2+CC5SQa+icmLpL9cgWfqVN9qxMNwqZs?=
 =?us-ascii?Q?2YJdXbqEYD8TeapYKg9xfNAa87ledPWrBTcJF4vATDBqKG1joEEzggWQ/Ebf?=
 =?us-ascii?Q?POkNHgxeWCeGN8VuCiyyHqzu2LYTvw0Egbpjx78HUZxVsEByVA7mqNfLeToM?=
 =?us-ascii?Q?2xeDOTqJepLyR2EWL7ojKPFOevZAAPM6fbmEEoJwX7WgTRNaiY0oAg2be8u2?=
 =?us-ascii?Q?nc5ANFBAaZ7idT8lwyEF056X8jKWbFN3zRpWNsWguZIn73p2Iklb3I5GdwG8?=
 =?us-ascii?Q?69p9cjJS0CkwTOD8LKZ4p3nIA5G1wypK0CG2LZvKIgTzR+9kL06oL9AtsGph?=
 =?us-ascii?Q?NA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d12e96d0-03b0-45c7-dc60-08dab57bbe80
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 04:53:51.0580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yMRoeVy0ftt7vYcr9cXLcDMfdTybxSoLrOAZDCjYmxVYntbo4gKGzVP3PuZqsxC8bTpSAZk4flG9zJyGdJ8rbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5374
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-23_02,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210240031
X-Proofpoint-GUID: KM19z0yYjQaiaKtR-pOclX3bVU6cS5rm
X-Proofpoint-ORIG-GUID: KM19z0yYjQaiaKtR-pOclX3bVU6cS5rm
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 8d57c21600a514d7a9237327c2496ae159bab5bb upstream.

Add a helper function to get rid of buffers that we have decided are
corrupt after the verifiers have run.  This function is intended to
handle metadata checks that can't happen in the verifiers, such as
inter-block relationship checking.  Note that we now mark the buffer
stale so that it will not end up on any LRU and will be purged on
release.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c     |  2 +-
 fs/xfs/libxfs/xfs_attr_leaf.c |  6 +++---
 fs/xfs/libxfs/xfs_btree.c     |  2 +-
 fs/xfs/libxfs/xfs_da_btree.c  | 10 +++++-----
 fs/xfs/libxfs/xfs_dir2_leaf.c |  2 +-
 fs/xfs/libxfs/xfs_dir2_node.c |  6 +++---
 fs/xfs/xfs_attr_inactive.c    |  6 +++---
 fs/xfs/xfs_attr_list.c        |  2 +-
 fs/xfs/xfs_buf.c              | 22 ++++++++++++++++++++++
 fs/xfs/xfs_buf.h              |  2 ++
 fs/xfs/xfs_error.c            |  2 ++
 fs/xfs/xfs_inode.c            |  4 ++--
 12 files changed, 46 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 084d39d8856b..1193fd6e4bad 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -685,7 +685,7 @@ xfs_alloc_update_counters(
 	xfs_trans_agblocks_delta(tp, len);
 	if (unlikely(be32_to_cpu(agf->agf_freeblks) >
 		     be32_to_cpu(agf->agf_length))) {
-		xfs_buf_corruption_error(agbp);
+		xfs_buf_mark_corrupt(agbp);
 		return -EFSCORRUPTED;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index c86ddbf6d105..e69332d8f1cb 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -2288,7 +2288,7 @@ xfs_attr3_leaf_lookup_int(
 	xfs_attr3_leaf_hdr_from_disk(args->geo, &ichdr, leaf);
 	entries = xfs_attr3_leaf_entryp(leaf);
 	if (ichdr.count >= args->geo->blksize / 8) {
-		xfs_buf_corruption_error(bp);
+		xfs_buf_mark_corrupt(bp);
 		return -EFSCORRUPTED;
 	}
 
@@ -2307,11 +2307,11 @@ xfs_attr3_leaf_lookup_int(
 			break;
 	}
 	if (!(probe >= 0 && (!ichdr.count || probe < ichdr.count))) {
-		xfs_buf_corruption_error(bp);
+		xfs_buf_mark_corrupt(bp);
 		return -EFSCORRUPTED;
 	}
 	if (!(span <= 4 || be32_to_cpu(entry->hashval) == hashval)) {
-		xfs_buf_corruption_error(bp);
+		xfs_buf_mark_corrupt(bp);
 		return -EFSCORRUPTED;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index a13a25e922ec..8c43cac15832 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1820,7 +1820,7 @@ xfs_btree_lookup_get_block(
 
 out_bad:
 	*blkp = NULL;
-	xfs_buf_corruption_error(bp);
+	xfs_buf_mark_corrupt(bp);
 	xfs_trans_brelse(cur->bc_tp, bp);
 	return -EFSCORRUPTED;
 }
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 1e2dc65adeb8..12ef16c157dc 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -504,7 +504,7 @@ xfs_da3_split(
 	node = oldblk->bp->b_addr;
 	if (node->hdr.info.forw) {
 		if (be32_to_cpu(node->hdr.info.forw) != addblk->blkno) {
-			xfs_buf_corruption_error(oldblk->bp);
+			xfs_buf_mark_corrupt(oldblk->bp);
 			error = -EFSCORRUPTED;
 			goto out;
 		}
@@ -517,7 +517,7 @@ xfs_da3_split(
 	node = oldblk->bp->b_addr;
 	if (node->hdr.info.back) {
 		if (be32_to_cpu(node->hdr.info.back) != addblk->blkno) {
-			xfs_buf_corruption_error(oldblk->bp);
+			xfs_buf_mark_corrupt(oldblk->bp);
 			error = -EFSCORRUPTED;
 			goto out;
 		}
@@ -1544,7 +1544,7 @@ xfs_da3_node_lookup_int(
 		}
 
 		if (magic != XFS_DA_NODE_MAGIC && magic != XFS_DA3_NODE_MAGIC) {
-			xfs_buf_corruption_error(blk->bp);
+			xfs_buf_mark_corrupt(blk->bp);
 			return -EFSCORRUPTED;
 		}
 
@@ -1559,7 +1559,7 @@ xfs_da3_node_lookup_int(
 
 		/* Tree taller than we can handle; bail out! */
 		if (nodehdr.level >= XFS_DA_NODE_MAXDEPTH) {
-			xfs_buf_corruption_error(blk->bp);
+			xfs_buf_mark_corrupt(blk->bp);
 			return -EFSCORRUPTED;
 		}
 
@@ -1567,7 +1567,7 @@ xfs_da3_node_lookup_int(
 		if (blkno == args->geo->leafblk)
 			expected_level = nodehdr.level - 1;
 		else if (expected_level != nodehdr.level) {
-			xfs_buf_corruption_error(blk->bp);
+			xfs_buf_mark_corrupt(blk->bp);
 			return -EFSCORRUPTED;
 		} else
 			expected_level--;
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 388b5da12228..c8ee3250b749 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -1344,7 +1344,7 @@ xfs_dir2_leaf_removename(
 	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
 	bestsp = xfs_dir2_leaf_bests_p(ltp);
 	if (be16_to_cpu(bestsp[db]) != oldbest) {
-		xfs_buf_corruption_error(lbp);
+		xfs_buf_mark_corrupt(lbp);
 		return -EFSCORRUPTED;
 	}
 	/*
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 35e698fa85fd..1c8a12f229b5 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -375,7 +375,7 @@ xfs_dir2_leaf_to_node(
 	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
 	if (be32_to_cpu(ltp->bestcount) >
 				(uint)dp->i_d.di_size / args->geo->blksize) {
-		xfs_buf_corruption_error(lbp);
+		xfs_buf_mark_corrupt(lbp);
 		return -EFSCORRUPTED;
 	}
 
@@ -449,7 +449,7 @@ xfs_dir2_leafn_add(
 	 * into other peoples memory
 	 */
 	if (index < 0) {
-		xfs_buf_corruption_error(bp);
+		xfs_buf_mark_corrupt(bp);
 		return -EFSCORRUPTED;
 	}
 
@@ -745,7 +745,7 @@ xfs_dir2_leafn_lookup_for_entry(
 
 	xfs_dir3_leaf_check(dp, bp);
 	if (leafhdr.count <= 0) {
-		xfs_buf_corruption_error(bp);
+		xfs_buf_mark_corrupt(bp);
 		return -EFSCORRUPTED;
 	}
 
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 9c88203b537b..f052de128fa1 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -145,7 +145,7 @@ xfs_attr3_node_inactive(
 	 * Since this code is recursive (gasp!) we must protect ourselves.
 	 */
 	if (level > XFS_DA_NODE_MAXDEPTH) {
-		xfs_buf_corruption_error(bp);
+		xfs_buf_mark_corrupt(bp);
 		xfs_trans_brelse(*trans, bp);	/* no locks for later trans */
 		return -EFSCORRUPTED;
 	}
@@ -196,7 +196,7 @@ xfs_attr3_node_inactive(
 			error = xfs_attr3_leaf_inactive(trans, dp, child_bp);
 			break;
 		default:
-			xfs_buf_corruption_error(child_bp);
+			xfs_buf_mark_corrupt(child_bp);
 			xfs_trans_brelse(*trans, child_bp);
 			error = -EFSCORRUPTED;
 			break;
@@ -281,7 +281,7 @@ xfs_attr3_root_inactive(
 		break;
 	default:
 		error = -EFSCORRUPTED;
-		xfs_buf_corruption_error(bp);
+		xfs_buf_mark_corrupt(bp);
 		xfs_trans_brelse(*trans, bp);
 		break;
 	}
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 8b9b500e75e8..8c0972834449 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -271,7 +271,7 @@ xfs_attr_node_list_lookup(
 	return 0;
 
 out_corruptbuf:
-	xfs_buf_corruption_error(bp);
+	xfs_buf_mark_corrupt(bp);
 	xfs_trans_brelse(tp, bp);
 	return -EFSCORRUPTED;
 }
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 1264ac63e4e5..948824d044b3 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1546,6 +1546,28 @@ xfs_buf_zero(
 	}
 }
 
+/*
+ * Log a message about and stale a buffer that a caller has decided is corrupt.
+ *
+ * This function should be called for the kinds of metadata corruption that
+ * cannot be detect from a verifier, such as incorrect inter-block relationship
+ * data.  Do /not/ call this function from a verifier function.
+ *
+ * The buffer must be XBF_DONE prior to the call.  Afterwards, the buffer will
+ * be marked stale, but b_error will not be set.  The caller is responsible for
+ * releasing the buffer or fixing it.
+ */
+void
+__xfs_buf_mark_corrupt(
+	struct xfs_buf		*bp,
+	xfs_failaddr_t		fa)
+{
+	ASSERT(bp->b_flags & XBF_DONE);
+
+	xfs_buf_corruption_error(bp);
+	xfs_buf_stale(bp);
+}
+
 /*
  *	Handling of buffer targets (buftargs).
  */
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index f6ce17d8d848..621467ab17c8 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -270,6 +270,8 @@ static inline int xfs_buf_submit(struct xfs_buf *bp)
 }
 
 void xfs_buf_zero(struct xfs_buf *bp, size_t boff, size_t bsize);
+void __xfs_buf_mark_corrupt(struct xfs_buf *bp, xfs_failaddr_t fa);
+#define xfs_buf_mark_corrupt(bp) __xfs_buf_mark_corrupt((bp), __this_address)
 
 /* Buffer Utility Routines */
 extern void *xfs_buf_offset(struct xfs_buf *, size_t);
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index d8cdb27fe6ed..b32c47c20e8a 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -345,6 +345,8 @@ xfs_corruption_error(
  * Complain about the kinds of metadata corruption that we can't detect from a
  * verifier, such as incorrect inter-block relationship data.  Does not set
  * bp->b_error.
+ *
+ * Call xfs_buf_mark_corrupt, not this function.
  */
 void
 xfs_buf_corruption_error(
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 30202d8c25e4..5f18c5c8c5b8 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2149,7 +2149,7 @@ xfs_iunlink_update_bucket(
 	 * head of the list.
 	 */
 	if (old_value == new_agino) {
-		xfs_buf_corruption_error(agibp);
+		xfs_buf_mark_corrupt(agibp);
 		return -EFSCORRUPTED;
 	}
 
@@ -2283,7 +2283,7 @@ xfs_iunlink(
 	next_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
 	if (next_agino == agino ||
 	    !xfs_verify_agino_or_null(mp, agno, next_agino)) {
-		xfs_buf_corruption_error(agibp);
+		xfs_buf_mark_corrupt(agibp);
 		return -EFSCORRUPTED;
 	}
 
-- 
2.35.1

