Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 863EEECAAD5
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Sep 2022 13:29:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbiILN3M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Sep 2022 09:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbiILN3L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Sep 2022 09:29:11 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA2230562
        for <linux-xfs@vger.kernel.org>; Mon, 12 Sep 2022 06:29:09 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CDEJXi005927;
        Mon, 12 Sep 2022 13:29:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=h0AQk453NGAod4+b6bLM2Gk/Ps38nE2TerFX3vzTjkQ=;
 b=crjyn9VLjmdfAR67S4fy1ziAdA8VIU5y0Cafgvd04i7n/rxIlhKGhQrxxSu0jgLJjNJL
 6dxL/c4Zm6hL9i3FhdcrNc5DSJrmQqIxbImKMvLi1805ri9y8ecmhQ7pLOLurNUZ16pF
 CO11KYuxuTwlzZ6Dx7enrWjMeP07BNsfQQlJZCUcQX9B95ya0D/sViU/Yfd8T5HrMA9/
 yOCOp38JpyZU5HzvpiBE0E8kpOhY46X1OftnhXp71GyCbdxTGIKAvAwte1ufuG3m0sFl
 En1n37S0AzEU58FpGddb+3+xXaNhIE3KJ/4YlJ/ft9rXVBuTzala4Mlkfjx9n6Q1Kr1s Xw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jgjf9uec7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 13:29:04 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28CCEhDU023770;
        Mon, 12 Sep 2022 13:29:04 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jgh12jbqg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 13:29:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MTlQAZhiX/+qERky2BymWcgtmvGuWTWbm823ZSEeLzUi4KxPJTPOrLbmNyGnBRptuAEsYXxKn8lsEYkk6nvZBuoll8Rz8p5N+IU6Ufw02kie7eFDtFIxKW/7RJmw1Cf2FyTpMHFzCpWOKkLsD6DB0VuWYwluu682/0/mQpNIc0upISAoEMmD40C/Y1BJlabOgIZ+YqUyZ8yY+OqY/+KUEe/odBZDdzXrr0NdlucQ887HJ/SAWJJPQmP3RY6N2mIsWaw9N4r9PNtCwsD8+Y1U2LcpA0Zu1Ek+FWTFsa7KS0VX1CV9cqEvPGJOnWNU30G8yDtJcegSLrruJMYYGuWvuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h0AQk453NGAod4+b6bLM2Gk/Ps38nE2TerFX3vzTjkQ=;
 b=X+pBAlc8qDj17dOkc/7Ie8vYdG/+zL2AN6EjSWsyUiqLxv9JMSy0YqKv8HsTDJtbUx+wnu7et5niZJ6Bo9T/c1Ej0qIxHyiLdxVFvVwz81h+0r4T/Kt1qxX1LIkGx56LtLgaRlvT/bmNVFjap31LHMnWw1DQer7U3hImJzYQRi00I7stq/S2Da+DIoArwINcm9EaGNpL0wxj/j2zucl19l50KIv7yJNvi3+1hzSGXS5pz5fgAChOD4lWS7LeE4+o28+RmHv5c90xBzJH1h3+jg0SvHgfBA4th8fW5Uk9La+L5dstV/ARrlzRh6TTVsZZnKEKJODIDLrTYfV0+1vePQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h0AQk453NGAod4+b6bLM2Gk/Ps38nE2TerFX3vzTjkQ=;
 b=xN1sP68hR5rEHBe64qGDBjzA1oSBWIdNu9vYjf7b+eMn2uDiX3MuiafFwSnEi+ysfsvgrxZKmob7FmIAX5QU7XHU6pPpH8ou8jUgMS+q+n1OBjVuMqDQM1oQ3ofo4rkHIQl9u4fnjY8SRgXRySNPflm0m7dB0yQzr08JBpfmu78=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by MN2PR10MB4173.namprd10.prod.outlook.com (2603:10b6:208:1d1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Mon, 12 Sep
 2022 13:29:02 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::709d:1484:641d:92dc]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::709d:1484:641d:92dc%4]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 13:29:02 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 10/18] xfs: convert EIO to EFSCORRUPTED when log contents are invalid
Date:   Mon, 12 Sep 2022 18:57:34 +0530
Message-Id: <20220912132742.1793276-11-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220912132742.1793276-1-chandan.babu@oracle.com>
References: <20220912132742.1793276-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SGXP274CA0013.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::25)
 To SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MN2PR10MB4173:EE_
X-MS-Office365-Filtering-Correlation-Id: 84d11972-d4b6-435a-1a01-08da94c2c17f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6nH+4JsLE+25a/ryIh2Hop74TaSkA+yLW3JXiZHXuAjJZm+OxNhW2srUDlhXPiUY6CoF9137TAxWeZRuF3yeegoy+Pri2oJPPQ0inhMVxpYqmk40dwhhQtOUYAZ/p8v/IugWy3CjGA0a9vy5aoAGLgOLNDmdaYEyInhVawGejMD4G9yKq2qaKQpPrl8gdwH7Hk7cj2MHFYUyQuUuCiyB1tbSc+HRr3j8Cyty8pXwb1dZDUAaTE4Mn7h4KyEzRgykDbWoOMXGlof06qa/lwWLfUNZKaBG2uQvdRxAjaPsZjCOyqmBJvI1y0stRYJ0qNTkkoPe1HN68s+/YKjkmTt7ZImdX/5Ts9Bfl5HjC+9QgDC8/CspNnyG5Tj4z52VVs01aJV9lOKHPfnw1wn6dfwgExIm8+7icMnLLlE80zotSRDaWh2RLTSUXtpO7J7tZbG6nbfwrC2P6+Iavex6/raEz/YfioPp72aalNfshpI56Jehxk876LSnXRDTFri7QD/MwGD94w36t4fspDcq3UT+Ygin3mPYe7oErgnLYiBK2+qVabryxWY6ZMeNqNHL4VXjX+/EP1vNhGxD8QZQlq8UvxN2EArlXVniyklw9Akr6xXfVT8RlPHelFlb9HT9XiBIz7NxhvOf7L9lBpuM5juuJN/OFK2mQkD/hmzpmmj0O7B5afj87uCz5pKhRXA4yc1rN9CnyMqzPBT4b8gvwxcjFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(39860400002)(376002)(346002)(136003)(316002)(6916009)(38100700002)(6512007)(2906002)(5660300002)(8936002)(66946007)(66476007)(66556008)(8676002)(4326008)(186003)(6506007)(2616005)(1076003)(478600001)(26005)(83380400001)(41300700001)(6666004)(6486002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KuKq9tZxp4NbRmFmqrpeHtzNuihLi1BFdahRf9QYv2LlIAA6Q6b0/HjUjEIv?=
 =?us-ascii?Q?CyKIPMRWyJJDfYEtWXx9q9jrK6hdbQT/taKgvCRNZZdQlLPXvsPyExNP+4pW?=
 =?us-ascii?Q?PY6z+yoJ85XkOzRCS2Yyx/yaTCJd3Vc50opD2GGQ2JjVj8ANDPj4Yw/LUWHd?=
 =?us-ascii?Q?clFCCHsXgUW8Jr6Bg+QYHAN6I3qP3cfCirRpKQpi7aXFS6ikzevMzeawFBMX?=
 =?us-ascii?Q?spT4CsrrocoojWPxYgHKatTqwmSuDZAfY0xfUf8BAGKUL+f16+4uSUKAOBD5?=
 =?us-ascii?Q?qFr0q0kqYVmOdk4O0WXOddK0sYMcI8AzRV1dtcBv8G6gPILT0FltXBR2pw/s?=
 =?us-ascii?Q?1hvcABdLYHjBi0HBNsaC4GRb5uUlD9ndFaajAIsuN878lxV8qE92V4ZE0slp?=
 =?us-ascii?Q?kXeLu6oF/nFDVFq1+uhbkZgKlv5H5j0/5+jYgcgtP/+Ti3u1ZuWe4r7SMPVb?=
 =?us-ascii?Q?jIq2I/0EmaIjR4VmRd1MK7BX9BVxeMftu+N6nipZn0kvnBzB599SfuAOLt8w?=
 =?us-ascii?Q?UrHeMwP9vrF0jMFYAaQgVS8qb+PMc5LOoFt1W/7UcODrm5R25kKSUyS5gI4s?=
 =?us-ascii?Q?/Jo8/J0AHZLi/NVnxHsaN2u1DpYl2Qqzl+oj29t2mgVjnfIDHlPZ2hrDMRzM?=
 =?us-ascii?Q?8AqHApRAama9KI7hmPOvibc2Iw9fFwerjXIqi4Ln5kCo/q/LALGgKEqECTHR?=
 =?us-ascii?Q?lhjrckIghIjG5BDceAsVQ1M7SKQOk3OOQW6xTSVu252E4gLt7/IGnKN1vvv3?=
 =?us-ascii?Q?dhwxQLUsZeumbJUwaBlMdL3LqA7pU8mgNS5MWDVdtdfsGYERnlQKO+hDd9Fa?=
 =?us-ascii?Q?YPcg0UMa6viwV0mXr4fMqNndu9KGe/6Cwi7Orv5+H+hxSrVluTi/XJ0aYZMR?=
 =?us-ascii?Q?XvSS8W7ojI6msYyh7BwggDgJCBw92O6ObBM/OV+twgB4ZirIlM1VrA6HbVK0?=
 =?us-ascii?Q?VVTrgRgli+PaUr0YDR47iKN3Cz1jHvEA/S2EPqNbsJFSO4YFd5UN8TiOGHry?=
 =?us-ascii?Q?DWKdaHhsituCQ5FH3+jhcBeS/agAHiFGV9fd91XP6k47XGT6SWDSl9SdCzQL?=
 =?us-ascii?Q?dk2uCxxTMG1tvM1oJWdR16VQSQkbVgQ0wPLaHFII59H7lL3Y1Eh2B23V+W8l?=
 =?us-ascii?Q?PeoQRib9P6iDjshqUTfaAF7TMwp9Epo8K/b8ou0I0gXCflaIVCSRADwXLP4Y?=
 =?us-ascii?Q?Dq+60HuQBvj96pLrgp/sT8qz3l2wZVy0XumxgGr0rjjrEOF/m6507osijaMM?=
 =?us-ascii?Q?K8T3iXfsZNK9Jdj/W26W/maqL3onRD/HbTk6GdMUvVjPSI/KfmSgtwUqMFVU?=
 =?us-ascii?Q?UC/oCUZko8j38Vzgs7GAf3WMkVZ61cqWV3HcEbCY6sU43xlofmYkuUKoNA5r?=
 =?us-ascii?Q?j9/zINk9T2xfukRWxsIOL4LOldFeFdF/GSp/G4nMLlgbTNIvd6bDqYh2QVvF?=
 =?us-ascii?Q?q5JglspxNYOTSdYStRVwWuHpgqBWvUSWJshVIB8aBSkN01pwQwXnbztXLkbj?=
 =?us-ascii?Q?StTxZwPp1X/gVLsBmaIoIsOTWVZXE7ZZ/yWP3JQ3PWjuOQ+a4pEFBVsEZDKU?=
 =?us-ascii?Q?oQU3j3cNtJLgb9MgNnLjBEICTJnU1YBRe76t6Pw8rv8NN/klazGRbb5qumVZ?=
 =?us-ascii?Q?Yg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84d11972-d4b6-435a-1a01-08da94c2c17f
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 13:29:02.0068
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Og+h+QqCsQThpQcUApBkIIaFiLgZa9C7XomJ5DJbHTgjV04GDT3/6OCcdKZi6+RPDT8pRzjtEfxiXPr1XcFIgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4173
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_09,2022-09-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209120045
X-Proofpoint-GUID: iFSsciJ60Y0VIyRvSVGGTQunYVKAjq4F
X-Proofpoint-ORIG-GUID: iFSsciJ60Y0VIyRvSVGGTQunYVKAjq4F
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 895e196fb6f84402dcd0c1d3c3feb8a58049564e upstream.

Convert EIO to EFSCORRUPTED in the logging code when we can determine
that the log contents are invalid.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_bmap_item.c     |  4 ++--
 fs/xfs/xfs_extfree_item.c  |  2 +-
 fs/xfs/xfs_log_recover.c   | 32 ++++++++++++++++----------------
 fs/xfs/xfs_refcount_item.c |  2 +-
 fs/xfs/xfs_rmap_item.c     |  2 +-
 5 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 83d24e983d4c..d84339c91466 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -456,7 +456,7 @@ xfs_bui_recover(
 	if (buip->bui_format.bui_nextents != XFS_BUI_MAX_FAST_EXTENTS) {
 		set_bit(XFS_BUI_RECOVERED, &buip->bui_flags);
 		xfs_bui_release(buip);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 
 	/*
@@ -490,7 +490,7 @@ xfs_bui_recover(
 		 */
 		set_bit(XFS_BUI_RECOVERED, &buip->bui_flags);
 		xfs_bui_release(buip);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index e44efc41a041..1b3ade30ef65 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -624,7 +624,7 @@ xfs_efi_recover(
 			 */
 			set_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
 			xfs_efi_release(efip);
-			return -EIO;
+			return -EFSCORRUPTED;
 		}
 	}
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 094ae1a91c44..796bbc9dd8b0 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -471,7 +471,7 @@ xlog_find_verify_log_record(
 			xfs_warn(log->l_mp,
 		"Log inconsistent (didn't find previous header)");
 			ASSERT(0);
-			error = -EIO;
+			error = -EFSCORRUPTED;
 			goto out;
 		}
 
@@ -1350,7 +1350,7 @@ xlog_find_tail(
 		return error;
 	if (!error) {
 		xfs_warn(log->l_mp, "%s: couldn't find sync record", __func__);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 	*tail_blk = BLOCK_LSN(be64_to_cpu(rhead->h_tail_lsn));
 
@@ -3166,7 +3166,7 @@ xlog_recover_inode_pass2(
 		default:
 			xfs_warn(log->l_mp, "%s: Invalid flag", __func__);
 			ASSERT(0);
-			error = -EIO;
+			error = -EFSCORRUPTED;
 			goto out_release;
 		}
 	}
@@ -3247,12 +3247,12 @@ xlog_recover_dquot_pass2(
 	recddq = item->ri_buf[1].i_addr;
 	if (recddq == NULL) {
 		xfs_alert(log->l_mp, "NULL dquot in %s.", __func__);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 	if (item->ri_buf[1].i_len < sizeof(xfs_disk_dquot_t)) {
 		xfs_alert(log->l_mp, "dquot too small (%d) in %s.",
 			item->ri_buf[1].i_len, __func__);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 
 	/*
@@ -3279,7 +3279,7 @@ xlog_recover_dquot_pass2(
 	if (fa) {
 		xfs_alert(mp, "corrupt dquot ID 0x%x in log at %pS",
 				dq_f->qlf_id, fa);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 	ASSERT(dq_f->qlf_len == 1);
 
@@ -4018,7 +4018,7 @@ xlog_recover_commit_pass1(
 		xfs_warn(log->l_mp, "%s: invalid item type (%d)",
 			__func__, ITEM_TYPE(item));
 		ASSERT(0);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 }
 
@@ -4066,7 +4066,7 @@ xlog_recover_commit_pass2(
 		xfs_warn(log->l_mp, "%s: invalid item type (%d)",
 			__func__, ITEM_TYPE(item));
 		ASSERT(0);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 }
 
@@ -4187,7 +4187,7 @@ xlog_recover_add_to_cont_trans(
 		ASSERT(len <= sizeof(struct xfs_trans_header));
 		if (len > sizeof(struct xfs_trans_header)) {
 			xfs_warn(log->l_mp, "%s: bad header length", __func__);
-			return -EIO;
+			return -EFSCORRUPTED;
 		}
 
 		xlog_recover_add_item(&trans->r_itemq);
@@ -4243,13 +4243,13 @@ xlog_recover_add_to_trans(
 			xfs_warn(log->l_mp, "%s: bad header magic number",
 				__func__);
 			ASSERT(0);
-			return -EIO;
+			return -EFSCORRUPTED;
 		}
 
 		if (len > sizeof(struct xfs_trans_header)) {
 			xfs_warn(log->l_mp, "%s: bad header length", __func__);
 			ASSERT(0);
-			return -EIO;
+			return -EFSCORRUPTED;
 		}
 
 		/*
@@ -4285,7 +4285,7 @@ xlog_recover_add_to_trans(
 				  in_f->ilf_size);
 			ASSERT(0);
 			kmem_free(ptr);
-			return -EIO;
+			return -EFSCORRUPTED;
 		}
 
 		item->ri_total = in_f->ilf_size;
@@ -4389,7 +4389,7 @@ xlog_recovery_process_trans(
 	default:
 		xfs_warn(log->l_mp, "%s: bad flag 0x%x", __func__, flags);
 		ASSERT(0);
-		error = -EIO;
+		error = -EFSCORRUPTED;
 		break;
 	}
 	if (error || freeit)
@@ -4469,7 +4469,7 @@ xlog_recover_process_ophdr(
 		xfs_warn(log->l_mp, "%s: bad clientid 0x%x",
 			__func__, ohead->oh_clientid);
 		ASSERT(0);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 
 	/*
@@ -4479,7 +4479,7 @@ xlog_recover_process_ophdr(
 	if (dp + len > end) {
 		xfs_warn(log->l_mp, "%s: bad length 0x%x", __func__, len);
 		WARN_ON(1);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 
 	trans = xlog_recover_ophdr_to_trans(rhash, rhead, ohead);
@@ -5209,7 +5209,7 @@ xlog_valid_rec_header(
 	    (be32_to_cpu(rhead->h_version) & (~XLOG_VERSION_OKBITS))))) {
 		xfs_warn(log->l_mp, "%s: unrecognised log version (%d).",
 			__func__, be32_to_cpu(rhead->h_version));
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 
 	/* LR body must have data or it wouldn't have been written */
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 2328268e6245..e22ac9cdb971 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -497,7 +497,7 @@ xfs_cui_recover(
 			 */
 			set_bit(XFS_CUI_RECOVERED, &cuip->cui_flags);
 			xfs_cui_release(cuip);
-			return -EIO;
+			return -EFSCORRUPTED;
 		}
 	}
 
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 8939e0ea09cd..af83e2b2a429 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -539,7 +539,7 @@ xfs_rui_recover(
 			 */
 			set_bit(XFS_RUI_RECOVERED, &ruip->rui_flags);
 			xfs_rui_release(ruip);
-			return -EIO;
+			return -EFSCORRUPTED;
 		}
 	}
 
-- 
2.35.1

