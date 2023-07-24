Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C40AC001DE
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jul 2023 04:37:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbjGXEhN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jul 2023 00:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbjGXEhL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2023 00:37:11 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941FD1A1
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2023 21:37:10 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36NMbAbn009717;
        Mon, 24 Jul 2023 04:37:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=gPFiyvYDKJuasOfkr+VvVb83W7GBnnHtVP9oyYOqt60=;
 b=lGPn353YWxrjdW5Ez5V8pwc6XYvKUxRYRV5ql1xc9kb/ukjDzgNbyTfqTi6tlLZBz25A
 qRTcouz2iNYtnmT2nHHQIOxU18BWG+YlADK6x8Ym/cpEinCrKUgSh8R2wDG/AXU8YSsk
 LzrH/kz0v4y7uGJS58vdUFha+X810+75GTeMnfDdzl6lTu8za0jcjpmD1UNvXEQeZr5D
 fRohgOZPtI6+oy/s69+wUZk5IXAUnYNNLVs2pfBEDyjMH3am5VWKCgwn/qX53a/RzHX1
 NnmqUu7664EeXoRcKtbagRnuBFGvhchDfKzAQoCN7gaLh5YAo4bQNV/5kD+dkMqKEbS9 8g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s070astfn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:37:08 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36O4Xb4p003751;
        Mon, 24 Jul 2023 04:37:08 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j2x8tf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:37:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SxOez5XEV+N1DxjP0diqtbogXzRa+dai3JWr9uS1b1u8cF4fFifUpffOkX63kuug5YUCUQG3PuC2bbm1ZJq8BueWKBaE7uU04FboWzVKx4+MzRtUxZi5MPGDtGmlltH25tPQxPdenK5GW3f3YWoUsYdfNbI/7YdU62W0eHXS0MZ45uhrnUpkTtk7D4oFJ8zsq3CA6cNnH/1Ne8zw9wo5o2SYs3wiKdWFTa9Ae7kse2UGHDIEAinX/zxwWj2w+OWFnBVzmo9w+ISXnveBdRSIUIgw5e20DnTQ7HqUJfEWscAUvPBUOwNViLHHFR6IDQVdMZSqmxvoGxt3WccKd38qMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gPFiyvYDKJuasOfkr+VvVb83W7GBnnHtVP9oyYOqt60=;
 b=a/mspOuWaBkqcHU1xUCs26PkBgBC4RDJBQrJs85o6Swf84l7ZgDEgoFqnS8aRhneDqdzPCuon9yIt/QXrFd6/SmMwjXHRovML+l82b+j6FFXu1+nWWolguVfBneU0WTN6Nk99+DN5IVl5v8zlU01JlTOQeT9i8c9pdAg/jgmwyUEk7rm+v33Kksd+LclnR3nyGkfmsyixR7C8b23iXeZkNwuzeLEU7IbTzSSPlJ0daDu0Zo2e1wKLH8+cxmpP3WhsB3ntFjTU/VMcwNzdkg2E7xHnw55eByc2zPxks+pW6lFf34LTV2gIa3KhqkKbzr++LocsAneCFmtABxyQH/Z2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gPFiyvYDKJuasOfkr+VvVb83W7GBnnHtVP9oyYOqt60=;
 b=ylWkjuyLVPrjRhAR0IVp/ubrQIta9ZJ2l4mNVCP3PXKNuEXMe/4FRLuzp1RAR9m0zkTmcqLXPX5rnElo3J4lmm5DOgkrwpI/pb/uGRW8Rx5775JPX8fihCAbLBavjoNvn/ucG1TVpiJMjXSqxthNDAA0CIx2oANrRgivmrHzsDk=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by PH0PR10MB4774.namprd10.prod.outlook.com (2603:10b6:510:3b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.32; Mon, 24 Jul
 2023 04:37:06 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0%3]) with mapi id 15.20.6609.031; Mon, 24 Jul 2023
 04:37:05 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V3 07/23] metadump: Introduce struct metadump_ops
Date:   Mon, 24 Jul 2023 10:05:11 +0530
Message-Id: <20230724043527.238600-8-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230724043527.238600-1-chandan.babu@oracle.com>
References: <20230724043527.238600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWPR01CA0008.jpnprd01.prod.outlook.com
 (2603:1096:400:a9::13) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB4774:EE_
X-MS-Office365-Filtering-Correlation-Id: fd4fb3cb-a19a-49bb-141a-08db8bffa236
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IqQQRhIQWE4NPkdDkhz3+TneOanqVv2TBG5S9C+6upVzbYBNa+nqbGM+71deCOPwARYiSqlG42YlPMeIOc/wSr6E9xy6NcuF7gLJPz0jrAVLMMgxOwPv0IElYxuq4hb7X+KZK1h06duru52FPv43AMQ6sk9b3jKzhu4SGPsjAOkuJKEZ0mHrKrAakFpUThcToEp8vsjM/jCJDcuYk4y6IutFivvF85lXwF28PmJR0E5dz+FPGKHCHxRg39IzhPzhOr1vIlJvKwd/qIUKeqykc4li5S2g+6oZX5fGQsVIlmn16rr2LgRWygqHYioeKM1sEnsN9OTa6THB9MR/0GSuahyqR3cKILjYQ7/XVdb2eNAL5lQ3+UH6kE/XiGb0Qz6T4FyrUxrVMXwNUMKcH/oKpjdTpnp+0R8ZIECJueX3Db/v3x9BPieeGUGLLJRbRDY0mGzPePyJdUYLWxq0M/F5NnmAKBJxd2rRZjGY//anXjJa2A3feerwaj3KNxt0tgI5AfVHEbgaEBCUD9Jljkz2mHm4I213vug53iQy4XqWHAyFwB+/tftJ3GBUJEQLSEBf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(39860400002)(136003)(366004)(451199021)(2906002)(66946007)(66556008)(66476007)(4326008)(6916009)(6486002)(6666004)(478600001)(86362001)(6512007)(83380400001)(36756003)(186003)(2616005)(26005)(1076003)(6506007)(38100700002)(41300700001)(8936002)(8676002)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pUzmrkeLHSDoYjSogBJpT6nXlMTctk64z95MRpua1AsJlcVdiLqn55XFsCZx?=
 =?us-ascii?Q?TEIQr1SQiqnf/e1b+TP7zlOhabTG3ZFz4O43dvec+LRJVODFcG11+USK6QT8?=
 =?us-ascii?Q?yxGUQfYdpfnAlr1SJkxmi9AliW4Vjs3xxLODlvs/olNHfzwTyOin14ExhP12?=
 =?us-ascii?Q?iMj4EjuJGZ4wjvhcdWThunozH4e34clV0dPxLqT4FzDSExxzdA+iqvq67naN?=
 =?us-ascii?Q?LHq1WU9y7jOgttuU2jU5lDO9qfOsJT//H2RgHbexImgKHLzAjQAwUpQJhjHa?=
 =?us-ascii?Q?gnGQh7ewr9AyovLYPZAWRogKOMZZCfvPWQAYdlOMHBPA3JPIJK7lX0w9eLk0?=
 =?us-ascii?Q?eS7oHt+JtjpBEkZsIPJz2uVMIkMwsHM8/w0isZnHm0YWHEylKOrCN7x5Wl3E?=
 =?us-ascii?Q?hA7yjPpNq7btUKYkkiXJZVg39AQJP/ULV+o5NkL5YiqGQeIDe5zaU23quz/2?=
 =?us-ascii?Q?Uq+84nFNmWw+89POhuXLFnVPAb7YJ/ufk4HXYTjnlev6TMEgkyHLzv/B3QJL?=
 =?us-ascii?Q?qAUDdM22ikhFFwIeBArF4BAsj/V7uCl1wcnEUCguyqwmH3YgSwgWCnQl6V+q?=
 =?us-ascii?Q?9gMUNnPcf4EV83y/qY4zZFukmVLstkPManPBlRKh6AbH0dl+iJeK1tcIJ36g?=
 =?us-ascii?Q?KPrrQ6FQbf69dvhORajsPLHbnKdnxzxEB/IFN0H9he1B3eG/hTI+vOo4YgCa?=
 =?us-ascii?Q?18M+b+oHf6b8bQm8xUpZRPM+QrLu/WwP5ng5wDx7RZeD+gaT6g9PjAY03sip?=
 =?us-ascii?Q?9wipVXaH1BURjJr7kIFTqvz5jbur3ACRk7jSJrlHoDYsfKwVeoCwSsacRYi5?=
 =?us-ascii?Q?UlRNjdvzlIDqDotkqVyugxQFROE3conHOdhrhV7KaHvtjKcY2YftEPDIUMOz?=
 =?us-ascii?Q?CbNWevIZV3tZm1gIuEtJjr68jILHwpAMuQdps1FaE+Dmy6i4rk0Lxx6w5KZD?=
 =?us-ascii?Q?++20R1RAi1qhBDMrYdFle/5zubHHbU6BQrivxNqrUTcCAQFl5MWX0Smi6rp3?=
 =?us-ascii?Q?z1MA8c4qVJuTymffHa+4IilmAmdwbuvjbu+E1qMQkPYkTfLhu9KijC7nKzTZ?=
 =?us-ascii?Q?27Ok7n1Ai5KOb2NGdr3MIE0SGIBs1ZgMc6rsSY9Jr0KR+hirMkhprDQljvZD?=
 =?us-ascii?Q?w7YRpiHbeAlbsGqiMBfJ4FnU3ZUzf2/G9lCZJbFYgS6YgQ8+kNTmXPm8CTlK?=
 =?us-ascii?Q?icHRqCswoe2Y2qdDh4qFc7p047v77QsGAhFq1QFDw3bGVK7acfq19vhnFOdm?=
 =?us-ascii?Q?WZop7tVX4ub9aa4xTxxEaVNBHdwbkUSQnMIR1QAj4gX/dJzumaksEu6q4+ux?=
 =?us-ascii?Q?jeMSx0uVG/+UcfUxbMkEkGFOZYsssZpcvMR+aP3X1MXJ3w2o3MM8zcsuDP4H?=
 =?us-ascii?Q?GgdIJyhIIpQlZr2Q0LaOO8ukqTfrqh2Hw9GuY/7DOSU1hfIdCE4G+mx1cPou?=
 =?us-ascii?Q?Jdneb6YgKctOE4hb0Q6PW5RZvoUemceMJaw6OT/27SoIZVBz34rWm//JK8VL?=
 =?us-ascii?Q?mHk3kNY4eEkJDS8Y4bTyAbSyjr9qr3M8UCXUayGcZQKf9qBipWyVHnlTMhvY?=
 =?us-ascii?Q?ekuqQM1oO2phcRAPHmZnNITmvdlMi0/1OIdqhUi3fM6vLBzNG5ObYxNe1GYy?=
 =?us-ascii?Q?DA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: NyD4YoWcDfs5vz8k4Af9hv3Wa5ijKelJs5fhhCX9JYoSlhZdm0JA9/XAs1627B/EZJ6Xgco6ItmytSdgd/UHBwHkO9lCp1I18s6KbogYqthc+oSB2S4IEwxwNmRkuErcGkzA9sBmdsvE3DSKB252P6KcAgEfheOXabEGmRkJjjJT2qjlqoorNSV9WyxHlcAUyRRQp7jydPXygEf4khw2BeU2dSgKei8O79op306H5CPLXPxXTbgJDlgluaERf+goE1Zo6yPJjiDvsqwimGrT4S0TUgUKzrwhZoOfl26U/ZmAGEaVTB8drFsTgvWaN4yicSYXYx2V7hmRIyK9pfTXuayu4HyjLVpfNYi40XRq5vRTUThRtWTi3HoH+O+n0qyS49edBQx96qWf3iLd2Xkm8PUuMgTd4zgKvXXSA3m5zaeYq3UQQDDqdJEwMxZ/1wBNP0YZT2JEFOUtXsMa4FDgg9D6A2uXxMTGwPiUcvr8fUWqgiU2W8euywFEr8kmqzMfurYk4ZUAIgyunGoLtQ1T6W6kvYPelvV4PDpdkZ74v+fXcPREEvCau1Owa1oJL5QwhYgN/GZG+PvM7Hu7LXB5p9GH99LWPPQZIIwTKnWqIlfE9onxguYjmOILZDOpzew1BZwRX7zNoGTiokmRqUmBvNDJUKWbyxCWfGWCYgwiu/8FZDyqQ+q1PpQCkVlLr6km3nY00Dd3nAklhYr4UrIR27tE4pce/VxAcWP9PYTP8ADOL7eL+brOznk5Le91lnyVg6kb8FYpATTxvEXNFXCw6kk1nQ7F3Cp+WVMl1Mc+icc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd4fb3cb-a19a-49bb-141a-08db8bffa236
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2023 04:37:05.9270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qCTqisAJKb7mDTwJYcavM5xKGMV2gteCQo/LbOAp/PlYKScLC90V65dcSrOGAMbzXDg3XMf1g5xQj8zaUv1HCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4774
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-24_03,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307240041
X-Proofpoint-GUID: Y7L8C-hX6qUrCjCVvZ7EVTum0OgGDyey
X-Proofpoint-ORIG-GUID: Y7L8C-hX6qUrCjCVvZ7EVTum0OgGDyey
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We will need two sets of functions to implement two versions of metadump. This
commit adds the definition for 'struct metadump_ops' to hold pointers to
version specific metadump functions.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/db/metadump.c b/db/metadump.c
index aa30483b..a138453f 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -40,6 +40,30 @@ static const cmdinfo_t	metadump_cmd =
 		N_("[-a] [-e] [-g] [-m max_extent] [-w] [-o] filename"),
 		N_("dump metadata to a file"), metadump_help };
 
+struct metadump_ops {
+	/*
+	 * Initialize Metadump. This may perform actions such as
+	 * 1. Allocating memory for structures required for dumping the
+	 *    metadata.
+	 * 2. Writing a header to the beginning of the metadump file.
+	 */
+	int (*init)(void);
+	/*
+	 * Write metadata to the metadump file along with the required ancillary
+	 * data. @off and @len are in units of 512 byte blocks.
+	 */
+	int (*write)(enum typnm type, const char *data, xfs_daddr_t off,
+			int len);
+	/*
+	 * Flush any in-memory remanents of metadata to the metadump file.
+	 */
+	int (*finish_dump)(void);
+	/*
+	 * Free resources allocated during metadump process.
+	 */
+	void (*release)(void);
+};
+
 static struct metadump {
 	int			version;
 	bool			show_progress;
@@ -54,6 +78,7 @@ static struct metadump {
 	xfs_ino_t		cur_ino;
 	/* Metadump file */
 	FILE			*outf;
+	struct metadump_ops	*mdops;
 	/* header + index + buffers */
 	struct xfs_metablock	*metablock;
 	__be64			*block_index;
-- 
2.39.1

