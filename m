Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70B7FC433F7
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52CB161A3C
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbhCZAcH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:32:07 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56908 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbhCZAby (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 20:31:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0OLKc057422
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=FhvOhACCM7yV3+0cg1jGtjz1cKc9cjYkbJ3yHNpF6uQ=;
 b=OU1iLe5rC3Df0k0etlYDSLKqX9LidKadDLGG6pZUET+OCTBCJbAg2dnqOgRaZknMKCZI
 Fh/se0TxboIq9o58g1vYb3EammT5/ZKomhxNTh0biQGCtnyEHVICo7xTF3X78jqobSwx
 mfCt5O9i0bnrY/MXqIkDSHDBoLkOKmKbK8FEwhA5qN3EUjF70P7fNfwXViQPGkreWfFU
 vFTP3TWl3QBMQaTSIe1jbr6WItyuTlvNxHBO7Q1v86Tj1A2UuAmCgwPqmhDM9VF/IuKr
 VdX0kMrUOnOZIerkR/J8IDGK5vdE4gPbpvjtoTQacuxXGhepEVl5WqRBc49jvOPiImaW zA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 37h13e8h4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0Omus009664
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:52 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by aserp3020.oracle.com with ESMTP id 37h14mft65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q2NF8Q9V5P4SREbGn3HA3dLqMooJANSTmkFOZW8rMndMb3Haxx/Rag7nzYFflf89QycftH1GqqQkziOkbDu+4iEON1f117iZMSOfMf0Co5/9tuPfr+/RyKKDIayJxt+LgnZ6t3AQxiR1K/q7wdNK9Zh8D/bR5KEE2IQPt7wrjyKn1jgImbAxx13s9IyIScJPxz2A+jCPWeRKMERpzhGPIXpeGPjOKOKyNIIHcVghsgtDzDXCiEqbIILVUIwrJig/xrzEm0fRIa4+/o4w4OZzA0j+IeuRHWvhwJxmFRf/moEbVU5vhPLRWDMvWNYadR7fU4eIK3diqXtWioUpCRkVsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FhvOhACCM7yV3+0cg1jGtjz1cKc9cjYkbJ3yHNpF6uQ=;
 b=YfOZwgkE7Q3Gn1VbpyZWctA7gzHgzN7pNu+rD+M6TmFFxRaoGOKcCOD8FuUzmaPccxXiI/nqkeZEs+/Yctqebje7k7OZVpTpbkzWxhrG9t0ytcEYc3mbwlaCIVVr89TRbbaDT1GYbv+OnlKXQafAdZq4nJD3/g8srlwaaWuqq9utE0qANWU3kSNzsZEDjo68W8MYGkT6Rbfv5Qt+kMtmJQ1BsaEYeVqGsV9Z+g67A7C1iZlPcRnCStcTkSkyGN/9x/nACnvymmxFrACdJQ3m84YUpoImopZQzV/T1SmUrmLVq9Du9A38VPyva1P70lNECr3+5j1wvf4oujSmXHOswg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FhvOhACCM7yV3+0cg1jGtjz1cKc9cjYkbJ3yHNpF6uQ=;
 b=wsm+6Tn5yNLLAhpjqCI/8emszyOvo6QVxKmQBM9BBTQngm/q7NAsLiF2BFx3tIN60hFDTwEymCABpRQphGKn1uKyXqMli8kkrQKvT6+kM2Jdw5XcLQ9xq46XdsOOBUdEhZPjdLFqOWcpaPM5lP2ObSlmM1PIiJh1h8rjoSP7obU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2709.namprd10.prod.outlook.com (2603:10b6:a02:b7::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29; Fri, 26 Mar
 2021 00:31:50 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3977.024; Fri, 26 Mar 2021
 00:31:50 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v16 22/28] xfsprogs: Separate xfs_attr_node_addname and xfs_attr_node_addname_clear_incomplete
Date:   Thu, 25 Mar 2021 17:31:25 -0700
Message-Id: <20210326003131.32642-23-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210326003131.32642-1-allison.henderson@oracle.com>
References: <20210326003131.32642-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR07CA0078.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by BYAPR07CA0078.namprd07.prod.outlook.com (2603:10b6:a03:12b::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Fri, 26 Mar 2021 00:31:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c19a18ff-29ab-49df-9f68-08d8efee8bf0
X-MS-TrafficTypeDiagnostic: BYAPR10MB2709:
X-Microsoft-Antispam-PRVS: <BYAPR10MB27098A75F0A097956C21F4BC95619@BYAPR10MB2709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:330;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JiGEoGyTbWGPgwXtrzywEXGrccrIJiP6iaZ0E+iKSQsEza0i7Z9N/BkiRTWWo7pW2mRmACDDNIGLUDqjt6yWwiISVvdY1wOQ3p4ZFluQ5ydBWsKRJyUyqp+rwIzECn/Crf+ZnIKJUE+tJOPn7htjfCF7JlKjny5dHssYrISLPhUOctUvBMScn9IHEyC3qSldSSLPYfesSshY16OyXXEmCGzzn6hRb49Ms/6KyM0y5AYhQAH/HwgKmelfRauorPBHHapy+b+qpU0tMsrLQ71UFQF6vGzuTWqXhTDb/fotZCas1FRTptiNbpJW5dwYmklM3y/FeogMCHU7/pF+bHST09CHwFGuXaKqELF/nXHqxqPIFWjmOGWOJcyT3TIu76NrwZoz7GHnQ+46HRhTvZwCqLg5ZTfmjKXL50cy1TICoETZSZZxf2v7701Q1qryjNUK6DOEGY3J3Zr+Y3GYD9qiYJXfzJ/R5wD1cQ49ldbAOo0MMUBOD32wSI5dqAMU/DKNxFhUXXjvhauRTer99ijQW8JirMeVORpzdG/eJR3bB7n26ddSpFdeK2x3xJ7uaoioRHf+UU+Q3/AcMQz58AZLobVVGgceU4VBeedknPED1WO6KWUKSKYq9KPDCqkTS2V+nSzwyPCriAM7FrDo02va+jcVClROdURzBG5H5XXpev5LzLNkuB7h7CF5YtPA+3w5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(396003)(346002)(366004)(1076003)(8936002)(6506007)(2906002)(6512007)(6486002)(52116002)(6916009)(5660300002)(8676002)(36756003)(66476007)(66556008)(69590400012)(86362001)(38100700001)(66946007)(956004)(6666004)(316002)(2616005)(478600001)(44832011)(16526019)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?3yAn6y+MuAoOUieSs305bsWw1V/NZeNFf0I5TIYlv7SvZ0jCPPVW0fJRhk/7?=
 =?us-ascii?Q?EjFhr8RY2YSDaNa+KPehIztQXjbOsHoP/fn6lqMflsE4DwEHH24IMDRBEel+?=
 =?us-ascii?Q?9RvqWo6iLnfSzWp+3P72PRouclj9L+j0ndfRRQPQIXZdfAINn7O7rGNQz8rZ?=
 =?us-ascii?Q?FGS1Wo/ZnJEbaaiDn+mNiDATdj6mWwcd6RvSCsTkpqTAYImXNWecri8ruhM8?=
 =?us-ascii?Q?8zJXKG7r8l4hIV81M7qbMiymKGR5W/o9d9wJ1ifv8t0Mnr9RVq7nM/gBEX8K?=
 =?us-ascii?Q?HgzIqaoeNl7Pjw+NRMkeYg4eD7BHgX3CgnCqm5XBa8ltr7F8ucuCYW39tfE+?=
 =?us-ascii?Q?yLCSZXQUINoVbr/EuCf1LgSXN+Ovay9/zFBsbZvoikz2fQ/Qa9zzI/Z+vNdS?=
 =?us-ascii?Q?5a8YPAkm+7z2agf8k86wZ9KSKrysW0DWND9G3dt74gz965WMSep0Nw2IDyyO?=
 =?us-ascii?Q?Hv0tnX9MbFkyLd5H7wVPF6A/Xx1f0ve1qGlnlAfAYrgR4SlFHnyoAg9ggQCJ?=
 =?us-ascii?Q?LexwDF1cmGFSkBdL8S4x1tp1oUeDNoLe/bx6WiifF/DYo/jfWz+8OOfVacAT?=
 =?us-ascii?Q?l5B8joBZNVKXqrJNVZ8xcaSXMCFkM5qT5IY/9ETleHPqjxGQ+JI46WIklaDK?=
 =?us-ascii?Q?+JAuA4XNyN0Olg7VmBNijdBwWBR9sQ88TcohFF72L1tdpz9ORthCuMHJnFph?=
 =?us-ascii?Q?OODlHdEz1SdZLa+6wc2jgBkPRWZI3Ct+8velfd2q63ykx+pwfe+AoiPVZeNf?=
 =?us-ascii?Q?r3NCvOCm8HFn5t3DxF8BFG6JG+FO8kUd8sp/S2xwQh+iC2CEmltBd0ROjCCC?=
 =?us-ascii?Q?iDIfP4LXqfGtzy9XsyK8TILzCoI/N/FZMKE4QnqkmC+7eRCfazQzBq72VsLN?=
 =?us-ascii?Q?YoRW91RerpHmnlvOfZeD2gj4v6zjizmSsWmIuxoGiTJVy6RGyHRmqX+jZyTb?=
 =?us-ascii?Q?vcKmKR4POEWXm7BAW7QFnHOfH3WUK6MpSehqkLzWT9S8gjAgD8AVy5rUbZ4c?=
 =?us-ascii?Q?n0JQseSrjWogvplPK/vTkRh1owwTnxmS6MTXcwHY9FsGBDo8dqznWnoZXSn4?=
 =?us-ascii?Q?LqFtdjWubxqiSj7wKGti+JwOLSyX9SWg5bEFWY2gonoV6WRwkebLqMUybUzG?=
 =?us-ascii?Q?8i4mhsdL2NqF04im9XHUgr8A4XnNC55wnZPDX4rqGy3Nf5co80b39RruioBV?=
 =?us-ascii?Q?k6ZOV+TYDNgod3Grm7B0kBXEzni5xYkAzzS9f3k+1iQsEBjv5e4eGGdQsUIt?=
 =?us-ascii?Q?I2KERaJYEqgAZsPUTdvD137FiWEr0TWD4fd7Gh4mCVgFEPzlXagnwJqRj9u2?=
 =?us-ascii?Q?Z6CYfZxMbsrS3CNKnrOZEm/1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c19a18ff-29ab-49df-9f68-08d8efee8bf0
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 00:31:50.3127
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GslLI35/2VGLDQpzhCGPvqksCvcbhknxNda6100DmF28ZNPffY5uTxutZrUHl/sKxyedOMSMgcdak9RUpMYO6yVL1PEngnbDKe8wGm/QMrg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2709
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260000
X-Proofpoint-ORIG-GUID: P1W4Y5w8apB7LtLgjrawYWjB4EDzJa-X
X-Proofpoint-GUID: P1W4Y5w8apB7LtLgjrawYWjB4EDzJa-X
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 lowpriorityscore=0
 bulkscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 impostorscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 392a7ea8080e3753aa179d4daaa2ad413d0ff441

This patch separate xfs_attr_node_addname into two functions.  This will
help to make it easier to hoist parts of xfs_attr_node_addname that need
state management

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 libxfs/xfs_attr.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 1db60ef..e1d37f9 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -54,6 +54,7 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
 STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
 STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
+STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_da_args *args);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
@@ -1074,6 +1075,25 @@ restart:
 			return error;
 	}
 
+	error = xfs_attr_node_addname_clear_incomplete(args);
+out:
+	if (state)
+		xfs_da_state_free(state);
+	if (error)
+		return error;
+	return retval;
+}
+
+
+STATIC
+int xfs_attr_node_addname_clear_incomplete(
+	struct xfs_da_args		*args)
+{
+	struct xfs_da_state		*state = NULL;
+	struct xfs_da_state_blk		*blk;
+	int				retval = 0;
+	int				error = 0;
+
 	/*
 	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
 	 * flag means that we will find the "old" attr, not the "new" one.
-- 
2.7.4

