Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3A47C433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Oct 2022 10:29:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiJDK3V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Oct 2022 06:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbiJDK3K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Oct 2022 06:29:10 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 330133136C
        for <linux-xfs@vger.kernel.org>; Tue,  4 Oct 2022 03:29:03 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2949HsRO029347;
        Tue, 4 Oct 2022 10:28:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=J4P+p2nSDzy4fGPOFA5Mctj/yytUX/S6JedtL4HRQU4=;
 b=Qr0bY0by41PRK1JfoixdUiTJf/C+/leexjdKamvndjI2vDHJpdq1JQE1edVt8cSnggOl
 tS+hlH5Rhg+8vFegBdYHSj0iRnR+Rc2114KQ7Bwp7YyTFKgJ/zNVQeyyZcNYtmdIiy7K
 EwkWbJINRr7dqfrkWvXRbMrx2vt6CEQno7kONuodqyfAT9kfz65Qp1kgG5cc7/OE/bAW
 3VbdvS6aGEbejRBW6gzeL7iaRnefv+61XQ0mOR7yafq75cQvU0PzY/+fuoB8b0uqoDjK
 63tjwk1SGtOOcorub201SNEWZvdmwcmn0Y9AE+ABmfD3c7oMb9EjC0HCLTfQSOXcO3Qe FQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxc51xb3c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Oct 2022 10:28:59 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2948AW6o000431;
        Tue, 4 Oct 2022 10:28:58 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc04jk1u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Oct 2022 10:28:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PkKZuxLu3z5U1+MuMpEvrf+o3T8KgK7smuBuSg3XchLGhLXJa/oN/vNUp07bcdWqpGe+Wb7SLqX7ohRUtoxzM0qAABkSHb94hjp0Mi1ICBn56UQhTnGEA+OncOoeJQiUu/M73sxemExq3Lu8oFvyQYBCfBNawkRQHmd/Cq+/ZshxLJZAXzUA7zokSqvZqWOBzQIWZpBLtN5DmnHB70DbfLJQwdPZENJdxqjWDV3qa7sgciEEyX6GguASnfwm5We3J/5EiL2nZaonF9tU9bEEJH2bxhEyYYqKFvqsflDD0xIMW96z+yoqLbQbceITHStIawGA/eyFP0GnaGaJdiNIcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J4P+p2nSDzy4fGPOFA5Mctj/yytUX/S6JedtL4HRQU4=;
 b=GmSraft2CzRfH0mrNs9XsDYWHjiY5iTpmxSoUlNTckNPWKB95PYqsge0S0ugnMhcm/QySoUK04E9tMB84kCTybBWdXW4qTnSN/dzGcO9OhXh8nFjgbYDUywsp+14gpGEyfdqJOnzj95dH/Jrb/rbt3WsPH2Rpp2AwV98vzwn7bGI8In0S+Ua70ZcY+g0iVHhtwrvQCECxYn60iT1b4r3FuoeF3WEhy0v7TSsT4WMp10OYPeKlK9VIX27dUJaRDiWSFhSGYi8PIK0frJEtCjKy8YtRINXp54KM8uTkkcM3GCkKJG25mJdIL5K0BeGecpBcjoHVTCfZrOnlbubB0Y4tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J4P+p2nSDzy4fGPOFA5Mctj/yytUX/S6JedtL4HRQU4=;
 b=XhPMdjvke9rnL0W6xEisshwv+JekdqoQCJpj5R29mxcb/AlpQkY/V1lQtYBDXutgGcXh5bNhluoWR+itBzhwU1fKsp5DSKpkTM3/ongLHSy/DU+In/+pQBebmqUCL8VspIkfBftbmzkkxexqjiqkVp/FDYaPO4CY7qIwS6YcSxU=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB5184.namprd10.prod.outlook.com (2603:10b6:5:38e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Tue, 4 Oct
 2022 10:28:56 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%8]) with mapi id 15.20.5676.031; Tue, 4 Oct 2022
 10:28:56 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 04/11] xfs: fix s_maxbytes computation on 32-bit kernels
Date:   Tue,  4 Oct 2022 15:58:16 +0530
Message-Id: <20221004102823.1486946-5-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221004102823.1486946-1-chandan.babu@oracle.com>
References: <20221004102823.1486946-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0006.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::14) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB5184:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a712045-1f65-41c0-35e5-08daa5f33e45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ft6rfTsuKe2YdY37PmG4NJl4s1LQuyxlXUOX1Ha2w8nd6F+DIuUw0nA0kLoDz2tal61S+ulNb3QtrWaWqvmeJqRv/zJgwbT45mWvojyaETMyAsq6xG/fCxVCFrRgyO7O2qrfntmzpkWvEEkFpppjNqHETwjMyK+bYJAen6ShmynA6bq5SNIeVGqu4bPQNiIcNSYyT+61SiF0F80PUjtc8A63pZ5rZKcttbbDLSUSuAoLRa6iId9kqx6N3vM/H6Usp9KrF0e7t4uNYdU1TCxbuHykVnizR0424KdMGohfLDl7suk91NxftGlTKfsEV6o7OI6hvYuzqyyf2dzm/g6fJsKN57mhJJTiGqwfRfyRrXBicFRyUZX/WSn2w9F0hCStTP/9yBlretrNRu+xyFwYbCQeLzv31yHj9A8b6jMLO85UI/OAg4M1L6WBUz8YnE2H30ru5IXVwrSecgwci4cRAhw3zplLTf74BGTaXxvyPcFvJUL6ZOLXAQTUCEnnoSamqsdS7z1OhH8F1qHgJM9w7vk/3EVwZzUOne7l4U4QzOAVc+BvipvRb4aQ+F2IJYEtROm+kO+r6WCslWUcd6GrC+DO/njVBsP3Dm6Gsm3LcAjn7n2Cev8BtTezMoh8DhhHHXx0a71hpSOT0ok8fNy04aonpAb081aO30Ez34g0khMkyKqD7DfMmsDJWF3Z8uqASqlHLgN/Ma+EpvRcQEP5KA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(39860400002)(346002)(136003)(451199015)(83380400001)(38100700002)(86362001)(186003)(41300700001)(8936002)(5660300002)(316002)(6916009)(8676002)(66946007)(66556008)(66476007)(4326008)(26005)(6512007)(6506007)(6666004)(2616005)(1076003)(2906002)(6486002)(478600001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4QA5bJ6W6tAEL3OXCfpbHjUIj0ij1miita0YOt1b+JRjRE33OkQ5fM67TK6A?=
 =?us-ascii?Q?IUd7G1w66l9NgMfW6NbwXFv8587VKUVNe86v5MbKRoVOEpzIij6HXiOyq9XE?=
 =?us-ascii?Q?Wu/gJxkL8ANVEz034/lx7yOtC3agrLv3aSp/YQMrjWJMQqgXPbMZt196oVow?=
 =?us-ascii?Q?pU7Q0gZfDwvya4PR5vg+1h007/UFVxsYJ8MO6Bh6wBgUqM9sCwdv/sh8L5LU?=
 =?us-ascii?Q?BEuhzXRlxIsEo3TVX/KLdu2lp0Ml9/aSfT9LtwukNkF5NdaMyXIOufOlNbbS?=
 =?us-ascii?Q?2ep01ZH8r2nz++hhP5d3IN84jraBBjvJkeP9hhCKmvgyH/Qzh2hWNeLHL/LQ?=
 =?us-ascii?Q?Ph4WtoTo4A3QPceSSpYaIcoPikkYpKZuz2eoJmfJFgyG2XDJY4gXfg2yEL5D?=
 =?us-ascii?Q?TsfHemuSNH0x0IXduTIsB1zAej/9w6UtEZcrz9DLkfpFe2IFSObv4tuOHSW6?=
 =?us-ascii?Q?TaiqdZ9qiTGxHfKfct1gppQ/HnoxajOjzmBLrKPD3cxg6MYNZmAM41w+eRY+?=
 =?us-ascii?Q?u3PlQv8jzkARws4KnnoUzW1NXjK7RTQncuwJRoAu1lCkxbYAHN7RsonyT2jy?=
 =?us-ascii?Q?lL3fsghxMLiAEHF0ZK8lnFvPHlLTMpvqESs8KQ5D9IU4w8dTkkeRHlSE/cCF?=
 =?us-ascii?Q?YH3BErGE+M92fsBpnwE0Gn3R4aVpgfzqwDml+Ram8lMG9G5N+8+FOtPzNoI8?=
 =?us-ascii?Q?3NYyu82Tnvik+esAtQK0rOKK9RWxxHfM3JQ8pr8PtjBePZthj8q4jWMc2iJW?=
 =?us-ascii?Q?fL2eNxEk8br8qtfPbyy8M8zw2HuP4xEgiMxypzwPBdQHBAyhyP//yMOL4xTI?=
 =?us-ascii?Q?XjTJfHlCdoNpVrWD/5fnGAHMddkrKNDrkz5z5hS2Wk/Lcp9150WmW6P3iSay?=
 =?us-ascii?Q?o/+6rez6kWC8qNHEj+Cmc8HK+nfLkKH6BvgQyCNGuwdExWrqcfbEUmi3a2e+?=
 =?us-ascii?Q?NsDwCmnEAtJEUmnC6QTRyRKP/GmtZ2sy+a4cgint8Qwn+WumSAMMaF+zlY1X?=
 =?us-ascii?Q?sv9juQzqakhLa6yfXhCVDYFD6SwUI6xkFUTvceXWrJSyOW1PlSQ1EPjTVBww?=
 =?us-ascii?Q?Ijj2ZxAMok/Ah5YgO7S6lVhBtYx/SKyWlObxDRbgfCTSTo2QbeqQWdjJ1jco?=
 =?us-ascii?Q?xTvoZ+/QWyJr9E3OSsWHjdtSaUadQ2hy23KyTuQkr1Q9Mx8os4Uo2j/aD/Ym?=
 =?us-ascii?Q?esKGdzjX0/M87fztanSTsLSEr69r02TJYrLy77YeZHGnqsOBHD4c7eOqiuDf?=
 =?us-ascii?Q?NSUvtfJ1hMlvgtQQ4ko+UrFn/tQ/dUpyiB0T1C0GVZAAXqqlKqNaXrvhkFmO?=
 =?us-ascii?Q?9ZHHA2lGIsSOGKCP2NKQYLLj7rPdRBSPWPf5dtQl2StJDpkJBt0uPGqsBhdG?=
 =?us-ascii?Q?DhaIG9iymC6BNlNcegAJtBt8P5D1EDXWQW4e/PV7oLYvGLineKecztHBKOT7?=
 =?us-ascii?Q?yaSaPGOC368M29Ap69BW9hQl0H7Axx8ZtGtt9CmBM3W/fhJKtjk72k9/CVkI?=
 =?us-ascii?Q?8vJgwNsGLdlThwA6rYWgg3MFhZh3lsaxKMfuOpH5fHC1oJzKf8h+80xwS5kl?=
 =?us-ascii?Q?i8lSTEMHpFHMaE5bCQTc4W4qFT0+arLt3djQg7asQsTvw5PIfJpiCvOmmsKs?=
 =?us-ascii?Q?og=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a712045-1f65-41c0-35e5-08daa5f33e45
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2022 10:28:56.9204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hp0V/pzri0ydwprfpkRyrvRHaVVFmPQ/o05wcC8T5OHWk+JSImmPwzN9WOi+wOhRc9WxGcDUol9NWdP9qvfbKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5184
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-04_03,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210040068
X-Proofpoint-GUID: -tn0I4abPNXTazZLuhc2Y26oIdARbJSF
X-Proofpoint-ORIG-GUID: -tn0I4abPNXTazZLuhc2Y26oIdARbJSF
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 932befe39ddea29cf47f4f1dc080d3dba668f0ca upstream.

I observed a hang in generic/308 while running fstests on a i686 kernel.
The hang occurred when trying to purge the pagecache on a large sparse
file that had a page created past MAX_LFS_FILESIZE, which caused an
integer overflow in the pagecache xarray and resulted in an infinite
loop.

I then noticed that Linus changed the definition of MAX_LFS_FILESIZE in
commit 0cc3b0ec23ce ("Clarify (and fix) MAX_LFS_FILESIZE macros") so
that it is now one page short of the maximum page index on 32-bit
kernels.  Because the XFS function to compute max offset open-codes the
2005-era MAX_LFS_FILESIZE computation and neither the vfs nor mm perform
any sanity checking of s_maxbytes, the code in generic/308 can create a
page above the pagecache's limit and kaboom.

Fix all this by setting s_maxbytes to MAX_LFS_FILESIZE directly and
aborting the mount with a warning if our assumptions ever break.  I have
no answer for why this seems to have been broken for years and nobody
noticed.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_super.c | 48 ++++++++++++++++++++--------------------------
 1 file changed, 21 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 8d1df9f8be07..a3a54a0fbffe 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -512,32 +512,6 @@ xfs_showargs(
 		seq_puts(m, ",noquota");
 }
 
-static uint64_t
-xfs_max_file_offset(
-	unsigned int		blockshift)
-{
-	unsigned int		pagefactor = 1;
-	unsigned int		bitshift = BITS_PER_LONG - 1;
-
-	/* Figure out maximum filesize, on Linux this can depend on
-	 * the filesystem blocksize (on 32 bit platforms).
-	 * __block_write_begin does this in an [unsigned] long long...
-	 *      page->index << (PAGE_SHIFT - bbits)
-	 * So, for page sized blocks (4K on 32 bit platforms),
-	 * this wraps at around 8Tb (hence MAX_LFS_FILESIZE which is
-	 *      (((u64)PAGE_SIZE << (BITS_PER_LONG-1))-1)
-	 * but for smaller blocksizes it is less (bbits = log2 bsize).
-	 */
-
-#if BITS_PER_LONG == 32
-	ASSERT(sizeof(sector_t) == 8);
-	pagefactor = PAGE_SIZE;
-	bitshift = BITS_PER_LONG;
-#endif
-
-	return (((uint64_t)pagefactor) << bitshift) - 1;
-}
-
 /*
  * Set parameters for inode allocation heuristics, taking into account
  * filesystem size and inode32/inode64 mount options; i.e. specifically
@@ -1650,6 +1624,26 @@ xfs_fs_fill_super(
 	if (error)
 		goto out_free_sb;
 
+	/*
+	 * XFS block mappings use 54 bits to store the logical block offset.
+	 * This should suffice to handle the maximum file size that the VFS
+	 * supports (currently 2^63 bytes on 64-bit and ULONG_MAX << PAGE_SHIFT
+	 * bytes on 32-bit), but as XFS and VFS have gotten the s_maxbytes
+	 * calculation wrong on 32-bit kernels in the past, we'll add a WARN_ON
+	 * to check this assertion.
+	 *
+	 * Avoid integer overflow by comparing the maximum bmbt offset to the
+	 * maximum pagecache offset in units of fs blocks.
+	 */
+	if (XFS_B_TO_FSBT(mp, MAX_LFS_FILESIZE) > XFS_MAX_FILEOFF) {
+		xfs_warn(mp,
+"MAX_LFS_FILESIZE block offset (%llu) exceeds extent map maximum (%llu)!",
+			 XFS_B_TO_FSBT(mp, MAX_LFS_FILESIZE),
+			 XFS_MAX_FILEOFF);
+		error = -EINVAL;
+		goto out_free_sb;
+	}
+
 	error = xfs_filestream_mount(mp);
 	if (error)
 		goto out_free_sb;
@@ -1661,7 +1655,7 @@ xfs_fs_fill_super(
 	sb->s_magic = XFS_SUPER_MAGIC;
 	sb->s_blocksize = mp->m_sb.sb_blocksize;
 	sb->s_blocksize_bits = ffs(sb->s_blocksize) - 1;
-	sb->s_maxbytes = xfs_max_file_offset(sb->s_blocksize_bits);
+	sb->s_maxbytes = MAX_LFS_FILESIZE;
 	sb->s_max_links = XFS_MAXLINK;
 	sb->s_time_gran = 1;
 	sb->s_time_min = S32_MIN;
-- 
2.35.1

