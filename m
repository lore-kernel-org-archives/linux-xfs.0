Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6928AC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Sep 2021 10:10:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5103160E9C
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Sep 2021 10:10:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234414AbhITKLw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Sep 2021 06:11:52 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:43568 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235607AbhITKLv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Sep 2021 06:11:51 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KA9SMw008272;
        Mon, 20 Sep 2021 10:10:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=ZE+8J2kosSWIBYMi9PiNAb9MXS8fRgzKtqov8AsfsWY=;
 b=hzeveyWB8sNX0X2u2m/8Girh4uBU/f+tAu6ZSlsBNEnth+IQ+h4n1r1hayeSpRkwP71i
 ZkjidnD79fGvmbIerTebkpCnVtAKCJ3h+SfsgqygXFEEwe51h3bCwi/XhB9/FK4Pcg6c
 /rR1Y/lUk2tBiQvIBmgD7y+0bjRjkwmaPKv/ggcSCcCPEUv8CNV2xweA9hHXPh49kt46
 guYDi/1YZYjP2anNc+DOzFygK4mCLqBLHT6GgWu5y2FDBfsXuQFiwa1m6LJMByGa82T7
 UCkUlTZfq4xrvwSAEr4MWDZ+TzIYcsRW59b8v8Qf9TuSp0guI/5nG8ul88ZeRYJDvYAG 3g== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2020-01-29;
 bh=ZE+8J2kosSWIBYMi9PiNAb9MXS8fRgzKtqov8AsfsWY=;
 b=MulSzkaZxIvXeL/6YG4EFob2irzOtzNXx2f6pnL8LZs/xhSr49+SZr3K578mIZOwqDbO
 12lVjJIir7nB5Hv5b6ypthR/zS0KKX3HOHoPFYVT4UsGtgrQB9GG9rrVqJaofLer5DTm
 AOYoBUSZRAibm3DqRfc97IyKMoVTLbSmpRoOxdvdwA0hkj6BPRvI8DRtUCA+3OD9Fc+9
 G+e0VByKD1LoITCpY4x+BmtA8oVN+GQ3yJw4gThk48nnD+R3hmq+KLApaXsu8Cus2hwe
 kYEgk5NIHm7CBSactEkd8bxDNZrWGlujv82Q/qVk+vSTjzegEg9pZBwC2O7By5R2gcRN zg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b66hnhsam-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 10:10:22 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18KA4qRl034344;
        Mon, 20 Sep 2021 10:10:22 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by aserp3030.oracle.com with ESMTP id 3b565cd9c2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 10:10:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XOBVaUCYcK1lAKW/l7uahJfo9+6/ZKDLY0/TOFIqU2VZdBwQuCBY95Uyhx1okVmIDbjdpelWgwElRq1D+bnmQWYCF+OooTNQ9Yb1sAfPmmSvFS0v2BooHowgxR3p6483L43sTqYcbs4QFvfCD5GsCvridl4gJlltwNn18RVKirolysL78W4aOneqw9x/do/HEyA0Q7MTKKeBH3F0flZtiWfPYtNB8Oygdcr+3ldV+lww0v/MUf/cKiOQ9kdqTs3/Z/HgVeN721eIKqWUCnANmQlSngO73Wo/3nRG8QKHdloUyncJ3kUyrJ+fE+qNeN8RDlnHIQ9FWjgsTXIid+Wsxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ZE+8J2kosSWIBYMi9PiNAb9MXS8fRgzKtqov8AsfsWY=;
 b=fvYCN+asOyx2r8iwjRjnCR7CBmEUnvUWNPYVhKttNA0x/ylnbsBJEO7k68bVFtjUqm9fUG+518cguWr4MXc6JJWAfa1EO5XeMt6YQznusdPPi+5otMwJ7HMR3wmTQCpSMUsx0jn+e0jJ4/HDr4E31c+i2q6ry5paYmVzNn8X0tnvNvLawoR7dhjuhvcuT0ha1fB+9nK8VYNHCqY5A/aIPNhZ/g6aTnOWwH29Pnl8tGP64fnhzYUJHVh84SZpZqKoJi2DU9IlblgRR7arxK15x97mjkYy02utcHOUp8OZgKfDc9JqvgOR67JSuqjtaoBYe4bXO3OtsIo54hTIVR2KtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZE+8J2kosSWIBYMi9PiNAb9MXS8fRgzKtqov8AsfsWY=;
 b=QzcbKSJYL2ya1daX8s4treJektgywr67opLXmYpx6a+lox7zrqDl/geoFAD7XDTV5HeaDWUlV3A8V0MV4/4I4q5ImL+QHWPuiptxTIdSVl7c5zx4mUpDYoU8r3mg7sedyXqSoCWKLO0G859cgApv5g+Lh8jl++QVuHIwHCjnJV4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4540.namprd10.prod.outlook.com (2603:10b6:806:110::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Mon, 20 Sep
 2021 10:10:20 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.018; Mon, 20 Sep 2021
 10:10:20 +0000
References: <163192854958.416199.3396890438240296942.stgit@magnolia>
 <163192858276.416199.6204001049315596078.stgit@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandanrlinux@gmail.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/14] xfs: check that bc_nlevels never overflows
In-reply-to: <163192858276.416199.6204001049315596078.stgit@magnolia>
Message-ID: <87mto77ese.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Mon, 20 Sep 2021 15:24:41 +0530
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0156.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::26) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (223.182.249.90) by MA1PR01CA0156.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Mon, 20 Sep 2021 10:10:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b45d12a-4a3a-4069-b2d8-08d97c1eda37
X-MS-TrafficTypeDiagnostic: SA2PR10MB4540:
X-Microsoft-Antispam-PRVS: <SA2PR10MB454051D79D56A6134BB3B93AF6A09@SA2PR10MB4540.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7hXcokYUEl2mFnkKMyI8cexa5PXk2W6FH7cT0OHVDPlgoFYRyQNqcKaaXcEV3k8wYOot3tYQGaZZKzpAtH1DBIFwM5slRsoZquNlfReQ7Ce4ITpXg488LqcUNnCobkPZWHZRDMdQ0fXsZYHRAxAfHMgU1gRMyuqkJ5J/pfX5XH02TuFExHillKPaega9khKpIFXnd8xgzfAyUPYgSFyUPt8zV32nkX1SoqxIUfbJT/wzGQ8QGwPob2fO6YBNm23Tf/0BZgwqmihqWcoBi7GfOCNmsIrIWqq/FWWi7LziIhCeNTmR1apRRM7zCHelPe64X0YfcjGp++hEy3Q8ActKUeQo/0Cp/tkQoEyvLOABQdb5oTmtD9maJRemi/DHGvb6WpFk0vkQUlnrYKG6Edh8I2AcLFZcbizgpH8AuGWodv/jrvSyCLgxvEQ2k+siSArqRg5vKul9LfKqUe3b6z44xEZ+UALq1+B1suUK4dL4pBrJenL9g1muwAzWGtYjN83D0sqMX5W3I533FfigBk7aZHgm2h6EYCrZuIl+PwKOGMSiu5vtnDGmE0E91O+C2jquvYQrzga6/tLhSPmbbOqLqV2QnMjFdBoNcAK6p0KSs8ozUjv7e+zKgKoXujLaMfQXNnqz0CbdARFSGQp0NyieawjzN4JDVbkupQUbuZDOEyuInCKcnEQRHL5DPrPhA0ER/jSWHT5ePc2VpX9bd5KkIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(316002)(4326008)(33716001)(26005)(52116002)(53546011)(6916009)(86362001)(6496006)(38100700002)(8676002)(6486002)(508600001)(5660300002)(38350700002)(66946007)(956004)(186003)(66476007)(83380400001)(9686003)(66556008)(2906002)(8936002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f6VONncDMKPXOVRVWAxvMusAUtdHZHm2jUdrlkvo5jRhkMTECa4YJIMkfvDo?=
 =?us-ascii?Q?McO2poYak/GwuzgZqOb/pQ3yW3wrnkyT1upOaomGpwtu++lCzUNJbhkSvayr?=
 =?us-ascii?Q?o0R+O8k+SEyYuvi9kBJviX67Euu1Yq3NYaeDBiOjPI8iZAuw3zubaonuWFJ3?=
 =?us-ascii?Q?6JFIE9ScoRRNAptsTd03oRCgxdWsxGPhcmGjdYbl3CGsPZKAZoee9X7WVRDW?=
 =?us-ascii?Q?3BhZVldKDkN5UxlH+exlFnPOyl7IKFs90dGfgGwy7Ac7rlJgGMhnMsTVhgqk?=
 =?us-ascii?Q?DTdg2ZTFbdUsyKt7wr4my8GvLRruZUYoUmEr1WktE3sAY2oCAReNC9fibGdn?=
 =?us-ascii?Q?yV7gnImUlmDzE/zTDLX2bcMFfWZPMXc/TsknIXVlYQIjc/zDLZ9v5/OB+/f+?=
 =?us-ascii?Q?rig/wk4GeGLTcUNnGox+o5KBqXZkO+7f/+T/enLzb/k3tdos5ZpqRH93+axS?=
 =?us-ascii?Q?6aYqLv/FWs1hFjbVvzyrq+sDjwspfaQ5B44/8Xg/Lijxq5UY0MHCLjzfHGj1?=
 =?us-ascii?Q?zytxEUrTO+xyGtOnM1DLcuPF5AAkk1R4ouI3+Mq7go99dulUBvhXphOzz1+O?=
 =?us-ascii?Q?sLiiiZqJmLt6n/jG71yIvekV+1xLh+lE1hgmEdLFGYXVnrBtNEe17oLKZlTl?=
 =?us-ascii?Q?QglgDPIeBqLLhkCesV1r9hxk2DFLbHnyyKip0ZQ6RbNURPEjQ8lA4gLOk5K/?=
 =?us-ascii?Q?9oh1Y2ztiO5yssQ2e/osNgY7P2XpSYoHtUdNNUGv5Ve2ey/5TPyVF6teMWjt?=
 =?us-ascii?Q?JwSDwRYKwmL3UOjYzqSwh2b+gADezNzewXUREjWckwIkJo+VVe8so6LyZC35?=
 =?us-ascii?Q?3OR17+F0d87BLrCEcJe/8gC3wYuPX0+sNvukHUq5iB9Sf+XeyXfIiFN0wiLu?=
 =?us-ascii?Q?DYSxZNFhk/v8IpnRN1Q0M/n74Bl5tW1dGTn7zI+6D/nOnzZGl1rjTNUXqIzb?=
 =?us-ascii?Q?GoHgXQhEcjg9q5E2Vi2a5wkYVyrHCtz7Wt1I4nWWxcq24M9xfB2XPQ6tZeQH?=
 =?us-ascii?Q?Wt5saW5BC0tS1lGPER4rvGYwBAf34nz7vs4An5KU5VfOBWdBMFvSFSh9QNq3?=
 =?us-ascii?Q?7IpM8zNRdF6+3w8LY9Wh0e++XOncr6xfgO0vkHVyzL5O+gTXrk6B3r1l4kcx?=
 =?us-ascii?Q?ZRIZy1Bei7+vY3BfwFFssjpXEo87eWuxKUf5/mP8PB/c4xqOxNars9NpmkQB?=
 =?us-ascii?Q?+W49awRmy8VRyQ109D/j/oi5N61+ZI7ujbv4v8IMCPnw/OGAxZ08F0drz9MA?=
 =?us-ascii?Q?L5YKrKJA+K2Uu536NuU7BE9q6u2VieFMGOZL7rerMy3FrkH1zkTVvEgsJXpY?=
 =?us-ascii?Q?JNjsgGs51I6JePXp5p00/2z9?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b45d12a-4a3a-4069-b2d8-08d97c1eda37
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2021 10:10:20.4688
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4ObRr8NDBJQxVml+52yNg2ij2K64Nv2g6pOYLgvkJqxGaq3VT0ch9BzXkJnuRAWKhXlqaG8JleMGRJf4ExCoaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4540
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10112 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109200062
X-Proofpoint-GUID: XDSbMcCLY8EbaavVUgOFyANtpV0oL0TO
X-Proofpoint-ORIG-GUID: XDSbMcCLY8EbaavVUgOFyANtpV0oL0TO
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 18 Sep 2021 at 06:59, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Warn if we ever bump nlevels higher than the allowed maximum cursor
> height.

Looks good.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_btree.c         |    2 ++
>  fs/xfs/libxfs/xfs_btree_staging.c |    2 ++
>  2 files changed, 4 insertions(+)
>
>
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index b0cce0932f02..bc4e49f0456a 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -2933,6 +2933,7 @@ xfs_btree_new_iroot(
>  	be16_add_cpu(&block->bb_level, 1);
>  	xfs_btree_set_numrecs(block, 1);
>  	cur->bc_nlevels++;
> +	ASSERT(cur->bc_nlevels <= XFS_BTREE_MAXLEVELS);
>  	cur->bc_ptrs[level + 1] = 1;
>  
>  	kp = xfs_btree_key_addr(cur, 1, block);
> @@ -3096,6 +3097,7 @@ xfs_btree_new_root(
>  	xfs_btree_setbuf(cur, cur->bc_nlevels, nbp);
>  	cur->bc_ptrs[cur->bc_nlevels] = nptr;
>  	cur->bc_nlevels++;
> +	ASSERT(cur->bc_nlevels <= XFS_BTREE_MAXLEVELS);
>  	*stat = 1;
>  	return 0;
>  error0:
> diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
> index ac9e80152b5c..26143297bb7b 100644
> --- a/fs/xfs/libxfs/xfs_btree_staging.c
> +++ b/fs/xfs/libxfs/xfs_btree_staging.c
> @@ -703,6 +703,7 @@ xfs_btree_bload_compute_geometry(
>  			 * block-based btree level.
>  			 */
>  			cur->bc_nlevels++;
> +			ASSERT(cur->bc_nlevels <= XFS_BTREE_MAXLEVELS);
>  			xfs_btree_bload_level_geometry(cur, bbl, level,
>  					nr_this_level, &avg_per_block,
>  					&level_blocks, &dontcare64);
> @@ -718,6 +719,7 @@ xfs_btree_bload_compute_geometry(
>  
>  			/* Otherwise, we need another level of btree. */
>  			cur->bc_nlevels++;
> +			ASSERT(cur->bc_nlevels <= XFS_BTREE_MAXLEVELS);
>  		}
>  
>  		nr_blocks += level_blocks;


-- 
chandan
