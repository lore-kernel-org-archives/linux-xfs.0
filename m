Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52B42C433E1
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:34:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D65A461A0D
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:34:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbhCZAde (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:33:34 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:39306 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbhCZAdX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 20:33:23 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0Ol6b066392
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:33:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=wZHHIINaGVjD+KW9VQdtpsunANMAZFXluaGiua2U3P8=;
 b=mCSFSslpwUPINjK0LUk1rk6U8Nk9qASiC1tvduQlyxBV5rgynLY+ntJkp7MSnF6wOtJ5
 LS0s91MFbvpMVIbU3YnV3xuyqtZE+3MhryV99N4VfG2mpoHWf3z9IIHYPhdnV4oysCEc
 zUDzS6qzuAkGzBoiu0p1AOLqQBa5u+N4wXX5Yj+0o7lm18kCyv5qm/UdnUul6QRzfHzg
 zeSFGgNH/XwvPhqcTa8//Z3SQVOfFJIiUerqJrJcx5sX8Sk+0l8b+nHvk2AfyufgQnEG
 KHwUBUjX422CC9f4gOZ2Tuyd4hx12QxL4O/x1N4iqTUsBQ/iuo0dOmpSdPwtnFLw4XhA MA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 37h13hrh79-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:33:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0QXn9076081
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:33:22 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by userp3020.oracle.com with ESMTP id 37h14gg490-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:33:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hKuGB8qm5wP4myEEIjTqlnHLLshVibIJDSzKNQqlJuPFXyDCzSkwvbj55GzskQyzrNQDtzUFLCfcviRolYqvlHKQICEYGS7T+h6xsJWZEe2Z7JtouKNmweuDuHEz/sGhgyX5lYhLONhEjVqzVEMwx6kkwT7ekKE1bKGobdCmZnCVtcO1UTzjXMj6hv/CWQJ1t0hS7wuPJQgtse2SKFGAyaQHiFjYQgkDPprT/7nxOUSTT/JCdCtP/chOmR36jdrt4h2qzUZRv9PMAlky/agx9+ecdSZaEaZwzDc0jqkHOCjKxj2kxtKbeSC0Rh7oWFw8lAsSx3DkWWc9zfjlZYNxdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wZHHIINaGVjD+KW9VQdtpsunANMAZFXluaGiua2U3P8=;
 b=CElf1+IY5XwBlJHL8GGZ182xYjartRpi6NdHOXgkquk8cVdbgz9MUtaL4rT24lnGwm4srQiysboTzcNcCbJ95HV0lwBXrOuz5dPB8Jq7zxTr2Wn4BOG8fePhifQFXwCRznpt8/rrLsdh8ItMJ0btm4qmeeVVDMVFrtAeih0BYqygiAfQe8SNOuXMRMWzuMtUkSJTjgcdQmhGmqhTqKma0KbX50IEZLv/qcmYqjxqVdc8N/HilHSRhN0kXBgxlVbCjjtnFLX4/nCerQKEZPU/QKBdDDNDKuXO83zwkmnYe6K78GqR/d/7ygwJacp7KQIaP2bLaDr4ME3rgK5y9X3n6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wZHHIINaGVjD+KW9VQdtpsunANMAZFXluaGiua2U3P8=;
 b=CLwJhsmxlT4Kj5hx9/YM6p4LTQiZBofd0G2179nwtPOwiiiy8tdBx2BT778iHvqTEzJx70iN0kBk4LV77epXhWM53Bv/rxO22qU2BkJ391nKpuLm/Fgz9clj86ZlDlGztIoht7DtSM9TK81JI4oNBIWsBUCk8T+Svf+e3/mdIaQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2709.namprd10.prod.outlook.com (2603:10b6:a02:b7::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29; Fri, 26 Mar
 2021 00:33:19 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3977.024; Fri, 26 Mar 2021
 00:33:19 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v16 01/11] xfs: Reverse apply 72b97ea40d
Date:   Thu, 25 Mar 2021 17:32:58 -0700
Message-Id: <20210326003308.32753-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210326003308.32753-1-allison.henderson@oracle.com>
References: <20210326003308.32753-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::8) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by SJ0PR03CA0003.namprd03.prod.outlook.com (2603:10b6:a03:33a::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Fri, 26 Mar 2021 00:33:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd42de58-d818-4761-46a1-08d8efeec138
X-MS-TrafficTypeDiagnostic: BYAPR10MB2709:
X-Microsoft-Antispam-PRVS: <BYAPR10MB27091FCDFCC1903D3720510C95619@BYAPR10MB2709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:644;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jr4jLyUpdMyySHJmp0a5Mnmiujg5RTCIvv0u9IP99oWDhwgAgGpinRVz+y2D8WQKrMnHVPUYslfbddjbzZ0EzzAggQMTk3jQQPLyioNsvscJ+78EyUlPL+ZXMzDWjjT0wP5zlw//3sO+P74GqntgnneMf1ozuSxKxeYIm0L8nx+a1T6cna/QTj5BltSFbdfZ/ZiMJjzOkE3IGtrLN+v4qPf1Kli4SNEdZvut13XWTTAVmSXPB1fMkQxHoVG5yovZsDdHks0Hz0zmwRy1SB2H4Ga8nOGzz6dApemtUVwNxDAcfaZocI7KsP/bmoIn7wtGQDOk0W+Up+lB9JOJM3Gjj9atTGvF6CuWxvdHJiuohvhDQGDt/OXSgV5CJtOXZ63xUv8k/1y92SV51gtdx7nDpSoxQoBpZtVWm2UT9ChSMagLZV8EFHwWGywuidupPIxYybwbEFA5vXnBsLskvuTf9J89mg+Sr6sek9ayJrx0Yu5qC6vP575mUx6wzbg1I2IjQfXaYg6inwpClUnsYbJ0/Hf7vopM23LsjWQTLq8z3kJnxzfdQWd9knVLlUT0eJB/8yJsCOG9s4Pq1I0tmXYaKa8DF1ZMZnun2e+5mODtpeIfe6WOVfTxvy5o8N/gwWHPfrddqSoweICctkRPaIoRmeezE0nNF0hMoyExDanjAE+xnOM13T47gL9++d9Glkp4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(396003)(346002)(366004)(1076003)(8936002)(6506007)(2906002)(6512007)(6486002)(52116002)(6916009)(5660300002)(8676002)(83380400001)(36756003)(66476007)(66556008)(69590400012)(86362001)(38100700001)(66946007)(956004)(6666004)(316002)(2616005)(478600001)(44832011)(16526019)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?MYebtkAYf4Rnbue1qPr3uNthdR0E1zmSNxWrxMI76MNqgSpTN5rJkIcXuBk5?=
 =?us-ascii?Q?XX7RSCXP8VFYPsVZY5KRCbiPJXzGxsgwXozmQLozFdVz/lZDJVprdbn6o7Th?=
 =?us-ascii?Q?wOi31vxbuhzsyV7UDjiqWUu+aXnO2/s3y+t6ofMa5HVwSBYeb8NPhOVAr0xr?=
 =?us-ascii?Q?/zxXMDZ5jZNGsRASGetLR3Oz8Wn5smf+eu/NGYDamVs3RXjuIMBQE/Nzm7IQ?=
 =?us-ascii?Q?ff0AebDdctTdB0z1jM66Kphw6X1ykT9hl3CBwYv66Tvn2cGZx7VvzIk92cG2?=
 =?us-ascii?Q?qhoFm1547e286RRled0JZD9XhedMyW8NA4/o0kKqJ3EPNtyfGxj4Z6dIeHbZ?=
 =?us-ascii?Q?PUQW5CRX+59n4eyZ5nFMj7E5Vgfu96LYABGwq+9pZb6CGv/DaCJvm0ntXJrt?=
 =?us-ascii?Q?uM41Tu9HfTPq60Dl22KiQqWjYAgqUettyqBrwYJIfCxmowcImYlmGo4yCkhB?=
 =?us-ascii?Q?A+Y43N4fHVDed4cdE2sr5iETjbxkZBxBC36R5QHzPxWT+IEwcIlYA6BTTPzT?=
 =?us-ascii?Q?eCvKinYJTclbqYZZ4evrhO7RPhdAZ0Emc3ImPN8uvr/NkNNKSaYmon4pET21?=
 =?us-ascii?Q?ePTia7sb4V1RnGE/ZMjC+Avsb6EQ7R905pzV7ExqQroCUvNhr4Li9ADgK4nM?=
 =?us-ascii?Q?MrpP7lQmx2fDkxvbkBESQJKCIgwoyVjN5oQMIDx/S21gD+9ZVX7pzKGvTXRL?=
 =?us-ascii?Q?/aWKfo2mDK3VRHDaYwI1UtVvF7sqr2z68hZsalG1J/zV/VeKq/WamO8hp3hj?=
 =?us-ascii?Q?iEvO0ZO/QsD94urDP1tiTRLFxiAu+9JhN/yjzKQIyzKnciIvCuuENFOcfGol?=
 =?us-ascii?Q?7TRcT+uW/I2dyVNjgOqs5w79OnxqW1gQoZpVS3B/19v6Rop3PT7E7Q0eTY6V?=
 =?us-ascii?Q?6AegikzNwGk9igi20NI6n0BRiXlgQcMcGzwBvSG464culJQE5s6P3xffNjbS?=
 =?us-ascii?Q?P39yRz/g3OjzEPMaJeZNsa8Hy6efJ2N5uWtlfAsLxHuaDbRj7l28UAjtVfq3?=
 =?us-ascii?Q?XVksVVnEbdfnQ0d7/AY+KHC1YfB1MbnAv6DwHIfaPGuLpp8cnGDxoRyw7SDw?=
 =?us-ascii?Q?ZVPltEB7BhYdBrK5ZoMeefqYaGlnHkAZWqW4hZyW9DzQxQiZII2n+Jcw02nL?=
 =?us-ascii?Q?9QL2nzKS9nbUNHF+uYMizt6xASL459RxRb3GwEbfVy33J7v5lbSZIw1RFis8?=
 =?us-ascii?Q?cK17XirEPh+fccCm/RbLP3m94Xr8nRg9nXqUMv98FPf9ZNhYRvyl9HkwvqhV?=
 =?us-ascii?Q?dYPQ4iZKzsO+B/JtqCRBN8xxA4Aa+etm7/p5rTdlwl23N0DeshgID2sBsgpc?=
 =?us-ascii?Q?jwTVFso6B3apianoCGNvbds8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd42de58-d818-4761-46a1-08d8efeec138
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 00:33:19.7085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jMpsManU0Ye2pTghEGY9Zg2671aUqXXUWZx0aDbznmpoR0WVGU8Lbo3Dpd3mNdm449NIqzSPK/boLu3xVEeqlq8W4Yg0R6J7Ex9hhYyRa5s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2709
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260000
X-Proofpoint-GUID: 8HwZzYmC4vWPhm2NzU5SrjQaC-eeW5VJ
X-Proofpoint-ORIG-GUID: 8HwZzYmC4vWPhm2NzU5SrjQaC-eeW5VJ
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 spamscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 adultscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260000
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
---
 fs/xfs/libxfs/xfs_attr.c | 28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 472b303..b42144e 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
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

