Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A37B6C6FA8B
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Sep 2022 05:45:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiIVFp2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Sep 2022 01:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbiIVFpS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Sep 2022 01:45:18 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B518278BC3
        for <linux-xfs@vger.kernel.org>; Wed, 21 Sep 2022 22:45:15 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28M3E3cd012604
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=bjd36n3iyK/NXMW+4a+6ApgBr/sGIjkSc95dj1/LM5Y=;
 b=1Y7xQAFmvOuRpP/4ITukaiczXPbCFUwwCFqUMvRm1gC9GOXseXowJqdD57YGnUKmwmyp
 w2VvXegal3NHfWnBXfQKb48KyGCq6idcGDyJ+Rf8FegNrhPR8lY+Kn7iUM8ezgj/GZsa
 vLYQ49KqxoHpuiwNAGJpconmOKXJzse6pcKQhM4IDdgHRvtu/Auq+RQ/NyusuhSWyUTp
 UXkg6GzL1xdZD0tTZK/d+L3/IdBSnf57/aQkMRKPgeUVkplMVhCTy7Elm26cNUcVyChZ
 Py9SJdWiojqnAnGoy0Y2l6mjjLfNQqoyuY7uXUAgaPKP3bMOGomdQry+93IecO+qOvKs 2g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn68rm8fy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:15 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M1wiIc037824
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:14 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2046.outbound.protection.outlook.com [104.47.51.46])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39sd8vc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B+Iiol5DA4ugsXFjxVDxizM5PEmNXeFf0EyqW3W7GtZPu3d3KxumeLCf70b5od4aBjVnD8zUB7Hx/9WT+kXN67WuFQBBpbqyhyDCKb3BuX3fbTo20IK4BnHr+qTq/OKpDZjq7f9lvmwaGGBixwR1ZbPqKmCm8OdSySKa4DGCl9v6v3OeDYJ1RnMN5HL0209KIi+X9VO61KnLKReKmz7GZIuVG/JBisD/OvYWDQxbZKfayH1zf0992dO1r4Rbzyk41Mio0v6zJcOYahUevCBaKIpuSDzAn+In09hxyw+oUQ7I5g//tUuhnZO5+StZwiIAIyzfg03LhoSDZxOCXJEe5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bjd36n3iyK/NXMW+4a+6ApgBr/sGIjkSc95dj1/LM5Y=;
 b=TX0j9KifvNSWqhCCMxY9Z4OMnQimkpeCkAM54HZIaSjVWb7MTncoHQq9mkz8KUj06GSz4Fdge9XxlMzPK5yyvnc9QO7/AfeegHqVZPRqTH8Q444gMRc/ewqsi2fcOosRYHdAfNotz1mTd1gMRSQvxZrzL17HqZmirbdD5WiyI+Wy9dl0pTdKcS+lT9crGlCq8lbHuuastPMxln57MmuwywMvKvaXpXNLw6B8q+KjVyvOnqspVZ9QS0/Xn1xIP2AZOwuPyZTYNxKcGKyj7tDB/aHs7ooEnNO8br5eDsGlKvggR2iSnemMEssLATUAd07IiLk1DdqXN2xQt6vUgMWOjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bjd36n3iyK/NXMW+4a+6ApgBr/sGIjkSc95dj1/LM5Y=;
 b=Y2WBe3TWCwWyMQXO2+/FWuwqN1VPFkfk9uKTaMZo+t7utW09Oh5XCI3j8DT26mW7tZRRkSdmvjSsh9ElJBNWrQLpqzY3LkRu0yBIWaBLwrBmef8B+FlqzoY81W5YjAkl64KrWiDmGgsKu/B+JkERA9stfM6zm6bLXtamzlTcRi4=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4806.namprd10.prod.outlook.com (2603:10b6:510:3a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Thu, 22 Sep
 2022 05:45:12 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9%3]) with mapi id 15.20.5654.017; Thu, 22 Sep 2022
 05:45:12 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 07/26] xfs: get directory offset when adding directory name
Date:   Wed, 21 Sep 2022 22:44:39 -0700
Message-Id: <20220922054458.40826-8-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922054458.40826-1-allison.henderson@oracle.com>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0156.namprd05.prod.outlook.com
 (2603:10b6:a03:339::11) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4806:EE_
X-MS-Office365-Filtering-Correlation-Id: 616a242b-1d69-481b-a405-08da9c5d9e28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fOJZ1txB/rOaiNIZ0o4VWGXJJF68+qV17B0Tp3nMlSM4IgJZUftsO2LzzzMhCC0mXsvzVWbrWjEJvWbljztz/rZCKmUui1mUFO9v/lOgrFsN8R/Hds7knRCj5ePq3mCz+I81qSAMdwqMPmCpeKXDKgOK1WAtoFCZyNF9bHEVdZfH/78hYZPWb2fYQGTtumsB8+vL4T6+z6SNA3qeGdIMpLKx8epwMUTDUH7TRfJuRJASAtveYROSFN6pTPP6A5hopoVb34nSj/BaPQIp1p0DXa5bAe0+hXNLru6/t4i44n2AtTHqo0RGA6OxGtDrXJ6uKA6Cc3/nb7v45/4/Fj+MRor6RZWNJIFrckHWNXVW4wlr7h1XoWjz7Tg1d1obFZA5hibPTjqIx/ULnbDY3X3nyM74OivopA4xcnltDiyVnxjOg15ZlumJAe6Jf7kUhM4fWGQldXDO/QrCaWUnat8UhWiu1z/79WRYBRgXopBSdn7LPh7G7zribRSKhIpt+3Vm0MO8yk/l5yvxwxAB6NWl4xZxEjAzeim9unbwU88dm72o8bB3Rsps7CRUc7/e8a11bBo4BCOz9euBNGp8sW+OGsEtYRbnPzYVXn0W7xeYTxUBd1/eJwvHHIag/Xlx4m9B+B741rYO54jN19No9M3di2+XEj+kXCXD50A9LZuqiSGes07k/IDskdPM/IQEL5mszQ7wGuyS0l207ZErMgx15w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(376002)(366004)(396003)(39860400002)(451199015)(38100700002)(86362001)(66556008)(6916009)(66476007)(8676002)(41300700001)(66946007)(2906002)(5660300002)(316002)(8936002)(186003)(83380400001)(1076003)(2616005)(6486002)(478600001)(6512007)(36756003)(26005)(6506007)(9686003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B46u9FeRif545Pi0P2kO0l/S+W3m2s/gVq1qR6SjyJgQbZqlEinLNscDfHe6?=
 =?us-ascii?Q?56ylYXvC9JaCis1itqx9Cx5fKD8m8kDNf8IQMOS9cSzs9eR7jlR6zNCmykz0?=
 =?us-ascii?Q?tsnAUQg/pf22vsH8L42c/UAyHAJgs+YuamlQpj+JTEgqsqatImUEVrsdjFkY?=
 =?us-ascii?Q?SLAG3i50JuG5r4Rr00qsQ1WO5n27gvSVRGMEVEfSSODCXanRQH4Ehy5oTC7i?=
 =?us-ascii?Q?K92WgLCB2bku8vypCW57Mpbr23DguljJWCMYXy3HdY/Uvpdv4z/ZCRghVaDS?=
 =?us-ascii?Q?uWUawBUu3LkwndHnfE2eoQFaKo2dgHMrYw+8U2MdjtfhEddY9/1Csmw2020m?=
 =?us-ascii?Q?I5Cv94KdtVEjnJ4Il4ekpHj01XujNTdUmamdiMN508gEzsA9wEZYeh5oyai/?=
 =?us-ascii?Q?ottTYARXRahV8l12d9kpRYAa9VRjwCWcvvirjkRZ93LiCZkQYCnH1eV+6Y5P?=
 =?us-ascii?Q?wYhS99hU1PrUqa2YxzgYJzdTzoWyR1OBj4reApyG1hUXbkF8w18AANn5yR9g?=
 =?us-ascii?Q?gE/dzrUg8hAXWWuJjemYdMVq9GW2fQtjzlgL/begoFzdxRe3lMvOJ4bCHtsq?=
 =?us-ascii?Q?p3kCLEg97bOcL8TBHZLUc6PtPbaKAF+6GpTtbZiNv/v5JBVsGxdh+BMq+Xaa?=
 =?us-ascii?Q?IJcF9zkGGa/L33UbDffy3fY3oDXXcIhxeQgGoqsqkkk4fLuM7ZGrLP2U+WV9?=
 =?us-ascii?Q?yniFv8zJtf3AaoGe/x0airZ/mOJfV4CyQi+2Qk+HH9pJL2b+2xKZ6RIYzW7r?=
 =?us-ascii?Q?BE3e6HYoYgWeP44evBbPAT/uxmwvwZpKy2tgzo69fOyC7ttNaVNru+eQv136?=
 =?us-ascii?Q?UwnDv7/z6fclsPS7UrfHPxlY7/5/CKDENZ6PKUEMcUQY0FcQO8CpNPDsPUqP?=
 =?us-ascii?Q?1TVzF8gZZ4QrpXNp18Nr7/5L29/frvfWNTlTUrCeVLIVNILDvwLUpC5uR3IN?=
 =?us-ascii?Q?M/tdoLpcntva96zF0JhUbL+0uGzNma7U4GcvbRdFULmRo3FdRfOhPddc3MFY?=
 =?us-ascii?Q?6Mp5YjxBaQejcYQ1yuuhhR1idrFip9w1E9eLZEoipsa20d9ulwMljOwc49hD?=
 =?us-ascii?Q?fyxUbqbXxsXLxpa0PvAQ1xPJUL+pYDDRqkXjtvV6hOxUYNv/bEand4auyMpT?=
 =?us-ascii?Q?7XLjaWsSWi6CGdVW9nHY+hi+yBuoycD4GwB2ijB4QJ+/OAT+zZlGejoAnRSW?=
 =?us-ascii?Q?Fp2danRI0d0J7pmuZHQsNOgfQkVZTrvgLnINc8yRuecN3jre6DtYINaOhizy?=
 =?us-ascii?Q?z6SU8qbrY8B315cUB4AiIvWhQE7Iexj9z8wHL8Y5Qd8NolVngZvoKQGiG5B6?=
 =?us-ascii?Q?1pd30qsdIhQKwOzVv2umVTPwIBjsrsXOrDttHhcwg8R3KAz9IF7jGFmvDIKk?=
 =?us-ascii?Q?Kv0dLcbjAwDuGUJO+2Zu+AAU9KXqNPPHMMTV07sBOSm20qe2r5uojLRn0OE5?=
 =?us-ascii?Q?o0q1iYJjVOH46WSdDVyY/+wr38tSclP1TyuQzASXPlzo+ROL+REjEPVwwPxT?=
 =?us-ascii?Q?dwFp/lC5IdQMBEFksfsK1NntJyXM3NgGNToYD94/gPTdivLfheMifAQFr+Q8?=
 =?us-ascii?Q?pvXPvhtwf5V1N00pu3wPWq5xrLlEEaf2o+CAo913A2Jy1OfSvuyO6LHOhO1B?=
 =?us-ascii?Q?fg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 616a242b-1d69-481b-a405-08da9c5d9e28
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 05:45:12.6482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1RdVhDn3qA7K0iPEwA8ik2KIZ50G0LZzZu/+jzv+Wf0KzwZIRJ8ciqgKv4nlJwnh+4kndpGeeCn4q1MuNXEAY+dXRc9M84TEZo6vh2GvDRg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4806
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209220037
X-Proofpoint-GUID: xzAVd_h7Elh2VJ97lZD-6N8d-FEJXcDM
X-Proofpoint-ORIG-GUID: xzAVd_h7Elh2VJ97lZD-6N8d-FEJXcDM
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Return the directory offset information when adding an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_create,
xfs_symlink, xfs_link and xfs_rename.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_da_btree.h   | 1 +
 fs/xfs/libxfs/xfs_dir2.c       | 9 +++++++--
 fs/xfs/libxfs/xfs_dir2.h       | 2 +-
 fs/xfs/libxfs/xfs_dir2_block.c | 1 +
 fs/xfs/libxfs/xfs_dir2_leaf.c  | 2 ++
 fs/xfs/libxfs/xfs_dir2_node.c  | 2 ++
 fs/xfs/libxfs/xfs_dir2_sf.c    | 2 ++
 fs/xfs/xfs_inode.c             | 6 +++---
 fs/xfs/xfs_symlink.c           | 3 ++-
 9 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index a4b29827603f..90b86d00258f 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -81,6 +81,7 @@ typedef struct xfs_da_args {
 	int		rmtvaluelen2;	/* remote attr value length in bytes */
 	uint32_t	op_flags;	/* operation flags */
 	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
+	xfs_dir2_dataptr_t offset;	/* OUT: offset in directory */
 } xfs_da_args_t;
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 76eedc2756b3..c0629c2cdecc 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -257,7 +257,8 @@ xfs_dir_createname(
 	struct xfs_inode	*dp,
 	const struct xfs_name	*name,
 	xfs_ino_t		inum,		/* new entry inode number */
-	xfs_extlen_t		total)		/* bmap's total block count */
+	xfs_extlen_t		total,		/* bmap's total block count */
+	xfs_dir2_dataptr_t	*offset)	/* OUT entry's dir offset */
 {
 	struct xfs_da_args	*args;
 	int			rval;
@@ -312,6 +313,10 @@ xfs_dir_createname(
 		rval = xfs_dir2_node_addname(args);
 
 out_free:
+	/* return the location that this entry was place in the parent inode */
+	if (offset)
+		*offset = args->offset;
+
 	kmem_free(args);
 	return rval;
 }
@@ -550,7 +555,7 @@ xfs_dir_canenter(
 	xfs_inode_t	*dp,
 	struct xfs_name	*name)		/* name of entry to add */
 {
-	return xfs_dir_createname(tp, dp, name, 0, 0);
+	return xfs_dir_createname(tp, dp, name, 0, 0, NULL);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index b6df3c34b26a..4d1c2570b833 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -40,7 +40,7 @@ extern int xfs_dir_init(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_inode *pdp);
 extern int xfs_dir_createname(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t inum,
-				xfs_extlen_t tot);
+				xfs_extlen_t tot, xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t *inum,
 				struct xfs_name *ci_name);
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 00f960a703b2..70aeab9d2a12 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -573,6 +573,7 @@ xfs_dir2_block_addname(
 	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
 	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	args->offset = xfs_dir2_byte_to_dataptr((char *)dep - (char *)hdr);
 	/*
 	 * Clean up the bestfree array and log the header, tail, and entry.
 	 */
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index d9b66306a9a7..bd0c2f963545 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -865,6 +865,8 @@ xfs_dir2_leaf_addname(
 	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
 	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	args->offset = xfs_dir2_db_off_to_dataptr(args->geo, use_block,
+						(char *)dep - (char *)hdr);
 	/*
 	 * Need to scan fix up the bestfree table.
 	 */
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 7a03aeb9f4c9..5a9513c036b8 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -1974,6 +1974,8 @@ xfs_dir2_node_addname_int(
 	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
 	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	args->offset = xfs_dir2_db_off_to_dataptr(args->geo, dbno,
+						  (char *)dep - (char *)hdr);
 	xfs_dir2_data_log_entry(args, dbp, dep);
 
 	/* Rescan the freespace and log the data block if needed. */
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 8cd37e6e9d38..44bc4ba3da8a 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -485,6 +485,7 @@ xfs_dir2_sf_addname_easy(
 	memcpy(sfep->name, args->name, sfep->namelen);
 	xfs_dir2_sf_put_ino(mp, sfp, sfep, args->inumber);
 	xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
+	args->offset = xfs_dir2_byte_to_dataptr(offset);
 
 	/*
 	 * Update the header and inode.
@@ -575,6 +576,7 @@ xfs_dir2_sf_addname_hard(
 	memcpy(sfep->name, args->name, sfep->namelen);
 	xfs_dir2_sf_put_ino(mp, sfp, sfep, args->inumber);
 	xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
+	args->offset = xfs_dir2_byte_to_dataptr(offset);
 	sfp->count++;
 	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && !objchange)
 		sfp->i8count++;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ff680de560d2..9d4c9f53c435 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1038,7 +1038,7 @@ xfs_create(
 	unlock_dp_on_error = false;
 
 	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
-					resblks - XFS_IALLOC_SPACE_RES(mp));
+				   resblks - XFS_IALLOC_SPACE_RES(mp), NULL);
 	if (error) {
 		ASSERT(error != -ENOSPC);
 		goto out_trans_cancel;
@@ -1262,7 +1262,7 @@ xfs_link(
 	}
 
 	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
-				   resblks);
+				   resblks, NULL);
 	if (error)
 		goto error_return;
 	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
@@ -2984,7 +2984,7 @@ xfs_rename(
 		 * to account for the ".." reference from the new entry.
 		 */
 		error = xfs_dir_createname(tp, target_dp, target_name,
-					   src_ip->i_ino, spaceres);
+					   src_ip->i_ino, spaceres, NULL);
 		if (error)
 			goto out_trans_cancel;
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index d8e120913036..27a7d7c57015 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -314,7 +314,8 @@ xfs_symlink(
 	/*
 	 * Create the directory entry for the symlink.
 	 */
-	error = xfs_dir_createname(tp, dp, link_name, ip->i_ino, resblks);
+	error = xfs_dir_createname(tp, dp, link_name,
+			ip->i_ino, resblks, NULL);
 	if (error)
 		goto out_trans_cancel;
 	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-- 
2.25.1

