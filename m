Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11A87E732D0
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Sep 2023 09:54:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232865AbjI2Jyn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 29 Sep 2023 05:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232746AbjI2Jym (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Sep 2023 05:54:42 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA42199
        for <linux-xfs@vger.kernel.org>; Fri, 29 Sep 2023 02:54:40 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38SK9Ssx022434;
        Fri, 29 Sep 2023 09:54:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=FwbahIUEBmvG4kdVE1iekVy0bJPwJzTPqXKm5nEROAM=;
 b=sgBX790qlmAlbeUGl4Bd5c7ja/mZXT0Nvp7oDVx3GigcAU94W/GcMjSQl+UKUxJoib1n
 ply+AWHELhcNVYoFd2pXEGGkZri2bsVYInxhKA5DXmm5O+JJ/zyHoW3n8IRoZvtQgEKs
 OAqSfVnYtV/u4H/6K1MChzOFzGtVcBNMHOBXc0FhYcQ46sMQcN+Xr+95Eo/6HihCIn4c
 H/Qs8R5to9XTgNRCLKxHkrnZ0ETQBQqzPa5nMQpTX7agUnTlVg/xfHneN1pwdRFowVZ4
 V7YtYSdq1DsFFc3+ZwTh+6Y3g+6CMb++NoeWzXMiS7D6FowdPLKbqsblJDBR5+lqKqVx Ag== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t9qwbpa7t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Sep 2023 09:54:34 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38T7bmId025296;
        Fri, 29 Sep 2023 09:54:15 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2170.outbound.protection.outlook.com [104.47.73.170])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t9pfh231p-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Sep 2023 09:54:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mZBUKx+cgPLs0cRenp1lsqWozAb0BRUnwW05hkR83SxwMnEeKg3oASA3Ta3kohd1KJmMy2pD2mejj/rgVWv7h/7ZMtz5ALXnpyXdS1t1mR3TP1G0/2jqxXUpG3YEUg0I/iJ/qpv0CGW6LvxBykf84WJ4oWS5AiKK+w22jDetNFjS3VKofs+ypnWw4cvAzvvxkF12qr3CeMEmUuIDCMWB5ziMFlWAbYnik/hjBDf5NWyv5zCHWAkDEheWCtd8kO1WAUoUQwZ/8HCx0S4GvhDuh+pSBEamoCcuuUdRpf0MFFVrbaGO/rd1j2TkPiFBh6vAFnvXBiiDbsx6rw/Ynd/uTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FwbahIUEBmvG4kdVE1iekVy0bJPwJzTPqXKm5nEROAM=;
 b=KmhCg5UOlNu5Tajji2SBqMMNu4FQTcZ/Up+QEZu1cStIT35hixO83OoD7spwok9MwlPR/cB+TMWQvdDH76AputD1yQn+ZQTVGrmZ0hfHUJWFGQmX38AI8dLIAGj4vZtpHw5j6t+XuhRU1AUo7a0m2s077V+PK+jt1/cQItTvtVgyNZ4zvYL6Vv0d3BZ/eSuEISDHrePv8I5XfreH6+sIZ5mSd2y+0pi5Vlxjf8QQfQIZMNZCdZLdFZm8ilk0gvXthxTw2DTDj4ASC/g5AKLJknsFVkJO9IE9fZRXNGII7e7b6u7LBPA44ukQYOedHIlr/+TJ2mx9E6d05v6B7fPF5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FwbahIUEBmvG4kdVE1iekVy0bJPwJzTPqXKm5nEROAM=;
 b=Fdmi3rZVViFVHQ5J80aLnHDpXHkonvC9yjrHeKc4L/MWczwsie+xfAYErKtMiWB04k6v6j1SJctBLYplpwLaIVq9a3f3sfcIQqo+/o7hzHgGfp9V9PSlK1bMPmBwkO9uawR4ZpVig8FHklB+eXJQ0u7Jhp4AqG4rvudwFfqN6vQ=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB5742.namprd10.prod.outlook.com (2603:10b6:a03:3ed::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.21; Fri, 29 Sep
 2023 09:54:13 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce%7]) with mapi id 15.20.6813.027; Fri, 29 Sep 2023
 09:54:13 +0000
From:   John Garry <john.g.garry@oracle.com>
To:     djwong@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
        chandanbabu@kernel.org, cem@kernel.org
Cc:     martin.petersen@oracle.com, John Garry <john.g.garry@oracle.com>
Subject: [PATCH 2/7] xfs: allow files to require data mappings to be aligned to extszhint
Date:   Fri, 29 Sep 2023 09:53:37 +0000
Message-Id: <20230929095342.2976587-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230929095342.2976587-1-john.g.garry@oracle.com>
References: <20230929095342.2976587-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0132.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::17) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB5742:EE_
X-MS-Office365-Filtering-Correlation-Id: e0f6d67f-1cd9-477d-b775-08dbc0d207c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kkn6EYaLMnJwmTnxzjfEyBquBPBvUaHN/lzBGPo2m6s6/XxjAYLQJhAZFZWjPEhdXAyjylYqZcbdvJuT/ylWUd/ufua0yGPSVKJRrH4mbcXD2Xj3rSXtLE5KO8P3e3LfZM3KdF/nB+cMKCKlRi3zJOL0ao/tSoOoASqX5saPhgG1PltYPq1JGi9fsnTj36sAqwbwKmmWhleenRZ0IZyAFVKDUxXUzQ6MBm2ctyynJ6GUSVuQLM3CBNHLsVO9S7u8A05mqvxKnt2qGj5/c1FNiHhZAN4Su+kOk5xxvEREexHl6zpKqylJvEiobsdPKvpTFhYD6tKWSG9nnIg9cbCgBzapVrGRz8+YIQY181U2cCj0Teexd2a6oKzL7EIoKI5X5wMYgIWMJJgRmfv+96qNaQVvCGuN/ztdrNgm0SiCtkECIihXhb0nXYZFgZ6ab8xq+RyMqYWpkjX2iC7PqVu30vSrfv3Z3K2RvNkprtZhWTiJL2CJOLN5pCZMMNzvQ8OLlU/syAuBAi3YQQKMjsPsdkYT0iexrkLk/sLqyIEe0MshFC1q4d9wWE3rDn2qfhWP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(376002)(366004)(39860400002)(346002)(230922051799003)(451199024)(1800799009)(186009)(64100799003)(2616005)(5660300002)(107886003)(4326008)(8936002)(8676002)(6512007)(41300700001)(26005)(6506007)(1076003)(83380400001)(38100700002)(6666004)(478600001)(316002)(66946007)(66556008)(66476007)(36756003)(86362001)(103116003)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FoO+9LPuN4fBq6ibR/FNLCp8pi9YJELBPDXzijH+RZmiZN6NKR+iCGnd1n0d?=
 =?us-ascii?Q?BySAjiCTi967ePhpeYPgC4b7eRU4rp8Jiwa3Ytj1J6GLnfiCi87UcjD2Smqx?=
 =?us-ascii?Q?PQAlQH6gMh41DCwMe/GgvMGL2UxZVlKjp0i4svOvgZSw8I8LKgaQ+cak8wlS?=
 =?us-ascii?Q?v8wYZ0rnaPAnLowJ9JaYd6gPaPQTekN8lLiy/5aiDV8sMMiiHClTR1mHpqxf?=
 =?us-ascii?Q?Nogs8LoHkOGB5mURoGNQe/GNetX+duwel5eOgtqIjC3IGxMR71aDPj7lFSDE?=
 =?us-ascii?Q?Jhuvt/SO5EUs38cToZ2vVRvrFR8jL6fS3R/g5nDMpC9Xzarx+P1t2/sOQCZW?=
 =?us-ascii?Q?Z4ELg5lZp3Zd2TGqCnQa+NWsaDibgfLL06gmh4f6reh/CueuDuNKz0romLXQ?=
 =?us-ascii?Q?xbJsK3sSFXTypC80XfLY1OVhP9OV5ssqYxNXjFqSQSOx4Kb9eVuOf/OF5GsW?=
 =?us-ascii?Q?2BaRfSQ9tzLuJadbzM17rbAHhhrs0/c+OPRHzsL7QkV+O0+pzVAdZNd8vMcg?=
 =?us-ascii?Q?HQMUzxaAFj28fPT17KAF1JoB1VfQndqEjS5xaWw0uKrpgZq64Sd8/9xDqL0g?=
 =?us-ascii?Q?qnRKCCGm0dGdXnrXT0WDM22YI8bJVEdZYmgFPWrlKh92WO15ye2TeLvBEVhM?=
 =?us-ascii?Q?lfHNVxf44lyTGGkKf4+t3tyUKqMr4rK1O6LZMcwGa5LJOQEB20B6pFuHIi19?=
 =?us-ascii?Q?jyxTug01J8NGQaA5JkTfiMeJswBLJMrgn8lnqshJxzh4bWHXcI3wKScP17sa?=
 =?us-ascii?Q?b5TXpgfpEFpSYTzPU/Urxq8BLvjAFz6DCKlOujyKukvnt2L+drU6TjFfJlxC?=
 =?us-ascii?Q?7Jn/2YKN8d7vFrDwMzWr/lLsorezxQIn/zqfkE+3rQe8GpFbpXC7p0aUBIaL?=
 =?us-ascii?Q?vp5H0ANJABruFDb7YnfqEsi0lAIYcWDe07lIujTkP0bU0IQ7RZeA9pU+sd/M?=
 =?us-ascii?Q?P3PdJl0H+5ay06+9johIBvEXT9oMWNvEFE4upEHhTNULBXq5p5KVIvHU6plD?=
 =?us-ascii?Q?uZ4YW0C0nVbFXHue7JKjDDWR5Aip69AVQLBEgnYJZorwIYWJ+iFsonQpnYjx?=
 =?us-ascii?Q?99skIS9oRzl86JDQqir8O5foc1I3XKMTuqM9ij5cnojXwRcFHQ6VBJIXMyw1?=
 =?us-ascii?Q?2UPfUhZgkVFfb3pAoU0azkhnQu4LQyhZ8hMsE9JEpSZbfujxWSIWZFna/h4O?=
 =?us-ascii?Q?B6+qBct0CjkWuQ6EBhE6bGCtXqnoN4pQlbRX3hEjbCLcuS7+3UuCmRhOVFbA?=
 =?us-ascii?Q?iFlrcdY1x6wpyeVfJ4E0S9nbaSqkMKOywdYI/K5nlweR0NnsV8b+C8jt0Q7s?=
 =?us-ascii?Q?mzpmwIN9eZ0gV8gNvWnBDWWsLPPMG3hWPV8jzCm8B+vTOmJJr0+lYf3rxpYM?=
 =?us-ascii?Q?86Jo5gCV6+CJndDgwQuQm78+7tWM4vyfJGWUu0NPYeXDQPdUaBL99JrFbMif?=
 =?us-ascii?Q?ZVzWOQwEETlso092TU+UsnKiO6nINYJPH4xAIoFrx3RX4eOjQQ9slXyKvX1/?=
 =?us-ascii?Q?n6/qjMRtKpO+67cNI/jCkMJ633t0KigcttT9jAZV3T+GrHjJKOEfbCJIvhZx?=
 =?us-ascii?Q?be7sRiTauowsfig3hUeB55AjHPCPCfONUOEOahTTXheh+EJvATcYEwTQnQ4s?=
 =?us-ascii?Q?Zg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 464AXu9i7ZHzwvV8Fr5za4iVfhJRgTh8hgyr53w2JvkTdsFSNuBUMBIp/5MWZl/yeuRq5M2Kk9nPo+AuWC1G5SNve20khtDem1/gTtjIRU5ib1uwsCLZNa75ohQcfQMkLFGoDc28ZlcZbX3wugcNEVNTtqdxXCczDevHU1qoVkR8MgJUaBEHI6gKMjRPlXiT3kg6qj7pdH7bE25+C1B7kuJw/hUriW4fPN8BBjrYJLpYwA/lMX4ry+NnS+3Xjw+w53kk0UcgVBVNbnh1C2WeUphlhzD7cCBYPEpjTF14KRgnczp9uhOJ4LauL5ODaOZ5l9vN1Aq3D/AbiieUODtxKl98ZILDxoPeTlE6Tt+Zu/8NeYQPCm3MOckPZOSZw7ywZ94ev/Y+FiVzlnpfyD0Q/qnpwPaAxcKYoXvv7yXgUuVH8jmd58b8B98DNypTWM9dVczAD+WhZ5J37UHAm+vjyibWltyaywvYZ4ypWKt52QaNxq9Nxy0/pyJLQO5uDjYSfIICdvmGEOgyjCSmRIxsP+lDj5rQ7AXXdE5n0nzJOxTLwvcoZL1SDANfX0Ts2d+vUfLRVvIvlMsmxP3SAMqS75pWFAnudkpsv4IPUn37DnGYQAW8T0HvBPmvjUP9Jrj970kA6jnaUBMpEReIAHRQrA8QxJ075uOI5O1uB6g6yVB2YSiKmK2dT/GjgOEBv+c2Vai5Mm3aifCT7qSljjn0XclMjgm1UIdwpIOYHSLzBABY+DN5a3ELVGkY3cxlw6A1eJSM+7QOoXjk/Um+RqDYlIx3jppJZ4IcjpcNPo7PPMFyHrNEm57kytsxrM0lG7PJ7R158XzTVLl+ryF+GblqTg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0f6d67f-1cd9-477d-b775-08dbc0d207c2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2023 09:54:11.0064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iHxgGlDYTDvKs82imN3xO3d31RgF5GTlJoSAlDBFqpJfiGZGvCi92ghPy2mT89+hh3qf08BWAqwzPThrdO8PdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5742
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-29_07,2023-09-28_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309290085
X-Proofpoint-GUID: mD0V3ozQayng4tIUsYRzMHrjcEzf4EJ9
X-Proofpoint-ORIG-GUID: mD0V3ozQayng4tIUsYRzMHrjcEzf4EJ9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

Add a new inode flag to require that all file data extent mappings must
be aligned (both the file offset range and the allocated space itself)
to the extent size hint.  Having a separate COW extent size hint is no
longer allowed.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Co-developed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 libxfs/xfs_bmap.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 2bd23d40e743..809adcf67985 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -3321,6 +3321,19 @@ xfs_bmap_compute_alignments(
 		align = xfs_get_cowextsz_hint(ap->ip);
 	else if (ap->datatype & XFS_ALLOC_USERDATA)
 		align = xfs_get_extsz_hint(ap->ip);
+
+	/*
+	 * xfs_get_cowextsz_hint() returns extsz_hint for when forcealign is
+	 * set as forcealign and cowextsz_hint are mutually exclusive
+	 */
+	if (xfs_inode_forcealign(ap->ip) && align) {
+		args->alignment = align;
+		if (stripe_align % align)
+			stripe_align = align;
+	} else {
+		args->alignment = 1;
+	}
+
 	if (align) {
 		if (xfs_bmap_extsize_align(mp, &ap->got, &ap->prev, align, 0,
 					ap->eof, 0, ap->conv, &ap->offset,
@@ -3416,7 +3429,6 @@ xfs_bmap_exact_minlen_extent_alloc(
 	args.minlen = args.maxlen = ap->minlen;
 	args.total = ap->total;
 
-	args.alignment = 1;
 	args.minalignslop = 0;
 
 	args.minleft = ap->minleft;
@@ -3462,6 +3474,7 @@ xfs_bmap_btalloc_at_eof(
 {
 	struct xfs_mount	*mp = args->mp;
 	struct xfs_perag	*caller_pag = args->pag;
+	int			orig_alignment = args->alignment;
 	int			error;
 
 	/*
@@ -3536,10 +3549,10 @@ xfs_bmap_btalloc_at_eof(
 
 	/*
 	 * Allocation failed, so turn return the allocation args to their
-	 * original non-aligned state so the caller can proceed on allocation
-	 * failure as if this function was never called.
+	 * original state so the caller can proceed on allocation failure as
+	 * if this function was never called.
 	 */
-	args->alignment = 1;
+	args->alignment = orig_alignment;
 	return 0;
 }
 
@@ -3562,6 +3575,10 @@ xfs_bmap_btalloc_low_space(
 {
 	int			error;
 
+	/* The allocator doesn't honour args->alignment */
+	if (args->alignment > 1)
+		return 0;
+
 	if (args->minlen > ap->minlen) {
 		args->minlen = ap->minlen;
 		error = xfs_alloc_vextent_start_ag(args, ap->blkno);
@@ -3683,7 +3700,6 @@ xfs_bmap_btalloc(
 		.wasdel		= ap->wasdel,
 		.resv		= XFS_AG_RESV_NONE,
 		.datatype	= ap->datatype,
-		.alignment	= 1,
 		.minalignslop	= 0,
 	};
 	xfs_fileoff_t		orig_offset;
-- 
2.34.1

