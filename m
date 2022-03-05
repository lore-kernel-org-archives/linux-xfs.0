Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C81DC433F5
	for <linux-xfs@archiver.kernel.org>; Sat,  5 Mar 2022 12:44:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbiCEMpM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 5 Mar 2022 07:45:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbiCEMpL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 5 Mar 2022 07:45:11 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 029F01CCB02
        for <linux-xfs@vger.kernel.org>; Sat,  5 Mar 2022 04:44:21 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2259i5kB009205;
        Sat, 5 Mar 2022 12:44:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : message-id : in-reply-to : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=3cJM90gvy+2l4Mi0zAzpMq9sAvcMMHstwgdK0AGLGNY=;
 b=rXCDYdm8JpSVp5HR++JkDHuKpcfvvkBvMORUI3UiOYHgMDjENsiqNxbUiao5K76YqMiD
 H4RHcAkyqMykDhyT6p217bHNRl8VR6PYv/LSC6hkQJBxFZLehy2XAsiuotZWQgG6QWWX
 Jdv2JDSGDNDF+NtIpJnh4kNEXMINHKTISIN5u6vy+xfCcvNMjrJJQevjkCXuqqPjvqOV
 ebvxhX19w8lQOYd8maqtcufym8NR2Mpsjt3Y7/gYaLSlv2KB54+unSMHO25xLfmGuVRe
 OpdydzuXfDPSX0yB410ACKXw+X13graFlQ3xVSuhYsS3ZkwB9q7Yhv04WZjl39/sv9M/ vw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekxf0grmh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 05 Mar 2022 12:44:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 225Caxww113053;
        Sat, 5 Mar 2022 12:44:13 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by aserp3020.oracle.com with ESMTP id 3ekynyqwe2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 05 Mar 2022 12:44:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ddq8i1+MP3CfVyq4TsAfvO7BjU+8gWH5/XsT6h0CPaT5ZSyLEzEknxBctKPNjIEb+v85aM7H1XKYu/fJgjlfFjbXauTS03bHgRdg7V0bJx/nrb5ltZyJ42mHylr2dWLRZEWdQAfuiXMllh0WLIWtN+V5Ji72Yha/pnqdhwVZ/jXYG/1dPEtsZnJ3o/S14xphrGFWe34QII9mLS6QI0QsAuqm89tgfUg8VJ+6a5fHNmwZ+VYoxDkbuFf9iywbyytsX4v6MrzlYJa1vOCAdpb0l89ZkpvcYRiBmV04MyaMzLgKXTv1vWv2+T+uXCa9O1wz7zqZLAWF6ziywwXMg/mqTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3cJM90gvy+2l4Mi0zAzpMq9sAvcMMHstwgdK0AGLGNY=;
 b=NrbMqxZ6cSqw7q/ZiClEhix4UQCPAD4Qr1ATS0laSg1RU2dFDdYFG+ld+uxS+kbjb7QwSjQexEQ7cRQuqdfJv4lWHF+zm2SxauS5PAP6kysD8hnRlObj6reNyC/noXNaZG6ubBNAcJxRDdPsJC99LQPkiqLVks+YAgkImtGC0osguuPRu5AnolauJNUXjG+KYvEHRPlTzYZCS5OlrlsmYBoLCfBVpDUFTPjCXf1AZiDbEntOF8sYySF94kehQE9OZnN7Da5wrkUznjpWXqJoSWG3qOJ6b2frgpywPelmsJMQDcEDQRcwBqTAJ2BWStlZkwjZA5Za8PrS2+8b9muXIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3cJM90gvy+2l4Mi0zAzpMq9sAvcMMHstwgdK0AGLGNY=;
 b=jIKQru32Pfz54nxgjp5vv5czfBg6t/ItDsKckIIZFPQAfj+1oHPTwu0/WW0saSS76uQjLA+Rbyy1+HYTPno5tuEYz1JulGBYGdGX1n7KmlKnJhTusFSkzzfWsMkwjQoqhHeK5yIFffRYXY4o+1PizLVJgoHD3YnzDMNJtI3flPw=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BYAPR10MB2821.namprd10.prod.outlook.com (2603:10b6:a03:85::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Sat, 5 Mar
 2022 12:44:10 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%7]) with mapi id 15.20.5038.019; Sat, 5 Mar 2022
 12:44:10 +0000
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
 <20220301103938.1106808-11-chandan.babu@oracle.com>
 <20220304020903.GF59715@dread.disaster.area>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH V7 10/17] xfs: Use xfs_rfsblock_t to count maximum
 blocks that can be used by BMBT
Message-ID: <877d99hmji.fsf@debian-BULLSEYE-live-builder-AMD64>
In-reply-to: <20220304020903.GF59715@dread.disaster.area>
Date:   Sat, 05 Mar 2022 18:14:00 +0530
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0026.apcprd02.prod.outlook.com
 (2603:1096:3:18::14) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 54fe2894-d294-4de7-5851-08d9fea5d837
X-MS-TrafficTypeDiagnostic: BYAPR10MB2821:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB2821516907D88ED3E16CD5F1F6069@BYAPR10MB2821.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m9bGag2tY08qCTHGFozIXY2G9YPyO4fsvxLg77fRY2U2G8evSHfIGBJeuMC+mKKQoZaZE6KlOyMd56Hdn04bQHlA+45pEVpgH00ZsvV8JjNJ3byXuhX5k+Dmez37nvDVc1Mcmfw5/CIFSe2Mdz1k/oSNyeQqO0fzAfMnt++HMNr+t0YnNkJnjWgiWcS/PJTWvT1HZeircR1CWM/wQ7jmlaCszWLxJT/hmPOf1nkOYtkvKIXT1ti2BhicZ6OD1wc7nu3Kbr5ouDL+5FDWeCchWW/XtAOadioPC61cGmgFIs0vY2IeRiXR9dOrvoK9PaAAWYq2m0yR7ATMNfRlP2NWuHGAL3cwWp5WJeU4ZqyvjHAoWidVAuKqSaHgyPZaKqx6K94sQjvUyBaWqJMHg/QocwgdcFc6cj6m2yaox7civ++tVq/1cQc+OGkLsSU1TRK/A7vdn/6tOR/TYdxmH0f+niVPK1RbTv55nLnKPaZzpAw+lchM0XaDUW8vm+/rRjRJrQN8O3GGmVJn/e87cCYCvPznak++0za+kNoZlexq8UQ37I0PQkyZ1x526dq3QleDfaJlQ7UR8d9YYr6f8TLh4lvClkTWZdmz7zIZDhlo6yG0f86wVSDXPCrSnY6RSuE1PJzbXd3M81lePLFGPzm4WznpmuNceHYbhHDSNjVBlBmz+H30BvPqBXf5eblQkq6L4oe+8F4oBZxEHYY0xbftMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(508600001)(83380400001)(26005)(2906002)(66556008)(86362001)(6486002)(186003)(316002)(66946007)(6916009)(33716001)(53546011)(5660300002)(6512007)(6506007)(52116002)(8676002)(66476007)(4326008)(38100700002)(38350700002)(6666004)(9686003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HiGEWfmjk6AHJz31F+tRLKM0/19yz30brsLFxc9I6dN45Nq0tlxSfd0kGGsF?=
 =?us-ascii?Q?2ElXEIUUKJnA9/sLxLcib+GPpUV8mcS4+ZiscGICYYEU62ZsDh64d8T35W+M?=
 =?us-ascii?Q?ftcVvOd5rk/KTmNWiMYTaiKbQt8tQINYlL43V/t0MDDPUvGuWc9WMEVg3LM7?=
 =?us-ascii?Q?byRlHt/t5VBJpUOQ5ZFNCVheex8ij3whjpltx1hHikL2QXLTFFpOp2baJP9T?=
 =?us-ascii?Q?VJAdrBiiai6+5OB4nBzobX5K49w6YJiBlbGSL/P0WO8pKjO70Owy78lj4ttf?=
 =?us-ascii?Q?+DMk+XPZPSCiv058ik0fk8gZ7SZpu3c8nGLh+uZR/5rIZFUFbJZSpPE41MB0?=
 =?us-ascii?Q?5dEfTOkvndaMOyLIZDRcQpVlz9d2ogoiTZo6f8+MxmhMC/vZu/v190NyjDWr?=
 =?us-ascii?Q?5YYGC0adS/IDWGIQgiBeOnEqVRgd2NZBLhGOCNk0F0n+JxMwMuloxs2poer6?=
 =?us-ascii?Q?NPI1gmoejiCXUoPdcSinWcTDPpxYoRWGyeKQH0gsvOhsyJWXuZpIc8px3Hw6?=
 =?us-ascii?Q?FAIqM2dpVzFWjivWknlsGfmIihuVM1fFhyeLlHuHFRRDAXaAFi6J1l3g6+oG?=
 =?us-ascii?Q?N2AhME5kEOxRbGjR+uBnGbkGoU9k6Qh4d2ltjo9H5z/8uAYXRUSI1b1smSE3?=
 =?us-ascii?Q?rsESd9i+ttxyZSXz06qH96xQO7m/wLH8LSI0EvaVjcXsUt3PxxWZWN4htBqi?=
 =?us-ascii?Q?POAfunX+xbO1C8LVvbBEfFWem9m9DfdmmaC4rPRGHSIPXsHMm1gskz4dpbSa?=
 =?us-ascii?Q?3MtTHWPO5ktLhu8hZ29V/fiPr0NE7LFYLPExQhExQnqPg9AaF+mEJ+Jy2Yf7?=
 =?us-ascii?Q?1MhNQfK5OVI8zDlGptKlDHhU5K8/WLmRzo+tsjo8mQswQ92a2UH738Bc3rLk?=
 =?us-ascii?Q?G8an6VeUIjX3fdPiA5QKrZM9JJ2ta323ocPVokTIW4oag1Y7ac2KJ8BEha3K?=
 =?us-ascii?Q?db+J5nJF4qM747HEW4TEjQ09g5PdTpY8jEMcCCXZbBBYalyK/1pKOxJsDb4V?=
 =?us-ascii?Q?tuMPhZL2BlbLiQYSGJBBeiX+oNx2Ypgwgb+k+sq5MnnyM2Br1/Iin+3IvXmB?=
 =?us-ascii?Q?6vH68a1NHPPqQf4D490OPYfYel0rZTkqG9b2BN3pbXxjiaDUSZ8YnLRJCglC?=
 =?us-ascii?Q?dR+rPPWHXjNFfRwunWxRVhpH2dh42evV0PThIxUOhHf9E4eblnFbtYra32BX?=
 =?us-ascii?Q?m2CzwkSbw8hsenPH62wcgk8r9RN4EvvXycl6VZ22ACDd9M2Z/xbf58AFMvty?=
 =?us-ascii?Q?VdUJR+vTGUpvkDhxNyv15YxMbZPYcMvWXzZnHaAISw6jqlO7E/oK+U6tb1me?=
 =?us-ascii?Q?IlUrEYlD9ipKBWhLMEvUywDIX030HRN0eY+4eVAmvx1gJ7X/yP8jAFh+IUKl?=
 =?us-ascii?Q?Mo6+PL0BjIdyO92t0+2QZ+Lz/qT19Xqfk2wj39nN5xP2cU9XY/lDzJ+4JbYg?=
 =?us-ascii?Q?BRLlZyKkAKqIgUIOy6wTlEIweWfTVF4ba/SmUS7A7s+/7T0JMd4FituG9fQG?=
 =?us-ascii?Q?J4jUVEeJ3jUgmkhRdlvK6Q3//Dlr5UEWPq8Nz5ldG9GJH3XmppGs0iHZFq/i?=
 =?us-ascii?Q?4mFUr4udGJ9WpCI1EvcFi4h2929voa8EfLpkj8MupYKPOeea39tZVtow5CMA?=
 =?us-ascii?Q?GM899q4E0uRHwRotj1GU314=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54fe2894-d294-4de7-5851-08d9fea5d837
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2022 12:44:10.3325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4NnVbyaSzanSUJgSIJkMbbFhEHiBVKQSWm4jZJ9IOptU25ZAe5bWTcOF5LkDn5Q9slh/SNo06hRUBhcfuosQ0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2821
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10276 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203050070
X-Proofpoint-ORIG-GUID: s5TL00a8EzNouWQWAm3xBAUydgZ_p7Dn
X-Proofpoint-GUID: s5TL00a8EzNouWQWAm3xBAUydgZ_p7Dn
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 04 Mar 2022 at 07:39, Dave Chinner wrote:
> On Tue, Mar 01, 2022 at 04:09:31PM +0530, Chandan Babu R wrote:
>> Reported-by: kernel test robot <lkp@intel.com>
>
> What was reported by the robot? I don't quite see the relevance of
> this change to the overall patchset just from the change being made.
>

Kernel test robot had complained about the following,

  microblaze-linux-ld: fs/xfs/libxfs/xfs_bmap.o: in function `xfs_bmap_compute_maxlevels':
  (.text+0x10cbc): undefined reference to `__udivdi3'
  >> microblaze-linux-ld: (.text+0x10dc0): undefined reference to `__udivdi3'

I had solved the linker error by replacing the division operation with the
following statement,

  maxblocks = howmany_64(maxblocks, minnoderecs);

Sorry, I will include this description in the commit message.

>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  fs/xfs/libxfs/xfs_bmap.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>> 
>> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
>> index 9df98339a43a..a01d9a9225ae 100644
>> --- a/fs/xfs/libxfs/xfs_bmap.c
>> +++ b/fs/xfs/libxfs/xfs_bmap.c
>> @@ -53,8 +53,8 @@ xfs_bmap_compute_maxlevels(
>>  	int		whichfork)	/* data or attr fork */
>>  {
>>  	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
>> +	xfs_rfsblock_t	maxblocks;	/* max blocks at this level */
>
> typedef uint64_t        xfs_rfsblock_t; /* blockno in filesystem (raw) */
>
> Usage of the type doesn't seem to match it's definition. This
> function is calculating a block count, not a block number. If you
> must use a xfs type, then:
>
> typedef uint64_t        xfs_filblks_t;  /* number of blocks in a file */
>
> is a better match, but I think this should just use uint64_t because
> the count has nothing to do with block addresses or files..
>

True. I will replace xfs_rfsblock_t with uint64_t.

-- 
chandan
