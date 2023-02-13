Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ACE3C636D7
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Feb 2023 04:08:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjBMEIM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Feb 2023 23:08:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjBMEIL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Feb 2023 23:08:11 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D94D3E396
        for <linux-xfs@vger.kernel.org>; Sun, 12 Feb 2023 20:08:09 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31D1j38A017538;
        Mon, 13 Feb 2023 04:08:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=SxjZvySD+XoKCl80iBM0RetdJ1lhBRKLBipN/AvwbUg=;
 b=p/MKk4EmP3K7enycV52gvZjragMxYz5minOvQiRrd7hy2wRNiNSlcthaheH4WoMQpptL
 hWRHBdd10UJNpY//20UXI5PsyfeuavMx5jyJp3T8cGuIBhvoeKDYbe8tI+DKQC3EnbyI
 aX3KxW7z+PLFkd0ayZYWou1QlCT0OsCU/H+8DHF27l4MAQccrwg9XgjPk0Uu07q+FYsE
 hY9hJOxRvmsAUXPI3RK1GKJOb2EnhE/Gz8BcJ5aMtrEsxCuysf8NI2rZ4id1SMCBremJ
 wM/n62uvDuK0ndoXn4QqNcZ1VXB7SNOJ6RPLqCTvBPgj7Vte2R7gl2yMe7qzk2Nb8az3 Tw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np32c9ukf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:08:06 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31D3APAW017976;
        Mon, 13 Feb 2023 04:08:06 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f42a4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:08:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YSK/gxUKkPTQSJtKI7AxtmkyywGKoRNOTUMNmSXh/3IgMjzbFPh9pOp6dBl6RshFUTACyHWu0fByg2Z8+EUzB++vpv4gJtTQE15hkwiGr6hBu1fDuDm+BdhA25cbQ2ANDqjSmmKmHZsSgZGg8Uv3SFZgZdivAKmND1H78O6ScfAbsajJam19RykDVg6yfWpcTvNwIt59LihIhqbwPoiWFKFUoJk3SgHxlPac5Z53SSFuNDBroXbiMabhSZ5smrpaPHjejtfqHyk7Hmgmi7CaWCfywWuKQNKZWVdBAR0fOLxP4T7jwo3rwk2tfyFv4l+r5sB4RhRq+zzWZD7jaqJcaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SxjZvySD+XoKCl80iBM0RetdJ1lhBRKLBipN/AvwbUg=;
 b=ImB0j2FV1pJAry03jpI32vp3HRcCShzPn4o1RmZBqaQYImOFjvKasn6AT6yOuEBZOBNnCDcpZwRaOr8FiahU+tIOdiJDVrPTPHhNX2txFgZvpwmEs48Ufv76MU7M0pa/+syZNbLfyWjUl7iZtvFSjaKaDJHksBCeTowsn2xwXDSULWwzRIeuN1wNDeQgtgQbcAIV7Bd7rlajmbBEBjHHxjX+4CJTLDcKab3/k3J5NejSvcM7afoHSe8yik5mTS8d+QQDTIoi9gGdaevTYavWltcJWPQnxssXb/FpMU3EtE6wGUmeEbTa8wM7o0iasLEte4jvkkZjfcK/mXBrwuzVBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SxjZvySD+XoKCl80iBM0RetdJ1lhBRKLBipN/AvwbUg=;
 b=cOTjNR+HHZArklp4hP85P8zE42bKhp5ZeNhmG1ve3M1nz4D17x5OOOjK1M+3ID8cunbgaQ384u3/n0IFDrcKKCPrBDNdAJNGLGrlTPm2SNaI3AuLNzUhjFH6t+f3kLmavXqkhFwPTmbhHOOA3P/i9+GOoM2CDU4+wGyP5cPbJe0=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by BL3PR10MB6089.namprd10.prod.outlook.com (2603:10b6:208:3b5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.8; Mon, 13 Feb
 2023 04:08:03 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.009; Mon, 13 Feb 2023
 04:08:03 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 22/25] xfs: ensure inobt record walks always make forward progress
Date:   Mon, 13 Feb 2023 09:34:42 +0530
Message-Id: <20230213040445.192946-23-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230213040445.192946-1-chandan.babu@oracle.com>
References: <20230213040445.192946-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWP286CA0015.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:178::13) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BL3PR10MB6089:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ec9b9f4-6622-4900-07b3-08db0d77e703
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HTs1gjxm0womG6bibD2Smkrlh3zo/cDoJaVZ5G4KfW8F602cth41HBWoSamnLcZcqgbtEV8bLcEs81lsUr0sMSEvIj3BrAs2lpXx+6sOWDEYCaF/GMUmJvOXcRoau/aTn5NRi4dgvhjfWCcEyAYct3lL2DjsQJiZAeA6CGaIQKKx8SJSiD4J7cAmFPUSb7CBpi+C1FaisDFB9AqJNkNxUifv6FfJsOK88TA0Gw5nxFElZ+h86zIWTVP1ogb/vZWvSZwgrFYI2e/ohIoGWt3iN0xwrdq+fCqB9KIRWxQXJ/DIMShlqFq0aDcKE5PbwtdzrcQjnOaamUrCmi0/4eAMkMCBjHQYnJPmxrN3f5uxrSA0F0vj7OpekWJUxthjWtfONGjIG3NM2PzR3bg+9HrHULJSyJ6EWi7iVI48Ia4mhyKsYl8Jdp/SnYXod6/0Ygt5bHAr0iIMTBTjyg8BBdWUaFH7GwK453slZhipldfhYLlumQhk1TOxEQbMwkWB3am4wohCKqrTVnJ++1fc9119rKVYAnuwu91buyZLnNZ+i4Qs71Y5S2DwgbRl7YXlE6VY6gWjSpSX7TyJ0TbL8lUTBAM0VHvdsdv9YLgRYxcWQsBrcepQkoCIM4gEFmsdQM8A0x8v7VBE6LqAtQBkD0qvPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(136003)(366004)(39860400002)(396003)(451199018)(86362001)(36756003)(38100700002)(316002)(8676002)(4326008)(8936002)(66476007)(5660300002)(41300700001)(66946007)(6916009)(66556008)(2906002)(2616005)(83380400001)(478600001)(6486002)(186003)(26005)(6666004)(6506007)(1076003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SeAgIUswV30Cp+FOkfnsrb/Oov+YnPYCbIGhNhny4I6hZAn5G3zrZhNhYM+5?=
 =?us-ascii?Q?bo34Fz3VdgyqKRLhdxxD+DzLc3FwfZZW8K/wzy5ft8GCfWu799ejwBNbmyOP?=
 =?us-ascii?Q?J+dWth0B+3cumtItqHkoQYmZbc/PmlDd6YPRqXtERqz5cEDG1IyWDidhT5+6?=
 =?us-ascii?Q?1nLklQAejfcNaJr+Dg0lCidxzzpz6J0VGPiQRK08GRo+Nq9l91XL6YLXcXIx?=
 =?us-ascii?Q?dIvhuG6mdOTQkgU18ktT64TXS2GlRf9bTKK086YTRfkd6DueIvFO26rZnf8w?=
 =?us-ascii?Q?uHUorqxaoxcxh7KiKFSLTKpBWcG5nx5HmSMcvRU3rq7QmpFaDrHDnSGKbjg9?=
 =?us-ascii?Q?Dm8Px61MGGmrkJuNxvrHIU7fgb491IoPMk3b2anRNgmQF9b1PxaC91veJQO9?=
 =?us-ascii?Q?55joasNmLzLTq66xrf0hvv6Qwc6BNFZkpFFRkG2OaG6aK7oQKC5z6wmcC4Tk?=
 =?us-ascii?Q?MvIwsmkfS5JRne1HOLd7PbvTtnvyM2wLGkazy9+z7oixaQa0/0v9dRBXuaBi?=
 =?us-ascii?Q?Z+7Oqbafoqm4CrrBY+4J3eagpUohj8xUduFuFQMr4wyEJCdIVfx+vELELgPY?=
 =?us-ascii?Q?Cz+k+WjvbfD4lziW1JNzqOStUbArCD4WqL5sJ/plFuHaMVEEydXkHUB8nL4P?=
 =?us-ascii?Q?RtbQM44TO3XIvPa5fps8vPdOOlAMHHTIPHBV6mEApEUI5xs2My5A2Yf5uY3i?=
 =?us-ascii?Q?qLLmRTVAAwwjugAOxoLBfOxhspy10ZhTMQVgsqw9oVs7lrTBrblFYOx+lmvH?=
 =?us-ascii?Q?RXLbFXTACRnQRagezQmnJ/pVBKxSEvmBlV1uHyS/zamDx7HBWf+EKDgRuMs2?=
 =?us-ascii?Q?b8DPGFvw9xzWaDUUVzpBHzGgF8A6rLPqpA2C9thuf77KmR2pVuJP5P9LaEzC?=
 =?us-ascii?Q?d+NeeYhcEGRvrm6IbWf+p0BbDcQZxt7uBHGI1MzYBN6tUR88vjR5hMo7hy9a?=
 =?us-ascii?Q?p6dRfiH4oURgY9B8S/KCzYE/qSqIZAFXWrayf/GdbmipGt/0qMW5ZSU/1iLY?=
 =?us-ascii?Q?vYcddDPYZjx8i0vv82Nn3SEsM7/1HKIQIgQmBY4TOJNOUDQ82/3YVAPq1AQY?=
 =?us-ascii?Q?O2yRSkXUcNZW498lEVhIAARePGtBCr3YKyWc4IqeCd3oC6X1svMcfpDI9eBg?=
 =?us-ascii?Q?B31YnNv2GbFeYluow0X4KcP1EBLnJ2qNpGc8t9tBcEkYOuhllsL1SRX+8xI/?=
 =?us-ascii?Q?zc0rJK2X90UV4Vdlwd6O9xxCbfyz3bSQS3y/UVI32C5nT343YN+KOovEcCj3?=
 =?us-ascii?Q?7TjKd5c3g45KBXb3v7Wnx3nI0pgfcmru9/jIAyLX3nCanPZCB8b0Wn2KLzKI?=
 =?us-ascii?Q?DXQuaVcYUtlXyNH0v8R4m6LP2HtFcFs6wwAODpHyk9yuhjxPXLh2XM5sGQZH?=
 =?us-ascii?Q?GqTgWCAzP1k4uhmXTBkZdTyX4GRExe861zYPDOndD3XkIO1cUFv5mqo8+8yg?=
 =?us-ascii?Q?Fpz9WY8I4qU29HeSKy8AzlCEwznT/xKxnNVfvbwXy4B4oGGfIgaKkgSpY9NJ?=
 =?us-ascii?Q?MNd20rpcja1Vx25+I0jBFv442RSV0OvCdVzpf14XItGIWG3+qHHIXBaPTRci?=
 =?us-ascii?Q?N7HJuawSo3GVY2/RgQPZ0BLVmaN5M7DSg2raakAoKTkA631B1wY9dbMrfKf5?=
 =?us-ascii?Q?yA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: FnYCnFZCRg2beymv9EYqXrErEueKNU0KOGpvVl9M8ysKFjQkqAHHZKEdk4M+/QYhqxnmnz/jWyngN3+1v2MOUTpwJ6grHNjrw7wUaW1u2sgxTvoNm+gah6+5UXcczJVDdQoiifnkJPg75HZrlANnkqdRHD2drDhA7N3HH81jf0qkH/3lV6OuNm6lUcurVQGM/4j2dYeh7FHhaKTAMoYz8B70I0fnciVNYNNtCl6/zRNiPFpVBaCRzlvQWk/nT20075VJyHHJjGlUXIHnfYAF1Q/q1/fhPGGKGIRk9jwDS8HoJX3YeYN/PlZpuBM6qMs/c3F14pQwMyXxylbbUZOCgYmPZsweLIyfE8dzPallBHukXZuMyROQMWFOPzO2MPBSgKJpKeANbaz71K6d4W7j5DZPziQ4/8Zt3dH2WZjlM6N2itVNoro3Gsd9/jnTdOUMnacbIiNvsKjaVjmf6KV16f5ooDilaxmKCCXShmQxsMqU9hO0lz+7Sx77QebO1Q6Uz7RKuqas8r1yvUbpm71zGVuvN6ELAUS6ISi04oT92pTULqQutBJlgCxZl5lnvdtHvPdFviyzNnWmAI2uZN99hbhAWSJejcvi1vwDzSAGRMbYLgcX1Rqlf7/6Bq7rbsNV0eUzLpGmV5nMmWUfNxXBKfE58IOTZ4hzrox7t2fbHX8nYhNONR5RYsl9xM8yn9ss+JO6nhYo7rNYkyPte7Embk0rdO4e90ydTqnEGybaZwgHhA194aE3IDnF06eLtmN4yOYk+AGpdN2eRoyhX7qQ9s0U193kPFc7he13cdpaX/nlMg2z/+zeTL9gqOTJS0NT
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ec9b9f4-6622-4900-07b3-08db0d77e703
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 04:08:03.2155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QSJXd1ABbzw/rtiqMqdgnvcbAsB8B988YCJ2lhZ/g5l22TnRTNk1NCqzUh7nn1lIiwVJIqSlB/FgzJOXQXr4dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6089
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-13_01,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302130037
X-Proofpoint-GUID: s9wxYrhe1SsveIw1W2UtrWUMtpxwXwwQ
X-Proofpoint-ORIG-GUID: s9wxYrhe1SsveIw1W2UtrWUMtpxwXwwQ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 27c14b5daa82861220d6fa6e27b51f05f21ffaa7 upstream.

[ In xfs_iwalk_ag(), Replace a call to XFS_IS_CORRUPT() with a call to
  ASSERT() ]

The aim of the inode btree record iterator function is to call a
callback on every record in the btree.  To avoid having to tear down and
recreate the inode btree cursor around every callback, it caches a
certain number of records in a memory buffer.  After each batch of
callback invocations, we have to perform a btree lookup to find the
next record after where we left off.

However, if the keys of the inode btree are corrupt, the lookup might
put us in the wrong part of the inode btree, causing the walk function
to loop forever.  Therefore, we add extra cursor tracking to make sure
that we never go backwards neither when performing the lookup nor when
jumping to the next inobt record.  This also fixes an off by one error
where upon resume the lookup should have been for the inode /after/ the
point at which we stopped.

Found by fuzzing xfs/460 with keys[2].startino = ones causing bulkstat
and quotacheck to hang.

Fixes: a211432c27ff ("xfs: create simplified inode walk function")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_iwalk.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index aa375cf53021..1f53af6b0112 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -55,6 +55,9 @@ struct xfs_iwalk_ag {
 	/* Where do we start the traversal? */
 	xfs_ino_t			startino;
 
+	/* What was the last inode number we saw when iterating the inobt? */
+	xfs_ino_t			lastino;
+
 	/* Array of inobt records we cache. */
 	struct xfs_inobt_rec_incore	*recs;
 
@@ -300,6 +303,9 @@ xfs_iwalk_ag_start(
 		return error;
 	XFS_WANT_CORRUPTED_RETURN(mp, *has_more == 1);
 
+	iwag->lastino = XFS_AGINO_TO_INO(mp, agno,
+				irec->ir_startino + XFS_INODES_PER_CHUNK - 1);
+
 	/*
 	 * If the LE lookup yielded an inobt record before the cursor position,
 	 * skip it and see if there's another one after it.
@@ -346,15 +352,17 @@ xfs_iwalk_run_callbacks(
 	struct xfs_mount		*mp = iwag->mp;
 	struct xfs_trans		*tp = iwag->tp;
 	struct xfs_inobt_rec_incore	*irec;
-	xfs_agino_t			restart;
+	xfs_agino_t			next_agino;
 	int				error;
 
+	next_agino = XFS_INO_TO_AGINO(mp, iwag->lastino) + 1;
+
 	ASSERT(iwag->nr_recs > 0);
 
 	/* Delete cursor but remember the last record we cached... */
 	xfs_iwalk_del_inobt(tp, curpp, agi_bpp, 0);
 	irec = &iwag->recs[iwag->nr_recs - 1];
-	restart = irec->ir_startino + XFS_INODES_PER_CHUNK - 1;
+	ASSERT(next_agino == irec->ir_startino + XFS_INODES_PER_CHUNK);
 
 	error = xfs_iwalk_ag_recs(iwag);
 	if (error)
@@ -371,7 +379,7 @@ xfs_iwalk_run_callbacks(
 	if (error)
 		return error;
 
-	return xfs_inobt_lookup(*curpp, restart, XFS_LOOKUP_GE, has_more);
+	return xfs_inobt_lookup(*curpp, next_agino, XFS_LOOKUP_GE, has_more);
 }
 
 /* Walk all inodes in a single AG, from @iwag->startino to the end of the AG. */
@@ -395,6 +403,7 @@ xfs_iwalk_ag(
 
 	while (!error && has_more) {
 		struct xfs_inobt_rec_incore	*irec;
+		xfs_ino_t			rec_fsino;
 
 		cond_resched();
 		if (xfs_pwork_want_abort(&iwag->pwork))
@@ -406,6 +415,15 @@ xfs_iwalk_ag(
 		if (error || !has_more)
 			break;
 
+		/* Make sure that we always move forward. */
+		rec_fsino = XFS_AGINO_TO_INO(mp, agno, irec->ir_startino);
+		if (iwag->lastino != NULLFSINO && iwag->lastino >= rec_fsino) {
+			ASSERT(iwag->lastino < rec_fsino);
+			error = -EFSCORRUPTED;
+			goto out;
+		}
+		iwag->lastino = rec_fsino + XFS_INODES_PER_CHUNK - 1;
+
 		/* No allocated inodes in this chunk; skip it. */
 		if (iwag->skip_empty && irec->ir_freecount == irec->ir_count) {
 			error = xfs_btree_increment(cur, 0, &has_more);
@@ -534,6 +552,7 @@ xfs_iwalk(
 		.trim_start	= 1,
 		.skip_empty	= 1,
 		.pwork		= XFS_PWORK_SINGLE_THREADED,
+		.lastino	= NULLFSINO,
 	};
 	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, startino);
 	int			error;
@@ -622,6 +641,7 @@ xfs_iwalk_threaded(
 		iwag->data = data;
 		iwag->startino = startino;
 		iwag->sz_recs = xfs_iwalk_prefetch(inode_records);
+		iwag->lastino = NULLFSINO;
 		xfs_pwork_queue(&pctl, &iwag->pwork);
 		startino = XFS_AGINO_TO_INO(mp, agno + 1, 0);
 		if (flags & XFS_INOBT_WALK_SAME_AG)
@@ -695,6 +715,7 @@ xfs_inobt_walk(
 		.startino	= startino,
 		.sz_recs	= xfs_inobt_walk_prefetch(inobt_records),
 		.pwork		= XFS_PWORK_SINGLE_THREADED,
+		.lastino	= NULLFSINO,
 	};
 	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, startino);
 	int			error;
-- 
2.35.1

