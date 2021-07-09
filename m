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
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2433C07E99
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 19:56:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5F05600D3
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 19:56:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbhGIT7M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Jul 2021 15:59:12 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:28554 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229459AbhGIT7M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Jul 2021 15:59:12 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 169Jqj4L014012;
        Fri, 9 Jul 2021 19:56:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ufaHmlSkDCz9hHiiQYe3xTWJORS55pf7vdzkR4yKXJ4=;
 b=brNMPmybDE8Hnnpt55xtdNw/ytd/ocDjS7+C1yMEwyuHn7OD0hVzKElzTl9ly9eeCupe
 FxL29lAn1GAX3Fa9794Fm2/UtQNfVIsKpryWh2nYgQYIEbigeBZFkJ++XrSJqhJZzNU0
 sJgYmtCjd2Pu+8zGRHCRkq88o9T3IhWQLCo/htrOw0r5ymqjEEoVMKCqxJKX+KY902Qv
 QYk3L3OsKqiYKDe5kAGA/bbhkwCg1+tejqWKx96mF3NJuqm7wk8yClL93ON2J3GmUlET
 7WXBOUpxA0EMFEVeRbwZ101MOmCEHomlT0OgCTvGb0abuJLm6zqKM+9VVTue/5L05f6Q QQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39npbym5f0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Jul 2021 19:56:26 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 169JogcA099814;
        Fri, 9 Jul 2021 19:56:25 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2043.outbound.protection.outlook.com [104.47.51.43])
        by aserp3030.oracle.com with ESMTP id 39nbg9y02k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Jul 2021 19:56:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NF0xh2jpW1tRISuwRNqIR2RC+P7XPvrxbwmvpHq1xXCbywyhJf1qvFlvNqdohdRQx7CTcUVh8s58seZb/aKdgutE/oelWneixZGBjJL74USM4kQXZ+RfgPnn9NITzuJQN8FJBD+s+MVtexgEtqdKJjLsxzvSGFB5fgKv2sE+bfqJSOfcpIEmRyrs3qroIMnou1Rl5ukg3If/DunBTnkA7nXBnLfiXzIzBPO0R5QriYWNkvsjoS+/pv1V7WZFrszGB6hbr0ZUw3QwmP5ruACx/FAxN3LaacEkNSQh94e48MdSXneIP83rMX2Gs4gRdMQB7DOlQVcw56f6dkVY5GYEbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ufaHmlSkDCz9hHiiQYe3xTWJORS55pf7vdzkR4yKXJ4=;
 b=TF/fw5Bd6RgnMaB4lcmWdTTA9D5a+wlTWiCyg4Z5kXzJD38rnjbTFI4crYFEWu/dJGRBHoJVOvqQPAo9SQpeLjtbeBOqGMRJtY9JI4NvmNyZrfW7Imckae0LbMMlkXQfBBRz55tL1pwjolP7xiMHbODKn1SoQ+fRqVvOX4/IpQuKDBT3W7rnOKfn3zOBRPIFIzDtV9TOdV+v5hJhNDnH8L0AADfIIglmjZx+z3Sha4IXVOoD6n7gBdv5l2GWeA/EITMPrYnHUgdwNSLMqEkriz5xe7RzfCXXX7RisoCd27dIZfDkJdL6WC4tMP3Ifun3qyDOYQZsz/KR7AcSLse/rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ufaHmlSkDCz9hHiiQYe3xTWJORS55pf7vdzkR4yKXJ4=;
 b=duDM0/oJwQ5WllyugA4Qh0uTTz4lgYrNDS2rb+QQorGyYtSNeoEyTw4kxkunXI0seQbmq7UNQVZo9tq9Z9tgJ8mu/gkcyZei8GekN2sRkeD1xqdtQTlgpUN8FI8qvbHXkFX/qR+gDAviSlA9e/5knXHlXnDTgoZmqVpfHcP+PyM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB5471.namprd10.prod.outlook.com (2603:10b6:a03:302::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21; Fri, 9 Jul
 2021 19:56:23 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%9]) with mapi id 15.20.4308.023; Fri, 9 Jul 2021
 19:56:23 +0000
Subject: Re: [PATCH v21 13/13] xfs: Add helper function xfs_attr_leaf_addname
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210707222111.16339-1-allison.henderson@oracle.com>
 <20210707222111.16339-14-allison.henderson@oracle.com>
 <20210709041726.GR11588@locust>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <afd380b1-ddeb-ee1c-8833-9965923e4160@oracle.com>
Date:   Fri, 9 Jul 2021 12:56:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210709041726.GR11588@locust>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0182.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::7) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.167] (67.1.112.125) by SJ0PR13CA0182.namprd13.prod.outlook.com (2603:10b6:a03:2c3::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.11 via Frontend Transport; Fri, 9 Jul 2021 19:56:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 53b844b4-ee3d-488b-71ff-08d94313a0ca
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5471:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5471276A296294E24DF2E82395189@SJ0PR10MB5471.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 66hkvm1L9Tfu6nQT/Dlj6GeiKRnHAEYHlJ257P3kI7JxSuzuFVXVFaI5IadXwOgdJ2Ijs7YxcYwCWLgQUYHGwolLl/9VXKwL0OslKoVxndq5isT884dOpR3kChOIEJ9T4zoM1GkUw+PVQgtWKUwGhciPGvdsOVa9IUOXIySPWfp7IYIpNSdabsOoQg4r+TKukueu6uVhe4fummFFhpR+wJfzSD9n80vRvaSpPm3+0sGv1gBwi4qzAlQ8jvoyMVBlMBFQyj0wAb0YQCvwVrl5cllK0KjwW2t/g56chsnqAxNOFv/HzL5PPaAFl120hKt3iz6EYzVgmBJQXzn0oPmpELOi20lZixqicfWPcWVEANPq/bTtXMEYhQC35gz71jHwbe02lSOFqb1zKJQA4z9EoBO2MoCotbePhRHP7Z6dQK36Qxu2EPihJm1t2yng5mu3h4/qAABBjMN48qKxFlLyNEE6He7/boob+6E8atnCAM/IW1Oy0gOb0garR7duKGYM7xLvYQ4QyCYSjRtEq3FK7hAMeX+oXnSePUQfV5JWa9yfGtjYbHD24lZ9epHRK4b8vzCBeCrTY2OV3DNgsqMUW9pPvdRZOK16ZeKw0aJFYP+fxeW/CDl51S/KmmzeGcinJZ2qSuDTg0JHOTgxsKeJYWPZdS44ZFnX6o/zbGWbpYRtf/k8Gh59JdiIZOrlADjtLMO57tsr0/A1ho09L/vYHG3FS1mEZbdAG6cgQaduqtmHOGHeNXSGaatzKxchud8d
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(136003)(346002)(39850400004)(366004)(66946007)(66476007)(66556008)(31686004)(2906002)(86362001)(16576012)(186003)(6916009)(316002)(36756003)(52116002)(956004)(83380400001)(2616005)(53546011)(26005)(31696002)(38350700002)(8936002)(4326008)(478600001)(5660300002)(8676002)(6486002)(38100700002)(44832011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cm0veHprRnVwRzI4OVBycUtjWUs3TVBrT1l6N2k1S3ZTNHZrcHFGMytXclNo?=
 =?utf-8?B?L0RDZG5rVVh6VloxRDZJMXFyMHZraEhSREN4d25JTGxLTzNjU3ZRL2ZDUDNS?=
 =?utf-8?B?WUJaYUxlbUQ0Vll4Ly9UMHhMZ0crdC9tVldtcXFoSTh4YXFkdDJaY0JkakFa?=
 =?utf-8?B?M2gzRVM1RVhPZDFLV25GenR5clpObEtMZ0ZXazhzUHdVMWdLSU1iODRsaVdu?=
 =?utf-8?B?SkZ3b2F1dlZZL3EvYmNVcGdONXBVdkxYT20yWTBjRWpuVUkycTJkWXpVbCsw?=
 =?utf-8?B?WkNJSlROaHJUemlUaDB5RC9GMWJKRVkvWWdIcmJZSGgzS2NXbTZBLzI1NTNm?=
 =?utf-8?B?WCtpU2V0dS9vNXFtNlpqVzk2bUN0NEF4c0pIc2MxZDdwbEJYa1V5bkFValJz?=
 =?utf-8?B?SW1aODZ3L0VrdFFIUFhrbS92YVo1UjA3V081ckZMVXNQazFCZjR6VFBBd2po?=
 =?utf-8?B?Wkk1dVdZVG9LMk0wTkR2Vkc3eEFaYXdqc0RVU1E0TkM0dmxsRjRmaE5JU1pW?=
 =?utf-8?B?SHgyMEVvWVFZdys3VFZOVS9LNTFPZWxSY3QyTFJTWTNSbE14b3BPRE9JOXJ2?=
 =?utf-8?B?dVlZSXB1K3V1ay96eXprMUVISHB1bDJ4QkMxc3ZsWGVzRE1KVnZrY2FKMVpu?=
 =?utf-8?B?bHBRdGxoRGNuTDlpbXdxdWNHQitmUm1KUVQ1VlVuSTUzYkp2aHYwQlRWbGE5?=
 =?utf-8?B?T3RFZDhmTGoyMGx1WGExdk8xWlRZY1JyeHVsNk9HYjV5cmJTU2M0eEtPYmw4?=
 =?utf-8?B?cXloWE4xNERodjNuSEE2ZnhvSVpGMTNHc3VIZ042aFdncEVTL0dPMWNHc0gr?=
 =?utf-8?B?SVQ2Z0U3QmI0cnMzQzZPSlJFY2xld0lPb2VVQ0RGNFVhZ1lDL3EzUEo1V291?=
 =?utf-8?B?dWp4SE55R29wcE52S3pGL3lucDN3ZnZaRkptcEJnQzJtd1BCSlg0T2dydEJ2?=
 =?utf-8?B?Q1RHVjl0QlFoR09BWlkzbFZKb3hUS2JQRVFVK2Z6MUtHYzBxanE2bmp6MXM1?=
 =?utf-8?B?eGFWZnNBRXBEdi8zQXpjWnEyZmVsaDNiOEVXelEvelQ5cEJqZTgxcXNRenVW?=
 =?utf-8?B?NlY3VDYvdkMxRGJKRmRkelpJM1hXSkVoeGtTdXdLbThCTFM1M0ZkWmErejcy?=
 =?utf-8?B?czIzcXYyS1hwWjAxZjdPQXhsYWpHZGd3L0sreGZ3d2ZqU3FQbGdMYnc4cCtD?=
 =?utf-8?B?eDlWc2VCNHlWUVVDRGVSN0RsOUVtZGFaNzJhWHl0b1JJS2ZIK3pZNURsRGtS?=
 =?utf-8?B?aTJ4bFpheldZbGxXM3pObzlQVjdsR1pYOStHNE1JYXcrZFQwN2E4K2g5T0M1?=
 =?utf-8?B?R2IxRDZONWpiSkVlNVpMQ0VmSmw0NFFuRVBYZk5oTDRNY2lMWGhtdkFWZkxK?=
 =?utf-8?B?NWJRRXgxcld3L3hVYkdEUjlBRU9USWhvKy9ZMCtnOFNGZnIxanNmRllQUjl3?=
 =?utf-8?B?SlNGb21IaTVwNXA2a1RuKzRkWS9aK0tOaHh4czgzTm42Mm1yQ052SG42MlVZ?=
 =?utf-8?B?WTRmYTM2ZjM3SFdPVklDTTR1RkJkVEtlT21UekZaMGxRc0h4bEdLQmdHZ2Rq?=
 =?utf-8?B?WktJNmZscWFnQmpRVmVRWHJaMElocVhNWW1ZeUFJOXBiVjlWdkt5SXNwU1R3?=
 =?utf-8?B?ZkpPZDZJSmF1dFhuVGoxVjc1VS9ncVk0dVU3bDMwZC9xMnUrcFp1L0REM1BP?=
 =?utf-8?B?TG9DL3RxaDlxWFNKSEE2V1ZKQjFYTlJsRUxML2NjbGtGWlQ2ZDFONkYrUXQ2?=
 =?utf-8?Q?dfXV2B3XirXPDF811ZY4gbq73QsZQRbHLg9y4Ki?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53b844b4-ee3d-488b-71ff-08d94313a0ca
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2021 19:56:23.2370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2eZuUG7Cjt1XzlnDLDBtDBSpYp5qQ7rgpST0ROyZ8DliImbm7GEnADpAW8Wd5t5jPVhBlB/NrU5k3lqVh5Mk86Ur3gOyMqP/JsLsOrxN+vc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5471
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10040 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 suspectscore=0 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107090097
X-Proofpoint-GUID: 35y5efTBAiUorOvaaqU1Zg-WqeL6Jkly
X-Proofpoint-ORIG-GUID: 35y5efTBAiUorOvaaqU1Zg-WqeL6Jkly
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/8/21 9:17 PM, Darrick J. Wong wrote:
> On Wed, Jul 07, 2021 at 03:21:11PM -0700, Allison Henderson wrote:
>> This patch adds a helper function xfs_attr_leaf_addname.  While this
>> does help to break down xfs_attr_set_iter, it does also hoist out some
>> of the state management.  This patch has been moved to the end of the
>> clean up series for further discussion.
>>
>> Suggested-by: Darrick J. Wong <djwong@kernel.org>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 107 ++++++++++++++++++++++++++---------------------
>>   fs/xfs/xfs_trace.h       |   1 +
>>   2 files changed, 60 insertions(+), 48 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index cb7e689..80486b4 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -284,6 +284,64 @@ xfs_attr_sf_addname(
>>   	return -EAGAIN;
>>   }
>>   
>> +STATIC int
>> +xfs_attr_leaf_addname(
>> +	struct xfs_attr_item	*attr)
>> +{
>> +	struct xfs_da_args	*args = attr->xattri_da_args;
>> +	struct xfs_buf		*leaf_bp = attr->xattri_leaf_bp;
>> +	struct xfs_inode	*dp = args->dp;
>> +	int			error;
>> +
>> +	if (xfs_attr_is_leaf(dp)) {
>> +		error = xfs_attr_leaf_try_add(args, leaf_bp);
>> +		if (error == -ENOSPC) {
>> +			error = xfs_attr3_leaf_to_node(args);
>> +			if (error)
>> +				return error;
>> +
>> +			/*
>> +			 * Finish any deferred work items and roll the
>> +			 * transaction once more.  The goal here is to call
>> +			 * node_addname with the inode and transaction in the
>> +			 * same state (inode locked and joined, transaction
>> +			 * clean) no matter how we got to this step.
>> +			 *
>> +			 * At this point, we are still in XFS_DAS_UNINIT, but
>> +			 * when we come back, we'll be a node, so we'll fall
>> +			 * down into the node handling code below
>> +			 */
>> +			trace_xfs_attr_set_iter_return(
>> +				attr->xattri_dela_state, args->dp);
>> +			return -EAGAIN;
>> +		} else if (error) {
> 
> Silly nit: No need for else if, regular if works fine here.
> 
> Oh, hm, this is just a hoist patch, and we're not supposed to
> hoist-and-mutate.  But this is a small change, so fmeh rules.
> 
> With that tidied,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Alrighty, will do.  Thanks!
Allison

> 
> --D
> 
>> +			return error;
>> +		}
>> +
>> +		attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
>> +	} else {
>> +		error = xfs_attr_node_addname_find_attr(attr);
>> +		if (error)
>> +			return error;
>> +
>> +		error = xfs_attr_node_addname(attr);
>> +		if (error)
>> +			return error;
>> +
>> +		/*
>> +		 * If addname was successful, and we dont need to alloc or
>> +		 * remove anymore blks, we're done.
>> +		 */
>> +		if (!args->rmtblkno && !args->rmtblkno2)
>> +			return error;
>> +
>> +		attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
>> +	}
>> +
>> +	trace_xfs_attr_leaf_addname_return(attr->xattri_dela_state, args->dp);
>> +	return -EAGAIN;
>> +}
>> +
>>   /*
>>    * Set the attribute specified in @args.
>>    * This routine is meant to function as a delayed operation, and may return
>> @@ -319,55 +377,8 @@ xfs_attr_set_iter(
>>   			*leaf_bp = NULL;
>>   		}
>>   
>> -		if (xfs_attr_is_leaf(dp)) {
>> -			error = xfs_attr_leaf_try_add(args, *leaf_bp);
>> -			if (error == -ENOSPC) {
>> -				error = xfs_attr3_leaf_to_node(args);
>> -				if (error)
>> -					return error;
>> -
>> -				/*
>> -				 * Finish any deferred work items and roll the
>> -				 * transaction once more.  The goal here is to
>> -				 * call node_addname with the inode and
>> -				 * transaction in the same state (inode locked
>> -				 * and joined, transaction clean) no matter how
>> -				 * we got to this step.
>> -				 *
>> -				 * At this point, we are still in
>> -				 * XFS_DAS_UNINIT, but when we come back, we'll
>> -				 * be a node, so we'll fall down into the node
>> -				 * handling code below
>> -				 */
>> -				trace_xfs_attr_set_iter_return(
>> -					attr->xattri_dela_state, args->dp);
>> -				return -EAGAIN;
>> -			} else if (error) {
>> -				return error;
>> -			}
>> -
>> -			attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
>> -		} else {
>> -			error = xfs_attr_node_addname_find_attr(attr);
>> -			if (error)
>> -				return error;
>> +		return xfs_attr_leaf_addname(attr);
>>   
>> -			error = xfs_attr_node_addname(attr);
>> -			if (error)
>> -				return error;
>> -
>> -			/*
>> -			 * If addname was successful, and we dont need to alloc
>> -			 * or remove anymore blks, we're done.
>> -			 */
>> -			if (!args->rmtblkno && !args->rmtblkno2)
>> -				return error;
>> -
>> -			attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
>> -		}
>> -		trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
>> -					       args->dp);
>> -		return -EAGAIN;
>>   	case XFS_DAS_FOUND_LBLK:
>>   		/*
>>   		 * If there was an out-of-line value, allocate the blocks we
>> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
>> index f9840dd..cf8bd3a 100644
>> --- a/fs/xfs/xfs_trace.h
>> +++ b/fs/xfs/xfs_trace.h
>> @@ -4008,6 +4008,7 @@ DEFINE_EVENT(xfs_das_state_class, name, \
>>   	TP_ARGS(das, ip))
>>   DEFINE_DAS_STATE_EVENT(xfs_attr_sf_addname_return);
>>   DEFINE_DAS_STATE_EVENT(xfs_attr_set_iter_return);
>> +DEFINE_DAS_STATE_EVENT(xfs_attr_leaf_addname_return);
>>   DEFINE_DAS_STATE_EVENT(xfs_attr_node_addname_return);
>>   DEFINE_DAS_STATE_EVENT(xfs_attr_remove_iter_return);
>>   DEFINE_DAS_STATE_EVENT(xfs_attr_rmtval_remove_return);
>> -- 
>> 2.7.4
>>
