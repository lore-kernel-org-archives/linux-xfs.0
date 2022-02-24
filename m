Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E23D9C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Feb 2022 13:04:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234752AbiBXNEv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Feb 2022 08:04:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234155AbiBXNEt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Feb 2022 08:04:49 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D034230E67
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 05:04:18 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OCYIb1000629;
        Thu, 24 Feb 2022 13:04:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=xchVTKQTW4IECbvoTNa5POR6is+dNUfG5DRGSLJKnqw=;
 b=BezIERBJhBU3fRMY79eqn8+kXXCfN21fXjHB/CFCS8omAVUfoowYp6D1YvvyARchJ2Z7
 ewcjdB0578mxhEk8LysyrMiAu6kUEA4zWDFFKHstfk0nqS+ByamwT++saOvA1MTeYpNA
 60mgkM3TDCOmdo3L+NIxTt6pynzmAoyWJ6Ps+yAEDGZP4ppri9jn57M51qrtluPnVDEo
 i110r1ryZHwQMjnzz+roBYobxTnsH9WiRhvYopmsy50eHZaidOQRyD0lc+pPJqLB7QcY
 xkfHQ3VD3TcR8Ua90L8jJxKzyO1H3p4knfGhDD7ic8Ml9kEQqEoDSd3nNvI4Tf3gbQkb eg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ecv6ey5ts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:04:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OD0ZLb120631;
        Thu, 24 Feb 2022 13:04:12 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by aserp3020.oracle.com with ESMTP id 3eb483k8bq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:04:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lZL7vtwapN6dxfAti4li8mM02rRnNQSexaSPOrYJatMRDpGeaBOAMNhzC+KmsD4HBqOaXekC41ypxWLvH35mxI6J2TI2CqcJZ+6i8G1W4u+S0VIUlbOpZRaCCEwkpd0tIXFX59qz4EN4Lzqglnm2R6SGZrZw5MKyfLbj3IA+gndHQMnUqxBgK7c+9ysNyUilYsgk859gvEyUTN+KH89tLgpQGT3p5mkjlU6sqKr+1kQ87JD/HmwIF0Piqpg8/ijfKk2uFYeUJ4NU807dna5Ww6zgErJ9ldYauatmEgxTiEr2zOsH0LLxSw0AsRq56d1gnWDbR7nSg7csY2xwK1WgAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xchVTKQTW4IECbvoTNa5POR6is+dNUfG5DRGSLJKnqw=;
 b=J9zJoXmsIt8A4cbD+2n97UFXUd+y0OMjJjpsDWDW0PDQ0hh8ibr101qXad5tN2MyDTCkyw3y72yxbu5wr2RNqTsbOu44qeY1byYqpw7hnuNyWLKg4HY3LUTO6HIJzf7F7Wdryr+QaMtrJRtt2Orxd4kScumwYOBODXxtgQ+0nXGe0xJUmWBOhlk8Rbrh1LXQ/UhvMBqtE8Ls+IK8VFMiuxnOvz8z5qe/u4HsfKLgyKENX+Fe3wZnb5A56IaJMSKaZKDvpGh69i5PUE/mz3FDoY6+z5H9SBEMfgFMTbK9moQe528agfnOksKM+zgC8/XurRKY4H2+z6zmzB5IJ/+qTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xchVTKQTW4IECbvoTNa5POR6is+dNUfG5DRGSLJKnqw=;
 b=oLvFgDSDhvr2NXFQ4GLy/ppUy4tapm00HxDRhic86OLT5Nn5Xb9gJ5MatXlfx98ZVnCEqGPNMY1OCSZzwgHZdmlV2Ecenc2cEDqhLnvJhOUgKkWxSggWbJYEal4EW6pAgQMuSs7xNTnMqsGoQ9Q/IgX3Ia0dmltEVlNhhFBPQvA=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4634.namprd10.prod.outlook.com (2603:10b6:806:114::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Thu, 24 Feb
 2022 13:04:10 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 13:04:10 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V6 06/19] xfsprogs: Use basic types to define xfs_log_dinode's di_nextents and di_anextents
Date:   Thu, 24 Feb 2022 18:33:27 +0530
Message-Id: <20220224130340.1349556-7-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220224130340.1349556-1-chandan.babu@oracle.com>
References: <20220224130340.1349556-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0013.apcprd04.prod.outlook.com
 (2603:1096:4:197::6) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd6701cd-3517-434d-4af5-08d9f79625f0
X-MS-TrafficTypeDiagnostic: SA2PR10MB4634:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB4634F8528845C1B498222DC2F63D9@SA2PR10MB4634.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XBlXrI7QKqmFopMBXsYW5zLbQXtCJninfJlCRaipd2QSDcoTCtqQWd45xPxKY5RhDj2WkBJ+tfkZUzh4mWnCJt+0uQ6XH5VpkVYN1BKQC0pAZZk3yhGiAWh7YC7/mC8tNXzmi2wYbDgetdJG37452qnrogfUu6RbJVevYzghMIxNhc2z+R2Pm2BqM0Zi9nD4Jzih955mJs2AuqyK6BqYbAaGfwxQO5Zba+QYVBVRcxWsxNzX+76M/69YLkV2upfjs97O7yw64LKRizfDZX7JWX2waVVb+pXAhSEQ/1Dd4UUR8AjJEXAhy70UUEMfP9plRa38mvm0+xCn4hRxticMluKj9KkTy/2bR9sltRpobMsQ2pV18CdgwtHFoSff6uMJpy2jC+1ApRK9ykugeOJzQFxMH18O4Xb3eMjyh11C6xLEjstotgKS8u2QDvOmmpEKLYu7bTOqgWGpmKMLeJ/R0bn6RJaY+eQkOVn/PhW4irUvWkPKHPpBaDAjFMl1fcAs3UFHi5NFXXeBknWoubEHTq9LAGmmmchhAhNwQeoahGTSBJIjUufq7juGO9gsd5fff2z/63jgPpvaS1TCZpOLJaaa5DQCbnTp2U+T/npd3CrszA7xIukXF4TkbcXDrQIury0gr6JMUea2C4Tk0rq5+8fK1r6OAYadL1RNnG/JW8FhJrb4rxFSZnohO7+DLSToDn/kkXnzgbGmd7nZJMb48A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(66556008)(6666004)(38100700002)(38350700002)(508600001)(6486002)(66946007)(8676002)(4326008)(86362001)(66476007)(6916009)(1076003)(316002)(8936002)(36756003)(5660300002)(83380400001)(2616005)(186003)(26005)(6506007)(6512007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L66+dsPv8gJVZxNKFi5hprajW3aCqsHuPSHFK70t0+wxhnFyVwQRXlSX4XAZ?=
 =?us-ascii?Q?1r2r8I3Pz+4ZMw+zzJmrucGxE4YbbnQRxDcBprveMAxAverpzIQJefALD34x?=
 =?us-ascii?Q?XLZ2lrgoGuKYjSScYn3Upx0gvpaH6mIY80d+5g0CWApnpc1zoUGD2Lg8HTpB?=
 =?us-ascii?Q?jCZ+5AtVy73cROHEix95Js0F30rc7mfAw3cnaqy5wNTlmw24wClfvbtNoTn0?=
 =?us-ascii?Q?TNjfEWJVNN08WFXLTyeBmmHkK6cfE5EjGxD7GG8MfX8EEKUJIA7eaOwxlJQS?=
 =?us-ascii?Q?+PjwreKXeEjLfkCRUvGOOJk/g/mOUk+SThPQt47A6tkQk32YAQAEazApDcPJ?=
 =?us-ascii?Q?k8Y9OTtghqOkDI+8y7g1XzeWRjBIC6U5p84DtARs3ztei97gxW8SdP4mIcnC?=
 =?us-ascii?Q?XZD1JZIWuDOJ3x7SqQPWHR6WVZbDQCASmM6tWV2m4UW6wcswJ7UKRQoa3b5J?=
 =?us-ascii?Q?yKdcTn3VVdZa09YuJW8MofEys/matpAc0400GwWUneHT8fZYkSBFSvve8NNx?=
 =?us-ascii?Q?tpMhFHccJbC5iXZnNjrBaoKWeht/kdOvXK28ILloAcpmKIZ7TvK56IIdGCUh?=
 =?us-ascii?Q?73OhgDhF6NVvE3wbx246DSejYZRRbMRe+xsDu5rCrFS1x4QgF9VtqurfYiOY?=
 =?us-ascii?Q?fGzfwafKnVqldraSDS+jPeC4jnyqnli9Jzj+OzCAyDQOvj5jHGc5oLFjfAIe?=
 =?us-ascii?Q?u4AgcTvrHPDtN6LEyWUye+ZD8jY+hONK96XRXk3Zk6XAuYu4ZHVAtxWemm4O?=
 =?us-ascii?Q?SuiIBv20qPu6wcrT29QC5KKRmZwbNyDH8vwxtEGLuv/e8vZjUd+IMKB5smOF?=
 =?us-ascii?Q?1WCBZYQMBSIncOCTX5dCfnXUDrNJcVlvUAslLIOrmZjHAgNujd5d9V/ZjWWY?=
 =?us-ascii?Q?U3K9A+8udPQU24/hK/x1O3YAOLSOX8h0HiDSp5nx3IdUHzfAqBm92Vd8dIDq?=
 =?us-ascii?Q?XmqXmC0PUsO4Pcl4TwfeCQkydXEKEvKCvWt6SsbbvUrIUltw9tL/uA4ZVIi0?=
 =?us-ascii?Q?hpp12DtJkb/oZdnhX3w/7ErFV/YXo1pEK+xDXUPBSuQ6rlJG0qr5JnvP23C4?=
 =?us-ascii?Q?dAj8Vk9CAAKmKnew4D0VzMrEfh7WcLaa7pPov8Uj0/MFr13n3mcDht0U2FRc?=
 =?us-ascii?Q?ZTcsuTN14r1M+nCGIKGZE4HbKM5p+f2Dv4tWO3uAygQ7/MAzZXLMkDGp7Xt1?=
 =?us-ascii?Q?GZISvTkDSmlt1gpNImc5u+Rv+t6nQreC0NVR9Z/2Dlbwn6BiWKRhP8BpKoFk?=
 =?us-ascii?Q?QyPakUVkXHdyLT4oifvVdnM/jGwR6cXwdk5iZlCKsoFpSKzBrwpuQAtXnh2J?=
 =?us-ascii?Q?lY5chf3sEIp5UpLO7PGRQRCHajjntUhWFxJHp/XJ1Cew+1nPbtzvWVwU+6r6?=
 =?us-ascii?Q?MWRZ+Hmaye9IRMYY8A4n0Corp4ZIdVpLMXssFtR6+n+LRikXe6fCxysdwNZ4?=
 =?us-ascii?Q?LASOSy44SisjiDgUxFui6xMiM78oenGcnPmazBbxh6L8eIx85Sn6Qd8ZJQKO?=
 =?us-ascii?Q?XNEqz82PGRRftbqfvQji8irVfUwanbxIN64nGWClCkUGakkDXV42F2attTFT?=
 =?us-ascii?Q?BJW37rjKcFI+hZXVmQa0VYysalneprXTBWkmJFdsSKZQAGOLPr5nqGZ/HeK5?=
 =?us-ascii?Q?97EXjYRV01zA9zij+VfYOvk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd6701cd-3517-434d-4af5-08d9f79625f0
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:04:10.6276
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U2iNHIpgh2JPCXp0AJ2J/sJR5Pdm8EajxEHaAmBYRCJTP6mAhEcgH9tYpkJwNzmOZ2luHtpzEG1YducxZ/OWTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4634
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202240078
X-Proofpoint-GUID: ov5iKjjKBDk2SamQLd0uF_2HncZ4sl5_
X-Proofpoint-ORIG-GUID: ov5iKjjKBDk2SamQLd0uF_2HncZ4sl5_
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A future commit will increase the width of xfs_extnum_t in order to facilitate
larger per-inode extent counters. Hence this patch now uses basic types to
define xfs_log_dinode->[di_nextents|dianextents].

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 libxfs/xfs_log_format.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index b322db52..fd66e702 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -396,8 +396,8 @@ struct xfs_log_dinode {
 	xfs_fsize_t	di_size;	/* number of bytes in file */
 	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
 	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
-	xfs_extnum_t	di_nextents;	/* number of extents in data fork */
-	xfs_aextnum_t	di_anextents;	/* number of extents in attribute fork*/
+	uint32_t	di_nextents;	/* number of extents in data fork */
+	uint16_t	di_anextents;	/* number of extents in attribute fork*/
 	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
 	int8_t		di_aformat;	/* format of attr fork's data */
 	uint32_t	di_dmevmask;	/* DMIG event mask */
-- 
2.30.2

