Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 645AFC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Mar 2022 06:02:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358415AbiCYGEA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Mar 2022 02:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358414AbiCYGD5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Mar 2022 02:03:57 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7906AC683A
        for <linux-xfs@vger.kernel.org>; Thu, 24 Mar 2022 23:02:21 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22P0UaVX000397;
        Fri, 25 Mar 2022 06:02:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=x1vl1s6T8Pm5aPfIkRl4BdK1qW1mddiL0cDR/trjE3U=;
 b=arXz7jLDmFtC+Jn2BAx+3PaD7wyN688pbFELChzQIAQSQdZnd9RKHNHIQWYp1SmQK8LX
 TzFSECBBxjo9e649azi273TVe71l6uHQp0Bw9nBXYbKvbRVr3qiCpSkCJymW78Y9Ftgm
 ZmI31HATuuvMcqY610oai1Ns9yfPcI4gYsEgH9GtIr6Aa/1uldYjkWaP6/LGRPpH6U8I
 Ldk1rP+Kn6IDc5oCuZNNiy3rFu9egJArsPYQqeNgd9eg+E1Ynsr44dWr+hrHiBd2Vey6
 oxxi9wDTpRmBMjKWg2rpIwciVaAqbHAq0eXvNx5Zx0wgLP7MXM0g71aaeeTEsNayVYbG 2w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80] (may be forged))
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew72any2c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Mar 2022 06:02:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22P61XrM087245;
        Fri, 25 Mar 2022 06:02:14 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2172.outbound.protection.outlook.com [104.47.73.172])
        by userp3030.oracle.com with ESMTP id 3ew49reyan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Mar 2022 06:02:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TsgE6/nMpTx0pbpBoVmPl4PDNG8HP4KEriCJKLTgzQL1DDDIcgHflUmSK+rlxfGk0z12FAxQcPFbiM8ChITGvEnmEhZNtXjP/vs5j5SxHlnsULZtB3ziQGMJLldi0+jQOI3yPpNGBJ+HeE2yeEY0RnWTk1NCPcrrvF3jLk/z7cbOg10R2cuKpEIu9hF9gxfnEWr2uaSUiTO5U4gP73VlgdFHLNL6zriic4N8lg6p8JO0muLR5t2+QRDXN+Kq7DVQQmya6e78AoygO0eGPtaV39uy5N2C9NmRo+gSoGsdcY/paOz4IVUQQeac/AxTD8ID3hdmmboXyohfIf/mHtHH/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x1vl1s6T8Pm5aPfIkRl4BdK1qW1mddiL0cDR/trjE3U=;
 b=jTbe9RqnZu8QyXbK9ZfXhMMK1SeuoGy6BEiT6f9iQ2iSW4eF9EIT3cFgF74IhIuGWw4kLAFYl6zX3tAsB7Jk5clh4SBkk7bPCjtlzCkfRgNwihkzytXGvHNnjvGGp3/gh7e1G14w7oHNajGP4QSSMv12ikQXZjgmFnqMayliWLJfaanWcMdEN9SERAvMVuaHDUpZV/Eo1VHVWOgAc9eIqHDJlksdar2XTdh3NcesJ/7L3eHOP31+QJ8qSrziaudAY1uc6x3cABnOn+5bJAQ4ElU7OALC62JJS2P/bzVfTGy9Xed64ewTVKX/KbfxZDsptfJD/IkgxaRtp4qCDWhIQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x1vl1s6T8Pm5aPfIkRl4BdK1qW1mddiL0cDR/trjE3U=;
 b=BXBkdqNJm24nHePN54pSHN41YItpzLCYQefKV0R9+jGfr1WvuX2ZmJJ3VPWjHAF060xDkBJ48S8Wp8aM6b39aPTjNfPbF67akcOwVjVYHjv0FWsnbEAgdfY8pYZK7oYNL6Wm7Dz3sS3C4fG5zg29D0Q8OaEsIcG85q2XSb4mM/A=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BYAPR10MB2776.namprd10.prod.outlook.com (2603:10b6:a03:87::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17; Fri, 25 Mar
 2022 06:02:12 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::f8e2:79c8:5da6:fd12]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::f8e2:79c8:5da6:fd12%6]) with mapi id 15.20.5102.019; Fri, 25 Mar 2022
 06:02:12 +0000
References: <20220321051750.400056-1-chandan.babu@oracle.com>
 <20220321051750.400056-15-chandan.babu@oracle.com>
 <20220324215348.GK1544202@dread.disaster.area>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH V8 14/19] xfs: Introduce per-inode 64-bit extent counters
In-reply-to: <20220324215348.GK1544202@dread.disaster.area>
Message-ID: <87zglewox2.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Fri, 25 Mar 2022 11:32:01 +0530
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0017.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::19) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 47733e6d-86f0-4daf-464d-08da0e25010e
X-MS-TrafficTypeDiagnostic: BYAPR10MB2776:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB2776E6535622BFC000FFD35AF61A9@BYAPR10MB2776.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: To8hw67qPLogjmc5TPTH8ykm6cgWrfopblXER5hn52E0HXuD7BixuYu8XFa5PCaKkuV9iFFq7ODUHJQaDGjITsJavLhdSGaGLGR+KvOfPuAbjwfaeAHLMN7R7NcpwZvvjkvgHxH50ESxHbYD+ZX4Hi+B9wYD2A7aU2PbYc+yajfACNOZlb0QrbsQyLkRRTo3TwocqFtaPCO2Fxq9Ak9P5TsJS7I/26Y+Ldeh1euuPSU0xCvA0/f6j6SDsEDcn9kDwgkFo5IHvGkibpwgEfUnnYamWkDVHtjNtjLV8UoG+v2w2eSxdN/zfmXMuFO7I6LZF3v7n9APwV12iao7HhXV7kCzNBrO5OyR+tDExfqdRxbv7c7gYJATlhIyB8Q1fnfNCbUlvE8piezDGXiIyi3r4Bqo5sra8N2JSH0A2cbKMg2UZhXm/zUW4uYpkvbCRetIq+HJeie7CEl0KRY7z3PTgNnjZBDpBCJkUbwdME5E0NNhUqSGLCA2tIXDwsF+hWMqHLyn7030qMTACcZjL7b3WRukRqscXMMBXeMRBzlDprfV4ROi7HTFnJ4w2VrrBIOe9l0eqk6t/delfbJ+tuAUjlJim0m9ivtFun1zUQAp2NRLQmgE0J/BTXhnewHK2qG6paKSPQO8nEK0EygXdJz6tavlZZJCJiaCZM1qwHCkGncCNsUd3V65qbFYIDCt8Re+j34HBNKGZb1DuWIR1JLc1Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(33716001)(8936002)(9686003)(6916009)(86362001)(4326008)(8676002)(5660300002)(316002)(66946007)(66476007)(2906002)(38100700002)(66556008)(38350700002)(508600001)(6486002)(83380400001)(53546011)(6512007)(186003)(6666004)(26005)(6506007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VZVcxctvMJPBnkSUcd8KWW1irTWLg5Lrj1ZbTI8mADqhEHxbge5WTvfVgDjD?=
 =?us-ascii?Q?pFxywIf9cQt1fxqj1igIxaJ/Zi082eUPRXfVmnQt40rp+4ighKeHQHK2waBG?=
 =?us-ascii?Q?Pvj6BC+9PsAI6D21AUUcQmNXFIRFvncK/r9wS7fz0RHBTQPgBbL6Ug++f9+N?=
 =?us-ascii?Q?fI49NkQQ1DLJ8ADgT1Z+5TEFiTh/PzOgCLM1FqNJdpHTqnRF9EMLl6TuRXNO?=
 =?us-ascii?Q?hQM+Z9vHTRwkCUViZq5rJ2nOGKQ4fpCsxhbeOJqXffV1i7JA8HDiy31pmY87?=
 =?us-ascii?Q?R6NEXCtWnwLPdRdn0IoUpOpy1CFBrfTSuAXdHwJHW6N4t0+ob1JK5ftB311x?=
 =?us-ascii?Q?9p0ClArpRQ0e0VlAlMaBNUt97gF6YkkXUcQqTzW8F1QTDUF8KbbbXxE2CGBx?=
 =?us-ascii?Q?DWznLIDP88wqed4VPmW9FIW2mjlWM9N5brKJqpl20ANfZaeYwqgQEcP9fhOM?=
 =?us-ascii?Q?SR9SjOayei/lsRInOkYSGtIiOUNiYjAhYr1+QilM8GgLubmO7NOAgEUoSJeB?=
 =?us-ascii?Q?JKklDFiIeJsBTX+YQvYM1Ro6W10W3Fzx4QhSe/CD/cVG70Yaa7pSPUKrKcqA?=
 =?us-ascii?Q?PnfDOe/PU2YAJy1sGTCqrI7kH8rHQue5hdCPAdSK2akp3riuwP3/Q8Tdz7i9?=
 =?us-ascii?Q?NKY63J13EnGXVDAvoqqZ0K5wUjzqQQADqvtGHfl9x7ojyDjL8KVsoyJ3wLsk?=
 =?us-ascii?Q?d75gCfzCKkOfxxZnk/Hom50AjmMv+Z9murkHsqdR0Q3f9lIlUhDuGtfpreCk?=
 =?us-ascii?Q?F2eFXzjnYr2KiaIYtmRkhH6UOrpi9CQ85PWdRIu3Go6iUfVYL5SH2pVmkmcY?=
 =?us-ascii?Q?i4clemdFwqSbGgzKEOhw4al2RIfGEy5d1g1bsAG25Lg+BZGMCitBCdOW/ZKD?=
 =?us-ascii?Q?00oEFo/2ZYE86S1atzeB3RvS46uuca4ctgyOJG8mz93Sx6IKGy8aZeJgKL7i?=
 =?us-ascii?Q?WrDVhacHfG+TQOXJkSU92k1QV7BpxofOX3lZXeQUeHRYPnobfBZam/fE8YDl?=
 =?us-ascii?Q?7IOlJltCZCrLEY35K8kZ8befWz8b6WcneHQCnzqrb+v31xPe84OlS3HfO1ll?=
 =?us-ascii?Q?BmtW9snnAvoLfgUWjLKw3DkcegkXI7Lmar4yckqjl3PYpTyK0urLjEI8SF2i?=
 =?us-ascii?Q?KRl6F7XOrIOEgSy7yDtfWmQMi9TJaMzxg+PY/qweOfmlj/h78t9Y2EoxAlVV?=
 =?us-ascii?Q?Ukfmt5y3zmmgM7c/uuj183MmOZbh7iZGhv5IGaJ8s4EdkFx3MGigDg5T+lnH?=
 =?us-ascii?Q?Pih707CrAZ4mQsaq80zMiNLjnuHhU4s5gdBk85HVeEE0hnsrOSVgpJR6Cnha?=
 =?us-ascii?Q?vAmG9yxukNquomRL3TDP57lLiN5Oziq/h/orbHlk+al69RH/trRjPuxcmZW1?=
 =?us-ascii?Q?D2p31tkBrGzdTAJMo+5tfP5YKw9D9/yj1pYQBjAlCNKC2xURzh2zIIql4X4S?=
 =?us-ascii?Q?3kIxMDnvWZhpaxpcrDQKnsfMXVV38jo9lHGVzPpLDV06LbEMEFqvBw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47733e6d-86f0-4daf-464d-08da0e25010e
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2022 06:02:12.3918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tMcLUfRIBWSVROuzvTwAMZYLE1QhGo2SUEr2+NDWTfJKIgkh+VqAs9cgtDWabe9OhH+OnuWM81M40ygBwYKtUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2776
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10296 signatures=694973
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203250032
X-Proofpoint-GUID: APS8q5w-gge2-13OECDLiO7tknOyZQhe
X-Proofpoint-ORIG-GUID: APS8q5w-gge2-13OECDLiO7tknOyZQhe
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 25 Mar 2022 at 03:23, Dave Chinner wrote:
> On Mon, Mar 21, 2022 at 10:47:45AM +0530, Chandan Babu R wrote:
>> This commit introduces new fields in the on-disk inode format to support
>> 64-bit data fork extent counters and 32-bit attribute fork extent
>> counters. The new fields will be used only when an inode has
>> XFS_DIFLAG2_NREXT64 flag set. Otherwise we continue to use the regular 32-bit
>> data fork extent counters and 16-bit attribute fork extent counters.
>> 
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> Suggested-by: Dave Chinner <dchinner@redhat.com>
>
> Looks good, minor nits below.
>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
>
>> +STATIC int
>> +xlog_dinode_verify_extent_counts(
>> +	struct xfs_mount	*mp,
>> +	struct xfs_log_dinode	*ldip)
>> +{
>> +	xfs_extnum_t		nextents;
>> +	xfs_aextnum_t		anextents;
>> +
>> +	if (xfs_log_dinode_has_large_extent_counts(ldip)) {
>> +		if (!xfs_has_large_extent_counts(mp) ||
>> +		    (ldip->di_nrext64_pad != 0)) {
>> +			XFS_CORRUPTION_ERROR(
>> +				"Bad log dinode large extent count format",
>> +				XFS_ERRLEVEL_LOW, mp, ldip, sizeof(*ldip));
>> +			xfs_alert(mp,
>> +				"Bad inode 0x%llx, nrext64 %d, padding 0x%x",
>
> "large extent counts" rather than "nrext64"?
>
>> +				ldip->di_ino, xfs_has_large_extent_counts(mp),
>> +				ldip->di_nrext64_pad);
>> +			return -EFSCORRUPTED;
>> +		}
>> +
>> +		nextents = ldip->di_big_nextents;
>> +		anextents = ldip->di_big_anextents;
>> +	} else {
>> +		if (ldip->di_version == 3 && ldip->di_v3_pad != 0) {
>> +			XFS_CORRUPTION_ERROR(
>> +				"Bad log dinode di_v3_pad",
>> +				XFS_ERRLEVEL_LOW, mp, ldip, sizeof(*ldip));
>> +			xfs_alert(mp,
>> +				"Bad inode 0x%llx, di_v3_pad %llu",
>> +				ldip->di_ino, ldip->di_v3_pad);
>
> the padding should be dumped as a hexadecimal value - it's much
> easier to see the bit corruption patterns in hex dumps than decimal
> output.
>

I agree. I will make the suggested change.

>> +			return -EFSCORRUPTED;
>> +		}
>> +
>> +		nextents = ldip->di_nextents;
>> +		anextents = ldip->di_anextents;
>> +	}
>> +
>> +	if (unlikely(nextents + anextents > ldip->di_nblocks)) {
>> +		XFS_CORRUPTION_ERROR("Bad log dinode extent counts",
>> +				XFS_ERRLEVEL_LOW, mp, ldip, sizeof(*ldip));
>> +		xfs_alert(mp,
>> +			"Bad inode 0x%llx, nextents 0x%llx, anextents 0x%x, nblocks 0x%llx",
>> +			ldip->di_ino, nextents, anextents, ldip->di_nblocks);
>> +		return -EFSCORRUPTED;
>
> Maybe should indicate large extent count status here, too.
>

Yes, I think it will make it easier to determine the inode fields of the two
extent counts.

-- 
chandan
