Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C6FAC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Sep 2021 18:39:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 386646141B
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Sep 2021 18:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346083AbhI2SlE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Sep 2021 14:41:04 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:44442 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346132AbhI2SlE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Sep 2021 14:41:04 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18TIWi4p001990;
        Wed, 29 Sep 2021 18:39:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=bFBOjjI3Hk/DK9GXc7obuh0nA3YelWJb7fIcC0lmJEM=;
 b=riUWHzYYXLT9PugIiX1d65gc5yBmN34Imcg4wIeBGyf+H7v9p332o3+G+hz7UEK+OPPm
 So0O+pHuwuPuwHiRB3LKG0ZNh7Bz3KjLdTfPbpYKl03lwVwZToxkIFkjcHABrjhAoHtT
 i/sS8QrdVkj2j1YR33QLx9+sHW/RIGnTrI0MZFctv/2Dw4dDCnugsR2Joz/FUg1yBwaU
 3YFCrPKL8hP2WrFynxWQVcTEro26nSggdMf4uvuvlK6vUqcrncyqJVbYVa5hwlH/+OCX
 tM2Ylt5OKis1pTmboQcBdoFsVrUzqVOg0RBnnc4RQ2aVhREczfNDdYuK3+VXJYdoUwTj Ug== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bccc8gy0e-34
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 18:39:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18TGpglX195345;
        Wed, 29 Sep 2021 17:05:04 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by aserp3020.oracle.com with ESMTP id 3bceu5s8ym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 17:05:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aklR5Z273Yon5oANc6ba03YrljR3m/Fq0ABaTCri9ta9X30GRyQvFxTRJWMBfla6P5SOLMfu8B+S0g1fwskU9HJ0VmIUg808XQA63vSqnq4SFQx2NhkKAT+Uv2y4GSmczL1ZNuDj/0jCRFfBpfDdijqTVuDfNdRbSWZswd2q/FK3zELWvg7Za+H5jTC7RJ8v1Nl+Yn5dH3KeXnHFNZjERjYe5McewkpLpkRuZ7uOlqWu8zPdesQwSkZnlzzk5pBYH4p8CRo1A2qi0v8PPmlRZzEKnZpeGWdVijv02osHGDsg46Xz5Ismptn7NuGo47P+HCIAICr2ia6Phv1FkGjlJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=bFBOjjI3Hk/DK9GXc7obuh0nA3YelWJb7fIcC0lmJEM=;
 b=NPwlfCP+XhF+E5cTD8DMI7Lsycu9wwvduhniwh8uBhTT+4uQKuIenbgOlAkOQ6UsYjrbQn4rLuG/lo/2qIL18UtSJiczwF7idjJDLZBWLQ9h0H7T2TMpoTyLoVtbpNrxTjJzM6UqVXBsa9YhK1wvj1iPM4ruBB2iXc9ajETsFf+6qHLvQJSDUTQNzdFlJbO4P3F1V2CDhS3DdAqmfY71xpgiPCpqzE/wxUNUup9TM9hGFgt3rgVaeHIAE1ORfzVKkH94ZCGeR0GIziGwXxr7VOQcGq2Q1PAmMoimKF9Mj8dqMRlSTRH8UQ9MJbBYzZLe4cqyGIdJwIvEc+GFPiLscQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bFBOjjI3Hk/DK9GXc7obuh0nA3YelWJb7fIcC0lmJEM=;
 b=Lys6imYOhGQd+GXKzbouLd0khfLiSz6ssQQdn8d8JBQTdLuoXcYZfdDTVaev+eJeTAscuGpLuC5tVwdwyFrDWxovcfYVIQksdD1DVQZCKSNpw8YKwWo1ZAnGSOFcJ7nKpKfCrrdX2aKXxBPDIjE7tlT+knjMBf0EPbuGFfELv8Y=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by BYAPR10MB2806.namprd10.prod.outlook.com (2603:10b6:a03:88::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.18; Wed, 29 Sep
 2021 17:05:03 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::c50a:e8fe:496f:8481]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::c50a:e8fe:496f:8481%9]) with mapi id 15.20.4544.022; Wed, 29 Sep 2021
 17:05:03 +0000
References: <20210916100647.176018-1-chandan.babu@oracle.com>
 <20210916100647.176018-10-chandan.babu@oracle.com>
 <20210927230637.GL1756565@dread.disaster.area>
 <87zgrxyqqe.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20210928233910.GL2361455@dread.disaster.area>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V3 09/12] xfs: Enable bulkstat ioctl to support 64-bit
 per-inode extent counters
In-reply-to: <20210928233910.GL2361455@dread.disaster.area>
Message-ID: <877dezs47d.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Wed, 29 Sep 2021 22:34:55 +0530
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0014.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:c::24) To SJ0PR10MB4589.namprd10.prod.outlook.com
 (2603:10b6:a03:2d0::16)
MIME-Version: 1.0
Received: from nandi (122.167.3.90) by MAXPR0101CA0014.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:c::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Wed, 29 Sep 2021 17:05:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca083347-8323-46a5-9951-08d9836b4705
X-MS-TrafficTypeDiagnostic: BYAPR10MB2806:
X-Microsoft-Antispam-PRVS: <BYAPR10MB28063ABE4B5BA327A40F23B5F6A99@BYAPR10MB2806.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KsdnXRVhIo5NdovKePb+vaFbCv3oQ0J7oJZ7t/47R2u4l+niYhWC9REQ78bwP+a6NojfTq84Y4id4LlFCehDrOqV6Cz0QCFb3qTwwMdKlgPYcPBbj4ihbeyutVwgXye91vcdXI3jK9Fx3EoMWuY6rbtSm2Viy4uDxJAV70nwyPlINgjUL27kjw3OhcGAvOiQnacksYaV96I5Z6DIBGEdWX4AK1oGcMBew31ZoebsOAFNWMER47hCQF+8YozFc3i5q0N4UD03t2vCHT7arMJ+sVrwaIpaZiivZCixctcuMyHERJM+Bx7I5TXElPy1/J13FMEfSUOaMWNSAenFu5h+pw7XWn0nSx3Wwp+WncQx0eDviSiSGgMMC/qD2hlqxUhVoNQBBHVXaMBEASYDajDQWO1/U+mlbGd72BbajniWJtu/X7txqpMHAJa32I+KeFqpnS6dvFiHURm+sGdpWbrnfyJRHxs2yOe/KX9MqSmDIVl4GfrDFVjESkEQ7tMDuNctstHJIpgO6d6x2SLxBvSYUbdtIC9sNpDt5mGGGyXiG++VL7KahzR4+lcJTIKg2OeVXKwlkxR7kVYQ1SL7Fjv5Ro8SOnU47N0GIq4nn35coAwrLh2BTA4p/LDf86HGi9uLwNkUheq6kOHWbfZvW4X/b6vvkdE3DxWkK7nr9+mco62bPZ/DVmNAhULhok5DmWdSnV9FCNmCcX0u4IycEdsATg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(66476007)(4326008)(6666004)(86362001)(508600001)(8676002)(66556008)(6486002)(956004)(8936002)(66946007)(6916009)(33716001)(6496006)(52116002)(186003)(316002)(83380400001)(26005)(38100700002)(2906002)(38350700002)(5660300002)(53546011)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?s2uNmNeRUxuZ6wztx+3v/c6IDvPZZ81u2F5JAICqdL5bcQEggJJyotstF/In?=
 =?us-ascii?Q?YHi6DqVZZGouyd5f0OA3kP3sc43mrceBKN3CqC7ZVIBT+vNiJTOLQZnGiD4v?=
 =?us-ascii?Q?shOYXonuypvQSukVG8TgloLlKTdI5LBLPbJzNlbm8WV2nJTq0PJHtZ+41WgE?=
 =?us-ascii?Q?jVQ0aTX5AUXx3i4h1lGb66W3JoHiphZDaC578x8bqSwY6AkMjj0LIVcQNqk/?=
 =?us-ascii?Q?VzUJgKPfqHUUDF6FpgHtNTCkuipKoBfw+xvOpwXbAhKeytulWJrZY6TlLwCW?=
 =?us-ascii?Q?DY+IpzAdG4V9Jpum+TZv3eHM89o8BYX+30Kt0KblA06QZYLaEiD11KmMTukG?=
 =?us-ascii?Q?9h6nt7hQ9Z1lf4ecrw/WlYjjMU4RtFXgxlie+K5AOKAyXSpgMKHrXDRMzgj5?=
 =?us-ascii?Q?e7yM4kz6kqCvLbtDdHQLXhw1xkI9tHqY7pDxh6cI/YqBn2ep7jkqoyUxLeFF?=
 =?us-ascii?Q?58/XTAddsGwYhOdked4jqk3iHo5qwRpRyHK+2gYlmzIwtt02Hoe9ocLslX6y?=
 =?us-ascii?Q?6A5I6yQLjmRl3vVolXJtcshE8JEvwUCCg8oxONZhL0T/dqYrDcJBd8MN+gE4?=
 =?us-ascii?Q?qXFBaEyWurRp62ckz3dcdX9Ut446P/RXjmVo1V1Xwvnaus7A59Ju35tdJln0?=
 =?us-ascii?Q?4Sd0vYEynihBD0AJbByNY+0W33ilo/ZVuVTcgWw1IMQxN3KHcj04Y3Krfz3K?=
 =?us-ascii?Q?TpD6XWkeFmEXRcHIuKvCr3n/H1O+9+NGB7YfiU+PH89X/cNm1Qk2xf1HX3/0?=
 =?us-ascii?Q?l9n5gfwsAfWmP7DNlYddBo/cD5FjDKfu/G9cKZHtkMXKBrGA567HdZUZW6bB?=
 =?us-ascii?Q?ReGn7obND9ByBfyOXdFnV8gs3ofibbM6PxscTNMQAwML7vBiJzzBZDoO8D+m?=
 =?us-ascii?Q?TZX119biZWf5ybUZzdJUKfRlJBeVmK32yD8dfK9wMZ0Oqi+gh8V36xiZba68?=
 =?us-ascii?Q?dEAuAxTemRZXne6SJqv2x7cCCyAVunmCu5T65il2cQMMPyu84y1FEdMmYnZ+?=
 =?us-ascii?Q?HV8/KGQ8UuvFkeAdQ5xglsyXD0aO8o+pkJV5sJPcSWuRhwtv830B2w/L8IaZ?=
 =?us-ascii?Q?jQK8oKdrjg5pVx7M1BY4Ei5cSFWZPhOX2QuRHkx4EDpJM/N3kVCZqbcVD43/?=
 =?us-ascii?Q?0YzumFX8Zkk8F67YyESbfpDNBPk57VXJRlaoyrXdX8Ju5yxcz+A+iTDclit+?=
 =?us-ascii?Q?IchnE5LF6wn0rKO3MN8RUxYqez7/SjCHjkmRa2oloz3dp1aFAwXAJlNvs881?=
 =?us-ascii?Q?i9RQ9mqmFF1eWsK1A454MQIYVTB0FN076HPHf0pg5LI4rNvYW85RGJHYJ9ps?=
 =?us-ascii?Q?Bp/CZhgLjXb5nILR+xzWnMR+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca083347-8323-46a5-9951-08d9836b4705
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 17:05:02.8901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TxF55vo7/hYTmBoZzldEMCzLZkaYa2EP9Xw/V/gfdwbQorWA3lbWoR1w3MEfK8K8+HNaADyX5mSZw/SIYYr2gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2806
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10122 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109290098
X-Proofpoint-GUID: SbHK2W9MsTNVkGTQbETTjwdV0mtBBWxT
X-Proofpoint-ORIG-GUID: SbHK2W9MsTNVkGTQbETTjwdV0mtBBWxT
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 29 Sep 2021 at 05:09, Dave Chinner wrote:
> On Tue, Sep 28, 2021 at 03:19:29PM +0530, Chandan Babu R wrote:
>> On 28 Sep 2021 at 04:36, Dave Chinner wrote:
>> > On Thu, Sep 16, 2021 at 03:36:44PM +0530, Chandan Babu R wrote:
>> >> @@ -492,9 +494,16 @@ struct xfs_bulk_ireq {
>> >>   */
>> >>  #define XFS_BULK_IREQ_METADIR	(1 << 2)
>> >>  
>> >> -#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO | \
>> >> +#define XFS_BULK_IREQ_BULKSTAT	(1 << 3)
>> >> +
>> >> +#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO |	 \
>> >>  				 XFS_BULK_IREQ_SPECIAL | \
>> >> -				 XFS_BULK_IREQ_METADIR)
>> >> +				 XFS_BULK_IREQ_METADIR | \
>> >> +				 XFS_BULK_IREQ_BULKSTAT)
>> >
>> > What's this XFS_BULK_IREQ_METADIR thing? I haven't noticed that when
>> > scanning any recent proposed patch series....
>> >
>> 
>> XFS_BULK_IREQ_METADIR is from Darrick's tree. His "Kill XFS_BTREE_MAXLEVELS"
>> patch series is based on his other patchsets. His recent "xfs: support dynamic
>> btree cursor height" patch series rebases only the required patchset on top of
>> v5.15-rc1 kernel eliminating the others.
>
> OK, so how much testing has this had on just a straight v5.15-rcX
> kernel?
>

I haven't yet tested this patchset on v5.15-rcX yet. I will have to rebase my
patchset on top of Darrick's patchset and also would require xfsprogs' version
of "xfs: support dynamic btree cursor height".

>> >> @@ -134,7 +136,26 @@ xfs_bulkstat_one_int(
>> >>  
>> >>  	buf->bs_xflags = xfs_ip2xflags(ip);
>> >>  	buf->bs_extsize_blks = ip->i_extsize;
>> >> -	buf->bs_extents = xfs_ifork_nextents(&ip->i_df);
>> >> +
>> >> +	nextents = xfs_ifork_nextents(&ip->i_df);
>> >> +	if (!(bc->breq->flags & XFS_IBULK_NREXT64)) {
>> >> +		xfs_extnum_t max_nextents = XFS_IFORK_EXTCNT_MAXS32;
>> >> +
>> >> +		if (unlikely(XFS_TEST_ERROR(false, mp,
>> >> +				XFS_ERRTAG_REDUCE_MAX_IEXTENTS)))
>> >> +			max_nextents = 10;
>> >> +
>> >> +		if (nextents > max_nextents) {
>> >> +			xfs_iunlock(ip, XFS_ILOCK_SHARED);
>> >> +			xfs_irele(ip);
>> >> +			error = -EINVAL;
>> >> +			goto out_advance;
>> >> +		}
>> >
>> > So we return an EINVAL error if any extent overflows the 32 bit
>> > counter? Why isn't this -EOVERFLOW?
>> >
>> 
>> Returning -EINVAL causes xfs_bulkstat_iwalk() to skip inodes whose extent
>> count is larger than that which can be fitted into a 32-bit field. Returning
>> -EOVERFLOW causes the bulkstat ioctl to stop reporting remaining inodes.
>
> Ok, that's a bad behaviour we need to fix because it will cause
> things like old versions of xfs_dump to miss inodes that
> have overflowing extent counts. i.e. it will cause incomplete
> backups, and the failure will likely be silent.
>
> I asked about -EOVERFLOW because that's what stat() returns when an
> inode attribute value doesn't fit in the stat_buf field (e.g. 64 bit
> inode number on 32 bit kernel), and if we are overflowing the
> bulkstat field then we really should be telling userspace that an
> overflow occurred.
>
> /me has a sudden realisation that the xfs_dump format may not
> support large extents counts and goes looking...
>
> Yeah, xfsdump doesn't support extent counts greater than 2^32. So
> that means we really do need -EOVERFLOW errors here.  i.e, if we get
> an extent count overflow with a !(bc->breq->flags &
> XFS_IBULK_NREXT64) bulkstat walk, xfs_dump needs bulkstat to fill
> out the inode with the overflow with all the fileds that aren't
> overflowed, then error out with -EOVERFLOW.
>
> Bulkstat itself should not silently skip the inode because it would
> overflow a field in the struct xfs-bstat - the decision of what to
> do with the overflow is something xfsdump needs to handle, not the
> kernel.  Hence we need to return -EOVERFLOW here so that userspace
> can decide what to do with an inode it can't handle...
>

Ok. I had never thought of xfsdump use case. I will fix this issue as
well.

I guess adding ability to xfsdump to work with 64-bit extent counters can be
done after I address all the issues pointed out with the current patchset.

Thanks a lot for reviewing this patchset.

-- 
chandan
