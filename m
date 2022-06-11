Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF5A7CCA47A
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 11:11:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbiFKLLT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Jun 2022 07:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233016AbiFKLLQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Jun 2022 07:11:16 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E6F11153;
        Sat, 11 Jun 2022 04:11:15 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25B3C29g023987;
        Sat, 11 Jun 2022 11:11:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=Bben4WFcMgmNwBxWJHG+HKAL/4V5NxgijURqkN/s7dg=;
 b=zOOH//gzm0JRCfIxvVuFHSz9FkRZuDAiAX2f0UoVvalCWlyJFW45gwHyPpgiYfjOG7tc
 1p5N9RFh+mJVUxmQ2rvt8x24oWxLG+H3aPZxejgwBKrnHkoAq2wp7xPhUClxBW6HfG86
 OdYH8zQiEVFdViAZhDqaYxQhTyrhQ7m3eBAsz4z7KAs0YLkRWb8V7AX1NAs8H1YGb3Uc
 xQPKhofoiHM7WLhwfqkxy+TtZTtLSMQmQyvggY+1Kv2AKK1ziJ3GTGXoGEhbLZFhW1qr
 rAy8hl9wilR4RSq5Io9QgMsFQTyE+E08WPHh6jylO2IWVD0Gi/5LcQ0MwXIPdA1WujPF OA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmjx98cka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 11 Jun 2022 11:11:11 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25BBAS4R035419;
        Sat, 11 Jun 2022 11:11:11 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gmhg0734s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 11 Jun 2022 11:11:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IM5VQgXufVL5BhMDmSWm59gTlIStRCmhVyl7tXiVy5mDQNfZ6saWNAe4HXii5F6bQH6ndCr1EQrjHLF2Dq/YQT1iBDwgu+LU3XFTYSPeUY1Lb6PRL6MNb+SvBfJjJlLJ3A2uODxAkp66uQMPHVi9790jnNuHGqOePXLQsn3fOkfxOqhk2v22hTYzqRa+kdYr/NZ9/ijiGLe0LFId8pX1ajSxm8igr6GP+LWAl6Mm3bxIqFC3HD4IguVXhZdCP0QGfGc6GPZ4mQ3Vs2vuK2rbw7poSwhSbHIAL63ChwhTigDXBuQLQyZSKq7BSNOIuxrtNWdmGG3yhOS+WvejN9zA+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bben4WFcMgmNwBxWJHG+HKAL/4V5NxgijURqkN/s7dg=;
 b=D4q0jVhliMgyoTtZbJUrOR72ycSr9Tr9ig+oLD5D5SyyhlgyD8MFTg7MCjrb+bU4Z5W7INiBbMvUSlA0sqzofYRsPyzfpi74HM6rZEo/J1DOjcanVOWIVugHO/t9sa24qUHHE1XrbYWWuMAuxkz5Yit/tsjSb6Lo21jdRwbD0KwCSFxMnH9UpQPL2fnQHboxq9q2O7s3Ijg6WwetTXAvBfv5KFBLIB5RPhzYOiMJnTThK/+L5bnneAiB85e+787JUWV11pTxikQ7a7p1knuilYrzWc50ta5I4fd1FaZzFUsTx4oKgxp8fLhs8jtphfq57LkQzxwnkA3lKZx+0ecUXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bben4WFcMgmNwBxWJHG+HKAL/4V5NxgijURqkN/s7dg=;
 b=i1Ek2bwFokP8DHSKGbcWv/BMzDEg5lHPoLUzPm3cnJSSNa1GS9cOYCepByuR9hmSc8M9Zxzavxr3jQXsF4gXjWbn8C9R8haFdW7BJBLyMKWuy1EGW3z8oM4bB6O394pWxSAjpI7GBEo9Um4NWPlWhSPfy01jR/WxDG/l7POqT50=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BN8PR10MB3313.namprd10.prod.outlook.com (2603:10b6:408:c1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.17; Sat, 11 Jun
 2022 11:11:08 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::ec25:bdae:c65c:b24a]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::ec25:bdae:c65c:b24a%7]) with mapi id 15.20.5332.016; Sat, 11 Jun 2022
 11:11:07 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, zlang@kernel.org,
        david@fromorbit.com, djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH V3 2/4] common/xfs: Add helper to check if nrext64 option is supported
Date:   Sat, 11 Jun 2022 16:40:35 +0530
Message-Id: <20220611111037.433134-3-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220611111037.433134-1-chandan.babu@oracle.com>
References: <20220611111037.433134-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYBP286CA0014.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:404:ce::26) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0aea795-9f92-4c81-486b-08da4b9b1554
X-MS-TrafficTypeDiagnostic: BN8PR10MB3313:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB3313AD79D2D5801C40128450F6A99@BN8PR10MB3313.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BOyMMoG2hq3RYUyPYFdBB33UfX6URuu0FhWmKTBrHxUyAjbuhm7ZTVExWdSTLe9QFIiSoGI++adlffpx7XcTfoqJ3H/PbrbDiZ/3Jjkzuq3j2y3jKyl4o2/RoDoif2z+lJsKOC02s8fkzFU37LKU7dSXW1P8T2UUHbVkKFtyj1QSuMOFUg+qb5YRy/sxCCjOngj6YSFQfsorrB1h/3owIDhQN0/e2qb5DG8Yum0yZiJu2EMjSrzKQd/+uLNEf5wwyyqzvnnnai3kyWytwLNP5lNHRV05fbq/MnptGyr618GdcnZg+F4z3twykheRoDMxK80N+692LSFXROko7p+xTsF+OReR43dOOQyvHe2yM2dxJE3vQ9lS/1qKRAjS8NKV55aGo9NhnMndvugZgY4c1j18FEvLL03mt/3QydWrAe0gqnXfxR/OAL48P5b5t953NvPB4ZUuiaWYBnWna8OK8ftGVCLzMbT9jqjsHj1/Wf6mgvJ0iUa6fEs+of97Tli/1nRn/GeT1eGh4vS2Wn9VIMNNy0Om13wprXy815Asffb/JzSTRd2sbDu4qPXSAocfhh+uDBNzY0050hz/bKCHHwartxFojuS3m1mnGEzBfOjvbcmsyqo38mAIGZCpbVkoIBSvDOzey2Xd7IIagXKliFKffz7PicuXDWVctiDf8RuqS7CvKj0OqRdf9Q3X72AMx4/qcz7i5Dt2cN6tu1uugw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(316002)(186003)(2906002)(1076003)(6916009)(2616005)(36756003)(26005)(66556008)(8936002)(4744005)(6666004)(508600001)(8676002)(4326008)(66946007)(66476007)(6512007)(5660300002)(6506007)(52116002)(6486002)(38100700002)(86362001)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VicRZNqLUqfAgEowGW6pm0MMCe9i9pfpZHmd77n54/DRx84QeR99pdh8IC7V?=
 =?us-ascii?Q?QHbnq90HFKD3ygoPIvjq+YBzc0Zu/Y6Uzgoqn7BPbqDF8MtgailT6qo3o9wZ?=
 =?us-ascii?Q?Z+2eTyiBxkjW287nspettXcZAOCGkajIyzoYf2Q0Z7yU1sz8O7soAaNKmfYh?=
 =?us-ascii?Q?oaHUBcnhNZY1VnN/6i/ml2u1G7b+KwLg7T9Q6d5GqWrriwNmHXkdhIe4d4qu?=
 =?us-ascii?Q?rfu+el1Df6DZ1WaBmxY9ME1neroptLByIH2IxjUQnQDaXUwDZ8d3GJvaCe7w?=
 =?us-ascii?Q?og0Y3wsMutNFOHxVc6AXzmTxOVGTDnGLhW+ZM4vLuFaXXwU7zE+VoBoIV+RF?=
 =?us-ascii?Q?D5Eu9Q3kRRWTl6MmiIwjv+6BB4qMbjk+y4GbqGUZiKgDb467ANbnk9DJrZwn?=
 =?us-ascii?Q?pI72XhU8Q6xHxwkc0rJUqXSFmr4bjet5BW1tgCQErAFckgIJuVpsOc+8csJ/?=
 =?us-ascii?Q?CtUDpKuCNVbCCIrL2ZqZLMj/rCSVh6oUDGKswkNwDLHB0rIDV5cAJTsUN1Yx?=
 =?us-ascii?Q?3/vXFvxQC0pavLDrZ7JbHziY7YQ8jITL/A/yp+CpVy6HCZVy+8jMyUeCemnF?=
 =?us-ascii?Q?YhF4dX8BpSGezrFQh+cNkbUqnJSpWEirzkoyqkFrjiOjCQBZylQvfPZo1pYf?=
 =?us-ascii?Q?xkhobM6nAyw6RsBvHN02Q67QVtjL7fj+t8Ld7tZsf6t36zuaPnwZiqtG7YMU?=
 =?us-ascii?Q?jK9XsnfzKoIYreTAjRqGNTJNaP8Q8HtIl20VlarB6stIrnr1fBzToCaIK7EF?=
 =?us-ascii?Q?UKMe3NAoX6BHKco1O7FuX6SAXSxLyS0VX3JDgHRa3URR9hWeDwNpkghKwvZZ?=
 =?us-ascii?Q?sXKs+iZC1afXHLZrQpvxNO5+aibxEDZAzKMViF5xfzne6mYoTbA3ZLFqbU2J?=
 =?us-ascii?Q?F27Zbt5L67EmJ//aLcj+8gtzynZx6bZTis56wJRC2xvch1Ca/5weJf9F4fUT?=
 =?us-ascii?Q?6aclUxQbXp0tXfxTtpTtzNN6X9uaWEL1YmPdlNcd6NsBLdK6NKtTGjlxF9HS?=
 =?us-ascii?Q?0hfkjQWb1NFaXyGb8CO2vaJoo/Z9WX4q8m7ucWnBT4OJf2X5VOdjvLRvsk4U?=
 =?us-ascii?Q?XpYRrXt8OXZrqaiK/JTv+yPlytGkPePN1Ea/FA62JnSad/Z6YccsCZNHeyB5?=
 =?us-ascii?Q?vswxKTdUsJ9ST/HdJkGGGtjbgnWX+2Vds6LLhoDSzMjuplsN+PFkigq/JPhW?=
 =?us-ascii?Q?bzuoJqF4gIjkn5THMP7VPW+kUpaKGJhgQfRNRafw3ekVyqTUZ1khgsK6Q0RL?=
 =?us-ascii?Q?3AenJmdLxPr74PVH+MusQKhlOC+HWKPdBpryVuMho/uP8KSuDLk2dMOvs7y5?=
 =?us-ascii?Q?00oiuX9SGObmLOildhfEB6M3aA5ODYR2tHyInD7zG503ejq0qoOjga/eThEP?=
 =?us-ascii?Q?fxsFM5lTNfnx70HuwaC0ZgClfMqo0G93SQ5dcZ0+5qtYtG3tB3gq0oXNe8B/?=
 =?us-ascii?Q?zRIP5F1YMt2DJGSgSRkSbIickqH0NUxhNx8JEYGcjMTvPtTE+kSWx301ePzd?=
 =?us-ascii?Q?5NezFEnB3r45WZZbSdLsM3WuViRjiExv7Nl9wFiY1paGWxJjl4e7BQfzv5v/?=
 =?us-ascii?Q?DOeLrJRaeKxiphQzuQ2RR8hxpKZhDYkAHo7PTgNQXmYyr8Ncq4eJACWnHwIh?=
 =?us-ascii?Q?AYLod8wtl9Rjj+SimhtqkJHZEDex0YFf4KEvMm0COCP75GRq8yQd1pPTvmdB?=
 =?us-ascii?Q?JiYqOQmgSoquTQwEGPW3KEPsc9ShFvU9VsdkOHY2YtJKSCtM+eqMcD7y+hyA?=
 =?us-ascii?Q?Ja/d3ia016WxtPSbsWN5MWKircQ+g+4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0aea795-9f92-4c81-486b-08da4b9b1554
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2022 11:11:07.8861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wxyXtVOHAnQh6FBE8sDGrx5gkgZImC+q+i1AiSvLaRzcByC4lhaWDjq3NBOLWoWyFWBESWy7OQDIY+46aDOd0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3313
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-11_05:2022-06-09,2022-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206110046
X-Proofpoint-ORIG-GUID: YgS9KdAQsdckHD7ipMMh6VPvAgsJFcWY
X-Proofpoint-GUID: YgS9KdAQsdckHD7ipMMh6VPvAgsJFcWY
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds a new helper to allow tests to check if xfsprogs and xfs
kernel module support nrext64 option.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 common/xfs | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/common/xfs b/common/xfs
index 2123a4ab..9f84dffb 100644
--- a/common/xfs
+++ b/common/xfs
@@ -444,6 +444,18 @@ _require_xfs_sparse_inodes()
 	_scratch_unmount
 }
 
+# this test requires the xfs large extent counter feature
+#
+_require_xfs_nrext64()
+{
+	_scratch_mkfs_xfs_supported -m crc=1 -i nrext64 > /dev/null 2>&1 \
+		|| _notrun "mkfs.xfs does not support nrext64"
+	_scratch_mkfs_xfs -m crc=1 -i nrext64 > /dev/null 2>&1
+	_try_scratch_mount >/dev/null 2>&1 \
+		|| _notrun "kernel does not support nrext64"
+	_scratch_unmount
+}
+
 # check that xfs_db supports a specific command
 _require_xfs_db_command()
 {
-- 
2.35.1

