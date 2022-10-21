Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D485C3A59D
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Oct 2022 22:30:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbiJUWaG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Oct 2022 18:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiJUWaA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Oct 2022 18:30:00 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C109F6CF42
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 15:29:56 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLDZSE029908
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=kEtpVBGiLJA32CBv22PixqhlMYVvPt8pB1mdJHaq1a4=;
 b=Y7cgytXI6lMCwn1xj6J6MFW/TahGA8njUd8rZvXTcSCspdeqaTV2ACdFHadkwOlJgP1O
 +NpCSmhdOuVf0n2ngQc5m0sUNSCVyUmQBsWRncpUJ115Zq3Yeh0NaNk8z2BxtcwWZGty
 7PL/JFqgrCyiMo0eaUVtxVgv+Y5fdGYyVxhXS0YHUSzd4uS6Izx5fHhttSNCJVBdOQDq
 ThIw0knW8UlGEYPtFmZgrtgVCST2G/CjGIcqdOTlabmfcQpVMOApkyKeDF3JlMsQdm28
 6AHz+8+pReZO14cRoA5ljp5DjM1tomBpWdqTiby1VethdTHR6WNJFbkj7Ul3aoxVk/3Z qw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7mw3tc23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:55 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29LM0BF1014789
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:54 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hua4x9t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z/uxC/F0w34LkinMo0IeAZ82u+EJpaRqtARrZXVEr3YFssbEqLTDE0MbnUWy8pMMm9iaANcz3QqOczHad3+IVsJ3vB8TiCUZC5fWZoqdUlF/rDEwPgseu+NdTdowskjo4F/3MXXiJo6TH8/M0iKALcSSJC0GLtdlPUBfBzdBdcmM6W3nNM0AfR5eOpz3rB4DvWg9wAkClSd+fWqnGe47YYCgylBPYC+d69Rx9iTl1ZrcP7KK4vM3uK4gviS8ct8iLPF3RzqWCJmUYTa9ZrRpgLKEfNcTOj+MhUWnPA953qNrQc1qcG3rDX5CdPoj8Wo6r7iQpE4uMQeSL7xZ0OuaCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kEtpVBGiLJA32CBv22PixqhlMYVvPt8pB1mdJHaq1a4=;
 b=OTdHhFahF9i0KNjSNNNughTD4WC3/M8W40fpqqUVC+H70ZNDxXkvqYyqWV9Pwz6YFgMKKvivdiAX8i0CSrSCUt6WY3ocFQQNH1IFpqFmhSGSpisKmCvHoBOff70Sm8ruMfo7zA6v1fwBvW1O/IwOsSO6ZCNL95rxXMhxc3zhkJ7TULj2WolSEFjHBZqeGUluscncjab+BSPUsjt9CmwErTEaU9ZY2yxgfdzhwadXG+Jgq1ol/rcAzt/nH+MxGu74SYV5qUsLhV1nXoJ2Dz4kWr5bVwpKde5JLRDmQf85njz5dYol8hdZiTzDAfKa2HY3Xr4/V37vYkcSCVreLWU09A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kEtpVBGiLJA32CBv22PixqhlMYVvPt8pB1mdJHaq1a4=;
 b=JxiPfIcfrd8VLjRmAIyHOdacQzNKVPLGJ5nAx/nFtOCjklDboj2f/waEkTIxwKfsFGXbTHgokqtvMijwwwdUB27Vji/VI3Wx/HdvsSP+Bob8abXcb4ZTRr9AT1r03pwAGRb3eM2DngAnpB2K3wG4XDxE8/BaqurKZzEUhL87j+s=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CO1PR10MB4433.namprd10.prod.outlook.com (2603:10b6:303:6e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Fri, 21 Oct
 2022 22:29:52 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5723.035; Fri, 21 Oct 2022
 22:29:52 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 10/27] xfs: add parent pointer support to attribute code
Date:   Fri, 21 Oct 2022 15:29:19 -0700
Message-Id: <20221021222936.934426-11-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221021222936.934426-1-allison.henderson@oracle.com>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0080.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::25) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|CO1PR10MB4433:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b0f9c6d-e276-4e6f-d375-08dab3b3c5ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TH4mcLMrv40H9NyvvTKVOpGVo4sF1aJjlXRwWimcxWiPw8jf1UyVeI8ENodaTtT6ATfA1AoinJeQOBsNt5YYP5IO9Po19qmGmTp8FwYhakRIb1du9W3hqrwkhnhs4ui5cYM86ZHLzSsICg29uKalZsjhzqPokAFJWq+qyJwXzacKkxoNedhMWxRoXYrmqg7h/a2j8pWMw4HvWjPjt7U6LbN8KBs8lO4x1zChaqxb/SOMDeM/nXWxxU0uGLPv2NtE53m+kUfIuaLeZpliKtb32cnovXAKvKWfxsaMvBp0i0dgQqLP/7B5HB2Hx7TVHN/eGVdS4XE76W4j840DGh1RpC9WGuCEVxVAWwnxl8fo7RjjBIeptPFQMa0q0Af9nogAkVvvozsaXCpCtspCUUIsXTv1McveZKsQBkODmToi2ixjBWYHc0kbJS5w4qdE4w9C/tNzfPe5NNGxjZ0wMJ5h4KJjG4PIFnlFWaftdnA1mVP6xD/BZortwd5Rlgy9767klasWPXca9Uvvkzv+4anb18UDIjUlSP4Q+TWJxMSTKDAvAHuL3v7h/ulZRTgXi1gAkK9J+Bc/ZCYAjQRO5YyjxCOCPpOS4Cvin6jhfaX7j3mz28kAnn8eXEuwhl3xFlS48tMIqAFWBbuWhRfgJ33oG0KJ15QQ23ut9UHljLgRmiB+nb05P/N451aAr5c3qXlQNpC3azUiRFHoyBEGKAtrng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(39860400002)(136003)(366004)(376002)(451199015)(36756003)(38100700002)(5660300002)(86362001)(6666004)(8936002)(83380400001)(6916009)(2616005)(6512007)(316002)(8676002)(6506007)(66946007)(478600001)(6486002)(66556008)(2906002)(1076003)(9686003)(41300700001)(66476007)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?93Q4Zave/GqyrsKi5mhJ+dN37LLeaiYctphcNIv7/SjCrsknAqddXf4ZCxpv?=
 =?us-ascii?Q?XQj0EV7kcQY/jKXDBm6RWh2Fce3cGdh/VAqnbdvIO0WekYedqjVPd+Q92MDP?=
 =?us-ascii?Q?ywdUJPiqscXrWHJuQw1qCg8Uz/MNvj32vPgH+er4LwUy0zCOWnbfl6JC3M6+?=
 =?us-ascii?Q?xoAHzN1rwWKOns3b3mkgAyHXi6jMUM6AmRnZaHtwRdkgjqkzMTlVhWSs3Ugx?=
 =?us-ascii?Q?Zi43mO7MVuSUfG9x9hoKXGGmL6yAB9HQxmguzdbqEgm8j8+Q3EPxLg3aHWk8?=
 =?us-ascii?Q?h4qJWEHXzFJkC0AYFXIkcqtDLVDURG9X11dDaF1HKDEKXcpqS+8o4p1ydbDM?=
 =?us-ascii?Q?zOvJ/Jq7R5CbfltFSIXO4m8/aiQILZe3L/1pvtjAaUEmfqXXhM9oH3BJz0h7?=
 =?us-ascii?Q?6fLUo6Si9dkEt+kbiYLxZXSepwki3AniaiB+CdD56gwjkWzqF6UoLH0F5hkQ?=
 =?us-ascii?Q?NKLO/Tc67GiKs6rpsQg4eJLz57CI6+F2kf1PXQ4UR7C6kFMbLAMLf8G5bDKj?=
 =?us-ascii?Q?OKaRG4rC8S/kTvO7CW3cmESsD7yjG93LAd51zs01vu79SNZs5+XxSsvKyQzZ?=
 =?us-ascii?Q?hGQNsvA58WPlHXEbmbKnUK9lg8CBQsyy90MhMkbBgi9nMXJtg26foI+A5kGQ?=
 =?us-ascii?Q?hCRGxOMsl/B+izfJBxCxoPh4ftsle3B9y6xBx463pesJ0h0SCO3NEI46Ec+S?=
 =?us-ascii?Q?NZ+e+cwdqoFU6iYyiyy/9i4karV2t6XqcALDX183aMljboE8Xa+WFVmmN8RT?=
 =?us-ascii?Q?UIN3OSaGU5HltFG8T62qWBPQYxiYBbrcw9jrGASuzYCod6DUo9UFuzSx9teO?=
 =?us-ascii?Q?6cC8quj+ro74CmyxODFbhnlsYdKFnc9FZK05WJ+cNqDw46RrlWigh20Nbahv?=
 =?us-ascii?Q?UVYtTWNQYv2sOan+jhdcSfPb6J7MMzLzqMWBlWdSBeN3COzOu3a2cLHXg+1r?=
 =?us-ascii?Q?erXdWPlX1ZgIIow4jr3vinZpcRMI8Ae/XDZ8mC/wV5Yf5yk/sSB50BezNEDb?=
 =?us-ascii?Q?Op9ghCehE+VybFQWj9RESLVfJWlJ6VFm7R/Jf8Z0JPjEGGMdWRc3pEUCBYe5?=
 =?us-ascii?Q?fNR46t5YaxQxtOangLWLFGTUhwcx26STHKRA4jie7eNTt/e+P362ZKgY4gZP?=
 =?us-ascii?Q?fbAjHUbvE/CvElDlXBnvmdHVUV3P4yUrnxyKaZRhKTBRKxhe8MSytmi+/J+v?=
 =?us-ascii?Q?ZqCQp2hLNOTYtIP1p9X3/gPyeLm7iFK8QLZToUym0pGlDVsjZSIIdXS35Djw?=
 =?us-ascii?Q?ifsOMbLbhfmmY406di2Mb3qWrIi3TzJF5a5CMEEZxV1iJ7qAz3TIbS6ShfUd?=
 =?us-ascii?Q?wmVbuXUGviLYfwYPZAquWYcb0P4PdPfALjPkpRDB0Q7MJc4sYPIeJw9Myxsw?=
 =?us-ascii?Q?tZDCysZg+iYPLPZ/aJU1dba2s5MOSaGQwFnkZMvdVSz3EfAv6rt1MTklrtbT?=
 =?us-ascii?Q?AWfybdJQ4I12IlfDQXZbRKX/Rr6PAKWdKMtgGKQs5hig2DludV9N4B00txhH?=
 =?us-ascii?Q?tqYzVT9CaghmsVVT4m5vUxVfj2mEvD+UUCCfocg3BBCCg6z9GOcBqrggNyEC?=
 =?us-ascii?Q?nsifP2GhEBIsPi+jaro/cHohNRAJS6lfJ4toobPwR2jktTbKQW5upqItf6Cb?=
 =?us-ascii?Q?xA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b0f9c6d-e276-4e6f-d375-08dab3b3c5ba
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 22:29:52.6875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vGGoJFjUVcrzzIIReDhl8d93+Jii4gPPlVH8zpHJOZVrXW3Uc5U4E6tRfebNQOZWvRIJwTrIlGY/CT/8VPtVHneL2d96672MEix1WgmJ8zM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4433
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 suspectscore=0 phishscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210210131
X-Proofpoint-ORIG-GUID: BfX_4yxfWNM2NiBJwsEMJXhwgLpgia9t
X-Proofpoint-GUID: BfX_4yxfWNM2NiBJwsEMJXhwgLpgia9t
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Add the new parent attribute type. XFS_ATTR_PARENT is used only for parent pointer
entries; it uses reserved blocks like XFS_ATTR_ROOT.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c       | 4 +++-
 fs/xfs/libxfs/xfs_da_format.h  | 5 ++++-
 fs/xfs/libxfs/xfs_log_format.h | 1 +
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index b1dbed7655e8..101823772bf9 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -976,11 +976,13 @@ xfs_attr_set(
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_trans_res	tres;
-	bool			rsvd = (args->attr_filter & XFS_ATTR_ROOT);
+	bool			rsvd;
 	int			error, local;
 	int			rmt_blks = 0;
 	unsigned int		total;
 
+	rsvd = (args->attr_filter & (XFS_ATTR_ROOT | XFS_ATTR_PARENT)) != 0;
+
 	if (xfs_is_shutdown(dp->i_mount))
 		return -EIO;
 
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 25e2841084e1..3dc03968bba6 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -688,12 +688,15 @@ struct xfs_attr3_leafblock {
 #define	XFS_ATTR_LOCAL_BIT	0	/* attr is stored locally */
 #define	XFS_ATTR_ROOT_BIT	1	/* limit access to trusted attrs */
 #define	XFS_ATTR_SECURE_BIT	2	/* limit access to secure attrs */
+#define	XFS_ATTR_PARENT_BIT	3	/* parent pointer attrs */
 #define	XFS_ATTR_INCOMPLETE_BIT	7	/* attr in middle of create/delete */
 #define XFS_ATTR_LOCAL		(1u << XFS_ATTR_LOCAL_BIT)
 #define XFS_ATTR_ROOT		(1u << XFS_ATTR_ROOT_BIT)
 #define XFS_ATTR_SECURE		(1u << XFS_ATTR_SECURE_BIT)
+#define XFS_ATTR_PARENT		(1u << XFS_ATTR_PARENT_BIT)
 #define XFS_ATTR_INCOMPLETE	(1u << XFS_ATTR_INCOMPLETE_BIT)
-#define XFS_ATTR_NSP_ONDISK_MASK	(XFS_ATTR_ROOT | XFS_ATTR_SECURE)
+#define XFS_ATTR_NSP_ONDISK_MASK \
+			(XFS_ATTR_ROOT | XFS_ATTR_SECURE | XFS_ATTR_PARENT)
 
 /*
  * Alignment for namelist and valuelist entries (since they are mixed
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 62f40e6353c2..57814057934d 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -919,6 +919,7 @@ struct xfs_icreate_log {
  */
 #define XFS_ATTRI_FILTER_MASK		(XFS_ATTR_ROOT | \
 					 XFS_ATTR_SECURE | \
+					 XFS_ATTR_PARENT | \
 					 XFS_ATTR_INCOMPLETE)
 
 /*
-- 
2.25.1

