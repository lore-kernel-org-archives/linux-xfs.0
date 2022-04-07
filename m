Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5486AC433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Apr 2022 08:20:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234093AbiDGIWU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Apr 2022 04:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242871AbiDGIWK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Apr 2022 04:22:10 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6157C157598
        for <linux-xfs@vger.kernel.org>; Thu,  7 Apr 2022 01:20:10 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2376uBRK024505;
        Thu, 7 Apr 2022 08:20:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=iRVPSE1eyVBHH5m4sIu/325+NQGDAqdHq+hSCRQjRl8=;
 b=UiKnUh5x2lZBy/td23yeJ7eluaYncFKB1V5Z5p4OZDjXpjw2LzqjVZTYgFp/1pBJyNVP
 tSPMq7LBAUj56jDj6pPfp07k+AURHVWVhbkJ+NW3a3TVnsb43mLME77z7z6kqZvALw14
 +I8+Lb+o7Pn4bEPX/XuFGw64ZTHGCv0tfnUUsJGKVn7tid8UcuZeYARavaEwC+lJJtn3
 FPtlmkBpLfk3DDTFeqHN+/JS8Zf5HSxX0hF8/orMHqiRz6pbni5mkbOdML7dnmdnMa5h
 6CC8rqXeUTN8wVsXlxaTsdEbKTFw/QNddnMGfb4Ot73pDOIQ/j9btGlSerhytnxs+8Um Ug== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6f1tbb1t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Apr 2022 08:20:07 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2378AlFl025311;
        Thu, 7 Apr 2022 08:20:06 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97y78s3e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Apr 2022 08:20:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c3165Rop4RxV7xHTI+1nHaYapFLiIbbuilAQw9rafOpnJpiEeUq8lhMo9WTXv92hWS9DP5jm28n9Kd1t9A0a3NHz3XOvJk9VV3CHOOdM/e1KVGgeSF6k2Rq01j1lN+x9VYBtx4mYYI3fJ0AZPbVfZe4ak3QvHLAXjLuG1obPdxxN9ol1EfkrqGR9nSkYfrDFazIhAlh3bpUWbrMSrCxQhdv1K9UoATKxmEmKpKQQImutX7BVQyfyaeDUZs1N1b9XWax6Lrj6MY8vS7cNBeC8QfNO3PBba/zf/BNC0laI2hrbQDjl9QalcOdOCnUEMFBmHR/FEj0HQEICZkC6+uR26A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iRVPSE1eyVBHH5m4sIu/325+NQGDAqdHq+hSCRQjRl8=;
 b=ZiNojBn8O3O5zBpvYzi6gfKZbUoa4bxZB80n8MYYQiLOJvO/bL+5GVAdJLr/sfncjQGHemVOgUMdGzPo8t+6f7owAvi/u+Hifw9hpPn2F3vDiGY0fmEWe9BfeVU4zz7DSkgFWG7OC3L7BvjROFc0l/jpyFTU+HJQchbjLGoeOb5Nr0xaH6vRTVV1E2pOYxMTunwUAmpU5dtVGnuzacOJkg2RFR1GAMW29Hfi5+VXk4jqvSdMFAiG2LwX9gaGzgwr3BwhL34RNIrsQrT6b6UxJJXBKuSMUaMFUsKwCMYl5WeuF3bEvmkDI+XOOO5aqfGgjM3b41WQijc47RHz+bwM0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iRVPSE1eyVBHH5m4sIu/325+NQGDAqdHq+hSCRQjRl8=;
 b=HOiQCRvmwxDoEEwYOYX/KAAAaLypfUtNa/d0YbD2g9BbFivGPp7/UZzuvx9r0ZYNxD6vQOZ3k+hQqiuf7n4LR6XyGBtQjb4Qfu0C2prL94v68JlF3BLD8F4aOn3VAgV5pSYV1ok2Ur6yHaDzKvD23WydE8/h7mRqeuOUil6Y0zE=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SJ0PR10MB5613.namprd10.prod.outlook.com (2603:10b6:a03:3d0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21; Thu, 7 Apr
 2022 08:20:04 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d%8]) with mapi id 15.20.5144.021; Thu, 7 Apr 2022
 08:20:04 +0000
References: <20220406061904.595597-1-chandan.babu@oracle.com>
 <20220406061904.595597-17-chandan.babu@oracle.com>
 <20220407014627.GV27690@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V9 16/19] xfs: Conditionally upgrade existing inodes to
 use large extent counters
In-reply-to: <20220407014627.GV27690@magnolia>
Message-ID: <87a6cxxq39.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Thu, 07 Apr 2022 13:49:54 +0530
Content-Type: text/plain
X-ClientProxiedBy: SI2PR06CA0013.apcprd06.prod.outlook.com
 (2603:1096:4:186::18) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 608948a5-4f3b-40fd-5a5f-08da186f6acb
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5613:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5613120CD0290C5A588108F2F6E69@SJ0PR10MB5613.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QJxAF1SOrMuHsYZo2nLhPuRot0Ph6HAhnlgESNYmkaumBHDSudLBhtlZN79SzZOIv0FctjnBM4t85cOOMfhXbIrzI65FVgUJw/OT7nU7+ykptiqnSXkFiOksOw6/hoGb7obq9OwuNc1n3tCXCROT0JamUysrWffWT6sb3pjjwiZ7aGHDRIx+qD93lgS+D34AVeYb4G0SpWfc5h/LZNPFCBKnfc5eLmsXrZfAeoL6CmfVAslEKCLUDapcdRymZ6ikxxn1FzE4Ssq2VyBILQj98vDuBU35UO+K9y9cWnW2eMox3kh0KEMqPeEFY1hsF4xZOM4CdWFnPKGV7yAh61meEGsQwxWaHz4Bo07DjTwZtknc3SUN3s/UicWKV2jiZNo+otQ2c1pe/L94I95Yn+U9eLp8WY4pg4c//8vsQGEwHCF+Zb8evbAFduFxiyVSEZJGFHdr22+jYmWHpzYPOrwljXeNU+1vf+oDh1YQVjb3Tau6yu0Fo4iqfSgaYP2WntsX5rdd32Y+TiEriu60lCs/MT6OrF4qMpC1G4p3t/d5ErF98BO7u4bD7QbdD9fH8NnBq4/5+4TWQbMjlfapq+NsbpqnF82xx9qiCU+KJSECR1bus4lC7xUkoA2P+X5yE7PEcYI4nw7HNnRonXWu47rEOsz3Qz+sbfoYpfHyBZ+vvoNaRuM73/NIIYxJT1VXDvoXmnVo6RuqQKhukzpWusgTj7pklE5F0W+k+6SkZHGX5coNkSVWvR4jKaPkRxYZEVTs6kPAHkdvqSUbIw1OvysGw9OhA2nRz+bU79bKqw3kfNA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(83380400001)(6486002)(38350700002)(33716001)(508600001)(38100700002)(8936002)(5660300002)(2906002)(66556008)(4326008)(316002)(86362001)(9686003)(53546011)(52116002)(26005)(6512007)(186003)(66476007)(66946007)(6916009)(8676002)(6666004)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r+S3Xfd4ujWWmhjzsgRSgV1I5/mrUp2Yf5DRFuDjPXisnQGXEHJKZ9wBeyP9?=
 =?us-ascii?Q?6LHSpBb1AjPOAlRwRBlPGja2DySaWqcUcVpSXzbq2LNNEdIsVkBKA6NbkPol?=
 =?us-ascii?Q?TG3bCmFCCmgn4mTRMVNzKBglH34/wygnnMmczxu3B1H7Xqrf77YmgVOxQ7iT?=
 =?us-ascii?Q?Vi4KYd+HUfTw28Ea/VXt2J4GCRXSXjb8KlH9PdqjL23FmRhDMngfepv654iP?=
 =?us-ascii?Q?IVZXaSX5E69YAa30BAWBPyFo5LQxCI/ortzGHMsQe5LfsXu0llqbODgnjtRh?=
 =?us-ascii?Q?2kTJo1xu3Lmx/rbmYNTKmjTmOWgUHD99MscVDOvcQNuITI1wSVIhsbx1Ta0W?=
 =?us-ascii?Q?/gmGbTU7nyvlD+fJrPeQzfpHeLHlVVW+5jUYwqlnLu7Bazzrg6zQIekJESG4?=
 =?us-ascii?Q?Gvod0KuBtAWqifU7cjs/QPzJQb/wTSKMLNzY/VtrrYvDe5HNs6g2q1plATc8?=
 =?us-ascii?Q?hKsd7u7Q4EGl17uFJhQWxSF492jXWHCvFTL6AnM80N8FriaIQ2ku4Mm9U9Hb?=
 =?us-ascii?Q?mX7Gu9zMfwJHx6FWKmyX0uN8VwaqpJ1r1hEjKzOP3vfT0m5FVWx5IgSLHmPf?=
 =?us-ascii?Q?pI6tBfNDWhrFTYs48ydQe58L0lZNDxS5ketjxu9j6pJVRXLBF3kh2Wm4idLD?=
 =?us-ascii?Q?jS2I5Mr4hHxWjv8hXP/FoXGyEHj8ZbfsKrXyHfu5aUds18uSxrPqIPUpfNO+?=
 =?us-ascii?Q?HMs4dnkNTq/T2Udw0Lu0s2EVHdoIGTkHCacWdc9sBsjKFdqUi8NNvylDykwT?=
 =?us-ascii?Q?G8CQ+3jvx34r4f2D9wj2toVOx4Jv3d1s8Zgl16KetoVzpdfvm7q+fSwwVfx2?=
 =?us-ascii?Q?KPNTctyWuMxoBigzk73usSi9BK9+om/nBTkI/39RG0mFUHncOLW1Chvwr83M?=
 =?us-ascii?Q?laugvtzBocBlhdbfvlRoBGL3AjkQgOXEjBSnfro7C93lWLNuYrdhiu9vxND/?=
 =?us-ascii?Q?Ixg5SKu2LqSMgkONeRoVgKqShn/wnzKvi9qOdKzCnhCxr56QCQZDiOCa+oc/?=
 =?us-ascii?Q?qIWk3ybdqiZgCn8o1u/Pjid7GEpew8vdHhCICNQNMUKyZpejEEcUOq46wpT0?=
 =?us-ascii?Q?AnZyusksJ0SbSzDtATp64qcBGUqKVRgScEj08nT+xLxrY5Mhjh8+824sHpmj?=
 =?us-ascii?Q?b5fKUJKyNnA5RI3WWXgc+bx75nTLW52aDe28ee0sSY76U/+4xPEg0Oayz9+Q?=
 =?us-ascii?Q?UZQN+Xbi1/4Mf3oJZxpxobNwJrtbFaRwO+QtyflE8RNEhIhqF0iM3LlshOtI?=
 =?us-ascii?Q?Vz2u7aiO53me2dxuiI8/81Ly/d/Bpm3jcRrwUSPEBZBm+olLyyMPveO2uICZ?=
 =?us-ascii?Q?OD4VKYuFtV/2RBvhMeZ9e9uOzvsr5cPHhjXVdLcSVQH6w7kFJN88BJIEdVTX?=
 =?us-ascii?Q?ZU77xzV5tN5jZmoDQDbVFGJnOW8ksKDruMZAMhr03S6WIFWHHQAbO6dBizqr?=
 =?us-ascii?Q?p5Wx63liSO3yENSAaTOu80eD6lDUjlt9m+bJf1kUg6oQQF+IOx6aLYQIna1P?=
 =?us-ascii?Q?nuhggbJSyYOhlIYTqMDiA+1LwyDau+0zzC1YAivTvdy9irTM8y5Fr4fOmPRz?=
 =?us-ascii?Q?yyxK9jyayuWxtVvzSCRXNTExWdk/x/4e1v4Jc8a1h1t1YzmQ17ujXgtE+QLF?=
 =?us-ascii?Q?QCnlLpH4xsLrWvJf1fyhGE/o/+QYH3uLFeuLdlv1n3M/P2ek2WmN+tXt2uqQ?=
 =?us-ascii?Q?iqBwejuBSFbvUXdqTqN0JM2k4x9PPmgCdxNs1cbuHWmtzRdP+HMYZLROXW/M?=
 =?us-ascii?Q?Xqf+VtphLU0pFohFXULzn+Z2mNCiP/4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 608948a5-4f3b-40fd-5a5f-08da186f6acb
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 08:20:04.1162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1r+BzVY+E46Lh5IT+qgNOCAy2TNzEQWLbF1IAmpB3mRla0yurlBCD7BryH14KzkvHkhQMjyoq9gQtC7G9rFqXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5613
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-06_13:2022-04-06,2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 spamscore=0
 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204070042
X-Proofpoint-ORIG-GUID: R7zf96m5PX7ZosC7FxWTiqensTjGSIXY
X-Proofpoint-GUID: R7zf96m5PX7ZosC7FxWTiqensTjGSIXY
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 07 Apr 2022 at 07:16, Darrick J. Wong wrote:
> On Wed, Apr 06, 2022 at 11:49:00AM +0530, Chandan Babu R wrote:
>> This commit enables upgrading existing inodes to use large extent counters
>> provided that underlying filesystem's superblock has large extent counter
>> feature enabled.
>> 
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  fs/xfs/libxfs/xfs_attr.c       | 10 ++++++++++
>>  fs/xfs/libxfs/xfs_bmap.c       |  6 ++++--
>>  fs/xfs/libxfs/xfs_format.h     |  8 ++++++++
>>  fs/xfs/libxfs/xfs_inode_fork.c | 19 +++++++++++++++++++
>>  fs/xfs/libxfs/xfs_inode_fork.h |  2 ++
>>  fs/xfs/xfs_bmap_item.c         |  2 ++
>>  fs/xfs/xfs_bmap_util.c         | 13 +++++++++++++
>>  fs/xfs/xfs_dquot.c             |  3 +++
>>  fs/xfs/xfs_iomap.c             |  5 +++++
>>  fs/xfs/xfs_reflink.c           |  5 +++++
>>  fs/xfs/xfs_rtalloc.c           |  3 +++
>>  11 files changed, 74 insertions(+), 2 deletions(-)
>> 
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 23523b802539..66c4fc55c9d7 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -776,8 +776,18 @@ xfs_attr_set(
>>  	if (args->value || xfs_inode_hasattr(dp)) {
>>  		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
>>  				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
>> +		if (error == -EFBIG)
>> +			error = xfs_iext_count_upgrade(args->trans, dp,
>> +					XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
>>  		if (error)
>>  			goto out_trans_cancel;
>> +
>> +		if (error == -EFBIG) {
>> +			error = xfs_iext_count_upgrade(args->trans, dp,
>> +					XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
>> +			if (error)
>> +				goto out_trans_cancel;
>> +		}
>>  	}
>>  
>>  	error = xfs_attr_lookup(args);
>> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
>> index 4fab0c92ab70..82d5467ddf2c 100644
>> --- a/fs/xfs/libxfs/xfs_bmap.c
>> +++ b/fs/xfs/libxfs/xfs_bmap.c
>> @@ -4524,14 +4524,16 @@ xfs_bmapi_convert_delalloc(
>>  		return error;
>>  
>>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>> +	xfs_trans_ijoin(tp, ip, 0);
>>  
>>  	error = xfs_iext_count_may_overflow(ip, whichfork,
>>  			XFS_IEXT_ADD_NOSPLIT_CNT);
>> +	if (error == -EFBIG)
>> +		error = xfs_iext_count_upgrade(tp, ip,
>> +				XFS_IEXT_ADD_NOSPLIT_CNT);
>>  	if (error)
>>  		goto out_trans_cancel;
>>  
>> -	xfs_trans_ijoin(tp, ip, 0);
>> -
>>  	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &bma.icur, &bma.got) ||
>>  	    bma.got.br_startoff > offset_fsb) {
>>  		/*
>> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
>> index 43de892d0305..bb327ea43ca1 100644
>> --- a/fs/xfs/libxfs/xfs_format.h
>> +++ b/fs/xfs/libxfs/xfs_format.h
>> @@ -934,6 +934,14 @@ enum xfs_dinode_fmt {
>>  #define XFS_MAX_EXTCNT_DATA_FORK_SMALL	((xfs_extnum_t)((1ULL << 31) - 1))
>>  #define XFS_MAX_EXTCNT_ATTR_FORK_SMALL	((xfs_extnum_t)((1ULL << 15) - 1))
>>  
>> +/*
>> + * This macro represents the maximum value by which a filesystem operation can
>> + * increase the value of an inode's data/attr fork extent count.
>> + */
>> +#define XFS_MAX_EXTCNT_UPGRADE_NR	\
>> +	min(XFS_MAX_EXTCNT_ATTR_FORK_LARGE - XFS_MAX_EXTCNT_ATTR_FORK_SMALL,	\
>> +	    XFS_MAX_EXTCNT_DATA_FORK_LARGE - XFS_MAX_EXTCNT_DATA_FORK_SMALL)
>> +
>>  /*
>>   * Inode minimum and maximum sizes.
>>   */
>> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
>> index bb5d841aac58..1245e9f1ca81 100644
>> --- a/fs/xfs/libxfs/xfs_inode_fork.c
>> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
>> @@ -756,3 +756,22 @@ xfs_iext_count_may_overflow(
>>  
>>  	return 0;
>>  }
>> +
>> +int
>> +xfs_iext_count_upgrade(
>
> Hmm.  I think the @nr_to_add parameter is supposed to be the one
> that caused xfs_iext_count_may_overflow to return -EFBIG, right?
>
> I was about to comment that it would be really helpful to have a comment
> above this function dropping a hint that this is the case:
>
> /*
>  * Upgrade this inode's extent counter fields to be able to handle a
>  * potential increase in the extent count by this number.  Normally
>  * this is the same quantity that caused xfs_iext_count_may_overflow to
>  * return -EFBIG.
>  */
> int
> xfs_iext_count_upgrade(...
>
> ...though I worry that this will cause fatal warnings about the
> otherwise unused parameter on non-debug kernels?

> I'm not sure why it
> matters that nr_to_add is constrained to a small value?  Is it just to
> prevent obviously huge values?  AFAICT all the current callers pass in
> small #defined integer values.
>
> That said, if the assert here is something Dave asked for in a previous
> review, then I won't stand in the way:

It was me who added the call to ASSERT() in V7 of the patchset. This was done
to catch any unintentional programming errors.

Also, I found out today that Linux kernel build does not pass either
-Wunused-parameter or -Wextra options to the compiler
(https://www.spinics.net/lists/newbies/msg63816.html). Passing either of those
compiler options causes several "unused parameter" warnings across the kernel
source code. So we should never see warnings about nr_to_add being unused on
non-debug kernels.

>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>

Thanks for the review! I will include the comment for xfs_iext_count_upgrade()
that you have suggested above and I will also replace the open code that you
have pointed out (in the your next mail) with a call to
xfs_inode_has_large_extent_counts().

-- 
chandan
