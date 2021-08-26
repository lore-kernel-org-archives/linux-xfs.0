Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06735C4320A
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Aug 2021 00:58:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA0436108E
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Aug 2021 00:58:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235201AbhHZA7M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Aug 2021 20:59:12 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:3968 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232139AbhHZA7J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Aug 2021 20:59:09 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17PM53JX010069;
        Thu, 26 Aug 2021 00:58:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=wY73ag6bJPcjIJjMdmtj/Y9bpWr97QGQ4RjisTFhHUI=;
 b=X6JuMohixLgtgNN8QWLk5Ue0/mc9Fml1SGri+/FIHjXdRno+TNIBg8/0xMmCxEKl/y05
 mJDQgJV4WL16WDheSI85zUfykKPx4ttP0NkjW+ajLOASxAP8Sl4lsSJ1WOgcu0gjkQyf
 mfHqZTsIqb8gakbQimSmBMPRhbCPxw3DhAyjB4cY83AUCXFCreRMOrX7OA/ZLV0bNqlC
 thx6ji5fStf94yeQqlvdZCaan3+O1enURtLxF5PpQShEbFiIvBmFwRoIs8q2LObP9+8X
 EwuUqm7ys2zRiZmPfd7eytXko3Z7EUccKMnT6YAdr4NePoObHNWzL3nxtnz4hwXGZhoK Cw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=wY73ag6bJPcjIJjMdmtj/Y9bpWr97QGQ4RjisTFhHUI=;
 b=kG4WeFnK6nxo3Nor3QmtBHJ+GVJKygiuiWqqKdAzavh8VoA65Oj7Fk/CTASQnrJOAVf1
 DQzlObdGktIm6A0Z6Uy1OkNDSxqDzXBmObLtI5RR6UGUAXHdAso6z2LDnsjSowW3IiHU
 SMffuMGLZuC/nOl4EcFPYsPshjQFjQ5VN4ivRT67Mktr3RoZCt+biKW0IjJKwXhLT/Z4
 +Lya+LodXLaLtiuFpic6DOUvWAUc5QRJ4kir8wiF060wKpwlDHByUn6D8C1ixOrF0VM2
 jkjpdlHcQRO39TnAcKAI82e1Ge0XKxhGXfn1uwykIWGVvFcnIYwdDzgeQMS4F7CAFGhq QA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3amv67d765-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Aug 2021 00:58:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17Q0tdbs098504;
        Thu, 26 Aug 2021 00:58:20 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by userp3030.oracle.com with ESMTP id 3ajpm1jgac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Aug 2021 00:58:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QCIlRstkVEWys/+VP/eFdyiWHr/QGaC4/6i8wMCKW0v62vQgxedZdbGZ41e1RArvxgPCVBAYIVGzo2GpIWDOVVRSLwxH6qa447WllDuKN+8cFfmQd+N/Rex2QpLunkwPVzi9HVKQaJl+S9qvAFgHfmur1niu8CAk0worKzJGISols18AgpfoVG1jKiQtDu3cR/p6lVvQJTF3MoHvwh5OeCSz+w1DDHendD2Tsb56+Fhhc9VYALKyXP2sKILCwiSlcKQ6ovzkweqhrsxANUzxUy8oJq7sxkxZeHCSPc722It316YsYEtZTxiJEPcVeaJxMmj6414Nlgae3SyfNc22dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wY73ag6bJPcjIJjMdmtj/Y9bpWr97QGQ4RjisTFhHUI=;
 b=fhbLxPdY//Ngp6F5n50evL6Tdn7WFrAnkNBxwrl5bH0o2yzNApBnfeJzCuBkbqB4pJqann7I0ioE2/hTl20QIsChun+Gwe1Pc7O87tLPHdbX/EENMdzzl+0SWH+I5j+UVZ0H9NhDFNsUt2RJmg1cKi+bzmbsNxGtHb3oZ7ioNrGI9BxujS/ylDGOhbCcmhVp/7KzfaSz0jv+cAN02+w2m/Z0vZQ/3uD9J+DpyQLdpRZeJUJHDuwDEtDjAb4ebjf6ZtKTu/Gps03UqjO+DsXdLrT6YyodlO7T3eH5o9vpvASHMMsQM7w9iYEAKMu0J7YMIpOKKnRVPr2OqTg9qPqZ6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wY73ag6bJPcjIJjMdmtj/Y9bpWr97QGQ4RjisTFhHUI=;
 b=XVG7Elde36ykGwFlXSrUeU/ySNg4sRV8scTvCZ4hU1ho8ujD9aBtgc2Csuz5qWaxgGi3yfVT3gtwe4B3gGl+iCEfALbMVMpVPQiNecpHgoHThhU4FohqNl2pQWuJ1/zuFLn15igD0znVkTpqOrYRxnqOseQiW5nQIGP6gaa5E7g=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3109.namprd10.prod.outlook.com (2603:10b6:a03:14d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Thu, 26 Aug
 2021 00:58:16 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f%9]) with mapi id 15.20.4436.024; Thu, 26 Aug 2021
 00:58:16 +0000
Subject: Re: [PATCH 1/1] xfstests: Add Log Attribute Replay test
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <20210825195144.2283-1-catherine.hoang@oracle.com>
 <20210825195144.2283-2-catherine.hoang@oracle.com>
 <20210825222807.GG12640@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <02e9685b-b6e3-2fc7-9233-e9e540c0d3a6@oracle.com>
Date:   Wed, 25 Aug 2021 17:58:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210825222807.GG12640@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0005.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::18) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.167] (67.1.112.125) by BYAPR06CA0005.namprd06.prod.outlook.com (2603:10b6:a03:d4::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.18 via Frontend Transport; Thu, 26 Aug 2021 00:58:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2e570ff0-7a1d-4242-589a-08d9682c969c
X-MS-TrafficTypeDiagnostic: BYAPR10MB3109:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3109D8EBEA6CC9AE45A9796495C79@BYAPR10MB3109.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1sxVI4/2S2LdKSUnH6NpcK9anNs0vPSJndYWaQB1evttluC76qRkhzsFKaB72T/8thVUXk0sLePFscpe1ydO8NMwJvFaUpZ0Ws7wT/TEl03Av5zNpkxJ9Zl1TWclj2hE4gCpMJ8W946pd+GPeOskfZw+C4YydIUjOoDrBVyUmPTAbrFgo6MIxABkX+pfxePzYFQU7Czgvv7xjEtVPSOd9h84MZKuKZkw8Z/AkDG8l8t2PiU6TXQHbKJOK67WTHx1JSnqksFVFNJMMFHoziMFK+PmCH934qPyO7F96eHeAwtytTr/roT/iuaZslikzRIBK0YwbSL0hCYRg+ZtarlKfld7L2IhMJ9jsSuH2G9VyqQIJzBhGETFpnbU8xvFV9BKrmZlk2AoatzAw0WrMg4hYTDdMMlFiAS2HUwhsZaRfjZGPCxqLrHBFsiWcV0EFw43oX3CBPrOItmeWLMJfJUlnDEYXLq7/gmCGHj3HszgIiEqhny/5H03wYpBlYQpAARcNUh5FqNthkBtPP+vcxz4s2rhtHkfU5b7TgPx9tInDabBYfSJavjR63XbMUgFYAydYlhWFerQu8P2mSRbScIDPMw2w8CRsy1oDYU14JVKp6ZX47XMWhArZzDwE2rFUp9k72HvwyCBxZwKrh44UemQl9WVGL1YhCXpS4ZQghuo2XozIRgswc7FthmgHVTIVEQwIgm7K+i0BTqjeLPmdSNzMnhBZyui9/hgKMYekAk8kUD97oOF+XG9OeeJ76ZJZiWrie1qzkKaLGRYFIvhDhQDAM9MofhYRtEMYtjEe2O+ncc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(366004)(136003)(396003)(346002)(66946007)(316002)(86362001)(66556008)(66476007)(16576012)(44832011)(31696002)(110136005)(2616005)(8936002)(31686004)(52116002)(956004)(5660300002)(8676002)(38350700002)(2906002)(478600001)(6636002)(83380400001)(38100700002)(6486002)(26005)(186003)(36756003)(4326008)(53546011)(43740500002)(45980500001)(357404004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bjNOL1VOaEZmQkJCMVFBYUtFV1pWWmxYazFFVWhJanZEOFYrK2RPNFJZdW5K?=
 =?utf-8?B?bmJLUnVHc2kvOUplMmVRclU0YU5JaVduVFFYOGR1OFBRZ0FPZGNZQWM2VUZV?=
 =?utf-8?B?YlBuUUN2emJMUi9FTFZmb0gySjZsYWl6T0MxOGlQRkhYbXMyVUtQVStCVGNj?=
 =?utf-8?B?YXBUVzdzZW11SXZXRGliNFZuOGNJdlFkaE91OXRLbXNZUlhNR0IvcWgwTitS?=
 =?utf-8?B?NzFISUFneGRDQVMvNXk1QWJ1NEZrV0lRZXg1NWliY2dxcEtqYmNsNC9uYUx5?=
 =?utf-8?B?UEd6d20wM2NaeVY3R3NtVXhwUm1aTWZNaTBIWHNjN1JnQ3RRZXRnZE1yWUJi?=
 =?utf-8?B?VFRNZG5jWWRBSSsyUHhUa0VNRWEzUmwvdnFPOWFnM2hLWFN0R1poNEJQRFpS?=
 =?utf-8?B?aS9HWnUxSzJNSkNQL2pxSmZpQUVQUnd6bkpzTEZJajVUOFVXLy9JeXo4MUpZ?=
 =?utf-8?B?NzE3SGVTdWNGVHpzSVdjR0o4Y3d6UjRnVjVhV2hOSmM5TjVwZEJRa2REVTRa?=
 =?utf-8?B?a2Y5bnF4eWVNRWFZbTNsai9TdUdhRXJYUWg1by9FVTZGS0Evb0ZNRTYvMzhR?=
 =?utf-8?B?OWhjVVFmK0hKMERtYUFDV1ZGNk5SckptaXlETFV6OXpPU1B3SGNyNE96YjJV?=
 =?utf-8?B?bUNxcHRCeHlhbExQOWFIbUgwL0oyTXpMZ2RTWjVqQ21peUJiWDFWeE5VbzNn?=
 =?utf-8?B?UkdWSUl6LzdEQk1RaVo1NkFzVzIreC9WbEF0L1hmSCt3dFBSVlpTL1A2UDhO?=
 =?utf-8?B?T0p2Wm1BYzJIZ204V0pFS2VDYU45blR6T3Q2d2VMTWRFclZNZmVaaVBKOFdU?=
 =?utf-8?B?VjlCTis4NXVIUDNWZkw2cEJKWkFLRXFKK2dmRENueHIrTDRVU3VhcTQvTER3?=
 =?utf-8?B?MEExL1A2WS9UMW9nYkNxNlZnWkVQZ2g1ejV3RFNDblN5L2pCamM1UWViTkRX?=
 =?utf-8?B?YVF1eDBWbnZNQWFXMFRESWVDckswS2c2eFRFVU5CNERtNm1pNDhkOTAxNHRy?=
 =?utf-8?B?c3hvWVJlemluOWl5K20xcE5wbXVaREIxUmpSVkxTMVVTdjhpRldsYytnQUFo?=
 =?utf-8?B?TW5QT0xnU3l1WFdZTE5OYzdPNXg2eEdsb010UjBxa1J6NDA4bTNGVldWSnov?=
 =?utf-8?B?MDV3M2dJN0I4TjRQbFd3ZUUxS3EzNmRaNjhNOE1oV1NyZ3Z5Z2hRMEtQSnho?=
 =?utf-8?B?UUhyRHc0b09pRXdUSjFTdWlZNjBTaThXS0h4aHZVeXZLeDFYeFNUaGRYN1dI?=
 =?utf-8?B?cWNPdmRnS2x0UE9uVGZKS2tuaTI2U3liUno2NWhHUUtVK3pBS1kwbkd1emRO?=
 =?utf-8?B?MHZrZ2J3M1dRSHQyRlFkakc5VC8zd3NzSmZvZ0VURVVNYkIrWFRKbm0vOXV0?=
 =?utf-8?B?OEl5Vmx1MHhoeUtaSnpEUDc3K0F3aVkxVk5QNHpobnV0c3BlcXVNOU5oRE5N?=
 =?utf-8?B?RmZLRHVCRlFkdndKOG93ZWJaWGl5V1ZQczJXb0ttR0twOG1rV3hGSXlCQ1lz?=
 =?utf-8?B?Wno4a2cwenJuSUtDeGVyTWxvenpWTHhIbUZRc0VUQUUxVDU5SjJEZ0pXZnor?=
 =?utf-8?B?ZVQyRDhXY0c3LzEvanFQSU1RMmc1T0t5dUNUZlg5ejdDL3U0bHVhN3FnNWhk?=
 =?utf-8?B?WDhYUGkyN2xnS3VSanExc1lGQTlsVkxVSDBqaWFvSnRlTW1ETHhORzdIWkZ6?=
 =?utf-8?B?N1NmVTUwcG1mS0FvNldiYWhrTWxxUVNHNzF0NGNtVTRBWUxOWHlqUDdMWFRR?=
 =?utf-8?Q?O0m8GtdVRdMExjyC49v/6mVhdmfEhAV+H+hd8RD?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e570ff0-7a1d-4242-589a-08d9682c969c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2021 00:58:16.5469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pX0680kXi61QdH9LOnRPmxMr1qk/GPTIagKKcTVe8Azvwr9sQEFirQta0g7kAihlVeDszvaCNcIUybD3X7N0/RmL+3fjuqwAJODzGwjKA6k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3109
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10087 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108260004
X-Proofpoint-ORIG-GUID: aLjTFQPHnTg3H5ObgEmCJcHHyhsVXhCE
X-Proofpoint-GUID: aLjTFQPHnTg3H5ObgEmCJcHHyhsVXhCE
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 8/25/21 3:28 PM, Darrick J. Wong wrote:
> On Wed, Aug 25, 2021 at 12:51:44PM -0700, Catherine Hoang wrote:
>> From: Allison Henderson <allison.henderson@oracle.com>
>>
>> This patch adds a test to exercise the log attribute error
>> inject and log replay.  Attributes are added in increaseing
>> sizes up to 64k, and the error inject is used to replay them
>> from the log
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> 
> Yay, [your] first post! :D
> 
>> ---
>>   tests/xfs/540     |  96 ++++++++++++++++++++++++++++++++++
>>   tests/xfs/540.out | 130 ++++++++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 226 insertions(+)
>>   create mode 100755 tests/xfs/540
>>   create mode 100644 tests/xfs/540.out
>>
>> diff --git a/tests/xfs/540 b/tests/xfs/540
>> new file mode 100755
>> index 00000000..3b05b38b
>> --- /dev/null
>> +++ b/tests/xfs/540
>> @@ -0,0 +1,96 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2021, Oracle and/or its affiliates.  All Rights Reserved.
>> +#
>> +# FS QA Test 540
>> +#
>> +# Log attribute replay test
>> +#
>> +. ./common/preamble
>> +_begin_fstest auto quick attr
>> +
>> +# get standard environment, filters and checks
>> +. ./common/filter
>> +. ./common/attr
>> +. ./common/inject
>> +
>> +_cleanup()
>> +{
>> +	echo "*** unmount"
>> +	_scratch_unmount 2>/dev/null
>> +	rm -f $tmp.*
>> +	echo 0 > /sys/fs/xfs/debug/larp
>> +}
>> +
>> +_test_attr_replay()
>> +{
>> +	attr_name=$1
>> +	attr_value=$2
>> +	touch $testfile.1
>> +
>> +	echo "Inject error"
>> +	_scratch_inject_error "larp"
>> +
>> +	echo "Set attribute"
>> +	echo "$attr_value" | ${ATTR_PROG} -s "$attr_name" $testfile.1 | \
>> +			    _filter_scratch
>> +
>> +	echo "FS should be shut down, touch will fail"
>> +	touch $testfile.1
>> +
>> +	echo "Remount to replay log"
>> +	_scratch_inject_logprint >> $seqres.full
>> +
>> +	echo "FS should be online, touch should succeed"
>> +	touch $testfile.1
>> +
>> +	echo "Verify attr recovery"
>> +	_getfattr --absolute-names $testfile.1 | _filter_scratch
> 
> Shouldn't we check the value of the extended attrs too?
I think the first time I did this years ago, I questioned if people 
would really want to see a 110k .out file, and stopped with just the 
names.

Looking back at it now, maybe we could drop the value and the expected 
value in separate files, and diff the files, and then the test case 
could just check to make sure the diff output comes back clean?

> 
>> +}
>> +
>> +
>> +# real QA test starts here
>> +_supported_fs xfs
>> +
>> +_require_scratch
>> +_require_attrs
>> +_require_xfs_io_error_injection "larp"
>> +_require_xfs_sysfs debug/larp
>> +
>> +# turn on log attributes
>> +echo 1 > /sys/fs/xfs/debug/larp
>> +
>> +rm -f $seqres.full
> 
> No need to do this anymore; _begin_fstest takes care of this now.
> 
>> +_scratch_unmount >/dev/null 2>&1
>> +
>> +#attributes of increaseing sizes
>> +attr16="0123456789ABCDEFG"
Yes, we need to drop the G off this line :-)

> 
> "attr16" is seventeen bytes long.
> 
>> +attr64="$attr16$attr16$attr16$attr16"
>> +attr256="$attr64$attr64$attr64$attr64"
>> +attr1k="$attr256$attr256$attr256$attr256"
>> +attr4k="$attr1k$attr1k$attr1k$attr1k"
>> +attr8k="$attr4k$attr4k$attr4k$attr4k"
I think I must have meant to do a 16k in here. Lets replace attr8k and 
attr32k with:

attr8k="$attr4k$attr4k"
attr16k="$attr8k$attr8k"
attr32k="$attr16k$attr16k"

I think that's easier to look at too.  Then we can add another replay 
test for the attr16k as well.

> 
> This is 17k long...
> 
>> +attr32k="$attr8k$attr8k$attr8k$attr8k"
> 
> ...which makes this 68k long...
> 
>> +attr64k="$attr32k$attr32k"
> 
> ...and this 136K long?
> 
> I'm curious, what are the contents of user.attr_name8?
> 
> OH, I see, attr clamps the value length to 64k, so I guess the oversize
> buffers don't matter.
> 
> --D
> 
>> +
>> +echo "*** mkfs"
>> +_scratch_mkfs_xfs >/dev/null
>> +
>> +echo "*** mount FS"
>> +_scratch_mount
>> +
>> +testfile=$SCRATCH_MNT/testfile
>> +echo "*** make test file 1"
>> +
>> +_test_attr_replay "attr_name1" $attr16
>> +_test_attr_replay "attr_name2" $attr64
>> +_test_attr_replay "attr_name3" $attr256
>> +_test_attr_replay "attr_name4" $attr1k
>> +_test_attr_replay "attr_name5" $attr4k
>> +_test_attr_replay "attr_name6" $attr8k
>> +_test_attr_replay "attr_name7" $attr32k
>> +_test_attr_replay "attr_name8" $attr64k
>> +
>> +echo "*** done"
>> +status=0
>> +exit
>> diff --git a/tests/xfs/540.out b/tests/xfs/540.out
>> new file mode 100644
>> index 00000000..c1b178a0
>> --- /dev/null
>> +++ b/tests/xfs/540.out
>> @@ -0,0 +1,130 @@
>> +QA output created by 540
>> +*** mkfs
>> +*** mount FS
>> +*** make test file 1
>> +Inject error
>> +Set attribute
>> +attr_set: Input/output error
>> +Could not set "attr_name1" for /mnt/scratch/testfile.1
>> +FS should be shut down, touch will fail
>> +touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
> 
> The error messages need to be filtered too, because SCRATCH_MNT is
> definitely not /mnt/scratch here. ;)
Ok, so we need to add "| _filter_scratch" to all the touch commands in 
_test_attr_replay

Thanks for the reviews!
Allison

> 
> --D
> 
>> +Remount to replay log
>> +FS should be online, touch should succeed
>> +Verify attr recovery
>> +# file: SCRATCH_MNT/testfile.1
>> +user.attr_name1
>> +
>> +Inject error
>> +Set attribute
>> +attr_set: Input/output error
>> +Could not set "attr_name2" for /mnt/scratch/testfile.1
>> +FS should be shut down, touch will fail
>> +touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
>> +Remount to replay log
>> +FS should be online, touch should succeed
>> +Verify attr recovery
>> +# file: SCRATCH_MNT/testfile.1
>> +user.attr_name1
>> +user.attr_name2
>> +
>> +Inject error
>> +Set attribute
>> +attr_set: Input/output error
>> +Could not set "attr_name3" for /mnt/scratch/testfile.1
>> +FS should be shut down, touch will fail
>> +touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
>> +Remount to replay log
>> +FS should be online, touch should succeed
>> +Verify attr recovery
>> +# file: SCRATCH_MNT/testfile.1
>> +user.attr_name1
>> +user.attr_name2
>> +user.attr_name3
>> +
>> +Inject error
>> +Set attribute
>> +attr_set: Input/output error
>> +Could not set "attr_name4" for /mnt/scratch/testfile.1
>> +FS should be shut down, touch will fail
>> +touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
>> +Remount to replay log
>> +FS should be online, touch should succeed
>> +Verify attr recovery
>> +# file: SCRATCH_MNT/testfile.1
>> +user.attr_name1
>> +user.attr_name2
>> +user.attr_name3
>> +user.attr_name4
>> +
>> +Inject error
>> +Set attribute
>> +attr_set: Input/output error
>> +Could not set "attr_name5" for /mnt/scratch/testfile.1
>> +FS should be shut down, touch will fail
>> +touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
>> +Remount to replay log
>> +FS should be online, touch should succeed
>> +Verify attr recovery
>> +# file: SCRATCH_MNT/testfile.1
>> +user.attr_name1
>> +user.attr_name2
>> +user.attr_name3
>> +user.attr_name4
>> +user.attr_name5
>> +
>> +Inject error
>> +Set attribute
>> +attr_set: Input/output error
>> +Could not set "attr_name6" for /mnt/scratch/testfile.1
>> +FS should be shut down, touch will fail
>> +touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
>> +Remount to replay log
>> +FS should be online, touch should succeed
>> +Verify attr recovery
>> +# file: SCRATCH_MNT/testfile.1
>> +user.attr_name1
>> +user.attr_name2
>> +user.attr_name3
>> +user.attr_name4
>> +user.attr_name5
>> +user.attr_name6
>> +
>> +Inject error
>> +Set attribute
>> +attr_set: Input/output error
>> +Could not set "attr_name7" for /mnt/scratch/testfile.1
>> +FS should be shut down, touch will fail
>> +touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
>> +Remount to replay log
>> +FS should be online, touch should succeed
>> +Verify attr recovery
>> +# file: SCRATCH_MNT/testfile.1
>> +user.attr_name1
>> +user.attr_name2
>> +user.attr_name3
>> +user.attr_name4
>> +user.attr_name5
>> +user.attr_name6
>> +user.attr_name7
>> +
>> +Inject error
>> +Set attribute
>> +attr_set: Input/output error
>> +Could not set "attr_name8" for /mnt/scratch/testfile.1
>> +FS should be shut down, touch will fail
>> +touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
>> +Remount to replay log
>> +FS should be online, touch should succeed
>> +Verify attr recovery
>> +# file: SCRATCH_MNT/testfile.1
>> +user.attr_name1
>> +user.attr_name2
>> +user.attr_name3
>> +user.attr_name4
>> +user.attr_name5
>> +user.attr_name6
>> +user.attr_name7
>> +user.attr_name8
>> +
>> +*** done
>> +*** unmount
>> -- 
>> 2.25.1
>>
