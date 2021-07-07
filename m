Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E13C1C07E9C
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 22:21:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDE7761CD1
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 22:21:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhGGWYJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Jul 2021 18:24:09 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:19712 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230453AbhGGWYI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Jul 2021 18:24:08 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 167MCXB5018228
        for <linux-xfs@vger.kernel.org>; Wed, 7 Jul 2021 22:21:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=e/jzZ9kTdOGQdC7A6N0ZYyaKQcovKgAskPBa3lc2K/I=;
 b=Ye4uTr2O8bFDA/LuGaYyl790KlfgdNlhTPGMxARAMpEROMsTngJPXSR37GwmxskpZaSU
 AtB8SYjQenH8vT13T8T24CzT9UodHTPziAllB+lV7Rtr9iXpXDPhc5ytVWeqhgmmWo5o
 aGHDsOGJ7UgGoP363bLTd4N3QtPHZ+QpikRJz9OEIX+3sdaqbIh6fwLjBCDjXE+hO6AB
 vFoVPLq7eIVh5oIufELzu71TZ1Oe/rSDE2h3VmnDpzJ86PTWkuMVLWlwUXnMfo3XYTnw
 UxAmUkfc6AOwZojRfT8TNwY5BeCYtbOp8nvlsMxct3wdYwM1qypp4byrXYn+yf86y/x/ tA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39n4yd1wb6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 07 Jul 2021 22:21:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 167MKYSd092507
        for <linux-xfs@vger.kernel.org>; Wed, 7 Jul 2021 22:21:26 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by userp3020.oracle.com with ESMTP id 39k1ny0hp5-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 07 Jul 2021 22:21:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uz5T6WIa+OdFLeesSd+zoQNr9/vd7ch9sQkT31vyY4PHJ10B2Cy9cpIigXbN5N3r3pbjrxcgdlH+Q6LbreV4fL64egNPqt8QfgtkDNLcSNhWlubwlzq4l8nsSKzLTHVkeUPlt1PPmWyI3dYYq/7ZO00nQYOO00FUKyLASgYoPCUuMfx4e7mmsV29VxfW6/JdXSMZpdmOd2cRZcTzsJkgyWjcPuT3NPUhShBbBa46afPxfFLjgJWjQUmU125M25pwY/9eF2+/nkokz422A5/8M2VzX0i35PoKkXAp8YplVwaSVH2x2tp75p+uUf6Y8BqJJsHCX0lTSxUkjL5PE108jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e/jzZ9kTdOGQdC7A6N0ZYyaKQcovKgAskPBa3lc2K/I=;
 b=YlgV5ATdJrCojqpRRMWFQXUUerM6N5z8johS6lZiGRPpcztHu4MLusrlrXxkVu0fAxgTB4Z/1MtMYriWn2cBrDu5evoGF8waMxMknbF1RecMY48Zh6Ked7ZZS86beUnMX0cBMhQD+zTzLlHK89xyVAqfoxFMmrTSojljWtLoM6BEhUahVD4dx3n/oBp2vTjslgXBNr1pE2xvW7fcERbuAZCeQwHW7Jsys0fyoQPgI4wIKk2WewPEvpLamuvvovrq6JeikXfjEhqphvsJ3/AG1XzUPU/s+wpeXtyOaOrG3ufPZZl/u87mtv1p2108Lc0Z9nq8ZFL1sSbui0U098nffA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e/jzZ9kTdOGQdC7A6N0ZYyaKQcovKgAskPBa3lc2K/I=;
 b=O6PyjCKS/SFDPesASyY/r4TzldxYCQw9gHoFqtlCeZGplPGm2OvxaG+hdNIFZ4PE1E/NiByiM81JOMFA0oMcTp+zNSzX/APtyZtJQmZ58z76dpI9RivX1B6B0xeNGNQJzRN0c1YWXOB7NB21pEze4pNme0LGoU/wjs+9J2GO5qU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2760.namprd10.prod.outlook.com (2603:10b6:a02:a9::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.32; Wed, 7 Jul
 2021 22:21:23 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%9]) with mapi id 15.20.4308.020; Wed, 7 Jul 2021
 22:21:23 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v21 03/13] xfs: Rename __xfs_attr_rmtval_remove
Date:   Wed,  7 Jul 2021 15:21:01 -0700
Message-Id: <20210707222111.16339-4-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210707222111.16339-1-allison.henderson@oracle.com>
References: <20210707222111.16339-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0026.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::31) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR13CA0026.namprd13.prod.outlook.com (2603:10b6:a03:2c0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.8 via Frontend Transport; Wed, 7 Jul 2021 22:21:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b92988c-a1a3-4bac-2d94-08d941958df0
X-MS-TrafficTypeDiagnostic: BYAPR10MB2760:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2760BB08E481E6307AE2B4DE951A9@BYAPR10MB2760.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1c9dFbnwPdV3QioRV74I2hoNu/eLdnVYDnTkvVZqRXADHeoWRI07dIOC2FAO+wmL04CIEF3axmORFXv2z7vfnodwLjuumPHzwYPqkyL2RuLXxjkIRtRA8fEl8ile7I8o3gMvyaReLjNiFtSMgcEO1OtTkqZ32Q3eaLyweRDHc17tkGUNBqGfseMxgX53Y9RKiIIw5qKOLbaluR1T+oaofDAVzQS+jCH1a4EAZQx1dLgZv2kL4K3iqoCFlKK+N9JX6cT+yaU5G1yErJQ31EPex+9EXBUfo5iByY50Dzdcl6rGy+toQstDTtswY860ddzl1fPUn6P/b9P5BhU3TZcKMDvIMDt8edG1mBkWRwLImqm3gkhPTtWjZyDtXi31VuFwHxeZigZNhHbqCv0jS3dJK9hZNucSvzetmatyXYOGAENzbKiBBh5ZotE5fSNCB3xiFxkMA3eyzievDkJgIeAjc6XKx5PD7ZmvJ7J5L5eKbihq8hl4iuxy7USJWweOtqXBp4ytTDEgvkLXioeuCfWD0mkQ79u6pLy6fn5IlxE2RgSNTGtAr2pCe+i3pAE9Wo/vs31WSZkgL645/q7PzzvUGko2jWM1BdUl/vyhJsKCL4z6hzRp5SUBG5iRoUoLKCH7GTZt0cQSVaNrA4YNAPwleR6EgCGrVc8QcO78I9mnweSarDkT8O4qCN4wBKtyGGc4U2tMKzk8Yisd2MdX3NkIQQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(366004)(136003)(376002)(478600001)(83380400001)(8676002)(2616005)(6512007)(956004)(5660300002)(44832011)(66476007)(66556008)(186003)(2906002)(8936002)(86362001)(6916009)(36756003)(38350700002)(26005)(316002)(1076003)(52116002)(6486002)(66946007)(38100700002)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W+KEB5TDOKJ9fKwwN9n9Chf71d9DVxOAPGET9T2GsKqFSoG0HWlJl8RxmoRA?=
 =?us-ascii?Q?u9WhTVVTnTfrBo3ngHxVfWtymHZOmawFQUUh4IeJWob32P1oYg0Vo0afP9wo?=
 =?us-ascii?Q?skEWgWr870epQMVnRdtxs06CEeqTf5F29lLrzVOSU2jLE/32Vg1Z5Pe+xcjS?=
 =?us-ascii?Q?mPu0YjC/jmwj1vP3hBxI0efsVy0o9EiEdmjPQjSbCKJzRBjIuNzNaduIzgpc?=
 =?us-ascii?Q?CGafhUxErBnAvdtTiW5AOOjiC3q+uADpHNRwidUzvVp/6Zi2Bk67rD6PI5a0?=
 =?us-ascii?Q?v2/YOVC5qqlijkrDuis8y6hxqymXr4hw13xOMjDtmvUJKcZv89bUt2ffwikF?=
 =?us-ascii?Q?BwaKDWjKRPmlw2aLBiktzhTsXL8lwsr/G1Yx05Aw9kQTCy0g+wpdIQoFjCDh?=
 =?us-ascii?Q?13q9WnbqezRbSaCcWm0IhUTemer8sHV3Y+XbR3cqJygu/vi+6HeCnK5nGdw9?=
 =?us-ascii?Q?t8TeSy+pLcT+LLHTkHg3QZNSCBXBtXO9ZbOGef+FrDO93Dpma7jEjRnz7JI2?=
 =?us-ascii?Q?P8pL+rXaQ2pYpaLIbGPVbwmMoBd0FoZ1ZqKKFiMr9C0PDa0EXBSJzpYbBH1Y?=
 =?us-ascii?Q?cmos6pevTuLBYxrLiBvtfiaJ2/uy8TkVJit1Q4aRg5E9nGIlr/AF1RjW3uIn?=
 =?us-ascii?Q?U+5fVeB1eiFDBWyAXIdOn0prw53MoqY/OwVbEfrqaufzwRBu9llQnWzvL38z?=
 =?us-ascii?Q?QzDF4ADCVbHERer6UZpFyWqTENVJORNqA0sY+bRbO+lBNqwXVrOORM64gS6k?=
 =?us-ascii?Q?fENN7g/ImWPrQxiytV1gVR3wd+fBHCdldzK32/Q4BQF691Wb7NWSGoedZj07?=
 =?us-ascii?Q?cLKo4CmpoqhRWaWUTnhzpHRFFqaJ0gvO/eHixFuUf9JLvyDssgV68cHcpybs?=
 =?us-ascii?Q?60ZvVQbsFrPzcm+CuHT2MdFsM27O1yeGMJhemLJ/6PCMd4dlksTfhWmMksav?=
 =?us-ascii?Q?eZ2yEeY6R9fpBWJQWJnplIFxj+pPiFWVku8U2bsadUWJeHpAM5tM7xctxuNp?=
 =?us-ascii?Q?NrEv/DKd4la5gE1C3A/uxXA2lpXqQ4ITpAoe1ZGaEL4b6secJ1rn+R0E3Q22?=
 =?us-ascii?Q?5JjVVt7UwlXv9h5Y0mCouZ9PfaWSh1QW2nhFI+1rcDCIcAYmdVpgra1AS7kk?=
 =?us-ascii?Q?F7S7dVHIcQtzDlD9R5/HgbZbamyFNr0py1OL5gFWzd4VgRp+6f545KH1j7Hv?=
 =?us-ascii?Q?l8mAbkdU6E/U97/j8C42TM3rihKlyc8XUG/FFwX0Tm3YYc1AwHu+St+2LA68?=
 =?us-ascii?Q?eOcdNSDwwIFJ1AJFMFeKawXgkRLBL0rxHuCUf8UhvirIX9312b3/GLCI9L5+?=
 =?us-ascii?Q?JJDv9UI70NWJyBuKTVZyCHzD?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b92988c-a1a3-4bac-2d94-08d941958df0
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2021 22:21:23.8419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ppj0/3kyxl90gAZxJcKH3hqqV7yCpEy8DE2a06X2oYgiMZFYsQvdLAIFSlkgGYm87u/alMdFopsITPm1yy2qffXZSzS6XwRNmDLjkXu9uPI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2760
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10037 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107070128
X-Proofpoint-GUID: nbaqQdHgpq2CPM5T3O4GBQzva4Awrpjv
X-Proofpoint-ORIG-GUID: nbaqQdHgpq2CPM5T3O4GBQzva4Awrpjv
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Now that xfs_attr_rmtval_remove is gone, rename __xfs_attr_rmtval_remove
to xfs_attr_rmtval_remove

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c        | 6 +++---
 fs/xfs/libxfs/xfs_attr_remote.c | 2 +-
 fs/xfs/libxfs/xfs_attr_remote.h | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index cb6eac1..8d51607 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -502,7 +502,7 @@ xfs_attr_set_iter(
 		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
 		dac->dela_state = XFS_DAS_RM_LBLK;
 		if (args->rmtblkno) {
-			error = __xfs_attr_rmtval_remove(dac);
+			error = xfs_attr_rmtval_remove(dac);
 			if (error == -EAGAIN)
 				trace_xfs_attr_set_iter_return(
 					dac->dela_state, args->dp);
@@ -615,7 +615,7 @@ xfs_attr_set_iter(
 		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
 		dac->dela_state = XFS_DAS_RM_NBLK;
 		if (args->rmtblkno) {
-			error = __xfs_attr_rmtval_remove(dac);
+			error = xfs_attr_rmtval_remove(dac);
 			if (error == -EAGAIN)
 				trace_xfs_attr_set_iter_return(
 					dac->dela_state, args->dp);
@@ -1447,7 +1447,7 @@ xfs_attr_remove_iter(
 			 * May return -EAGAIN. Roll and repeat until all remote
 			 * blocks are removed.
 			 */
-			error = __xfs_attr_rmtval_remove(dac);
+			error = xfs_attr_rmtval_remove(dac);
 			if (error == -EAGAIN) {
 				trace_xfs_attr_remove_iter_return(
 						dac->dela_state, args->dp);
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 70f880d..1669043 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -672,7 +672,7 @@ xfs_attr_rmtval_invalidate(
  * routine until it returns something other than -EAGAIN.
  */
 int
-__xfs_attr_rmtval_remove(
+xfs_attr_rmtval_remove(
 	struct xfs_delattr_context	*dac)
 {
 	struct xfs_da_args		*args = dac->da_args;
diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
index 61b85b9..d72eff3 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.h
+++ b/fs/xfs/libxfs/xfs_attr_remote.h
@@ -12,7 +12,7 @@ int xfs_attr_rmtval_get(struct xfs_da_args *args);
 int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
 		xfs_buf_flags_t incore_flags);
 int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
-int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
+int xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
 int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
 int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
 int xfs_attr_rmtval_set_blk(struct xfs_delattr_context *dac);
-- 
2.7.4

