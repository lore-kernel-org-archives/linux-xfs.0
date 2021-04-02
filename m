Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67FC2C433B4
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 09:51:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F50F60FE6
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 09:51:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234217AbhDBJvO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Apr 2021 05:51:14 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:59318 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234512AbhDBJvM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Apr 2021 05:51:12 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1329o2ZP092234;
        Fri, 2 Apr 2021 09:51:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=WUmQfGtlaGZEOQFinq1sZ/xMeKFzMwVCcdb6YTkSpL4=;
 b=nItLxzr4mMkyx6Nh8erlZMQNZbeY5WDUcV4T9zur97RVZiMyZ9z0ukmGw2JHqbyE0FGv
 igYINGlXat7bm3V4522b378procDz2H0nF9uo45Mw+3+7Zxg3whUXw85xYVTQ325xgNG
 3vYw3gq3lgU5F4ekNTgQ+9HurxH7NmK+EDBZf6UhKVoGu5Mgaa+VbDEJ5C1Lmnvz1psI
 LJV9IOXPvLLXvSTUkPx3XcNQT85p7Yu+joi+wwt5DhLy8rjd/+FeYxTNOLAruWvlmaY+
 xatqwGmRN12KrPUpH5q2ydlXJ9lX+5gs7as91XuPISar8IhJ83Z8UjJcUHVmYJqn5mpi RQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 37n33dv8p7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 09:51:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1329ilx8091486;
        Fri, 2 Apr 2021 09:51:09 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by userp3020.oracle.com with ESMTP id 37n2pbm251-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 09:51:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oSqhJn7M8hLl02eGIUbVWBgJZ9xFvwugu624Ui5qbFsu+0IdYD35SheWRE2XLXBEMhyhjGFd48Pe5xI+UAct9JJxVVQEZJD+KOhM68GwMT3SalIdv8DHti46OTF+W1RdTCHxvIfFizbNZWLgV9LXB+HAVuOVZWUoUPWzt4Xu5/gfMkKZxInmbdwbjEYYHF0xvBmTZwKz9pNhJXubdA3giYwG5/mOz1PR4Iumj+Tjsl9QRuhEifcsRl8fQz1bg0vNIdP6kz8ShPHyyCHon8FeAWPuyvAayeH/kxZdMxEv9w0lEI55SWusgv/KveAqxLa03EA1eMJ8gWk6zfXVt2P+AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WUmQfGtlaGZEOQFinq1sZ/xMeKFzMwVCcdb6YTkSpL4=;
 b=SrwfKfegYEW9Wy483Xf1laWR+2v3Grg5iDIrx5+ctSDyiuBGm2Gium81KBpSScD4sbjbW7somFP75ZgTcNYOwsvhs7cx6yeV/Z1BkqmUJmQ6B8qaiW48K1+LMfpB+YSA8Zvm/CU11LZmA/2fFbc9q8r12FnVpHkom/qp0NZt5ouW5o2y9hvUcbH6qwLcEwILaeAjAlVdPqTqa6H5kNQafE8J3HMdH8r24Ri6MhbkBa+FJUb1EMekLYhmEv/HbyQx2pHwlrLnrdyDtb9rzIr267B+uP/zzNVrlKF19ckp495+DWhYRSYd/+gR2T5DFqMfbkO+DdMQ0oF5jo3yL4P34Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WUmQfGtlaGZEOQFinq1sZ/xMeKFzMwVCcdb6YTkSpL4=;
 b=TuyaQN4eW/aRDLq5HcwqvdMpm63PDg/4XLHo3Fmc0ewllqOwh7dmvxB8ilYHVvsv6AycjdhpXE4sdDu5Zcn2Y2vskZfORX+UCK77Pj4GtL41duW7dUlrM228NDK4rL1mGNLKYIDUtYtvSD+UyeQuIR6RlhQRD2sqXAjAIydUqR8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3046.namprd10.prod.outlook.com (2603:10b6:a03:8e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.33; Fri, 2 Apr
 2021 09:51:07 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.3999.032; Fri, 2 Apr 2021
 09:51:07 +0000
Subject: Re: [PATCH v16 09/11] xfs: Hoist node transaction handling
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210326003308.32753-1-allison.henderson@oracle.com>
 <20210326003308.32753-10-allison.henderson@oracle.com>
 <87pmzd6zuv.fsf@garuda>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <e2235749-0be9-3075-e496-b5c7d4516ed6@oracle.com>
Date:   Fri, 2 Apr 2021 02:51:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <87pmzd6zuv.fsf@garuda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR05CA0199.namprd05.prod.outlook.com
 (2603:10b6:a03:330::24) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by SJ0PR05CA0199.namprd05.prod.outlook.com (2603:10b6:a03:330::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.9 via Frontend Transport; Fri, 2 Apr 2021 09:51:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80289926-e8a3-40d3-75d6-08d8f5bcd675
X-MS-TrafficTypeDiagnostic: BYAPR10MB3046:
X-Microsoft-Antispam-PRVS: <BYAPR10MB304646267BF7DEBDD01CBE41957A9@BYAPR10MB3046.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u7rTV0Jq+0LvtYYbIGxO71YglFP3tkzkrgVdnSX9QOChofDMk/N4FY2no1pVtnUOK+SCkYUQ+3KbBDVVHI+BA6M/NppBQXpE7w+otZNQlY4VfPQVyVVwZ7kiQNpZwiMsZSVNCcUYFv9StNIHm8skHRbMwzMvHLJiOPj2vUmdudLSE28USZPHH+xCdMhfXbvKDpTyGrVLoqfhrru7GuqF5+mQLeQD786fRDXQCPW1dnM8XqwBds02i3XOErJP149HhPPSp0gOMuzcR2VGl83uJzfvrSTPUCOFYI7geWGZ08SFjmpwrZibey/to7vEY+DlkLez5rHxbLpWzkK9z762q9wflcYMjSJdyp3g+NQmAHrcuznNRfjos5lG4SI7zNlEHK1K+Xrcth+wHZoaqdMFNOKcQzUlgcTUJ8h4p+yA7ETtKW7Ro3n7RVl5NMdpvX4nBUbt+wAB6v0QBinD1DibhmeLU8+XSdpvySwZsay5Cb9lWkobzVYbVDLaBC8C6eOKW4akyibfn/e+vP+7BqjKYAypQisoE7lsQ9SiRs/h/2E0Gn3OS24aI7dyRgCr5COlYQFPgbQTQNJmzDgAPIVU/O92wRzncLabE4KePbDkAwt0tJ1vKht4Ogx8lF//o4btJJjI/v72YtMdtPMRqpHbYNijXpIN1f4sG92/0GbWWfJTwEAPzsGzSuNF4B+jpf8Siz/DEYf9RC6b2zvREY8ojg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(136003)(396003)(376002)(39860400002)(956004)(36756003)(6916009)(2616005)(38100700001)(316002)(8936002)(4326008)(86362001)(186003)(66946007)(44832011)(66556008)(31696002)(5660300002)(4744005)(53546011)(16576012)(31686004)(16526019)(6486002)(2906002)(52116002)(478600001)(66476007)(8676002)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UGdUQmlYK1NYUnlRR0ZBRjEwM0o2amVoNWFBcXNrdEhRYTBWZE1uZlRnTGVr?=
 =?utf-8?B?VDdVeVlsK3p2TzRQamJuMWkyWTd2WUdkT3g1UmlpMGV1cU5od3R3SWI2SzlY?=
 =?utf-8?B?L2I0ZTl4TzNwa3gxK3Y2alB3dC9VMjR3U0x3NjREV0F1cGkxdjJRSkZPN25I?=
 =?utf-8?B?c29BdmhuWUlYaW5IQktxcDNRMTVZQ1hMQkpZdGRKeWgxKytEWkFvYzJVUGRa?=
 =?utf-8?B?aUhxc3IzNFlNVFh2YTVtRmhQMGUzTFBORG1iWlRveDZEUWNETlRwRHRXMW5W?=
 =?utf-8?B?bDJqUW83NXYrMzhSMmxmYUEyZlVmcE9CN1FUcnprbkZhNWJVVEpDeko1S2N2?=
 =?utf-8?B?ckJCaWdLSWRKQWpacUFJa1VheDFoblFaWXpXM2dTeWxabXpEMU9qRlpXWDZx?=
 =?utf-8?B?aEsyVitmNWdYcUpwUzlNM2ozZ2NpVDgzSENpYklGdzlSMG5JSDl1eWppOGJj?=
 =?utf-8?B?czlIQm9PNG1lcTZSMHBFWlI1SFBvK3ZDTHE3ODBUVnVaMHI3V25VNmovbW1j?=
 =?utf-8?B?TFNTenUvV1hlYllWUkdiQmhKZFRGTGtSMjl0Zk5tSml1RFptWExCV3FLMVdm?=
 =?utf-8?B?VFRwVDhBdmZ5c3RRNHNnVndkRERHR1dldUlOYlBheTd2eXkwWGNjSTIxMCt6?=
 =?utf-8?B?RjdMWnBoOVYvYmZGYnhOUlhhaWlra1dIL3hOOHJGSkZ2bWdxVm9KNTB5RnJu?=
 =?utf-8?B?ZFlRNHZZczkzMDZyL3pHZTlwTktGTnN5Y2xjdnZ0aFpZajdWcHh6RjljNDJN?=
 =?utf-8?B?RE00OXVqVW11OGdOK1h6M0YrUmVpZ3ZQK0tGdjdyQlBzd2dPRkdtUEdYcTc3?=
 =?utf-8?B?OHZ5d3lIb3lVMnQ3MzdNVTlVZW1jU1AyYU50dHNTQUFuSkFpWkRWL2xCRlJq?=
 =?utf-8?B?d1hKZE54R2tobDRpS3c1WENFc0ZzaU1PK0J0bUFxeSszdDVSNkloanR5YXZT?=
 =?utf-8?B?UDFyRWEyb2FNMG1FK0FlYnQ4dmF1VW1hTTNIdHEvNzNZUE5FZCtCTUkwR2d5?=
 =?utf-8?B?aFlUQit3RnVYZHVKb3Z6VjVRT1pxSE04ejNiekQwS0pqbFpEc1VOQTNjbzhT?=
 =?utf-8?B?cE1nSWVXMEl2RU9tbkg0cGQyelZDWE5jZWZWTHpuRFB1dFFNQmxkSGdaREla?=
 =?utf-8?B?RDQ0dVFIOTJYM1hFYndIeE4waVlYS0MraTFzdVVwdGt0RE4xZUNoakxWVTBG?=
 =?utf-8?B?UnNtMVZJSzV4eWNweW96dUh4c1NCVVVDVXYycFJXRWp0RFp2NEI5MG0yQSs3?=
 =?utf-8?B?UnNobk4raWlSaEt6dDVzVlFQWFJadEY4MzZxcG9QNFJobFNtb3RYeWpyUHlP?=
 =?utf-8?B?SmYyZTkweEpuMnlFSXBDZldIUUJkYVFHUHEyODVYbVc3MUFQY2s5cGRKeG9U?=
 =?utf-8?B?d0lZcXlyajRZZmltcWwxZzRhTVg0NC9tbXp3bXM0bUNRbUI4RjUvUUJNK1dm?=
 =?utf-8?B?V2p5NWxuL2dWcU5PQ1hmUS9LNGtPZkd1MTFPRjlacFJTZjlIMW0wZkplZTZs?=
 =?utf-8?B?NUxuVHhEYWlYbHdISFJPcTg1K1g1eXRSeWFwZWZ3VkZGOXJLOUpQUnRqdm1j?=
 =?utf-8?B?RTZka2hFWXp6RGlxV3FPRGcwbllPQXhzbzRjZmg2WmpOUUM0b3RPdUVaMHJi?=
 =?utf-8?B?L1h5Yi9BaHR4c1hkdmVwa2MrYXh1ck8vQmp2YXV5TmFNTzBnRUt3bnFRbnF3?=
 =?utf-8?B?QmpwSDhHbDJiUzR3Q2o3WVRCVDVRbkhQV0pwL1pTeDhNc1lhN0lUeTAvWS94?=
 =?utf-8?Q?lTiT62NH2rH1oYouYiHFJLRqLdaW3uRW6RJP95E?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80289926-e8a3-40d3-75d6-08d8f5bcd675
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2021 09:51:07.5346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2y0jtb8wMUHelMhIZ6thMQmFi5TkxZmuGiYgU978VhcuaNfikNti/enwKALumDMqvLwSxW/+bRo57SPHo2ac6dHeHDryv1EJvrwp2LRYJg4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3046
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 mlxscore=0 spamscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104020068
X-Proofpoint-GUID: rsehpc4qszmj49HLMPBvQC-z-Y892Y6q
X-Proofpoint-ORIG-GUID: rsehpc4qszmj49HLMPBvQC-z-Y892Y6q
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 impostorscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020068
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/1/21 10:04 PM, Chandan Babu R wrote:
> On 26 Mar 2021 at 06:03, Allison Henderson wrote:
>> This patch basically hoists the node transaction handling around the
>> leaf code we just hoisted.  This will helps setup this area for the
>> state machine since the goto is easily replaced with a state since it
>> ends with a transaction roll.
>>
> 
> Looks good to me.
> 
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Thanks!  Will add the rvb.
Allison

> 
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Reviewed-by: Brian Foster <bfoster@redhat.com>
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
