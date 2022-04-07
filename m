Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB6C7C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Apr 2022 08:20:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbiDGIWg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Apr 2022 04:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242946AbiDGIWe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Apr 2022 04:22:34 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C283B2C12F
        for <linux-xfs@vger.kernel.org>; Thu,  7 Apr 2022 01:20:32 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2375hrfr006371;
        Thu, 7 Apr 2022 08:20:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=BCKEBgF6ilJ9T7hEkUVQTZTtg+6lZSyf69vZ1psJZtU=;
 b=NpdZQzO/QJorK3xmL2pwLCNerz4AapIenkn+RlWXjyF165+l6F6In9aEYGBmhlf9z6Fw
 f6y0jWe8mpNe1gT8pU3CB64y0fFR6iecfHd5yOnqb/OhfvY5GOtXfaUwvKCc3M6bnMZy
 KSIOMrtYkb7rkyRTy4CKc2oM5cClAmNzOkLjFq+5AuRQ4GN5kYwjZQPj+Xt8lAL4SvSk
 BL8P9tbSFTe1U8f56l0ojnnjwb2SkOW/o109OHPM+ndG0vqtmq4kFyOV9uUTx9Zpm++L
 S+dMA8qkexGpisjeOIRE9JGS5QnFD2b1ogE/gTnD1eprsP2lHNJpGbJ0AI6FZYUYUEJN IA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6d31k8mj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Apr 2022 08:20:27 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2378Abno018404;
        Thu, 7 Apr 2022 08:20:26 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3f9803q90x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Apr 2022 08:20:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VW1qkWhGJdMo40qV9BgQAvBmKQxLRjF3McyB70zok/m3gCxiZT0z/WoUykXJ+V8WQ5nTV/u94D7GwkXIib8SL8AY11qY1qnGQoLDR8XvyYukuC382tiZ64IMs6k3YHUe4EYZI5hRuXdCk8xzurj21eZk+FgVubG5WFLupJcG18n8zopmfNvEX8IY0tX1XnpFL7wqvyG/Xm8CDwljNbDrTtUuoWcYDju7JpN1KjymwBY/eCCaWqybQqyqgP3SlFVYG5LD6Yt2jXQO5P0sedu/vGIL5h3X4Jo3Hd2ursU9KIRAglCKU451H3c1Lx7/UgJcKlR3jC5Nlpkc9Yu6JSfoeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BCKEBgF6ilJ9T7hEkUVQTZTtg+6lZSyf69vZ1psJZtU=;
 b=VJIQ01j+TNi2H9Qc+xw5H7/sUO5tPuObzGBvuvTAv8k0tZlF50Ehy6Lbns4CRuUquv2QWaOTvFiltfRYgzBq97fDVh1pn5M4I1qoNFmre2wsUSuHih2u9Pt1fc4FxEcD2+Lntlqgfaw0Tl4A+bULSobJ6Oz48DGvlhpGIvwf6MF7dzwgvC2dXHNi61lha0TbzkLh0duRUZE6BYkuRhvjcntQYCecNEXes9yixdavEXiIz2XrWnsVaK5g93llGHJcxSRjREoSUZerI6tSjBjFQQsyLBYu41JXsY+dSMeA2XT2elhIeC8YITsAQR2SqFxZYX4RKUsRr3FHPROfsXdAkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BCKEBgF6ilJ9T7hEkUVQTZTtg+6lZSyf69vZ1psJZtU=;
 b=ypXVNMJkwob3es5Z7wk/6b6T4Xn6MD1EXqirvN41JmR5sTqbJ6xB0WG5COuXZWjLfh+yJqqVMEvPFOmVSUM2o7rt1RLaGCFb+UJv6/kSRI3c0KzQdxYCIyhyqjt1us0egGphUU5n/O3Aub3FzuS/CGdSM5rlNu/BlCokuhMQ5cY=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SJ0PR10MB5613.namprd10.prod.outlook.com (2603:10b6:a03:3d0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21; Thu, 7 Apr
 2022 08:20:23 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d%8]) with mapi id 15.20.5144.021; Thu, 7 Apr 2022
 08:20:23 +0000
References: <20220406061904.595597-1-chandan.babu@oracle.com>
 <20220406061904.595597-19-chandan.babu@oracle.com>
 <20220407012912.GT27690@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH V9 18/19] xfs: Enable bulkstat ioctl to support 64-bit
 per-inode extent counters
In-reply-to: <20220407012912.GT27690@magnolia>
Message-ID: <877d81xq2p.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Thu, 07 Apr 2022 13:50:14 +0530
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0023.apcprd02.prod.outlook.com
 (2603:1096:3:17::35) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d5081380-c13a-4ab5-9be0-08da186f765f
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5613:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB561331114CE67DF5187181D2F6E69@SJ0PR10MB5613.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KnQvmI/2eG0etl1folnDCWa3ZiPN9flDI6TmqsS6Bp0qws68o40VLsnrCazkicd+prd4xwuztFDAlAxD4xm43eEd3f+rjMxoBLkolOgxHxQwRG6O3A3D+Kq3++D5iNRTau+kGwgjrw/7a77DThBGGEYtFY89LFT/JtdcDcp2SpA67LyjMHJTM2eHMIWsXTnxVR0gdmfebuMjkS3+uyVLHBnaXlfSU0K5pF3R6hS3GrCNWCgllL9giUptgHIbYWlCSD1GpeX7nvcMIeqF1T2LuQbHvHn5+3Ucp1JCO71i30I6oQ6BlbEYRBPuIY5zEo+QldcnkCyHo+lfD8Pvgom3y1D7yzG/jux/exdnBs/UicV1pjuRDgPEqQL1dKRMTMW3/DvkePU0jaPXER0phVGB0rOmlcT13trK9nBxV9ZE21mVnEPeBiFFxa0hINFTDtFDvSvU/i2ewfz80mLoI4ipGhDyUT/Wa20IsKVjlPUESSqsZO4QDclHxZ/usy9QCyjpA0d3xX9Ro924sWaU0Colw7aOSKeRpErn/msfTfzNiDNPcXah7VjbfjYParGrMdOEDJH3iEMRrwvbWVGAIsYcLuIfeZOFjDqM5d+r/R1f7VQfPAjCPHQCNB4zX8fC24GOnzj+KQ0IRkPWYargs8WfB5hP2ITRSgGFlckOYvX0SS1N4hfOiMg1jUwUHJXS6M497z1ma7bHHL51B3sfARGCSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(83380400001)(6486002)(38350700002)(33716001)(508600001)(38100700002)(8936002)(5660300002)(2906002)(66556008)(4326008)(316002)(86362001)(9686003)(53546011)(52116002)(26005)(6512007)(186003)(66476007)(66946007)(6916009)(8676002)(6666004)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VI1GjMI1QFMbNK4FSogt50Qa5Ok2AZDxpOaBtYf0kvFLfoP5+mrtPxZ3JLsd?=
 =?us-ascii?Q?1yIXcum+qN85IsLKXlsRx8rgXWmf7IwoJY4hoSJRWGU3iz9vj7hNhTsRX6sc?=
 =?us-ascii?Q?AADXfP4G8RIJ1gb4oCHiSCJDe/0E6DvMhAS1PnVkXB/gtLcrGG0V7n0P1d6K?=
 =?us-ascii?Q?ntbslJG8fHZMNPVDs3MBI+Lg9dSAMbdfK5KdVVJCKteNptSuHBy9Ljlbzkp3?=
 =?us-ascii?Q?qKc2GV/7Q4Bb7t3rcGwFLjyBB8Rm1qTaDGJZpZ+9yWvfSV/vYFYJ6p8DojNH?=
 =?us-ascii?Q?hBQLwbX2vZ+C5uOieWTwXj+0J7Y8q5/U6vQvWZvUMV8s3Y/2qA6jjni8v9eF?=
 =?us-ascii?Q?VkO1MszPq10ANfBhEThewBC5ePfDYJHTMmaKmnLToy4jgAm7kYElIFrOHkSd?=
 =?us-ascii?Q?vG4bRSNMnXI9O00/3B4T4ctRu4TYHv8FObDr3AqqDJcKRdlqaQiaStK/PnWV?=
 =?us-ascii?Q?W5AHGF6+qnp6COSanm+8h5y9Bet+1qJfhpvRE8M47ic5hBXtmCm63mKdBTNf?=
 =?us-ascii?Q?SQx5AXGp0K8w6DcVyviA6sUKSxnIqpSll/xbELjtt6yZNKxmYvzHBC/5KesD?=
 =?us-ascii?Q?EfNneC/iFfaMsMF/f49LEvzCfkinf8KKMxcmZxkMI597V5tLl9TBttQ9I1Jm?=
 =?us-ascii?Q?PInc/Yl6HIDWvIQp3N5EFjP0QGbqm4iRQ+EJmXMfLnj8hKUAs86dPty7hFZA?=
 =?us-ascii?Q?0RuVm2xNPvH4btTR0WPy1zZx4+y02JcG4+kvVzT7KpskdHvGVn6nkcS+fr58?=
 =?us-ascii?Q?eR8IGZWffFGvNtTdEhZckspakI+yOmTs95Tl5P4qW6jwit9JklAZ4a+/nDMv?=
 =?us-ascii?Q?PyQMnX0YuBX/l9xezGB/Mc3s44gGQ24GH6So6/o3i+2wk8dWG2dqzDmgs35Q?=
 =?us-ascii?Q?zesefbubAasOXMtpmh+CmAQ8nXroU+hJIcIBxhiXyMGOmb77htIoJSruQ/I3?=
 =?us-ascii?Q?SAzUCCDQKR/Sq5a6APtu/U4Tg8Ol4i2WP1kWAXpijWFyK9SjOJcDJne2kT7h?=
 =?us-ascii?Q?ucLeNC3YpIgrQTs64XA/kltT4asJsekuqJbK3MjsPV0l7BGVpBVQO8v1741w?=
 =?us-ascii?Q?VflhG3M7OpYNqV3aET1vJ1Npz4sPshRiR700ovkEfW8u9cGlbG0LTLtNIjUA?=
 =?us-ascii?Q?xgO30xhA3YNe0XPvAw6JfkwfGN5t1PM0IUWCQpVWKQDADBFXJ+0LxngpQk96?=
 =?us-ascii?Q?1djzlAPRuZRNaqsBEp/0ySrgDvxXp9I+0poHeZpHZQljMLHz95HYz0x2vfk8?=
 =?us-ascii?Q?XXhqy/vJx5LGAfPdp1DyChx/jIqIx1BxxxnM9V8PrvelXsjw8QAGkxZarite?=
 =?us-ascii?Q?jSzs3rGvZ992U5azx2PlIQ0WemoEcy+l8KwPyPoaHegTmJ8dq1YU0ByIsyAy?=
 =?us-ascii?Q?C3+P58cU1rt6h1S2YCD0yi4ulXTCzqbRzLpohnOtAyAm5fh0GhBgHocdsz0F?=
 =?us-ascii?Q?XWp97wzQdA9y8Rv7b5qluSUdmDRjHAe9B+yHBnhvul8IHhjQl4MJWUUJfjOi?=
 =?us-ascii?Q?1Cv/bbyqLGS05QZ0DdC6XvNuRcBCa6ogqsozKSd6H0e71aDojSEtSi+YUFDV?=
 =?us-ascii?Q?xqn0FXkK/NlV8qtGFAog0zYdA8Vjtwpk5eb/HXrLbgbUx4lr7DMwVqcO30ws?=
 =?us-ascii?Q?3h2OgyA8CVyyQcRJ0oCjib03mdWWtRyeqANy+EnFFZTUUx8F454DhILpU7vS?=
 =?us-ascii?Q?rwZSIUChJM3ziA0e4/ITEpB0hdrhCFl+QKyIm/EEYZVfW6Qvdj8SWgTQXdJX?=
 =?us-ascii?Q?zPFK0ycW1n8sZ/PCta8IOq/jHPLEo30=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5081380-c13a-4ab5-9be0-08da186f765f
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 08:20:23.5572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8E6/PRojkA3Mc+LUbnanBiZUxHiS7fyazI5nSXcKJfQlr+5ICP2XnkY4hA4gsfGie9DUpvmyo2CcwfLaYGQjlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5613
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-06_13:2022-04-06,2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204070042
X-Proofpoint-GUID: ppBI1lWlOHwwEhasqZCff0CGNlvWt9yg
X-Proofpoint-ORIG-GUID: ppBI1lWlOHwwEhasqZCff0CGNlvWt9yg
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 07 Apr 2022 at 06:59, Darrick J. Wong wrote:
> On Wed, Apr 06, 2022 at 11:49:02AM +0530, Chandan Babu R wrote:
>> The following changes are made to enable userspace to obtain 64-bit extent
>> counters,
>> 1. Carve out a new 64-bit field xfs_bulkstat->bs_extents64 from
>>    xfs_bulkstat->bs_pad[] to hold 64-bit extent counter.
>> 2. Define the new flag XFS_BULK_IREQ_BULKSTAT for userspace to indicate that
>>    it is capable of receiving 64-bit extent counters.
>> 
>> Reviewed-by: Dave Chinner <dchinner@redhat.com>
>> Suggested-by: Darrick J. Wong <djwong@kernel.org>
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  fs/xfs/libxfs/xfs_fs.h | 20 ++++++++++++++++----
>>  fs/xfs/xfs_ioctl.c     |  3 +++
>>  fs/xfs/xfs_itable.c    | 13 ++++++++++++-
>>  fs/xfs/xfs_itable.h    |  2 ++
>>  4 files changed, 33 insertions(+), 5 deletions(-)
>> 
>> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
>> index 1f7238db35cc..2a42bfb85c3b 100644
>> --- a/fs/xfs/libxfs/xfs_fs.h
>> +++ b/fs/xfs/libxfs/xfs_fs.h
>> @@ -378,7 +378,7 @@ struct xfs_bulkstat {
>>  	uint32_t	bs_extsize_blks; /* extent size hint, blocks	*/
>>  
>>  	uint32_t	bs_nlink;	/* number of links		*/
>> -	uint32_t	bs_extents;	/* number of extents		*/
>> +	uint32_t	bs_extents;	/* 32-bit data fork extent counter */
>>  	uint32_t	bs_aextents;	/* attribute number of extents	*/
>>  	uint16_t	bs_version;	/* structure version		*/
>>  	uint16_t	bs_forkoff;	/* inode fork offset in bytes	*/
>> @@ -387,8 +387,9 @@ struct xfs_bulkstat {
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
>> @@ -469,8 +470,19 @@ struct xfs_bulk_ireq {
>>   */
>>  #define XFS_BULK_IREQ_SPECIAL	(1 << 1)
>>  
>> -#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO | \
>> -				 XFS_BULK_IREQ_SPECIAL)
>> +/*
>> + * Return data fork extent count via xfs_bulkstat->bs_extents64 field and assign
>> + * 0 to xfs_bulkstat->bs_extents when the flag is set.  Otherwise, use
>> + * xfs_bulkstat->bs_extents for returning data fork extent count and set
>> + * xfs_bulkstat->bs_extents64 to 0. In the second case, return -EOVERFLOW and
>> + * assign 0 to xfs_bulkstat->bs_extents if data fork extent count is larger than
>> + * XFS_MAX_EXTCNT_DATA_FORK_OLD.
>> + */
>> +#define XFS_BULK_IREQ_NREXT64	(1 << 2)
>> +
>> +#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO |	 \
>> +				 XFS_BULK_IREQ_SPECIAL | \
>> +				 XFS_BULK_IREQ_NREXT64)
>>  
>>  /* Operate on the root directory inode. */
>>  #define XFS_BULK_IREQ_SPECIAL_ROOT	(1)
>> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
>> index 83481005317a..e9eadc7337ce 100644
>> --- a/fs/xfs/xfs_ioctl.c
>> +++ b/fs/xfs/xfs_ioctl.c
>> @@ -813,6 +813,9 @@ xfs_bulk_ireq_setup(
>>  	if (XFS_INO_TO_AGNO(mp, breq->startino) >= mp->m_sb.sb_agcount)
>>  		return -ECANCELED;
>>  
>> +	if (hdr->flags & XFS_BULK_IREQ_NREXT64)
>> +		breq->flags |= XFS_IBULK_NREXT64;
>> +
>>  	return 0;
>>  }
>>  
>> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
>> index 71ed4905f206..847f03f75a38 100644
>> --- a/fs/xfs/xfs_itable.c
>> +++ b/fs/xfs/xfs_itable.c
>> @@ -64,6 +64,7 @@ xfs_bulkstat_one_int(
>>  	struct xfs_inode	*ip;		/* incore inode pointer */
>>  	struct inode		*inode;
>>  	struct xfs_bulkstat	*buf = bc->buf;
>> +	xfs_extnum_t		nextents;
>>  	int			error = -EINVAL;
>>  
>>  	if (xfs_internal_inum(mp, ino))
>> @@ -102,7 +103,17 @@ xfs_bulkstat_one_int(
>>  
>>  	buf->bs_xflags = xfs_ip2xflags(ip);
>>  	buf->bs_extsize_blks = ip->i_extsize;
>> -	buf->bs_extents = xfs_ifork_nextents(&ip->i_df);
>> +
>> +	nextents = xfs_ifork_nextents(&ip->i_df);
>> +	if (!(bc->breq->flags & XFS_IBULK_NREXT64)) {
>> +		if (nextents > XFS_MAX_EXTCNT_DATA_FORK_SMALL)
>> +			buf->bs_extents = XFS_MAX_EXTCNT_DATA_FORK_SMALL;
>> +		else
>> +			buf->bs_extents = nextents;
>
> buf->bs_extents = min(nextents, XFS_MAX_EXTCNT_DATA_FORK_SMALL); ?
>

This is much cleaner. I will apply the above suggestion.

>> +	} else {
>> +		buf->bs_extents64 = nextents;
>> +	}
>> +
>>  	xfs_bulkstat_health(ip, buf);
>>  	buf->bs_aextents = xfs_ifork_nextents(ip->i_afp);
>>  	buf->bs_forkoff = XFS_IFORK_BOFF(ip);
>> diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
>> index 2cf3872fcd2f..0150fd53d18e 100644
>> --- a/fs/xfs/xfs_itable.h
>> +++ b/fs/xfs/xfs_itable.h
>> @@ -19,6 +19,8 @@ struct xfs_ibulk {
>>  /* Only iterate within the same AG as startino */
>>  #define XFS_IBULK_SAME_AG	(1 << 0)
>>  
>> +#define XFS_IBULK_NREXT64	(1 << 1)
>
> Needs a comment here.
>
> /* Fill out the bs_extents64 field if set. */
> #define XFS_IBULK_NREXT64	(1U << 1)
>
> (Are we supposed to do "1U" now?)
>

I will apply the above suggestion.

-- 
chandan
