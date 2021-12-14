Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09497C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Dec 2021 08:47:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231918AbhLNIrN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Dec 2021 03:47:13 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:1110 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230007AbhLNIrN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Dec 2021 03:47:13 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE748BP021570;
        Tue, 14 Dec 2021 08:47:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=y6ooW7QQDFdRJRm3rpj35TwjLn8JKm0/R4XltzwnXF0=;
 b=kXwSggefI+vPrLNozUkEw3uSn9HlGbT2pY2mK8zeuwFc9vAaRdllXjcGcu6mCRx5oKQF
 ZvgDdgzaTn6MY6irdATJTjDVVuxVTTTiHhMWgzVlnGDL/9v+cKJJ0MC217fD8iCOZM7C
 vLdr6w+AQgBCAIX95D8zbazK/HzibCwv+zU0/TDPolb2KV9pK+6g5dQnOmE4+uOo+kL3
 zpsu9Wc7loprG1n0AWqVzLx+sAC5Jwr20MZZTccFGx93tmpF/efNgop6SV5XBDK/sFhQ
 7zmbybn8NT2Ea67S2bE9dSdsOLpndIX2p5nfYyCDt8W4LlTBomrajMJA3AaNJZycVkBx vg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx3ukb2sg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:47:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE8f5fa107701;
        Tue, 14 Dec 2021 08:47:09 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by userp3020.oracle.com with ESMTP id 3cvnepkyye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:47:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CEj5Ti4Zvknp5encRmdbNhHYU6mCDFzes+VVdjsG7TVROdkQKtHCS9f8tLZovaN3jdiw7oCFKB5aDT1HYqMqId84QklraNXQI4Plq73Hij2GXMhAh3DJMVy05QQHB8iN9T5HL+FKJlY0HtJ3FJwWIkBLpPu9NNT22YoW/HcBoANQDs9zM9LHWobLuWT/5awk9I6tCwx8GHweA3OOenvngWGUGq52JygbAAeUX64KWPDgZ2pB3+7jQcBo1lITzW8tiw5mLWt/5RsAPL64gAQw7h8b5gSwYkNZIAh8hE1Th7Y+fXhiw8zcAvO4AKMJMm44K3ynDpzpFSnIe1qtuAlxSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y6ooW7QQDFdRJRm3rpj35TwjLn8JKm0/R4XltzwnXF0=;
 b=mYeixMBqBeFO/5CPoEovhbvY/0/Ge5ncqtoUklqycodrOHiYne+lqrflLkLg0uV+EkQUxRiXhTTL8LxqUBlyWhPnJxDDdsBMRi8uStocUZrVI/qAjFkQ4IKyAy/6wbv7mqTJwzniQf4cH0XQk9Dhwn1k6tthzX++h21sCTKI5ImC3LA4GdGBrbPFaSvpFj6y17Wpw3U3UtL3KhNZxyVAR3ipfaZymDkGgbnBwS3/+9RzdIHXX6xDhAh5lV7CImHfuxxpNS/uIcvnSeUgysbxAIs5qZ7OiyLGVWlLL0z9p0KD5drhb1W33y4GHbmaa6k4iGwGZW7txrIeQv9lnzffHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y6ooW7QQDFdRJRm3rpj35TwjLn8JKm0/R4XltzwnXF0=;
 b=S+QEDIyP43d/VxdJdaiiPt/8Tbn2LP9rFCUAnAEf+wC2NN4JluMmTWyPBhekZcJcM3P0o9mGD9GR98BYH7tJ8wvtOVSUNh568ujn3GMt0TOEs938mQJJSrg6UeX8Lhfn5CgdMnUlTERXwbuLfh0+3pfwHJDsYQs5WCNWbJAbB9Q=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB3054.namprd10.prod.outlook.com (2603:10b6:805:d1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Tue, 14 Dec
 2021 08:47:07 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%6]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 08:47:07 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V4 05/16] xfs: Use basic types to define xfs_log_dinode's di_nextents and di_anextents
Date:   Tue, 14 Dec 2021 14:15:08 +0530
Message-Id: <20211214084519.759272-6-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211214084519.759272-1-chandan.babu@oracle.com>
References: <20211214084519.759272-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0052.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::14) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1301268-fceb-49a4-60c0-08d9bede4f4c
X-MS-TrafficTypeDiagnostic: SN6PR10MB3054:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB30545163FAEDE5A4CC9DBCD5F6759@SN6PR10MB3054.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:428;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fyZOfjBOevLOPtysMY824u/WRjrq9ofm5ul4SZyd7F8pDU65PPSuUjpH9OgrUOHxKHvATJfUQZSN4KOt7zsC9bAPPGBSbiwgygrqNiwCSZ8QAUKRZmbtPQ+uKqAjptG3cKZ0w2yyaOVFYlnq4KFKM8ouFgjgvW9LGSXUyfrkg9hx2MsSalrq+b92+dgraKKdByvjW/T9c5ZGBjdH187z4TbqydC3hY+cE8TkUTcI5KEQo8DqbfwVAwXuWM51YKxsOdXOJYn1X0QNMB8VQDj6M6043fDW35s/eIU5uEu4ODR2jIAkzPrwiuVmyf30nHSgjuMibH2mDH1pmkecDF6DQRMy8qBs2ofA8xLWenjqpG8BYpHg98nVR5rHHz2ddqlwcRbHAL59h7PKug3voWrkT5a3vjNC9flyx/42UklixeKEsescNOu5xZVXUPKnBjY2bcdI/IjlUTfs6lpS4kGLhqjii35SjZ8oxzGSy/qVEbz2xbgt/C1MfUYFkcGpNPIHp0SYREvxPP6pn3M/7PKMmnG5GrVE5jOyYkhGH+TUrdAOe8kaHHxuAJrXYMXWT4aG49oQ1o+4tt3UOHPfeMHVfnzpNWA+PDw+JwXRJATyfuGW74Lh+rBBKWeSE3+YgpTA4UO861mDwDRglZFLe8ZHOzm9ZxFY7js9xO6E9yCJkRFaAvtUxNjQubXp/Qg3QEw79b/l1HCa5AkmTnWkIHgVwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(8676002)(66556008)(66476007)(6486002)(316002)(6916009)(6512007)(186003)(5660300002)(2906002)(36756003)(83380400001)(26005)(66946007)(2616005)(1076003)(4326008)(6506007)(508600001)(52116002)(38350700002)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TuLkHS1HK7Ogvq7e9oukxqHhTM13pNIC10klzvKPir8K98EX4R0giSx/IN+9?=
 =?us-ascii?Q?reHYpye/kNI6jRHndJw6gtyMMVQZxFPFeo0kQQ2JOClU1mSQFhKJwhbUIxR0?=
 =?us-ascii?Q?6c2D5GTG3CD1FMtzOGzNjgSpf3wFDAKnwa/piNVgAKTpbaS7NHMRb8jZmrtM?=
 =?us-ascii?Q?RuunjbhnapLLqQAaWBQIGoiCAb4OU+8XmiUdQUq5MzV3nFZXrQxptNriKjpO?=
 =?us-ascii?Q?yLrdc5U8tpVFwTvh+Ui3B86cqEf0cd25ePD+qJj5LbFfbNHAYGu+kulljSKk?=
 =?us-ascii?Q?eFOvj6vOfjtc58RGUlfZODkQj1znUI1047XCo8JQdE4nbI70Zka/9Z5NRvE7?=
 =?us-ascii?Q?oe05pHbP4ec8uQWYpsRCSjprzuChqFfrT/SFW8RUG8OtRV9zZvoJkjtCpstH?=
 =?us-ascii?Q?h5XHh7c+zrdU9j0XbiaHr3X17Y3b7uJ9GaXOEmNpVRUiPLw85i99PwVz3In9?=
 =?us-ascii?Q?EdZZJax9zQr57InlofuZFzSZZG2ec2Akqnl9Igo4wqRWR+K07yBkJj2zXZK1?=
 =?us-ascii?Q?2dALTpGcnxXeTIfUyOP89ne6Dai7SKDN73eg0VrlJqBdr1Rq71igTuNtdxQU?=
 =?us-ascii?Q?jBY+uTQngDLACVH5nL/pAQouNhPBO30ZBu2rNsy/I/d//mToPIbKFXqm35l1?=
 =?us-ascii?Q?ytQ+MEjOCNNVbggigwcZDm50HSCvuOpzU98dxYkssJxXBi79XAag91uzHsop?=
 =?us-ascii?Q?yiE/lkoJkf7x+q423TEamaI3WCZt0KettwuoIKIoazVW8Pt790PZeRgBEhqV?=
 =?us-ascii?Q?7YQvhbjyNMsfmzOXvdk5ccJFxZXM0wY57plwQjrFLF4UUzuiB+/fu/4xjTXr?=
 =?us-ascii?Q?zKb3Go/54wWGJJLQKjiA32c5sWbdsf0wYcWxzn8wB9snJfxkBxtEP7gOiT/u?=
 =?us-ascii?Q?efoBW0qZ/YAO9UOJQDzijc3x1/3U4uf/C54THDz3UmjgoF6VdiSz5I152ild?=
 =?us-ascii?Q?8TiDhr96T0QuNYz9y/AbU4XqQAV4Coox4vrxXXoGcqR+qgTVP7Se7p/jNM+b?=
 =?us-ascii?Q?pVu83qFciYPVmMOJR/dZpM/owGTvW6chK9CWMZ4jtFNjCRAif1FV+T/TXM8D?=
 =?us-ascii?Q?JVeqaRzdtKmNQZM51Lj3vlULMip+rsn9ElDdJ5rZ12yaqXBy24u5bC+kbJyB?=
 =?us-ascii?Q?S99awZ6T3PYmXQY3MOURZGsBgJOnq8qtZ0MZqMaHZvDQTmdkwv04mYR2jqaQ?=
 =?us-ascii?Q?OUbAfoTrd4lhZjruaFwLTIEfQDMOi0FDHjj8V1b7ZKrCfvmgkL0ay4Mtu0W/?=
 =?us-ascii?Q?+x9LxyewKF3Q+uaZZYRCR4SwHhB2kLTeVEwWjdbDA3VNmsA3BbDFfi/2ARVa?=
 =?us-ascii?Q?BcDVdFh4xS4/hmL8kUu9I2uZdOiLSTzU3Ow+bJf0TQeljadHwisJWC18PhTb?=
 =?us-ascii?Q?VbOSbY/+DBRzuXRd8DiaYIQk1XD13/iWpM0BXLGn2ilBeHjmdVUzmuN0vmam?=
 =?us-ascii?Q?hyW7v4d2SyfQfWcfXSmYxnc+9I+UE0CizZLdJnHdPnPfa6HJaxcddds3KfXP?=
 =?us-ascii?Q?9dTVtBrgCHnwMxjSh3hHoxUcnc2m75kdS0FmwTF0LSIsTqjg+OidnRGh1HZK?=
 =?us-ascii?Q?6yEcuwnfbHm6W3ESdbfRbO7Dts8XMTOlRb2rw3IxmlHF3zmSnxgtA71Rd4Op?=
 =?us-ascii?Q?Z9Arb0MJimpHRcPI8mp8puo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1301268-fceb-49a4-60c0-08d9bede4f4c
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 08:47:07.2865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r0V4dzUfMRhuL5DoF3244T0LlL9oe4VhhYNohsJFxqD7vH8jD7kjmuCYjf7hVM9KTvn++cZl3fBsaHNjH5yzAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3054
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112140049
X-Proofpoint-GUID: 6NplpnlKU4T6HhkXaL1qU79MQssBvoMP
X-Proofpoint-ORIG-GUID: 6NplpnlKU4T6HhkXaL1qU79MQssBvoMP
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A future commit will increase the width of xfs_extnum_t in order to facilitate
larger per-inode extent counters. Hence this patch now uses basic types to
define xfs_log_dinode->[di_nextents|dianextents].

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_log_format.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index b322db523d65..fd66e70248f7 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -396,8 +396,8 @@ struct xfs_log_dinode {
 	xfs_fsize_t	di_size;	/* number of bytes in file */
 	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
 	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
-	xfs_extnum_t	di_nextents;	/* number of extents in data fork */
-	xfs_aextnum_t	di_anextents;	/* number of extents in attribute fork*/
+	uint32_t	di_nextents;	/* number of extents in data fork */
+	uint16_t	di_anextents;	/* number of extents in attribute fork*/
 	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
 	int8_t		di_aformat;	/* format of attr fork's data */
 	uint32_t	di_dmevmask;	/* DMIG event mask */
-- 
2.30.2

