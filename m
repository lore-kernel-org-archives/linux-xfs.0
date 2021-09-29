Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54D8CC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Sep 2021 18:00:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A8E461527
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Sep 2021 18:00:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245539AbhI2SBm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Sep 2021 14:01:42 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:25486 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244878AbhI2SBl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Sep 2021 14:01:41 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18THQ1QH007974;
        Wed, 29 Sep 2021 17:59:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=2UhY1KPKznf+FAcW0/S/vYShuDA6nACXlBNE2wFs1EA=;
 b=RIaKBoQre4SmXYTKug5AlWK8kOT5uPpfZmUdam4rnBbp44CjEXr9WenrWLnD81Vjarx6
 0Ha3uMjMPMkwOTL0I6oqe8aj71KDYKp2XdGUm7td3U6J9iXXZRY+2DSPAlaTNv0xT1Oh
 4ni7T4r22HtfRwgie0XLbc40eG5TyYYeUzr+r1tuEGR/r9phZQhmLOxluN6VAuBFmT9I
 qdJ7TC6tKmKpfBlee7WoS9u1LxY8NO5PSYWXdYyAd/ASjQV6+fku1fqf8iKOfTbg+MVp
 I4EOghH32gzbDDZIaCF1DjElIrC94iYdIEVfOyLiWmKY79uQ9yE/SZ20gZ2Mb2QF+A0G Wg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bcdcw02nh-160
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 17:59:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18TGpf54195314;
        Wed, 29 Sep 2021 17:04:23 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by aserp3020.oracle.com with ESMTP id 3bceu5s7rr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 17:04:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jnnBQyKWg0haLO5G0JOipcAcdL2hExpbJFoY41wAovWD67yBiL+OJN3F50W3pUQUwH8xj4wwjUsp0eqVbLDxJNpz68aLOzN8GZJoMFebVsc5lyYHJ1Us0x9fjxtqK5gIh++Qr2SIZuCziwP45cQ4sWRN8eUuDaBkRkMNYERI7aTOYjB8hYkWb25V0NLLBFD02IiS7utLTAWYGil6SpVemTigptkRIQmw+JfFYmOTl8oPTWNdTVJRIkz/40IsSa6YiOByhWwRMYHZ0G/CytgYpynszZ5VuukKxTVHysUhJuLb9qfepMAm7e8OV06HI56CAyBcLpExqf83l8yTUsftmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=2UhY1KPKznf+FAcW0/S/vYShuDA6nACXlBNE2wFs1EA=;
 b=Kitoz0CjM9O3JCVOLTSfoaZD+I3wvnkytfJmen9yAazg/bmeFagDqx4ePgFkcrCs/oRLbPEO0kiZJOH/XWRG/S1T/vkcxjZDyw0gxo6q5DkskrFo/VOiXwDuZc61WQXHMSW5s7jW52FfZzvESZJbNvftVKVGGO+viLNr6CI6LL5NQDOcaVFtB6JREJTGi/ctzX7QaFNSMzTqYu/BMtmbmsGGLN/BmDeo/kbRaD/oPYjUcssbqyaFzINH0VGBIsVwCScDoSCym1ERRM3u6enQpQHZZCrWvxEvDI+ZbPHkXZwf5u8qEwazW8QCAntTaSALaAmpFgOzI2QSFcgy+3YtQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2UhY1KPKznf+FAcW0/S/vYShuDA6nACXlBNE2wFs1EA=;
 b=R+DeU1Qo7rBTxEnHQqftT2lpIfUfr9OOKkHuyiJzTlMrC5deLwrl6WqxQoquV6kCkecw2tqJIMiXFSa/CH7xb7hyC7qhA1ezKAdczmSecKad/MOVN6/LrnaGteG5hgrBVJBdiqU3vIBMzeVIIK1nQ5EtbGGvQHiG4bG5IPO5UQ8=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by BY5PR10MB4244.namprd10.prod.outlook.com (2603:10b6:a03:207::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Wed, 29 Sep
 2021 17:04:21 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::c50a:e8fe:496f:8481]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::c50a:e8fe:496f:8481%9]) with mapi id 15.20.4544.022; Wed, 29 Sep 2021
 17:04:21 +0000
References: <20210916100647.176018-1-chandan.babu@oracle.com>
 <20210916100647.176018-9-chandan.babu@oracle.com>
 <20210928004707.GO1756565@dread.disaster.area>
 <874ka51168.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20210928230822.GK2361455@dread.disaster.area>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V3 08/12] xfs: Promote xfs_extnum_t and xfs_aextnum_t to
 64 and 32-bits respectively
In-reply-to: <20210928230822.GK2361455@dread.disaster.area>
Message-ID: <87a6jvs48l.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Wed, 29 Sep 2021 22:34:11 +0530
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0038.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:22::24) To SJ0PR10MB4589.namprd10.prod.outlook.com
 (2603:10b6:a03:2d0::16)
MIME-Version: 1.0
Received: from nandi (122.167.3.90) by MA1PR0101CA0038.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:22::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Wed, 29 Sep 2021 17:04:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 618e3623-055c-46b4-06a7-08d9836b2e7f
X-MS-TrafficTypeDiagnostic: BY5PR10MB4244:
X-Microsoft-Antispam-PRVS: <BY5PR10MB4244394C7A7B5241928C82D4F6A99@BY5PR10MB4244.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mF8BytEEB75YWX/qaCaibs6NQ1nb4f0/Pyzke/Cn04cdCorRh2H2ssscXb7ZAFnqf7inEFcwVZzJvBTba9avup561hqS622s0Nym/sa7e8V78r1k/bSpHo83EyD9n9kyvrcQPO2Rv4k2KI6JjuZkZ18EkLatLSfGsg1r340pMa4C/9evQ1SDglOd//kn8mUfwR3n4esiF+CjS4Gg23UA8cD+nKWGnlgN9dYMpZvpU/EesU1A50Psue6TU3kWzswsUWyIjCDVSL2JTgwT5XVSD5+GxnMrygYe77LZr6ATrbG19ljFdqxrQCgsMhRHYTox9Jmdv+FWaimdSETu8/X7SsJjIeDYn0TPj+OiJbW6nIj9MjLQ9xn7fdj1Yjy4J4OQmiNZeI72DtFRRQgas7WRusP0DdIEdgYAX2NgjXp0ged4bg0SLxQzwoddups7DZKLyguWOuuWxMOM7jpEArpAV1Pskzc3Xa/OFRVRrrTYGT+/VQ0iM1aYWWROHOpCYT74JF0m95XJlsSMd04Em4UuKRp+hmyxlsfLsJcQyaDtCgmoHUhzdH0mLQiDD8fQ9vpEb7tMZxMVzXiE+q2kYs+cAR8pFVe95MYl6AcWNdFS3dJfEvVLj/3y5Om6U5n3TFrtHD+/0CvVC0e6RQTKvb+nkna04We1PFcZM/aUqsPh/K9z8GGDLTOmSYhk3C1MpwL8kORLcQJ52CmIsAFSWxgqgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(8676002)(508600001)(66946007)(86362001)(4326008)(53546011)(8936002)(316002)(6666004)(52116002)(6496006)(956004)(66476007)(66556008)(6916009)(83380400001)(5660300002)(33716001)(38350700002)(26005)(38100700002)(186003)(9686003)(6486002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ovtc3cQB/NaWC9iS3QzGDRz2Yx4w9oMgMh1eQOwBvzzXeSqF1iyjUP/prq80?=
 =?us-ascii?Q?7XmihUdPAWxKea11gqVUxp65W3RSqLYhNpuW60CbsHKVJXm+SlPsVqUMez4O?=
 =?us-ascii?Q?H/VJ9L6HJJyg7siII0sPlViRO170EeoUph5uTJ6T9/FstCB/P+dSd5nwDPBw?=
 =?us-ascii?Q?rZ/vjtGyuFqoD9RsBArCJw8tjexpviAAcw3r9exan4XwpRgkn3cXRn2W3YES?=
 =?us-ascii?Q?ajRUhCiZTLce3eZA5nJtcHVZ6bQC+hRZBTXXjLy6HW4AB9RSXeRZjcw/hTxl?=
 =?us-ascii?Q?/4sUq3NIJZG9WvX4SFL0aMZkYbk6M8tQeptr+nyXiSTmuOpmEMZLDIL9hAR0?=
 =?us-ascii?Q?OUEu2wQuYEh87m3lXUpJxmtaIPll1MlJCoQMCo8PP23qPeZnGRTd2M5sqEq7?=
 =?us-ascii?Q?3TrAwW9UhHr9WgHtAAwkVifGNENdfL9R12dQguj2xodCeQtgk7RY+4wQO7du?=
 =?us-ascii?Q?i5LF6Saxh6d2ROX1g1dVQCXruH8t8Bwms+/jY9DMowJVE4rF3Wbjee/HU6Ah?=
 =?us-ascii?Q?wD7WKPDkTyaFa5mnJQ/1/LImyGTCwc0I8X7BgZ6wE/gfS6oUhspiB+iFFob2?=
 =?us-ascii?Q?43OAHArbcohJwsqphySCjmb+n7nDBeOnGUzBBeJolPSf7y3ExnI6OS5ll5Bi?=
 =?us-ascii?Q?2UIgDCoNUfoWCFTGAmBovRA20UDZEWFivP382RaEgauwz5IeLKYEEwX0oXNi?=
 =?us-ascii?Q?h7sQW0PcjzcJI/iPzacr5hXtQ4L9TNczZ+OyaoOSwrHvbcmy5yfbSaUD5tAZ?=
 =?us-ascii?Q?VX0fSrtU6S+9FrMNziMKZiQy9M6IBJh3WnWZCGyvTD7Ioc8GQiu3CnCEvlvM?=
 =?us-ascii?Q?RVzkJoQb0YN70gle0A2glQYX6O9BLnsKEnSsmVVkvQSjwOdN9Jqlqa+cubHb?=
 =?us-ascii?Q?jMqHttNxiEbiMPnjtTVRKEP9Waf/6ii+NRY3DTHif3uBEFnFfgPm0xE6PYsJ?=
 =?us-ascii?Q?W+PriEGNVnnOwLlo5j0vPZVzSwOPD/7Sh+gI6KKP7pPR0F3KYZ15NGqTMNZX?=
 =?us-ascii?Q?Q5N25IG+tDiIYjr+SAOgTX/vTE/hwtLjaIl3mPWJ1dn29dqOgB/RKF0h9l+1?=
 =?us-ascii?Q?+AIlvJbXDTNok+SmWUnKBauGhMaYkK04XlsDQi5Xmi6rwS7kz0NC2YGgrzAe?=
 =?us-ascii?Q?HreDY50dlj3/6xMFaYCoQZYjZBTLg9xmG5ktsI8tn/klPPGFdII3BML+W1GL?=
 =?us-ascii?Q?V+p2W19psLbsjx2DambhSZZT+X2BacvPHCgMfmjgtoY4fjt2CatxZRhTa7gm?=
 =?us-ascii?Q?GUVzYmG3jOMorCqKt4Fae7cS+uYYhB3s6prGMFbtQk0QF+LKaSBo2FBYIuyC?=
 =?us-ascii?Q?mgan26Peoq6UMNNU6QES86u4?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 618e3623-055c-46b4-06a7-08d9836b2e7f
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 17:04:21.7379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vdnltW3BbqpdPMAOTh7Wcj1ILyO+SGXnO5u5OD/EZP/3XMfOaCt0x7CK/WRfbKrjasZYL21Z3zNXfTPi2MuSfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4244
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10122 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109290098
X-Proofpoint-GUID: IzOXHsFR5DSD8Xc42TTOcJpS-eL6WZVa
X-Proofpoint-ORIG-GUID: IzOXHsFR5DSD8Xc42TTOcJpS-eL6WZVa
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 29 Sep 2021 at 04:38, Dave Chinner wrote:
> On Tue, Sep 28, 2021 at 03:17:59PM +0530, Chandan Babu R wrote:
>> On 28 Sep 2021 at 06:17, Dave Chinner wrote:
>> > On Thu, Sep 16, 2021 at 03:36:43PM +0530, Chandan Babu R wrote:
>> >> A future commit will introduce a 64-bit on-disk data extent counter and a
>> >> 32-bit on-disk attr extent counter. This commit promotes xfs_extnum_t and
>> >> xfs_aextnum_t to 64 and 32-bits in order to correctly handle in-core versions
>> >> of these quantities.
>> >> 
>> >> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>> >> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> >
>> > So while I was auditing extent lengths w.r.t. the last patch f the
>> > series, I noticed that xfs_extnum_t is used in the struct
>> > xfs_log_dinode and so changing the size of these types changes the
>> > layout of this structure:
>> >
>> > /*
>> >  * Define the format of the inode core that is logged. This structure must be
>> >  * kept identical to struct xfs_dinode except for the endianness annotations.
>> >  */
>> > struct xfs_log_dinode {
>> > ....
>> >         xfs_rfsblock_t  di_nblocks;     /* # of direct & btree blocks used */
>> >         xfs_extlen_t    di_extsize;     /* basic/minimum extent size for file */
>> >         xfs_extnum_t    di_nextents;    /* number of extents in data fork */
>> >         xfs_aextnum_t   di_anextents;   /* number of extents in attribute fork*/
>> > ....
>> >
>> > Which means this:
>> >
>> >> -typedef int32_t		xfs_extnum_t;	/* # of extents in a file */
>> >> -typedef int16_t		xfs_aextnum_t;	/* # extents in an attribute fork */
>> >> +typedef uint64_t	xfs_extnum_t;	/* # of extents in a file */
>> >> +typedef uint32_t	xfs_aextnum_t;	/* # extents in an attribute fork */
>> >
>> > creates an incompatible log format change that will cause silent
>> > inode corruption during log recovery if inodes logged with this
>> > change are replayed on an older kernel without this change. It's not
>> > just the type size change that matters here - it also changes the
>> > implicit padding in this structure because xfs_extlen_t is a 32 bit
>> > object and so:
>> >
>> > Old					New
>> > 64 bit object (di_nblocks)		64 bit object (di_nblocks)
>> > 32 bit object (di_extsize)		32 bit object (di_extsize)
>> > 					32 bit pad (implicit)
>> > 32 bit object (di_nextents)		64 bit object (di_nextents)
>> > 16 bit object (di_anextents)		32 bit ojecct (di_anextents
>> > 8 bit object (di_forkoff)		8 bit object (di_forkoff)
>> > 8 bit object (di_aformat)		8 bit object (di_aformat)
>> > 					16 bit pad (implicit)
>> > 32 bit object (di_dmevmask)		32 bit object (di_dmevmask)
>> >
>> >
>> > That's quite the layout change, and that's something we must not do
>> > without a feature bit being set. hence I think we need to rev the
>> > struct xfs_log_dinode version for large extent count support, too,
>> > so that the struct xfs_log_dinode does not change size for
>> > filesystems without the large extent count feature.
>> 
>> Actually, the current patch replaces the data types xfs_extnum_t and
>> xfs_aextnum_t inside "struct xfs_log_dinode" with the basic integral types
>> uint32_t and uint16_t respectively. The patch "xfs: Extend per-inode extent
>> counter widths" which arrives later in the series adds the new field
>> di_nextents64 to "struct xfs_log_dinode" and uint64_t is used as its data
>> type.

Sorry, The previous patch is the one which changes the data type of the extent
counter fields in "struct xfs_log_dinode".

>
> Arggh.
>
> Perhaps now you might see why I really don't like naming things by
> size and having the contents of those fields based on context? It
> is so easy to miss things like when the wrong variable or type is
> used for a given context because the code itself gives you no hint
> as to what the correct usage it.

I agree. I will go with the "Increment inode version" suggestion.

>
> I suspect part of the problem I'm had here is that the change of
> the type in the xfs_log_dinode is done in a -variable rename- patch
> that names variables by size, not in the patch that -actually
> changes the variable size-.
>
> IOWs, the type change in the xfs_log_dinode should
> either be in this patch where the log_dinode structure shape would
> change, or in it's own standalone patch with a description that says
> "we need to avoid changing the on-disk structure shape".

I think I will put the data type change in a separate patch to make it much
easier to spot. Thanks for suggesting that.

>
> Making sure that the on-disk format changes (or things that avoid
> them!) are clear and explicit in a patchset is critical as these are
> things we really need to get right.
>
> I missed the per-inode extent size flag for a similar reason - it
> was buried in a larger patch that made lots of different
> modifications to support the on-disk extent count format change, so
> it wasn't clearly defined/called out as a separate on-disk format
> change necessary for correct functioning.
>

You are right. I will pull out critical parts of the "xfs: Extend per-inode
extent counter widths" into as many separate patches as possible.

>> So in a scenario where we have a filesystem which does not have support for
>> 64-bit extent counters and a kernel which does not support 64-bit extent
>> counters is replaying a log created by a kernel supporting 64-bit extent
>> counters, the contents of the 16-bit and 32-bit extent counter fields should
>> be replayed correctly into xfs_inode's attr and data fork extent counters
>> respectively. The contents of the 64-bit extent counter (whose value will be
>> zero) in the logged inode will be replayed back into di_pad2[] field of the
>> inode.
>
> I think that's correct, because the superblock bit will prevent
> mount on old kernels that don't support the 64 bit extent counter
> and so the zeroes in di_pad2 won't get overwritten incorrectly.
>
> Cheers,
>
> Dave.

-- 
chandan
