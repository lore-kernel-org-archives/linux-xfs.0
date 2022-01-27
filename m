Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59EB2C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jan 2022 05:38:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbiA0Fil (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jan 2022 00:38:41 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:11288 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229801AbiA0Fil (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jan 2022 00:38:41 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20R1LAgg012687;
        Thu, 27 Jan 2022 05:38:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=/mDVx6WYa7RPaWPRTBLHSKHVs9/kVFTnirOjPuFmDa4=;
 b=0Io/yEB/IwEbERr4uADfD0DcXAGy7eZwqJ+QY8RL45q4FjIFfBcr3qXLHGGHauK1E0fG
 YyqFCGn2xvrpG7g3Y+gWGlSciaxmsRQDcXnZ8tLlO3hIR68UbVLopFoFywxDUqQtPAlc
 qIO3CVvWNJsXpIEkIDRjxM05cE3bwwbTrHVQ10c73cFzTCPkIF2nF4fyz/UmetvkHT8G
 pOJDqg88SOGTKgbX2jPbJLqNhnXk8uOi+DO5DemV7uQU7ifD2CvY9c+xeUBdKxvSXx2l
 V1GvJ5E0Rfkeky93SetAMA3ju8dETa5leXb/R3/an1V4Mnpsy1vxKFozpW/BsEFEktNX Ag== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dsvmjgq7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jan 2022 05:38:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20R5aq52034138;
        Thu, 27 Jan 2022 05:38:36 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by aserp3020.oracle.com with ESMTP id 3dtax9qbfw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jan 2022 05:38:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=caxzG+T1PjmaXiDFFOH8Ibpp882Vs9WukZF7FXbm64+zzrf+78iYqxyrd6LG6rRdh+2I/W+LaR1jd8Aj3oGoG3ESL7Gxl9kLjlbaiyB4moPXsnboeSQgiKHS3W114SQF/GaiQHe7e5N0KrJHm/Ki6Kx4E5yUJdiaNejkB8wpM5tOCvZZPLyvxo+gnDoPQEXuSXLHY6rpxL1f3oc+ibxU5ejM6OVWkWOr3TuKkeiZqQQdlIIWrbMr0ZymNG6JqUaW2E9S1bTD7g2lhYhGjoOgcH3y08jQd1gfDnCio6oWEHTLZaLHmos92D0hQa8Ozj/fXEr2FWgDUwomcfrjOuOERQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/mDVx6WYa7RPaWPRTBLHSKHVs9/kVFTnirOjPuFmDa4=;
 b=EU6qw5zr2XXOi1suO1FitoSsrmQuHhiFqlN2zVhYE78NLWZyeHVguuUvzfQtIHe+0IZe2k5WdWwRkOLWz90dE6/I0qdUeqrAYPvQOihPfXZawVAgObDDHog5NZLFskqzQkSY1FNQMs6zmqXjiSK4l0HO5QnXfp8zOfpDCczRxNgh8EmgHP2Mye9VGtb/eXnvtKstr3JoVk2vu+EQ2f9Nvz+h4qQiC9BTzArw+TlXf1nhd43E3wclF+j+MZsP9B8UsNoDaApE0fjjTMw56IswcYF1Emc0mcrJmbAQc4Xrd70B7P5feQD9mQW6LoZm0FYQi6/iMexKPKpmBB35rSUsGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/mDVx6WYa7RPaWPRTBLHSKHVs9/kVFTnirOjPuFmDa4=;
 b=cvRV55cUCU96c0dhOjiRWEOt7EmWrcorXv02n2l8Reuvck0v3T+0yYCiKaSoN0LOIlec3OQ5xErxTP2MdD0svoo9ZQZxlAJL27CeQCbGaGtFHImBeoBaLE+qIi2vIRQVeoYv6ISODTzuUMxNUFpcEexImZ3Z/jDLuNUK1jIfQoM=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2654.namprd10.prod.outlook.com (2603:10b6:805:40::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.12; Thu, 27 Jan
 2022 05:38:35 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::3d38:fa18:9768:6237]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::3d38:fa18:9768:6237%4]) with mapi id 15.20.4930.017; Thu, 27 Jan 2022
 05:38:35 +0000
References: <20220124052708.580016-1-allison.henderson@oracle.com>
 <20220124052708.580016-2-allison.henderson@oracle.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Allison Henderson <allison.henderson@oracle.com>, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v26 01/12] xfs: Fix double unlock in defer capture code
In-reply-to: <20220124052708.580016-2-allison.henderson@oracle.com>
Message-ID: <877dalwxf0.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Thu, 27 Jan 2022 11:08:27 +0530
Content-Type: text/plain
X-ClientProxiedBy: TY2PR06CA0036.apcprd06.prod.outlook.com
 (2603:1096:404:2e::24) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0870691c-6f0b-4c46-8fe4-08d9e15742af
X-MS-TrafficTypeDiagnostic: SN6PR10MB2654:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB2654195CF4842E3DA49505ADF6219@SN6PR10MB2654.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:514;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +1w/1Vwz9pRL6JHNhQJsE+4aNXkdqwwsuepMCpaD7gKr878DEwB6I5TKqSBIIpONAKmx6ffmZqj7ua4Gmc0ynd2oS1fs9xeW8I3IKaJ1fq2vbmQngguw4IuxqMLvEYmZiqQp/udkPBFPQIFrwwE9L+LpVoXTvIvcjR+lKmfd/zH6M0MKcewVH4oM57t1h4k07OpBv6yK6+WJ7he+XwshfasZC711LDhIO8wpg8sTHLoahR67JyGcrVL+3Icc9RHd8FscH6NtORJ7WqyDcwgxvEQ739fzmjW/rRPKbN5DjeH/45zNf75SMmyjub56sBCnHlwvEheziUn0A6QevPeoZxVKlf0Y32le7g2DRPmQoaDIRlw6L3qH26qmstquDnoa/mw1FpRTlyQgPY4g0zaYSIqocGqR9dgGVdaZ3HXnMkdRSTrOxhDStG9BDY2Wu13zJL1PRV382WQCmFv8WOdN+ls7mguJwmjgPhQBg4YKLHEziUX1TAHkL+kLoMwTqxRQh4Tt5Kv8aKelOcscUKzmBhWtqbz+iWsBxgof7OeQSb9f+BOlW37+BBtsZN/aKKoVRI5GvMqpaKfJVizftjzIxrGmIa0yZTlzTBvdQExJhbObz8t/LkRn5cKH9z3V7iXEoKJT0oPsKgkdAlIBJll127H9YyNbNj+13d7Juy+NeUOqzesAgQCxmcg69G/cgYVfk8Q9eLBYgwV/0noWvRnYiw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(186003)(26005)(86362001)(38350700002)(38100700002)(33716001)(6486002)(316002)(6512007)(9686003)(66946007)(5660300002)(66556008)(66476007)(6506007)(508600001)(53546011)(8936002)(4326008)(2906002)(6666004)(52116002)(8676002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ntGmRB+ghwOgFgSYqiBLeggHced+dtrm4AopM64qkxrgdc/Ltes3kZC54Izi?=
 =?us-ascii?Q?EOQp42r3SjVdndtq/leqJIwA4+88Q43ha/8aBbflf/2qFuqCpGoPt5tJlhxl?=
 =?us-ascii?Q?MKSB4KppNk/F/QCt26gHJYO9/tPlP459ZSpooHOw1NK/6b2nKF9XlJ+CDq1Q?=
 =?us-ascii?Q?vUI1H5S+nXyN3SYj2RRmj3TWIC4PFTLvWEYftuxzvxvvP9eq0e/3VIVMn0sp?=
 =?us-ascii?Q?5/Kw0Hpavduso9W4xab6WTRDni8quavKZoHXs+D1MokKLLgayPDKFMoBMPf4?=
 =?us-ascii?Q?RRfE474hS0PaUl1j3AUCv6UWkRP/U7rP356djkK5+3rVl1Id3n2qJnEHWv+5?=
 =?us-ascii?Q?vj2A0ZMb2+iu0zMq/9JPKSQ5vrq3aW7ovQigmLX1oDcg9RMokpBfPhX8r8t/?=
 =?us-ascii?Q?46Nz7/VHHwkTo8+HJZEO92hzxYjkwrF6J1Lpx2q/dFGSshxY6LRGG1Pp1N6S?=
 =?us-ascii?Q?Sda/6TJHol1QSYysZSy2m9L+6vJfhEjgQwVCc8tIZ6is2+CWOmd5HYK1OFTX?=
 =?us-ascii?Q?lRZtGEH3kDJiqnUXEZDWcuqw0+ZxPBH0yi4tozNnfUd9tSKPS+YcpOhp/I8q?=
 =?us-ascii?Q?u/4M0ZFY1w3baQpl5tnrQ6k31ATsVXYKNBf4G4tKk78KtSeFVqXoJ5leLfTK?=
 =?us-ascii?Q?93qNDSleAgeaiuwAcBXaiozU7S+rhXFl8pnrSJ+q8b++/hXIzDxKKeIGUj32?=
 =?us-ascii?Q?tRf1/XepwosLkb5qKxPKR4oNAUQK1ubglEaxdKwjt9vBVVqKlxY/GDL6Z2UJ?=
 =?us-ascii?Q?hINE9FZU0uSiO1DUPGnnVmapzAsDm9MmZZJkOSnJUp3GAwxyM+ZWyos8Tqia?=
 =?us-ascii?Q?rEtgNQfdUL/A+ThXCePAI8IWjndlQAtV7UOJmjI3bEJxr88nCv6VFp8vqCII?=
 =?us-ascii?Q?dJw+RNb36XEnOaImnanCKVDqmPvzeN7WFGtXVEiDOQshR370TANoYac5hwmi?=
 =?us-ascii?Q?KyvdpnlaKVybyLFyXxKqSl1FXsK1XAamJLPX6MShtMnm7BowDCa9KRkjC4mM?=
 =?us-ascii?Q?Sf6MFb13pHfXliulhdYiF7wHJMFSZg7ELXitc9r/FSrNg521BHbn7FkVBZYP?=
 =?us-ascii?Q?mA8BdfFtzcL+23IBJ4DCVnjTcow+tkF/0DDDqyv4yipRIkNIh2IS1cH1bCeb?=
 =?us-ascii?Q?5vhH5HidbD2+Aeyr8qV1ctFLFOAhIDv/CMKDG6AYFaMzk03+GYNwsUDsUP2d?=
 =?us-ascii?Q?TS28NguTF0lx4Op+5hz+8dylHK0MoUReWEdlFJRF1jHCNlkBvceSpoJmKQBJ?=
 =?us-ascii?Q?+hUcN6+iBLav4y/JJ5PavCyGOVLIrkWUaRQgJUMr3K8/Qwnw/Wx+3xBiNxeq?=
 =?us-ascii?Q?C32DJnx+P/0BU/H4+1Ho3oe77hSDVRnLZWclRHtg1hMyCisgS0qCB+FmXJ/g?=
 =?us-ascii?Q?XIlx297Y9zmSLHqyKi9wApha0tHvyscEAYi+fK8kS8aNHBwoLClMlypbXg5D?=
 =?us-ascii?Q?jGvV2G8l8lViyfbv2oiJ+suJIKKk5S13Skr5KMRTDc9ddLDoStI/XDGhuGqd?=
 =?us-ascii?Q?lYEHlfxbs+ri0YGmU4fspEXzVaKsA1vOgP3LdRpuCXxFB1hVQXKUJd2lxqKq?=
 =?us-ascii?Q?btSnpgZGfCHL6Cj1DIg6LXW1G8PgIhAhL+vu4ZSlM7/UO/eLwTOl44/Lh7FH?=
 =?us-ascii?Q?/mj0pKHruEg5J9CyVzg4keg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0870691c-6f0b-4c46-8fe4-08d9e15742af
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 05:38:35.0435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SemW8qYt7sflnS1hSRbk1bGLUxLp4Dl7yADUgU0Lffn0u09e6vcIeztY9tQt6Vyp+o7oDjUgZBfJwABV6LApMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2654
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10239 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 mlxscore=0
 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201270031
X-Proofpoint-GUID: uCSRu2VogNEeR99GBh1Sl10EjZaXB2xL
X-Proofpoint-ORIG-GUID: uCSRu2VogNEeR99GBh1Sl10EjZaXB2xL
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 24 Jan 2022 at 10:56, Allison Henderson wrote:
> The new deferred attr patch set uncovered a double unlock in the
> recent port of the defer ops capture and continue code.  During log
> recovery, we're allowed to hold buffers to a transaction that's being
> used to replay an intent item.  When we capture the resources as part
> of scheduling a continuation of an intent chain, we call xfs_buf_hold
> to retain our reference to the buffer beyond the transaction commit,
> but we do /not/ call xfs_trans_bhold to maintain the buffer lock.

As part of recovering an intent item, xfs_defer_ops_capture_and_commit()
invokes xfs_defer_save_resources(). Here we save/capture those xfs_bufs which
have XFS_BLI_HOLD flag set. AFAICT, these xfs_bufs are already locked. When
the transaction is committed to the CIL, iop_committing()
(i.e. xfs_buf_item_committing()) routine is invoked. Here we refrain from
unlocking an xfs_buf if XFS_BLI_HOLD flag is set. Hence the xfs_buf continues
to be in locked state.

Later, When processing the captured list (via xlog_finish_defer_ops()),
wouldn't locking the same xfs_buf by xfs_defer_ops_continue() cause a
deadlock?

> This means that xfs_defer_ops_continue needs to relock the buffers
> before xfs_defer_restore_resources joins then tothe new transaction.
>
> Additionally, the buffers should not be passed back via the dres
> structure since they need to remain locked unlike the inodes.  So
> simply set dr_bufs to zero after populating the dres structure.
>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_defer.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 0805ade2d300..6dac8d6b8c21 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -22,6 +22,7 @@
>  #include "xfs_refcount.h"
>  #include "xfs_bmap.h"
>  #include "xfs_alloc.h"
> +#include "xfs_buf.h"
>  
>  static struct kmem_cache	*xfs_defer_pending_cache;
>  
> @@ -774,17 +775,25 @@ xfs_defer_ops_continue(
>  	struct xfs_trans		*tp,
>  	struct xfs_defer_resources	*dres)
>  {
> +	unsigned int			i;
> +
>  	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
>  	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
>  
> -	/* Lock and join the captured inode to the new transaction. */
> +	/* Lock the captured resources to the new transaction. */
>  	if (dfc->dfc_held.dr_inos == 2)
>  		xfs_lock_two_inodes(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL,
>  				    dfc->dfc_held.dr_ip[1], XFS_ILOCK_EXCL);
>  	else if (dfc->dfc_held.dr_inos == 1)
>  		xfs_ilock(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL);
> +
> +	for (i = 0; i < dfc->dfc_held.dr_bufs; i++)
> +		xfs_buf_lock(dfc->dfc_held.dr_bp[i]);
> +
> +	/* Join the captured resources to the new transaction. */
>  	xfs_defer_restore_resources(tp, &dfc->dfc_held);
>  	memcpy(dres, &dfc->dfc_held, sizeof(struct xfs_defer_resources));
> +	dres->dr_bufs = 0;
>  
>  	/* Move captured dfops chain and state to the transaction. */
>  	list_splice_init(&dfc->dfc_dfops, &tp->t_dfops);


-- 
chandan
