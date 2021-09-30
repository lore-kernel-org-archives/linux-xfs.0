Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0AC9C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Sep 2021 07:30:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 887A861439
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Sep 2021 07:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348759AbhI3HcA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Sep 2021 03:32:00 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:39468 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348742AbhI3Hb7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Sep 2021 03:31:59 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18U6YJHu031091;
        Thu, 30 Sep 2021 07:30:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=JUJrbFkF6cAH+GRpGIotTbbrFwJ+Y3c+QqHGS8Icokg=;
 b=semQhwh29P3dGJMWp0/SYH9smh83rFdTU3jKKnsC3ngM2JRtdlrsQdPVAvte1HEsvjBK
 hh1n9UVyee+oozqLTsjXyOnLrma3X4ut1KbuoSSySfXdA6xnkxgq6kIV3WNjm85IPhh6
 WV4CKVxGEsmJ3m3Fc5V1diAdfZpz+kX/DScCRO5ilYL06qyR7I9rwqF+l9w4NVumguKg
 Y0Z+3GiLUTkecTcjY7b7ygtRfQG5QUgFVPMthIBC/WSLUcdN8I8HxCp3xTFM81yzCnEy
 u/hZ6jlsGKCtnMgW1g+ha9/dR8vA4f774PyENOOqVRMpJSXB4oCJ+d+jhmKPts8A5QFM WQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bcdcw4hv6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 07:30:15 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18U7ATA7141139;
        Thu, 30 Sep 2021 07:30:14 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by userp3030.oracle.com with ESMTP id 3bc3bm5d31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 07:30:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KnfxHQ7rhgWz9j8p4not86MF/OzJmRLYZTc6gMJMZnMDu1Pl2ojwV6iHhsUZRHcGALUKJ1Qwnv8W0Mn/aiDEtZIBm7ef8EkH/WrE14b9M0Q1l3S99IWNWutu8iKNh0xf2GHH+tVV8efTDYnFmPXPyYtIZPSwn/WarZP/lq3j2y7iwyGzD7AkGAwsbcZuY/NIHQM5SIgTWRHZcJRhsPcpZ3VQnfByGaaW2ewhNCVVxkHjXK8VCBNHBaNKdIUqr8Q/VSIgtKL5rDztaOA136P16L680T09TJXz8iS+k82yVB6bAoBFOO7ls+KCIBQQwNwtpBTaT5PSqf4KVjFI8f1iBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=JUJrbFkF6cAH+GRpGIotTbbrFwJ+Y3c+QqHGS8Icokg=;
 b=GbO8RRgSfUVGt82wXsivJAqDfgemlbK79kbaVYjCmfNzxqbWRp21MgJpolvQqNq4M7xBiiHGEdFKbRrf4o3Ff+u1WyBIcblbh5iIUIo9KDjyvkmV+ElEwUurjCh+e3duvuqgaO8M3B2Me2vS/aUBbeF9T15yUhHjykQcPwKjfNy0GnzBhiHZ687+dfeU1VevMRlhF4HeQP35ltofYqVbaKLvHYAcVUQu8bKDbO5kdjBgF2sp1Jr207/5Vb7H8fVkWlY5ki1IEDq0aKxJdLrB8ZkWZiXp4XnOQA2/bg+YV3/UD1OaY8TRzNLjETS49OLpCoh4+pHByBf0FJ23a6JRPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JUJrbFkF6cAH+GRpGIotTbbrFwJ+Y3c+QqHGS8Icokg=;
 b=BgfPOAFpsGlgryc+8RhibdRrj1t+BJDUHs6Z/jcmmJveCSiOwseVWPfD+X8IWEvXfo5ggP+jSEpZXi6LFEgv+CbrnezGO21PaPCvMFp6kWRzoA9p1FLJrGdrV8ZSSgIWUhxhHsjcusWd7r+Csigaz75Y/BG1HyRxDXCh9LJPHuE=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2831.namprd10.prod.outlook.com (2603:10b6:805:cd::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Thu, 30 Sep
 2021 07:30:11 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%7]) with mapi id 15.20.4566.015; Thu, 30 Sep 2021
 07:30:11 +0000
References: <20210916100647.176018-1-chandan.babu@oracle.com>
 <20210916100647.176018-8-chandan.babu@oracle.com>
 <20210927234637.GM1756565@dread.disaster.area>
 <20210928040431.GP1756565@dread.disaster.area>
 <87czors49w.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20210930004015.GM2361455@dread.disaster.area>
 <20210930043117.GO2361455@dread.disaster.area>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V3 07/12] xfs: Rename inode's extent counter fields
 based on their width
In-reply-to: <20210930043117.GO2361455@dread.disaster.area>
Message-ID: <87zgrubjwn.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Thu, 30 Sep 2021 13:00:00 +0530
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0172.jpnprd01.prod.outlook.com
 (2603:1096:404:ba::16) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (138.3.205.13) by TYAPR01CA0172.jpnprd01.prod.outlook.com (2603:1096:404:ba::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Thu, 30 Sep 2021 07:30:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d7fc01df-8dc5-4230-2a9a-08d983e422e8
X-MS-TrafficTypeDiagnostic: SN6PR10MB2831:
X-Microsoft-Antispam-PRVS: <SN6PR10MB28315566852F03B06D59A58BF6AA9@SN6PR10MB2831.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: idfznBU2Bs/JPlHUt/FytjyqQbYp2NtQreHqpLguOiO7UgWPEcDd1fSjA6vurlIfEqERZ5IvwWxwRfq2FnZDg50lPTHkKFuFT7iteIgNRwCbcZTFMD14vgLZvft+TC2nGjbKojQa0j2ys7TtIHlIlDVs964ASauchdAWJuW7bEWMxv4ROALmR5sz/X2+QKPyUnV67zEzYaDC0DdTvS2zMczhO/iLcSsNEv+4ymT6rj3mELgyaZIeH6gCnjDskk5Qunq1iOLYjDGZpAQT7UwXBRKD8xZfoHF/3t7NiBp+cayj4zUpivMYaO5/GX33z4NCKfIwUjkR81HkB6tZgqFlPVJBwSF48DLQf4nT3W6oGda4rKjC+IEXzB+47nOUN8lx2ZhImZ9egxqQ+r7QHEuNUTpdLE4JOgOVUnfDMq14twvXx0erYN9WlQa98I+da9jLFt33qUWWagoD77VFRfOXrr/57GuMirjDu7JKhoX1u6HrebTphqxRsDG2Gl1hz5EDseihnb70jkJkHSjatKyfQeugTYkgcxOmwnBl6wjS+zTN3fd2YODQNMCtTL8+TYT7R83YkBMZBTYYsCgTozjihNTi8dHXdue35Q9gJq0wNwIY5tsjHRMckdkYLnVO/yFFl5GTUVdkZTXzlyuLBMyFdgPOu0rWt+NOgXfULNykXrQnyJo5lfWyStuB8sBC6I7ilH4RoMxq1fmz54D6XDiuVA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(86362001)(6486002)(6666004)(508600001)(316002)(8936002)(6496006)(956004)(83380400001)(6916009)(2906002)(26005)(30864003)(52116002)(9686003)(66946007)(33716001)(5660300002)(186003)(53546011)(4326008)(8676002)(38350700002)(66556008)(66476007)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mCpvViBq95vzyJzHQC/XKDvHICp/dzQvqaHw0tFQcc0/i3o432DDyRB7LHNI?=
 =?us-ascii?Q?A6wCPogVScDX4MMAMCUirPRNA8BTX5EtI7eG3bHO8v9y1wcLGJNlFGhX1fhy?=
 =?us-ascii?Q?FBxM5tSl7C4A9o9+ayssDnkCMZDO3gf7gECtfz0KXKuKZB61s6qCfBV39t4c?=
 =?us-ascii?Q?c3AmzErS6a95uawlGrLYeAM9HZt0BZqtAiXoDbaRcZJJ29sZyiItSrkomVXy?=
 =?us-ascii?Q?GP3otXsurCeNK+zQ1ujI/azUYp4kk2NwKWJouMVeLSOdR85sYb4VWIC2CSgn?=
 =?us-ascii?Q?FY9lTko1N3/mWEJOBFCJqB/gdFShBt7qNjTK7jp2qvKQVg3PYueWUQM1wkWQ?=
 =?us-ascii?Q?VmVtKFpvDXiGVieD4ib5ZSCh/tog/sEh2K6cWs9hfDm+TQGMJmnfUcmA3jQW?=
 =?us-ascii?Q?zHPDdTYDYoM/7UeRa0YgLmPe6MQxDOBA3zzR3tMFS2/+Xdtb9Q85jl5vABR/?=
 =?us-ascii?Q?qVY5LYl1hJqJ9AN/66FMDrd2UgclURguojIlMjZzLLo8ZsRwekHgm0JMC/Mz?=
 =?us-ascii?Q?MX4yGCot6VpbwZz3bv6GIqpxOPLBEl+hLS1prQXYLQrcVojU7IPrOgVrCjDQ?=
 =?us-ascii?Q?1E81PlGX9IOCAk2SsrPxQR6HQZN/OhSKYsmvXfhvdtiqfQRo6XIM0ijKtMCm?=
 =?us-ascii?Q?trpwFLk2JetvDoEdCP4aBDc4NF4Ks++HUA6TaAsO5YkjyZH/7aheiGiF6sh0?=
 =?us-ascii?Q?EPxK7RNINHj6DszAENtckhD0tiCtc3CApT1XjVc2OO4gG+5j7xeth7OW5yg6?=
 =?us-ascii?Q?5xQQ+ABWBv9GnNXbm14yikB/qohFr9HxeP5nyJTaAHs7ZnMAXWMy8kbYez4P?=
 =?us-ascii?Q?aGX+Q0HzdlZXL+z0948GcYAaun5G4R/24qDoin+7V87LzJ3NqiaRET5fJ35O?=
 =?us-ascii?Q?NsILM3u+RMpJaYkgq9CtgHxjSmHV5liMj+XNWFQTK8nCO8B7RBiYVq9ElUT7?=
 =?us-ascii?Q?PEWsDeK2XXGO+ELcduPEbRe5mcSP/m8qWQ7jfiUUnvCiizfA+Ro/chGy6DkH?=
 =?us-ascii?Q?4KoTipxn3xT6mVELtBCV69FrZmSLHmThdsUnQQjsoY8hc3Xy0aB7S0Q3XsjT?=
 =?us-ascii?Q?fA+pzuy3lyp9vt/DYT7dbnTECwZkAFHsj3z7VRJFFK9srijZDrHlx6F6x/VG?=
 =?us-ascii?Q?Su5bZvvpM39l74EXUpNxOJUR+8TqN/yMwAMp+FMVROQNmB0jjEc6UrvL6WIB?=
 =?us-ascii?Q?qA05CqBKTk8UamFItGcwYrSqZGAPXSC1eeT65R6uvYs++w9zKXqFUF7hkW1d?=
 =?us-ascii?Q?NfMOKBxgpa2PYNoKT4PMIulN3tnuovy5HwcWXf9kCAZU9r5P1u1miV5TUuXe?=
 =?us-ascii?Q?1LQ8tSG+gtSv3JS6LUaXE333?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7fc01df-8dc5-4230-2a9a-08d983e422e8
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 07:30:11.7719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aMMR3AQ60ZPxHD39JMkHHy1LQTeCv5gvDa8VU/BJBlFDGxbDKmGUF6lfTGnrrt7wT4dLywlGl+47sKvV9DZjPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2831
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10122 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109300043
X-Proofpoint-GUID: oKwv0igTOl5zqR2CLwFlgDh7oZsmutuC
X-Proofpoint-ORIG-GUID: oKwv0igTOl5zqR2CLwFlgDh7oZsmutuC
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 30 Sep 2021 at 10:01, Dave Chinner wrote:
> On Thu, Sep 30, 2021 at 10:40:15AM +1000, Dave Chinner wrote:
>> On Wed, Sep 29, 2021 at 10:33:23PM +0530, Chandan Babu R wrote:
>> > On 28 Sep 2021 at 09:34, Dave Chinner wrote:
>> > > On Tue, Sep 28, 2021 at 09:46:37AM +1000, Dave Chinner wrote:
>> > >> On Thu, Sep 16, 2021 at 03:36:42PM +0530, Chandan Babu R wrote:
>> > >> > This commit renames extent counter fields in "struct xfs_dinode" and "struct
>> > >> > xfs_log_dinode" based on the width of the fields. As of this commit, the
>> > >> > 32-bit field will be used to count data fork extents and the 16-bit field will
>> > >> > be used to count attr fork extents.
>> > >> > 
>> > >> > This change is done to enable a future commit to introduce a new 64-bit extent
>> > >> > counter field.
>> > >> > 
>> > >> > Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> > >> > ---
>> > >> >  fs/xfs/libxfs/xfs_format.h      |  8 ++++----
>> > >> >  fs/xfs/libxfs/xfs_inode_buf.c   |  4 ++--
>> > >> >  fs/xfs/libxfs/xfs_log_format.h  |  4 ++--
>> > >> >  fs/xfs/scrub/inode_repair.c     |  4 ++--
>> > >> >  fs/xfs/scrub/trace.h            | 14 +++++++-------
>> > >> >  fs/xfs/xfs_inode_item.c         |  4 ++--
>> > >> >  fs/xfs/xfs_inode_item_recover.c |  8 ++++----
>> > >> >  7 files changed, 23 insertions(+), 23 deletions(-)
>> > >> > 
>> > >> > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
>> > >> > index dba868f2c3e3..87c927d912f6 100644
>> > >> > --- a/fs/xfs/libxfs/xfs_format.h
>> > >> > +++ b/fs/xfs/libxfs/xfs_format.h
>> > >> > @@ -802,8 +802,8 @@ typedef struct xfs_dinode {
>> > >> >  	__be64		di_size;	/* number of bytes in file */
>> > >> >  	__be64		di_nblocks;	/* # of direct & btree blocks used */
>> > >> >  	__be32		di_extsize;	/* basic/minimum extent size for file */
>> > >> > -	__be32		di_nextents;	/* number of extents in data fork */
>> > >> > -	__be16		di_anextents;	/* number of extents in attribute fork*/
>> > >> > +	__be32		di_nextents32;	/* number of extents in data fork */
>> > >> > +	__be16		di_nextents16;	/* number of extents in attribute fork*/
>> > >> 
>> > >> 
>> > >> Hmmm. Having the same field in the inode hold the extent count
>> > >> for different inode forks based on a bit in the superblock means the
>> > >> on-disk inode format is not self describing. i.e. we can't decode
>> > >> the on-disk contents of an inode correctly without knowing whether a
>> > >> specific feature bit is set in the superblock or not.
>> > >
>> > > Hmmmm - I just realised that there is an inode flag that indicates
>> > > the format is different. It's jsut that most of the code doing
>> > > conditional behaviour is using the superblock flag, not the inode
>> > > flag as the conditional.
>> > >
>> > > So it is self describing, but I still don't like the way the same
>> > > field is used for the different forks. It just feels like we are
>> > > placing a landmine that we are going to forget about and step
>> > > on in the future....
>> > >
>> > 
>> > Sorry, I missed this response from you.
>> > 
>> > I agree with your suggestion. I will use the inode version number to help in
>> > deciding which extent counter fields are valid for a specific inode.
>> 
>> No, don't do something I suggested with a flawed understanding of
>> the code.
>> 
>> Just because *I* suggest something, it means you have to make that
>> change. That is reacting to *who* said something, not *what was
>> said*.
>> 
>> So, I may have reservations about the way the storage definitions
>> are being redefined, but if I had a valid, technical argument I
>> could give right now I would have said so directly. I can't put my
>> finger on why this worries me in this case but didn't for something
>> like, say, the BIGTIME feature which redefined the contents of
>> various fields in the inode.
>> 
>> IOWs, I haven't really had time to think and go back over the rest
>> of the patchset since I realised my mistake and determine if that
>> changes what I think about this, so don't go turning the patchset
>> upside just because *I suggested something*.
>
> So, looking over the patchset more, I think I understand my feeling
> a bit better. Inconsistency is a big part of it.
>
> The in-memory extent counts are held in the struct xfs_inode_fork
> and not the inode. The type is a xfs_extcnt_t - it's not a size
> dependent type. Indeed, there are actually no users of the
> xfs_aextcnt_t variable in XFS at all any more. It should be removed.
>
> What this means is that in-memory inode extent counting just doesn't
> discriminate between inode fork types. They are all 64 bit counters,
> and all the limits applied to them should be 64 bit types. Even the
> checks for overflow are abstracted away by
> xfs_iext_count_may_overflow(), so none of the extent manipulation
> code has any idea there are different types and limits in the
> on-disk format.
>
> That's good.
>
> The only place the actual type matters is when looking at the raw
> disk inode and, unfortunately, that's where it gets messy. Anything
> accessing the on-disk inode directly has to look at inode version
> number, and an inode feature flag to interpret the inode format
> correctly.  That format is then reflected in an in-memory inode
> feature flag, and then there's the superblock feature flag on top of
> that to indicate that there are NREXT64 format inodes in the
> filesystem.
>
> Then there's implied dynamic upgrades of the on-disk inode format.
> We see that being implied in xfs_inode_to_disk_iext_counters() and
> xfs_trans_log_inode() but the filesystem format can't be changed
> dynamically. i.e. we can't create new NREXT64 inodes if the
> superblock flag is not set, so there is no code in this patchset
> that I can see that provides a trigger for a dynamic upgrade to
> start. IOWs, the filesystem has to be taken offline to change the
> superblock feature bit, and the setup of the default NREXT64 inode
> flag at mount time re-inforces this.
>
> With this in mind, I started to see inconsistent use of inode
> feature flag vs superblock feature flag to determine on-disk inode
> extent count limits. e.g. look at xfs_iext_count_may_overflow() and
> xfs_iext_max_nextents(). Both of these are determining the maximum
> number of extents that are valid for an inode, and they look at the
> -superblock feature bit- to determine the limits.
>
> This only works if all inodes in the filesystem have the same
> format, which is not true if we are doing dynamic upgrades of the
> inode features. The most obvious case here is that scrub needs to
> determine the layout and limits based on the current feature bits in
> the inode, not the superblock feature bit.
>
> Then we have to look at how the upgrade is performed - by changing
> the in-memory inode flag during xfs_trans_log_inode() when the inode
> is dirtied. When we are modifying the inode for extent allocation,
> we check the extent count limits on the inode *before* we dirty the
> inode. Hence the only way an "upgrade at overflow thresholds" can
> actually work is if we don't use the inode flag for determining
> limits but instead use the sueprblock feature bit limits. But as
> I've already pointed out, that leads to other problems.
>
> When we are converting an inode format, we currently do it when the
> inode is first brought into memory and read from disk (i.e.
> xfs_inode_from_disk()). We do the full conversion at this point in
> time, such that if the inode is dirtied in memory all the correct
> behaviour for the new format occurs and the writeback is done in the
> new format.
>
> This would allow xfs_iext_count_may_overflow/xfs_iext_max_nextents
> to actually return the correct limits for the inode as it is being
> modified and not have to rely on superblock feature bits. If the
> inode is not being modified, then the in-memory format changes are
> discarded when the inode is reclaimed from memory and nothing
> changes on disk.
>
> This means that once we've read the inode in from disk and set up
> ip->i_diflags2 according to the superblock feature bit, we can use
> the in-memory inode flag -everywhere- we need to find and/or check
> limits during modifications. Yes, I know that the BIGTIME upgrade
> path does this, but that doesn't have limits that prevent
> modifications from taking place before we can log the inode and set
> the BIGTIME flag....
>

Ok. The above solution looks logically correct. I haven't been able to come up
with a scenario where the solution wouldn't work. I will implement it and see
if anything breaks.

> So, yeah, I think the biggest problem I've been having is that the
> way the inode flags, the limits and the on-disk format is juggled
> has resulted in me taking some time to understand where the problems
> lie. Cleaning up the initialisation, conversion and consistency in
> using the inode flags rather thant he superblock flag will go a long
> way to addressing my concerns
>
> ---
>
> FWIW, I also think doing something like this would help make the
> code be easier to read and confirm that it is obviously correct when
> reading it:
>
> 	__be32          di_gid;         /* owner's group id */
> 	__be32          di_nlink;       /* number of links to file */
> 	__be16          di_projid_lo;   /* lower part of owner's project id */
> 	__be16          di_projid_hi;   /* higher part owner's project id */
> 	union {
> 		__be64	di_big_dextcnt;	/* NREXT64 data extents */
> 		__u8	di_v3_pad[8];	/* !NREXT64 V3 inode zeroed space */
> 		struct {
> 			__u8	di_v2_pad[6];	/* V2 inode zeroed space */
> 			__be16	di_flushiter;	/* V2 inode incremented on flush */
> 		};
> 	};
> 	xfs_timestamp_t di_atime;       /* time last accessed */
> 	xfs_timestamp_t di_mtime;       /* time last modified */
> 	xfs_timestamp_t di_ctime;       /* time created/inode modified */
> 	__be64          di_size;        /* number of bytes in file */
> 	__be64          di_nblocks;     /* # of direct & btree blocks used */
> 	__be32          di_extsize;     /* basic/minimum extent size for file */
> 	union {
> 		struct {
> 			__be32	di_big_aextcnt; /* NREXT64 attr extents */
> 			__be16	di_nrext64_pad;	/* NREXT64 unused, zero */
> 		};
> 		struct {
> 			__be32	di_nextents;    /* !NREXT64 data extents */
> 			__be16	di_anextents;   /* !NREXT64 attr extents */
> 		}
> 	}
> 	__u8            di_forkoff;     /* attr fork offs, <<3 for 64b align */
> 	__s8            di_aformat;     /* format of attr fork's data */
> ...
>
> Then we get something like:
>
> static inline void
> xfs_inode_to_disk_iext_counters(
>        struct xfs_inode        *ip,
>        struct xfs_dinode       *to)
> {
>        if (xfs_inode_has_nrext64(ip)) {
>                to->di_big_dextent_cnt = cpu_to_be64(xfs_ifork_nextents(&ip->i_df));
>                to->di_big_anextents = cpu_to_be32(xfs_ifork_nextents(ip->i_afp));
>                to->di_nrext64_pad = 0;
>        } else {
>                to->di_nextents = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
>                to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
>        }
> }
>
> This is now obvious that we are writing to the correct fields
> in the inode for the feature bits that are set, and we don't need
> to zero the di_big_dextcnt field because that's been taken care of
> by the existing di_v2_pad/flushiter zeroing. That bit could probably
> be improved by unwinding and open coding this in xfs_inode_to_disk(),
> but I think what I'm proposing should be obvious now...
>

Yes, the explaination provided by you is very clear. I will implement these
suggestions.

-- 
chandan
