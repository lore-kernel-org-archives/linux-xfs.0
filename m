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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3178DC433B4
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Apr 2021 03:27:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 085646124B
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Apr 2021 03:27:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233084AbhDXD2O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Apr 2021 23:28:14 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37446 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232619AbhDXD2M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Apr 2021 23:28:12 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13O3RXlt043237;
        Sat, 24 Apr 2021 03:27:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=y9lRbtmnnvLubootlcD1wormSuhlFNTwJ+mQEBABHGQ=;
 b=DHLGeoR03PjrdSRc0H3lR73Z+9itYdLZqx5ka132Hlv46Jymu9fa6J1Ajm6Of+sIkf81
 OUuWDPSzlmgi0MPMsxQ9POVdD/eM1lDfyMrPBvpWcJMCIuJySUEJHLYC2uS88pbTUadu
 l7rdCBeK26wKMQgJZZzAR7hHtgyUFfI0O9pJf6ykNowdtM6Hk/XolNv1zuSHXLiPI1xM
 nXc7sHybDrqN09XG23bFTAbbVxUMUQyZq/ViG6XhOjcfsTuKxMvaWRq4B/aUPx0hzjTr
 rXUT+6srD1PRkCWrNg8AN87nhfC47U0hFA79coPTT5Y/75yd5IGNhQG5X0TVclUsEVcF Iw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 384ars00qy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 03:27:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13O3QSHM082380;
        Sat, 24 Apr 2021 03:27:32 GMT
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2058.outbound.protection.outlook.com [104.47.38.58])
        by userp3030.oracle.com with ESMTP id 3848esc1yj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 03:27:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fAuYsNyTxHo6AZTU7/aXYE3D+XreamCGMrAa/3rO1s80CS971q2oZn7eZ5EFzcW7JA2MSWbgr0tCeNorJFHtA1HTAsKVKBEy5tLdrDc4Qhv13UlXxSejmy0WHH87+2bfGsP1y6Wve/YIE1bfDo0/r6l9P1MIF4tVr9Ol9V9rnT1VITALwU1JiXT7zqaXaHHfGXIlLZAa45PP3hYBErXYWfghZ8nTJ83HQwdcFBLDDRjP2fUE5UHdwtKyF4KxXZpZDrNdOjsMryxpOkDyVPkSJQwHoVcwZVAJLmtkABjSaB2aLYn7nSlMvaN3YN2XX4abPNPuyW3kEEYh6MZzFnYX1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y9lRbtmnnvLubootlcD1wormSuhlFNTwJ+mQEBABHGQ=;
 b=BrOxMM7DiLtTCIpoBLw+zmf+cVud/dQu5klyCQMdAq/u3TF90orwJRq1CqGpg3AAoCCb069i96peWDkOU6WnGsJeoNIn+G+zTylwlrG7fQxiFXgWJ5zJWrmvCKNnViEnIg8qr3nvvB6BSSVN17de+jIeP3ZWrucxIeHEMRNaqVQtiPIGyq03WmB85ZOR7VaP+Zcl3dy2XaLSRxV07Th/h1236lUueHSw76gTupwCpYub8lCPvER9ir+ofCkSY2HhGHI5g2BfQ0XDT6bzbnzuNjKuljNixUwA77rmtNPA1LsimlTRVg8XvvmUKIaK72pOtMVdVb2AEsgjgZaMAityRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y9lRbtmnnvLubootlcD1wormSuhlFNTwJ+mQEBABHGQ=;
 b=xGilTvD4VfIX9+pQPa7TgSzODXr/BNxC2L19DfTVJ6hXSpA7cnfbbjnEiR8w8t/hityJvq+IrqjRfZn+kv8bddMGSjJUOr+ut3HNeoYiq1ASPNtyFszAf+Mmyzus5ion3A27aPGffLCQYyXry16vVNClz40GS5sE6YaUoPnF7zw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB5406.namprd10.prod.outlook.com (2603:10b6:a03:305::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20; Sat, 24 Apr
 2021 03:27:29 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.024; Sat, 24 Apr 2021
 03:27:29 +0000
Subject: Re: [PATCH v17 10/11] xfs: Add delay ready attr remove routines
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210416092045.2215-1-allison.henderson@oracle.com>
 <20210416092045.2215-11-allison.henderson@oracle.com>
 <YIL+j3BmnDOEqHrp@bfoster>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <85c61f76-81e1-9c03-3171-0f01759c46de@oracle.com>
Date:   Fri, 23 Apr 2021 20:27:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
In-Reply-To: <YIL+j3BmnDOEqHrp@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: SJ0PR13CA0133.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::18) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.222.141) by SJ0PR13CA0133.namprd13.prod.outlook.com (2603:10b6:a03:2c6::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.16 via Frontend Transport; Sat, 24 Apr 2021 03:27:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc6bea7b-17ce-467b-8656-08d906d0e3a1
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5406:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB54066F7024EE5B3D4640901695449@SJ0PR10MB5406.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8mKsCHdNlfTElw3N9ySagd81PsrxOfnFlshpDz/6POCcX1TXmgfZBDa+1QWD6q9KOUBKXHoPApvdaVThYHhGHU8jcBdvIXaVQwa3cEPHm97SvhfJflOYLfHvXQddw4hJJRTthoPdykB9rVfk58vp2CJc5kUOqDCu0rLyVgyNrEaRdJKHEweIpUwFHhS6RlysLc1hSGZhDmK0TYvQjP4CMjrtRWrsFvrskIp/xjJc/5SPxJNwlYEBom44A+QeDHZdrfHMq2WQk/zQI6OkTg9B69lBe2gqWEMSEIk6R5WNei2SCwT0ts1K54R3lvVj7R8ScqbDiM5xT+FzqPAv+vyre8iE0UrrkSeo43t1nA7S3lY/BMmUmiHvq4bdq0fU/8HuvZLb0B0lK4dvVOmvSQj20/o1Aut8GwImr6OYcdglfKfnrc9GdfSh96FW+I0EjYQRu/HXa3cNEihNodz902sGfPNjWDJWmPXBEuRxPoLwThYnoZQh4wfF/JCq/RbxL/pRUIGL1kp0UNzlqPTJTrG7gJi0a+aTDvwp9sp7DXL2zEdFFEioe8Ox/kbDzgq5OZzlY8NQcqrknzrisnYyAYTfnF7JEGkTPe5am6UsrPtw66KaMA0yr6Axqwuve95OHZ26cuZrYDvYytQ5+ETI/y3TBvFMvPjyHJrCLTbfJUjDI+W0Dgs/3d5AGNRRtBnHZohJOPkMj4gQNduGUzfLFVi6fg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(136003)(396003)(346002)(39860400002)(83380400001)(478600001)(30864003)(6916009)(2616005)(186003)(44832011)(26005)(16576012)(31696002)(52116002)(316002)(86362001)(16526019)(38350700002)(8676002)(53546011)(6486002)(31686004)(66476007)(956004)(66556008)(66946007)(38100700002)(8936002)(4326008)(36756003)(2906002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Q3o4aFE3TVowellZbnFOSGxJY0NCcVM3YVVJbVdlSDQ5cndPMWhOWDJiTUlm?=
 =?utf-8?B?d2tmOTRlbnVsQXppUU12TVJvZDF0RFVKTXJ5ZDRwdCsyUVVKdi9LUldydUhD?=
 =?utf-8?B?a0ZPNTBqNDRDVU1QMk13UGRlL0J6SlkxZHNia0Z6MWxiVWJ3ZjQvaDNrOVpP?=
 =?utf-8?B?NDhybENGWk5LREtvR3N6bm8zZ21HUStHRU5COFc4cUJENzVaam1YRDJyYTE2?=
 =?utf-8?B?RXM1Ykg5UVJIaVplVzhzZGNVVkpINk5qQ0VGU0R3UWZyNk91Y3dSRmFvdWE4?=
 =?utf-8?B?bnpJbm5Odk9GTlNKWnFBNUJNRVNhb0hqTmM2STNQeGlLNzFQQ0pNTmlPazlu?=
 =?utf-8?B?d1RwWERFU0pOc2h5SWR5cVdpS2xWdkVWbnkwN3ViNkw2NnVQL3VMSXB4WGRt?=
 =?utf-8?B?T28xNkh2RlBGTzdna2RJUVd2SldqSlZBb2NCV3B6ZDVRSExLMHF4cWFtNEJE?=
 =?utf-8?B?ZnZwaU1rYlV4TGNaTERQYitQNDJmQkVjR3E1QWw4SVZON2tWVk5zVnQ0d0VN?=
 =?utf-8?B?MlZ4QklFb3FiWTdKMDdiYnE5aXNpUkNqRHlIZlM3bEZWdW1VV3ZyUlVPMTBl?=
 =?utf-8?B?a1cvUEVlTEExSi9QK3RhUnYrYkVDUnl6bXZ5Y1RiaEJrSit2K25JSkdPdkRG?=
 =?utf-8?B?VGF1a3NVaWFTUHpPNkpZQ0x1ZVRxSXYwYWpRZ25KV3BhM2Q4YmtaalVzSG4x?=
 =?utf-8?B?a1J0OWRCUEZlS2ZjK0p3Ky94eFpwK2ErKzZmNE5vWU1JNy9qK284eGdxUG5Z?=
 =?utf-8?B?R2RTSXRpaGx3dkxlR3VLVTNyVC9kWm43aGxoYmRlR051MWxKcVBlODJRb2lG?=
 =?utf-8?B?amg2RE9zdVBnZmVXOTdxSUNsMDJZWEF3WUJrUXFlK0xyK2xXdWNRK2I3RC8w?=
 =?utf-8?B?RGhsNVhFTVdqZEZBaTVvZVRmOFd4c3BpRWpnV2xjZHp3ZXZzTzhERG15Nnh5?=
 =?utf-8?B?VHU1d3B4K3BRZ3gyeWlQZjhCb0FHVnZyZlY0bitzRXlZVWs3czhYRnFqUTNG?=
 =?utf-8?B?Uit0K1MwVXhZd1ZOc05CRWlTR2tpdUgzVWNWVmc1cGZzUEcxNm1aY1dtVXg5?=
 =?utf-8?B?b0w1ZkRyYlE3U1p2OFUzRS9paW9hcHBTSDdlRnJHYWlyMUdqK1JoRG16OEdL?=
 =?utf-8?B?cWNXMTdVTjZtVGdQcFhyRVRPQ2ZXTFpqeU9jTDk0RFBFS25wa0wwQWlESnEw?=
 =?utf-8?B?eUxXODJobUhqZjJjeDU2VUVpd2dzQm5aYUthY25hTzgzUmppdlZJRkxQK21W?=
 =?utf-8?B?SG5XVWdJT2F0dmJNOUsxa3VwZUIyc1dmL1VLbDE2cVVoajRLMW5ZU0ZCR2Uw?=
 =?utf-8?B?WDFjSGpjQVNCbmt3S2p4R1VmOEhrYjhTeUNqU3loR2p5M0ZUeTdFNFhURURY?=
 =?utf-8?B?MUc5OFNDL3JXUjFFdkUrUGpMSWZlTFY4RFRXVEJHNjROMmRMZkUyMFk3RGFH?=
 =?utf-8?B?TEU5STJqcStldnZXa3FiYmIyaWp1aWl2cjdMVThYRVlPSUxucG9JZFVTeWJJ?=
 =?utf-8?B?bUUxWmNFTUptQlB2N1VQek5NeWpQem03T3dSaFdWL0d0d1JwK2tQa1pUeGE5?=
 =?utf-8?B?RDFodWtYRVJYcWZEUlRNSTkwb1VSV2lydGNkUU93eVpUWUNyUGVTMCswS1Br?=
 =?utf-8?B?c0JMKzUySVF2bDd5WTI5TktYbWRHVzhRcjBraXpFaGRsRmQ4VU9CVnVrMkwx?=
 =?utf-8?B?N3hJejNyNGZHKytEZmFRbVYyR0p0bUVUa05FRzBTdU0zUmtmdktUdzIyYTNk?=
 =?utf-8?Q?QlnwkFP5LEtXcHBuNjykMCrHMJvRhZJNkX+vTGf?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc6bea7b-17ce-467b-8656-08d906d0e3a1
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2021 03:27:29.2340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MvPXhFmpHmrwfpxisJGT2ZRgRGl5p7IygH2+kIxcgDXf5GR0HwJcILssJH6o1g7EpmTNAcNjW6qF/tfnLN2QXnzx8sVDxlyD+G5+x+FCh60=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5406
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9963 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104240021
X-Proofpoint-ORIG-GUID: kmjeXQ2OtyoC6aXz4OvgqLqjqAX7d0r-
X-Proofpoint-GUID: kmjeXQ2OtyoC6aXz4OvgqLqjqAX7d0r-
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9963 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 priorityscore=1501 clxscore=1015 spamscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104240021
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/23/21 10:06 AM, Brian Foster wrote:
> On Fri, Apr 16, 2021 at 02:20:44AM -0700, Allison Henderson wrote:
>> This patch modifies the attr remove routines to be delay ready. This
>> means they no longer roll or commit transactions, but instead return
>> -EAGAIN to have the calling routine roll and refresh the transaction. In
>> this series, xfs_attr_remove_args is merged with
>> xfs_attr_node_removename become a new function, xfs_attr_remove_iter.
>> This new version uses a sort of state machine like switch to keep track
>> of where it was when EAGAIN was returned. A new version of
>> xfs_attr_remove_args consists of a simple loop to refresh the
>> transaction until the operation is completed. A new XFS_DAC_DEFER_FINISH
>> flag is used to finish the transaction where ever the existing code used
>> to.
>>
>> Calls to xfs_attr_rmtval_remove are replaced with the delay ready
>> version __xfs_attr_rmtval_remove. We will rename
>> __xfs_attr_rmtval_remove back to xfs_attr_rmtval_remove when we are
>> done.
>>
>> xfs_attr_rmtval_remove itself is still in use by the set routines (used
>> during a rename).  For reasons of preserving existing function, we
>> modify xfs_attr_rmtval_remove to call xfs_defer_finish when the flag is
>> set.  Similar to how xfs_attr_remove_args does here.  Once we transition
>> the set routines to be delay ready, xfs_attr_rmtval_remove is no longer
>> used and will be removed.
>>
>> This patch also adds a new struct xfs_delattr_context, which we will use
>> to keep track of the current state of an attribute operation. The new
>> xfs_delattr_state enum is used to track various operations that are in
>> progress so that we know not to repeat them, and resume where we left
>> off before EAGAIN was returned to cycle out the transaction. Other
>> members take the place of local variables that need to retain their
>> values across multiple function recalls.  See xfs_attr.h for a more
>> detailed diagram of the states.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c        | 208 +++++++++++++++++++++++++++-------------
>>   fs/xfs/libxfs/xfs_attr.h        | 131 +++++++++++++++++++++++++
>>   fs/xfs/libxfs/xfs_attr_leaf.c   |   2 +-
>>   fs/xfs/libxfs/xfs_attr_remote.c |  48 ++++++----
>>   fs/xfs/libxfs/xfs_attr_remote.h |   2 +-
>>   fs/xfs/xfs_attr_inactive.c      |   2 +-
>>   6 files changed, 305 insertions(+), 88 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index ed06b60..0bea8dd 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
> ...
>> @@ -1231,70 +1262,117 @@ xfs_attr_node_remove_cleanup(
>>   }
>>   
>>   /*
>> - * Remove a name from a B-tree attribute list.
>> + * Remove the attribute specified in @args.
>>    *
>>    * This will involve walking down the Btree, and may involve joining
>>    * leaf nodes and even joining intermediate nodes up to and including
>>    * the root node (a special case of an intermediate node).
>> + *
>> + * This routine is meant to function as either an in-line or delayed operation,
>> + * and may return -EAGAIN when the transaction needs to be rolled.  Calling
>> + * functions will need to handle this, and recall the function until a
>> + * successful error code is returned.
>>    */
>> -STATIC int
>> -xfs_attr_node_removename(
>> -	struct xfs_da_args	*args)
>> +int
>> +xfs_attr_remove_iter(
>> +	struct xfs_delattr_context	*dac)
>>   {
>> -	struct xfs_da_state	*state;
>> -	int			retval, error;
>> -	struct xfs_inode	*dp = args->dp;
>> +	struct xfs_da_args		*args = dac->da_args;
>> +	struct xfs_da_state		*state = dac->da_state;
>> +	int				retval, error;
>> +	struct xfs_inode		*dp = args->dp;
>>   
>>   	trace_xfs_attr_node_removename(args);
>>   
> ...
>> +	case XFS_DAS_CLNUP:
>> +		retval = xfs_attr_node_remove_cleanup(args, state);
> 
> This is a nit, but when reading the code the "cleanup" name gives the
> impression that this is a resource cleanup or something along those
> lines, when this is actually a primary component of the operation where
> we remove the attr name. That took me a second to find. Could we tweak
> the state and rename the helper to something like DAS_RMNAME  /
> _node_remove_name() so the naming is a bit more explicit?
Sure, this helper is actually added in patch 2 of this set.  I can 
rename it there?  People have already added their rvb's, but I'm 
assuming people are not bothered by small tweeks like that?  That way 
this patch just sort of moves it and XFS_DAS_CLNUP can turn into 
XFS_DAS_RMNAME here.

> 
>>   
>> -	/*
>> -	 * Check to see if the tree needs to be collapsed.
>> -	 */
>> -	if (retval && (state->path.active > 1)) {
>> -		error = xfs_da3_join(state);
>> -		if (error)
>> -			goto out;
>> -		error = xfs_defer_finish(&args->trans);
>> -		if (error)
>> -			goto out;
>>   		/*
>> -		 * Commit the Btree join operation and start a new trans.
>> +		 * Check to see if the tree needs to be collapsed. Set the flag
>> +		 * to indicate that the calling function needs to move the
>> +		 * shrink operation
>>   		 */
>> -		error = xfs_trans_roll_inode(&args->trans, dp);
>> -		if (error)
>> -			goto out;
>> -	}
>> +		if (retval && (state->path.active > 1)) {
>> +			error = xfs_da3_join(state);
>> +			if (error)
>> +				goto out;
>>   
>> -	/*
>> -	 * If the result is small enough, push it all into the inode.
>> -	 */
>> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>> -		error = xfs_attr_node_shrink(args, state);
>> +			dac->flags |= XFS_DAC_DEFER_FINISH;
>> +			dac->dela_state = XFS_DAS_RM_SHRINK;
>> +			return -EAGAIN;
>> +		}
>> +
>> +		/* fallthrough */
>> +	case XFS_DAS_RM_SHRINK:
>> +		/*
>> +		 * If the result is small enough, push it all into the inode.
>> +		 */
>> +		if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>> +			error = xfs_attr_node_shrink(args, state);
>> +
>> +		break;
>> +	default:
>> +		ASSERT(0);
>> +		error = -EINVAL;
>> +		goto out;
>> +	}
>>   
>> +	if (error == -EAGAIN)
>> +		return error;
>>   out:
>>   	if (state)
>>   		xfs_da_state_free(state);
> ...
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
>> index 48d8e9c..908521e7 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.c
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> ...
>> @@ -685,31 +687,29 @@ xfs_attr_rmtval_remove(
>>   	 * Keep de-allocating extents until the remote-value region is gone.
>>   	 */
>>   	do {
>> -		retval = __xfs_attr_rmtval_remove(args);
>> -		if (retval && retval != -EAGAIN)
>> -			return retval;
>> +		error = __xfs_attr_rmtval_remove(&dac);
>> +		if (error != -EAGAIN)
>> +			break;
> 
> Shouldn't this retain the (error && error != -EAGAIN) logic to roll the
> transaction after the final unmap? Even if this is transient, it's
> probably best to preserve behavior if this is unintentional.
Sure, I dont think it's intentional, I think back in v10 we had a 
different arangement here with a helper inside the while() expression 
that had equivelent error handling logic.  But that got nak'd in the 
next review and I think I likley forgot to put back this handling.  Will 
fix.

> 
> Otherwise my only remaining feedback was to add/tweak some comments that
> I think make the iteration function easier to follow. I've appended a
> diff for that. If you agree with the changes feel free to just fold them
> in and/or tweak as necessary. With those various nits and Chandan's
> feedback addressed, I think this patch looks pretty good.
Sure, those all look reasonable.  Will add.  Thanks for the reviews!
Allison

> 
> Brian
> 
> --- 8< ---
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 0bea8dd34902..ee885c649c26 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1289,14 +1289,21 @@ xfs_attr_remove_iter(
>   		if (!xfs_inode_hasattr(dp))
>   			return -ENOATTR;
>   
> +		/*
> +		 * Shortform or leaf formats don't require transaction rolls and
> +		 * thus state transitions. Call the right helper and return.
> +		 */
>   		if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL) {
>   			ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
>   			return xfs_attr_shortform_remove(args);
>   		}
> -
>   		if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>   			return xfs_attr_leaf_removename(args);
>   
> +		/*
> +		 * Node format may require transaction rolls. Set up the
> +		 * state context and fall into the state machine.
> +		 */
>   		if (!dac->da_state) {
>   			error = xfs_attr_node_removename_setup(dac);
>   			if (error)
> @@ -1304,7 +1311,7 @@ xfs_attr_remove_iter(
>   			state = dac->da_state;
>   		}
>   
> -	/* fallthrough */
> +		/* fallthrough */
>   	case XFS_DAS_RMTBLK:
>   		dac->dela_state = XFS_DAS_RMTBLK;
>   
> @@ -1316,7 +1323,8 @@ xfs_attr_remove_iter(
>   		 */
>   		if (args->rmtblkno > 0) {
>   			/*
> -			 * May return -EAGAIN. Remove blocks until 0 is returned
> +			 * May return -EAGAIN. Roll and repeat until all remote
> +			 * blocks are removed.
>   			 */
>   			error = __xfs_attr_rmtval_remove(dac);
>   			if (error == -EAGAIN)
> @@ -1325,26 +1333,26 @@ xfs_attr_remove_iter(
>   				goto out;
>   
>   			/*
> -			 * Refill the state structure with buffers, the prior
> -			 * calls released our buffers.
> +			 * Refill the state structure with buffers (the prior
> +			 * calls released our buffers) and close out this
> +			 * transaction before proceeding.
>   			 */
>   			ASSERT(args->rmtblkno == 0);
>   			error = xfs_attr_refillstate(state);
>   			if (error)
>   				goto out;
> -
>   			dac->dela_state = XFS_DAS_CLNUP;
>   			dac->flags |= XFS_DAC_DEFER_FINISH;
>   			return -EAGAIN;
>   		}
>   
> +		/* fallthrough */
>   	case XFS_DAS_CLNUP:
>   		retval = xfs_attr_node_remove_cleanup(args, state);
>   
>   		/*
> -		 * Check to see if the tree needs to be collapsed. Set the flag
> -		 * to indicate that the calling function needs to move the
> -		 * shrink operation
> +		 * Check to see if the tree needs to be collapsed. If so, roll
> +		 * the transacton and fall into the shrink state.
>   		 */
>   		if (retval && (state->path.active > 1)) {
>   			error = xfs_da3_join(state);
> @@ -1360,10 +1368,12 @@ xfs_attr_remove_iter(
>   	case XFS_DAS_RM_SHRINK:
>   		/*
>   		 * If the result is small enough, push it all into the inode.
> +		 * This is our final state so it's safe to return a dirty
> +		 * transaction.
>   		 */
>   		if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>   			error = xfs_attr_node_shrink(args, state);
> -
> +		ASSERT(error != -EAGAIN);
>   		break;
>   	default:
>   		ASSERT(0);
> 
