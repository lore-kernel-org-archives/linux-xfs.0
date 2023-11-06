Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 533C1C0018C
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Nov 2023 13:13:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232142AbjKFNNN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 08:13:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232184AbjKFNNI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2023 08:13:08 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E89D49
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 05:13:04 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6D2656011546;
        Mon, 6 Nov 2023 13:13:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=Utm5Lvcd+DgY9K4VopJp4jyGdtSR30ppD5dN5Gzx6HY=;
 b=AR2vBAuo4aBGNhZYsAOyxobPbmeaVQyMzc39fAoIBhMaocK/WjsGAlFrbZYOx1scsZFl
 Y7Cysg4W1Qaqu2WoECsVRWN9Aa/okuB3wNRlB68ZRQx19jidsk9pPam0IAqW0B2WxJ1o
 35EOjAmPyFn8ALsUYNwYZlN6j39G0cn/Ykq3jOD35IADpu86AX35eOnrBxo37eUstgXk
 qaS3JTimcv1s/PrP0zmZ9i22P5A0pBMnV4mTnb20pBiwY+/mpiFBtr2m4+AVToSYyYuS
 nEpt4mc+rnMjSKWi+8PEQJOVzI8LrNARymCJZjv1EpqwHrdzXIIS74F9A7QPasuZyIs8 fA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5cj2u09c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:13:03 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6CvwM9030456;
        Mon, 6 Nov 2023 13:13:02 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cd4td05-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:13:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ehAjxuOLuNeO5O2ALXfXJUbw7KZk0EnCXBSxZ3BuRO00XR/+V20ztWa3WuLs/6nZDHJKoaVHePCtZERXJ2QXNEhXzCDUZimojupqZa+xSDAh80uWJI4m7zTgnKQt2YWflk0sj35tXCUvoKpnBE7XAYE0RifQEQxx5/6b/b0TC5BvsRN7fi0duq++J36zP1AuObcGGnm6r5Y5NCE8+PRxd3p3iA+nl4vI5ANbXIcwc4CT/pb4MXsmBdkTIh1PdzYD/00G90gV/6Ic4SegJ2T7h9R9npHVKrcbKJ5sxt+qFW6C+qcBd0dI4TGrYo7RNFx1O6tnNYBBCQT/THAERliI0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Utm5Lvcd+DgY9K4VopJp4jyGdtSR30ppD5dN5Gzx6HY=;
 b=YLHcvnSrL8RRq6DxrXWZzxzh7RbKNfkWfPe+ZvhkzawAWmZjafIkxBcCq+ot24hKELQjkvcdA6gxuOr9naHOCxzAHtHHFNp98AhSvpr3IMbjvB1Zyyikkpnll/ZgJllwBFm4dSZ26C9DakveBYNxpmhYCgtN4Rnv2CUDp9gMGQUuOqMSq9Bmompi7iYZyzFv/V1YPFPq/kPJcbm+sCGtjQwVVmZZuwab0007sRT1TQofuxoKJ0kkcAANu4lDe/pH+4unnKveZrStVv656Qx0Mlq+WHf8fpmhaVPWVWkB+z0jMkwvZyXanzv/5VXxfMYfWAunvtP5xBoWQi6NAaE/0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Utm5Lvcd+DgY9K4VopJp4jyGdtSR30ppD5dN5Gzx6HY=;
 b=tU7hC2Xkfg7xRwdjky+uyyKUZFFN4fSop+KnAQzUW5li92i9Aw6QNK6TjNHBQu5gkgynTDhVRJ+us2L/EGpA2AR+rim0lgBguGQoeYIWE5PHuCKxiV0SP0anedpMnuZNFEH72mWtGwjHdJCqZosKlsOyTO01vOH7QsQ4Gpmwx/k=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by BN0PR10MB5127.namprd10.prod.outlook.com (2603:10b6:408:124::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Mon, 6 Nov
 2023 13:12:58 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Mon, 6 Nov 2023
 13:12:58 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V4 19/21] mdrestore: Extract target device size verification into a function
Date:   Mon,  6 Nov 2023 18:40:52 +0530
Message-Id: <20231106131054.143419-20-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231106131054.143419-1-chandan.babu@oracle.com>
References: <20231106131054.143419-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0012.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::15) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BN0PR10MB5127:EE_
X-MS-Office365-Filtering-Correlation-Id: 98f04c05-42c8-4aed-9f75-08dbdeca1867
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KvDqprYFcBO/iyLrpmrZucBmSuUdPbo0evlVNc1TMlqny5tCWdZnNAypck1LKBgBtmAJXc/j1rMmDp7SylqfucL8HgplB7z+yuLw5XQXy44Xut3ad/swRJ8oZc8qyIsygHrkdX4UNtvjQxKVKYOYyJG38ZJRuDe6LTpBez7TzY/s+weCNW8+VcjI7R4AqhxqmNa7wHdiSBWxqm77oZXIdykpM/hRFmht/avDEzyemlkyzIVPpD9KWSIsADCewzyJEYblhE9nLUoCVKC0fz54dibnXS9kgHRfrMbrO/7R4t3gk0hIQUdTDUpMawcQQo4I0o/QU8YBW8+FAVPdh0KEz7l/izS6ZbFPeSnMjyEeOlMwyWfx0fIkW0MhiI6Gk5TJjUA/spaveWxRvDEv2yL4AjTSbvEJagUtPIcV2HTRYMGOFMWyetLb69eYKN6Ep0njVAvTuSJbFz5RExh9+RF6jwrVKcE+gEGrJq9E3BvSW+/RtPgibtDiPRlqiV1OkppZRdgs9I9mEk5AQYUohLKzgC0fOWCH1XzG08dE5XZ2NbJX1/Nk5bb4Ry/Uqm0hRFv3+0MCaDocAeqmzg7XPxRh8kLcOXKN+AuzS9ENK/QAWXOuGWNa3UZZoOkQ9VSxQb/U
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(366004)(136003)(346002)(376002)(230173577357003)(230922051799003)(230273577357003)(64100799003)(1800799009)(186009)(451199024)(478600001)(41300700001)(6512007)(6506007)(2616005)(6486002)(6666004)(83380400001)(8676002)(8936002)(2906002)(1076003)(5660300002)(15650500001)(66946007)(26005)(316002)(6916009)(66476007)(66556008)(38100700002)(4326008)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S/iQLD3qVtWJ4wfPql6iZ/hHyEeuESsl7g2SsOtwfC6CQwmIHi6icXDVyp1q?=
 =?us-ascii?Q?VUWD9YyskLukaSfCVG+bTe//G394AZ0zvzD5aeQ6xwbG13xMEFe1uYtVPjVg?=
 =?us-ascii?Q?IQdqhJV2JYIlrfHvkkjTOR9WY/JvComjR01TO7W4JcET/qZtAGFYbUjppPk+?=
 =?us-ascii?Q?LlgH83ix1OrXyA1JY9mEhmpUZfKR+u/wrjEcsjqa7oQpYwbSajbnCeOYuPRs?=
 =?us-ascii?Q?VCL9eTFOpeH05wXygGm+wjYlTkkqNJSGM73fcxgPYW5atPIe59PylU6nwpzV?=
 =?us-ascii?Q?S74s6y/vpLPNHCX4GkGV3YF3Aa444gvdHgDV1/oBvKaVKXQC5nRAflLoKrX9?=
 =?us-ascii?Q?54ZwZQ98wBkVN6/znL+rrbnexPNpRrUtzgxUScu0Sz4Xjv0fkd8msQmeANex?=
 =?us-ascii?Q?jkMt1h7xJk7bCQp8XDt6q+H1qGTB67vRNM+u0JVN3nBe47OTCSxmQUVRNEc7?=
 =?us-ascii?Q?UHon0gvr/T/WahRgBoXyNVVTYoAXAwttJdFUUhBiixq/B9kq88BkFDNIc2VH?=
 =?us-ascii?Q?du9KG8RQ0uUj9Qv207osJCFydM+8N3kFUPjRmySoP8mqoi92SCQ1M3F00aTW?=
 =?us-ascii?Q?Pr0kY5fH8WmmSQPGqFJ6vX2XpeVQ+oJTesf2y0l26iIomtK+CFojm5oe17dO?=
 =?us-ascii?Q?iNtU7ELH9zBA/u4YC6TPoux4GjgHAGmXSdhrZPOAj1m+macsp6JNLXvwR28B?=
 =?us-ascii?Q?0N/nwnonE/nTWYOpOi+czgNlVOG1qsDkSppdNRxHkHwq4LGvJ09BuSyE8ioq?=
 =?us-ascii?Q?eBQOcQlJAWX0q6cYJgcf4+jdTy78I0gSndfKI7ZTq5HTMYbz5w0Y75YrAf4E?=
 =?us-ascii?Q?vhxMJYSQaZue0/J9mVrz7wacQFVeBrPzM0NNc6au47N9Pp2xHPTqp2pgcrnh?=
 =?us-ascii?Q?qINPSG7GHLJsh1F372rxqDBpfLkcJwWZ6LeIN71v19z4vui3oNrEt/XfsJ7Y?=
 =?us-ascii?Q?C6p9S+opEBUzfKKg0ceSuZgWboQYw9tvItVoGWRD0/z+hWH/57DUJ9IrHGit?=
 =?us-ascii?Q?2lYsS2Ki2NwLdYr+v2Hwp73SdKnne6JGXvoOhJednrLn/OP938Urzhamxezv?=
 =?us-ascii?Q?K1Wi11qasjYnWwtu+8eLVMFvMDpiFm66aY9SdFq5SlZV4cPZ9i3lnyF9ruUj?=
 =?us-ascii?Q?mX7S1jnWbA0PLiASeMhmiHp67M1TbfuV1BvzTaaafizTUE+5g2Ty8l8O5D4X?=
 =?us-ascii?Q?EuI9u/HXWiCORRV45JzKEnym+O0+LI3UqDARSHn3VNIrp88NjLq0wEnS9eEB?=
 =?us-ascii?Q?1x/FipNOOcqW3xY39GMAtOifOhLY7Un4ZkKerT+S0O9QtNUEiGW9sx4FeVrz?=
 =?us-ascii?Q?UDy30DbdYM4F5uDMpV1YHhspisSWnKqL863iDDifAMh36YaxIhMD28rrOMjK?=
 =?us-ascii?Q?iCJE3Sx8900A0ttts+V6s8Lx3Qg0cCb6AE2ilKKlWxi5fnFm5e/ukcNhreHy?=
 =?us-ascii?Q?yNfGhqhYncZBYaTNtz53rwvVQdsavgYM4sKPPBhi7gZicmUc2o5y1qaHhgen?=
 =?us-ascii?Q?RKzvA+k6W+IHY7l3r+LSGMdXjzJdX9yNa8gFzSbr96vBZN2Ndmn0D+yZ5q8I?=
 =?us-ascii?Q?+WngpvSOdIIO8PWMJIyOZGIzhdfn/rsPmt6+cR6+ahAfPptU++cj3NPE22Zb?=
 =?us-ascii?Q?GQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: YtPHm82Mv/8ut+zIlnJRJcFp4AbDlICCXV4xW/+IjL6Gab7qSXYvWOAAK6ufX4/veOaeD3T0DWfJMXy3Zpad9c9QSwFXM8o98xjIg9JRQZc2e1ScSsCUwh/j3mDEqPLIxm6VtIMlj0ZPsSpeGaU4NL0393vinI7ycdpzeqmbu0DXfOpvW6cZ6TFD7lJF/oVRqhK/QpOsOrBnNV75s4kKZgI8tfgbiPu4DqNcZQAth72pU3CHhI5ZxktbDxbehFtjnI/Dqm+9QumzwYJcTndRvXYfFwyZVgGruZflE1hZHAgG37Z5jjWblp54btBWOxrSjhIpGRtTf/WraQBLizR4QJ0DOQgeWeIuy59aDvPngk7etE82l9Qv2G3xeYElvxtcNkCvR1wH2fyoGcQ3EMFRlnhOi8RsvOgWRP583p/FRbQ+bTpVerc4G89Bj8/PLN7fh2CsrBVdJqW8XkX712FwpWmB5h1tbc8m77fDkPEHcsGuynDyvawSvWrunnpt+kMZHk+KenLJ2S8vCrd+/S0cBI6/mMicm3UOhrfxAJ6Sbl6H4SCP8i6ZRSDsEv3ySHarBHBZu+ilyPvGc26RoCzkG3ax3I9FqR82mHPlkqYUOnlfFJtFd7EnVJsGr+0ZGyOFyaJ87RSKbMNfMcppicgsSCP3UMg59DgAGKtyYjsWb0dAuC9cLY7/o1SnqFS6uYM/7buRWMoPUxO6kLLBOnlnttbVamE+61gjr1SeqTKDuKvR+l3oaRjZE4LvqSIJkuexfZF/jWTA0SfEI8bsMPXkzSY8Y9QU4gNwkQb+7sCBSAs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98f04c05-42c8-4aed-9f75-08dbdeca1867
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2023 13:12:58.0051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w6bZxDXj/zjVHsbeasZtpEozULQjgE2g3QXfYiIPW6ojVozOssz7Xm9BWhlrHaz8BIKCdek3M00D5UFsi5/AxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5127
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_12,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311060106
X-Proofpoint-ORIG-GUID: TgcMQ1fIaUUo0EBP-KmiuxOlEGSWdiaE
X-Proofpoint-GUID: TgcMQ1fIaUUo0EBP-KmiuxOlEGSWdiaE
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A future commit will need to perform the device size verification on an
external log device. In preparation for this, this commit extracts the
relevant portions into a new function. No functional changes have been
introduced.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 mdrestore/xfs_mdrestore.c | 43 +++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index b247a4bf..0fdbfce7 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -89,6 +89,30 @@ open_device(
 	return fd;
 }
 
+static void
+verify_device_size(
+	int		dev_fd,
+	bool		is_file,
+	xfs_rfsblock_t	nr_blocks,
+	uint32_t	blocksize)
+{
+	if (is_file) {
+		/* ensure regular files are correctly sized */
+		if (ftruncate(dev_fd, nr_blocks * blocksize))
+			fatal("cannot set filesystem image size: %s\n",
+				strerror(errno));
+	} else {
+		/* ensure device is sufficiently large enough */
+		char		lb[XFS_MAX_SECTORSIZE] = { 0 };
+		off64_t		off;
+
+		off = nr_blocks * blocksize - sizeof(lb);
+		if (pwrite(dev_fd, lb, sizeof(lb), off) < 0)
+			fatal("failed to write last block, is target too "
+				"small? (error: %s)\n", strerror(errno));
+	}
+}
+
 static void
 read_header_v1(
 	union mdrestore_headers	*h,
@@ -173,23 +197,8 @@ restore_v1(
 
 	((struct xfs_dsb*)block_buffer)->sb_inprogress = 1;
 
-	if (is_target_file)  {
-		/* ensure regular files are correctly sized */
-
-		if (ftruncate(ddev_fd, sb.sb_dblocks * sb.sb_blocksize))
-			fatal("cannot set filesystem image size: %s\n",
-				strerror(errno));
-	} else  {
-		/* ensure device is sufficiently large enough */
-
-		char		lb[XFS_MAX_SECTORSIZE] = { 0 };
-		off64_t		off;
-
-		off = sb.sb_dblocks * sb.sb_blocksize - sizeof(lb);
-		if (pwrite(ddev_fd, lb, sizeof(lb), off) < 0)
-			fatal("failed to write last block, is target too "
-				"small? (error: %s)\n", strerror(errno));
-	}
+	verify_device_size(ddev_fd, is_target_file, sb.sb_dblocks,
+			sb.sb_blocksize);
 
 	bytes_read = 0;
 
-- 
2.39.1

