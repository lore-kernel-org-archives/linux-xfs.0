Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66753C636D7
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Feb 2023 04:08:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbjBMEIS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Feb 2023 23:08:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjBMEIR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Feb 2023 23:08:17 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E1CE396
        for <linux-xfs@vger.kernel.org>; Sun, 12 Feb 2023 20:08:16 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31D1jFA3010497;
        Mon, 13 Feb 2023 04:08:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=trhfPZ23r+skcnoaq5v9EvxYo72XODS8/LIMe7VbhOQ=;
 b=l4139g/ijB+jQzu98vDxibSDjWSq0OdbP+DNE93NGtAWfHAQomy/ewwJOshe2DwByrxd
 Yex3GfSnXdu+oAZ8BVt8HFb+w7RWNUbZ4L1KVuZpZ3yO9bI6fPSZ7vOaiWxFUg4YiKYN
 Wl6UzCpvRTFEnj2a5vzPpO1bf80KjC0OmYxQFHZ+9PmRSheOA1tjJ8sEAliKHdy1sVmr
 7wtc01vMXSkvywc+D5OnnC/bfT2GZJR5Kp1fZXqN9tBElcIk3YvAnhHG1ItNd5n6ulRc
 vPuCeNAdTbQGebuMNMBsJogJMYowWm21uMiTFCB6SrDyeUHwuY14v3qVCv1TsOHdykPe QQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np1xb1wwk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:08:13 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31D41lP7018012;
        Mon, 13 Feb 2023 04:08:12 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f42a74-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:08:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L+Fy5/fkEbPcWOWwEfytAYnTOBh0dLSG2R7NoX6h3UOOiqFAdjU8PM0I/Ix7SEIbV2JiFQdkEdWs1n4/LZXhjvAQJjCx0zlGcG0Oa+/lzLhm7pF1RUvsQLpkv0ah3mhOh32ukj2SPbduHGNjCakYeT/2CelSxNLTNbpHABQfcRVCqAWvDP1R2DESAwf74kNqppOpZSaZu3ymAGOqbIWZLapg0J9tq6Onb+ABsbsFoOKJzDUpG+gtG6xy+/rJwDFHZVK7+cC82zKexTpIWtAQI73ZUqQbsSeiyZjfm5MNp9RWdB8QGkva1UIka9Cn9gQHrdEcHPxJFiUQbUROOokp3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=trhfPZ23r+skcnoaq5v9EvxYo72XODS8/LIMe7VbhOQ=;
 b=fOqZT/OKf2CD6N7lNGw8Sk4Yhzx5uTKO0LKchqOnw258Bvtj1Q4UK+ZvqQEJWywFvDhu+CLZhETy0aWLijjTIjYzP0+4OWiWTBDsSl0W8eDrAt7jxN+6yFezq++J3zZzqmW8rp1RMJWfoyVQTiPLYO1Fr589Gr5tON+oVeCjl3OH5K1D1f5w+iHfCEb2h5/48YKjmrdQBJURKmRn6dLPq9i1MfhNvMobkWy09A9S/2YyYLVPyu+kMGkMCMsvw4cTOgzP/gU2X+tJwZYEU1mdHibAud1Fz+UQkcAomgwB9CDUFBmcAB9yf7E5NgoQHUgtZvTN2IFOWfJvcbI0/bReYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=trhfPZ23r+skcnoaq5v9EvxYo72XODS8/LIMe7VbhOQ=;
 b=xgQCio4XX4VAWOvd+tQZXfpdYNk1AZPk3uyuAewVs1BubOcDfc/zTf0AejrnK/OzsKKPrqAQsEbhRiv2/2X4jj3KZCJ0KQuB8YztMKTuVt961KJ5UyMFmGJXOWvTMrFVjvwREMxDYNRsefi4orG5T9kHcGv0rZZ9ZoBDPsXB/cE=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by BL3PR10MB6089.namprd10.prod.outlook.com (2603:10b6:208:3b5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.8; Mon, 13 Feb
 2023 04:08:10 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.009; Mon, 13 Feb 2023
 04:08:10 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 23/25] xfs: fix the forward progress assertion in xfs_iwalk_run_callbacks
Date:   Mon, 13 Feb 2023 09:34:43 +0530
Message-Id: <20230213040445.192946-24-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230213040445.192946-1-chandan.babu@oracle.com>
References: <20230213040445.192946-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWP286CA0001.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:178::12) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BL3PR10MB6089:EE_
X-MS-Office365-Filtering-Correlation-Id: 07a5efd2-e649-4aef-ec5f-08db0d77eb59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KPHO2YvecLOjeiKC6dUrPZqwbzkP0Fg1Oi3rFG4ERelcAHNVumdiNlsJJVNIufio3IUwQk5VTYrLnr0l/Klqmqkf8KxilO4xdvUULFHyIGxAmrGKE810nAhsYk/zpBhbrbkyW0nHLLIr0JF2ZL/3c1JMbov9isHQmVRbBF5aU0gvsriEzvOxlYuevJOcHjBzfp0+DFewskrdktaAdNheRku4x2sc47Si5nfauvABAWCBVq9yJ+qq1+cN3fQYV+6/j316Tw1fpRiz53I6TZ2M0ZhSF7tNvzEtl/dcvCy6PX936cNmW0DxN+bge6/O4mpBkuq3WyILAFpksPGL85exRe5xcE/HruDxVufLJHsjy9EY2EB50RsXt9NWJkH1jQ9ONZJm5TxSvAUDqsm3ktyDTrc40RFTrjeK2qghFH7YI/MOaX43HEU5hUcoztf85m7cE7DTc7dYWIw802SB8SHgWiXEIA24HPFVzNib62BVAAaaYmwnKhw/CgPInh5muVybDFWGh7HI6KAIVUpYae2LTmPiqfZ1Ob8pDNXNTXJRKFXskl1vy8ZAnum88jOBYLZ9nLDOmdvOawPcF2ZtYrIByfuEv5eI/a5JmuRlrA8vnMC3MYf3MNnkP3AZPwaFVpH0FwicsAk5E0IOuS6K5HtiQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(136003)(366004)(39860400002)(396003)(451199018)(86362001)(36756003)(38100700002)(316002)(8676002)(4326008)(8936002)(66476007)(5660300002)(41300700001)(66946007)(6916009)(66556008)(2906002)(2616005)(83380400001)(478600001)(6486002)(186003)(26005)(6666004)(6506007)(1076003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?beb7k7pew/AlR0pmTuPAVqxvPwgt4MHrFrnVAMgxlk2MYOqQN3TekAMceKOY?=
 =?us-ascii?Q?dCDEdvXiK1AhNn2op4OBPaWF+GezKujIiNwrAyTF1xzkBZQbnpvnMgPMGAOJ?=
 =?us-ascii?Q?cbMB6mD+co/LQ2qiSM3ZTtdW6UVqseeDNs5ccZKWrhNOiImNRaPvAR/eUQUP?=
 =?us-ascii?Q?JssNDT6tslyFrkPVW2C7gCrgwMHVAaF3ibxpMgoFKDVJjnREALxkpd9Y5DhA?=
 =?us-ascii?Q?1tqIc2As+ySVgwvA0T68ri4n0pNDMeAXN5D1WfNzp7+1mD7UAO36Ohv81Ho8?=
 =?us-ascii?Q?HYeIs8bsK19u5CeVCeUSQ9OVo5lDxT6TBeTMlnICY91AmVlvFynPYSpbfuyw?=
 =?us-ascii?Q?77VJ5/Ns3veJTMvBO327YrSA4IKuO7AYdK+5oWyfUUD7H5YmSdTFTH0mQPUa?=
 =?us-ascii?Q?KxHvXrkjPxOCLuxIiXWw67Lut/g05SpBa2bclSN0Uqtleelm73gWkQ97xpCK?=
 =?us-ascii?Q?SMlF8IJEw4ZzUwsK1Duze8RFPOA5zASyjjtSf8QlTzIc7Z+Wh6N98FE13v4g?=
 =?us-ascii?Q?ycdkTMnIi6glFZdZAbxUs317VcKC+ANmsEXXnKXfLS2dAPpns9IMW7CGxT/+?=
 =?us-ascii?Q?pZGYpM7SUYNEb6u1QM49nJNvO9QlAqfy1CkLFszBd6ndSABE03qN2InKCZTx?=
 =?us-ascii?Q?gVTdBv94wzkyFn7R6gFtPbgLQV5SabqWJaPUVdLpox+lQRSzEKW/GUgEly5O?=
 =?us-ascii?Q?3SB1fJhkAXhhe7RYCQbBtSmyaNwinnUyBVSRPwHhcCO5PMQtvdiKEa2+zbt+?=
 =?us-ascii?Q?u60elXj17QZlCks9nc0qFt8Zl9fetvDxVwe1GouqFACIR2NvsZYlkeKaIOe2?=
 =?us-ascii?Q?F0Frg5MNIELiByyyApdn8t9ilHVQJ414zqbY1wA0tCqHfoSP/B25bYdqmFL4?=
 =?us-ascii?Q?dZDK+AOlzIsFdk+aVIwFHFPZyV16xULyHiGDG3qaRHMBBydMCXJ3fFY8Pp3b?=
 =?us-ascii?Q?0XD+ov4VCMeuq5msoWR7/5hWuBsXiaJhLh91OfjIqcIwj5kB/wQWKhXIOWF3?=
 =?us-ascii?Q?1+GkKQwbc9HE1hVfvrgTgDvdUhSqJtYFSEw3Oq5m/diae/pB0o0M4flGK5s8?=
 =?us-ascii?Q?/6kbhZYtCCK9EdxEJ6ZtGG6pWe6B1Y6CRaQgQxHlWN8+FWRkPJWJYszC/0cH?=
 =?us-ascii?Q?L00r6OF8FExfUvwjG3cDHiYOb8wYXE0VkMdyyTdXmYv0MAusJeoN/DxcgDr2?=
 =?us-ascii?Q?DUuQor/q3RhLp0xIjXQpXuHyMpMHcZiFsqqT/0JdI0Xx7Xx3IcUdSlpbgsOx?=
 =?us-ascii?Q?qh9vZCDc5XiDIO4T8cCVHN779ruOUDtoE8w1NvLWxmRQuFA03IkjLgpcCEYb?=
 =?us-ascii?Q?BSHAkGOB+J8m5PBbJf4RTanZBV1zEOc8r0KrtZwEPQi7soVoQm1uIbvwHFWt?=
 =?us-ascii?Q?xzeaPULwTECwCfxpIkuSK0saDISaboc4gafHZYqzqznS/W7L7ltLmXsA/tQ+?=
 =?us-ascii?Q?pxXxBSdiZIGMkvo+Om7ZuXVIUWFMfC6oGDXRu09jUbJRByMq/UzMafi1QGe9?=
 =?us-ascii?Q?u5nLMzCVla4q8ixYVIRcHB1519C2rG0HkVt1WLaTg18LgHkazDRJCkoxoslo?=
 =?us-ascii?Q?W6MZ9nCQjeVYCYeZKIbgfUQoBnu9P6KkfuVFoO5jSVcjGqlJ5l7TBzN/vnCO?=
 =?us-ascii?Q?kg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 1KW0DuX8Yr41HQE0XTeIm1lmCVuXgUonhNditggrei+VwqfzkFPOYI6elw7w2oiJqZkp7qjoSIfY+/NmCe1qZbrEnGNi5PuiRjSV2R8y6Y3E21SpBtPBkkSyjLhqCtcHfky8wdw9UXDyywv9sLKzUqiNc6GUy8lOPzxhGnd66fuK7yW7g9X6EBo6PFF1YpDMfzPPVBro0d5IuZW9C5YnDbl3Vy9dUn/0K/IqVHzabl2OVJnMi5nHL7URW7rIQvOid9+k6nGNQ1us9GJPLa3dLQwzHFURQxIUo9hjzvq/s4/XO1kQfROeW9CjlDnsSW6AhWLXAJPAT3vi9ySdDbzmPi5k8XRU6jsVSVLTlbkxC2/xmO2tYki6ZLXwdwJne7Ve4kXXfcqcQkDyQDs6rH/Ew95ejJiwOPIpO5dQA2grfUsybTfhtSXXLkk1ESWzEgahp/iPFsq23Ag7grgLw1DmPdcPywr6Fuwn860bUMfQ3vuGvvwjeCR8S51skJTEGBVHK5HpdgxzVoQKYxc1yVzHzwwKjv3lCfkHLWGVQWOmLoEHVp2QYlO063DG73KWax2+fed6QDFRat02AM+x5jj1yLCcm3MUr9334MFI8qfH1o0FtSd2AQekTZ9mh2XATOLCzl8xn+c/engq8zfIo9K+nkxQAcACHsBDBCC2GsvBVKFkW00RAChIopKxTuFZjC4yEKt4OtA0jkcHDSPqFzowIc5tBN97T3TzXlhGqQuPRjyidHqptj6Wl+KvZSFC5xVkDdKlcjhZyzAQ9Ysx9OALADSyB3Wx68LZJEboDvZIrYNZzjjx3huQGArEV3HY72Rh
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07a5efd2-e649-4aef-ec5f-08db0d77eb59
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 04:08:10.6052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Dpr/JZM4GZNkJOQjymqiE+buuiB3StTLTnC2pS8xUK92wUdQ5imVtIM+PfuFbEdTplYol349zpLKSv1Wl8/wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6089
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-13_01,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302130037
X-Proofpoint-ORIG-GUID: UptAKOmPXTHVS7rrC7oB35sRd0NQtaX6
X-Proofpoint-GUID: UptAKOmPXTHVS7rrC7oB35sRd0NQtaX6
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit a5336d6bb2d02d0e9d4d3c8be04b80b8b68d56c8 upstream.

In commit 27c14b5daa82 we started tracking the last inode seen during an
inode walk to avoid infinite loops if a corrupt inobt record happens to
have a lower ir_startino than the record preceeding it.  Unfortunately,
the assertion trips over the case where there are completely empty inobt
records (which can happen quite easily on 64k page filesystems) because
we advance the tracking cursor without actually putting the empty record
into the processing buffer.  Fix the assert to allow for this case.

Reported-by: zlang@redhat.com
Fixes: 27c14b5daa82 ("xfs: ensure inobt record walks always make forward progress")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Zorro Lang <zlang@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_iwalk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index 1f53af6b0112..cc5c0c835884 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -362,7 +362,7 @@ xfs_iwalk_run_callbacks(
 	/* Delete cursor but remember the last record we cached... */
 	xfs_iwalk_del_inobt(tp, curpp, agi_bpp, 0);
 	irec = &iwag->recs[iwag->nr_recs - 1];
-	ASSERT(next_agino == irec->ir_startino + XFS_INODES_PER_CHUNK);
+	ASSERT(next_agino >= irec->ir_startino + XFS_INODES_PER_CHUNK);
 
 	error = xfs_iwalk_ag_recs(iwag);
 	if (error)
-- 
2.35.1

