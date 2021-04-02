Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AA64C433B4
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 09:50:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31ECD6112E
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 09:50:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234479AbhDBJuq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Apr 2021 05:50:46 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39332 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234316AbhDBJup (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Apr 2021 05:50:45 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1329nQ0A150042;
        Fri, 2 Apr 2021 09:50:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=NnwiD3o1+iRhyL6MFLZLWZ+loQiFArxnxW2QmdR6taY=;
 b=akuaFzVqMIIN7abKp+upMaV+8Rp4jyJvQm1mwPrOy0rEd2maqG2E3RmRwVmMmAFHcEBU
 D4sEca/UQ0oykAI4ehnCiHQV2yeO4BNI8YGHb/Clgr2e7+QJngwUlpGMatYWqUVPFsIn
 LjOd8SHMOG6CsqusMyQO82b6QxJDk5ceTRIqAkjxo76mjDkbxlGHOrt656abJS/qm9J8
 hYmvV4kaZvhLGhbQth8k7Fp7FI/l4iAG2exk5mcLubX8LNW/xlsfQqHFIc4dU95IarLa
 s/9tP315EMfqkLnJFV1vr2NigjaxeZGu4GvKBJ3kB/Bb8waU0sa1zmVqqvk5i97abeuR oQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 37n30sc888-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 09:50:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1329jkSc021030;
        Fri, 2 Apr 2021 09:50:42 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by aserp3030.oracle.com with ESMTP id 37n2ata14g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 09:50:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b+AF1yTvW/hepKQbGRoD+ORigjWD07CJaDhmt9P/f+f0ZvMdZvhdwDvkDwWlspb/Ab6i4Pczr7RGjmMHDzslLmsRGu3eo8TvEBQuxx59yVYUsVuGH4VfQDxywN07uBmFRUwNsux6nL+Qt5qkqVBBNKAO5VKaxrVP1lC2SqLz1LxFOKjRFmbWhPFle9YmwbbdexGVOterRKoCHLF7j8wMw26YG8NDLTzbLoGVEiEQBfZborzZtr22sWN81MaB5coZMS9BQIbCDpkQBqISVZe8gIGqBiVU845nMXW3UfSzhEHeHRKDywa+VXG7jKEQTl2EiROl74M27+DHaV17ZdwRXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NnwiD3o1+iRhyL6MFLZLWZ+loQiFArxnxW2QmdR6taY=;
 b=hGwDZ3S3jYcxuyzaaQcTJY/sjBSW8huFFVezZ36xpoKGkbqkjNM2nvLolFoa3mmpxi6Jwu1WT3fjQxaZJohc1bNkUZTPZG94i0q6z37blWjYV7U8Rk4R6MD9LmxsT+HDckh1awlTVsev9ShGWjYFxS7JH1R9xfx9WHyxpr8h7ClLF8Be88KDd74vudcOL8Ebl2GyM9zLAf7Eol16K9Fb1QJlWP4NMQbY+dDfiKzq3L5YJ1+oXcMe24rPri7nKy3W3cdZPTw2mstahaKraiqDUH0lisQXZdacbbSfaJO/lL9eZpapIf6P2QfKQEtf56qOK16+2i+sevPT6pOLKxQtww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NnwiD3o1+iRhyL6MFLZLWZ+loQiFArxnxW2QmdR6taY=;
 b=A+6EccnNOxH3s13nNBDnJqqVe3MMBLvwIs/yijLfLlU/lLu2a4WDnXdPDWx9tREFACVn3DcNX9+pGBggQCLwJ4DCsgDqNywxNtipmL2nH/QaN6DYlj0JfPAevoLjKbqJfPmHB9IuQtTp4U3BBwiqUDCb+KZEuRYovi2EC1M24jA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3046.namprd10.prod.outlook.com (2603:10b6:a03:8e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.33; Fri, 2 Apr
 2021 09:50:40 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.3999.032; Fri, 2 Apr 2021
 09:50:40 +0000
Subject: Re: [PATCH v16 08/11] xfs: Hoist xfs_attr_leaf_addname
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210326003308.32753-1-allison.henderson@oracle.com>
 <20210326003308.32753-9-allison.henderson@oracle.com> <87r1jt70yy.fsf@garuda>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <d68f0179-e2c7-ba4d-c25a-a0b9e4d23e73@oracle.com>
Date:   Fri, 2 Apr 2021 02:50:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <87r1jt70yy.fsf@garuda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR05CA0052.namprd05.prod.outlook.com
 (2603:10b6:a03:74::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by BYAPR05CA0052.namprd05.prod.outlook.com (2603:10b6:a03:74::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.8 via Frontend Transport; Fri, 2 Apr 2021 09:50:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ab3947c7-8ca7-4dd7-cf75-08d8f5bcc65d
X-MS-TrafficTypeDiagnostic: BYAPR10MB3046:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3046895F2791B1DB7450819D957A9@BYAPR10MB3046.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: icXld6Cugu3aipgda1H83pvG1XsPUZXbVefM8Eb4kFYzLXfgNOz799PK90xzG2FiERmRHokt0SjQAGPlROT6RSGeaV1QcDkVfu3RI3Gef5YIG6GwDvGnTSik1ktm8HGlcRdjFXAHISgUY8lfHfEqubd6uAob66DVNpIHuWXyjGlz1lGlKisIQycKYHBq4cgEX1MOBOPdFmAgA54qMJ/Mvm30ldEc75vZWF6h4oG/FB6WzdLVxmJ2Ow3AL41p8ylWglQXSpQhBv37tXc/+Wff+KqNbIIIBV4nn96Un+fMUKlIvBTqVBj+ZfGksLuW/wcTKiQhuc4S2sofgRFhsN3Wfzuhc8+U+WT+VgM6EPsbjpLgJn1KFM3aqLD40odiqRXGalWlOkbEm5NzxIFr/rwt73dV3UBKRXYnZw2VeTg7gRX4wm4udyVlAUYENqcnboHskxLyG0Xkfrwo5RuEwG2loMD34b6Mal7/CNbx9uZVcQ07sEuSQKe3iyA007uL0+WP877y7/4Npq0MYBgQBa4rzXs4TI6KN3VUm5iV0owc48R1T/JN6ZNYsOLct16Llk7SllnUmUIkQ9MTuM3F+Cajppht0Kv1VXSZU3SAJvnt2RKiAbogUcPRUC4xfAm7ZGAgcKqSXktq/e6gVUtuS28az1ORAB4DoXig3/suS0lHWKWkRuflPglzz5KitGZT5ZZtHclqO7+KP0E+m/JnmF6wGg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(136003)(396003)(376002)(39860400002)(956004)(36756003)(6916009)(2616005)(38100700001)(316002)(8936002)(4326008)(86362001)(186003)(66946007)(44832011)(66556008)(31696002)(5660300002)(4744005)(53546011)(16576012)(31686004)(16526019)(6486002)(2906002)(52116002)(478600001)(66476007)(8676002)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?L2JMZVgxZnZZWk00SkZTdi9xQzBuUVFMSHArcjArWlpvM3JXcWhFMWFYRk42?=
 =?utf-8?B?WjJ2REhxbWxJRVhWUklub1lMRTBudzM4V1kxMStycklBZjZEeHlobFA2TWRS?=
 =?utf-8?B?RytuVVFXV052ZzhkK3ZpOXg1STFNRnJqUmYwTDNPdjR4bDR0NXREdEVqMENY?=
 =?utf-8?B?dk9WWGZSWTJvQS80V0E3c1ZEd2RCOHB6YTkvdDc4WFdKTjJ5dHRIZnh2U0pH?=
 =?utf-8?B?anZkcHQ2VmJ5NUY1K0xsQ0FtZTBXTUxrbnlqellaczJFOEhwZTZmOXd0Tnh5?=
 =?utf-8?B?M3pIWjlPVHBDTUhKVFJlbk1Jb1QwTWFlT0RIUXJOclF2aDVMc0FLWjJ2L2JU?=
 =?utf-8?B?L1c3ODUxU09oN1g3aVdSS0xoTHZ3V2RkNG9qaXR4Y2lRQkdDUTVsa0dyenU2?=
 =?utf-8?B?aytoaDlTazhSM0FhRWlTQkx5SCsyeEpta285SmxOcjhSY0cyMHJrckkvSENi?=
 =?utf-8?B?cFFkOEZOek9Wc3J1WUNXNkhWSzlLU2YzVk1kS3dVZ2Q4cGQ1cFllc1owazl6?=
 =?utf-8?B?bG9pSXpiRDZWdCtwelNZNTU1aWtUanNiUkc4c1hSZXl4THVRNXJ3b05KdVJp?=
 =?utf-8?B?eWx3TXNhdTg2MlVQbUtaUWFKV0hoOWhvUUNHMWhDSzcrL3VpRFVtRVE4bTc3?=
 =?utf-8?B?R2pwZUZmYXZlZmpIYWNsZ3lvYXdFOEh0bFpXTk9hcWhldkVpdUx3c3BHWEVU?=
 =?utf-8?B?S213ZnkzU2VZV29yUGx1TUh0Tm5oUlE1QXFrekZQcUtkK0swQVNlbDBLNE5J?=
 =?utf-8?B?WUpQbWVLaFF2VWY3TE96U2o4ejA3eFJMckl1Ui9UZWQxUkhmUFNlWjcycm4z?=
 =?utf-8?B?RW8xQTVvM2IzWElvZUxla1JwcDNuWitHZGxoWDhGWGRFR3llUFFUbjlJSmtO?=
 =?utf-8?B?ZnpqcEtsQTROMUg1SnhyeXVBVzBEc1QvSW9mOG5KTVhIMW1yTTJGbXhOYmdD?=
 =?utf-8?B?YzBDbis3bXpXbEJOUkRwN3FkMVNtdWRHVm5OeVhJUlV2U3Q5TGhjcE5TNEIz?=
 =?utf-8?B?aURvdnhHRWpLV0N1T1ZBd1YxcnRVZ2t3dXFJWEFtellsYlVlQW90YTMyWWR2?=
 =?utf-8?B?SGtRbUJkeEc4U1YwYW5aV2xKWG94K2RnUWpTdW1XbExLNkNCZ2Roa0psNDNJ?=
 =?utf-8?B?WVJaQ0szU2o3bEtGWXdDczM1ZmdJZGtvVDJGdS84Z01zclp2b2o0NXhZYVNk?=
 =?utf-8?B?QVRJQXVGUzJLYkFkYXJDY05IMHQ4YjV6UDVUcmMyY0R0MGpjZWlSaGFCeG50?=
 =?utf-8?B?TWV4S0dlT0wzd1BqN0hJRFdReVRoZ0ZYVVRjQk9tazRGKzFIMHNZVndtek9W?=
 =?utf-8?B?SkI4THJNR3FlU3A0RW10Zkt2RktUNjNnZU5TS3NyZkk4b3paZlV1VWsxVlc0?=
 =?utf-8?B?bm12U0tqZlF4UXFxYlFMYkRMUkRBbzJSS3g3SHVGNzkya2pPYlRwVlB5eWV0?=
 =?utf-8?B?bnBXR0pRSCsyVFdHM3M1cTZnZk1XYlBzN3FXalRPVlV0K2hSU3ZNZHZKbVNx?=
 =?utf-8?B?MjJ4UlhvNkp1b2xsamprWDJzMWJETGg5WFlrUVlKY3pXdnNFN3R3eGVSbGVF?=
 =?utf-8?B?R1pOT1c3MnNzTjlZREdteVlvV1FNaTVXVlZKZmRMS0ZRUWhIenlyMlEvNXhK?=
 =?utf-8?B?bnhaRTh3UXNKSFBJWDZXYTZ2RHF6YUZpV2YrYWc3eGtiSEJtVm1BRzZ1TGtU?=
 =?utf-8?B?MHhGT3h5Q2ZJQnB2TWdSOFB0eGFoY0U0WGlZNUYvenF0U2Jpdko2YklndG51?=
 =?utf-8?Q?4Eo8RuQcblq5N/gDA3Wd2Wi37e7B8RERU492HVw?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab3947c7-8ca7-4dd7-cf75-08d8f5bcc65d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2021 09:50:40.4773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XjPCR5W6+EH70DScF3nhnjKtUiQDSc2H7Rl3RA9X8/yS+i4uHMZzMZex3np7t9bbRDlgSs7KSkRfgzcnF2bWSfLSUwEcJ2OQrfhfSePEv/o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3046
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104020068
X-Proofpoint-GUID: zwV6XOaFYpzQQSmHrXlV9-78gW9krTyj
X-Proofpoint-ORIG-GUID: zwV6XOaFYpzQQSmHrXlV9-78gW9krTyj
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 bulkscore=0 priorityscore=1501 suspectscore=0 mlxscore=0 spamscore=0
 clxscore=1015 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020068
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/1/21 9:40 PM, Chandan Babu R wrote:
> On 26 Mar 2021 at 06:03, Allison Henderson wrote:
>> This patch hoists xfs_attr_leaf_addname into the calling function.  The
>> goal being to get all the code that will require state management into
>> the same scope. This isn't particuarly aesthetic right away, but it is a
>> preliminary step to merging in the state machine code.
> 
> The changes look good to me.
> 
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Thank you!
Allison

> 
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
