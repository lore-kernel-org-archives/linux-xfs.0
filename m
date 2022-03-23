Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24266C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Mar 2022 21:07:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240996AbiCWVJL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Mar 2022 17:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344860AbiCWVJD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Mar 2022 17:09:03 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B08AD8CD92
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 14:07:28 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22NKYRgZ007708
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=piXmY+S1S6x5J8G42q3OPS42p4KfHP7SjH6+nGTm5Xw=;
 b=Sbz1XXmJol6L8Av86wZxbQZov3ckf3vnrWk1qtvO5wnaZt7Wgl19vy9DI0gZ4Z5zG7Fz
 ZXbfYtxifQ9jatircXULC19Ahiz1xmYVVHshSDpB6g0DcsTLyiFetJlekDw61+CTVHjR
 tFuPw6qdLArFo0Tmxc7Kf4gMYwRDInP/8+LPq37iEciPocb4i1/4AbODD9Mq0oU/qPmb
 gdW5phYUZgjeKPoHxlLvjSi0CXPgIgXdqU9fOD9XEbczlvt+p62IHcytP3ZOLnoJCoIA
 2/+balFe2WDXRE/7BsDfqU/BtMzBn3EKT42Ce2aam+NuOLNN6pbss8dF0nwygZ6lWg6f Iw== 
Received: from aserp3030.oracle.com ([141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew7qtawts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22NL6LdD082870
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:26 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by aserp3030.oracle.com with ESMTP id 3ew578y1wr-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fpDanooWIdSOhpVoYpcEQvM0Rjo9P5PIOwfBpHpTda45Vh/kRtBMbW14RdiBiw8F58Xjh78rBxQxg4op2iCTX8SsjUG7SiRFDI3euH4wF0b3iwxxdN3WYfS78u9Wex75q97UPi+OQ/50m05crlQ2aC+HnXYBPKunKWFExDDWedOujQKLIL3qCV9v57kAwEZLbe4pR8wSo9CrsheP/vjBD+SbRdthPlWoA/9QZ9U746Q8J03eKTvuZQtN4deg4+UhO/XvosKqS3sV/ZkaR1pkcBDwlwtR6Do87+wh6w+j2W6Y2Qwy7Fu12JfoSONe6YMBFFUQ29VLPZgQDhlasbzthA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=piXmY+S1S6x5J8G42q3OPS42p4KfHP7SjH6+nGTm5Xw=;
 b=j3Jqo0eCmYZn/mzEBMEigziVRpNoepK9WuFbsm1f/YpQJ+8cYCSLT85Y0XyE02VirtI1G6iYD+Zg9/seiT6JOPau3sI0EHUTPCJ5GuDZ7x44/UjkIkuNuNMUs00iuJy37teolvx2z6bIqhbgddYO+ZUaHV8mwGyq0gqWjlPBRnPLshI+apAHCylMAhMJuHGiON6j8FYVqIgpQez5ncQAPauMVtOVFJ/rd3mm9zhcDKqjsjoZeHCIOmoDW1Mjt3ktnyKTmRoztGz5TFfTQZQ2+L0QzeMQC9bg9ajbMRA2bU5fIifBBSRxQlgaAPwP5cK1aNLxylPyqJCMKZLOXEC4dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=piXmY+S1S6x5J8G42q3OPS42p4KfHP7SjH6+nGTm5Xw=;
 b=YTDsHmM6mzFtGao1qMiq34nyxR3qO68YFoaTMNDbOXlUlPrNVE+mFWDH8b41x30kihwdCRQMX1CqkdpQnDqMAu9ePvFxN1Mmgw6jcqny3fJl0T7vTP36O+pGkUq/MDGFAbRXbv6nucLYF+wo5lp8oG26ewgrZWfs6TdUaLDJ/TE=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4744.namprd10.prod.outlook.com (2603:10b6:510:3c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17; Wed, 23 Mar
 2022 21:07:25 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c517:eb23:bb2f:4b23]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c517:eb23:bb2f:4b23%6]) with mapi id 15.20.5102.017; Wed, 23 Mar 2022
 21:07:24 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v29 06/15] xfs: Skip flip flags for delayed attrs
Date:   Wed, 23 Mar 2022 14:07:06 -0700
Message-Id: <20220323210715.201009-7-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 104b472d-9e6e-4e4d-c9cc-08da0d11211c
X-MS-TrafficTypeDiagnostic: PH0PR10MB4744:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB474415CE2DD5656A2B4932E295189@PH0PR10MB4744.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QsXcr7HCb6wlryAakHbUyU3kugRl+5jFvd6VnUPDG1T8kKUWT+FK0ia+9sqvIoy5EUHkcl71tmXS1xgraZktc5rG1X7Dw8DVVabnbfOxjZTuw0FEhZjYewjLHqJTFuQXqwQ5yUPr0yglceO/pcqV/XSzei1fkhkU47cqpCyVod4M9nAxcrxWQnYjR9PhfzdJr/TT9TIdwn0+vd+u2wjaZx7YxMrd+sFzbxm2n9TzabjnkKEIEJVQJ+Rm6R6c1nAT0pDJpgFxPSIxutNFLACD99OLpM4oPmGYCPEGLpW5Fd3SPxfoJCRUf9hAek2J4/EEirfs3rIRDH+GZHQUW6l1S/5sO3716gJCU/S2OocvzJLB5Y0GBu/PxPff0HhcsX8GjJhcrw4/oLR/dMVynUKhism+l48h08eRod6XyPY/finQtY4jKNagDU56F5aQt2mkDp1mhoyB2TLoF2YJO7zSDkEutHNyrtROi6SGxgoh8Pkvy/WjavGa2ZxWtD5w2HmVu10VPaNGlfHgYnGOoVYMN2ngD2JjEts0qU7QrCjUFan2xKn9kWV1TaoXQX3WweS1T0eG0dxjwEmkIowGsOU6z9xgaNrzlYQXGYkoxMueRRYkBtiHsmDtd5yF6Bu5mPqagRtIB2ECTtgEvUWsUpHnUAeZF6sA/qauJU8ywimwcgv3UqMa8YpbqrvyTNcUduIcE6P9lGBH2Z5VixnRliyQnw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(44832011)(2906002)(508600001)(26005)(186003)(36756003)(38100700002)(83380400001)(6506007)(38350700002)(6486002)(52116002)(86362001)(6512007)(5660300002)(66946007)(8676002)(66476007)(66556008)(8936002)(6916009)(316002)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ShJl6kzQFdtejFQcxxJV9f66YCCvDg/CIzOLeUANqr/mYEhSOef4vn04duWJ?=
 =?us-ascii?Q?Y5Ft1spUjavmcZ8uUpZLYsMlOBCPsEuMLgpiqFOK6v+s3PUKADf3vP5F6T0b?=
 =?us-ascii?Q?6iPCLzMD8mYV0Yjbz+Vfn9DqZAHEvsPclnLQtMED5FJ3IJJ/ys6mr6bmZNcA?=
 =?us-ascii?Q?di7gBUyD/ohfmEuPHPGqzJsF/HmbVfjObr79xG6/nZfFkilJzm+XbRjTYznY?=
 =?us-ascii?Q?WrjnYFr70JoWvMIje1EBytd7XGVDrrOvaF8W5fRJEl68mpO9G8Ull8hP8l6N?=
 =?us-ascii?Q?LXGW5kqcDnDVF3+0XXqKG5Zy35plUcoXS0QZ3HLe0iJS97pc+BgMSkoBTeAK?=
 =?us-ascii?Q?limhAHET9x43IoGO/6WGmSiY9RZg5fi2BJlyJ+OIYuc1ECfmp97mgDO++QIW?=
 =?us-ascii?Q?SRYRagWoARqZwbzOycrv2xr4v7Ek4FQ5pPjbPz4071EhVQlYq4qsJqmfVAMs?=
 =?us-ascii?Q?5JiQOVvYapdmssVplJTNn78qNNwCaTrj7tgZIMehS8a0kLTdhsk/MrhWsTq0?=
 =?us-ascii?Q?zvrRyaGhIyJhIS4GWI1Z0T10pRO4zzgWvmQgU1Tb5LD7ACWOYv1GB34sLZGk?=
 =?us-ascii?Q?22VhJ4Nifv3zfGs0YzGL8K+UYvgpd9ofZpTLYKG40rzVwIatwUQPBD9u35Lc?=
 =?us-ascii?Q?K1lXCvJubzfngOcow28ebWW8q1cW/lhTu8e/HhQnekzUAVTUt5Kzhxwx2PIV?=
 =?us-ascii?Q?bC1pu3dyw7keBvdYV37R2vxNJfGGmVE8hbsJo+DivBzeMFkZKaOILXUpAmFa?=
 =?us-ascii?Q?TYY+iDHxY7h63cA3mSeX1mOIQPdRoeiEejw5Zr7i9EbJYrmDrV7UDFC7DlhJ?=
 =?us-ascii?Q?2oAQ7IYypGDCMiptZ7jRIsToaM+PQuQkLYwdPiHQVTJth0NhERdBsYuM2IuS?=
 =?us-ascii?Q?2XMXbtKP91Y4UsLPpw+3crSgY0sCjYbovy0lPI/MiDvKNesj8F11C7RP0YWp?=
 =?us-ascii?Q?Y2gYteInpK2asY8Pd7bSKSapV9mJeCIiYkR9rkpE0kZo86BIQPHyJjLjs7zK?=
 =?us-ascii?Q?KEyqAtChH5Xq32qYimvqHB3CurFSCV5UgpmtZukqNjQvaIRQr+2hZGdH+I0I?=
 =?us-ascii?Q?nAwcOzxjHEoD1rb9S990EMpLF6cczC9FyPCdc4e6dmJ1UnahUSPJqxIasSMD?=
 =?us-ascii?Q?TrYq7EBxjJVguVA/Nm/ZRiRv46bIvlDbSn0WZ3ZnCj6LdMZpUMoQkvYUa6Dk?=
 =?us-ascii?Q?s69y4ieFw2EbW6iGctzsXomtntkXwkjBMFtVYVn4n738R+fQBBmtsnmFmxsB?=
 =?us-ascii?Q?w+6OYlKzczsBhVT6UpvxTM4aRDnsj6gaARO1ouW9FwGN02oofH/cDNaJdXdF?=
 =?us-ascii?Q?k46BAQ9MGJ5WvjvGbg0csKRTn6W0KoXOJmSbWDpw/fyURnDyuwNvyU73Ldtd?=
 =?us-ascii?Q?EnZTqWQ22r+3imi2F/EhRBlWn55lSupfky92Xn6bk45JlXuYyx7zL2o1wjMt?=
 =?us-ascii?Q?o3U9gym8qAyHdW9QegQWwT5TDLXgJvF6LjUQ6pmLPLY4lURbnR6OBw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 104b472d-9e6e-4e4d-c9cc-08da0d11211c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2022 21:07:24.9048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wj/ednIJmKM5d+I4Vyz2C97UtIZWtlvpag9A5VN562u5LnZmrYXnzbpGmus4ypBuMr6DjLgcGUXohujQG77VJEtGsOz4J1GUOEZHauk0VaY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4744
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10295 signatures=694973
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203230111
X-Proofpoint-GUID: kVB8L7gLy_5XispxAQNWsLrXZyJE8jGQ
X-Proofpoint-ORIG-GUID: kVB8L7gLy_5XispxAQNWsLrXZyJE8jGQ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a clean up patch that skips the flip flag logic for delayed attr
renames.  Since the log replay keeps the inode locked, we do not need to
worry about race windows with attr lookups.  So we can skip over
flipping the flag and the extra transaction roll for it

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c      | 54 +++++++++++++++++++++--------------
 fs/xfs/libxfs/xfs_attr_leaf.c |  3 +-
 2 files changed, 35 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 21594f814685..da257ad22f1f 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -358,6 +358,7 @@ xfs_attr_set_iter(
 	struct xfs_inode		*dp = args->dp;
 	struct xfs_buf			*bp = NULL;
 	int				forkoff, error = 0;
+	struct xfs_mount		*mp = args->dp->i_mount;
 
 	/* State machine switch */
 	switch (dac->dela_state) {
@@ -480,16 +481,21 @@ xfs_attr_set_iter(
 		 * In a separate transaction, set the incomplete flag on the
 		 * "old" attr and clear the incomplete flag on the "new" attr.
 		 */
-		error = xfs_attr3_leaf_flipflags(args);
-		if (error)
-			return error;
-		/*
-		 * Commit the flag value change and start the next trans in
-		 * series.
-		 */
-		dac->dela_state = XFS_DAS_FLIP_LFLAG;
-		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
-		return -EAGAIN;
+		if (!xfs_has_larp(mp)) {
+			error = xfs_attr3_leaf_flipflags(args);
+			if (error)
+				return error;
+			/*
+			 * Commit the flag value change and start the next trans
+			 * in series.
+			 */
+			dac->dela_state = XFS_DAS_FLIP_LFLAG;
+			trace_xfs_attr_set_iter_return(dac->dela_state,
+						       args->dp);
+			return -EAGAIN;
+		}
+
+		fallthrough;
 	case XFS_DAS_FLIP_LFLAG:
 		/*
 		 * Dismantle the "old" attribute/value pair by removing a
@@ -592,17 +598,21 @@ xfs_attr_set_iter(
 		 * In a separate transaction, set the incomplete flag on the
 		 * "old" attr and clear the incomplete flag on the "new" attr.
 		 */
-		error = xfs_attr3_leaf_flipflags(args);
-		if (error)
-			goto out;
-		/*
-		 * Commit the flag value change and start the next trans in
-		 * series
-		 */
-		dac->dela_state = XFS_DAS_FLIP_NFLAG;
-		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
-		return -EAGAIN;
+		if (!xfs_has_larp(mp)) {
+			error = xfs_attr3_leaf_flipflags(args);
+			if (error)
+				goto out;
+			/*
+			 * Commit the flag value change and start the next trans
+			 * in series
+			 */
+			dac->dela_state = XFS_DAS_FLIP_NFLAG;
+			trace_xfs_attr_set_iter_return(dac->dela_state,
+						       args->dp);
+			return -EAGAIN;
+		}
 
+		fallthrough;
 	case XFS_DAS_FLIP_NFLAG:
 		/*
 		 * Dismantle the "old" attribute/value pair by removing a
@@ -1270,6 +1280,7 @@ xfs_attr_node_addname_clear_incomplete(
 {
 	struct xfs_da_args		*args = dac->da_args;
 	struct xfs_da_state		*state = NULL;
+	struct xfs_mount		*mp = args->dp->i_mount;
 	int				retval = 0;
 	int				error = 0;
 
@@ -1277,7 +1288,8 @@ xfs_attr_node_addname_clear_incomplete(
 	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
 	 * flag means that we will find the "old" attr, not the "new" one.
 	 */
-	args->attr_filter |= XFS_ATTR_INCOMPLETE;
+	if (!xfs_has_larp(mp))
+		args->attr_filter |= XFS_ATTR_INCOMPLETE;
 	state = xfs_da_state_alloc(args);
 	state->inleaf = 0;
 	error = xfs_da3_node_lookup_int(state, &retval);
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 014daa8c542d..74b76b09509f 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1487,7 +1487,8 @@ xfs_attr3_leaf_add_work(
 	if (tmp)
 		entry->flags |= XFS_ATTR_LOCAL;
 	if (args->op_flags & XFS_DA_OP_RENAME) {
-		entry->flags |= XFS_ATTR_INCOMPLETE;
+		if (!xfs_has_larp(mp))
+			entry->flags |= XFS_ATTR_INCOMPLETE;
 		if ((args->blkno2 == args->blkno) &&
 		    (args->index2 <= args->index)) {
 			args->index2++;
-- 
2.25.1

