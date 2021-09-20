Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03503C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Sep 2021 10:12:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5E0160F6D
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Sep 2021 10:12:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233370AbhITKOE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Sep 2021 06:14:04 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:3158 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233135AbhITKOD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Sep 2021 06:14:03 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18K80tak018028;
        Mon, 20 Sep 2021 10:12:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=HINndrqWKNRWgISp8DIiB2/pw48Ae8kuQQ0HOz5ZMwQ=;
 b=ZEh0/q2xqddj6pJbc53Onp24s7diFIaH6lSLr/NGVnwhDq7kL8Snz5LQVhF30qy0+fy1
 2Snwe7QCnqqZG1/2DetK3U4+bEPYSLGV3jO9LIkZvrPkonXK8xc/fsq5PMOGZ4M1/hOy
 b3cfu0v/mWQgVVLzsDB1l2CCjCn8qpId34vQnMVDP02cuJoDoDPTC+wszJeMmz6yhOJj
 guFwpQDAA1AcAjRHqVA9yMb8F390jGdapgsofNxYPez0iM0MbxGBtcp918bCjmI7/C+1
 WAfpyRb2Y+Tox8RM7Eb4alwto7wRZ9PmT8l0CSy8sQHs3ia0EcA+fpJ5YUDAP4DWz9TZ 3A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2020-01-29;
 bh=HINndrqWKNRWgISp8DIiB2/pw48Ae8kuQQ0HOz5ZMwQ=;
 b=Z5xjVASFfCZFUE572tVwJ8m4wOKzilHV6Ik1pf0eBVyM3oaNrDZ1fk2L2K09QjUnG1CR
 6g2xJQqGwjC+ZFP9RTQPAnhjkDMR3HHdY8Vl0LQhq93CsI+lMIOmaPnaIoZQ/K7Y9XTk
 vKcseT/4+7agWDNTufhQZNPHsQ7DXM/8B1Az9FFR7s+k/ENQYjzk7i+GVbUjS1/pZa0Z
 BtGtRAz0PLx9w94GpRzh1/h4Tuk+81+upHNlRdsdRWSGrpenlKEJozWUktz+Et8NIGO8
 qPMVMdm1+Xk+QjSLvGLTOLnUEMBhwswypd6VGhsOi3SrVQbCrCSNNxI18lWtNGNa2kCs gw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b66gn1ra6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 10:12:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18KA9tpK085115;
        Mon, 20 Sep 2021 10:12:34 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by userp3020.oracle.com with ESMTP id 3b5svqfvee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 10:12:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MDeY1ztVmA65G4BnCD002Ei8SWEQw5Wxptc8um+62ZX9R4ydnOHoEAiZplIFXxZmqOSF420rt302ohkBPDXoxNv6UcE5VdMGFb6dgktKmBsaFuSfet2MKdZtj9GcRoMGcCfcaG/yjdxAoyJaNFUXMIs+ZD79cdKIc5vokfknvHgU5P70A66jRyVJ4N1aw41FCqczhDafIADguvsg1uen2z8sqctjnyDfy3DIG7q010yb2vAc3QZO7ZVLmAqLfyucvR12kyPpI8qgPGDFFopImmF5Phy0gVOBNJH4kdFG/zyhGsHHg7aVQZcNm1VV/JP0lGkWeye85qlGTutk1HEFfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=HINndrqWKNRWgISp8DIiB2/pw48Ae8kuQQ0HOz5ZMwQ=;
 b=R+N1CWMurv3884zhrPDksGW59fJ2Er3VKD74+jfryh4+WpsoGFw0NiBFs8x9Hu2HKefMgvNXF4fa9NIH/fcf+D+8hqT654Qk24xwnVRfmKLREtNZXng74zLrE6jj1qNSznCOyRSRBP4AqDlxGsE29Xnx8/tJ4D2ckox5kOkCDE8ZcFgtP0nDVtZ4KalHyqtPUajfCcL2cvRQuhp/RFnCwec1wa4hCpG+HTNvpLRrJrUQdGBZ2ioshvtS8X+3MRV105BIspZYs3ZhhBQAgN0UF5/62Zhx5vhQOJMmo2gYbFSM4pMRYSN7dyp7k1VQ3+vqZTKZ7OyJoABXhdoim5wUeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HINndrqWKNRWgISp8DIiB2/pw48Ae8kuQQ0HOz5ZMwQ=;
 b=ERIlBVydK9A0QZGYYurW3szpT7+jyx/uNZuOqb6bUq4nGBVr7H1A0LmT//iUaolczRZ+Vpml2zJLxJrXDhIm8kLFqATu5gf2hWWniPTHB1BDwjqfyysY1GcgfFzBPipR2glFYil/OP11Aj9uUPpQjjnDQ7t6HuySLiM6VbWsKS4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4540.namprd10.prod.outlook.com (2603:10b6:806:110::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Mon, 20 Sep
 2021 10:12:32 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.018; Mon, 20 Sep 2021
 10:12:32 +0000
References: <163192854958.416199.3396890438240296942.stgit@magnolia>
 <163192862112.416199.3937220618088469929.stgit@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandanrlinux@gmail.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/14] xfs: compute the maximum height of the rmap btree
 when reflink enabled
In-reply-to: <163192862112.416199.3937220618088469929.stgit@magnolia>
Message-ID: <8735pz7eon.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Mon, 20 Sep 2021 15:26:56 +0530
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0147.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::17) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (223.182.249.90) by MA1PR01CA0147.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Mon, 20 Sep 2021 10:12:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57df5195-a038-4527-62ee-08d97c1f28a1
X-MS-TrafficTypeDiagnostic: SA2PR10MB4540:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4540F4FFA384BD9A011FBC6BF6A09@SA2PR10MB4540.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 16GtS73PRq/AAUrMq4aGA1ijf8NwEPUW6PwKt/9+iSdMEDPdLkXCoGb6k+phggDoJTXPzr6WKck4qoDGi1lLzmfkBUinG2T4sXJBwK+I7LnrTdthin7VxpurHratWYqcmTi0tzxEr3YsBZhIP0Nax3U/WrzwBAu6V6Yd8ZDjjzneUQpP3FdolzR6QwufiARtO5dbJgWmQAz8ojLKaBVAuferYntv6o4Wxcvy8WQuJziXBlAZ/IWWOSxhtLJp19Td7jIrlURtIGyRN5wnNOMMUfS0aGne5o4LaIoHqGK3sdTq43fuXxTyGhSeWeqZYLzR6Ood96UnbJbUVwlpzQBpMwXg1JNM81lrCMDTD5pVmTh+ee+N9AgrbwXzjrJMNVfKuFaenK4iEHUQPi6fOCPVjgFphv7qAVoiweFvNgN1lyg/yjHDyPqCh2iRGJdsyboV9jLNsPF7gZqzHd7cFoKHlGDrfY6ctv7BWbb2Yo5ICAN10HWVqQzjPVaNVUDPRblvdSOdXKC8xj0myZxco6OW2qPS+24oVMJbf/xSC4PWy8Llp5WGXt/KJepG7YWYZQpITsZ7kHmspry3msU1DAEEm0TIx+vdPXxhd78O7jxnfGZFef0nNHf559XgFq47L6at923vwlaYGWDA1KsBCmodI/ap9IHv7GYdwIbMoI2hx+DFnEzwSUi2vElDa1Ler4+kcZ+PYp0DgIBYJh33PMty7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(316002)(4326008)(33716001)(26005)(52116002)(53546011)(6916009)(86362001)(6496006)(38100700002)(8676002)(6486002)(508600001)(5660300002)(38350700002)(66946007)(956004)(186003)(66476007)(83380400001)(9686003)(66556008)(2906002)(8936002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?F/Y/CpVlwO1MebSaoHI6kkx85yvx6hIHdorf1gQP9gq4lAQOsJSA5DloKKtK?=
 =?us-ascii?Q?oGQWHZHOgRwLiKskgoVONkmvbPhUU8KDufABRoM/8j8xKtTAnHk4SFR00+00?=
 =?us-ascii?Q?WMHM6DOiZLgE4Vgoc3oc1x4DsvpL6mJSS8oaS5yJO4fs0XN4dfHxkZ/gbqZQ?=
 =?us-ascii?Q?7sjDOjTx8Xd1DPmTy7+vXNImrD3bMkO4WO0ijPCMqTBl04g0nhIyBjG3NtHi?=
 =?us-ascii?Q?cV0TekDfooyi43sFLo2Tbm81tbZyCkgsttiErQWO7GE1h7EenBB3qATV9X0E?=
 =?us-ascii?Q?JZ8yEC6JIpmIOcfKaP3xYeEykF9B773UHxr+U3BZ7ppeRLfmEtlu3a18zuA/?=
 =?us-ascii?Q?X+h8RGNtZ/WtaB3n3sGHbx/7081eavQJPCEyyOD69SOvC2SqEzPQ/R4tpMBM?=
 =?us-ascii?Q?4vp9kYm0UcjNthIW+y/ZICOdNxHVJT8Txs+UCc/weKvvNICHqFRtxx9hqDTx?=
 =?us-ascii?Q?arJ/inybhZbrfatUedDp+AjOpSmA8anlZjRg8gtUnrNW4ElMdsM1vevL68aD?=
 =?us-ascii?Q?CYOhTjM/Hyglyf5nnur3WYxhOo9p9h+BrXoBh5yGBiVbRMKjGSGYmyLBVyv5?=
 =?us-ascii?Q?MWC3av0FT1EN9sF6tc3x+mCPU5LZuKaJPPZTLR5C2aZKo+RD/3NSlajLPhC0?=
 =?us-ascii?Q?9/ytdxd40YFpY5zMZUbQ0IdZBVvQ8T+tLg0vkU6GdNKJH2Iw6WCaVZDidYQ+?=
 =?us-ascii?Q?74MgNa06Ax0PvUs95Rvn1J2n5yWhmENFBQFAbTuuynbQM4jD7szduThtOOAg?=
 =?us-ascii?Q?LBQtltyymtVmzrwtUxklB7ScYK96ykuWzoDmAFIkTkilTECYz1AgpvYnZqXl?=
 =?us-ascii?Q?4kzVw+LyFRZtPKCvzqFJdxFVw6pg5ujOceIZRU6wGwqcSefQhDPF5kBr44Qz?=
 =?us-ascii?Q?7uztHzKu8jx2/5KJL0+qrcKr9pQCjSifv4UYo+DIDHBVR/flOEKH6tLeM2wX?=
 =?us-ascii?Q?T1A7Rbu7mjWRv5pjiZJvq9XkyjdOqmiak2YTMlga48p5OmDSHJV/YY+B2O8/?=
 =?us-ascii?Q?8EuV7XAA6L7pg4kQ9B8Duf7q8aoqOUP5Zy8cSJ3h8JXU5+iVHCrDb0+boCnc?=
 =?us-ascii?Q?x6+U8B1fwZVSOgWUj0LfXz9qOl7fswrLcODm8kF9IAWYtlxKEBqIzV4ODnUP?=
 =?us-ascii?Q?5ICBDSjewbKZSxCXERzdrUdE7dX8fW5Rp7su0Glhzv/sTV7tCcF+vVeAxUk/?=
 =?us-ascii?Q?oohcbXB3g4CQSG8w6UuYZy5pxIdvj1s6KteQ2ZcK4KFT0KEFqzIzkBenIP+O?=
 =?us-ascii?Q?0UfGwfqUNYS4v5aiFqI4uZm6+xmyPPVsbxolNJ0SFYYzxesRTnOoWBiQZlMm?=
 =?us-ascii?Q?c68x+/+sHEgojTk0eRalDHsW?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57df5195-a038-4527-62ee-08d97c1f28a1
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2021 10:12:32.0207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Foo/poYPFJiaDeQklNyUSxum2j9fZEjgApKD1zsxeGUzlYdEHnvs0qiPgySDGKGXWBdk6raQS5V7S54QyaAcQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4540
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10112 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109200063
X-Proofpoint-GUID: SlppMkqlviSmoZQOdtt0F4X79aHi-9wO
X-Proofpoint-ORIG-GUID: SlppMkqlviSmoZQOdtt0F4X79aHi-9wO
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 18 Sep 2021 at 07:00, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Instead of assuming that the hardcoded XFS_BTREE_MAXLEVELS value is big
> enough to handle the maximally tall rmap btree when all blocks are in
> use and maximally shared, let's compute the maximum height assuming the
> rmapbt consumes as many blocks as possible.

Maximum rmap btree height calculations look good to me.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_btree.c       |   34 +++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_btree.h       |    2 ++
>  fs/xfs/libxfs/xfs_rmap_btree.c  |   40 ++++++++++++++++++++-------------------
>  fs/xfs/libxfs/xfs_rmap_btree.h  |    2 +-
>  fs/xfs/libxfs/xfs_trans_resv.c  |   12 ++++++++++++
>  fs/xfs/libxfs/xfs_trans_space.h |    7 +++++++
>  fs/xfs/xfs_mount.c              |    2 +-
>  7 files changed, 78 insertions(+), 21 deletions(-)
>
>
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 6cf49f7e1299..005bc42cf0bd 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -4526,6 +4526,40 @@ xfs_btree_compute_maxlevels(
>  	return level;
>  }
>  
> +/*
> + * Compute the maximum height of a btree that is allowed to consume up to the
> + * given number of blocks.
> + */
> +unsigned int
> +xfs_btree_compute_maxlevels_size(
> +	unsigned long long	max_btblocks,
> +	unsigned int		leaf_mnr)
> +{
> +	unsigned long long	leaf_blocks = leaf_mnr;
> +	unsigned long long	blocks_left;
> +	unsigned int		maxlevels;
> +
> +	if (max_btblocks < 1)
> +		return 0;
> +
> +	/*
> +	 * The loop increments maxlevels as long as there would be enough
> +	 * blocks left in the reservation to handle each node block at the
> +	 * current level pointing to the minimum possible number of leaf blocks
> +	 * at the next level down.  We start the loop assuming a single-level
> +	 * btree consuming one block.
> +	 */
> +	maxlevels = 1;
> +	blocks_left = max_btblocks - 1;
> +	while (leaf_blocks < blocks_left) {
> +		maxlevels++;
> +		blocks_left -= leaf_blocks;
> +		leaf_blocks *= leaf_mnr;
> +	}
> +
> +	return maxlevels;
> +}
> +
>  /*
>   * Query a regular btree for all records overlapping a given interval.
>   * Start with a LE lookup of the key of low_rec and return all records
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index 106760c540c7..d256d869f0af 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -476,6 +476,8 @@ xfs_failaddr_t xfs_btree_lblock_verify(struct xfs_buf *bp,
>  		unsigned int max_recs);
>  
>  uint xfs_btree_compute_maxlevels(uint *limits, unsigned long len);
> +unsigned int xfs_btree_compute_maxlevels_size(unsigned long long max_btblocks,
> +		unsigned int leaf_mnr);
>  unsigned long long xfs_btree_calc_size(uint *limits, unsigned long long len);
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
> index f3c4d0965cc9..85caeb14e4db 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.c
> @@ -535,30 +535,32 @@ xfs_rmapbt_maxrecs(
>  }
>  
>  /* Compute the maximum height of an rmap btree. */
> -void
> +unsigned int
>  xfs_rmapbt_compute_maxlevels(
> -	struct xfs_mount		*mp)
> +	struct xfs_mount	*mp)
>  {
> +	if (!xfs_has_reflink(mp)) {
> +		/*
> +		 * If there's no block sharing, compute the maximum rmapbt
> +		 * height assuming one rmap record per AG block.
> +		 */
> +		return xfs_btree_compute_maxlevels(mp->m_rmap_mnr,
> +				mp->m_sb.sb_agblocks);
> +	}
> +
>  	/*
> -	 * On a non-reflink filesystem, the maximum number of rmap
> -	 * records is the number of blocks in the AG, hence the max
> -	 * rmapbt height is log_$maxrecs($agblocks).  However, with
> -	 * reflink each AG block can have up to 2^32 (per the refcount
> -	 * record format) owners, which means that theoretically we
> -	 * could face up to 2^64 rmap records.
> +	 * Compute the asymptotic maxlevels for an rmapbt on a reflink fs.
>  	 *
> -	 * That effectively means that the max rmapbt height must be
> -	 * XFS_BTREE_MAXLEVELS.  "Fortunately" we'll run out of AG
> -	 * blocks to feed the rmapbt long before the rmapbt reaches
> -	 * maximum height.  The reflink code uses ag_resv_critical to
> -	 * disallow reflinking when less than 10% of the per-AG metadata
> -	 * block reservation since the fallback is a regular file copy.
> +	 * On a reflink filesystem, each AG block can have up to 2^32 (per the
> +	 * refcount record format) owners, which means that theoretically we
> +	 * could face up to 2^64 rmap records.  However, we're likely to run
> +	 * out of blocks in the AG long before that happens, which means that
> +	 * we must compute the max height based on what the btree will look
> +	 * like if it consumes almost all the blocks in the AG due to maximal
> +	 * sharing factor.
>  	 */
> -	if (xfs_has_reflink(mp))
> -		mp->m_rmap_maxlevels = XFS_BTREE_MAXLEVELS;
> -	else
> -		mp->m_rmap_maxlevels = xfs_btree_compute_maxlevels(
> -				mp->m_rmap_mnr, mp->m_sb.sb_agblocks);
> +	return xfs_btree_compute_maxlevels_size(mp->m_sb.sb_agblocks,
> +			mp->m_rmap_mnr[1]);
>  }
>  
>  /* Calculate the refcount btree size for some records. */
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
> index f2eee6572af4..5aaecf755abd 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.h
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.h
> @@ -49,7 +49,7 @@ struct xfs_btree_cur *xfs_rmapbt_stage_cursor(struct xfs_mount *mp,
>  void xfs_rmapbt_commit_staged_btree(struct xfs_btree_cur *cur,
>  		struct xfs_trans *tp, struct xfs_buf *agbp);
>  int xfs_rmapbt_maxrecs(int blocklen, int leaf);
> -extern void xfs_rmapbt_compute_maxlevels(struct xfs_mount *mp);
> +unsigned int xfs_rmapbt_compute_maxlevels(struct xfs_mount *mp);
>  
>  extern xfs_extlen_t xfs_rmapbt_calc_size(struct xfs_mount *mp,
>  		unsigned long long len);
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index 5e300daa2559..679f10e08f31 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -814,6 +814,15 @@ xfs_trans_resv_calc(
>  	struct xfs_mount	*mp,
>  	struct xfs_trans_resv	*resp)
>  {
> +	unsigned int		rmap_maxlevels = mp->m_rmap_maxlevels;
> +
> +	/*
> +	 * In the early days of rmap+reflink, we hardcoded the rmap maxlevels
> +	 * to 9 even if the AG size was smaller.
> +	 */
> +	if (xfs_has_rmapbt(mp) && xfs_has_reflink(mp))
> +		mp->m_rmap_maxlevels = XFS_OLD_REFLINK_RMAP_MAXLEVELS;
> +
>  	/*
>  	 * The following transactions are logged in physical format and
>  	 * require a permanent reservation on space.
> @@ -916,4 +925,7 @@ xfs_trans_resv_calc(
>  	resp->tr_clearagi.tr_logres = xfs_calc_clear_agi_bucket_reservation(mp);
>  	resp->tr_growrtzero.tr_logres = xfs_calc_growrtzero_reservation(mp);
>  	resp->tr_growrtfree.tr_logres = xfs_calc_growrtfree_reservation(mp);
> +
> +	/* Put everything back the way it was.  This goes at the end. */
> +	mp->m_rmap_maxlevels = rmap_maxlevels;
>  }
> diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
> index 50332be34388..440c9c390b86 100644
> --- a/fs/xfs/libxfs/xfs_trans_space.h
> +++ b/fs/xfs/libxfs/xfs_trans_space.h
> @@ -17,6 +17,13 @@
>  /* Adding one rmap could split every level up to the top of the tree. */
>  #define XFS_RMAPADD_SPACE_RES(mp) ((mp)->m_rmap_maxlevels)
>  
> +/*
> + * Note that we historically set m_rmap_maxlevels to 9 when reflink was
> + * enabled, so we must preserve this behavior to avoid changing the transaction
> + * space reservations.
> + */
> +#define XFS_OLD_REFLINK_RMAP_MAXLEVELS	(9)
> +
>  /* Blocks we might need to add "b" rmaps to a tree. */
>  #define XFS_NRMAPADD_SPACE_RES(mp, b)\
>  	(((b + XFS_MAX_CONTIG_RMAPS_PER_BLOCK(mp) - 1) / \
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 06dac09eddbd..e600a0b781c8 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -635,7 +635,7 @@ xfs_mountfs(
>  	xfs_bmap_compute_maxlevels(mp, XFS_DATA_FORK);
>  	xfs_bmap_compute_maxlevels(mp, XFS_ATTR_FORK);
>  	xfs_mount_setup_inode_geom(mp);
> -	xfs_rmapbt_compute_maxlevels(mp);
> +	mp->m_rmap_maxlevels = xfs_rmapbt_compute_maxlevels(mp);
>  	xfs_refcountbt_compute_maxlevels(mp);
>  
>  	/*


-- 
chandan
