Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27204C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Jan 2022 18:37:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347998AbiARSht (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Jan 2022 13:37:49 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:4578 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348164AbiARShr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jan 2022 13:37:47 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20IHSilc024422
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jan 2022 18:37:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=GaEbPm9pB79F8m0V1j5t0aCnM6WqoxqXrjA0Bc67s4Y=;
 b=Cjov7GF+UbwpdFWB/K6PdWBskSRpWwTKQaN41+ukW1vjLzGWjrWCii+6BJVnNE43KK2p
 URbNG3ArkjphIaM5RfGKFHA9rChICpwj1IWiak70tACFSKAX5hYRo9EKvv5Hqmi2jtu5
 Bpa5EgKLR1bYTbMw5oCtISuS0pMcQy6yJ3T23n/UVeRazfUw5O24zT6vE3ED8Sj9G30/
 IDMd9NsAfmAZlrZ8cAUYKeOTDmtHlGe+bD7aSyctYaoGou9s65qL1BXeRP4wzvcgM6Vb
 vKyymlMM5iP7Sb4XirPBxJHUAMl+yzbXAxv9SN1F+RdzPUvB6mP/vEwnWdCl3VfMy14V iQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dnc4q2tfr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jan 2022 18:37:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20IIa2RX131281
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jan 2022 18:37:45 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2045.outbound.protection.outlook.com [104.47.73.45])
        by userp3020.oracle.com with ESMTP id 3dkqqnvp44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jan 2022 18:37:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vay8t1/3oKhJXaEHugiIDlAD2bKXjCBbdAvx3LJuQrqrAG4D8KXWfQGg+w45JLlLC2tZ720xbs25jJ7uNBf2mf4qEvCuPW948DgN+OUXj9uAqLN7ys/+Jn98L6JWPhnAdbB5T8oNdRzJsBSyj70i7/JGWxymYpqwMlelaTtkhEVLCFDQswfn6+D2wOd2lWunIwr20GfyKW3woqmtCdwubhF6zRkHu9YlgAW15Sf0QgjJqAfOwTRGcwDQ8JYvtLsx7p9PqQ5DXUBHq6jKCcpVGvTPh5EwhjXVxubHJMfj0GLacoMS9WhZzH25XXwVyy625QQKKk4IZ9jIa8A0gkFSag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GaEbPm9pB79F8m0V1j5t0aCnM6WqoxqXrjA0Bc67s4Y=;
 b=mY6Nw6tppYGQ4l5fVDj1xtQwEzKG9m4LdaicfUKWBAilm4ltEvTnwBF51aHylSA/gOJ/RDqNrb1BMgefz36L22F90FMZ1y11mP6ExhjE7KWzApHAGuAwdkMqAzt+C7YpeQ+Qu54Wb4H6H7evIdyNQyGx/v3hGGer6wJo36cBJnkeSrmF5Woe3kCc2VFij+Apbp3fsLoSrPjQuJIui1dmjvGd6ebw+D5EBEFPCA+BiENJA0qjJvWTrBqkUwNVvunIE/nhFb8BAI7ezdcDeTX5DMdIsrE7kxlSvuYeydKNWGIJDa7Px8qSrEqENacVSWOlVgHo49wlxQd+6c83iy+zXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GaEbPm9pB79F8m0V1j5t0aCnM6WqoxqXrjA0Bc67s4Y=;
 b=GBsie6B3eYIUjbO1Q4iL7MJp+shV4GUDv9dP8b+iOpOvnp4XvEfFj4gcLMAzdaaCDnZzzSz/+phGry7UFFndq7jEF8YJGiM0JxPAPY8KHXPbj0Ywd+o1bIDqZ7PAciZZlrNq/fl/k9wr8bGlRlFZFIH+8ZLvSd2PXS94jEaGeuI=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BN6PR10MB1777.namprd10.prod.outlook.com (2603:10b6:405:7::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Tue, 18 Jan
 2022 18:37:43 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3c8d:14a4:ffd3:4350]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3c8d:14a4:ffd3:4350%8]) with mapi id 15.20.4888.014; Tue, 18 Jan 2022
 18:37:43 +0000
Message-ID: <767e861c-10ea-0aca-bd4b-590a1d01910d@oracle.com>
Date:   Tue, 18 Jan 2022 11:37:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [RFC PATCH v2 0/2] xfs: add error tags for log attribute replay
 test
Content-Language: en-US
To:     Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org
References: <20220110212454.359752-1-catherine.hoang@oracle.com>
From:   Allison Henderson <allison.henderson@oracle.com>
In-Reply-To: <20220110212454.359752-1-catherine.hoang@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0175.namprd05.prod.outlook.com
 (2603:10b6:a03:339::30) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 43576e26-723c-4840-b34c-08d9dab19d2c
X-MS-TrafficTypeDiagnostic: BN6PR10MB1777:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB1777117F5FE039B416F6DBB995589@BN6PR10MB1777.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YkEP+xHYtURx9F1VDDf/Kt5gy5MSoWhskfp63IP9hyGnoWyWI8Wa0VoZtBpP0grlZslz282+bP7tkJWOkhJpbrDgX344sIzDWTu8CSgS6h/6I9cNIQuoyqyY6cTql21KqtsdaRBsNKxA5SVd6rRyxDNF5crl0EZdvNOrd/LkfiEBywAQRekHsz1inuhJmAj8/+wTMEfNZU4XxXJ+7DA3aodyGZB39d2Wqy1qslPNM7pMkD7GlXNCQxEjf3kFnVI/QDL7ro4pvQq6fqhS81TrSR1MPUorKRC7Urf532nP1YArWUwIjUR1jIzZNktQO0g3RmaAMd5JDV8E4QJ3jpxJbQPFrDqAtJLwp606V9VZQgiPm9CHOsFE1l+fKYoICfGdEcGGgracmr2v5cFfXLoUth8prAHaPHupi3LS8XZCY+Z5N+MQ7SQhiOIxKD9Vfil0LjbKaYmH9IDe7HM0rm6id4ka5YUfhEsYSu5Y+kDwRE/nuxTxxVLmmk56acB3hPMj6E9Y4KBJD7kEeOXCOw6Wtoqf7/sL99gdWamDQgKoRT9uxn82mg32em3rJ1vIy+KyaIqB8RCqONmtr9XRiulwPyy8DaMRK2IvILC04SLvxeC44fHt2bdyH23PEMDX+JAxdxC+h31tnyID++cFJoOeHV/bSX9l31Oc7Hvr+eMVpQGuHEw19o2p3t+kEHDBxSFv9EaufML3A5Fqdar8Q22IT4dk6E5jFqz/gnftVO7btI9v0avOk89n2hvZm79DoqXM304cln+UPdgL0SxySpxkyjFGr3jd2tRm8Uo4aS7z/DMzERsIww0TJnmLmwxwPgYosg0PPlxcAVCLWjalAA1IdT8Ytbw6i2ecBYf/pZCJ9CM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(31696002)(31686004)(6512007)(66556008)(508600001)(86362001)(44832011)(316002)(8936002)(2616005)(8676002)(966005)(6506007)(6486002)(38100700002)(38350700002)(36756003)(66946007)(52116002)(66476007)(186003)(5660300002)(26005)(2906002)(53546011)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N25ZbElrQTdUclhpNnU2a01NOG95VFRUcGs5WDBTWThWSmFCaUMrejhPd25t?=
 =?utf-8?B?NkVxZXV5ZkZVYTBySWhkU2sxQS9LZzNhK1NzQ1RTdGVqTzMwRityZnBYeWg4?=
 =?utf-8?B?Z1hNdFI4REo0dVhjVmwyM1hIbWhRc0JVWXNPczM0VXRiNnJQbGxQYXlEcTBL?=
 =?utf-8?B?UW1ORFFYMEduc3ByUWMzL3ZmRER5dElDWGNTbUdoaXFPRWsweDFLRkdycGNQ?=
 =?utf-8?B?TVNMR2tEcTdIdWhJS2NFRVZqV2FFYU83VG9iRjJzOTVVb2lGUElkUXNIRHNo?=
 =?utf-8?B?aUFhQUtnOHlCU3l0UEQwVTZaTTRleGNXWGx2TlNqbVpqQWRBN3FTSW02NlhR?=
 =?utf-8?B?SzFwMW5tdUYvbHdVQllHQnNIMGxvUk1pNWtBbk90cWRWKy9Va3Fodyt6TG1x?=
 =?utf-8?B?RUZOU1JWRWhjOVNSZjM2cVZEdlVLTUVjZFBEQ3NNOVVNa2E1d3lyQ1BEVElP?=
 =?utf-8?B?b1B4b3FzRDZ4M2lkUm5BNWFpb1A4UExhQVI0Kzg0R2xlOHB0ZldKUXMrdXB3?=
 =?utf-8?B?aGxUQTZ2a3VWRHdQL0JCemNQc3hRWFlnNGdSUlBuRHhuUkVZczQ3U0U0TGFP?=
 =?utf-8?B?N01PUXcveUR5S0Uzd2RNTFRPZldNaS9ZUG1vMmFjRXVHajMzeVIrV01XMWFN?=
 =?utf-8?B?VHAwN0pKZEg0Y09iM0Z2WEhhdXVrSlg4YjhaSHlkbUtPNnZybDFKMmtIR3Z6?=
 =?utf-8?B?ZzFKTUU2c0tzSUpNeExTL1A0OEZSSnMzdzlDeUFiZGZFc1Rra0NVa1pCQkla?=
 =?utf-8?B?bTE0UDA1MGhuMy9ZWFQxZ21qSDNMSGd3NUcvR1hEMUlnOFZqLzI4d0JqWUpn?=
 =?utf-8?B?cXVseFdzVU83L292UnR5WDNxeDBkd3JCcVZlbzdOZGNJMnM2bXlob0VBb1NH?=
 =?utf-8?B?R1AzWUVGVDBpY1JxMzNUVG5XNnVYaElva0dRZ1ZSVUlnbkY1Uzk3T0RmZTNB?=
 =?utf-8?B?UlJIcEpNRmY0endFRXFMK3FpWTdlV2R6ZjlSTTNOUXQvVXcwcm5DT0V0eEoz?=
 =?utf-8?B?c2VLR2FOWjFVT2g3am8xd2kwSEJMbVE3SEl3L3VxTGVieFlrRldMSllvS01S?=
 =?utf-8?B?NEVwV3RJWC9CUW50T0Q4aE0zQWNVUkpQTWJVbHdIUUpDdVNXcEYrMHIrTGdN?=
 =?utf-8?B?TVRyQy9jRDEzYlY0bVg2Vm5NWExWUXE5b1RCYktvSlVkU3pQcGlscXg4dnRx?=
 =?utf-8?B?RHVtWk8xM0pjQnBKTFlkQldmRkxwa0c1TWZrSTJsYm44NFVROEowRjhtL0JU?=
 =?utf-8?B?aytId3V2S3RuTWNNL3UrTU12OE1nU2wzcFFwTUx2YmtDZVprWVZWWkZXTEVL?=
 =?utf-8?B?WGpISGw1aFBsaFRSclByNCtLK3orUW5FUXAyZXExU0ZJY0tVaVhUWTNqQlFJ?=
 =?utf-8?B?ZHd1bVJtM0hoSGRhVlV4SUVwdEVuc3l0c1pkNWR1a3ZRbmM3Ym5oY3BibGpE?=
 =?utf-8?B?Zm55aU9GWGpGRC8yNDFSMWxZNlJWSW15SUN5TEw2dzRYdnY2eHdIRFB4VjJt?=
 =?utf-8?B?QnZnSFdzZ0pUWFJ0cFJRL0R4Q0NBcWFvMmljQm9idDhqNzJKUkpURGM2NW9B?=
 =?utf-8?B?WDE5VVRPQjF6TTR5cUVUWlJKdkIxZjhscThOcnU2U0NZNnVVWmtqQjNCMjZJ?=
 =?utf-8?B?Y21VS3JsRGt4YzkxY3hxT2xwS1pLTTAzcThyQ0J3VGF6eldqWnRrZXcyNnU3?=
 =?utf-8?B?d3FiQW9JZVJCemkwMjVwaEg0aENtdk16UEh4OHNNWVRaT3FnTGtBM29JK2pJ?=
 =?utf-8?B?LzdORzVtblhsRFltZWFXL1BGZy9hZzBCWjM0bkxpRnBjbkZZYm1nMEdEUmwy?=
 =?utf-8?B?NWx3M1RGNFdRZHdTNDRsVlFaWTRlb1FsbmVRTnRnVVE1azZoQURjbzJQQVhW?=
 =?utf-8?B?N3RlVGR2UjFnZUdhaUFOcVpjdzZaSjJUYkpFVWUzUGxrbmFmYXpiLzc2T1B1?=
 =?utf-8?B?TE1BTW9vWWtnV1hDRGxjdHd0U2xGRTd0emE1SXkxeWpUYU1Wc1VEQkZuOWdy?=
 =?utf-8?B?dTBhZUxMbmYySDI2ZTlCMHp6bXRhS0V3dkdNcGVVcVVnZjhEWFFLY095ODFH?=
 =?utf-8?B?N0w4NkRCZU9kYnl3QTlKdlRLb0ZURDk2TWN0YjNDSit2UDNMczBMdHJvcjY5?=
 =?utf-8?B?bGs3ZlZnZEFYOFBaNFFRa3liWW5wZkNoYlVmQzYxWjhJUjNuT0RTSmJsc1lz?=
 =?utf-8?B?MXVhTit6aXBudURncy83ZGRWK3dWejJMOUZCRGc2d3VTM0ZyS0FFeTNoeDZ6?=
 =?utf-8?B?MTdCWWZlR0Izc296aURsa1lHaHVnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43576e26-723c-4840-b34c-08d9dab19d2c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 18:37:43.3154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dk7J/F/vSQewJI66UkvJpXOrFP7tC37XqPQSovy72yLOwSXvMDnQOElZeelk0aKJo2r4BTyPxvKF1HG2ALZRBBfCYnh1eYjjk0/NGgf48hw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1777
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10231 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180112
X-Proofpoint-GUID: H-Xe8C__6DqNAIv6X5OkmTxzNiWGZBLl
X-Proofpoint-ORIG-GUID: H-Xe8C__6DqNAIv6X5OkmTxzNiWGZBLl
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Catherine,

I know I've already rvb'd these, but these all look great to me.  So, if 
no one else has any complaints I am happy to add these error tags to the 
larp series.  I am getting ready to send out another revision soon. 
Thanks for all your help here :-)

Allison

On 1/10/22 2:24 PM, Catherine Hoang wrote:
> Hi all,
> 
> Just wanted to get this sent out again after the holidays. Original text
> below:
> 
> These are the corresponding kernel changes for the new log attribute replay
> test. These are built on top of Allison’s logged attribute patch sets, which
> can be viewed here:
> https://github.com/allisonhenderson/xfs_work/tree/delayed_attrs_v25_extended
> 
> This set adds the new error tags larp_leaf_split and larp_leaf_to_node,
> which are used to inject errors in the tests.
> 
> v2 changes:
> Updated naming scheme to make it clear that these error tags are meant to
> trigger on the attribute code path for a replay
> 
> Suggestions and feedback are appreciated!
> 
> Catherine
> 
> Catherine Hoang (2):
>    xfs: add leaf split error tag
>    xfs: add leaf to node error tag
> 
>   fs/xfs/libxfs/xfs_attr_leaf.c | 6 ++++++
>   fs/xfs/libxfs/xfs_da_btree.c  | 5 +++++
>   fs/xfs/libxfs/xfs_errortag.h  | 6 +++++-
>   fs/xfs/xfs_error.c            | 6 ++++++
>   4 files changed, 22 insertions(+), 1 deletion(-)
> 
