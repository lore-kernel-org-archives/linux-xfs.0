Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65010C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Nov 2021 22:24:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A9E260698
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Nov 2021 22:24:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234656AbhKLW1r (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 12 Nov 2021 17:27:47 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:26560 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234508AbhKLW1r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Nov 2021 17:27:47 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ACLnH5F029436;
        Fri, 12 Nov 2021 22:24:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=8sbR4gLJw9PlQfi4/rrqrqvNfDVQ8NKBJv+AefCdw6w=;
 b=wx55giz5OXWO6utcCEJWS8y5FSr4DKjnMreiJODtEgJYoJ3VlTeubT1Hx4n6w5lcNsyB
 Lbce2xtjs7ictTH1XpotaPIM1KJSIWxwAvfQXRRjxNjXUm0M9xFpJI+7uZM7WOzZ/oKZ
 L7WD5RaHbeDuQ7CJgVYQASsQbAMCKZJwhulZ38ZDuqWguXP8V8oGSJInn38eCZuqlgzg
 5G9ZUdukh+Nib+j2vwiMipIewR0EcZzamo7QObq1wNtgedObm7BTsS5PUj78lmvKKASp
 VCXRzghflx47i9iXBva1BKZPr+ANmVnu78BSKge89KxY+F4VchV1xdeNzDrEl7mhN4Rh hA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c9kn54822-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Nov 2021 22:24:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1ACMMGX9051187;
        Fri, 12 Nov 2021 22:24:54 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2040.outbound.protection.outlook.com [104.47.56.40])
        by userp3030.oracle.com with ESMTP id 3c842fu89a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Nov 2021 22:24:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WiRWlf0b2ljjfAOzPuqOsVN9Q7tXOE+HcO86Pb0ftMzk8lUJhM5MYLjkyUsSI4lfUAmZY+YEFrZEqodBBuwNxJFqeCEIobg0NUrwj/i97bulFzqnlXnhmGPvo6ZRKCFtGvdA4bxQzd1pLZJfVUxE/yFpISA/s8S3Lg77kQnkPzKTs/F75JqAO8EkJwkAphiCWdCEAPAAbpMu0cKQGaYgAsyrNNcs+VkC6uUA4hYBTQM0J90ktRrgGjwYinQigBd72gI497R4fReS2qAvVfQCkW3XBHqt10V4H6gqWICaKAoAWU5TEf1kNXTiv8/fZwun8oI00vwxguCojA+0iseOsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8sbR4gLJw9PlQfi4/rrqrqvNfDVQ8NKBJv+AefCdw6w=;
 b=ZPXeqT0MmupAdqWwCKeEJ0/bYd54C/u0w797dX/5oHQrLn0PBao28H/sRAYu1nbt8/MdjRRgzaHdp0Tw49cM0PCohrUOeOzoekC3m0kZOBZNVkvZ9WHKvpBTQEsmMlXjSCQD8bRLWRYOPWxhdqiRMl1s9bTbDaFtdnXNtOTeq/kc64QVHYUcGF6Cn4Bd7SzwW6i+ph3iwSqmxciA4N4USzoUf0q6bmzQY2NFwGkM8h05jGVVWiz4aU+WbzlzDUHa0uYAhvTs9QyeIbR1qP5tmb8oKaXmJCNGEguubZQB0u9PSZzMC+/jub4k9+hRLfQGVzSIdDyKUEiL4nJxp6M7PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8sbR4gLJw9PlQfi4/rrqrqvNfDVQ8NKBJv+AefCdw6w=;
 b=vPlGcYcMfc6TbNT1GyqdB16bOWsQpLAQ4x2DKbyOlMDwORq2fbGvY06HAXWbdkHpx5K3EUaM2I23N4WSox5b6AB+nM3Q1qf4lfmlIoQwIC7PAEY5jvUWROo1JK03gHePX9TY8UKHn/rIwHxv+i3GQ5+MEKAYGp0fnwWQxbKqLnI=
Authentication-Results: fromorbit.com; dkim=none (message not signed)
 header.d=none;fromorbit.com; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3860.namprd10.prod.outlook.com (2603:10b6:a03:1fe::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Fri, 12 Nov
 2021 22:24:52 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2%9]) with mapi id 15.20.4690.026; Fri, 12 Nov 2021
 22:24:52 +0000
Message-ID: <8a0f4aef-61d5-ccb6-63e9-73ea6dc6e884@oracle.com>
Date:   Fri, 12 Nov 2021 15:24:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [RFC PATCH 2/2] xfs: add leaf to node error tag
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>,
        Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20211111001716.77336-1-catherine.hoang@oracle.com>
 <20211111001716.77336-3-catherine.hoang@oracle.com>
 <20211111232439.GK449541@dread.disaster.area>
From:   Allison Henderson <allison.henderson@oracle.com>
In-Reply-To: <20211111232439.GK449541@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0107.namprd05.prod.outlook.com
 (2603:10b6:a03:334::22) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from [192.168.1.167] (67.1.243.157) by SJ0PR05CA0107.namprd05.prod.outlook.com (2603:10b6:a03:334::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.8 via Frontend Transport; Fri, 12 Nov 2021 22:24:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f926dc3e-7cd2-44c7-1997-08d9a62b3ef6
X-MS-TrafficTypeDiagnostic: BY5PR10MB3860:
X-Microsoft-Antispam-PRVS: <BY5PR10MB38608D2873AD96D019141F3595959@BY5PR10MB3860.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aBEMjdiRYzyIBBuZqbby4GbB8XCHrhg10fjw5wN4ZmPSCVbqObBL7SOjtm4AqZLLiAGIopyGqdmFz1qvpY+dT/QYCygb1h3RtT5MWys4g3xNEWHTtrxVcM1HTjhB0dupS2nYNvDDTpeX/Q6c/xSu9UdSfeB3GvJKpJrpbsZ/UACBBb3vRgRWr7h8eYx6BZGM2V0yjFN4EYf6PHhqhBnt8B83fRynWceZFV3J1bsKM3xXkaLOKnThmruW7nyMtHV6/OemX79KJW7f0izZh/hVnblXppn3gU26DcnKfZrbTAxD+8YJGK74ZaLCU/Ryx2yp7RLJhYSE7+jufd92yZUzGjWOO7+1bRDDDfzuG4titqepwDo5Z4Iitxecbur1MS0ZpmdRTjxMXWybZDB6tF4GOjHxILZeWUMgrUdDM9fvUdM8AccXqxCer4g3pLB5shUwH4eyiwMvXXnIhtodmL0LDtHSoRV0ouObn7++Lv9mOPoqqSc/N5HapMQDYCYQ3rcclg9dD9WMuZb+8xQiZJ5l59G8vN0meuASxdZ7kvQjB52LJX5kxzJFQJzj0JJmhM6GNdIrXqPZQF5l2zVOt5OJG3eEMbnIR6hcVqwRl+ohEePdBU9QvCuyPxhN6zYcyJPTTCwFGPsVPbwKRtGTwg2VjGwR4p8ibrQIcCc7g4Yo7I6eRdQd2LYdJDsuzdsnVR8X0J3vuBl/OZTagKtyPaioliTdYsPu7B/6XYn7iuO7FamQ37HGlinJ+MZDwRg2Be2aI49iKO8GAx7Q137GR3N66w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(52116002)(66946007)(6636002)(38350700002)(66476007)(38100700002)(8936002)(36756003)(86362001)(31686004)(6486002)(31696002)(186003)(8676002)(66556008)(53546011)(26005)(2616005)(956004)(4326008)(2906002)(44832011)(83380400001)(316002)(5660300002)(16576012)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MTNGaG1nR0ZNU3VpTXlqcThqVDRpTnZmSTcwSEplRjVrWWhJclU3MkhWcTlo?=
 =?utf-8?B?TmJmQ3FGTTZVekJzQ29rYVkwR1VOeEhFTWpJaUltN2pMN1JtcTFxdFN2R08v?=
 =?utf-8?B?QmxwUDY3RDIrVmtVTWJLdFRrTTFRVmlrampHalIwOFY0cWpmWitWUUFoQTlD?=
 =?utf-8?B?a04xR2FFNjJKbWQxNUFudGZyQkZtaUxDUVN5bStTR3VaOWFPaXFveEhidDRJ?=
 =?utf-8?B?eU40ME9Dc0JaV2EydlEwVkQ4STBCeDV4Z012eTF0cTlVaUViNHZBUjhEcGFu?=
 =?utf-8?B?NGg0bnk1aHY5ZWdyMjBUMnRMcGtQMk81YjQxRktDUi82V2xNajkrOGNJbjBT?=
 =?utf-8?B?TVBURFNTWmlHRGFsbDdRUG5GK29vajFtVmRPL1dBdVB5cTgzNDZoQTV5Ujc4?=
 =?utf-8?B?YzhBTmFid3Zhb2QwUmtzdDk1SHppcnE5TUxEZDNYZS9EL0kycmt4dXdhdDNz?=
 =?utf-8?B?YitXbS85NHNadlJnNXNYbERIWXFqek44LzFMLzgrUkY4eTJZVmU5NmJKQjds?=
 =?utf-8?B?S0NsclIrRnRWU1kyWTIvclFmenhGcWNDSm1zaFg0YS9sSjlJRDdsY0FVSEsw?=
 =?utf-8?B?c1RXeGt6VElVU0RGSStBOFBmUEp2dGc0V2lKWEk3Tk5adXQ0V0NoNitmTEhV?=
 =?utf-8?B?Y2w3WmtSaEFLdG5CMTBYd3N0TVhIcThibXV2TmtqVVREeWpBQVVmeHNxSTNU?=
 =?utf-8?B?dzlSMWY0MHVFYnFWQW1NOS81L1pVWkZ2YlZmclRmVWFLOGxHZHhYVmlzOEV2?=
 =?utf-8?B?aS80bTZxOGQ1RGVVOEsrK0RobmJUR1h4NTJPOXZHOW8zRG5Jc0Mxd2NCeFJQ?=
 =?utf-8?B?UGZMTkExYnFIcWtvZGN5NVR6WVIrRWcveGNyMzBYcEt1WTFGVzhuOEVHMlNM?=
 =?utf-8?B?Zk5rTkVjbW1jZFpibUFHL2w1WkVQR1F1NkpzWWM4bTZ1cmtnS2pja0s0SHBN?=
 =?utf-8?B?eVVoRlJyb2FJYUJ3WG1Zc1RObkg3UFFOVitRQi8yWW5INWFKd2l0QjBVNlhH?=
 =?utf-8?B?TTlPVnREa3dXNHBreEVZcWhDMHJDaG5WcG0rejM1a2FiM0Z1VDVxdEM2c05u?=
 =?utf-8?B?eVR3NVluclJJNGFESGJZR1VYWGluL0o1Q1FRa3VjaEM3cTBpcld3WnRaVFhk?=
 =?utf-8?B?andkT3JKZDVISklRbXowSkRnUzV2UTBuL2Q2WG1Ib1h6NlErVml2MERtUHVH?=
 =?utf-8?B?QUhDRTdjaWV2MmV3aEpBL2xXUzJENlFoanZEYzNJK1VLbVBXMFZ1WU11YU53?=
 =?utf-8?B?cWJCZHlYK1Vud0p0SEM3Y09FZ1ZsSDloMkRhOFdFaWtFTUhta1BsM3dZUDJ3?=
 =?utf-8?B?VEUraDlsTDQyajZNcVZ6cGhZUUJSMlVhUGoyWGJwVytSZTNSVHByM2NEQkFv?=
 =?utf-8?B?ZXBwaVlGTnBCcmhUMmpKRjN0bndFT0lsdGVjWGVydHc4NEtsT0tZQ0hDRG42?=
 =?utf-8?B?NUJFSUZnWjhkSHVaOUNjeVExcm9KcTJLeVhJZVFLam1jU2Zjd2pVVHUxMkVX?=
 =?utf-8?B?N3hqMzNaZEFmODB2ZFhhYmRmQjlpbFpzYzJRM3ZwK0tyYXE4Vnhlc3hkcVJu?=
 =?utf-8?B?N1E0cDFpV2ZHbkpJRGpOdUlFVGoyOFg2S2paNVJNNXJUR2JCaDlVbnlnUUZy?=
 =?utf-8?B?dGpTSStmWWE2YUoxY2hrcTdJdzU3bEVMUEdsZTJYeGlDelptV0VLOUIzVEQ1?=
 =?utf-8?B?RU90SkJtcjUxckx2ekpwZFhTMmhTSlloSWZqeUFTQ211SnhhNXp0cGpQVHpa?=
 =?utf-8?B?a05RTkVGY0hja2ExNE9KM3NsQnFHU1QxNDNPeE5qYk92ZE1HYys1NmtIWURh?=
 =?utf-8?B?Wi9LYmdpeVVFVXAxWDdIWVlIWVl5QjNTNEFaRUJzcVc4czBmNmhPZXB0dEQz?=
 =?utf-8?B?TU4rMFBJYWE4YzQzL2RPWFN5S2M3aW5HQmk4dEVPWFF3RWJvMWxLckZSbWUz?=
 =?utf-8?B?NzZYNGZ1UTJ4NmJHWXU4RHZiNmliUjJzMTBGL2lwTVhSSUUzWjE3Slkwbllt?=
 =?utf-8?B?blRBQmFxclZvMEx6YStwTDV5SmdmRUJvT3JHeDQ3eVNWU2xuQ2ljT3dpNWdP?=
 =?utf-8?B?dkZqVlhudFUwb0dkNktBL0tZNElaSnMwNCtSdVA2NEttUTROUTArVnFIRXpH?=
 =?utf-8?B?cHRkU2NvQzh6SG5paHJ0MitRRzBzNGMxa0hOcW8yVUZySUY2YzcvK2dBN3lK?=
 =?utf-8?B?eVJnYVZFdnpWSlNYQTB1YXdZU1REZlpVMTdZR0ZiQzgrbGhjRmxKbkJ1aDhh?=
 =?utf-8?B?dHNOdC9OZE5wS1hBaWpDZENCcTBnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f926dc3e-7cd2-44c7-1997-08d9a62b3ef6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2021 22:24:52.1090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PNtuXC9fd31aNlZ8UXS2oEJ1rTwpktXBeeGq8AQfuHQbjK3fZhrKw163OryexLLWvsQGLGeSsMzP7BLjd5VXk9vwYauyMchSG2YFGe4k/Ik=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3860
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10166 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111120113
X-Proofpoint-ORIG-GUID: Z6nYVYJhVdA7P3dBGOyiRZQ0CdCT4mo6
X-Proofpoint-GUID: Z6nYVYJhVdA7P3dBGOyiRZQ0CdCT4mo6
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 11/11/21 4:24 PM, Dave Chinner wrote:
> On Thu, Nov 11, 2021 at 12:17:16AM +0000, Catherine Hoang wrote:
>> Add an error tag on xfs_attr3_leaf_to_node to test log attribute
>> recovery and replay.
>>
>> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr_leaf.c | 6 ++++++
>>   fs/xfs/libxfs/xfs_errortag.h  | 4 +++-
>>   fs/xfs/xfs_error.c            | 3 +++
>>   3 files changed, 12 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
>> index 74b76b09509f..fdeb09de74ca 100644
>> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
>> @@ -28,6 +28,7 @@
>>   #include "xfs_dir2.h"
>>   #include "xfs_log.h"
>>   #include "xfs_ag.h"
>> +#include "xfs_errortag.h"
>>   
>>   
>>   /*
>> @@ -1189,6 +1190,11 @@ xfs_attr3_leaf_to_node(
>>   
>>   	trace_xfs_attr_leaf_to_node(args);
>>   
>> +	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_LEAF_TO_NODE)) {
>> +		error = -EIO;
>> +		goto out;
>> +	}
>> +
>>   	error = xfs_da_grow_inode(args, &blkno);
>>   	if (error)
>>   		goto out;
>> diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
>> index 31aeeb94dd5b..cc1650b58723 100644
>> --- a/fs/xfs/libxfs/xfs_errortag.h
>> +++ b/fs/xfs/libxfs/xfs_errortag.h
>> @@ -61,7 +61,8 @@
>>   #define XFS_ERRTAG_AG_RESV_FAIL				38
>>   #define c					39
>>   #define XFS_ERRTAG_LEAF_SPLIT				40
>> -#define XFS_ERRTAG_MAX					41
>> +#define XFS_ERRTAG_LEAF_TO_NODE				41
>> +#define XFS_ERRTAG_MAX					42
> 
> Same again about naming. THis is an attribute fork injection point,
> not a generic "leaf-to-node" error injection point.
> 
> Whihc makes me wonder: this is testing just the initial leaf split
> shape change. There are other shape changes - inline -> leaf, leaf
> -> multi-level tree (xfs_da3_split()) and multi-level -> single
> level leaf, leaf -> inline - for the attr tree, and there are even
> more shape changes for the directory tree (inline, leaf, leafN,
> node)
> 
> As a general infrastructure question, are we really going to now add
> separate error injections for each different shape change on each
> different type of btree? That explodes the number of injection
> points quite quickly....
Well, that certainly seem like a bit much.  But I don't think that just 
because we've added a few error tags that we necessarily have to put one 
on every transformation.  I think it's a fair compromise to simply 
identify a few points of interest, and if we later find a need to make 
the tests more rigorous we can expand the infrastructure we've set up here?

Allison

> 
> Cheers,
> 
> Dave.
> 
