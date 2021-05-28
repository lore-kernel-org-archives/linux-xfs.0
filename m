Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEE6FC4707F
	for <linux-xfs@archiver.kernel.org>; Fri, 28 May 2021 00:54:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 907B5613BF
	for <linux-xfs@archiver.kernel.org>; Fri, 28 May 2021 00:54:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235571AbhE1A4Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 20:56:25 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:37962 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235598AbhE1A4V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 May 2021 20:56:21 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14S0skR5072522;
        Fri, 28 May 2021 00:54:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=zWr9VazCPSvMbcwj/kcyKO9/d+aSWZUEnCiPwogO2yI=;
 b=O3DwG8i3aXI1bif2AyX6Ihau8kbaxrwmgI9pw+EzMcAbO5No1oeyneXAMAOv7IRPekFN
 9le67pPGe3QsIMgaMDK8EWUEgcbnoY68Qd3Cu1s576fzuxTQJMj/sydjk7/g7687i/Yl
 bpTiX/6eCR/i1SQpZiuECVnhxnZTtdm27T982iphrPwO2vH42cvYMmaGaZ1xaL/u94SH
 NAUFILZGup/l3GrIi1QzrqF9mb9Yzkq3Ee89NUfy4OfITAFeYv6z7xFkN/hSixhyt2Wh
 U7tOubeTZdZIfPjkSP1+yCi7OyH7G5DwrQYEDn1PPQUR1TSNr7VleSAoSgm5a1kyQ/7l Dw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 38pqfcnq1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 May 2021 00:54:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14S0jcLo047854;
        Fri, 28 May 2021 00:54:42 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by userp3030.oracle.com with ESMTP id 38pq2wy4c2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 May 2021 00:54:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bn4PNb66vZDSvnhIxMe3zcr29mLIZQLuH0nGMSIxyJLnkPjO+6B2gC7xAl99H4cYfGdVOJy71082UGszKvq93JL2B9YJQhCU+0Co7PRaC0B3CGmUKK5KYW8OPd8WPmwHv/x6Lwu3o1vdnkx+kOzgnZwmWIB3uzvvDpvayXpxsYRt6u3oviI+yEOvWY1qwUkCzW1Rkmk71Om3EeqnKkYE1cCqb/Z1+EcGmuNCnU+TPc9nM73nqQ9pU7k4gjDCCBn6z4Nt5XRgp2iL7EkPySkzlS93/nCQwJ4EuFTH2CJx33VhSQbeg5puulL2WYUdoBMGaA5VnPzlglmKbFVUxFiHBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zWr9VazCPSvMbcwj/kcyKO9/d+aSWZUEnCiPwogO2yI=;
 b=hDZnlvGLWKzkJiKnTVT9KcVhqE5IrC1//f8OvW8mmYf1YkCyv4fGje4NkqC5x2WQB/VoVccEmAn6ftkI9zP3rk1Ncp3s887sWWSwRR4yFGLVlHgKU4lZDN2sdwF4gvpcoTZKcXn6rV3yTaXSpd0On0NKA9bLUVc/oWN5f32ztnlw3pQIb73dRNjTrXzjRUo04gAl7i5rHAX+la3aN3WGleTJZha6yZCHdZw+c1uEOd2SUiDNLUMA/RVdYhEaUyGF+EiygKkZCzEymkJuobd/whllxOCs9cN17DKpqIo8PHDAS8KeWcYcoFx7kx7NE4Nf8W4C4Xnnz5xF3dYs/bZVng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zWr9VazCPSvMbcwj/kcyKO9/d+aSWZUEnCiPwogO2yI=;
 b=oMzxjES3aYcSHi78AItKVqyuaY/UsHJZiImNlB7JBXBs/9RJCM70+KYb95vY8aJJIlaLKRk78W/0EI8VqMHv+4ufOgYdzpLQ8KSdEq0Mvyn50uObRe9vPrVdIB2NpniVBIFa3LwjbiCQx3+AHbW1CQNMtUMeW3Qi79keiGPyzI0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4510.namprd10.prod.outlook.com (2603:10b6:a03:2d6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Fri, 28 May
 2021 00:54:40 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4173.022; Fri, 28 May 2021
 00:54:40 +0000
Subject: Re: [PATCH 05/39] xfs: CIL checkpoint flushes caches unconditionally
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20210519121317.585244-1-david@fromorbit.com>
 <20210519121317.585244-6-david@fromorbit.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <87025443-5350-a1f5-ebae-76c474094cb4@oracle.com>
Date:   Thu, 27 May 2021 17:54:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210519121317.585244-6-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: SJ0PR03CA0208.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::33) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.210.54) by SJ0PR03CA0208.namprd03.prod.outlook.com (2603:10b6:a03:2ef::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Fri, 28 May 2021 00:54:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c21995d1-5351-4f13-714e-08d921732c86
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4510:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB45106A2BC7A655B5B59E525395229@SJ0PR10MB4510.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:409;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 101Zlgs+OorCJ058NcB6umaGFc6woJyJHO3LHk9k4F2ggeL36mP8jIe9V3uEFqM1en/GpbwraOXUQoRMvQdBoaR/+4p2yJKRwtrodNB06JIElxtLmw5TYm7PDTIuhagqM9+U2B3FK4/jdUJPJs2Clep1mrRz6NCcZS0+uGcnBSqfuhm/SQd4ly6G9drKKq3uPHEICsWW4+mxZ0KJ0EMM+xGi4SLA5l2CIS7Xi50+Gq5vLc/bTJQmNIMcFLs/u3fXZOHzKqSH7tKkiSNN4aDLfgAWzp1dfRXWQN9UJepNm4AYiQmbnnVhzvir15X7zRwLh6T7w3BH5v3Vc9zgprhNNuN82L1jIQRVI3LxyredHHhoV/RQKnAyoBABa+MdVJcfVxg6XC3p2ddaEsHr1z976IXE9W+/7OYvpbkaOO7FxvoaVQR+xrMwnGVQVaEYsEYiJabsTCFm5x24oJzQuyQdHjtGnnRbcGVLA65I+SbEAsyUwuHuSAv6DT4FhtmOdDodb/RR0LK9hp+4G6tgDYeWcuVjljtekYUEkGCvkkpuGOS9lMLx8bluFIK8Wizk+qAwdHa3xZzk0LYyV/SCfOsST19kv68fdivjF6Cd03+S7Ewvy5R8bbXaoBLtYTVtRYsATEwiRy2IlS1O/oo/PRcc8IfwKaPsFpZSx/VvGs498Dtuk3uEqsEmF934JMT1HUGn91wnTyxE/7EDvS13RkOT4RoI8DxppQy7oUtTbPThsck=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(366004)(39860400002)(396003)(5660300002)(26005)(44832011)(31686004)(36756003)(316002)(478600001)(2616005)(16576012)(956004)(16526019)(2906002)(83380400001)(38100700002)(38350700002)(52116002)(86362001)(8936002)(31696002)(6486002)(8676002)(66556008)(66946007)(53546011)(186003)(66476007)(60764002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VThnUEpwcnVIM1V5amM4cHdHcDVHRlRrZWtqK01pZEhwZnhyajlSWHZVdjdp?=
 =?utf-8?B?dEdTbmIyN3NmR3hFWXVIQ3lRdnZTRzhpM0JRTUNXMXJUdkMzSGozY3N0V0xP?=
 =?utf-8?B?RTAxVkdtMWR1NEZmV3U1WHZRcVRna2FtSHg2dU1RMXZ1eUZOR2tKWGFpUURR?=
 =?utf-8?B?dlJNeHFuU0gwUkNIbTZ5ZndkL1R1RWI2aHN5MGk5Wmo3czZpVm9BMHVuSjZl?=
 =?utf-8?B?L2tuZFl6ZkgwdnVtclM3THdsY0dSN0tMdWZKbjAranhBQkI2Q2FrYmdGU1FN?=
 =?utf-8?B?QWIyeFdaWHhyaFRiMVJnTUFqdnB4YzNYQWthcEQ1bWxYeFZGUFFqd25KS2R2?=
 =?utf-8?B?bStjbjFnR3Y0emo4THgxc043d3JydVJGMFptekhwMW1NemVHdWRiR0FJb2d3?=
 =?utf-8?B?dGlsMUpmcVZjMzlwZHNMYjh4NzVIMVZ0WnFIMW9Pb1JqT3Blby9IWm4yQS8v?=
 =?utf-8?B?cC9LQlUyMHhUcFRoTnV4bllIVFZXbmk2YVhReDJuWmJEdU4yWnZENERKZjg4?=
 =?utf-8?B?c3QzbFQvY2VNVFFYMVp4eHhzQVpoWWlHcEpLMHNwdW9vWTUrN25id3MxVHJi?=
 =?utf-8?B?aGliZjJubWpjV2tVK0VOdDNzVFFRUVpqMmF5MHJQbG9SQVlHVzZvQm9RdGht?=
 =?utf-8?B?KzJ6M0VOZ21WVWppSUtaa3BKcGQrSXBjUWFOUHVsUzRreWNjSUJCcVJ6OU9V?=
 =?utf-8?B?NEs5MVl1RlhHS0NrUGNlQVZ3Q1VnSzVRdjNKckx3VytFcHVSRnhTZCtUZ3ZI?=
 =?utf-8?B?SERJcDZ1OHZlVG9pRXZuVEE0dzFFcXdhV3hYYXNQUERYVE8xREIxdkdMNWg4?=
 =?utf-8?B?bGpLeVk5N1ErZ3lWVjRkUTlmSmE3c2dSZ2pmai9xR3hyZWlmNlBxK1B1N0Zw?=
 =?utf-8?B?NmlxcFU5bkJaZHVaRXZuWVZmZWQwVGxSVUMwbVVITnUxU29NOGR5Q0RwMDU2?=
 =?utf-8?B?WkZEL1lUcjBkV1QyTm1aQ3pPSnBCWGg4ZEROQ0tGaFlLditOaUtqZEw2WEhu?=
 =?utf-8?B?eEZ0YWpwQk12SmVzS1ZrMUJOMGJ2VlRxMHlTWnFjNG5aeUxuZy9VQnJYTlB4?=
 =?utf-8?B?ODREVlpmUklBSVRQUDY4RVZYMDJHVkxNdzNsRkxaU3hRNVBreTdId2YvZFo0?=
 =?utf-8?B?WkJzdVhFOWlnS3ZFWEZYTXFYcFdoazJSM1IvMEgvS05sKzFDOERyWEd0Nk5N?=
 =?utf-8?B?MG1pdU9abVJ6VVRTNC9iOHhjbGcybEtaU0pTNmZaQUgySzI5LzA3c0ZCbzh5?=
 =?utf-8?B?R3YxVEJUUjJKQVNaNjk4RStDUEFhUVFPMWR3QzVWNFFQSVdMYllIOWNLR29j?=
 =?utf-8?B?MDZtMXhuV2hxd0tkOVdHUUJVY01vUVVhQ3hvTmpjZFNTdkhXQlVDbXBQNXVr?=
 =?utf-8?B?ZlVhYWQ5SGI2dVFxRlk2OVphdnhsdm9yUGtxRTVuZGtqalhwZmFxWkxkNUNQ?=
 =?utf-8?B?dHZ3bnlJbGRwSjQzVEZscm1hWXhjb0RPRjluSFFtN0w3NlNvQ2pZaHBUcnBT?=
 =?utf-8?B?UERrUHc2VkkwYVA1dlpTUnJQRG9tZE4wRWhBSTBTYTJ2QmxFUTNORFpBd2g5?=
 =?utf-8?B?TkVZaWV1K0JoWXFiYVoyeWdyMlhUZVpvY3hpY0V4WGpNdEhOK2hnR0xERVRE?=
 =?utf-8?B?VVA2Rkg0dGJYdzFWcmlVNUZDRUVGYzVjK2ZtdXFBN055ZWdkREFzc29zVTFY?=
 =?utf-8?B?cy9XcmUyQWhsTmtPaTAwWWE2eDZWbkdDSTh3bVZWY0ZFTW1PNFROaFhrUTJr?=
 =?utf-8?Q?IuHefqbMJD04N3TrXVu5PRsedXECdoyW/WK7Q5B?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c21995d1-5351-4f13-714e-08d921732c86
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 00:54:40.2615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pO7BE4IpoH2sZiLrm1GoxULogyyXTduvuCc8vj+aIZI5IAf+kBK8KA7ahrnaEVgX6hOJbHnAJvm58VOEbJisw9L/Ewi8lOEisOCE4dvU5ck=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4510
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9997 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105280003
X-Proofpoint-ORIG-GUID: 9wMRwkBD5X1f3QO1khmn9mVMTwosuOa4
X-Proofpoint-GUID: 9wMRwkBD5X1f3QO1khmn9mVMTwosuOa4
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9997 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105280004
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/19/21 5:12 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Currently every journal IO is issued as REQ_PREFLUSH | REQ_FUA to
> guarantee the ordering requirements the journal has w.r.t. metadata
> writeback. THe two ordering constraints are:
> 
> 1. we cannot overwrite metadata in the journal until we guarantee
> that the dirty metadata has been written back in place and is
> stable.
> 
> 2. we cannot write back dirty metadata until it has been written to
> the journal and guaranteed to be stable (and hence recoverable) in
> the journal.
> 
> These rules apply to the atomic transactions recorded in the
> journal, not to the journal IO itself. Hence we need to ensure
> metadata is stable before we start writing a new transaction to the
> journal (guarantee #1), and we need to ensure the entire transaction
> is stable in the journal before we start metadata writeback
> (guarantee #2).
> 
> The ordering guarantees of #1 are currently provided by REQ_PREFLUSH
> being added to every iclog IO. This causes the journal IO to issue a
> cache flush and wait for it to complete before issuing the write IO
> to the journal. Hence all completed metadata IO is guaranteed to be
> stable before the journal overwrites the old metadata.
> 
> However, for long running CIL checkpoints that might do a thousand
> journal IOs, we don't need every single one of these iclog IOs to
> issue a cache flush - the cache flush done before the first iclog is
> submitted is sufficient to cover the entire range in the log that
> the checkpoint will overwrite because the CIL space reservation
> guarantees the tail of the log (completed metadata) is already
> beyond the range of the checkpoint write.
> 
> Hence we only need a full cache flush between closing off the CIL
> checkpoint context (i.e. when the push switches it out) and issuing
> the first journal IO. Rather than plumbing this through to the
> journal IO, we can start this cache flush the moment the CIL context
> is owned exclusively by the push worker. The cache flush can be in
> progress while we process the CIL ready for writing, hence
> reducing the latency of the initial iclog write. This is especially
> true for large checkpoints, where we might have to process hundreds
> of thousands of log vectors before we issue the first iclog write.
> In these cases, it is likely the cache flush has already been
> completed by the time we have built the CIL log vector chain.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
Ok, makes sense
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_log_cil.c | 25 +++++++++++++++++++++----
>   1 file changed, 21 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 1e5fd6f268c2..7b8b7ac85ea9 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -656,6 +656,8 @@ xlog_cil_push_work(
>   	struct xfs_log_vec	lvhdr = { NULL };
>   	xfs_lsn_t		commit_lsn;
>   	xfs_lsn_t		push_seq;
> +	struct bio		bio;
> +	DECLARE_COMPLETION_ONSTACK(bdev_flush);
>   
>   	new_ctx = kmem_zalloc(sizeof(*new_ctx), KM_NOFS);
>   	new_ctx->ticket = xlog_cil_ticket_alloc(log);
> @@ -719,10 +721,19 @@ xlog_cil_push_work(
>   	spin_unlock(&cil->xc_push_lock);
>   
>   	/*
> -	 * pull all the log vectors off the items in the CIL, and
> -	 * remove the items from the CIL. We don't need the CIL lock
> -	 * here because it's only needed on the transaction commit
> -	 * side which is currently locked out by the flush lock.
> +	 * The CIL is stable at this point - nothing new will be added to it
> +	 * because we hold the flush lock exclusively. Hence we can now issue
> +	 * a cache flush to ensure all the completed metadata in the journal we
> +	 * are about to overwrite is on stable storage.
> +	 */
> +	xfs_flush_bdev_async(&bio, log->l_mp->m_ddev_targp->bt_bdev,
> +				&bdev_flush);
> +
> +	/*
> +	 * Pull all the log vectors off the items in the CIL, and remove the
> +	 * items from the CIL. We don't need the CIL lock here because it's only
> +	 * needed on the transaction commit side which is currently locked out
> +	 * by the flush lock.
>   	 */
>   	lv = NULL;
>   	num_iovecs = 0;
> @@ -806,6 +817,12 @@ xlog_cil_push_work(
>   	lvhdr.lv_iovecp = &lhdr;
>   	lvhdr.lv_next = ctx->lv_chain;
>   
> +	/*
> +	 * Before we format and submit the first iclog, we have to ensure that
> +	 * the metadata writeback ordering cache flush is complete.
> +	 */
> +	wait_for_completion(&bdev_flush);
> +
>   	error = xlog_write(log, &lvhdr, tic, &ctx->start_lsn, NULL, 0, true);
>   	if (error)
>   		goto out_abort_free_ticket;
> 
