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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 479C9C4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 09:02:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29B3560F91
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 09:02:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbhG1JCD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 05:02:03 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:55528 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234963AbhG1JCC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Jul 2021 05:02:02 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16S8qrOw012328;
        Wed, 28 Jul 2021 09:02:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=iMeK10yGaGoF5zI/2hzGsB7rZWWm735xT+9d9yYXO3Y=;
 b=FNFES6bgF7Wzt8c+bkUwLpFzI1YRPje2VSZ9MgGj+Jd73lE0k0gkKgHzVk6uDmALd9V2
 i1yU4DA5sZjWP4PPI7S5k427Hi5oDd+t1V6e3sXwEqar3iHsHqJPR+xZx9gSRUyde02g
 8YogpaQNrg5gm+uRvI51sti6UVXz43VAOMnr+0qn5Rqz8H5H5IshFwaaNwriTWnCs4hL
 iDN7obFHRqLtIp2bJZWke/qJGrnZouIot9mcRZMAliVNEdN7d0W/cttBoai0+HXOC67+
 p5DoD+HtdZBu8ORyrSihQQPWOp5krwjlM8WN269vcBeRTC4eUxq5L9xUaVx1HxJvRZNq 4A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=iMeK10yGaGoF5zI/2hzGsB7rZWWm735xT+9d9yYXO3Y=;
 b=Jatoo+AmE9NkZEFNkOw3n+Tr310vSizWvymto1Tw5EI29Ix4eNsATv+LKfeDIiO7NMPi
 rRl40Jx/allq4lsGBGXu9H149U8kzZivuWBLskq06hML8zufqPlZjv5Opp/koIxnCDiV
 MniCmmEcH3G+FAQqhBwqRuStQqcSWH8YRclEyFUCtFTQB/QeBU64EPSsZpQn28EgzRYu
 pNnN4t+ZHYllGND21PZS5IQ71l72lJLEeuhNHJn3VhwhaJqf9GiIUps145iXHVlcMYMq
 rCgzvjp9C9OhTRXApW0Pk0cDkyrYZa9Fu7vjywlRaWDMfc09PmMhqafs6yCocx3pdQl/ Og== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a234n3u2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 09:01:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16S8xkik131183;
        Wed, 28 Jul 2021 09:01:59 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by aserp3030.oracle.com with ESMTP id 3a234c15hu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 09:01:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IJ0on46Be4mfkcF7lMyMChGNnbj5G2WmLuDvm8gLYE07bF13rire9DZFxwrNEGcFaGaKnsEduizCconORleF08Dy5x0Vv1pIE3vJoBqh0ndPhnMKPeDXxZ5rUS7VOTWJp58czdS0C3IzJ06Pf3eQ2x6tAlYaYjUmqb4am801wsy6gV6+lmFqzHD+SlzYKXJKPGlzicF205b/LFml45FfoVItTrHkDMEEAYh9kDYEGthcVCsZTZv7Kf6KL1OYFk5kVKrJ6Hc50QX2d2eqdEKQIB3YDsZzAALbePDJi8cIFtzdl1hzjT3aJ1fIeKBXdORK9F7gSgKjZYEjM69wNnge3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iMeK10yGaGoF5zI/2hzGsB7rZWWm735xT+9d9yYXO3Y=;
 b=mG47in6jfBhqA9e8HTDAasxTD5C91j7So/rtoWVBa6EbKlQ7RBYUavevuPWk0zANUsH3cUVozgpmqWJSscCmmPPTzJiJBy7gKbv6ttfVz1wzRuvelvJcJ9sqB9yAnn0/p0KKqz4ZlgvsP4qpZ414w2lOyyulcZBpZB/dwkbPnMaqGKqccH50scV+EeXe+Rk4BOXSC/vdArf9QJkhKnYNJg1f5rTBlqdtO+FkTMYPOxc+N9I1Q4q8VtgsW9QUHcEY9mcbWCn25Awukswfo94Geb8u37M8uPw1d/+2EICgy1OihZTTTjkYi9HJi42DKKqnrG6ZUAJqnwRleEbnm3PTLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iMeK10yGaGoF5zI/2hzGsB7rZWWm735xT+9d9yYXO3Y=;
 b=qclSKfohRUOzb2t0qUUUEAWLmE++5A8RrMjBQs0V/DYpvqEJdWUSRXM+XnOy+3eDT/nAGy74wyUTO1XwVoZIm0pNAe+9PiGqKvMpzHy3fiYW5oI0YBnB0ZpEgc3BDr1jRQAcOjsjclJVa6s1HUBAsD60HVFrUMtRkaQa0368dVk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2792.namprd10.prod.outlook.com (2603:10b6:a03:87::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Wed, 28 Jul
 2021 09:01:57 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%9]) with mapi id 15.20.4373.019; Wed, 28 Jul 2021
 09:01:57 +0000
Subject: Re: [PATCH v22 04/16] xfs: Return from xfs_attr_set_iter if there are
 no more rmtblks to process
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210727062053.11129-1-allison.henderson@oracle.com>
 <20210727062053.11129-5-allison.henderson@oracle.com>
 <20210727233022.GZ559212@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <6180e7d4-bc38-fe01-a031-8b4853cc356d@oracle.com>
Date:   Wed, 28 Jul 2021 02:01:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <20210727233022.GZ559212@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0029.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::42) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.166] (67.1.112.125) by BY5PR17CA0029.namprd17.prod.outlook.com (2603:10b6:a03:1b8::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend Transport; Wed, 28 Jul 2021 09:01:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a8ad86a-a8db-4b51-0e1f-08d951a65a41
X-MS-TrafficTypeDiagnostic: BYAPR10MB2792:
X-Microsoft-Antispam-PRVS: <BYAPR10MB279242228AD93B730B7EC8AA95EA9@BYAPR10MB2792.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2BH5IVmmqfpOHZ3e7GhhU5uh2YQdYCEu0L7hWvY4Z0cAD+jc+PMlVQvIygKuy+G1bG8J9hq87zYyyK+nSFxOG5wpIGzf16hTEiSIUlVEnuM6AVZL/9CNiowqkOFtr5XnKCo1jaKX+wm1QkU7mBNJy4K8jflvgHVwrgrpAfLM7gs3SL7Cb0+rCFGHhBpTUU+g1q9sPkdliA2Nt7+dHSA3XepoyEiyy8loHCiI4KUVwIvTOBjFuxp8WkaMVWzpwYT9xYLH0iunzuGnjdSwQjrPBjKVqpyyfezTN51JaYBU4yYOppfc4lR9Q4IElS8a4qJnwbV18w0ZwjkUfbUaN4c9MwkgoaFkWtb9AiyYKkdApmj+gAlwv6TQNudBPWoKL+L0+wgFJdTUwQ3Twrfg3CZFzxnQ1i+v9l18HgP5AzEXn52eEjGo4hY5R+vQdiy+QlZgEY7lHuWINyMZDqrg040PlN1nznUeIvTTFEBufIs9gJ5UoMb7g5nUjyTqQlxgvJYmu6ArWvIXTsM3jex1l4Uh9IWf9p9TH08FxGtjWti4qza9RA1foX1gzLvqolySmpUCdIus8jEAcdZ5/ZAxUVb5HkrtTJR7pH19HEnVCuucPKxyaOipNMX+qjV6obIjvw+wElyqoTbabOUMWutBSKnLETfU51EfWap3gVDB0ntyMWAg2HycKvGHFSv63h4sgzrk0muggQRtcC6SxdDNY1c2TsjBI0J5SslHXHcAAr0xJ5/Sy34boOe6Ko9tV6azFO56MDfTLNPzM8QwWR4ySgatCkJwziEu2b30VZfRZRTHFG4TDvkbWWQNdFLtUb7/U2z+3e3mt+L7IKwIVjJIDFAm4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(396003)(366004)(346002)(136003)(66946007)(36756003)(31686004)(66556008)(66476007)(16576012)(6486002)(316002)(44832011)(4326008)(6916009)(2616005)(956004)(8676002)(478600001)(8936002)(2906002)(5660300002)(26005)(83380400001)(31696002)(53546011)(186003)(86362001)(38350700002)(52116002)(38100700002)(29513003)(40753002)(133343001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cGI0aDYwblFWQ3NsOWNuZGVFOG54aThDb3d3dE9haFFPSm45Q2lJOVo1amxT?=
 =?utf-8?B?c016bW5pQUp5Ymk0Y3FJY3lsWVphc1RFTjNlV090MjFyR3N6M1p0MjhJaGJW?=
 =?utf-8?B?eVhYM0JnTlplWUd4NElnRVl4NnpPdW1kOXZvazdnZ2tmelFzRmFVQnRocUEx?=
 =?utf-8?B?bytpQVc2VWJlWVJ1cmRoTVpLTWlOYWtYUnZ5RGhMZ0pKUzRzN3hIb3cvMCs3?=
 =?utf-8?B?U0R3OHNJbXRQaEh4WlZMQTBYZ1lLd2JCTzBDTlNtUmJoMXZlalpORkUrRXBE?=
 =?utf-8?B?aHY0dm5pclV4empVU0J4OFZkRzRVSEhkK3h4SlgxQ1V3Nm5NVEtnT1pXUGJE?=
 =?utf-8?B?VjY4angvb0taOGZpd1QvRk9yRFVUcmxOTm13bEc5Unc0OHI1Zk45NksxdGpI?=
 =?utf-8?B?ajB4WXZOVlBSWks4SmoxVnI2S3ZXV01zS0pJeXlLVkxSNENvSC9VeFVEYURq?=
 =?utf-8?B?dnhRNXNBdmFScFV6SjIyd0kzekdyQjNobFhMV3JjZVg0UUFNUVhpNU5oOHBk?=
 =?utf-8?B?anh0M2djdGJoSEJIV2l5b2hqWjhPSzNCQXRja3pMVXFDQ1NtUWhncEkvdklo?=
 =?utf-8?B?YjJOcVYyZXdyV3UyWnFBNWE3U0l5Tlk4TURrelU3clZkSCtwbytZcXFhV1V4?=
 =?utf-8?B?dWJGYWlBSlhET0k0VVd4NGRheTRhVnZBRWc2SHVXc3FoN3p3Y3VCKzFiakZN?=
 =?utf-8?B?RnMrV1B4MUlQa3ZvdkJUKzJEVzB6Y0lUeURENzUvNFE3WmlMMzRxTHZiWFN2?=
 =?utf-8?B?QUh2QlN4eExlYTB5eEtwTkJjTWJPMUJML2lrWG5Xc3FhK01CcDlKaWk3ZndE?=
 =?utf-8?B?NWR0V3NiNzVpWllqVnJNT1hMbmVxZTYyVnlsWHNkbzRDcW14aWQ2Nk4yN0Y3?=
 =?utf-8?B?V3NOWWFiY3N2Rm5Oajg5ZXVmZUhFVFdHdGdnUkZPYmVTNyt3WTNkc1EzSXNq?=
 =?utf-8?B?dHpTQXVLcFhGa1RCVXB2RjVUR3ludVkwMVJpeU9yRGlTTXg5WURUTGJPNEF3?=
 =?utf-8?B?aDlVdmw3SVdoV3ZGRFdiMkc5aG1lZnR0TWdMR2t0cmM5S0dLTUVVOGozR2xU?=
 =?utf-8?B?SzRPeUNGQVpxYWtHVnBSampjUy81RTdseVNXTG5NRzhNcGVKZFVtaWZRT09Y?=
 =?utf-8?B?SFBWQ1hHSlNUNmxVNURVVHR5L1NyZ3VEaXFZdk9pbVJkcEI5TTB5dzM4SkV4?=
 =?utf-8?B?ZzdEdkt6K21DZ0d4ZGd0T1dSOVVSSURTeEpFMWQ0ODNhK1ZtQWxJamdESkVm?=
 =?utf-8?B?eEljSUVuVU1wa2NWc1FuUGh4WUUzRlF1NWR0TFlBNGczaTdlTG1DK0cxa3Ro?=
 =?utf-8?B?SW5SODVjYzRjWm1OdDV2Ym9WWGNZZ0EwYVNGU28rb2E0WW90OUpzVmhRNm10?=
 =?utf-8?B?T2FuOXN6bldXNVczMFl6SlZKTFFQSi90M25tbDlmYlpnNGk3U0ZsODBlZVJO?=
 =?utf-8?B?SUFJRWVEcEFNNnpvZ0ZRa1E2eUUrc2x4SkRPaHhWc0oxak93NWxyT0JHYWNz?=
 =?utf-8?B?WTAzVXAxd2VuR0JqUXNHeEp4VGQ5dXNxdEc5a0ZGOENYa0xoaFM0S3g2MjU4?=
 =?utf-8?B?UE0vcGM4TjVtNExQUFg1R0twQTVlQU9jK0N5Zlc5VjVGZjh3d1kyTmthZVFh?=
 =?utf-8?B?MXRpdThhNkVkZ0lrb3hXZHpJV2NZdTB6WGliRjFyS0VkVHZGNGJLZ3lBMGY2?=
 =?utf-8?B?VE52N2FUbkhVenQ3UTlhVjNpWjFnY3JrWUNXMVp6blZaRkpMbE85NG9jT1oy?=
 =?utf-8?Q?2jjyskmzRASdN7HO3brOeXfH5fvk16x6kas6ykp?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a8ad86a-a8db-4b51-0e1f-08d951a65a41
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 09:01:57.0946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xd1X988fUeAFv6FvC2AvOcj+qA65tpUaiGjk3vvNf1apUYkamFVy9bBZH3DHMO2qOdDbPQ54N2eHfr7U9V0j9/W+gNnki5/Xcy/KtfAtitw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2792
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10058 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107280051
X-Proofpoint-ORIG-GUID: YwlOPH3tm66mJCX_U9CWtupse6gIQgzo
X-Proofpoint-GUID: YwlOPH3tm66mJCX_U9CWtupse6gIQgzo
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/27/21 4:30 PM, Darrick J. Wong wrote:
> On Mon, Jul 26, 2021 at 11:20:41PM -0700, Allison Henderson wrote:
>> During an attr rename operation, blocks are saved for later removal
>> as rmtblkno2. The rmtblkno is used in the case of needing to alloc
>> more blocks if not enough were available.  However, in the case
>> that neither rmtblkno or rmtblkno2 are set, we can return as soon
>> as xfs_attr_node_addname completes, rather than rolling the transaction
>> with an -EAGAIN return.  This extra loop does not hurt anything right
>> now, but it will be a problem later when we get into log items because
>> we end up with an empty log transaction.  So, add a simple check to
>> cut out the unneeded iteration.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> 
> Looks good,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Great, thanks!

Allison

> 
> --D
> 
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index d9d7d51..5040fc1 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -409,6 +409,13 @@ xfs_attr_set_iter(
>>   			if (error)
>>   				return error;
>>   
>> +			/*
>> +			 * If addname was successful, and we dont need to alloc
>> +			 * or remove anymore blks, we're done.
>> +			 */
>> +			if (!args->rmtblkno && !args->rmtblkno2)
>> +				return 0;
>> +
>>   			dac->dela_state = XFS_DAS_FOUND_NBLK;
>>   		}
>>   		return -EAGAIN;
>> -- 
>> 2.7.4
>>
