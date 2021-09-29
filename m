Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90010C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Sep 2021 19:12:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72FA8613D3
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Sep 2021 19:12:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344146AbhI2TOe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Sep 2021 15:14:34 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:28152 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344094AbhI2TOd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Sep 2021 15:14:33 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18TJ8HGL013615;
        Wed, 29 Sep 2021 19:12:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=1KwjHxZezOg6Dmm0PGHgnJhW6/Ys/d4ZhI9lbaQKRFQ=;
 b=RaNaonYHx/6792lJjgGCIcI/VIzVpxsKP9AU6cEOHahanmvxA6jgwLoQMHCuYnTvq0bX
 KU2Vj68uAA7psgpJmJpP59nPgnwTytBq4GYmejnxEN6eyYwiy5ZIQlLXoAlwlRcPYjXM
 tww2UyKMBNLr+7vHC95LVBQb0giLHmgM6+TjKeb5ok9XIhNnt0pqAQm2qt2eZrKQqW5q
 o1Yen2utq5XOrKkDmedMlagPo0K7seFpSrc8OrvqdSs0wGCQzCQjuus97/+Xd5ocCYbZ
 GPy1SjuP3LWBJMD0+YSfZnNFbjpfFYoqyLnKE5LAF6iOzMwJZp7kKoZiqc6tuLtCmlQE JA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bcf6cx7s5-22
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 19:12:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18TGoBvO143187;
        Wed, 29 Sep 2021 17:03:37 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by userp3020.oracle.com with ESMTP id 3bc3cej6d4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 17:03:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FNguVEkqsGqnp1R2nd4kBzqd00XXTgu0qtUhULaJrb90eQwDwp0C/zxEQMVEqvsUv1L2wEXm9bhxQ4tTJMdMe9vLQmU30DIX819go1DlTGpFAqNDxb7qWqN7hiVb8j6plUGmQhpR2FtN2ghetYd/rhBCbdRwAU/JZdIXpglKh2dsyb5o4GXLVKTVchicdD5fF0h4A/X6SMzfP+wFcY8Qk7YRNGQJnWyIktYUQBrFcADRZ45WSlkfN2rwY+lIjniZH3nWzGt2TAHQWqZDLhORJpAkcJxTT0c+/4mdK05+mauK/wwBYhcisn1ucVVf9yx9Jx5Uohtrbtgyh6lKkYZh7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=1KwjHxZezOg6Dmm0PGHgnJhW6/Ys/d4ZhI9lbaQKRFQ=;
 b=jS8C9EL1v5+md4hSn4CoxtOwj6hzfVDIlh+lFRrzwXADslSGlnxJkoHMXfsgdkuzqLdZymmeMIRZBvt/sXMHgQluuFE8gN++9U8BtYizClCf9CdeQboMoue4sm3MbVqx48hIOikIJTPajuGDOgtp7ipiPpxu2Nsh7s5E5RJdiE3zA1GjwPXIguud+BdNIKw4woIHyNLANROTrqzRjN5kAUP0xfabs13VwUQyXIncxfwHM1l1XcqmCz22jhgKv/ZZt8wCEUJGQE1N3U701b73NpEzEkq73EVuUuElWR4e6VdFdxQx38mhmjZtE9XT6I7fNlKsRRPZUVdfKtLwXB+NEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1KwjHxZezOg6Dmm0PGHgnJhW6/Ys/d4ZhI9lbaQKRFQ=;
 b=CRtFzPLxR2MKtzHuL5GVLg3OQ9mVgkRLuk6u+kvcyBu3eTD67JLhol9BLn/SULG24iNzvCdwZ9l4Zva2t3WtTdMJs4awBVukwz1YmgUN2GVRw/J4YXeQqq1nkM8RUQ7tLNiwo+W+rAF0v3v9tgo8+PQKWVH4E6BLTfUDyFtBSxE=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by BYAPR10MB2678.namprd10.prod.outlook.com (2603:10b6:a02:a9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Wed, 29 Sep
 2021 17:03:35 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::c50a:e8fe:496f:8481]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::c50a:e8fe:496f:8481%9]) with mapi id 15.20.4544.022; Wed, 29 Sep 2021
 17:03:35 +0000
References: <20210916100647.176018-1-chandan.babu@oracle.com>
 <20210916100647.176018-8-chandan.babu@oracle.com>
 <20210927234637.GM1756565@dread.disaster.area>
 <20210928040431.GP1756565@dread.disaster.area>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V3 07/12] xfs: Rename inode's extent counter fields
 based on their width
In-reply-to: <20210928040431.GP1756565@dread.disaster.area>
Message-ID: <87czors49w.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Wed, 29 Sep 2021 22:33:23 +0530
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0113.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:1::29) To SJ0PR10MB4589.namprd10.prod.outlook.com
 (2603:10b6:a03:2d0::16)
MIME-Version: 1.0
Received: from nandi (122.167.3.90) by MA1PR01CA0113.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:1::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.13 via Frontend Transport; Wed, 29 Sep 2021 17:03:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c166b7b-1e58-4c03-ba71-08d9836b12c7
X-MS-TrafficTypeDiagnostic: BYAPR10MB2678:
X-Microsoft-Antispam-PRVS: <BYAPR10MB26785DB8323B25681481CE36F6A99@BYAPR10MB2678.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B7CDSh41dj/LizFJCtNuHkuD2UVwAfAmldprMUOVfB3TmRnzAxhkAEiCesXvfUrtEmxSexTUmWCmyobgMS97vodpKHd5XP4xij/Ha0k0lN2YglFGIMLVt+sn9V1suIiymPG1apRTtNazasX3/vBD8OdehNb/EHDUJIna8H6MIXkwE4Yek6/98Nn2nM5yl/G0Si+j6C9Lxsh4ZQPwgDuYqFJBL8Z3oOaAiRjBAjU+Y+mZvOqibVvN4tN7r8U0/KXtbrXFL2/HK3XMugOBdt9UmzYWKzapXk7QQKjeWjuyCZRzutVPwmUPHc1tCCTYwzKflmY7M3EmprmZG6MD7/uE4V0U12sxNeSElC9s5nd7qWcFHi09VHOrf6bx+NooJjaX7Y7ZG5w71JgKtyEe5KK80VvWoZpaM0i9DAIIz8t3juWRloZLSsJ1AWeAhxrFubXjC8zPw9f6j9KAj2fOKzHjcE/DYVQpLUfkk096E7xC2pc0KsBk6AvrG2UD3vrn6BhijmunXamFmZr+cbqUOulnhmt2p9lHc0LxC0VDrym1T1lcqOyJnQblIzO7udIMNe3zTr7iryXStkJJid4iq9Bb/+74XqvpnGdBkJcgReoIXRD1+jJzZUtF39/VjOvVxzMwXvSzQnRKHomMJAHH0SYrDjZct6VIY4Aj1/YMR3zXkoBQU2Kr02peOeKEP5xpTlLyDlDnfdxHcLCZtTGPB/wFgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(38350700002)(38100700002)(956004)(86362001)(26005)(33716001)(186003)(6666004)(83380400001)(6486002)(66476007)(66556008)(4326008)(53546011)(52116002)(66946007)(316002)(5660300002)(9686003)(6496006)(2906002)(6916009)(508600001)(8936002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GuYkpWiuc/ZrkTUfWnKLSUdvIi386Pvz8Rv6gkpKh0UgmwpxRPwJc1fUFNFt?=
 =?us-ascii?Q?hpdRufolyA5dz85AaHynfLm8hXuiHnJoXzVU7GuMqgol0YN3QrZIWwnGylDi?=
 =?us-ascii?Q?CsI4i6e0dJ4XPlC4n0H7D+8Ls+j/8Hw6N9BCw6+46K+1hcgjqG6j8SF8F3RY?=
 =?us-ascii?Q?Fm0KSy2YqE/huySUbdibBylLvRSkRJL1agHY8zj1jujaPVtqucfTRz1O0z2o?=
 =?us-ascii?Q?IpQnfHnFpCn+64yYaOV6BXh9hzLrIWJl2qgD+x9XCvYdLPDkfhGQoeAKyhB+?=
 =?us-ascii?Q?Vjtp4zdMGkmzaDVH91klr/43HotLd/vyhhd4Uyl2pcT3h+5O+zngbut7bYxY?=
 =?us-ascii?Q?QOjupDGgNfNg3arkELVXuBA7YbvIP8iVxQvbYig7K8q70XVkgNNi0+m2Mao/?=
 =?us-ascii?Q?GIdOT7tz5Fr87Yy9FkdgiubVIxE0C+YBJ+IAJPcZ3QfWZgvli7z8REicTClU?=
 =?us-ascii?Q?SnpcB+S6SMGHBZ/MpPhD4IHj+7amFM+CKOXjOiQmaqerTnttMBL8VlDEPbZx?=
 =?us-ascii?Q?p/1nnIzlcf24fCIZLqNWYldrbpjbm/7hPmbPqudJT39vU0e89izyl5VlsCjO?=
 =?us-ascii?Q?f5kZ500sMWX8PrqAMZ+NeU+VrWvfV2tqaj7QtkR4+ICYHoIzM/Ai6pM+DU4W?=
 =?us-ascii?Q?27eGFBIoS5JseOMpxxtK0Yiwh0xwy09Uv1gLOnX37xlxWUvwCqYSywz7Fy7J?=
 =?us-ascii?Q?ppBQWuSjwv3TXF6a9eMWx1mJCAOa60o92BdzMFjkf8nSWY9kgYEbV72EG6Nn?=
 =?us-ascii?Q?mP6vrIR0alg6+ntn3S/LoEbAv23hwchZRAd8TyngQwfV+Kbui9Oaifle3o8+?=
 =?us-ascii?Q?TyykYOR6DOIAGICAfTxbP0fNqA6RkiDHd4i8Gen4/gPtmkUpDaZT3aQPwN2W?=
 =?us-ascii?Q?W5twD7/sLNZfCPJhHV5V89kUjGTRTX/brz/8gJnn3mO1PCTyH80Lo2dVwLYI?=
 =?us-ascii?Q?hyY5SpGQ5KtRHNk0nb6vPNuCVG147OIU6evkhdNKQrxiO4u1gekvmpk/Nd0i?=
 =?us-ascii?Q?sCU189CL+DX6vb4MT28PSea4GLXzpR0fNn/sWztt+Rtb0kQif6Fcs9oF+4Ub?=
 =?us-ascii?Q?JKh2w6cL5JS7aqcdp6d/tg40PIK2hUyY8kvifGf1IpPthhMmAuQB0uRCa7BX?=
 =?us-ascii?Q?q251XSwKdE0UJ2jwEf/qOp5/a3fGA7ZeSdzjLy9wAS0pj/s43EK0y6EBZvAN?=
 =?us-ascii?Q?YwnvGBI8RSLyZ9jRnKbTAR4RHoWUQuUaw7am3F0kzyspH0b1qZcYDUGp51oV?=
 =?us-ascii?Q?w8Gp8lX5J28cvShWmkAJp0Yi9GpyYzXkVQFVFW/zZsLjJJm7FDOYCFacqzz8?=
 =?us-ascii?Q?mYL/eBT3PMBpi4olb5KCyHK5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c166b7b-1e58-4c03-ba71-08d9836b12c7
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 17:03:35.1605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Q5hvIWE3nddaphu/6rmqlp993CcBr/U2DrKM20SK3Lokk831+kBjv1OD2P2V2nWpvyGR7eapLkYXxyydoOfCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2678
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10122 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109290098
X-Proofpoint-GUID: 4V-bnEASapwbVM3_4A2AiObmP7-gePql
X-Proofpoint-ORIG-GUID: 4V-bnEASapwbVM3_4A2AiObmP7-gePql
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 28 Sep 2021 at 09:34, Dave Chinner wrote:
> On Tue, Sep 28, 2021 at 09:46:37AM +1000, Dave Chinner wrote:
>> On Thu, Sep 16, 2021 at 03:36:42PM +0530, Chandan Babu R wrote:
>> > This commit renames extent counter fields in "struct xfs_dinode" and "struct
>> > xfs_log_dinode" based on the width of the fields. As of this commit, the
>> > 32-bit field will be used to count data fork extents and the 16-bit field will
>> > be used to count attr fork extents.
>> > 
>> > This change is done to enable a future commit to introduce a new 64-bit extent
>> > counter field.
>> > 
>> > Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> > ---
>> >  fs/xfs/libxfs/xfs_format.h      |  8 ++++----
>> >  fs/xfs/libxfs/xfs_inode_buf.c   |  4 ++--
>> >  fs/xfs/libxfs/xfs_log_format.h  |  4 ++--
>> >  fs/xfs/scrub/inode_repair.c     |  4 ++--
>> >  fs/xfs/scrub/trace.h            | 14 +++++++-------
>> >  fs/xfs/xfs_inode_item.c         |  4 ++--
>> >  fs/xfs/xfs_inode_item_recover.c |  8 ++++----
>> >  7 files changed, 23 insertions(+), 23 deletions(-)
>> > 
>> > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
>> > index dba868f2c3e3..87c927d912f6 100644
>> > --- a/fs/xfs/libxfs/xfs_format.h
>> > +++ b/fs/xfs/libxfs/xfs_format.h
>> > @@ -802,8 +802,8 @@ typedef struct xfs_dinode {
>> >  	__be64		di_size;	/* number of bytes in file */
>> >  	__be64		di_nblocks;	/* # of direct & btree blocks used */
>> >  	__be32		di_extsize;	/* basic/minimum extent size for file */
>> > -	__be32		di_nextents;	/* number of extents in data fork */
>> > -	__be16		di_anextents;	/* number of extents in attribute fork*/
>> > +	__be32		di_nextents32;	/* number of extents in data fork */
>> > +	__be16		di_nextents16;	/* number of extents in attribute fork*/
>> 
>> 
>> Hmmm. Having the same field in the inode hold the extent count
>> for different inode forks based on a bit in the superblock means the
>> on-disk inode format is not self describing. i.e. we can't decode
>> the on-disk contents of an inode correctly without knowing whether a
>> specific feature bit is set in the superblock or not.
>
> Hmmmm - I just realised that there is an inode flag that indicates
> the format is different. It's jsut that most of the code doing
> conditional behaviour is using the superblock flag, not the inode
> flag as the conditional.
>
> So it is self describing, but I still don't like the way the same
> field is used for the different forks. It just feels like we are
> placing a landmine that we are going to forget about and step
> on in the future....
>

Sorry, I missed this response from you.

I agree with your suggestion. I will use the inode version number to help in
deciding which extent counter fields are valid for a specific inode.

-- 
chandan
