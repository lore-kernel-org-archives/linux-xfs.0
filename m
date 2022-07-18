Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 074C3CCA481
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jul 2022 20:20:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234987AbiGRUUu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 16:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235355AbiGRUUm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jul 2022 16:20:42 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5407D2CDF3
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 13:20:41 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IHgTq0008482
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=Q1GgKi/zi77NXRJC/Ns/LZICDR4IYWS8LaobQuzV9W8=;
 b=SdiL9cEBR/YdSoBvTi44Fp0WLbmyWuuVCMaZDXQyxQcccMmv+b2bReMBAhHVPwrpPkid
 5lVcHLMfmZE9v0LGT9crQ34cSdqNBxYB0QpnRiBTAMbf1W4yBgk4Ci7gjjZUv8ktdSbD
 aBhpy1J8UhwxBHADGQekmPEKsdkIcPrfg6cFyUwhGWwuysdMLiv5Fuxn1ZxjIUkPhwq7
 tfZ1SviQzfg0pWB5rPhwvHDRFB/IWdUaV3Bg/fQD0G21kMiJDSdT3YDMnCsSyg10TcQV
 A9OTRL9S/1QCOIaswlioKUlcV9quX2KiOJQL2jF7a6pvZ79fEYC2G/iYLRDOxSyb+lwG dQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbkrc4cvk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:40 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26IHVRS2007937
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:39 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1ekx2da-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hcx1QmoofRSbZ9JWayYGEAbv19VMjIzoEEgBXRSV1VyYqCZAB87ERhyiU+SVqamzXxHuiBliwwVGolFDLiduGt+o3waTmdlFFvVoTSe7p/72WYC0blsB9l3yxlWHDO2uLl6ScMuCZjRCbayOUkE8wmpYZbKA7vBjXw1XM9+Oev4b2rZLGTix6cErvPHzsRQIcCQW2HtqmvsA2VuN/iIl08dCZfNK/2WS0Ab1TdSar3JmCV7iWlv6ik2tLpL5T9sAAC40DEtNtrEGIR0trjsKTPGYjh0GKeG2FfcLEhzBCbUoPjt+Eo9W586A2hJzBCUWnoeiM5zf7umIA/rL7bWdoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q1GgKi/zi77NXRJC/Ns/LZICDR4IYWS8LaobQuzV9W8=;
 b=AgHKOfbOkqdMYnL6EDR9OSJX7twnwXUB+En2+d92XlgeGCgSjk6cvq6TtPh99d2f4aXzde6D/d87r8QDkEe6hjzA6TwrspUjMGrUz+8gfcyOKAhIsOMxCWYLbnF957PDRWNnDkx0C0+QJjK/jqallI0zZ7woDr6x3lXkOAXbLmk4m4J34UrzTZZMdxhb6nuQYdUItQmP0jAL0jaNPDhRkw5iqbhDOhCSwZoZ8bW+hvwz+cVg7HCJdU4hhaKbp6vkzXHEZXAJXYHWxFL5ekmeIv+qfZcQprWJL+jIFtJ3D00PupPCbs/HOGNkDou9dfknFwOQDGevMMnli3OLQnzOmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q1GgKi/zi77NXRJC/Ns/LZICDR4IYWS8LaobQuzV9W8=;
 b=Gg/0+3SQmWObmdkZ16YFKZ/KyBKZKxhKXBmpkMOziL1PsMAYKjQovcjY/XMqA4BwzQLCRygjvIHLAGoO3f1HsmnZtY7lydL4Dx4VsD96mILdc3bBEE/1bGA9jstXoGFaGj6hve+UeAaIdmq290ZRSuCy6O7HRjsZI7QAVtD6XPA=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SN6PR10MB2717.namprd10.prod.outlook.com (2603:10b6:805:46::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.22; Mon, 18 Jul
 2022 20:20:37 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 20:20:37 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 17/18] xfs: Add helper function xfs_attr_list_context_init
Date:   Mon, 18 Jul 2022 13:20:21 -0700
Message-Id: <20220718202022.6598-18-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220718202022.6598-1-allison.henderson@oracle.com>
References: <20220718202022.6598-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::16) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a01851e-a0da-4a6a-433e-08da68faf7df
X-MS-TrafficTypeDiagnostic: SN6PR10MB2717:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BEwJR6ufVvTTIDTK8sSwg/nu/oiIgH3ueRHqV4YDSaJiu27tF4Cr5P13lcqSEgk9PAQMN7axnTa4Gsctxc6jbwYClrfKyLEShRr1HnwqFwN0+ES7ci3Etu07VKGi5CcA98TVRNz4KNVy65vprJSR2C0VmJaSPT2jckkoizzmv3yw/YTJ/WuhpvdFm9y4jTmP7GdaphjAf2uDRqM5sQWXI1uZ373WhmM+fhJJvA8NaoL3wjIpBEltSMHdR+pNOo1xn5/LCM/58SdthUcbpMKN/3itw0NG85fHSUo5h8dMeNg0TBD/bY5ZhYRobQ7kARzaUAsJ+Qb3HJhL/wOy9pBDHpnebOKuncqUMrbAwoILFOErx2MlCVf4ssVfP+XB9jrA0ipwUU4fZV8WYNjJlc2wkrYyVHC45YazOgjIEXP3vQ+yPUtKVbW+vR78aZP2XwatbPhI0oz7auyk2i0wZUwb0BzVkc+5lNkeRQRFJYs4lc76lDFtpUrBloLHK/PfxFekmyI1TsrBHohEsXDWptFCoUI8m0akXRaQxI92W9hZcM1J9a/+p7x64EfjxwHQswCFqsHLdXtip7Ac4A7z9z2tz71BBi44SBljrA/iV7PN24g5gvNwQzQdL1RBDO31kFbjRM85jKBPU8AHh6lREUtTTN0jEOyA6bMShYZUrflidV8AOQKLzhCY9rvkP/oV4Zrp3ASAbgh/6h7yFWl1I4Pk7u0AUClh+AXQgrCRfUzskNJMd2G/kfh5uT4UqQfYpz3nmCVxowUTvOVrFAELgx0GmnVtn0C+d77TxClX25HtkxM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(346002)(366004)(39860400002)(376002)(66476007)(2616005)(1076003)(83380400001)(66946007)(8936002)(186003)(5660300002)(2906002)(36756003)(6666004)(44832011)(316002)(6916009)(6506007)(26005)(6512007)(8676002)(86362001)(41300700001)(478600001)(52116002)(6486002)(38100700002)(66556008)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6x+Mfhf73QRSDnexlpYHW8pDDyX6eCAZuWiwGTcxNQdleXoFrPG0xzaj/yyI?=
 =?us-ascii?Q?68zw5PIf3kofldUEw97poqU1bL3EQVMojE9HZr5I5gs0sfL73xL/HtaU4HNo?=
 =?us-ascii?Q?kOVFSn6q9dpZocIVg0ShBeu886GZszoxGXtjtMcyvKSCuLVMfLGuzV/7aanI?=
 =?us-ascii?Q?ikXySmdtiQa+4aP3Bftny3rkBMR0yFVcHAv2sKF3hj0CszcD9K+f0fJy/ZD7?=
 =?us-ascii?Q?zFNN+aN5imupS19vG9jWT5hCKLj4dFFIJmIjoxXw9caQ+1DChZaH0LgB7P9V?=
 =?us-ascii?Q?ZOS0HBUWmzvSgmyaH19q0oYyZxnYmxO3CDo1te4iblTwXP7521+O/SaWiP33?=
 =?us-ascii?Q?YaN3SpZOWlUBd8ajp6tg/8zxv39Zy/tSE28xLwxKSts9UiX2VE/CUOynzN0r?=
 =?us-ascii?Q?UkOowkpEaUClJw+oDq0Eph7ywl4ZnUzJkGx4nyyPlN/0+XSX3QVeHUdwue5Z?=
 =?us-ascii?Q?7bCHOxDd/4otfi7Ic73lObA9GNYUuEpNaUyq39xUC1Mrx+nrpwTaxF1SYFam?=
 =?us-ascii?Q?C3QFPkG8JZX1+HKRcPv8m1lAYSb0V04fsS0Mu14R5taI+Fv1/w9RElhCxcDT?=
 =?us-ascii?Q?NLMjlaWD15t2j+Jy4mbMtNNB8bB29H95lSNBEVaVxiBMCLmCUaryTsn2sAbn?=
 =?us-ascii?Q?4prF8xRV7WIUU094uXEmX29n9jHyKaywsdj1nBAO/w4M7j5Wy3sDpRuuXyzw?=
 =?us-ascii?Q?g1+Vy6OqTOElyNWBPyc6hlCzRmA+YPaCN0rgjh/SOk0XyOy1EaALSoPVDF5V?=
 =?us-ascii?Q?g08zPkzOmU8aLODn//pAzlbl7E0n3GEYGhkVBMRprkUYFVvw/auW0K0HDG3y?=
 =?us-ascii?Q?sdzoH0LLYVyXKHsoUeYJEOoS+JBgJbtvihuaYuZu+kVJQXfXpH3eTJ+dVbpT?=
 =?us-ascii?Q?EWDQykPhguc3ukT7VPxVe3IQjC9BR1QviUljohESQzfH3OgxnK/5luQytYTx?=
 =?us-ascii?Q?ljW5N/sKO/tY9dieFEl5Q+YbdS0ttIaBFLssrU2E5AzfSLvp8fBSAX2k0XFS?=
 =?us-ascii?Q?BL00pfQNT9v8ycG+v+NpXibDmYWATLTEwla7wgn5agY9UQR9DuViGAfARpnz?=
 =?us-ascii?Q?gN9z4RqbJ6FeKv1m0fcDiXiCpP5RzrpYmD5x/icT1W3cAph7r6nxxUUMxB5A?=
 =?us-ascii?Q?9GEXUXLrbFPgLRGu+4Mlne5DzhZPr2qfsj83EjtD+W0sCr946urqBAuLpQ+w?=
 =?us-ascii?Q?8ZP5hsepDSc+2vOQzkwAT38S9x+pfU6Dnp3AQBqPHVVJc1eXA1tCUVqenr4n?=
 =?us-ascii?Q?jXriRENLBmaQHyzAppEwXlDa3uiPY+Osts5/KU9dfh9pybv10BsvKLZ6PwHQ?=
 =?us-ascii?Q?9f5bavwDiT0IyMwwlNEB0yIzpL7CRE3vIIBZj5S98VZJnRv0t+YrYLVSwEre?=
 =?us-ascii?Q?ZKqaaBbGFoYpY5cZF2iUK2CNqa41dzG2oXwJT11SM/yRnNhpywtE75O6BmqF?=
 =?us-ascii?Q?dMGNy3TVZ9wjJa4HTgj0Njvc2JY26/BEfCG9YKlurYb9NfZXpn8PqRg9V8Zz?=
 =?us-ascii?Q?cP8DYqG3BGHp8QNgbhxCst1S+BYskLDj0Az8mS0ef3jB+x1CjtfJ3O8jKftp?=
 =?us-ascii?Q?x/PhETM/VS8b18GM59ZqySgesECjMKUFeU1e41HBZ9uMJe/ZkHnHNPdWiYnk?=
 =?us-ascii?Q?cA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a01851e-a0da-4a6a-433e-08da68faf7df
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 20:20:33.7313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uCBYacm7y7luEXLg4beZAMV+CnhMBZJqhpkksuIo2+h2sSXpVP+Tso7gXw+kMGwZ+vljqLwbLJFtvAISpZ9vVdhaq0Jf9RDzNo8jBt7zeA0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2717
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_20,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207180086
X-Proofpoint-GUID: 4zmvZTuu-eWpdPJ0sUIR0bVQ69jkyM0P
X-Proofpoint-ORIG-GUID: 4zmvZTuu-eWpdPJ0sUIR0bVQ69jkyM0P
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds a helper function xfs_attr_list_context_init used by
xfs_attr_list. This function initializes the xfs_attr_list_context
structure passed to xfs_attr_list_int. We will need this later to call
xfs_attr_list_int_ilocked when the node is already locked.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c  |  1 +
 fs/xfs/xfs_ioctl.c | 54 ++++++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_ioctl.h |  2 ++
 3 files changed, 41 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 5a171c0b244b..7a54887cc37c 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -17,6 +17,7 @@
 #include "xfs_bmap_util.h"
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
+#include "xfs_attr.h"
 #include "xfs_ioctl.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 1f783e979629..5b600d3f7981 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -369,6 +369,40 @@ xfs_attr_flags(
 	return 0;
 }
 
+/*
+ * Initializes an xfs_attr_list_context suitable for
+ * use by xfs_attr_list
+ */
+int
+xfs_ioc_attr_list_context_init(
+	struct xfs_inode		*dp,
+	char				*buffer,
+	int				bufsize,
+	int				flags,
+	struct xfs_attr_list_context	*context)
+{
+	struct xfs_attrlist		*alist;
+
+	/*
+	 * Initialize the output buffer.
+	 */
+	context->dp = dp;
+	context->resynch = 1;
+	context->attr_filter = xfs_attr_filter(flags);
+	context->buffer = buffer;
+	context->bufsize = round_down(bufsize, sizeof(uint32_t));
+	context->firstu = context->bufsize;
+	context->put_listent = xfs_ioc_attr_put_listent;
+
+	alist = context->buffer;
+	alist->al_count = 0;
+	alist->al_more = 0;
+	alist->al_offset[0] = context->bufsize;
+
+	return 0;
+}
+
+
 int
 xfs_ioc_attr_list(
 	struct xfs_inode		*dp,
@@ -378,7 +412,6 @@ xfs_ioc_attr_list(
 	struct xfs_attrlist_cursor __user *ucursor)
 {
 	struct xfs_attr_list_context	context = { };
-	struct xfs_attrlist		*alist;
 	void				*buffer;
 	int				error;
 
@@ -410,21 +443,10 @@ xfs_ioc_attr_list(
 	if (!buffer)
 		return -ENOMEM;
 
-	/*
-	 * Initialize the output buffer.
-	 */
-	context.dp = dp;
-	context.resynch = 1;
-	context.attr_filter = xfs_attr_filter(flags);
-	context.buffer = buffer;
-	context.bufsize = round_down(bufsize, sizeof(uint32_t));
-	context.firstu = context.bufsize;
-	context.put_listent = xfs_ioc_attr_put_listent;
-
-	alist = context.buffer;
-	alist->al_count = 0;
-	alist->al_more = 0;
-	alist->al_offset[0] = context.bufsize;
+	error = xfs_ioc_attr_list_context_init(dp, buffer, bufsize, flags,
+			&context);
+	if (error)
+		return error;
 
 	error = xfs_attr_list(&context);
 	if (error)
diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
index d4abba2c13c1..ca60e1c427a3 100644
--- a/fs/xfs/xfs_ioctl.h
+++ b/fs/xfs/xfs_ioctl.h
@@ -35,6 +35,8 @@ int xfs_ioc_attrmulti_one(struct file *parfilp, struct inode *inode,
 int xfs_ioc_attr_list(struct xfs_inode *dp, void __user *ubuf,
 		      size_t bufsize, int flags,
 		      struct xfs_attrlist_cursor __user *ucursor);
+int xfs_ioc_attr_list_context_init(struct xfs_inode *dp, char *buffer,
+		int bufsize, int flags, struct xfs_attr_list_context *context);
 
 extern struct dentry *
 xfs_handle_to_dentry(
-- 
2.25.1

