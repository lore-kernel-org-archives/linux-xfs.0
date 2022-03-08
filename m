Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0033AC433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Mar 2022 02:53:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236131AbiCHCyO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Mar 2022 21:54:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiCHCyO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Mar 2022 21:54:14 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF0D369E5
        for <linux-xfs@vger.kernel.org>; Mon,  7 Mar 2022 18:53:18 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2282WI41022335;
        Tue, 8 Mar 2022 02:53:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=iJ7syxgf5pe/dxbxLakXW3sYr3qFH14A1Ugov083Y1k=;
 b=jkQY0v/7RFEZf+8e03rvhqJm42LOeHSwWSwbRLeGLn+nXfsoKfB0gkdGxhpEwWcKwVbN
 7AGioglsm+Kr+ktWmyVaeaX6ZZVi6FcpLm8Xi49GCW6CTnEOrBzjRoVoMDg88OppJsxK
 GSX1FEKrvZduTlndCTWlLUWb1EKEnMDP/oX18xeyW0xk1QN8Rn4Pk+d5ySpsO285Fp5y
 OcmGUPFyIG1+QC4HphDhLWAXfTncXAfm9UjKWk4RV8v/SieAFAirrcMPFFYwVy14jUPm
 dshntEX1d/F19uuOE07a7OYVoK7epgYcP31wDH25r3K8lEi2/+XT5PKUa9NJA/Ie3LSm Tg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekxf0nrg9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 02:53:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2282pviM013136;
        Tue, 8 Mar 2022 02:53:07 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by aserp3030.oracle.com with ESMTP id 3ekwwbhccb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 02:53:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=djZtIudGbBq54Y4KOmiRRzzXot4JokY+/Ip1c8inVuoRwI1McFsiLG4nUHa5/H/tibvsymFIWNP0RzubIov6Lan2VJcBk46kWtAQbBkZoPoaPXb0NqzxbJmljXd9LM+l47XmxQrL/RJ4hM9+2XT5HmnPj9LIKtSLrPZVyY59CGbkNO1itu8FOytrrDTRf3bJS+py2+fu709Sv0vICkUpZmOOb4u+p48Dc+GM8TjBAVxDCrJ++cV95yTy4PGBkyG71Wxl3yrreQE/YryGtTGnjRvJSPacWiheQB/Pj7BCBKS+BOElxb201kXsGWZOpiyTycwdnV64bJo1YMFMdK3E4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iJ7syxgf5pe/dxbxLakXW3sYr3qFH14A1Ugov083Y1k=;
 b=MShg64iFABRHxLnR7B6cq1hCfv3E+aU3BKDRRjuFbdwTB9B9FVzsF2pTzNsNGVm2UBzKM2HsXnixnQ3mjODJeqpe49bP46JuSfKy70M1KlXJUBVvSA55+23zZ6ZwDNiBj4hHH/m7RlspvMT/AQnn0ovbDlukMmP8HhhjWsQgM4/fhFwGZd7fzoDJtHaiMOpAfL3aHU5NQ3AjncniIlLvpB45Kc4V7EYmTr3rnG5XzKW2JRrS/VFTXKlP2n7CpS5loEd8s94YpNydkx4UzM3ZCaRuLh2EsR2uqtmUYhaXRb3LUkxbuVJ8QrOy0HlIJG4hVwcZ1nRSQx1eZK9NF7Nk5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iJ7syxgf5pe/dxbxLakXW3sYr3qFH14A1Ugov083Y1k=;
 b=Mz9EcpJ0G8PLgbY7NI2WN0oOPd8zwwUZAfFg0EN6h/8TqA62JraUyWEcuSqCOcmMmATC9w5VapNmSJr/AlkHyjyuYCgYSX+dJ/W0wv3GAjwSiy3RfyTs3w2Blo4yBSbB2hB+5nTTtrdzG42DkGonzbydvNbGE2FSlLfMX8vayNA=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BL0PR10MB2772.namprd10.prod.outlook.com (2603:10b6:208:72::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Tue, 8 Mar
 2022 02:53:05 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%7]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 02:53:05 +0000
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
 <20220301103938.1106808-16-chandan.babu@oracle.com>
 <20220304080932.GK59715@dread.disaster.area>
 <87fsnwlg9a.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20220307051339.GO59715@dread.disaster.area>
 <87h789swmm.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20220307214127.GQ59715@dread.disaster.area>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V7 15/17] xfs: Enable bulkstat ioctl to support 64-bit
 per-inode extent counters
In-reply-to: <20220307214127.GQ59715@dread.disaster.area>
Message-ID: <87mti1qhof.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Tue, 08 Mar 2022 08:22:48 +0530
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0002.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:c::12) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c9adbc8c-e764-4754-441d-08da00aec43b
X-MS-TrafficTypeDiagnostic: BL0PR10MB2772:EE_
X-Microsoft-Antispam-PRVS: <BL0PR10MB277210760EC2F20C387ACE3DF6099@BL0PR10MB2772.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GeOXu/PECdrMjuVCnLvJE5P1Z3AvYhJCmG66FJZcDIInPhM1/b3aHJaC1+ZVKSe/eJryo6VmXNvtNAySdpLZVDo98SobIn8z0rk0ORP3pBXq6Gj6/IZUADxy0ijdeWP6eKkgtcQ9KvzTjA3RIleQbv+iz1KDyXr7gdHaTBYf7lX1UhRrux200C+jlMb15T97UUiVcNDlMIJHItnAcWluXgfyRTZHM/d+QWg10iVFoRDcxnhcrRTl55uskUb9XdAiuzB2EwmEwrOdNhHKm8u51iu7z8MUChJx3MU37669Uj5TLY3690FXaF12rroxufyKZpP+yOsKy/RRPPC8koOJzyQxQMqt7dlqCvlPBAczo0GHLk+cG5CuANdt+B7OInzrwQqWW1u9FrUjdQGfHnhUtC5glf/nBYVzImELrqwcbb0NAULQFCd6e5hanUKwf2B8jtOQQa/ZszOIg8vvCvQNpgjtJuQhwQa9/cNsdExjvSOX0Q70Sh8ZMxdZmu2X17shdtqLxh2t/NUgD6dQkT8O85VlnLJSSE7nl6MOR7r74Ya2ANbQtimI8stjdadff8ytCu45QptxlueuinYEGiMCdB+YGDFh8pqieOv3b2HtvE6HjPqBDUhBu8pxj/EPWuxWoU65uaGjWX2Kexdz5mnVr/q0PY5QbO8iHMq7Lg0nOU6xFKCx5kf9Ee2dR0UuUQeuRJWj8j2Zpo+Epj7TbsL2wiJW3O1p+dIxxhwzCm6DZuAn4w/JxDD+jxAX9QkBz/oV0J/Tj/Qz8tREl/gzmrIWkLaYoE5qYFSSCHzmd22PCPM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(316002)(66946007)(66476007)(4326008)(38100700002)(8676002)(66556008)(38350700002)(86362001)(8936002)(5660300002)(2906002)(9686003)(6512007)(53546011)(52116002)(33716001)(6916009)(26005)(186003)(966005)(6506007)(6486002)(6666004)(508600001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hVyeIO+O9umMJimiG8L5N2VMWUmoLn3gQoqqiLrclfvwdbbc+RDtGHYBcXb8?=
 =?us-ascii?Q?56R3U1PeySQfMV7hoo0B9WOzZJPbtEDAr//JCBLZv6VuleV7O02o8yrJR8SU?=
 =?us-ascii?Q?qVC0NbYOzAYfzO6oSSiZKoO/kdpoqDsxLawy683U2qn2hpO6v0puYq/3E0Jw?=
 =?us-ascii?Q?eacP2fNNovrU0/fNxZ/pIuh7dTPRKpMxQiHz2ftjkr21mvWGuBAz6GRWhc51?=
 =?us-ascii?Q?8/334Kt/j1tj5doOnwaVUEqaU8WdSfzA9TrNzq+kHP1rXtRx88IiCuTWsKmw?=
 =?us-ascii?Q?hvXH8LLyCZ39N2rjMmC5FVuznnWHm6mUr4MVXCjRI7jzI6EcwCeuzHIYnIU/?=
 =?us-ascii?Q?IXlSy5IfC+wfEpjt3zrcD/ou7o7oa2o679iCmnVf4DwpzTc5qjjDq2BiWrus?=
 =?us-ascii?Q?mhjnfsxy5rjD3I3S7GD99sjhw3uUtwHVzbN1JSL4PHB3j/7P1klH1YV0mUbK?=
 =?us-ascii?Q?LsbIaRq/eclxVc/+38sHiJa3FOZ1ZYSyPgMrG5qfS0sFy3uREiiMrp8Zmbol?=
 =?us-ascii?Q?OBq018scPQno7VHzavH8imuqh5UZykhVSvB+s2AbxSg/A1the5l5ZdBjajq1?=
 =?us-ascii?Q?DJ7l8I17ZemFH5GROvDHd79H5UJLqvnMOrW2qgcfvlrANDAiuGg9vQjEryUO?=
 =?us-ascii?Q?KOV+yq7GRPbNJNRUeACSD/bAjbYOJesG7uMsRBIioteA/8fS0h90xI4ByuGm?=
 =?us-ascii?Q?Dg1Y+v0s7YUn+BypQONLC0zxc/s4nJgELqwHJGdoLwmlkP5fk9j7tSMCGxuc?=
 =?us-ascii?Q?c3dsJL4OBIT9Cpn1IlAY6n3hzfLrYQMMu+Q//+AN5rSo6LvDU1Z9WBQRGteq?=
 =?us-ascii?Q?rG4wDvkVr7UDSBqqt+0O1QyKkFVpZaxomOYREqSCe+byNQ3/eTdoFQRXmbXm?=
 =?us-ascii?Q?h0IxPOxLDCNNYIqC2TFY7YJFAYOrGVtDtACpFWMBOdJlyu+xHYneBDiy4ptR?=
 =?us-ascii?Q?CZwh0C14TfK/wXW8OKpE8NwI1GTx1xd2A6svhC0Dc5MuxyqZdWbjn5MBQaY1?=
 =?us-ascii?Q?NLW2+WyJaExx0AztD0gpTryLDRnMY+yJk1kS+na+KPZGVbFRTWShX2gpP+tO?=
 =?us-ascii?Q?vM/5AUm+TUpuSWjmq5Pr2gjnCqL/LjlpY6B4WZgk1X2Pd9NMchMfZzCn4eq0?=
 =?us-ascii?Q?fxFFiznNS/RMWnwV1R/ugcvaDVO7lIzamZEx4dqSAhOYUzlistF/ZXnhu+zd?=
 =?us-ascii?Q?CpshuEknKt8AzmlAzI+rjs4BpJKcAnuIqny2ggQL8lkcscmppVOdYU0GGSDT?=
 =?us-ascii?Q?yw+l29Hu2gGzsdD4rjhBCrlToLGk/hJcy6Rl0AHl9Vz2QCoYYTseS2ybfHp+?=
 =?us-ascii?Q?Z0loQp2S2vMjf6nl6b78DOtLTZtpGsvSCr8joIx3+HDbhuCAnXSyepW3aByN?=
 =?us-ascii?Q?XrNx9mLLU3NhsNRFPMadIJwzUwKoKByIMVBJvBf9T8Z81OFQWLNRp/wBYNvR?=
 =?us-ascii?Q?FoW8Kd1iYUSfZhRQnhCTmsAx23NUkftIIMc0O5Y4gEyfmSht2IsZfO55TuBJ?=
 =?us-ascii?Q?xszQTXZ9ANreS5pU4Do01ztzghr+hjhpi5IYqNN6fftye6YijmdCzHUXLy5k?=
 =?us-ascii?Q?0YwycghUd15qB+nA5UM1hRas3+ySIk1i67QxapEj4xRTEdR8YZ5CEk5KCvcT?=
 =?us-ascii?Q?/8hXQ8z/FdfOuHTxQtR9WqM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9adbc8c-e764-4754-441d-08da00aec43b
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 02:53:04.9123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vqVpZJZwAiZhVvF2d4je7A7mkae9xPi6ihsYx8kH+yP+ZkHWaStolHWIW344ByH6qRnKb4dtNN9p2PpJDCW4vA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2772
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10279 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203080003
X-Proofpoint-ORIG-GUID: -XYI3LG8eRN4FMrEQZCIclTA1IA9h4AM
X-Proofpoint-GUID: -XYI3LG8eRN4FMrEQZCIclTA1IA9h4AM
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 08 Mar 2022 at 03:11, Dave Chinner wrote:
> On Mon, Mar 07, 2022 at 07:16:57PM +0530, Chandan Babu R wrote:
>> On 07 Mar 2022 at 10:43, Dave Chinner wrote:
>> > On Sat, Mar 05, 2022 at 06:15:37PM +0530, Chandan Babu R wrote:
>> >> On 04 Mar 2022 at 13:39, Dave Chinner wrote:
>> >> > On Tue, Mar 01, 2022 at 04:09:36PM +0530, Chandan Babu R wrote:
>> >> >> @@ -102,7 +104,27 @@ xfs_bulkstat_one_int(
>> >> >>  
>> >> >>  	buf->bs_xflags = xfs_ip2xflags(ip);
>> >> >>  	buf->bs_extsize_blks = ip->i_extsize;
>> >> >> -	buf->bs_extents = xfs_ifork_nextents(&ip->i_df);
>> >> >> +
>> >> >> +	nextents = xfs_ifork_nextents(&ip->i_df);
>> >> >> +	if (!(bc->breq->flags & XFS_IBULK_NREXT64)) {
>> >> >> +		xfs_extnum_t	max_nextents = XFS_MAX_EXTCNT_DATA_FORK_OLD;
>> >> >> +
>> >> >> +		if (unlikely(XFS_TEST_ERROR(false, mp,
>> >> >> +				XFS_ERRTAG_REDUCE_MAX_IEXTENTS)))
>> >> >> +			max_nextents = 10;
>> >> >> +
>> >> >> +		if (nextents > max_nextents) {
>> >> >> +			xfs_iunlock(ip, XFS_ILOCK_SHARED);
>> >> >> +			xfs_irele(ip);
>> >> >> +			error = -EOVERFLOW;
>> >> >> +			goto out;
>> >> >> +		}
>> >> >
>> >> > This just seems wrong. This will cause a total abort of the bulkstat
>> >> > pass which will just be completely unexpected by any application
>> >> > taht does not know about 64 bit extent counts. Most of them likely
>> >> > don't even care about the extent count in the data being returned.
>> >> >
>> >> > Really, I think this should just set the extent count to the MAX
>> >> > number and just continue onwards, otherwise existing application
>> >> > will not be able to bulkstat a filesystem with large extents counts
>> >> > in it at all.
>> >> >
>> >> 
>> >> Actually, I don't know much about how applications use bulkstat. I am
>> >> dependent on guidance from other developers who are well versed on this
>> >> topic. I will change the code to return maximum extent count if the value
>> >> overflows older extent count limits.
>> >
>> > They tend to just run in a loop until either no more inodes are to
>> > be found or an error occurs. bulkstat loops don't expect errors to
>> > be reported - it's hard to do something based on all inodes if you
>> > get errors reading then inodes part way through. There's no way for
>> > the application to tell where it should restart scanning - the
>> > bulkstat iteration cookie is controlled by the kernel, and I don't
>> > think we update it on error.
>> 
>> xfs_bulkstat() has the following,
>> 
>>         kmem_free(bc.buf);
>> 
>>         /*
>>          * We found some inodes, so clear the error status and return them.
>>          * The lastino pointer will point directly at the inode that triggered
>>          * any error that occurred, so on the next call the error will be
>>          * triggered again and propagated to userspace as there will be no
>>          * formatted inodes in the buffer.
>>          */
>>         if (breq->ocount > 0)
>>                 error = 0;
>> 
>>         return error;
>> 
>> The above will help the userspace process to issue another bulkstat call which
>> beging from the inode causing an error.
>
> ANd then it returns with a cookie pointing at the overflowed inode,
> and we try that one first on the next loop, triggering -EOVERFLOW
> with breq->ocount == 0.
>
> Or maybe we have two inodes in a row that trigger EOVERFLOW, so even
> if we skip the first and return to userspace, we trip the second on
> the next call and boom...
>
>> > e.g. see fstests src/bstat.c and src/bulkstat_unlink_test*.c - they
>> > simply abort if bulkstat fails. Same goes for xfsdump common/util.c
>> > and dump/content.c - they just error out and return and don't try to
>> > continue further.
>> 
>> I made the following changes to src/bstat.c,
>> 
>> diff --git a/src/bstat.c b/src/bstat.c
>> index 3f3dc2c6..0e72190e 100644
>> --- a/src/bstat.c
>> +++ b/src/bstat.c
>> @@ -143,7 +143,19 @@ main(int argc, char **argv)
>>  	bulkreq.ubuffer = t;
>>  	bulkreq.ocount  = &count;
>>  
>> -	while ((ret = xfsctl(name, fsfd, XFS_IOC_FSBULKSTAT, &bulkreq)) == 0) {
>> +	while (1) {
>> +		ret = xfsctl(name, fsfd, XFS_IOC_FSBULKSTAT, &bulkreq);
>> +		if (ret == -1) {
>> +			if (errno == EOVERFLOW) {
>> +				printf("Skipping inode %llu.\n",  last+1);
>> +				++last;
>> +				continue;
>> +			}
>> +
>> +			perror("xfsctl");
>> +			exit(1);
>> +		}
>> +
>>  		total += count;
>>  
>> 
>> Executing the script at
>> https://gist.github.com/chandanr/f2d147fa20a681e1508e182b5b7cdb00 provides the
>> following output,
>> 
>> ...
>> 
>> ino 128 mode 040755 nlink 3 uid 0 gid 0 rdev 0
>> blksize 4096 size 37 blocks 0 xflags 0 extsize 0
>> atime Thu Jan  1 00:00:00.000000000 1970
>> mtime Mon Mar  7 13:06:30.051339892 2022
>> ctime Mon Mar  7 13:06:30.051339892 2022
>> extents 0 0 gen 0
>> DMI: event mask 0x00000000 state 0x0000
>> 
>> Skipping inode 131.
>> 
>> ino 132 mode 040755 nlink 2 uid 0 gid 0 rdev 0
>> blksize 4096 size 97 blocks 0 xflags 0 extsize 0
>> atime Mon Mar  7 13:06:30.051339892 2022
>> mtime Mon Mar  7 13:06:30.083339892 2022
>> ctime Mon Mar  7 13:06:30.083339892 2022
>> extents 0 0 gen 548703887
>> DMI: event mask 0x00000000 state 0x0000
>> 
>> ...
>> 
>> The above illustrates that userspace programs can be modified to use lastip to
>> skip inodes which cause bulkstat ioctl to return with an error.
>
> Yes, I know they can be modified to handle it - that is not the
> concern here. The concern is that this new error can potentially
> break the *unmodified* applications already out there. e.g. xfsdump
> may just stop dumping a filesystem half way through because it
> doesn't handle unexpected errors like this sanely. But we can't tie
> a version of xfsdump to a specific kernel feature, so we have to
> make sure that buklstat from older builds of xfsdump will still
> iterate through the entire filesystem without explicit EOVERFLOW
> support...

Ok. Thanks for the clarification.

-- 
chandan
