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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA5DEC433ED
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Apr 2021 03:27:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A04476144A
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Apr 2021 03:27:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236539AbhDXD20 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Apr 2021 23:28:26 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:37230 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232619AbhDXD20 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Apr 2021 23:28:26 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13O3OBZW142600;
        Sat, 24 Apr 2021 03:27:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=kZJd/P/AcZ+b2J/AuLz0NNDGLRj4uJfh1D3qPtSpZgg=;
 b=OOo2AS4wL2ncHFWAnx4hmbPb9Ferlwrwy34MHZvmwhndVEMcZOliD27NLi3m2Ng4dNgR
 wnvCNVlqsWejLujocUukCRvYYkKL2XCDeC+qiomPuFzajNPf/16OzdkVlhbpxXQ7yvAc
 HWgLPDj7iEDDUhkmzeikzbXTji6yhSfmELTjGdhEM+A7VfyiUheVlH/P84C6XAb8Ab0G
 8+bJJV8wY0L54siaqSTDKErBNq2rjAzYvTnxM411iaV8ZpVZHLBHFmPd6oO/qKRuoCt6
 RD34G3LN8qpbi0wWfUUuCDaCQiNJdiumqGr4NGHJ8hetJx3eITj6b1ZRtoc92uV2kFbm 4A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 3848ubr325-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 03:27:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13O3QJg5082188;
        Sat, 24 Apr 2021 03:27:45 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by userp3030.oracle.com with ESMTP id 3848esc230-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 03:27:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BOL8ZQFR+ralEu9pXUOtJPegEzUMw+ny9Ry12dkTII6TAqCqOedpR+h0lFyNdTCw37lBkqjq96rFYEFxahPTp5c21XvopYVb2ErJRRBnW0oj7Smwkk+Zuk91ryTxopb2oOMrlTfeLoe0LNgMZ12q5pE4ZjbGwV8HTXO1Nnyxm2mBuYT4irOBBjobi8HR8qWY+uHPcqAeoW8mI2oFIGrajiTjvZ+nK2WodgMLGW/OAwnPiug8Yckxue+JinZMyfplfoJRtk+fSspNoYTFiObA2lPNeq0atpl3DSXME2uafA4oLsyvoy06IWySSykN6ZT2/qdJndXba4FttWSdt33y5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kZJd/P/AcZ+b2J/AuLz0NNDGLRj4uJfh1D3qPtSpZgg=;
 b=TeDB5PHdtt6iEbUMz1mLBH0r2FKFBWj3fEPo2TZep7NO2UuRKCol1SrES3eQqhcqquMHgdR1B9Hi6zVA8Ab1yaDgM+c0UADm/8pzSnQhS0yvRX83eEIniOwmDeCwDGQK0ZcLVxFswFwWJPzOuxAIXEx7YYEG8QkO183hzoAAATKYvdkVPbv8OPfxaxmTLu0eU/tBs0p3YPwitoFQ+G+R0lz04NVA8jY0jdLR/jpdh8KEKXm785VKtA4x99rO1F9nEw4zlf27vc0PfAFA9Q1tVEDmflds39CPxFl5dsJyXrXbe47eHlFUX80XSa6JLKM+f5kgOJx1xf1rkQag9nDDBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kZJd/P/AcZ+b2J/AuLz0NNDGLRj4uJfh1D3qPtSpZgg=;
 b=Qj/k7DkTNSbI5DDHb/lS2qX5ijf7S1RZ8B2tFgmqVn659Toe0gyD5U1deLhrTs38f24/PWNEQJMBOWlnHc1mOKKcUDIR8nqyMm85TVLoYzHozcJEk0Fa5KrOuk7oNabIO8Voa5HDNrDylosz45z6XwfTwdEAhWX8UHTfJmRHA+A=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB5454.namprd10.prod.outlook.com (2603:10b6:a03:304::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22; Sat, 24 Apr
 2021 03:27:42 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.024; Sat, 24 Apr 2021
 03:27:41 +0000
Subject: Re: [PATCH v17 11/11] xfs: Add delay ready attr set routines
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210416092045.2215-1-allison.henderson@oracle.com>
 <20210416092045.2215-12-allison.henderson@oracle.com>
 <YIMbIiSgkzY06rRf@bfoster>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <c44d541d-ceef-a6b0-9b92-6d660a131d4d@oracle.com>
Date:   Fri, 23 Apr 2021 20:27:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
In-Reply-To: <YIMbIiSgkzY06rRf@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: SJ0PR13CA0121.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::6) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.222.141) by SJ0PR13CA0121.namprd13.prod.outlook.com (2603:10b6:a03:2c6::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.15 via Frontend Transport; Sat, 24 Apr 2021 03:27:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 900dbd0a-29be-43a8-231d-08d906d0eb33
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5454:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5454AAFCE4FC7F6BBD725A1995449@SJ0PR10MB5454.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 54S/RM3wM5jvyzDNv+OgAAGkdNE5KGh4KxxMGxbrE8X57KE7pADcqCRoXKzEGSRQGSyRkplKkMYEX/BQIwkF8F0+o5/fWOEc5sBiVefhvEdsbc5NDEfomG+hoMjw8lqpprhWuiwwv4WhUrTFEWMUHWFRFETJ3ysH4XJLmivLPHtarix9WcZoKRK43Xw7AwPJ6m/cVgjHrnylH7Od2sVBGU2AFWdvNyWg5D2Aop6oFRhfuHLe8dxP4RLsiYHfbOjfDyGDYx/aiQF0ElkSdw0BpX6Dg0Hk8xyRBMuevcobxV8uB6ZQUYLq8u6k1VoY4WVzs0wF9tuPZyZscAar7nGmAISipSYnfp8USwhhQK0fPFEc3/Al0ItCASrjJlcH9LyPsmXBSTqOR7YQ9A3XzgmWpaqo92XtzW03lOBs/cBRuq9jXvMJNJx5QyS2EJV7xNTlWGeJiXWBAIH/IqOwkp8pO1NDc8oyNff4da2otyXHu90gYfM/10eJ0ffbZgwG3YeS3qANckOEtEkFmQVtTuE+wq6sUXMwTHK0DQaZamqBsT9k2Cmg9pLatkN2oZc0z6PM6odTrzXUOfpgJcre9aYc+La565am2Qzd4ybrdyn2UGqTyeWYn7XGTkO9CaXbQogcZFz5RBaAhFBvcXeNK6YnUzdlHAMI6T7QwBTp8ampthGQ1WwOR6qawSdBTdrPsAv9R463nnlUfdiWOfEtJvj50g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(136003)(366004)(346002)(39860400002)(6916009)(16576012)(83380400001)(316002)(36756003)(44832011)(52116002)(66556008)(38100700002)(4326008)(5660300002)(8676002)(26005)(478600001)(38350700002)(16526019)(31686004)(2906002)(86362001)(53546011)(956004)(66946007)(31696002)(6486002)(8936002)(2616005)(66476007)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZGJpUGFzbFJ6Mm1GUWVTTC9JWEUyVURzNVVhRlJ1aWowWWczcklzL2NBQmtY?=
 =?utf-8?B?WnBVdnZqZ2hlRkpBcDFDVHN2RkRxa0xrWWVkME1RblFrMHY1NmxtOGd4VFRi?=
 =?utf-8?B?WmxqbU5hUnB5RDlBQytaWjdZTmQxaFAwY0tRZkxPc0UwRjgraE5NUjVwc2Ri?=
 =?utf-8?B?TVBKMFZxMDZmUTNUME9Qa0pZTGY0aWFWdU5TbXFkVENWOXMwNzVneldSekVC?=
 =?utf-8?B?VTFiQThVQzVxc0RZRDNGSlppY0JiQUtzUmxCbGRES2I3WXdHL0pnQmFUM1VG?=
 =?utf-8?B?bU95MDV1Z0YxeFlvV2pKL04rY0VoczJYYzhYaE1DS3FWcStUbFRPU0pvOE9a?=
 =?utf-8?B?UzBtNkJpRlpzTmNzQ0dDbldicWNUdjZJSnNuamp6Q1ZoQngzT3IzTEtqb1Fi?=
 =?utf-8?B?aWlDUUN6RHJxcmxJeHNmeDJQOU1hK0RBUkVTbFZmMTJJU3lSRzAvcDg2YnRY?=
 =?utf-8?B?SzZJZlFsUUNabENQbUdPdlZJejFtR2gzZndEbzZzVDdpcUNicXdiVkZHL1pU?=
 =?utf-8?B?NUhWRG1jRDBPZkZxbnlMdVdvclhvSTFZdko1c3FrYVJuU2k2UFRhdVk0M2s1?=
 =?utf-8?B?aTRhU0h3RkN2WjJlQ2IrMEdkWlU3WTIraXhIeEtiR0JlakxUZlFoeEdIWitK?=
 =?utf-8?B?NVRWYzFhUnlPMTVZU0I3MjFWc3ZGa2lZZjZTM2o1ZWtlek51WXpkK3k5NDBx?=
 =?utf-8?B?NHd3OWpINXR3dERlK0FsZTltYWh1VXJCdUVZc2dpdmNwcHl2aFV1MldyTzhS?=
 =?utf-8?B?MmdXV0xkQmZQV0MxVkx1TmMwUWJtbUJFaCtxajJuOE9GRG1NT0Q4VHZDc0xv?=
 =?utf-8?B?cXo3bUFBSkUxWWRBcGkvVm1yWXVhdXkxcDJpeVdNZ1JMbWI3U29TMnBuTFBN?=
 =?utf-8?B?Y0RlcWdObjYwb01zN3VFNTBxOTlpYzNlQ0cwKzJSZllPR0hkUWkrdHdjQldn?=
 =?utf-8?B?S0w3QVRVUTNOb3pyQ3ZrRTdodUdQU3UwNUxVc1FVeWdQQXpKL2FoOW5UUnU0?=
 =?utf-8?B?VXBGMkZYNUsvQWFxaWRiNkt6RnVZSHZXZkdwRkFxZzV6UW93ZXpPWjR6SEJM?=
 =?utf-8?B?UituSjduWWhCU3dWRzZWT2VBQ0tEVjN4R3BDejRCOWVvMlZOVUFqUjJhTk8w?=
 =?utf-8?B?SXJndXl6d1BSYmRucTM2YTlrMzhhMXQxcUgvQ2tHY3hDSUFKeDVqNEVpY0Q1?=
 =?utf-8?B?ZktmK0NFYlZJRm9nWjB1NGZXTm1vSVBuNUxwaU9tOGJzdGhmOWdwTnowWEhr?=
 =?utf-8?B?aUh3ZzdtY3dyckJtUXphL042WXJpT0xHNmtQa2RnLzRJWkNpczhpSmdQdm8y?=
 =?utf-8?B?c1grWEVXYk1SeXY5TGRvQUNEVXlVZ3lLK0EwK0o4a0cvNWcxcTZxVExQaXVp?=
 =?utf-8?B?RlBnNjBrVUFuYmp1N0F3ZXp1a0NaaGtjVzRWMWw2RlVoWEpjd1lwTTBFaWRF?=
 =?utf-8?B?cG84Zk14OC81Si9IcEl6T212LzFyMnB1SURwOEJnTmE1M0lDUDV5Smk1eWVI?=
 =?utf-8?B?VTRQZS8wN2x2UTlVMGp4bTBNRnNHN21waWZSNVFpWnEyeWgxengwUVd3N1ky?=
 =?utf-8?B?TDVSekpNamRSejZqWmJ5Z1ZSTWw5b0k2c0lsYnpTY2tEL216ZU85V1hodXBq?=
 =?utf-8?B?aDBhdTRUM24wUTFRdlYrcURPOTJOOVE5aW43R1IxaGZTYXZGU1RwcElCbDdO?=
 =?utf-8?B?RkwvWlJlSnI1RE0zRm9BYlJPR1BrKzJXYlBwUGE1eVNEUlZHaEM1VkRvZnZU?=
 =?utf-8?Q?KzmfcambQR3iDKxriLE/rmMKsRo8GbDxJLkkchq?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 900dbd0a-29be-43a8-231d-08d906d0eb33
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2021 03:27:41.9264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lDIyWEdojSIe8bz/iJojOSWBZBG6dclmpbnHDVMwywTPl/cuVacxVclfwBVDKU/tPvqxcz3yfSraRPUO63quvAguOWAzpzMSX4uKyt3xVaI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5454
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9963 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104240021
X-Proofpoint-GUID: ZAuKTYPbB9p7LrPAPXCx1kksMJxPjynf
X-Proofpoint-ORIG-GUID: ZAuKTYPbB9p7LrPAPXCx1kksMJxPjynf
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9963 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 phishscore=0 spamscore=0 adultscore=0 clxscore=1015 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104240021
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/23/21 12:08 PM, Brian Foster wrote:
> On Fri, Apr 16, 2021 at 02:20:45AM -0700, Allison Henderson wrote:
>> This patch modifies the attr set routines to be delay ready. This means
>> they no longer roll or commit transactions, but instead return -EAGAIN
>> to have the calling routine roll and refresh the transaction.  In this
>> series, xfs_attr_set_args has become xfs_attr_set_iter, which uses a
>> state machine like switch to keep track of where it was when EAGAIN was
>> returned. See xfs_attr.h for a more detailed diagram of the states.
>>
>> Two new helper functions have been added: xfs_attr_rmtval_find_space and
>> xfs_attr_rmtval_set_blk.  They provide a subset of logic similar to
>> xfs_attr_rmtval_set, but they store the current block in the delay attr
>> context to allow the caller to roll the transaction between allocations.
>> This helps to simplify and consolidate code used by
>> xfs_attr_leaf_addname and xfs_attr_node_addname. xfs_attr_set_args has
>> now become a simple loop to refresh the transaction until the operation
>> is completed.  Lastly, xfs_attr_rmtval_remove is no longer used, and is
>> removed.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>> ---
> 
> This one looks good to me. My feedback is mostly around some code
> formatting and comments, so again I've just appended a diff for your
> review. With the various nits addressed:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
Alrighty, I gave it a look through, and it looks fine to me.  I'll test 
it and fold it into the next version.  Thanks again for all the reviews!

Allison

> 
> --- 8< ---
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 302e44efa985..3e242eeac3d7 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -337,15 +337,15 @@ xfs_attr_set_iter(
>   	/* State machine switch */
>   	switch (dac->dela_state) {
>   	case XFS_DAS_UNINIT:
> -		if (xfs_attr_is_shortform(dp))
> -			return xfs_attr_set_fmt(dac, leaf_bp);
> -
>   		/*
> -		 * After a shortform to leaf conversion, we need to hold the
> -		 * leaf and cycle out the transaction.  When we get back,
> -		 * we need to release the leaf to release the hold on the leaf
> -		 * buffer.
> +		 * If the fork is shortform, attempt to add the attr. If there
> +		 * is no space, this converts to leaf format and returns
> +		 * -EAGAIN with the leaf buffer held across the roll. The caller
> +		 * will deal with a transaction roll error, but otherwise
> +		 * release the hold once we return with a clean transaction.
>   		 */
> +		if (xfs_attr_is_shortform(dp))
> +			return xfs_attr_set_fmt(dac, leaf_bp);
>   		if (*leaf_bp != NULL) {
>   			xfs_trans_bhold_release(args->trans, *leaf_bp);
>   			*leaf_bp = NULL;
> @@ -354,10 +354,6 @@ xfs_attr_set_iter(
>   		if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>   			error = xfs_attr_leaf_try_add(args, *leaf_bp);
>   			if (error == -ENOSPC) {
> -				/*
> -				 * Promote the attribute list to the Btree
> -				 * format.
> -				 */
>   				error = xfs_attr3_leaf_to_node(args);
>   				if (error)
>   					return error;
> @@ -382,8 +378,6 @@ xfs_attr_set_iter(
>   			}
>   
>   			dac->dela_state = XFS_DAS_FOUND_LBLK;
> -			return -EAGAIN;
> -
>   		} else {
>   			error = xfs_attr_node_addname_find_attr(dac);
>   			if (error)
> @@ -394,8 +388,8 @@ xfs_attr_set_iter(
>   				return error;
>   
>   			dac->dela_state = XFS_DAS_FOUND_NBLK;
> -			return -EAGAIN;
>   		}
> +		return -EAGAIN;
>   	case XFS_DAS_FOUND_LBLK:
>   		/*
>   		 * If there was an out-of-line value, allocate the blocks we
> @@ -415,14 +409,13 @@ xfs_attr_set_iter(
>   		}
>   
>   		/*
> -		 * Roll through the "value", allocating blocks on disk as
> -		 * required.
> +		 * Repeat allocating remote blocks for the attr value until
> +		 * blkcnt drops to zero.
>   		 */
>   		if (dac->blkcnt > 0) {
>   			error = xfs_attr_rmtval_set_blk(dac);
>   			if (error)
>   				return error;
> -
>   			return -EAGAIN;
>   		}
>   
> @@ -430,14 +423,13 @@ xfs_attr_set_iter(
>   		if (error)
>   			return error;
>   
> +		/*
> +		 * If this is not a rename, clear the incomplete flag and we're
> +		 * done.
> +		 */
>   		if (!(args->op_flags & XFS_DA_OP_RENAME)) {
> -			/*
> -			 * Added a "remote" value, just clear the incomplete
> -			 *flag.
> -			 */
>   			if (args->rmtblkno > 0)
>   				error = xfs_attr3_leaf_clearflag(args);
> -
>   			return error;
>   		}
>   
> @@ -450,7 +442,6 @@ xfs_attr_set_iter(
>   		 * In a separate transaction, set the incomplete flag on the
>   		 * "old" attr and clear the incomplete flag on the "new" attr.
>   		 */
> -
>   		error = xfs_attr3_leaf_flipflags(args);
>   		if (error)
>   			return error;
> @@ -466,16 +457,14 @@ xfs_attr_set_iter(
>   		 * "remote" value (if it exists).
>   		 */
>   		xfs_attr_restore_rmt_blk(args);
> -
>   		error = xfs_attr_rmtval_invalidate(args);
>   		if (error)
>   			return error;
>   
> -		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
> -		dac->dela_state = XFS_DAS_RM_LBLK;
> -
>   		/* fallthrough */
>   	case XFS_DAS_RM_LBLK:
> +		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
> +		dac->dela_state = XFS_DAS_RM_LBLK;
>   		if (args->rmtblkno) {
>   			error = __xfs_attr_rmtval_remove(dac);
>   			if (error)
> @@ -488,8 +477,9 @@ xfs_attr_set_iter(
>   		/* fallthrough */
>   	case XFS_DAS_RD_LEAF:
>   		/*
> -		 * Read in the block containing the "old" attr, then remove the
> -		 * "old" attr from that block (neat, huh!)
> +		 * This is the last step for leaf format. Read the block with
> +		 * the old attr, remove the old attr, check for shortform
> +		 * conversion and return.
>   		 */
>   		error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
>   					   &bp);
> @@ -498,9 +488,6 @@ xfs_attr_set_iter(
>   
>   		xfs_attr3_leaf_remove(bp, args);
>   
> -		/*
> -		 * If the result is small enough, shrink it all into the inode.
> -		 */
>   		forkoff = xfs_attr_shortform_allfit(bp, dp);
>   		if (forkoff)
>   			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
> @@ -510,36 +497,29 @@ xfs_attr_set_iter(
>   
>   	case XFS_DAS_FOUND_NBLK:
>   		/*
> -		 * If there was an out-of-line value, allocate the blocks we
> -		 * identified for its storage and copy the value.  This is done
> -		 * after we create the attribute so that we don't overflow the
> -		 * maximum size of a transaction and/or hit a deadlock.
> +		 * Find space for remote blocks and fall into the allocation
> +		 * state.
>   		 */
>   		if (args->rmtblkno > 0) {
> -			/*
> -			 * Open coded xfs_attr_rmtval_set without trans
> -			 * handling
> -			 */
>   			error = xfs_attr_rmtval_find_space(dac);
>   			if (error)
>   				return error;
> -
> -			/*
> -			 * Roll through the "value", allocating blocks on disk
> -			 * as required.  Set the state in case of -EAGAIN return
> -			 * code
> -			 */
> -			dac->dela_state = XFS_DAS_ALLOC_NODE;
>   		}
>   
>   		/* fallthrough */
>   	case XFS_DAS_ALLOC_NODE:
> +		/*
> +		 * If there was an out-of-line value, allocate the blocks we
> +		 * identified for its storage and copy the value.  This is done
> +		 * after we create the attribute so that we don't overflow the
> +		 * maximum size of a transaction and/or hit a deadlock.
> +		 */
> +		dac->dela_state = XFS_DAS_ALLOC_NODE;
>   		if (args->rmtblkno > 0) {
>   			if (dac->blkcnt > 0) {
>   				error = xfs_attr_rmtval_set_blk(dac);
>   				if (error)
>   					return error;
> -
>   				return -EAGAIN;
>   			}
>   
> @@ -548,11 +528,11 @@ xfs_attr_set_iter(
>   				return error;
>   		}
>   
> +		/*
> +		 * If this was not a rename, clear the incomplete flag and we're
> +		 * done.
> +		 */
>   		if (!(args->op_flags & XFS_DA_OP_RENAME)) {
> -			/*
> -			 * Added a "remote" value, just clear the incomplete
> -			 * flag.
> -			 */
>   			if (args->rmtblkno > 0)
>   				error = xfs_attr3_leaf_clearflag(args);
>   			goto out;
> @@ -588,11 +568,10 @@ xfs_attr_set_iter(
>   		if (error)
>   			return error;
>   
> -		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
> -		dac->dela_state = XFS_DAS_RM_NBLK;
> -
>   		/* fallthrough */
>   	case XFS_DAS_RM_NBLK:
> +		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
> +		dac->dela_state = XFS_DAS_RM_NBLK;
>   		if (args->rmtblkno) {
>   			error = __xfs_attr_rmtval_remove(dac);
>   			if (error)
> @@ -604,7 +583,12 @@ xfs_attr_set_iter(
>   
>   		/* fallthrough */
>   	case XFS_DAS_CLR_FLAG:
> +		/*
> +		 * The last state for node format. Look up the old attr and
> +		 * remove it.
> +		 */
>   		error = xfs_attr_node_addname_clear_incomplete(dac);
> +		break;
>   	default:
>   		ASSERT(dac->dela_state != XFS_DAS_RM_SHRINK);
>   		break;
> 
