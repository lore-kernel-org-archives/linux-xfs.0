Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C4D1C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Apr 2022 08:18:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242756AbiDGIUf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Apr 2022 04:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242790AbiDGIUe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Apr 2022 04:20:34 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD50E19EC64
        for <linux-xfs@vger.kernel.org>; Thu,  7 Apr 2022 01:18:34 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2378GgkC000752;
        Thu, 7 Apr 2022 08:18:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=R8mSCyyMCqBaF0clxYr0RVKfSyezbWsRtl9gKhDvfQ4=;
 b=OI+X1Rj1aGUZo2VC4CCq5D695sFvAIFDpVqxzn9QUQB9HXQXhzlaqChba5LfeUNGLpz/
 jCwDnZsIbXSm3MgC5AgzybLTWtBFwNgn26l080f3g+znNfSGuJk9vt4/8nJHJZfVHnxP
 EqcTauyhWoGZvdhsEoeZda+qmlxy0vBIgovo5plrk4EMYrl6BFgDjyH7plP6cLVL0CeF
 ezo+7+yMGt9+it2eADyTMrCj2lIAn49DA9+5dOdccKMw3OZLx0zplABqCdQIEXxHfoVA
 Va4398U+EVP2YK0ime6GJBfdsB80AHxEi/p2x7KTaYd2J7Ir/eBSVQ5mY32Q9hbJSXnD 9A== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6e3su4wt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Apr 2022 08:18:30 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2378Bcsd008080;
        Thu, 7 Apr 2022 08:18:29 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97tt153d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Apr 2022 08:18:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XeSNzQ5LOTT7TZyYdyc0ok1mG49ZXpNkMM++n41KzPCV0sQNEzzxODB1uYw2jprFn09Zvyznhgq9RI3BoNL0KtbC4pbAcVBHfq1G1H72KbGgFXn4ucR6U8rISQjxuxPbvO5b7lNkNnuWU9P05/Cy/QC7WFE2nv2uRT/yy9oXH/sfFxL3EfQMvn5yCOykyAbVgbuxv7hKLz8tJuUoHxFNjQYAscyIvQCBIccyE/VdRiMdkJ16QnSjS43ICb+dDvMkXpkE5o/7xZLm3knthOCf3xgnUUfOABWnGA4PNvWPzQrW/QMpzy9ab3wFSjDf1sgiru6fPaQwirl7XjinmP+Ktw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R8mSCyyMCqBaF0clxYr0RVKfSyezbWsRtl9gKhDvfQ4=;
 b=PVdPfCnUVrIfwA1cgRFxIi6Q3sCKdz3vQm+0166RlZ6Ya8estFdk9DPsc9TGxWjWL66SKOi2KlDHMtHGeWryV/I2EV2tnuEPwwUAlU14zGMRUm1gMzsKen/Mme7bouI9WOMUQsLl3k2jTbEayEcWETjcQnA+i91Y4jhtqvcD2jhatpTv73ObSf/4ZyWV54vS6H4rsPjPqYRklI96kqim1ZRV7Ll8h1urAUq459yMEzh6RwX7Z0CPHCYmnZ8Xh8jlZtrckVCpNLm+Hp4ha6TdtF9YHb7+nfiEwj7y64trUkoO8o8iK2XpAGSoT6wzL9SjBaXOGOxGe1AbgFC401ziiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R8mSCyyMCqBaF0clxYr0RVKfSyezbWsRtl9gKhDvfQ4=;
 b=Lk5PJfxP3w1NIfvWJPnwW7HQeg7OTtU3ntx9ps/wmO922p9ft57WtDmrrwQNhJ/dgug2NcVI3K/cRHZr6LdZ1gkNljPltLH6vZGpPOS0R+fwJFTSlOhHgn2O6ouIzDchWNaAF0eTbEwh9TyR91o0QzQobuJ6JbIW/m6lu4Bn8iw=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SJ0PR10MB5613.namprd10.prod.outlook.com (2603:10b6:a03:3d0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21; Thu, 7 Apr
 2022 08:18:27 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d%8]) with mapi id 15.20.5144.021; Thu, 7 Apr 2022
 08:18:26 +0000
References: <20220406061904.595597-1-chandan.babu@oracle.com>
 <20220406061904.595597-13-chandan.babu@oracle.com>
 <20220407010544.GC1544202@dread.disaster.area>
 <20220407015855.GZ27690@magnolia>
 <20220407024401.GI1544202@dread.disaster.area>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V9 12/19] xfs: Introduce macros to represent new maximum
 extent counts for data/attr forks
In-reply-to: <20220407024401.GI1544202@dread.disaster.area>
Message-ID: <87o81dxq5y.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Thu, 07 Apr 2022 13:48:17 +0530
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0025.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::12) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24482fe4-56e5-45d8-1bb2-08da186f306b
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5613:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5613658AB2891A4F9AA90579F6E69@SJ0PR10MB5613.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B+KZLs/UZqZApcLGGqjTe1NYkewIem+ii0l5D3mpn8+1seOMxF++T9IY27pBhkl8WQa62HDstAmghxx6oY4DXSSTJBFtq44bos9e1K/YJcP+6BEzzllV4CG72kIqk5CPYqooCzlhhM2Nl5Dm91zPmfv1WBvDww6v40xcRHkjefD36p9L3DsaC2sGLlbib4lXbeLrtaFjlY/u4NdoFKPbQq1DdpegzGfYNl87QVkYUkKlY1HqmH/6gyCbZ4Kv8Fs0ARzY6PmT7uuBaosU3nEe/eN2ihndKMmt4gaGuYHe8b6DIy9gPuOpToAjdGNjIpWWDkWuzYLpjmnQkQGhTKOjCuei7AbIVxLFrSbM0B3RiVWB6mI6uc12IcmHdECRVK65qU5LT/DIHYxuUTj5eUXCnhklsVXpShvZCTmfi/T8PbAWSokYebx/jh4AHAtPI/iqgjsoMO6qaz5o89uVsZogMCa8rFI+CXWgorSmnJSx5e1Auo6P/zAzdZ3BPTvaTIvqT3op7LGxB8xTJ2/DtPaYwaRzYoCp8J731gLDkhRhWk9Mi3RuSihx6ENes1rnzMT9vgwJkYGd5b9UohXN0jehMly0YYtjkj4ca9gZLjqsohmeGL9y6TA+qd+c6DM18E51AZ5zW4rIBj5yblyg9AXCR/pInP5Xk6fVqAigr35YMarTfRG+rFnR2P6vceY/WqeWQbmGMxte+V5QNypQfIFqLjrhuDP5gylx1vca5TT/dMT9ZZe470aR3Q4jCSelJJv+U04r5yVDXE6p7RWeqyIDc+Db7NFyAxwW2eY2FZEbxss=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(4326008)(86362001)(316002)(66556008)(66946007)(66476007)(6916009)(8676002)(6666004)(6506007)(9686003)(53546011)(52116002)(186003)(26005)(6512007)(38350700002)(83380400001)(6486002)(966005)(8936002)(5660300002)(2906002)(38100700002)(33716001)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vkJdjYG44jFB8iYpk63+Fjrz9eBKfe7Qz3G8O3Bwpm6zPM4xrj8tkikf+1/A?=
 =?us-ascii?Q?ZlEzXnKQ+ehq/Os9BxuwlsqXf+wHqQLKI9YY7gq3aCxED/fdqgX/HQOMAmD/?=
 =?us-ascii?Q?g+fhn+vnrQoFXMv1pT4aLSAn4Zk/+ndR5yA69aUM4Bi8kBQSXZ2FjpdokyJm?=
 =?us-ascii?Q?A66zaPgGDi9VNGWa4Kt0ZPL+LjH4AKD2nP8rfKo6WcW391aW1eBZbrARZGra?=
 =?us-ascii?Q?8dD5D80NLmPAC6smNEqQHfdGKOPKHBwSE0Ro6sLOkNRzmWFHoK8PNK+hY53D?=
 =?us-ascii?Q?tQrH9evfwxzKGNA7s6tvGer7hyg3jCiFTIWP9hYwp19MNb35Aigo028zywUN?=
 =?us-ascii?Q?iJbElvOLnYtgVw+qTOwE7Z8WJrBNFN9JUfVfa/4z5QVbFyRVpm1+uJSBA4Wz?=
 =?us-ascii?Q?iy4EQGgxJDvzI2hxwCUmcHlLLauLDk4a6xBZ+iP4ETod+xX6hKs0VJ8hHOLv?=
 =?us-ascii?Q?jIPSRQrp+tRo2rmYxsY+GrxFw5pE9yzH2M90buWOorleG3LbVAcb9rEJV0TE?=
 =?us-ascii?Q?VnpShtmsmuOLqDfRCgMQwLmcY2Cr6ZYLsna7AiyXgDO0/fxVer35tlisJTDZ?=
 =?us-ascii?Q?v88vc7HXlyo96ML22JTAsiQw4NNNuzXtDS2dvUSNroGqkKsGVAC15tITC4aC?=
 =?us-ascii?Q?LJdS1QgEE6i78jVQn4gT1NfPy/CKy0lE0nA/K0RrumHHlntamI4uOxqIwRrb?=
 =?us-ascii?Q?TvIz67Gjs1Kv6SONycfSmRWs0lgeKQcRF8SSDIHC9IeR9dL9+ovYW+kRKamo?=
 =?us-ascii?Q?0voHkUEH27v7oc6C5yZbFg2mExq/L3rbHjEoNOOpGQ2E21MsTjSKZMYpmGGB?=
 =?us-ascii?Q?Na9sX+fFJAB6vEHwGi2/zZ0I3b6f/4EE/3vCLuQY0WUa6tkEx0xizgWEfWxs?=
 =?us-ascii?Q?cHa3alKmGgFWvowBUl5LrAPDJV6zIvQ+IaZmKJtWQLMLAm33Uj4F8DSJ4v5N?=
 =?us-ascii?Q?Q40VOZs4H67Gklu66UHJElAie2lwhx5f1FV45fYRBJkF4ogxSwypslCbrF8R?=
 =?us-ascii?Q?u+40R8T/Z0ay6FbdreBC1i1YyxEWMqeiESYW3dhS91GVjAuV2eE62NssBAgZ?=
 =?us-ascii?Q?fhD7tq0hNNxuM3fLdL8ZoEvakMLCXThtZ4VWORdHYxZHVIqYHa9Qvj4GVNTT?=
 =?us-ascii?Q?+yVbw/oqNYkikjFdrbmSIyaSWws4hxoT99OHZzjg+gZBg/fl65SAQfT9KhYy?=
 =?us-ascii?Q?/uWqPXnSHE5HBLlSn3QVWqJBPxPd3hvJYO3JWMqXoeid7u668hOwl0GoWdOx?=
 =?us-ascii?Q?OsGX7nggzbYsxzpVxwCHI/Gaq+jndpgzjXXnbw8vhpNXKTkEqIdeQvmTpE7R?=
 =?us-ascii?Q?d3YuR08zQeQV5ZsrtAs2Ml4NiWNgFQlwYhLL8Y2SjC2cS4NLJTLPqoapxed7?=
 =?us-ascii?Q?R2RFN8/Hy/o6g8MuCNGWr50FV3B996U3QbX/tcW21FbXCdSCN+4t4v7A5C7q?=
 =?us-ascii?Q?6Dr+eHyRPkev/acNJLUBpX+W3X23wDDxswnb52z/CAY7XopIAg12tNNJaNoy?=
 =?us-ascii?Q?lL1xR7YDiLCItrDHlAb+RK88iEcNUJVArQhut7wWTVQToreX4mXrNSQ7vjYx?=
 =?us-ascii?Q?wn+NmGSRBFnQsS/FtDtuXy8QeEnoDQyqj0qzjyZGy1uVOpHVRYiNKd6ckcON?=
 =?us-ascii?Q?rp/AH9HtgF+r5RxsO7JZdzLjh1jI9fmJo0eVyPvuEpNFYTZnd+513WryL1/v?=
 =?us-ascii?Q?4LFhRn4Mkc/RfO/9Yj5yKSXEuydvOZOfFm8Z94Q/j47IBJqLYlTqnSojAKe0?=
 =?us-ascii?Q?VLZeA5ROID8M/KWVn3y7gVXH2mBoZZk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24482fe4-56e5-45d8-1bb2-08da186f306b
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 08:18:26.0983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n+7CsnYuZDj+o7OgY9yPakqLKYsZmtqmk+wAn1Bqq8xnocxQHyQizAKzgcdAU7I8tiJe0JV0y1UEsu/W3RvvYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5613
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-06_13:2022-04-06,2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 suspectscore=0 bulkscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070042
X-Proofpoint-ORIG-GUID: ltYwqkoRNBu9kNEYy0DH8-S_0NTvCsN_
X-Proofpoint-GUID: ltYwqkoRNBu9kNEYy0DH8-S_0NTvCsN_
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 07 Apr 2022 at 08:14, Dave Chinner wrote:
> On Wed, Apr 06, 2022 at 06:58:55PM -0700, Darrick J. Wong wrote:
>> On Thu, Apr 07, 2022 at 11:05:44AM +1000, Dave Chinner wrote:
>> > On Wed, Apr 06, 2022 at 11:48:56AM +0530, Chandan Babu R wrote:
>> > > diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
>> > > index 453309fc85f2..7aabeccea9ab 100644
>> > > --- a/fs/xfs/libxfs/xfs_bmap_btree.c
>> > > +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
>> > > @@ -611,7 +611,8 @@ xfs_bmbt_maxlevels_ondisk(void)
>> > >  	minrecs[1] = xfs_bmbt_block_maxrecs(blocklen, false) / 2;
>> > >  
>> > >  	/* One extra level for the inode root. */
>> > > -	return xfs_btree_compute_maxlevels(minrecs, MAXEXTNUM) + 1;
>> > > +	return xfs_btree_compute_maxlevels(minrecs,
>> > > +			XFS_MAX_EXTCNT_DATA_FORK_LARGE) + 1;
>> > >  }
>> > 
>> > Why is this set to XFS_MAX_EXTCNT_DATA_FORK_LARGE rather than being
>> > conditional xfs_has_large_extent_counts(mp)? i.e. if the feature bit
>> > is not set, the maximum on-disk levels in the bmbt is determined by
>> > XFS_MAX_EXTCNT_DATA_FORK_SMALL, not XFS_MAX_EXTCNT_DATA_FORK_LARGE.
>> 
>> This function (and all the other _maxlevels_ondisk functions) compute
>> the maximum possible btree height for any filesystem that we'd care to
>> mount.  This value is then passed to the functions that create the btree
>> cursor caches, which is why this is independent of any xfs_mount.
>> 
>> That said ... depending on how much this inflates the size of the bmbt
>> cursor cache, I think we could create multiple slabs.
>> 
>> > The "_ondisk" suffix implies that it has something to do with the
>> > on-disk format of the filesystem, but AFAICT what we are calculating
>> > here is a constant used for in-memory structure allocation? There
>> > needs to be something explained/changed here, because this is
>> > confusing...
>> 
>> You suggested it. ;)
>> 
>> https://lore.kernel.org/linux-xfs/20211013075743.GG2361455@dread.disaster.area/
>
> That doesn't mean it's perfect and can't be changed, nor that I
> remember the exact details of something that happened 6 months ago.
> Indeed, if I'm confused by it 6 months later, that tends to say it
> wasn't a very good name... :)
>
> .... or that the missing context needs explaining so the reader is
> reminded what the _ondisk() name means.
>
> i.e. the problem goes away with a simple comment:
>
> /*
>  * Calculate the maximum possible height of the btree that the
>  * on-disk format supports. This is used for sizing structures large
>  * enough to support every possible configuration of a filesystem
>  * that might get mounted.
>  */
>

If there are no objections, I will include the above comment as part of this
patch.

-- 
chandan
