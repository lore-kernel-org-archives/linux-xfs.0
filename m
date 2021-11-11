Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF905C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 01:37:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACA9E60EE4
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 01:37:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232528AbhKKBkV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Nov 2021 20:40:21 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:56658 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231312AbhKKBkU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Nov 2021 20:40:20 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AB0qbac032063
        for <linux-xfs@vger.kernel.org>; Thu, 11 Nov 2021 01:37:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=W8jjxu/g9bVK8v4lX8/tVH9f2qbsftqorpO/9aXt5pU=;
 b=kjtQMYHcgOiN28hUJZU3f2Nnf+rgz2Sc0A3bWlke6lodQ14iB1k1XkaQwLSqvat870cy
 eB25KfdNEJ9kErJuxPjzCiVpQ+JzNHQUjdGI2YTxgBKuOaCc+YKcm+oG+YRuRfPIk2kE
 96aTO6L2fNSrk4VLblbh1ZYu98LATli47uwIOdNLNRKdkJ6foc1UThLxJzXKUp/+Y0ZO
 0NCZUmXaW3myzaxmTTnT/XN0FwsG2bdVz+IoPrCxQHFfAlkIFHRzC0dnY1vXCd7sFXtz
 Q257n2r1zjweqNelu8vGDPFBWbaRJniZEH2vFGgysiLli3XRULxLDD3MKg4ixvlL1uZO zA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c89bqf5dr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 11 Nov 2021 01:37:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AB1aj6U019328
        for <linux-xfs@vger.kernel.org>; Thu, 11 Nov 2021 01:37:30 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by userp3020.oracle.com with ESMTP id 3c63fvk3jn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 11 Nov 2021 01:37:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ebYeXhvGSrI5qfPQ+7AIRvJeSDkJ24ip5bGYJbfobGhI3BXoFwMsg9EIUSQSy2IKfIUWZdF/uy5XMNeDFmzNgsVrYD5nAaDOo5J51pFeFk3SR0woy0Lwy92iRbHthfjaiHXNru1ouu4xuLUy0iefcZocUpJIg9tLoPeL0cxzxb7K094omBN+eucTHzVxHKcDKxGl8fZ5OiGD9jd4YPc+GGovFT8JNeqcYapqVQkPAWe3l92EYQo6mX9qITfWswKyLbJoiKp2nlKr753Qot5Z3Gdv/d/++luabX/Mg1uHJlw05/RgeMf5NUcCsoTN2ttkcw4ar6COH8eyYMeYKA6Chg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W8jjxu/g9bVK8v4lX8/tVH9f2qbsftqorpO/9aXt5pU=;
 b=Ja8Lotljt6WSais5+3XPL/KoKXn5u8zPfurSgLu9+a2ltVbKjnuLHCVq+4ANlnXoUWPl+eoZ0MO37OHdqajyF/k7bjtmM0XPTer4nQE4Yy3B/m2BVWH7dk/HizUqpDfaLDOJWz+vAG/QKMWxxDVMN8/FfFCGTHH88Slp0WwTfQAMqAqPzB2+OeS4LFbiYjRazQHF5RsTLgjowijw8V5Qm9wfMOHByFdqYnWa6VE2q9PDvCYIs4g+1bKHfhBJjhhixR0sjl5LETpK+AYqEvwc1VblQT9JzL4CVDT/dw4q1OAkqAuKKRq7sdoIuZEgx6RhyK1jr3gUpcGSfSARYc9wkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W8jjxu/g9bVK8v4lX8/tVH9f2qbsftqorpO/9aXt5pU=;
 b=vx/YcXK+Uq9B+Kl0XLsvFnDWY1/c7jcowO3SP4bIz3oOHBqwEsfOaiZ5pK5K9CVBSS3rSRdIXtcGPmwiCi6g+ohEdCLy2x0eianIoEXYgBTJaz54RzzRdCNrnu/wVy2sxaNrd2cHOXeIGF7NEmzb6TTG13R0s86L+SIBsgiIl6Q=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2647.namprd10.prod.outlook.com (2603:10b6:a02:b2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.15; Thu, 11 Nov
 2021 01:37:27 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2%9]) with mapi id 15.20.4690.015; Thu, 11 Nov 2021
 01:37:27 +0000
Message-ID: <3c74fe87-ef85-a040-cf2c-f10f23902361@oracle.com>
Date:   Wed, 10 Nov 2021 18:37:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [RFC PATCH 0/2] xfsprogs: add error tags for log attribute replay
 test
Content-Language: en-US
To:     Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org
References: <20211111001112.76438-1-catherine.hoang@oracle.com>
From:   Allison Henderson <allison.henderson@oracle.com>
In-Reply-To: <20211111001112.76438-1-catherine.hoang@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0133.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::18) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from [192.168.1.167] (67.1.243.157) by SJ0PR13CA0133.namprd13.prod.outlook.com (2603:10b6:a03:2c6::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.5 via Frontend Transport; Thu, 11 Nov 2021 01:37:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b1fa2ae-149a-4402-a3dd-08d9a4b3d183
X-MS-TrafficTypeDiagnostic: BYAPR10MB2647:
X-Microsoft-Antispam-PRVS: <BYAPR10MB26475C1A0B2F022C7071FE2D95949@BYAPR10MB2647.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v67cT6EwGx6ekn+TFWJtiH0Ue0ECsgOaMR6sMNsT63qog3PiNp5FOMItsEn/HSnK7kMSrSFLK7nivCBF+e1bL4bh+poqd2Tv21oN5MkelhUXOEgjPg7dyzj5Rz4oedajV8hKakEGbuqOtnXnT3K5SnHvjxBUFjVxikXrp+BVDOcZtp7X0ktIeMReCxNpU4h9pkSpsmRhDG+cYSjTlBy1AKrkLMql91QviUqsIXzBv9HFiUXie9zDGR4Dik8sW7np2DKxCxVS2uxdr/H0FbF190DuserH0pz/wE7ETKNAsIFd4PLB7YXtywkNbO246seBu3EdGtyOM4WAoVGNtFg3SRyfBjvhoNreGMw7v+U16brMePzXlToYuTf1ZzHdJ05Xj1nIPqTCKZm3jPYap7EDu3nULtoTX1dZBLYz6G1xYWo+Y3Efo2I65pxFNA28anRDfDvSK+x/bdf0kCkPVnlY5FeZ2KGZYCE6IeDARmWhfqVJS0HX5d9K1PuxzsXP5AN2KeCnyMBRmjqOh3j1MGxfp8y/9Ww/T7ja1sotqvRbqmBkzt55+gSznRYKNtp3U25qoD0GWFwoYQExGKXH5DzS44CogK0b1plE8UtcCgpO2wgS/OQEmXFtw6t9hPpU/0booYn/yuTO1zWgeqJ/s8GrG1q1AqgQk4ciWv1unmrQvMM3HNhmQ3ta2GblZsPk9jCwa+givQ9o7GlDMPx5H89t0eV8HLHsk5pojfTPOSXWURRT3oMEIPcMoagRnoBvUFFh2fsLQ50wDaBs4pnRTvFA95BmPN8MUlN/NOaYSuZhJcXF901BIj3twz4cCyWq4sLNytRgFDZd94AqJH3HMs7LEZYfGVc5HaaS75El4Woq66k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38100700002)(38350700002)(5660300002)(186003)(16576012)(31686004)(44832011)(2906002)(966005)(83380400001)(508600001)(956004)(8676002)(6486002)(52116002)(36756003)(316002)(2616005)(8936002)(66476007)(66946007)(66556008)(86362001)(31696002)(53546011)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TEhCY1d5dkRpMXp6dkJZWnBFaGRRUisvNndXR0tEN2Q3MEp5SUp0SFk5cnFq?=
 =?utf-8?B?U3RZbS96QWdZU3BzQmc5NUF5aHY0REMwTWY4QnNFSlhCbzdYUjBsblI1WFA3?=
 =?utf-8?B?Sk9WUzVyeFhBQm1XbmZmRnZqblc2SWkrNmhCejRMVWJtbTluT1RnOEVvemlZ?=
 =?utf-8?B?dk5iV3o1Nmc5VTJGSGZqVlJqK2g1UnRYNzFZRGNSS1ZIbnNhL0FYNUpOaTFs?=
 =?utf-8?B?d011WWxuQnRsK0NSaUpSTXo2dXVJMHJ0Nll0R0tCK1UwYks2TXRvVFljc2lI?=
 =?utf-8?B?YWJCUi93eW0vUTkwVXNJL3BmdE1kQ2YvWEJ2V3RFelRkTEtKQ2JKYXVud2lj?=
 =?utf-8?B?NjN4cmVhYkNnaExxT0MxSndnQ2pZWDJTbUorOWVHSVZkTVV3clJjQy9hR05O?=
 =?utf-8?B?RU40ZGEwTzArcDdRQXc4VHhSd1BLLzF4c0IzbHA3RXhlajg4RTY5ZHN5SFRv?=
 =?utf-8?B?Sm5ndUgvd3p0OVgwTkpuS2t6aDgwT0d0NHVmOWxVMXFMQ1NQL0tWWFpzNVMz?=
 =?utf-8?B?VVZsV0k2MWFXWTFvZDdLRkthMGlLcmhqMjQrdGNvWFdxenpiRXc3b2JwYUdV?=
 =?utf-8?B?VUlSOWtoLzl1N3BPKzFPK1FlT1VGQ2hxbnJXZ2NyUXBxYWVESWNCdlVEUXY0?=
 =?utf-8?B?Q3NnS21FRVA3Y09pNlN1N1RxZ3JmV3RZcFFrc0NabWtFaVorME5uS3pvdkNv?=
 =?utf-8?B?SnJ3RTRPN2Q2TG1ycVdEZ0hBZkJTcmtrMXkzNmxxTVMzL3JVbDB6S25XR0dB?=
 =?utf-8?B?MkV2Wnk3V2w3UTcybVlKSi9uTkNkRlBxMG8ySjk3WGNGeDc4clMzbjhsZWxa?=
 =?utf-8?B?SVNFdkhFL1dGbnNrMGMvNndyWWRjMUp5TmVuNUlmY3BJT1BsYzR5bFZmdjNs?=
 =?utf-8?B?Mzk4ZmZ1bm9QZTIwQklEdGZGM0R2OUhBVjl6dXBDT3FVM0lVN1JWNGwzVmZo?=
 =?utf-8?B?QVhUNmwvdFpVOTZWOTFGSm5tOUMwRTltanNQV3orcjNMTVkzNUhRS09vV0Q2?=
 =?utf-8?B?VldTRGZxRVdhN3dNOS9HeXdxOGlCMVgzRkFHNzhmTHNWanUwNU9zZktLSWRH?=
 =?utf-8?B?MXZXUitQQUlUYnNsQXVSdnhBM2RYOFUxdHlzRWg0eHFXWjlxMGRGYVNLY0VS?=
 =?utf-8?B?WUs2L3V3Tnc4K0VEbjEzdGV5N0dlb1NEUHJobUxTTkQ1eVNvbjhTaitsOGlw?=
 =?utf-8?B?eUYrZzA1Z2FmUlFMVlhVZXRMSDdSV2hjL2M0MXk0VExqVzBubTNpL2VGeG5r?=
 =?utf-8?B?L2toYmxFUVBrWnY5V1Y1aFI1aEJQc0kzZFdoY1VoOEdWOG1CZXVxdDBSYXVR?=
 =?utf-8?B?WGxzRWoyYVZxVzNyaU1nOGVxUlhqRlYwVW5rMFNNbkRoT1BiRVdabmg5RmJK?=
 =?utf-8?B?VlVQa3YzU0hDZCtxbWV4TEM4MDBaQTg4RWMzbkV4Uk5nRWpEOXNFNUsyVnFT?=
 =?utf-8?B?ZzljazdlcHU5RzlZYmFPcUNjTjFwM2hvY3E0eUZPa3lJdFl3VXFid011TjZV?=
 =?utf-8?B?V28wSzVyTjI5UXAxUWpSd2daY0NESnEwajlISk5sSXlERXhlNkQwTFB2djF3?=
 =?utf-8?B?d3FOMDB1c3YxNlEzTmdTOWM1TWRCY0kyaUZiOWV1RVFRZ2xuUk95SXQzVUZV?=
 =?utf-8?B?NFZ5WHh1R2dHSUNpbDFKTmh1SkJkVzRIK2ZPbjJsKzIvck1XMTlMM0VHUDc0?=
 =?utf-8?B?b0NDRVFvQjREMFM1WFNORFpFaFRkYjJ3eHBJZmJJQXFCMXJBSk1jSmNIWlVP?=
 =?utf-8?B?TWdYVndKaXdFcGVwNUJPeHpVTzc2L1ZaWnMyWThuL2N6RGt2QW94Z1FUM2xa?=
 =?utf-8?B?MXF0SU8wd0dFTUdqc3hUdVV1dlJacnZhUkNRdThrOTQxRFdKc0M2WVFVQlh1?=
 =?utf-8?B?YWZsTExoTmxkVStqSDRBa01WZGRvcVV3bEJKbmpLNE84MEJpTUZZenFoZ3R6?=
 =?utf-8?B?SUtzZU10VUZNVFlTV29ZbjN2c24rZlhKZStWUVFvWTZrLzk1R28ySnFBNEJ0?=
 =?utf-8?B?aHMwdFh1QkJ4WFJ2bUo5SlVKSWRMVUtjdUFlSGordGwyQllYcGl3V25ySXdT?=
 =?utf-8?B?SDY0NWE1RXpESjlWcGxkckhsR0dUYThmMUVDeWhYV1JwVFlPZGdCcWVxbXM1?=
 =?utf-8?B?S0loQW5ad3ZQV3gvTmFwcW9YNWtnRG15YXNjVW96K0NuaHh2R0FqNVM2T2V5?=
 =?utf-8?B?eXc1SEdrcjZHUlZDNEJobEswY2lnbWFwdDVMZGUzZFlOQjBMZmIyOUxHelk0?=
 =?utf-8?B?Qmt3R3k2bVIyVk1PY0RqQ3R3eVBRPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b1fa2ae-149a-4402-a3dd-08d9a4b3d183
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2021 01:37:27.2305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /yj3wk55mz8AhCS/xtTuewgWhOTIde6x7GtVgCBVHBU60po7nsyNSKQSwEmDU2njCS+rH4pCn5sKXwyJw8yPhlpyTPilb1squ4LC9CGg24k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2647
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10164 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 bulkscore=0 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111110004
X-Proofpoint-GUID: lfyiviTL5bzLnHw42ZWS9agJw8Cqlhw0
X-Proofpoint-ORIG-GUID: lfyiviTL5bzLnHw42ZWS9agJw8Cqlhw0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Catherine,

These new tags look good to me.  If folks like new testcase I'll be 
happy to add these new tags to the larger log attr set.  You can add my 
rvb to these four error tag patches.

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

Thanks!
Allison


On 11/10/21 5:11 PM, Catherine Hoang wrote:
> Hi all,
> 
> These are the corresponding userspace changes for the new log attribute replay
> test. These are built on top of Allison’s logged attribute patch sets, which can
> be viewed here:
> https://github.com/allisonhenderson/xfs_work/tree/delayed_attrs_xfsprogs_v25_extended
> 
> This set adds the new error tags leaf_split and leaf_to_node, which are used to
> inject errors in the tests.
> 
> Suggestions and feedback are appreciated!
> 
> Catherine
> 
> Catherine Hoang (2):
>    xfsprogs: add leaf split error tag
>    xfsprogs: add leaf to node error tag
> 
>   io/inject.c            | 2 ++
>   libxfs/xfs_attr_leaf.c | 5 +++++
>   libxfs/xfs_da_btree.c  | 5 +++++
>   libxfs/xfs_errortag.h  | 6 +++++-
>   4 files changed, 17 insertions(+), 1 deletion(-)
> 
