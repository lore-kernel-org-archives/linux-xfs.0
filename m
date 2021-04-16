Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 070BDC433B4
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:18:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD92C61166
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:18:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241319AbhDPJTC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Apr 2021 05:19:02 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35038 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239944AbhDPJTA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Apr 2021 05:19:00 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G99g7x026244
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Qmv/kUJZBgyPYv/BSQbHpRIxDuNKwrXgo9t8HQbjkmg=;
 b=fZ2Q3/lAklFWw+gx1fZVDltuQ7KFsMJsso0LYPfmdWClVVa1Ach7rCeeikZnDiKRHIWS
 9WjZSvVIUrq5BRbr+9mtUewi5zNccv00kyy/IcLZdGxKlv04BJMckgSv15uYSqDv+Wie
 OxhphcvSMLrKczzFECRsX1BvEJ4gCW7KC/FZSNBBeI7WBmgN/EIgo6JBU7YVWjSH8Ko6
 exk7FSj5iC6+dLhUDa7iYw0d7PXxUW3ExjtRGO9IrwijWL48XTsyU8sbqxIZurZg3DTF
 4PhuvFeSL6psUU6HzpeMOEuBOViCqYP3p8JEbO3hlc8cB1PWC6chdTyoNPwS+nxrWDpN 3g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 37u4nnrh8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G99dBN182009
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:35 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by userp3020.oracle.com with ESMTP id 37unswy4uk-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RoS+REZgvwZA8hLG0ISS/X1N2/RDpblEDTVQX+pFdYsTxukvSeTaLi6dGAXRdJUT61rfAPKfe0/ZHm7e6Wk3jrM1yqOKSMh3tPYZBCipD7jSKUC/hCFwlwSz/Y8Jn57a1HJqucCl26kR46eNY3vCmJseX++huTTJlblgqO9mljN8ppONptxf3D1r454ucSsXrnWj0b/uKvY/TODlXgw1Pe2oN2pjcCl7Gtdqa5TbbMpIubPgq2iDENSBSTgJuCQOAenkchyYaGxBVMQApHTL8XDb2G7aRhxBTFbHUeKbkDNLnENaWYJJnT4GnFxFT6ajPM8OmM54ZIxwDec8UPbZiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qmv/kUJZBgyPYv/BSQbHpRIxDuNKwrXgo9t8HQbjkmg=;
 b=a9eXh3/BLHmqqfbgJtcBsDjKQyH04zevuK6w+hAVjT2+Q9G5EKmOw6LNZHaz7jXR9pYJ6tnh3TBjN3iRHbXkOFVQPxasXSGd5/+mngGt6SF4ZuGy+dYCHOkzKl0ONO8FuzvUXZf9HU2MN4AeabGm939hXHarSdvEmErCCtMSUy1QEHxaW3BBekiQhzyFHsQeHK8gsTsDlnEz5Ju50w7XpqwsFnR9QXzSEDSoRvxEpAnrL6sYFlzkKAVSOwDZjBLbTiRScP++CWwdUmYpjE06++iA2seuLLcjS7Y7rZEcYCPocO9CAW+x6DKe13Lr0Tz1wRGPu6vIPOBlTonNEXLARQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qmv/kUJZBgyPYv/BSQbHpRIxDuNKwrXgo9t8HQbjkmg=;
 b=M1PKtY0cnFYLguCC4ouF93pCBoq7sjd2oZ2qsrUzipip4r6+ivdR75apJ2DpT6N1VrgmJaZ4tUYaRmSUGPAnw79O3qY2tx+6N2aC8AgXyovL1WeHIFyNvDiKAzmKlUY4SIhB+UZmmWW+gKkPhdYklX0nJiBYJk6CdlV7ZKsaly0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4800.namprd10.prod.outlook.com (2603:10b6:a03:2da::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Fri, 16 Apr
 2021 09:18:32 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 09:18:32 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v17 02/12] xfsprogs: Reverse apply 72b97ea40d
Date:   Fri, 16 Apr 2021 02:18:04 -0700
Message-Id: <20210416091814.2041-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210416091814.2041-1-allison.henderson@oracle.com>
References: <20210416091814.2041-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BYAPR07CA0070.namprd07.prod.outlook.com
 (2603:10b6:a03:60::47) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.222.141) by BYAPR07CA0070.namprd07.prod.outlook.com (2603:10b6:a03:60::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 09:18:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b720bba9-f0be-40a8-4fb4-08d900b89aa1
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4800:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB48003A2B983609CD675D162B954C9@SJ0PR10MB4800.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:644;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kIFuHj0Ia1PdykKCzmVNeT7SFpLfeZBdG2l6QyB0FMUNKHzOyqeYgJCT8e+f7j9+KKjmSsRSVD9sWM08HTtXhIMAEdXnOd+ZPANDbSoYHAnaohRst08vuXJlgScim4kd+U8ap5v8PtPBkfdI294L1QwZwF6AQ/Y2TVRRn34Yv3u0H3O9R3K0RKbA97gkJjwTTVWp5jsrUckSx6+TSe+gLQy68lPjHC/D4IJ/f673jzaOnMPGa9RAnp5PPliKyX0KiOMT9vmKI+yATEYs1oBKKQm0XJKALzDfUOmMKNnmB0AmFxl1dHZULSg3/3sMWUCOW4gmkYlDvsFSbbQwIeyjQYkxItKtEoUF1hxyI2ZwSiEcTZlIiO+k9jkrpJeZktp+efTdJUcHloP0rll4NW/2dnPew0Y3tJR1Fcke+t/tUzwI8IwfmzeeCzNf6c7oM1mvLVagPI2H8I39Px0izTHK8BXOwAJmZ3sOiFis/dBDqFqxyBkmZoNrtFpyjbeguxuzJf6DPRDe6ZZU5Lnjc2VFUijPO6c+QxMOi44jmZrcJX45SdKxqbEEg6XlAdR1S0C3C4CDpDjnwd/wzhE7DvZ+w1r7zpjj0wi+iAmNj3j7Jj8znZC6locBHx63oVXdqbkCxVuHr7aLjz8vWP9dRAaADujioesp3F6UNp1e6veIObx437qpT8VbcpnL/IAIWLdp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(366004)(136003)(39860400002)(1076003)(83380400001)(6506007)(5660300002)(16526019)(186003)(508600001)(316002)(8676002)(6512007)(36756003)(8936002)(26005)(66556008)(66476007)(69590400012)(44832011)(66946007)(38100700002)(38350700002)(6486002)(956004)(2616005)(6666004)(2906002)(86362001)(52116002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?OMJs2Yi5J2O84g7/F1D4dnROL3jMyUF7rnKpU58YQSd6BXDonr5GupphIXZs?=
 =?us-ascii?Q?3ophD5O6FW6jJ/YEX0sYmg6K/GIELessyCs+7OvbjD4VDDURJeGym1Qa/s7V?=
 =?us-ascii?Q?/NAIZgugu8qq12gH2MiXhXjzQ2QvIVGrsODCPsYc/FDMkDqm+WopmJ6Dn2Kn?=
 =?us-ascii?Q?KRjrNqfFngRFeNflWkd+mokrA1V9z2cVFpZxxozr9WNT3ns6P1FptTYn0LKB?=
 =?us-ascii?Q?Ryq1RsnmCNiEjzFhFyvt3VYN54oUt+DVSB/Ga2wcRX1XBcO2C1xYYiNbTMQT?=
 =?us-ascii?Q?SENj5G3xPW8Bkz87b88f10cMcI6mOZ7b9zjcOEXJuQqm/JRJy1XEqUK0dlMC?=
 =?us-ascii?Q?nBSnAx7lYmmJ+kG8Q1AUt3iJKisdzuwVVn+xKOY1Fhv7ZVkmiug4AwSOzZJM?=
 =?us-ascii?Q?PbvH+G8yAEwRp5L+ssvt/J/mohGS44OOGOYcw4TOmyY/kxYlMW8G7PbjoQhx?=
 =?us-ascii?Q?m7t2C+4M10Ey8zMrjtWszLY+phc4lqm5pihHJHv/h4i1bDUWVdCsCoMKkQBO?=
 =?us-ascii?Q?TZjWFDAcihNavG7mGOPmA3HE2KQitti5LmAUO+OPjbh7nm4oFp3ySZkwIdKD?=
 =?us-ascii?Q?PKWL7p2rjyWsDsjwyRAwlbhk20R2wWxb2i2xHeA1NBTNfzJWwzUEDg8O203F?=
 =?us-ascii?Q?QB3b/onTn536BqgixYTeJb9DP0qPK1CppDUgE9Hh3ERae0xh2R+OYXhB62S5?=
 =?us-ascii?Q?juRVbAVlV1ywHZuuJgbCUOGFAj5TrNu9Jw886YA3rL+M1cPVqXPegfJFUsyJ?=
 =?us-ascii?Q?wFZX2I2Yc2AUhk5qYWgIS7d/yryyO1OFS5YfPe/MT78w3mpXHNiWpmauYsLo?=
 =?us-ascii?Q?67jtmPqpTZUtNefrZVdohAwJsEk/IuKVLNkG9ZKdqKGXtSt0XpIkhmsBvFzL?=
 =?us-ascii?Q?MTSRfYW1X3BztwoVCOgF/NzlsgElokI2SpDHYSCNbOeohG8djPFSfCYtW770?=
 =?us-ascii?Q?E+/xxVVdTGAt6mHQRZL+euu2+wNYjvQzmGKJwdEx07+kYbZITDu1sE6jqyq3?=
 =?us-ascii?Q?zM5StbvZA5WPS5VfKseIeVGYrDgdUyr3omTVvVs1Q7ZBzxkqpg2ssN12ZN7T?=
 =?us-ascii?Q?Mf3qz1XWCf55Xo8vTAHgB1e1XQIramOTc+6MBhnbYKpv+KjzUVUO6BX/gNnO?=
 =?us-ascii?Q?3br3uo+sboa1DaVUP+TWodQZfmIfu7vGft3wm3NAJnsyKp9pjwTkBxAQzite?=
 =?us-ascii?Q?EVSF7PRe6ky1nL6fy3tVFOESpK+VJUppUQ08CMhLLDc98SkDEuDzZCU1Ij4N?=
 =?us-ascii?Q?AuWhTlXtyO0hzgV/+PLdj/K+8Mb13KICXK43SNUKGK3FGzxp1w4wwWy6JIAg?=
 =?us-ascii?Q?0pcBM8vTw1ZFEh6buzcwA8BR?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b720bba9-f0be-40a8-4fb4-08d900b89aa1
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 09:18:31.9733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZCn2tanUhjVLE7jyYHmsHfLugWxnkcpjp0/Okq8sftmLDUt1g44C2H1RuR2k7apydNkregr9xqSyCrNgkXNS1v0ysN6fQO4Bsyf5edQoso8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4800
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160070
X-Proofpoint-ORIG-GUID: i7S6D5mXgiRK94-8oewd-8fXsitzLNMm
X-Proofpoint-GUID: i7S6D5mXgiRK94-8oewd-8fXsitzLNMm
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160070
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Originally we added this patch to help modularize the attr code in
preparation for delayed attributes and the state machine it requires.
However, later reviews found that this slightly alters the transaction
handling as the helper function is ambiguous as to whether the
transaction is diry or clean.  This may cause a dirty transaction to be
included in the next roll, where previously it had not.  To preserve the
existing code flow, we reverse apply this commit.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 libxfs/xfs_attr.c | 28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index f7ed4e2..c356238 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1202,24 +1202,6 @@ int xfs_attr_node_removename_setup(
 	return 0;
 }
 
-STATIC int
-xfs_attr_node_remove_rmt(
-	struct xfs_da_args	*args,
-	struct xfs_da_state	*state)
-{
-	int			error = 0;
-
-	error = xfs_attr_rmtval_remove(args);
-	if (error)
-		return error;
-
-	/*
-	 * Refill the state structure with buffers, the prior calls released our
-	 * buffers.
-	 */
-	return xfs_attr_refillstate(state);
-}
-
 /*
  * Remove a name from a B-tree attribute list.
  *
@@ -1248,7 +1230,15 @@ xfs_attr_node_removename(
 	 * overflow the maximum size of a transaction and/or hit a deadlock.
 	 */
 	if (args->rmtblkno > 0) {
-		error = xfs_attr_node_remove_rmt(args, state);
+		error = xfs_attr_rmtval_remove(args);
+		if (error)
+			goto out;
+
+		/*
+		 * Refill the state structure with buffers, the prior calls
+		 * released our buffers.
+		 */
+		error = xfs_attr_refillstate(state);
 		if (error)
 			goto out;
 	}
-- 
2.7.4

