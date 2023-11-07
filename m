Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37E57C4167B
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Nov 2023 07:08:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233251AbjKGHIe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 02:08:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233518AbjKGHId (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 02:08:33 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3FE511A
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 23:08:30 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A72NlbE031838
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:08:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-03-30;
 bh=I0zjj2CL6DlbFMncP2dw5WzEyx+XqTByG5FVAskQdFE=;
 b=D49uSDNzl3t2uoxTfLE1CtEU93q8GxbxxmCuLi3YkPCOSJNLHQUBBnLuchn1vXFjpDgl
 JBxuZQSrN5UPezVxvoDBXTrzsTRR4yrkKBW03LGUL8HLvetvEHfYBIY7J4Lu+McEM6Pk
 k3nN3d51DoI99brKvXjOuvxHvIGEo9wdP5odYC85HSo4zcsuUvQ0wTgJczxhIeaPG9Dt
 9UjWgui/7rdkud1vIFa1J8iguKJY7G2rfpOa0HguY0SlXi4qFBSlQTUH4FiBCbfEs9xs
 O5PeF+izZ2ZfzeqE7W/84yFPRTxhUlIGZPevq32dcCLVVE90quWAanJSGPrsMcPQPSLw Ng== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u679tm2jy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:08:30 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A75sH93020794
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:08:29 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cdd1vuc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:08:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N0nOSD4XhdiU8H48S2Zykc/FxI48wfmHhwTb7ywrZ9Pk3Q9HZ6/5BbjuEtEW8PTCSddAytTn2WkhWuLLYLKDg8QsqgprdLcuaBLq5FCaNZsp1hhPZy1r4/bz8ShczUvllf97UKJNVzxgt9AFS9AXv7DojLz9acp0PCBku8DzrwBBtyImdCnAY3SPcGGOGwbVNSB8GkYZIgz+c251Vdh7LufXgR74onLWS7s85s1suXoRzraxi7Gu5OzZVL0Oc3SF6hlKfFZBFS4HP1Y0epR6cFeQIXrtiVREgTdmP3tdlbacTWHnJSs+JZh2SImCyRxd18iQHxdbA/WRuIKhsoYynA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I0zjj2CL6DlbFMncP2dw5WzEyx+XqTByG5FVAskQdFE=;
 b=nrxQsEA1gWk1oFXAxIPsbgIOovERXtcAbYaqIBUdmvaovdvqKPXabx3r53Uj0+AR1xNstv+3xSxA5/CwYRxJFweuPRd6udmGSzxB8niqQse52DY7m6XHCfCA1vXlQuM73UZk4FOWDdN9YW3TLtDsjGVFE7sz9pOsJ1hFgaZtREqv3OPW5y6r/n33UTYhuR6Hh4qxteQIE1F19KbPBPKBzGxYyCH24mwQLxsMaXINo8ICxN0rTtXED2oqTFKRV4tE4lsG7WlcO5pm7NzjPgl2npqPQPgRCxMDecy7yUIu6tsU9k6b5OWdWPozHfsrCrZy76Mn1vEMJS7s7sNmyY2smw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I0zjj2CL6DlbFMncP2dw5WzEyx+XqTByG5FVAskQdFE=;
 b=oGB82ko2ekfbr120D9BuVGFHZvI4oyiVwU+oPRwQ7WL+Q3DFicAysFmugYulQWFtD7J/fa7W4E3OOck4q0DqoHDVYi21OjoCgJrh+m2Qp1DXmCDpDXkYCE1FLkDF0zZOgm6CGX5+DF1CHhXTLDxfixkyjyFVBTECaAKyp2NneWw=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by IA1PR10MB7263.namprd10.prod.outlook.com (2603:10b6:208:3f5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.29; Tue, 7 Nov
 2023 07:08:07 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Tue, 7 Nov 2023
 07:08:07 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH V5 07/21] metadump: Introduce struct metadump_ops
Date:   Tue,  7 Nov 2023 12:37:08 +0530
Message-Id: <20231107070722.748636-8-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231107070722.748636-1-chandan.babu@oracle.com>
References: <20231107070722.748636-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0022.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::16) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|IA1PR10MB7263:EE_
X-MS-Office365-Filtering-Correlation-Id: d52e5a5c-bf03-49d6-2744-08dbdf604af9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MaVlvG3FtGJzaFI0DQApFvCWGOscwILJmIJjZvPkRHthHygBVzFIySG49ZeCiBkoFlnNEOhXIhZDHBwfKdHOm8hjcyBJTOmd1mU0WF0p4L4LmG8TccwxAVFTb2SKjbbuFFQwAddyWo1i1pROXnlBSLK7BtAaGb7UwPrNoI8hK1ixrnL9PtvGV3aMtP3iH8ArdxfkfASwo3wAy1oCCBpVfanlOh/hIDDqvAFdq/mvbfU4wP5X19vZGny2GYtVxCt4LTWfuYQZAS5rmDs+grjw70m0U2Jh2Vgp2um4hac1p1UhtBspDSKiZ/AwjOrpZh21c5MF7MNLf3pf5DfYvvoI+ve7ybcOdWPx+KLwqZLa0l107tZ7yeVEPATAFJU5+xV/2g62MvCpMHjFVY0UqMt/ytk+Nvm/S0Xgiq8IfsD3NCOBHG7ac7mEksfcAUffYoU2xcYDkb0T/g51OE5xPVxk4Z1Vpao3RDv4qjht95EEpHtN1PmyPUnpBSEcVcGb6RsV3EiZ3CjvqKTJCla+AfvwAP1qsFwT4EUEAd86wVvPZ0B8+T+/bzTMRs34T6JjhwlB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(346002)(396003)(366004)(136003)(230922051799003)(1800799009)(186009)(451199024)(64100799003)(26005)(1076003)(38100700002)(83380400001)(5660300002)(2616005)(6486002)(6506007)(478600001)(6512007)(36756003)(316002)(6916009)(66946007)(66476007)(66556008)(8936002)(8676002)(86362001)(41300700001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IJf0iQdWOt6TaYUcdMJ4NvpuxRFSD7rMggPqZ5nWkDdunr9EEKbofgpejBUT?=
 =?us-ascii?Q?xFkYRb95w5y/fjNnjb0eLCepvA43n/Fiz1No93XCUI3HDxypQx7xZCjPnl+2?=
 =?us-ascii?Q?By7fV14vc2ytZ/dw2HOplZ7svwacUcbvRB3F6jyoIxWKXLp+B0aoVlq3C2qG?=
 =?us-ascii?Q?88/8uw2cqtOX2GmVN2PwvzWp/siMGg1Njl6KF1pQqotym+5SBJNHYPvwwrwQ?=
 =?us-ascii?Q?mTc6Ry/U/KHdWzf7QF/JT7mKpo491MyBy7KNvoa+zqTUow1oe1O//e9LFvEw?=
 =?us-ascii?Q?6HqsqgEg+JgFaxOJxGk2qxblbemZOhA6juIMlmUI5/3lBa5lyVKF65ef7hJs?=
 =?us-ascii?Q?zcVEYJhSeKtstWxMx0HbS1xl95WX3K4GapTvdvc5K4jdeTanGmOJTA31LE0d?=
 =?us-ascii?Q?xqM6MIYwbtHEfeR/sxPKFORWP6J/Rb2ckBYcYadlTt9zBa4TBaRpeS6sgZHb?=
 =?us-ascii?Q?AIje1Xn16zrokYIqRm7FIp+DUb1TVVuDPnPs0GRW+3dm6fPceGVH7pMIGpWz?=
 =?us-ascii?Q?WDmg7Qu8wKAxPPPdeM91AXI3/4oJzgrCg4+KzuAq32NjSlAaDJd5ANXR4Z3d?=
 =?us-ascii?Q?CyPJiZApczP1BWYzwOeuxvz7yCF36LUPHujn5O0zf5D+PBINQrtaZ1Kq9GBP?=
 =?us-ascii?Q?u7uzZEFs2lZOZTi4e3qAI5qwD9LwPebLyI/cAgH8f0sNj7DYbtpx16/gUfVq?=
 =?us-ascii?Q?ZdYwPTP5zIKu++SJYsejY3smHvOcIeA5bjE2+dL4xrJ44N5TL/Xp0IHDqkr/?=
 =?us-ascii?Q?5fkK7eTUgT7YS9F3vQ4Oimr3y/H2p32kpMsTuG4fOzuQLZymaHeMeYLGAO1z?=
 =?us-ascii?Q?yv8SQO6LRNG5t/Nfmg1OeHPtlEFi+Wm52wZKPkJw0LQtLVUUUMW1y/8vuQQv?=
 =?us-ascii?Q?tHzosQACWBiXQbAIdtrOeFpd76cVr3gM/wlZakJkSG3SX584khBa+bUA2XDT?=
 =?us-ascii?Q?MhMlDH4TMWYcrwQsRszCbZt1+bKdTMyfSNppj78FdkIuqeVKcKZea18N9v2t?=
 =?us-ascii?Q?PFFkd5AHvME5TiuywQGJO+0aR7sNRnFhYp91WjbhWkBDi0SshGrcxHVChhC2?=
 =?us-ascii?Q?hTY56w4Vw2rOXTgiBGahhpGtD9h7gc8tSCvu60C1iYNMT3fc9x15+T/u6Ek0?=
 =?us-ascii?Q?Q9NcJnIaf/f5YMx6a4TJKboJE5JgT9EEtU7Yg51aN6H836IYbdHuoIjG+C2F?=
 =?us-ascii?Q?uuYfthx73l1db5LuUUNyLJHhPhIXyAdyDEvi7ZPTnCxbmYDOo1MZog5WwLKo?=
 =?us-ascii?Q?0FRPqleoe+jjFmjUeVD53SBF369IDM1WlvOKxfe/0+yi7nSYpFguG8PlmyEx?=
 =?us-ascii?Q?duT9RU6ZVr5MynvdYaVVOxLEL6QJDbBxm+K5iUo9BiwJD5gwKoMVCGptkeCJ?=
 =?us-ascii?Q?LlxkDy3QmdYet98g1Q9q91NUfM5x7ii7xtP0JrbNXNdE7ctomgutRy2SyMR9?=
 =?us-ascii?Q?MjnVmuNBdkxUZV2wyIT+A1EHeW37lt2+fs4e1U+HQpftYa/e121TbKRpq374?=
 =?us-ascii?Q?leWFzWjcE93wego1Y+6uwLW2GoHoOwTLs544HTG5Frp+0xRDbkMfTKUB33yM?=
 =?us-ascii?Q?CzhbmnyG4SnQBVBQyfXUz80YuMf84fLZssMlKlYm6aCJhEqNBwjoUOJMHM7d?=
 =?us-ascii?Q?Tg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: r+Lls4O11j87cRzWPLyddYGX+ygWYIq/jzhEtENifY4WESl2tHmqCRxJZ648PldIsvXNcYdxd/Ah4eANhKdL+DwRoM7gVvkacx3Gmbv4FeKWt/qp59pyeSN0gFcqnugn4TCi/WuTqhbqNpEajP5RRfAFMMCj4jbnavWC/XsKHQKNalcuSTK9J0hFPqwx8R50JjbfOpiwPclh6pmBhXV+2g9JtnwW3W1ZqDmAa3nGbL8Wwf7c+KK/QZ5h5/QuebsqRnGhVnasG4wciEe151RwC4EFqEA2aG4sY2dA1c2Mo8YkDRl+03NtYBLmCxD4jH8UUilxT339HJm6yC2Y25qrwYkhrg7j0j/UikxViARWppWOtoWxYsYIuNMMln3TKf02qSdrHNDAt+JozYJUgWTvzeV5egYKgtvw33MJYZ4/jZvxRkCNaT75P+L4jqlyp7V1lyBzHXzMMmvxequH4yDyxJ8mRT+8kF/XOvkDjt40wwBPs2hPxSCvrrx5erY1JHdDRT7K323rTQJ0EA9kSfKL2q+4uFXHGlS4/2AIkSihGUXwXEFcay5oufSp9qhRMvjUg8abuod/mT5S1c+dQAVfiie/pny/v5Tb/hXugtRhaAsh3Ugv2dx9ZvpDyVVvoRoVdRdMCTTv0cxk4btaSYaupbsiJ7IGGtT+e3dD+PVI2C1T16NYEfFXBBdn/j7lkWWp4fZwuuawca5CY6p5ouh956aZrspViq9/sdnFsQF1NEXAS/SbbqJRsb+UvCBaek3WoKDSTqYzP9dNDhURfOMFzA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d52e5a5c-bf03-49d6-2744-08dbdf604af9
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2023 07:08:07.3356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cT84FXxe5Fu3y9kiD5mvDVPX1CslR8lyAo3HVw9D3zlV0w7s+OghOEWiqW95GoQy0lk+Xe2Sxn87XJz11Bh5lQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7263
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_15,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311070058
X-Proofpoint-ORIG-GUID: OU75lehwllIY5bRaSNWGh40qCcYx3GSz
X-Proofpoint-GUID: OU75lehwllIY5bRaSNWGh40qCcYx3GSz
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
index 24f0b41f..a2ec6ab5 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -41,6 +41,30 @@ static const cmdinfo_t	metadump_cmd =
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
@@ -55,6 +79,7 @@ static struct metadump {
 	xfs_ino_t		cur_ino;
 	/* Metadump file */
 	FILE			*outf;
+	struct metadump_ops	*mdops;
 	/* header + index + buffers */
 	struct xfs_metablock	*metablock;
 	__be64			*block_index;
-- 
2.39.1

