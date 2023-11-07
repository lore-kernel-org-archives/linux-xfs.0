Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B46BC4332F
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Nov 2023 07:09:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233550AbjKGHJB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 02:09:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233518AbjKGHI7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 02:08:59 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2824FFC
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 23:08:57 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A72NlOm031854
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:08:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-03-30;
 bh=/KP32ZJg7SDQdPTH1tDHHHVFET+KgjOaSgavp0Oa2D8=;
 b=qfWqxZrIBPs0VnI7Lkk+afuz6HqevyfWtE4gtToFdp9gZMZaJdZBKzq9kpum8Gm6QGV6
 avliIi9ybyxLy9ok7gcsrmnYJJjmRQCJpC6Au5/g5TYEW24QZHml2vbZ0pD4Odm1rsvH
 VAtnuVlEcR2IRPzbxqPVHuSUwZYL2DyJRW+xtNi79/OVG2J06s6CnGsTvSDWfPMUkT58
 IJfaHiJfXiZOg/NnX45nXG0SXc6Mr94p42/dUO+85TXswgXj3aMaZTSMq6t5mZpABhij
 NL++6KVdm+17PHwamnMkX7wmc0rZatdVw2O7yXGahUkBz85USVSuaTVkbA4R+8EoCK1P VQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u679tm2ku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:08:56 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A76PYvv030550
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:08:54 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cd63fev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:08:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NhoG4ScGs0KQ+Xz5M9rmn0qnQIUTugQ+eX9MBkhlocm63PO1sys2vxbfBxfCK7v3WlMQ36TY/0AuUU9lS3FI7Uf6FjefQ4q5xyAyp9PbFGi/A6IMxRt4otir/mLEpmkWgp0ugq3Y8zHQEH2NI6w96E9jJt95aqOME6jS68M8WwBOLjdJ6LHSOY20NQAiza6dAR8sQ9/gicszD7OTtYfY+6uX9pGBXjYbvUX2N7aI2q5jve/TI8DhtHwTnsfi/Dmo4yuzL09QpTfEawNorpzX9gKWI+gWNTKjOSSnAdutMmw8cbbKVM/HxzlhcRk0XNRPQxp6+/8zxA9YVtl6lAyewQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/KP32ZJg7SDQdPTH1tDHHHVFET+KgjOaSgavp0Oa2D8=;
 b=DXLPt60ry4/aXCHKmsJCT3KfP1g5NB5EHbZPYA0UMX+bHmrYWff9nPjdppmw0LdwEvokmLIGz8swVoQax6GFzD9lDedzDkD3FBTvLBq+1O4stYdW/ee+q8in/HCVtjTxiW9on0nbrENiYt1L+9lKX2q2lrKfuOZ/gLEFJKp28M+mtaHK8ZnPJZXNMQiP6q4DIP+95Pvm2j8t5R9+oN/J20WgPbEGrHNLoX6Bfd4HOPlQhcr/kIqRMVxifgkWVqY6XbZ1L6gRALAW7M6icoc91LeROBtXjiZLQftkOBjrXkI2dm3iNIqX6jLl8WUoXx+69WDVcNGsHtCRVmjM5IJgBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/KP32ZJg7SDQdPTH1tDHHHVFET+KgjOaSgavp0Oa2D8=;
 b=REzJFha0OjSRMM1vEP/5YYCma4GqntO34ZgWc75fod+0UVtP6Rlk05ML4AnWrHngAHvsBAalBFo4G6K2snCGx5bJYOZlRrM+oEx4rQsPjLDqRQ/udIVeGq460KUTPtBJL8i5hQOIU3VK2o/FZ4g9KUTGwErFiEP1jeKSn90rfBs=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by CO1PR10MB4770.namprd10.prod.outlook.com (2603:10b6:303:96::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.29; Tue, 7 Nov
 2023 07:08:28 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Tue, 7 Nov 2023
 07:08:28 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH V5 11/21] metadump: Define metadump ops for v2 format
Date:   Tue,  7 Nov 2023 12:37:12 +0530
Message-Id: <20231107070722.748636-12-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231107070722.748636-1-chandan.babu@oracle.com>
References: <20231107070722.748636-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0169.jpnprd01.prod.outlook.com
 (2603:1096:400:2b2::12) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO1PR10MB4770:EE_
X-MS-Office365-Filtering-Correlation-Id: 762680cf-b302-482a-97c9-08dbdf605771
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JL/8/K51/+HoPSpeEaT6AAUD1RE+NrHScWm0lAEo/rMPf2gKJSD0AVkPEzYwgBnKGZvEDWY9yT3d87/rAlalUDoO1VVIBDSqMtpgWKEHV4fJsk6guD8Y2/wT62rRsqeA4gWOvgAxzzhGzOoWbpcc1u+TsWV4QD2bb4PeCx7xtG8EUNCcM0ezunwuvHotNzSfzZJQfQWcCI0/0KVBJqLXkTsZ3In5Qe21FY3ewCtT8iks2E6dNLg+d6KiEfqonuhrlu6Srj3yBN2C4K6eW4iHJW+h+0RPTupsBbgisl9ZYNtph46xxepN8O57ogMLern5B0vD06DWrFqs8W3HtPcRar8XMs61TqUvnY/BBB2r/axT5D99aaiTfnh+X3qO235AUFqpgnYBc0TOJB1jXaOgt97W2ynhxIx0fD+Jte6k5rFRne5oWrPE4+ZN8kHtXbVAVKCsmdhSHvXGJp8kPMkVpcW165wMWDxSinBSIPSSIrfYulxEp2Hb7vI/kiMIcek/4qjlvIZsfhdLrslwRcNFiIZKo+O+91clNDceLiTHhXf8I9tU9ey9GvnhKCAM3/K243IT8FqVMqdL+t7xO5zOeVw1Wzl3So2hRXjBlbTBRpc7TNoTSHgbPZHxzYQiO7Wo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(39860400002)(366004)(376002)(136003)(230922051799003)(230173577357003)(230273577357003)(186009)(1800799009)(64100799003)(451199024)(6486002)(478600001)(6666004)(66946007)(66556008)(66476007)(6916009)(316002)(26005)(1076003)(2616005)(6506007)(6512007)(8676002)(8936002)(5660300002)(2906002)(41300700001)(36756003)(86362001)(83380400001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PqYqEPpMcpyHauH9eRv7B2NJ6y4xgiwRGCszFypAn4oW0ZzUFF8hqFb9LTw3?=
 =?us-ascii?Q?x4B7pkUcrSK8azTerIAZQXQdTB4UYc4nPQ6wBHMeXej1S4bU44W6ryZzblP6?=
 =?us-ascii?Q?6LtEZpFAepKSuxPwcdKD6Oq1jVITTLuM/6qEetsSm8KzprCeQrp2o8j9I0+R?=
 =?us-ascii?Q?iJ8DutWAQtF8CUlEcFTxwDxCex3f3MYrYhXSY1bZCaYF/Vxvs8AfZ+nocyae?=
 =?us-ascii?Q?263YkHYLv7T5H4t0dSr+JjL8ogv42BCyzUmpcwjdO86JE1Qx+I/ZB6t+GhWE?=
 =?us-ascii?Q?iYHJ6AYLFBLynTvFRqjTJy+/jFUAvKu0xYF8+hbqea/B7HcjYNfKZ4WwkyfN?=
 =?us-ascii?Q?bl7u+M2HpH6qj1SRabogtaVFDFJuavYlgc8sgO+9IztXjNjxKQAJnZh8GyBL?=
 =?us-ascii?Q?4nDBWDtwFXwijySTUlLkWPecdjA5BDDH/uwAc5LpgNhubdD1KvdviThg5NR4?=
 =?us-ascii?Q?9ilEwzhWaR4opBsIEQw+F/Xe1/vhvBCPpPY6EzplyARan8wsH5UMt7MXSBHd?=
 =?us-ascii?Q?rn03HsU/w5fYG2iyop4015K9itF3g2d/JU6DPF1Z84L1DIIqlHY0rQFGFsF6?=
 =?us-ascii?Q?n0WEy0GYw2Vmwg9UIKWGCkXMKZzcapREl+pzh1xsMovLq/6PUiL0wTyuazM0?=
 =?us-ascii?Q?uN6yQ1RNC11nP4qRNsEUTW5dUWc5GsFoQ92w7Zh6KBxOm1u4xtoj2tA0Pt+v?=
 =?us-ascii?Q?19xIZRtDmiLU7faycMGVYjPWOqX6ZLdZabgxEqfg9Fptsni+PJS92HZnNRQD?=
 =?us-ascii?Q?NrEysHxH4jD5snLJJ1GyACMR7gHAbjTcOF02VdU1kC34byNlbHwpDhNnPL5S?=
 =?us-ascii?Q?UBP6vTLGef6ool+EF/TBbOLSx0co23KL+7GoNl9F1wyYFn8uVXn7Slq7v9cx?=
 =?us-ascii?Q?TbL38X4gcKIjYusbbfyROzDFmqeuM6aCA+7UVS2qv1uyZHNwx23CJ42d7uH5?=
 =?us-ascii?Q?inL/IQ//XJ8Jnk35W8J8hJ8xrGk/fNA4Lj/0QwDco9YMBq09W9kz4yzQlmKY?=
 =?us-ascii?Q?ZKJVcNDsXQCg3ADR64dE08PX20O/A/tBy1mKZsYRt+zwPcr+cQd4n08y1rY8?=
 =?us-ascii?Q?KoDMhh7qdsOX/u9mfxC4rPEOiNV57bAsbHLgnUC86qj13WAIvpDqZ+lAEcu5?=
 =?us-ascii?Q?1gm9/yAhfZum/j2qWK0UpaRHmKVB7VIRPDDwC5DTnGhPaRUSqNDXg7EGrCxK?=
 =?us-ascii?Q?JbJ5OR1Ps7XwX6/IAmU7PDprLhLKEKsSUO0PXPB4kawQ99qKLvxSKDjqrlN/?=
 =?us-ascii?Q?bz9QC32pUiSON8foAbB8CXvxGH0yRfV6Gq6ucCok2REbUuLahMl3CWNBSjYw?=
 =?us-ascii?Q?CSZk4Kp08U1IUVqeCT3xd+391Pfa+1ZbTHePOwQhTIhb3Y4s6Jbas1BMxzi7?=
 =?us-ascii?Q?FV4utSNqe3Ysb3qWi3WqS54CZfSF31CRwOW5atfviHV2n5W31d/r42WMR5cO?=
 =?us-ascii?Q?SYWnSHIKQ4Iow5edfogAa6SVeKBcyS6iuu82iv7nw/SyzgZSo1K0DoJ7Q24B?=
 =?us-ascii?Q?/TaF3q+H+qg5oTFCWfSLiJuihgKMmWI68Hw7eI7ZybpBGdc3ilVUIah93Wll?=
 =?us-ascii?Q?wwIySMYRz00+L0SFa/nNrmg12lhs2csv1UoRRiSsV+uBAcPc/8XoyVTLj28J?=
 =?us-ascii?Q?2A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Rf/KIZx/ypsqJj12Pul6dW8uzk7py50cyNZrmlPvFnwgtGlXAnM37lFkG7O648Cy+9DNOSpHxlx83WtXNNvGfnOzzg2VugWT+dZK0omSLHzU0OjCj8t3/3ItS8A+CKWXu8eaxQoIulFeA87U4OKYX8RrlauM4I4Jy5D8OYCn5tPDH3V4bFtMJNXdVSZ6hx5hHxyneNqkmmh+8tJsFscI2/Gf0+RsmR0+4DeIEmeeORcVJWmjWwHLUM/JXUCsPfjg20/MuAoqcCwvj4d8jXXvJGFhVs31rCUHO5KkxRX7mmzvlEPFxzNacb+yOPnAs0L+beR1coWw8BGvGrzyfiMw2PKTfsju/KmzCm0D1Nv1/pWKlKEeOtEd5KTNYOPZ5hbHAhBDHtC+k/IW+bYsaRm705z7O+k4mWQMAK5V2Wgb79quPm/xjQOeac/S/1Us3xe+G85hoNwdUyIOhI7OcnhEcDwiQeJduAS8qB3Q+zxcUwdx/JdkjuxySlyLom2UH//liTbyWNi0GE0BBNOu/QFVKQ4+fUMJ+4zITkZH+HWRhPcF0fhuR+BV/bjHTmA3NriQjuouQptAbnDj4kgiPvTmdLFH4dSsa1XBl//oElfaczyDV+xvLdzygZqGLPNiYpx2aDqrTZkO2ROrDe1Qz1yLpGLo9Cv0eEW4Ow8bs8Y8WZBelfS0vwevkyLMl9EUqbR7ssojwkHhUCf3Y/HG7TyUg/Vrr3IGNiBCYfXokwgpbXHoXajLWGJp8AKUs+LjC819V/E80bzcb6TvB21fKUx1Dg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 762680cf-b302-482a-97c9-08dbdf605771
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2023 07:08:28.0806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jx2xZKclcD9zS7xNw81688uaz4sE6/51/acJsSJ98KHiHf0g3UUYSV9bzpQc4Q1Pl6ksd37VjxpUtSCBI343Dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4770
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_15,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311070058
X-Proofpoint-ORIG-GUID: PKkXcgUw73T2ZVJOa6u0mIk0ZPsYcJn_
X-Proofpoint-GUID: PKkXcgUw73T2ZVJOa6u0mIk0ZPsYcJn_
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds functionality to dump metadata from an XFS filesystem in
newly introduced v2 format.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c | 74 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 71 insertions(+), 3 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index bc203893..81023cf1 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2736,6 +2736,70 @@ static struct metadump_ops metadump1_ops = {
 	.release	= release_metadump_v1,
 };
 
+static int
+init_metadump_v2(void)
+{
+	struct xfs_metadump_header	xmh = {0};
+	uint32_t			compat_flags = 0;
+
+	xmh.xmh_magic = cpu_to_be32(XFS_MD_MAGIC_V2);
+	xmh.xmh_version = cpu_to_be32(2);
+
+	if (metadump.obfuscate)
+		compat_flags |= XFS_MD2_COMPAT_OBFUSCATED;
+	if (!metadump.zero_stale_data)
+		compat_flags |= XFS_MD2_COMPAT_FULLBLOCKS;
+	if (metadump.dirty_log)
+		compat_flags |= XFS_MD2_COMPAT_DIRTYLOG;
+
+	xmh.xmh_compat_flags = cpu_to_be32(compat_flags);
+
+	if (fwrite(&xmh, sizeof(xmh), 1, metadump.outf) != 1) {
+		print_warning("error writing to target file");
+		return -1;
+	}
+
+	return 0;
+}
+
+static int
+write_metadump_v2(
+	enum typnm		type,
+	const char		*data,
+	xfs_daddr_t		off,
+	int			len)
+{
+	struct xfs_meta_extent	xme;
+	uint64_t		addr;
+
+	addr = off;
+	if (type == TYP_LOG &&
+	    mp->m_logdev_targp->bt_bdev != mp->m_ddev_targp->bt_bdev)
+		addr |= XME_ADDR_LOG_DEVICE;
+	else
+		addr |= XME_ADDR_DATA_DEVICE;
+
+	xme.xme_addr = cpu_to_be64(addr);
+	xme.xme_len = cpu_to_be32(len);
+
+	if (fwrite(&xme, sizeof(xme), 1, metadump.outf) != 1) {
+		print_warning("error writing to target file");
+		return -EIO;
+	}
+
+	if (fwrite(data, len << BBSHIFT, 1, metadump.outf) != 1) {
+		print_warning("error writing to target file");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static struct metadump_ops metadump2_ops = {
+	.init	= init_metadump_v2,
+	.write	= write_metadump_v2,
+};
+
 static int
 metadump_f(
 	int 		argc,
@@ -2872,7 +2936,10 @@ metadump_f(
 		}
 	}
 
-	metadump.mdops = &metadump1_ops;
+	if (metadump.version == 1)
+		metadump.mdops = &metadump1_ops;
+	else
+		metadump.mdops = &metadump2_ops;
 
 	ret = metadump.mdops->init();
 	if (ret)
@@ -2896,7 +2963,7 @@ metadump_f(
 		exitcode = !copy_log();
 
 	/* write the remaining index */
-	if (!exitcode)
+	if (!exitcode && metadump.mdops->finish_dump)
 		exitcode = metadump.mdops->finish_dump() < 0;
 
 	if (metadump.progress_since_warning)
@@ -2916,7 +2983,8 @@ metadump_f(
 	while (iocur_sp > start_iocur_sp)
 		pop_cur();
 
-	metadump.mdops->release();
+	if (metadump.mdops->release)
+		metadump.mdops->release();
 
 out:
 	return 0;
-- 
2.39.1

