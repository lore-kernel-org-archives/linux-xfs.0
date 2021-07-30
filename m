Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BCF3C4338F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Jul 2021 09:17:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01D2961019
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Jul 2021 09:17:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbhG3JRt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Jul 2021 05:17:49 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:30190 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230359AbhG3JRt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Jul 2021 05:17:49 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16U9Bjce007780;
        Fri, 30 Jul 2021 09:17:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Lq9i2XT3V5zUHs6CZVPu/vV6b3ygKGAHYPZ/nLDT/SI=;
 b=0hwj3MEudHlYO9Ttk4edhiYXAyk5XBqpXQrTn6ViZv3DAY3rYyvmHncrUdNHtOnTwHKt
 I1gL6VmCsD39MWyYAJOTrgcUS4I4SnAEq0Nb7EZwe1/LhGQlVyF+JNGflZNsY9Drnw4h
 UNxkEcMr1+utfVJe4clI+RuvXNK9YP7eDJkmGgJ8juwOuOBRb+UyhawOEyuEyotejknm
 /6FexwR+pe9B0ICkm0bQcYY0C66k7VlTpcaMRrJbYefoeqHYIy2oCZ6c6DpBDrogEgIP
 35UBAzfMkv3NLox2/83GOhYpvWZro6gMREiTaW2BscPjIMiNsDlKeg4iVRuUpRB0JQxj aQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Lq9i2XT3V5zUHs6CZVPu/vV6b3ygKGAHYPZ/nLDT/SI=;
 b=KVHjugdEo7UK1ujabftcvFW/Hn75zcN1i7ftX/SaygaSsXG/Vuu8km1bVCuyNnh+sfKl
 3n1SyQDZK7/txON4Mtrq7q8qwQhqHkTRdehF9/ivNICLE3v25WRXIRrYktN3MJqMR5iA
 VJ+goXZx6QaT/9i2Qdo+MbQDNP8dFI7ten4mSsj/Ehup9a/pYpQzkD3JZbgV0YJJ9vav
 OBNIf0uzF1/u3lCYA8EQYv/7/hecLhlYeiBxlM9c10urc9ENZ1wOpdZLZ1+TTqy6u7d+
 WkA2Gb1cssB03+TyzWlEz7kfZhjP5genPlc9dK+P6IB28T5ruFYNd4xBFEsHjoeVWvcM 1A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a3uujacg2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Jul 2021 09:17:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16U9FNUm078497;
        Fri, 30 Jul 2021 09:17:42 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by userp3020.oracle.com with ESMTP id 3a2352p0e7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Jul 2021 09:17:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KD24h5PxNDQf0LCIe2ksu5y96Ryv/WFdCENgwDSn1kK7JJsgsqaU15d2VT+Ec+PnKjsJoBtrwr9+UeI8rYNARxzHM64fmgBJyIwrIf0zRgHfHuBmF/9JO7CdXskWVh/zrObL1RXD7d7vm1ZGXEJSxpQCCvOu3h1aoXnPTRKHuJMQ2bZE0CSt96aCZNEg6oJ/kKQbCvSfzqTPg//ENbUKYArjYHCuY6k6EyRhLzFcJfQp3EEdaQ6Uro7zkso/SH3TELM16JTuyQIm8aSy+/O8lZmgNuG06sRl7R7qrmtO5ZYaFEpeI0LBIoH0DoOWh6Ws6crYD0kVK5WENqAefEQ9Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lq9i2XT3V5zUHs6CZVPu/vV6b3ygKGAHYPZ/nLDT/SI=;
 b=jmEUiM+87+QWFnkK+zU0r+7gitci8bjbhxKFdgLwpWow2849W9ZMTUE2zd012DxmMLvDc3Qp3FBl+Kh17byxAnY4m/77LHUUhJTDXUfWPGqf5dt9d401S3lo+UylfepYx61/o2yrP9h3zUS6+YGS42hBo3A6hjj5t33yynqwrE1D3K2WVLBDNA5D2anz0DOT5HQ9NcnKjF3yerPqYFrgn7IcNN5dNc0HYE04IbsHoe6q5Wxmlv/xx5qDNurKr+JtDxh6Knly6bhjw7i4qjEVPgXCRZJ8O1oH9yVoXhcbRU4v0bdp2OtN3OgqWY2y0jE5GpClg3IByKh1oYkeTnBWjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lq9i2XT3V5zUHs6CZVPu/vV6b3ygKGAHYPZ/nLDT/SI=;
 b=tGz1xn82pS/XLMXTxIaMeFk73aWBRDI28GWrs/72BahC/2b4D8sEn//Vvvx8+c4otzhGl5wEs58rWAKG9aeECljXn6X9lx8Nj/pizCHKdyx2iqjnK6H8paHECoPQ3P0/hAGWfmtqkWVm1sdyvCJ+M9nqop4cBo0VcM2wchA2h+c=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3384.namprd10.prod.outlook.com (2603:10b6:a03:14e::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17; Fri, 30 Jul
 2021 09:17:38 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%9]) with mapi id 15.20.4373.025; Fri, 30 Jul 2021
 09:17:38 +0000
Subject: Re: [PATCH v22 03/16] xfs: refactor xfs_iget calls from log intent
 recovery
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210727062053.11129-1-allison.henderson@oracle.com>
 <20210727062053.11129-4-allison.henderson@oracle.com> <87y29qvekr.fsf@garuda>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <fcb8fef9-cb8a-1f51-590b-9ffa9a20b090@oracle.com>
Date:   Fri, 30 Jul 2021 02:17:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <87y29qvekr.fsf@garuda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0061.namprd08.prod.outlook.com
 (2603:10b6:a03:117::38) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.166] (67.1.112.125) by BYAPR08CA0061.namprd08.prod.outlook.com (2603:10b6:a03:117::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Fri, 30 Jul 2021 09:17:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb7f2bb1-785b-4fa1-a84a-08d9533ae012
X-MS-TrafficTypeDiagnostic: BYAPR10MB3384:
X-Microsoft-Antispam-PRVS: <BYAPR10MB33847BFE228643016714145195EC9@BYAPR10MB3384.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:565;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IyCtaGYC3NWhiMUxZRU58NCrMjtNDsbUIJEl3HrszyKZduMMkj0Npelltr6HtrtRQz/UW36OLrg2nJbBE2qh8VKtbspz7ZUz+rDceyPH+8POWPJn76txp4DCNozDPzTtbKKiCsPu2zv7goCfIe2w1QfQORKr8gPjBUTSjlmtC0Kc8ZjtXFfcTc2CLxjeLx4lMbRVbQxBL3QwRsK2jETaZ2RxnAGzWsXFapawSF9RjZGBK3Jo/D5pmKlLMf4gDixNoS8BH9qMc9RAgXcNXmGH7rCXxWJ8cPG6vQJRzQaQLdrBI5T8v9xMlREJani8rxuscLw321DDv6O59y0FZXSJxBksoI98LkRjd27ORBK2x8rQV8D0p/4bhvIM9snuQuo2Ptk/Y/3QuihHs+ROi0fuPXsz/duGnXrrBvzK3Vyt46WBqojaVj5IIKHoCP1iU+eqUEO0KsbbMR2LVspDuqiu4ZfkW/DaSE4DBgPQE9g75s4f9hmB7XcF6yzNvYlQQuC6uDhfCAtkML16cIGsfSeg7eHsPoYyJz5X+IE3w6cTC1In3ZJIUxI15aywY4fw0YDIXl0+4bnF4oCQBSMZx4hUnEiNLtDVI07yG41uzpRNN5iz16ZATpsGUsosYc0HnqUN2epqS6M46r7WThubr6z39DtsKAQ3mXNFeRaE2821MOa8qyZTk1Uz2ELQqjQ2Ldr2p0ZiikHPO/Lbp48ZnhrpBumJDrO2GhN7JF3PGOWBfgFWDeFTJm/81IYaK43DpGrOfaVd2ctsOF1h1kmJheEfqA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(366004)(376002)(136003)(396003)(316002)(36756003)(4326008)(16576012)(8676002)(186003)(31696002)(66476007)(31686004)(478600001)(26005)(66556008)(8936002)(52116002)(66946007)(86362001)(44832011)(5660300002)(2906002)(6916009)(53546011)(38350700002)(38100700002)(2616005)(83380400001)(956004)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b1FST3M1enFqeVhkNWpVU3JiZnlGWEpGMWJudnQvMktQTlRaN2JabEIyK29B?=
 =?utf-8?B?Mkp5MlpUTXI4dEVtRmN1UVBXaGdlVEdqMlp3cG9FRTNNN2FLSFUzT0xQb0g5?=
 =?utf-8?B?M2R3a2RJMEN2VFFPMlNZdjg5Z2xKWlN1ZVc4Zk5VVDlURVQvdE1jTjFFMEUw?=
 =?utf-8?B?ZTNVVmtEU1FWMGhNbXpTZmwwUCt2RHJxNjk5UG1mUXdqdldNcmp1TDVDdXlu?=
 =?utf-8?B?SGJTU3FKcUpRWHpySDJFRkU3eEV0N3c1SngwZjY4RFZtZHYrTHBkR0xJaWZE?=
 =?utf-8?B?TFJsU1NsTEliNlNzYWs2ZkJyYzk0Sk1kam9sRi8xVmg4eUJGdVJKZ3V3Vktu?=
 =?utf-8?B?SjhFRVlhbGlGSFkxTmhpb1dxTEd1ZTJNU2Yydk5Tc0pQYVMwOUN2T1dEWHVG?=
 =?utf-8?B?eGZkQnFENHNLVE56dnpxamJpZi9Tbi9iZjhRZTRNYkZCSHZNdXp6TjBZN3JI?=
 =?utf-8?B?K2VZQ2tab0I5cmdXb0xrQTlkNmduQS8rejJDSlZteng3c2dQQzdzVzk4YlpS?=
 =?utf-8?B?N0ZWMmZ1UlR1eFkvaEVLWE4wOHhGcEFVM3B5R0ZsN3V5MVZIY2d1ZWVNM0M3?=
 =?utf-8?B?NEgxTnpFSmFQN29tUjZFVHUvTVpzMlFJYkQybHlPWk1UeEdRMXNOOXZGZklz?=
 =?utf-8?B?UkQ2ZEVFaSttNHZaeWRrR0JDT2NuaS9TNkVWNFR0eUo0MkF4QklaSktLeGJP?=
 =?utf-8?B?Qi9QeVkybDB6RFBMcXB1QWQ5Znh5YWRIMEpqT0daWVBqbGdnTWpqNDdiVHA3?=
 =?utf-8?B?VlBWL20vVjRXZXR6VllCNUtWZ2FWRC9yQXNHMEdZc0lLN1lML00yNXJBNng4?=
 =?utf-8?B?Zm1LOFdVcTZUTVZCdEZsZXNsV1F0V1lmeUNIbXlrV0tkWFFsYjg0UHhwUFV4?=
 =?utf-8?B?dERvemZUQmlrY2hQLzE5V0ZseEo4Q0xvV1NFUjg0V2U5WmRXVWZpRXB0Zk5I?=
 =?utf-8?B?dXFEQXhBV1dFNlFkUVVrZG1mdGNhL29waFFKK0ZsWmJSZURpdys0SmNWY2ow?=
 =?utf-8?B?M005TXRPZ0phYVc0Y0dhR3lnY3BpblEwakFFSkRIWi9tRHBWMUgrVFA5SUZG?=
 =?utf-8?B?RjIrVGJnaklNZjU2TnZuK1JUenlidDRGODlSejNkRGdPR3d4eDU5Yng2dDVq?=
 =?utf-8?B?R3JIb2lOekhtYlpoa0ZGUEpqQVIzKy91VGkwYjFqNzAvbW5MVXlFTU9VUlQw?=
 =?utf-8?B?Rjc4bnRlWjhaUHN1elVoZ0hZUjJPbnRtUzRycjBObjNWUythZjNvRHVKdE9W?=
 =?utf-8?B?Zk51d2R5Q2F2Z1pGak5kcElqaWlKYS93S1NTazdIWFNaTnN5SUl2THdXUmNO?=
 =?utf-8?B?eTJGd2pIaXFvRnRzSTdUY3VOQVNEcDhuUWsvYlBqUGxUQ1FyMHg2bkxieURs?=
 =?utf-8?B?VW5JUVM1RGJ3SWNYb2IzamhySTA4MjcyZWVEaXNaOTBISmhSMnZkYnVLNzJu?=
 =?utf-8?B?eHZkZWlzMHB3U3d5MU9SYzhSM2lUS29keis3N25LdWxOVjZYcTUwTVIvbFZM?=
 =?utf-8?B?VEpXdEErajVMZ29aajV1TEsrUXhGTUVOT0hkenBHSWFmcE5JVWRNVHMxWEFh?=
 =?utf-8?B?Q2ZjTDBVamlLTzFhK1BFS1hZckhBL3pFYTJKajVBTDE5QzJZNjNEckJhNlFJ?=
 =?utf-8?B?VFREUDFUOVhXT1VWV3JsdEErSWQ0cmtoWUNHMCtBaHFBYTBYQ0w5RjRlT3hO?=
 =?utf-8?B?WEppV3lxNFJxQVZVRlFYZUMxMllFSGpmU2xMOFJ2Y3paZUdjWVpVc09SbWZ6?=
 =?utf-8?Q?06p2XtOOCehPa72mH3sQW7JHiNlqW7/WtcN6Ps+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb7f2bb1-785b-4fa1-a84a-08d9533ae012
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2021 09:17:38.3278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qg548Au9H6JD+4F+0aAo2/MNxLPDBcVtkKAHZ3wY1HxlFLjAGgesx2wN1wDMa+F4OFp953Fm+VPcko0dIJifWy2XKQibkz6v3LUpi5Ex20Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3384
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10060 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107300056
X-Proofpoint-ORIG-GUID: L7NcnFnzVr1LEsucnHK8MBegeXzkK-X6
X-Proofpoint-GUID: L7NcnFnzVr1LEsucnHK8MBegeXzkK-X6
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/28/21 4:54 AM, Chandan Babu R wrote:
> On 27 Jul 2021 at 11:50, Allison Henderson wrote:
>> Hoist the code from xfs_bui_item_recover that igets an inode and marks
>> it as being part of log intent recovery.  The next patch will want a
>> common function.
> 
> A straight forward hoist.
> 
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Great, thank you!
Allison

> 
>>
>> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
>> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_log_recover.h |  2 ++
>>   fs/xfs/xfs_bmap_item.c          | 11 +----------
>>   fs/xfs/xfs_log_recover.c        | 26 ++++++++++++++++++++++++++
>>   3 files changed, 29 insertions(+), 10 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
>> index 3cca2bf..ff69a00 100644
>> --- a/fs/xfs/libxfs/xfs_log_recover.h
>> +++ b/fs/xfs/libxfs/xfs_log_recover.h
>> @@ -122,6 +122,8 @@ void xlog_buf_readahead(struct xlog *log, xfs_daddr_t blkno, uint len,
>>   		const struct xfs_buf_ops *ops);
>>   bool xlog_is_buffer_cancelled(struct xlog *log, xfs_daddr_t blkno, uint len);
>>   
>> +int xlog_recover_iget(struct xfs_mount *mp, xfs_ino_t ino,
>> +		struct xfs_inode **ipp);
>>   void xlog_recover_release_intent(struct xlog *log, unsigned short intent_type,
>>   		uint64_t intent_id);
>>   
>> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
>> index e3a6919..e587a00 100644
>> --- a/fs/xfs/xfs_bmap_item.c
>> +++ b/fs/xfs/xfs_bmap_item.c
>> @@ -24,7 +24,6 @@
>>   #include "xfs_error.h"
>>   #include "xfs_log_priv.h"
>>   #include "xfs_log_recover.h"
>> -#include "xfs_quota.h"
>>   
>>   kmem_zone_t	*xfs_bui_zone;
>>   kmem_zone_t	*xfs_bud_zone;
>> @@ -487,18 +486,10 @@ xfs_bui_item_recover(
>>   			XFS_ATTR_FORK : XFS_DATA_FORK;
>>   	bui_type = bmap->me_flags & XFS_BMAP_EXTENT_TYPE_MASK;
>>   
>> -	/* Grab the inode. */
>> -	error = xfs_iget(mp, NULL, bmap->me_owner, 0, 0, &ip);
>> +	error = xlog_recover_iget(mp, bmap->me_owner, &ip);
>>   	if (error)
>>   		return error;
>>   
>> -	error = xfs_qm_dqattach(ip);
>> -	if (error)
>> -		goto err_rele;
>> -
>> -	if (VFS_I(ip)->i_nlink == 0)
>> -		xfs_iflags_set(ip, XFS_IRECOVERY);
>> -
>>   	/* Allocate transaction and do the work. */
>>   	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
>>   			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK), 0, 0, &tp);
>> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
>> index ec4ccae..12118d5 100644
>> --- a/fs/xfs/xfs_log_recover.c
>> +++ b/fs/xfs/xfs_log_recover.c
>> @@ -26,6 +26,8 @@
>>   #include "xfs_error.h"
>>   #include "xfs_buf_item.h"
>>   #include "xfs_ag.h"
>> +#include "xfs_quota.h"
>> +
>>   
>>   #define BLK_AVG(blk1, blk2)	((blk1+blk2) >> 1)
>>   
>> @@ -1756,6 +1758,30 @@ xlog_recover_release_intent(
>>   	spin_unlock(&ailp->ail_lock);
>>   }
>>   
>> +int
>> +xlog_recover_iget(
>> +	struct xfs_mount	*mp,
>> +	xfs_ino_t		ino,
>> +	struct xfs_inode	**ipp)
>> +{
>> +	int			error;
>> +
>> +	error = xfs_iget(mp, NULL, ino, 0, 0, ipp);
>> +	if (error)
>> +		return error;
>> +
>> +	error = xfs_qm_dqattach(*ipp);
>> +	if (error) {
>> +		xfs_irele(*ipp);
>> +		return error;
>> +	}
>> +
>> +	if (VFS_I(*ipp)->i_nlink == 0)
>> +		xfs_iflags_set(*ipp, XFS_IRECOVERY);
>> +
>> +	return 0;
>> +}
>> +
>>   /******************************************************************************
>>    *
>>    *		Log recover routines
> 
> 
