Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F109CCCA47B
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jun 2022 08:52:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348389AbiFJIwU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jun 2022 04:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348466AbiFJIwN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 04:52:13 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63480203D05;
        Fri, 10 Jun 2022 01:52:12 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25A8IVLW012400;
        Fri, 10 Jun 2022 08:52:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=3oJ0N30Gm/+zMy5wugWbJOuybwI/vbLLyI3HTBEW900=;
 b=qMD5lVCeLu8DfwcZecmvtRYoI6DjKt3R+Gz5AVMiMwEcygcPFbdWEx4ctKXJLrcMfOC/
 SzuPIlweCS8w1ZRXhMUCTTJv8t6La8IPb8j1uEI2pm81iRgEf3smDp/X387zry3Sv/+C
 0iP0xWxVdSxBhsSJsGxwU9qw8dAt2wUdfLnHq46PohaHmM6o7Qylw5R7IvsfvWrasWMn
 6pF3PhNfWpasXXqYVvRDabnYg7ZyjqqL67xUXr+Yanhwb0uHTtAM/FGEEc2kFxOFCsBQ
 hMKeaCTpqtAh7sV2CymWOcv1VhJtZioRN5KDgaT/BngvUHHiKXUOk2If6CENUMdbJfAr hw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ggvxn36ba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jun 2022 08:52:08 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25A8oRZ8023935;
        Fri, 10 Jun 2022 08:52:07 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gfwu65bt0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jun 2022 08:52:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i/102yQ3HwiS4r4vx9FvjbuuBKd5O3o0AsgNz6+9T6nEFo3U8Vate/SYDuk8aHEI9jiOngh/jb+Wf+tGFxTY2FwBHyG2jew0Qzpo9y3mt+K3TJMcuy0LSV8SBqBFQ9Sm+wTpxhO/aCY2K+bf4Ta2BO+vvCr0UenIukE7LE7HdBeD+81YOOXLJGxpGnBoi81uVg8cfjBEKrq7ev10pboMXIBBaxnbwAC+JOqfjkk2gOMzH4pXdN7EnGo/11XZBjaX7qPDMA/6nrNLXuSMYTEEpZbqcApGQA4rIXY0Afoe/bT05ktXtA91eEIZKV4NuqE7OL9Dw77QoJIDs+CovVIZYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3oJ0N30Gm/+zMy5wugWbJOuybwI/vbLLyI3HTBEW900=;
 b=liszfv4EFNkaU04Vctwf6oH4DXjRKB2jWOfKFTxUqy4xDYqNlW2tx0SVCZoOSNAcV4H9Tn5dY1H0yJVj8RznUxuzRBP/S7XT8AuFc1Lt7OOsrQ+DbqiTfivSpH+Fht4fnHdRdMaxysDlhO9nhw6thqLlHZgxtf/Gzl8iDyye/KT/IQcJxJ+p/E3uaUji93uJqKdNuvPtBrdCX7JcU4EPy+Iok0Vg1TGZTqYRfR2FJ9cIAAIkiFgWCjXKqEcfrUrJyzpBy7x1yi6uO8Ql7AYVLSQmrp/rbgzhC+NZHHd5z6LCqpuJLrcq6v2hL0zR4lmEToYUYKk7owjsmMNSlGBzVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3oJ0N30Gm/+zMy5wugWbJOuybwI/vbLLyI3HTBEW900=;
 b=wlF38/NVlq3kTdClPikPN2Z5fbEprmZ0mRR680FIiYv8ZAnZQ1esuBP3vDk1eORggasQIPV49Pe+RaGA/qZJ5bl+ZOnl++eK/ZHq2+0D4dr6MOKvg5wUCvpOJOVfLmztP+AmaCcOBg+hFhAX4daBZy4mTT46LvxNNRa4Q/e3P8o=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by MWHPR10MB1965.namprd10.prod.outlook.com (2603:10b6:300:10c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Fri, 10 Jun
 2022 08:52:05 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::ec25:bdae:c65c:b24a]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::ec25:bdae:c65c:b24a%7]) with mapi id 15.20.5332.013; Fri, 10 Jun 2022
 08:51:58 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, zlang@kernel.org,
        david@fromorbit.com, djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH V2 2/4] common/xfs: Add helper to check if nrext64 option is supported
Date:   Fri, 10 Jun 2022 14:21:33 +0530
Message-Id: <20220610085135.725400-3-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220610085135.725400-1-chandan.babu@oracle.com>
References: <20220610085135.725400-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0229.jpnprd01.prod.outlook.com
 (2603:1096:404:11e::25) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 05e1209a-f31d-4a60-814c-08da4abe7a4a
X-MS-TrafficTypeDiagnostic: MWHPR10MB1965:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB1965487E82C9804EF7E04332F6A69@MWHPR10MB1965.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9LDi4S9swKpO4+CEtbF3fzWnZ6xybXHa/lYtIG5bbxItkp8e+tGM4DVOeU8rwQhD8acJ38x829zARff48VWKN8HbrwokjKOnKjiTByfLQlOR30WZj917WIviWsfcjrxk/CI00WTVJuLPMBmdTBfCHO4XQcdM6MIQtXmyT5szV3O9mLFjABWL/MosbGD0j6gRtiT5sjsqUFVPLGtjZxMXVbOBU4GYTFAgO8XEJKgL8QbUiW06P0ReWy+ub6NHptFyR0rlNnHhqHR3OUFWtrXgG+uRTnJ8RN/y0aWQNQgCd4a9pYER7VQYHWDCMLc4sQlGE1nfxcAzb9NYAmzcSWbr8iQvlU9F0cT2TIbW0QAkzFJp0pYhVaF77mPK7lQ3Tq7F+lIbRw31eYsQs0ubEP2iDUsl5l2bHU+iGbHRzBye4LuetMaFZiEkKKk0phhKyMUmZDpv57gPlb80oijRLOv9vMt0HeqWxqOi2Auao8v+0WbxStnqFCcmYCUPBspYVMnmegG3675OxqAPM8fUKZlYAbOGIvSRsd+AOZoBIp0kG/gTPAIrCN2vxa6cFXaH4tdIvqejB1j30VvnqigYXat/a4tUev45YkTAzGFVr7Z7xajHw1zUByDdT3p30NW50ApDyEm3myp+eVtMAiMCw8EM/8VcoBFVE1LrOgwTB1DzdP9OKgkBuHbJ35fbcjwWYS7uUQJImuxtMYlV5GSPWVjIKQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(6506007)(6486002)(508600001)(86362001)(52116002)(26005)(6512007)(6666004)(1076003)(186003)(2906002)(66556008)(8936002)(4744005)(5660300002)(66946007)(36756003)(316002)(38350700002)(6916009)(38100700002)(4326008)(8676002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qryx+D1yU86cYKAr5gmtMf+JQoBoMwfDM2s8k44ElgbCV/cFenG5FdLhzkKW?=
 =?us-ascii?Q?ldlMnSSSubPy6W/SziWdRav+OyKlA8ZWhI1/s6+rY0Yz7Awt4LuWxaeo1vBA?=
 =?us-ascii?Q?Adb6ls2OdyuMkVLwQCTJndKLe33tuOdeHKA8iHPlG5607JGQ7EOkUv1xCvM2?=
 =?us-ascii?Q?9Xa3/3rCkxrFO97koS2IShf8T/SmnDHq7fqmdetc5zrRGvSZyGMwKCQEkwSh?=
 =?us-ascii?Q?b+u877HVDz4LlOonfF/sF0oXLFMWg00YZHXNoG4C8Pirq07S73lwvqqc4hGg?=
 =?us-ascii?Q?eGeyJjGlIJg0RAfkyqVVJ/j7Awh3dptl7KB6+U5+raf+0HCWt7J7rpqwM6jc?=
 =?us-ascii?Q?sEnnJ+L6A8ZQoFdeNrBiFP/MDTyk0DN0hriLGuZylUZy+DDvXgw2eIYlwjxj?=
 =?us-ascii?Q?KKjs7kyBEvLIDlUIm5vKsEA/5JxFxGWFrQSZ4EBgLad/mfoI5x++t+objw0v?=
 =?us-ascii?Q?CTpWLzIKVWpWy1ZKXCVbNYG9V82jpbfKnUOppEf4l3PysZP6ypY5pAXm4tml?=
 =?us-ascii?Q?+mtZMu5swPmA3aJKpS5YRlS/Mr1sOEs2xtLfg0S/A5wX2wN18fsf7MYpl9/P?=
 =?us-ascii?Q?Q8M91RjaFYhJrP99Rc8zDxE6IKKBs9RxVgjDaZVHlovli6Cw7Zbgl0bivlzz?=
 =?us-ascii?Q?VCOz9fy61s//0Uj4W1F59Ed/aw1a1K93AmO93sNqvTV4p2OWG99HUvSNNAXO?=
 =?us-ascii?Q?Iy1mTXfsn8VdSzEao2Vd4u+CWcYu4Pv2fyjwy0Om85zFnG98eygpHuWlOdtP?=
 =?us-ascii?Q?NsCYsRSt5k9rrpZsHo0pwVF3vC64mUjaaWj/X98SKTFusMTtp/kR5IFAgDeV?=
 =?us-ascii?Q?cEA14CtJOR6prgqM6OaHNnef7lZGKO6tW5AQ7ZzGCnUDfyboNFlVzjysFnYY?=
 =?us-ascii?Q?8jBL14WRVzmPr1S85VtsxAL+vQVB+gwG2cmF5/iYPdJgczY9IJ1vytjhS3pB?=
 =?us-ascii?Q?e6WXj+XH1CGn5UYyrPT9cPW/XNd6zu5irEHXkb+4d3zN+LUiyGMSWrkg0GFP?=
 =?us-ascii?Q?GMYv3wYZPrgkvxDgYFedVkTT4y9rCfIZSqFjiL8KzLUU5LPus8/q3RtjC2WI?=
 =?us-ascii?Q?iuKz2fvaP6z2hM1HBJZgqtaNOsoNP9Mc2n0HAgcfmdpr16Xu+WerNuVKf4We?=
 =?us-ascii?Q?0O3mt4Dmwx5Nh3tXm4kUqseVe8sDlzJxKfddwBLNCLAwyHx3iYR+9bFhVqYB?=
 =?us-ascii?Q?z3AfQJarkfRpiz/RJnkYgSQsTBp+PfR7Osvj0F/INrJC1129cit3iezpsyfL?=
 =?us-ascii?Q?VfvYT69/aWHmGdlbXR43a02hPayYOUZ7Y5u4kWejVnhI4JaEl8VYq7qUEI91?=
 =?us-ascii?Q?YNYkNm5ZVDuKVz/hgFmCOGyHWv/DMTctiP7Vb3Lcly5a/n7QGEA1cbnV3fpr?=
 =?us-ascii?Q?Obh8UoypdnYKymlyVdVQaiIzjtU5Zj+/4uX4hYMK2jd/u80+VHGO+Col+tvA?=
 =?us-ascii?Q?Ve6efPDkNuX7+wbrQvfmBU/K2E2No74QqBAS8GF8GOKqJM+CmeA7NadbwKDd?=
 =?us-ascii?Q?tg1JB5+Vvg0gSN72XZ7ud2d3EWOiSzorHiv7PksR/Cul/0WPjNk35fHQfD/t?=
 =?us-ascii?Q?jQ+iMNAtTkf47RIl8Pd3jvKAPeiCmIm9xeQDM2Bh2ELvMGcLQ5b4algMfYxb?=
 =?us-ascii?Q?VZ7axHLgb7GHoZXJvgE1CFrKezLJaMrZ2Aydm9AxWI1L0K/HudQI/GqU9wSB?=
 =?us-ascii?Q?cOv0g+Xk1bcqZtb+xB8kGe44c23AHZf0BncZJ0KzFD7L7HvdBPnDP+usoKQD?=
 =?us-ascii?Q?aHG5lqrFsH/AWrePXZRZ2IFGxLGGOZ4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05e1209a-f31d-4a60-814c-08da4abe7a4a
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2022 08:51:58.4634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HJzG2oiNGA576tyFC/R9SVk0BfK8Ps+a8BwaZW7QWcsx+1X8vK3HP8SH9Z6v0zHHRu4FS33dBl5q3Pig62aSoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1965
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-10_02:2022-06-09,2022-06-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 phishscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206100032
X-Proofpoint-GUID: nyk5SVTv2xxUceX1v634VwJY9YehQgAJ
X-Proofpoint-ORIG-GUID: nyk5SVTv2xxUceX1v634VwJY9YehQgAJ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds a new helper to allow tests to check if xfsprogs and xfs
kernel module support nrext64 option.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
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

