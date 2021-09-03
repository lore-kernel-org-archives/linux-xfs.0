Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 584DDC433F5
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Sep 2021 21:10:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BAA761107
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Sep 2021 21:10:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235926AbhICVLF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:11:05 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:57076 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235953AbhICVLF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Sep 2021 17:11:05 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 183IwuWl017829;
        Fri, 3 Sep 2021 21:10:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=w36XQQ3MFlzk/0+H3/sXwQW97HseDZXh1q02uvm5bAs=;
 b=mdxWzMRcT+tnRvBddCL76DmzkfI/KgBSZVAFEGHZUTGprY/rb2zthT3UmVhP53jSPxWh
 0Ygj0QKU9WRXQT6TnA09VxIdqGZ0W3lq+U13jd4ggEFLPV7zR2SzCG4Deq5V5NDT2uL1
 l0nnzdsVvZa44w9qaGEfQ8vtVfJRhTiClepSX8kWwde+y2pvHQKfnDlvxGEVlv6uSh+D
 1FH3L0lnb6DP2oJTqoVtUwfBRKnKnYfZknRCEaOadQJ+D1CVJ5a+J67mHansCg02jfKf
 Dbk4n/juA581L9CZZwIAG6hVV9vTu46iJbP5QgfWLJyPUou2//84/kFYpjsrHWFCY5pN cw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=w36XQQ3MFlzk/0+H3/sXwQW97HseDZXh1q02uvm5bAs=;
 b=TDuHwh17MRgySG8tOe6zMgTcr1TIn/hvdDtThWf5WzRctfUmNCDK03u4dDn/9psH5wzK
 0eEPc2URSyCZ9GuQQBJ4Wejxrwl7HZ4TB4etWmkEWzmbtOfRCR58WbGZ8g0xeusKFg/r
 rt9fJvkYnyibRxiOacuA535mAgk8lgxe3zJOsXWSF8GhW4gJ/lhXE6rnx70AFGx6huft
 WZCXq9IUEvzL9cJTQzkkRBm7ZZseST3bP66esC0ZBcgyA5WE3pQm671B71GJvEiHdBxJ
 XmxpBTvr7veVjY1LWIgbenAQXSUXYotsm51dIC+FJNm6dH+rwoLzyRgh4eGx318xGSiq zA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aufj7a3kj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Sep 2021 21:10:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 183L6Zdr002524;
        Fri, 3 Sep 2021 21:10:02 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by userp3030.oracle.com with ESMTP id 3ate081hjc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Sep 2021 21:10:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ioNinOtlTM7A+S7jfZWX0KUtjy649qnj/kTE7A+8brFMcak3adBUq5DiUkn0HOdyBtg4m+7QFo7ZBEecn/EZUtNyYaBz7cO5IlLzA5s3wFxuJ06bCMak5kBaaZ8NlM5l1E9z1cP1OlR7vOrgC81HMaphnqQP4v6ZYatEd13GCr2OHSO6wIFExT2bp7sz5nV7qiXFzOJpf+SX1ERpdawBpgMZWayz5AD8rD0ng7vFWbYNB8ufxDcbiYEGMIiIoq3ocWv0Xpp6NNfpnl8uKuVhFVFETT+QCQP2sMKDtnIrd9A2s17kcviEwW9z8weg+tkKpN/i6ejx8s50jVWPZkeR6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=w36XQQ3MFlzk/0+H3/sXwQW97HseDZXh1q02uvm5bAs=;
 b=E5ngpD2Jc6by54oD0pSuUJ+0do4YPz7QSW4ZR1VogJvhzqA+I+37HwQ17+jEPcdbx/CBVoZpXV0rIHnFDjhzs0eLPukLRQlXQRBWY9aGDRZI1LBvewpApHWhK93zoOGsV1fK8oeDp1O73X371uvjr5zW/wGUiBdINbwEMUlhyJuuh5B+MAhDn4MAlBgzPnAQic7N2iNKeP+izcVdBZ5K0K24sHEMxuSVvVmYtLOcX60tvZFObQPdVI3eLn3Erpp+HlkclX9J7IH1pXFk7ihV7tvR8EMpb6YelENklNwA+vZYS05/hCtu1iIWwNEHxivv7e3JGvYDX9XktweaYFIH2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w36XQQ3MFlzk/0+H3/sXwQW97HseDZXh1q02uvm5bAs=;
 b=KDgbV4xPTI2khtvEkTdrceRh5oDAPW0j0hLSSuOd7eupXzVSYjA/d6il7ZkyVakKzfjGSASXasqHuTlALhOLXwQ0/SIEFNokMqwC6nIOyCIy8fhA0UYJEkn8cqaJVu7mvfoO4H3V2UpJU3/3lHLaNlpugR1Di7lIVVmaA3rqnpg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Fri, 3 Sep
 2021 21:10:00 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f%8]) with mapi id 15.20.4478.023; Fri, 3 Sep 2021
 21:10:00 +0000
Subject: Re: [PATCH 6/7] [RFC] xfs: intent item whiteouts
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20210902095927.911100-1-david@fromorbit.com>
 <20210902095927.911100-7-david@fromorbit.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <67e48ab2-bf23-cff1-7793-6e6b4fa1dd70@oracle.com>
Date:   Fri, 3 Sep 2021 14:09:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210902095927.911100-7-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR03CA0034.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::47) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from [192.168.1.167] (67.1.112.125) by BYAPR03CA0034.namprd03.prod.outlook.com (2603:10b6:a02:a8::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17 via Frontend Transport; Fri, 3 Sep 2021 21:09:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: faff934e-8bfa-4fec-a24b-08d96f1f309e
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4429:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4429A4520CD3ADCDA10E945395CF9@SJ0PR10MB4429.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vyj+TfDiLGLCZjedy294yhVKN17qBvO6AC4uX11DuFKFtF/mE7E1S3EIZhjK0fQHMybVMfxfn90lVQY5qwwqZ+33uJg+Er5fNXwYxmVWs0zk290o+JhoKvz1gHtvY/JJF1lgliXpXc/k0s9E2jcBkMXyj8t9O/Bbby852LtvvlUBNG63PCz9UbczcbsqBKMcWhy15fdGCGwd9IPXCLp8wPQVvrBOToy3qtNMfOKya4I8DunTqylxwwFPsF3t5xeZU1tV7LxWBLGKC1NhkLotnk++L4XKbyugE6btlnLJwgaF/G0znQxxLYsTLw1prpJgbfAjYL2sgKP8Wb2Tm1NxXLNFh09fO641OVc13sAu12M5En7bhoeAgLnvVr3LBA2/mHZFpZoIpxFTR7zuNYeGp/QUrMTYznFPE08oBfAssk1famENynbt0/D0GfmSLkHq0Kj0AKC7u4unDPvWzfezcSAFzm4qWlXQgDQFkFnbDD+mQyhNOf98nzEbFYgMRqOjj6RKTWZnT9aFVX7kiOqU5lG5fvjiljrUB5Nc0xRxcwnsPZtG8BeSrV86wvb+fT35E/TJ6WH7CuCyp7cvqQGbXFV5vs09S9pJn/1RuFpUEz8YP0JQlArtcLYLxxM/jq/mUMU1ZIfkgzu4tjubFy1ZZiq+dbdO8Szqp/BhMC1jp0JbwEQn3QzDeVVgMYkSyCVJAVY9FZsAF3UK5hvztlgiOgCLC2ucu0LReAqKHK7En4xHyzk9dIva7X0tSjTQbGiUPbpVGcTR05E4SjLMwh+yNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(366004)(396003)(6486002)(956004)(8676002)(31696002)(316002)(8936002)(478600001)(86362001)(186003)(83380400001)(16576012)(36756003)(38100700002)(38350700002)(66946007)(30864003)(2906002)(66556008)(26005)(31686004)(2616005)(44832011)(66476007)(53546011)(52116002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N29UYlgxVHRDNkp3L0pyVVJlczcvNGdsdS9ZQ3BUdDE1UWVYQnBFVVdKZnJD?=
 =?utf-8?B?OGUwMy9abG9Pdmovb2tPVGs1M05UcUdlNDRVenVvSThvSHZVSUhkQ1pUSjVa?=
 =?utf-8?B?YlJJRzhwVWg4Ny91dlBsSTlVWE4xVkV1YVVZMnB2cXZNbUpVdjE4MWdCTStx?=
 =?utf-8?B?Zkg4aHg1d1lOeW1sTUc3MTNIWkxneHVqL3R1UnFlK1crelROUzBnQzh0S3du?=
 =?utf-8?B?c3FDWm4zVmxRZC9KMFdjbGtTejM0UTBnODFyK2gzZGlRRHYweW5VVEcrbHRR?=
 =?utf-8?B?Z3hqRnBqREdNUmlEb0RPR3dJOGpOMnJZWVNFaEJPMS80aTFKaExCWGxwSUNr?=
 =?utf-8?B?V280SXlpYUZXeFFwVnFPRWJ2SFl6eEcyYTRUbmtMQ3JQT3FiT2Foa2kwcEV4?=
 =?utf-8?B?THhQamt6ckdROHhuZDlBU2xTR3QzUDl2bVpMQlp5aDdSek15M2IvNkJMNUlR?=
 =?utf-8?B?WDlhdFRhUkJzUWtFMitUZTFpNk8vc3Zxd2hMcUltdSsxNDJKM0NsOWdpWUVN?=
 =?utf-8?B?NmQzc1duRmt4eGk3QmU0cVRwQTJScmIwWHVBSjM5M3lzdFh1S3d5NHRUc3c4?=
 =?utf-8?B?MjBrVDhUamhvWlZvYWFFNW9sTndHZEJ5M2VJYzdBQjJhTzhQckV0N3FFK29a?=
 =?utf-8?B?SVV2QkNrWlNFeERMbndxTXRSb21pQ1R4ZFYrSEg0eFk0amVVUWlTd3lLNjdL?=
 =?utf-8?B?ZWVmMnBENEIyQm4yeXVZVDREeXYzdTRwMkRrSjRaYU9TY1lNYTBvMTViWjhw?=
 =?utf-8?B?bm9tZVA3N0p1T3lFeXJvRjdFUUFibU9vWFU5WXZyd2ltajV6K205Rll4UFNL?=
 =?utf-8?B?QlVCVU9MYjFpUlBrQWdGa2ZwTVkzYnVDQVdEQTV0cFp1b2JETVJQNGp1aXMw?=
 =?utf-8?B?UTF6QmdQcDRmaE5iQzlmb1pPVjd4dExZc0pkWklMYjJLOW0yTWxxdy9BN1gr?=
 =?utf-8?B?QXM5VHlWRkVWVlRJYUN2NmdBNnpkQnFHRzRGYUc4MnpNZEEvOVp1ZzhERmlR?=
 =?utf-8?B?TmNTSGFPNDN6UVdOelJ3ZFpQUzNscVQxQS9kWVdSWW11QjFkcEJuZHYyOTVN?=
 =?utf-8?B?M29KNFZvNFZiaFIyUk5XTUhzSlIwWEJrK2tGQmxpTDd1azNYU210SVlSUHNl?=
 =?utf-8?B?Qkp3UVBkYWFYTGlKL3BiSU02Q0RKWjl2TDRVL1BWRnI1cTI5S0U4YjNMaWJv?=
 =?utf-8?B?UHNleE9XNEkwMXRQVGJ3YVNiTHJEWUdCTWliU0JJdWE1Ull6RGxDeU1FSndo?=
 =?utf-8?B?RXRLTU8wbjhuRUZJNFE5U2hUMkNqZTNkQTFvQVFhNWxzNEdNaW51Wkt5U2Ny?=
 =?utf-8?B?S0JkUHphclU4MHlPTlVEZGJtaUlmYUh0U1JnVDMxVk41ZG5COHRqWE93dmx3?=
 =?utf-8?B?eVVOODZUWXJCaWd6Q0JLUnplczgvZ3I0dU9RQnJOYTJnU29CcWh4dXBpa1hC?=
 =?utf-8?B?NG9lVlJ4cHpEWm0wNlpxd3NZN2UyQ2pJUG5BVW8zcXYvaEN3VVpkM0ExaGpE?=
 =?utf-8?B?QU9tOVlLV01LN1g2SDRtTEdpWjlmYW9rbHBHTDdUSjJWZnI1d3RuOWhDSm5H?=
 =?utf-8?B?NnlkYXMva1JOQmt2cmd5U2thZk9ldmx4N1lWc0tzL3VqRUNMQ2wrZVFTTTYv?=
 =?utf-8?B?RnFNYUFlU1Y4YTBHcWFWRDlPOXFxOVpDekRIeHRvenppN2VBMndpU2h3SFR4?=
 =?utf-8?B?OFA3cTFZcjlDUkFqZ01NOFlkVzUxcm9MblhheFRJWFZsYlAwaVFZVEpXcVV6?=
 =?utf-8?Q?2LHNJ7vdeb7h/pp3Ei9p/Af4vqtC0l2IECDlT1l?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: faff934e-8bfa-4fec-a24b-08d96f1f309e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2021 21:10:00.0903
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vXdj0Xc5ahd5OAZXYz25ybpEQkTDAWjsYjcD74eGWE/UO9Su0x1lwGU+AtYPp+NqTggNfrF4CIus29Vi7baDWJIh4BEbqcdIwRDi7xnLq54=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4429
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10096 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 mlxscore=0
 phishscore=0 malwarescore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2108310000
 definitions=main-2109030123
X-Proofpoint-ORIG-GUID: ajCGA6aR4bRVjESL7kuHVMCQvEO7epSy
X-Proofpoint-GUID: ajCGA6aR4bRVjESL7kuHVMCQvEO7epSy
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 9/2/21 2:59 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we log modifications based on intents, we add both intent
> and intent done items to the modification being made. These get
> written to the log to ensure that the operation is re-run if the
> intent done is not found in the log.
> 
> However, for operations that complete wholly within a single
> checkpoint, the change in the checkpoint is atomic and will never
> need replay. In this case, we don't need to actually write the
> intent and intent done items to the journal because log recovery
> will never need to manually restart this modification.
> 
> Log recovery currently handles intent/intent done matching by
> inserting the intent into the AIL, then removing it when a matching
> intent done item is found. Hence for all the intent-based operations
> that complete within a checkpoint, we spend all that time parsing
> the intent/intent done items just to cancel them and do nothing with
> them.
> 
> Hence it follows that the only time we actually need intents in the
> log is when the modification crosses checkpoint boundaries in the
> log and so may only be partially complete in the journal. Hence if
> we commit and intent done item to the CIL and the intent item is in
> the same checkpoint, we don't actually have to write them to the
> journal because log recovery will always cancel the intents.
> 
> We've never really worried about the overhead of logging intents
> unnecessarily like this because the intents we log are generally
> very much smaller than the change being made. e.g. freeing an extent
> involves modifying at lease two freespace btree blocks and the AGF,
> so the EFI/EFD overhead is only a small increase in space and
> processing time compared to the overall cost of freeing an extent.
> 
> However, delayed attributes change this cost equation dramatically,
> especially for inline attributes. In the case of adding an inline
> attribute, we only log the inode core and attribute fork at present.
> With delayed attributes, we now log the attr intent which includes
> the name and value, the inode core adn attr fork, and finally the
> attr intent done item. We increase the number of items we log from 1
> to 3, and the number of log vectors (regions) goes up from 3 to 7.
> Hence we tripple the number of objects that the CIL has to process,
> and more than double the number of log vectors that need to be
> written to the journal.
> 
> At scale, this means delayed attributes cause a non-pipelined CIL to
> become CPU bound processing all the extra items, resulting in a > 40%
> performance degradation on 16-way file+xattr create worklaods.
> Pipelining the CIL (as per 5.15) reduces the performance degradation
> to 20%, but now the limitation is the rate at which the log items
> can be written to the iclogs and iclogs be dispatched for IO and
> completed.
> 
> Even log IO completion is slowed down by these intents, because it
> now has to process 3x the number of items in the checkpoint.
> Processing completed intents is especially inefficient here, because
> we first insert the intent into the AIL, then remove it from the AIL
> when the intent done is processed. IOWs, we are also doing expensive
> operations in log IO completion we could completely avoid if we
> didn't log completed intent/intent done pairs.
> 
> Enter log item whiteouts.
> 
> When an intent done is committed, we can check to see if the
> associated intent is in the same checkpoint as we are currently
> committing the intent done to. If so, we can mark the intent log
> item with a whiteout and immediately free the intent done item
> rather than committing it to the CIL. We can basically skip the
> entire formatting and CIL insertion steps for the intent done item.
> 
> However, we cannot remove the intent item from the CIL at this point
> because the unlocked per-cpu CIL item lists do not permit removal
> without holding the CIL context lock exclusively. Transaction commit
> only holds the context lock shared, hence the best we can do is mark
> the intent item with a whiteout so that the CIL push can release it
> rather than writing it to the log.
> 
> This means we never write the intent to the log if the intent done
> has also been committed to the same checkpoint, but we'll always
> write the intent if the intent done has not been committed or has
> been committed to a different checkpoint. This will result in
> correct log recovery behaviour in all cases, without the overhead of
> logging unnecessary intents.
> 
> This intent whiteout concept is generic - we can apply it to all
> intent/intent done pairs that have a direct 1:1 relationship. The
> way deferred ops iterate and relog intents mean that all intents
> currently have a 1:1 relationship with their done intent, and hence
> we can apply this cancellation to all existing intent/intent done
> implementations.
> 
> For delayed attributes with a 16-way 64kB xattr create workload,
> whiteouts reduce the amount of journalled metadata from ~2.5GB/s
> down to ~600MB/s and improve the creation rate from 9000/s to
> 14000/s.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
Ok, this makes a lot of sense.  Thanks for the detailed explanation, it 
helps a lot.  I think we need to do everything we can to optimize things 
as much as possible.  Since the over all goal is parent pointers, attr 
activity will increase quite a bit.  So I would support this change.

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_log_cil.c | 78 +++++++++++++++++++++++++++++++++++++++++---
>   fs/xfs/xfs_trace.h   |  3 ++
>   fs/xfs/xfs_trans.h   |  7 ++--
>   3 files changed, 82 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index bd2c8178255e..fff68aad254e 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -502,7 +502,8 @@ xlog_cil_insert_format_items(
>   static void
>   xlog_cil_insert_items(
>   	struct xlog		*log,
> -	struct xfs_trans	*tp)
> +	struct xfs_trans	*tp,
> +	uint32_t		released_space)
>   {
>   	struct xfs_cil		*cil = log->l_cilp;
>   	struct xfs_cil_ctx	*ctx = cil->xc_ctx;
> @@ -569,6 +570,7 @@ xlog_cil_insert_items(
>   	 */
>   	cilpcp = get_cpu_ptr(cil->xc_pcp);
>   	cilpcp->space_reserved += ctx_res;
> +	cilpcp->space_used -= released_space;
>   	cilpcp->space_used += len;
>   	if (space_used >= XLOG_CIL_SPACE_LIMIT(log) ||
>   	    cilpcp->space_used >
> @@ -1028,11 +1030,14 @@ xlog_cil_order_cmp(
>   }
>   
>   /*
> - * Build a log vector chain from the current CIL.
> + * Build a log vector chain from the current CIL. If a log item is marked with a
> + * whiteout, we do not need to write it to the journal and so we just move them
> + * to the whiteout list for the caller to dispose of appropriately.
>    */
>   static void
>   xlog_cil_build_lv_chain(
>   	struct xfs_cil_ctx	*ctx,
> +	struct list_head	*whiteouts,
>   	uint32_t		*num_iovecs,
>   	uint32_t		*num_bytes)
>   {
> @@ -1043,6 +1048,11 @@ xlog_cil_build_lv_chain(
>   
>   		item = list_first_entry(&ctx->log_items,
>   					struct xfs_log_item, li_cil);
> +		if (test_bit(XFS_LI_WHITEOUT, &item->li_flags)) {
> +			list_move(&item->li_cil, whiteouts);
> +			trace_xfs_cil_whiteout_skip(item);
> +			continue;
> +		}
>   
>   		lv = item->li_lv;
>   		lv->lv_order_id = item->li_order_id;
> @@ -1092,6 +1102,7 @@ xlog_cil_push_work(
>   	DECLARE_COMPLETION_ONSTACK(bdev_flush);
>   	bool			push_commit_stable;
>   	struct xlog_ticket	*ticket;
> +	LIST_HEAD		(whiteouts);
>   
>   	new_ctx = xlog_cil_ctx_alloc();
>   	new_ctx->ticket = xlog_cil_ticket_alloc(log);
> @@ -1178,7 +1189,7 @@ xlog_cil_push_work(
>   				&bdev_flush);
>   
>   	xlog_cil_pcp_aggregate(cil, ctx);
> -	xlog_cil_build_lv_chain(ctx, &num_iovecs, &num_bytes);
> +	xlog_cil_build_lv_chain(ctx, &whiteouts, &num_iovecs, &num_bytes);
>   
>   	/*
>   	 * Switch the contexts so we can drop the context lock and move out
> @@ -1312,6 +1323,15 @@ xlog_cil_push_work(
>   	/* Not safe to reference ctx now! */
>   
>   	spin_unlock(&log->l_icloglock);
> +
> +	/* clean up log items that had whiteouts */
> +	while (!list_empty(&whiteouts)) {
> +		struct xfs_log_item *item = list_first_entry(&whiteouts,
> +						struct xfs_log_item, li_cil);
> +		list_del_init(&item->li_cil);
> +		trace_xfs_cil_whiteout_unpin(item);
> +		item->li_ops->iop_unpin(item, 1);
> +	}
>   	xfs_log_ticket_ungrant(log, ticket);
>   	return;
>   
> @@ -1323,6 +1343,14 @@ xlog_cil_push_work(
>   
>   out_abort_free_ticket:
>   	ASSERT(xlog_is_shutdown(log));
> +	while (!list_empty(&whiteouts)) {
> +		struct xfs_log_item *item = list_first_entry(&whiteouts,
> +						struct xfs_log_item, li_cil);
> +		list_del_init(&item->li_cil);
> +		trace_xfs_cil_whiteout_unpin(item);
> +		item->li_ops->iop_unpin(item, 1);
> +	}
> +
>   	if (!ctx->commit_iclog) {
>   		xfs_log_ticket_ungrant(log, ctx->ticket);
>   		xlog_cil_committed(ctx);
> @@ -1475,6 +1503,43 @@ xlog_cil_empty(
>   	return empty;
>   }
>   
> +/*
> + * If there are intent done items in this transaction and the related intent was
> + * committed in the current (same) CIL checkpoint, we don't need to write either
> + * the intent or intent done item to the journal as the change will be
> + * journalled atomically within this checkpoint. As we cannot remove items from
> + * the CIL here, mark the related intent with a whiteout so that the CIL push
> + * can remove it rather than writing it to the journal. Then remove the intent
> + * done item from the current transaction and release it so it doesn't get put
> + * into the CIL at all.
> + */
> +static uint32_t
> +xlog_cil_process_intents(
> +	struct xfs_cil		*cil,
> +	struct xfs_trans	*tp)
> +{
> +	struct xfs_log_item	*lip, *ilip, *next;
> +	uint32_t		len = 0;
> +
> +	list_for_each_entry_safe(lip, next, &tp->t_items, li_trans) {
> +		if (!(lip->li_ops->flags & XFS_ITEM_INTENT_DONE))
> +			continue;
> +
> +		ilip = lip->li_ops->iop_intent(lip);
> +		if (!ilip || !xlog_item_in_current_chkpt(cil, ilip))
> +			continue;
> +		set_bit(XFS_LI_WHITEOUT, &ilip->li_flags);
> +		trace_xfs_cil_whiteout_mark(ilip);
> +		len += ilip->li_lv->lv_bytes;
> +		kmem_free(ilip->li_lv);
> +		ilip->li_lv = NULL;
> +
> +		xfs_trans_del_item(lip);
> +		lip->li_ops->iop_release(lip);
> +	}
> +	return len;
> +}
> +
>   /*
>    * Commit a transaction with the given vector to the Committed Item List.
>    *
> @@ -1497,6 +1562,7 @@ xlog_cil_commit(
>   {
>   	struct xfs_cil		*cil = log->l_cilp;
>   	struct xfs_log_item	*lip, *next;
> +	uint32_t		released_space = 0;
>   
>   	/*
>   	 * Do all necessary memory allocation before we lock the CIL.
> @@ -1508,7 +1574,11 @@ xlog_cil_commit(
>   	/* lock out background commit */
>   	down_read(&cil->xc_ctx_lock);
>   
> -	xlog_cil_insert_items(log, tp);
> +	if (tp->t_flags & XFS_TRANS_HAS_INTENT_DONE)
> +		released_space = xlog_cil_process_intents(cil, tp);
> +
> +	xlog_cil_insert_items(log, tp, released_space);
> +	tp->t_ticket->t_curr_res += released_space;
>   
>   	if (regrant && !xlog_is_shutdown(log))
>   		xfs_log_ticket_regrant(log, tp->t_ticket);
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 77a78b5b1a29..d4f5a1410879 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1348,6 +1348,9 @@ DEFINE_LOG_ITEM_EVENT(xfs_ail_push);
>   DEFINE_LOG_ITEM_EVENT(xfs_ail_pinned);
>   DEFINE_LOG_ITEM_EVENT(xfs_ail_locked);
>   DEFINE_LOG_ITEM_EVENT(xfs_ail_flushing);
> +DEFINE_LOG_ITEM_EVENT(xfs_cil_whiteout_mark);
> +DEFINE_LOG_ITEM_EVENT(xfs_cil_whiteout_skip);
> +DEFINE_LOG_ITEM_EVENT(xfs_cil_whiteout_unpin);
>   
>   DECLARE_EVENT_CLASS(xfs_ail_class,
>   	TP_PROTO(struct xfs_log_item *lip, xfs_lsn_t old_lsn, xfs_lsn_t new_lsn),
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index a6d7b3309bd7..5765ca6e2c84 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -55,13 +55,16 @@ struct xfs_log_item {
>   #define	XFS_LI_IN_AIL	0
>   #define	XFS_LI_ABORTED	1
>   #define	XFS_LI_FAILED	2
> -#define	XFS_LI_DIRTY	3	/* log item dirty in transaction */
> +#define	XFS_LI_DIRTY	3
> +#define	XFS_LI_WHITEOUT	4
>   
>   #define XFS_LI_FLAGS \
>   	{ (1 << XFS_LI_IN_AIL),		"IN_AIL" }, \
>   	{ (1 << XFS_LI_ABORTED),	"ABORTED" }, \
>   	{ (1 << XFS_LI_FAILED),		"FAILED" }, \
> -	{ (1 << XFS_LI_DIRTY),		"DIRTY" }
> +	{ (1 << XFS_LI_DIRTY),		"DIRTY" }, \
> +	{ (1 << XFS_LI_WHITEOUT),	"WHITEOUT" }
> +
>   
>   struct xfs_item_ops {
>   	unsigned flags;
> 
