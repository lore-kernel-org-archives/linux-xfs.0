Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 310E5C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Mar 2022 21:07:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241015AbiCWVJO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Mar 2022 17:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344879AbiCWVJD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Mar 2022 17:09:03 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E04158D68E
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 14:07:29 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22NKYUvv011998
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=3CKt3Kwzn19dUSRfAM8d8zKP6m2jL9pOOdLbeTl0s6g=;
 b=k37aPJdMBwFu8mwXwB+tCPWU96Zd/2u7JkuS6btVWXc2fgNyu4mz2Ekdd2zMYJPvsYyx
 U5wFxwve9UKkXKPG26Mtq9hLLKteMwebWVF2Sp+z6I+Ad13Bge7rSPcg/Rbx5IZiMZuh
 bgAGYBbmo+WQePC1aEdQyR6ExWLcK67lbxeGL3W1Iqme0rojMdFnc2eNlXSk7zd7GMdh
 bIUFhAYBBbcw0GkQ55Z/HaBTXhiTyy8n2A1dYyVOJzBKZ+FVPc+bPQxg6j9mGL4BwWpB
 qw/d68QAlrpQXGyo6gD8h914TBWSAp+4BH5IdwpPq4a31iJNA4vl4QVhGdMkKQHtJ6PP bA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5s0tt85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22NL6R9m154749
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:28 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by aserp3020.oracle.com with ESMTP id 3ew701q88e-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TVOa4Z19wYxhPcriVInkcD6m1Vg0FCUwff+HslsUddAJOSjcRAx1zlXpwiy4V6UJUBuHykYeC7xuza9TzNiQkrbDugCM9ZFoXewbrzbikFhxmjHGydEZQ4TlwsCso3wHfvNPgtTez6P9VICEgvIvrigiFTkqd7QNlkDFarubw0WsbCPMM1SoRXGS+LcmODEtVGKm89bHGXpXn9l422sXdXCmAVpBEZj1HtJlvzI/ndtJh9SNFi+qUjRUsnUz+Lsw134cFZpjmbN8b6ISS3fIMpyE0ypumufjdJdTUFyVbBk6kM6PYmyt6wrDwzWPCLZUbedOPZ0q8sVIw2qNfOEz9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3CKt3Kwzn19dUSRfAM8d8zKP6m2jL9pOOdLbeTl0s6g=;
 b=BuMekyJZd800U+ecbLn44YwSSsuFeI0zXL2Dl//Sew4SSi25+Hl3Bz59rEZASPCMcAp/cRwXq7vouqQiGUN9pplXlJOvmfDOsOuAXc7OEE0isMD1jAg7JZhGpTzUjE2XOPboY5rmL4uIyzJSO8XMybbDgn/Gd9ZObc6D8b/RHZUa8rb+nlMxfSu4ykhl9uHk7o0g+FAbDogl3d8gTqRUb8aOIziKrN5Nb/CphNspzp2W3szCpKHG50MU+kGDW65Ct4BFU7OzRo83IwBRiTg0M/gD0chYQZTfi5kvH4ag62ORY8KYT2Ed45W0pXe7bWISkT3b0+WugAGJbbIOa3AbdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3CKt3Kwzn19dUSRfAM8d8zKP6m2jL9pOOdLbeTl0s6g=;
 b=IzwSahSWwYaL+/45laTLsO6lyqQo0zUfEYmnm7rm8Y0mv4R62q4F+rvK8P4ia2eKnt5L+zd7eSLlwlZoDfqx6+Nrfeikl4sK6ZiE1ojitImJ+aPGUON73x693BuyXG8mUgzu7kQruTRRJKyjIJFV5C+TAx52Wjk/ORzPn7fC+gg=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB5600.namprd10.prod.outlook.com (2603:10b6:a03:3dc::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Wed, 23 Mar
 2022 21:07:26 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c517:eb23:bb2f:4b23]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c517:eb23:bb2f:4b23%6]) with mapi id 15.20.5102.017; Wed, 23 Mar 2022
 21:07:26 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v29 10/15] xfs: Add larp debug option
Date:   Wed, 23 Mar 2022 14:07:10 -0700
Message-Id: <20220323210715.201009-11-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220323210715.201009-1-allison.henderson@oracle.com>
References: <20220323210715.201009-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0084.namprd07.prod.outlook.com
 (2603:10b6:510:f::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30d09e35-cc16-4a70-e31b-08da0d112214
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5600:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5600C58B9BFCB68597FEB8E695189@SJ0PR10MB5600.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fqkgO9eJd+75cnNxNg7ZIwMn11Pkv/4NP30H7GfVdAFEsSC6+gajeVrexHp0fZIB4JyOcizClLudZjnGRDuomb9rjbY7Xf31PZlSAGqnRy8oGwW5AhAtyQ5PuHocSzTnhIuMaForDtOzmKPOr3a/4L0V2lFF98fsLPbnbVzt51py2vpNW+qb9rJKFxo6uuLKamSEKjZE4KlounTbZ+Y7RLw8Arg15Ve/IIxf3Zz6Sl3+cYPSP5PpQJWWmOZar84y70ogK4vUNpXwnYUEKQEepgCpUMuHB2Gx7IaPH6cIXaMmqprcn/J9y94UTiGFr/QelTzRcElH+j9in2vk1vhWfk4s31t8iNIPvHsa1LrQhDVtxDybGCcHt214303/Bsada0wJYXY4MVZUOM2DBBD5nFNb4hwXIwIQf8syRNaXZ2RbwDuZEGsDNmY2+i4jlRP9B/cb6H+ehH00lhaA7LXtZW82mI+xngl7Xc4PzS16k6BLKjcXlsRFkTwT/KmXdpTYQdE5K8sd6AxO3Ou93tkj2OyQb/UOGtCp6Xjvia/uIdwoePHVVOFDnxhH0xWeAoeXBjokifgJ/LOkE2COvZ9XLfBRZvHDlGocqv+0QwoomQ11w5NglmzZ6pgmxBkHbf5Kt7XuflWhbtJ6exXbMMcvD2v2kBjDDV61haUpmqAHiaaLtZs39/Jq7xACJojGMnaIXAracFJSQZ9vp7iyYguZDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66556008)(66476007)(66946007)(44832011)(8676002)(6512007)(83380400001)(86362001)(52116002)(6486002)(6506007)(508600001)(6666004)(2906002)(6916009)(2616005)(36756003)(316002)(5660300002)(1076003)(186003)(8936002)(26005)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Jpv0CvzurFJJ/tZMw5sDoqvI7b9YyBGWCHrs/vyex6EMmUMTmMgSPAv3W7ab?=
 =?us-ascii?Q?+GzSw+jYBw2LjF3IGOKPxRB4lwbn8X+BUgHWmJCmD7Dfx3cm0qV1ydKvdyJZ?=
 =?us-ascii?Q?AYDaNP2f/5+nMcEOEbS93RjVZPsoXz7FxYCzfRJ2/Eqx4Kqpcwf30CgzVy5l?=
 =?us-ascii?Q?JC4e8TSsBVUWD8hG1GQ0xDh6JxZhLzRK+DoE2ROk2oFFF9r7bRprn3q3qBMl?=
 =?us-ascii?Q?MYjkWHzuAlw1PMCqv3kvFhtJfDgD2DkzwgWBvBlaFga+isbnbRjTrqurgNWP?=
 =?us-ascii?Q?B/+FpozEzXIk9Y4WI7Xn06+iRUqC4aGKyZ205tqknie+jJLdBQdpnbQwmhXV?=
 =?us-ascii?Q?0Wvlb0qNBs7y99jOvfMf99TkUkQQAwAgM0AbtRrhVtl50K1OTmD2tk17IHHd?=
 =?us-ascii?Q?Gq0Ep0rFV1XkMAJb696+/ImdssGNonLTfkBRPWuqvhVGwVfas1+NmDUBntZV?=
 =?us-ascii?Q?p8XC0yqGlvJ0kVZweY0g2GJeqiIz1hoT3/uR30DkGVLCNYXW1J4693soWpJD?=
 =?us-ascii?Q?Q51FfzLPn7FIPK6Tkb7sTZe2NJQ7/1TMyxbgwBPTVfPfDCJd4exwsarjcs0E?=
 =?us-ascii?Q?nrVZLdX1/52jUE5ByPG71MoDZSknKBcB26X0NvOjaRjsCzI1iblwWnn+Tx0P?=
 =?us-ascii?Q?U/lBuXVnsgYkOMr2VbLgCD4mRHsS6wI8CE96zDsiAZ1rSfC+f1cyNwVw/HCW?=
 =?us-ascii?Q?dsYEa8++7w7/W7r8W7C7V4RSspf1idYrTHX6W0D7H4pA7tvEfxNFG4yFfP8q?=
 =?us-ascii?Q?2nU4Uq0YJC13XLL/0LSlFc37VWPUNfKrafoa8ckiZfSQsQJjwViYCwWf0at9?=
 =?us-ascii?Q?ddX+p02RagvTx/f41s2BzwXk5fyqSjXlYz997MpF1pYRh6bdaosx4h+2oQqT?=
 =?us-ascii?Q?kCFbGNbmTatsIMvPQvuGy5pgQszvB0aVp2r6Xn1nBH5MD5HMlYbU6h4U10Ci?=
 =?us-ascii?Q?pt7hZF9kXG89/BPt1a4vDqQQ96+pEfMB7wFYEbwmKVX2Ctk38qvToexKPXDi?=
 =?us-ascii?Q?zu7MxvojXOS6zf9lECxv2vCHx/yFBF1Ed3ecdC8PniJr902x5L4syCoaDA1v?=
 =?us-ascii?Q?wPavV1i2995DSXLI06XLxtgM55Q618ZhA/KOORoPrlBdFanTRu2rS5rhFlXE?=
 =?us-ascii?Q?bhk+6oagK9Zy0Bp/yNaGLVWP3CgFt39lIt2oNDZ3Bn6zi0WmgQqkmfxcuZ+D?=
 =?us-ascii?Q?kDrb0yDEPfME27QI1ZXga7Zlbc8tpE4o6eYQSY/31Z2nopdC1gKy+gOjQ38a?=
 =?us-ascii?Q?qfvh/W0Z1aNNmSHsPOXr5NhIACFkt2xiGg0MFZDptqkqf+CncaK87hEeCm2I?=
 =?us-ascii?Q?hYtyK6DzZKghYUdOFgeh5IRXX8xzkc5pl9yCmOJuK7nXjyDyjq3ExvbfN59k?=
 =?us-ascii?Q?MetILcegSRoEGt/hZy4tTGuz2x5t9MTaG4q4Es89f8C7GjzFNy4ufTkYXapZ?=
 =?us-ascii?Q?ttic1mJO42d9ZuzI9p9Bk7dnW/pqwLg7JeFNvn4eOw9OWkfMiTFENQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30d09e35-cc16-4a70-e31b-08da0d112214
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2022 21:07:26.5464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1vkqNtv4X8n6ZFMsN80JTzF0oq4jynoHLaSg9QEIk4LNsTbX7bulPLt3birxUkMBQYO3xDuYxgKbTyrL8LYwZkukEp2ixlsr0m0kMj3Mpms=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5600
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10295 signatures=694973
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203230111
X-Proofpoint-GUID: 68SI2IIPURhV336uFO9bo6ZvmwOwXi5s
X-Proofpoint-ORIG-GUID: 68SI2IIPURhV336uFO9bo6ZvmwOwXi5s
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds a debug option to enable log attribute replay. Eventually
this can be removed when delayed attrs becomes permanent.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.h |  4 ++++
 fs/xfs/xfs_globals.c     |  1 +
 fs/xfs/xfs_sysctl.h      |  1 +
 fs/xfs/xfs_sysfs.c       | 24 ++++++++++++++++++++++++
 4 files changed, 30 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 5331551d5939..78884e826ca4 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -30,7 +30,11 @@ struct xfs_attr_list_context;
 
 static inline bool xfs_has_larp(struct xfs_mount *mp)
 {
+#ifdef DEBUG
+	return xfs_globals.larp;
+#else
 	return false;
+#endif
 }
 
 /*
diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
index f62fa652c2fd..4d0a98f920ca 100644
--- a/fs/xfs/xfs_globals.c
+++ b/fs/xfs/xfs_globals.c
@@ -41,5 +41,6 @@ struct xfs_globals xfs_globals = {
 #endif
 #ifdef DEBUG
 	.pwork_threads		=	-1,	/* automatic thread detection */
+	.larp			=	false,	/* log attribute replay */
 #endif
 };
diff --git a/fs/xfs/xfs_sysctl.h b/fs/xfs/xfs_sysctl.h
index 7692e76ead33..f78ad6b10ea5 100644
--- a/fs/xfs/xfs_sysctl.h
+++ b/fs/xfs/xfs_sysctl.h
@@ -83,6 +83,7 @@ extern xfs_param_t	xfs_params;
 struct xfs_globals {
 #ifdef DEBUG
 	int	pwork_threads;		/* parallel workqueue threads */
+	bool	larp;			/* log attribute replay */
 #endif
 	int	log_recovery_delay;	/* log recovery delay (secs) */
 	int	mount_delay;		/* mount setup delay (secs) */
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 574b80c29fe1..f7faf6e70d7f 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -228,6 +228,29 @@ pwork_threads_show(
 	return sysfs_emit(buf, "%d\n", xfs_globals.pwork_threads);
 }
 XFS_SYSFS_ATTR_RW(pwork_threads);
+
+static ssize_t
+larp_store(
+	struct kobject	*kobject,
+	const char	*buf,
+	size_t		count)
+{
+	ssize_t		ret;
+
+	ret = kstrtobool(buf, &xfs_globals.larp);
+	if (ret < 0)
+		return ret;
+	return count;
+}
+
+STATIC ssize_t
+larp_show(
+	struct kobject	*kobject,
+	char		*buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.larp);
+}
+XFS_SYSFS_ATTR_RW(larp);
 #endif /* DEBUG */
 
 static struct attribute *xfs_dbg_attrs[] = {
@@ -237,6 +260,7 @@ static struct attribute *xfs_dbg_attrs[] = {
 	ATTR_LIST(always_cow),
 #ifdef DEBUG
 	ATTR_LIST(pwork_threads),
+	ATTR_LIST(larp),
 #endif
 	NULL,
 };
-- 
2.25.1

