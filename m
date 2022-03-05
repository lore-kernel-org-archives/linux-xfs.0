Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0E23C433F5
	for <linux-xfs@archiver.kernel.org>; Sat,  5 Mar 2022 12:45:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbiCEMqX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 5 Mar 2022 07:46:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiCEMqW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 5 Mar 2022 07:46:22 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9FF41CC7FD
        for <linux-xfs@vger.kernel.org>; Sat,  5 Mar 2022 04:45:32 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2259qmnH006681;
        Sat, 5 Mar 2022 12:45:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=vJAHNDiJyHNRRex64lHiWN6UpjueIv50B+LBTzXOCiw=;
 b=qTjiLkryo6VF5lA9I+FWiGsdcueF8lnHPNuVCMohw29bhY9fPt7EHD1c+I32soXYK/JN
 9dz3yvlVPsyeIval8C56ucZ0Ff4Ncg7fDL889Vxt8A1JxIXtudgw3RSTYaMYl8W1oYOI
 JLxYtojJbtd4KQPRLAk0NxUie7yMh6f66FUQSWpqKWZx1goQWbuGEqj5ZU95CAzYjHx2
 gW4NBeXhxYAK0Dg8VgKi5jgUMIfNT/JioZQkjITOIbIXKdNJ6KFxRIB20eWDlRWNfCRt
 xzLmsWr15xfqEC3NO46oFGKRM4OmpOcNxmUzjWO5metGxg/bhMOv1FMrc1tPF5wvXrX7 Kw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekxn28pt5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 05 Mar 2022 12:45:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 225CaOsu137000;
        Sat, 5 Mar 2022 12:45:27 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2174.outbound.protection.outlook.com [104.47.73.174])
        by userp3020.oracle.com with ESMTP id 3em1afssym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 05 Mar 2022 12:45:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fdIPs/mnK94w1YyLJ+aL/ORuQu9rMaDtpr61kTGoVgGbfPAWONB+usEhDYIcoz3bCb/1NX3NJNeXydhCjaYRepzTmSr1U7lZmHCCrRPJ5VgJOVJ14wq1ZAeQ5p5NyVGP092iOB0mZ0AiTHuj5kJ4DYyK35r/x/vcQxBOoa44j7X0jcN+YnLTz3umXz5Rp3zPXCNvLaBhxvQkQTTrQLnXfG1ag03IlUOWm78G5IS4hY1X76MXuImqKU8lSNYLG1BnpOwHZblaeZS066QorOtDE74uNRuO5qjtk12NcxT62iJwvlPyehFIlrPU00s4DgC9whq35D4oYAEqUIs4EhXYYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vJAHNDiJyHNRRex64lHiWN6UpjueIv50B+LBTzXOCiw=;
 b=JtkVSA94Wqz2/Fv/dgQWNRCF8Rb2/RRiVK4m+gGcBLc4njXsQYl/db1tb0uMdMomN7wVgp6044ldAVKBbqpGo4xu+OC0GrT2oGLf+e6Tg6i/lCvOudwyjqeQ041mywkmKfAnEKDsRabueehWo7cVNwOy+J2xuPhI+TuxtUrOfUz3xDPGsMoAeopY6CiVBt6m9ZpogsF8aKkSpWimIspxPgH55f4MuiiGlYgAEw0WMNO+cCE9wEo/hPuKn8+bVHTcOP9GO9BW72eCueEO2kwIfwyexqRRjmOhX/ugYSkCrvIYpCv1Ab6+bVg9nLDCz3iE1gRLTm1zjDmQpOP2BvBlew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vJAHNDiJyHNRRex64lHiWN6UpjueIv50B+LBTzXOCiw=;
 b=L9aRCAbT29+VDk2PScj0At/L3T56wKqkjwE7FfwbUvoOfPyC15vLu2OQB8etijna/vi/fqSNBwnBE1liQbTo/JSddtY+65kzZ6NWxAElB/vGOX4QS4IrhnJVnoDBeQVYAYTg1JXLEHDZouFlaaycXtNkYF3oqcQC22LTohR2SWE=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BYAPR10MB2821.namprd10.prod.outlook.com (2603:10b6:a03:85::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Sat, 5 Mar
 2022 12:45:25 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%7]) with mapi id 15.20.5038.019; Sat, 5 Mar 2022
 12:45:25 +0000
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
 <20220301103938.1106808-15-chandan.babu@oracle.com>
 <20220304075133.GJ59715@dread.disaster.area>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V7 14/17] xfs: Conditionally upgrade existing inodes to
 use 64-bit extent counters
In-reply-to: <20220304075133.GJ59715@dread.disaster.area>
Message-ID: <87ilsslg9w.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Sat, 05 Mar 2022 18:15:15 +0530
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0099.jpnprd01.prod.outlook.com
 (2603:1096:404:2a::15) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b03bc799-1f16-4934-26a9-08d9fea604be
X-MS-TrafficTypeDiagnostic: BYAPR10MB2821:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB2821E1CE7D60E5FD21E73EEAF6069@BYAPR10MB2821.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rg0scmZDOeSmb2O5hpI8AX9aK2sJIk9bCBieeFHVr6G1TnPBLbvY5/NYMfe+p0wwX/hgYSWdHpJk+wq3hyRlVxb5CDLL8d0d0b9V4pmbiSnM8hv60SpNi5/PxYS/2vHy6uXBarY8Pr2sYTy7C0ucWPMpxHdextp9mN23VhRAM7oABvLbZxraPzWc8CqzlIeLUM92gvnwtYE+/C8kcASCgxyrDHyDfeKxcpLcyYceaABF8J/NMjn0x+OBuhFSIB7qBhv19apGXHb+fqjyeWvtK4KTfGPDqs/EMYEfD3VuMLD87fSWqr2zjamnHTlX8RX+b75w2pBhd+5UKlahVC6HcpIYo7jOgkgOIvXXUNc8K1o4v+H3X1OnrezFjD/63svNb5/+rOu/yaP6SPNTKpL/kyt8LkOkRmFMpczfyDH4J2KnvjYN9th0F7fG3VIM/kQnP13kLWC6bJ1qpyHa5/z35n9rvK1ZffXtJhhRNMr3/ZgTjHTgcwvPYVaTnC+/l1VpO8e884enUwmLGFj4Qd0F/PYHEvKHHt4u3U39cT0XUlftDR3A/x5u9BJQ4ezZGjU3cDuh/0ufgDaffMzCoXl4dBdbFtrKT8BHNlFsi+4l86+M6zmTOXveROQt6HFFG45Va/KWOH7azg7pQ/LnaVCvZqoAVqmtJ+j7EMu6F/yxQwv+a733qtqxFnHNksYz1KZn3IfZSZMjDDsonUvMNSwLQA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(508600001)(83380400001)(26005)(2906002)(66556008)(86362001)(6486002)(186003)(316002)(66946007)(6916009)(33716001)(53546011)(5660300002)(6512007)(6506007)(52116002)(8676002)(66476007)(4326008)(38100700002)(38350700002)(6666004)(9686003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J1Ow6S1EDX/uNZIW7hDRFiukR6hR0Beb0W2gJkOUk5pC4aZruf1FCVBvNE63?=
 =?us-ascii?Q?Pfc8YZZ+ano8gmgl77+vjALeZHwoG+aCQberVHFByrMG0BhiRmVXpuaK53Tg?=
 =?us-ascii?Q?kJaXMPD2KO03DyXSWb2GkiI5ODEKqyytAi/Yu/eRNgLZUUbla1MzHAawY+m6?=
 =?us-ascii?Q?SbcwT2kBwlRq4aEPn0O4+zQqY6VN7vj8YgPmZeUMThEQqbge/tWzzDF/gn9B?=
 =?us-ascii?Q?uOOV8+xWt4WreSMPgDqAapdr1LhGGuy30iOJjC4FG9jndRkwPvGzSRgoiW8X?=
 =?us-ascii?Q?Z5jL0Vi+QfM7BGJvc+Y4AbKFf7iaAkz/2TmEBC6Y7B0zQNEImokDyrjF+RU1?=
 =?us-ascii?Q?7ppA/eJBQg2sNLBk6Oouq+W3vOqFzs1k5tJqq8kXZyWFfHwMFakzYPK8gp8Z?=
 =?us-ascii?Q?pigQzfVFHxJzOUCIIiFBV/2FcS5wA9XgTZdnZKTLwk1Etsy49dIta5tSHz+9?=
 =?us-ascii?Q?+2bMBJeV/fqhOu9b/9YQWhfqj94wc5uNULLZ3S/6jH3qc+MoOJWRrZDx5n3R?=
 =?us-ascii?Q?xKpfTWfzICwapWNkVEtej1hefn4Ez3n9tUNnfGm5sKU+S6cOLuQfuY6l7om6?=
 =?us-ascii?Q?n1YNkwCeuonO4DQRf9yjVMVgKVgTeEEW6Re9cmeFHbaIjKfezlMuxiWycFVo?=
 =?us-ascii?Q?+U090Q0CYOjMr5L/KWc6fbDF8IrI3Fhy88oQUmDrShYSaRq+WbqzMe3vOwZ7?=
 =?us-ascii?Q?2zdAYw2uBjgT12dvSjw2tklkxEx/MbPf2bgjOSvRKyTwBw9K/VACCGEQh9e5?=
 =?us-ascii?Q?qI4tq1WrGq8FEuR1ZKUbnyx2UeR6vTTZm/7vAXAM24mKwyJ3mNS0xjsa4rOi?=
 =?us-ascii?Q?57Z3lVZqMWrKa39wOV0d7lpTNkOAKHeggy8RKdU3AXF5vK6hiPj41FHIlIdq?=
 =?us-ascii?Q?FwkMzRaynmLiTIYviaE5NlS3N8+wFSzFtLeLpy0UNWoghNH25WLscBzDnW/A?=
 =?us-ascii?Q?x5qRPBC5O3GrBObOXabpDvGVZ33RwgZVszVGtg/ot1V+ZZi5JqQOeWx9gxVb?=
 =?us-ascii?Q?O/uwLr+GmwEqNYjDxkhsq73pIWJiAUwXPebcuY10pDlg4NBzb+BqIJUPsf9E?=
 =?us-ascii?Q?nmR1y5MeGI0Hi+9NOfI1IRdowoO74KNYNEYiH8jV0XimneX2dWBu0JvjIMem?=
 =?us-ascii?Q?Ki+4Yzd/HTOOxSNCIR5KgKp1f/6LzOQvKrn0X7mJVoF0k4NbBqVby3l/U+wD?=
 =?us-ascii?Q?+vOlrA4skluFKqnCxfqn4tsnlHAU+ZlSgcEp7IHDHWRGIMW9BDU4WHZqkO8A?=
 =?us-ascii?Q?AS0bIVbO4tBwN5yCg16WKY4lRcQ5zCRD4NDIupC9TZs6vN+LgVF04bOsudRu?=
 =?us-ascii?Q?fkvndRnuqe4JwFFcdGWJOLAALHdWejpTNGWk1Biorx6bgf4ryTeaof9tze3n?=
 =?us-ascii?Q?clpgr1aIySq9HT+JOI2i4g0cUNo4cty0TUZmbcoDtKAALYNmbXIbmGrXC126?=
 =?us-ascii?Q?cRsYGfPH1DIqtgby8hEa+pzlVBIEAtrzEdi6p4AitQzuVWw1EnN6Swp9o4T+?=
 =?us-ascii?Q?GEm+rB8AmypL+lcDPr5wMoVwo+fOfocR+8lZBCIlzpxSFIlRFezhMjDwvXef?=
 =?us-ascii?Q?3z7RmoslQToYblOCLWaobFSMsrn7WaDSoYB3+D0TFYhcs+m1gHjwxTxjnCCJ?=
 =?us-ascii?Q?olSjABb39QtTSbxNpKMkjFE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b03bc799-1f16-4934-26a9-08d9fea604be
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2022 12:45:25.0981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lhvJ4M2ndeNBAevoQIYJ2X/Tv9IcxUNUZDJhA38dkI8GqyZjRXyx9nmE2ek+0zNccWM1QL+Cd5iqtT88TzaU/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2821
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10276 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203050070
X-Proofpoint-ORIG-GUID: JObNWYu1g4lRoYVRWWn4isPUiOfPAuTe
X-Proofpoint-GUID: JObNWYu1g4lRoYVRWWn4isPUiOfPAuTe
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 04 Mar 2022 at 13:21, Dave Chinner wrote:
> On Tue, Mar 01, 2022 at 04:09:35PM +0530, Chandan Babu R wrote:
>> This commit upgrades inodes to use 64-bit extent counters when they are read
>> from disk. Inodes are upgraded only when the filesystem instance has
>> XFS_SB_FEAT_INCOMPAT_NREXT64 incompat flag set.
>> 
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  fs/xfs/libxfs/xfs_attr.c       |  3 ++-
>>  fs/xfs/libxfs/xfs_bmap.c       |  5 ++---
>>  fs/xfs/libxfs/xfs_inode_fork.c | 37 ++++++++++++++++++++++++++++++++++
>>  fs/xfs/libxfs/xfs_inode_fork.h |  2 ++
>>  fs/xfs/xfs_bmap_item.c         |  3 ++-
>>  fs/xfs/xfs_bmap_util.c         | 10 ++++-----
>>  fs/xfs/xfs_dquot.c             |  2 +-
>>  fs/xfs/xfs_iomap.c             |  5 +++--
>>  fs/xfs/xfs_reflink.c           |  5 +++--
>>  fs/xfs/xfs_rtalloc.c           |  2 +-
>>  10 files changed, 58 insertions(+), 16 deletions(-)
>> 
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 23523b802539..03a358930d74 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -774,7 +774,8 @@ xfs_attr_set(
>>  		return error;
>>  
>>  	if (args->value || xfs_inode_hasattr(dp)) {
>> -		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
>> +		error = xfs_trans_inode_ensure_nextents(&args->trans, dp,
>> +				XFS_ATTR_FORK,
>>  				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
>
> hmmmm.
>
>>  		if (error)
>>  			goto out_trans_cancel;
>> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
>> index be7f8ebe3cd5..3a3c99ef7f13 100644
>> --- a/fs/xfs/libxfs/xfs_bmap.c
>> +++ b/fs/xfs/libxfs/xfs_bmap.c
>> @@ -4523,14 +4523,13 @@ xfs_bmapi_convert_delalloc(
>>  		return error;
>>  
>>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>> +	xfs_trans_ijoin(tp, ip, 0);
>>  
>> -	error = xfs_iext_count_may_overflow(ip, whichfork,
>> +	error = xfs_trans_inode_ensure_nextents(&tp, ip, whichfork,
>>  			XFS_IEXT_ADD_NOSPLIT_CNT);
>>  	if (error)
>>  		goto out_trans_cancel;
>>  
>> -	xfs_trans_ijoin(tp, ip, 0);
>> -
>>  	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &bma.icur, &bma.got) ||
>>  	    bma.got.br_startoff > offset_fsb) {
>>  		/*
>> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
>> index a3a3b54f9c55..d1d065abeac3 100644
>> --- a/fs/xfs/libxfs/xfs_inode_fork.c
>> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
>> @@ -757,3 +757,40 @@ xfs_iext_count_may_overflow(
>>  
>>  	return 0;
>>  }
>> +
>> +/*
>> + * Ensure that the inode has the ability to add the specified number of
>> + * extents.  Caller must hold ILOCK_EXCL and have joined the inode to
>> + * the transaction.  Upon return, the inode will still be in this state
>> + * upon return and the transaction will be clean.
>> + */
>> +int
>> +xfs_trans_inode_ensure_nextents(
>> +	struct xfs_trans	**tpp,
>> +	struct xfs_inode	*ip,
>> +	int			whichfork,
>> +	int			nr_to_add)
>
> Ok, xfs_trans_inode* is a namespace that belongs to
> fs/xfs/xfs_trans_inode.c, not fs/xfs/libxfs/xfs_inode_fork.c. So my
> second observation is that the function needs either be renamed or
> moved.
>
> My first observation was that the function name didn't really make
> any sense to me when read in context. xfs_iext_count_may_overflow()
> makes sense because it's telling me that it's checking that the
> extent count hasn't overflowed. xfs_trans_inode_ensure_nextents()
> conveys none of that certainty.
>
> What does it ensure? "ensure" doesn't imply we are goign to change
> anything - it could just mean "check and abort if wrong" when read
> as "ensure we haven't overflowed". And if we already have nrext64
> and we've overflowed that then it will still fail, meaning we
> haven't "ensured" anything.
>
> This would make much more sense if written as:
>
> 	error = xfs_iext_count_may_overflow();
> 	if (error && error != -EOVERFLOW)
> 		goto out_trans_cancel;
>
> 	if (error == -EOVERFLOW) {
> 		error = xfs_inode_upgrade_extent_counts();
> 		if (error)
> 			goto out_trans_cancel;
> 	}
>
> Because it splits the logic into a "do we need to do something"
> part and a "do an explicit modification" part.
>

Ok. The above logic is much better than xfs_trans_inode_ensure_nextents().
Also, I will define xfs_inode_upgrade_extent_counts() in
libxfs/xfs_inode_fork.c since the function is supposed to operate on inode
extent counts.

>> +{
>> +	int			error;
>> +
>> +	error = xfs_iext_count_may_overflow(ip, whichfork, nr_to_add);
>> +	if (!error)
>> +		return 0;
>> +
>> +	/*
>> +	 * Try to upgrade if the extent count fields aren't large
>> +	 * enough.
>> +	 */
>> +	if (!xfs_has_nrext64(ip->i_mount) ||
>> +	    (ip->i_diflags2 & XFS_DIFLAG2_NREXT64))
>> +		return error;
>
> Oh, that's tricky, too. The first check returns if there's no error,
> the second check returns the error of the first function. Keeping
> the initial overflow check in the caller gets rid of this, too.
>
>> +
>> +	ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
>> +	xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
>> +
>> +	error = xfs_trans_roll(tpp);
>> +	if (error)
>> +		return error;
>
> Why does this need to roll the transaction? We can just log the
> inode core and return to the caller which will then commit the
> change.

Transaction was rolled in order to make sure that we don't overflow log
reservations (computed in libxfs/xfs_trans_resv.c). But now I see that any
transaction which causes inode's extent count to change would have considered
the space required to log an inode in its reservation calculation. Hence, I
will remove the above call to xfs_trans_roll().

>> +	return xfs_iext_count_may_overflow(ip, whichfork, nr_to_add);
>
> If the answer is so we don't cancel a dirty transaction here, then
> I think this check needs to be more explicit - don't even try to do
> the upgrade if the number of extents we are adding will cause an
> overflow anyway.
>
> As it is, wouldn't adding 2^47 - 2^31 extents in a single hit be
> indicative of a bug? We can only modify the extent count by a
> handful of extents (10, maybe 20?) at most in a single transaction,
> so why do we even need this check?

Yes, the above call to xfs_iext_count_may_overflow() is not correct. The value
of nr_to_add has to be larger than 2^17 (2^32 - 2^15 for attr fork and 2^48 -
2^31 for data fork) for extent count to overflow. Hence, I will remove this
call to xfs_iext_count_may_overflow().

-- 
chandan
