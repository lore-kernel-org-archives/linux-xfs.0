Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0048C43462
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 08:09:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8928D61418
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 08:09:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236730AbhD1IKa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 04:10:30 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:33896 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbhD1IKY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Apr 2021 04:10:24 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13S80YnX136839
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=HDgCZkqldcmb0ocAyZaIHAJzTV4YbiB/8YouhIbErFQ=;
 b=NW0XATENoNa6XPjmTXWh04tFrpMc+MleTXNj4Vpw8VWbgo0BszauK3uowtR1aZf/zOfF
 cwrDZLhXQJuFiwhRk32OwxSQ4/66LmSiF/OqrIBPcvqAGg4Ue/zFgEvGC5sCppNVKei4
 5g2PeguJF7nqO90DQD9+PnSupEo8+EWhNbCDqeGknXXbv3ci7R3iJrvDkuBHepqbJkGo
 LDkf0t5WOd6yNvbrh7g/MSUBE8ncUtxljN7E1vXh+HOJ18MdxkNYNnxg4A3DWf1x63AS
 7GQtbjnuJ+b4XP74Go83g28e3ttU3oQRvCkjm4DhJXcUKQLoqxEfhacxPAQcqExdQ3Lb rQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 385afpyxs6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13S80oJn196107
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:39 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2051.outbound.protection.outlook.com [104.47.45.51])
        by userp3030.oracle.com with ESMTP id 3848ey69y1-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yxd/KwyefL7PxOqnnG/Y28PpDL92ak61qI3XXGXQ2jVYPPtye4JOQ8JdeB4uYySdIGUSjJKiAURu+ccY+gQ49lP5PFlem1Lc8UYVl2gNYn87GJhm/4CnEZP0/9GxkZRmCKzDny3AdCTb65hDxjgDx8APFqPYOeYgt4dYTy1fFzPzH+GFQQFwXzRjJbDBZqERrfFVt0OTTQvRKjGaJKzyL4+cAwgJ/ve5YhOHdRXlqwr6QGs0QFWFXXkY5y6bpZy/LE23Sb8oKYMBGfbmhrcXe5HusDto3O6SEyAuW8qkntIK7h7jWzZgyTuQ4++uf8XZ/eBML8o+Yxpq7G7+swOUHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HDgCZkqldcmb0ocAyZaIHAJzTV4YbiB/8YouhIbErFQ=;
 b=hyT/3S5anyxtB0v7+advMkpllQ/oT3LchKhrNMEv0TBWS+hXAqDmnObWI8RLB7HQq1pXzRtSsjvvE0ELGym1Jz9gP+ykOk0xLS8JkwutTdtDMFkemiZOw4xWi3dc79aRakldbj+YxHlo4fYtannQAWbqoiGwkfP6aVvOQLUN21ExULwfa8P1l1j99+wCIax+37XQ3ES4uL+kqzRz1zHORDXO2R+hj5bEeFLuV8hdWkTVJF4CAj3AuAq9OFxhQA40rBPDeRNVcLX5r1srEpooGZcI5OpEspCo5J9L+DCkmGkVMG4T2ZFftggI0pitCdf3fTsGYazGvT+6uc715aaphA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HDgCZkqldcmb0ocAyZaIHAJzTV4YbiB/8YouhIbErFQ=;
 b=r5FgUlLn1QAZTdo/rcf1moFVooTtntbhYgqVUgDBgHwic/Huak/G/2rylR0iJiJmOfUdgLGIq1P0OLQmXtoTz+HDhyIaz0vdKnreX8PgLftDd67TGpQGTFFrvhHS4O7tW60ETC9zBzv8gwVoHkrezIvNiBqELSs7olrC9bWg/E4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB4086.namprd10.prod.outlook.com (2603:10b6:a03:129::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Wed, 28 Apr
 2021 08:09:35 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.024; Wed, 28 Apr 2021
 08:09:35 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v18 10/11] xfs: Add delay ready attr remove routines
Date:   Wed, 28 Apr 2021 01:09:18 -0700
Message-Id: <20210428080919.20331-11-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210428080919.20331-1-allison.henderson@oracle.com>
References: <20210428080919.20331-1-allison.henderson@oracle.com>
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BYAPR05CA0051.namprd05.prod.outlook.com
 (2603:10b6:a03:74::28) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.222.141) by BYAPR05CA0051.namprd05.prod.outlook.com (2603:10b6:a03:74::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.16 via Frontend Transport; Wed, 28 Apr 2021 08:09:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6847eeb5-6de8-4c93-415c-08d90a1cf5e1
X-MS-TrafficTypeDiagnostic: BYAPR10MB4086:
X-Microsoft-Antispam-PRVS: <BYAPR10MB40862936FDE6340B292F191695409@BYAPR10MB4086.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1/LVNJl19cI4tIShoRawoyiE9letquxVFBZNAXowAaQ1du5FPnQwIIJq6ZOpGxpvvNyq6r/eXHDIMHwCqrxMmGvbHfpKN3oPv6eMZEuOedQRJcYmHFcWB9PUpXXxfc/fz4awV+ZdaWL4+YRVHEvLI61/GIYs1n6Idt427VrZUrDa30twr9XcEkahRaebLWPpnxa6dD987YJu3IxNASSivWZ+ZzHDgyM7sBQSNMQI79a3eK1AsJXW3jEauyyvXv8PHmuKC/g3YodxlvbIGrxeGO1h/xXrS4KrFrgnqgC7pGE8pyf/9a6XrPtA2F6S82cQQAqebYrjbo5+H36YbuDNcWoWYtjSyNM3XJBT2Mps+KURsLfU1dyPZ54IOFOEbJIcHmSqSU45zgCqxE/FjbEBWZ6NTIUxKqwBIiyLK9fW/XvF3HUT6oDjc0pm7cxdNhadAeWh2gYghp5/ItkHUyka5FaxUSroutpsvcldiPsxn0jv0pIewHgQybShwDxwMbLfVUBL28uwdTD22HF5EZujo5uX6FOSm+imyHWtnX8KETsQ0/bf2kHjMq9aHFZu/U1BZmlbEb2qw2K/Hg5eUqUTLQT9F2CgnTkI5WF9s+6fpkORcDcZQhMGnQnuwBVEFeMBR+BD7ERwN39FXY1qA8r4kQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(39860400002)(396003)(346002)(83380400001)(8936002)(52116002)(6506007)(66946007)(36756003)(316002)(66476007)(26005)(956004)(6916009)(6486002)(2616005)(6666004)(6512007)(8676002)(30864003)(478600001)(2906002)(86362001)(1076003)(5660300002)(16526019)(66556008)(186003)(38350700002)(44832011)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?77G7xW2kQacFjsgyCxoY7WNgEUYKELy+LcoihXgwajm1S4ChV29JHoeprHpa?=
 =?us-ascii?Q?DnF2OtetMnToC3206b1aCzkHA4ppXAc3GnPVS6tEFBY2lNO4VNg96d5Vy7N4?=
 =?us-ascii?Q?a92KxEXM0LxGnNwJgU2wLww1rAGfNUegSTgun2OEtuxV8ARhTBDiTo3A2UL2?=
 =?us-ascii?Q?skuSBhiBF42awZ3UTCmpQi0pnSFNJ0+Q0wmRQTwxldl3v9as4wu2uBsfJ5mC?=
 =?us-ascii?Q?8M2FG9LolvtWhw4MYzqmADAFmXCBkib+phO6mK3GhSF+NfphPZiFM6SlLxbs?=
 =?us-ascii?Q?vmcErUAy/XICZG2fWuYwAQ/p6dfyfx+8p7WP7K52XANIZxIKVRLehLdkA/Yh?=
 =?us-ascii?Q?K+Zr9D/vLbb7qQwUAaDRLqf9BVmbw+2h1du48DiFCf9RuIxECSBz22lkSxR1?=
 =?us-ascii?Q?onGBRLEjIizot/DS1YpNnDYCHZNp2nWvVyYbR6m9KaOLti0NhrzN3AHDA0uf?=
 =?us-ascii?Q?+KyyHH/Uoo9FQ1/XEImq73NfzvzcBLI6jiBBZQ7a/KehWLi+ldR7HEp44j1w?=
 =?us-ascii?Q?grK9dbwPF7LOjkupJ/+sqB2xZTyP1VZ8i10PovcSb7HhOMbeWIKZnPJHmeN1?=
 =?us-ascii?Q?yi7Vc37yXKY7JrU3enxS3bpLvfh8Tuk5pmeWRYUN7cmojo/LEw71A8eXA+vV?=
 =?us-ascii?Q?PvaX3FCzAfw2Wh4TMG51iEkjQmNYIrqvqCOGkuW5KgjYu0DNPxa85MdwuUSa?=
 =?us-ascii?Q?lAAVOmy2CQiRjemN+vcEZrIVZ/jOLUt1qnoIvloOTPmjLeyc6ZOUZ6N/QyPw?=
 =?us-ascii?Q?F78fYRyu1MMn0Frbx4D2fXI04ARg0pepZCiOS1VOqD4e1M/r96ZQQcgD8ZOe?=
 =?us-ascii?Q?Nb6O9xjt9crS00cJ4LbVymqCuyqDVHNv7x0GK2wqDVwqxziCa6Ul8B+afcE4?=
 =?us-ascii?Q?H5b9F6TiUTcWPNIHxCX9FvGLOUbW1b0Cv491MsG8Juik9jgru9v/pP4byQu4?=
 =?us-ascii?Q?KXdANciQPLLln5tuNqsYJlx+Sap6E5qMIhNjJ9lJnDm3Nlm0Z9xfK+Kg8w/a?=
 =?us-ascii?Q?U/XH+56p3CxytTzcfPu3o6cleF94TEq/kTPFW0cptJxFW4SAx6R1nCOmcLT1?=
 =?us-ascii?Q?5koMWZQCAxTKj5wAM36EVyt3mJ1J9aibBJoOYtnXp2CVxb84CYfsil714zgq?=
 =?us-ascii?Q?vo3hELWOPnJMzRpMY567jh8X8DvdJ2mM7IVVOTBOPd/ZoTdRmKPymCleUe2j?=
 =?us-ascii?Q?RcjtbmAuxYvidmcNWf0klsNJodLkxxSXRAPq6QpwPa6LE6N76v7sRDxE9X3L?=
 =?us-ascii?Q?k7PQTibTLIYj6oqw8fRnvm4pTh0VPZQ1efrpus6ehy0UimB4CTE8CINi1WO/?=
 =?us-ascii?Q?aTXpvIXQPJF5jK1rD5OY8T5J?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6847eeb5-6de8-4c93-415c-08d90a1cf5e1
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2021 08:09:35.2089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6Ih/tw/UhGcCJWU/SgoZEQKLYnMFWhTRIEgdKQM8p+5avi0KzWOIr/9IICHeEzdd8pkwPRelRLDfbhHKpZ3pQxuLLzmguWptrjKPwmBgTRQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB4086
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9967 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104280054
X-Proofpoint-ORIG-GUID: CKgLyRD4PQFn0pAZ--TrusUm2r3YlwGT
X-Proofpoint-GUID: CKgLyRD4PQFn0pAZ--TrusUm2r3YlwGT
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9967 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 clxscore=1015 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 malwarescore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104280054
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch modifies the attr remove routines to be delay ready. This
means they no longer roll or commit transactions, but instead return
-EAGAIN to have the calling routine roll and refresh the transaction. In
this series, xfs_attr_remove_args is merged with
xfs_attr_node_removename become a new function, xfs_attr_remove_iter.
This new version uses a sort of state machine like switch to keep track
of where it was when EAGAIN was returned. A new version of
xfs_attr_remove_args consists of a simple loop to refresh the
transaction until the operation is completed. A new XFS_DAC_DEFER_FINISH
flag is used to finish the transaction where ever the existing code used
to.

Calls to xfs_attr_rmtval_remove are replaced with the delay ready
version __xfs_attr_rmtval_remove. We will rename
__xfs_attr_rmtval_remove back to xfs_attr_rmtval_remove when we are
done.

xfs_attr_rmtval_remove itself is still in use by the set routines (used
during a rename).  For reasons of preserving existing function, we
modify xfs_attr_rmtval_remove to call xfs_defer_finish when the flag is
set.  Similar to how xfs_attr_remove_args does here.  Once we transition
the set routines to be delay ready, xfs_attr_rmtval_remove is no longer
used and will be removed.

This patch also adds a new struct xfs_delattr_context, which we will use
to keep track of the current state of an attribute operation. The new
xfs_delattr_state enum is used to track various operations that are in
progress so that we know not to repeat them, and resume where we left
off before EAGAIN was returned to cycle out the transaction. Other
members take the place of local variables that need to retain their
values across multiple function recalls.  See xfs_attr.h for a more
detailed diagram of the states.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c        | 213 ++++++++++++++++++++++++++++------------
 fs/xfs/libxfs/xfs_attr.h        | 131 ++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_attr_leaf.c   |   2 +-
 fs/xfs/libxfs/xfs_attr_remote.c |  48 +++++----
 fs/xfs/libxfs/xfs_attr_remote.h |   2 +-
 fs/xfs/xfs_attr_inactive.c      |   2 +-
 6 files changed, 314 insertions(+), 84 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 21f862e..a91fff6 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -57,7 +57,6 @@ STATIC int xfs_attr_node_addname(struct xfs_da_args *args,
 				 struct xfs_da_state *state);
 STATIC int xfs_attr_node_addname_find_attr(struct xfs_da_args *args,
 				 struct xfs_da_state **state);
-STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
 STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_da_args *args);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
@@ -241,6 +240,31 @@ xfs_attr_is_shortform(
 		ip->i_afp->if_nextents == 0);
 }
 
+/*
+ * Checks to see if a delayed attribute transaction should be rolled.  If so,
+ * transaction is finished or rolled as needed.
+ */
+int
+xfs_attr_trans_roll(
+	struct xfs_delattr_context	*dac)
+{
+	struct xfs_da_args		*args = dac->da_args;
+	int				error;
+
+	if (dac->flags & XFS_DAC_DEFER_FINISH) {
+		/*
+		 * The caller wants us to finish all the deferred ops so that we
+		 * avoid pinning the log tail with a large number of deferred
+		 * ops.
+		 */
+		dac->flags &= ~XFS_DAC_DEFER_FINISH;
+		error = xfs_defer_finish(&args->trans);
+	} else
+		error = xfs_trans_roll_inode(&args->trans, args->dp);
+
+	return error;
+}
+
 STATIC int
 xfs_attr_set_fmt(
 	struct xfs_da_args	*args)
@@ -544,16 +568,25 @@ xfs_has_attr(
  */
 int
 xfs_attr_remove_args(
-	struct xfs_da_args      *args)
+	struct xfs_da_args	*args)
 {
-	if (!xfs_inode_hasattr(args->dp))
-		return -ENOATTR;
+	int				error;
+	struct xfs_delattr_context	dac = {
+		.da_args	= args,
+	};
 
-	if (args->dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL)
-		return xfs_attr_shortform_remove(args);
-	if (xfs_attr_is_leaf(args->dp))
-		return xfs_attr_leaf_removename(args);
-	return xfs_attr_node_removename(args);
+	do {
+		error = xfs_attr_remove_iter(&dac);
+		if (error != -EAGAIN)
+			break;
+
+		error = xfs_attr_trans_roll(&dac);
+		if (error)
+			return error;
+
+	} while (true);
+
+	return error;
 }
 
 /*
@@ -1197,14 +1230,16 @@ xfs_attr_leaf_mark_incomplete(
  */
 STATIC
 int xfs_attr_node_removename_setup(
-	struct xfs_da_args	*args,
-	struct xfs_da_state	**state)
+	struct xfs_delattr_context	*dac)
 {
-	int			error;
+	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_state		**state = &dac->da_state;
+	int				error;
 
 	error = xfs_attr_node_hasname(args, state);
 	if (error != -EEXIST)
 		return error;
+	error = 0;
 
 	ASSERT((*state)->path.blk[(*state)->path.active - 1].bp != NULL);
 	ASSERT((*state)->path.blk[(*state)->path.active - 1].magic ==
@@ -1213,12 +1248,15 @@ int xfs_attr_node_removename_setup(
 	if (args->rmtblkno > 0) {
 		error = xfs_attr_leaf_mark_incomplete(args, *state);
 		if (error)
-			return error;
+			goto out;
 
-		return xfs_attr_rmtval_invalidate(args);
+		error = xfs_attr_rmtval_invalidate(args);
 	}
+out:
+	if (error)
+		xfs_da_state_free(*state);
 
-	return 0;
+	return error;
 }
 
 STATIC int
@@ -1241,70 +1279,123 @@ xfs_attr_node_remove_name(
 }
 
 /*
- * Remove a name from a B-tree attribute list.
+ * Remove the attribute specified in @args.
  *
  * This will involve walking down the Btree, and may involve joining
  * leaf nodes and even joining intermediate nodes up to and including
  * the root node (a special case of an intermediate node).
+ *
+ * This routine is meant to function as either an in-line or delayed operation,
+ * and may return -EAGAIN when the transaction needs to be rolled.  Calling
+ * functions will need to handle this, and recall the function until a
+ * successful error code is returned.
  */
-STATIC int
-xfs_attr_node_removename(
-	struct xfs_da_args	*args)
+int
+xfs_attr_remove_iter(
+	struct xfs_delattr_context	*dac)
 {
-	struct xfs_da_state	*state;
-	int			retval, error;
-	struct xfs_inode	*dp = args->dp;
+	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_state		*state = dac->da_state;
+	int				retval, error;
+	struct xfs_inode		*dp = args->dp;
 
 	trace_xfs_attr_node_removename(args);
 
-	error = xfs_attr_node_removename_setup(args, &state);
-	if (error)
-		goto out;
+	switch (dac->dela_state) {
+	case XFS_DAS_UNINIT:
+		if (!xfs_inode_hasattr(dp))
+			return -ENOATTR;
 
-	/*
-	 * If there is an out-of-line value, de-allocate the blocks.
-	 * This is done before we remove the attribute so that we don't
-	 * overflow the maximum size of a transaction and/or hit a deadlock.
-	 */
-	if (args->rmtblkno > 0) {
-		error = xfs_attr_rmtval_remove(args);
-		if (error)
-			goto out;
+		/*
+		 * Shortform or leaf formats don't require transaction rolls and
+		 * thus state transitions. Call the right helper and return.
+		 */
+		if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL)
+			return xfs_attr_shortform_remove(args);
+
+		if (xfs_attr_is_leaf(dp))
+			return xfs_attr_leaf_removename(args);
 
 		/*
-		 * Refill the state structure with buffers, the prior calls
-		 * released our buffers.
+		 * Node format may require transaction rolls. Set up the
+		 * state context and fall into the state machine.
 		 */
-		error = xfs_attr_refillstate(state);
-		if (error)
-			goto out;
-	}
-	retval = xfs_attr_node_remove_name(args, state);
+		if (!dac->da_state) {
+			error = xfs_attr_node_removename_setup(dac);
+			if (error)
+				return error;
+			state = dac->da_state;
+		}
+
+		/* fallthrough */
+	case XFS_DAS_RMTBLK:
+		dac->dela_state = XFS_DAS_RMTBLK;
 
-	/*
-	 * Check to see if the tree needs to be collapsed.
-	 */
-	if (retval && (state->path.active > 1)) {
-		error = xfs_da3_join(state);
-		if (error)
-			goto out;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			goto out;
 		/*
-		 * Commit the Btree join operation and start a new trans.
+		 * If there is an out-of-line value, de-allocate the blocks.
+		 * This is done before we remove the attribute so that we don't
+		 * overflow the maximum size of a transaction and/or hit a
+		 * deadlock.
 		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-		if (error)
-			goto out;
-	}
+		if (args->rmtblkno > 0) {
+			/*
+			 * May return -EAGAIN. Roll and repeat until all remote
+			 * blocks are removed.
+			 */
+			error = __xfs_attr_rmtval_remove(dac);
+			if (error == -EAGAIN)
+				return error;
+			else if (error)
+				goto out;
 
-	/*
-	 * If the result is small enough, push it all into the inode.
-	 */
-	if (xfs_attr_is_leaf(dp))
-		error = xfs_attr_node_shrink(args, state);
+			/*
+			 * Refill the state structure with buffers (the prior
+			 * calls released our buffers) and close out this
+			 * transaction before proceeding.
+			 */
+			ASSERT(args->rmtblkno == 0);
+			error = xfs_attr_refillstate(state);
+			if (error)
+				goto out;
+			dac->dela_state = XFS_DAS_RM_NAME;
+			dac->flags |= XFS_DAC_DEFER_FINISH;
+			return -EAGAIN;
+		}
+
+		/* fallthrough */
+	case XFS_DAS_RM_NAME:
+		retval = xfs_attr_node_remove_name(args, state);
 
+		/*
+		 * Check to see if the tree needs to be collapsed. If so, roll
+		 * the transacton and fall into the shrink state.
+		 */
+		if (retval && (state->path.active > 1)) {
+			error = xfs_da3_join(state);
+			if (error)
+				goto out;
+
+			dac->flags |= XFS_DAC_DEFER_FINISH;
+			dac->dela_state = XFS_DAS_RM_SHRINK;
+			return -EAGAIN;
+		}
+
+		/* fallthrough */
+	case XFS_DAS_RM_SHRINK:
+		/*
+		 * If the result is small enough, push it all into the inode.
+		 * This is our final state so it's safe to return a dirty
+		 * transaction.
+		 */
+		if (xfs_attr_is_leaf(dp))
+			error = xfs_attr_node_shrink(args, state);
+		ASSERT(error != -EAGAIN);
+		break;
+	default:
+		ASSERT(0);
+		error = -EINVAL;
+		goto out;
+	}
 out:
 	if (state)
 		xfs_da_state_free(state);
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 2b1f619..32736d9 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -74,6 +74,133 @@ struct xfs_attr_list_context {
 };
 
 
+/*
+ * ========================================================================
+ * Structure used to pass context around among the delayed routines.
+ * ========================================================================
+ */
+
+/*
+ * Below is a state machine diagram for attr remove operations. The  XFS_DAS_*
+ * states indicate places where the function would return -EAGAIN, and then
+ * immediately resume from after being recalled by the calling function. States
+ * marked as a "subroutine state" indicate that they belong to a subroutine, and
+ * so the calling function needs to pass them back to that subroutine to allow
+ * it to finish where it left off. But they otherwise do not have a role in the
+ * calling function other than just passing through.
+ *
+ * xfs_attr_remove_iter()
+ *              │
+ *              v
+ *        have attr to remove? ──n──> done
+ *              │
+ *              y
+ *              │
+ *              v
+ *        are we short form? ──y──> xfs_attr_shortform_remove ──> done
+ *              │
+ *              n
+ *              │
+ *              V
+ *        are we leaf form? ──y──> xfs_attr_leaf_removename ──> done
+ *              │
+ *              n
+ *              │
+ *              V
+ *   ┌── need to setup state?
+ *   │          │
+ *   n          y
+ *   │          │
+ *   │          v
+ *   │ find attr and get state
+ *   │    attr has blks? ───n────┐
+ *   │          │                v
+ *   │          │         find and invalidate
+ *   │          y         the blocks. mark
+ *   │          │         attr incomplete
+ *   │          ├────────────────┘
+ *   └──────────┤
+ *              │
+ *              v
+ *      Have blks to remove? ───y─────────┐
+ *              │        ^          remove the blks
+ *              │        │                │
+ *              │        │                v
+ *              │  XFS_DAS_RMTBLK <─n── done?
+ *              │  re-enter with          │
+ *              │  one less blk to        y
+ *              │      remove             │
+ *              │                         V
+ *              │                  refill the state
+ *              n                         │
+ *              │                         v
+ *              │                   XFS_DAS_RM_NAME
+ *              │                         │
+ *              ├─────────────────────────┘
+ *              │
+ *              v
+ *       remove leaf and
+ *       update hash with
+ *   xfs_attr_node_remove_cleanup
+ *              │
+ *              v
+ *           need to
+ *        shrink tree? ─n─┐
+ *              │         │
+ *              y         │
+ *              │         │
+ *              v         │
+ *          join leaf     │
+ *              │         │
+ *              v         │
+ *      XFS_DAS_RM_SHRINK │
+ *              │         │
+ *              v         │
+ *       do the shrink    │
+ *              │         │
+ *              v         │
+ *          free state <──┘
+ *              │
+ *              v
+ *            done
+ *
+ */
+
+/*
+ * Enum values for xfs_delattr_context.da_state
+ *
+ * These values are used by delayed attribute operations to keep track  of where
+ * they were before they returned -EAGAIN.  A return code of -EAGAIN signals the
+ * calling function to roll the transaction, and then recall the subroutine to
+ * finish the operation.  The enum is then used by the subroutine to jump back
+ * to where it was and resume executing where it left off.
+ */
+enum xfs_delattr_state {
+	XFS_DAS_UNINIT		= 0,  /* No state has been set yet */
+	XFS_DAS_RMTBLK,		      /* Removing remote blks */
+	XFS_DAS_RM_NAME,	      /* Remove attr name */
+	XFS_DAS_RM_SHRINK,	      /* We are shrinking the tree */
+};
+
+/*
+ * Defines for xfs_delattr_context.flags
+ */
+#define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
+
+/*
+ * Context used for keeping track of delayed attribute operations
+ */
+struct xfs_delattr_context {
+	struct xfs_da_args      *da_args;
+
+	/* Used in xfs_attr_node_removename to roll through removing blocks */
+	struct xfs_da_state     *da_state;
+
+	/* Used to keep track of current state of delayed operation */
+	unsigned int            flags;
+	enum xfs_delattr_state  dela_state;
+};
+
 /*========================================================================
  * Function prototypes for the kernel.
  *========================================================================*/
@@ -92,6 +219,10 @@ int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_args(struct xfs_da_args *args);
 int xfs_has_attr(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args);
+int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
+int xfs_attr_trans_roll(struct xfs_delattr_context *dac);
 bool xfs_attr_namecheck(const void *name, size_t length);
+void xfs_delattr_context_init(struct xfs_delattr_context *dac,
+			      struct xfs_da_args *args);
 
 #endif	/* __XFS_ATTR_H__ */
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 556184b..d97de20 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -19,8 +19,8 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_bmap.h"
 #include "xfs_attr_sf.h"
-#include "xfs_attr_remote.h"
 #include "xfs_attr.h"
+#include "xfs_attr_remote.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 48d8e9c..2f3c4cc 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -674,10 +674,12 @@ xfs_attr_rmtval_invalidate(
  */
 int
 xfs_attr_rmtval_remove(
-	struct xfs_da_args      *args)
+	struct xfs_da_args		*args)
 {
-	int			error;
-	int			retval;
+	int				error;
+	struct xfs_delattr_context	dac  = {
+		.da_args	= args,
+	};
 
 	trace_xfs_attr_rmtval_remove(args);
 
@@ -685,31 +687,29 @@ xfs_attr_rmtval_remove(
 	 * Keep de-allocating extents until the remote-value region is gone.
 	 */
 	do {
-		retval = __xfs_attr_rmtval_remove(args);
-		if (retval && retval != -EAGAIN)
-			return retval;
+		error = __xfs_attr_rmtval_remove(&dac);
+		if (error && error != -EAGAIN)
+			break;
 
-		/*
-		 * Close out trans and start the next one in the chain.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
+		error = xfs_attr_trans_roll(&dac);
 		if (error)
 			return error;
-	} while (retval == -EAGAIN);
+	} while (true);
 
-	return 0;
+	return error;
 }
 
 /*
  * Remove the value associated with an attribute by deleting the out-of-line
- * buffer that it is stored on. Returns EAGAIN for the caller to refresh the
+ * buffer that it is stored on. Returns -EAGAIN for the caller to refresh the
  * transaction and re-call the function
  */
 int
 __xfs_attr_rmtval_remove(
-	struct xfs_da_args	*args)
+	struct xfs_delattr_context	*dac)
 {
-	int			error, done;
+	struct xfs_da_args		*args = dac->da_args;
+	int				error, done;
 
 	/*
 	 * Unmap value blocks for this attr.
@@ -719,12 +719,20 @@ __xfs_attr_rmtval_remove(
 	if (error)
 		return error;
 
-	error = xfs_defer_finish(&args->trans);
-	if (error)
-		return error;
-
-	if (!done)
+	/*
+	 * We don't need an explicit state here to pick up where we left off. We
+	 * can figure it out using the !done return code. Calling function only
+	 * needs to keep recalling this routine until we indicate to stop by
+	 * returning anything other than -EAGAIN. The actual value of
+	 * attr->xattri_dela_state may be some value reminiscent of the calling
+	 * function, but it's value is irrelevant with in the context of this
+	 * function. Once we are done here, the next state is set as needed
+	 * by the parent
+	 */
+	if (!done) {
+		dac->flags |= XFS_DAC_DEFER_FINISH;
 		return -EAGAIN;
+	}
 
 	return error;
 }
diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
index 9eee615..002fd30 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.h
+++ b/fs/xfs/libxfs/xfs_attr_remote.h
@@ -14,5 +14,5 @@ int xfs_attr_rmtval_remove(struct xfs_da_args *args);
 int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
 		xfs_buf_flags_t incore_flags);
 int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
-int __xfs_attr_rmtval_remove(struct xfs_da_args *args);
+int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
 #endif /* __XFS_ATTR_REMOTE_H__ */
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index bfad669..aaa7e66 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -15,10 +15,10 @@
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_inode.h"
+#include "xfs_attr.h"
 #include "xfs_attr_remote.h"
 #include "xfs_trans.h"
 #include "xfs_bmap.h"
-#include "xfs_attr.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_quota.h"
 #include "xfs_dir2.h"
-- 
2.7.4

