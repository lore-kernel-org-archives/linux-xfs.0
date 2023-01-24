Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1DEBC25B50
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Jan 2023 01:37:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbjAXBhQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Jan 2023 20:37:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232339AbjAXBhQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Jan 2023 20:37:16 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C0E11EBD
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jan 2023 17:37:15 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30O04X72021356
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:37:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=QnZjoGgIcEUP40CqmQBJYUuAmBfobRJOlbitbtUwDrQ=;
 b=RBZ40kIwKYQ+Ip5L5oJwRcvSvah44fhNCFLBjBaY5cOMv9F/7fs1j/GnhZWPf/xKY4TM
 H37UETSoorEbEUD6JulDg1F/KMX7csPSxJA24juzwBGA9ryanaeCyyzgoZoSDImxXvX4
 tzE/MQqbWIciHtu8cLXQMslUsxp1jwsswagWFVQm2FK3Px8RsktFxA8/NDVl+G671bqJ
 dL7bArIt3Vf7C5FBYprpSvbPeWSmEeUxVF/HQsx44cWrknsBg5QkZhbtuHYNY1OlYS5S
 kHq8tjBouWEC79xEbhijM/A+akxymTosvH5mviYxvRP/6K8WPui4DReabL/52D6TxVob WQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n87xa4a21-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:37:14 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NNeBmF001149
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:37:13 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2047.outbound.protection.outlook.com [104.47.57.47])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86gakw2e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:37:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e1GChdJy/Xy+794aa1XTxTPhLswT0lqhkTxxRrbVJCM9xHrbNOo0ne45WWywi61s65VQpyF7R9YNrZWdtzoPfEqAafb/goCZrlCDblutBnvUusnt8Or2JicbHXBmaF8/7Q/E9u+BFQpXgu/vTpxGh/4HtyPaEVJJ4nLkHlP4KfK8fAU2MuEdSSoJmg1dDr/YLBAGNTbCQUQt+4KmLb8yck3Y8wdPiNyGQyswOAxJIXX0cKxN4wssPoMtp+Tk/AL0uc9rWQ/hqd+XSSzs8DQMR6+WylonQEPw68ca/AGYexwiiRzXMTHZ6hM5b5GxnW8YhMZ8szOHRUw53PrswR7jxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QnZjoGgIcEUP40CqmQBJYUuAmBfobRJOlbitbtUwDrQ=;
 b=Quy1eI9bT2A239dC1/hMpT0CNNa47X8YCK24kJITqOzwPm0QgQkVZQ6MLtPeWoez3GHW8p2k9zjLdcHqOgMinyF6evVUTac2hGLE1Y/62tbX0p5hzuLJEUqqnCvtbHClpqo2HLOk4z7d1FgeqDL566WMn8dToIJPwt1HVKkuM8bwKvdqVmO75093uxK5aFrApAwV8XH+QEqQVUYy1cM0Bi/cUxlw/KkhZCHR88JRM/09BRv5D/lWtt2x4n/BTZg8+5xpZg//HLiqejbpkNwN57Hj6w3dsD4wWVdAQ7F8u4Y7OqpOPX4iu2tH4J0t8m0UuLqnTo5Ckqc8qP1emheYlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QnZjoGgIcEUP40CqmQBJYUuAmBfobRJOlbitbtUwDrQ=;
 b=TAbYhVFhQj1MPW2ISEr4FUFl/CTi6DenUZMMOtwI8Ia+TvR3TNTyn4CbQfWhU7dn8WjtcAzEwccrDf3l2NidrtuJbzc3sflxazVpMXRsvZ6K/YClekzu9L8IzKWTbmv2oGPNjqpzTjY9MBWTHQccS9wv2CabsCUUHyBJ+N6IH00=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SN7PR10MB7074.namprd10.prod.outlook.com (2603:10b6:806:34c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.8; Tue, 24 Jan
 2023 01:37:11 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6043.016; Tue, 24 Jan 2023
 01:37:11 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 27/27] xfs: drop compatibility minimum log size computations for reflink
Date:   Mon, 23 Jan 2023 18:36:20 -0700
Message-Id: <20230124013620.1089319-28-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124013620.1089319-1-allison.henderson@oracle.com>
References: <20230124013620.1089319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0161.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::16) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SN7PR10MB7074:EE_
X-MS-Office365-Filtering-Correlation-Id: 367a3eb9-cddf-484d-7a8b-08dafdab8377
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rdgRM1BJSUJMK0KseRvfxww/dPi4c6STDX4TbqnN6qhonmAEY7GuuooceZLeJD+ttFq0iMuPvSMxsHPEQNV6ucGAc5w0/bW68yg9KAK/yMZuei7PsGWvM9tLZge6y1MyBZumzXtKEr+DmQuOg9vZNW5MZqJRHIHsR9NOo4/+g3lx4Ml/AEivaNqkyETnHwSmzvhmKtM7GoPnvEgjg5wxeyubDo93WiDP/et4ZP04UrmIC7dqNoUBx2HykfcjMtLQT7ssb6/QRrH6M0k7jeU/hT9iTI3aoM39nt7NFqRvwHYSDpijyFGRGqWaMvTQ5ZEjqkyMKhDYlyDiIyKq/ynCY+8ZiVUjjnptYHr5n4T5VfW+rRcGLdlZtVKxQDuBQYNd0N9oJhAsmUnS2V7PLEmxa8ji5ZHvr17uF6aA99mI63pvUhhqCBL1QVRppeM2QjMqUq2dpj7cYTibSHKDw4QH+P6zKFRCAjMCP9IPcO6jpI/ot4DpYj0njsoQKOe5HJ6wbmQbbvfCorTZ0jC7QgfcYa3+MohBvefv1dfw9xcrvRdxai1l4tr9FungUa70VlO87OPkLKRLHEwog8O03gViluOU8hFLOhKIp1QEWHCXDSlf32SWg41XSoVMbvkDzZpjctdZxjmoGXAc8xU9PanqIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(346002)(366004)(39860400002)(451199015)(66556008)(66476007)(83380400001)(6916009)(8676002)(66946007)(41300700001)(86362001)(36756003)(1076003)(316002)(2616005)(2906002)(38100700002)(5660300002)(8936002)(6512007)(6486002)(26005)(9686003)(186003)(478600001)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qM8wskH0CPBjM1EPD6BLwG3NEu7Pzdvi+mQFO0GF3MNEJMJt+lJlpf6RqCOt?=
 =?us-ascii?Q?EP5Irx6oFAbwCGQKi1KwfnwGuphFyp24HNmXiXAop8MbByyVDWJuR0owlTQv?=
 =?us-ascii?Q?Br1mnPvHfy6bg3npNJ8mVQK8qVO6HTGaJLR62Y1TeNt/jbeYdpOEp363qQo2?=
 =?us-ascii?Q?r9m5MwLKzmzi5to1xgcr6jHMTZPfLk9nnzk3RTvRThYTXTrj9ADpkA52EBfc?=
 =?us-ascii?Q?Mb+UHh8is3mJbr1glcbH3NJQyARRzR+D/PkhnJuxpZCWUEcHZ7dpF9QM2x7W?=
 =?us-ascii?Q?uK06hOsq6ZcltIfqP8oGO6vo6Ez7ato1UZRuQV9zgdPXi3D26wxbW2CWiBbw?=
 =?us-ascii?Q?9b0989oQAxp9PxlBD2m7LbfGG15Y38r8ieFKnEJhBNxSfZShHXF1SG44BjYE?=
 =?us-ascii?Q?6/TP4sYlJyLMqvQvS+Vswe6m4+qjNN2D267/6fryIGoltwgkI9oXee8T6oWn?=
 =?us-ascii?Q?sGpbP24tpYKfnnAA1OMVHn+2vYzslFhbZAUyQD14Gv+2MbaPpKHRL9e6Hk5a?=
 =?us-ascii?Q?BcVoF6c4DsHLpnKBvWJLLJ8KSP3O6VRV7t+/1U2fN3IWfvoo39tas3uu1tOs?=
 =?us-ascii?Q?QUJP6k8gpziHjHg65+Zru7D0IJr0NsimiWMDcj9uu8WMIoJRzExMrGtBcb5C?=
 =?us-ascii?Q?YdjiYIZPwkiMhKsE6hYnChK1zif34r2+RiRaC4E9Yq5unIIWzcYtKds46jW2?=
 =?us-ascii?Q?8gEyARBziLZG4wx7Gb8OM/TrB5wsUECLIZb6X/EyPxZInzEvQ+glcAl7yJLc?=
 =?us-ascii?Q?FkGzNIUwRrmbMVD2FatDDvU3XtZbcqihshRMZCi3Yz3T2KgbUCAxoFqp7iSH?=
 =?us-ascii?Q?7pIbtGDKqgXYVa+R9rJ5tvLBgMaRePL2O+de/jo94siHcSviQP48890vAY+D?=
 =?us-ascii?Q?G7bUzd0CYwTIp8pOyQtIn2iMkfK5n5GDa1vGaoCMbXrnvSbiK7ENcWFwOYAD?=
 =?us-ascii?Q?W1xxQAP8Z8kkvaauzDw+YhNNCYZRxt3bhPxfH46DrdNMjA3SrJksMG1GtayJ?=
 =?us-ascii?Q?3ccscH2P4PWKjkL37rC4HfPLGs+dJRE3b7Yn5S43NfYMxBY0/zSCEXOlDDev?=
 =?us-ascii?Q?AXchZJkaNHH7QnJsInYfRtHQiuqIRqhO6+N2RoMhHXd4zsHdg8QyMZYhAwzL?=
 =?us-ascii?Q?azpakAhvVSItYbmQy7U8SJv0ucj9FCMUQKKwmLePcxakN7+e+waTLLJxAd/0?=
 =?us-ascii?Q?YuBws2IwYgCu6g1dKiiOC2uhsh5adc2WutJ/qeKKHCoe/py/uO/53N5JEB4U?=
 =?us-ascii?Q?iUjfB1SRd/ahWztXDfCFD1vAaOHdfc7Q698h2DlXp7zidLH1TsxxXomYa7Yf?=
 =?us-ascii?Q?wFA+XLwGxegFQdw22JgHnVhr0/2zRzQDeB8gGna6kflUU6L23IeojDQRP6ts?=
 =?us-ascii?Q?zZDtmZD8UGRxIVyi9Ruyd3YYZeOJnDo28w+f92RWKAo43kyYpXkle+Yk7BqN?=
 =?us-ascii?Q?wxe3JDd1gbr5Asm0/ZKyG1WLfyYs6vk/4dOI1/dR6XS2BCH6C4FyNgLOsBf+?=
 =?us-ascii?Q?TZokQ5VkFtKRImSfygbr8BYcAIzEgsqV/Ej7smAg2r/YzsOtJxIx6hnPOkkc?=
 =?us-ascii?Q?VSM3CcFurzYanhU/puWLgQAIFZ+wgVJkd7PffBBjhKuniCCUM/z3r4zwgqjF?=
 =?us-ascii?Q?gw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: QTjc6wSDqdtKUO8lAjcKvVUDylp1JK4e3TpXt/nCREvuNQaeoUUKwYkQGeA5pnn6oA9V8Nz7ifeZsVQbjZr1xzHRaZ/pFq8UOBPkqUxzRQROcFDqhCqIJ0kcd/aK4AHXZzq2sV2A82x52601j5QYuRhhfDVtQfNJjLeGb/hDWJ9kpeyPnzQuz/Rov4EAzYzizlobVIdgiIkF3eR4VODS2yHiwwN3HYcN/ZZfCMlMpoDeYoeDRTzzHuRGUQnFlnck8IDglvRJzOK0dSecc0Ro9nW6pMTFxB2elbCV3Ot3vElrrtb0pi4TKx10ejiWWTvuhMpUT9HyUM/GT54y4ZDBrxMLBxl4RHMLMawl6NqSIgn+pxgLDIsbHvGTcpd4ezQVe68PHTytZrqyV/ChQ16PyZtS5RWMZv2YWfKuv5ekP2fRegBOj0buqjqXee/7Wz6gn3QDfIGiRKN1eYMZDWvc5VPXnQ1GTEiHDMVScBa2IJXCk43kXKSMt+KceALVzotTzCcd5grUEVp/pRNGxYStjwpD645IpoeENi5q2dh5UZe9yaagdIe53T6/p/zafLuMEtvxDe4ibVBBfny2gEGl5m2NcD8ll9roRe7EU/5aPDzBgOVORufByfXYTOvvlkYVvaK+MT2dqkNxHavc8PS7LGhtaV0w+n1HzxXEKqYau8WbNPP1JCgVmTJ/J1lnfZTJtW377spFW3S+2Ud1XrbM4e5NXVI+vuPGcFZ29pW7P7tFUqLlewg94dhamhWFXHh8wXb68ojlEcg5voObrE4Yeg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 367a3eb9-cddf-484d-7a8b-08dafdab8377
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 01:37:11.4476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OfZw3YnfnE5OsEWvwB/+zwQ8QJFKiGvCs27I06WkCzwfXlu4V0p/kyG2ciLaVlAEZ3FF9upbR5h+xcfl4bPXVAkyBdEJOGk3ZEvkFdU9KEs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7074
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301240010
X-Proofpoint-GUID: kt2rI1ql76w79b7YyOKLdxUWU5snWwB1
X-Proofpoint-ORIG-GUID: kt2rI1ql76w79b7YyOKLdxUWU5snWwB1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Having established that we can reduce the minimum log size computation
for filesystems with parent pointers or any newer feature, we should
also drop the compat minlogsize code that we added when we reduced the
transaction reservation size for rmap and reflink.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_log_rlimit.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
index e5c606fb7a6a..74821c7fd0cc 100644
--- a/fs/xfs/libxfs/xfs_log_rlimit.c
+++ b/fs/xfs/libxfs/xfs_log_rlimit.c
@@ -91,6 +91,16 @@ xfs_log_calc_trans_resv_for_minlogblocks(
 {
 	unsigned int		rmap_maxlevels = mp->m_rmap_maxlevels;
 
+	/*
+	 * Starting with the parent pointer feature, every new fs feature
+	 * drops the oversized minimum log size computation introduced by the
+	 * original reflink code.
+	 */
+	if (xfs_has_parent_or_newer_feature(mp)) {
+		xfs_trans_resv_calc(mp, resv);
+		return;
+	}
+
 	/*
 	 * In the early days of rmap+reflink, we always set the rmap maxlevels
 	 * to 9 even if the AG was small enough that it would never grow to
-- 
2.25.1

