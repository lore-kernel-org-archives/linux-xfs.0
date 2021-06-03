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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F6DBC47097
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 22:29:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 271FB61402
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 22:29:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbhFCWbR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Jun 2021 18:31:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52742 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbhFCWbQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jun 2021 18:31:16 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 153MKvgY035448;
        Thu, 3 Jun 2021 22:29:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=MdoeL+e2hM+9VvS4gd+Oj+exLiaEf4Yt2WzQ5JD1x4o=;
 b=E7QyWSfsE7iVwW01d3t0nfR9jO4rrrX3EK/NzsSsUX7e8Gle+FOk4ur3scO/v9OuBF61
 SVDa/s0aNjIw2beRk2wc0bB5FYYzv3U49hhcl2X5YqELDzk7T5WRHTRZpwJx25PvdAbZ
 xPD8/nqeni+5FyYXCbSQf8MlAqamqsaRMYBA3pCYpDYXFZ3Oce7whXB4zkLKbjKqrPgq
 k0MEeBni7MvmBpJfg7GbjJJakDXIQQYcjHepBIAG6x9GrDeVXvTb1am1U/xICyhQ28ZP
 0oaDgQTzENaaG/AI3rTGhRhWYcHvBvDmJHXX3nyTXButnQcjMjPuqAVVPI4ZaLQsGCmx Jg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 38ud1smj0g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jun 2021 22:29:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 153MK7MX031457;
        Thu, 3 Jun 2021 22:29:29 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2042.outbound.protection.outlook.com [104.47.57.42])
        by userp3030.oracle.com with ESMTP id 38uaqypcmt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jun 2021 22:29:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fCWxNbdjIJZxAP6yF8TBCfrPVvfYcaZInw330fw1tPbGmincA94NdVbXFauaF2GbBBFqRDzjtbiEUnVWwPuZ3rev1Sl/pTQEKk7wGDcMbkMSIoPDthihUg4GAKXO61dYefJQNI/Ss042A5gPkQOH38FhLalfZ1BpbU7kQqnhTA4lyxQd+58DdJtFwWTm+D3+gZytK1RZZNuuMESl+dolqicsV/B01DqlN+H3+gQxPXXlfSCyaNJudtsdWih+FB6dSBqa5w5OWJQ9kpoFYv4V9P8arpk0wDk7lBo3Pnyj9TaVHfo1IbtlDcviagJ9CuMWvrr63O1iWdKtKmxOZ0VJew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MdoeL+e2hM+9VvS4gd+Oj+exLiaEf4Yt2WzQ5JD1x4o=;
 b=irwNUZjXuKSSehw7PyO7y/TmlD01Y54mu2sXr20po84kua76WZ3kC9FVx0WtUFo9BBrE4cR1NnIQwErbcUmVIkFG4rxs5INAxyvRaeWCtUkcBr7irAOr2iZYpROM5xAIDmO+mSL1IBs3b6eO8+kIgu/Vz+cxVBRwHy0XIo7KvTr95k5c0XdtgD5WdQiGOk015XWXNDAqLW23fnd1izVZEXi4T9gXqZAIybNFlJtAinO/q7HoJlX/Uj58GGmkXwW2T4q1XZG2Z1qZxvT6NgH1gjRJBujdlJlFrEYkjCvTddmj/TRChLduz9lZnKIuukdxP3KqSArCncyA7fq4+Tnlww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MdoeL+e2hM+9VvS4gd+Oj+exLiaEf4Yt2WzQ5JD1x4o=;
 b=w4ev0MzfDrvDdMjI1JRe4ud69yFx7BY7Ou9wczjkriFwDBG8cvs6FkIywBWA16NLaQn/HrNccyOu3ZsbOTzyESlWcsHad/JjDuIfCtylxngLyq9skmO4coNFwBg4N04Wf7d6lFqBGMeMEElApbvA8CFMtfTBe5+/8hFLRH0LOko=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2712.namprd10.prod.outlook.com (2603:10b6:a02:b3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Thu, 3 Jun
 2021 22:29:27 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728%5]) with mapi id 15.20.4195.023; Thu, 3 Jun 2021
 22:29:27 +0000
Subject: Re: [PATCH 06/39] xfs: remove need_start_rec parameter from
 xlog_write()
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20210603052240.171998-1-david@fromorbit.com>
 <20210603052240.171998-7-david@fromorbit.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <a5b5d295-8cc4-8e36-a1f7-a8f5a4f94217@oracle.com>
Date:   Thu, 3 Jun 2021 15:29:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210603052240.171998-7-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: BY5PR17CA0062.namprd17.prod.outlook.com
 (2603:10b6:a03:167::39) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.210.54) by BY5PR17CA0062.namprd17.prod.outlook.com (2603:10b6:a03:167::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22 via Frontend Transport; Thu, 3 Jun 2021 22:29:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 26fee5c8-38d4-440c-81ca-08d926df0c31
X-MS-TrafficTypeDiagnostic: BYAPR10MB2712:
X-Microsoft-Antispam-PRVS: <BYAPR10MB271243845F442546AD8FCA92953C9@BYAPR10MB2712.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1060;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VEx4HjH6Ab6xHBcluW0cgWYZHwlpCDwncx2FQBvLkHrBMDCeL5u5BBagpkxBVUFYmDUztOhclBDhuKz+m3mK9ELQMONuH6eiyIrPrPoO/LLUsJ4GMyRVNlnbu6hCt4CNLD5C6m4h0t2i3gkP5SApyGZs8Rnt4jW20FOE0G2cKmZPZLuEK8Lb+E/JIioHq/jJZ5QRa4lEiDlD26fZ9ruTt/jmggnb5T0ojnq8NwLHywlPa25S33fMcWKjqhoGm3Rg0LrhxCdABfs5YRWGd0WOr47keDkc/s+XQP4rKkkpzemZMw/+gmPtUY6Cju1KPOldVED/XmujY51hKLdnG3TcljihpShouwOSwcwNJEiVTSegtNaV90x0WT+p9PiTLNbzCDGt/e34ZIBn4Sg9jzqpvxUe2bpsoRauRXkIfQbsa8hZDOEsnVidaTXlppku2TsIoapjQo/PwpOzZkuPlq6EXAOORwRiN8VZHTQSds7uO/SAFcoiAkvgDgn+QH0BREImzSq8KNGXcjnYtPfOakeGOc0Oo6Z48hJr9TjMiCk1burBCwHP2OQxJJon/jnkdEd+NCo7m5ctAKvueeL27Iwk3IYm3g8xi8MNODJ3PM7JML/luwCQmqOfizpAUxvO8HVRJSZVBNmOu3C+PVOorIlU9hyjQr55zU08iF2eX7D8A6VGDdY79VDRqnlI7DimnS107KUieEIU+9T7OAkszogwHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(396003)(366004)(136003)(346002)(16576012)(316002)(66946007)(36756003)(44832011)(8676002)(31686004)(83380400001)(66476007)(5660300002)(66556008)(186003)(26005)(16526019)(38100700002)(38350700002)(956004)(86362001)(31696002)(2616005)(8936002)(478600001)(2906002)(6486002)(52116002)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Q1poUCtqbjBIZVpyN3dndnh2Q1AySWNhZFdZNTJwang2ZUN4VHYzV1ZnNk9W?=
 =?utf-8?B?VlpPUkxXM2g2ZXpnRk9zSnJHc0VpY3Fib055cy9PNncwTjBRaWZIV3d5UWZG?=
 =?utf-8?B?S1owQmZQYzV6SEdBbkJkVkJ4R1VvUW90aURnQldUaWc1Mjh6UVQ2QW8wekNz?=
 =?utf-8?B?VlRob3owTzloUSswYURSSGVKUW9ValVUSmxLRHRobjQrNk1hRW95eUFCMWpW?=
 =?utf-8?B?RFNBOFIyQXdPdUg5OHpIdG9JQzVBa2ZsMCsrcGZYbXpDNWZCd0E1UnpFbjZn?=
 =?utf-8?B?NjhFdFYzYmNBRW8zK2tseDBPU01sZ0g5WUIwRlNSZjhyVHJvdmo1ZWI5akc2?=
 =?utf-8?B?TlZaUnZDa3RvUENDN2NLQmdoUEZIOG9GUUFtQXhKQTZZVENpMENDTlVNeEI1?=
 =?utf-8?B?L2ZIMFVNTjFjWXBKZXNZeitIbDJmS2hYbTUvMUw5aXpZbXppWFFPMTJCTzNT?=
 =?utf-8?B?L0FtQ3A0ekZZalFWVWtObWJhV1M2cjhObHF0ZHRWZlNuWjE5MnU5TU9VNmUr?=
 =?utf-8?B?RWFKbTZqNEc2L29ZRFRKWklpYnJBRytrQTExTGxtRDhFQjA1eXdWTHFVcCs2?=
 =?utf-8?B?N1g2VmdKOTBoYWNwSiszMzg1alg0cm1sNlN6MUFqdlR5UmlNRUZLRzBXa1ZT?=
 =?utf-8?B?VXZzTUd2ZVZaL3JGbzF3Z3oxbGVWcmRHbUpXK1ZDQmxqQXN2RXlaRVBDNmI5?=
 =?utf-8?B?OXZBdEo5ZktKUVdzN3ZhZEtOanliRWdYM04vM2t4b3plLzJ2RXFVTkpxK1lY?=
 =?utf-8?B?ZXNhYW9nSFRaL3JLMXF2N2pYVUhhcUExZHcvamZXODVpVDBsdzFGS1IzRW1a?=
 =?utf-8?B?RFU2QXVlNVRMUUNiSFMyMkVFMWNienVZQ1RDZXpJZk1zV0pNRzl6TitLNitS?=
 =?utf-8?B?NnE2YyswSk1XaEtSVXdrR015ZWhseUxBNGhqVmV2K0oxNUJvNmpTWk1oQk5l?=
 =?utf-8?B?T1pUbnVmMUUyV0VTOStCS1R6RHIyR3VWU3NRdU5TNUtmM3RDYnRQa0tzY21v?=
 =?utf-8?B?MVJtdHI0UWN1N1dhY0FSVjNza3JRVU9NU2RZd25nS0RaN05RdzJIYVF2TzJV?=
 =?utf-8?B?ZHBxd2toemlFVGNlSGtWQmU4TlJMY3FYeVFHNnJoNVpwVVllUnBpS2s3d1gw?=
 =?utf-8?B?a3N1WHd0Q2pWMEJMWHdZSC9pWFpiM0dvdmxPWGhBY0pTdWNGVEtpN0EzL3hn?=
 =?utf-8?B?VzFHRlZ4aVR6d3I1Z1cyR1llVkFmZEtMVTBVMTRqT1JWSDRBQmI3RzJMUWM1?=
 =?utf-8?B?R1o2bHdPZzZUL1B4NFN0TytiUHZCdVl0aW5XU1VTWmJGclIyWkRocWdIclIw?=
 =?utf-8?B?NUpMMUphNjI4S3A3NnVPWnNOeDNCZHVUb0ZkSVJpTWRvcTFpajR1b2VBblh2?=
 =?utf-8?B?YUlmYVNiV25VWmtrbnZGa1NVdHBYNFlkVm5JSkh5ZUlKcUMvRDBVWVFDa0tu?=
 =?utf-8?B?Y2FLK1ZmeGltdEZHVkgxZG5Da2JjNzBVcDVZeGN6cktDYmR0OFMxbFdEOUpa?=
 =?utf-8?B?MENJelBjdzFuN1UwSEdqYktXd09UU3RQOE1hdFUrTmw2N3BzTG9LS2pJZjY2?=
 =?utf-8?B?eW40VUkzREFWbjRlSTBkck1Zbm5pWk9mMlFlR3l0L056S3JON1RJTUwxZ1Y1?=
 =?utf-8?B?QkltUXhRZG5WVHF1cTRKRUkwVm5reDd1NTN5SFlaSThnZ1IrWnFXZi81VnZP?=
 =?utf-8?B?YkovUkVGelNLbGxlTitxVG5sZ3NZRXRzZmgvMTIrVkkrQ2hldkMwRm02RzJX?=
 =?utf-8?Q?AVQeKUBJDfjbYypp4hAe3ArH4ALpec/asLSt6w+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26fee5c8-38d4-440c-81ca-08d926df0c31
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 22:29:27.4685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yTl8erpqvv+bpI3XSnWstSNQ5AHOwf50S53b+1BCjJf2C8a0Ag+8mOftwsQ/G1r+ajkrTWtD0M3ypZyWhtQPPBC+wBUvL3gOiGHYgw6OhNs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2712
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10004 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106030148
X-Proofpoint-ORIG-GUID: DUHvpUBblHqXOJ7OVCWdfKdjaDQ-JmwY
X-Proofpoint-GUID: DUHvpUBblHqXOJ7OVCWdfKdjaDQ-JmwY
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10004 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 suspectscore=0 phishscore=0 lowpriorityscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 spamscore=0 impostorscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106030148
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 6/2/21 10:22 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The CIL push is the only call to xlog_write that sets this variable
> to true. The other callers don't need a start rec, and they tell
> xlog_write what to do by passing the type of ophdr they need written
> in the flags field. The need_start_rec parameter essentially tells
> xlog_write to to write an extra ophdr with a XLOG_START_TRANS type,
> so get rid of the variable to do this and pass XLOG_START_TRANS as
> the flag value into xlog_write() from the CIL push.
> 
> $ size fs/xfs/xfs_log.o*
>    text	   data	    bss	    dec	    hex	filename
>   27595	    560	      8	  28163	   6e03	fs/xfs/xfs_log.o.orig
>   27454	    560	      8	  28022	   6d76	fs/xfs/xfs_log.o.patched
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Ok, looks ok
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_log.c      | 44 +++++++++++++++++++++----------------------
>   fs/xfs/xfs_log_cil.c  |  3 ++-
>   fs/xfs/xfs_log_priv.h |  3 +--
>   3 files changed, 25 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 969eebbf3f64..87870867d9fb 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -820,9 +820,7 @@ xlog_wait_on_iclog(
>   static int
>   xlog_write_unmount_record(
>   	struct xlog		*log,
> -	struct xlog_ticket	*ticket,
> -	xfs_lsn_t		*lsn,
> -	uint			flags)
> +	struct xlog_ticket	*ticket)
>   {
>   	struct xfs_unmount_log_format ulf = {
>   		.magic = XLOG_UNMOUNT_TYPE,
> @@ -839,7 +837,7 @@ xlog_write_unmount_record(
>   
>   	/* account for space used by record data */
>   	ticket->t_curr_res -= sizeof(ulf);
> -	return xlog_write(log, &vec, ticket, lsn, NULL, flags, false);
> +	return xlog_write(log, &vec, ticket, NULL, NULL, XLOG_UNMOUNT_TRANS);
>   }
>   
>   /*
> @@ -853,15 +851,13 @@ xlog_unmount_write(
>   	struct xfs_mount	*mp = log->l_mp;
>   	struct xlog_in_core	*iclog;
>   	struct xlog_ticket	*tic = NULL;
> -	xfs_lsn_t		lsn;
> -	uint			flags = XLOG_UNMOUNT_TRANS;
>   	int			error;
>   
>   	error = xfs_log_reserve(mp, 600, 1, &tic, XFS_LOG, 0);
>   	if (error)
>   		goto out_err;
>   
> -	error = xlog_write_unmount_record(log, tic, &lsn, flags);
> +	error = xlog_write_unmount_record(log, tic);
>   	/*
>   	 * At this point, we're umounting anyway, so there's no point in
>   	 * transitioning log state to IOERROR. Just continue...
> @@ -1553,8 +1549,7 @@ xlog_commit_record(
>   	if (XLOG_FORCED_SHUTDOWN(log))
>   		return -EIO;
>   
> -	error = xlog_write(log, &vec, ticket, lsn, iclog, XLOG_COMMIT_TRANS,
> -			   false);
> +	error = xlog_write(log, &vec, ticket, lsn, iclog, XLOG_COMMIT_TRANS);
>   	if (error)
>   		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
>   	return error;
> @@ -2151,13 +2146,16 @@ static int
>   xlog_write_calc_vec_length(
>   	struct xlog_ticket	*ticket,
>   	struct xfs_log_vec	*log_vector,
> -	bool			need_start_rec)
> +	uint			optype)
>   {
>   	struct xfs_log_vec	*lv;
> -	int			headers = need_start_rec ? 1 : 0;
> +	int			headers = 0;
>   	int			len = 0;
>   	int			i;
>   
> +	if (optype & XLOG_START_TRANS)
> +		headers++;
> +
>   	for (lv = log_vector; lv; lv = lv->lv_next) {
>   		/* we don't write ordered log vectors */
>   		if (lv->lv_buf_len == XFS_LOG_VEC_ORDERED)
> @@ -2377,8 +2375,7 @@ xlog_write(
>   	struct xlog_ticket	*ticket,
>   	xfs_lsn_t		*start_lsn,
>   	struct xlog_in_core	**commit_iclog,
> -	uint			flags,
> -	bool			need_start_rec)
> +	uint			optype)
>   {
>   	struct xlog_in_core	*iclog = NULL;
>   	struct xfs_log_vec	*lv = log_vector;
> @@ -2406,8 +2403,9 @@ xlog_write(
>   		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
>   	}
>   
> -	len = xlog_write_calc_vec_length(ticket, log_vector, need_start_rec);
> -	*start_lsn = 0;
> +	len = xlog_write_calc_vec_length(ticket, log_vector, optype);
> +	if (start_lsn)
> +		*start_lsn = 0;
>   	while (lv && (!lv->lv_niovecs || index < lv->lv_niovecs)) {
>   		void		*ptr;
>   		int		log_offset;
> @@ -2421,7 +2419,7 @@ xlog_write(
>   		ptr = iclog->ic_datap + log_offset;
>   
>   		/* start_lsn is the first lsn written to. That's all we need. */
> -		if (!*start_lsn)
> +		if (start_lsn && !*start_lsn)
>   			*start_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
>   
>   		/*
> @@ -2434,6 +2432,7 @@ xlog_write(
>   			int			copy_len;
>   			int			copy_off;
>   			bool			ordered = false;
> +			bool			wrote_start_rec = false;
>   
>   			/* ordered log vectors have no regions to write */
>   			if (lv->lv_buf_len == XFS_LOG_VEC_ORDERED) {
> @@ -2451,13 +2450,15 @@ xlog_write(
>   			 * write a start record. Only do this for the first
>   			 * iclog we write to.
>   			 */
> -			if (need_start_rec) {
> +			if (optype & XLOG_START_TRANS) {
>   				xlog_write_start_rec(ptr, ticket);
>   				xlog_write_adv_cnt(&ptr, &len, &log_offset,
>   						sizeof(struct xlog_op_header));
> +				optype &= ~XLOG_START_TRANS;
> +				wrote_start_rec = true;
>   			}
>   
> -			ophdr = xlog_write_setup_ophdr(log, ptr, ticket, flags);
> +			ophdr = xlog_write_setup_ophdr(log, ptr, ticket, optype);
>   			if (!ophdr)
>   				return -EIO;
>   
> @@ -2488,14 +2489,13 @@ xlog_write(
>   			}
>   			copy_len += sizeof(struct xlog_op_header);
>   			record_cnt++;
> -			if (need_start_rec) {
> +			if (wrote_start_rec) {
>   				copy_len += sizeof(struct xlog_op_header);
>   				record_cnt++;
> -				need_start_rec = false;
>   			}
>   			data_cnt += contwr ? copy_len : 0;
>   
> -			error = xlog_write_copy_finish(log, iclog, flags,
> +			error = xlog_write_copy_finish(log, iclog, optype,
>   						       &record_cnt, &data_cnt,
>   						       &partial_copy,
>   						       &partial_copy_len,
> @@ -2539,7 +2539,7 @@ xlog_write(
>   	spin_lock(&log->l_icloglock);
>   	xlog_state_finish_copy(log, iclog, record_cnt, data_cnt);
>   	if (commit_iclog) {
> -		ASSERT(flags & XLOG_COMMIT_TRANS);
> +		ASSERT(optype & XLOG_COMMIT_TRANS);
>   		*commit_iclog = iclog;
>   	} else {
>   		error = xlog_state_release_iclog(log, iclog);
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 7b8b7ac85ea9..172bb3551d6b 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -823,7 +823,8 @@ xlog_cil_push_work(
>   	 */
>   	wait_for_completion(&bdev_flush);
>   
> -	error = xlog_write(log, &lvhdr, tic, &ctx->start_lsn, NULL, 0, true);
> +	error = xlog_write(log, &lvhdr, tic, &ctx->start_lsn, NULL,
> +				XLOG_START_TRANS);
>   	if (error)
>   		goto out_abort_free_ticket;
>   
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index ee7786b33da9..56e1942c47df 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -480,8 +480,7 @@ void	xlog_print_tic_res(struct xfs_mount *mp, struct xlog_ticket *ticket);
>   void	xlog_print_trans(struct xfs_trans *);
>   int	xlog_write(struct xlog *log, struct xfs_log_vec *log_vector,
>   		struct xlog_ticket *tic, xfs_lsn_t *start_lsn,
> -		struct xlog_in_core **commit_iclog, uint flags,
> -		bool need_start_rec);
> +		struct xlog_in_core **commit_iclog, uint optype);
>   int	xlog_commit_record(struct xlog *log, struct xlog_ticket *ticket,
>   		struct xlog_in_core **iclog, xfs_lsn_t *lsn);
>   void	xfs_log_ticket_ungrant(struct xlog *log, struct xlog_ticket *ticket);
> 
