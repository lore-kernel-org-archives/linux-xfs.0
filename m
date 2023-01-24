Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52D93C05027
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Jan 2023 01:36:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbjAXBgt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Jan 2023 20:36:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231610AbjAXBgs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Jan 2023 20:36:48 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED801ABFA
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jan 2023 17:36:47 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30O04YLw013521
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=6GP8mJBw+M/AN5gzsRzuXZkkeJob7qVdrYUi7TC2yiA=;
 b=IDyIZRhNp5heyfjutD+90eq8Pj+7j0AYbaGnz7pfGNzWT/KCdBjAyTXCoQr+n4PmanaS
 WVcRLunis6Bqwtp28f5Mco5Ifu8QDMlW7YI6acDH1T4Yoo+MjOpInRW1OmSixvxASHoz
 h6G2jUF6YrU/UX3Uiio5y20dOGrfN3LVIQNhtKaSkpE966bNwRSahX9sFxXWSoXLjmAU
 I1UWmzJQPaPDWEZMKDh80lmLoxuh1oALVyLtIoT2CbXkNVcPPnFcE0XqWPyxUZXFNGzJ
 3IhlQ2MhOMqeRFG3MA5GH1avgfuSoKYp5x4q9I4tXtLz6PXeQxTKPd1h4mmpRicaGbNu zg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86fccbxv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:46 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30O1V73s040249
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:46 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2043.outbound.protection.outlook.com [104.47.57.43])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86gb4b1u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PcCSpo3sFt4gEpvbfUWi3ICGZ85c2XEaH4LSdHP+gLayYKf8sUp26br7lHXUqINtBs5aIdWXUcqZSEEUEwWMiil6BosjYvHjyOrtLp3n2yYldfDpHl8wj6wiDy6sX8S5P8aNQQZo2AbVnNg7hfECD1XzSp8MFw2vz8LJrGLRavkLQMQnl9jFKiPyE8cGS0Wz9FvSPI0E7Saeszryf4gbzRbr9VaM+Z5Uc5Efrfps9jL8hYrg0/9ngHG/jUBUZakRBa5jnNtxlMlUoUG0c0F6Eno0U5dHzqMIDaUSeUSsqA6J4AKvJgzAz7Tq3Pg2NgaZVlV/wl5x0zCJTlotS6J7dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6GP8mJBw+M/AN5gzsRzuXZkkeJob7qVdrYUi7TC2yiA=;
 b=MF3F8+7hvZpzXVE2ekwq1nrtcG3MDeuxKx8wNGoboBHHeELaZsavHs+kLOUJlAEJPKaTpDUIS97Y0uD1SweUnGlWFgvUyF/C396wcBo/tLPGP/xjXTLlwd4yjwDE0ZdE/JPjeIThMRv2QVgsRYF37R0eoe5U8BligwP/36bRHBwL1Dae02aUmvFzy9g3heKRIW/jKMOHW+aQbapppHq3Rt/Nc96ABlCWwQbWNlO536TJJpf6wTQOKMdU2IYFhNJGpRdQEosBXjQlMkzMF0wPFUA5UAFTTClKPowrraZB30Qr35PdiwFKP3yZ0Ikr2wmrg+JHTIE7AmcXDXowTMmN+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6GP8mJBw+M/AN5gzsRzuXZkkeJob7qVdrYUi7TC2yiA=;
 b=nWMoomKVkrHDOR6zL1/4n5AUouK0xypCIs/a8hQ7XjDZt8nkcl+2OBoxQnoxOnWhYUNqQpP/Xr9A2fTW039HMLOrkQxY3EI8RLK87h+nLYZXxqkza6mdeCG4l7YvArdhPdnmZL8nUR1Q+xobtd1b41vEPfLHU5SkCpueFar54Z8=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SN7PR10MB7074.namprd10.prod.outlook.com (2603:10b6:806:34c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.8; Tue, 24 Jan
 2023 01:36:44 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6043.016; Tue, 24 Jan 2023
 01:36:44 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 13/27] xfs: Add xfs_verify_pptr
Date:   Mon, 23 Jan 2023 18:36:06 -0700
Message-Id: <20230124013620.1089319-14-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124013620.1089319-1-allison.henderson@oracle.com>
References: <20230124013620.1089319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0P220CA0001.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::7) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SN7PR10MB7074:EE_
X-MS-Office365-Filtering-Correlation-Id: 3207fb2a-f2a4-4691-cc06-08dafdab7337
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L3QnD43CHreYp2++GT4zUJtm2bP0vHPKnI8IUeF0oEqAdbtnsG2b6MxGwFvBI4MeIamIdQmHzwg5gwKvHXQsrU8Y8n9yGFEcW0CfIzsePgGY6aLGAi90Xyhy0MQmAYsQ1K3CD8PySbSw4lDIn3vwWENa5VlhmuAoTWPdvrsdTU8K9fqKHuMXM7BrsxxjUWOiB2E73hvGZzqQGazugEi2XQbEhx85fVQIx3HMwbLinoLcLc65ZS1r68YV7w5HA2s1EObbz77SB3qZGJ3DW/zcdX/rsoUxhCDEHK87BwVnkng19ysQKFWNQwPQ9/Cf63+s+G59l7r+K27Q/6PT5f2sbIbD/wrgW9b3iIyELapS3psTLn4lyP7vDxoH9c1Oc1eI265/LA4RUvpc2rZq34Q5Fg7E7Z11lUPlQPqgybpeCgYY7dKpWY9bgeN0PdNxydhLw/1ZY75LWOHhZ9ioz6yVECANX9+xvJaVQNgIze1LwE5/n36PjVJM1zE2tkcwQiFUK9f5eNOcqbTNc5SNJ4tZky8aBf9WBVwvxW9cEg2ChWkhNanijVaTHPkAODkzE8hyX5CZkX890ZpbFMGbZSL+zMKfib+KbfJAy5IL9hw1XH7R2fx945si2P7uY0ELFvCbx33yHaFb62ZnsFGMDsSNig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(346002)(366004)(39860400002)(451199015)(66556008)(66476007)(83380400001)(6916009)(8676002)(66946007)(41300700001)(86362001)(36756003)(1076003)(316002)(2616005)(2906002)(38100700002)(5660300002)(8936002)(6512007)(6486002)(26005)(9686003)(186003)(478600001)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ugl8Fxp27ndw4Ijptm/0t5QOfoj3euY8ACVOVU/DbyOkjDcmwABRuuBunFNQ?=
 =?us-ascii?Q?xLo3jqwH7p3Sx/X8rT8G3d+zbjORkWdkkE9rdozDP96Aq132A8MkBBkeNNd3?=
 =?us-ascii?Q?8YoJafgXdpglBAMEGz+9oSwmDDXU9f+XzIu5lf3YoHQw500YXuce+xlZFHQt?=
 =?us-ascii?Q?cRYn2cnC7gWUDg5x3coxA953JRpta/XAFIzQCJgDcp55W4Kb0K3LN+vKEccU?=
 =?us-ascii?Q?uWCknXyAGotcYDvgPjb2b2wFz4Fkkmon9sZE3UJV7BB3bJnnaxUMYlB76T2R?=
 =?us-ascii?Q?uBaBfQzQbVQv8D5m0j9qkUJtZzr7RqU9cLw21lQcGRGYhfjryiiuzbb0D1pw?=
 =?us-ascii?Q?+D40rfXFcVNrznuFkCElCYrNUBYTOplUeVDsT51LZHXHtU9TgBEwQ0tRCIYb?=
 =?us-ascii?Q?RlyHMyfJj1oY8XVrRzGZxXujSq5ZPUM7SfL11g599b59oCe82LLMPzIX3Xml?=
 =?us-ascii?Q?wCwVQYsrP8SGuZNa0WWfj1ShZvkZND8k2DiUpnGPZhMnq7BnxdD1zA2+2h0N?=
 =?us-ascii?Q?rEXoysFgn/4eX0HSqUsjJd8r+ICmo0jumD48810vmRlm2ooy0QOosT8NL95S?=
 =?us-ascii?Q?JXdlA4Rv9TnD/+y5GRqDELfZUXF+0jLAg5mnZk3lIuy5YWpTnK6+BvnpjUmG?=
 =?us-ascii?Q?UJ+IsbkPRe7SzPy4Zg/Ugff3IQL2KVB2UnPdSFvjb8WTFcIWwyY2+dgt3V99?=
 =?us-ascii?Q?wXDIIUOd9DiT01hIreEDChSQSd8p0zv/RmRQHgP5MgqhvRF6IfLRiP3FPhW0?=
 =?us-ascii?Q?HTgfNTvyaeS5FoNXhE5t6FfsEL2EeilrNOgBF3VznhYr5oeI5sfhMFd5UWXI?=
 =?us-ascii?Q?myU06n9UxOm9giyaCflQGI9Ant6bhf6sDtIyLDv/KXlTBiUvWDKE9bnlZ3fd?=
 =?us-ascii?Q?d1rxbOBg0lhAdqz6D61fAAY+OiCOdAXxiknFY9ym+XAoMQgC5DFqqboF40Ia?=
 =?us-ascii?Q?HT7QB65OuZ935UoSNp/twn97uA9KX4cuY+Kbh6OtgNuvbTrIjGqdBQ/h1b2x?=
 =?us-ascii?Q?6GZ/Pzq2NQhT0XnYhnT+1Kly7goan/GR+WNJQi77eK4JC5+uk0qL74AZ8/Ww?=
 =?us-ascii?Q?6P42Bh7HF1hFkzyu7M2kXr9u8gSvqwEoU+aB7mHAIbQ7LgdAv0nq/CGoXINN?=
 =?us-ascii?Q?aczf+raubb9KCljKJC+wxg1A13/cn3GoG5nh1rzl+0qwxL24iLouT3ZEmSu2?=
 =?us-ascii?Q?m7iRswEdgAJEB6bcn3SXHZQAYJa7gOQI3TwNDdxLcqcQIMiKc8mH9fCeD7DQ?=
 =?us-ascii?Q?pNjYljsjCCOW8Qg3m6Aox5ceDdkf6diO1Ur8KvdaKVEM5ulhYdFHpRIJ3WSU?=
 =?us-ascii?Q?uwK4ZmCrOGBjZ8WkBThdPpQjqASsWgV2PNfPK1PTk4punAJO3bsmA3VDkG4R?=
 =?us-ascii?Q?ubjc5mORenYK4zXJjDDkqtmfTdV1VUlIQ0qkcwc7OZOCRgQAT/jAaWMx/QbQ?=
 =?us-ascii?Q?sy3zn4zaffmtwmHJE8MSRYRQ/BWAMvgpXDKEdv6vXEHgHq0ruAkZpmyDHEQN?=
 =?us-ascii?Q?nrFnvDfkVgn+4YRhvuxksqAbwcsNXkMrvYdZhnZhfin+vUEcsX13I77vNYGL?=
 =?us-ascii?Q?h5yZtH9xOTrJOgzxdraEtwIiXu4tq7+qpv9QbI7gBa/8+MLpKrk+y7Zt3x4N?=
 =?us-ascii?Q?ew=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: wOBbHmYqcPldMCwexs9NO+dynxDa/8M4d046H2RVvJN0jBp1fKv9GMZ+XTn44zKgubN5eFJR8//2uSbwEV2wOTTatiZc2t4HOGqPp69CmVviSrBb1T6Sdw8UxFn6dU/1hNs1++QKZFXBLHS8Nzapao7idbFOfaYv1dwx6M+K11guk1auNwfnbbiB7W6irj863mxdhe7TcLg9ajdUmGowJqhzkqs4tuAAsl8nEBpQ6O7RZw9jph8UNvr3wXzFd6D13Y0c+rN26lqI3t73IwFrOQXmIh95nttiJscfAGC0dZUTIGg32WVuau9KjJWqKZZCNaTlmFhj1UgJTX8w18gegBZJjZ6pHbvkIxYqwbWHAgtLn2Dr9FOGDf35Aoz5wmHD3YkuT10DhFqzyECClCsZNgihJSwnCS3WJ2e5a9zm2I2hPkCtPmE5mR1sJ7moFvHcxImj3k6dB+a0CSJdSZJH57geHkNNX6thQp/OzUf72rprA19/bTqRM7+b3z/5T++iBhRPLJKYNfLpGTjM97QmrCTFmny3IHrimCVF8R+CvyJOLEDsuN2eb0BSVEwJ/nhRwnEw3SqLqU8vOtvCSuYC81Alf2mpjrTPzxUvgcJD8Hk2mCrN/5lteY32WQU1t/PZUullj7E6JHTstLUbNpK0bO8d70xMXu3/uCC1bFa8rDJkNpSYbSi1OqLvzsVyyVXwg5FjH7ld6PEWLT8FjHhhchoYPkEFM7fm9zDnp6Xu8FrZ/4/6J+mLWkgxXgjHN3Ol1kmm2YcrtJp/1w3HXp/60w==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3207fb2a-f2a4-4691-cc06-08dafdab7337
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 01:36:44.2975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M+VSWq5QOdS81xaBki1mzY6dtIp9IeBdNK6RE63p4CH53ysIiT7tmcHglOthALPU6IKLlsvvvAIxTB6epNgk7RMH+C1i5uMVhdsGjfW4I14=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7074
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301240010
X-Proofpoint-GUID: TfMeJR1jiam_deo1aSlSY-pq5m8rF5x4
X-Proofpoint-ORIG-GUID: TfMeJR1jiam_deo1aSlSY-pq5m8rF5x4
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Attribute names of parent pointers are not strings.  So we need to modify
attr_namecheck to verify parent pointer records when the XFS_ATTR_PARENT flag is
set.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c      | 47 ++++++++++++++++++++++++++++++++---
 fs/xfs/libxfs/xfs_attr.h      |  3 ++-
 fs/xfs/libxfs/xfs_da_format.h |  8 ++++++
 fs/xfs/scrub/attr.c           |  2 +-
 fs/xfs/xfs_attr_item.c        | 11 +++++---
 fs/xfs/xfs_attr_list.c        | 17 +++++++++----
 6 files changed, 74 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 101823772bf9..711022742e34 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1577,9 +1577,33 @@ xfs_attr_node_get(
 	return error;
 }
 
-/* Returns true if the attribute entry name is valid. */
-bool
-xfs_attr_namecheck(
+/*
+ * Verify parent pointer attribute is valid.
+ * Return true on success or false on failure
+ */
+STATIC bool
+xfs_verify_pptr(
+	struct xfs_mount			*mp,
+	const struct xfs_parent_name_rec	*rec)
+{
+	xfs_ino_t				p_ino;
+	xfs_dir2_dataptr_t			p_diroffset;
+
+	p_ino = be64_to_cpu(rec->p_ino);
+	p_diroffset = be32_to_cpu(rec->p_diroffset);
+
+	if (!xfs_verify_ino(mp, p_ino))
+		return false;
+
+	if (p_diroffset > XFS_DIR2_MAX_DATAPTR)
+		return false;
+
+	return true;
+}
+
+/* Returns true if the string attribute entry name is valid. */
+static bool
+xfs_str_attr_namecheck(
 	const void	*name,
 	size_t		length)
 {
@@ -1594,6 +1618,23 @@ xfs_attr_namecheck(
 	return !memchr(name, 0, length);
 }
 
+/* Returns true if the attribute entry name is valid. */
+bool
+xfs_attr_namecheck(
+	struct xfs_mount	*mp,
+	const void		*name,
+	size_t			length,
+	int			flags)
+{
+	if (flags & XFS_ATTR_PARENT) {
+		if (length != sizeof(struct xfs_parent_name_rec))
+			return false;
+		return xfs_verify_pptr(mp, (struct xfs_parent_name_rec *)name);
+	}
+
+	return xfs_str_attr_namecheck(name, length);
+}
+
 int __init
 xfs_attr_intent_init_cache(void)
 {
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 3e81f3f48560..b79dae788cfb 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -547,7 +547,8 @@ int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
-bool xfs_attr_namecheck(const void *name, size_t length);
+bool xfs_attr_namecheck(struct xfs_mount *mp, const void *name, size_t length,
+			int flags);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
 			 unsigned int *total);
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index b02b67f1999e..75b13807145d 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -731,6 +731,14 @@ xfs_attr3_leaf_name(xfs_attr_leafblock_t *leafp, int idx)
 	return &((char *)leafp)[be16_to_cpu(entries[idx].nameidx)];
 }
 
+static inline int
+xfs_attr3_leaf_flags(xfs_attr_leafblock_t *leafp, int idx)
+{
+	struct xfs_attr_leaf_entry *entries = xfs_attr3_leaf_entryp(leafp);
+
+	return entries[idx].flags;
+}
+
 static inline xfs_attr_leaf_name_remote_t *
 xfs_attr3_leaf_name_remote(xfs_attr_leafblock_t *leafp, int idx)
 {
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 9d2e33743ecd..2a79a13cb600 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -129,7 +129,7 @@ xchk_xattr_listent(
 	}
 
 	/* Does this name make sense? */
-	if (!xfs_attr_namecheck(name, namelen)) {
+	if (!xfs_attr_namecheck(sx->sc->mp, name, namelen, flags)) {
 		xchk_fblock_set_corrupt(sx->sc, XFS_ATTR_FORK, args.blkno);
 		return;
 	}
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 95e9ecbb4a67..da807f286a09 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -593,7 +593,8 @@ xfs_attri_item_recover(
 	 */
 	attrp = &attrip->attri_format;
 	if (!xfs_attri_validate(mp, attrp) ||
-	    !xfs_attr_namecheck(nv->name.i_addr, nv->name.i_len))
+	    !xfs_attr_namecheck(mp, nv->name.i_addr, nv->name.i_len,
+				attrp->alfi_attr_filter))
 		return -EFSCORRUPTED;
 
 	error = xlog_recover_iget(mp,  attrp->alfi_ino, &ip);
@@ -804,7 +805,8 @@ xlog_recover_attri_commit_pass2(
 	}
 
 	attr_name = item->ri_buf[i].i_addr;
-	if (!xfs_attr_namecheck(attr_name, attri_formatp->alfi_name_len)) {
+	if (!xfs_attr_namecheck(mp, attr_name, attri_formatp->alfi_name_len,
+				attri_formatp->alfi_attr_filter)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				item->ri_buf[i].i_addr, item->ri_buf[i].i_len);
 		return -EFSCORRUPTED;
@@ -822,8 +824,9 @@ xlog_recover_attri_commit_pass2(
 		}
 
 		attr_nname = item->ri_buf[i].i_addr;
-		if (!xfs_attr_namecheck(attr_nname,
-				attri_formatp->alfi_nname_len)) {
+		if (!xfs_attr_namecheck(mp, attr_nname,
+				attri_formatp->alfi_nname_len,
+				attri_formatp->alfi_attr_filter)) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					item->ri_buf[i].i_addr,
 					item->ri_buf[i].i_len);
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 99bbbe1a0e44..a51f7f13a352 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -58,9 +58,13 @@ xfs_attr_shortform_list(
 	struct xfs_attr_sf_sort		*sbuf, *sbp;
 	struct xfs_attr_shortform	*sf;
 	struct xfs_attr_sf_entry	*sfe;
+	struct xfs_mount		*mp;
 	int				sbsize, nsbuf, count, i;
 	int				error = 0;
 
+	ASSERT(context != NULL);
+	ASSERT(dp != NULL);
+	mp = dp->i_mount;
 	sf = (struct xfs_attr_shortform *)dp->i_af.if_u1.if_data;
 	ASSERT(sf != NULL);
 	if (!sf->hdr.count)
@@ -82,8 +86,9 @@ xfs_attr_shortform_list(
 	     (dp->i_af.if_bytes + sf->hdr.count * 16) < context->bufsize)) {
 		for (i = 0, sfe = &sf->list[0]; i < sf->hdr.count; i++) {
 			if (XFS_IS_CORRUPT(context->dp->i_mount,
-					   !xfs_attr_namecheck(sfe->nameval,
-							       sfe->namelen)))
+					   !xfs_attr_namecheck(mp, sfe->nameval,
+							       sfe->namelen,
+							       sfe->flags)))
 				return -EFSCORRUPTED;
 			context->put_listent(context,
 					     sfe->flags,
@@ -174,8 +179,9 @@ xfs_attr_shortform_list(
 			cursor->offset = 0;
 		}
 		if (XFS_IS_CORRUPT(context->dp->i_mount,
-				   !xfs_attr_namecheck(sbp->name,
-						       sbp->namelen))) {
+				   !xfs_attr_namecheck(mp, sbp->name,
+						       sbp->namelen,
+						       sbp->flags))) {
 			error = -EFSCORRUPTED;
 			goto out;
 		}
@@ -465,7 +471,8 @@ xfs_attr3_leaf_list_int(
 		}
 
 		if (XFS_IS_CORRUPT(context->dp->i_mount,
-				   !xfs_attr_namecheck(name, namelen)))
+				   !xfs_attr_namecheck(mp, name, namelen,
+						       entry->flags)))
 			return -EFSCORRUPTED;
 		context->put_listent(context, entry->flags,
 					      name, namelen, valuelen);
-- 
2.25.1

