Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D70EC433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Nov 2021 06:44:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbhKWGrh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Nov 2021 01:47:37 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:26916 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229948AbhKWGrg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Nov 2021 01:47:36 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AN5sr7F013543
        for <linux-xfs@vger.kernel.org>; Tue, 23 Nov 2021 06:44:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=DlO75emG/raRJckORk4juOmUEoOpss30LHoj9g0+ZOs=;
 b=zZG2qwcP//3gCfpzcJc5X37iiKM+sYPdCpbwdkdHpJf1MuEX4Mlz6RsN7lyYuTA3vSr6
 k36nWz4FjXY35XdJ7tzwfYFr8uQDWoSY9gCB8WxsQ0UVy6QAxpBL17an9w6pIduXGXQb
 p7At5aj+MnpZ8R8brpzoC3HpcQ9lnvSQBj/WTjR3/vaBtEuJLKa0HJir7JV6csG6IFt8
 aYaYc3eeUqIy3qUKqOnU86xiepJI1+0G6rGUyqsLCHIvxrFcb0qC7mgiznQX1rLxuu0D
 sTtxeEwQFxkTTWlOC/2goxiAEybR2p6H7YLl3jCRAGLB4olxaUKHzokw9//wltwZepG6 cQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cg69mf6vw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 23 Nov 2021 06:44:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AN6ecPk016920
        for <linux-xfs@vger.kernel.org>; Tue, 23 Nov 2021 06:44:25 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by userp3030.oracle.com with ESMTP id 3cep4xw04x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 23 Nov 2021 06:44:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=enl8F1QG0AZgAN0kIy50yNkzoiTi9k5Dt2TpEY4CpWm8g9LIWlDnCmQCKgEoa/MhcWpmuGbgh1OHTetUzYuwuZ9aPVpU+naNHtW7m0rAlNE0BkIlfx3AMqOd0X65sbF8Bn45o05wmkC3bvatGH5q1wTpZpf+Vkq3oUi0UaqK4bM8Y0HYiKM5DbmJNdmb+rqzesgcaddogHHrReZSBiHKHkG65Dam036M+MFe8Jaam0dPadpiRvImyu0koUmz5nOL26CGUMREZrNDuEgI3YVDSzCh5fExIsAxvlFRVusdcUwS/tbE2xag3aYFlaYeYWlw0LkX9p9KyyYwMdGwxwJ05Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DlO75emG/raRJckORk4juOmUEoOpss30LHoj9g0+ZOs=;
 b=W4wju2lAdFh3pjGhF3xPSiZz8sWu0vukuUiRJHxdZIu1YYUlJRpkgtP/TMyYeO3XdJ4kk6Lvn3sKZ2FOcdmFTql+s8jW4H2DxvFCVpGv6mlZtxRM8pUCt4W+2wUBRDgGbgyz1r6zgykMAxP2WW4Un1n2+cT54Ay/zOma5zOtccKOoh2mIeS8MTTDF/i121dmcrTndqLetCo66CBdTjsYqmxydlssoswifpL8HoLj/McMfSL1vtdDr5pPh8baYnxS/CCQGim1aCdN4J53dxTLyX1PF/W9qIMIJWoMcFhdPNYfrUHJQIsUVfPUo3WO0jM6hUab7vP8H7igMPacbndbKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DlO75emG/raRJckORk4juOmUEoOpss30LHoj9g0+ZOs=;
 b=m4uWWhbo/+QPXJcS8+C+GLxc7350CO396SHmqF5NGopQIGHW5Sioh/l3mzpKa+ZgCGpndP2LWBgAUjtZllKh2E4wGdZ+S/aiktqAmHfMqzthVXr9W9VFZFwKuJ0u7UxpaG3+Z5o2jh0XCUDLc6jUzXpA7c4Jb+uPPz0jFd8xu10=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB5647.namprd10.prod.outlook.com (2603:10b6:a03:3d7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Tue, 23 Nov
 2021 06:44:22 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2%9]) with mapi id 15.20.4713.022; Tue, 23 Nov 2021
 06:44:22 +0000
Message-ID: <062e4bf0-e037-4154-cf34-47c91234adec@oracle.com>
Date:   Mon, 22 Nov 2021 23:44:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v25 11/14] xfsprogs: Add log attribute error tag
Content-Language: en-US
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
References: <20211117041613.3050252-1-allison.henderson@oracle.com>
 <20211117041613.3050252-12-allison.henderson@oracle.com>
 <11E93260-33C2-46BE-82B1-0402CB52BCD4@oracle.com>
From:   Allison Henderson <allison.henderson@oracle.com>
In-Reply-To: <11E93260-33C2-46BE-82B1-0402CB52BCD4@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0027.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::32) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from [192.168.1.167] (67.1.243.157) by SJ0PR03CA0027.namprd03.prod.outlook.com (2603:10b6:a03:33a::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Tue, 23 Nov 2021 06:44:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf029f86-632d-4f15-4407-08d9ae4caeb9
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5647:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5647DEFD2F6730A53185AA8995609@SJ0PR10MB5647.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dxGPgYLL1lNKLhUO0ovMpKkX2N3fDyULcZJwkuxpLNmDDpbxoBy5ko1siK8qmMCOxZsmWgJQdOpN9LEHbR4NXiCCO+r5k85kBKE8/2kQHSzy7uw2/hL6IfH/K1LadYRoqfTwHHbvShJ97znEa96l0ykxuUUR66N1zZSUrZKbU9gLefbPtjVs7ZR8Ys1XFoHn3D2Y8k767P7HxLtVxMX98MGeSJWeAxGuDAk7hSqwXSM7nbqSnfEXCB12nVegJDIDOqhIoOS0nnF8I3UG0vOcJM2crN3xnlbm4xp0ZiKksnBBuXtBt1OB0kWNewB4gVjEreXhMoFh9LlgzVZZSAskX4x/X1OxkLwf7ETwYUwIgcJuSOE/uaGRJh2A7dIkuGIZ7/YK6jpsEmBDRqU8xG0gbVELpYmmbMHM43LpVqbs5ykXOTKbPyljvCJA7EPjyVSRbGcm29YpG0mcLNMM1RN+6NtaTZRi9X1lz8s1G9ja5bUEaUVCSPYRjve+ZY99qmbBqAAOuS1a/f0LMIw0MStOMqkmNdZSrW5BqALfZW7egmXXG6+jiJ+QBuHXa/XridCvHf0NcJ7pbvbdKaZ4090A21zgWXQiL8eT+t6/YzcovBuQTvupgNfqEaZgNvMsR6YwtSL27fnThUtZuvrSacX6TVvPF/a5kJy/hJOfGrGhGa0nISOCHucip1j3hUE9D8/9V4gSWdvSaR2qpNotnXmV/yjW1cWoprxEy5u1Nr5xXtWcsa+wIj7gBiPRDYY5u7CHW6LPpWiYmL5eFN7tq3iKiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(37006003)(53546011)(4326008)(5660300002)(956004)(508600001)(6486002)(66946007)(6666004)(86362001)(2616005)(44832011)(16576012)(316002)(38350700002)(26005)(52116002)(38100700002)(8676002)(66556008)(2906002)(83380400001)(6636002)(31686004)(36756003)(6862004)(8936002)(31696002)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a255OXV3dWJRYVFmY1l3dVQwOHV6NFlCcDdMRmRjQW1FbGV3MXl5aW5YQmwz?=
 =?utf-8?B?Tm8ybHJ3dFlneDhqQy9mUFMwMUVvenhpeXEvM29qVnQ4aDJkTlkyODJGY0l6?=
 =?utf-8?B?dW4reEpBVnZ5Wm5EQkZzTFAxV0szUGhBVUwyZFRQM0hsYTRIS3VpK04rU1l2?=
 =?utf-8?B?eW8ycDdLa0tMdFQ3OTRSWWxpamVMNWJSaGkxSkZYeTJmQ2lkWjVXRE9kWW5K?=
 =?utf-8?B?QUFQYjk3NEt4YmR4UER0T3VOamlYV1hEUEdFb3FkaVhBbXNaUytlTnNENUlw?=
 =?utf-8?B?WUZTNzZpU1ZYTGlQbFlTT2RGTjdOem5MWW5PWVlzWEV6eHRlbW5GeFlHcEtx?=
 =?utf-8?B?bEw4Z3IveG1IaW5NRVRoS2pIWldoV0s3Uko0YWdyclR2YmtLQ2lZMHNPaFVx?=
 =?utf-8?B?VlhJR3hhZ3dkNDZ6T2FQb244Z1hUdkQ3Y1BDbkQwTzlCNDZhcnpNMWlZczd2?=
 =?utf-8?B?Sy8reW9nZU5ScWxuL1dkWlpUYmpLQyt0WlRMZEQxclFSOGd0WU5Gc3g5dERT?=
 =?utf-8?B?eURoemJEN25JY3lVRmNyQVl5MzVFZ0srUUFqZEI3Ynp6dTdqZXRMUDcvcHAz?=
 =?utf-8?B?OEVtemJMM1pRMlhCQnZxOHRHNzYvWjhsZjNTelZDT1Rsd1RvTlNlT1c5cVJW?=
 =?utf-8?B?MC9LaTAvaWJsQmUwY3BweVl0VXVra1p3VFV4MVpPdUJKOTVLVTlNSjQ2YWtF?=
 =?utf-8?B?bGY3YWVNOWZuNGVFc2J6UU1jeHlzQjFWYW9GT29XUE5lVGcvb21HMHA1QzBk?=
 =?utf-8?B?Tng2Wld3MzlLak9nWEc4ckhEQWFTSXZPWk1wRnhPL3I1ZDlkVGN2Mm93VXZy?=
 =?utf-8?B?bEgwWCtaVEZJd1crUXRVQkdETjJHd3p2UUhHS3ZOa0hOemNHMlI5K3Jxc1Vo?=
 =?utf-8?B?R3BoblVtR3R3MDVTUkJJT1lmeTZxM01FMHhBdGNLajlCQnpEa0p4SkdzM1JI?=
 =?utf-8?B?dzQ2WXVRaWxxSU5FRTU4VWdEbmZ2cWwzNEYxMjhLQTdNTU1VZUtSaTliODZX?=
 =?utf-8?B?VmRhUHlNcUpmdlFMbkI2QU1QVC82TWU4U1p0MGpydlROMXdNVXVUTlBNTjB3?=
 =?utf-8?B?NjdRWE1UMzBBV1NHV2lENEZEQXZMcWYwbkU1U3ppQVJtdnBVWVBHT09IeXNU?=
 =?utf-8?B?ZmxEaFNHUFU4M0tJdUw3NEI5MCtBQWQvcHlmbG1KMnFRL0Jodm5LU3JFaTFM?=
 =?utf-8?B?K04xdmdxYjQ3T2JzT2N5Zm1nOVVab0JCbjdMQ2padDRnZitURE94ckJHY2Iy?=
 =?utf-8?B?OHZLS01LaU40c1pNN05zajd3aUhwY2ROOFVaWjR0T0dYa2gwei9NNlVFWWlR?=
 =?utf-8?B?VGZnNS92dkhFdWQyOXY3d1JqS1ZwWWZCY09QUGRTSjRUaS9oTUNOeUJid1c4?=
 =?utf-8?B?ejR6Mk1DdXJPRDZqa3J5Mld2Z2NWZDZ2ZklncHIzRDhpbjdqWGV5ejh0aWNy?=
 =?utf-8?B?ait2VzFpN0dta1ZQU0RJbDZQSW4rd0dUR2lscnJWU0ZrT1oyaFVGMHNkekdk?=
 =?utf-8?B?eXFFYXFjRkxKaDkrSGJVM0l0eFh1Smc5cVB0cnZPTGxDcGQxS2VjVVpjS1NK?=
 =?utf-8?B?blF4MWU5NW54MHV1NzNyMWU0cVRtd2h6U3RQLzdpbjVSclVkRXZ2d2pFMGVS?=
 =?utf-8?B?NTRxQWhEK3kyNm03UmhmV3ZDR3ZtM04xVGhwaHF0NTRTdm1NL3RCNGY5czFv?=
 =?utf-8?B?TjFrb1hWOFZwbkRiODFsQzE5UGsxaThEeVRoOHNaZEU3dWh3SURrTzdFOVZa?=
 =?utf-8?B?Y2d5eVlZc3lGTHp6YUhZczN4cXQvZU96TFN4SkswR1dTNWk1a0NQWDdnWDEz?=
 =?utf-8?B?ZUtPYU9vZDFNbXNpcWRlbXkwZnZiNUxPOGUvQ2hyZXNkMXZhWEZwUmpzUXB3?=
 =?utf-8?B?WGIrQTdkdUYxY0MrejhMSU1rWlhobEtwdzluVVZ3ZkZ0Y1A2bmpVb1RrTXB1?=
 =?utf-8?B?OEpoQlBrcEV3V1pvUURiMHJBNks4cDdqOXU2MzY2Qm15VU40NEo5SC9BcTdC?=
 =?utf-8?B?KzdnUDhvaEJsQnJoYmhGSlNaSmpIT3dIVGFkK1JmUHpBS09xd1FJcWZMdFpv?=
 =?utf-8?B?SFZ4SndDTGFjODFUZ2hsWE9URnVWY21HRm50ZHpoT0pmQ3NDcEY4R09qNldQ?=
 =?utf-8?B?TytBZUxncEwwMWJEYnV0QXNrKzMxVGoyd0VDNjRBS1JCMDVEQXp1SHNnZXdQ?=
 =?utf-8?B?SWtkeEdYVkFzaU45SXdWOGNMTVVTVHlXWFNWbmMwRWt6ZjRHaThwQ1E4eXB4?=
 =?utf-8?B?QzgyNFFjUEpKWHBCRVVRcTBMY29BPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf029f86-632d-4f15-4407-08d9ae4caeb9
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2021 06:44:22.3692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VJGuG5EzWA/QFkfhaTsE/ohPo0IVOCNgMEykGKMInBXEFY+c4jhesP7XTFVojbLb6ocz0aCj50dcCEahMkpXmREgt1kHtOTqLrcv9IpTOTY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5647
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10176 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111230031
X-Proofpoint-GUID: 1nZ87SKcmNcdCLYl4jeKPs5QpPfe2rrA
X-Proofpoint-ORIG-GUID: 1nZ87SKcmNcdCLYl4jeKPs5QpPfe2rrA
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 11/18/21 4:23 PM, Catherine Hoang wrote:
>> On Nov 16, 2021, at 8:16 PM, Allison Henderson <allison.henderson@oracle.com
>> > <mailto:allison.henderson@oracle.com>> wrote:
>> >
>> > This patch adds an error tag that we can use to test log attribute
>> > recovery and replay
>> >
>> > Signed-off-by: Allison Henderson <allison.henderson@oracle.com 
>> > <mailto:allison.henderson@oracle.com>>
>> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com 
>> > <mailto:darrick.wong@oracle.com>>
>> > Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com 
>> > <mailto:chandanrlinux@gmail.com>>
>> > ---
>> > io/inject.c           | 1 +
>> > libxfs/defer_item.c   | 6 ++++++
>> > libxfs/xfs_errortag.h | 4 +++-
>> > 3 files changed, 10 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/io/inject.c b/io/inject.c
>> > index b8b0977e139e..43b51db5b9cc 100644
>> > --- a/io/inject.c
>> > +++ b/io/inject.c
>> > @@ -58,6 +58,7 @@ error_tag(char *name)
>> > { XFS_ERRTAG_REDUCE_MAX_IEXTENTS,"reduce_max_iextents" },
>> > { XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT,"bmap_alloc_minlen_extent" },
>> > { XFS_ERRTAG_AG_RESV_FAIL,"ag_resv_fail" },
>> > +{ XFS_ERRTAG_LARP,"larp" },
>> > { XFS_ERRTAG_MAX,NULL }
>> > };
>> > intcount;
>> > diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
>> > index 594f5e92e668..5392a1bcb961 100644
>> > --- a/libxfs/defer_item.c
>> > +++ b/libxfs/defer_item.c
>> > @@ -131,6 +131,11 @@ xfs_trans_attr_finish_update(
>> >     XFS_ATTR_OP_FLAGS_TYPE_MASK;
>> > interror;
>> >
>> > +if (XFS_TEST_ERROR(false, args->dp->i_mount, XFS_ERRTAG_LARP)) {
>> > +error = -EIO;
>> > +goto out;
>> > +}
>> > +
>> > switch (op) {
>> > case XFS_ATTR_OP_FLAGS_SET:
>> > error = xfs_attr_set_iter(dac);
>> > @@ -144,6 +149,7 @@ xfs_trans_attr_finish_update(
>> > break;
>> > }
>> >
>> > +out:
>> > /*
>> > * Mark the transaction dirty, even on error. This ensures the
>> > * transaction is aborted, which:
>> > diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
>> > index a23a52e643ad..c15d2340220c 100644
>> > --- a/libxfs/xfs_errortag.h
>> > +++ b/libxfs/xfs_errortag.h
>> > @@ -59,7 +59,8 @@
>> > #define XFS_ERRTAG_REDUCE_MAX_IEXTENTS36
>> > #define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT37
>> > #define XFS_ERRTAG_AG_RESV_FAIL38
>> > -#define XFS_ERRTAG_MAX39
>> > +#define XFS_ERRTAG_LARP39
>> > +#define XFS_ERRTAG_MAX40
>> >
>> > /*
>> >  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
>> > @@ -103,5 +104,6 @@
>> > #define XFS_RANDOM_REDUCE_MAX_IEXTENTS1
>> > #define XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT1
>> > #define XFS_RANDOM_AG_RESV_FAIL1
>> > +#define XFS_RANDOM_LARP1
>> >
>> > #endif /* __XFS_ERRORTAG_H_ */
>> > -- 
>> > 2.25.1
>> >
>>
>> Looks good
>>
>> Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com
>> <mailto:catherine.hoang@oracle.com>>
Great, thanks for the reviews Catherine!  I will add your rvbs :-)

Allison
>>
