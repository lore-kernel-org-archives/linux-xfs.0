Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B03DC7EE2C
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 09:30:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235961AbjFFJa4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 05:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237497AbjFFJaw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 05:30:52 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F3D010C0
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 02:30:50 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3566HeNN017276;
        Tue, 6 Jun 2023 09:30:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=dcva5siLPay8IRF9eBR/PBNk/97Dab2XWuV/EHFd5GM=;
 b=zhaViF/s/Am6r+3yxVEEaVkyQ4Yv+NW+qD/S7Q5Bb3v5PvMmk0sYlDy2S+5YjtuWKgJW
 mkpJk9dSESqAGRO/hwgVH/pFFf8+rMBjGLZef3DpwVHOzMq1sWNZSDugu7btIpe3gMht
 eqShMS3O7oXVL0CQ8t4jSlsgZBuNloRI0iVu+3D++RgwRJa48Nwk+8gUj/XIdQ2X2if9
 UlwH2r67bKIejR/gXdORJZJjU8iMei+JP/LiThbluno27lQUL1niQ8xE2weVCH7PXa1R
 +ttuVmJQsk2bfltl0cdOb8srMIpZ3X0N79agJ6qjLAqAYEqHrUzCNnPRs62R0M8zVwyE jw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qyx2c5169-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:30:47 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3567c68J011385;
        Tue, 6 Jun 2023 09:30:46 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r0tk04sua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:30:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H7w8/VU40y+6XueAvjDD3Hvfs4FctzbspodaZ0LGT5Z+9E2bcVI2GjDQJ4zeeC2dDKYq58nYosBUahd6Tl1EUYor/k+uQRciCb00auRxJ20ScVZgOdTDDh2EsZMIAP6WEwJg2ygpmFTu/HBP4Yw7JitNGHGZh2bqY3NoECYxQNXmbUSq8M7dfL/p0hAdFFzAHHre+OR2r3U+HaCWpjN/9t6949nKaK76Fa4Af3bEGp1KOu+i/Sxy76pI9JnfXFsuHUrzOtGpJXrxq0J/KmErt5a7IYccLdUx1lRvXYYuzr6HwT/bf1e3eqnDr4/PoZV0hjDRRTaqeq8jWl9TeO6wbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dcva5siLPay8IRF9eBR/PBNk/97Dab2XWuV/EHFd5GM=;
 b=mKYizB9fa1w+hCQe6w8f1N6mLiKLKSZdwTMG6KEy6mu08q2bK4KwNLfqlIgC/biVlpCdf69IwSG4nQPalaUAA0crtv2x4k+zBd+8i+qV2CD5uye7EELutcGGQ2SJC7gadJlCf8vf+6M0D0loTrvij7Bvb70jc5StuaYic912qbepn6EUFIGjpLdl9nOCpGbtIkDHe6ch1Hl35ZxGWOkMLi9PcHMnfEnSz2iWrCzv9Us9STenPw6DiMJ0h9wMWg718WaExQ6XPI0Cxs6Vk3oaNpJrVf+zgvUgrHfh0Vr6jOT3qRuYKNSBCUrhtAkNkly+9wRhuovSnUUGVe2IZUoC7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dcva5siLPay8IRF9eBR/PBNk/97Dab2XWuV/EHFd5GM=;
 b=du1mW4TAsIerOx2dnyKll8vz4XnwD6aMgE8Ee1biQ36CjQEQaqP/aMgYb+5xnJIMAgUJWQhvKlvoAXh/HXVCnf2UYqYmvhA4dn4bnkmI+gEu1A6IAJk27mH/8aqSN7cWT5jRc2HKFm1pfZHwM8V/JAhz4XmBOxXGUGSIhBLunlQ=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by LV3PR10MB7747.namprd10.prod.outlook.com (2603:10b6:408:1b0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 09:30:44 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%7]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 09:30:44 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V2 20/23] mdrestore: Introduce mdrestore v1 operations
Date:   Tue,  6 Jun 2023 14:58:03 +0530
Message-Id: <20230606092806.1604491-21-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230606092806.1604491-1-chandan.babu@oracle.com>
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0310.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:38b::7) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|LV3PR10MB7747:EE_
X-MS-Office365-Filtering-Correlation-Id: 909de262-1b18-4746-7d63-08db6670b3f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UfeTTLPdMil6ZuakBRB7fIC1XSJL2gL4+GVRvt4oduwBhMEUKezfqr6rQ67c1y1I92+3onYam9pckVrg8llL0S8REUTnE78D/KcRQyytEa+f9HdizAQwtpqQ+xkv94zr6hE41JEP557UtXEZI8TpFTyuUKIGeVgRxFHiC9i+QZSCFo6fjLrdmZ8rgOix7O5YWpQ13XErFtuh1z6d2vS0eGPBt6DzXMTH5ZuyE0+GLAk/PGjE+5i1cgxezQuq9c33Ki1h8N70e7fTUDL4dx8oFw5VA8hjFsMF3tMVArD0uMxuP4pddM5RdJieYzPa4szBa2PrBbJHdz8c1OGUMtWunaZilm+82clW9WVimEKC2c+aUqOT0OU0rK0Fpqx3Ga7nrmW1RK9FjZ/p7p3goYiyqay2hGzt8fh+W8toelbbHGadtcGjzVW6VzuryTorEURGBejpHMCIs7kFv4YTpfVCcbfZ2Mj4QrjVnN7f4uStK2AbRCosjLLLluLxkUpV5YoozncHmaHAuvvXReTE3AdXc4n5j4rJw/D5u9+yU5RaMP4D/3zkghiqZypFSrqilBpw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(136003)(39860400002)(396003)(376002)(451199021)(186003)(478600001)(6916009)(8676002)(8936002)(4326008)(41300700001)(66946007)(38100700002)(316002)(66556008)(66476007)(2616005)(83380400001)(6486002)(6666004)(1076003)(26005)(6512007)(6506007)(86362001)(5660300002)(2906002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/G1vBvFvOc2TBHcYQ88JoxTT/Nr0MaebxAbpfCBC7r62twE5RRmxnVJYEzFO?=
 =?us-ascii?Q?EEq1zQcO+0uN6Vi1JFD34vShPfjl6hTirMvdkzHt2+rwY1T4bJK0vIQ5oaNt?=
 =?us-ascii?Q?iVBOKJwpJDVSalJ1n1L1JiTHQx7wYZs8XkwVwP+DniSRCa54p7T7JhNMzrVg?=
 =?us-ascii?Q?1v64kadJvgoZIXqD5talfH/LMhT4Ef1yOg8V8sZaigSqx93nu0lhyJvqBcgr?=
 =?us-ascii?Q?W/q7EQ1xLoG8NZiCaLS9UGYWzRU3gJsf+oM3MixeO1InTotLooLFmygp9xjz?=
 =?us-ascii?Q?tt6pB4mcP9iLH9/UMTzywgC52VWhLsltfoKyafLTvjrx8991twrQ8+YZXZfP?=
 =?us-ascii?Q?BgDUnqA6JMPhXV2ACcO9Tk5BFEQU/+jnaqFuRMUDpqhiOUUIDvflbJrXccAL?=
 =?us-ascii?Q?GiAfpbmcUZx67uhbiu2W2rmOU4uBWY8NdRdmgLvkyy7bvvRU7aLeD0lQEI3b?=
 =?us-ascii?Q?SrHI8c6ugiq7YjQo2dgQqDCH7/ZX4GBuvFNMnpe27G2ufhgr8P1AmE6vbYIn?=
 =?us-ascii?Q?Mw8uIIW5MdfRSug8mkkcoTMvGMLjIJuHNkAsnK0q1/Y5Nb5Hoti0Dq99GwEu?=
 =?us-ascii?Q?s4QukTbkQMUTyCfSiX86Q+DG+4WKr4gG0dGjgPIAQL/kSsph5SaTOmT6Si6e?=
 =?us-ascii?Q?umQCRWKgJhh3knzHv3Gw2V8JpFmJV7jJ6yUlvL5P6GT/ma3Uv/V0SP9LPVIa?=
 =?us-ascii?Q?877mLZ0MOwt3Lzeq5xavBsXmEwLVfFxgjVmAAWrHUCZDE/VGj0CQCiKuWp+F?=
 =?us-ascii?Q?+97jLPIbXyqq/IWJZ3cW8n8gBcR+bzebXIHzSARDNrSZbwoHK+3O5uZIkStN?=
 =?us-ascii?Q?f8hgTw4cbMfhVKJ6VUTuQh8tquuL01ZtjXSadqLDkLgIHIuK2VEE0f4Noqw4?=
 =?us-ascii?Q?MK+gM68yS9Pg97YGq6xd7DROjZtycd+9NXYCO5ijtCytu2pYhbVdkJ29HV1R?=
 =?us-ascii?Q?Yw5ei64zsQynqRhPrMiTGQe9YJQpOCuWMLkq2zY9EP04+rDGtIvpo1rpV7vE?=
 =?us-ascii?Q?SWok0KZgvIK7AUVl7zvzn3kwHWDcI0yXVAzvNZ6TsE+Bu9daESVwNHGRtjkE?=
 =?us-ascii?Q?F4uBb0HvKx+XVgViztpIkUZTiB50PWdJITJHPaf6PWkgOgnzeT2UB3zBAo0H?=
 =?us-ascii?Q?CAX51CgQUwFBp4f6cmZbgwkZju1kYqd59sJ7fc6ZEAEs2Tv08v2M2S7Q6o7k?=
 =?us-ascii?Q?vOi7XjqaiKPQ4FEie2sGjY3ozoZYXJdFdtNBj5wYfbaL1tTtymF48AgHQj9B?=
 =?us-ascii?Q?mU9/ttDMOW3oINth/mUahHGFyCN1mE0e9M7wC0G+M3J3wTU4w0KIHOBBitJ4?=
 =?us-ascii?Q?c3dRfMzuGm6hcymT8MozeFCyWs+a+cdY+lF1ziaVqJlKNLRzxDCDqb9RCbcu?=
 =?us-ascii?Q?ghhm4QTeuN8uwl+1asqnXFrMPA53ZXJJIxsrj/yuZKsdMXBYHsoCDbrfn6eH?=
 =?us-ascii?Q?sPQs/2MGXMzKe5eaA7CFlV42+it/8BqbrCXJXwGZLDEAlF+jZBPZ91T1HyfA?=
 =?us-ascii?Q?ysAytkUUU9S6ZrHdSXqCBWQy7nPuhy1eE6zQcPon6DwntsqDuI6b1ZBup3dG?=
 =?us-ascii?Q?COlAf6OJaVFG1/ZDLd9jSF2V6aYcBEb3vqPG5EqV3J1bUCVpHMlIUG68l9QU?=
 =?us-ascii?Q?aA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: TiHTgT2Bce4XcpQoPrMT7mPGVxVqdNC4AveRjIdwsUz1sLJiOxhcd03mp9G36FzXBMnw/UwCopZFtk46aGj27aFGoc+uP2ctXj6t+yGBe8bkNMNlTC5WQkURl0wJkekfoXmtjF33QSdvNIOUohcncFxCdt4BAHD4Zr+lW2to/nDe778PYFkibS2cB0O4pG4nnVH7iWiMDU7vo8uUAufVpeXP7i3Tn2Npt18Dm1aP9UGv8OSuOgqYyGlYuRV+jGht9XmJnTp8+Lp1itQvQ2BWxxiZQ01uBQrXss7tHR6b0F5ZCVM/S5JStINSrz9deEGLwkUkSsEuZwuGJyk6dBtuXJI2c9myEqMjkZX5mpD/mBSMSSRqHu7P8V7ZFclq8o2qbOz0u3s1BG4ysXv37ZdaV0oDFNkzj/vTfkXM4qVvcHF921uqyWd6GU60xlVqq4B0kv+Qv/MCLT8l+PfvUudtH6uFoChuH7JiOvYbx1QcHLknR7ojw1kuTfKwYzMqJGthTXTtlSni0+zGFQbFKMWRd9cCFap29m5wTQrv4AL5AtIN38z9CVzeG3NiMMa69tOf/dEROHhxXTwH4/RpDmCAUN8ieY/q+EZSjYqDGKixg+Ea3wuz+XgGn6/bWLwX4eUIb1jdo/kWrsaHKInO8OBWBvv4ThngkUtGwxpA40byQstT4qhDPJdkl8hi8TKSok2J1SZKLLP1oE+ytVdRAsVDIHt2mQH8PfdK8Pp5o6zlShSVMcqKYWCwp+NgUncHklidTRkyoxaDGX9RDSzYQn6JAtGuQ2Co/qahBEq9VGqX40o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 909de262-1b18-4746-7d63-08db6670b3f5
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 09:30:44.6749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2+iN2MTSAhw6Ub4e21KtbCCQkzQ0seNe6UnYBRiPbB5cN4bumHaVUKHzxBrXT7BbjheiAIhPb68pskOkkrMjFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7747
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-06_06,2023-06-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2306060080
X-Proofpoint-ORIG-GUID: btcRCR9PlOyRRz8NMW8fxqSoouBmnSsM
X-Proofpoint-GUID: btcRCR9PlOyRRz8NMW8fxqSoouBmnSsM
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In order to indicate the version of metadump files that they can work with,
this commit renames read_header(), show_info() and restore() functions to
read_header_v1(), show_info_v1() and restore_v1() respectively.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 mdrestore/xfs_mdrestore.c | 39 ++++++++++++++++++---------------------
 1 file changed, 18 insertions(+), 21 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 5451a58b..b34eda2c 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -86,7 +86,7 @@ open_device(
 }
 
 static void
-read_header(
+read_header_v1(
 	void			*header,
 	FILE			*md_fp)
 {
@@ -100,7 +100,7 @@ read_header(
 }
 
 static void
-show_info(
+show_info_v1(
 	void			*header,
 	const char		*md_file)
 {
@@ -117,24 +117,14 @@ show_info(
 	}
 }
 
-/*
- * restore() -- do the actual work to restore the metadump
- *
- * @src_f: A FILE pointer to the source metadump
- * @dst_fd: the file descriptor for the target file
- * @is_target_file: designates whether the target is a regular file
- * @mbp: pointer to metadump's first xfs_metablock, read and verified by the caller
- *
- * src_f should be positioned just past a read the previously validated metablock
- */
 static void
-restore(
+restore_v1(
 	void			*header,
 	FILE			*md_fp,
 	int			ddev_fd,
-	int			is_target_file)
+	bool			is_target_file)
 {
-	struct xfs_metablock	*metablock;	/* header + index + blocks */
+	struct xfs_metablock	*metablock;
 	struct xfs_metablock	*mbp;
 	__be64			*block_index;
 	char			*block_buffer;
@@ -259,6 +249,12 @@ restore(
 	free(metablock);
 }
 
+static struct mdrestore_ops mdrestore_ops_v1 = {
+	.read_header	= read_header_v1,
+	.show_info	= show_info_v1,
+	.restore	= restore_v1,
+};
+
 static void
 usage(void)
 {
@@ -310,9 +306,9 @@ main(
 
 	/*
 	 * open source and test if this really is a dump. The first metadump
-	 * block will be passed to restore() which will continue to read the
-	 * file from this point. This avoids rewind the stream, which causes
-	 * restore to fail when source was being read from stdin.
+	 * block will be passed to mdrestore_ops->restore() which will continue
+	 * to read the file from this point. This avoids rewind the stream,
+	 * which causes restore to fail when source was being read from stdin.
  	 */
 	if (strcmp(argv[optind], "-") == 0) {
 		src_f = stdin;
@@ -330,16 +326,17 @@ main(
 	switch (be32_to_cpu(magic)) {
 	case XFS_MD_MAGIC_V1:
 		header = &mb;
+		mdrestore.mdrops = &mdrestore_ops_v1;
 		break;
 	default:
 		fatal("specified file is not a metadata dump\n");
 		break;
 	}
 
-	read_header(header, src_f);
+	mdrestore.mdrops->read_header(header, src_f);
 
 	if (mdrestore.show_info) {
-		show_info(header, argv[optind]);
+		mdrestore.mdrops->show_info(header, argv[optind]);
 
 		if (argc - optind == 1)
 			exit(0);
@@ -350,7 +347,7 @@ main(
 	/* check and open target */
 	dst_fd = open_device(argv[optind], &is_target_file);
 
-	restore(header, src_f, dst_fd, is_target_file);
+	mdrestore.mdrops->restore(header, src_f, dst_fd, is_target_file);
 
 	close(dst_fd);
 	if (src_f != stdin)
-- 
2.39.1

