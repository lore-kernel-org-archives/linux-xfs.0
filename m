Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1653C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 06:19:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90E6B64EC4
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 06:19:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232270AbhBYGTj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 01:19:39 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:42430 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232263AbhBYGTf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 01:19:35 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11P6FP9F119780;
        Thu, 25 Feb 2021 06:18:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=9QjQzcGkVhDOC5Ohi8ah1hizIgXjy+yed9xccJfJcW0=;
 b=NICVbYd4vP/uIwRG1rDP8BO70/aURgKJdNiEagXH3jggJnyC8XzWGh7nUsRD7fqmc/88
 +d+m7HbpOoRlppj442+HCBIjRRG376GQl6x4Sda8kkLlLtm7i04ZtCQCJQAWgkY9eBE9
 ZzB7a6La/1NAi4MUolWEOgL5DgbezJX+1TGk8HPqVo84vPZLpTaD/UMrqN6mbZd0pT+M
 5b7UZRzmh+SjJGlaov81byjzrwsvN+ChbgC29mJrR9ykwmo7q5MyL6bCXDPsLVQjbj+W
 A7kN4V83y93gK9necZ4gKWVnTBKXmIsxdG3a4MQd/5+0p1xvhhcrn/V4QAQfwVj+1Hpp WQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 36tsur5bux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 06:18:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11P6AZxD159101;
        Thu, 25 Feb 2021 06:18:50 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by userp3030.oracle.com with ESMTP id 36ucc0t82r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 06:18:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OeGCupZzwzoly4biYFwU3jKzjnt9f0Ch5gdozI9U2IS4lMO7VdFI2Hpbg08IDUW5qwyhjSk5Y1sydDenThBp7HEh+oAXy9qatpTTmfCH0IHh9djp57ut6k0IFoXsf72viXXwfrTSQaXyhUEcE+g+hJswwNr9UvnKKbmZ0BTzQCjdP0HX+jGK/CzxopGq6YlwaObrr+K9Fi1Jjqp6yoxfQqUjqNWssRl+CwpuTQTNc8Nbb5G2q3TinsL2AJ92TnG0k7w3NiXRVwaXE2mCMn3VQiMN6zT53AjdlRkkgk7I/nxybZyF+FIgsacDkBer+t+o+NRRwuA3tMcuvFjvjtRpNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9QjQzcGkVhDOC5Ohi8ah1hizIgXjy+yed9xccJfJcW0=;
 b=dIJAB+umiFRiwo7tXP2VzU0+YH14cNJeWS/h3hidHafzlrIPf15MZci6pSZSsl1I5s9vLMf1kCxC/LXx5ICSMifxOtKq+vOV9rFEolZxLarcYTVJseZJSOBkSQs8crCmlUoxFmsKJUKC2IZtsBC6JOF41rrmNcyYQGWHpQMNcNmchXyR7Zhjaq4peKF8Kbhm6Z+gJafQhKxxEzvNybEj4r3sbR6O892f+4UjG+QmrKBLMQv4cvS4HxKTqEWvUCOSEXWW9I0JfTnwTgKNEwVPRm7QM/Hg6K4yq6qmc8tFSaYYlRPJLVnKvZx0LzMT2YejU6T3JlVIRPVUoSJjtHzsVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9QjQzcGkVhDOC5Ohi8ah1hizIgXjy+yed9xccJfJcW0=;
 b=lRKDJY8S6sqb7UPJLpPbVEiP23hOGA0sOnQaiFDO/W3MO9mqaZfg5ZwhdWEVHmAvV3QC05vJHTq0Z5Apkz4TTu/zbrbv2YzGcwYnSV9mva8mokTIRQiDl92hsVRa7U5gbr1Yh2BFmxDClE8I5XLKtajmPXt/+5A5eLOJ9T4lTEc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3780.namprd10.prod.outlook.com (2603:10b6:a03:1ff::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.33; Thu, 25 Feb
 2021 06:18:48 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3890.019; Thu, 25 Feb 2021
 06:18:48 +0000
Subject: Re: [PATCH v15 07/22] xfs: Add helper xfs_attr_node_addname_find_attr
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-8-allison.henderson@oracle.com>
 <20210224150452.GH981777@bfoster>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <aa1f3c2b-342c-6602-6d14-48f5b1b4f394@oracle.com>
Date:   Wed, 24 Feb 2021 23:18:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <20210224150452.GH981777@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BY5PR16CA0034.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::47) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by BY5PR16CA0034.namprd16.prod.outlook.com (2603:10b6:a03:1a0::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Thu, 25 Feb 2021 06:18:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f7d5aaab-7d05-4cd0-cb50-08d8d95536ad
X-MS-TrafficTypeDiagnostic: BY5PR10MB3780:
X-Microsoft-Antispam-PRVS: <BY5PR10MB37802D51353BB8D0EC06399A959E9@BY5PR10MB3780.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wam6upyeZN/sivMdOTrxXNIxugwbzqNh3fcTmZKReUZ+cziMNbylwH31N8eJoUljy1COirl0W2wqLwAi2WfGgatwSTmmDwZqq6mNAXzKLeNtwhs0hXlOEcAXL065ewj8aIl+aGpghcvKcbCZ9aNZgwsBuGE4r2bIKmOzPEkJUAet1GaCjOymxv5EbLlfihao78A1yzrxqlmMfz0t9gVOxC4dktF6cnnh4eQXg0yaONJodSyRHCkbxhGNzAxyfBUqgrQxpBPsok6+Jgr46B9MeVZM2duzoDli5YWtegqvDbzWIqTLD+PfVPcMYo8bIVY+CV2sF39eBbBKNiS5lwFPgQ2mEysF7XYiGA3DH0oAL8JxNtxbgPvsXyRc3LG0OE6nHtoK4o6v2kjgTfnOC4yhdcXz3bdHx9RLev0UMxqwiOkQMRgScckt2YMknlFrPkkEB0QDv3pGAR87A7xHkR7lpjtsgENp4G0dzBAUPHHe7j9VSkKZtEO/VxVxw4VepF7z/0CaBbwoUb1ZhrE2qoPMgI0hF9OKs/TSP49fWBUsj+x2YvE4uJlvYJLy3dsv2WSEb6RInogvOUUsdjfpozq1dA0peIT8xaorl6Ixr4qoosY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(346002)(396003)(39860400002)(136003)(6916009)(66476007)(8936002)(4326008)(478600001)(316002)(956004)(83380400001)(31686004)(16576012)(36756003)(8676002)(86362001)(26005)(2906002)(2616005)(31696002)(66556008)(186003)(52116002)(6486002)(5660300002)(53546011)(44832011)(66946007)(16526019)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UlRGVWpHQXhacWNDNWdwbXY4MWdCSmczQVVBZjZQS0VtQktjMmd6VFN0V1Rj?=
 =?utf-8?B?V0JMWU5oczk2aTNrYkcyOEV4cjZQOTExOHdIdUxUQ05Rd0lIak9TdkFFNjRL?=
 =?utf-8?B?OU5oZWt6TGVRNHZGWE13eE1Ydi95Wnd5L2YzaGpJQmJwWGpGb0NoODVyUGtZ?=
 =?utf-8?B?VFltNi9ENUJzUE5KLzlhTHJBVURaREszYWZnVHU2b0wxcHB3bTBZUGIzOFMw?=
 =?utf-8?B?bUw2Ti9kNkNCRXRhb3o1cnlkRkxFWmQrLzhBK0NxU3AyOHFtWHlLREhGVEZp?=
 =?utf-8?B?SVh0QUpMSDk4S3h3LzdWZFc2anFGTWd3UWlQRDA2TmdhM21IR2dJWGlzQW9E?=
 =?utf-8?B?c2wyS09WWGdydXFEUEN3aDErdG5YM2dwMXNKaWIxeU5kdVYvQmp0MlFHR05J?=
 =?utf-8?B?ektaWXM4cHd5QWx0REZvUnl3SUdvUWthYVZiWi9EdVgwSmwraVFtR01zWEw5?=
 =?utf-8?B?N0FzQ2dBQXk1VUpNUnRSWktnZ0JYTDZKc0xyeUt1QkF2WncvL1BsdTN1OEdu?=
 =?utf-8?B?UWF1aWZNY3VHTW5vT1g1cmdVcVNFb0N3LzBNdXZYdjhvUnJuaXpqYitKa3lJ?=
 =?utf-8?B?RGx1QmtYeG5UVjFGblpIMU1oNGxQU2swL0JCc2F4SzN1ZVAwMTVxVU5aN3Nw?=
 =?utf-8?B?eisvMWc4bVVzbWYxbUpHMDRUY1QxbFo5bTVIcjdMOXQ0Z01BOTR3SldJb0sv?=
 =?utf-8?B?c0MrNzNQY2I5Q0lWOS91K0N0ZUhCQmxheTA3eVhRVmxjeFJaSWtPMkVvM0lD?=
 =?utf-8?B?eHptbWM0SmhFQXRidVhxVGs4Q2Q2R21VYnBhdUJiL1VKOGRHVFNlcnpzdm1E?=
 =?utf-8?B?YmJOa2FHTVJsTVhyVFJOeUowY3k0QUZyc2FBRnR3cGdVd3Rkdk82U2tCaHpu?=
 =?utf-8?B?dHU3VnhCWENoOHc2TFNwK1diZER4ZTBTYTF6R1hhZDJrZGRtaUZlcUIwMEZU?=
 =?utf-8?B?emFHbFNJUWtkWkhMbmJkZ2RYZTRwTmVrRWhhNGNlc1E4UDFkOWtCSXpwaTVS?=
 =?utf-8?B?ZFQwT3dDTU5kdUNxRGhpMHkyV0ljMEhiSFJlVCtwUmtGSDNjWnQwa0dldW5M?=
 =?utf-8?B?eGxGRUVwVkJ5OGlrSGNrNGY1YXpxVnFENHAzQjVKdmZMTnJ0aWhRWGR4SHV6?=
 =?utf-8?B?bDhpWEExWGQ0bE5MOE0zRDBEZ3BGSkkzbEFDVENkcDR1TkxmYXREMFV6ZFho?=
 =?utf-8?B?TU5OcnBET2RtUzhOZ1M0UjlZYjM2eUNtL1pxaGdUYVBvSWxlYVpEa1dxaDJL?=
 =?utf-8?B?QnJUb09vV2NieVhrZTBIWjNsVE83RjdacTRpc2Y5SEowSVVhTnJRYSt6YU9V?=
 =?utf-8?B?d0V1a0RUOFphQUhHRUZEalc5d01wWldaUm1FTlc2QTFxT0Vnck9MTmVleTFF?=
 =?utf-8?B?Mm5ScDM0ckdraXAzZEN2N0JwV3ovYlhjUGZtRFljOWJ3dWZlVUhBOG16c0NM?=
 =?utf-8?B?cVRpQXVjaDV0SStnRjh2SGhMV1krS2NOSWUyU1BseG5kd1I1YWptejJtcnlx?=
 =?utf-8?B?SzJIWWFHRXBXaDdxWkhvSHM2cW1PMGQzZ3lDSXpmSHlrSmlMRkM1anAybkFC?=
 =?utf-8?B?ZWFSNUtPZHFqQzlVcVVidmkyb1kxMDJSTUx5Q1l5ZjFnMmFmOFFiRFJVVDE0?=
 =?utf-8?B?OG5PaUVsRnRpaUJ5M21OV3pBbGllVmdNZWNPZE5PdzZ2NUJENXdneVNydnY4?=
 =?utf-8?B?WFRVUWdPTzlzdmVRRFRmUnBBZUZHaU5zYkJNdzhrR2FKYk85Q2dZV2swcUhU?=
 =?utf-8?Q?Hegahcsv4hsqL2o1U62JHk6Ae3pitl5o1J05eoP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7d5aaab-7d05-4cd0-cb50-08d8d95536ad
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2021 06:18:48.6747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ferc0K6M0kDrEyXDjjRdjpZamrGW52gTmvimj/QI9Jb4DCCPxehbFkqaiy1SUgwU+CiAWnhG/fgmp7XIx34ZIb2smcfjesGXKZUERF69Ss8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3780
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9905 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102250054
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9905 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102250054
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/24/21 8:04 AM, Brian Foster wrote:
> On Thu, Feb 18, 2021 at 09:53:33AM -0700, Allison Henderson wrote:
>> This patch separates the first half of xfs_attr_node_addname into a
>> helper function xfs_attr_node_addname_find_attr.  It also replaces the
>> restart goto with with an EAGAIN return code driven by a loop in the
>> calling function.  This looks odd now, but will clean up nicly once we
>> introduce the state machine.  It will also enable hoisting the last
>> state out of xfs_attr_node_addname with out having to plumb in a "done"
>> parameter to know if we need to move to the next state or not.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 80 ++++++++++++++++++++++++++++++------------------
>>   1 file changed, 51 insertions(+), 29 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index bee8d3fb..4333b61 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
> ...
>> @@ -941,6 +931,38 @@ xfs_attr_node_addname(
>>   		args->rmtvaluelen = 0;
>>   	}
>>   
>> +	return 0;
>> +out:
> 
> Nit: can we call this label 'error' since it appears to be used when we
> want to return the current retval as an operational error?
Sure, will change out

> 
>> +	if (*state)
>> +		xfs_da_state_free(*state);
>> +	return retval;
>> +}
>> +
>> +/*
>> + * Add a name to a Btree-format attribute list.
>> + *
>> + * This will involve walking down the Btree, and may involve splitting
>> + * leaf nodes and even splitting intermediate nodes up to and including
>> + * the root node (a special case of an intermediate node).
>> + *
>> + * "Remote" attribute values confuse the issue and atomic rename operations
>> + * add a whole extra layer of confusion on top of that.
>> + */
>> +STATIC int
>> +xfs_attr_node_addname(
>> +	struct xfs_da_args	*args,
>> +	struct xfs_da_state	*state)
>> +{
>> +	struct xfs_da_state_blk	*blk;
>> +	struct xfs_inode	*dp;
>> +	int			retval, error;
>> +
>> +	trace_xfs_attr_node_addname(args);
> 
> This moves the tracepoint into the looping sequence whereas previously
> it would only execute once. I don't see a clean way to fix that with the
> breakdown as of this patch, and it's not a huge deal, but it would be
> nice to fix that before the end of the series if we haven't already.
> Otherwise LGTM:
I see, I could hoist it out, but it is short lived really.  Once we get 
into the state machine it wont much matter if it's hoisted or not.  In 
the greater scheme of things, I think it makes more sense for it to stay 
where it is.  A lot of these patches are not particularly elegant during 
this refactoring phase, and then things sort of come together once the 
state machine gets here.

> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
Thank you!
Allison

> 
>> +
>> +	dp = args->dp;
>> +	blk = &state->path.blk[state->path.active-1];
>> +	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>> +
>>   	retval = xfs_attr3_leaf_add(blk->bp, state->args);
>>   	if (retval == -ENOSPC) {
>>   		if (state->path.active == 1) {
>> @@ -966,7 +988,7 @@ xfs_attr_node_addname(
>>   			if (error)
>>   				goto out;
>>   
>> -			goto restart;
>> +			return -EAGAIN;
>>   		}
>>   
>>   		/*
>> -- 
>> 2.7.4
>>
> 
