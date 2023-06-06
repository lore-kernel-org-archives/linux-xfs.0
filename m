Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFC68C77B7A
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 09:29:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235996AbjFFJ3j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 05:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235503AbjFFJ3h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 05:29:37 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8974126
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 02:29:36 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3566K3WJ028671;
        Tue, 6 Jun 2023 09:29:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=IjnpYrE8Mt3s4OrTm6TWK+ndOWR0ylQnjuwgZK9oDz8=;
 b=c0aXi7MP41qYmKCUAbqort4LfUkVvMiI/IwYP8Ad3cD+ZFQgkAEApT6mAM+VP/wmlr5F
 PB0FOTya7byXWGBoYz9jXVRxV4ew2qfL//XzpKNn/ZA5vU3J98GjnAZQWKgxK1zwshvT
 O4r4GWHo4jKLMIqHpiXtO1IkJnvNKVzRMEXHJOax2iua8U0JneEMM5cLONQIUJJIU/w/
 +X6uGly8O5PQ8rDA7FGDtDRCINP3CNyF8tUzRfMVBOLZ4y1odrLEQYsQkykMU5siC4hN
 Wj0nP9YHvpTcfQrIYaMgNR/NAmoUsK4NW7ve/g5OhR/zZ57y2tGcgJqa2PdQI44F9Vkz 5A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qyx8s4wsf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:29:34 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3567kvNb011175;
        Tue, 6 Jun 2023 09:29:20 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r0tk04r7k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:29:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rp44VOdikmYgRirpHH9dpAKWWMQBueSNEFI44sU3gno9cmbIHvMVBJjmWSfgnu4SD6kKsDlfUdxVKMqhV/a6p4ulgBvcWMHwf9ZWvodP8CBSMU0OFig08YOvm1AWGGYtWZzDYJ87vd/3xkvMJPRy7puOhM7tkgI9/aYyy4iYVlU1jZucSySU1vWdsQVz92kl4lLIq7EZPGtEHcCj1koZVaC97iZoukHsY2pAq9A4A2B28fmhLzNk0p5ojLolNx1GPtqFKzK+6gotQ2ja5A5lyhzeTx1PSp9XNP+wXMc80vfEy28/+t+S7gb5W+Wio+nbWvFM6YU2+FKQq4GXGjszhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IjnpYrE8Mt3s4OrTm6TWK+ndOWR0ylQnjuwgZK9oDz8=;
 b=PFR4247VITkd4luelFd4XxrDl4RVghQm306VQwsCb2fEjCg8bjH7Tl69ClnsmLZBi7J1Fuw/pNpFISwHN4cFCxMLPNAtyzuals/wggSm4TY6teWHGO7qZCA2BSJZwUUYb9K/rIFqLovBuNZqI1LJP9syDPXJ0T6oz+LxzbVKzcVV1q3JNR2E6f+Y4ttKKjl+prgELo38RxzcI7utZDf4grgrKM13X3qwan3wUS8FUvJlaW/qPi4TdJ2TxR+0VUll/l+FiIfHDo5w6cUm88sw/tsD3qQrZzpBW39CaOjZIZBzD5x4Mki8tDriKeijC+eYbVdrvHuyz9mf6pWGMyH3mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IjnpYrE8Mt3s4OrTm6TWK+ndOWR0ylQnjuwgZK9oDz8=;
 b=iJPW5f9WMaAHtN2SbOFGso8WTJNhiox+nfbtr3fN/odEzv4yA6908ymBwuKY9uUYIj/dI1fAStnzm4Wu+HeewX836kn+/tIJIpsk61QGmiSvkz0f9ZfI1bq1QP/A+uX0XPNFBgnfDE869v374pjIEwzctTncXlU4LHEpwXvPpTA=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CO1PR10MB4562.namprd10.prod.outlook.com (2603:10b6:303:93::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 09:29:18 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%7]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 09:29:18 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V2 08/23] metadump: Introduce metadump v1 operations
Date:   Tue,  6 Jun 2023 14:57:51 +0530
Message-Id: <20230606092806.1604491-9-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230606092806.1604491-1-chandan.babu@oracle.com>
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0289.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:3c8::14) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO1PR10MB4562:EE_
X-MS-Office365-Filtering-Correlation-Id: e8ca01c7-16d2-4afe-7889-08db6670809d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nNR7AzvUMX3Wx6bLG+6yJQKNdzOVVo0HnS0kdes2YNoWitEjchKdaSwgZYqvD7fNiV/INX4+JS8+abrjVl8WGA/0wBsIJ5KK0NSkOFmHl9oScjk8p1IEGOUHvEXfrS0NRxr4QFpdZLR0R8tga9odzfBi+NDIBEGyqj6uy+aa2HXy/hejTW2yZv3aG258FCNcrmj+qJLyJVhBGVxG0mSN1U6WPi0urxIOVkgQRnXYXNY27uqrzdBThu7dQhjTDkrs9S23aVcizA+rlaghxZ7mX3tiZK4+KIrZHcivjT4NEcOEYfuXejm6rF4uWN4S6FqVQ7kNqReSbY3ZpzGkWzEOAcTRaYLqvZbA/VvQZv/cIrWCY29D8k6hJlc5+HESamBAA9NBSEHeMLzC0jEjFaqMaA+BoKe0Sx2DkVw5w82aC0qyvBHpfzDn4mEBpAa2Y+NYTVmlhookOiQRANN1+2yUwrF+ktaEyZzF0x3s3SbCzd1I2Yue6ARy5zz/pOq2utaAkc3t3sa3aeawrn1HEe5npn9k/FdFJ+9UoEF0lnaKA+rPDQnJDyNlJPC16cWXTsIb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(396003)(136003)(366004)(376002)(451199021)(8676002)(4326008)(66556008)(6916009)(66476007)(66946007)(8936002)(5660300002)(316002)(41300700001)(2906002)(478600001)(38100700002)(6512007)(1076003)(6506007)(26005)(86362001)(186003)(36756003)(6486002)(2616005)(83380400001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Te4/h0M+2qnWNyuw+OnB2/yra1XRkbq7qfXZJ9s/HYDlGushvhfhvaCbrpJ7?=
 =?us-ascii?Q?g2DvdsMiP60WY9D65ZSbtCH8l+sVa8qRQzccv6YhPZvj41s/TDaAeMpIMSjO?=
 =?us-ascii?Q?xcqoZ5gUrTJEFfTGMCDXJMEcnHQZcaKj8f+WUM80S3JpMrbuLHCTZ+gk8dhH?=
 =?us-ascii?Q?nao0PTKyepJ820YQnsOaJwVro9HH5t2zXeoY2dndJ56xSr95vgxBZHRGj6Hb?=
 =?us-ascii?Q?mKWCbd9Zm6PJ76MLmBlZoCT/lmP1+AHIMqtAB9U/g13SdG5jAubfI2rH5bwu?=
 =?us-ascii?Q?bzPXngKb+mCwB01eMkt72yXBx29ZzZhTtiIjAmetSroAoZfOCyIyQ7td1OtL?=
 =?us-ascii?Q?OdoLdnsyp1Z5lS67AlKX61rYMfPFNWFsLkTiLHdqCgUY3HdAYby3f/DMHREa?=
 =?us-ascii?Q?EnZ9NHQeo8NKs/iysK1nCztabsDHzJkz5B6iiEuaVJY+EGcH/Y159E7qNJqe?=
 =?us-ascii?Q?ssxc2J33IPiNWRfSMoc7U+26S5yfR+bobIIDessYB/SdbThT4r+3razgl+OI?=
 =?us-ascii?Q?VS6evWDwWmNKQuv2A/w6AYecbh7HgVCxSY+frNHvJSv/dqU8poiqYX50rBOR?=
 =?us-ascii?Q?J4QY3XXN2jKXlu/hMOS3Deg87fAEvjhnmtfZSzf5E7oTCJMrPUAGlC1BRFWz?=
 =?us-ascii?Q?uK2uzvy5IOvlWZ/rNVwEBstL5BmnkPSmyLTys6bPW2j89esIJBh8G08BT3s2?=
 =?us-ascii?Q?1XzE20IkhsP2nN93crJxal2zr8U1PRrf0CjMQ/kza6VwLgVv38Ctq2C5tsr0?=
 =?us-ascii?Q?h/H330J8GvX8zxrVCUvxFoXiuKQyzRn/Q/IrN7J2vBqaBROOuYFAXG21wLTS?=
 =?us-ascii?Q?yhwP60vvoBb+/Ujat1+oQg0f8OZQWwSratPpZ4nrSmBT8TKgapmWKXOlCu0O?=
 =?us-ascii?Q?BIipopw2gm0JV0x5Ga9ceYHJthmiKFzUuY7bWkcL9K/kQvMuaUVmY3gQixso?=
 =?us-ascii?Q?boiTpKFJeNczoy0wKhLIhiUiJ1RPR6SLkYuFRvidP/DlzuAySCjSmEsVCXCW?=
 =?us-ascii?Q?DjBRMIV2D1mQzW/tpTvneJVriJtU3nZ2AXankaOr7kWMpxPrNPivDIXw/REr?=
 =?us-ascii?Q?GkhnAPSlkfb4RvJjnd7zk8E6OnIc14vLdLncwBbSw8oE7gYtGLhwsRVE8AaD?=
 =?us-ascii?Q?k9sJnUXJC/uOb3yw/4tOwE00nvZt+ULjt2eXtlwNUc9AMTVrTrD4JhFkrkSO?=
 =?us-ascii?Q?d4T8QC33EyTCX86a2C/ptfwHcg76Vjj0fph85YOiXTB8NxuqRzqOrGO/GWPT?=
 =?us-ascii?Q?vXWi5xxQCwsCHy/mg0A0SWdRwCBcwQ94RnYQDpl3F5A86oXJri/5wh3QyaQ/?=
 =?us-ascii?Q?kqW7/Y4umCUSlh1OHdJqHgNiVm1SNUXcslerc9RzEQjx253quuS3Tao7KPvy?=
 =?us-ascii?Q?6q2CeH18hlAhnHDSIDs/7kFXLy5hkTFcoFgH5sPrNy6kQqGaOdYuvxhWuaDL?=
 =?us-ascii?Q?8kmK/zCXonEH2QyCJJPaD+WWXyGVVRHrQmsYRQhlKJXKsNpX58drm2sm2Aax?=
 =?us-ascii?Q?r/3zHbISCawfQPzx8Ip7uyyST3BD3XCv0MHZNNLkrXlqWxQIGjFyccjTnpgq?=
 =?us-ascii?Q?Jx7oB4uS+NpXh6KT1CQPk3YjVlbOu9OfxcVNpS0E?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: zQjM23euDGLubzW9voQctQgax9kKcaPxhTvZJtSEjIN5RJV1McQX3T/q0J10WCIzUeV3IApgxiESggAcHMkK/CQ6QaUWIT8gWVO8xW4YwvUDqaecHfGB/nGfoEP9/mIslYwux9/x2b+iJxBeBElN74IsikP1WbR8rDC8a/b+9tZ5h+cl2PhW5r2ob+Ui4k+HmSzCh937ibhSqlrYiFTdqg/s6PmEfIAd9E7JDrtHGjtflxW177ltoeiYSjHNcPQduVYH0fxRYLcA8qblADgG/8h9g1knA0oJZeH6IQnA9/qJKJSTu+8+oOQLL6aktr/FD4ToOte8RJ01e/ydCr5PIc8cFVBnvzPbZnR/9VWHFMg/8Q/eKEeDoxG0i9OG3vlTsyZVCfvuRR+rgXSfILmcHUDCoqSM2FxDuswmqqnMKyEvawDMmrVKzaipzAa9cLLEs/yFhhPmhJzXZvYNrQbwiOzrJ5lhTSiQ+VONK4ixaEadbNXxJAE1QY47aVX112J1S2Z6zMvZXD+We2yg+vYXogFVqEzYTzusBN7aAYRlg6qKrLVVM3hp+7fuYd04ylQ6PQBnl/jcb2EUzXpTj/SHvFc2wk6Xhn4Van8JMWOQYXg88hDoi1QE2RTF6/XoR9JiaMlv2SCEzpAnOqNODhNSxBKfArzSdAvCcKFc3Jd+0uEQeuLS0rp0mhVoE8xdd5jTQTS+yPTWzXjPTug0nOBi98rWrtIu5/6qoisROu899mCrLO2ZWFefbD0xe5Nvzuq4s6cu1WcFJkBlCPUhotyGm9MZBhiRb5hqzyv7I0+5XWY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8ca01c7-16d2-4afe-7889-08db6670809d
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 09:29:18.5184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: euTlgURxJT4TEQoy850PjUZ3ioGqADjdCgmQzGwjqF1zDljaDn8tABByG5gLjR9Zj78Yh5lghdvo+9AH7cK3EA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4562
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-06_06,2023-06-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2306060080
X-Proofpoint-ORIG-GUID: K14nPbGbiUwZzT6Slw4e5PFHVnsYQmUH
X-Proofpoint-GUID: K14nPbGbiUwZzT6Slw4e5PFHVnsYQmUH
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit moves functionality associated with writing metadump to disk into
a new function. It also renames metadump initialization, write and release
functions to reflect the fact that they work with v1 metadump files.

The metadump initialization, write and release functions are now invoked via
metadump_ops->init(), metadump_ops->write() and metadump_ops->release()
respectively.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c | 123 +++++++++++++++++++++++++-------------------------
 1 file changed, 61 insertions(+), 62 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 266d3413..287e8f91 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -151,59 +151,6 @@ print_progress(const char *fmt, ...)
 	metadump.progress_since_warning = true;
 }
 
-/*
- * A complete dump file will have a "zero" entry in the last index block,
- * even if the dump is exactly aligned, the last index will be full of
- * zeros. If the last index entry is non-zero, the dump is incomplete.
- * Correspondingly, the last chunk will have a count < num_indices.
- *
- * Return 0 for success, -1 for failure.
- */
-
-static int
-write_index(void)
-{
-	struct xfs_metablock *metablock = metadump.metablock;
-	/*
-	 * write index block and following data blocks (streaming)
-	 */
-	metablock->mb_count = cpu_to_be16(metadump.cur_index);
-	if (fwrite(metablock, (metadump.cur_index + 1) << BBSHIFT, 1,
-			metadump.outf) != 1) {
-		print_warning("error writing to target file");
-		return -1;
-	}
-
-	memset(metadump.block_index, 0, metadump.num_indices * sizeof(__be64));
-	metadump.cur_index = 0;
-	return 0;
-}
-
-/*
- * Return 0 for success, -errno for failure.
- */
-static int
-write_buf_segment(
-	char		*data,
-	int64_t		off,
-	int		len)
-{
-	int		i;
-	int		ret;
-
-	for (i = 0; i < len; i++, off++, data += BBSIZE) {
-		metadump.block_index[metadump.cur_index] = cpu_to_be64(off);
-		memcpy(&metadump.block_buffer[metadump.cur_index << BBSHIFT],
-			data, BBSIZE);
-		if (++metadump.cur_index == metadump.num_indices) {
-			ret = write_index();
-			if (ret)
-				return -EIO;
-		}
-	}
-	return 0;
-}
-
 /*
  * we want to preserve the state of the metadata in the dump - whether it is
  * intact or corrupt, so even if the buffer has a verifier attached to it we
@@ -240,15 +187,16 @@ write_buf(
 
 	/* handle discontiguous buffers */
 	if (!buf->bbmap) {
-		ret = write_buf_segment(buf->data, buf->bb, buf->blen);
+		ret = metadump.mdops->write(buf->typ->typnm, buf->data, buf->bb,
+				buf->blen);
 		if (ret)
 			return ret;
 	} else {
 		int	len = 0;
 		for (i = 0; i < buf->bbmap->nmaps; i++) {
-			ret = write_buf_segment(buf->data + BBTOB(len),
-						buf->bbmap->b[i].bm_bn,
-						buf->bbmap->b[i].bm_len);
+			ret = metadump.mdops->write(buf->typ->typnm,
+				buf->data + BBTOB(len), buf->bbmap->b[i].bm_bn,
+				buf->bbmap->b[i].bm_len);
 			if (ret)
 				return ret;
 			len += buf->bbmap->b[i].bm_len;
@@ -3010,7 +2958,7 @@ done:
 }
 
 static int
-init_metadump(void)
+init_metadump_v1(void)
 {
 	metadump.metablock = (xfs_metablock_t *)calloc(BBSIZE + 1, BBSIZE);
 	if (metadump.metablock == NULL) {
@@ -3051,12 +2999,61 @@ init_metadump(void)
 	return 0;
 }
 
+static int
+end_write_metadump_v1(void)
+{
+	/*
+	 * write index block and following data blocks (streaming)
+	 */
+	metadump.metablock->mb_count = cpu_to_be16(metadump.cur_index);
+	if (fwrite(metadump.metablock, (metadump.cur_index + 1) << BBSHIFT, 1,
+			metadump.outf) != 1) {
+		print_warning("error writing to target file");
+		return -1;
+	}
+
+	memset(metadump.block_index, 0, metadump.num_indices * sizeof(__be64));
+	metadump.cur_index = 0;
+	return 0;
+}
+
+static int
+write_metadump_v1(
+	enum typnm	type,
+	char		*data,
+	xfs_daddr_t	off,
+	int		len)
+{
+	int		i;
+	int		ret;
+
+	for (i = 0; i < len; i++, off++, data += BBSIZE) {
+		metadump.block_index[metadump.cur_index] = cpu_to_be64(off);
+		memcpy(&metadump.block_buffer[metadump.cur_index << BBSHIFT],
+			data, BBSIZE);
+		if (++metadump.cur_index == metadump.num_indices) {
+			ret = end_write_metadump_v1();
+			if (ret)
+				return -EIO;
+		}
+	}
+
+	return 0;
+}
+
 static void
-release_metadump(void)
+release_metadump_v1(void)
 {
 	free(metadump.metablock);
 }
 
+static struct metadump_ops metadump1_ops = {
+	.init		= init_metadump_v1,
+	.write		= write_metadump_v1,
+	.end_write	= end_write_metadump_v1,
+	.release	= release_metadump_v1,
+};
+
 static int
 metadump_f(
 	int 		argc,
@@ -3193,7 +3190,9 @@ metadump_f(
 		}
 	}
 
-	ret = init_metadump();
+	metadump.mdops = &metadump1_ops;
+
+	ret = metadump.mdops->init();
 	if (ret)
 		goto out;
 
@@ -3216,7 +3215,7 @@ metadump_f(
 
 	/* write the remaining index */
 	if (!exitcode)
-		exitcode = write_index() < 0;
+		exitcode = metadump.mdops->end_write() < 0;
 
 	if (metadump.progress_since_warning)
 		fputc('\n', metadump.stdout_metadump ? stderr : stdout);
@@ -3235,7 +3234,7 @@ metadump_f(
 	while (iocur_sp > start_iocur_sp)
 		pop_cur();
 
-	release_metadump();
+	metadump.mdops->release();
 
 out:
 	return 0;
-- 
2.39.1

