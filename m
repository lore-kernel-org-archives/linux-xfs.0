Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93238C636D4
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 08:02:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbjBIICo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 03:02:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbjBIICn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 03:02:43 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A87AE265AC
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 00:02:41 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3197Pm37024495
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=QnZjoGgIcEUP40CqmQBJYUuAmBfobRJOlbitbtUwDrQ=;
 b=MtL+sgDSiaRgXMVWLe1vR0oSY9yeIBJITrBb1F0FN0zB6JBJ/878FlYMshiOzZA8gk5y
 6jrovqIqdTorYBGijeNiP6fS4HKiIXJBwIkHNv2t7eoTwxR1R7vf1fi2tjvllyzvid7s
 sqCTgq0Z+79018pZOTeZJjUmT3SWylubch8DCBxL4qYFMe2nFtAItnWzX9ltsEBqu30P
 BqT9hB1EbKe0NqVzkkiqod5G1E5d/pDjiYRUxxDEgUVRuTRw0e0gXYoNzyptT9lv984h
 ebYHsh3PgGLKTYVjWiXyEJLlil/Hz0G4EbZlSZqYR/I9byzM6i+whw4zRCVf2qvOzPZs FA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhfwua2n0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:41 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3196fNet005776
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:40 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdt8wr6y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AbMPCIEeZVS+oB0DiXcl/RMgUAHheqs7TZlHtg/mMdzSQJ9ywbyY0QgId7mwts/BZCV7XPOwQZeN6mAagxb4XXlyu7EdQgd+k1JYnnsUreHf3X3tWSypO/XvB8+WeplvSHnDvjV+DfO1KluVen/6ahF0aRWLGg0NaCg6BPSO4178EUYgbJd2lu85w0fol7zeR2Cl2WkzWmeH+EZUWp+R7Tn3hCnkfRLjwRUyzZexriTfrx1xOTyQihAMnBE0j2TROVvQnBBIJA8LP2mHyKJv30fX3qm3MYiPHOhnZaL72NYLyPLYqvr3n2I38HS4VWhjE8C9Dz43VlLMv829XglLzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QnZjoGgIcEUP40CqmQBJYUuAmBfobRJOlbitbtUwDrQ=;
 b=nFIsNsRAbRLO9BG+4q6sJdHcB3fbszCbsv/CiY76zgcwOFA56DATK4m4liqWE9m/mtyrRrJB+UmNx1qRXLmWJ8Ewwjnd1zzXwSnXaYUZ0YroZB3gGEygUTlZh8TyNyM4xDUfP0yBXsxnxEHoWUs9XzY1fZOwBzCVRZvbWwQLr4xe0DubMC1neQMi5wlr35IA56BfTb/BtiELgz/cJq1TDPWxcxsvzhYgmSr4Mv5EGztFnlBMHMlDjx3+sfgOh98cXHPaAZ3Zv7OZMo0+khYZVJkfCBav+uMWrZQnbkltrXoONyVeUBuQpLTURCKKcNBAZyJoIJ2MRdIUVCUFC8N8HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QnZjoGgIcEUP40CqmQBJYUuAmBfobRJOlbitbtUwDrQ=;
 b=toQDVBWWOEVHTt6oEvBdmozpSbg6Ft6UGGSnMdhC+L/WBeTKaWDiW1mJdrnJc9sRb8DsYUzQKyxx12G1DnYdpGm/Pm36v4T1ePYWmqPWxd9LCRt9KY6t+UM3eXDFPHRMkVD7uhZBNxgFbdjqGqrFUre7lZK81cwS8Ud1ijbj5Zk=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BN0PR10MB5095.namprd10.prod.outlook.com (2603:10b6:408:123::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Thu, 9 Feb
 2023 08:02:38 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6086.011; Thu, 9 Feb 2023
 08:02:38 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 27/28] xfs: drop compatibility minimum log size computations for reflink
Date:   Thu,  9 Feb 2023 01:01:45 -0700
Message-Id: <20230209080146.378973-28-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209080146.378973-1-allison.henderson@oracle.com>
References: <20230209080146.378973-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0158.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::13) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|BN0PR10MB5095:EE_
X-MS-Office365-Filtering-Correlation-Id: d7aae42a-f3fd-4fb3-d4af-08db0a7402de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H8g3+yk9z173xZdQsCKkcGhHJcusJGw48sseH8VjmV+Kwm8zf0iCCXAmgjdrw75fShpxeNzI7OU/NqtPRnvZxIjebdbNXTtgcg2R93Ud+Yv0xNd+9BBoGZck3/qi98QQP8L7wBfiSzMuCwO9ZkA262gl3Yh7rpSq0KL17DEeZi0XIJOoSpT7xwgelXoQK55nyfbtpfFKyUoe+UWY/DOnp06IvV+OC3uf8E5tTcpxy/IBkJARgCxa3EGHCIokz5w8t2Qhno3RW9m5nanE4Hr+rGajwWye8kQAAs7VNMCY4G9j7IYmlfT/LNWc0ppW0bIrKZdJ6a5bxd4Bg2WGO4skPopGd/bhyGh3VE48D9xUGeZla3/zGWAZdcY93NSOnuFX43UWIY3BEpT931890H3uGT5Gb/anJoatmF9fqT6Elir1kAIQzU6KxwVcTyduXLZAeHY1Ffb0+rpAK9jN5C7wyWIvtz22om8ZG1T66orlSmgCItYrQuJjzRhGU/rUDjprqNOmhgxhosVD7hEAt0KjEzZzCAHUaqAC3JaFeROWI8Mu0DTMFrrLLRcgk97BNuAkg1Rz9dpWcIPIdGx9CvTOxfLzLCfRAnQdQeIMwq1NCV1cvFbM7HceKLgDY0B0iHfFF4EnYBBV7GXJVcoGecUIGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(366004)(136003)(376002)(39860400002)(451199018)(1076003)(6506007)(6512007)(26005)(186003)(6666004)(38100700002)(9686003)(2616005)(2906002)(6486002)(83380400001)(316002)(41300700001)(478600001)(8936002)(6916009)(8676002)(66476007)(66556008)(86362001)(66946007)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BzisVKAZKFIdj34OD+BvoG1xT8J2YESEc5BHZbTaAN14z+Jnk73j+VdjWq8I?=
 =?us-ascii?Q?/l2RNHdMYFnl94cOlXKUta8flPzp8RdeG3Lo1fsZ13pxEGjCwkAZi9LDDXi9?=
 =?us-ascii?Q?EqC417jGw2KCZD0DnZEFzqkq5icM/bZf/bEFs8Gc88UzzKLYlACQQlgiyTSb?=
 =?us-ascii?Q?n/dYnRK5/zw5zmF8UdMWzZ3Ukw/1lGsdsQXaY/9GJP+LJ+H9J4SWnKJ+NH05?=
 =?us-ascii?Q?yqFAZRyB3dR+4L0Zh+Y7RfFeWZe/fV/CDJwkQ7mXwWEDi/hCGbpGoEjrtAs1?=
 =?us-ascii?Q?Zsqs1GFRy0wf+Nt0SN8GSuetKj5pxXykUzdcaAixSTJfIBv8tl42ibRF2A8y?=
 =?us-ascii?Q?XqXNJmt19XljezZBsICQuIhJlT1mEOf+3ui+YsZEqe0X7zotKcxHGIqEWfMk?=
 =?us-ascii?Q?7qTb7rfsctcIeFF0wNBAuh8wVA+osGQeCxd/kDYcrbr4/WhJ0+6s/f163p1w?=
 =?us-ascii?Q?6RrXbCbsOKS4UgmwdgspNxllS7gn5BqqICBTvwWZsCXT2VBe58Nt5BUVlIiN?=
 =?us-ascii?Q?37lSykbOGScd4UDqwSWiX+2NUr14GVojkaL9uJoJ3KoiQgIBzikzha90ksVJ?=
 =?us-ascii?Q?VVH42GUAvJ871HaSCTZ+caXSodvBpNRgpbhCx+YnO6KjqD5UPBfTRUf4RUVU?=
 =?us-ascii?Q?UCgXqgcL4Re4Km8o+rMDM7UmqDm0+EJtl8dyjZcj+eyZyJbpFLD3cnclxZxX?=
 =?us-ascii?Q?tT5X5fVAK+aRYoaqOUvef30H1QFlo+0DkM/zR1x2jc15nhkzTcuD0ws0Td6P?=
 =?us-ascii?Q?zGHEydwJgTTjzq0keRLRuHpG5E29Dp0bWOrhEyT/Mm5Ii0lqHaIVd1/5MPKa?=
 =?us-ascii?Q?vaMKiqTV9xFTQA5DZ1ukY86ROzpubvI13AkiwDoINSMCGplsUyHu6FpIIjoJ?=
 =?us-ascii?Q?URECTQyFowDGwNSS/gVX+ri5NLh7gqWyssogxjBJda9gRUJi4Lv3ePBuNZRF?=
 =?us-ascii?Q?Zh8obgxYA1HJdZL6DJesHh4zGCcC6Q1EkUT1Gpql5TTl/BWdV9olxPERm0oc?=
 =?us-ascii?Q?DP827O8Jb6CoZ7BfU3g4K6Vngmv6mZTOIOyOdA14eXwnR9m8uaL3wVXnYRIr?=
 =?us-ascii?Q?distcGICl9DGbNc06VBO2/Dx7Aim+94XghKKzSb4A4gZ8lHGSrZQhWCs9bk4?=
 =?us-ascii?Q?4KYxja/bDOUwO30lS1AQwp5JWXfF5nxqiAkTHLN6QeFemJyzr7FAdbLgl5eO?=
 =?us-ascii?Q?fLHYgXIAb2dNd1yK21SHGlvoOzClEG95aDXFui96ek8Dw9xT5slo3nk7ZZIj?=
 =?us-ascii?Q?iZSx/q2fByCeEHhZWdEZYfbIQspJlSBsnZjO8oKtrSKZRBo6pE5nicueYAIG?=
 =?us-ascii?Q?ODD0sZCsss035xm8fPLDFAIr2gZthn+BOM4Thg9Pu+jeNXsaK+3E55XGEslL?=
 =?us-ascii?Q?5WNI2ZzmsMpik4rbztB940Judc/MkxFQHLoQk0Qe6sFjTKFWeSTxoof1z4kF?=
 =?us-ascii?Q?3uPY1fA2ohvokF1fSShBlZCuKIaIUKxArCb5XEyoGqYm7auHfleoiUXb7OX8?=
 =?us-ascii?Q?TGpM2vPOFcsfdm2b+1L7ipRtIm4gvHQr4N+VKB20ZIZUYa8CYJNV1+JdUDmv?=
 =?us-ascii?Q?gmJZqHeGoNitXlUhfkg9XGxAE5aEpzteKJeDwD2fqqjnuVjR7i0XJs/qEjwg?=
 =?us-ascii?Q?1Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: x7TXU+d3Uv6wRQQbh28SMM7TBuL/HgNJDfbkzDV4qbFycVVEGJyGJhg0NIsH4LjCiD7lKXjO3ho7t7/YbsAHXmHnVkqKlFImwYaPY1mllKITFC99uJF/k2rznSkFQmazubbSEbpnd3r/KBaN9fTrVQMtH6K2pKY3KHfM1l4iwEYvTDoxtBDWOEqo1sMumsltiqhefpw1eNYSi36ZBiq/0lvtBz2g9MXExBoNmuaPqr+8MNv/ylTOLcUcJPAOfziK7EBGIKPzvfCU513rULRlzW83MtHYEEIKrnfN1KxQk1qAYY4qx6Sy4HeX2eF6kyjNCFljNVbdz3WKAtpZwnbkv2lzbPYG8Bv6Kh29i7OBqLGUWhb5KlTg5Zl2LTTMHS+rgRPC1T0uwkiCiCHwTUY5S+gLlcUMDK+cS6evKKjtk5AIte/c5+8VKZrnhc7JdzybNImdWYim4/wxQPoolyk7EeAoXECVfdy76qeTXJD6M+/RBJvm8Ruy/qSuhnfFZ+GerTvPw4qCNu123WGKbDMNzLXMQoRA5gYi9058iojy+iiaAk5h3e5EjbaYx9aj9B2Xa7ZPFiTjCJCmLN93Ert1ge8aJ+qVuC3nq3lzyQR/fUYl249GqhJPanwhE3YpXtKMXmm9X0l+ZtThUKKZRe3sYbqKIl2agkBNANQFpqTXY8qnWk9MGBzWhx/G+C2UoHCMLRNJFtORA9TjNE/ng+EpByuHrubv7ayI02l5Jk06QWRaFMJRGLwqolXlwvw2ayry
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7aae42a-f3fd-4fb3-d4af-08db0a7402de
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 08:02:38.5573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TfmGuZO9SzS2NkrwKNgOWxQDZGqgwcydNkWrcVjvi+QwJHiGe3WGUbD/yIZXHShnLIqGRkVv5XFNQ9jA6tla2117KyH2htmK4m2q3nIbKhU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5095
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_05,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302090075
X-Proofpoint-GUID: Vn_ROGFXFA8jnor1h8AFZf27NLwTEvpd
X-Proofpoint-ORIG-GUID: Vn_ROGFXFA8jnor1h8AFZf27NLwTEvpd
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Having established that we can reduce the minimum log size computation
for filesystems with parent pointers or any newer feature, we should
also drop the compat minlogsize code that we added when we reduced the
transaction reservation size for rmap and reflink.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_log_rlimit.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
index e5c606fb7a6a..74821c7fd0cc 100644
--- a/fs/xfs/libxfs/xfs_log_rlimit.c
+++ b/fs/xfs/libxfs/xfs_log_rlimit.c
@@ -91,6 +91,16 @@ xfs_log_calc_trans_resv_for_minlogblocks(
 {
 	unsigned int		rmap_maxlevels = mp->m_rmap_maxlevels;
 
+	/*
+	 * Starting with the parent pointer feature, every new fs feature
+	 * drops the oversized minimum log size computation introduced by the
+	 * original reflink code.
+	 */
+	if (xfs_has_parent_or_newer_feature(mp)) {
+		xfs_trans_resv_calc(mp, resv);
+		return;
+	}
+
 	/*
 	 * In the early days of rmap+reflink, we always set the rmap maxlevels
 	 * to 9 even if the AG was small enough that it would never grow to
-- 
2.25.1

