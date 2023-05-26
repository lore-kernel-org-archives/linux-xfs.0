Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A0BEC7EE23
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 08:48:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242575AbjEZIsm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 May 2023 04:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242614AbjEZIsl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 May 2023 04:48:41 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1F599
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:48:39 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34Q8JwXx026817;
        Fri, 26 May 2023 08:48:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=RATBCbEDIFa0wxqCZuapw4GVvT45ODOOhARg14R9jZc=;
 b=eCjpyPJdZaWtLi1Bo7az1s8OORoVfnRQCgVg4FmFlco63qw2YsYeZ3OSk52LEtqd3IVb
 0MmetPayLYvMkLbq5d0UIWk3ZNZ3zzYijR4H7CYeaDdknC4L8gK6kv90sVyhjuQtDuBm
 uCVtdfyq3kU/SBwy8r2QmnMqy84xryOPUgjJSZvBhWqJ0hBARfatuYilP4Hgf3XoBViw
 m3t8X+7MdXc/FBO4Y1ve0xFulnoiCy/kn1VpHehiMaQzRzwx8RnrQ3B3lq+S2N9JFYEE
 oc0qgZDASgGoxHPzv4uwebPZ41PKh+qxjLPilPL4Ko5tWk6UR5hF2v0i5nuK1a+BJwr8 xw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qts5m02s6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 May 2023 08:48:37 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34Q8Xorj029043;
        Fri, 26 May 2023 08:48:36 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2048.outbound.protection.outlook.com [104.47.74.48])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2eqfbh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 May 2023 08:48:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MwyzojZudDkoycB8kZT8jT1SnN8E+MQo1u5ZKIgiEvh51J8XQ5M1taqC77gmORV5YyxVXcAb5Bfmnibrjld4vG+yvNjSlJ5S9Ngp+iLlxf3wpJmZFFMmsRlrEpXOm5VrM8oOgkipjdDkjY81lV5J+G3R6ErYI1kKUaZvY0aHeHTOylGMmMFTAOcwOzkZFWQv9ziU0+2e9WeN62i2aYC+zp0VNREM3eP4PoiT/uWNDKPv1P88wvyYqRcmCFt4eeqsN6Iqp+B9u+B7YGnbPYdVj0MygUF17NZlWOi/0w4YXbwDb8Bo05ut2CSfW3WyEomhp+x12V3AmS1+qxIw+8kjrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RATBCbEDIFa0wxqCZuapw4GVvT45ODOOhARg14R9jZc=;
 b=YNKGk72WY8o93zkFwoSmJwK6ZlOL75FdpxT4s82bTvYtleIIi/souboDXw74jSRVH3lVZY/NCtMH8Uc51b7u9OSeTb8RjTA+9SWSh75P1UaJcAlc/LiglwUmpWmh9XLHshlnQUcmd9sgxYGUKCWX9hwU1bFxE+XwIxORDqllKJZCGrRzuF5r0eg/Xica+SkkUpR/ak+hKxdsEaXzaMurKCmycpvI83Ym1gKl749HRRwCRpF15Bq+BIwKFKozSB5VPJ93VxPXVcuf8Zc4iqmXWVSdNxbPCEsk3qSTEupCKhUcLjQDtrdYX1XllvL9uGLRhCN7hcqSybHJ3hn+V0Z9MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RATBCbEDIFa0wxqCZuapw4GVvT45ODOOhARg14R9jZc=;
 b=G5JVOiz2tkpisUvzkmqxWtAioPtwghpqQmBYjQf5AEMJGUtbZslE+35wLy6yiuNbC1W7UfHz/Y1ccwfyCWoDja+Ow3o+xuKa0QV5wnO1R7jc3MV87IQrwXfK7Gx38J/qTYvstBVMoIUE4vWk7546R8c5rdCgq1VO3VTQYUy8Zio=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by IA0PR10MB7183.namprd10.prod.outlook.com (2603:10b6:208:401::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.18; Fri, 26 May
 2023 08:48:34 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%6]) with mapi id 15.20.6433.017; Fri, 26 May 2023
 08:48:34 +0000
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-7-chandan.babu@oracle.com>
 <20230523170212.GM11620@frogsfrogsfrogs>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/24] metadump: Dump external log device contents
Date:   Fri, 26 May 2023 12:24:31 +0530
In-reply-to: <20230523170212.GM11620@frogsfrogsfrogs>
Message-ID: <87y1lbjx5x.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0044.jpnprd01.prod.outlook.com
 (2603:1096:404:28::32) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|IA0PR10MB7183:EE_
X-MS-Office365-Filtering-Correlation-Id: d22bcfcc-4ff5-4061-4091-08db5dc5fd16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9hv/armyG7NFTcRrVgvAk2i+rp733sHwkQzQl8/IOOcIqsd8R4FDqxZltRA/RMsW968dO6ga5KkF0Ypw5pcgGWF1m2caEO1z7TmnXpsngWEe1omqF6eh/PL20Bs48s1ajL/MINyGR+hDmcDoxd7khQVcFHit3k8Vwl8CU2/vum//UJDohWJQPCGA6tGvUyyG1uhtsu48y8et4S//p6zmmk6SnYSs+iD7qQi7dJAZtGQrUDx4rIrAwxt0Ckq0OzqGMTIUEIC57hEsdxX7PtR46LzUzKqWWKK5b0kNvqNZBIUuw81x4w/vV7LY2uwZ7JjiMMZFj5/Jb7g4tlSPy4o0/I4rtp9SXOr6jwDVuTIcPPYVF+Jv5uPG30ZOFmqQT5lW984gGmGKX1/7rwzTCZOEgCXM2m5tfl8iu8tFZWus5AMuo+UcLylIEZBhN7k7dvtQP5nJdbpIl6IXaNtYy9AqtkZFYbZOwGPprkrQwukn/9kKXDFQ3sdK9JYv0pmK11gds//KMlTCDFdLD6iHt26+u0PBKf3XFHA2jl6uioCweyX6PU0SPzhdYY4JMQUNlDW/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(366004)(396003)(346002)(39860400002)(136003)(376002)(451199021)(86362001)(2906002)(186003)(66946007)(4326008)(41300700001)(66556008)(66476007)(6916009)(6506007)(6512007)(9686003)(53546011)(26005)(83380400001)(8936002)(5660300002)(8676002)(38100700002)(6486002)(316002)(6666004)(478600001)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EyUKjRYaEXsvMSs0LxOeNdCGWmKc2Z+UTOlhDsptiILTaKte2jtB4ku3krwv?=
 =?us-ascii?Q?rBHF0aH3sm6r5W7UcW0Hv+70RIToWWk4weH3PNJTpAUQ4JfrIA/0NUbfxIJP?=
 =?us-ascii?Q?jnO5Su/ozD5mehTDSo9y3azT9SNoKJJynTR0clVxLk/2Cp5YEW2COKi3AEh9?=
 =?us-ascii?Q?9m2AfpMZ5f9haKMNLqSVgUMBxLOtQzE8PyDGdwB3r5i0OoRCucm3i6e4QxsN?=
 =?us-ascii?Q?NdkhdpOMH8jp/dK8M57GoXas3REqkUEQwF0u1ondfQkMW/V6JZRKw1T783RU?=
 =?us-ascii?Q?U3nj7NPKLD8LwAJqhCe1CYwIs48ZdDrEbnjF3vic8fH+uw1VH2lsAPJ970dW?=
 =?us-ascii?Q?IIV0UqobQ4PcMz/00qo6LaSx/YFOBAsDqScbZz9gZ4CkFM1VXP8PKnEuJVqV?=
 =?us-ascii?Q?gXvfPGlsVvEP9kVRsxStANUdcdo3MzqoFyP2XVYR7/6AqhFJBHHjLFiSLDFP?=
 =?us-ascii?Q?KU0B7KohtvCjM4cE4Sjbmj6pZsYw8H9sz33toGyz4TjNtJGLwJlW5f3VuCYr?=
 =?us-ascii?Q?YI80v2xytg/wNNG8otx4Ngx3Tqga19eEHdDdMhUtrjQUxhCbuf+YREv++HFY?=
 =?us-ascii?Q?3n9Lc3KaxJA93bEipl/MviURSj7Xp0z6tnbbooH87yVzlXLe0Xp3q8P5KLTJ?=
 =?us-ascii?Q?qnGIWzPbrhecFm82RIaNM3uc46Fr211Fo35CdRaF2MflJXxqB9YpulWIz7Hy?=
 =?us-ascii?Q?AlmqXcZxYfQw/Y2txg34JTqT6yynl60GEmMw4R305HfJyaRyN8VDNCetdvXn?=
 =?us-ascii?Q?PM7CYK3Y37t9a6V1u5T631eCWuW13fD0Sb2HhkKj+Jl4QFarkcoUPqH3Bi+1?=
 =?us-ascii?Q?umaXQ7aJDgBciyozvGQ0YyC8bIfZpVMvfEc9W/U8zNPf4MBpjdXAu+6gAeTz?=
 =?us-ascii?Q?tbDNmktRzTMQpkwbl+yn6OWrXhotr90KhJ5BnKB5iLLnitpfOyVdL6BLACmt?=
 =?us-ascii?Q?2kdbIHiJz9Bv8gMUAxj5MQYQfl/P8KSK4Mx4hMuGiFNpjfZQX2fyeUY5Piyw?=
 =?us-ascii?Q?wryft/GwOoGX47fu7gXSed9YR3ANbcXI/aQsKHNDI7Mo4Fd6YJKYKBvsSvpr?=
 =?us-ascii?Q?+fCrDqU4V7HanH4BjDihTtkeCqbwSM6tkCg5x6SWVMwnxnZ91cZxDHIo8Fo0?=
 =?us-ascii?Q?9dp2tih0TINGgzAtUCm8yvMJlbnnzVFq0MbeAjopu7dwqsd08UipiD9bds57?=
 =?us-ascii?Q?vjbKBU++Lo4fFskDY0oppOufeup2yu4DBR64/nSTfCeiX8qmBCwBpA8Uv50L?=
 =?us-ascii?Q?tQUDKdhylX7fgKBtvr09rOrvuPeRFu0r/FrwsyeqiLWu5UqvMOSY4m88tB0b?=
 =?us-ascii?Q?mw4yEE8wNO71B7P3BRaKk1CUd/zV3zDxGtUFfby1qsHUYqKDuLBuFywKKXXl?=
 =?us-ascii?Q?+mmSxyUpHI6sXzdDnGAvqRiDozFZF1NwndTBKA09n/L/Hj4gAnDRyUWh89pE?=
 =?us-ascii?Q?GqZGl5mEqDr6NNncUxFf7trdXpAtCXW+Rh7VvZ3E5J8Kj2LLzqbeCnEFMiRn?=
 =?us-ascii?Q?c55loyHzFwbNyrYZGE26AOJ9s9j7Plw+3tKIjBofXMVck5pB2L4y/exPOAr9?=
 =?us-ascii?Q?NyM8LNYojYXQiG9Jx+Bi/E6J6lY4TfKoPZx5lZgO?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: DZindiCsKhuYQbjC9wlbR7aCH4NHbwyYyqSaPVPXRyUSeIlXx77vcf0g3Yi+ysRF4ygrXYwt4qssPQ7ASpON4loPi1Hyke+6fo0BF7AIfWqcK9Md6UD7bRWDZUskWIOXSw8Tt/zq7oxPod7wIt3SwMMN/areZ0FtNcnqIcDWysHwDZhpAd9vL6y4igUQjpgrxj0+C3KCPI52i6mDNCUb5gVggyVcQkf2fjOuZ3yIsF9EDeGJrPpYyUytOO0+RNzOlr+U5vm4e83cum9W5hVDjtO5hqk4641xNFO9vKMKUltJ2fHG6VMGIhqX9bMcwkJBFf0QDHBRG8fvPa0sXbp3DczpWh2OPbUmutzhcEYyOKi6Y9HDynm7fG4916wgr9UgvrGwdXV8OHaN0+tWOHx+ifD+K5itqU8GY4adQ6zOXu3sbKRtQgMGFy9qB5voMR5nDSr17ba7C9VpG6QseZXsmJavk+vec0gngpsq9UxcwatO+aKt/ag2+MxexgxCTbz0dI/+WUJCmQlwSXgJkN636Y6lANhF7kDvQh6UBDPpk4q25WsdMi16n9NJMbGo8CjWqXGrtC23qKHmqzB5J/besR309esyAGOj2RgJd6/FQitgBm9HSSmTJJIfBv9Z71DgeDPp5+wzUAk5jlidblfftInQpl7wF+WZeo73XM2f71ILYpOu5j165dseQ4SYdfXeVHLMJdOH8Oc68rrLvURxhLm+b4UB0RXUqYPQ5kSjZr0Dr+AcvWtvO78Dx6y5dVoMl53K38VV90cULJuIfTZI7jLMYpGYUgPFjSvR6knxBJs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d22bcfcc-4ff5-4061-4091-08db5dc5fd16
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 08:48:34.1509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wbQe0e+/EF9BO+cg8Nof8WsC/Oj+QaGrlQeg39lTBOt0+V1hRRj1VC4gfA1mgeNHp4YE2frV64mMNzH1jV6lhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7183
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-26_01,2023-05-25_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305260075
X-Proofpoint-ORIG-GUID: PInM4EWA8fj1bnyw4HqmOM-L6dl4YX1n
X-Proofpoint-GUID: PInM4EWA8fj1bnyw4HqmOM-L6dl4YX1n
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 23, 2023 at 10:02:12 AM -0700, Darrick J. Wong wrote:
> On Tue, May 23, 2023 at 02:30:32PM +0530, Chandan Babu R wrote:
>> metadump will now read and dump from external log device when the log is
>> placed on an external device and metadump v2 is supported by xfsprogs.
>> 
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  db/metadump.c | 20 +++++++++++++-------
>>  1 file changed, 13 insertions(+), 7 deletions(-)
>> 
>> diff --git a/db/metadump.c b/db/metadump.c
>> index e7a433c21..62a36427d 100644
>> --- a/db/metadump.c
>> +++ b/db/metadump.c
>> @@ -2921,7 +2921,7 @@ copy_sb_inodes(void)
>>  }
>>  
>>  static int
>> -copy_log(void)
>> +copy_log(enum typnm log_type)
>>  {
>>  	struct xlog	log;
>>  	int		dirty;
>> @@ -2934,7 +2934,7 @@ copy_log(void)
>>  		print_progress("Copying log");
>>  
>>  	push_cur();
>> -	set_cur(&typtab[TYP_LOG], XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
>> +	set_cur(&typtab[log_type], XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
>>  			mp->m_sb.sb_logblocks * blkbb, DB_RING_IGN, NULL);
>>  	if (iocur_top->data == NULL) {
>>  		pop_cur();
>> @@ -3038,6 +3038,7 @@ metadump_f(
>>  	char 		**argv)
>>  {
>>  	xfs_agnumber_t	agno;
>> +	enum typnm	log_type;
>>  	int		c;
>>  	int		start_iocur_sp;
>>  	int		outfd = -1;
>> @@ -3110,9 +3111,13 @@ metadump_f(
>>  	}
>>  
>>  	/* If we'll copy the log, see if the log is dirty */
>> -	if (mp->m_sb.sb_logstart) {
>> +	if (mp->m_logdev_targp == mp->m_ddev_targp || metadump.version == 2) {
>> +		log_type = TYP_LOG;
>> +		if (mp->m_logdev_targp != mp->m_ddev_targp)
>> +			log_type = TYP_ELOG;
>> +
>>  		push_cur();
>> -		set_cur(&typtab[TYP_LOG],
>> +		set_cur(&typtab[log_type],
>>  			XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
>>  			mp->m_sb.sb_logblocks * blkbb, DB_RING_IGN, NULL);
>>  		if (iocur_top->data) {	/* best effort */
>> @@ -3185,9 +3190,10 @@ metadump_f(
>>  	if (!exitcode)
>>  		exitcode = !copy_sb_inodes();
>>  
>> -	/* copy log if it's internal */
>> -	if ((mp->m_sb.sb_logstart != 0) && !exitcode)
>> -		exitcode = !copy_log();
>> +	/* copy log */
>> +	if (!exitcode && (mp->m_logdev_targp == mp->m_ddev_targp ||
>> +				metadump.version == 2))
>
> Version 2?  I don't think that's been introduced yet. ;)
>

I will move the aboves changes to the patch which adds the "-v" option.

-- 
chandan
