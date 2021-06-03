Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,TVD_PH_BODY_ACCOUNTS_PRE,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0649C47082
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 22:29:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD4EC61406
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 22:29:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbhFCWbY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Jun 2021 18:31:24 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52854 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230511AbhFCWbX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jun 2021 18:31:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 153MKvI8181955;
        Thu, 3 Jun 2021 22:29:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=dnVbRZhoHE5R1Jv2E9P/TudYeZflUQwhmYJVJaF2Oa4=;
 b=uMMTqu9mIHY/ExJHg2gQXEjV49SPYxN33zdON2fe3T91VzcOUPiYRjoJqao9vfXq/ziw
 YSexyOKXn+1HDyijzzFrbBI3e6DrdkZspKsF/x5iJaAY0DhQUo8RmQqVt0vbLEO9K6p8
 y/TlGmTA/NM5/xOiW/mA4T8tB7o2PCb2ySpoWdXYeLNYCWCxAfdpVGg+Y3QKviIuh7RX
 otwJdzPL3AErKDmgW6FPo+mEh2xhnC1lY1NJAEBpQvxRWMP28MFHblEhIip8+sBs3cCH
 lcBQGNlzsN9UhpP2NRk4LkzbhlagK0K1uvuZNxVXQy3cYPaiS2lj6e7ZMjx8fO5xA0TT Xg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 38ue8pmj3b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jun 2021 22:29:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 153MK7Yv031507;
        Thu, 3 Jun 2021 22:29:36 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2042.outbound.protection.outlook.com [104.47.57.42])
        by userp3030.oracle.com with ESMTP id 38uaqypcpj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jun 2021 22:29:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cSW0bIvtpQyYXV3E8IvLdyhrK4nUYT15/Uvx5zdDPLWCysQ+k0MGHUzItKeGcOOomC/C0ORCpSNeV/emm8fmY2hzlodLn9GGImmEmQYer6zUMEK/o8B0BvmgdEa3DGB1SasIkL8PcqZPj24R9zAcbA9E1tj45hDzxcCWimOdWXqZdr3zLLurURESffa4Q3u0p8vQEGRJQSGS08W078iYjhFmgWBDxsSZ4GU9YW+1/Ax4pQFacnnkEnYAc+oDqspV4UeQG4mofHRwpafeirohVQIqX9INDYjtYwOFQRjSsy1stCwVxsqLam83sd5Wbf/ydJmBgR/374/qFRWAW8lTgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dnVbRZhoHE5R1Jv2E9P/TudYeZflUQwhmYJVJaF2Oa4=;
 b=LNWGPuy4OQwnhijZHxf/3HkgjbHxFu1EOItFvazuaA+Ar+ebIIdDx7jWuaX7y+MMN3boMFu/aWBwLyrNU85MzmeilRHEhh0crkFcBTUFWlJh9gzCFAdvkjkvgz38cPVsmqmfsDOEt6uw5ox+C5lGmOy1l/o4kyLdylmesS6yhZBClJkpy9wc9q9i3OJofVW7jTrH9MFcE4rqT9h5S8NfgmZUbGe2LvcCvYWQznbxLyZxOkVjNW3wAoFYC6Ky6DbwHf2jfhHJwN5EPzXJaevaN2565E0LoTNYDHl9c39o80kiu1pcsxdUQhLzVhQIJHNZgTSqwavSrV3HEffeSLtN1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dnVbRZhoHE5R1Jv2E9P/TudYeZflUQwhmYJVJaF2Oa4=;
 b=KtRnIrrpTWps/hgYch3tFMUWImkxCPennHstc7TtwI3F7XdW+EGTCKcsJ4KXMGrboNCvNcZy5Vs5TYMVes5Vcb/CbrAcwX9jlgaWf0uCCrwKnCmw47RSBY7N/ur434W4VGUAEVSyC3Lo/5yoizi/4hRTqTes93yUzJmi/ALWr74=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2712.namprd10.prod.outlook.com (2603:10b6:a02:b3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Thu, 3 Jun
 2021 22:29:34 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728%5]) with mapi id 15.20.4195.023; Thu, 3 Jun 2021
 22:29:34 +0000
Subject: Re: [PATCH 07/39] xfs: journal IO cache flush reductions
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20210603052240.171998-1-david@fromorbit.com>
 <20210603052240.171998-8-david@fromorbit.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <265f67b1-a0a8-ae43-368b-add687e17fae@oracle.com>
Date:   Thu, 3 Jun 2021 15:29:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210603052240.171998-8-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: BY5PR17CA0051.namprd17.prod.outlook.com
 (2603:10b6:a03:167::28) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.210.54) by BY5PR17CA0051.namprd17.prod.outlook.com (2603:10b6:a03:167::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22 via Frontend Transport; Thu, 3 Jun 2021 22:29:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21ea0485-ccbb-4498-618b-08d926df104f
X-MS-TrafficTypeDiagnostic: BYAPR10MB2712:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2712F40A46824DA3A7998D85953C9@BYAPR10MB2712.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g4qL+zS10AyItDEhJVw4l11b/F3SKMHNj50ayU4aLhhBxDwBa2RlpEWXDsMCfhvFe6yTRMK5/cy8bG0F+Crc12GqSXQel0fCYHRvhlj8mF1JPLcVUEaKY9ohAD3P+GCi8jn8wSg/qIyxV3cj2CbjRO4548VDc3EU4T0ujeTQAHBiWRD/bppp71Qja4iuR5+MNvfjXSIc0vIBiuwMsY6V62wW+Ag0iVYlZirEluK4qrOMi1/Jv6Avn/QUEhNffy38QOKWfTibYRTDCQ004TpUDtucs4N0ackg3bLdOGknEg9b6ipOYiHssTnYg2Vy/4hD5THUlhJg6/tXF3PQqQGMRp2PPj26GSe2OvkrQKGfWu8l+fSZv6Pq2+NoU4jaX+cESkRgOGRf5YVtlynrEWNf8tRubcsBLFmqO+tu5/r8CSFP9LHgHha3JWzPUNwrGWkohPyj382nNyBHMie6Ydqzrzc5p860EJCVlvBR3VWfM5ATRk9GSOKmsJ3kT0cj0AlcrOeMTNSjRRyKBudvhlifm1K9xxdXKaxVcZoJjdr5lMXNnHFmwlZb6kMNUN97YZpWQRFykTO/tsiJUebPvz7U1cYjsof9U8j99K/lJBzmoIdYm/mwm5iCsC2IdbKHlZkHce3KWo+u5TdV9hBXeATvh7HQQETwlBX87QNVFGCNGCWT62rxeojyYNd5FPJSTqK1l4uTZG/hPMuC2eV62EybrI2AjjQCvkjNRdMIDTl8a5A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(396003)(366004)(136003)(346002)(16576012)(316002)(30864003)(66946007)(36756003)(44832011)(8676002)(31686004)(83380400001)(66476007)(5660300002)(66556008)(186003)(26005)(16526019)(38100700002)(38350700002)(956004)(86362001)(31696002)(2616005)(8936002)(478600001)(2906002)(6486002)(52116002)(53546011)(60764002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Y1Blck1NRUhUd3NJd2hPWUNRckhPVTMvaXdlTmN2QW5XSy9xSlZCb0VHTWQr?=
 =?utf-8?B?ak8yQmxQNUlzaW1RWFZVeXNUSWNsZ05BV3FsZjdIRjVpWjF5cTZTZ21IVS9o?=
 =?utf-8?B?RW13ZUdtUXRMVG5CYW1qSnZzWStSTEtIZlBzUHo3RHlmLzRyZCtzb21sSmVU?=
 =?utf-8?B?dVlidFdaTDlybWVYYTFNTHlkNGdlVlNBNzRLbWo0Z1l6Yk1DMlBHTHNwVzlP?=
 =?utf-8?B?d25pQ1NmQ1FoWFR5WU1pemltZmpYSm5GZStQNi9BWUNNbm9jTU5ocDd5eTJY?=
 =?utf-8?B?dkdTSE5uOWVkN2RjU21lb1pLYytYc3BzRnhXNHJZRHBNM09zcVRXVnptWW8y?=
 =?utf-8?B?d3F4QlpXOE9vYjR2allDalBBbVdjMWlxdERWbHErNElLeDNsMVM4NEN5N1Fv?=
 =?utf-8?B?M2xrTjNBQ3FIMHp5UjZ6Tk9WTmlxMUozaWFNRVk2dXA1VGtZbWt0VFBTR0Rt?=
 =?utf-8?B?MGc5akZYSVZ1SGZGeEdsdWowS0djVk80YnVkc2h3MzZxTEhkYlM3bnkrTDhH?=
 =?utf-8?B?Z0lJMnlIdmM1UFF3K3RGUFlDMXE0SGpEU3V1NTVFdWFmc2Q5K21lcGVJcEhV?=
 =?utf-8?B?bWpjYVZmTFFVeUpvSC9zeTBhOUZxd0l1UHFvdFJ6NmZNcjdkNHlteWczOGhm?=
 =?utf-8?B?anM5RU1nRVl5NER5cmZ0M211QTVYWE9SWWdvY3dISTErSzhrWURsa05uWjBU?=
 =?utf-8?B?SkI5M1d6TUtjczZ6UDBBR3RmVGU3andXN3k2cGJ6OElReU1jcndkclBONEFo?=
 =?utf-8?B?MXF0NVorWjNHRW9iUndwZVgyZklYak5WNm85ZTAxaVlOVHFsdndUQjlZWVJQ?=
 =?utf-8?B?MzVjZlpycGdWV2t1M1lCMHZ0bDRrNTh1V1AyNWErVTUzNkFuU3dIM3RrYk1S?=
 =?utf-8?B?M291bUF5dUZ3L0ZieGZKbU10Rk5jZXNRdDExOUVZTDExSVNiTE1HdUE5OTVm?=
 =?utf-8?B?RXMwdzZpaDNNMyt1aTFYVzlpZjJkUmhQZkFaWityb2RGNmNuUUNtSzVJNFRa?=
 =?utf-8?B?dk9rTUNHdnNncVBmbmNyRUF4TFVFMC9sK3h1Ym5jQjRkTmxzdzRWRW5xTnVr?=
 =?utf-8?B?WlZJc29URUlMTm5ZclJZeFdldm5mU3hRWHZqSEdITUFPOXBPSStORVVLY1Aw?=
 =?utf-8?B?QjJ1a3pDcjNsZzd0MU40TlRyZFpHMWxPZi9pdjBRWGNUam1nYlNoU2dyL0t0?=
 =?utf-8?B?c0FRK2VCNm5vVFBEOWhhQXlvcjJ6cDdNY21CUVVXV1R3UGNjZXpidTR0bGVB?=
 =?utf-8?B?NlBiV0hEcTNmYUlRYlF5dWpJOEhCd2hVV0lEZXl4WU5uVm5jWENhbWcxSmhX?=
 =?utf-8?B?L0U1bzBuSXIyTXRPYmpmeEFyM3RiVEhoSUFDeVhYYU01N0dFR084cVZHdWl5?=
 =?utf-8?B?ajNZb2JSekxQVlk0YWp4MU1obW8xdzVtc0NPcENBZncxamJwRmxSL1U0VXM1?=
 =?utf-8?B?bXZvMHNqbWdrMW5qYzVjdEh4MGlPODZ2bHAxZDNKVmpXS1pyeW1EWjkwR1oz?=
 =?utf-8?B?RFUvcTZIcmNkYnpmZGdvVy9uMk5CYUR6REpsRWRsZjdaY0FXcC8ycTNHYWVW?=
 =?utf-8?B?aU5DRHgxUGVpU0VaRGloVy9JOWY3enFSMGgvMGVYNzJsNHU0RXRjWnJ1TTha?=
 =?utf-8?B?TUtJTURxaU1XQlZUY1VFTGhkNnB2UVZCcXUzSDhkVVo4RVdFbm9BZVk0a0pj?=
 =?utf-8?B?bFZDK2Z5REdjM29XaU94UW1jaEYyaStCbk1OTEZZcCs4UnBDTDFyMEk4Y3By?=
 =?utf-8?Q?qbONnkHYW3zWwS/T/PblhYeTAwp2gyU1YN0Zt6G?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21ea0485-ccbb-4498-618b-08d926df104f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 22:29:34.3801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dEPw9osZ6Vd8MYb6ECj87aVVbszRx6+lRmEQtfH6Hnk4hc0y9Ck7RbIGw1KwXEs8slcIVjVgJqQ95iQnx2t3uyycBYNvQ3uDw3c8GSrmc44=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2712
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10004 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106030148
X-Proofpoint-GUID: fS8wZ5I0-aVxSrAoGVq_Cwcyl-ShIZ4Q
X-Proofpoint-ORIG-GUID: fS8wZ5I0-aVxSrAoGVq_Cwcyl-ShIZ4Q
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10004 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 malwarescore=0 adultscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 phishscore=0 priorityscore=1501 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106030148
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 6/2/21 10:22 PM, Dave Chinner wrote:
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
> The ordering guarantees of #1 are provided by REQ_PREFLUSH. This
> causes the journal IO to issue a cache flush and wait for it to
> complete before issuing the write IO to the journal. Hence all
> completed metadata IO is guaranteed to be stable before the journal
> overwrites the old metadata.
> 
> The ordering guarantees of #2 are provided by the REQ_FUA, which
> ensures the journal writes do not complete until they are on stable
> storage. Hence by the time the last journal IO in a checkpoint
> completes, we know that the entire checkpoint is on stable storage
> and we can unpin the dirty metadata and allow it to be written back.
> 
> This is the mechanism by which ordering was first implemented in XFS
> way back in 2002 by commit 95d97c36e5155075ba2eb22b17562cfcc53fcf96
> ("Add support for drive write cache flushing") in the xfs-archive
> tree.
> 
> A lot has changed since then, most notably we now use delayed
> logging to checkpoint the filesystem to the journal rather than
> write each individual transaction to the journal. Cache flushes on
> journal IO are necessary when individual transactions are wholly
> contained within a single iclog. However, CIL checkpoints are single
> transactions that typically span hundreds to thousands of individual
> journal writes, and so the requirements for device cache flushing
> have changed.
> 
> That is, the ordering rules I state above apply to ordering of
> atomic transactions recorded in the journal, not to the journal IO
> itself. Hence we need to ensure metadata is stable before we start
> writing a new transaction to the journal (guarantee #1), and we need
> to ensure the entire transaction is stable in the journal before we
> start metadata writeback (guarantee #2).
> 
> Hence we only need a REQ_PREFLUSH on the journal IO that starts a
> new journal transaction to provide #1, and it is not on any other
> journal IO done within the context of that journal transaction.
> 
> The CIL checkpoint already issues a cache flush before it starts
> writing to the log, so we no longer need the iclog IO to issue a
> REQ_REFLUSH for us. Hence if XLOG_START_TRANS is passed
> to xlog_write(), we no longer need to mark the first iclog in
> the log write with REQ_PREFLUSH for this case. As an added bonus,
> this ordering mechanism works for both internal and external logs,
> meaning we can remove the explicit data device cache flushes from
> the iclog write code when using external logs.
> 
> Given the new ordering semantics of commit records for the CIL, we
> need iclogs containing commit records to issue a REQ_PREFLUSH. We
> also require unmount records to do this. Hence for both
> XLOG_COMMIT_TRANS and XLOG_UNMOUNT_TRANS xlog_write() calls we need
> to mark the first iclog being written with REQ_PREFLUSH.
> 
> For both commit records and unmount records, we also want them
> immediately on stable storage, so we want to also mark the iclogs
> that contain these records to be marked REQ_FUA. That means if a
> record is split across multiple iclogs, they are all marked REQ_FUA
> and not just the last one so that when the transaction is completed
> all the parts of the record are on stable storage.
> 
> And for external logs, unmount records need a pre-write data device
> cache flush similar to the CIL checkpoint cache pre-flush as the
> internal iclog write code does not do this implicitly anymore.
> 
> As an optimisation, when the commit record lands in the same iclog
> as the journal transaction starts, we don't need to wait for
> anything and can simply use REQ_FUA to provide guarantee #2.  This
> means that for fsync() heavy workloads, the cache flush behaviour is
> completely unchanged and there is no degradation in performance as a
> result of optimise the multi-IO transaction case.
> 
> The most notable sign that there is less IO latency on my test
> machine (nvme SSDs) is that the "noiclogs" rate has dropped
> substantially. This metric indicates that the CIL push is blocking
> in xlog_get_iclog_space() waiting for iclog IO completion to occur.
> With 8 iclogs of 256kB, the rate is appoximately 1 noiclog event to
> every 4 iclog writes. IOWs, every 4th call to xlog_get_iclog_space()
> is blocking waiting for log IO. With the changes in this patch, this
> drops to 1 noiclog event for every 100 iclog writes. Hence it is
> clear that log IO is completing much faster than it was previously,
> but it is also clear that for large iclog sizes, this isn't the
> performance limiting factor on this hardware.
> 
> With smaller iclogs (32kB), however, there is a substantial
> difference. With the cache flush modifications, the journal is now
> running at over 4000 write IOPS, and the journal throughput is
> largely identical to the 256kB iclogs and the noiclog event rate
> stays low at about 1:50 iclog writes. The existing code tops out at
> about 2500 IOPS as the number of cache flushes dominate performance
> and latency. The noiclog event rate is about 1:4, and the
> performance variance is quite large as the journal throughput can
> fall to less than half the peak sustained rate when the cache flush
> rate prevents metadata writeback from keeping up and the log runs
> out of space and throttles reservations.
> 
> As a result:
> 
> 	logbsize	fsmark create rate	rm -rf
> before	32kb		152851+/-5.3e+04	5m28s
> patched	32kb		221533+/-1.1e+04	5m24s
> 
> before	256kb		220239+/-6.2e+03	4m58s
> patched	256kb		228286+/-9.2e+03	5m06s
> 
> The rm -rf times are included because I ran them, but the
> differences are largely noise. This workload is largely metadata
> read IO latency bound and the changes to the journal cache flushing
> doesn't really make any noticable difference to behaviour apart from
> a reduction in noiclog events from background CIL pushing.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Ok, I followed it through and it makes sense.  Thanks for the thorough 
explaination

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>   fs/xfs/xfs_log.c      | 66 +++++++++++++++----------------------------
>   fs/xfs/xfs_log.h      |  1 -
>   fs/xfs/xfs_log_cil.c  | 18 +++++++++---
>   fs/xfs/xfs_log_priv.h |  6 ++++
>   4 files changed, 43 insertions(+), 48 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 87870867d9fb..b6145e4cb7bc 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -513,7 +513,7 @@ __xlog_state_release_iclog(
>    * Flush iclog to disk if this is the last reference to the given iclog and the
>    * it is in the WANT_SYNC state.
>    */
> -static int
> +int
>   xlog_state_release_iclog(
>   	struct xlog		*log,
>   	struct xlog_in_core	*iclog)
> @@ -533,23 +533,6 @@ xlog_state_release_iclog(
>   	return 0;
>   }
>   
> -void
> -xfs_log_release_iclog(
> -	struct xlog_in_core	*iclog)
> -{
> -	struct xlog		*log = iclog->ic_log;
> -	bool			sync = false;
> -
> -	if (atomic_dec_and_lock(&iclog->ic_refcnt, &log->l_icloglock)) {
> -		if (iclog->ic_state != XLOG_STATE_IOERROR)
> -			sync = __xlog_state_release_iclog(log, iclog);
> -		spin_unlock(&log->l_icloglock);
> -	}
> -
> -	if (sync)
> -		xlog_sync(log, iclog);
> -}
> -
>   /*
>    * Mount a log filesystem
>    *
> @@ -837,6 +820,14 @@ xlog_write_unmount_record(
>   
>   	/* account for space used by record data */
>   	ticket->t_curr_res -= sizeof(ulf);
> +
> +	/*
> +	 * For external log devices, we need to flush the data device cache
> +	 * first to ensure all metadata writeback is on stable storage before we
> +	 * stamp the tail LSN into the unmount record.
> +	 */
> +	if (log->l_targ != log->l_mp->m_ddev_targp)
> +		blkdev_issue_flush(log->l_targ->bt_bdev);
>   	return xlog_write(log, &vec, ticket, NULL, NULL, XLOG_UNMOUNT_TRANS);
>   }
>   
> @@ -874,6 +865,11 @@ xlog_unmount_write(
>   	else
>   		ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC ||
>   		       iclog->ic_state == XLOG_STATE_IOERROR);
> +	/*
> +	 * Ensure the journal is fully flushed and on stable storage once the
> +	 * iclog containing the unmount record is written.
> +	 */
> +	iclog->ic_flags |= (XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA);
>   	error = xlog_state_release_iclog(log, iclog);
>   	xlog_wait_on_iclog(iclog);
>   
> @@ -1755,8 +1751,7 @@ xlog_write_iclog(
>   	struct xlog		*log,
>   	struct xlog_in_core	*iclog,
>   	uint64_t		bno,
> -	unsigned int		count,
> -	bool			need_flush)
> +	unsigned int		count)
>   {
>   	ASSERT(bno < log->l_logBBsize);
>   
> @@ -1794,10 +1789,12 @@ xlog_write_iclog(
>   	 * writeback throttle from throttling log writes behind background
>   	 * metadata writeback and causing priority inversions.
>   	 */
> -	iclog->ic_bio.bi_opf = REQ_OP_WRITE | REQ_META | REQ_SYNC |
> -				REQ_IDLE | REQ_FUA;
> -	if (need_flush)
> +	iclog->ic_bio.bi_opf = REQ_OP_WRITE | REQ_META | REQ_SYNC | REQ_IDLE;
> +	if (iclog->ic_flags & XLOG_ICL_NEED_FLUSH)
>   		iclog->ic_bio.bi_opf |= REQ_PREFLUSH;
> +	if (iclog->ic_flags & XLOG_ICL_NEED_FUA)
> +		iclog->ic_bio.bi_opf |= REQ_FUA;
> +	iclog->ic_flags &= ~(XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA);
>   
>   	if (xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, count)) {
>   		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
> @@ -1900,7 +1897,6 @@ xlog_sync(
>   	unsigned int		roundoff;       /* roundoff to BB or stripe */
>   	uint64_t		bno;
>   	unsigned int		size;
> -	bool			need_flush = true, split = false;
>   
>   	ASSERT(atomic_read(&iclog->ic_refcnt) == 0);
>   
> @@ -1925,10 +1921,8 @@ xlog_sync(
>   	bno = BLOCK_LSN(be64_to_cpu(iclog->ic_header.h_lsn));
>   
>   	/* Do we need to split this write into 2 parts? */
> -	if (bno + BTOBB(count) > log->l_logBBsize) {
> +	if (bno + BTOBB(count) > log->l_logBBsize)
>   		xlog_split_iclog(log, &iclog->ic_header, bno, count);
> -		split = true;
> -	}
>   
>   	/* calculcate the checksum */
>   	iclog->ic_header.h_crc = xlog_cksum(log, &iclog->ic_header,
> @@ -1949,22 +1943,8 @@ xlog_sync(
>   			 be64_to_cpu(iclog->ic_header.h_lsn));
>   	}
>   #endif
> -
> -	/*
> -	 * Flush the data device before flushing the log to make sure all meta
> -	 * data written back from the AIL actually made it to disk before
> -	 * stamping the new log tail LSN into the log buffer.  For an external
> -	 * log we need to issue the flush explicitly, and unfortunately
> -	 * synchronously here; for an internal log we can simply use the block
> -	 * layer state machine for preflushes.
> -	 */
> -	if (log->l_targ != log->l_mp->m_ddev_targp || split) {
> -		blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev);
> -		need_flush = false;
> -	}
> -
>   	xlog_verify_iclog(log, iclog, count);
> -	xlog_write_iclog(log, iclog, bno, count, need_flush);
> +	xlog_write_iclog(log, iclog, bno, count);
>   }
>   
>   /*
> @@ -2418,7 +2398,7 @@ xlog_write(
>   		ASSERT(log_offset <= iclog->ic_size - 1);
>   		ptr = iclog->ic_datap + log_offset;
>   
> -		/* start_lsn is the first lsn written to. That's all we need. */
> +		/* Start_lsn is the first lsn written to. */
>   		if (start_lsn && !*start_lsn)
>   			*start_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
>   
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index 044e02cb8921..99f9d6ed9598 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -117,7 +117,6 @@ void	xfs_log_mount_cancel(struct xfs_mount *);
>   xfs_lsn_t xlog_assign_tail_lsn(struct xfs_mount *mp);
>   xfs_lsn_t xlog_assign_tail_lsn_locked(struct xfs_mount *mp);
>   void	  xfs_log_space_wake(struct xfs_mount *mp);
> -void	  xfs_log_release_iclog(struct xlog_in_core *iclog);
>   int	  xfs_log_reserve(struct xfs_mount *mp,
>   			  int		   length,
>   			  int		   count,
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 172bb3551d6b..9d2fa8464289 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -890,15 +890,25 @@ xlog_cil_push_work(
>   
>   	/*
>   	 * If the checkpoint spans multiple iclogs, wait for all previous
> -	 * iclogs to complete before we submit the commit_iclog.
> +	 * iclogs to complete before we submit the commit_iclog. In this case,
> +	 * the commit_iclog write needs to issue a pre-flush so that the
> +	 * ordering is correctly preserved down to stable storage.
>   	 */
> +	spin_lock(&log->l_icloglock);
>   	if (ctx->start_lsn != commit_lsn) {
> -		spin_lock(&log->l_icloglock);
>   		xlog_wait_on_iclog(commit_iclog->ic_prev);
> +		spin_lock(&log->l_icloglock);
> +		commit_iclog->ic_flags |= XLOG_ICL_NEED_FLUSH;
>   	}
>   
> -	/* release the hounds! */
> -	xfs_log_release_iclog(commit_iclog);
> +	/*
> +	 * The commit iclog must be written to stable storage to guarantee
> +	 * journal IO vs metadata writeback IO is correctly ordered on stable
> +	 * storage.
> +	 */
> +	commit_iclog->ic_flags |= XLOG_ICL_NEED_FUA;
> +	xlog_state_release_iclog(log, commit_iclog);
> +	spin_unlock(&log->l_icloglock);
>   	return;
>   
>   out_skip:
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 56e1942c47df..2203ccecafb6 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -133,6 +133,9 @@ enum xlog_iclog_state {
>   
>   #define XLOG_COVER_OPS		5
>   
> +#define XLOG_ICL_NEED_FLUSH	(1 << 0)	/* iclog needs REQ_PREFLUSH */
> +#define XLOG_ICL_NEED_FUA	(1 << 1)	/* iclog needs REQ_FUA */
> +
>   /* Ticket reservation region accounting */
>   #define XLOG_TIC_LEN_MAX	15
>   
> @@ -201,6 +204,7 @@ typedef struct xlog_in_core {
>   	u32			ic_size;
>   	u32			ic_offset;
>   	enum xlog_iclog_state	ic_state;
> +	unsigned int		ic_flags;
>   	char			*ic_datap;	/* pointer to iclog data */
>   
>   	/* Callback structures need their own cacheline */
> @@ -486,6 +490,8 @@ int	xlog_commit_record(struct xlog *log, struct xlog_ticket *ticket,
>   void	xfs_log_ticket_ungrant(struct xlog *log, struct xlog_ticket *ticket);
>   void	xfs_log_ticket_regrant(struct xlog *log, struct xlog_ticket *ticket);
>   
> +int xlog_state_release_iclog(struct xlog *log, struct xlog_in_core *iclog);
> +
>   /*
>    * When we crack an atomic LSN, we sample it first so that the value will not
>    * change while we are cracking it into the component values. This means we
> 
