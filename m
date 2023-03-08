Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D926BC6FD19
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Mar 2023 22:38:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbjCHWi0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Mar 2023 17:38:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjCHWiV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2023 17:38:21 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4995960423
        for <linux-xfs@vger.kernel.org>; Wed,  8 Mar 2023 14:38:20 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328JxfQA001632
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=cWzKpC4JeeUtDEmxa4jbTgEim+CrQ7MaR2cG7+iHYHM=;
 b=UszGo1FI9S71s9XkuoK3TKU9BuW2qZhdvp7+YVY1jAjuBibU9P4ExdBrOpSFpaUaul2a
 MZENPo+1Go4cyBQ8un0oyKXb1VZ1jZY8dASfKklMduCqsn7n+Z4cLFZ75XSD9Fg0EewC
 puoUI3iDnF4mImeQhMOuvpRcOKXsIOgV083IithQ6TO5mBxEfnanlaSF7GuolN+HwpkN
 cTqpzgLvmxEJcgQG7iT33WId3OGquao65MomaytFM3P9/GwftSvuFgBUg7UlSRS5mOMx
 pCi3EMJSbixfxFTL7rGQQPNTHLCu5EhNwSIkzyVGXDvYIUMNlTzOZeWV9Yr//rDbOJER kA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p416wsd29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:19 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 328LM2BL021689
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:18 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6fr9dws9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZyIhzDPjlv4rDHS+9MjniqWZKOU1mA6MPmz3k6RjQ3S7XxEwuUpiJ6/CrRI8ADKtZiVedRfrCTpxJObpC3C7nTPX81gNebuRuGrXO0/uXN6kt5mWqIwEWmX4yMOs395jcoCUp7zx8FE3CQ3xbmhxkVLqieOMTzG9VOt9pXaFAH+i2nHGtLp1h/+vMnNPboJbtYeBkqcPB2d3CTA8mn7wZ8CfKd+zqE8XDrjrJzJnGqd4t2zS2CwhEeN2aPzF7P5UBfwevTxGkvnWQSTIrOubi38XnRBT7mpYRfrZmDaizltrTvtqjtE0JekYSxHS8aygqeHWrfhnuTtA4h9dGt081w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cWzKpC4JeeUtDEmxa4jbTgEim+CrQ7MaR2cG7+iHYHM=;
 b=B/Q+ehES8K77w+vskXNUdHf6+OdogH/F4OAaG37OexYyfjIgKRGxZ9m6+1K1usCvCn4kIflPLsKISjtT6Y4xNW1xCeEtWZ0PclhVC/jGPDyKOh0nrb99hJ9f4wa0rJqJHhOQs7aWiM4ZQoIk5CCod/MV4CzWWaxy4fw8VRY1YY1rVqo69iJPHp5zyiJuq4BMtsT2S7qOi8n6gyyHCl6GX05qlUaBJHSveAU5/F5/f3ashxzl2TuONGErFZBP0heHrg2yymsed+XDNTVetgJgoKEJGJsj0gMtJmI5eh1UmUsL0CsqtWxsJ2EUruZU1TOe4bHIREWnIHcMhaOMl60vog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cWzKpC4JeeUtDEmxa4jbTgEim+CrQ7MaR2cG7+iHYHM=;
 b=f1bDPNZR2/iP5JZDvi4bn3ByZo/9o1WcVH0WBIyQzoZaQmmOQN6zxzYAKCOkqVxBlDZld6TIAupq9KrsFf3h9s80NhhYgdOcIB9OylT5tawC5RR9gTCynGHO5P6p9QeMFVzzvOBEvzsRLQC1Adcl1a+jmf0tW9v+jRz63cQjFDo=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB5708.namprd10.prod.outlook.com (2603:10b6:510:146::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.27; Wed, 8 Mar
 2023 22:38:15 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06%8]) with mapi id 15.20.6178.017; Wed, 8 Mar 2023
 22:38:15 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 10/32] xfs: get directory offset when replacing a directory name
Date:   Wed,  8 Mar 2023 15:37:32 -0700
Message-Id: <20230308223754.1455051-11-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230308223754.1455051-1-allison.henderson@oracle.com>
References: <20230308223754.1455051-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0234.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB5708:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f775693-ec24-4069-47fd-08db2025ce4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uPNCFiYFKR+Ri5/tcN2hZ0gFebEGDovJBsT9s//MC1aLqSuVFAuinUGWIaPRIq2QEvtjdfakGOUsJVCiHln+j25v7Eu1qDle9B/8gBEd2Qvqneqy1enOAoq+Rhy04WqbzKNPfFeUOeZUBcnDKOiCFF/t8nbrZnzRmftbxMvJ/cw6w3/7Q6NrZpSp+UOQ/FHECCTSZpmxysh/x1cfu1RgKzSQYcRbmxZYXtUNusH7NGG9Ym9hrtlVKBn9O2Bemr/CjpEIuJliImbdv7P66tVZIGzUOThcClVoWsSEy3OEqKiwKtD8Kh+Li80Wl8JR9a/0xq2qo1a8ReOD9lC4DvlKmAlZI7pIoOYOnUVldB1g6S04e0OPECmOizXzzGgZ+ptRKRlB8WqevBkLLN9LJGdtHciZYSo0A2fRxThilbb3a6cBDYzus/lV56P79MwkE9+UFxGbi7/YYNMisDEod3MQbp6I5BC/Kvpml873Ls4DiCFn9auXLz1/4IB+L7uytw9kVjEVitTFaqGRwJNbtFt+Wb+p5G0fvhlzFn24AgaaT6TQGXQdqTXeyRBwMhyMMJDII4XvtrdRC8jbkwLqs8Pcu67gleLSTODVIIExAzEWj+HKrowtVXX7b9Nf3djiSD5Jnyxhi4Yb22E4HPBtY7n5ag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(136003)(39860400002)(376002)(451199018)(36756003)(6666004)(478600001)(83380400001)(6486002)(6506007)(186003)(9686003)(1076003)(2616005)(6916009)(6512007)(8936002)(66476007)(66946007)(2906002)(66556008)(41300700001)(8676002)(86362001)(5660300002)(26005)(316002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NWJ5atVW0JXeIU3EQTkkYdsBJokuQzUdsSQpKbRZ5+sLhk3KSoNCYQecDUB6?=
 =?us-ascii?Q?i8ziXd8HWQ19zMtH5pNIQcC9IFhrXxpsn0r9iW5U2C/GCsrE9F158/TVcAAA?=
 =?us-ascii?Q?3qXB+VmAgvhIV8NPQsmRecokTGdBhbBAxng9GiB6ddKtFEo0+tmMgWTatJJ6?=
 =?us-ascii?Q?kRHuvmwC/Mp++hceuS7sgfWHjBT61bOFDXJZ1GXh1ncp40Kfhekqho7RHxlz?=
 =?us-ascii?Q?BzSJTSS57VmAUEto0mNCnzj26cQ/EtUsGauDrZ4LDHLrS+Bhn1+Ec9rRfbQG?=
 =?us-ascii?Q?Y3LD4uSL+Tylv7Ir3D+ea8EqvI1oT5xB8NVvCHaWc4syv1tYuM9mGPRFT/B2?=
 =?us-ascii?Q?b04kn6ODhLWFTOHP8l31zBNp8Avo5tAI3IvlHiEeK1jG+MW2ak4WP1kGpATD?=
 =?us-ascii?Q?5N5lSvNqh50bBCfJb1eeg3tlSFjZhQu3A8dxE0NS3QOdQhsjFgeNVbVu3E7X?=
 =?us-ascii?Q?4HaJ7TDwgjNTG7f0jORoG9Jn+aESOX314eZ2lpCesMgXREHIqFYloDKzpkB/?=
 =?us-ascii?Q?Pi03h8cEEI1Rx7uhpHhLXBmULz4vmtcWmybsYweyar277a7XHQU5rKl0eQN8?=
 =?us-ascii?Q?Ha0G90Szn73EmgYerI9E0K3zZ277MBAHl7SQbr4k8b9n8BKEo81VRGxxep/A?=
 =?us-ascii?Q?GyBkuIzVMb8hNHX2+Ucu3adrNhldl7YGO1Ev7S+sWnEaqkcZDFu/2zY2MEgT?=
 =?us-ascii?Q?jf9eKdzwGF9pEOcYE2hpqAyiVR8S+d9qpNztSVGXWU3dT1MB/P9LgcGTNOrc?=
 =?us-ascii?Q?Y5dvw0ykfLUxW4I6DJrzIHapJTPQ8DmEbp9hvTI6+oF2YLXlB7uqoISH8Af0?=
 =?us-ascii?Q?oMC7Exw/s5UmSTWqQBO6WA1aNn4GvfcGggV/SAM5HKkzDI7T/80EN36qJLaY?=
 =?us-ascii?Q?qmBIcpUNKmFQfCDAUrYcMtQ5TBwa6JaHhHB1w5AO7bjZtM1HWEmrpOvOf5yL?=
 =?us-ascii?Q?pQR31xWsucgAtBi3O26S64awydSM4Kh0g7e+7erIN2RqDoZwb6vM038U511Y?=
 =?us-ascii?Q?xcpDoD0CNtkgldwD18eHakzekZB7Vz7/N22JWOCTEeZrPmJs/Rimh88jgdds?=
 =?us-ascii?Q?11z36ggJXZMSJhluqYQITm2PcLYiKAyBudTB89babbYa8RLoX7SMxY6Pc9BL?=
 =?us-ascii?Q?/mx5gH1c+fieW+a+SrM4NQD8Cop5UN3/o1Wm+o7wSpnQLGvdjXc3+AqkEF9Q?=
 =?us-ascii?Q?O7CgxAhlmyG5imTEwxruarsczjdoShTo1S8tE2vvenjDVL/yfUnygbDj0MfZ?=
 =?us-ascii?Q?5LtLqEdaXT4s/SQ4YshAE2NI3twfatLoyVlAHGSSjFyc2p1x7LVsjBmSWCwb?=
 =?us-ascii?Q?EXJe4LFQ+cuRRmgcHJrPO2S1C0qxClwNgab7sy3yPhjD9uk8VQSftVvbpcq0?=
 =?us-ascii?Q?eMePGyqhaHPijuxPIun44XClynqG8mPc0zJBoapiEQz4iRJAgBKctcfLZXlI?=
 =?us-ascii?Q?nDvldIOCdKuwG8E2pUmIrD9jXJY9e0DkKMSNd1n8Tw6LjSyYCgblYpV7lQj1?=
 =?us-ascii?Q?nVG6cCBWfav5l2e3qVDJ8JU/0jBXppAaiqev7fTvPB2t0e02AjvP9wIkVr3v?=
 =?us-ascii?Q?OSnCD/SIszv4HHdWPu7E9gB3dbrJJO4W2iV9GHCHlojMpKKJScLkLfzh8dyy?=
 =?us-ascii?Q?6Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: laWWZF3IdOQ0wztLwDBQyhAb4vHcT6T97kT95/K9cfIvn75HVUmuBrUztn9sgRuPlvT0ZZT0VE2JA+iMem0UC7vd0ZiOR785utdpHV44C9aoI8qFv8V3XaCVYUtRtUgPtusd2F+01kL5SW1uhuwCmN6fH0Bxs534wwnJqeRoP5Qz/dDvWQ+cDWQiFokZfOxZnStMrzBU9c5ypmafdP1SRgUia2RhS2deVFoMDDnCnAvZ7VZ7UkzVvuH4ssb0eaqY4Sd0lQ9+Z1KfXaAn+PKLNhmPkXnO/NM1X8MqG9Fe5qGkAcoa7XIdTNEVlICEh+1/I/MqXFO+lMsthrwclhjCw1d5Q0FC7CNkXDmL6HjtWcj7SVWh/Igchvwty4UdRp3+HUCxkNjOLAQwEmDdaDAACZhM3Dgs7adhLVgTlRCDIZb2D4Kr9o2kLG+3PMcUlSsSNmIFuqvA8x0mvDXgCcvZQ+2hWGBVKV+l4xcsd26Aix/96+NYWTVXiTrqJ1i+VrFWlXw5G1zutM0hU4yfFHEnplrRXO9H+7e7Ygy5J100Il96VEBsSt7ksu1NkE6O+1vKbLf2ECmu+sIXxqE71zMed+fUWnJSwW0crGgEOghQy8n7gVSw75e2mctt/1XPnRH6XIEFaouBARgj5QkuF1YtZo6oKLRKiBmd45NUWIdcFzbarKZAHQ/5X6FvrgsKOaspStbBGlwcYhNWa9eRQhpgtUKKt37vvmNGjvon4Fq59fPkg3zIW2zgJAvfOKurJxu7kyQGlAGvfuekm7ZooImlSQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f775693-ec24-4069-47fd-08db2025ce4c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 22:38:15.2541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /asttIBacM0IbghXH2r/8LCcZU4wGIVHnzxFVe4dD2tOoaQQhrhKL/5MqGG9Q9zNvUP+jRi1oZic9iFFzYkqPXghUckbf3uXLR9wwDbGxJ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5708
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_15,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=927 phishscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303080190
X-Proofpoint-GUID: dOomlXCjnMfzj9lzhFNB39OY0ApoqWTe
X-Proofpoint-ORIG-GUID: dOomlXCjnMfzj9lzhFNB39OY0ApoqWTe
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Return the directory offset information when replacing an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_rename.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_dir2.c       |  8 ++++++--
 fs/xfs/libxfs/xfs_dir2.h       |  2 +-
 fs/xfs/libxfs/xfs_dir2_block.c |  4 ++--
 fs/xfs/libxfs/xfs_dir2_leaf.c  |  1 +
 fs/xfs/libxfs/xfs_dir2_node.c  |  1 +
 fs/xfs/libxfs/xfs_dir2_sf.c    |  2 ++
 fs/xfs/xfs_inode.c             | 16 ++++++++--------
 7 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 891c1f701f53..c1a9394d7478 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -482,7 +482,7 @@ xfs_dir_removename(
 	else
 		rval = xfs_dir2_node_removename(args);
 out_free:
-	if (offset)
+	if (!rval && offset)
 		*offset = args->offset;
 
 	kmem_free(args);
@@ -498,7 +498,8 @@ xfs_dir_replace(
 	struct xfs_inode	*dp,
 	const struct xfs_name	*name,		/* name of entry to replace */
 	xfs_ino_t		inum,		/* new inode number */
-	xfs_extlen_t		total)		/* bmap's total block count */
+	xfs_extlen_t		total,		/* bmap's total block count */
+	xfs_dir2_dataptr_t	*offset)	/* OUT: offset in directory */
 {
 	struct xfs_da_args	*args;
 	int			rval;
@@ -546,6 +547,9 @@ xfs_dir_replace(
 	else
 		rval = xfs_dir2_node_replace(args);
 out_free:
+	if (offset)
+		*offset = args->offset;
+
 	kmem_free(args);
 	return rval;
 }
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 0c2d7c0af78f..ff59f009d1fd 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -50,7 +50,7 @@ extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t inum,
-				xfs_extlen_t tot);
+				xfs_extlen_t tot, xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name);
 
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index d36f3f1491da..0f3a03e87278 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -885,9 +885,9 @@ xfs_dir2_block_replace(
 	/*
 	 * Point to the data entry we need to change.
 	 */
+	args->offset = be32_to_cpu(blp[ent].address);
 	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
-			xfs_dir2_dataptr_to_off(args->geo,
-						be32_to_cpu(blp[ent].address)));
+			xfs_dir2_dataptr_to_off(args->geo, args->offset));
 	ASSERT(be64_to_cpu(dep->inumber) != args->inumber);
 	/*
 	 * Change the inode number to the new value.
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index b4a066259d97..fe75ffadace9 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -1523,6 +1523,7 @@ xfs_dir2_leaf_replace(
 	/*
 	 * Point to the data entry.
 	 */
+	args->offset = be32_to_cpu(lep->address);
 	dep = (xfs_dir2_data_entry_t *)
 	      ((char *)dbp->b_addr +
 	       xfs_dir2_dataptr_to_off(args->geo, be32_to_cpu(lep->address)));
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 39cbdeafa0f6..53cd0d5d94f7 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -2242,6 +2242,7 @@ xfs_dir2_node_replace(
 		hdr = state->extrablk.bp->b_addr;
 		ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
 		       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC));
+		args->offset = be32_to_cpu(leafhdr.ents[blk->index].address);
 		dep = (xfs_dir2_data_entry_t *)
 		      ((char *)hdr +
 		       xfs_dir2_dataptr_to_off(args->geo,
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index b49578a547b3..032c65804610 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -1107,6 +1107,8 @@ xfs_dir2_sf_replace(
 				xfs_dir2_sf_put_ino(mp, sfp, sfep,
 						args->inumber);
 				xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
+				args->offset = xfs_dir2_byte_to_dataptr(
+						  xfs_dir2_sf_get_offset(sfep));
 				break;
 			}
 		}
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ec5ebbc4d52f..62c9fb2cb96e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2489,7 +2489,7 @@ xfs_remove(
 		 */
 		if (dp->i_ino != tp->t_mountp->m_sb.sb_rootino) {
 			error = xfs_dir_replace(tp, ip, &xfs_name_dotdot,
-					tp->t_mountp->m_sb.sb_rootino, 0);
+					tp->t_mountp->m_sb.sb_rootino, 0, NULL);
 			if (error)
 				goto out_trans_cancel;
 		}
@@ -2644,12 +2644,12 @@ xfs_cross_rename(
 	int		dp2_flags = 0;
 
 	/* Swap inode number for dirent in first parent */
-	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres);
+	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres, NULL);
 	if (error)
 		goto out_trans_abort;
 
 	/* Swap inode number for dirent in second parent */
-	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres);
+	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres, NULL);
 	if (error)
 		goto out_trans_abort;
 
@@ -2663,7 +2663,7 @@ xfs_cross_rename(
 
 		if (S_ISDIR(VFS_I(ip2)->i_mode)) {
 			error = xfs_dir_replace(tp, ip2, &xfs_name_dotdot,
-						dp1->i_ino, spaceres);
+						dp1->i_ino, spaceres, NULL);
 			if (error)
 				goto out_trans_abort;
 
@@ -2687,7 +2687,7 @@ xfs_cross_rename(
 
 		if (S_ISDIR(VFS_I(ip1)->i_mode)) {
 			error = xfs_dir_replace(tp, ip1, &xfs_name_dotdot,
-						dp2->i_ino, spaceres);
+						dp2->i_ino, spaceres, NULL);
 			if (error)
 				goto out_trans_abort;
 
@@ -3022,7 +3022,7 @@ xfs_rename(
 		 * name at the destination directory, remove it first.
 		 */
 		error = xfs_dir_replace(tp, target_dp, target_name,
-					src_ip->i_ino, spaceres);
+					src_ip->i_ino, spaceres, NULL);
 		if (error)
 			goto out_trans_cancel;
 
@@ -3056,7 +3056,7 @@ xfs_rename(
 		 * directory.
 		 */
 		error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
-					target_dp->i_ino, spaceres);
+					target_dp->i_ino, spaceres, NULL);
 		ASSERT(error != -EEXIST);
 		if (error)
 			goto out_trans_cancel;
@@ -3095,7 +3095,7 @@ xfs_rename(
 	 */
 	if (wip)
 		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
-					spaceres);
+					spaceres, NULL);
 	else
 		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
 					   spaceres, NULL);
-- 
2.25.1

