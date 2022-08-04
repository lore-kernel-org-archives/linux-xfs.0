Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8A81C19F21
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Aug 2022 19:40:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbiHDTkg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Aug 2022 15:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239133AbiHDTka (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Aug 2022 15:40:30 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 116A5F3D
        for <linux-xfs@vger.kernel.org>; Thu,  4 Aug 2022 12:40:29 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 274HbOZb024334
        for <linux-xfs@vger.kernel.org>; Thu, 4 Aug 2022 19:40:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=RfDQaFTJ2peyZtPxJgtawUcik0Pb0vWHQCcSJCeqo7M=;
 b=w3h8RsdnebkYQZOW7coDFTxP4unXTo+agnDXE0GRbrpbnjgEjp++TKv0EGk2PRH76l6j
 vkcOLq7yYdim10dM23YNT1xyWNzx0ebavJ0PX9I36xpFfF4Poie4JDWoNVjkADTTI4Dh
 g/8rK/5sm5PlKimvuOGohOuGMz0JNL0FRZuQpyO7Z0SDcJhzTSANoiaEiw1UAvEnx4Nz
 6rlf5MxnFlfEzuVoJHefvJORzQpYXYeor+4fQGtxz+FsCG/y9ycFV/R3UB/7vG4gxGgd
 BN6WloU/gMX7B8DqJ6BhScCdT7fqjv+qRKygzXaElj0Dh9QIan7ebkoxCi2RAD/ccJRF sQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmv8sdyqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 04 Aug 2022 19:40:28 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 274JO4XB014188
        for <linux-xfs@vger.kernel.org>; Thu, 4 Aug 2022 19:40:27 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu34p7ev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 04 Aug 2022 19:40:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jo2R6usqcH1Uyk1EpMy0Rct829+VgvfLq65PRPGOme4ZKCIv8ZcWj9OVZmLTJXI56C6+OUX1KyZfqLq2MPsrRIB0zfIf5wVX7J/8NZa+i0AkwKkA5Une3RbWTMp1PeZ+KOseLNtdn+asW/EglBw1q8M2dhApR6IxKVTzy1nGvAIXZsMYmZnOKqfM6pXY465Tdd9I0OGqzOEALv0hcr/FzFMcRiuthmu3UYWoIbHGxLlzsWrbeGUIl61KcLmbZuHprzInmWw9+LvzpArsas2pVHE0JNxWubk12CqtwQGLfE2intwFi7i7Am9jZmLl8UdaDZDdpMlXToQ8G9Lh6XX2RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RfDQaFTJ2peyZtPxJgtawUcik0Pb0vWHQCcSJCeqo7M=;
 b=QD8y1tzZA3wI58RQnGExHii/2jGiXIA9aRJAVVuIGEAny5wqw0hM2tEKZHu1ALd/XrRYsdwguuNQxiAQs/zos2JKDO++PGL3zFLiwx5e0a2bwMH5B9XEn2ie0rlobiFHDNEbPYGVOXGjO6KJD4NGOzlMGyjY7Ac/wsYwjTaCPiJ3g4ca3WHGAIz2nAT3F1IxNq/wg9A321CiDNP6xQ7UzDp9EM3HbZzsoeL6/ta+PR+8aiO0S5iql84K/lOKqDpVVR5gDPVsI23B51OW8OLHgcpaGvHT6MMGAz6USloVG1wGeN39LibsnfvIVnLbGS0fEVmbWWxlN55J614E1CFp+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RfDQaFTJ2peyZtPxJgtawUcik0Pb0vWHQCcSJCeqo7M=;
 b=m9PGUAMf7ClEmHq7CUBDK0yElGzvscfWFlEM1MQkvIc/jmPw8vEo464QLCLObdfCckWsc86J+yFNK1XiK0MJjiFCqZSTHSwGzg6JSNKwhsJB05zx5gg9bV2upixNQXIB4cqFgI1oM6azlpiIOl0UJGz9UO5VVzH5RjcpN9Sk+FQ=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS7PR10MB5136.namprd10.prod.outlook.com (2603:10b6:5:38d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Thu, 4 Aug
 2022 19:40:25 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5504.016; Thu, 4 Aug 2022
 19:40:25 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RESEND v2 09/18] xfs: define parent pointer xattr format
Date:   Thu,  4 Aug 2022 12:40:04 -0700
Message-Id: <20220804194013.99237-10-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220804194013.99237-1-allison.henderson@oracle.com>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0198.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::23) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e548e9d3-af01-4743-ca7a-08da76512c84
X-MS-TrafficTypeDiagnostic: DS7PR10MB5136:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 95+FmhUz9kMlvzl9tStKCA2quYha8OgiH05W5askXITslyPKycu6eK3DLKBnJ0G0eUpLxsiQ+4OlhyloYvXaFktx7nuE5+85pX0NjWoojORyXDGhbwN4tCCHBrhBtvD0PsSfWwwjvE8/iOd0lKonnaadMcSXQA9WCqYdecUd9LlNI3oxdHZ6G0cBGyk94B/KKjI7o2ffuCpNf6s1yX2fdigy2NWXf06bdAE6NEFJDSaeMI/nETpDfBkY6FP9ydbzlazpEqrLeD6U1WjHjJEia4GbJ6He7jY9mygSeLsvGsHlhgfZgrUP7BWSn1Ks6QUeGebjdO6zA7EncqtoRV5Vc9GUPBo+SikvVh4GwpGvLs987cHkVGI6qymaQodlvJvRInAkEX8Ic5NyhTtosUziyRRvHU8CQ0Xa8nLgOLmVOoThDoHaOZJ5+vmj+QeX7QeZeLJqqbXb6uFKsWjHNc/UlYuVgNDa7JvDEOzLcASEKmC+vtBUsVQ7Zkq9RmI/O51wBp6fQDGCIhCtCMRd/ZDi7H5CNuL/LJ5CfojrTIizHG9p9li2+gjN/JszlNZFOqQPVTsYKXxg33vVxKvsb0aeg0yIefNxP3df02BVR5prtNGazNA1V5XYRHbKZNXAgp9V+080dcqshc7ywg0wLSEDrfDVrYohdizGaUk/SxhWb+0DP0aSpT3wJ+YCYW7GTmmD/R5FP1VSrQFeMN7OjYB2QL2VP6EanKHYsFvHVXPGPcB1J5iWx2B4or7qSZN1P7PzonhGxKaTXlLpqo9gBQNgUt+IgTgPfkshzooPPnrMXnk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(136003)(39860400002)(366004)(376002)(6486002)(66946007)(66556008)(316002)(8936002)(6916009)(478600001)(38100700002)(44832011)(66476007)(5660300002)(8676002)(36756003)(52116002)(6512007)(1076003)(6506007)(26005)(186003)(2906002)(2616005)(41300700001)(6666004)(83380400001)(38350700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HEZnQl0h8Cu+L0WtTEfnE4jtI4k5Bh5wAGt5TkORi6Es0/Tt+b6BaNo5xUzv?=
 =?us-ascii?Q?aZL3aFCQc6+6Eh1Cj/BHiFYqnbbCdMS7BpNTIbOyN0+mQerMDfjty+xvpMog?=
 =?us-ascii?Q?U0KjKBh8Q8KoauLG6ZkYME/FQWMgDCGIXOFJcC3qP9j+/18Ifb4jiil6KOrc?=
 =?us-ascii?Q?1PXR00UNUkzVcV3GEYX7lkqXbkdNcyPeMB4q7IY0sFSW/n0uol4t6uXgn4IS?=
 =?us-ascii?Q?N2vsGCCeyStKp7K5FF8CeV3otklLv/9vPtBT98+tQrsRrBQnYp2uCbSbaIid?=
 =?us-ascii?Q?UuFz3XXamOH98dxUWLrinf5KOzMQNl+RNUOKNtKfYCTekYQFwBaYodh/3Jk1?=
 =?us-ascii?Q?tzaGEIzJmnNITHOs6zobbrFgY66ABxDpvLe7BZz0PKr9g+u8sb1yXCAN8tD3?=
 =?us-ascii?Q?774s5kQSlycyUG/dLlu1ojS9ZQo59wzu2K6L3kuEgxxuCttSsh0JmBqSm6ph?=
 =?us-ascii?Q?oB2dyb0yHOgbMcRQ9fqfkVIYvEhSRNqSlDrgWGI+iJmuqiYzHBsSyW4mVO2u?=
 =?us-ascii?Q?ZnMVQ7dVv7azKODW4MznKrxx9CoM27+Gdjlx4juBuxb6vU9FiZvcBK/kMAGz?=
 =?us-ascii?Q?i7mPtpMnW6ybpdtxi3IkCEDof6OKSpiHnIjKLZnlD/nfZBUz411ZA727XFNO?=
 =?us-ascii?Q?t/Td3z1qvKuZaa1pTOuKrG9JUNlhOtX/Ci4e9l/qWbrmww7uxc2yBpkxgOxl?=
 =?us-ascii?Q?wxtWPJYmjfvVFj7I4rtmUxXBHiRtSc3hfN5nKVkgr2YpzI4tTTvMqjk4ys4K?=
 =?us-ascii?Q?stPHSvCpl9691CoWun5q6G/5Lfhf5tRJHPg8s4IgXfaf9o2WSVFu0x2p1xqZ?=
 =?us-ascii?Q?HV8hAMTxwvlEFXUOJdf7LMUxc1Ihk0vEDcI6wfvS6Kjr29+wNsb5PFUkvyTJ?=
 =?us-ascii?Q?utQo11pLwzVaChhWskbyBDEIPMQL3Zhbya9idBRQOeyauufYnPLHouahXWRv?=
 =?us-ascii?Q?ucc93fc+gUKRLqfX9PFk7R2HXjFwG0/bR5wMpidPhRhz6fNTqsunNxEDpM6v?=
 =?us-ascii?Q?YInQl5cuLqDJToPuaU3HohnkAuydtasdx8xJMMfPiXKRIldFWfFO2AdNiUqM?=
 =?us-ascii?Q?/Oh0gksJx6O7a2U5c7d75oecHKElKPLZkVHqP2NW8jxKdN11UMNp+GTOHSe/?=
 =?us-ascii?Q?AhVpdHZAPY8cqCXasaJZGWzhFmMrEdNoPBKEtgIJZwu+0F4Vgs3I5XNrKGxS?=
 =?us-ascii?Q?ppwKaPg1XsJIfmoQZMv36Sa3op87v2ebw384kvsOMXjtC5tAPguqCK828BuV?=
 =?us-ascii?Q?Je2fVJCOPFyLfmRCT5E0LsmO/sNK8K314jK8g3HGNJVPcxQI0swcSCouuSJe?=
 =?us-ascii?Q?LejbQCV+GNzChxmR/4rxYJQlPga/x8bd76Z9Q7grKYT5lflOZfyWeXwjBMGY?=
 =?us-ascii?Q?G4pCvBLMEm6cxH73ltmy1yKa5d3RhlOLZyEarVgssDe8WZ2v9sB5kfSl7lXp?=
 =?us-ascii?Q?WaqvZj/BhI0/PHKvYiPFK6yAT4CN8tT7sS51/sKUBUPdqezugUmtAoTunEpn?=
 =?us-ascii?Q?oodFfwggIjtRWttaxcBX1gYc14LDsqJ+43Lmq9z93n+fHlT6zTpuDEoSiF4J?=
 =?us-ascii?Q?q1oRj9AZmUbPxVvGPyi49EY2Lu6eJhARrjA9kpPcD1cJR8ZdSTALh6AbX3j3?=
 =?us-ascii?Q?nQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e548e9d3-af01-4743-ca7a-08da76512c84
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 19:40:24.1736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AQYv8fjwsltZHlV60RjMbk1XjuFIOhcySCcKx0uS7YII9w/hzU+ChbzIArW3+q5Qzjt9zW9e2+faEnKKrBz/HiGjsDBmyNLVqMMZPGd8YYE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5136
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-04_03,2022-08-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208040085
X-Proofpoint-GUID: 8BBbuhIeCBraEDSKOhG7SAOrvvs9Uu21
X-Proofpoint-ORIG-GUID: 8BBbuhIeCBraEDSKOhG7SAOrvvs9Uu21
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We need to define the parent pointer attribute format before we start
adding support for it into all the code that needs to use it. The EA
format we will use encodes the following information:

        name={parent inode #, parent inode generation, dirent offset}
        value={dirent filename}

The inode/gen gives all the information we need to reliably identify the
parent without requiring child->parent lock ordering, and allows
userspace to do pathname component level reconstruction without the
kernel ever needing to verify the parent itself as part of ioctl calls.

By using the dirent offset in the EA name, we have a method of knowing
the exact parent pointer EA we need to modify/remove in rename/unlink
without an unbound EA name search.

By keeping the dirent name in the value, we have enough information to
be able to validate and reconstruct damaged directory trees. While the
diroffset of a filename alone is not unique enough to identify the
child, the {diroffset,filename,child_inode} tuple is sufficient. That
is, if the diroffset gets reused and points to a different filename, we
can detect that from the contents of EA. If a link of the same name is
created, then we can check whether it points at the same inode as the
parent EA we current have.

[achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t,
           changed p_ino to xfs_ino_t and p_namelen to uint8_t,
           moved to xfs_da_format for xfs_dir2_dataptr_t]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_da_format.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 3dc03968bba6..b02b67f1999e 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -805,4 +805,29 @@ static inline unsigned int xfs_dir2_dirblock_bytes(struct xfs_sb *sbp)
 xfs_failaddr_t xfs_da3_blkinfo_verify(struct xfs_buf *bp,
 				      struct xfs_da3_blkinfo *hdr3);
 
+/*
+ * Parent pointer attribute format definition
+ *
+ * EA name encodes the parent inode number, generation and the offset of
+ * the dirent that points to the child inode. The EA value contains the
+ * same name as the dirent in the parent directory.
+ */
+struct xfs_parent_name_rec {
+	__be64  p_ino;
+	__be32  p_gen;
+	__be32  p_diroffset;
+};
+
+/*
+ * incore version of the above, also contains name pointers so callers
+ * can pass/obtain all the parent pointer information in a single structure
+ */
+struct xfs_parent_name_irec {
+	xfs_ino_t		p_ino;
+	uint32_t		p_gen;
+	xfs_dir2_dataptr_t	p_diroffset;
+	const char		*p_name;
+	uint8_t			p_namelen;
+};
+
 #endif /* __XFS_DA_FORMAT_H__ */
-- 
2.25.1

