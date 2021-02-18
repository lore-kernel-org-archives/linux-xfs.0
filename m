Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AAD1C4332B
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:45:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4951764ECE
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:45:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbhBRSpB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:45:01 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35524 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231750AbhBRQql (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:46:41 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGTgSw040315
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=TOOBB0sq3MTNlwRa7Cz/k3KxX2lVRPUBo0E0YE4Rq2A=;
 b=axUSlGN2nwGT2o5v9cChKfmQZIcGnFFJkBQ7/8N5oDjdOrzG3i+id12JqGZ4jR+qZS9I
 4O+TRrpz4/jfpK+LCsk2duK3oVkkDg5Zc2gxWUAkPhDSV53I4PSOSxIqa6kzyBYeyAaQ
 mpYwZmFr+qOweh0FQBoQ8OE33nEnpXoGI+9HIeaPWv2Xa7ApMj+aJoTzmCqWrdzZCGjC
 bzclB9ZuKjsQUPXwdvs7f5Dc/OcFhAxUzQbcnu1/VycO3JHr1XJRF55PLaGwaF17yQ/9
 BgOe/7f93PdScCpRBLduD75yjFv8zDm83P2NmSCE5JhSGGkLz1UKJ+GkolyyuBSCfvzQ BA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 36pd9ae3gx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUHT5067740
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:32 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by aserp3020.oracle.com with ESMTP id 36prp1rjuh-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hnvhyse0JkGufClcXHBvYKEZ9U6BdcjBNf/6PuPkK3hiIDxscL2Em0yl4eqwvHfV96qkohVfMHAGiRfgn/T++tImfJVFYqvKB7EpptX3joEoXzHUCf9l84Zn7ux5aw4ZUX3Mq+rCqpGxm3MIpDt5D6eh+u/MyscY3tHPJHePhh/BsctiQTDYPNrNoeT3Htv05ZEHXHUoKzp7ByHcovUK5QzTfyFRZdES+6ldpzxMq3vRr0x/7zGXqCGNxEGiSOSvy14xXaeDX4JVPqAvyPv7OykEUOG8kdkKBFUelaAUq9APK2jx5GyNjvBh1NETGfdICzHrmtzzZvt3acNZbpDG6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TOOBB0sq3MTNlwRa7Cz/k3KxX2lVRPUBo0E0YE4Rq2A=;
 b=BDJ2q7nonU+Dosw+yUkX0j6sw0GvUDQVUgNpd47KlvaTo3tcf8PwGreEc/MiT+nabMe6IIH5c+ZKo9rIt7T3aOxo4GzM4UjxbAIK/KIvjV7UUtO1KnU3fHxEFgOJRrHJWDYbycPErYh1sSC3yPnyv3NYVXlNHUY20pvk48UgwAF454CKBfGl3TvGGqd5cELpo5W999qEhhexMnckij7WNYmKD8jXAP0uhF7oAcOrfvFZB+CxrePgWgi+c0qKZO6zUFVWx1sY3P3UTmz7mT160Y9bI7a1VsfsFEeERm7HTDABtRug4x9aZ9qzqVlwfEhsEtgM+Usn7tTzc+fFtT/Rfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TOOBB0sq3MTNlwRa7Cz/k3KxX2lVRPUBo0E0YE4Rq2A=;
 b=rOHJWRW7wc0YTBtCQ13BoavU/8B9SY9wHmaVYMsXtRdeQMMxPMaMu+LiRpR4XpS6wPWm1PJI3ivOU4FSBeM/gtpLLytFBsBnOu5b7rKaQWMNgtFTlWiHxNQZDysR6f9gHbnNMIuWp1maMaXcnxVBBtZJareiavesxIWC+s+iplo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3461.namprd10.prod.outlook.com (2603:10b6:a03:11e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Thu, 18 Feb
 2021 16:45:30 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:45:30 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 02/37] xfsprogs: Add helper for checking per-inode extent count overflow
Date:   Thu, 18 Feb 2021 09:44:37 -0700
Message-Id: <20210218164512.4659-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218164512.4659-1-allison.henderson@oracle.com>
References: <20210218164512.4659-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR11CA0088.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by BYAPR11CA0088.namprd11.prod.outlook.com (2603:10b6:a03:f4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:45:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e668917-29c0-4f42-2cb1-08d8d42c9a3f
X-MS-TrafficTypeDiagnostic: BYAPR10MB3461:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3461FFC7A600B4C79753A6B495859@BYAPR10MB3461.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:883;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F6gqlfcFrvA8qVm1s29IV1V4DC3symnGXuej1OdcwVM+whZexa/dSpo+Dbrk1Hu9rT16R4TQATvrSqbOiCFr85slziUUYJTC1tkv5rmkZPtOmgxrTZDjfHRB0OMlbaS0stbhMRSi31ejd+x8BK47jXoZ2YcMogZAjIwmdLyJKv4DWcMa+6h/XnX88ndPNgbDzF5K62mVNKNQv+GfSIoBOmbocKD133aiZfwa5PjT/DEleOSp/+QXgAvVeqtzvRQd0tjQaDqU4YxPjmf0TQKScHmE66TEh5Kx53O91ZflKsyl/++DNChy38kn5GE9CTGwuSkUYfWDmxICHzAgRDHy3n/HTiXjFwxEmIQHFEjzgQSnP0IJn1RZ+BHxalI7Gtyd8e67aM/ZmfxGCOykZSEfRI/QcHJhME5y6rGYT4uCbHytuGZVrYDPFPcbWoetXPv5K87iXCuVNUhlU6B+T256sUlXUsO/L0hjthb3eMHWJ+JknJWkdpIz61eEKhx56CMXsEvktQiAPMXBdloEjSNeC63zptUiiUa++gC6D9Nz7Fu0b7CWkhj9ZkWIzMSe6pw3qGkpBH9BosBC7dqqBX9fcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(396003)(376002)(136003)(39860400002)(8936002)(66476007)(1076003)(69590400012)(66556008)(2906002)(86362001)(316002)(26005)(6486002)(52116002)(16526019)(8676002)(6512007)(186003)(36756003)(5660300002)(83380400001)(956004)(2616005)(6916009)(66946007)(44832011)(6506007)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?oJ4/lyOS7h97/97nKPx5vOtK4TOKmjiIfH0+fxnjquBsT3HCfPz1r1/MuExy?=
 =?us-ascii?Q?O6+M3VIqDRk+QWmWXspNPcuYyVAan7rbGF4WC37Qp8MaI4u35pqqT775pGp5?=
 =?us-ascii?Q?YGdw2aJVmePLB8Zh0IqQI1vnvJdmIb7wDcTElzxftWNsQQsVBxeSIlFPLGBF?=
 =?us-ascii?Q?A8sjROaTyWu0Gt/aUV3W56d+8J/qgAbP4TXiAQ8Tipe9T6On2IzW6FOy1nIU?=
 =?us-ascii?Q?xKhPV9EBpwCZIF0V/Oez3rGrJdTBpUvdyMugJE+hOLEW2rX/24abxO8fL31n?=
 =?us-ascii?Q?rXOJUfuV7qWaV5v20rtXwW1Or/Uk9cjxrRC6SzYL0j7I02FpaIUiNRhmWd4E?=
 =?us-ascii?Q?aWWiiFhjglUMbOqXtjM19po47OGxMUPjqJihZJeUaejuynqb8JX8VeBP/drZ?=
 =?us-ascii?Q?QiGR/BxCjn3b5P1TphaX9cQuywMlnqdJFqCEDtvb8GVebp3eMUnouNloYe2Y?=
 =?us-ascii?Q?D7IUCajKndArFrIkcTUnWwWhk/YVHA8Be/M28FqVdCzYVdimTb1kWb/oDmg4?=
 =?us-ascii?Q?uKVqxkyOxjX6ro1nQWoGkoD6RxA71sksNWJCZhGWFqLJjt7HtaOY5OfpW5Ni?=
 =?us-ascii?Q?TkTEtKEfAHs63A/mTOJsYVdwM29Uzy7Vgr/1ReMA/3D/ksK9s1PtFHKpunsa?=
 =?us-ascii?Q?s0Pbv/I78vP8SG5SFOcanm+vauYWxEraJFX1Y+ETGJTXjdhb52DrgU6XZSQd?=
 =?us-ascii?Q?3WZ85ZZLmpZHONJqOOnDfLqgtDA0rWAtQdXmpxIyabrowx4TZWJrDBD8x4oG?=
 =?us-ascii?Q?yZsghfdCxpN8jwcyn33mbwZ+J6qJ0uBGuBpgl0qd8PlOp6xAvksm/DUFOY0l?=
 =?us-ascii?Q?C/9VEhH19E1625wWFA4VBfKTekziJlq8hTsQXslWJEoeJsD/GSEAu7TPVhzz?=
 =?us-ascii?Q?ad0ViEQIiwzLFbhDalXLoKl8/4e7BSPDxYYl3iM+wc0AFKoudn7hUgejOzjQ?=
 =?us-ascii?Q?paF18R3YgWVB/As1ekglgVDPrinzOgExGRpw5gBPzLsn0aVOuXY+sJAZ9OaX?=
 =?us-ascii?Q?kzqktcQYtEenXzdFkU76DcusO3ycnMNTtiB4hzb1EBp+78wmFdCaDe7RNBH2?=
 =?us-ascii?Q?kZkoXqy3I+Z/PRgdrsjzKohJG/sBerYRG3vsb2fGJ1IBwaz76NpXFIL5uiaN?=
 =?us-ascii?Q?xssPExMiLhW/p53jBXqyDcc4V7qHkcFd4defwQYnjJ0o/s1q0tWzeJ8dNMtf?=
 =?us-ascii?Q?kxMCsT4xf2/lsOd1itD3AMKGo+fie3G8e5DNiCZF56Jgad2h//inXEvqmR6q?=
 =?us-ascii?Q?0sFxhws+La68VsAvye/IL/q6Fy0xcy6pVcmVCFA1vcWus3njFQzTjnAAp6fb?=
 =?us-ascii?Q?bAUvaTrlsEJ0v4V/x+EP39B8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e668917-29c0-4f42-2cb1-08d8d42c9a3f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:45:30.6666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xSfi1Sdf6nD35haRV03kItVM4FymNvlOKFu/qafBGV1LItzxi6M+vW0FPeYabX0JJjQ9yQvIrSutId4Qo3XD2VfcW3ZBKQpKaUcjz1CQWMg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3461
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Chandan Babu R <chandanrlinux@gmail.com>

Source kernel commit: b9b7e1dc56c5ca8d6fc37c410b054e9f26737d2e

XFS does not check for possible overflow of per-inode extent counter
fields when adding extents to either data or attr fork.

For e.g.
1. Insert 5 million xattrs (each having a value size of 255 bytes) and
then delete 50% of them in an alternating manner.

2. On a 4k block sized XFS filesystem instance, the above causes 98511
extents to be created in the attr fork of the inode.

xfsaild/loop0  2008 [003]  1475.127209: probe:xfs_inode_to_disk: (ffffffffa43fb6b0) if_nextents=98511 i_ino=131

3. The incore inode fork extent counter is a signed 32-bit
quantity. However the on-disk extent counter is an unsigned 16-bit
quantity and hence cannot hold 98511 extents.

4. The following incorrect value is stored in the attr extent counter,
core.naextents = -32561

This commit adds a new helper function (i.e.
xfs_iext_count_may_overflow()) to check for overflow of the per-inode
data and xattr extent counters. Future patches will use this function to
make sure that an FS operation won't cause the extent counter to
overflow.

Suggested-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_inode_fork.c | 23 +++++++++++++++++++++++
 libxfs/xfs_inode_fork.h |  2 ++
 2 files changed, 25 insertions(+)

diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 0b1af501..83866cd 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -21,6 +21,7 @@
 #include "xfs_da_btree.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_attr_leaf.h"
+#include "xfs_types.h"
 
 kmem_zone_t *xfs_ifork_zone;
 
@@ -726,3 +727,25 @@ xfs_ifork_verify_local_attr(
 
 	return 0;
 }
+
+int
+xfs_iext_count_may_overflow(
+	struct xfs_inode	*ip,
+	int			whichfork,
+	int			nr_to_add)
+{
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	uint64_t		max_exts;
+	uint64_t		nr_exts;
+
+	if (whichfork == XFS_COW_FORK)
+		return 0;
+
+	max_exts = (whichfork == XFS_ATTR_FORK) ? MAXAEXTNUM : MAXEXTNUM;
+
+	nr_exts = ifp->if_nextents + nr_to_add;
+	if (nr_exts < ifp->if_nextents || nr_exts > max_exts)
+		return -EFBIG;
+
+	return 0;
+}
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index a4953e9..0beb8e2 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -172,5 +172,7 @@ extern void xfs_ifork_init_cow(struct xfs_inode *ip);
 
 int xfs_ifork_verify_local_data(struct xfs_inode *ip);
 int xfs_ifork_verify_local_attr(struct xfs_inode *ip);
+int xfs_iext_count_may_overflow(struct xfs_inode *ip, int whichfork,
+		int nr_to_add);
 
 #endif	/* __XFS_INODE_FORK_H__ */
-- 
2.7.4

