Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 227E7C433F5
	for <linux-xfs@archiver.kernel.org>; Sat,  5 Mar 2022 12:45:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbiCEMpu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 5 Mar 2022 07:45:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbiCEMpt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 5 Mar 2022 07:45:49 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DAD1CC7FF
        for <linux-xfs@vger.kernel.org>; Sat,  5 Mar 2022 04:44:57 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2259kxqB010192;
        Sat, 5 Mar 2022 12:44:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : message-id : in-reply-to : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=RVwroZg/Dm92JK+Ss7U4+z9Lpq8+c3D9v7xgr2FigLI=;
 b=aMbtdaQa6PJji33FH1AsrELuQM9egsMN5ec7FFDu0ylNvE1w+avqlXyLrigHnE2f0g0P
 IpBIjMvSy1Gls8SkRTg2q4j2kdr1kjVz/tOk4gxSi15umDjQAVE5/s1MM5upIyjeTj6X
 bAR/Hv3TCLbE0EYbOENHsjWA+DRhqalzfunKT72zxN4IN4YUjYD0oViRBy4pOFHUMz17
 l0GRgqPJwJ681hdC4eL8xKOerwZKA3JSToVPvKWMHfKXdOwc1C2Sqn1DVo7TUbmfQ/Jv
 4hWizu99nIuAOceVRyaN6UZowDNX/iN/RycFKlGEscW4uaRg5lmn6snxHlt7qFRpER7K PA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekx9c8q0s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 05 Mar 2022 12:44:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 225CaQMJ137025;
        Sat, 5 Mar 2022 12:44:51 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by userp3020.oracle.com with ESMTP id 3em1afsssj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 05 Mar 2022 12:44:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LLrFS02dF7U1lkdo/euTNP1nacAqvgsqzuYSaYe0cakP7RIlQo37MnU18+ZyuBQqBGBaENrW28tbeOoPMFE2NjYzowMSc5dbXHnwvx2y2N6XU0sAsDp0FMHkS+zwlKUgaheA1L2o7Q8KyLd/eg/W7l4jaqMVy+SGyxV4r+rKG9tiFrrxTULMOdqhTq6N7KnhmEvO/sqSPeyal2eoIauo0VEIPekoCFHuN4vf5Qw4t8Nneg7ZeBwctN59UWm6ZEe1cXo7z/BFSiWiTdfsew2WmnYL0k3IX0lLMz4S3+3SVQCopabwpoh8h4sWDTQKF+tOEUT/Tr1thdcSchFhHt4DrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RVwroZg/Dm92JK+Ss7U4+z9Lpq8+c3D9v7xgr2FigLI=;
 b=XFxK1sp3Gq9cLGRgPLk/sRgHUmnPba7atLBqaSKQyGgzLLLuriwem75fokHQzW12frJlhhBSOQ6+YGe76vH18FRIiuPObl68sbgo/2iJfpa98+cozOoNSSxV+p/A2guhHKrWzRW4RWRdS8KKGwC+/IBhZ9bANrogUEyhdcbuhT+iI6qeEuz5XrDpgKpwOalsuZYu8MEBklyxcDs2IDBfxO9Zq2/i2hF4awJiNt9f57DCLBn2GEa9FmWDWuBRe0l8JVqC7f0uTG5RTQhhPC8Payh87kanuznc3OyJt8mZqSctdUqgc0dj4wlqJ5iAs8yPvxfdCZ8pNxJysJSCFtWXGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RVwroZg/Dm92JK+Ss7U4+z9Lpq8+c3D9v7xgr2FigLI=;
 b=dv1nFO0b+pIpNuiXOqB/QjxxPDALcL89ewRASfesORBMHRjZ62Mh4EsWaWjERVjFHOcewZ5XiZ8q45Qutx7Fx4QT9xF6ZOXuJAaqsSeyfAdVav3m3CxXXE8okXBPWO7Sia3B9FFdcEFFBBzJZ56P3NcMnpn0qQ04pdEXfSODGkY=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BYAPR10MB2821.namprd10.prod.outlook.com (2603:10b6:a03:85::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Sat, 5 Mar
 2022 12:44:48 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%7]) with mapi id 15.20.5038.019; Sat, 5 Mar 2022
 12:44:48 +0000
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
 <20220301103938.1106808-13-chandan.babu@oracle.com>
 <20220304071427.GH59715@dread.disaster.area>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH V7 12/17] xfs: Introduce per-inode 64-bit extent counters
Message-ID: <87zgm5g1hq.fsf@debian-BULLSEYE-live-builder-AMD64>
In-reply-to: <20220304071427.GH59715@dread.disaster.area>
Date:   Sat, 05 Mar 2022 18:14:38 +0530
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0019.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::10) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c200c4ca-3e68-4895-4500-08d9fea5eeaf
X-MS-TrafficTypeDiagnostic: BYAPR10MB2821:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB282177AF3264D232DE5F44AFF6069@BYAPR10MB2821.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M4dl2JeiiSCnc4A9PgQ5iu+MMtTAL+bDvTIW94pUtYuROGeCFC+mBL9WMsmoqjC7z/0bZIlvE3eK4rgH+k332qLZtSZ5jhhaCi+zCwJMkpjfB0dM/Y+mL3CcF114cp1dOiziwQvHwK8k8JTBHmZjUGX+hRFSlbiMo+RHIKFroKktbBDID9Z/Wa0gQo2XpiPh6AOw8MepH5smb2dCGeghPOBXlMKQQFgu3v86TGDIyF4MvaMgjkeV7hySIEV+5hNXNvawQMxbXH2ubj9b3CYDL5NAYIoap4UHvn6a41fuZCpurpl4bgfVp9r6MdwvYsoRpoqrBbpN6iEjWS5EE1aU1O6SLf3ewof9QsPc8BTLQvYngJ9svjPGWqD9Ap4jHyuvmkL1UhIza052D6f2mdEjm+4XJBXcSOzENZg4TyclV/RG/6sJfyu/mKrCUb+UZc2JWViFSbu69YMVB/b+49TxSIRsgKGP/3Qe6GC7lKIAYJDO6waU5hnkgWNnBZ4/JU81Uqsd5TxlKevoqxDZIGOD7IzxsBqHncw8ijfBoLGweMsHdhwfaxCIA1HJGkSu0Jl705xzjBVzgIFglmGrcl2KsPTpkHOpZicnkY1hfnG+tEoyien1R0FEtHGH/1KwzuaHYO5Z/hBLHSWwQ40acmMZfMQNE2f+xcwtrKVgNDzUqoE6Yw/gV+BvS6Alan3L2Hc3iiZXCZWjLGVh0A/ZFgH2lA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(508600001)(83380400001)(26005)(2906002)(66556008)(86362001)(6486002)(186003)(316002)(66946007)(6916009)(33716001)(53546011)(5660300002)(6512007)(6506007)(52116002)(8676002)(66476007)(4326008)(38100700002)(38350700002)(6666004)(9686003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5R9OT4YbbW7q6EmmjbAYOrV3fFEbODYVR27WDGzdFRsKWjZXwtYE5Og2MSr7?=
 =?us-ascii?Q?0iNWBsl6eL2kdrbBXXazV6vyUdqwL0HvcJb1JqF4yl3pw3Ycq1uzi0Y3YtnG?=
 =?us-ascii?Q?OB2GUHDvNdyQGyHQSsQwEvMrz66oHboEJNqTRAUOu8ac2Qzq5fvE8Xd62VPE?=
 =?us-ascii?Q?hA4c3IsmdccrAxByNGbMF/TT/dr83CVDJuuq06eKhej/+Ikvn9eRJhFZjYQX?=
 =?us-ascii?Q?UoGsHN2M7Ff9N2rvB0FODDiwe4Bfq+Bqi6uGNKkAaK2elD4FCEK/NW5AE3ss?=
 =?us-ascii?Q?49ffYfC8vJ69WHRzEYVoK6KeljIiLpXg03juy8rXeKoBN/EFa0Y9mv/GeLHx?=
 =?us-ascii?Q?5GbKxHJLzNLMkGZqdDz3FN+hOd6VGpcXebQ59zGS1SqEZrJpApToZNCkpBUz?=
 =?us-ascii?Q?XJkHPP5j12CcBtEU9IvWY8uwiULkXWNLkormYBtFR4w0sjtiwnMNX7xfRkNe?=
 =?us-ascii?Q?gTZgaksoZSbZHYrAYdhJEIElJ7RHGO7GbnY2ZLqD0urbMfUKSeRXkgAHxFuc?=
 =?us-ascii?Q?KmVg5JSo6LCW2XSaLe43poLcJ3cAYu48QFAOXFsunPzI/BztJgNJDnIfbPm8?=
 =?us-ascii?Q?Yqu61+hCr1WuICTFYrFAH0QRBSDPCNpOss5G5LXd1QkFG8KAHQZLKuqOB556?=
 =?us-ascii?Q?Woz9U5cZ3J5EfdDjf/70M5E1QEsE44+yV75F8F2udqnkJ+SfS03AoL87oLwg?=
 =?us-ascii?Q?1JZUxvmKHmeuI0GdmTVk8slgqoCyj+wyqqje4RGI4IgePMjUXUdk0f7R/O3T?=
 =?us-ascii?Q?oaeCVYsqsCBuW7Xeb11sxPxjV5aJYWEh+N3EKSO+ffNLebN8xU3+/o6CYIQl?=
 =?us-ascii?Q?Ie+5zhHwlBF9/kjMf1A86JyCNa4pBD6lxxMt+VR5YFEVgIF3QC7B7K73y3fp?=
 =?us-ascii?Q?y0HppuGthNQX+8kj3xyidhAL/R8IBIWqCsKOVec7VcupmufEEvXUpMDT6zEe?=
 =?us-ascii?Q?qT1qhQ6AV4HBibMM10Ia+c+fdKCnvXBtIM8H0vTzf8Lu/XdjbgQ5kVJqbmSW?=
 =?us-ascii?Q?yflAvte07Mn6lRW9uDXdMuMAOIv5wYoh0IgDgGzlFHm1VQUbIink004+49RF?=
 =?us-ascii?Q?TnkniZbjrS+aR5Sjh2hdc9sf+LyDI/R9YaPH1Cs6/i77ujz7Pa9lsBgNV1wM?=
 =?us-ascii?Q?nMDe9RonfRepulOlyn2dHtmGJDWdGsyYFtFpoLbkluvBvHBu+pgvv4QgQKl5?=
 =?us-ascii?Q?g63UeqC3sCe95EM8Pk/8Ron3LaZyuwNpotV8utIsPV0mcTeMDsBKV6cwxMX7?=
 =?us-ascii?Q?NLpcwSEK53GbHQ403NlzS7nSBybINbjv4vsbRhloEhHUbt/XZs0x8jlSydWG?=
 =?us-ascii?Q?S5SXBG2jAzskDI4RlQdLbBUnCoMZChFQ0NJay9TDca9PkkbiTps//4LUPg/i?=
 =?us-ascii?Q?7fvTPE8LC5cCMZ5nXzOxE1KU3qgoxOAHpnEtxNL6hNvoTBv6Yxayf/GnPTcp?=
 =?us-ascii?Q?h84+13rcw6CSfK7cogTwFOOCKwCoGNRtviVmrea9I0gqapNdQ6VpQ52JvZl7?=
 =?us-ascii?Q?pi0QXc42a7GHjdGuND6wegHScCJQTwBcvCqRcgjQo4xegMWDwm/1gZ9JE+wD?=
 =?us-ascii?Q?bglRSc3hGyTi/vccW/qpbbC7+3XoDZKAS8OHitXyeazEA+abjs+fd9iOZuWg?=
 =?us-ascii?Q?pG8hyZ9iI35kJG78YBA1wpQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c200c4ca-3e68-4895-4500-08d9fea5eeaf
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2022 12:44:48.0126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YRw0yQOwsbXniGn4w9yTiOkZvWNAHt4TesNqOYYKQ9+Isl4HY1Cq3GX/NUI6523lREm12WzRNVa8BxVmS2E5+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2821
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10276 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203050070
X-Proofpoint-ORIG-GUID: wIjpf_wsz2zBPqQ1JExdH5nLMTG1ttbl
X-Proofpoint-GUID: wIjpf_wsz2zBPqQ1JExdH5nLMTG1ttbl
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 04 Mar 2022 at 12:44, Dave Chinner wrote:
> On Tue, Mar 01, 2022 at 04:09:33PM +0530, Chandan Babu R wrote:
>> This commit introduces new fields in the on-disk inode format to support
>> 64-bit data fork extent counters and 32-bit attribute fork extent
>> counters. The new fields will be used only when an inode has
>> XFS_DIFLAG2_NREXT64 flag set. Otherwise we continue to use the regular 32-bit
>> data fork extent counters and 16-bit attribute fork extent counters.
>> 
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> Suggested-by: Dave Chinner <dchinner@redhat.com>
>> ---
>>  fs/xfs/libxfs/xfs_format.h      | 33 ++++++++++++--
>>  fs/xfs/libxfs/xfs_inode_buf.c   | 49 ++++++++++++++++++--
>>  fs/xfs/libxfs/xfs_inode_fork.h  |  6 +++
>>  fs/xfs/libxfs/xfs_log_format.h  | 33 ++++++++++++--
>>  fs/xfs/xfs_inode_item.c         | 23 ++++++++--
>>  fs/xfs/xfs_inode_item_recover.c | 79 ++++++++++++++++++++++++++++-----
>>  6 files changed, 196 insertions(+), 27 deletions(-)
>
> .....
>
>> +static xfs_failaddr_t
>> +xfs_dinode_verify_nrext64(
>> +	struct xfs_mount	*mp,
>> +	struct xfs_dinode	*dip)
>> +{
>> +	if (xfs_dinode_has_nrext64(dip)) {
>> +		if (!xfs_has_nrext64(mp))
>> +			return __this_address;
>> +		if (dip->di_nrext64_pad != 0)
>> +			return __this_address;
>> +	} else if (dip->di_version >= 3) {
>> +		if (dip->di_v3_pad != 0)
>> +			return __this_address;
>> +	}
>> +
>> +	return NULL;
>> +}
>
> Shouldn't this also check that di_v2_pad is zero if it's a v2 inode?
>

xfs_dinode_verify_nrext64() is meant for checking only those parts of an inode
that are influenced by "large extent counters" feature. Hence, I don't think
we should check di_v2_pad field in this function.

> Also, this isn't verifying the actual extent count range. Maybe
> that's done somewhere else now, and if so, shouldn't we move all the
> extent count verification checks into a single function called,
> say, xfs_dinode_verify_extent_counts()?
>

Validation of extent count had been performed by xfs_dinode_verify_fork(). I
think it still continues to be the right place for validating extent counts
since they are per-fork attributes.

>> @@ -348,21 +366,60 @@ xlog_recover_inode_commit_pass2(
>>  			goto out_release;
>>  		}
>>  	}
>> -	if (unlikely(ldip->di_nextents + ldip->di_anextents > ldip->di_nblocks)){
>> -		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(5)",
>> +
>> +	if (xfs_log_dinode_has_nrext64(ldip)) {
>> +		if (!xfs_has_nrext64(mp) || (ldip->di_nrext64_pad != 0)) {
>> +			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(5)",
>
> Can we have a meaningful error like "Bad log dinode large extent
> count format" rather than something we have to go look up the source
> code to understand when someone reports a problem?
>

Ok. I will change the error message to apply the above review.

>> +				     XFS_ERRLEVEL_LOW, mp, ldip,
>> +				     sizeof(*ldip));
>> +			xfs_alert(mp,
>> +				"%s: Bad inode log record, rec ptr "PTR_FMT", "
>> +				"dino ptr "PTR_FMT", dino bp "PTR_FMT", "
>> +				"ino %Ld, xfs_has_nrext64(mp) = %d, "
>> +				"ldip->di_nrext64_pad = %u",
>
> What's the point of printing pointers here? Just print the inode
> number and the bad values - we log the pointers in the
> the log recovery tracepoints so there's no need to print them in
> user facing errors because we can't do anything with them without a
> debugger attached.
>
> Hence we really only need to dump the inode number and the bad extent
> format information - we already have the error context/location from
> the corruption error report above. Hence all we need here is:
>
> 			xfs_alert(mp,
> 				"Bad inode 0x%llx, nrext64 %d, padding 0x%x"
> 				in_f->ilf_ino, xfs_has_nrext64(mp).
> 				ldip->di_nrext64_pad);
>
> The other new alerts can be cleaned up like this, too.
>

Ok. I will clean it up.

>> +				__func__, item, dip, bp, in_f->ilf_ino,
>> +				xfs_has_nrext64(mp), ldip->di_nrext64_pad);
>> +			error = -EFSCORRUPTED;
>> +			goto out_release;
>> +		}
>> +	} else {
>> +		if (ldip->di_version == 3 && ldip->di_big_nextents != 0) {
>> +			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(6)",
>> +				     XFS_ERRLEVEL_LOW, mp, ldip,
>> +				     sizeof(*ldip));
>> +			xfs_alert(mp,
>> +				"%s: Bad inode log record, rec ptr "PTR_FMT", "
>> +				"dino ptr "PTR_FMT", dino bp "PTR_FMT", "
>> +				"ino %Ld, ldip->di_big_dextcnt = %llu",
>> +				__func__, item, dip, bp, in_f->ilf_ino,
>> +				ldip->di_big_nextents);
>> +			error = -EFSCORRUPTED;
>> +			goto out_release;
>> +		}
>> +	}
>> +
>> +	if (xfs_log_dinode_has_nrext64(ldip)) {
>> +		nextents = ldip->di_big_nextents;
>> +		anextents = ldip->di_big_anextents;
>> +	} else {
>> +		nextents = ldip->di_nextents;
>> +		anextents = ldip->di_anextents;
>> +	}
>
> Also, this can be put in the above if statements, it does not need
> a separate identical if clause.

I agree. I will move these assignments to the previous if/else statement.

>> +
>> +	if (unlikely(nextents + anextents > ldip->di_nblocks)) {
>> +		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(7)",
>>  				     XFS_ERRLEVEL_LOW, mp, ldip,
>>  				     sizeof(*ldip));
>>  		xfs_alert(mp,
>>  	"%s: Bad inode log record, rec ptr "PTR_FMT", dino ptr "PTR_FMT", "
>> -	"dino bp "PTR_FMT", ino %Ld, total extents = %d, nblocks = %Ld",
>> +	"dino bp "PTR_FMT", ino %Ld, total extents = %llu, nblocks = %Ld",
>>  			__func__, item, dip, bp, in_f->ilf_ino,
>> -			ldip->di_nextents + ldip->di_anextents,
>> -			ldip->di_nblocks);
>> +			nextents + anextents, ldip->di_nblocks);
>>  		error = -EFSCORRUPTED;
>>  		goto out_release;
>>  	}
>
> ALso, I think that xlog_recover_inode_commit_pass2() is already too
> big without adding this new verification to it. Can we factor this
> into a separate function (say xlog_dinode_verify_extent_counts()) 
>

Sure. I will move extent count validation into a new function.

>>  	if (unlikely(ldip->di_forkoff > mp->m_sb.sb_inodesize)) {
>> -		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(6)",
>> +		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(8)",
>>  				     XFS_ERRLEVEL_LOW, mp, ldip,
>>  				     sizeof(*ldip));
>>  		xfs_alert(mp,
>> @@ -374,7 +431,7 @@ xlog_recover_inode_commit_pass2(
>>  	}
>>  	isize = xfs_log_dinode_size(mp);
>>  	if (unlikely(item->ri_buf[1].i_len > isize)) {
>> -		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(7)",
>> +		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(9)",
>>  				     XFS_ERRLEVEL_LOW, mp, ldip,
>>  				     sizeof(*ldip));
>>  		xfs_alert(mp,
>
> And this is exactly why I don't like these numbered warnings. Make
> the warning descriptive rather than numbered -
> changing/adding/removing a warning shouldn't force us to change a
> bunch of unrelated warninngs...

I will write a new patch to replace these numbered warnings with descriptive
ones.

-- 
chandan
