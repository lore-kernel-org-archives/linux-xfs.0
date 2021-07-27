Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64C93C4320A
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:20:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DF9261108
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:20:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235502AbhG0GUA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:20:00 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:49862 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235323AbhG0GTu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 02:19:50 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6HkJ1023079
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=K8/1r7HMYGqk1yYsUlSnIWER3NpsCLUmX/FH/8Ujzjo=;
 b=wb7I4fVuvhfOFVnArDKoZzB5J4+xDzClUpDmPZKRkmkSRn5ny/XVEOFpjkvz8gaPHeWy
 vY0Gd9Av3FncRZzcfsQY5XXIYmfiMlsJnMKy6kNeBE5sSCfoeo/obxDUBQSKp6CoYbOV
 dd9TI9Qtxj3yZ5BQjzROfB5JW110ngRCE3J+q0bg0XWA9CuHvxKYwEZzJgQQp2wLwQLG
 qfyz+IJL61zbiDjmx3Nm2G4uBt8E2qvFdwi03w7nkiEZKSLXCscbrjmidMucl8H5BSgv
 VcHDtuG0kKMLKLC8AuLiUAO9mGEBFMJ27im9FY9ddiIaoAtAi+pICZSLTGZhY/UDal+0 cA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=K8/1r7HMYGqk1yYsUlSnIWER3NpsCLUmX/FH/8Ujzjo=;
 b=obVNayKvTmnrmSbARdG1BcUnASRGYMAMxGntL9r6401Tt4c+1MXNPHcIX0kS9lxO+VD6
 QA9aTTVrX/FRV5GvwQ6d2FqApOjEGh2SSTevYcV2N6DUe0uu5Ad64x1N+v7PaDSD9cme
 oiW6PVvmSoTrPqVMBzNNWVhlfNYTuWhuHpvYpE8dKC4Jctu3o82uG5h4oIvC/xsu9gX2
 PrmBEuuPcD9yHUA/ZwinCaZ6Nh0KNvb5oqdxJTS+thQ6RSqcNp5DpTU9CE7MUdqqc5Kv
 Mu/eyDkwms3W2QVdKsf0cUdbdksgxwIr8fAYFykMkYww4VPFLzABGc2SnSCyg/KbuMB7 QQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a23538uwa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R6FjJ8114851
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:48 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by aserp3030.oracle.com with ESMTP id 3a2349tqqb-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sc9FML+X6M8NZ64y//k5kdAUFCdnwaLktO2Mqg0R37lOz378dYj97rm0tvq4OGS2JeKv9kxZ+SXBWyUL40FcOYvKa0YjruveJXASsTPQM9wu20rj1LeoeXVtPYWWCeI1SzdDG6hNGpKzoRlvQxAolHaxr8naSeEn9/zDpj1OnSGt02QYwBjT/yTaKoEsrlgTs/ctreMEhfbNDGSG34YjIBzOwvv2b2Y7+dMTsW75JzgXO+nhnUYbZF33xipGcdOtNsQBKabOhUeA82eK5Vm/7iO4wg51zcmN/nrnpER6vJlVFiLD6ggsdMbITNWsejoNCc9t3/hqV2yfeWkcf4F14A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K8/1r7HMYGqk1yYsUlSnIWER3NpsCLUmX/FH/8Ujzjo=;
 b=dK2s5icKHyUcHKvrg8ik71KjNpFGyTL/Qvu+box2lXqR9e+EQRju0tusQ2Sgb7sY8Fa33HCnprci1Y8x68OIFoW/tPCwWTL6rkq+eH9VMnVkwsNxn8QCB5eVsfslHIDbitBTLyGHs6AMGzkh8gurTFHyym5EMcalYElM30/dYCKReqGteGj1ZTOFHKRIiCrcrcUiSQe+qUFsBlGlB0ojh13ABe/M6RvYgqEo2Az8aP2HIYtCltJ0nV8onZ36DKlgqX7j58Bn5O+lAR6T7x0OQ8Dd0Qbi/NCOaBqjk7SZtpTmZVtw0dKRo6Wz2vJzsLUFdAoFecueZQVWNpoAfhBMcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K8/1r7HMYGqk1yYsUlSnIWER3NpsCLUmX/FH/8Ujzjo=;
 b=aKkLh10Hwz/HsB7hzytbbFzpFBupZkMlD+3kW+gliF1qkckGjvZlpt+axWjtmaVjWkq5BQBOF3Qrsb+wJ0sp02Uu/D4pPWHEava0jWCY+p92gsnlVM/ZbUFIFkQvXzyDo9kKGmZwjRhnhjgaC0HQPJg+m4xFl95k/tOdhOmuuCs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2709.namprd10.prod.outlook.com (2603:10b6:a02:b7::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Tue, 27 Jul
 2021 06:19:47 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 06:19:47 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v22 20/27] xfsprogs: Implement attr logging and replay
Date:   Mon, 26 Jul 2021 23:18:57 -0700
Message-Id: <20210727061904.11084-21-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727061904.11084-1-allison.henderson@oracle.com>
References: <20210727061904.11084-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0074.namprd05.prod.outlook.com
 (2603:10b6:a03:332::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR05CA0074.namprd05.prod.outlook.com (2603:10b6:a03:332::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 06:19:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2fab27b4-e9da-4862-8da0-08d950c6882f
X-MS-TrafficTypeDiagnostic: BYAPR10MB2709:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2709C9D3E18DD9E411C6032B95E99@BYAPR10MB2709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1265;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AMdDFZ7cgzAui49fngq+3g/FiSEdeEkptGKhEZkKlzXpuPZF/yW/1I/9EkkHPL3b5QNKCVXjbd6/jcE4zqy1EtlydMWUtFMm81wbmt9LQoXBobjXLTahtd+kFeeGMHt0/iVhsoNGqZriGBrHdQx0yrHJ8zeWCEWcB5KP/XdeVI5DPYsVcA/LubA9OL6MVcudxFxxRo1IfcVarz/+ng6fdeRY45nNvgMqGXUSpco2UzViyLhc/1rtSIWx1BJKWrqJJl+YOfY5Dkp/dtcvWZM1vkE/y5Wgs48wmppGF+caqCjP439WxD3dIirsNgVcD88oQe2Zw5wkGjbWO3gmdwaSHF/E9Y3gCwHCklS8d+xlK1GWRs+ClSUjJuPHaasrK8JoIw/sNoaOhyheYAl4AYOajG5MS+HfG4PEhKRgvt1nypXKc6RknLqvc3oKmWPZVizd+Vy0hFU5vPdiVDA3isgoK54uspQH6lowBVLag7BSxdQLMkRgAmXrd9JrB23O15Ctw9Fy3Oa90BhQfefcanHwxwnzsr+Xamxr/MT2xKnlh4R6Z53zLt1P6lQnTCMRhWbrRLBsYfi8zPUHWQA3mL4EffvAk9ifa+VbJRG+/ho8piR2ZW0CwDiNcmSjZmqEuJzaRwewfJCPQmoK31wzK5R5HW+w0lCI17F8x96LXdg0Mlp5iGTGnpuGfyW0nnePIYJNZGwRYNrWnS/dg7RPYJ5tNQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(346002)(366004)(136003)(83380400001)(6486002)(2906002)(44832011)(6666004)(86362001)(6916009)(956004)(38100700002)(2616005)(36756003)(52116002)(38350700002)(478600001)(8936002)(186003)(8676002)(6506007)(5660300002)(66946007)(316002)(6512007)(26005)(1076003)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qsXzmJkq9tLPO3JfG28TYzGRAKEQLag7Wl6HTWybjG9x6haFMga+Q3SpxzFR?=
 =?us-ascii?Q?ghwZZOqjVSigkScGry2ExNgrTPbJBk2f+BBzf31nd+eMzJaB/K6ntKfHut+a?=
 =?us-ascii?Q?ITItPfwDeiwFSJcOkfNARtW8a215W7yQa9UhJok1vNSZKhO/J7ykSo9EfW22?=
 =?us-ascii?Q?WSHasbQRUyloukxvZ0wXgdLW5SHYTP5uY6SEinI8tfM0P55r0/82ST5kJBGs?=
 =?us-ascii?Q?7uFIqACRIaFAx6IEz5SxFFrjlFGrpkt1kSUBqGUb4yY1w8oDlQgtveJNGS8r?=
 =?us-ascii?Q?vwtFbPGxMQ+yeNiqiuna5WbYVsmirqeeFVeCsAOopWJCry6HmhMTJ+IIiWFw?=
 =?us-ascii?Q?nHgCp5D5Z0wZVOQ/DSjJHQKjD7eV2lJIbWtXN5vxPLVmAOFiWeMgIDd9Bjh1?=
 =?us-ascii?Q?mVOWvpSUjPJlv1ku8QYLqJgzE7lldNeWLEFywk9jTi327jGoRqVC4R060rx4?=
 =?us-ascii?Q?saN0J6el1qBEejZZvCVUSUWvFN5K1xZuzY+T15iTJt7NEHuVlGAHSVchWWWD?=
 =?us-ascii?Q?a+B+iat4PW4cICRLj0TWZxaHL48ybYODpZLen4dMYx9waMhiS2MRXJMIIgOj?=
 =?us-ascii?Q?NNDDl2M34ZsSr4lvQQ2dtFSNfhRvIuxVPs7l0n4SpKte5ZVashrWQyEPgBUm?=
 =?us-ascii?Q?HJhggSeau5lzSr5E3ucjnac9zdR5ucpFHfbySF33syEByN6vpVHYFF9VFwVc?=
 =?us-ascii?Q?+YuDbKPw6ECf7EvqNdtbtL8dqNmxDv0K7nGVQ4E49nT1cIJ9GVr9bY4ubFhy?=
 =?us-ascii?Q?ZekN0N7vjBC8ALBvb+QQkHABvzunXeMJQ3SsrYxO4e8IG5t/ZuLTTuLSG4mU?=
 =?us-ascii?Q?4KgE4kQTmaqqRuFDdMQfZ831lD3lCfTcs/iYxzCBChUt2W8R+E9yVkLK6fhu?=
 =?us-ascii?Q?Q3lMqlett5PhISayNtFd+3nTWKVNjmc9PPW9TOa9o8u3fn+21uEZLVx49NQs?=
 =?us-ascii?Q?fnvltjHhz89v/K/fhjLgtm6yvXlxiQehhxQXq4UWrlf1b6B4LSdcsf0vhNy4?=
 =?us-ascii?Q?T0n68Uw4gHkbLu40TFu3jMcvTiFxWZeHvUxTx583NhBj9iI34FV0PfsYMNzT?=
 =?us-ascii?Q?YM99mRkrchPrNpzRTuMbayutbbPBGZpnsLvwfL6M60DDFnuso9gp8rXoZIU2?=
 =?us-ascii?Q?PtAtPu90zFV9Srfj0E+32v0mIo6vDYuMFvbVPfKsjk7JfH/Rs1WCykNKor5E?=
 =?us-ascii?Q?SyrkTd6b5kploMHpcA1hwKPpXMyHIU97g6GSUA6ijISGduYYuAJ9LMaAo1oY?=
 =?us-ascii?Q?ty//H691x/xcMtTJ5L+ubnqCi83q0uDYWnOO6QpkUGbzsl0bI2rffc5FfVVZ?=
 =?us-ascii?Q?qi/BeKKuhi95+ZnTMw2m18um?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fab27b4-e9da-4862-8da0-08d950c6882f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 06:19:46.9902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eTA+hIyVFcbFPRJ983b92GE9H+fezbcrQqBTeU3yqbO2lmV09hVckdGjo6+q5ss5eXrIiO9XlAO2dIZTd75wYqb7UVwJ/oFTTJujVBthOmI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2709
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270037
X-Proofpoint-GUID: D7xrgZcgEVO2TEojZA92rUWrJ1C4fhda
X-Proofpoint-ORIG-GUID: D7xrgZcgEVO2TEojZA92rUWrJ1C4fhda
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds the needed routines to create, log and recover logged
extended attribute intents.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/defer_item.c | 137 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_defer.c  |   1 +
 libxfs/xfs_defer.h  |   1 +
 libxfs/xfs_format.h |  10 +++-
 4 files changed, 148 insertions(+), 1 deletion(-)

diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index a1f0d7e..f144ed6 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -116,6 +116,143 @@ const struct xfs_defer_op_type xfs_extent_free_defer_type = {
 };
 
 /*
+ * Performs one step of an attribute update intent and marks the attrd item
+ * dirty..  An attr operation may be a set or a remove.  Note that the
+ * transaction is marked dirty regardless of whether the operation succeeds or
+ * fails to support the ATTRI/ATTRD lifecycle rules.
+ */
+STATIC int
+xfs_trans_attr_finish_update(
+	struct xfs_delattr_context	*dac,
+	struct xfs_buf			**leaf_bp,
+	uint32_t			op_flags)
+{
+	struct xfs_da_args		*args = dac->da_args;
+	unsigned int			op = op_flags &
+					     XFS_ATTR_OP_FLAGS_TYPE_MASK;
+	int				error;
+
+	error = xfs_qm_dqattach_locked(args->dp, 0);
+	if (error)
+		return error;
+
+	switch (op) {
+	case XFS_ATTR_OP_FLAGS_SET:
+		args->op_flags |= XFS_DA_OP_ADDNAME;
+		error = xfs_attr_set_iter(dac, leaf_bp);
+		break;
+	case XFS_ATTR_OP_FLAGS_REMOVE:
+		ASSERT(XFS_IFORK_Q(args->dp));
+		error = xfs_attr_remove_iter(dac);
+		break;
+	default:
+		error = -EFSCORRUPTED;
+		break;
+	}
+
+	/*
+	 * Mark the transaction dirty, even on error. This ensures the
+	 * transaction is aborted, which:
+	 *
+	 * 1.) releases the ATTRI and frees the ATTRD
+	 * 2.) shuts down the filesystem
+	 */
+	args->trans->t_flags |= XFS_TRANS_DIRTY;
+
+	return error;
+}
+
+/* Get an ATTRI. */
+static struct xfs_log_item *
+xfs_attr_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count,
+	bool				sort)
+{
+	return NULL;
+}
+
+/* Abort all pending ATTRs. */
+STATIC void
+xfs_attr_abort_intent(
+	struct xfs_log_item		*intent)
+{
+}
+
+/* Get an ATTRD so we can process all the attrs. */
+static struct xfs_log_item *
+xfs_attr_create_done(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*intent,
+	unsigned int			count)
+{
+	return NULL;
+}
+
+/* Process an attr. */
+STATIC int
+xfs_attr_finish_item(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*done,
+	struct list_head		*item,
+	struct xfs_btree_cur		**state)
+{
+	struct xfs_attr_item		*attr;
+	int				error;
+	struct xfs_delattr_context	*dac;
+
+	attr = container_of(item, struct xfs_attr_item, xattri_list);
+	dac = &attr->xattri_dac;
+	/*
+	 * Corner case that can happen during a recovery.  Because the first
+	 * iteration of a multi part delay op happens in xfs_attri_item_recover
+	 * to maintain the order of the log replay items.  But the new
+	 * transactions do not automatically rejoin during a recovery as they do
+	 * in a standard delay op, so we need to catch this here and rejoin the
+	 * leaf to the new transaction
+	 */
+	if (attr->xattri_dac.leaf_bp &&
+	    attr->xattri_dac.leaf_bp->b_transp != tp) {
+		xfs_trans_bjoin(tp, attr->xattri_dac.leaf_bp);
+		xfs_trans_bhold(tp, attr->xattri_dac.leaf_bp);
+	}
+
+	/*
+	 * Always reset trans after EAGAIN cycle
+	 * since the transaction is new
+	 */
+	dac->da_args->trans = tp;
+
+	error = xfs_trans_attr_finish_update(dac, &dac->leaf_bp,
+					     attr->xattri_op_flags);
+	if (error != -EAGAIN)
+		kmem_free(attr);
+
+	return error;
+}
+
+/* Cancel an attr */
+STATIC void
+xfs_attr_cancel_item(
+	struct list_head		*item)
+{
+	struct xfs_attr_item		*attr;
+
+	attr = container_of(item, struct xfs_attr_item, xattri_list);
+	kmem_free(attr);
+}
+
+const struct xfs_defer_op_type xfs_attr_defer_type = {
+	.max_items	= 1,
+	.create_intent	= xfs_attr_create_intent,
+	.abort_intent	= xfs_attr_abort_intent,
+	.create_done	= xfs_attr_create_done,
+	.finish_item	= xfs_attr_finish_item,
+	.cancel_item	= xfs_attr_cancel_item,
+};
+
+/*
  * AGFL blocks are accounted differently in the reserve pools and are not
  * inserted into the busy extent list.
  */
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 1fdf6c7..06df7ea 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -174,6 +174,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
 	[XFS_DEFER_OPS_TYPE_RMAP]	= &xfs_rmap_update_defer_type,
 	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
 	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
+	[XFS_DEFER_OPS_TYPE_ATTR]	= &xfs_attr_defer_type,
 };
 
 static void
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index 7566f61..58cf4e2 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -19,6 +19,7 @@ enum xfs_defer_ops_type {
 	XFS_DEFER_OPS_TYPE_RMAP,
 	XFS_DEFER_OPS_TYPE_FREE,
 	XFS_DEFER_OPS_TYPE_AGFL_FREE,
+	XFS_DEFER_OPS_TYPE_ATTR,
 	XFS_DEFER_OPS_TYPE_MAX,
 };
 
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 5d8a129..f062766 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -485,7 +485,9 @@ xfs_sb_has_incompat_feature(
 	return (sbp->sb_features_incompat & feature) != 0;
 }
 
-#define XFS_SB_FEAT_INCOMPAT_LOG_ALL 0
+#define XFS_SB_FEAT_INCOMPAT_LOG_DELATTR   (1 << 0)	/* Delayed Attributes */
+#define XFS_SB_FEAT_INCOMPAT_LOG_ALL \
+	(XFS_SB_FEAT_INCOMPAT_LOG_DELATTR)
 #define XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_LOG_ALL
 static inline bool
 xfs_sb_has_incompat_log_feature(
@@ -590,6 +592,12 @@ static inline bool xfs_sb_version_hasbigtime(struct xfs_sb *sbp)
 		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_BIGTIME);
 }
 
+static inline bool xfs_sb_version_hasdelattr(struct xfs_sb *sbp)
+{
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
+		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_LOG_DELATTR);
+}
+
 /*
  * Inode btree block counter.  We record the number of inobt and finobt blocks
  * in the AGI header so that we can skip the finobt walk at mount time when
-- 
2.7.4

