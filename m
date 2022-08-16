Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0CAFC25B0E
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Aug 2022 17:35:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236479AbiHPRfV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Aug 2022 13:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236463AbiHPRfT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Aug 2022 13:35:19 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8464375CFF
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 10:35:16 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27GHRRWT015342
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 17:35:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=w1HMRVQkgxPGzEqxaDVgrjwwmUy4jx5Sd4JlZm8Wf1k=;
 b=V+uCxu6aezWCU0NKjYtFDU1cw19rn/E2M0fKlBS7Ag4XJHsVk7Qnu5DGojcbYwURFA9P
 NNwWJA9s6dUsruZfcZRtTtK2kknZG9P3IcDoZJA+4oiaLOuMppZ4iNOLGWCLY/d9l0Oi
 FJtwhiS0ZVb+EJsFWm0I7HefjXBdHBKGzZgOaimP9tX4LK6YWeNHB0Z82zpd9SrM1Yhm
 jcv+3q8Aln2KO24V3miZBpjJ60QYuP8jY0DZlUeUp7tMspjddtWypAgsdeN25e1YuUNV
 p1S9Gb8J+/joZcPGo3DXRVKXxsYDY48iLCrlxWTSmq4+/4tJNrDulvPwQt6oe2SwHtRq 4g== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hx2r2essx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 17:35:15 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27GFAnkE021311
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 17:35:14 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hx2d8q39e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 17:35:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L/G/yuhdrxFLYQmUo+BAC0WJLSWLcZqcWUf0QtQ9Q3ZEcp6zf03p1ApXMRmfp0A+2x86+KaJ1RDFGKWOFblkF0urRJBuKR5YESkxq/C32j61fcpjpxnQYP1S+KUXvFEb3Mwhofovme5Hi10PhckAWmbTTY/kS4yykn3o66dZuqYa49nKE+C7ueYc4xBN5d82AxJ+xoIyhzObok3XxA7ajMcY7Rrdl2Nouikg2h28LdDUjx1A1FulQ5FIe6vGeaIKRxCEQM7N2cRCLVBFk6B89OIIHxqIIPp/6biQBkOWI/N4c8mFgRnlZgW7Khn4iq9gybVTWvix/7zvrjG8QOSdRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w1HMRVQkgxPGzEqxaDVgrjwwmUy4jx5Sd4JlZm8Wf1k=;
 b=QWujwTzhUVnnj7yKkw3VKVnAYauBgrxUJv9cQASWfrvo92o1ntJt7F+IAewOlBXy758qDXkq2FPycJBlPNg5zL+xXeifIza8ufks6jjMqTSSxA1f44eQxEOBQ+wITgamoSkAq9VaiL4EXUhkzh1B4bRSQpRuGTaZsS6NvvD6zhzoufsVhiV16xkjwgorDujKkKHF76SbYbyX/1TK480Zs3TgTX98ZmxWOXxUgbcr8Fxvtc1my0xT5IxNYYl20MJtyYmx8AngfGJGsOF+igvVdysWbHkNiWdFXAcZF1vcBXyq4qXCiHQdrchRG0Tybxo3I2p8AvwfD3ldqxAcLokNTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w1HMRVQkgxPGzEqxaDVgrjwwmUy4jx5Sd4JlZm8Wf1k=;
 b=aEyyD+R3P3oxr3ckXQG6zYTiU/kAvA4rw30fZlDOonvz+hnFYEHFWT+VCBY1GSIKcEmXqAW0YsgTx+5WWz66nE4xZsIRdUYKHu9Pkuu/6Rvv8oVJg7Q+7VC4cgsW2i/52eESR+TAyS6qMzCz7f3hLQLfKbaAfDepc3rWrWBEqd8=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by MWHPR10MB1808.namprd10.prod.outlook.com (2603:10b6:300:10a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.22; Tue, 16 Aug
 2022 17:35:12 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5525.011; Tue, 16 Aug 2022
 17:35:12 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: Add new name to attri/d
Date:   Tue, 16 Aug 2022 10:35:06 -0700
Message-Id: <20220816173506.113779-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0062.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::7) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 93072fa6-b518-4b01-ac00-08da7fadac84
X-MS-TrafficTypeDiagnostic: MWHPR10MB1808:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HmEdg4EeaSG8RohUForcLmJvM27xJgd2eyF9r82j2fPhbQMM9aJ4BGXQUGFdGBUN5/t4Vb791Ew+VIcD5nFs1VWKXn9SjkhBXQy0lJrPSdu40qXc/eK8nywsCt8S9iOo3r/VQNJQPQfdDwIgRmqC+eJ9IHoCXEhB9imeul2/1HeBckr8ZdUdsYkgvjJrV4BYBIf5uY5JZ0hhQ1bZaz7EUNhq7ziZTWCMs2gvkqtrRfMJLPyLN0CC5scQeJ3Kw+9EG6X3XWfKuvIc9lqSV2yJEGmP/TBDWX+fLOKC7N6ESywvCvEiSKSGsq3RjrN/VWFeZ80GzrfhT4Heb1fPIPIARHek59jKgEd6ZtR01jNZbk03sJxSzIR7GhErxmepksNGLOO4Q0ku+cOD+5mdWTutk1+uP7/ZLVriAFGOEhlWWbxC9DVEduiOOA9Sz0iI+twFsaUq2s7sYFze6FsZZomCDYhmcT+ZJIbwVoJTtslSGz3p3B8LYQvahY4oQV+oq9E4SZqC9vrcg2tLwyiTlIj4hFFCqNMoohalXA4/NbrvZWhdY8vGuJrWPOjgOnGRbab3/iFzsVroZcOEpMl/Z8j3bLco2Xc4hWZ09AbgAA77nQqjnNTLDNVn011IQIl3lB7nix2Ofjxn3qCth9NKVcwLkuciOwYbQTH7Ma+Rv3ZYzMJrqTOQ+mtaMwtEOBhNRpeBHnahYmwMmP0YAR0Y1q4n4Usp4KdoBNkEPFqTZEdYqAZhHhCVuv4H0j/ihNWPagvKFNyvzltfxDJ4BGhFhy96yhtbU5uyh/7V95VWAp6wIFk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(136003)(396003)(39860400002)(376002)(8936002)(36756003)(44832011)(66476007)(66556008)(8676002)(316002)(2906002)(66946007)(6506007)(26005)(6666004)(30864003)(6916009)(478600001)(52116002)(41300700001)(6486002)(6512007)(1076003)(2616005)(186003)(86362001)(83380400001)(5660300002)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0A5acWx0zPn0Zxk1Ng71H5CBwMbNScCBEJUxI3FihD6XIAP7qE7milCeq2kM?=
 =?us-ascii?Q?zYOFczeUOyHL15SfDREH6nDBZJv+bSOJixv3IJ6vXr3NuCPb6cN2GSI0JVeD?=
 =?us-ascii?Q?c3UG4mE0H7xmMRmgsLmk2JM1RZsTZSxOarWKjCo4qCoFhWbJ8sQmtq9JNl+e?=
 =?us-ascii?Q?x0DhawAEnO7C9PmLeSk099OGo/l8t7xp9OcThNiPAZ04wmXHlk28IUqCPKii?=
 =?us-ascii?Q?YSW0+takgTP4ex1Tb+4cBkF+395XUSd2QGTAYTHzYLkJpgf0o0GlMzMHQ5bC?=
 =?us-ascii?Q?PAh43pqMSBsRrB5q7jvyKaDwLPVwmATKvsPo6hfuW+uFXhGo/MhRqyEPzBZI?=
 =?us-ascii?Q?bOQWJLqJfp+sOMkB6U+X5kAIA81RXYQ9F+aWheDRwx7COikiXImv6eUMbXxf?=
 =?us-ascii?Q?IyZHTMIOBERWm1GAp7vd+zMtNdPvrUwRB1NrqqSRy9BdOGaZzHQc3i/v4ST8?=
 =?us-ascii?Q?kIYO634w1svu/9EBIA+W5jNsiaMq38Oz0XSgz7JznjLsTKo1kZK4u9duVr7g?=
 =?us-ascii?Q?/Q1AxrxPh0GYqTaHToUuA278BmyPA7fcbxlAF2OxwHZuuvDBPk86MIQ7vCAP?=
 =?us-ascii?Q?GSq6+v6wQLefTNC+KfFM8QSgGHHHG5uJ6vFuc6Ep+QmVDIds2XnCAmhMzltJ?=
 =?us-ascii?Q?ZwPYgYXGfV0GYmszWTbza0km6vr+cLe32SiXjo3E9wIui+ABuZa0tmT2/8YG?=
 =?us-ascii?Q?iLJuqU4SXvTDw1GioQyroBwvYqH5T58MBdsUMC/akHPT0SJ7YDh5+MHbu9J/?=
 =?us-ascii?Q?XYXnHxq/A6QT1yA0Ize4tAOs1bjibKIIeA/6cOqod5T3A2rx5Qi8BFa+xvVB?=
 =?us-ascii?Q?ndC4p6Kq5Addf0rw8ifZ3baMsBQ6pBLSM7Xy5YQNqtPp3ItLJLA85ExRiYJX?=
 =?us-ascii?Q?QssbB4lHR0vks1wi7fsDCned4YwTSr/zOSVCbomNYAqQAI993irulBOVoE4T?=
 =?us-ascii?Q?OCmWb8f00H2zfF6gl2zqCiyhv9ptm7LC89x/dtWqyukZjhSbdVBVcaF/5+It?=
 =?us-ascii?Q?JK04+iAIlzuq7Y30OmQ8IwPVyVzRW9VfWa1ZiooJnPszrwXH00HeQfxYWZnM?=
 =?us-ascii?Q?8qK4z35cA6LLZAg2LYxTEBwyq+q1fY7ER/c4ptRKuKl7ykh941f5TIwzdTTZ?=
 =?us-ascii?Q?Z8UVwRSa9JaMBt4jMdKorAYyF7Tbz6u0R/pKQSWtBHpCGVCIbMsabNyMzVTX?=
 =?us-ascii?Q?DHN/ZD5rSuXKPa1/StZfx4yOCjC0Ek1aOUtbhlAd84if+1XBflFVAOiCqd41?=
 =?us-ascii?Q?TFLZUieFJ/TXGbQfFz8/vH7TNGERwJO/LkbEZmQIq8gmyK+yc7QkCEnU4wMK?=
 =?us-ascii?Q?VJ8VoTbhsDAK+U+NWwBedyu7wj4ebCfzCWTvuSa7pdLAGUEiohKHmLUl4Tnb?=
 =?us-ascii?Q?+VbNRgnMRClm/RXh6+GodkUF69iiKrlUNnP0Ou4/HKz87WrKSnV+wE1wUPzU?=
 =?us-ascii?Q?Pmlb+lpHM/tw1r0vq7jAGH27dSv3GaFlk50KD5bvLSapfQLd5HpAp3QdmuBe?=
 =?us-ascii?Q?n6Ps7OHM7m3AkFHgJeunOrICMliMGOW4/cuaiZxm7vKGVafvR+kYlE7YAsT4?=
 =?us-ascii?Q?LUd+Dgo10EdnvoXBqNblfCPgM7o1BU56L6B2tqf0CC3SiLuqPGUTa4XnL1wV?=
 =?us-ascii?Q?Hw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: v17t64h8+8x/HFHqqW1GoIV4a2oFBahFtPZN6Sl8uAVv2bJNhmQOaYJAL7IkM8Kj5XacXAmj3mXFiUtUdPnnntVQdFTyqHHxKXVETyrAgIyzJzlUVI392fEbBzngJgaftoiaDZfnDKLiqMzL1pp4Zp+68hcSAy8vBNAPhU+7E22ENJPMqIbaECC5iTEIPk3M3PB+aYgFVtSmhU0/V2Kn+WdSYdQNdL7dSUPtI8q7exgi9Z75g4KJagpw/xQBmxHIm9h7Nsov67mVvE9857qgWEkCoFkmxfwUtTh9kjAnE1UiQa1UVFuC4/nGfaO0Hxkdta2RIepxCEBuG8/WDYc28x6DQgCre6WZaubBt5WPPRMcAMcLNZwNMELcyZ5SHjHkf1AnUUDLuJJ6t/TmxMDUHYtWQipzTYJrn+A7PcPPAG4Ze8l4kKwCkIPHUymnxBl084OmDetG5n3Pz4YhH6m5MasB9dcHmjvsAG8ErHbhHYdsrRaKrcoIlACbmn4qycR4FOuF5m2kx/SSnffwv/TUIkwDUTsH0bLOz4tYsF8Kq0RD/dTXsWhl9kM7/L1IEOacL0EGFfgXzhb/KxwoVpPF/xBB0JqAwy7IwujyPHWS67PrC6AHUcKg/Ql3v/VGo/KkHybTAcbdmoVTgJ2BYgQlbVmqwmaJC57435WbndpvpkxmODD9AGDN98qMcbdK8EUJylOcYL6Xeofb8PEY7o2d8xGXinHPY64pY3nj5NW7H9Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93072fa6-b518-4b01-ac00-08da7fadac84
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 17:35:12.7729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xEgiX4Ek96uJWH2NoeVChreiYCHtulcDl14w13zM9C47R0OjxV3R/EAJyFz5zCsjagjC9PLz3aFHxVmT6f/2KCoBr78Y18JDrj9sY9c/Cj8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1808
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-16_08,2022-08-16_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208160066
X-Proofpoint-GUID: lqM29iVQfEugkVG3l1Ii3egMitjN3Ap-
X-Proofpoint-ORIG-GUID: lqM29iVQfEugkVG3l1Ii3egMitjN3Ap-
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds two new fields to the atti/d.  They are nname and
nnamelen.  This will be used for parent pointer updates since a
rename operation may cause the parent pointer to update both the
name and value.  So we need to carry both the new name as well as
the target name in the attri/d.

As discussed in the reviews, I've added a new XFS_ATTRI_OP_FLAGS*
type: XFS_ATTRI_OP_FLAGS_NRENAME.  However, I do not think it is
needed, since args->new_namelen is always available.  I've left the
new type in for people to discuss, but unless we find a use for it
int the reviews, my recommendation would be to remove it and use
the existing XFS_ATTRI_OP_FLAGS_RENAME with a check for
args->new_namelen > 0.

Feedback appreciated.  Thanks all!

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c       | 12 +++++-
 fs/xfs/libxfs/xfs_attr.h       |  4 +-
 fs/xfs/libxfs/xfs_da_btree.h   |  2 +
 fs/xfs/libxfs/xfs_log_format.h |  5 ++-
 fs/xfs/xfs_attr_item.c         | 71 ++++++++++++++++++++++++++++------
 fs/xfs/xfs_attr_item.h         |  1 +
 fs/xfs/xfs_ondisk.h            |  2 +-
 7 files changed, 81 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index e28d93d232de..9f2fb4903b71 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -423,6 +423,12 @@ xfs_attr_complete_op(
 	args->op_flags &= ~XFS_DA_OP_REPLACE;
 	if (do_replace) {
 		args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
+		if (args->new_namelen > 0) {
+			args->name = args->new_name;
+			args->namelen = args->new_namelen;
+			args->hashval = xfs_da_hashname(args->name,
+							args->namelen);
+		}
 		return replace_state;
 	}
 	return XFS_DAS_DONE;
@@ -922,9 +928,13 @@ xfs_attr_defer_replace(
 	struct xfs_da_args	*args)
 {
 	struct xfs_attr_intent	*new;
+	int			op_flag;
 	int			error = 0;
 
-	error = xfs_attr_intent_init(args, XFS_ATTRI_OP_FLAGS_REPLACE, &new);
+	op_flag = args->new_namelen == 0 ? XFS_ATTRI_OP_FLAGS_REPLACE :
+		  XFS_ATTRI_OP_FLAGS_NREPLACE;
+
+	error = xfs_attr_intent_init(args, op_flag, &new);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 81be9b3e4004..3e81f3f48560 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -510,8 +510,8 @@ struct xfs_attr_intent {
 	struct xfs_da_args		*xattri_da_args;
 
 	/*
-	 * Shared buffer containing the attr name and value so that the logging
-	 * code can share large memory buffers between log items.
+	 * Shared buffer containing the attr name, new name, and value so that
+	 * the logging code can share large memory buffers between log items.
 	 */
 	struct xfs_attri_log_nameval	*xattri_nameval;
 
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index ffa3df5b2893..e9fb801844f2 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -56,6 +56,8 @@ typedef struct xfs_da_args {
 	struct xfs_da_geometry *geo;	/* da block geometry */
 	const uint8_t		*name;		/* string (maybe not NULL terminated) */
 	int		namelen;	/* length of string (maybe no NULL) */
+	const uint8_t	*new_name;	/* new attr name */
+	int		new_namelen;	/* new attr name len */
 	uint8_t		filetype;	/* filetype of inode for directories */
 	void		*value;		/* set of bytes (maybe contain NULLs) */
 	int		valuelen;	/* length of value */
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index b351b9dc6561..8a22f315532c 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -117,7 +117,8 @@ struct xfs_unmount_log_format {
 #define XLOG_REG_TYPE_ATTRD_FORMAT	28
 #define XLOG_REG_TYPE_ATTR_NAME	29
 #define XLOG_REG_TYPE_ATTR_VALUE	30
-#define XLOG_REG_TYPE_MAX		30
+#define XLOG_REG_TYPE_ATTR_NNAME	31
+#define XLOG_REG_TYPE_MAX		31
 
 
 /*
@@ -909,6 +910,7 @@ struct xfs_icreate_log {
 #define XFS_ATTRI_OP_FLAGS_SET		1	/* Set the attribute */
 #define XFS_ATTRI_OP_FLAGS_REMOVE	2	/* Remove the attribute */
 #define XFS_ATTRI_OP_FLAGS_REPLACE	3	/* Replace the attribute */
+#define XFS_ATTRI_OP_FLAGS_NREPLACE	4	/* Replace attr name and val */
 #define XFS_ATTRI_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
 
 /*
@@ -931,6 +933,7 @@ struct xfs_attri_log_format {
 	uint64_t	alfi_ino;	/* the inode for this attr operation */
 	uint32_t	alfi_op_flags;	/* marks the op as a set or remove */
 	uint32_t	alfi_name_len;	/* attr name length */
+	uint32_t	alfi_nname_len;	/* attr new name length */
 	uint32_t	alfi_value_len;	/* attr value length */
 	uint32_t	alfi_attr_filter;/* attr filter flags */
 };
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 5077a7ad5646..40cbc95bf9b5 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -75,6 +75,8 @@ static inline struct xfs_attri_log_nameval *
 xfs_attri_log_nameval_alloc(
 	const void			*name,
 	unsigned int			name_len,
+	const void			*nname,
+	unsigned int			nname_len,
 	const void			*value,
 	unsigned int			value_len)
 {
@@ -85,7 +87,7 @@ xfs_attri_log_nameval_alloc(
 	 * this. But kvmalloc() utterly sucks, so we use our own version.
 	 */
 	nv = xlog_kvmalloc(sizeof(struct xfs_attri_log_nameval) +
-					name_len + value_len);
+					name_len + nname_len + value_len);
 	if (!nv)
 		return nv;
 
@@ -94,8 +96,18 @@ xfs_attri_log_nameval_alloc(
 	nv->name.i_type = XLOG_REG_TYPE_ATTR_NAME;
 	memcpy(nv->name.i_addr, name, name_len);
 
+	if (nname_len) {
+		nv->nname.i_addr = nv->name.i_addr + name_len;
+		nv->nname.i_len = nname_len;
+		memcpy(nv->nname.i_addr, nname, nname_len);
+	} else {
+		nv->nname.i_addr = NULL;
+		nv->nname.i_len = 0;
+	}
+	nv->nname.i_type = XLOG_REG_TYPE_ATTR_NNAME;
+
 	if (value_len) {
-		nv->value.i_addr = nv->name.i_addr + name_len;
+		nv->value.i_addr = nv->name.i_addr + nname_len + name_len;
 		nv->value.i_len = value_len;
 		memcpy(nv->value.i_addr, value, value_len);
 	} else {
@@ -149,11 +161,15 @@ xfs_attri_item_size(
 	*nbytes += sizeof(struct xfs_attri_log_format) +
 			xlog_calc_iovec_len(nv->name.i_len);
 
-	if (!nv->value.i_len)
-		return;
+	if (nv->nname.i_len) {
+		*nvecs += 1;
+		*nbytes += xlog_calc_iovec_len(nv->nname.i_len);
+	}
 
-	*nvecs += 1;
-	*nbytes += xlog_calc_iovec_len(nv->value.i_len);
+	if (nv->value.i_len) {
+		*nvecs += 1;
+		*nbytes += xlog_calc_iovec_len(nv->value.i_len);
+	}
 }
 
 /*
@@ -183,6 +199,9 @@ xfs_attri_item_format(
 	ASSERT(nv->name.i_len > 0);
 	attrip->attri_format.alfi_size++;
 
+	if (nv->nname.i_len > 0)
+		attrip->attri_format.alfi_size++;
+
 	if (nv->value.i_len > 0)
 		attrip->attri_format.alfi_size++;
 
@@ -190,6 +209,10 @@ xfs_attri_item_format(
 			&attrip->attri_format,
 			sizeof(struct xfs_attri_log_format));
 	xlog_copy_from_iovec(lv, &vecp, &nv->name);
+
+	if (nv->nname.i_len > 0)
+		xlog_copy_from_iovec(lv, &vecp, &nv->nname);
+
 	if (nv->value.i_len > 0)
 		xlog_copy_from_iovec(lv, &vecp, &nv->value);
 }
@@ -398,6 +421,7 @@ xfs_attr_log_item(
 	attrp->alfi_op_flags = attr->xattri_op_flags;
 	attrp->alfi_value_len = attr->xattri_nameval->value.i_len;
 	attrp->alfi_name_len = attr->xattri_nameval->name.i_len;
+	attrp->alfi_nname_len = attr->xattri_nameval->nname.i_len;
 	ASSERT(!(attr->xattri_da_args->attr_filter & ~XFS_ATTRI_FILTER_MASK));
 	attrp->alfi_attr_filter = attr->xattri_da_args->attr_filter;
 }
@@ -439,7 +463,8 @@ xfs_attr_create_intent(
 		 * deferred work state structure.
 		 */
 		attr->xattri_nameval = xfs_attri_log_nameval_alloc(args->name,
-				args->namelen, args->value, args->valuelen);
+				args->namelen, args->new_name,
+				args->new_namelen, args->value, args->valuelen);
 	}
 	if (!attr->xattri_nameval)
 		return ERR_PTR(-ENOMEM);
@@ -543,6 +568,7 @@ xfs_attri_validate(
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
+	case XFS_ATTRI_OP_FLAGS_NREPLACE:
 		break;
 	default:
 		return false;
@@ -552,6 +578,7 @@ xfs_attri_validate(
 		return false;
 
 	if ((attrp->alfi_name_len > XATTR_NAME_MAX) ||
+	    (attrp->alfi_nname_len > XATTR_NAME_MAX) ||
 	    (attrp->alfi_name_len == 0))
 		return false;
 
@@ -615,6 +642,8 @@ xfs_attri_item_recover(
 	args->whichfork = XFS_ATTR_FORK;
 	args->name = nv->name.i_addr;
 	args->namelen = nv->name.i_len;
+	args->new_name = nv->nname.i_addr;
+	args->new_namelen = nv->nname.i_len;
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
 	args->attr_filter = attrp->alfi_attr_filter & XFS_ATTRI_FILTER_MASK;
 	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT |
@@ -625,6 +654,7 @@ xfs_attri_item_recover(
 	switch (attr->xattri_op_flags) {
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
+	case XFS_ATTRI_OP_FLAGS_NREPLACE:
 		args->value = nv->value.i_addr;
 		args->valuelen = nv->value.i_len;
 		args->total = xfs_attr_calc_size(args, &local);
@@ -714,6 +744,7 @@ xfs_attri_item_relog(
 	new_attrp->alfi_op_flags = old_attrp->alfi_op_flags;
 	new_attrp->alfi_value_len = old_attrp->alfi_value_len;
 	new_attrp->alfi_name_len = old_attrp->alfi_name_len;
+	new_attrp->alfi_nname_len = old_attrp->alfi_nname_len;
 	new_attrp->alfi_attr_filter = old_attrp->alfi_attr_filter;
 
 	xfs_trans_add_item(tp, &new_attrip->attri_item);
@@ -735,10 +766,15 @@ xlog_recover_attri_commit_pass2(
 	struct xfs_attri_log_nameval	*nv;
 	const void			*attr_value = NULL;
 	const void			*attr_name;
+	const void			*attr_nname = NULL;
+	int				i = 0;
 	int                             error;
 
-	attri_formatp = item->ri_buf[0].i_addr;
-	attr_name = item->ri_buf[1].i_addr;
+	attri_formatp = item->ri_buf[i].i_addr;
+	i++;
+
+	attr_name = item->ri_buf[i].i_addr;
+	i++;
 
 	/* Validate xfs_attri_log_format before the large memory allocation */
 	if (!xfs_attri_validate(mp, attri_formatp)) {
@@ -751,8 +787,20 @@ xlog_recover_attri_commit_pass2(
 		return -EFSCORRUPTED;
 	}
 
+	if (attri_formatp->alfi_nname_len) {
+		attr_nname = item->ri_buf[i].i_addr;
+		i++;
+
+		if (!xfs_attr_namecheck(mp, attr_nname,
+				attri_formatp->alfi_nname_len,
+				attri_formatp->alfi_attr_filter)) {
+			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+			return -EFSCORRUPTED;
+		}
+	}
+
 	if (attri_formatp->alfi_value_len)
-		attr_value = item->ri_buf[2].i_addr;
+		attr_value = item->ri_buf[i].i_addr;
 
 	/*
 	 * Memory alloc failure will cause replay to abort.  We attach the
@@ -760,7 +808,8 @@ xlog_recover_attri_commit_pass2(
 	 * reference.
 	 */
 	nv = xfs_attri_log_nameval_alloc(attr_name,
-			attri_formatp->alfi_name_len, attr_value,
+			attri_formatp->alfi_name_len, attr_nname,
+			attri_formatp->alfi_nname_len, attr_value,
 			attri_formatp->alfi_value_len);
 	if (!nv)
 		return -ENOMEM;
diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/xfs_attr_item.h
index 3280a7930287..24d4968dd6cc 100644
--- a/fs/xfs/xfs_attr_item.h
+++ b/fs/xfs/xfs_attr_item.h
@@ -13,6 +13,7 @@ struct kmem_zone;
 
 struct xfs_attri_log_nameval {
 	struct xfs_log_iovec	name;
+	struct xfs_log_iovec	nname;
 	struct xfs_log_iovec	value;
 	refcount_t		refcount;
 
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 758702b9495f..97d4ebedcf40 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -132,7 +132,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format,	56);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_qoff_logformat,	20);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_trans_header,		16);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_attri_log_format,	40);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attri_log_format,	48);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attrd_log_format,	16);
 
 	/*
-- 
2.25.1

