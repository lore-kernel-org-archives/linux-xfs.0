Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 954C0C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 20 May 2022 19:00:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353116AbiETTAu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 May 2022 15:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347982AbiETTAs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 May 2022 15:00:48 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9459FD9
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 12:00:45 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KIcLTL010504
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=FZIT+Ft1J+BSRlt7nBwmOtqiPhJlZ5Nj+OU0DTQAVVc=;
 b=gzotGz15vhJn9ZXmLIUxsx8XCsujpTtBiWDTEPi7tT2OO4/FJT4JdANJoIylZI1a4oBg
 9IpvxNmrjyfEI4Umdl5SdXemsJ+3dsFthFy09xxJLCTwNWsyi2AtIlpppxh9Y9MZz9J5
 pZ/hghURCel+k8jpB/Mg181lUGXP8+PCY8Dl0eHnNLhOPL4ySISUzt/20H7iPfsYo9PQ
 lJGNJA8zn2Loh5gMnbTmkf9EHdeoBTiIYCmGsJKDKrK73cb7EoyivkJMoEY9f7sWIdl6
 pWgWTEGI9ZnYr3VsXsFlizFN1iC+KssZV3an/cy9xF+k1iqdF5JORzTb6CyDYZCj6o7V mQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g241sfvp3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:44 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24KInrM8031336
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:43 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2045.outbound.protection.outlook.com [104.47.56.45])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g37csr1tm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SkHKSpHUbPlblN2CrK4NVKM7Ri38Nkus2BWi7TeWvx17R3ZVYz69t5+j+UIgWX0LgekNQ3vIIN9kSnAm/ypl/5iO42w+s1dBwmeWrwsJZXqZP6QnBzymhwqLh52ncBgc4aX6cfzGxY5SqU+UhTrUSrTNtPrGotBFRgENB2w5MoCgeT/V/3oIUhwys2SkfqOujfVh7KeyoJVTNKGFmCXyuhVy1bCwXiHArUR2Dn9b5uBpyCDsfmsjIgq173TJ1BFQE2d4XEJYNUXpc74OPS/T5GftJYcANJIAVeGRZA4nrMiqQP/aY0MAs1/inV1YE4MW0ZBO3tLfhexgcPJkn84l0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FZIT+Ft1J+BSRlt7nBwmOtqiPhJlZ5Nj+OU0DTQAVVc=;
 b=XDho8wgpqdosBYL1a0Bj7Q1TPATIkeAc2bOd7Q+3N/+zCwwW5rbWgAxmjaGLkLLprb7AN18QUMeUYZ1Sn5j/Q73mMALd6h3ejom5DE0hp2lkgAoGvj++CSQIQIggjlwvoLp3AQFL8p3VEBW3DXr98MoDBz23PLfsbxuFG6d3tNSuH1hsz3vmQzESsyM6uhPknXUGKH+tD5brxQFrctr/wbLXMYi3cFBfIqeh/wbSdIPGYMpyCyd+EAAv3Ovl8LEGtINbIUzlxS7OCzVqjvhiG5UUu5MIHdOXOcLHbCuyIg5fGc0VdcR1EMvpg/iukMUiprVC1iHy9XQhKH8s4vu4Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FZIT+Ft1J+BSRlt7nBwmOtqiPhJlZ5Nj+OU0DTQAVVc=;
 b=g+9h8fWn9h7ipGcXPoCvT2MobcsKNGv6/742cHsP6HKDVh5NpiFHcrkR2pA8V+NE8ueTUnY6AbdKEgzwC39Pg62Z32SR1IawN638NwkYUt7JmDtScYVqj6/Nqw2n8Ynj/t88X246zLlRs207PSmCCIEXM/s6IDhMBQ5aDLxw37s=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM6PR10MB3658.namprd10.prod.outlook.com (2603:10b6:5:152::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Fri, 20 May
 2022 19:00:39 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.018; Fri, 20 May 2022
 19:00:39 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 04/18] xfsprogs: tag transactions that contain intent done items
Date:   Fri, 20 May 2022 12:00:17 -0700
Message-Id: <20220520190031.2198236-5-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220520190031.2198236-1-allison.henderson@oracle.com>
References: <20220520190031.2198236-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0014.namprd04.prod.outlook.com
 (2603:10b6:a03:217::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ee25ddc-359b-4d38-cbfb-08da3a93076d
X-MS-TrafficTypeDiagnostic: DM6PR10MB3658:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB36585625FE06DEEF2234841495D39@DM6PR10MB3658.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: azJljG0dGtsoEe4Y3/1pvjzT9EaKOzADzzF8w62B/uNy1+h5Lxyk0x7+QtoSHJH1oeEfYXYpOaGhp1JxRs7LcbylpdpRyWDoAPyCz7OVklqQadJRgedO4dMHG1tMQsxVUz8+NtnuDmf0uroZRDdnEZ8ox8PryJiRPUh8qS0vAGhbc2nxj4TlP8VFVZTOc8yfjaZuXumptO/K24NbNmcUJEuFMJedzmW4ZcKk5qjqBE1nwZdyY/2rOEt+fDd3F8EtuOajELzpK76kt8ZW3K5I8B+c4cUqfn3CQ2GO3RMctzLTZYFy25yD1VwD5EbXtCTgA/XBw8S31g0EnptTV+Ww+h5CxusanGjY3sN0864R7FBUYk2B10VLnd7o42R2lG5eIEGK3nQw/xWQjdCTng4p7LrSqLhQew7kQc+WQ9pJMe8qYDFjxzTGYYho0XkwIPHE2nMmPRLzds1Ea7JqdU0Um1WvB/175yXhrkib6dExYX0JW7+RZkCGb2jodlDiZGkFwLPkLCfwU8gY1tA4qmoL6Z9qzWsaSX+9eGWUs2WQu63skkNdDE5z19hb0ovMaB3kJz3kCZPqgF0+KnEesRL6DmJJohmHs9Eqcm2rg4/zwiv5/CSC4KcJRDbuvH02cb5xq1RgV6h0cJdZgvIyxAIjMTa2TjlOyls87by22MV2JDWN0Ew7yoDb5Y//ZoPEwGpD+gX1vjp1kLf1BfR8qjreOA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38350700002)(86362001)(316002)(66946007)(2906002)(38100700002)(6916009)(8676002)(66556008)(66476007)(5660300002)(8936002)(44832011)(1076003)(508600001)(26005)(52116002)(6506007)(36756003)(83380400001)(6666004)(186003)(6486002)(2616005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DjoFElL934G/oGhcpk/aFz/bTVhA+lqqIzdMeusOxrCDjpf/udh47aJTOwqJ?=
 =?us-ascii?Q?7lzPQRBYVmVsd6SXieekbwsdWN7LrDfLyulXFQw63dLSWUVHCbl2CDbJFh2/?=
 =?us-ascii?Q?5ZfRnLrKirVHtEVrG7Z8ywFunGAWgD+T3BsLJrwnktYFo2yTjxxOAOVJq2uS?=
 =?us-ascii?Q?mqXui8unnTj7j5yGEey7RaxpRfUzMvYe71mStMOzp9p3kE4wrGGioHlTVwGq?=
 =?us-ascii?Q?235kR9nH7lRN1SKWVOzh/h/UDXReQIylTH9YqlDmSYi852eGzUj7ep7ZHxdv?=
 =?us-ascii?Q?sahSv7elETd1WXsWHF/O9lTZjJFyABjO3/na+lV0R/sKgNeU+O+XRvKK+swY?=
 =?us-ascii?Q?blBV7RDCOtj43Fegol3qKbaK9JgfByfrPUBELiZzhRiBXXSlvvX4IgpNaEkt?=
 =?us-ascii?Q?zSmOwv4kU3wN3/1l3QiRUabfObWdlFsp8NTi8+1bgG3lKLO529A4EHNcXbfi?=
 =?us-ascii?Q?XvDXkR9Ct9GUCPbDMGs/zkii+qzW/WD6eQlxu9UGKey9n4A3u1LqpsZgAJOc?=
 =?us-ascii?Q?eMvG65sWN5N1eec1Uzkind8bS5IIW9MDhVi37Ja0ji4RvO8IJcJPJShqQv+t?=
 =?us-ascii?Q?gArcjp3Xk5KTdUL+MIM2OL3xBqF4z9zn7OkhGcxruRzL4iWWcP/E/QK/evO8?=
 =?us-ascii?Q?qThCPlSYoHg2J94/L8mSk+awvjcp4W0r3rmbEdpHaKoXy9/mX0yikca2bEB0?=
 =?us-ascii?Q?RrEQ+8PkpsAYDjeCFUvn08+yHiX2xKBqPIBRgitY9P/UfCH4IwcYcyr0yzk9?=
 =?us-ascii?Q?cUzjWMe+Z1OrAics0ZtRMQxsT5DDMPBAGgGUhb9nV/hMEmIllZoc2B3aex5X?=
 =?us-ascii?Q?5xCCu80Z7+hCRCze9cniNEID1pLMVx3zwtWzzdJN/OXiXGEsmt0xMqJLsKCB?=
 =?us-ascii?Q?9GiE8vplujfXwFKDoDmpHH+H5wFkPcdvxAVgH23FlCIuEkGucHj5PaN+f4eJ?=
 =?us-ascii?Q?W1Rd7pu36YF9TrxIAiBuBCIpTAa8PHtujx93axTKTQlSJjpUmeq6uYWHjEyG?=
 =?us-ascii?Q?NvARtsMhgdp32nWBAu3fFZ6rV4zcxu721y31M3GK1dUvC/MG4a6+HQMszt9c?=
 =?us-ascii?Q?36ykPkszvQ6JR5BbbItTaNsA60vHmI6Wv8UwjGZI5ivY43x5Au4JAr09WEkY?=
 =?us-ascii?Q?PoxkQ6ISag+PK5fLcATf9LZUCdLQk98rmZUv6vWU90DFo6yXfhSb7x4fHyw6?=
 =?us-ascii?Q?XJYBVzmEKmexR4Pq/zXX/IS9Bpsshh+fnc4A/Xa/Ux+MVMm0rl25t3Ntal+W?=
 =?us-ascii?Q?sPzTCyNprKAcJXiI2AqPOw/18uaLsj4W3e9U7qKPFlDXIDkxTjUDNy9Yzc48?=
 =?us-ascii?Q?tiZ9lcuCgrfM4B9+re2zlcAE5p+oBXWbNSUcsvFPGWtgslkFLQn9iOY5EENx?=
 =?us-ascii?Q?BQmsLjJ28I5BiFACG2idtqPyyDGbQGp/MeLriejoyQIy4RIY+tTNG7UkxSBr?=
 =?us-ascii?Q?42LOo81/79T9Olz7N/vkhXDfcGJTJGwsFRDtUK/vG62rxevgk2elU+Lfi42G?=
 =?us-ascii?Q?VI7MZQUrB4VPzS7vGgR8I2lvsGcZwp7DOLsar7r/G2BSRoXT15orvmgNAldP?=
 =?us-ascii?Q?xk3A09s1saNr0KwWhWTdAGrXfK5BkmxSB/UPZjf8aID3WEJR2yeLI7/LILtH?=
 =?us-ascii?Q?RW5Z8pIUUEbkmE8ZCh+10+vTS1+LE/35kX8SWKmeTUAq8EOSnKIlK65PJTOG?=
 =?us-ascii?Q?Q72T/A9XhOLwglqH69Zv/+P3e3w+RJ8POAWvjHyLpOREinH4rON7UuluKHF+?=
 =?us-ascii?Q?WS6gsGOTznN4Ypel8YGvepWk4BLamns=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ee25ddc-359b-4d38-cbfb-08da3a93076d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 19:00:38.6679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eV8opRSCAFFe/tZcAKXFl0vuefL8nStX00C2V3lQBHWcpyL5cgcaHBiCXEKPc3gvIXw9tV0HAusxkiIiXItH0/qhsr40nDR+o/B2KR8URcU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3658
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-20_06:2022-05-20,2022-05-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205200119
X-Proofpoint-GUID: QeFp2ga6bVSbajybtnS1IRm9kgL1ZtzT
X-Proofpoint-ORIG-GUID: QeFp2ga6bVSbajybtnS1IRm9kgL1ZtzT
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: bb7b1c9c5dd3d24db3f296e365570fd50c8ca80c

Intent whiteouts will require extra work to be done during
transaction commit if the transaction contains an intent done item.

To determine if a transaction contains an intent done item, we want
to avoid having to walk all the items in the transaction to check if
they are intent done items. Hence when we add an intent done item to
a transaction, tag the transaction to indicate that it contains such
an item.

We don't tag the transaction when the defer ops is relogging an
intent to move it forward in the log. Whiteouts will never apply to
these cases, so we don't need to bother looking for them.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_shared.h | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index 25c4cab58851..c4381388c0c1 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
@@ -54,13 +54,23 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 /*
  * Values for t_flags.
  */
-#define	XFS_TRANS_DIRTY		0x01	/* something needs to be logged */
-#define	XFS_TRANS_SB_DIRTY	0x02	/* superblock is modified */
-#define	XFS_TRANS_PERM_LOG_RES	0x04	/* xact took a permanent log res */
-#define	XFS_TRANS_SYNC		0x08	/* make commit synchronous */
-#define XFS_TRANS_RESERVE	0x20    /* OK to use reserved data blocks */
-#define XFS_TRANS_NO_WRITECOUNT 0x40	/* do not elevate SB writecount */
-#define XFS_TRANS_RES_FDBLKS	0x80	/* reserve newly freed blocks */
+/* Transaction needs to be logged */
+#define XFS_TRANS_DIRTY			(1u << 0)
+/* Superblock is dirty and needs to be logged */
+#define XFS_TRANS_SB_DIRTY		(1u << 1)
+/* Transaction took a permanent log reservation */
+#define XFS_TRANS_PERM_LOG_RES		(1u << 2)
+/* Synchronous transaction commit needed */
+#define XFS_TRANS_SYNC			(1u << 3)
+/* Transaction can use reserve block pool */
+#define XFS_TRANS_RESERVE		(1u << 4)
+/* Transaction should avoid VFS level superblock write accounting */
+#define XFS_TRANS_NO_WRITECOUNT		(1u << 5)
+/* Transaction has freed blocks returned to it's reservation */
+#define XFS_TRANS_RES_FDBLKS		(1u << 6)
+/* Transaction contains an intent done log item */
+#define XFS_TRANS_HAS_INTENT_DONE	(1u << 7)
+
 /*
  * LOWMODE is used by the allocator to activate the lowspace algorithm - when
  * free space is running low the extent allocator may choose to allocate an
-- 
2.25.1

