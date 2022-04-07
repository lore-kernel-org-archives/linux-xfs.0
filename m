Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 313F4C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Apr 2022 08:19:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242867AbiDGIVD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Apr 2022 04:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242902AbiDGIVB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Apr 2022 04:21:01 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1103321E52B
        for <linux-xfs@vger.kernel.org>; Thu,  7 Apr 2022 01:18:50 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2377Z0Ou024447;
        Thu, 7 Apr 2022 08:18:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=ncKyOtArtIqXHMPxUbDRRiXSVpsBsRlehd/GeTJWFF0=;
 b=rIB0kZiFsZDACrq1ZuxWaoIOIhIgdclMl4znpvLtwtOXhEBCXcNhFj/eW0nddcai2HyY
 CHPV0koWODFTqmnGd/g2hNol+/C03KKUMr7wEkGOXvtzREXjn7qMCLgpMSFNsfmGdEfK
 Kxw1LYkkTRTNwQTAcHAEt+sN87Cd9e3QYL4lo0+XMXLPapOlRhHgkgy8UbNnNVXHJo0X
 2na/vjHzx1V79QZA62l0t0bpqhvNxUDRHQW3cvXCdzbEdCeFxl1UfQs/EebGUkEoIdlY
 CHAg+iTTszXCZxQFgD4BbSthRP9CJycKC9E1VxPS6/KPNwolo4SrBccBUZRsOgBpNbeF 7A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6f1tbax8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Apr 2022 08:18:45 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2378BMtm022101;
        Thu, 7 Apr 2022 08:18:44 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97uwgw62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Apr 2022 08:18:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VfUwztxtp80lHsQwakXYkDrWpMc64ZSq9EVMJ7uN6ngKUuN8amgq1JhpRvLWCCLDwQRVVttbM3tDbdvwaeWMvwxpg0Uj3NMmxKwGPA+/jC6leth2w/mHu78QNIOn2Qbg8S3FA1JwHXfFin180OZ/kmUqj8R+wvI296DOhsprv585Ioji6/vJbwvKMk9skg63dYcoRHLnV74tXrvSRNOdriNHOvLcQKVztpkd+y8UohXQ7Ksak3igklU+fGEFY/zN0YI/BLwV9X/8BOuepr4YQfcpzvjvCOkHT3qnvLN7HIOlPjFw2Wx+I6eDV82XPxfLb5sXoynEuJdjHCio1Kvc3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ncKyOtArtIqXHMPxUbDRRiXSVpsBsRlehd/GeTJWFF0=;
 b=FnIqR7vUE3UQ4R1EPNCpEs/mKn4oDMj3E+CDejQ22nFwL5WizsbyyruQ1LRSMBrNX9RACIDJfM01jIzqTr26437i1uwGoaPuaMjUMY0IA6UWs4B6i4WqmDmb44KLRqKv1GMv4m8fQtbIT0H+Xz6iOiuvIJa/dBc5AQ174c8WHNMlMh+7SRlS4wBkFgFYMz1tpNfA8DODz/xxqKwQfiKsUTiq21cQgZ2Lp/B8LGQMiQXhw26i2EDfWdruFDHcPGx3swAFqbVOs5hDSF92rPz3wYAkPolCGuiffQamH7hvc6sZ5Ig3xIry7kGi5dM/MqqDHgWNBknLATWJ/pvoUiQaLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ncKyOtArtIqXHMPxUbDRRiXSVpsBsRlehd/GeTJWFF0=;
 b=YijoAmAyixSt230xrAc7pXxApYmhEyhPKdrQjmosjlKgIWXS3dUwlEZ1ROLN2RsrfA5pxRPEr9eE7OOdrNMzB79cw7z9uwIOF35GkuhmCGMFpKyRGrL/Lvq4AcPHShzRYc6ewzyu1hdRhBywGu0oReAMALMM2w5zkmSg7Pm49EM=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SJ0PR10MB5613.namprd10.prod.outlook.com (2603:10b6:a03:3d0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21; Thu, 7 Apr
 2022 08:18:42 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d%8]) with mapi id 15.20.5144.021; Thu, 7 Apr 2022
 08:18:42 +0000
References: <20220406061904.595597-1-chandan.babu@oracle.com>
 <20220406061904.595597-13-chandan.babu@oracle.com>
 <20220407010544.GC1544202@dread.disaster.area>
 <20220407015855.GZ27690@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V9 12/19] xfs: Introduce macros to represent new maximum
 extent counts for data/attr forks
In-reply-to: <20220407015855.GZ27690@magnolia>
Message-ID: <87lewhxq5j.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Thu, 07 Apr 2022 13:48:32 +0530
Content-Type: text/plain
X-ClientProxiedBy: SGXP274CA0021.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::33)
 To SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 014693b3-64ac-46c3-b2af-08da186f3a2f
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5613:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5613363D9BF3F6345D754BFBF6E69@SJ0PR10MB5613.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DMkOgPMC4x2t6/nTLXqfXbpSRuViSV/vKhBX1jzhkcsOtJXQp7WIiN6qcJVvfmOH4T5O3fxNqNdJ0VMbe4dJ40I4/nrSKwf4Z4LGLvA5tHg8H4EZzupX+OUUioH5a+cpn4iROhM090fR+bVq8GotvJRUvf54EdoZyAiMiyYtxBBnNgPUOQPPLfoxQOv4oe2g5pqgePvZ57+PKk8qVX5ObsnBerxAsRcw1eYTZB0qMi0gszhP/ukGv0kL/6m9vKCLzCF8sSj/ZHpT4hNKNYQ4ztQmZds2xOALwx1O8tyo1oGD/kjMiyTBR1as6RO4dCwx/p9sH5LWz5P406MWBfjdM43bDtANWaL/ZxMZS4+DyVbeef6AV8u7dQYAxYqintWEMQGWjLfO9SnLAaTfxp3cqyHZh/9HC6A7zhiA79V00AhCBW8F8SKOIoJ2r2DdJ4UQGHu9k4peh3k7BFY/0U1AJ1iDziF5aiFQKWNFWG5Ex/bnTK1Vo4lDQb08J/6MjnIOqCTCkJMMeLhOqQnrh/sCnHSINjeVBv8fRq4Ki+m4iIbdTmS7SlOSbV43Rd8I2azgRicha3Qag+b6hQEqdMY73DcPaIRUrMhdLa5GbkV0DH+tddj6dtF2dOYz8R7pfqauRkTX4ApYM8DV3kiZBMw4gUAFpd4o8JxBzcl2uAxBzFDL4AS0ojyUdDVxGMjhM4+B/1v648+iNJa8aPVLu4io/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(4326008)(86362001)(316002)(66556008)(66946007)(66476007)(6916009)(8676002)(6666004)(6506007)(9686003)(53546011)(52116002)(186003)(26005)(6512007)(38350700002)(83380400001)(6486002)(8936002)(5660300002)(2906002)(38100700002)(33716001)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KGMt2AGKD+PzcB2h2vTRegFPf3gOaVkdm4UvB4kn5eKRVULkWiYlywVakKpL?=
 =?us-ascii?Q?pIdNxNruggNjN2AEvNQQgGWZaDyPek7ukAPCJidOpzSGYQC2fDW3R9vW5X0+?=
 =?us-ascii?Q?BPDUquNmnMxCvCMsqfLQx6xo3O3ddy3PZDJqmdtk8SZeUs/tje3++DORkCmw?=
 =?us-ascii?Q?kNbv0pX/uF2g0EJBNDQ9Laf0xzEhzwJcuBUq8VcR/lbpxNmnK+RjzQlyrOHP?=
 =?us-ascii?Q?WkVFzfFezn6q9plV+4RLxWihP4Y72WfWyfT/f2VWZ9cdqkDCfuz9QhMAOwqZ?=
 =?us-ascii?Q?23he/6rPehKmt9+PIg0xwNqCzwv/los0LEGHYUG0ehpm/MiRkty6Dt7stR94?=
 =?us-ascii?Q?Rpclka4ceV7Zxc8IXbzIMnYx408CmdM6DLr4bNQzkA8D1IiIZ0W8UD4ic5xZ?=
 =?us-ascii?Q?RbNymmtLKhJywAGnGOSRG0r4H/blVtho5k3F7FrtjabPaEUXUj6vJru5NFEY?=
 =?us-ascii?Q?r0tWJfcd5R6D3fkNfhzLzd7+M3Efur7hCE0ydppJpuwVOCOnc6W37OHvHSdA?=
 =?us-ascii?Q?Tp4mPdX5ZjtHkP80j+Y8xUg1TMKKm9FaPR+kAcuyA42QXvrySUUN0rvVWoWp?=
 =?us-ascii?Q?W3NQmJXEvoULvWUjwia2YtM+LPYcXBh76fod6vEgBaxE6HqNZj61pbMW8YE/?=
 =?us-ascii?Q?OX3HNM/F0Azr5X0ki/iZWXqSYUfpvgkKGCaOTmjLI6DSWp/9ko0Y6JY2atQD?=
 =?us-ascii?Q?d+YvhmR+62oyFifIFdBHcAhEvomHI6VVqAHXOu9DfBdP8zCd7yl0xI9V3E3q?=
 =?us-ascii?Q?PiXZatGTdldJBThF7Sm6fofTNArtNtKMc++Wxbt7GhkQ9WbbhpV3ocXDcVLe?=
 =?us-ascii?Q?CDZ6WNpDdSHUzVREYjoqmRkxAoQksTjEOlT7ypwE/f3nocmSZ09LKvl1Udqw?=
 =?us-ascii?Q?GzCMJF495buLhKYn5TSq35+iRc8ReyRMXo5cqTJ5yw8Y/EpqGpN31b0AccWM?=
 =?us-ascii?Q?UbHhHms6FlsOi5C3Ag6f0KzLYixCPtF46Hals/aMT7+m2jMkpuo3QPuHMzaa?=
 =?us-ascii?Q?bL3Vp4PrF9an44viy7sfXNu6zo1quj1ZPaPQb+fZPcLnjODY8okZWonOT5bN?=
 =?us-ascii?Q?COPd43nSORShoWxhO85ci+gSK76nRkVihmQOKUE1jGx+iEq272RX1pGUq6Tm?=
 =?us-ascii?Q?fO2+nZZZwcjTARLi0jq14+HjikpePAbqcOQtiVRACD3nijQDH8upnP5J/Lh5?=
 =?us-ascii?Q?G2OHV1M6CBRuwBVgcPulsA8n2ISk44JRfjPzdgxvQGEAd5o3tBP/buD5kps7?=
 =?us-ascii?Q?HaKkk11JtYTvB2vtcCw8TY0cCRNz46OC4j7KzOp1KIrAv9WGW/AYX3IheRz7?=
 =?us-ascii?Q?NKUo4Euj2U+sfyQteSp8aO6Q2/V27TuAag+sdvmRwgtAVlFknWCSBEXnc5JN?=
 =?us-ascii?Q?r7NlmKtPB6b8RVAUnK05EV7sxdnwmO4rarOh6I7XPCOGetvdzRe276y+hAUX?=
 =?us-ascii?Q?krTu+seueFNxJFLAOBJRNqa+H3FDzdRKUlAXhBdb7tjTuHaW+qJTKlMQSKr2?=
 =?us-ascii?Q?OcTtdY98lg/jY0E7OCgoJYJKbINOsI5GVQZIVdueepaCFURM3CpqeiWu0Tjw?=
 =?us-ascii?Q?e+ej5VhslVGTA+JFTj0CSBh8kQ0vF5wZ0ebkFX5KVjI0qnFI5Nyb4+xmrntt?=
 =?us-ascii?Q?WgJ/A1JTQatMSHShLPRsMeTRP6xrr8ZdJT29uKSqPXIPI9lIIcaUZ/CU6gIt?=
 =?us-ascii?Q?dwSBKw7bCpHzZGNsNRnemgcoPfI/fIHe8BpTpzsvIIuZhMsnqUF4xGOn53If?=
 =?us-ascii?Q?u12x/zkK84V7ZTyIN/1JVvRBT3lTTto=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 014693b3-64ac-46c3-b2af-08da186f3a2f
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 08:18:42.5643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: swIfWI+1Wd1vX/XhtXE3roRzp1jDc3E3hM8zAp7VH/IMXEm4OI/HAXMt2lRd4v82wn44ML0jZLeAGIpKFmXgYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5613
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-06_13:2022-04-06,2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 bulkscore=0 mlxscore=0 adultscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070042
X-Proofpoint-ORIG-GUID: 3lTLXgtnw6jd3f0MWB80THKwJZ8R_IPg
X-Proofpoint-GUID: 3lTLXgtnw6jd3f0MWB80THKwJZ8R_IPg
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 07 Apr 2022 at 07:28, Darrick J. Wong wrote:
> On Thu, Apr 07, 2022 at 11:05:44AM +1000, Dave Chinner wrote:
>> On Wed, Apr 06, 2022 at 11:48:56AM +0530, Chandan Babu R wrote:
>> > This commit defines new macros to represent maximum extent counts allowed by
>> > filesystems which have support for large per-inode extent counters.
>> > 
>> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>> > Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> > ---
>> >  fs/xfs/libxfs/xfs_bmap.c       |  9 ++++-----
>> >  fs/xfs/libxfs/xfs_bmap_btree.c |  3 ++-
>> >  fs/xfs/libxfs/xfs_format.h     | 24 ++++++++++++++++++++++--
>> >  fs/xfs/libxfs/xfs_inode_buf.c  |  4 +++-
>> >  fs/xfs/libxfs/xfs_inode_fork.c |  3 ++-
>> >  fs/xfs/libxfs/xfs_inode_fork.h | 21 +++++++++++++++++----
>> >  6 files changed, 50 insertions(+), 14 deletions(-)
>> > 
>> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
>> > index b317226fb4ba..1254d4d4821e 100644
>> > --- a/fs/xfs/libxfs/xfs_bmap.c
>> > +++ b/fs/xfs/libxfs/xfs_bmap.c
>> > @@ -61,10 +61,8 @@ xfs_bmap_compute_maxlevels(
>> >  	int		sz;		/* root block size */
>> >  
>> >  	/*
>> > -	 * The maximum number of extents in a file, hence the maximum number of
>> > -	 * leaf entries, is controlled by the size of the on-disk extent count,
>> > -	 * either a signed 32-bit number for the data fork, or a signed 16-bit
>> > -	 * number for the attr fork.
>> > +	 * The maximum number of extents in a fork, hence the maximum number of
>> > +	 * leaf entries, is controlled by the size of the on-disk extent count.
>> >  	 *
>> >  	 * Note that we can no longer assume that if we are in ATTR1 that the
>> >  	 * fork offset of all the inodes will be
>> > @@ -74,7 +72,8 @@ xfs_bmap_compute_maxlevels(
>> >  	 * ATTR2 we have to assume the worst case scenario of a minimum size
>> >  	 * available.
>> >  	 */
>> > -	maxleafents = xfs_iext_max_nextents(whichfork);
>> > +	maxleafents = xfs_iext_max_nextents(xfs_has_large_extent_counts(mp),
>> > +				whichfork);
>> >  	if (whichfork == XFS_DATA_FORK)
>> >  		sz = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
>> >  	else
>> 
>> Just to confirm, the large extent count feature bit can only be
>> added when the filesystem is unmounted?
>
> Yes, because we (currently) don't support /any/ online feature upgrades.
> IIRC Chandan said that you'd have to be careful about validating the min
> log size requirements are still met because the tx reservation sizes can
> change with the taller bmbts.
>

Yes, taller BMBT trees causes transaction reservation values to change. This
in turn causes a change in log size calculations.

-- 
chandan
