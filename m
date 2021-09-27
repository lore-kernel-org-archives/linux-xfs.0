Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95594C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Sep 2021 20:26:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69D1460E94
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Sep 2021 20:26:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236982AbhI0U2H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Sep 2021 16:28:07 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:30694 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233460AbhI0U2H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Sep 2021 16:28:07 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18RKOMw9016465;
        Mon, 27 Sep 2021 20:26:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=B52TQDYnEGVdHoKAnntmt0/ZxRqUeki47G+dMJYEVvM=;
 b=yOXGqbc5yd73fGWiQFoTylL3yUW0qZbBHyOx+JBkNVlziFaiUuX0n2X8CQ084rslHchp
 S6o++TibF4Vr0TYYst1uPZXGiGx9XebTT9mBh/8R8RaAFl9nYoaA4cIYw9aOLluhwlUq
 KqiFEXzvF5nah5gSiqNG1XQqc7K4QisJCgsmuqbDUe311YNQ10YLk8EZH4iGRAiAQLCE
 1I9ykvpeDsqeIa91gK0f378hzgfoV1z+8T75c6BlRojsYEBVkX+JJ3sQ2Lf2DdTtzFev
 4533RSvDK/kmwr4FdJVUMF7aP0G4e8E29i26PNncRiZtN6PbZSHyV74n3yVP6vE9imfq mA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bbhvbssbh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Sep 2021 20:26:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18RKPJVU153478;
        Mon, 27 Sep 2021 20:26:26 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by aserp3030.oracle.com with ESMTP id 3b9std3cxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Sep 2021 20:26:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y+AL9DhtOcMNnxgtNSOotnEcayRNNm/dQZwOTRKnm7NI2DNUxsCwQGbOVB9A8J8/2UxVBuuA2hdc2CGy8KJKjL6vmUTaiGXkSFavv8Vs7p/ukjxPWndIzImsUle7lBBaEE7skNQtZFzY3/pTpx4BpAM4dQH6jM1XWWU1heQR7hI9qudcwEu+RYZOttA7SAIMjein5WGdSaHeLy1pggxMw2huIN309bvtx20FMZzyJ2akucdwMYRIR64RyPV8jeChrGg+CJSwKeyKepeB0/hCXaODIx1PNqy3Sz4TzhlZnVYS+70H3ten20RtTDmx+4AuBFCJ0D8w1A5rMndHCBgBag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=B52TQDYnEGVdHoKAnntmt0/ZxRqUeki47G+dMJYEVvM=;
 b=CB3ZBpP9RsPRqleDfuSudf1dpKyUhAPOSIKsL3eh1fTamkMANfsn3bFd3JNB5kbxaLzzhv4nrOugyQZq996CvEdHNM2in2fNXxMV2Jccv/qF8Z1B5u8FteblCmSM65wi+ETccp+zOoWKbIIzVYaTH9DizBEJDGKRXa4qS3vJxO0IuEomJ0dBJeeK0zWRJmYWDUV/iNYvY2JvCxldM5nmo7Ci9jJOFXt73sgZrI/Tbrs/lWaKouSiwiL6DWtVICd8W8vOTxdFiaF7T6Ca0d3krXPzKnjeN3tft6d7fQ4c+8qeWvS7e2c0hkqJUmRj1DskuMJyYhOZJyLGszwpd7MVMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B52TQDYnEGVdHoKAnntmt0/ZxRqUeki47G+dMJYEVvM=;
 b=V6iUjWp84J3yVLfJ65jXRLLjJrPFMd6XWZRGoqcUqC3aT+QTumjTJcXY3+VsKZWfGSIdsnzSejULUg/a8Hxs0uu+6upzL1vMUE+oenFzxVwG6GaT16yBySJEoNO/YRAUepE9oNYBU/MczkRPmgP0YENs8J6hqQP+hO14gSz8OVg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4387.namprd10.prod.outlook.com (2603:10b6:a03:211::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Mon, 27 Sep
 2021 20:26:25 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::b054:cb04:7f27:17fd]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::b054:cb04:7f27:17fd%6]) with mapi id 15.20.4544.022; Mon, 27 Sep 2021
 20:26:24 +0000
Subject: Re: [PATCHSET RFC achender 0/2] xfs: refactor log recovery resource
 capture
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <163192863018.417887.1729794799105892028.stgit@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <a104f21a-3e84-9e63-5bf6-ed4b939736e4@oracle.com>
Date:   Mon, 27 Sep 2021 13:26:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <163192863018.417887.1729794799105892028.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0046.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::21) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from [192.168.1.167] (67.1.243.157) by SJ0PR13CA0046.namprd13.prod.outlook.com (2603:10b6:a03:2c2::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.7 via Frontend Transport; Mon, 27 Sep 2021 20:26:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1cab155-9bff-4769-e9f9-08d981f513b6
X-MS-TrafficTypeDiagnostic: BY5PR10MB4387:
X-Microsoft-Antispam-PRVS: <BY5PR10MB43870A2C3CFE0E6EC5674C0595A79@BY5PR10MB4387.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q7XGLnQ2Hpfax+hSOWFJ6FdjD4RJNqTvr9eh8/7KVpCYVkElaR/XM+u9xtGtCGIl7omPmW9pdnxK8m7JSZv2+snuewouxImyLAzUeetlHqOUOndolQASnPuhHU8FFpmw5SJCt7ONGkYYo2/9gONQ+ubtfUQBmqi3YvRS9lnhb+S1wQxuoJy2+Fs/Lt5OrKLbDpPofxJAHqVgVGA87Z4B8IkaJlnmhbt6qSQL8y2BO6+IZPedjdMQbtqM876D4RaaJ+c55c452jHtCNa8MzJlv4Wg/uhFKEaQ7x/6t98AbJf6uqS6AKgsBp6KZy8UwFASHKu2cNdNFBVtaDV53d4imiW7xTJW/KTECj6fQz2XRO+NauZ6yLzYBsPJe+RGaC/iSIOihcbrNRj+fhEr9qGi1mteWrE1szm0VdxP/9nDql7HHHDJPUOYWPx7luWRdDKVF6DZgeBVf128Lj06LNgVy8kPqUShNPMLCkRjfZX8/pG4o1Oj5khWa5rwQ5LRQxASNji1l9yHV1ULBPfTxPI4qCQZMntS4AwlKx6YvK3YiGIf9VT+zQ/CPXhNjpO0K7Sz7Nh+0u2qSOat3fu6MIC+sU3gH+x4VqRwPBveST5w+cKcuna9f7/dF9rkG/xPl/MlIWlzlMxyr4lZz5KXqRGu6d3I59WErFi8Cc/XQCFJBjqSX7yvJYnGkljeqvBBbLNGtp7uS84GRvR8QqJafplrOUZHQC/DxZ589REx4cjBJX4vFrhP20c2WmlydtFi3LPCzguMuMFSCsznYM+uT5PS6ahNGKGX5zVlpATQVC7tr4W5ntbjwHZd4W45RKoonJPFa9Lc30r+P29EAnKcCryEtt+aKLJORUvEDucM+3Sd8bs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(44832011)(53546011)(38100700002)(38350700002)(966005)(52116002)(66476007)(66946007)(66556008)(508600001)(4326008)(26005)(2616005)(6916009)(31686004)(6486002)(186003)(36756003)(86362001)(956004)(31696002)(316002)(16576012)(83380400001)(8676002)(5660300002)(8936002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Mnl1T012K3M2VGh4YTFFVVZrQTkrQUhXRHFXeGRqdFZqUHlHMzRBalBVdll2?=
 =?utf-8?B?dkJRMUhCM3NicFNSWHNYaFZHYzQ5ekJTaGVTbUY5cnI0NlRaVWVsYVhwVVlD?=
 =?utf-8?B?dktJeldUdDNnY1NhdXp3Zzh3UEY4NSszRWRRcEdLYmhVdmRnaTVOYjNmUzl6?=
 =?utf-8?B?Q2VHVHpVM2YzUTRnYzMzZUJIajdLdWM2VkM3eUp3a3MvaWthaXU0ZWlaK3po?=
 =?utf-8?B?REhGVEM1NnJMUzJSM2s5S3lOZCttaG5qcEdveFBrYlQyYmxGcDRWcFZwMm9O?=
 =?utf-8?B?ZU1sSGtySlZkTkhzR295ckhNczQzS1dHdytFbjJlUzNIK0doclhNa2k2dDZQ?=
 =?utf-8?B?RFNnR0sxcVVKL1dxWDRMSVc0V0xKM2lJcEJKMWJJT1IrSVY5bHM4dkJXYmhv?=
 =?utf-8?B?VUpYYU9XbGU0R3lSMk84S25xTkNFZXNMbjFydHlqcHdHVkFReFhhdHhnYldn?=
 =?utf-8?B?Nk9iYnRweUNtbUtWMGR3MWowYTZkaUpqZWJ6UnQ3YmVCNzJRSUJkTXRQYnpy?=
 =?utf-8?B?Z1hKQU9iTUhkYi9YNzk1NWx6MzdoKzVEMjMrRFprZmpzOWtmc3hLSThFVmJR?=
 =?utf-8?B?eWJFcEQ3ZHRPNjZ6c2huNEJudENXVFFmWjF2dTJZbU91Wlgwa21GSXcvMHRq?=
 =?utf-8?B?NW1QekFsYWFvSVZPZzkxQ2s0NHpuUm9SVUJTWVc2cTcwS1RvMjA3V01JbnVS?=
 =?utf-8?B?ZHJOWXVLcVgyVUY5OSt6elppdkJxdFBia29TazdpalBQV0tVNEtndnpDWlFm?=
 =?utf-8?B?bmZVazR3OU8yT1c3cDk3Nm5xcENhMHZMRFRZQkRyUlRTQnd1azB6bTVjdFNx?=
 =?utf-8?B?TWNpUXE1aUZzSnJ1T1JweEphVjVCZDB2VFEwNG44OSszVTNBOFp4aTlVd1hv?=
 =?utf-8?B?bWZKWmVKcTFweGlvUU5iWW9CUVNqMm92V3ZrTi9uMU5JVGpTSzEvMktRaUZt?=
 =?utf-8?B?cFlVaW8wMWVKNzF5S0RzR3BsOWlDMWt2TDkzQm1PckIxTHlrRUFoMkFOUE4r?=
 =?utf-8?B?QzZNM2hEK3VBUlE2Z3FmTjMyckwxU2xBaUtwRXBZSDJsN1RGVHBnSHNEMU9x?=
 =?utf-8?B?WFQzTkFHN24rMVhsQUtySWR2cUFkbE9EdmxUakhqdUY3MXN4OGFmMCtjbUoy?=
 =?utf-8?B?anluN3B6NW5lMkJNRk9XblNXRTNzaVFhMDN3NS9DbGZ1UVl5dnFKZjBCeCtS?=
 =?utf-8?B?cFZwd3UwTWV6Q21KQkpBMXJLMkY5V2dNNFV3K284SkFxMTBKdUd4L0l3WVZ0?=
 =?utf-8?B?NDAvZzFaTHhOYXB2U3dIR0E0MGZDcUpUSXJvOHpYR1pjQjUxUHRhNWwrSFMz?=
 =?utf-8?B?TFNEajhqVnZXbG5XL1YrbGM5cEY2cWtVVFBEcHhKaEZUQlBoWlNmZXlSZ21Q?=
 =?utf-8?B?QTRvQ2oxTUhzTk1mcVVEL1RxbEM3WnVJV0FwL2NnRTVoeDMvOWdwd1kyZWFx?=
 =?utf-8?B?aHNzbEhyME5pNTBLUVpLYjNmWWZUbHFvVEpJdkNWS1ZkQTU4Q0cwRUI4YzM0?=
 =?utf-8?B?NmVVVWRFYUNUZkFmVTlqQlY1TUN6alBwd2oxLzVyODBsYkgxQ1FLOFVtVWNr?=
 =?utf-8?B?RlNyb0t4Q2x6RjhnR0FKaEw5UXRyNms0NUc3WmR2Y1EzMmtMbEZjOTBRbGZs?=
 =?utf-8?B?MW9Qd2J5YlVLWVdpNjl2OUt1SXR5V0RkNWZsWDRzV3BQRlNpRzFtd1g1Wkcy?=
 =?utf-8?B?QzNNQ2pyWWpNcnc1TzNYSndtK3JiaEhFTHEyRDRpck1JMUtuUWtIcnhNd2pK?=
 =?utf-8?Q?LAHhorELcPUIIWKp+8iu3CsLFUclOxUC26WkvZC?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1cab155-9bff-4769-e9f9-08d981f513b6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 20:26:24.9322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B9JJ2zSHRQ/KonaH4FAC8dbZCBKNSYcR0wtXIFjlqwkg4SB/keOkdXdUBTSHfG/rm+7/RTdlfAV0NoB2kD9Swh6wZlyOa/3+WfdbWtlqPss=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4387
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10120 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 mlxscore=0
 malwarescore=0 spamscore=0 phishscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109270137
X-Proofpoint-ORIG-GUID: GLzC7XFY3oEtzzCzNMEFl-S_4UIncOR5
X-Proofpoint-GUID: GLzC7XFY3oEtzzCzNMEFl-S_4UIncOR5
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 9/17/21 6:30 PM, Darrick J. Wong wrote:
> Hi all,
> 
> During review of Allison's logged xattrs patchset last cycle, I noticed
> that there was an opportunity to clean up some code structure
> differences between how regular runtime deferred attributes hold on to
> resources across a transaction roll, and how it's done during log
> recovery.  This series, in cleaning that up, should shorten her
> patchset and simplify it a bit.
> 
> During regular operation, transactions are allowed to hold up to two
> inodes and two buffers across a transaction roll to finish deferred log
> items.  This implies that log recovery of a log intent item ought to be
> able to do the same.  However, current log recovery code open-codes
> saving only a single inode, because that was all that was required.
> 
> With atomic extent swapping and logged extended attributes upon us, it
> has become evident that we need to use the same runtime mechanisms
> during recovery.  Refactor the deferred ops code to use the same
> resource capture mechanisms for both.
> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D
> 
Hi Darrick,

Sorry to for the delay, thanks for putting this together.  These 
improvements look good to me, I will see if I can get this worked in 
underneath delayed attrs and give it a test run.

Allison

> kernel git tree:
> https://urldefense.com/v3/__https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=log-recovery-defer-capture-5.16__;!!ACWV5N9M2RV99hQ!ZyRkandC0OnbO6-EW6AVFwC62a54u8Ki6doYqvl2vJDfgBmkzB4GFZe5s25s8_0XfN1E$
> ---
>   fs/xfs/libxfs/xfs_defer.c  |  171 +++++++++++++++++++++++++++++++-------------
>   fs/xfs/libxfs/xfs_defer.h  |   38 ++++++++--
>   fs/xfs/xfs_bmap_item.c     |    2 -
>   fs/xfs/xfs_extfree_item.c  |    2 -
>   fs/xfs/xfs_log_recover.c   |   12 +--
>   fs/xfs/xfs_refcount_item.c |    2 -
>   fs/xfs/xfs_rmap_item.c     |    2 -
>   fs/xfs/xfs_trans.h         |    6 --
>   8 files changed, 157 insertions(+), 78 deletions(-)
> 
