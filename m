Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98944C433EF
	for <linux-xfs@archiver.kernel.org>; Sat,  5 Mar 2022 12:44:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbiCEMow (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 5 Mar 2022 07:44:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbiCEMov (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 5 Mar 2022 07:44:51 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B4F71CC7F9
        for <linux-xfs@vger.kernel.org>; Sat,  5 Mar 2022 04:44:01 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 225ARlq4009954;
        Sat, 5 Mar 2022 12:43:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : message-id : in-reply-to : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=x/t6kAfEIA04YQ8fyF+I0gM4x5iRTK63j74f/v3k9AM=;
 b=Ps1AhHjvd/5HXU4HUR9Ruea/SA3Iz0S5rk9LZpPvpcDYaj1XpJGOxXM85Av+sgs2jdIw
 SR7GfT9Ccl935i/5LDvV9VIzUkjLKzDelGGBpd7m2CkcUl6WxtHyP5A/r7QVZwxz5idO
 L7rSGOwHngNhkSYkiZFtuRSHQ0OqrcMKfi+ger9qKtOq/1wDs5TRj5nPNuc7M6QF098d
 DA4SO7AS5yT2gsgqxzEhe31E8Mht+W9lGij8a0wSap9gpjpYqzRu8o9ZtmCctWL83Hth
 rShKOBZHtkkv+DFDEtThh+Xq/FpLxZg699UuJVHXEzJktzuzWYPMFh3hPNda8/wHA6+W 3A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekyragnky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 05 Mar 2022 12:43:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 225Cb1sa113102;
        Sat, 5 Mar 2022 12:43:57 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by aserp3020.oracle.com with ESMTP id 3ekynyqw8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 05 Mar 2022 12:43:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b9E6AfulnW1QyalBN5Y53yyI21tY8Cz3rQ0aXfkfGDey95V7gUwJDRSO6yj8Mb5SjYOi/jdPLxby30Xe7ovFqfAVVz+R6oHoYRErMZ+ABzSxkIGrN4+xXqMnZIFdWpzEdsFEcHpZMkXoHLM3s1Zlrcbm87pwWgp3U3TVn6pWBIe4lx6Q4mnwApMZcz+wLbOrNP08imaHqyloLKFB3W9Vqucs+O5VkcDv0NHROB+e61p6zWJRrtHXNeMIhNQYz9/s3yI9AYZrf9kpj/0SOugsNv0MUesCXWAvIft8p0mx2+kgokNlCv6Ba0oyvD//Tqvow7XlJWz0d0h1EYahF/eZkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x/t6kAfEIA04YQ8fyF+I0gM4x5iRTK63j74f/v3k9AM=;
 b=D8MC7ypY1icv0eMm24Wq24E9HNRdx3+vP7zJ9hOp/BIOD1zvrvMsf4d579SGeXbdVz9APQMuKuNzXxlJvgfLn3d8XypbnmskjyX06ZGJOx61BAYkGyNap9EtZGrGJzC6SOKwkpupqaE5bAJo3usth/XjoH1b68zoZdYPyrRPEpJk4KZ5DLV/jzSrkC+xSQJRqQjG8z6ycH69umkznX3enzZgOJmS26hF7rb7nm1ZCC1GMLSTisq1zeQsBNGJSUUTgE/sVMe+4sNOxPuncmhH9rHYT58rc2T7yGpDa8UmiJ/2x7lDiiVV/tpE/JYeDYVh/m9Azqhoi9ZAK1UKK8HXJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x/t6kAfEIA04YQ8fyF+I0gM4x5iRTK63j74f/v3k9AM=;
 b=uWH/ooHxpdnKneZxOjZCYFIfz5Pju0qbyG9RV4eL9bidZNSd5JjTAT0D1qCyfE8arKqHXaUPq6W3TZ9zaGXe0h2kXQ9xWJ45BiH/cyz984MG2j4XHMFUXQhDg6/Ihy4onc6cX1BdHVNjOiAooPKAI7EhRpjQBf10J+jLfzIVlpg=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BYAPR10MB2821.namprd10.prod.outlook.com (2603:10b6:a03:85::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Sat, 5 Mar
 2022 12:43:54 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%7]) with mapi id 15.20.5038.019; Sat, 5 Mar 2022
 12:43:54 +0000
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
 <20220301103938.1106808-8-chandan.babu@oracle.com>
 <20220304015722.GD59715@dread.disaster.area>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V7 07/17] xfs: Introduce XFS_SB_FEAT_INCOMPAT_NREXT64
 and associated per-fs feature bit
Message-ID: <87a6e6gcyz.fsf@debian-BULLSEYE-live-builder-AMD64>
In-reply-to: <20220304015722.GD59715@dread.disaster.area>
Date:   Sat, 05 Mar 2022 18:13:43 +0530
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0179.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::35) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e0fb9d22-e273-4cad-29e1-08d9fea5cea3
X-MS-TrafficTypeDiagnostic: BYAPR10MB2821:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB28216102636F51D1BA8AA2FBF6069@BYAPR10MB2821.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eUi1s5BJTcdCvD2eG1wLRmCqwOwzypUJnzdmwva1AyOQTBvZ3ufWEciWhtFneJri+HvWRmhxrDk6a9hFNGrN9v/YEKlrPsEWHjnC3nMH3FlxyOYKLXva+3EPR17fiBciHWWVpDKl8FQxHSeGQGtESjKQi4iHtv0hicqrkYz+wRkhTUFV9qH7SlhQmbctvPbHN5KUvD2QeTA5KqZNtUoNPYo4JPHq64UbdjH9+gjUFNc2K2SwbO3EfES3OpMyTN9Xea0XuY4sp8a3d4ZnfxqwK3r2op7rIHfHwQ04fuVM3y5264QQAylGrJpsqCtyXHp02+n0yf2hRWFgcex9gsSMfesN+/On90Q01qhm27wMfwMp42CXxpsecYnqVNYl+M/xKdSUXxYOhpklBqrsKx5HAymfkFpWs05bYOeqIJPRgia2E8Ki8ykRBlWr8/R9Z1W4cheq2wlnXgRpTJavXX9rlMcOpIt2yc2Y06P/ybxredxkXMc5AslxJtm1hh6sUEF7Wvob7rupraLBbhcSR9OCYt2Wee4meLz8FhwXVh3vl3SbMAhclTIHcmWN1tcYoGcteqYxKjHIImPZbujRBmhgHziih6pvUB6/b7Qnnd0jSigHP27y1AZP1O+7ufLrMILM45erK+2fRcJyCb28Oqo/dlko7Tf1uGeu5txYEcYwlRShnsTsivPKk8QA3DVxzvay0/BD2o5W+L+GPrtWKjYmUA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(508600001)(83380400001)(26005)(2906002)(66556008)(86362001)(6486002)(186003)(316002)(66946007)(6916009)(33716001)(53546011)(5660300002)(6512007)(6506007)(52116002)(8676002)(66476007)(4326008)(38100700002)(38350700002)(6666004)(9686003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?APw9yeRiSsD3KQoNcg8PByXvoM9zRvj4yJdH+d4clFUfy7Zxy1Ko6kmMW/Oi?=
 =?us-ascii?Q?H8SoIP3bP2vEyOwR8yDkhkAnwTZ6z4Cn3KDqW/MLn8T1fz+D++IwDderlMZL?=
 =?us-ascii?Q?mjTMJhORAMv21Om9GcvA/P5g+wukdLlvm2hVurKqOCCEtDvzInlNIGe2WLjq?=
 =?us-ascii?Q?AizQmo/66kGt0jzugmwfS/xcq2SJNUWVMop6UlYsmGaq/LGODExajzip3zDp?=
 =?us-ascii?Q?HHKdmrOON4Yu/+2FrbHIJFLP4an/66oBdGiKFkocuHQ+poGAoKsVHD+5S2gW?=
 =?us-ascii?Q?SayQrNV/vsLmp+Biie4aRbqAgQsGFcsEl4xzAFSfGwHcuSRX0jfdKPQNIgDi?=
 =?us-ascii?Q?Iuj47x1BghvY8HTL5f4b5FzJ9jW3VPDdeGlzwA2wNIBzSNpNEpT58uIDEeQY?=
 =?us-ascii?Q?VD2AeZbROQK401279D+TvTJ2dLmKm4kvaTOUii1rZ5luIes500glUHRn6WSF?=
 =?us-ascii?Q?SSIaWBVGiQ8KPW9ONwvkfEKDNAh8ed39l+/WCw65qODRGjH7+cprr1KKL+7v?=
 =?us-ascii?Q?vxr4Qeobys+sS0UKJKNtvkYeEa7iOyce8wAwWChWTuydB9r5DhX3KoZj5RS+?=
 =?us-ascii?Q?QsYq/QYFg2hg0EPBxcCQ+oZxybeZmhNpfBkWCVfzQ5K9yzP7ZOn2j+QxEV1I?=
 =?us-ascii?Q?occpH0QCcOuoEoyIyhP9TSkhVvT8y3dTg67CEd8rU4mTdjwGtG3flnme5r6t?=
 =?us-ascii?Q?afLuc9mCrfxwJuulqZp4ZHk5O38TvQvKeprKomTIqvXPIshojtOl98Ie03XT?=
 =?us-ascii?Q?2IhbPLaELAl8KLDnDecrSQ0KKz+va4/yVZQ9GL7fqPpK3KLTmRvQwsQm7wq+?=
 =?us-ascii?Q?5bjOl5B6LBLDY2ZmLaf40Avn2o4QvAF9BDu0CaHQH0dCiK+DvAV1TJ63Zryo?=
 =?us-ascii?Q?ZHLVcMaGpyjb5/L2WcuLtTaQwLbQh+SB01aI2+9hcAj/q9Yx4JIEyI8ZGyDD?=
 =?us-ascii?Q?VFAiN+HxlmxYmdx8sb44LrXEICGF2any7udhjdcZiT43/rNSqKp9DQL7CkZZ?=
 =?us-ascii?Q?qMFVFWXdVLljfkZGp6ahW//gUORN27zrTqMmjltaivDRPh+d6lgmqQf+x9JW?=
 =?us-ascii?Q?UXMXd+LA/n3vUn3mtmxPjxrpps1mTfpyUStaK8AzdsAY2HCmAlOHXYx2OwzM?=
 =?us-ascii?Q?vK7iCRKDfWud9suS/A850OCLBCwTAmcg05YGr9TIaxFSp5IcOsxZTewEXnRH?=
 =?us-ascii?Q?rzyxNaAWF0yW7rhwPZivIR0E8TGVd2hpRFvfzczfRLNiFDYNKVX4Lmb80yxa?=
 =?us-ascii?Q?cDqOL1AqJAFerf5xzOJeBVOoE/qpaw9b8+tl5j2fIhsOL/R/zh6QnvSveut5?=
 =?us-ascii?Q?JKQLFmA01511hzVJtG/qJ1lWs+5IE2LXvEyqIF3CgCueyyKxK4UqVuTPR5Uf?=
 =?us-ascii?Q?KKJvvuorq7Hei8x+PLuW12YNex/n53ZZkfAKgtDF+NA1CUNS7pLarJgt3qKW?=
 =?us-ascii?Q?BACEoer4GoGnWBqieUA3+ixXYyfeA8ya461OHlXsbuT6rKJPlzu2tlDFnkXH?=
 =?us-ascii?Q?ETkoWMH8ta80GGFV/Y3WfIxeUYltgzgPozD/tHj58uT9cY47Lkj1426D64xC?=
 =?us-ascii?Q?dfMe0TPjaj+khKSUyI51cjg0XekP5jRG/uvdK9bKnwetfzSaJFYcM3z0hb29?=
 =?us-ascii?Q?frVHWm15/WGUQAr3yFy0c0w=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0fb9d22-e273-4cad-29e1-08d9fea5cea3
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2022 12:43:54.2463
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aVWIZZ+mrHjPOZFcsOforu5NEEYDdSgIJeS4td71skV+DfNDSOI638kRgr1jl/2/K7j3WRyLwxKAicdbH/pLIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2821
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10276 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203050070
X-Proofpoint-GUID: 3CLFMFDTh3j6JS268vSwR63eqkjEbLVY
X-Proofpoint-ORIG-GUID: 3CLFMFDTh3j6JS268vSwR63eqkjEbLVY
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 04 Mar 2022 at 07:27, Dave Chinner wrote:
> On Tue, Mar 01, 2022 at 04:09:28PM +0530, Chandan Babu R wrote:
>> XFS_SB_FEAT_INCOMPAT_NREXT64 incompat feature bit will be set on filesystems
>> which support large per-inode extent counters. This commit defines the new
>> incompat feature bit and the corresponding per-fs feature bit (along with
>> inline functions to work on it).
>> 
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  fs/xfs/libxfs/xfs_format.h | 1 +
>>  fs/xfs/libxfs/xfs_sb.c     | 3 +++
>>  fs/xfs/xfs_mount.h         | 2 ++
>>  3 files changed, 6 insertions(+)
>> 
>> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
>> index e5654b578ec0..7972cbc22608 100644
>> --- a/fs/xfs/libxfs/xfs_format.h
>> +++ b/fs/xfs/libxfs/xfs_format.h
>> @@ -372,6 +372,7 @@ xfs_sb_has_ro_compat_feature(
>>  #define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
>>  #define XFS_SB_FEAT_INCOMPAT_BIGTIME	(1 << 3)	/* large timestamps */
>>  #define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4)	/* needs xfs_repair */
>> +#define XFS_SB_FEAT_INCOMPAT_NREXT64	(1 << 5)	/* 64-bit data fork extent counter */
>>  #define XFS_SB_FEAT_INCOMPAT_ALL \
>>  		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
>>  		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
>> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
>> index f4e84aa1d50a..bd632389ae92 100644
>> --- a/fs/xfs/libxfs/xfs_sb.c
>> +++ b/fs/xfs/libxfs/xfs_sb.c
>> @@ -124,6 +124,9 @@ xfs_sb_version_to_features(
>>  		features |= XFS_FEAT_BIGTIME;
>>  	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR)
>>  		features |= XFS_FEAT_NEEDSREPAIR;
>> +	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NREXT64)
>> +		features |= XFS_FEAT_NREXT64;
>> +
>>  	return features;
>>  }
>>  
>> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
>> index 00720a02e761..10941481f7e6 100644
>> --- a/fs/xfs/xfs_mount.h
>> +++ b/fs/xfs/xfs_mount.h
>> @@ -276,6 +276,7 @@ typedef struct xfs_mount {
>>  #define XFS_FEAT_INOBTCNT	(1ULL << 23)	/* inobt block counts */
>>  #define XFS_FEAT_BIGTIME	(1ULL << 24)	/* large timestamps */
>>  #define XFS_FEAT_NEEDSREPAIR	(1ULL << 25)	/* needs xfs_repair */
>> +#define XFS_FEAT_NREXT64	(1ULL << 26)	/* 64-bit inode extent counters */
>>  
>>  /* Mount features */
>>  #define XFS_FEAT_NOATTR2	(1ULL << 48)	/* disable attr2 creation */
>> @@ -338,6 +339,7 @@ __XFS_HAS_FEAT(realtime, REALTIME)
>>  __XFS_HAS_FEAT(inobtcounts, INOBTCNT)
>>  __XFS_HAS_FEAT(bigtime, BIGTIME)
>>  __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
>> +__XFS_HAS_FEAT(nrext64, NREXT64)
>
> Not a big fan of "nrext64" naming.
>
> I'd really like the feature macro to be human readable such as:
>
> __XFS_HAS_FEAT(large_extent_counts, NREXT64)
>
> So that it reads like this:
>
> 	if (xfs_has_large_extent_counts(mp)) {
> 		.....
> 	}
>
> because then the code is much easier to read and is largely self
> documenting. In this case, I don't really care about the flag names
> (they can remain NREXT64) because they are only seen deep down in
> the code.  But for (potentially complex) conditional logic, the
> clarity of human readable names makes a big difference.
>

Ok. I will rename the feature.

-- 
chandan
