Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 402A0C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Sep 2021 09:50:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FE726023B
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Sep 2021 09:50:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240001AbhI1Jvo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Sep 2021 05:51:44 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:64704 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239989AbhI1Jvn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Sep 2021 05:51:43 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18S9UDTA024914;
        Tue, 28 Sep 2021 09:50:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=dGnlEWqayCwJPosptNoPHz6kYNmlBegvLqXrsS+IbGk=;
 b=lTIx+YDMAi2+QKyFVaz3wj1PQNxwYqdt5ipDOHumdW/MKwKtvrhI4A3jtLfu+y/4zTaj
 t4rcSqDuY0/pNr+NNLhJCNMgp27x5G78U8wX3LjyisE7mXDK3fs1BvFH5LGTaNjJMpT0
 KNvxl2xdsw05PVXvRVGPjUuRuPWc8UOId7smF96Tkk9xKxh92Or5ZVaQPWgAYgGNYI3n
 QYvBG8lEp7gdX7ixh5HSHH9VNGzApdRkFjyy6jdQOCsgpHdmB2Qs8E2l/u7sXm07UKJW
 MpKd2a3ocKIFQKmR4Q0iTb4HoNotCCdP2Y3MUvIEonh0aR/s0wRfUaldwo2QgpviHgBf NQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bbhvbwh7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Sep 2021 09:50:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18S9nv3J053921;
        Tue, 28 Sep 2021 09:49:58 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by userp3030.oracle.com with ESMTP id 3b9rvv5jx9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Sep 2021 09:49:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D8GHJZx1HzxbKGd2y9SZ1KLd71sHcMhKANJ/Lyz+YrUfnjQ6NG49StBbGW3+T4wli99NUQQnA7rjmNZeoxtLtQ/qW9h/Z2ROMcCOJ2g9OvCgETIaT2BcMNYzlD/pgEfJRr91Prq2wmf/CpZGpPJB4HtKNOy+PIMma7z2sAUhxpeYh2Afx43nkh1aogAP7y4bu/O3JIOtlMPo4/4OYCbZBkSTm15wQpvx14R3ry6vj3LVLH1fMudG0wPAu/qF7lcrDgNq+nEUKZjnziSqmJHL5tK4xsOdMie9FcOYxnejaZCfrKMOrwET64oCHBe31NvqUGPuWImrVjRd5BC4gEDooA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=dGnlEWqayCwJPosptNoPHz6kYNmlBegvLqXrsS+IbGk=;
 b=hyHt1eqECXUQ8PLceTlg1Ijwasa28FNOI4MxXU4ePHyWgWLGIKhhQe/BXuq2/FMZ0No0wrcHKMPQkoxsDlswuUKElYeT49JwU1iop8zoTyOp20ltgjn07Ut7sRNaT1wmFdIHPAbmPwOQbDOBo4JEj65mth0RpeRdecF1i4UZzaGku8PrBVBIghbi7F//WFXRlf/QYf/xvk6y9Z3TI1YTo0x3Bf6TKQgNTRGFgCy8mc1ezV75jpu2Q65ponp9Qf4Y6LqNyz375OYyTOSVB4MmJ8JBhklO7p64mu2EAAGDRjeM4IrDkf0DKOVmIiNCFqK/Le8+DuGng56LgwD8xS1OiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dGnlEWqayCwJPosptNoPHz6kYNmlBegvLqXrsS+IbGk=;
 b=pNmf2Jp9OQPUxdgNTJsJsvN1mVHdBoZs8Yx5QO6DBO1Y5ldOKRQ7TheJa2+TuaQItrPAeZEhQm6x+2uaivmqy+Yo6JuE3t66d/mZAxSbvFn99JQ3liHc5mSf5p+LrQ2zddRGtxYOWB2RncaYT0yVBA4V6ZbagejZhbDsU5aFHiw=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN4PR10MB5560.namprd10.prod.outlook.com (2603:10b6:806:203::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Tue, 28 Sep
 2021 09:49:43 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%8]) with mapi id 15.20.4544.021; Tue, 28 Sep 2021
 09:49:43 +0000
References: <20210916100647.176018-1-chandan.babu@oracle.com>
 <20210916100647.176018-10-chandan.babu@oracle.com>
 <20210927230637.GL1756565@dread.disaster.area>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V3 09/12] xfs: Enable bulkstat ioctl to support 64-bit
 per-inode extent counters
In-reply-to: <20210927230637.GL1756565@dread.disaster.area>
Message-ID: <87zgrxyqqe.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Tue, 28 Sep 2021 15:19:29 +0530
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0047.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:22::33) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (122.171.129.29) by MA1PR0101CA0047.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:22::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Tue, 28 Sep 2021 09:49:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 576d31e1-aa74-4cd3-a756-08d982654c5c
X-MS-TrafficTypeDiagnostic: SN4PR10MB5560:
X-Microsoft-Antispam-PRVS: <SN4PR10MB55603C12CBA260B1896DD1ABF6A89@SN4PR10MB5560.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1388;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2I8YclZHBYNvpQhe4xOG2UZ+2gmihR89KzNX8c3vuc/YQmUFIfu0XwqHO8XBJjrz5b4uoAmYh3vUvn5xSb2vWkzUuoofX94vSbNoUFPJlOJ/8MAq2KVKw9ftlBe/ockPPf8qC3k07pvwbhWOW4mc/OKfqZbjV8s6GhTcsWh5XSOpHWR/rgIUxnTCz8vW9Z9am1LmRMtNF/jo3dV2FddO0DXFWP2sDTBUT+ceg2FLHEAWd97i5gzj+luRmJh4RcoASfruLnBGl17tF7EYy6uhL2wYMU2Ci8J//YhNP69sB8otLMqDwzchQ1SLlpt5fBKuCFXTk7yDAw/oqF4nWhwyqOW53rCloqcnNQN0fYfNTx0rlJR8UgdB0EvmFOKAVtGLPnoeizJhilZmoOFIoa8+TXdv9FmMR4Wf0KfPHW9KcdEPKQRKuPoDrcfN1zBtqRKxJk4fk335/10+sTkO0A5Aqli1nV58OmWMfsXON+4eHmWHBAbpapx2ofEbdmcHAfZh4G3tRq3+Qw3/3QUWCJ3QMn/RobCgJNwrvj64FGapbfRgN+R1Klf3R3idCD4ih0DaP5M6Qc164l2NszAGBpuBnVS/7buTmVfyjdOewek1EUFDwk5OU7qpZmQsRk9S0gME8LW1F3d4uiNhtVq/EYsV3l3RZFv4yRkrpAQA1vPDTUOlZUlnTPINjzGh+bws1FodKQCIDIjZ/XRdOAKh/pEYPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(508600001)(83380400001)(6916009)(6496006)(9686003)(66946007)(86362001)(66556008)(66476007)(53546011)(52116002)(6666004)(2906002)(186003)(33716001)(5660300002)(8936002)(316002)(956004)(6486002)(26005)(4326008)(8676002)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LY6IXC4dUQExezBurBufBNyxeAK030NEvdEvvWOcJ2jk+vpA+m8fDqjesc6p?=
 =?us-ascii?Q?iNrGOxoUOq0I8EcrS1lHXZQGJJHa9jcRKy1veQrV/0AMGNkweNbUNTpZhi6h?=
 =?us-ascii?Q?Y5/UoMo3+ACjl9i+qbbkpmNbAbcAc6oZwXetid/dg1cRePlxSc8TypfWKzzo?=
 =?us-ascii?Q?J86VcWmGXCIKmJ5xBXTU4nq+0NV2aVJHFjajkYXoTg+aOV7HfE4ltK8ydoKG?=
 =?us-ascii?Q?HuAuM8pGlGxrfVKRMeIx94RJccN439+erKJo/4a9aZUpN0tYKA8vamCSLZcs?=
 =?us-ascii?Q?Bo7bmokbilyiSLYuzVwArqFmpBy2N56kX/VDGNe7EoclDjzTK5uE3C2GWQSu?=
 =?us-ascii?Q?+fRCIkhNmoy020Uo6rxih5DXZIX1+oJshr8TGAfuvfNxBjJ6+fFfR8QFneba?=
 =?us-ascii?Q?coOi73eJYrQ9nOGcPe9syezb7ERoTsXnrtq9qFQk9ftdBEqnuUt0HrtASC+C?=
 =?us-ascii?Q?c21aLnr0pLZC8D5ZSvU4e5VwrDKWgVYQjibIt/p3q8RsBsktZEseBrF0UkOt?=
 =?us-ascii?Q?BlZATR9hB/yCGv0h6SG4dkWgNecW6OYlopb8+kjOhZgr7yl2EO2I/esoybGC?=
 =?us-ascii?Q?Qn9UJzQs0W0FxQx2Zsq6p6wRNZaFVZw+VT3OZvhN9ppuTvXcZl0Mfqqa3NJk?=
 =?us-ascii?Q?o0op0vswWEVmBll4q4S+Ghd9ZiooM4NMbXOvj4TiX4iBMxJNLejYKEH2KndD?=
 =?us-ascii?Q?nWvFKMayZoPC2koxfzxH8ms1gk9zw0FyQm833gypEGWKwTnjOtVq31gEOdMO?=
 =?us-ascii?Q?5iEsX/NpSu8YlsdbkYvS0u/1PaB1IH7WB8kWpimPSq5pS8opqli3pxyRc6ik?=
 =?us-ascii?Q?4vuPxAxUtnk1iqt4tnhqrF++WVioc6T5eglKuQ07eExT8pv51vmhTRRlN9GB?=
 =?us-ascii?Q?2kEXnR1hzy8Vf7v+kbqs+/hePWphOn0Ha6PQG5Fva2u3z7a6khGXll6QtJMp?=
 =?us-ascii?Q?aDX56BBaNXrrpBEWD8L/hKXW7Zz0pB1XRNjaeCWCa9HymYR7ys6GmBnsQTun?=
 =?us-ascii?Q?PcBNRd1wCP0rKFIWa6IYtEewesYnVLdvt+/Cm+c651vOhOyu7Yc5LjQJdSkf?=
 =?us-ascii?Q?VrC9uWDVoQCipFb5EpJafOdscNMqUTEWmvy1EtI0Y/tDNppGLMppnJz6RhUo?=
 =?us-ascii?Q?s3Lhhli1otE49z3QE0w9vazHcDmxXQDg/nPzmjUqrtp5E3JFux2qNpQlAA0m?=
 =?us-ascii?Q?EvZze9rxDPJDTiC1ptOY33RGCITzuOvmJenJ7bvg5PG+C0l5Bn6e/aVqD/x2?=
 =?us-ascii?Q?BsxzDZyv2H4F+chfXmkU69wP6y5o3L7WBGLopsrBeCPf1+Fmxn/YtfKNQavU?=
 =?us-ascii?Q?bfE5Y0yZ1VEXR/0bK5qlRibo?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 576d31e1-aa74-4cd3-a756-08d982654c5c
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 09:49:43.7170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Go1GrpW+W745HlCmXvc72wEZpH68ymEXwtmeQlrhg4GrnyXQqWz4ttZDK9MI0paqvuzwzSSofuVJfJWxP9+6ZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5560
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10120 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0 mlxscore=0
 spamscore=0 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109280057
X-Proofpoint-ORIG-GUID: -u5mIUmTwoxLsNPJ8p7or6iP6CGlc2f6
X-Proofpoint-GUID: -u5mIUmTwoxLsNPJ8p7or6iP6CGlc2f6
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 28 Sep 2021 at 04:36, Dave Chinner wrote:
> On Thu, Sep 16, 2021 at 03:36:44PM +0530, Chandan Babu R wrote:
>> The following changes are made to enable userspace to obtain 64-bit extent
>> counters,
>> 1. To hold 64-bit extent counters, carve out the new 64-bit field
>>    xfs_bulkstat->bs_extents64 from xfs_bulkstat->bs_pad[].
>> 2. Carve out a new 64-bit field xfs_bulk_ireq->bulkstat_flags from
>>    xfs_bulk_ireq->reserved[] to hold bulkstat specific operational flags.  As of
>>    this commit, XFS_IBULK_NREXT64 is the only valid flag that this field can
>>    hold. It indicates that userspace has the necessary infrastructure to
>>    receive 64-bit extent counters.
>> 3. Define the new flag XFS_BULK_IREQ_BULKSTAT for userspace to indicate that
>>    xfs_bulk_ireq->bulkstat_flags has valid flags set.
>
> This seems unnecessarily complex. It adds a new flag to define a new
> flag field in the same structure and then define a new and a new
> flag in the new flag field to define a new behaviour.
>
> Why can't this be done with just a single new flag in the existing
> flags field?
>

Yes, This can be implemented with just one flag. I will make the relevant
changes before posting the next version.

>> Suggested-by: Darrick J. Wong <djwong@kernel.org>
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  fs/xfs/libxfs/xfs_fs.h | 19 ++++++++++++++-----
>>  fs/xfs/xfs_ioctl.c     |  7 +++++++
>>  fs/xfs/xfs_itable.c    | 25 +++++++++++++++++++++++--
>>  fs/xfs/xfs_itable.h    |  2 ++
>>  fs/xfs/xfs_iwalk.h     |  7 +++++--
>>  5 files changed, 51 insertions(+), 9 deletions(-)
>> 
>> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
>> index 2594fb647384..b76906914d89 100644
>> --- a/fs/xfs/libxfs/xfs_fs.h
>> +++ b/fs/xfs/libxfs/xfs_fs.h
>> @@ -394,7 +394,7 @@ struct xfs_bulkstat {
>>  	uint32_t	bs_extsize_blks; /* extent size hint, blocks	*/
>>  
>>  	uint32_t	bs_nlink;	/* number of links		*/
>> -	uint32_t	bs_extents;	/* number of extents		*/
>> +	uint32_t	bs_extents32;	/* 32-bit data fork extent counter */
>>  	uint32_t	bs_aextents;	/* attribute number of extents	*/
>>  	uint16_t	bs_version;	/* structure version		*/
>>  	uint16_t	bs_forkoff;	/* inode fork offset in bytes	*/
>
> I don't think renaming structure members is a good idea - it breaks
> the user API and forces applications to require source level
> modifications just to compile on both old and new xfsprogs installs.
>

Ok. I will revert the rename.

>> @@ -403,8 +403,9 @@ struct xfs_bulkstat {
>>  	uint16_t	bs_checked;	/* checked inode metadata	*/
>>  	uint16_t	bs_mode;	/* type and mode		*/
>>  	uint16_t	bs_pad2;	/* zeroed			*/
>> +	uint64_t	bs_extents64;	/* 64-bit data fork extent counter */
>>  
>> -	uint64_t	bs_pad[7];	/* zeroed			*/
>> +	uint64_t	bs_pad[6];	/* zeroed			*/
>>  };
>>  
>>  #define XFS_BULKSTAT_VERSION_V1	(1)
>> @@ -469,7 +470,8 @@ struct xfs_bulk_ireq {
>>  	uint32_t	icount;		/* I: count of entries in buffer */
>>  	uint32_t	ocount;		/* O: count of entries filled out */
>>  	uint32_t	agno;		/* I: see comment for IREQ_AGNO	*/
>> -	uint64_t	reserved[5];	/* must be zero			*/
>> +	uint64_t	bulkstat_flags; /* I: Bulkstat operation flags */
>> +	uint64_t	reserved[4];	/* must be zero			*/
>>  };
>>  
>>  /*
>> @@ -492,9 +494,16 @@ struct xfs_bulk_ireq {
>>   */
>>  #define XFS_BULK_IREQ_METADIR	(1 << 2)
>>  
>> -#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO | \
>> +#define XFS_BULK_IREQ_BULKSTAT	(1 << 3)
>> +
>> +#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO |	 \
>>  				 XFS_BULK_IREQ_SPECIAL | \
>> -				 XFS_BULK_IREQ_METADIR)
>> +				 XFS_BULK_IREQ_METADIR | \
>> +				 XFS_BULK_IREQ_BULKSTAT)
>
> What's this XFS_BULK_IREQ_METADIR thing? I haven't noticed that when
> scanning any recent proposed patch series....
>

XFS_BULK_IREQ_METADIR is from Darrick's tree. His "Kill XFS_BTREE_MAXLEVELS"
patch series is based on his other patchsets. His recent "xfs: support dynamic
btree cursor height" patch series rebases only the required patchset on top of
v5.15-rc1 kernel eliminating the others.

>> +#define XFS_BULK_IREQ_BULKSTAT_NREXT64 (1 << 0)
>> +
>> +#define XFS_BULK_IREQ_BULKSTAT_FLAGS_ALL (XFS_BULK_IREQ_BULKSTAT_NREXT64)
>
> As per above, this seems unnecessarily complex.
>
>> @@ -134,7 +136,26 @@ xfs_bulkstat_one_int(
>>  
>>  	buf->bs_xflags = xfs_ip2xflags(ip);
>>  	buf->bs_extsize_blks = ip->i_extsize;
>> -	buf->bs_extents = xfs_ifork_nextents(&ip->i_df);
>> +
>> +	nextents = xfs_ifork_nextents(&ip->i_df);
>> +	if (!(bc->breq->flags & XFS_IBULK_NREXT64)) {
>> +		xfs_extnum_t max_nextents = XFS_IFORK_EXTCNT_MAXS32;
>> +
>> +		if (unlikely(XFS_TEST_ERROR(false, mp,
>> +				XFS_ERRTAG_REDUCE_MAX_IEXTENTS)))
>> +			max_nextents = 10;
>> +
>> +		if (nextents > max_nextents) {
>> +			xfs_iunlock(ip, XFS_ILOCK_SHARED);
>> +			xfs_irele(ip);
>> +			error = -EINVAL;
>> +			goto out_advance;
>> +		}
>
> So we return an EINVAL error if any extent overflows the 32 bit
> counter? Why isn't this -EOVERFLOW?
>

Returning -EINVAL causes xfs_bulkstat_iwalk() to skip inodes whose extent
count is larger than that which can be fitted into a 32-bit field. Returning
-EOVERFLOW causes the bulkstat ioctl to stop reporting remaining inodes.

>> +		buf->bs_extents32 = nextents;
>> +	} else {
>> +		buf->bs_extents64 = nextents;
>> +	}
>> +
>>  	xfs_bulkstat_health(ip, buf);
>>  	buf->bs_aextents = xfs_ifork_nextents(ip->i_afp);
>>  	buf->bs_forkoff = XFS_IFORK_BOFF(ip);
>> @@ -356,7 +377,7 @@ xfs_bulkstat_to_bstat(
>>  	bs1->bs_blocks = bstat->bs_blocks;
>>  	bs1->bs_xflags = bstat->bs_xflags;
>>  	bs1->bs_extsize = XFS_FSB_TO_B(mp, bstat->bs_extsize_blks);
>> -	bs1->bs_extents = bstat->bs_extents;
>> +	bs1->bs_extents = bstat->bs_extents32;
>>  	bs1->bs_gen = bstat->bs_gen;
>>  	bs1->bs_projid_lo = bstat->bs_projectid & 0xFFFF;
>>  	bs1->bs_forkoff = bstat->bs_forkoff;
>> diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
>> index f5a13f69883a..f61685da3837 100644
>> --- a/fs/xfs/xfs_itable.h
>> +++ b/fs/xfs/xfs_itable.h
>> @@ -22,6 +22,8 @@ struct xfs_ibulk {
>>  /* Signal that we can return metadata directories. */
>>  #define XFS_IBULK_METADIR	(XFS_IWALK_METADIR)
>>  
>> +#define XFS_IBULK_NREXT64	(XFS_IWALK_NREXT64)
>> +
>>  /*
>>   * Advance the user buffer pointer by one record of the given size.  If the
>>   * buffer is now full, return the appropriate error code.
>> diff --git a/fs/xfs/xfs_iwalk.h b/fs/xfs/xfs_iwalk.h
>> index d7a082e45cbf..27a6842a1bb5 100644
>> --- a/fs/xfs/xfs_iwalk.h
>> +++ b/fs/xfs/xfs_iwalk.h
>> @@ -31,8 +31,11 @@ int xfs_iwalk_threaded(struct xfs_mount *mp, xfs_ino_t startino,
>>  /* Signal that we can return metadata directories. */
>>  #define XFS_IWALK_METADIR	(0x2)
>>  
>> -#define XFS_IWALK_FLAGS_ALL	(XFS_IWALK_SAME_AG | \
>> -				 XFS_IWALK_METADIR)
>> +#define XFS_IWALK_NREXT64	(0x4)
>
> Can we use '(1 << 2)' style notation for new bit field defines?

Sure, I will change this.

-- 
chandan
