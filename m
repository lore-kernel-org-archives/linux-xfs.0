Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F910C46467
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Jan 2023 12:53:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238513AbjAJMw3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Jan 2023 07:52:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238527AbjAJMwW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Jan 2023 07:52:22 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72FAE1D1
        for <linux-xfs@vger.kernel.org>; Tue, 10 Jan 2023 04:52:21 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30ACjkWM014974;
        Tue, 10 Jan 2023 12:52:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2022-7-12;
 bh=7rb8r2hC//gSqEQCGHLhl9fxZmk999Ia1KYUmND7n5A=;
 b=BSz0sEs6qzhAIi87gD3PZh5BgtBFtghEo3+zDyrs69v1w2mlPb9ELYin3I7maRs3J/e8
 l0uBJkGP8MBAuq5LOWAR0jyUQWt6Xy0EhIdoqESr9HpcgylsvRhfaG2LvcYnG8wW5ynF
 MTZPtgwbNfQEgtvAqrNcMiLURK9x9fj/Q5jVNP3cRJ7VbbucbgJ+c4vNSr6YgZWSyRVE
 aWelSLNHJV+2iuWTzxdYCelAbLtFTQ652en8PasqaB0dn0DiBzqXOtacy3EaFXi+IItu
 zfF2IYThJERrfsGa7fhK/Y8cuxe0Xe1GvGjazvZBtOmMPO9oM3xu1HFN62V1vicix49m 9Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n14nf8f55-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Jan 2023 12:52:19 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30AClH2H036336;
        Tue, 10 Jan 2023 12:52:18 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n17dd2mdj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Jan 2023 12:52:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JzhvtU9QSRMVyIv2OpgTjKDLmRhRYt1Vl/8zt2l+Ae6uEfIra433pvCAJEKmPfJp1SbbWiSrs7r6sBpr66D7Fi73rq2cSWNw7i7iVgn376yQONqITb24pCg5tfNXn3cbKyLNJRmVJEb4lqhknLjLMufDg/+DTmc+vIvYXSFj8BH72PDMcBSJSGybAnuCHawubdyhMV6hlVMvllhhgTYncpUQLAazg7b/0kYL1Z/IEfQ/qQYhacnbwE7IuOQeQIxlouyjKDHViEttW7Z/XCY3yO25pJ8cVj4nIeV84hrXCwb4rwtzNYlA9U08vQZVlZRElCp96I3Vw8dL0JTb/pX/LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7rb8r2hC//gSqEQCGHLhl9fxZmk999Ia1KYUmND7n5A=;
 b=a9zvi8K1jisj0wz51SyYr6twpAtFr1aAImBtKIsKAvHDv9wWN1zRuJijmeYC3AU5ENQ+Ykmte+IOkXICG7k2inmIhlWuYkjM55IeD7lmhAl6TBNE9HPED4IK/Yu8ZAJZi8/cSko8OEUvZEZAy+FZOPp6lZ/jPm0ZtxNZwhMtDEPJQpyLLpBY2qYtNOCOHF66EjxoDHsdqx57gcsSXnrK2QuBOCDbWi5sDiNbqEGGTg5mIZwtHFzZKLgGc/K05JsyrNWSITyNyZ87hos2sf5dw306OVZ1d93k9btqzAnbzEpgXNHmdJRXPfiJb5fUpDGEggf4NyTb4NApW/6qgbLwJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7rb8r2hC//gSqEQCGHLhl9fxZmk999Ia1KYUmND7n5A=;
 b=mi1F6FGg3EF5dyfglHgisQ1x4A78Mj77a8PFRkxRRhBuwwJFbb6hW8AQbSM6smVA2eaCavApDoYbv0f2kdtp+EeO9VdqvAHGYEuLTnfFJGLDOfmiQWwL9m24RCiRz55v4axx05ILxUjgI0quJ7dYJFXUGgN/mmJ6QjbI+Yn2S5U=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH7PR10MB6107.namprd10.prod.outlook.com (2603:10b6:510:1f9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.10; Tue, 10 Jan
 2023 12:52:16 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%8]) with mapi id 15.20.6002.012; Tue, 10 Jan 2023
 12:52:15 +0000
References: <CALg51MN+crXt0KcsLOAUF6feGa1q5SJ+bPDy=-SsfQD45nKuMA@mail.gmail.com>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Cc:     chandanrlinux@gmail.com, david@fromorbit.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: Prevent deadlock when allocating blocks for AGFL
Date:   Tue, 10 Jan 2023 18:18:59 +0530
In-reply-to: <CALg51MN+crXt0KcsLOAUF6feGa1q5SJ+bPDy=-SsfQD45nKuMA@mail.gmail.com>
Message-ID: <878ria7ds8.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0026.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::13)
 To SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH7PR10MB6107:EE_
X-MS-Office365-Filtering-Correlation-Id: c466f81b-5a4a-4c5c-3c71-08daf3098032
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TwnBPCngfZ46q1IcQKY85plm78PJz+5wE4G6vQehAvlP99RO3Tp3PozJ1btiAI+nCr9OSMwXDO7yyBH7yr/Wq2qcAd2EL2/JhDKRc6Vgg7JXD/+4mJXsM/mug7Y+d2xSuEBUpYVwexrBhYSh40jEX0LG9w7c1me7igy30uZbr4fEhgGF8K77uBXM0onEPEg4CP7fwpJLQJPbuEhAX6sJlNOfgsDwpQjIMraUccPNSAloYL3ULVM8OTXjc6tcSk5xyT7LwOvkxHQl6bIqP5ozVR/e90ZjQQzOAPhLsQ2+bDSgiTp39KK6wIEEeqqFFvMOW2+oeYrLt4f7M4QibMYUF/AC3qcXpyg+OrDdK3JKveaOY5qRXp/2TcDaSIRDifGIGkH/qLFg0Zg1Rd5LoMk8FgDVvCaR5k32zd7g8rx5ZWOgyLvoQa2mNq7qBBmpbD5KYEoaWCIx1FmHnJ8bplc6J0wGdYtOuPNWJTi8HB/ixc0g42WWbcN+9+A5Fwogayb2Sj8ojQ3f7GzcwKmXegeTUMwh0dIWAUhDfhnc177AjJeJrF5mpM2OfJBIHWREkxUUliA8SBULxgpnYdGGINLBjgR05kFBGaFTQKK4qs9VUV1U42V11EQnShit7hXdqAJp8njtlM3AEGLvlZ84EDLt3w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(136003)(396003)(376002)(39860400002)(346002)(451199015)(86362001)(83380400001)(8676002)(66946007)(41300700001)(4326008)(66556008)(66476007)(6916009)(38100700002)(53546011)(478600001)(6486002)(26005)(186003)(6506007)(6666004)(2906002)(8936002)(5660300002)(316002)(33716001)(6512007)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WKpSNza90gQksMEoYOMS5sNX0Zmo1rp6pIsdq34d4pqOWKh0mqQuxX+qyz9K?=
 =?us-ascii?Q?iFhUxiN9ynfI8i5LWNfriU+v7f9D9MfhW/e1w8khQcpKlW97xlAruRAumpAO?=
 =?us-ascii?Q?Q6/NJ7QtMYRtgVnjX5LCpl8RHQNzwgAnnJ1ncN2kD9Yt9TQjd+VoevRBFfC9?=
 =?us-ascii?Q?4wpLEglSCw0HtRd8ucofyFHb0cZiK8tmAaRbLQKMKU0jTQcHDM0QZf66IIHt?=
 =?us-ascii?Q?e1PwdLExfJfuTGwvyixBZ+QnCqPPg9hYVA0Pykt+gmTrhevoOXdy/KWHpetc?=
 =?us-ascii?Q?xE7yq+xnIYs4c0OQ15xc3+S0eBlf7OOEhcYtBYhXnhVkXsq/aFOnzHNXYd0Q?=
 =?us-ascii?Q?mAbhEQBpwXskUEc8YIK1bYdc9PD0E7HZiy2SvjRcW+yz4IoSliJn+dCx8Ydl?=
 =?us-ascii?Q?t8OrOJiFsJidGxXn0cl/RNbQSf1uAuH9q3nZreX7tuTSzDNd8OUZPC5XJ5Ct?=
 =?us-ascii?Q?VFmqhkuN4Mp4+RNvVdWV+il2tr2eLfPLJ2zOUzjMTavJy8v3UMsO2vb+Wqzk?=
 =?us-ascii?Q?+v/N0ElGLSwAMfhcJOOAVyIhn3bSHrBIvWoMs0ZdnKE9TbrgPeZjOtjKss2q?=
 =?us-ascii?Q?/UHRxlvgOFc19qjRS7jy1LkEcA5znCDPj+4QgeQQijxe2B05cY/aTcS3YnGm?=
 =?us-ascii?Q?lDLjobWy2897TZO041fpG30WUZ1oKYE4K+NnJ9OZ8tFeECPaT3eyyfzxuveC?=
 =?us-ascii?Q?AZnjaHDeOCxZ4AFykv3ptv2XBN8r/yccbJhRYVJCjs92PcYXghTMjJSjMDh4?=
 =?us-ascii?Q?o3We+59vMkGPJKxf01PDOXPC6JZJtUyMDNBQIdr/L19sLL9se3hyVgXab8gU?=
 =?us-ascii?Q?m4zQ8OhHT8hAyVY3J0/e6UTDgmr+v1t1+F9eR9TOMhkJxDGmyxKHROQhnl7J?=
 =?us-ascii?Q?Qp2tJ+InY/qBIq3+mcqDtvGGseED68SOIb1fJJgYvtO5gVEB/v7hSOlpjP1r?=
 =?us-ascii?Q?Tn7RxSAzuO4QBteQfGvhqzU7IihX/vHC+pRzKAOCT7cltwvChUL37hU5gnW+?=
 =?us-ascii?Q?iD8KsWvpGC9HO/+inW/09/ydtHjxOzS5pSSrbgK9tbfeyssoU4xM+6b06AIV?=
 =?us-ascii?Q?EfUY4C76He95Uij/Oabd1iXCumJXMiUT4rGuVxmg4jaOIleMOVY+/2ZmEDBw?=
 =?us-ascii?Q?mdmZ3QT9fkZ4KiN4FBkoF2HWHWzh4l94LBGtH5VnBLZenIudJHnchV8WMOEc?=
 =?us-ascii?Q?zfsBBLOTbmdWEvIVa6nXUycVbwJYkw43Yum3lkyF3c/+9322AFBev0Nly+Mk?=
 =?us-ascii?Q?W+hR+vXW6uYtQgAEpb8w28Ij8OS/+sKJaWmfFKPn+beuKLul6q+/CmcB563U?=
 =?us-ascii?Q?0jCtg49SJLAHzQYmFzxZvz7dfKEAOvH2j4QzKI0LobJ1o4s4l0i3pRSJCSLn?=
 =?us-ascii?Q?mpSAvR05BG4rmgKPUkr2kbII6GU2JZDlVyKRcteqhzn/X5K3khRZKjcIbJkS?=
 =?us-ascii?Q?03IABOLfUi8bw2wPjwh6vPgQiTYaqHkhuc8cNfSKpINWOPv76bN7SN+iG1bp?=
 =?us-ascii?Q?L9uGt54iBsq5EPoqZ3zXuBQ0pKdyJ/2up1+ysb52EYwqqgeROA421rbbJOMs?=
 =?us-ascii?Q?VVMkV+gJenb3naIDnUcraeF004aaEO+avm8qd1SR?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: oaN3X8sOVHUtIyzkmoNpbVAEDR/x5M+KHGm8WPc385VEPVtYSjt0OSyzXyWCvX/CfpXN7Bbb0ioin0tCL0F3iNskXsg/nKgIMzBKHeCvlT7kIK2OvjI7yC/ZiadCpEv7bxGz0ia68BB45scFOoJNPn40UBeLyZ3ro1PIc8wt6qVS3p4TU9oJjEdwL5HXaP9kYZnQMDruWljm8XPTlbqTW4fdzo10O05pVgB0mV7bUs5tPO5HdXaO1yA72yXX8H5cIO+X3gTJpCLHd7QFVPVMvBbbqfPBxExKBjmzRDKDg9z+oebwKCFS3AzqY0LPTvXt5eAAvaRP9uDT+P6vrQK8+oOHQzD/LAW49gsTlKPOv4RBjK4WVdZ0eHqAviO2f1I+BOXacrqV9KPmvB1bNwOSmvoexAv8RCajLZkWf6eOEvf2rJcDwheaIZ8Mj9BDfssR/4+tvtPwJpWug0O3PzeY3eOfwEdX/KVuRvO7R4KRJ5jaZBAT0E/b840ruoc/2PHvzlNYsSetDSUs6O7Z5EqBWvyjw34ArvDhcdtnXhH/Q8QqdBmwEHHjdynuRSTF4QTnhzuDjyeR2y/fkaQtPY/H/g9FP0+wVHCw1WrhQ6dR/TClFFVJdKFGucwqsAtnsXI3D3DvdlTIQFQjEu3WjgozisBtliU9zHSI94dZcEB6AC79C6EBSKNXnmCFjCswUe3tFzkCd9Xv8Qbn0Z6rRzyonBv/O7hnrzsNPH2was3GAeDtc142K/Z0x1YC8fRjjX8QUx6Ld2elaH7p/fSssT9XJbuaU7xngTI7mHIVOfioXBnuup1WB3iO277cNM7v7UjwyX5zV+qnA0Y6RRuXXdf3WA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c466f81b-5a4a-4c5c-3c71-08daf3098032
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 12:52:15.8606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tNYBfkihed5Km0GbyTSplLhXl4CLLteNG6SiopEWHGyUe1qXsLL9XknjbRh9DLfdhSeuarGB0/8w7HErenaFeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6107
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-10_04,2023-01-10_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 mlxscore=0
 adultscore=0 suspectscore=0 spamscore=0 bulkscore=0 mlxlogscore=898
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301100079
X-Proofpoint-ORIG-GUID: QQp2MuN96dcqn7-iWaJWaX2u0UvGkoAG
X-Proofpoint-GUID: QQp2MuN96dcqn7-iWaJWaX2u0UvGkoAG
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 10, 2023 at 08:24:41 PM +0800, Xiao Guangrong wrote:
> On 6/17/21 12:48, Chandan Babu R wrote:
>
>>>>
>>>> Just because we currently do a blocking flush doesn't mean we always
>>>> must do a blocking flush....
>>>
>>> I will try to work out a solution.
>>
>> I believe the following should be taken into consideration to design an
>> "optimistic flush delay" based solution,
>> 1. Time consumed to perform a discard operation on a filesystem's block.
>> 2. The size of extents that are being discarded.
>> 3. Number of discard operation requests contained in a bio.
>>
>> AFAICT, The combinations resulting from the above make it impossible to
>> calculate a time delay during which sufficient number of busy extents are
>> guaranteed to have been freed so as to fill up the AGFL to the required
>> levels. In other words, sufficent number of busy extents may not have been
>> discarded even after the optimistic delay interval elapses.
>>
>> The other solution that I had thought about was to introduce a new flag for
>> the second argument of xfs_log_force(). The new flag will cause
>> xlog_state_do_iclog_callbacks() to wait on completion of all of the CIL ctxs
>> associated with the iclog that xfs_log_force() would be waiting on. Hence, a
>> call to xfs_log_force(mp, NEW_SYNC_FLAG) will return only after all the busy
>> extents associated with the iclog are discarded.
>>
>> However, this method is also flawed as described below.
>>
>> ----------------------------------------------------------
>>   Task A                        Task B
>> ----------------------------------------------------------
>>   Submit a filled up iclog
>>   for write operation
>>   (Assume that the iclog
>>   has non-zero number of CIL
>>   ctxs associated with it).
>>   On completion of iclog write
>>   operation, discard requests
>>   for busy extents are issued.
>>
>>   Write log records (including
>>   commit record) into another
>>   iclog.
>>
>>                                 A task which is trying
>>                                 to fill AGFL will now
>>                                 invoke xfs_log_force()
>>                                 with the new sync
>>                                 flag.
>>                                 Submit the 2nd iclog which
>>                                 was partially filled by
>>                                 Task A.
>>                                 If there are no
>>                                 discard requests
>>                                 associated this iclog,
>>                                 xfs_log_force() will
>>                                 return. As the discard
>>                                 requests associated with
>>                                 the first iclog are yet
>>                                 to be completed,
>>                                 we end up incorrectly
>>                                 concluding that
>>                                 all busy extents
>>                                 have been processed.
>> ----------------------------------------------------------
>>
>> The inconsistency indicated above could also occur when discard requests
>> issued against second iclog get processed before discard requests associated
>> with the first iclog.
>>
>> XFS_EXTENT_BUSY_IN_TRANS flag based solution is the only method that I can
>> think of that can solve this problem correctly. However I do agree with your
>> earlier observation that we should not flush busy extents unless we have
>> checked for presence of free extents in the btree records present on the left
>> side of the btree cursor.
>>
>
> Hi Chandan,
>
> Thanks for your great work. Do you have any update on these patches?
>
> We met the same issue on the 4.19 kernel, I am not sure if the work has already
> been merged in the upstream kernel.

Sorry, The machine on which the problem was created broke and I wasn't able to
recreate this bug on my new work setup. Hence, I didn't pursue working on this
bug.

-- 
chandan
