Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC8CCC7EE23
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 09:00:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242617AbjEZJAZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 May 2023 05:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242378AbjEZJAY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 May 2023 05:00:24 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 839C99C
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:00:22 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34Q84lAC008628;
        Fri, 26 May 2023 09:00:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=vFwZnr7ETanHhow4xLs3MsTNz2f5xG+ASfZY0n0jt3g=;
 b=sdiZa5GU0388aJOrFkeQbyrP6cZZUnB8rHkWnafxTW6O1zS56Kl3XKWWy4j8bum21IgW
 WmIswNK6vFBOWPJ8Aiy8tIiTPwgzuiIfYVVPQb33I4eTcUgBWGw28THV2xShhCQZ1HGS
 xVCTrx8DF+gvTRHwJHzK8GCAI8Lu2JLUBnRC8GqCDWnqIM7EKn2/vNYhHVT2cCxcCNBY
 h1D3Q6qpoHimyFmjeSh5+7t4wpAgNPI7wbMW8jGK3+fbZSXh6nkkGNGUARetcMHVWnAx
 A5YdB/YJQdII0Luf2mVW/TpFVgtLLLpEwjeTtgZkblz0OG48T5HfNHdpd54MDk2rjqK/ Uw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qtrxfg56g-32
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 May 2023 09:00:18 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34Q8cU4j013202;
        Fri, 26 May 2023 08:51:48 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk7jrp45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 May 2023 08:51:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jk4yjhw7fCnIr9rvdLQ2Fo/mVJmC759OuD/YMxDCracTCU5dE8kYLQeky0GZsjqotgAuNgQMpKs5Pr8A6dgTC0D0Rd8/QUQysPe3FUmbrJIUv4TIZdNaFat3X1amu0IHrhjU86ptEgwJ0/9ITQVsi1ZfBGVQSB6rvLYR9Omm3nsei/e31QYROIdSsNbyKkIcUdBjp3jZvqfCe0DcAyaG6s2QR0n7V6iRS/cOEgTA8aIki6uHam6TYp5uMuvP5O/uJh8bXBonNUijBcRzzQxcWiE6qpRrjAwCBK2cNngCDqQpFRPeiPSCvXoNSMDfTpqUiSRfAfVZ2/wK/DQhqrBUrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vFwZnr7ETanHhow4xLs3MsTNz2f5xG+ASfZY0n0jt3g=;
 b=ix5xtOuefoLeahwBVWwI4GwXuTgxNGsW+sHwJWp8251z8KKirmxxdrosHf0ykTv3Tt7pqa2C1FS+6v7dkwc94itggAaclvZcr4ySwIXdMjC5gDhhzSj18FO/CT6IPDEKLtu1TtqVtGskG5edU+tZuxYMCh9ZgEqefmvvaI8+HHrVYQmc+3n83kV4U66A8EfpwY75emFmQz9Pk9Dhhwgu4srdST0sqrHwqr5Dvw4nz8MwRw4ak3pKfHMIXDH/s3V8wgiuxk8lCwOxaOhI0vnW4HFlfVevHQZRLDg6AJMKO019GRjDHrNb2Kvjkd3fxMjNilqkU6F0su9RT2yzBZ5Myw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vFwZnr7ETanHhow4xLs3MsTNz2f5xG+ASfZY0n0jt3g=;
 b=fTIEmbNEcjy5/jCNMbprR3g06QfjkVpuZJOc/0oZjC5IOBEB8iuS0WPRkAIxjMxfZ+ury3bTrVNPJXA89tHlzSjc+elTMT3q2fTIMzrlIC1RCK+If1so3m3o4H2KU1VxSs21IYHAqd4/uk5qyqqJaGwX09OdaDOB0BaKD/OTbcc=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH0PR10MB4439.namprd10.prod.outlook.com (2603:10b6:510:41::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.17; Fri, 26 May
 2023 08:51:46 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%6]) with mapi id 15.20.6433.017; Fri, 26 May 2023
 08:51:46 +0000
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-16-chandan.babu@oracle.com>
 <20230523174053.GU11620@frogsfrogsfrogs>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/24] xfs_metadump.8: Add description for the newly
 introduced -v option
Date:   Thu, 25 May 2023 15:34:47 +0530
In-reply-to: <20230523174053.GU11620@frogsfrogsfrogs>
Message-ID: <878rdbjx0m.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: SI2PR06CA0014.apcprd06.prod.outlook.com
 (2603:1096:4:186::11) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB4439:EE_
X-MS-Office365-Filtering-Correlation-Id: c07c5d7d-6340-4309-010a-08db5dc66fc9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BD/xj2PoymZSY36aCDx+Vh+Dn3Pbhy2qnOb/VqD1waAAq6pp4yERHdhixU9WmzwHMi5H5sMFCfi6i4De7wK4ycBpqfQdXkV0fVgVYY/xeVZr0s4bJw2gpdoeIlq2PvEjJJ0LCHk3lkgaR2tcSVEWAYBU/8G44TRlFuB1l2Ksp7PQgOsnkf6u8gNsqs7+p6kNI7cr3/TKvcZtkHgs+lUDZrYHkmR6rmFnRf6VNon19dd8/+fB4IQKV74XiMBYomW42Zrk45wSd9HrOKjturuwKZ9FEBLqvJmjbjLIUsCSzpgm6/ncnF/Jdb8nlpAoe6BbZePWqYkgTtvSfv/ZhwFFK5RCLN3+CwMScZ0cFylm0cBXaZ7VHHBsZ5rs2YjQP84RkEV2NjRWlNRTMHsNGcC3DMwx1I1nnwLcN87+1FsK8kO+8GN2sEdvvoE3AHpMtULRO4Ee8ilLLrpDSYKR1AAfNy5qYN5GwNgmJ8vfhRKiRMjbvJ942zFtrUI8fzFU3SAMZ3b+vqcV3MpPwk6NBww5zjCUidgki6n1SfLPzNL1ksU9pasShCUc3F2qX1nBNnV1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(396003)(136003)(366004)(39860400002)(376002)(451199021)(2906002)(186003)(33716001)(86362001)(38100700002)(66476007)(5660300002)(66556008)(66946007)(316002)(6486002)(41300700001)(8676002)(8936002)(4326008)(6916009)(478600001)(26005)(53546011)(6506007)(6512007)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dtlu4ATDMrnxDDiZL4Ght9xBcgmT4aw2YopMBiWfW8xEVsBRdNBLl6Rd0eTz?=
 =?us-ascii?Q?Ri6QKxqmAe+bqJZxbBWldpMxe1buRWKzsG/p3tY8b2++h9IYvOsYPRFyJdyn?=
 =?us-ascii?Q?Re6QtU/jkhfioQNZlJPG7C+8U0ogTMsser8T9WczTbMWJpe688xPotqtzDsq?=
 =?us-ascii?Q?XmkOll5YPpQVA22LRkVKyKLuvmQ3wj/bJ/7rC4OD0gS6ag5P2ZpYsdVYjl7Y?=
 =?us-ascii?Q?8mHBG2Dhhb46OZ2/3WCLi8qHkwpH4KsE5nGlb0GspU1gwa++lIuHnWmnCWtM?=
 =?us-ascii?Q?JtRPrHq1WCf56ki5b/DTtQYdqe0fvHys5TLNRKVzdSPPNmMCCtdldmyXpkE/?=
 =?us-ascii?Q?FQhRokXdMFHdT4EmS1MMNDjOxAWaPZXquuZMI/kdfWbG59nDhG1bOEdlpnZn?=
 =?us-ascii?Q?0Ai5lSrA/n9jvfz4Mpx/k8hFBRvVgsDmfTGZpyBALPeMl1boTBl1b70L568n?=
 =?us-ascii?Q?swbfocLXKB3g6xi/tx6zywJG4DjuD9YARuMwZWKUhE+ZCMxOCQCumg+Rseco?=
 =?us-ascii?Q?38pJJ+Nu4zjGc52/ZbG8kA/tWy7sTO8Aig4rGIjZSBlaxx5OB6iNCPqPasoG?=
 =?us-ascii?Q?8+6SR/UlBjnqLwJCoUD0+95CnMgowxZWpxwvrRHIJYOpaa/obtj4ZGt9uAlS?=
 =?us-ascii?Q?8eWIYz1tLOUWVvWk6sT7qwELNxRd28NmuL0Sd+Qfk9vV+GTEcz5szl1J1B4N?=
 =?us-ascii?Q?LPS/NmR5UtfSHCyLIE1XZVzEvKBZ4fqfAJeUjaChVa4QJrcv4yNacP/KkDWC?=
 =?us-ascii?Q?NfTSHpw+eQocOWy38p9WHcHqfRCE2qUXvm7kzXpcXYvcPvzEeCE5xAI8c+tJ?=
 =?us-ascii?Q?7H8upgp6VYzjVDsI20m6Mt2aPSG/jCCX+DVKVZoPFCWdnKcR5aN6ho4e3l+x?=
 =?us-ascii?Q?kemBhCqxJoVGwud0lMgn68rDlH80xpEAYEtJFXOPHl7OS8c+eT7kstSBhEoQ?=
 =?us-ascii?Q?HCrydHqJvtXVkeX6n0QKvzRum8vG6b+/nOsABfNxpHS97O8Jut8f5C8G0AWk?=
 =?us-ascii?Q?8eB4h9lclvibaV8sjNa7WqKUBIGXQVI6bpfJzgulj1gMOaQMkG1MaOILIx/A?=
 =?us-ascii?Q?ayUs/8Hx+ssjL5KpsqW6z0ioF27DQOYAGvybi6PsjYA2y2XRem+jDUqG0lKv?=
 =?us-ascii?Q?DjJFZaw4kRjexfkAD5YgcYAvVm4pEV/39cUEvZIshxlrsJU2smdP9RJGSeaf?=
 =?us-ascii?Q?ztvLte/TTGR7ootKWsUGwUb0tJN1Nz8ze3MAE1Ery/Tfv0zmENWhmuRTdApy?=
 =?us-ascii?Q?5lhOz8eIyl68YaQF08nYWm5aQRc3AQuIfeVW4Ned1X9WpgVMfROz6vd7Hnwj?=
 =?us-ascii?Q?kzGtgN/qilT6Gz8T4zgFpXPBl3Y14UACG2KDfuOPGUMPiOBP1rQv5mLJS9ok?=
 =?us-ascii?Q?tk1rR7eu6MAAqsUIUehqZ58F0xe0JwCyY8IMoaTGM+QfY9SLuD0aJlhPm4LI?=
 =?us-ascii?Q?MSMdwxUbhbhFOJLMxW+JT5tRu4rz51ukm11dY2DOB2KaBfpuQUk+LZU4d9uY?=
 =?us-ascii?Q?8EJ/4/yscaqBP4hj+q5HA7hfDAwYlrvkITxyMc1Vi8KxQ9AsLLdgxNPXopCn?=
 =?us-ascii?Q?D9+c5/DloIy9LsiCPcjk39i8IzmM3hSkYlgmIeeL?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: FT5l3YfTFBkuSu2/Pl8E2RxmEd3aTrUIBj6ME5M4p3yqP2aJKf5RUnykq8hQoD3cZq84KIp54QK4C00a+UllU/8bfpGPRrcr1b3cDUSWLuWKHhS/71dNg4pfi4WkislHZF3vg+ubjNghdK6RRuL5ZVQ/8xR57rETRsfAyOZaM8jVR5PN8GqBuPdEfG2tMONhKSfv9L4mPak2dZp2egNEBnWlqNyclfcflVHWrNlOvXKbNqICKC/5IFwMTFcST6pIN4g/5CzMNqJoyXK+brnRw/xBsuY3s54R+rqgpbKdQy3ulSHIGi3gNMZhVPHNUPyf8W2Fy4kDpUhdYTZ1plTHejT7tEK0iS1Ib6S76JRtxQgJPLXyUI5hGFa9qiXydQec76ArziDBVHcHxVaxkz1jVF+/2jdiVuuu5+kmrzOSgy1tRbi09irRftd7CxOlvFB6TlewRz5kuEKZEw3EIUJuBESUoE+K85BYl9WZZin6wM06VSgDbBzhIvAwXMWvV7591DcSaHTG0FMbwpCYa3AQNIsX+bjF7ZtPyzkZyfmHaXYkDFP2IpwEp0A9Urc33fOSNr3w/hfGAA0MezIC1PwhlPSSFICPgQQNoezMIJNNq84ybbA6a49mNdZuIoTsUKmqBdtZkpHd4NVsGhlG5k6la60RKfBnD+Kshvk3spvaLhQc8w7xGV/Ilf8e87lfmabG+4MOT8FbrajHWwIqhz9rnLns7nAzfFjOh4FRbvVzsE1FS5dg04NkMHH/dKo/5qKkr+TtFfX//0dY8ilE6h9Sc23WyYgGYeSKdQL5+mODxSI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c07c5d7d-6340-4309-010a-08db5dc66fc9
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 08:51:46.4587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: URKMtTHkHBW/Ml0Iqc6d9qZcOMfx6tPWwj9QfRSdr8Di4+YljnjRCZbjY4D3L2qpIXUnJPAuNtuSNjz2I2/0JQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4439
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-26_01,2023-05-25_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305260075
X-Proofpoint-GUID: yu-L6jyAJKkt2vmmdhvBxrBujKW7Zw1W
X-Proofpoint-ORIG-GUID: yu-L6jyAJKkt2vmmdhvBxrBujKW7Zw1W
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 23, 2023 at 10:40:53 AM -0700, Darrick J. Wong wrote:
> On Tue, May 23, 2023 at 02:30:41PM +0530, Chandan Babu R wrote:
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>
> This should be in the previous patch.
>

Ok.

>> ---
>>  man/man8/xfs_metadump.8 | 10 ++++++++++
>>  1 file changed, 10 insertions(+)
>> 
>> diff --git a/man/man8/xfs_metadump.8 b/man/man8/xfs_metadump.8
>> index c0e79d779..23695c768 100644
>> --- a/man/man8/xfs_metadump.8
>> +++ b/man/man8/xfs_metadump.8
>> @@ -11,6 +11,9 @@ xfs_metadump \- copy XFS filesystem metadata to a file
>>  ] [
>>  .B \-l
>>  .I logdev
>> +] [
>> +.B \-v
>> +.I version
>>  ]
>>  .I source
>>  .I target
>> @@ -74,6 +77,9 @@ metadata such as filenames is not considered sensitive.  If obfuscation
>>  is required on a metadump with a dirty log, please inform the recipient
>>  of the metadump image about this situation.
>>  .PP
>> +The contents of an external log device can be dumped only when using the v2
>> +format. Metadump in v2 format can be generated by passing the "-v 2" option.
>
> Please start each sentence on a separate line.

Does it need to be formatted as shown below?

The contents of an external log device can be dumped only when using the v2
format.
Metadump in v2 format can be generated by passing the "-v 2" option.

>
> This also should mention that metadump will pick v2 if there's no
> explicit -v option and the fs has an external log.

Ok. I will include that as part of the description.

-- 
chandan
