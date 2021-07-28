Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17C2CC432BE
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 09:05:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDE6660FDA
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 09:05:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbhG1JFQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 05:05:16 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:18454 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231287AbhG1JFP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Jul 2021 05:05:15 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16S91QDb030816;
        Wed, 28 Jul 2021 09:05:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=n2Idff2mUHRS0ttmcrZyKEWaKXyjwdc8sAmPRyTqLvA=;
 b=stSMFVyVE0OrU/g67lpJMyl3i9bKHDZ/CDckkxDIAtkNtcy638rP3yxNq8h+CAZWGw0L
 lEy8Uo7hiboHuS97QV8Xsv22jWiVvggLvV+Ba+BZwW3g9lMvFdiL22sJUUrMi5vWe1hO
 TWLtq3Z1kt65xUtvs8xcLj4/WgLe4NmRqlWvRa+BentZrXf2Ss/iWvdROB20AIlfCLQz
 yQ3uQ9RInMAqqBGA2HW21uLhxPajaLj0Y8TSTbzXj/WWPfYV7d3y2appLsdQRSRRgJxz
 RagS/HoMnS3v1FucpdbrmMNsLTIIiRCQu26q1tVAJ4pkQVAmaAJD+K+ZPDCrFE+g2HHO DQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=n2Idff2mUHRS0ttmcrZyKEWaKXyjwdc8sAmPRyTqLvA=;
 b=JYC1ZNjmGEPSyQ6O2aYexfxWJF+jCcIKH5BKWKVV9zfeD0y8cWd2/Js6Q1cV3Ob7ffph
 9lVvanK1JmNuDbtW0xA75X5TY5lLWSdqaSY/y2cnRLXaj2+XiAHXSiPfN02WiU81gFYG
 l1xFPo5st6y51Az4dA4ZRPFfYphMWb312f3WXJh5+UVxV+WDyC/w9yYzPkVgXjYdCf9e
 by0EpHTGAnhqxSZ980d5fvGIU48TE4002kJ90hyFKNn6zW7Fme3zm2QMDsBpB7OhIsFB
 BHXUIdUrbTioexJ+Rns2m83eD/HYEcS3Jo2t3Dbm8XzUUqRwaBDjYQwCXvAW8gr4ys+r iw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a234w41vd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 09:05:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16S8xXLO046430;
        Wed, 28 Jul 2021 09:05:12 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by aserp3020.oracle.com with ESMTP id 3a2349sef5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 09:05:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GV/VFDEdSWyY2j2X6cVLH6OYSxVNwGRu5ptrsVh6SupFwPiRSdgOwEcDwfXJuIHTwfnxOLB29mv7nbfpyAJ6VrtqXlsJkTIEyGDfqtKNFEJTs9n4Xvqvuz+NeakIm6/egfWCXwMN0nt4r5WHYRfgcKLKVdvTn4dvZHnablh7K6BdJXBmnJa1gtf31EuKC5qHHlZCp+FbMHoMFrfJsC+oR8Wqd9hp90zwtAY6f8ODEyd0CR9XeV8tm0XxWh46FZNM3E/0vV+8UR/G25nudJpnEUb140fG23wZiSG0fGE7iUxbMPg+nnMTo9f85y6xWBNugNvWIDAImoUodF2Zk7dGlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n2Idff2mUHRS0ttmcrZyKEWaKXyjwdc8sAmPRyTqLvA=;
 b=VcTLiKvKVY1S517mcY7itP/ZJgnWE6rwqM0HnxdHrzY1GmsYyaY+eTo8UlIEgG1i+1UTknutNd5vYiKJWG76vYK/ymF6ZEsEeKvT8yf7MNKy5zldILDal2YksIjHc1An0xpLCs/ISr87iRajTKhxnfs0maDjD7pyaf53iXIWEC5YK2idOjGjijzqFbZNvKL1S9W/yCcJKm4l515ou3A+E8QnTIuoTCPN9omFYkOrnuu4a/TqrGOMVis4zZOV25tOyiUOKSvJB8iZdSTbkavwVKfytY4ZKPbhug3M3fm2pgCLUeZHtnkgw5p46OrvJjf9PxO9rkrnrQZ+/CQAHA4k7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n2Idff2mUHRS0ttmcrZyKEWaKXyjwdc8sAmPRyTqLvA=;
 b=bA9xthFa55Amty+O2es7XmGClUPx1kUHFReIiQhgqUdOJb8J4V3aYa1q3o9rZAHog+oOMkD23DNH3IHlZHApnv/oede0IHdLODWYQQiX3LrqkVGQvK6/jbgAl1mT7WCwLNCw1WvjfIBvDClk6FDy6y+fFQ4z2vJyFLvd7Yb12lo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2966.namprd10.prod.outlook.com (2603:10b6:a03:8c::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Wed, 28 Jul
 2021 09:05:10 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%9]) with mapi id 15.20.4373.019; Wed, 28 Jul 2021
 09:05:10 +0000
Subject: Re: [PATCH v22 14/16] xfs: Add delattr mount option
To:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210727062053.11129-1-allison.henderson@oracle.com>
 <20210727062053.11129-15-allison.henderson@oracle.com>
 <20210728004757.GB559212@magnolia>
 <20210728021303.GA2757197@dread.disaster.area>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <09ec631f-4cd8-cd6e-ea2c-76dab5d4b26f@oracle.com>
Date:   Wed, 28 Jul 2021 02:05:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <20210728021303.GA2757197@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0246.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::11) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.166] (67.1.112.125) by SJ0PR03CA0246.namprd03.prod.outlook.com (2603:10b6:a03:3a0::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 09:05:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9485d2bb-c840-4c03-afa5-08d951a6cda1
X-MS-TrafficTypeDiagnostic: BYAPR10MB2966:
X-Microsoft-Antispam-PRVS: <BYAPR10MB29668827FE2446CA0F78A14595EA9@BYAPR10MB2966.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qo790YnVsIE0TN0NyXPFsxs9mvOwEpgqZMEcgP/xaEmKYkyBVpaG6bNRUrvBKukGLkVG/nsTuMt5qo4DeJBFIdzqyKgnoFvo5AhX3aQ2N5IIczeZrVB/wYYHMgIPE5VMYC7EZPMzdiEuBM05i0hTT2Vqe+hdaDEvV2qfrTBhFl9Fv0aCXmoNEqeMQ6D9fRa0P4LZISelnbmY8rSCPm4sgoJIwpzseq7fxGkr2ClV/+MxzF8vjMa+//cu289AYijdkQrvUx03efaGgRdgum0iDP2RDpAesIqv/iTq8kN9lmZCxdV6itZ1L4ZJJSB6Vu8cv/dijCZ9FRZxK6ORy7tELaZoLnhhT8JKhZv/AamZGXNnPU9MbBEqcLrEpEJAo0gCFE2g0v5DvoxQAhQYNgrsIM6/mCLZAnhNWieMZWt6wcFrIGPnsA/T9m+vL2IaPwaHKwLlFsWGfcPWHRr78JkUQ2XM2dCupSWchi18grbmRoqA4Jp9FpaGSFW7ju7kb2yPMiaDAyTWS0Ejga0poRw48683jO/XuwJinhFDX43I0Quo81yZGUnEQmT7FG1PqrmoGVez8FgS9doBHZTnZWZXsjIFH5WN3GekR3w4o5fqkHtik7Kcq0eWy3a6HHaBkeGze3ultKmgrrsyTDhP9dkKr9otl8nIIc2Af8Nbt4Ibd6w6yHkcWK3Gdh9rW/vRp9vNG8EQNcOI+oYNWA1tdhvifDC/R2oiCun8ns9l08enyrsNJEfNaI8iYlwzX4RIQAouUd4yZqGWWkajjPfDyY0B7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(38100700002)(26005)(6486002)(52116002)(2616005)(38350700002)(316002)(66946007)(66476007)(66556008)(83380400001)(5660300002)(2906002)(508600001)(956004)(36756003)(186003)(110136005)(16576012)(44832011)(4326008)(8676002)(8936002)(53546011)(31696002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bGdoamNhcldRU0hFejRSU0RoRk5Qam1CRk15TXFqeTZ6SzkyYjBRd1lJL2Nr?=
 =?utf-8?B?SzAxTUhwUWc2NEpWVDZVek1UOGg3b1JaVGJYWUUyTEN4b1lnWU9qdHBXZDA1?=
 =?utf-8?B?OUFlR3d0VE1pWGxxNUU0b1NibnpSSnF4aGxGQU11TmFHbXRkUjJnc3VhRWNw?=
 =?utf-8?B?S3l2RE02SDk4WnUzYTJLVGFQN1FPT1lzU09DVXBkNmJOSzRDWG9SUUdYUW1n?=
 =?utf-8?B?TmxMLzJTRmlJNHVLUGFQYUZraVJWRGsvRStvc3QrUVRTRXNNMHhmUWZDSG5x?=
 =?utf-8?B?SlBnK3N5RzFiV0dyVmUwMExSV1RERk1rQkJ3a0tSL0VCSVM3alBydElacFFZ?=
 =?utf-8?B?OFUrdjVOTW93V2NwcEJxcjREZmJXV2pGNktjKzhiZW5JSDFaeEE0ZFdtVWF1?=
 =?utf-8?B?TUNNUEM5NnBrdnpFUXlRRUdPWDFweUhIeHh3eXhzMUc4WWZFMmxlRHFrSEdN?=
 =?utf-8?B?NU5DVDR3OU9hV3dtMzJkWHcrZk1RdEl3R1ZER3VxN2c5UnB5NlJXcWZpZEF3?=
 =?utf-8?B?Y0VEb1JNZ3RYenN4WWJTRUVHd1E2dHc5VEFpbkI3ZHh0ditBQ1l4aUdhS3Uz?=
 =?utf-8?B?S1dVVTE5Vk02MXFJUytkTlRBajJWcno5dEVPSFZRbHRPYW15U3NCRmJpQVA2?=
 =?utf-8?B?OWZDV0lKcnordnVlcnJ4VVRneDNUQ3AyN1hVZ0t1L1Nla3FKOGpDYlMwc3Y5?=
 =?utf-8?B?KzZ5bDJCRFNYdTZBaDdGN01VaUliWm9sWlREdW5pZTA0VWw3NXI2OWtvTnJo?=
 =?utf-8?B?Sm0yazRscXlMbWxLYWJCbkdmZ0pjVkgrSjdNUnprQkwxazVVSlY1MTdsdHVZ?=
 =?utf-8?B?ckVldEN2MExqSWVveHIyUE1Dc0xUbE9iQ3Q0UzJiVUVBczFRYW1UMEZWendv?=
 =?utf-8?B?bWhNWVNzM2FQZGgzaXlsZmU3OGo5cnd3OCtOdEU2V242TWtzN0Y4c0ZHWTh1?=
 =?utf-8?B?YmE0QkkxOCtmM0hkNCtiQ0lpcDZwSnNKMlVHRzFjdjIwN04zMGN4T3BFTVVv?=
 =?utf-8?B?WXBGTXdsMldqTkxyQ3BhQ0VKL2tkazk0ZmprU0MyYVd4OWxlOWVHVnE0VURx?=
 =?utf-8?B?cTRvZzY0VDdqQWxUa055NG9YUkZYTkhZTHR1V3VENDR1NzJpT3BocC9INHRQ?=
 =?utf-8?B?VWI4MzQ2bVoxMFZXdy82cFM0SFgrUFJFNlNnSm9qSFBBUWYyTWtZMDYyT1JD?=
 =?utf-8?B?VU16NlhRL3lreVYyQmtObDVWTXUrclNScmkyL3QxbmdSOTF1WDJSZEo2SHB1?=
 =?utf-8?B?cGdMRXBZZ2IzV1dPamRMWkc5VU9RZjg5Nm8xeG1uU0t3VEFRdHU0L21qd3M2?=
 =?utf-8?B?dHk1WFBVWE42bmFhOXFCWlZwMGtTNXRPSHFxNUxpQ3psZHcwK0w4NDN0UzNM?=
 =?utf-8?B?VXQ0TXNKN25oRnZmaDdwTkwwYVRWYWg0U3RQeWR6LzcxeDRVZVlOS250cEhG?=
 =?utf-8?B?TlRnczY4T1g2WkxzU3RZdWYxL2dtcTMwN1Bva2hhc09LVEtOdUpwQzZtM3pP?=
 =?utf-8?B?MjkyMXRpWG9vQ2ZaSks1Y2dOc29QclB6WFBWeTZMMlZRditXVUlSZUxxS0Fj?=
 =?utf-8?B?aGtGZHZabXpYelp3NWw0ZzJTWWRVeFVvc21HdWJ3alRTNGpLRzU1akM0QWUw?=
 =?utf-8?B?Rk0vRlR1Wi9QcElqdmdqNEg3bWpLY2g5bHVjK0ZoRVIxbmg0STdRTUpibWpy?=
 =?utf-8?B?a0NJaUc3Z2pKNy9YMkhOVUlPRENZU214U0dZbHJDdnRLTXlWN2hkd1NSZVJm?=
 =?utf-8?Q?rqX0KlvQJdbv4IEE1CKBmQ13s/FVnCL95KRdjNA?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9485d2bb-c840-4c03-afa5-08d951a6cda1
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 09:05:10.6719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3/MbsiE2yut/1d31Ju67j9vYxarzPKOrHgozlLIcmyFOpugsdQ8eoq9i080izXwB5I77vZZesbaRlAnsdxjeNrNGUP5sDIVUDLbW0LZxt9E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2966
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10058 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2107280051
X-Proofpoint-ORIG-GUID: l-gXGLrjIx7pfhDmu54gEY5FJ6K6t6aL
X-Proofpoint-GUID: l-gXGLrjIx7pfhDmu54gEY5FJ6K6t6aL
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/27/21 7:13 PM, Dave Chinner wrote:
> On Tue, Jul 27, 2021 at 05:47:57PM -0700, Darrick J. Wong wrote:
>> On Mon, Jul 26, 2021 at 11:20:51PM -0700, Allison Henderson wrote:
>>> This patch adds a mount option to enable delayed attributes. Eventually
>>> this can be removed when delayed attrs becomes permanent.
>>>
>>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>>> ---
>>>   fs/xfs/libxfs/xfs_attr.h |  2 +-
>>>   fs/xfs/xfs_mount.h       |  1 +
>>>   fs/xfs/xfs_super.c       | 11 ++++++++++-
>>>   fs/xfs/xfs_xattr.c       |  2 ++
>>>   4 files changed, 14 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>>> index c0c92bd3..d4e7521 100644
>>> --- a/fs/xfs/libxfs/xfs_attr.h
>>> +++ b/fs/xfs/libxfs/xfs_attr.h
>>> @@ -30,7 +30,7 @@ struct xfs_attr_list_context;
>>>   
>>>   static inline bool xfs_hasdelattr(struct xfs_mount *mp)
>>>   {
>>> -	return false;
>>> +	return mp->m_flags & XFS_MOUNT_DELATTR;
>>>   }
>>>   
>>>   /*
>>> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
>>> index 66a47f5..2945868 100644
>>> --- a/fs/xfs/xfs_mount.h
>>> +++ b/fs/xfs/xfs_mount.h
>>> @@ -257,6 +257,7 @@ typedef struct xfs_mount {
>>>   #define XFS_MOUNT_NOATTR2	(1ULL << 25)	/* disable use of attr2 format */
>>>   #define XFS_MOUNT_DAX_ALWAYS	(1ULL << 26)
>>>   #define XFS_MOUNT_DAX_NEVER	(1ULL << 27)
>>> +#define XFS_MOUNT_DELATTR	(1ULL << 28)	/* enable delayed attributes */
>>
>> So uh while we're renaming things away from "delattr", maybe this ...
>>
>> 	LOGGED ATTRIBUTE RE PLAY
>>
>> ... really should become the "larp" debug-only mount option.
>>
>> 	XFS_MOUNT_LARP
>>
>> Yeah.  Do it!!!
>>
>>>   /*
>>>    * Max and min values for mount-option defined I/O
>>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
>>> index 2c9e26a..39d6645 100644
>>> --- a/fs/xfs/xfs_super.c
>>> +++ b/fs/xfs/xfs_super.c
>>> @@ -94,7 +94,7 @@ enum {
>>>   	Opt_filestreams, Opt_quota, Opt_noquota, Opt_usrquota, Opt_grpquota,
>>>   	Opt_prjquota, Opt_uquota, Opt_gquota, Opt_pquota,
>>>   	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce,
>>> -	Opt_discard, Opt_nodiscard, Opt_dax, Opt_dax_enum,
>>> +	Opt_discard, Opt_nodiscard, Opt_dax, Opt_dax_enum, Opt_delattr
>>>   };
>>>   
>>>   static const struct fs_parameter_spec xfs_fs_parameters[] = {
>>> @@ -139,6 +139,7 @@ static const struct fs_parameter_spec xfs_fs_parameters[] = {
>>>   	fsparam_flag("nodiscard",	Opt_nodiscard),
>>>   	fsparam_flag("dax",		Opt_dax),
>>>   	fsparam_enum("dax",		Opt_dax_enum, dax_param_enums),
>>> +	fsparam_flag("delattr",		Opt_delattr),
>>
>> I think you need this line to be guarded by #ifdefs so that the mount
>> options parsing code will reject -o larp on non-debug kernels.
> 
> As i mentioned on #xfs, this really should be like the "always_cow"
> debug option - access it via /sys/fs/xfs/debug/larping_with_larts -
> rather than being a mount option that users might accidentally
> discover and start using...
> 
> Cheers,
> 
> Dave.
Sure, if folks are ok with that, I'll take a look at always_cow, and see 
if I can put together something similar for larp.  Or larping_with_larts 
if folks prefer :-)  Thanks for the review!

Allison
> 
