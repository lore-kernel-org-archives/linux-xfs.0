Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1542C43214
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:21:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9530261009
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:21:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235700AbhG0GVS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:21:18 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:39902 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235579AbhG0GVP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 02:21:15 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6I7sv006844
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=MASg6vg9FcK/Dr58zYmr4Tu7AWWqilydGc8C6LeHFlE=;
 b=WwZU3Tat1/Dn0968468BQVexmMXHEbKytoQTWUQVZdXxORMMfgnAze99rIC0+0+d7qpl
 oWWiIAuv7Cl5o9VaAPuHWElZkf6zPWwvi+QlAudt16OqgNbEIa/Y/JhuwHNYbahiuJpZ
 KS0r3t9h0mWcR+d5BNKEk7UxkJI/W/+FtWlNX1toYReAQc38biJmSYWb1WjbN7Dcb3XZ
 rdRXZ1BxtGJdfXJ6Fd3NCj3BD9QhJqPxOIOSoCmbGsyc5oJP5ZQBiN/uOqIrEZ5GNmK4
 pqvgH6IlRsw1J7tfGYRbdTQRB6drnhJCMDqKrhV+18GBNwhYP0KabnRcb3za4x3rWkwQ lQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=MASg6vg9FcK/Dr58zYmr4Tu7AWWqilydGc8C6LeHFlE=;
 b=MU41pCx745KGuRX63G0z4tZVCTm8in8SBgsNUbZYDNR9HXDtTdicnp5odCU6bMu1xkyx
 tKhBCXbgTsNepob2DjUALQ5UbIY9QqJ1qowFuKAmsEkQuMUxMu9HPBTEAIuxf21FPMC7
 kh/vIGRwxusuo43WxCWKHk6cT09ekKz0px30qElFl1hBQzaT1/nBF0QPLmW8p0duVEKq
 RlSojLaws1uCSC6ik2SRo0aikbaEV2f3zfCTvpljvnoKezENjd0LV4iOrY7NruSCKn+k
 shyTU5VQ2BYaZS81eDFfR3lB7fy6L7TwxFW9L6c0YDVyxcy4I66QLW/0LcrMrKi2Mcet 8Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a2356gucv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R6FT1t019894
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:14 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2042.outbound.protection.outlook.com [104.47.57.42])
        by aserp3020.oracle.com with ESMTP id 3a2347k0as-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jJ/LZOoOXHD06Hq9bW3pmR5WqUeN75Sc5xCCc9TCFVcPhYNPaUr08HpdmuE+YBq45ZHZlha8DB14p9rGzS1XvNAVFN/kyxQFg0TdPggExCiBNUi+YAJwcwcHua87JIemOlpyng5brTzFqcgIW8/Jmg2dZINVpu9bVfCY274tFdQNeqFMtA7XXUrWG5HaYFMQOjOiWYsaJE/SE4kOOyDFTSrxFDc9brLrZWaStLNcLMKCNM/e05J2RWyKnFFsgDtsP5RK2ngIh1P9HdBP+f//tspwQ5ViLZTxt0zaNr47B8Br7MY1JhBePwPXf/BdGbHFfp4QR1C+gJVejAZvtSZhlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MASg6vg9FcK/Dr58zYmr4Tu7AWWqilydGc8C6LeHFlE=;
 b=Z2fIrZ2i4TPQ9jFrmuf979zto0aRrRVZpNoGsNOY4kaI7JisAIIcSepTVLP8MPu55KmXc49sDgXPFXXMMCTk3ZYESgNPZ8H/KMNgI9PUT87K+zo8lFmN5vtJaiGz+KMYJlQNR1VmJoieeVzDaUiVoljDe+WXBStBLCDlH+KqiAxHApShnjkq8Zqm/pmN4DguMVBl+DTC62Wo+7yPuip5zkF9jpK5Slwe6qKCe78xsrJWDHl1uQSsy5sj0UM8hq5C0pr+R22x/O12YDPZkaem2MuK14WDk/9gO0zs2nLhABuoSjFbkCfk1bDKLZNSSasLgjAEkc6llsqJcKCT4+P8/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MASg6vg9FcK/Dr58zYmr4Tu7AWWqilydGc8C6LeHFlE=;
 b=mcaGs9vglm0GLDdv9LH/ZcqzGIAMyf8ELcjKW4Kv52PdnxfEAxWrckr2MVSg5o/dvRaPKVxXYad5Ci/itMxqEIUP3t1Cypozxv5+oF6zbvRAwXORvbjHHB6hetmwpiPxeO7lhWSbw0VoGasXdvfx4oiU4NTt7SR/G9ipYFP+6to=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3383.namprd10.prod.outlook.com (2603:10b6:a03:15c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Tue, 27 Jul
 2021 06:21:12 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 06:21:12 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v22 10/16] RFC xfs: Skip flip flags for delayed attrs
Date:   Mon, 26 Jul 2021 23:20:47 -0700
Message-Id: <20210727062053.11129-11-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727062053.11129-1-allison.henderson@oracle.com>
References: <20210727062053.11129-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0191.namprd05.prod.outlook.com
 (2603:10b6:a03:330::16) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR05CA0191.namprd05.prod.outlook.com (2603:10b6:a03:330::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 06:21:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 01f74edc-2793-46c5-b279-08d950c6babc
X-MS-TrafficTypeDiagnostic: BYAPR10MB3383:
X-Microsoft-Antispam-PRVS: <BYAPR10MB33832AA1B4CA739E16963D8195E99@BYAPR10MB3383.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2++lFylEDiFygwHnPjazVlaw388bSBMI/oaslgPj8dd31IEL2gegHpCpDxcG4zMio0UZHRLTFQp1IU/ckGI+Zv8HmFuJaTjXwcjkTHgAExMYh1jyYFeCGXZfKsh2oK+Wga7PIWOi0bhFFkJGpuK+lspDKghzIyrILAKq0NYWBtGLnu2veP1X2P5uUDIoRjEag317bVsR5ke9JtU97fZIRXN6QrOcdZhQcxF9uuNbsL0lz0ZL3/5rK2CgokBvpagWaE1AZhO7E+fNz194uPNAQQeo4hyOnmycysbtF5+k0qnCAR49pDFyqYtCq5Qd3zYt5EBD+na7mL+Ih6BDwOwX1Qr7/CuCwwgT7XuiXD2jZQoPDSHkrmsLMmTlW9sGTMZLJDywfFJuAQsbEcDph9PQNgbfW4tI8H8A6qORIzJu1Ovg6iDQL68ELQOx2Dlk9MrVxL8Ml+BuGgobeZky0zRJnZtvzZNObqvbrEfNg3xEcm0pwf2mbeExSJAxS22/LLPVGCN+VolHnrMp0N6hesUzGcbeNGsPN+weA4AYSEEhB07y0ujcvn96/0icAoKGKF3oGYyT5hRRLQ7dEcgbmWcuEy31sS4yk3j/JYeo78enHT/b8FY289SfR7Rjo73DHaYhTAxUEjtAuIYgol0SZ7JaKBxTMT14fb0B9Y5yHfmRjmvbZG/fKfK3//5h9iqIkiRP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(39860400002)(136003)(346002)(44832011)(956004)(36756003)(26005)(2616005)(6512007)(6506007)(186003)(6486002)(86362001)(6666004)(2906002)(8936002)(1076003)(6916009)(66946007)(52116002)(83380400001)(66476007)(66556008)(38350700002)(38100700002)(8676002)(316002)(5660300002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hXTZ25tfVfZPO2RwuKndf0GDauaVBeSh02vCQ3ml7zlFCNeFFsL9Bjh/BzB7?=
 =?us-ascii?Q?k+ZgQPtIZHatPZLDM/Z6oPBJPe7Mmlj3GGRMsSPnqTRXlifA0nyWVUXpqIMM?=
 =?us-ascii?Q?79Exl27VaIqcilduFBAsUmfCV8KHuVSYDmqt3cCln7M6qMItcP/HtQEgOi/i?=
 =?us-ascii?Q?36O34Gom5l+0ViXIEAjqJ6GWCF29BxBvGArLvOPzGPnLMHQc83kCD6vCpOCa?=
 =?us-ascii?Q?kLWocUdixKz05hBjZPWD/lI1jROtKhIYcTCwwozHhhYvRkzWXe8dsNaou4eN?=
 =?us-ascii?Q?kfJlhbno8qKSg2IK7ttwlRPahP5NNgCyFYEPGdL833tAq05t+v0m/6IY2exK?=
 =?us-ascii?Q?uG8rFRH+b1UCKd17j/NLtpSVf47hlZAvX8rg39pwfppgC5mDvS/OJcdkLoj1?=
 =?us-ascii?Q?Vay9o3gSBTHvXnlrdPeiIhFfc1mJp6o/ENY1tmtLVmy0D2XKZvsXuLawK8HP?=
 =?us-ascii?Q?00HmJY3vH1yIeAQWt09jGGJhnNzFZSXutFLpTnqiZglnbU0KCGNFY/POJfV8?=
 =?us-ascii?Q?PBZf5CLUPssRhGwDg+ZDW1m8cPGMsjMW9Pd7hr0MX1end1p28rl11O5wwglS?=
 =?us-ascii?Q?lLdMC/kk2LJgYSPsMVqX5z7SZGN3P32gNXBeKq7vmMMvv6AOs9peTDLp0oSe?=
 =?us-ascii?Q?1YcQ9Y1oxqYb6jI+U5/ZP/jHd9yuSOLMLMU1XuyAqSU1JYCpYDPGAACqdmWI?=
 =?us-ascii?Q?t1S9MDtopoqbJudmcGMp4rZoZub0igibvoCb+lTWb1/N47vilb87QGT03GQ6?=
 =?us-ascii?Q?n6lDxdh6dNFkPv7SsEi/nFa6Re0VcqPvAcbHMmaAY0KdpjMx35Mah3TsHI+i?=
 =?us-ascii?Q?hpOAYMcPq5uUOvA21sv5ik7KlNhw1kQ5bwl4arezxklXUqcuwAyXMMNcZND6?=
 =?us-ascii?Q?UUMJvvoppuNVqZCqtbOyxvKsWbZ2T31Lo56pZfN2KaZpDtKRwgFzgoCKr/Xf?=
 =?us-ascii?Q?BtnWVkIExcxh1fUdg3OkDB+bZr5Iebup+9EOUgWQH1p4JpZ1fCJpx5qJJQpc?=
 =?us-ascii?Q?0JYN9f62uj3J+CJnqTguxuWzszSArV4OQczSHXabYPds9I8BKLiXi7LZCIR2?=
 =?us-ascii?Q?FrNKNR0Dq7Ex8yOOteXiLz9Ldy3kD+gDB7Mwzvfs+hSiIAXAt7/cQSype2GR?=
 =?us-ascii?Q?naFSlN9A65krd3An0zPl2QzyoeKgL/IH9yAuChDz//snXhOAZWj3IRCE8DOT?=
 =?us-ascii?Q?tYxIBLuJZE2nzatOqUc8EgXZqTuhTVqymzo7aUgXUGyf8BNJ8UJwh6Nne5Nr?=
 =?us-ascii?Q?aNWESRsMrzkgpuiT/OviPukB6NrN3xHTHp8r7EHoGnlzW+nV7wxzy/oRNK36?=
 =?us-ascii?Q?aEyc/pu9l+gNKWtI6XFlXSDW?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01f74edc-2793-46c5-b279-08d950c6babc
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 06:21:11.7794
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: erE7k04m89ndz93GWJMsoGp2JFK+PyS72hsFBh4e5VCA4iO2K119gSo7Jr5ngWItMbcDkfX1m7geKms5KId0WTgW9Pq3LArHWaeZOJ4hVrc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3383
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2107270037
X-Proofpoint-ORIG-GUID: lglYfrmclZRE-9GL5yHtkxrmE63zPtSi
X-Proofpoint-GUID: lglYfrmclZRE-9GL5yHtkxrmE63zPtSi
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a clean up patch that skips the flip flag logic for delayed attr
renames.  Since the log replay keeps the inode locked, we do not need to
worry about race windows with attr lookups.  So we can skip over
flipping the flag and the extra transaction roll for it

RFC: In the last review, folks asked for some performance analysis, so I
did a few perf captures with and with out this patch.  What I found was
that there wasnt very much difference at all between having the patch or
not having it.  Of the time we do spend in the affected code, the
percentage is small.  Most of the time we spend about %0.03 of the time
in this function, with or with out the patch.  Occasionally we get a
0.02%, though not often.  So I think this starts to challenge needing
this patch at all. This patch was requested some number of reviews ago,
be perhaps in light of the findings, it may no longer be of interest.

     0.03%     0.00%  fsstress  [xfs]               [k] xfs_attr_set_iter

Keep it or drop it?

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c      | 51 +++++++++++++++++++++++++------------------
 fs/xfs/libxfs/xfs_attr_leaf.c |  3 ++-
 2 files changed, 32 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 11d8081..eee219c6 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -355,6 +355,7 @@ xfs_attr_set_iter(
 	struct xfs_inode		*dp = args->dp;
 	struct xfs_buf			*bp = NULL;
 	int				forkoff, error = 0;
+	struct xfs_mount		*mp = args->dp->i_mount;
 
 	/* State machine switch */
 	switch (dac->dela_state) {
@@ -476,16 +477,21 @@ xfs_attr_set_iter(
 		 * In a separate transaction, set the incomplete flag on the
 		 * "old" attr and clear the incomplete flag on the "new" attr.
 		 */
-		error = xfs_attr3_leaf_flipflags(args);
-		if (error)
-			return error;
-		/*
-		 * Commit the flag value change and start the next trans in
-		 * series.
-		 */
-		dac->dela_state = XFS_DAS_FLIP_LFLAG;
-		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
-		return -EAGAIN;
+		if (!xfs_hasdelattr(mp)) {
+			error = xfs_attr3_leaf_flipflags(args);
+			if (error)
+				return error;
+			/*
+			 * Commit the flag value change and start the next trans
+			 * in series.
+			 */
+			dac->dela_state = XFS_DAS_FLIP_LFLAG;
+			trace_xfs_attr_set_iter_return(dac->dela_state,
+						       args->dp);
+			return -EAGAIN;
+		}
+
+		/* fallthrough */
 	case XFS_DAS_FLIP_LFLAG:
 		/*
 		 * Dismantle the "old" attribute/value pair by removing a
@@ -587,17 +593,21 @@ xfs_attr_set_iter(
 		 * In a separate transaction, set the incomplete flag on the
 		 * "old" attr and clear the incomplete flag on the "new" attr.
 		 */
-		error = xfs_attr3_leaf_flipflags(args);
-		if (error)
-			goto out;
-		/*
-		 * Commit the flag value change and start the next trans in
-		 * series
-		 */
-		dac->dela_state = XFS_DAS_FLIP_NFLAG;
-		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
-		return -EAGAIN;
+		if (!xfs_hasdelattr(mp)) {
+			error = xfs_attr3_leaf_flipflags(args);
+			if (error)
+				goto out;
+			/*
+			 * Commit the flag value change and start the next trans
+			 * in series
+			 */
+			dac->dela_state = XFS_DAS_FLIP_NFLAG;
+			trace_xfs_attr_set_iter_return(dac->dela_state,
+						       args->dp);
+			return -EAGAIN;
+		}
 
+		/* fallthrough */
 	case XFS_DAS_FLIP_NFLAG:
 		/*
 		 * Dismantle the "old" attribute/value pair by removing a
@@ -1241,7 +1251,6 @@ xfs_attr_node_addname_clear_incomplete(
 	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
 	 * flag means that we will find the "old" attr, not the "new" one.
 	 */
-	args->attr_filter |= XFS_ATTR_INCOMPLETE;
 	state = xfs_da_state_alloc(args);
 	state->inleaf = 0;
 	error = xfs_da3_node_lookup_int(state, &retval);
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index b910bd2..a9116ee 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1482,7 +1482,8 @@ xfs_attr3_leaf_add_work(
 	if (tmp)
 		entry->flags |= XFS_ATTR_LOCAL;
 	if (args->op_flags & XFS_DA_OP_RENAME) {
-		entry->flags |= XFS_ATTR_INCOMPLETE;
+		if (!xfs_hasdelattr(mp))
+			entry->flags |= XFS_ATTR_INCOMPLETE;
 		if ((args->blkno2 == args->blkno) &&
 		    (args->index2 <= args->index)) {
 			args->index2++;
-- 
2.7.4

