Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22F3AC64EC4
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Mar 2023 22:38:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbjCHWif (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Mar 2023 17:38:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbjCHWid (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2023 17:38:33 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F383D902
        for <linux-xfs@vger.kernel.org>; Wed,  8 Mar 2023 14:38:26 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328JxoWL009740
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=6tYSEWWb1wiKYWw2+XP6sFmWvJlNNBn4jDtZsPv6VNo=;
 b=DweW3I+mLWC8natrHHmVltb7/eFKj+e2/ysoXGJRm/0AyoqfP+QB/wr0yti30pIN7/sr
 cbtdVuTTJtzq4/eq2wqSz+JdPCZeC+mg7jEUXEbhzK/yXaxs+zs+Ci3w3AeVM3qcxTSA
 x/PCj3Ub5ju83NA8WBYv8SFf19ywFZNCNKdHFSHbCRavlB1EKY+qFYJOJHTmi8FMv6Iu
 ZtqnDYm/YChGSAomu8qo+Ra8i4lyjwWQezlUcjKozyjRuU2E9uD8SrPFRG97dwHseznj
 6R//FPa20uctH0gE083kLUzqvITJOkOj1NH2PFbNdiTUftMvqOxjIui5nfN7/hM9CzS8 uA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p41621a52-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:25 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 328Lu5MF021598
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:24 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p6fu8mxxp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=itWz3bpbZbCgwqvEirLbFwB5ylZXRfgW2XVMZYSs7HG4AyHgjss5g2fy4e4124EFOR29C/Okh/a0Zm/iAi4kgBkgJ9ionL51me4CiHsYPXpyKzRZR/YT4CEplPvt9m3e5wK9yjnq7qvgGOwGwPfXnBDaxmVuGLMr/TbZzJQFwv7ITZFQPxM936LUipFS7tsJh9Xf1vJhw3u6JX4dIX6gzG+I1kRb1WVBBlUyxQbhg47yk5/KRcEHgzRpum1hGou8Fx6zYBuaKRXipA8knCls2qHJ/k0Ksej50xgBFpqCmeJzoYVXSJOM0bTyYNyrzB7g9xq+ivZIGJejWm4j9IZSww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6tYSEWWb1wiKYWw2+XP6sFmWvJlNNBn4jDtZsPv6VNo=;
 b=DA3YDJNeCqpfqYj33abSnEUw7SHb9aRQ+cH7X0Zvyq41d0ZEYWZro/MjbJzzvFCnEd177KWX0Ovac4ns8t9DFt89Kbyd20jMG7ST1ZAwJX4tN5ar4HRZUgKokIRvzuXUJkmpbxqL3ed0p97PA2/bFsKlE9GrbfN8NM6/sYpyqaEH+mCbjEL+GGWeR6H4vph8J6afKMe0EFkefZrk0z4+Uqm44hNFfkP0qljHoMg9kh5g0hHjIFOdyqSdNBLX8JANhCR0N63QNZwnKr9ixEolk8a11H366/YzSrZDA/tjjAdtXo80bOYsVJMQjpm3FrKT95WcBqfHp3/5QsyfKfKrRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6tYSEWWb1wiKYWw2+XP6sFmWvJlNNBn4jDtZsPv6VNo=;
 b=v1EvqmwJXf4douTGyNikGWq32eU87oSJJeLyAWhd2oT1qHVDJivORlwCvO2ocxa5I8tD5KC9WcF3ifEPBMBvBPDZjIFuhW+friODFEjU+CZvV+ephgqUaGVTk3K1F0VdBAVZKESVKXZOvLO1jx05+z17MbUWyYm3cBFK3oNQTXE=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB5708.namprd10.prod.outlook.com (2603:10b6:510:146::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.27; Wed, 8 Mar
 2023 22:38:22 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06%8]) with mapi id 15.20.6178.017; Wed, 8 Mar 2023
 22:38:22 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 14/32] xfs: extend transaction reservations for parent attributes
Date:   Wed,  8 Mar 2023 15:37:36 -0700
Message-Id: <20230308223754.1455051-15-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230308223754.1455051-1-allison.henderson@oracle.com>
References: <20230308223754.1455051-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0047.namprd11.prod.outlook.com
 (2603:10b6:a03:80::24) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB5708:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f1157c2-24a6-4572-0825-08db2025d2b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7h79ENJ0ZxaP/qTFlC0YVGfMVhF/giuIy8Wil9aIPRVeVgEGeimn9F2Jx7CZX1H6V1b0tjDSkCE2p+uTeDKSOdjD4jobkwiUaB9fi/MbC6nKhgUWX7gYoQAIHeA/dE0IPGmWJnPV2MGhnFknDgHHBTUM9nMd6rv9gDxmm2m6qR5r0E84kpfktBDubPNO+Lyo2ot1EUAc8QVwbEugK61QGtHRPX6VU94/0Ct4g/406CX0GW0Pe3lOd3en2S3x5JS2Mqyyik29mSOL4QpWiaJoAo1a8ZSdp0uZng/ImpgFF9Pw7I1yUGHLAJXNEik/6JJBdNC/1RA3aze/e4blKuBz5RN1wSwMkpaU039Eial5bg40M643lJ1SSXoQfJ9DR4oWBRstyZXLncek3uyzkWkPFz90+uBgZIdk32hXEmyTfKE67uKIBYXe4mJoe18b2di16/sQyyzFqUj/oo1iGVIVRwai5unsAm4Qa9gMoEzaj5z/6J2wLadXZCwbclFsJi0CUS/RxqCZZfd0QMXCx+O953G/nvrLChnC3n9YWQwilqOEaTra2BtcmJbldkG5Zr+my7Vj3X4mXr1dn/HvLboe1vYK35WHwKWf4HeBdl6NfRrnm8SKILwaCUlTav1CrY3Zu+CSzZytThLcCMAQXcK+rQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(136003)(39860400002)(376002)(451199018)(36756003)(6666004)(478600001)(83380400001)(6486002)(6506007)(186003)(9686003)(1076003)(2616005)(6916009)(6512007)(8936002)(66476007)(66946007)(2906002)(66556008)(41300700001)(8676002)(30864003)(86362001)(5660300002)(26005)(316002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4t93aITeFkOFPupjAfn7vnt1Yq0ORDCrejFBWhMy+lq4J/fU0XfApuGiPoWm?=
 =?us-ascii?Q?OOmXteoH+jTV2G1ckLX2Ct/wrcLaTxZop50jVx2dgcANzUao3i6CLVpHiPb/?=
 =?us-ascii?Q?gUfnz3WAVmSfD364V5U9tkCtFtBuDh6DPyolUhJoFM55PDAO7plM5MpmgFfN?=
 =?us-ascii?Q?kKNkDLWNRnFzG7+vuxW9P2Ack0wK8rWojwp2e6WNznN75JQn4M/5X/2ZXJq2?=
 =?us-ascii?Q?WZJzyE354yoJ1YkJ/BnALcPf/QWdVXw3slMBT+55Nie0QkU2rtW/WZ2M7CMO?=
 =?us-ascii?Q?FQockyCyf0Uq8S2/C28/q90Cnv05BcdpBtVsA5gqhaz5dF+TYjRQG3kGLC9p?=
 =?us-ascii?Q?VGRfrZp1Ro1d2Zw1gmK/H9h0WMN4JypWrTRWPqMO6uAYG1OHLzd7H9lbv+U6?=
 =?us-ascii?Q?Zjduxjse+UIQe5jNyHb7p6TzYvnZ8Bwd6mG9zvzI7BbN56dinl2jV450OS3M?=
 =?us-ascii?Q?DPaTXYzLquy9ByvLKCGBhaOD01QSuR6P2izs9R5gWy7k1Yf8QalltwNukR2E?=
 =?us-ascii?Q?xrkZQC6tQds0IaeA51RwDw1DSMUwo5bRyPmFNMXKYeoToXbCbpL7innOO3k1?=
 =?us-ascii?Q?qg5nAyixC8fHZHSDK/IoJGNP/mWnZfybKeaRNxr65SHYbvpovpkNh+barBBw?=
 =?us-ascii?Q?cs1nNTt3orqAo4UK1JFoUYXgpyo6T32pKzxeata7qe9MkCNyxjnwaAifDiVN?=
 =?us-ascii?Q?IS4DJyXn9/yPDEaJpOlEL9VJgVxR/Phpm9Z5nF14wTzTfQaDoCH8cEbZrxBU?=
 =?us-ascii?Q?44k7dQjwaZ0vadgeprQsLAAuo7A+197MZnGAxR07gdnXN6E8yJ5caL0NOHxu?=
 =?us-ascii?Q?J9v3qj6gAvpalv97i86kzLYZezO79rQZyTUhgIj3yg+/3YCxiKMvQHNiQYA0?=
 =?us-ascii?Q?KhBBZHM7SKmsfHFpX6rkLgpKxEmug8tYaNd2DCOOuSItNOLcK9CdPpn5oaB7?=
 =?us-ascii?Q?cs/IV8NrXBuYNAINkVzO0aBZ6jqEaTvufWqE4xbpdk3vnYPMLg1Md1eH/OkV?=
 =?us-ascii?Q?yEOCtJhN1Ih4v0RQcU/BlggfhIdNNkeRjTl/rEJWniwtPeywJ4uatPlx+X17?=
 =?us-ascii?Q?/YSc3HSwJ1yZ0PuiEuVKK73r1MDRtJi2EhABzMDGo9YwokBelg2/WRLaW+KU?=
 =?us-ascii?Q?XsQsbwgXsJ/4QYc5zwqCm8did+aB8RF8U8M3BnCyIhQGfR8wE/A9b+FzIm15?=
 =?us-ascii?Q?HLGaWEWksxF/vasDLutszqtnTYExy6sP8vvsBtbdGZ19y0YkdWgc0GoImb4e?=
 =?us-ascii?Q?+lJzbFzFIXJ3BsVZk12Nr/0p8r+yRxyFXSUUgeacMRgf4SK1Oa70l37nfuBR?=
 =?us-ascii?Q?Ylctr9+D0Y6oZnzO3NQe/GunvVgWRu9fnVnmjIxYxXSLKv8Z07n2TwyrGhr/?=
 =?us-ascii?Q?ZFqLzcV4jxViofPfzK4QDQshNSvWVQnHgaSZ+z/WdCT8GiTj4ITQsH7y/ket?=
 =?us-ascii?Q?6TwMhADSIQbxLX2IqaxaVzylMTRsNscghvXTV8CcFlAggdPVkfc52QRUdR/T?=
 =?us-ascii?Q?OGVrUfoJBIcq2QyWWQR2OcN+ZoH1ud3J3KOTl9Jhpc/fqPKKoVmK9R3wJrLS?=
 =?us-ascii?Q?re1AfhMC5Dh6+NI19tnDUGVhqcNjTYoZzN4uGXzJEEyZcvTlqRi9tSEI8Ghz?=
 =?us-ascii?Q?pw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: msEbG+/SmgDAQbJwjrdx3yeQh2cc5ZHR+4i2NopFVIS+rD5Ekz36BIwGRU5D3kdzX2IoVgU5VV9HdU3nV2ojWyd/8MZUhwAhk9HNhjdspf5rLhmDu5mW1QY3suzeVafIFEV8JC01E5WB5BlsjgZBEJ922vw+mKkpEZGJBbqzjVoRr1f2SHsuaPoTZftP0WBbJDWXWTWkoZHLWdgn/8F7+wFudFKCtuOaqxKhExmY5FEyFdzaLE9WwhIomQy/eluKtiOXYcTblMi99CUDZbpnYWibeNA/NamGR03b5JRpNVMRDnSCwYtHuQRMB1LfedVFwfjyeawRispVYmQsovvoX+qcINJRtMzajV1rQdlhzP246KhMGcKyQU+RtDbWOM2QV/C8FlDRyO/3uMhA1TfW0X1SZ4E7n+8FXJNGXA4OtkcFrcs0MU5+UZg1bvxVArAX2pTptY0tBRi+6ZSPBgq1XFhhMQdaNa4ISi+rOBkszkIZxuPG13lHX3F1JIO0lG9Q7iuajhxVCF7Ol9yZ/j0a8/Kfzs7B4kXNpLahseBGEMWY/lBFqLKDVNPju5HRnnxf9UG5/Zh3YAKZM+fRk/mDGIx84ZMn2UluwbBDctiecsYp+CWUquya3gkSgB/aO+yWC+8mMYXYGVRISAgW84bMInNUeXtEMV+SnKICNKx4LRkkELXoR97jdhIWbIAvRhqIERicDhTvpgr6XjH0lLoluI1Iris3S+6hepnD0xiwEw41sc8+S5M07lV10oqSkQl7wQolM9mD/TN17IM82HnOBg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f1157c2-24a6-4572-0825-08db2025d2b2
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 22:38:22.5537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o9anxTnEl3312F83ZPcPK37EF7r3/MXaiInyThRCQNLilwjALug3QuSpcVVQj0shzqxKvsTFpnULxeuHiL5SwBWQXe9l8fuRWmX1RdZFiic=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5708
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_15,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303080190
X-Proofpoint-GUID: l7nGS9sCSRaSucb1DvBst5IvhXHbXl0t
X-Proofpoint-ORIG-GUID: l7nGS9sCSRaSucb1DvBst5IvhXHbXl0t
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

We need to add, remove or modify parent pointer attributes during
create/link/unlink/rename operations atomically with the dirents in the
parent directories being modified. This means they need to be modified
in the same transaction as the parent directories, and so we need to add
the required space for the attribute modifications to the transaction
reservations.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_trans_resv.c | 324 +++++++++++++++++++++++++++------
 1 file changed, 272 insertions(+), 52 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 5b2f27cbdb80..93419956b9e5 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -19,6 +19,9 @@
 #include "xfs_trans.h"
 #include "xfs_qm.h"
 #include "xfs_trans_space.h"
+#include "xfs_attr_item.h"
+#include "xfs_log.h"
+#include "xfs_da_format.h"
 
 #define _ALLOC	true
 #define _FREE	false
@@ -420,29 +423,108 @@ xfs_calc_itruncate_reservation_minlogsize(
 	return xfs_calc_itruncate_reservation(mp, true);
 }
 
+static inline unsigned int xfs_calc_pptr_link_overhead(void)
+{
+	return sizeof(struct xfs_attri_log_format) +
+			xlog_calc_iovec_len(XATTR_NAME_MAX) +
+			xlog_calc_iovec_len(sizeof(struct xfs_parent_name_rec));
+}
+static inline unsigned int xfs_calc_pptr_unlink_overhead(void)
+{
+	return sizeof(struct xfs_attri_log_format) +
+			xlog_calc_iovec_len(sizeof(struct xfs_parent_name_rec));
+}
+static inline unsigned int xfs_calc_pptr_replace_overhead(void)
+{
+	return sizeof(struct xfs_attri_log_format) +
+			xlog_calc_iovec_len(XATTR_NAME_MAX) +
+			xlog_calc_iovec_len(XATTR_NAME_MAX) +
+			xlog_calc_iovec_len(sizeof(struct xfs_parent_name_rec));
+}
+
 /*
  * In renaming a files we can modify:
  *    the five inodes involved: 5 * inode size
  *    the two directory btrees: 2 * (max depth + v2) * dir block size
  *    the two directory bmap btrees: 2 * max depth * block size
  * And the bmap_finish transaction can free dir and bmap blocks (two sets
- *	of bmap blocks) giving:
+ *	of bmap blocks) giving (t2):
  *    the agf for the ags in which the blocks live: 3 * sector size
  *    the agfl for the ags in which the blocks live: 3 * sector size
  *    the superblock for the free block count: sector size
  *    the allocation btrees: 3 exts * 2 trees * (2 * max depth - 1) * block size
+ * If parent pointers are enabled (t3), then each transaction in the chain
+ *    must be capable of setting or removing the extended attribute
+ *    containing the parent information.  It must also be able to handle
+ *    the three xattr intent items that track the progress of the parent
+ *    pointer update.
  */
 STATIC uint
 xfs_calc_rename_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
-		max((xfs_calc_inode_res(mp, 5) +
-		     xfs_calc_buf_res(2 * XFS_DIROP_LOG_COUNT(mp),
-				      XFS_FSB_TO_B(mp, 1))),
-		    (xfs_calc_buf_res(7, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 3),
-				      XFS_FSB_TO_B(mp, 1))));
+	unsigned int		overhead = XFS_DQUOT_LOGRES(mp);
+	struct xfs_trans_resv	*resp = M_RES(mp);
+	unsigned int		t1, t2, t3 = 0;
+
+	t1 = xfs_calc_inode_res(mp, 5) +
+	     xfs_calc_buf_res(2 * XFS_DIROP_LOG_COUNT(mp),
+			XFS_FSB_TO_B(mp, 1));
+
+	t2 = xfs_calc_buf_res(7, mp->m_sb.sb_sectsize) +
+	     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 3),
+			XFS_FSB_TO_B(mp, 1));
+
+	if (xfs_has_parent(mp)) {
+		unsigned int	rename_overhead, exchange_overhead;
+
+		t3 = max(resp->tr_attrsetm.tr_logres,
+			 resp->tr_attrrm.tr_logres);
+
+		/*
+		 * For a standard rename, the three xattr intent log items
+		 * are (1) replacing the pptr for the source file; (2)
+		 * removing the pptr on the dest file; and (3) adding a
+		 * pptr for the whiteout file in the src dir.
+		 *
+		 * For an RENAME_EXCHANGE, there are two xattr intent
+		 * items to replace the pptr for both src and dest
+		 * files.  Link counts don't change and there is no
+		 * whiteout.
+		 *
+		 * In the worst case we can end up relogging all log
+		 * intent items to allow the log tail to move ahead, so
+		 * they become overhead added to each transaction in a
+		 * processing chain.
+		 */
+		rename_overhead = xfs_calc_pptr_replace_overhead() +
+				  xfs_calc_pptr_unlink_overhead() +
+				  xfs_calc_pptr_link_overhead();
+		exchange_overhead = 2 * xfs_calc_pptr_replace_overhead();
+
+		overhead += max(rename_overhead, exchange_overhead);
+	}
+
+	return overhead + max3(t1, t2, t3);
+}
+
+static inline unsigned int
+xfs_rename_log_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	/* One for the rename, one more for freeing blocks */
+	unsigned int		ret = XFS_RENAME_LOG_COUNT;
+
+	/*
+	 * Pre-reserve enough log reservation to handle the transaction
+	 * rolling needed to remove or add one parent pointer.
+	 */
+	if (xfs_has_parent(mp))
+		ret += max(resp->tr_attrsetm.tr_logcount,
+			   resp->tr_attrrm.tr_logcount);
+
+	return ret;
 }
 
 /*
@@ -459,6 +541,23 @@ xfs_calc_iunlink_remove_reservation(
 	       2 * M_IGEO(mp)->inode_cluster_size;
 }
 
+static inline unsigned int
+xfs_link_log_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	unsigned int		ret = XFS_LINK_LOG_COUNT;
+
+	/*
+	 * Pre-reserve enough log reservation to handle the transaction
+	 * rolling needed to add one parent pointer.
+	 */
+	if (xfs_has_parent(mp))
+		ret += resp->tr_attrsetm.tr_logcount;
+
+	return ret;
+}
+
 /*
  * For creating a link to an inode:
  *    the parent directory inode: inode size
@@ -475,14 +574,23 @@ STATIC uint
 xfs_calc_link_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
-		xfs_calc_iunlink_remove_reservation(mp) +
-		max((xfs_calc_inode_res(mp, 2) +
-		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
-				      XFS_FSB_TO_B(mp, 1))),
-		    (xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 1),
-				      XFS_FSB_TO_B(mp, 1))));
+	unsigned int            overhead = XFS_DQUOT_LOGRES(mp);
+	struct xfs_trans_resv   *resp = M_RES(mp);
+	unsigned int            t1, t2, t3 = 0;
+
+	overhead += xfs_calc_iunlink_remove_reservation(mp);
+	t1 = xfs_calc_inode_res(mp, 2) +
+	       xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp), XFS_FSB_TO_B(mp, 1));
+	t2 = xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
+	     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 1),
+			      XFS_FSB_TO_B(mp, 1));
+
+	if (xfs_has_parent(mp)) {
+		t3 = resp->tr_attrsetm.tr_logres;
+		overhead += xfs_calc_pptr_link_overhead();
+	}
+
+	return overhead + max3(t1, t2, t3);
 }
 
 /*
@@ -497,6 +605,23 @@ xfs_calc_iunlink_add_reservation(xfs_mount_t *mp)
 			M_IGEO(mp)->inode_cluster_size;
 }
 
+static inline unsigned int
+xfs_remove_log_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	unsigned int		ret = XFS_REMOVE_LOG_COUNT;
+
+	/*
+	 * Pre-reserve enough log reservation to handle the transaction
+	 * rolling needed to add one parent pointer.
+	 */
+	if (xfs_has_parent(mp))
+		ret += resp->tr_attrrm.tr_logcount;
+
+	return ret;
+}
+
 /*
  * For removing a directory entry we can modify:
  *    the parent directory inode: inode size
@@ -513,14 +638,24 @@ STATIC uint
 xfs_calc_remove_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
-		xfs_calc_iunlink_add_reservation(mp) +
-		max((xfs_calc_inode_res(mp, 2) +
-		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
-				      XFS_FSB_TO_B(mp, 1))),
-		    (xfs_calc_buf_res(4, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 2),
-				      XFS_FSB_TO_B(mp, 1))));
+	unsigned int            overhead = XFS_DQUOT_LOGRES(mp);
+	struct xfs_trans_resv   *resp = M_RES(mp);
+	unsigned int            t1, t2, t3 = 0;
+
+	overhead += xfs_calc_iunlink_add_reservation(mp);
+
+	t1 = xfs_calc_inode_res(mp, 2) +
+	     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp), XFS_FSB_TO_B(mp, 1));
+	t2 = xfs_calc_buf_res(4, mp->m_sb.sb_sectsize) +
+	     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 2),
+			      XFS_FSB_TO_B(mp, 1));
+
+	if (xfs_has_parent(mp)) {
+		t3 = resp->tr_attrrm.tr_logres;
+		overhead += xfs_calc_pptr_unlink_overhead();
+	}
+
+	return overhead + max3(t1, t2, t3);
 }
 
 /*
@@ -569,12 +704,40 @@ xfs_calc_icreate_resv_alloc(
 		xfs_calc_finobt_res(mp);
 }
 
+static inline unsigned int
+xfs_icreate_log_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	unsigned int		ret = XFS_CREATE_LOG_COUNT;
+
+	/*
+	 * Pre-reserve enough log reservation to handle the transaction
+	 * rolling needed to add one parent pointer.
+	 */
+	if (xfs_has_parent(mp))
+		ret += resp->tr_attrsetm.tr_logcount;
+
+	return ret;
+}
+
 STATIC uint
-xfs_calc_icreate_reservation(xfs_mount_t *mp)
+xfs_calc_icreate_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
-		max(xfs_calc_icreate_resv_alloc(mp),
-		    xfs_calc_create_resv_modify(mp));
+	struct xfs_trans_resv   *resp = M_RES(mp);
+	unsigned int		overhead = XFS_DQUOT_LOGRES(mp);
+	unsigned int		t1, t2, t3 = 0;
+
+	t1 = xfs_calc_icreate_resv_alloc(mp);
+	t2 = xfs_calc_create_resv_modify(mp);
+
+	if (xfs_has_parent(mp)) {
+		t3 = resp->tr_attrsetm.tr_logres;
+		overhead += xfs_calc_pptr_link_overhead();
+	}
+
+	return overhead + max3(t1, t2, t3);
 }
 
 STATIC uint
@@ -587,6 +750,23 @@ xfs_calc_create_tmpfile_reservation(
 	return res + xfs_calc_iunlink_add_reservation(mp);
 }
 
+static inline unsigned int
+xfs_mkdir_log_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	unsigned int		ret = XFS_MKDIR_LOG_COUNT;
+
+	/*
+	 * Pre-reserve enough log reservation to handle the transaction
+	 * rolling needed to add one parent pointer.
+	 */
+	if (xfs_has_parent(mp))
+		ret += resp->tr_attrsetm.tr_logcount;
+
+	return ret;
+}
+
 /*
  * Making a new directory is the same as creating a new file.
  */
@@ -597,6 +777,22 @@ xfs_calc_mkdir_reservation(
 	return xfs_calc_icreate_reservation(mp);
 }
 
+static inline unsigned int
+xfs_symlink_log_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	unsigned int		ret = XFS_SYMLINK_LOG_COUNT;
+
+	/*
+	 * Pre-reserve enough log reservation to handle the transaction
+	 * rolling needed to add one parent pointer.
+	 */
+	if (xfs_has_parent(mp))
+		ret += resp->tr_attrsetm.tr_logcount;
+
+	return ret;
+}
 
 /*
  * Making a new symplink is the same as creating a new file, but
@@ -909,54 +1105,76 @@ xfs_calc_sb_reservation(
 	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
 }
 
-void
-xfs_trans_resv_calc(
+/*
+ * Namespace reservations.
+ *
+ * These get tricky when parent pointers are enabled as we have attribute
+ * modifications occurring from within these transactions. Rather than confuse
+ * each of these reservation calculations with the conditional attribute
+ * reservations, add them here in a clear and concise manner. This requires that
+ * the attribute reservations have already been calculated.
+ *
+ * Note that we only include the static attribute reservation here; the runtime
+ * reservation will have to be modified by the size of the attributes being
+ * added/removed/modified. See the comments on the attribute reservation
+ * calculations for more details.
+ */
+STATIC void
+xfs_calc_namespace_reservations(
 	struct xfs_mount	*mp,
 	struct xfs_trans_resv	*resp)
 {
-	int			logcount_adj = 0;
-
-	/*
-	 * The following transactions are logged in physical format and
-	 * require a permanent reservation on space.
-	 */
-	resp->tr_write.tr_logres = xfs_calc_write_reservation(mp, false);
-	resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
-	resp->tr_write.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
-
-	resp->tr_itruncate.tr_logres = xfs_calc_itruncate_reservation(mp, false);
-	resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
-	resp->tr_itruncate.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+	ASSERT(resp->tr_attrsetm.tr_logres > 0);
 
 	resp->tr_rename.tr_logres = xfs_calc_rename_reservation(mp);
-	resp->tr_rename.tr_logcount = XFS_RENAME_LOG_COUNT;
+	resp->tr_rename.tr_logcount = xfs_rename_log_count(mp, resp);
 	resp->tr_rename.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
 	resp->tr_link.tr_logres = xfs_calc_link_reservation(mp);
-	resp->tr_link.tr_logcount = XFS_LINK_LOG_COUNT;
+	resp->tr_link.tr_logcount = xfs_link_log_count(mp, resp);
 	resp->tr_link.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
 	resp->tr_remove.tr_logres = xfs_calc_remove_reservation(mp);
-	resp->tr_remove.tr_logcount = XFS_REMOVE_LOG_COUNT;
+	resp->tr_remove.tr_logcount = xfs_remove_log_count(mp, resp);
 	resp->tr_remove.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
 	resp->tr_symlink.tr_logres = xfs_calc_symlink_reservation(mp);
-	resp->tr_symlink.tr_logcount = XFS_SYMLINK_LOG_COUNT;
+	resp->tr_symlink.tr_logcount = xfs_symlink_log_count(mp, resp);
 	resp->tr_symlink.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
 	resp->tr_create.tr_logres = xfs_calc_icreate_reservation(mp);
-	resp->tr_create.tr_logcount = XFS_CREATE_LOG_COUNT;
+	resp->tr_create.tr_logcount = xfs_icreate_log_count(mp, resp);
 	resp->tr_create.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
+	resp->tr_mkdir.tr_logres = xfs_calc_mkdir_reservation(mp);
+	resp->tr_mkdir.tr_logcount = xfs_mkdir_log_count(mp, resp);
+	resp->tr_mkdir.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+}
+
+void
+xfs_trans_resv_calc(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	int			logcount_adj = 0;
+
+	/*
+	 * The following transactions are logged in physical format and
+	 * require a permanent reservation on space.
+	 */
+	resp->tr_write.tr_logres = xfs_calc_write_reservation(mp, false);
+	resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
+	resp->tr_write.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
+	resp->tr_itruncate.tr_logres = xfs_calc_itruncate_reservation(mp, false);
+	resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
+	resp->tr_itruncate.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
 	resp->tr_create_tmpfile.tr_logres =
 			xfs_calc_create_tmpfile_reservation(mp);
 	resp->tr_create_tmpfile.tr_logcount = XFS_CREATE_TMPFILE_LOG_COUNT;
 	resp->tr_create_tmpfile.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
-	resp->tr_mkdir.tr_logres = xfs_calc_mkdir_reservation(mp);
-	resp->tr_mkdir.tr_logcount = XFS_MKDIR_LOG_COUNT;
-	resp->tr_mkdir.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
-
 	resp->tr_ifree.tr_logres = xfs_calc_ifree_reservation(mp);
 	resp->tr_ifree.tr_logcount = XFS_INACTIVE_LOG_COUNT;
 	resp->tr_ifree.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
@@ -986,6 +1204,8 @@ xfs_trans_resv_calc(
 	resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
 	resp->tr_qm_dqalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
+	xfs_calc_namespace_reservations(mp, resp);
+
 	/*
 	 * The following transactions are logged in logical format with
 	 * a default log count.
-- 
2.25.1

