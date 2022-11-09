Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABDDCC433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Nov 2022 22:21:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbiKIWVk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Nov 2022 17:21:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiKIWVk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Nov 2022 17:21:40 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F8E1260B
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 14:21:39 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A9MJaQ4003220;
        Wed, 9 Nov 2022 22:21:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=UsIMlltZ4jhulaB/9IGU2pslkYeO6SMGSYbSD0i/GnI=;
 b=LBrSJat2FObG+lX5lFJ2QuaYGjStFebKZhoXSRwu/XcuFYZJxjXqAeAi+wlXratH8KFJ
 KQyt1ie9T6nvBP7QCZtRPE6vBzXLEe673F+Po/rICRKzGPpYBp+vVSh9ekiUwH2ycmAe
 LXpSpSxtr+KrrxsHoGeLtNC2DPINDnf9VB1kePIF+BOUEbfqHCb2OrJCxh29MFWSK8Q8
 FDph/Et2iCqE0FBN/CyTmHHuGwuAlW/6zM5o/cnQ7cUYQnWV+AuotbqvZ14ArutdYERO
 QGEDPWMV/QLBgxsCm54YqdWmR9Uc/uslAgIEPbqV7cgsPdO509TZct2S4fOVnSFkBCpO +g== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3krmqqr199-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Nov 2022 22:21:15 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A9LIHBW004326;
        Wed, 9 Nov 2022 22:20:09 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcq428ns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Nov 2022 22:20:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V1Wou3FdlkqnLzVPJkBtTt+gQCmK9c9OZ9GhxHVf++MOMKsOWOiS4R3qbahrqVFhrez0g2QSx17KcQHvEsSNM1cvmgT3SPosHI2H2tSJFWbymQQKzze1Y6ZLtjvz/pgbExizLYAjtsIy3DsccoPHzMLS01G4qoe7g9bqz1CooUFuF0EE3NcnxX8JuqeekhYfohAs/ILtxpwUe5BBg5w0N6XiP6A7t40z/A/7CvZmydvtnZCYFkSwiVRjRcjRWZqoyK/k4yo+nxgPyhF7ILfzQX2B3qFpc4eD4FMPWEbXMGDcsAg92gEnefEJ7u1df0l8N0nOegZ+HdTok7mw+blU7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UsIMlltZ4jhulaB/9IGU2pslkYeO6SMGSYbSD0i/GnI=;
 b=b4f/rJ6f2qSJu2tNFuak64uj4AtEwwrD1nJOPoPjRBPYYfKxXbwKVg52NlfCvO4iCGVfpswvsSeKjDhqvy3gflXsVdouvvyZVSJWy4E5emIEbh8Z0hEKVXyR8rvx9HKO+WxMa0PmeNkOYl4uLJFaCPUM1eAi6HhmLhzMP3l38j5plLERlsG+EZhCc1yixtTojMdIAaMPLCptH7i50lbFMjxIJMuyQ286ESkxH3vtWDkDVX9zL8x0jDWiqqtJvXPfOlDqEMARGEd3ehr6Zqc7e8m1OW69nQKWQvha0624J4nIp7C24Ndo8EfjI2B2ATLaIeQVBQFkdbdGzW1FRR8Fqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UsIMlltZ4jhulaB/9IGU2pslkYeO6SMGSYbSD0i/GnI=;
 b=L9THhOvYEuFB5ER95KktZDqZiJxHMVE4C7BKPJc9RexE/RP82L602f1woH0dKm1mKEKtqoYgwRYyBaK1xNvwXV3GR9GiS/7ZdGCsy2evB9G5CEaoswZg+7FC4AtJ7lSNP0cQIXcFXMyG38+MwJZ+J/MRMBn9VhYlMa5ku1256Pg=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH8PR10MB6672.namprd10.prod.outlook.com (2603:10b6:510:216::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Wed, 9 Nov
 2022 22:20:07 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::e1d1:c1c7:79d:4137]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::e1d1:c1c7:79d:4137%4]) with mapi id 15.20.5813.012; Wed, 9 Nov 2022
 22:20:07 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     tytso@mit.edu
Subject: [PATCH v1 1/2] fs: hoist get/set UUID ioctls
Date:   Wed,  9 Nov 2022 14:19:58 -0800
Message-Id: <20221109221959.84748-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20221109221959.84748-1-catherine.hoang@oracle.com>
References: <20221109221959.84748-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0102.namprd05.prod.outlook.com
 (2603:10b6:a03:334::17) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH8PR10MB6672:EE_
X-MS-Office365-Filtering-Correlation-Id: a9f56bec-c7a0-40e7-f117-08dac2a08e90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /XrMTHsSHQtCuuaFAFxQ/krbaHyPAZ3/qFDv1OaYn+GCW6Ug5KM3ON2DzlAfsA3bUtlZb6YA6TgUgfa12omsn3//gydDaTqmuUd3+FsqoNK5qmv/oVIA2ZWOgXpqXuJWKf5btaC8P+Ri6E09LgIePZBJHgzhVCjae2fyFcAA5BT4OLobIDe78UztVAb8AjeT2CjiUblBvRNlsR3iXzR9r3eIvfDBWz3x553dZmmypQA3WcfOU9iDPtkwxGiVg9C9Y0OJP1mB9SHrHykojDWRIQUaaP/AJxvKij08xg28X4oPBf1An6y5+xlg4LZSKOjQu48Z5vEka9gMZYrG2Di67+l3g19FpB5Q4OkiaJoK141LFp5lVZwPnDfG8WOn6cG6EaSnpJ9fjVkul9+yrU1HBp6+RfAmLM370XBDWYPVg79YqviyfqgCpfNpm4fhp5JDrXD3G5mrFW9IOxFkzyYE11gRvIZ82/WF4mPl/3FrCfdn7Wk8CV8bQZO0OFOJ6w7VUfLKi+DqUj2GMzJpi3MoF4Et1KQzRRJ5qWni/Ji23GIeahCW360FQTz6ju0IprHvsXIhIy36sGnQ+RSOz89Y16zbQyu8A1UaQb7ivrx1ctYNoPJGtrcdNv25NUATFJWc0Sc8LadvVySet8d5ByCwTfBNw9C2+kmdr/0v5z9Mn0qxZG8/itNPDLAZewHlP7EpQ3TTzcpTaBN7kVfzR5rpHA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(376002)(136003)(346002)(366004)(451199015)(36756003)(66476007)(38100700002)(4326008)(66556008)(41300700001)(86362001)(8676002)(83380400001)(6916009)(186003)(2616005)(6666004)(6486002)(478600001)(316002)(8936002)(2906002)(44832011)(1076003)(66946007)(6512007)(6506007)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3TGHViPb7JM4R93lOUD8FIpY1veBvPbFu0S2aq6sP+p8Kehd9ldRwzxslzUM?=
 =?us-ascii?Q?zeFO8qC0QkIRhIf6mhLrMRj71UOWJ85FS8/dyJ8aeRmZzR2HYmZKe15OXuAy?=
 =?us-ascii?Q?9nBoWn5XwawibNvjOlKIqMCg1XAeSwohZBcC85p8E9IUUQvKGgtZq8z/pvrW?=
 =?us-ascii?Q?vkKYwluofYeTgeliVt7Y4JPIUgllGcktRn1ZBQbtlfzIKzpJ/1cfCQ1FYmYy?=
 =?us-ascii?Q?XoID0YqslfIG+fpBH4A8QXEi0YuluuNMZ0ST/ZGr14+DZZf9pWlOnzkGBcTi?=
 =?us-ascii?Q?LUIdEjCwMdkOLc9nCA2wwuZ9hRLvDsHnRkxXI3UBKcLy03MFDo9rBS7UV6Oa?=
 =?us-ascii?Q?mev1ZZyLTOhLrZAP9+H32BWWi/5lcmLWwidMT5NDQq/L3od77VgIiHFXRaOy?=
 =?us-ascii?Q?CR2Lk3NHoB0qbG4ebjVQaTYO7+Wjom1hJs6+gjX+dHua0SJemaiFrt0VX+wi?=
 =?us-ascii?Q?UQyzMP6Qw2TqXW6vG+T8MKUfmqBRfn4qHHs6fOCFRqWYrSnIGw9QDfBc/SjR?=
 =?us-ascii?Q?q9HKWzUrWsUwWwixlzaRiNwB8sqzTRJmk2t1hh2sjwfy0+8jc8Dz+C0QoUB9?=
 =?us-ascii?Q?Gdttr7LGUwDkh4g4NbUms2N1cuyTTqWyDG8FP0eTbNfyIS+Ss/rX21+Wro1h?=
 =?us-ascii?Q?ICQ9ye8XsRCrNR9hHm+CdXHRFV49q6I2bitWWdqg2F2vDFFu/6NYm4rqoogH?=
 =?us-ascii?Q?f08+bg+vDWMC1RRYK8CrnaHkJ6mnYljG8DwOIAeANK6uBtpfJU0Pbq2lJe6P?=
 =?us-ascii?Q?bB/usMP8sURrKt8LzYrrIZTiZHbKjV/QiM24ESERieyCbIt5Dy1kmP2PU5O3?=
 =?us-ascii?Q?HLhs/42Q2hkFxBDQ6JrfsnYWScHF4CVBv+TfFP26hu/XUZYooQbmE1gz5mwn?=
 =?us-ascii?Q?D+Pq5C/OlyeLp12NUw3dqkYmlxHsTP+NrF8YX7aFoKW9Tc/ut6n0pvC4iZPa?=
 =?us-ascii?Q?vfID2T6gF2WMbJAcxnQm/XOEqj0+8VbcG0O9h4gYumsV/9TTb4BBk6KQMxjE?=
 =?us-ascii?Q?++f/42cY58dyx8cX0Kc5Crp4bEtRp/KHx64OFbQ56MzavUlOcnF6mETeIF68?=
 =?us-ascii?Q?kalnzx/onWxy8rQsc3+y0T22aqbLxePJBZz/SHodjYu9mBTFX8lm9yqdlwh9?=
 =?us-ascii?Q?QKRIJJf/M4MylMEdl5BhaOJAjquKbIJVePWM1nphkElZgLXS3MZYbjJynkLw?=
 =?us-ascii?Q?AV12jI5I3VIPNoHHxzxD5UUSS2mQNNhjhYwk7sinwmY+B9KpD5siCFY40Uy1?=
 =?us-ascii?Q?1as8hg+fFn8ej2LFEtQepRQtgIKSILKmchFOAc961lVgLszTvJEHyoKZzhEv?=
 =?us-ascii?Q?Xv85gJZBwJgLXyGvcPTNgcsRZKZ2WxYt9xWdbGXGF6Juaaqw2PvrkDaYS5I4?=
 =?us-ascii?Q?cVVqgo0ppJgOUlRvR/IGkRJ17HvyxOxAeMHrWq384E53+YbJsJFr2KZo0a5h?=
 =?us-ascii?Q?1MIkgvSE14vVIxLQe/+rwYazAj51j3/fVOmEmI7DLZ/wHlGOfys4vpmaizX2?=
 =?us-ascii?Q?IQaj64ADemnjXwMmqFhBEmWAicHPv0S1gIPm9wm8Wehi/aA7JMnU7rfaDHiV?=
 =?us-ascii?Q?ObLGFCW0U8GYmqsnSdq7oYw8SBYCiGiAt4y+tNz87Pk9pINWWTBMC2qI8nb6?=
 =?us-ascii?Q?VtzTjnRK95Og/wxyF1ZdHm+eMqVJpbN3ZvgYLcA+nJk9tB7QQCOZq8r0N3PC?=
 =?us-ascii?Q?kmb/rA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9f56bec-c7a0-40e7-f117-08dac2a08e90
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2022 22:20:07.0473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iTcFJwtQR1yZOuCjVz3hWeaDwWoZyZWFfyaR0SEm/8YJb7psEDGGK6kkyR77AxRYAO6rBegT0zopS5Qq8dzmuI1oac42DDQd02Yd5+Bd050=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6672
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-09_06,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211090168
X-Proofpoint-GUID: hDtf5drDIsvXqpPlI0FwhK5_4BxjVu6D
X-Proofpoint-ORIG-GUID: hDtf5drDIsvXqpPlI0FwhK5_4BxjVu6D
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hoist the EXT4_IOC_[GS]ETFSUUID ioctls so that they can be used by all
filesystems. This allows us to have a common interface for tools such as
coreutils.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/ext4/ext4.h          | 13 ++-----------
 include/uapi/linux/fs.h | 11 +++++++++++
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 8d5453852f98..b200302a3732 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -722,8 +722,8 @@ enum {
 #define EXT4_IOC_GETSTATE		_IOW('f', 41, __u32)
 #define EXT4_IOC_GET_ES_CACHE		_IOWR('f', 42, struct fiemap)
 #define EXT4_IOC_CHECKPOINT		_IOW('f', 43, __u32)
-#define EXT4_IOC_GETFSUUID		_IOR('f', 44, struct fsuuid)
-#define EXT4_IOC_SETFSUUID		_IOW('f', 44, struct fsuuid)
+#define EXT4_IOC_GETFSUUID		FS_IOC_GETFSUUID
+#define EXT4_IOC_SETFSUUID		FS_IOC_SETFSUUID
 
 #define EXT4_IOC_SHUTDOWN _IOR ('X', 125, __u32)
 
@@ -753,15 +753,6 @@ enum {
 						EXT4_IOC_CHECKPOINT_FLAG_ZEROOUT | \
 						EXT4_IOC_CHECKPOINT_FLAG_DRY_RUN)
 
-/*
- * Structure for EXT4_IOC_GETFSUUID/EXT4_IOC_SETFSUUID
- */
-struct fsuuid {
-	__u32       fsu_len;
-	__u32       fsu_flags;
-	__u8        fsu_uuid[];
-};
-
 #if defined(__KERNEL__) && defined(CONFIG_COMPAT)
 /*
  * ioctl commands in 32 bit emulation
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index b7b56871029c..63b925444592 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -121,6 +121,15 @@ struct fsxattr {
 	unsigned char	fsx_pad[8];
 };
 
+/*
+ * Structure for FS_IOC_GETFSUUID/FS_IOC_SETFSUUID
+ */
+struct fsuuid {
+	__u32       fsu_len;
+	__u32       fsu_flags;
+	__u8        fsu_uuid[];
+};
+
 /*
  * Flags for the fsx_xflags field
  */
@@ -215,6 +224,8 @@ struct fsxattr {
 #define FS_IOC_FSSETXATTR		_IOW('X', 32, struct fsxattr)
 #define FS_IOC_GETFSLABEL		_IOR(0x94, 49, char[FSLABEL_MAX])
 #define FS_IOC_SETFSLABEL		_IOW(0x94, 50, char[FSLABEL_MAX])
+#define FS_IOC_GETFSUUID		_IOR('f', 44, struct fsuuid)
+#define FS_IOC_SETFSUUID		_IOW('f', 44, struct fsuuid)
 
 /*
  * Inode flags (FS_IOC_GETFLAGS / FS_IOC_SETFLAGS)
-- 
2.25.1

