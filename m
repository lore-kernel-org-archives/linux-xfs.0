Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2456BC678D5
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Mar 2023 22:38:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbjCHWiv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Mar 2023 17:38:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbjCHWir (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2023 17:38:47 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F376D59811
        for <linux-xfs@vger.kernel.org>; Wed,  8 Mar 2023 14:38:46 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328JwfA5021962
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=osx2BRmek3LOfWl8WanI4Tp+HkrnP616x7FMcCq8FeI=;
 b=GMrTI/7sWBtNLWCCe6mltzc0jglbU70125w4kYnqxmX0d+hoBfwYpJmjEFwoCla2EE0U
 LKZ4/LdQUEB3erTnbFAMNf6X87D9X0Q7t2dzvpwumyWEK7JPfi7LDxc6LkzkgLHXwwkq
 9R2t12AyFoNbTJjht9cphjiAZFpIE2R/WAwA/NVuggqMRl0iidieSO6ffd+S26t83zSh
 Hay/ye83Safz1q/dlTH9TAP11dgKLSHaBIVMjVXjcjfn0tLZN/ts68lGrvhbeQMqgVzy
 xM8/Le+Rsa4F7mnPMEjJx2bKmZViNAmV9yIAApwKq53N024YVvpXGvJ5U/fo/hv1Mp/T BQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p4168se0y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:45 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 328LqwPE020912
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:44 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2049.outbound.protection.outlook.com [104.47.51.49])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p6fu8my6f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FT2G16gDdl/HPiW+sQx0kqRsv8ngD4KSkKTxUxwyAfYrUYLzl8rt+c08azsHq3IIDkIfEuRUgzz1HV5swxYVNy8OyTtzlq1MHfWsUUNE+pG0hC7PzkuchTQ4RRw0HNwepUEW0vNZajmFGuwYWGDyrzGT3yxCoF+oeD1E4yL3KYIiPlnXiyzFBhDuqXhTZ8Z+nW/ab94UEYtgFWuCS7eQ7hjxUE+r3gMxVUYSYnHwdbbZ9Zvo+Y/ilAv5JkUQPxZ840VGM5EK3RmCRPnVZBfLblmecahAa3qNaeb99LiYOqmfDjKRW4HEkMf6ueqhCLx6vrh8H3ygB0eAhtcA6A0PjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=osx2BRmek3LOfWl8WanI4Tp+HkrnP616x7FMcCq8FeI=;
 b=MEwGdrEpnuk/m+NE1Ph3ZZzpHrnNrnWLYwIqHF/hg9enR2IGKJFvxqaeyEhm3wZA2AELFwfL1rLAy6JJtM4jYJUx8R/8i5zHlexKt5TOgRKl1GzOMfkgTXo4qI5yruOcUmfcX49qeIN8q0osco7qxuheQ7hHh0fsse+xATLMyP/bTlYjjPkqT84KhlGUF5NxytI8aZR4MwG+nCF7ozlQi7LSPG2Q6xKZ+i/8aW/B9OdI07Qu8laWLYpuB8jZJUD4i6fCzGw+NC3NU7v6VEIAWvxPb8dsCiy249uPiDglZjtmtcwTXZF7eocxVePpsibOqRmwYzG/WgpO7OzigjgN3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=osx2BRmek3LOfWl8WanI4Tp+HkrnP616x7FMcCq8FeI=;
 b=gDGnrzTl2focu45oa/RDfjw6jS5V4i+fCLkQUBkgofgnuWv7PgH3zKgqMiGfWqR6EPpRB08VKeE+63m6uqfvl3F020jDPujSlduobJRpNebr7pQuoWnLDYfzJ2yrzkQKE76UCNYxQTD07C18WQIieZ4OvmS155AoWYWYqk+Buqg=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4162.namprd10.prod.outlook.com (2603:10b6:a03:20c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Wed, 8 Mar
 2023 22:38:42 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06%8]) with mapi id 15.20.6178.017; Wed, 8 Mar 2023
 22:38:42 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 25/32] xfs: pass the attr value to put_listent when possible
Date:   Wed,  8 Mar 2023 15:37:47 -0700
Message-Id: <20230308223754.1455051-26-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230308223754.1455051-1-allison.henderson@oracle.com>
References: <20230308223754.1455051-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR22CA0012.namprd22.prod.outlook.com
 (2603:10b6:510:2d1::8) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|BY5PR10MB4162:EE_
X-MS-Office365-Filtering-Correlation-Id: d90f4146-237b-46a9-057b-08db2025de70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DfVx8pkv+pHMMbyO4k3lNaAusjBFN07l+sX0qUsusHsovFb7ORdm4iq5DEuABbbZ1lpKxX291UcMcRXy6vjEGB+PWkq30YgQ//kvMHXAmUm5yhM/hHDhvB/u1KVaN+/zSyeI7gMbJIr+Vp4vgf1sBy0lel/p46X1zrXNGecSolsVLFaw6LTxGLi7o/TbHex5rCgjpIMI2qEyKGgI8cyfPui2ITCBP8RFt/6eX5G+uC3d3+gSYQYX8FFHi9I1XHgfqTEBJlBaGRThif3u1XCb3+IJCXaiulgRZLx/Syxb/+yWYCu6uhvGJlJhP5y/UtYBQjV/MVwMbOJsOxhptjxGrzTJyj75w3J/PiLC3tpJvl/PnZkBnZ3imPY8F7Zi6Ynj4ccEv7fk33hWGuH+xO7ZQf6MzIo8AvytXOYG/4VzjtGSghJIOR//W5AKD+xonS1O/VDziW8HP9vySZv0cs8ftyeYaHWVYEnm3FnUM0xtr6EPXpfWD7vMyx3Q8uLHK4AmGbr65X4sOi12MPryNiTdSZjEeTezAEQihzbp+773ZWIinDAixlt1Sq4U2EXesJj8915Wl6B2qDJ91fn5Z1ObL7opA5DtlGl5RkzDsB1flp65TxhbdzST0/DAqGruNYrnjyZBf60eFoELQ/Dr16kjeA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(346002)(136003)(39860400002)(366004)(451199018)(5660300002)(8936002)(8676002)(66946007)(66556008)(86362001)(66476007)(36756003)(478600001)(83380400001)(316002)(41300700001)(6486002)(6916009)(2906002)(186003)(38100700002)(6512007)(26005)(9686003)(6506007)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L0gBsUwyl0HTAH3J7G7qQSDrZCLSKmnD96gB3ZFQ3okbfggPcA2HafzIiMwb?=
 =?us-ascii?Q?L7wdRM8Dn/eWRI+d8KJShY9ofAVQXEcdIexG1r2jTuikk91znwsUEAL0JqBi?=
 =?us-ascii?Q?xVpGNIzJ49s6IvkpC+H5gVvMT4xG1RoNzrdDm7/rus+qy8fz4+pqzZTiIw9g?=
 =?us-ascii?Q?tyUfPhm1fxcIZbRQXKC2/yWuEHSO6hU1g9jkpYTGXQe6CeORJJIGE81Vnsq+?=
 =?us-ascii?Q?mf98Pv+GpS5ntZqNqWGcikD4DMmZbWr7OUUte11y57HRS8OdR1qBdcC+LPuM?=
 =?us-ascii?Q?bSubV6DAcC73miNkf8mtdsE7ZnaQm0v25Q7aGgJXdaJys97nIDsfPvl3Ws+I?=
 =?us-ascii?Q?Fjf3CLqOGN1f4HRjJ+6VdtV7K/p/utc7KmKokuc6OlduC/hmWCBC+p6Ps1BB?=
 =?us-ascii?Q?lk4h9fYKyWrD02AUEkR3DkIYH0XHGB/ViJsCAhGQBmzAJFktmrrAwN/LWYO+?=
 =?us-ascii?Q?aBICZ1ldlt8vgKXi4eDSuusgjvkQoQfBJimq5uUzMqHWXuxhxBdJHVam6qNb?=
 =?us-ascii?Q?nmr7OWERImJ7GqqD65gEd8tSXkj9QFHGlnv9eY9W/yIIajvQD51vwYk+eu5Q?=
 =?us-ascii?Q?niTji38ZA5IX9crn+ISlHArusuJ4c8Hxu8EDpUV3FC/1JRp1MRLNRKZ7GMI4?=
 =?us-ascii?Q?i72yMVibUzTJxxYicNN7Q06rzQGRMUt3tErj6/O4rYEur068xOD65YGUC2/r?=
 =?us-ascii?Q?SgeahIt2OFjlCCRI4wiNzWlEMS5pJO1UAsmgiR6BARitCHtOsyuvYLXCZy8n?=
 =?us-ascii?Q?k1JkqxmEaH9Z9KTQ/Pf5xBpNp/0m383bGJgUbAk2Zok8i6nplragBgt7XiLE?=
 =?us-ascii?Q?TZrgu/6xdIWv0Vsaq2nGiSJJAWV26mcXJAqemZFy33jVGKQ09Yvk4ulU88ib?=
 =?us-ascii?Q?I0j85T1aCkdGaJHAumx8nPpKYjNccfIrIRWywlcBhkICCvIS2BDIoD9xCrk1?=
 =?us-ascii?Q?k17cM3Q6wAkS2gxGnXP7WcC9Ey56+IwN+CpEWYbcFRSOkc6yNaBWCkdIlNjI?=
 =?us-ascii?Q?DjtDyO4ERzRuvN6cu7Btyq+Vq2CaQWDC8Mc4Xn3gIiVbxVC1TMLx0v8dHu4O?=
 =?us-ascii?Q?2Ll8odddh1PJvwPI1ugO/kzL9ZlZszT3iR3ZNWdPHte8p/2tMv3Jc5g17sDD?=
 =?us-ascii?Q?DopO5aK4CHz64ClzKFDFuM4I0nGVgpQYfa47I5nYIJZX6ORCoMODW0ZaKnkf?=
 =?us-ascii?Q?aclyUBFSxrusEWv3mX6QJGiuPs7Q2+VmHxftmGENua//TGgQHyeaqOCVnGF5?=
 =?us-ascii?Q?N6OBBp8k8ZWc8CM1YlGdBUfYai1Z1oUo1+3nFvS14SpQsxAEtR70P1Roq6Aw?=
 =?us-ascii?Q?2zczXGORIbrPl7obgHZRSbw9dpzEGHcCfPsic+bco8VkWkRZCUWRrmdpPW2N?=
 =?us-ascii?Q?1dS2ALSHaElD9tQjdEUzbEyWZpa0TbYfP+iJHJrF/ck/yMuF4vYErnhvZ0Y1?=
 =?us-ascii?Q?5aydebUNFNQNM3Eoy2Xynm+2zzCZD03aLM7h/U3TPbbuXE0e4M7cRN0bydVY?=
 =?us-ascii?Q?9p6izJf6+cuaKaWsVAFD61xCZKCZivV6ZPBX1YtNfxE5+eekUhK5apstGBJp?=
 =?us-ascii?Q?lftH+LeAetcRiEbn4a3C/jnafsPO1ffOIKVeGkhpp08N6EHv4JBRFrkeg49U?=
 =?us-ascii?Q?ow=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: HzPlGEwB09/etuOPlCR40eQrrAr4gvQTxHmy/uvE2wXxKwHn3DbqguLgkeY6uMPwxJPGlp9n/RrMqCAISIpz6gNVFdYeuXyZ+m2jKef3oSpPcgb18XMjldBcN2RDreBNerOUK67GeXKA6/S00/26avfwoW3lls18XqxD/WyWJKhs/lw6R8enD1PIGJpa8X7L16WbGwdfu/gNmBVwSbEkqVE75vbA1KErvC/iw/inHOt3KyLvRSVDOo2ySR7FtOSl8np7mG63JmlSnSRFL2L8aIihQ7CvUAcnBVMjm0M3X9ZBSR735fy3p5waqqtqcfAq3sGwWlj8Fj35arQMzDMf7IAAYQJi4etmUtpQDVrrPFmVY/Khvds0qj27tWGeNzaprJ6xNzKfvAnqGW2tL7dyiWdy7wXIkeqaNORPwNe5TS0Oq98OP3QXmtmNRcIoFwiHt6XLS7365HZbcxmugtBEBe9qBYX4yOyFOCtDm0NMnbvLZlUDU5nm1xXNYPP6+MqceNh9TMSB/zu+8Z5EEMmTXsgZRkbmVKwHuiO5h91Lk2Lvqy3e0ms1zjizfIxTJueJqNnHfkb5f/P9juSPQ70DUGfwnPNbV16Kjah+My82i9W9/eGxwwWhtUDBDYxjouxpoWi4pX8suI5aaXKvppKT8im7SMGypRh301K9oEHsjmoQiHlaBVkSeXsTlr2YrJaIsTKDHbWdFrkC6sQRCu6vF/heHUTYCU3mW4epVc5oshF4Evxhjaahyh0voAhxRprYVjtYsyVIfUd9c4wDWQrz4g==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d90f4146-237b-46a9-057b-08db2025de70
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 22:38:42.2706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8teGICxCVE9EiD3k8Tq0lnQioxdi7PQxGIiGzCioBivIWcVTIbn8CIm7A7Ss6o7xtQAtlNXxO7UtPzFCOlfVDx+Js10gn09F5HclCylimxc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4162
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_15,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303080190
X-Proofpoint-GUID: TjUwU660M8xXIl4c8qVVpvEsknFOJctt
X-Proofpoint-ORIG-GUID: TjUwU660M8xXIl4c8qVVpvEsknFOJctt
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Pass the attr value to put_listent when we have local xattrs or
shortform xattrs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.h    | 5 +++--
 fs/xfs/libxfs/xfs_attr_sf.h | 1 +
 fs/xfs/scrub/attr.c         | 8 ++++++++
 fs/xfs/xfs_attr_list.c      | 8 +++++++-
 fs/xfs/xfs_ioctl.c          | 1 +
 fs/xfs/xfs_xattr.c          | 1 +
 6 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 985761264d1f..b034cc165274 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -47,8 +47,9 @@ struct xfs_attrlist_cursor_kern {
 
 
 /* void; state communicated via *context */
-typedef void (*put_listent_func_t)(struct xfs_attr_list_context *, int,
-			      unsigned char *, int, int);
+typedef void (*put_listent_func_t)(struct xfs_attr_list_context *context,
+		int flags, unsigned char *name, int namelen, void *value,
+		int valuelen);
 
 struct xfs_attr_list_context {
 	struct xfs_trans	*tp;
diff --git a/fs/xfs/libxfs/xfs_attr_sf.h b/fs/xfs/libxfs/xfs_attr_sf.h
index 37578b369d9b..c6e259791bc3 100644
--- a/fs/xfs/libxfs/xfs_attr_sf.h
+++ b/fs/xfs/libxfs/xfs_attr_sf.h
@@ -24,6 +24,7 @@ typedef struct xfs_attr_sf_sort {
 	uint8_t		flags;		/* flags bits (see xfs_attr_leaf.h) */
 	xfs_dahash_t	hash;		/* this entry's hash value */
 	unsigned char	*name;		/* name value, pointer into buffer */
+	void		*value;
 } xfs_attr_sf_sort_t;
 
 #define XFS_ATTR_SF_ENTSIZE_MAX			/* max space for name&value */ \
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 2a79a13cb600..00682006d0d3 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -109,6 +109,7 @@ xchk_xattr_listent(
 	int				flags,
 	unsigned char			*name,
 	int				namelen,
+	void				*value,
 	int				valuelen)
 {
 	struct xchk_xattr		*sx;
@@ -134,6 +135,13 @@ xchk_xattr_listent(
 		return;
 	}
 
+	/*
+	 * Shortform and local attrs don't require external lookups to retrieve
+	 * the value, so there's nothing else to check here.
+	 */
+	if (value)
+		return;
+
 	/*
 	 * Try to allocate enough memory to extrat the attr value.  If that
 	 * doesn't work, we overload the seen_enough variable to convey
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index a51f7f13a352..8e3891b96736 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -94,6 +94,7 @@ xfs_attr_shortform_list(
 					     sfe->flags,
 					     sfe->nameval,
 					     (int)sfe->namelen,
+					     &sfe->nameval[sfe->namelen],
 					     (int)sfe->valuelen);
 			/*
 			 * Either search callback finished early or
@@ -139,6 +140,7 @@ xfs_attr_shortform_list(
 		sbp->name = sfe->nameval;
 		sbp->namelen = sfe->namelen;
 		/* These are bytes, and both on-disk, don't endian-flip */
+		sbp->value = &sfe->nameval[sfe->namelen],
 		sbp->valuelen = sfe->valuelen;
 		sbp->flags = sfe->flags;
 		sfe = xfs_attr_sf_nextentry(sfe);
@@ -189,6 +191,7 @@ xfs_attr_shortform_list(
 				     sbp->flags,
 				     sbp->name,
 				     sbp->namelen,
+				     sbp->value,
 				     sbp->valuelen);
 		if (context->seen_enough)
 			break;
@@ -443,6 +446,7 @@ xfs_attr3_leaf_list_int(
 	 */
 	for (; i < ichdr.count; entry++, i++) {
 		char *name;
+		void *value;
 		int namelen, valuelen;
 
 		if (be32_to_cpu(entry->hashval) != cursor->hashval) {
@@ -460,6 +464,7 @@ xfs_attr3_leaf_list_int(
 			name_loc = xfs_attr3_leaf_name_local(leaf, i);
 			name = name_loc->nameval;
 			namelen = name_loc->namelen;
+			value = &name_loc->nameval[name_loc->namelen];
 			valuelen = be16_to_cpu(name_loc->valuelen);
 		} else {
 			xfs_attr_leaf_name_remote_t *name_rmt;
@@ -467,6 +472,7 @@ xfs_attr3_leaf_list_int(
 			name_rmt = xfs_attr3_leaf_name_remote(leaf, i);
 			name = name_rmt->name;
 			namelen = name_rmt->namelen;
+			value = NULL;
 			valuelen = be32_to_cpu(name_rmt->valuelen);
 		}
 
@@ -475,7 +481,7 @@ xfs_attr3_leaf_list_int(
 						       entry->flags)))
 			return -EFSCORRUPTED;
 		context->put_listent(context, entry->flags,
-					      name, namelen, valuelen);
+					      name, namelen, value, valuelen);
 		if (context->seen_enough)
 			break;
 		cursor->offset++;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 59987b95201c..9abf47efd076 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -307,6 +307,7 @@ xfs_ioc_attr_put_listent(
 	int			flags,
 	unsigned char		*name,
 	int			namelen,
+	void			*value,
 	int			valuelen)
 {
 	struct xfs_attrlist	*alist = context->buffer;
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 14a324bbcf59..b92fc38bd550 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -227,6 +227,7 @@ xfs_xattr_put_listent(
 	int		flags,
 	unsigned char	*name,
 	int		namelen,
+	void		*value,
 	int		valuelen)
 {
 	char *prefix;
-- 
2.25.1

