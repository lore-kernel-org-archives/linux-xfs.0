Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE119ECAAD5
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Sep 2022 13:28:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiILN2V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Sep 2022 09:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiILN2T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Sep 2022 09:28:19 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B97530544
        for <linux-xfs@vger.kernel.org>; Mon, 12 Sep 2022 06:28:18 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CDED4h020718;
        Mon, 12 Sep 2022 13:28:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=GpVza2hBdOKubBuOwGjAoM68w46/dvddR7dUUyzuI24=;
 b=g1nNEltZypyzmVSFebSKtwpQwVWKmpSwpkEzucgT3G3zuc2z2g2diShljgQi8iJZYh9v
 NLglVSX+16mJe/K07b83LLRmESZx+iq1kSAxaSjNA71jPXGaB90Vuk8YPzTTSnLaHOm5
 BmZXPVsjweyUyZOB2vk9WEZ5JTVUEGOgVcLqVV8Cv8HtPLbUsntje7pz/YpW+RJpVYwE
 n6ripmU5dwTk9mXtzYa50jzOYwxQIa754W87tk0u4NMEHJe12VM8xYFSKiB+JhYJipND
 XG603y0NsCdQIx6Jk7ZfSR1b5w1w8+Q3byMyDVj7Vh7rkAHBF7oSIkrTLWec39t0u8s0 0w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jgj6skf73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 13:28:14 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28CCEhCp020484;
        Mon, 12 Sep 2022 13:28:14 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jgj5b1451-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 13:28:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VE/zB2Gww32BdOzsPAUN1a9/Li0gqEWo1OA4U0+TWbW6kv0z6zzDXtHBXutfgwrIb6LzfCyP2F9QaOEYrfka+inF56ubNOy48jZ8pu8T/QCWbTAOLA+j/rU4ynQna+kzqXmBj1rA3isgpxcgI8wC6vGqpv269MQfJtEBuCbU/uktkyDvr9PaykcWYqLTPUo25R/DLpP67BzJxDNqwAP4uWuvsjiqhVyr7/CHRqNAxLXwnJJaBXh1XZSk7ZeOs5vca6ViMlQIAkNyK+P/BgAldXk1IODU9zWbj+IK124jPANDJvwcCx2d/tWzAAkAMxpCxfppOfPi6a6U0/im2b/DYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GpVza2hBdOKubBuOwGjAoM68w46/dvddR7dUUyzuI24=;
 b=GMbpSQxETyN3lDK0NZqeLaWNCu2gjU7t27bWRZuWsCGrqDLbJQyEMLdd0B3OSRtZGrTB18jAeL+rpeMEBAm5u+xhEpe9RqvvswxVDGse7LslaHvauj365iDcPYR/jrhtWjra+HQBc4ZEu77cwTTeqnY1YPsh3DwC1V0TUcnvn2bP/e6+WhPxX61b05D8iWApENn9qCDB7K69KY/OCZ+8tJ7mEQv1v8cgJvPLEmqdZ7SES4+1HJ0BoOrJW6JQhthRBw1Jx5barVBNTCrjrWWp1U2TG8tot3OgJhmhQ2pXPlZ4uCM7Ih9XSte71kcvj23ZjTfnFB4AOMokbd/Y5hmsMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GpVza2hBdOKubBuOwGjAoM68w46/dvddR7dUUyzuI24=;
 b=bt+PJUCq1tt1QoSkwfvCP++aLWv/AxPhvjplD6scD9fUMP5lulxH0dn/+bc0w+wGCiquvR5ev0lmeoNQw3QF+xO0h105b2ixO1hZsqxgHeAnUmeiryBtXSyGwywbsMoH6C/w0g7LuQroLsmccWLFS2hgngzzFlzLFCdIw6pehn8=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by MN2PR10MB4173.namprd10.prod.outlook.com (2603:10b6:208:1d1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Mon, 12 Sep
 2022 13:28:12 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::709d:1484:641d:92dc]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::709d:1484:641d:92dc%4]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 13:28:12 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 03/18] xfs: include QUOTA, FATAL ASSERT build options in XFS_BUILD_OPTIONS
Date:   Mon, 12 Sep 2022 18:57:27 +0530
Message-Id: <20220912132742.1793276-4-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220912132742.1793276-1-chandan.babu@oracle.com>
References: <20220912132742.1793276-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0012.apcprd02.prod.outlook.com
 (2603:1096:3:17::24) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MN2PR10MB4173:EE_
X-MS-Office365-Filtering-Correlation-Id: 545e1097-bc1d-4222-cd70-08da94c2a3ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OyVucnS/lQLMC6nO4rZ76Fppl5Z/2jHyta3985eGriUVNOzO3F8Dw2ro5gxi0dKlxf9Abo70WiD4vCYoz9vrsueK0qwo7bsxN6CljTJEiN9A41f9mrUYhIrrp2NE7P22lu6v8zQTfF07uX7rG23jqIlXIyQmL2jryEIkOq2N61jy77+bOghTOlbmR1GcWAr11w5lvj7vTPzVq/G1GoIDxq/DZZ5g/QcwTCbIKyvnbjVSsX+fdR6CAj+/DGUQvtMAyEfD2nB7zyXJr+uvZHggLvfkKjfuUOK0o0vNq9w1lY5JSowo+nPi6wsuXkA4VhI4128IDxJokx2pTFFkUH/Ce/B4qgXw/Dty7YOtKTMmZfL0NQjp5rznvSTlblQtvlli9gxrsQ7GVrUbPrt1YESc2xJfTKgTuaahXeCvI+vmt0Zl578f3vloOwvifLvEvMsYXAlRK/Yse5l6Q1BENrfRI9AesFFHSGzQDfMyhlBZTw+0qhl+P+e7jSsHnGZMdfq/IjJiBXTN1ql/jt7f5cEgvmuvMh5DRlwPYdj6hGz9y7YM+Rh2wY6vzUm/5PbziUepm9bAOByCZq7mBdqpG8ffueewYr8SVJfVeYFNepTNPJtpURqpWuYVDNxyeZTSFaXrpKQa5474nsBbAm/0rhOs+sXvIjy2nr/D1oARJptEtXRihPaMvMw5oMuwO7JjbIO+gc8ygKgu42cqojfX1LuILA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(39860400002)(376002)(346002)(136003)(316002)(6916009)(38100700002)(6512007)(15650500001)(2906002)(5660300002)(8936002)(66946007)(66476007)(66556008)(8676002)(4326008)(186003)(6506007)(2616005)(1076003)(478600001)(26005)(83380400001)(41300700001)(6666004)(6486002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hVaLDg75MU+i+rYhlrEAHcy3VlNw6h+pUk4wInvzwLBo95cGX8nJHOJP5pxy?=
 =?us-ascii?Q?QNLSK2/Emj7agxEAs4rKKivrc2E4Lg7xAwekDGRGu6s80UGVjO6Qgv9myiZc?=
 =?us-ascii?Q?3UYU8ttLMNkZIAXe/N7xZImXvRqhlGeBGcSjeB3CIo+r5eNukdJq8RyBv3qe?=
 =?us-ascii?Q?jQv9hWjLFCFJ6elr3m6L1ab9o+mClHsjNIgShXV2DwiaOaPZQBMdiVET29sL?=
 =?us-ascii?Q?AJndFaWhnQnCvgxmLKI1mphHSsnN/in1NRyFIFy3dLmNAReAR49kxaQvxXyf?=
 =?us-ascii?Q?62SPyN254A4YJWHNJt52FYJQG5OcYM5EUtp8IahLHhkb5oIqvsGclmQ9Gqgs?=
 =?us-ascii?Q?EqWwZmyZNWajgzLzKpos/F+ei2Nqr9wkl1E6QZxPxN60sKsEo6UmnPBtfgDb?=
 =?us-ascii?Q?JHqxInWdHgusfFraKUlIAnn7iSMS+lUPIxLnfJLo7mKZV7fnAcg520GcwRI2?=
 =?us-ascii?Q?kOYKIFgeIJ5nQehNSc5JPr4f+jWjrNXDf0bvtqUkTtvpzDqc5O5l8o63wv3U?=
 =?us-ascii?Q?r4iA2x4IgWmiQh72i9rWQNy3IxWTJ62rSrutlo5ZuVz5HDu657TXCjtBt6nk?=
 =?us-ascii?Q?yT8PxPJ/ku5PtbJSULzbLsCcOYMVJxDAIA/5yD1+kwfC9AJv1+BUGtb64K2X?=
 =?us-ascii?Q?82G2tnhM+VGixDm72ClZgGly3udl69GtsCOt3YjOkf5pNvHjnEPd+Gdk9fqX?=
 =?us-ascii?Q?9wi1pPcPdNkPSTf3JEPRdvAvTIa3bK/NCmh2sAHoRcWZ9E/EIsXDVLITziZr?=
 =?us-ascii?Q?0HXtZzWph7sDLgIUHu8nI/FrJ72HwjFeSPH6l/qJGCHzMZw47K/sZbiniA2R?=
 =?us-ascii?Q?vngyiac3qL1VJV8zkhCaLev/81br4RFsnz8NWOkn47IG2/+4+cOFppqWJwHw?=
 =?us-ascii?Q?eCp9aLRwoTnJKAnN+aYomXfnAkHUWtVKj/84nUptJpTBvwlClWsM9mCzvLhl?=
 =?us-ascii?Q?Kp4DPVFOysAq6JygC5KdqlrMTgqo04QIMT2DpIaRAu8+9WvUAGaFu+rYnxnr?=
 =?us-ascii?Q?il4yGWMb5KgLgp3BKpqYdBGWCLnEypOcPODIMvDNHLRI04eHtr7wJx5oNuv3?=
 =?us-ascii?Q?UEM5kdik+utqEh4A/AHHN+q08qhyQJ6kvNc2G1U0SYLwEQZDLpp9Z4hal16X?=
 =?us-ascii?Q?gi/RQyn+6Xo4PF16g9oj+qnxXqnUr4DtPVKfWAJBnTB1BaV4FChoq//CkSx7?=
 =?us-ascii?Q?rr6/07jPEM2vGrGjFbVQl60jY/T9HSr5U3NCYFvsSPKTtzzFwL8sXSJfcWYx?=
 =?us-ascii?Q?dQHnSmXcQOSOozKADE4J5nRfgAfHgzulk7+lm8t8K/rruDRoDWV+7rVo2QPk?=
 =?us-ascii?Q?pBQZSaOnM97FVCRCQ8n55FFQQ/rOtrfb9v+xG7KYrwFWm79ZXcMDS3fQAcsi?=
 =?us-ascii?Q?H+rcfQ1nujZFm+mPY0m1EVorpbF0uVp3Rrzb4tYjlneLmVcI+CtpLetyuvmO?=
 =?us-ascii?Q?wqgK0eEZITF+h6pR+3Yk2Szx3E1sVCBplTsbD6alUKs5nT3onPziGShoOz2m?=
 =?us-ascii?Q?aBuqHjwArdk0ko06r23/Gby3E6LEHy5Ck4yW725UzwaqUSJSiYwi4k8DpBgU?=
 =?us-ascii?Q?QJ2jpIz1uu2kNP5QU8IOTyWGhos9WZ5GZJ8xtMVVwS02dUyGnqnSiyX4MC0d?=
 =?us-ascii?Q?Rg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 545e1097-bc1d-4222-cd70-08da94c2a3ca
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 13:28:12.1675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aDwilWppwyFNZvPFIWsBYTb08AlqSHNZ/DG+lVpPa1OuN4tFH41W1TJtYTBa8R2eFmhcE51oijZhvPVDUfJPCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4173
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_09,2022-09-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209120045
X-Proofpoint-GUID: jb5l2wrDQoLZwv7EJ0ffE6zaCopFzL4G
X-Proofpoint-ORIG-GUID: jb5l2wrDQoLZwv7EJ0ffE6zaCopFzL4G
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: yu kuai <yukuai3@huawei.com>

commit e5e634041bc184fe8975e0a32f96985a04ace09f upstream.

In commit d03a2f1b9fa8 ("xfs: include WARN, REPAIR build options in
XFS_BUILD_OPTIONS"), Eric pointed out that the XFS_BUILD_OPTIONS string,
shown at module init time and in modinfo output, does not currently
include all available build options. So, he added in CONFIG_XFS_WARN and
CONFIG_XFS_REPAIR. However, this is not enough, add in CONFIG_XFS_QUOTA
and CONFIG_XFS_ASSERT_FATAL.

Signed-off-by: yu kuai <yukuai3@huawei.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_super.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
index 763e43d22dee..b552cf6d3379 100644
--- a/fs/xfs/xfs_super.h
+++ b/fs/xfs/xfs_super.h
@@ -11,9 +11,11 @@
 #ifdef CONFIG_XFS_QUOTA
 extern int xfs_qm_init(void);
 extern void xfs_qm_exit(void);
+# define XFS_QUOTA_STRING	"quota, "
 #else
 # define xfs_qm_init()	(0)
 # define xfs_qm_exit()	do { } while (0)
+# define XFS_QUOTA_STRING
 #endif
 
 #ifdef CONFIG_XFS_POSIX_ACL
@@ -50,6 +52,12 @@ extern void xfs_qm_exit(void);
 # define XFS_WARN_STRING
 #endif
 
+#ifdef CONFIG_XFS_ASSERT_FATAL
+# define XFS_ASSERT_FATAL_STRING	"fatal assert, "
+#else
+# define XFS_ASSERT_FATAL_STRING
+#endif
+
 #ifdef DEBUG
 # define XFS_DBG_STRING		"debug"
 #else
@@ -63,6 +71,8 @@ extern void xfs_qm_exit(void);
 				XFS_SCRUB_STRING \
 				XFS_REPAIR_STRING \
 				XFS_WARN_STRING \
+				XFS_QUOTA_STRING \
+				XFS_ASSERT_FATAL_STRING \
 				XFS_DBG_STRING /* DBG must be last */
 
 struct xfs_inode;
-- 
2.35.1

