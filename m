Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78763C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:09:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6345861185
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:09:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236222AbhIPKKl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 06:10:41 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:48722 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236263AbhIPKKl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 06:10:41 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18G8xk7k012704;
        Thu, 16 Sep 2021 10:09:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=KUArRdw3FrjlcpqJO+fjXluUhOXFP593hwgK4AwhNxk=;
 b=JNddPCTkzrpcqH6IpvGIjKw0KAWzhMlyjcr60YGc6j8AX9XFPyoKmwIMZRSIYkRzAn9t
 RuhI/c7vwo132ctQqUX+8e7ysYcQdZVc9ojluuEFGvhmoI/AfDCAbPS7Hs8DcyzZSb5f
 u1ni2zU+UlZhhkeDBZM9zHc9mjAsq5rsbZchmRZVy8DFl2CA+C06KSMf0CGn/vHDNzpY
 PMjW9nxUkyxbkRhjum6MLuBo6oyXZYVvDL+nDOdaFt/UP5WJu/cfV46tZWMYfAzkJh5D
 WpWlp2cQA8tuQTu7R3S7pq+6mdzM8yvwUjHiT7lIPbO/HAY2huFfcbVDFlmxPFHYTuSe vw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=KUArRdw3FrjlcpqJO+fjXluUhOXFP593hwgK4AwhNxk=;
 b=jcKJnEiOZ6LEo9B8cTS0O2zeGIo/GyAC1A1exkF2nGIjtzHHk1MaRf+0Mo5M/q6mToM8
 Wr+UG9MbW7NLe0S8R2u2odw5bhuerCuGKTpfQHH5r3SuQ2LnTR4gjFAPA8NwACFjyeHJ
 X6B4ueL86cYK8wYLcVk9dd6lq/e6rdw0IPIBduw2AzpvrOgwvVrLsTCI761eCv4W/Ajn
 5T7rqcKuDGGmBS0ekBGnnkCRm6Hjy9xFLCE5yx/3vxOCZro+V1NlS08olld72e2MaWyS
 2SnQLXfwyI/eDSJG7yB1OUEgh6uDTpyrIMYrvBjz/RlBcbsj1wsv5H8mQ7b1EJS1E+FJ 7Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b3s74hgs5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:09:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18GA6cq6160357;
        Thu, 16 Sep 2021 10:09:18 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by aserp3030.oracle.com with ESMTP id 3b0jgfv62u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:09:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VQx5glY2jBrdAJdmEQVL4e+kFgGz953TV9j2++p4Hwf7IIVfzJrF/frYnpYuJIBMJFM9m2Sqax5x1Ul+7bk5aZkXQitFZWzaIYN/00OfVAfQmQd3sdBqLPJdE35BYCdWvnO5Wggm6C2LY2uSy9dCykUaoO+5PWuVATcvkyfa0Zrly9apFBvCpRhwt9ctwG1ir0dRmrZv1hQELo7EW0WW1jPKZ+wSw6SIZJfqboloSgfwAXbcwBfDZGeTOIPAVTdhsd8sI7JjxY1J8BPt8FGNhKSm21x2U7B6wRrwcrwlnEOHGzl3bAUHYoZ44SG8h1ecb0rh9qXu/dfyfcNRdqKYsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=KUArRdw3FrjlcpqJO+fjXluUhOXFP593hwgK4AwhNxk=;
 b=XJtSc1JjtQOf3Mtb7fFY/G/3nNUvNTZjFno3s1/V7U2FocGNaekaPEFUnPTTdC14YVyMDm3VUMfu2EB9j6hNmUzleHby0pEGAXZ1hLC4zynXa2YzrJWc/fnO7lk5ORA5H2m1JfFIncjYesgGQed7BX91KkFHMtjW7TEHW/8ZAa0lnYuLjwuleJldW+XP9EyUBWQ1uw1rL0B7kn5U2f995vHgkF6HFSfMg2GaaohcdrGjE3vnW983/Hii4xDQDT32Bso3mc6Fr7+CAHHvvWLDE/gyGmNMKG4gvIIexbGJGfRCk1rP6GyvTCQEJbYi2D45cvLmThLJ03FHH39/BrOseg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KUArRdw3FrjlcpqJO+fjXluUhOXFP593hwgK4AwhNxk=;
 b=I03oYtm+ZE1sO0hTtpBvBBd5fWCL6hi2Mr/QfsdqZSNRkSEV/B29biWEpGfls7KUBEFC+vJdc15XlLecP9UouIi/bZnC8oTRHuzkrpxTRZTx2ET8AiOgNGcDonGa0vEFZsC4+VVB3cqQVXuD6vl7JwXyNtZdpDp127SNo2h2UIs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4748.namprd10.prod.outlook.com (2603:10b6:806:112::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Thu, 16 Sep
 2021 10:09:17 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 10:09:17 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org
Subject: [PATCH V3 12/16] xfsprogs: xfs_info: Report NREXT64 feature status
Date:   Thu, 16 Sep 2021 15:38:18 +0530
Message-Id: <20210916100822.176306-13-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210916100822.176306-1-chandan.babu@oracle.com>
References: <20210916100822.176306-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0158.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::28) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from localhost.localdomain (122.171.167.196) by MA1PR01CA0158.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021 10:09:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99b3d163-c37b-4815-2d99-08d978fa0b04
X-MS-TrafficTypeDiagnostic: SA2PR10MB4748:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR10MB47481A64B201ADC3329B4153F6DC9@SA2PR10MB4748.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:229;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zZ1zSX08CFq+eIS8dEsePi4YUKWDZ0T/MNkPQyi8Uf9LSPpWm6OV5VLMPylQl88ckHIgVeNRRfzuP0orZ2nfLjI/d4jZuWpSf+rLl609Kc/9mpKD0smbQWZZfuiVv4i3Qsd9iJjD9lGzvnFnWZ4NZXRCpJeVKyb2FxucIFKb4vg2cQyngQdUDV5Gstahf3s0qOOaeFVkkv8Y9+ylJwJLCTKwCdIrdKzckyh6uLejhX6bpoZ8fvn15llnXQmIMspahXzbRnXcEEcCxIggwDF+zL7QpdbQlnLZzIPlAcQ+9ke+lzfwFZ+cllD9hGFwxEyBROdQCj3+f0BQ4R2NVawrR8sMEow1F2K03w4x3NsRU/CjwyHhTUDUVxhmJqIf0z+zmpf5gK1nBKKSpowc39bNZsT1NeSkFauxpdVTa0iF3Q0LiuIcm31SllbxxdDDjAuO0ECwpTcBMMlbDsRYayKVxFqLypKbE/mo0s00kR8WmFVocDBX261rTXjVb9Njp6gJvcqc+QqwxJb0jk1Aar1Noq+uAmRZ2rRwFkpM4b1cxgG/SJLhzczvdFlECahG7B8ZfH2yhAEgkCIExZLITLYS43PcrkGzIhkcfr4tRtNi1kjofy1v6w+/tSemhY6VYBuyqJg0j4LxK4pL8kTqQtlq78eib/b9I8urVDfBCwqxCNSAHme/9EIuIorl/bDNTH292RisV3KHTDHnZK7rnqUc7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(366004)(136003)(346002)(66476007)(2616005)(66556008)(66946007)(6916009)(2906002)(1076003)(4326008)(956004)(6506007)(83380400001)(316002)(8676002)(36756003)(478600001)(38100700002)(38350700002)(52116002)(6486002)(8936002)(5660300002)(26005)(86362001)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KBxo00RGX0pi2c2zz6vG7zGDUGDvPD8dAide+2k9r+HMQjgjZgP/eRW0rhg2?=
 =?us-ascii?Q?0/J0TeqVjfiQNBXisWNfLtAljHQJ6paiJmYLYVPwFkcpOPgVBePmKr2QgbMJ?=
 =?us-ascii?Q?duKmifuPGM5XE1ys7JXiNdWfvCiMsfy3oyLVibJm8QlBJUvGfnwiqKtxRbGg?=
 =?us-ascii?Q?Z09tL8LPxVwZsbCYNSnUefmad+tAnM4QOu7ZlpUaVD0Wa5lwjFr+eaKXIp4M?=
 =?us-ascii?Q?Yw1EIJo3juEyfqZEYsnGja0sCWr6Dv7qHzd+uWIhOH5rFqIeWOaFvI++mwp2?=
 =?us-ascii?Q?vNbWN6n/Xz1BrvP/o2vnnv0ERbvsycs8/JnFTb/ZU91az1rl8hu1s/xX/PzH?=
 =?us-ascii?Q?bT+IL78JvmBoFm++qS3dZ53AWiFcpXdnTpuAK50f+CP5RHQiVYMhUFivJcM6?=
 =?us-ascii?Q?BJLsiBmzX4KmuiV8oPnOcxKcCUeQGpbLe6Z6HxoWuSR8rhOM6pjLo/NRuY2z?=
 =?us-ascii?Q?olihP/jDBrdlrLNnpu5xcvtVQAav1tlXavEd/RMVDJGNYAwTlG0A3D4rQlNV?=
 =?us-ascii?Q?fUcKFHktvbva8123+q9Yk5kPTBmcRj54Jl+UypEIQQxvMrpbXR8zJNurOUSd?=
 =?us-ascii?Q?zIH7L0wf0//kF+a4PSd3K40MPatQn64jEWJuZsxIDz4Y8CAu43YnmN/F0G72?=
 =?us-ascii?Q?5MxoHhCRV/ifM0mU/kjAS1nlDutA+8F3azdVL0k12ADF+OrxasYPp0acLTVz?=
 =?us-ascii?Q?mpWTirAl9ORVlIQQcwu93khtgUoirQ/Vn4kwENsr4hXMjjoUb5qLRO+GfUhD?=
 =?us-ascii?Q?iQjqTVJFPvjAChPQ/+a0jqDJLnKIxCJ/QuWVwFCPwtLuHGJzmAayjDTx4/Go?=
 =?us-ascii?Q?p6nPzUuZx982LOw6xU7F1ehQxycfxe+fZzN/I053Fbhj5uySgKpC4eKHwmRI?=
 =?us-ascii?Q?y0h4bSRDsU2uDE0ewi77NK0mnE5IM/tZIpCkcFi4D43JPMjRhNJ+Ll4afgOF?=
 =?us-ascii?Q?PBtu3HNNBt7A7FQLwlYzv9EMcjUUbrWAeks7ujENHqEoKvL7TI7ZXNd9tFXY?=
 =?us-ascii?Q?yndDE6/I2kPVNns5rpZS9sntcD9W4XqQdb4hsg34yOZzXmClIAn5fSBDCPZ/?=
 =?us-ascii?Q?5Yfk2KVqhlEtys5uMXI/raiDc4Ff2WfiyXBch2x3KSDJ1H4muFSioCAAhzKx?=
 =?us-ascii?Q?AdDMaJoCMxoFEYe7RnUGRqKRdoFIpXOJCfK6yDEF/rxIHH3FPVr7flZk2PJL?=
 =?us-ascii?Q?fv4eCUqedU0Kl0fCDx9H+gIMLTA7ynp5B1LyfKzZZPnxiOraiO8EXL1xNToE?=
 =?us-ascii?Q?aABunUovchDJ1+MKJKTh1nepcZwXZ0ZBMVpy7J6MpSXE5fBgLAo+xA5a1Bjo?=
 =?us-ascii?Q?2YZKGLQXt9Tb9ZOxDepY+urr?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99b3d163-c37b-4815-2d99-08d978fa0b04
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 10:09:17.4911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hPXVHLy4E94IdX9RK9GCuzaHneyI+2ulYootk8pe2WS9OUb9FLwbAN9q/VnOOAcFgCPjFpvxTnNzd5VUHf8+8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4748
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10108 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109160064
X-Proofpoint-ORIG-GUID: 0GZm25dk5V29fbAXV9nrXfoGMKAj6n88
X-Proofpoint-GUID: 0GZm25dk5V29fbAXV9nrXfoGMKAj6n88
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds support to libfrog to obtain information about the
availability of NREXT64 feature in the underlying filesystem.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 libfrog/fsgeom.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index c499ef2a..33645503 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -31,6 +31,7 @@ xfs_report_geom(
 	int			bigtime_enabled;
 	int			inobtcount;
 	int			metadir;
+	int			nrext64;
 
 	isint = geo->logstart > 0;
 	lazycount = geo->flags & XFS_FSOP_GEOM_FLAGS_LAZYSB ? 1 : 0;
@@ -49,12 +50,13 @@ xfs_report_geom(
 	bigtime_enabled = geo->flags & XFS_FSOP_GEOM_FLAGS_BIGTIME ? 1 : 0;
 	inobtcount = geo->flags & XFS_FSOP_GEOM_FLAGS_INOBTCNT ? 1 : 0;
 	metadir = geo->flags & XFS_FSOP_GEOM_FLAGS_METADIR ? 1 : 0;
+	nrext64 = geo->flags & XFS_FSOP_GEOM_FLAGS_NREXT64 ? 1 : 0;
 
 	printf(_(
 "meta-data=%-22s isize=%-6d agcount=%u, agsize=%u blks\n"
 "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
 "         =%-22s crc=%-8u finobt=%u, sparse=%u, rmapbt=%u\n"
-"         =%-22s reflink=%-4u bigtime=%u inobtcount=%u\n"
+"         =%-22s reflink=%-4u bigtime=%u inobtcount=%u nrext64=%u\n"
 "         =%-22s metadir=%-4u\n"
 "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
 "         =%-22s sunit=%-6u swidth=%u blks\n"
@@ -65,7 +67,7 @@ xfs_report_geom(
 		mntpoint, geo->inodesize, geo->agcount, geo->agblocks,
 		"", geo->sectsize, attrversion, projid32bit,
 		"", crcs_enabled, finobt_enabled, spinodes, rmapbt_enabled,
-		"", reflink_enabled, bigtime_enabled, inobtcount,
+		"", reflink_enabled, bigtime_enabled, inobtcount, nrext64,
 		"", metadir,
 		"", geo->blocksize, (unsigned long long)geo->datablocks,
 			geo->imaxpct,
-- 
2.30.2

