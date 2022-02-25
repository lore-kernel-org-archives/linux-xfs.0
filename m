Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A27CBC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Feb 2022 06:13:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237621AbiBYGOD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Feb 2022 01:14:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbiBYGOD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Feb 2022 01:14:03 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 364F5194AAB
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 22:13:30 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21P4kiQH019374;
        Fri, 25 Feb 2022 06:13:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=IQpc80+wHQifbU2Gn+kl5PnWvspfiMzyy7It/XU7OsE=;
 b=bLr2uFfapKTN3AZzcc7g5qtSookYvg7YXFGKPa7AGPYOXrIKKj5wD4iy6Bb9/Ay/R6/z
 oJy9+0m4W3HGC0BXJBG6g6nPfjwTy3u3wEhbaN2HvfZKnMlRLt2TQBPCSmpZFxfAYcbs
 tEn/w6Ny33xslKeyqJSIUvHJYJpdIuiRbEGcO0fHzwoFJ2nhA0m6DlE+GAipGG5Ga9BK
 V5WFP5ghcGtIlsGpFuDRXtnoey1SkSHeUEP4YUSlVls5YkNV1po2XKb0myh1ivE3fLjn
 /Mw21kmsTMmswFEglKgVFZXDW12QNtj0hII87wfXLnRMp7DSQWGaB7+kh1MbGY6CQ1N8 jw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ect3cs46q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Feb 2022 06:13:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21P6B1nW121560;
        Fri, 25 Feb 2022 06:13:22 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by userp3020.oracle.com with ESMTP id 3eat0rntvu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Feb 2022 06:13:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QGdbX2LmJ0iasOyfmBMXx9trTUr8Yq926weVC9g7DppAGEyLUEQjktm2pEYhe1pw4hCvfhhrt+RtU8NVVgl/njLg3t7ristZLeMmr7DQRlw0fDzE6qnalqKjINJ8EDLOYjUp1oIU5GXK7wumLdjHG2VjraiZ5FBaxxkbmfrBiqwrMlWo/ew2sTVM2MCw3EIGtMEbsSoF/LBTOgCKfNJ/EmwxzUHbptdY2Al0NVdRiaGN31wU08cLHR7oDJ25qm3wkneh8PFAWhHWK9/zgT61sUN0RwUNdryoo2OZ7YguAbJtSNtWCyYSpZ+oVfObiNNdQWfYtWajKs5MYofWLYShCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IQpc80+wHQifbU2Gn+kl5PnWvspfiMzyy7It/XU7OsE=;
 b=UtZ8pvV/eSsRbpYvxWzphIwvEcBsdtt8Derz8T6y8ouoBFJu7fucy6Hc9nAmDv+nzH7Dsw0ivX3iVZg76ia2yr/Xgg2eUvxgFHkJgoCg+l7vTcXe8stih06Z5pGvbh97HMXS2RBO0yOMLkJTG2aFewHnKKxhpR7AEUWDA8/E/w8dMTsNRjDZu5RDPKhqqxzAc8RpVXnPmqjX0TD147ErDKGgMBBqsx5gaP5YHn/u1W8tF3eg7xA8TU+QhvhyEtbA3x/S0uHNUPcOxbN1py45pobh++31s+F7yv2qTJsEddVwbizoLkobVK/23Oc3JppslojErIANAzpHmjOHD9v7Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IQpc80+wHQifbU2Gn+kl5PnWvspfiMzyy7It/XU7OsE=;
 b=Mqv9REcBMtj+u3PE7W9rE73jA2W+goHWEMuXniygroWCUGvDuMR+xZhP32aWnWSGRh2VDmMdZZh7EZMN6Q1qIeZ6n5FRCaNpj8YnsbDQ8rfZWyGHk2m6kxt0SgjeOvrKL4cFs2SGvacuhOIXD8A26f3duQclNjMnkStiTsDwyU0=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by DM6PR10MB3355.namprd10.prod.outlook.com (2603:10b6:5:1aa::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Fri, 25 Feb
 2022 06:13:20 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.025; Fri, 25 Feb 2022
 06:13:20 +0000
References: <20220224130211.1346088-1-chandan.babu@oracle.com>
 <20220224130211.1346088-14-chandan.babu@oracle.com>
 <20220225050610.GQ8313@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V6 13/17] xfs: xfs_growfs_rt_alloc: Unlock inode
 explicitly rather than through iop_committing()
In-reply-to: <20220225050610.GQ8313@magnolia>
Message-ID: <87pmnba2yx.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Fri, 25 Feb 2022 11:43:10 +0530
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0015.apcprd02.prod.outlook.com
 (2603:1096:4:194::16) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd3c0324-bbaf-437a-c4ac-08d9f825eb7e
X-MS-TrafficTypeDiagnostic: DM6PR10MB3355:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3355C5F350DE117F65385BD0F63E9@DM6PR10MB3355.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0jH0FynGSUEZQKpP0mN+XSFAWPbo5ZSlxDTyYySUbBIdz9n4KwZgtcTfKlONEFO0wG9DlZMK5k4RNqNkDlo3f/yMhOqWNc+2/cayvDd1iYu35D+GmrrY3TzjIadcGi9KtvN1GzzvHGZUaLx+4LTMeyoOZWc+ugvG7QO1O+Y0jEI7w+PR8qeZhy2+s0I+Jp7WEG8dNgEbZoIwYS24i+TQQESJbNawtRmGncriFNkzcJFjBvTmwQlqKCXthTsaXG/sOB6DAz8dqLM69YZknh5Bkqxk/V3on7f8jl3ONduTFKzzf6h+MmlGBWio1ozYCzTAFal5SCuuh6DqPHoCYvRwsxq20FCrKul5SCOJUbaIuBcWDbL99tJcF1Bm+NgncgW4ZvLWvq+NZkiXwu30TobdI3bQwkhfpDulPQi9QH9AcdOmya6gesEoM8PuaVRMAHfxV2LW+1ECRsWNycBejn7IqctvxeQ/L518vm6sVNVpBDVNdiwM1j/nt7xcVQl8xvffHOhKU6FTujX8y499Yas46TQcIr81gYwZIqToEQZFpTYXiOkkP6cS2BNTZ5FHf5mSo/aoxccv6dEpk3NPG8EA/uddVTAhFgSN9M2FcopXgyJHc7RG3iM11iDe+xWfg9r6RNkrgD/UdhM5drsRPjzPEaAqnl34NBNev6/l87TrBBQB1opReJQCxHjkL5z2Ai1O61QQqNSMM6VRsK764GEJMEo88ndYKAQuZ0/BQ/o9tis64oB+x4p6XIsVK8Pnd9Czlbf7OQ3Dmnh83IuBeRQm0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(33716001)(83380400001)(8676002)(4326008)(186003)(26005)(2906002)(8936002)(508600001)(316002)(86362001)(38100700002)(38350700002)(5660300002)(52116002)(53546011)(66946007)(66556008)(6506007)(6666004)(6486002)(6916009)(966005)(9686003)(6512007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?86FUPUytGeTg8MqSI3iA1cItTfWxXEcMZTc+ZYI+tWhPsmQip1uekyHRmPrw?=
 =?us-ascii?Q?RkhTjDCVTu5HFvYoE4RIasKZcLFQdRXwHpSHEvLwI3SY4WrJ1S0AKfmitZ2b?=
 =?us-ascii?Q?lttP2rZ9fA+RYBpHX6nXSf0A1NITdYFPMChI1tgq+HueW473NiaYXW4xFSHT?=
 =?us-ascii?Q?2FKFi1ArgpXfr76h8VRcMMsQgZ3Uthn8uR9M7W04gmz78A471YBOKhIUNSNU?=
 =?us-ascii?Q?xj9/7odpC0Ct8zYt+n/1KTT75pur56+4UupGvTA9pXo2Q90EpkHweHDOegGt?=
 =?us-ascii?Q?GbWD3RshmtmIuSuxnX+VeZDxyq94/aQb7T+t8UAUFkAEiZ1B0CURgsOC9ZB4?=
 =?us-ascii?Q?NanmY9pAWNgDSDdfFqlnWJPfP4VGktEjthNxSXGM2AaKUnLAxjlmYkJXbrkd?=
 =?us-ascii?Q?P7dG/+KtfniIhMSEJDa5qdHTbbXLikCLzJGR5CZXf+pM6PkHvbNg+9Bcz56R?=
 =?us-ascii?Q?9Umqb45tWoi5Spvr0sEG+ULr7E0bFBefNky7X4g3Kjhn1aUuG/ijwFLs1N8O?=
 =?us-ascii?Q?E/5hK/CGngZKKWTyyBoXw6YLi+abnMPO+aV7VP98K5CrpvGifnPgqJsmZPjU?=
 =?us-ascii?Q?yEvBJLT1BEK/+tFQ+GOWHR+SeV3YzlOYZVRIrIK57h8WI2hUAGUx2NSiio7E?=
 =?us-ascii?Q?N7wjojIpTbQxpHGcfKLVNRovrHIIKeQrcKGzaB8IzV3zGf2jMTLwIwrNTtnE?=
 =?us-ascii?Q?hSlBrX/YOjXTDC4K5jIMTLqSE5ILNKZMUTOnMNzlwu4PuM03JfKQ637VALTI?=
 =?us-ascii?Q?I4QnakD5MmFIjHd4aC/roEWrhHmaty+/2MEXqhTLUtMMH6tg0OE2HZ9N7qCz?=
 =?us-ascii?Q?SFBnjOMPg+L1uIxWEuC0030YAK+5hiH7saQyPh8DPMWOsrdA+FtH7kZyU+bu?=
 =?us-ascii?Q?J/+Hbkjy+wfuSLd2QiyLsYVDR7kaND85Qmeb6oYCb6uTfhogKcfNqqlNeU4t?=
 =?us-ascii?Q?lVHWHVw5D4XH1jtFEHqM5AEJlueiLijBSkSMKK8QRm9jLG/POL2/mPpXxgKz?=
 =?us-ascii?Q?53hpv6RbYpWtUjr/dywtKdFiv53b673uU5k4tbyLqPCCAJLJvhSI3DD3LyJN?=
 =?us-ascii?Q?a4pjqZMLOJi2TF/fHsYJu46i7/zJOvRlO03TBvJFviplyyCae11WYuhESQOX?=
 =?us-ascii?Q?8YEuDDPx//N5klSt94UHiQEB9YGpLgouNlszuchRzAY06HjDWcfCGI7dMbRH?=
 =?us-ascii?Q?aeDJamsZ1Ick5dCB0/Eixm7FKuY7n9SCgJyARehaG2NgIrhiM7DGrBWZTDO4?=
 =?us-ascii?Q?KvaK+jAyEBxohWZWBjNGNUzBGWrAa/tgALGLHGGLqzl25eUUVFLYrHH5aTd7?=
 =?us-ascii?Q?jRYUkvQLPlnOSXut92p7cFZqSlMofcbUe6ISviOaq0nm30XhaJHf+r/n+FBl?=
 =?us-ascii?Q?pG6iVA8W87VE5bxSUHOauxYW9mkBkF+qBA5HlyrbuRfQvGSeqOvn/nhYLfPd?=
 =?us-ascii?Q?cl3qJR4LKPq6Rs7h2nYDGy/YnYEpiD3uV1aooqXj3BCuxFB5ZCYe3YXNFqHN?=
 =?us-ascii?Q?f/KjBX0MbnPTRJzPZ1ALQ4/EkqN3znf9cBsSeXAikgMlxIPPRj8FaIkxC5+V?=
 =?us-ascii?Q?ukPb6cOxhzsbHk8Ct6s8Mw2rjwFK0Gs8kLuQLAYLVPtJ1JM+smIpRYwbJdAd?=
 =?us-ascii?Q?ZZxTYhU4+VFuhixlBNHoQ7c=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd3c0324-bbaf-437a-c4ac-08d9f825eb7e
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 06:13:20.1504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KylsP8OLhhdH6G34zSaNS5OglF5brik+UnFLWo+nylr1ClBlUqORXBivPXW4nSFmEwZwcA4eVGiT6d6T1ciU1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3355
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10268 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202250031
X-Proofpoint-ORIG-GUID: w9bs1F6y7dSHATdo7XRL4wkx0gVVFPxt
X-Proofpoint-GUID: w9bs1F6y7dSHATdo7XRL4wkx0gVVFPxt
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 25 Feb 2022 at 10:36, Darrick J. Wong wrote:
> On Thu, Feb 24, 2022 at 06:32:07PM +0530, Chandan Babu R wrote:
>> In order to be able to upgrade inodes to XFS_DIFLAG2_NREXT64, a future commit
>> will perform such an upgrade in a transaction context. This requires the
>> transaction to be rolled once. Hence inodes which have been added to the
>> tranasction (via xfs_trans_ijoin()) with non-zero value for lock_flags
>> argument would cause the inode to be unlocked when the transaction is rolled.
>> 
>> To prevent this from happening in the case of realtime bitmap/summary inodes,
>> this commit now unlocks the inode explictly rather than through
>> iop_committing() call back.
>> 
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  fs/xfs/xfs_rtalloc.c | 12 ++++++++++--
>>  1 file changed, 10 insertions(+), 2 deletions(-)
>> 
>> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
>> index b8c79ee791af..379ef99722c5 100644
>> --- a/fs/xfs/xfs_rtalloc.c
>> +++ b/fs/xfs/xfs_rtalloc.c
>> @@ -780,6 +780,7 @@ xfs_growfs_rt_alloc(
>>  	int			resblks;	/* space reservation */
>>  	enum xfs_blft		buf_type;
>>  	struct xfs_trans	*tp;
>> +	bool			unlock_inode;
>>  
>>  	if (ip == mp->m_rsumip)
>>  		buf_type = XFS_BLFT_RTSUMMARY_BUF;
>> @@ -802,7 +803,8 @@ xfs_growfs_rt_alloc(
>>  		 * Lock the inode.
>>  		 */
>>  		xfs_ilock(ip, XFS_ILOCK_EXCL);
>> -		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>> +		xfs_trans_ijoin(tp, ip, 0);
>> +		unlock_inode = true;
>
> Hmm.  Eventually you could replace all this with a single call to
> xfs_trans_alloc_inode, which would fix the quota leak from the rt
> metadata file expansion:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/commit/?h=realtime-quotas&id=c82a57844b60bb434103eacf757e47417f94a631
>
> However, as rt+quota are not a supported feature, I'll let that lie for
> now.
>
>>  
>>  		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
>>  				XFS_IEXT_ADD_NOSPLIT_CNT);
>> @@ -824,7 +826,11 @@ xfs_growfs_rt_alloc(
>>  		 */
>>  		error = xfs_trans_commit(tp);
>>  		if (error)
>> -			return error;
>> +			goto out_trans_cancel;
>
> xfs_trans_commit frees tp even if the commit fails, which means that it
> is not correct to call xfs_trans_cancel on tp here.  I think you could
> do:
>
> 		error = xfs_trans_commit(tp);
> 		unlock_inode = false;
> 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> 		if (error)
> 			return error;
>
> Right?
>

Thanks for pointing out the bug. Yes, I agree with the above suggestion. I
will fix it up in the next version of the patchset.

-- 
chandan
