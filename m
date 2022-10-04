Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07DB1C4332F
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Oct 2022 10:28:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiJDK2r (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Oct 2022 06:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiJDK2p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Oct 2022 06:28:45 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F0F32BE35
        for <linux-xfs@vger.kernel.org>; Tue,  4 Oct 2022 03:28:42 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2949EVQD032723;
        Tue, 4 Oct 2022 10:28:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=GaisccWsHTvhHiHV26l7UIAoKUt7Sv/Pe73IE6M9+Mk=;
 b=Kq6xRJEHKfTBrM4DtzPd/XPdmoQ78rIA3tbesP0NlJLIB1SxTk3dcgwZXXTtkM1iwRB1
 fo4NUkR+Wbtf1NZ/QKnbJvCNG1+Ndsb6tIbqGXTtbuwUYmcFhxJjPHzLKE5QuUXtYd0D
 CtRe6ZWJphzpczbQbLkgC/fLazGWFs6vrPBvojxgTo8PU2OxXxlMz6NpJyJc8n8g/1Hm
 moVABtte+wiCFEzj+raqDf/S/wpRyvaIqBhwaO+e+Jn93ZXuFF8gRlZtTp+4gRwgrtIr
 1QfJspZIhYXd/tHvG8t9pyHguST0NESabYL+rULi8ESXfWC1tUN93qVn8BoX+r3E5PM3 BQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxe3tp84x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Oct 2022 10:28:38 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2948AX0S000460;
        Tue, 4 Oct 2022 10:28:37 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc04jjrj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Oct 2022 10:28:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GRHHxByXPUEU5V3cEOwc7GTEOjg1YJbNAV+uyuVZE7TaxkdJpR4qKgBI9e4dCYtV0GHIpvbaVm+crRFPfjFDrwrfoZ3VVAqg+W+i7WB3JESSIzIC90/Re6Om8PCJGl52cZQrKScF02wOTdSMUqN+9VwyIlgBRuAKvAhflcB4FTwmMdbdUsbYbHNj7xoPv4Cb56jcuoUwZDMtbFUMXZizfOO+vQeJKR0ZphyTAe6rSBmUjHOCwASoLwryr550HEooy3f++oG6jPm5G3osIB+1cBbL/m1NyhYnlJ1RS4CYDXFt5lePI720VeUoapIJtnMIuvlZQqOv3uXA/jKj7tHRPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GaisccWsHTvhHiHV26l7UIAoKUt7Sv/Pe73IE6M9+Mk=;
 b=g1DogiPX9az+AUS6hCgd5XTniGVdJtWaR5DNuKiJ33qC+vTSHCgashNXsgw8Vsy3fwAN6ORbARUHWbAbCQYpA5Uxjfu7ui0aQN5akPtnNgT8q3MFZjT9a3oGjv44AuQG45ywlDV7yyWnBbw7SKSB/3L6/13E3ClM5OsUM3ooKHdWOY9MkBkpfkKsNz4AktVXITFszZAk0rDtvymFtBqu4aI8US13z4tH1d4IZiSGg8VRQcNdPAxmFKg/T8SMg5TIkUjyCQL2EffD9KNdoqVY7aTEGn2C7YHKH2L/lYJTUkPnMdxV3O/WE3IV9r8h1fgCgptQ+8mxA6OeWEA44rOiEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GaisccWsHTvhHiHV26l7UIAoKUt7Sv/Pe73IE6M9+Mk=;
 b=OWZMfestnebeFKrl7ei0aELqpN0Pu/wGlmn/4AmhIbe+1v4jbEvRVqkIu5tsGtLSLIGuoo8ThEvw6hs1QwV90YFub32OpSV4cpy6Esv1AaKv67N/qZ/N58MDSAz7jbZ4q7iClwfGOGOhn5jlbWN2f9qnz49IXJRE8RNzlTwEizw=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB5184.namprd10.prod.outlook.com (2603:10b6:5:38e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Tue, 4 Oct
 2022 10:28:35 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%8]) with mapi id 15.20.5676.031; Tue, 4 Oct 2022
 10:28:35 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 01/11] xfs: fix misuse of the XFS_ATTR_INCOMPLETE flag
Date:   Tue,  4 Oct 2022 15:58:13 +0530
Message-Id: <20221004102823.1486946-2-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221004102823.1486946-1-chandan.babu@oracle.com>
References: <20221004102823.1486946-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWP286CA0031.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:262::19) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB5184:EE_
X-MS-Office365-Filtering-Correlation-Id: 847156e8-a0c3-4b6e-34b2-08daa5f331c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7Nr5Y8+6i8VhEdFrt6WsdbY/kNB3UcKxwhGkT29WO88Ka1DcGAUI5MHkGOcKLJ+IhoH0Sj16dkJZ9Tati9Z/a8eEv79tQSYWN300EDPYhoxh2lIheR9IrmS5Wz4H6GFYfLMkdNoPUP3eCzVPNNPVZnyUXrSyMtaesgAL0WGQluh+ksF47lBmGH799qiGq2ObrBT+B7TINo6HXT9Cq+LxcUajiSSCxUlAVDkgRCm0v9vCyFH+bSNpbdhABPWq0PUWUpvJz7ppHSjU/40GwtdvfvPeLi2At67hiVrQvOuYPmjJF33WUR4TrLhadpFIt7wBI+21fJsR3OYPW/8X8GiYGQojSBwjqsmd7pQgIaGXTE8PO33ocXjZqIY3twzIhJnfMs2w49K1/uRElkJPOBCRflIwQY3SZHaYt4jtht1/ffPedlF/KvDPg1nmR42IFctvc7vgvQk7dHBaafkfQBrKrDSQUE9mEnKnu5vkydyg2qqVml9SXmz765Q8MUNGnsSi3BdxSsXSLDkdR24yLRtWzUj2ts2+u/opP70uUt2iQfNbgws0Veib9rC4DeF0Z0ZwqT7Z+73pxjsykDbb7NEKWInZBYybFz95aVoN5WFzZlgKzidOKxOaN5/Y97/bG8xhXsIVQ3yAo0ZVk6pTlv6gdQizQcccoA6bm3tA5ko1bNqyNt1oB2F2ZtFrqE8ljd4j1XQK0dFZ+HvMmrsTGZx0Ow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(39860400002)(346002)(136003)(451199015)(83380400001)(38100700002)(86362001)(186003)(41300700001)(8936002)(5660300002)(316002)(6916009)(8676002)(66946007)(66556008)(66476007)(4326008)(26005)(6512007)(6506007)(6666004)(2616005)(1076003)(2906002)(6486002)(478600001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7vRl0hsDTnZsUXmOtzDiiqfTz6yS2yvOlkPj0TUEmWgmxP616iR91yawBNLU?=
 =?us-ascii?Q?0RMojEpVKnmgZwvG+o+cXKTTb/SM8zLfWXbpYGycc2uPnYyJKXaEWDMA+nKD?=
 =?us-ascii?Q?nW+A+bJ91umSJrC7uy9O8V8t/jds7uUG6UGariYj0cuBBWC5kWjzYxCH5h7d?=
 =?us-ascii?Q?uNPJ6vKDv0g1Z2OTvXaJnLct/8f54yySKuIazx8b7Ys+6LdQmKAswd83WK2n?=
 =?us-ascii?Q?oPkDUKiL9oQo0Ir9OEE0TeKcgJpUIylIFef7iVx6KLx9sKvSQ/6MyFjY05wU?=
 =?us-ascii?Q?3Nd9Y1XIKajqjn8NaYjDjyg3KO83vfFvS2L7SZ+yWHeoVCcFFe2luT27GJ+e?=
 =?us-ascii?Q?P3epVerU+eSCoyPMXoZzaP6KoQ7g/6O1SB0siS6iAa1fjlxHS/msbiVk435i?=
 =?us-ascii?Q?uysjCNZKvkANLvlVzrxhB/cQ32T77mrlm6GNscpC3FpoDdt3KfC420+KKjsC?=
 =?us-ascii?Q?yW0ZSmgfsdiuqctKGJ5wEURR+X5BzWzZgQMW4ho12qEJclcCXR36kWykU4gi?=
 =?us-ascii?Q?ddRDbmCsGbv96IdhNGfvennwFLf3HFcWZn40hDYmRqDuwOc0flrEKQ3UwJr2?=
 =?us-ascii?Q?MNgziYOKG9vfTIVXGbkbrIr7TN9Dk5RoPAiv9kEy/kEdp6WygDqvqhdSn308?=
 =?us-ascii?Q?yjAnbn9AxmqD4nPLw5XjMVia5JixOrHzboiyT3uDhkX1UUboVbJg33nQQ2eR?=
 =?us-ascii?Q?O6SY/pvTwXvCI7Va0HHpkfrNOUi49eyUeL3BVjkHaQHHYgchurLR4eZ1CHN0?=
 =?us-ascii?Q?AXwRRQHNHJ9vL1rqbeqJTQzakGSRUzW5RXjunKvBQa0/oConUPkF3MT4CpF9?=
 =?us-ascii?Q?WhcfquTrg/FveUbElBa5SAFH8Gq+dxrZLfEpptIIvhuWeLeA4XB9NugFD7H6?=
 =?us-ascii?Q?uIg/suB+DsyEz79flmmagTqeJ5vN5rKL11CzTLy7lJwt9DLX2qbm2ypIdWHl?=
 =?us-ascii?Q?HxsNC+U4Wfh3PvRp4xbEfpJZYDw0eMEIoFwhE5FvcRt8/OaJyGk2XJJq0+l0?=
 =?us-ascii?Q?+cBQlKKnGbIGukc6d0QtPx/nHkLQwDGKHPbNMD/0FRuPTcgH3YjV8EOmNT8e?=
 =?us-ascii?Q?5qO0Ik1b3E9s50hMCRU+ktoPb7K8/klu0PMIE+zH7iA7hJQoNwijs6EHq4aT?=
 =?us-ascii?Q?UXjC6W06RssnNhUQyrnC6PZauJt4h9+MaT8GxURfxH8wo3yD2kvq1t+G4PKk?=
 =?us-ascii?Q?UbvzHgjTsF/FRQ2Z62hQSlTB+tOW0p8OpqI1e/J/XHjDoUvB2CJC6hC/Negv?=
 =?us-ascii?Q?xZvk8GFz0LsZm6mn/zWp+phYWZZVRQ9hMyKA4Kv2yo3hbEehkx57jMzyZ85T?=
 =?us-ascii?Q?tWWpIWFj7uCLgQ1bjYVJQWRHVA1E/MPivhynFOAOLq+gPUGP/0T/EfsMXp25?=
 =?us-ascii?Q?eBi2qGtlLcym0nFn+wbB4FMuC3MbOGfkGtf/VCkD4b2IOGo0m2CaYwwh92//?=
 =?us-ascii?Q?hNL+hGdhB69NzHngDTu/OkIbtUPvZyS1R/iJCXDawzzDVrTApdFP0SMtrjh0?=
 =?us-ascii?Q?1wrRaXHG21qOwqtA8ZfLjm/mxp9Dlfz/jXbb99t5YZRI4cXwo/k5uK9UrF1v?=
 =?us-ascii?Q?O7tl15UJJxaSkXm0JeGmMfHbh8UwpHMFnvNcqNswuCTjFyw6F8KBgigTMn+Z?=
 =?us-ascii?Q?nw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 847156e8-a0c3-4b6e-34b2-08daa5f331c2
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2022 10:28:35.8814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4IYIRKZref5mBrogz68TmYDkSkJPQkYJ2c4o3kVeCwakF61RydyCrXp3HInIBJSDK38cI+Lgrfi/Mdn66meaaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5184
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-04_03,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210040068
X-Proofpoint-ORIG-GUID: kMzSAf0DN4l8mCoajrKw6qncxy4r2bIN
X-Proofpoint-GUID: kMzSAf0DN4l8mCoajrKw6qncxy4r2bIN
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 780d29057781d986cd87dbbe232cd02876ad430f upstream.

XFS_ATTR_INCOMPLETE is a flag in the on-disk attribute format, and thus
in a different namespace as the ATTR_* flags in xfs_da_args.flags.
Switch to using a XFS_DA_OP_INCOMPLETE flag in op_flags instead.  Without
this users might be able to inject this flag into operations using the
attr by handle ioctl.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c      | 2 +-
 fs/xfs/libxfs/xfs_attr_leaf.c | 4 ++--
 fs/xfs/libxfs/xfs_da_btree.h  | 4 +++-
 fs/xfs/libxfs/xfs_da_format.h | 2 --
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 510ca6974604..c83ff610ecb6 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1007,7 +1007,7 @@ xfs_attr_node_addname(
 		 * The INCOMPLETE flag means that we will find the "old"
 		 * attr, not the "new" one.
 		 */
-		args->flags |= XFS_ATTR_INCOMPLETE;
+		args->op_flags |= XFS_DA_OP_INCOMPLETE;
 		state = xfs_da_state_alloc();
 		state->args = args;
 		state->mp = mp;
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 0c23127347ac..c86ddbf6d105 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -2345,8 +2345,8 @@ xfs_attr3_leaf_lookup_int(
 		 * If we are looking for INCOMPLETE entries, show only those.
 		 * If we are looking for complete entries, show only those.
 		 */
-		if ((args->flags & XFS_ATTR_INCOMPLETE) !=
-		    (entry->flags & XFS_ATTR_INCOMPLETE)) {
+		if (!!(args->op_flags & XFS_DA_OP_INCOMPLETE) !=
+		    !!(entry->flags & XFS_ATTR_INCOMPLETE)) {
 			continue;
 		}
 		if (entry->flags & XFS_ATTR_LOCAL) {
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index ae0bbd20d9ca..eebbc66f4c05 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -82,6 +82,7 @@ typedef struct xfs_da_args {
 #define XFS_DA_OP_OKNOENT	0x0008	/* lookup/add op, ENOENT ok, else die */
 #define XFS_DA_OP_CILOOKUP	0x0010	/* lookup to return CI name if found */
 #define XFS_DA_OP_ALLOCVAL	0x0020	/* lookup to alloc buffer if found  */
+#define XFS_DA_OP_INCOMPLETE	0x0040	/* lookup INCOMPLETE attr keys */
 
 #define XFS_DA_OP_FLAGS \
 	{ XFS_DA_OP_JUSTCHECK,	"JUSTCHECK" }, \
@@ -89,7 +90,8 @@ typedef struct xfs_da_args {
 	{ XFS_DA_OP_ADDNAME,	"ADDNAME" }, \
 	{ XFS_DA_OP_OKNOENT,	"OKNOENT" }, \
 	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }, \
-	{ XFS_DA_OP_ALLOCVAL,	"ALLOCVAL" }
+	{ XFS_DA_OP_ALLOCVAL,	"ALLOCVAL" }, \
+	{ XFS_DA_OP_INCOMPLETE,	"INCOMPLETE" }
 
 /*
  * Storage for holding state during Btree searches and split/join ops.
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index ae654e06b2fb..cda10902df1e 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -740,8 +740,6 @@ struct xfs_attr3_icleaf_hdr {
 
 /*
  * Flags used in the leaf_entry[i].flags field.
- * NOTE: the INCOMPLETE bit must not collide with the flags bits specified
- * on the system call, they are "or"ed together for various operations.
  */
 #define	XFS_ATTR_LOCAL_BIT	0	/* attr is stored locally */
 #define	XFS_ATTR_ROOT_BIT	1	/* limit access to trusted attrs */
-- 
2.35.1

