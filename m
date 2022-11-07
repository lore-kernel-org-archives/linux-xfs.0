Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D950DC43219
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Nov 2022 09:03:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbiKGJDL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Nov 2022 04:03:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbiKGJDJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Nov 2022 04:03:09 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A4115FC0
        for <linux-xfs@vger.kernel.org>; Mon,  7 Nov 2022 01:03:08 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A764BZr018998
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:03:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=FuweUXNs/mHpq8tcHmEQakMY6UvqeZF7ltV3oypreb4=;
 b=HrjmXigQC6l+ySPK2pgmTXFQDTcwSRjqX9uNdA5PzeVzCTOTrt2ZEMxTUxjcXxfGPVJV
 CZXYrhNYIdynF6W954aFca1umBR0Mk/94L6TmYv59aAARiNs2gMGuk7i+OdDNYu3sOgm
 PkeTTsdd8SLCKd//0cSmnvsWr8vuTa6NdWbQ0EzUZV87myI6/6rjMKmQNvOBvZoi13QT
 ENY/cNvLhJVmn+Go0e40eYMUyE+B0GiDbX2nYhq5sYlrKOSOtKJAUfClbMmyrJLuOjZD
 OyzhOCGWZvvV14uAWU7Vaoybs9FHJoVr1xu+byqE0LLnoh/F08m7HOZO8KN2P8pIa6S0 ug== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngmj30j7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:03:07 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A77lfFn022925
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:03:06 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2045.outbound.protection.outlook.com [104.47.57.45])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpctj2kh6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:03:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ljzN0wTlAYYmx6EJeqondMZKQ5Js8YbFJA0Taj2CvzSA9ZGDnUVHjLNqgft9f2ST6LVNKhl3NPjp26AZkpcEvF9i4hIhbh7BqpO2upF2pQygUc1TocsKklvDUp9Wse+cipoaFU2n+JiZxNJQONy0TMmUZxQ2VrBV2kt5PQhuZomQRzHBjYUU4F6eoZqT3xvc86QRrOvpclgC8Bd4fQcgqzrKCmmSKz9u9YRviwUFOpO4ffITmi2PrEhdVY4RbN4WN5l+PbJKoy+cMFxClOusrMJSIcFon5ZZyd/YryqlbIXFc9off/8JpyjOt5QnE098t3NQrFY2beR7y17Wd+I0cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FuweUXNs/mHpq8tcHmEQakMY6UvqeZF7ltV3oypreb4=;
 b=a8L1KGXCEcK15iMlE3fAhFnE+Dw1TeTPYUOViUPxQEBCvXmAHE+d/6gOKE9JtHZCxTiPRDb1AhSYbILRD59/m9qhCqrHYlaL4/FW/77xURruP/JFxvfhcB6QbUTtR1xXR3ZZiVHsqH1uOLqijzXZ1v4xxExLAO8TL6sEzRZ87gG3FyfrZAC0w2FX+gf6SzW4xcEgbPagvY5M507vyBxwPeDk4TulZJ1Ad7MfsGD0uM1Gam/7V85uAVZGMLuZLp20DjtvzHPwtWV7LHeRhBWTbY8CPRJeqIZXBsYZUKWUHkfhBUrvMinW6C0Hqjt9NfALGSgweccKGqKSd6ZbaF791w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FuweUXNs/mHpq8tcHmEQakMY6UvqeZF7ltV3oypreb4=;
 b=JvAuKcM7gEnWN94k7Jv4vsdxJ36cSIGg3kPq/zhvedY+XMIEsUfCHHoi1AoRsiwlXUJ6Hm37dZvjY6yv8uJlOGYYRDxD9OBR2Qiqp71QX0bKbSjOq3wObDRhls/zBN2bduykdN1kP7gMK1orcAqVp8PF+YnqNnqrL6bHMTiD2L4=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB5848.namprd10.prod.outlook.com (2603:10b6:510:149::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Mon, 7 Nov
 2022 09:03:04 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%4]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 09:03:04 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 12/26] xfs: Add xfs_verify_pptr
Date:   Mon,  7 Nov 2022 02:01:42 -0700
Message-Id: <20221107090156.299319-13-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221107090156.299319-1-allison.henderson@oracle.com>
References: <20221107090156.299319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0069.namprd05.prod.outlook.com
 (2603:10b6:a03:74::46) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB5848:EE_
X-MS-Office365-Filtering-Correlation-Id: c8adf814-d5b5-491d-8482-08dac09ee15c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LQi6bJk/5KTgMwK/ilO6lBaMDAb13vjUMkohE+m5/Gj0q+OrK0zhYxQgkg2lpoWb7bfsoU3zyemGHPv+bd6nXP0AUX9c4vHmpL3+YGnenzJV89eEPSd6aa+XzbBWlr0oiN1rBiNa30JxyKWOnDYyMhwWhhVcbheZdyhZfTZhTSYjRc54+MPyHd0YXFerPDT/E6SV+4RsL7Aq0hb5i5cLw5J5Fsg+X5O1OhdMIOZ2xMYwHAgn/2UID1FKq31x63j1Q5aW8UrP36/pTcUUh37eQDBZ0+C4qZff2MzpkIQ7bte523RQQOxuXJN5CQMhsdOKHWI67qa3HJc8aCRa5Xki/Q+2B/N2uFAcy0FNCesLPLrR17s4Na4srnDz6pwygAznSGBfyFo7VMhul+Q6Di43xVR9nxt5SeTtNtRJveItH/djdEXU66faUKbzbl+Hg1BJhpdP7c4LxuGBGd1lqSBIFLpn7p9MygCsjclrpc2GjTVVCKmDMtkDqkxtx+n5QHljY1UMSR0KvM3KwkgKhg7XQl468T0Eno2I0fiTFagQzsDe1vspWIv8g+3yCcuVKp4CdQKHzNZtgfnQsaV4TQsj+WMBkIGV7sBb5inMpqAHdVQOiOPcHMmrzyjNVOFGwsYFqhM++p7D06HiuMSP+DkBaPDh0kAIntuZBGKBKwyTX61nuHoIDTN3C2QZx8+MsuHqgpqybP1il4X9Ssj0SREIZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199015)(36756003)(8676002)(66946007)(6916009)(66556008)(66476007)(83380400001)(2906002)(6486002)(41300700001)(5660300002)(8936002)(478600001)(6512007)(2616005)(186003)(1076003)(26005)(316002)(38100700002)(6666004)(86362001)(9686003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a2thFBv7LXKNYv6PIgDNGCTupErpEUK6DTZPjsGBCOJHj4W8NYvSrLid12gx?=
 =?us-ascii?Q?FqV60Qz0cp4Ig+gO/79FfxqLJFWl9/CFVIbl+9fnl7qzUXeG9SWFguxpHk7E?=
 =?us-ascii?Q?nHPv2n14lxydHBJ6AoMgQK8ENcxvY9bn4/QTrLKPJgMD0DaJgtqSbBqRZoW1?=
 =?us-ascii?Q?E+zcQKbYhb0GpFVV97/TKRCih4xc6iB9eFdu2NR/CdZLKXbtHBTEr2zqJm5v?=
 =?us-ascii?Q?Rd34UFsYfkNWQLCSfbwfAwHdRQ07b48u1Zx/h9FQG+saKBYuce+q9n/cXddj?=
 =?us-ascii?Q?seSz4DSdEe4SzCB/Fqa6c912PmKQAtDAplK4i83qtTgOJB/gtZRc7K/iLz1q?=
 =?us-ascii?Q?zDGWDdgE88mA2DTfleMC9M9ae6d110SJpz/6GtHAz1qMBOGamiubV+VNwQx+?=
 =?us-ascii?Q?Bgg+lVxWf1OgEr9Nchz7pVxk3nYSIw38YB1XDTDat1QMEFKcmMyy2faApfow?=
 =?us-ascii?Q?s9GbuABzKrmC7S8VCUDat/Y3yVs3W3Mj6/+06LIoS2koqGuJrQQ1iv+ZzZn1?=
 =?us-ascii?Q?UoHakYFTRabeU4wYZVbyqK0ntWTzw+hqq28ecYh+rqzMDIkB9z10Rc04/165?=
 =?us-ascii?Q?Epvp/7+etzUkAHTxp977SmYbkBOvInPrJbr7Yv/DOb2LEE1OJybef1vGbnv/?=
 =?us-ascii?Q?JbHHvBhOw/HZECLwCdRJrlv1LZ913+bPzN0nAFyf73xEnWrVOv6uBQ+fXJtY?=
 =?us-ascii?Q?L43yHpcexZ8ep88zNxp60jrbsTjCrjQA+jZcz21nhQFZtsx/003r+DnCVpYE?=
 =?us-ascii?Q?ETzeBze1AAzlGahpYbgG+jprrRF7Nvaxz6DUSiXXqeaJe8GZrRSqOsk9tsTm?=
 =?us-ascii?Q?2+TUALLTJ+/JQ3qpDmAIXzOdDrmQGE1avj/vX0eIcOY9k64RHDWyjrfoFkv1?=
 =?us-ascii?Q?WUDhhdDOWBHwIGMWWcysQCPJkPlD2J5jfI3N9mvenFVKlsnfbtutYtw/GFs+?=
 =?us-ascii?Q?yDRhDf8lPfzzOqGUaWEFE52btDhq2+TGHwE90iUJWmOHwchfNf1ZQRb4AwwK?=
 =?us-ascii?Q?+6HzKH6z0zccSoRBE1SYRhYRPwSDjX3Sw7xhUGmd92e4SSjmZMj2Gr5mW2Hw?=
 =?us-ascii?Q?XaqqW+6OAI87kfeV48unwVqnFgqgC085Fx9HFgs438yndH0mktMqXIWTsjoL?=
 =?us-ascii?Q?5iJB+CDVKlyiM/YslPAsk3AalhaFGScRYrpvMcIKw8DpDD0E5wfJ5MHwxGN1?=
 =?us-ascii?Q?NRT1vcKnXfQ29EmzL09G3prBeUkI7ZVFkYj2ugQYmrBZUTZa7G3iEkJKhiT+?=
 =?us-ascii?Q?R7MFCnSBlKb7lyCnPGjV7DmGhLAjQqW/1z0h93T49hwGKl3YLiq/frOFenet?=
 =?us-ascii?Q?1DLh/z18hAfJaQ0u4Upema3Xx0INkjEGJrGWwKcBKh/+hBTO5P3Kk/YM3TZm?=
 =?us-ascii?Q?z35SUPsmZdGUJeKFZyapHntTY88/DYvPsaRkvQeuuaShngluC1ygAAFJL3Qw?=
 =?us-ascii?Q?S7zC54vMWP4LDZyZmiQaNpl+6ZMe2S1De8eAQVKPS5WPAZxkuMOml4qSm+G9?=
 =?us-ascii?Q?MkEAnH2oUn+E7Yon0paAhWnmFLVl2H9pS7EZ2752QqhcrXWIHByJFyI/yWc3?=
 =?us-ascii?Q?uVYmdzs3+qnn8p/z5J0OaaQl3L+gh1xQmknF1olsGHVxjQVGaoilMTX/dmFN?=
 =?us-ascii?Q?rg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8adf814-d5b5-491d-8482-08dac09ee15c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 09:03:04.5743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lcdQ1xnItRqevVlCRNUgNFIXu5LpJLQ5X8HP4bPU+gFFWgo7m67Az0RAkiG35jQa+js7tyjfhEYqfAPqUNRCAu0ayjd6lEism7ywiRLxQxU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5848
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 bulkscore=0
 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070076
X-Proofpoint-GUID: zwz6X2Bx9NMF7BOQL14XsakwVQi3Fa8T
X-Proofpoint-ORIG-GUID: zwz6X2Bx9NMF7BOQL14XsakwVQi3Fa8T
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
index b6f0c9f3f124..d3e75c077fab 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -128,7 +128,7 @@ xchk_xattr_listent(
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

