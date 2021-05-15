Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0918AC433ED
	for <linux-xfs@archiver.kernel.org>; Sat, 15 May 2021 05:42:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D17C361206
	for <linux-xfs@archiver.kernel.org>; Sat, 15 May 2021 05:42:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234386AbhEOFnZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 15 May 2021 01:43:25 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48322 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234371AbhEOFnY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 15 May 2021 01:43:24 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14F5gBiG057865;
        Sat, 15 May 2021 05:42:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Q05rUR8AteFeMzKTc3uFmPRW9a13krJo9P4+6ndHcy8=;
 b=a46vqrHEk3dsFJumfTxfTi/KlwXZSkBzluCUys1LRuLMsfGMc3UdvIttov/kjiOQl9Sz
 VExIVw92LZ+dyfNTf+TiDGrM5McB3RpLhaigB0IvF4OHMgz86iqWZ3ee+847DWIs7JrH
 q1wVmx71x+tdNFXuLfDdsTtsjMgW68YEMDAituHMMVyJcjvefYOnkemQNLtNQPOYXuSZ
 kj8e+nP1r8THUB3ljhTu4ZqdlbobBxT3KiLgnEeUbAj2GsLrJVql9B+0eL98DgevoF85
 Vj3eov0lrWbluJxRihKrWhmcXUCw5PRjaoSDChzyeki4dMDGlDSubTu1pKShsRPl09hU RQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 38j6xn81je-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 05:42:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14F5eoB8178315;
        Sat, 15 May 2021 05:42:10 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by userp3020.oracle.com with ESMTP id 38j5mj38x3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 05:42:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RZ99PzVvAjucGzzK0ZLPWKutk6ROM4uhXY+O2uS9ZiPSNKSQEugecrXIjYGR9dh70srH7P5i0GXmOb3i5Gc6oJmioZBqjx6/36MxIOBdFa7ApmEGrhufKkqQIeRKkcPQA7faLAs7Sal+BX/PHNRfZ33v9+WfTWmwLfwyN/JDWC4ednFN4Iaq6Q3GMMpl2RZgVuzneerxtp7HP9O3pZ7ew8s2mBuTOa18haw7fkjIyjLNdb8yoBM6KV/DuZsdzSFL8ulsK8IoDEkbwsa9anbyiNC9lrhATpoSklNZn0ZhWyk/yDkqc/Xg7AGNphRQVPbpyaHR+ZZATACsPcSo/SAhkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q05rUR8AteFeMzKTc3uFmPRW9a13krJo9P4+6ndHcy8=;
 b=KlpQG2JWGMFoOy59kJXPrklQeYdAuOjymL3++VtcHIQ13z8oORLZxAtQNy50xIlxztwFdUxs1Ik5wj4+6Rkc8PaWaCNiLwnt+MV3pO/z5Wz/kUtEvhd12Gycy1yV1Yv3qSmszNFOEw3S3CT0UL06LTZhO8+MjIxUeSvCzQhpxN1z03dlhp4DYsUxrnrf1SxiozGNp0fRF901zduabTq54wru82pzlfaolKwAGMtMF8OLkSKVdrYJOL8v7vl3g+K/54U2oEPEhmVPsE/MyBZwPb04j/2fx/2u6TnZGHAtjL1YAqVQA8zXq84k7xWvSSKaE1HkAPv9unqVUAsUL1ESbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q05rUR8AteFeMzKTc3uFmPRW9a13krJo9P4+6ndHcy8=;
 b=NZVcuuw1L9rL5BuzMcZXRdz4kGJ99y0jNHb67SBXKVOxlHdMEN6Y28Tfy9Bderk6xE7X8LjuUo4woiiFNHVIK1yfxQTs4GSrEWSu0oUTEYj/5JV12Wmjr2w6KIGHTHfV/eVPo6pVi63EcbmE/aBcWsQa/5LBZQ6PGYBowgmaaDE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4798.namprd10.prod.outlook.com (2603:10b6:a03:2df::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Sat, 15 May
 2021 05:42:07 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4129.029; Sat, 15 May 2021
 05:42:07 +0000
Subject: Re: [PATCH RESEND v18 04/11] xfs: Add helper xfs_attr_set_fmt
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210512161408.5516-1-allison.henderson@oracle.com>
 <20210512161408.5516-5-allison.henderson@oracle.com>
 <20210513234604.GD9675@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <50c0cda3-d3e2-2d02-4958-123f08b535e7@oracle.com>
Date:   Fri, 14 May 2021 22:42:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210513234604.GD9675@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: SJ0PR03CA0196.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::21) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.210.54) by SJ0PR03CA0196.namprd03.prod.outlook.com (2603:10b6:a03:2ef::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Sat, 15 May 2021 05:42:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a0da1ff-8306-4d6c-e9a2-08d917642d1d
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4798:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4798CE80194357148480C751952F9@SJ0PR10MB4798.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NCTKKvOPtGXW/d/d2zw24l0yGiyRU/IS0iF3omk2sf40IR0hQVTjYcFcuHb6lPYK+44gl37XA/E9QrjXQJSX/vG+i7PKR+mQmMUKSJbjycrdocscR6RMdULFSJWERgY0j301YTdShCr9Ln25eqYEBFaSRYSD6QOBIBqxfXdFXt2S9jrcfaUM2wbG6rmkEFf6W2WAg9e/kkSZMPPgbK0ptGTOyiJlrtY65cISlBisbhfmGOrG7DSzdOyjJd9XslwQOCuBM+XafggavunUGWzFPmU6piLBydg/JHCqy//naoi8oxZHUtt+tLbnJEQ/Zt+FSLma1rzSQcx+SPtQlqrYY8coj00PHrqHY2YMkGAfDBqb42F+0LbqGDdhnHgi1OvhWBU9sxBODuS57JUvgvfo5cAlhlIP1s6C+I7W0Fq0x3ZSNIiyaiQCVnOi/IVOYNwLFxT+Oa/3AgLIV0LxlRCTptAkCQOXu/g9XpvDA+0s/L3E8EPVjNAoa53Jg+wVDlVdCPSA2MSkzRZsTtNmylw2/mkbYmILXt/gFSMwDfXPrrkrnNbrLlktBnfNU1H2TUWa2oAkryHyAYMyk+rvIQNISgdSs/PqCk21vjyGGe1656xSYqh9rtsj1xO3c7rJ9iWBQIkFLzu2yRzqEP87DStAwUuLbwydHGUC9TECKpRtAOHclHVRoFGQ72V8l2HPhVW6rtSmlNVxaW0Ngv1Gjgcukw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(136003)(39850400004)(396003)(16576012)(478600001)(2906002)(316002)(83380400001)(5660300002)(16526019)(2616005)(66476007)(66946007)(4326008)(66556008)(956004)(8936002)(86362001)(31686004)(38350700002)(38100700002)(31696002)(6486002)(36756003)(53546011)(26005)(52116002)(6916009)(8676002)(44832011)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ejRqbkhTNVBINVRERWNiUkVVbzNPRU1ucHVLMlYyZjBGdkpzajNIS2gyRG1B?=
 =?utf-8?B?cTBuRjVlRGgrVHVZZGhsbnFpdFNNNW1nalRSd0kzc09JTWlZRTRraSttVXgv?=
 =?utf-8?B?V0NNQW1vd2NJK09RQ0M0TkphZ1VkNWN0aDZ3WExhMDQzU2EvM2hjMDQ2WUVP?=
 =?utf-8?B?ZE9PV2RaNzVQK1RxTTVmd1hvaWZYcnhiZ0FxL3Bia3UxZ3ZRb0RyNDRUNXZt?=
 =?utf-8?B?Z0hWdE4zcWdlTGRFaFdNNDE2MDdZeGw1Q2NuRXl4djhPOGNQOXRPUnhWNyts?=
 =?utf-8?B?YTlEeDNkcXlISlN4ZTFvd1p4U0FLQzlGSGNpQmRVRWRGNHNXQWlVeVE2MlpF?=
 =?utf-8?B?Y1dJdE8zekxkKzJKTHZ3S01MUUpaRm95R2JNN0paZWYxclFNVFZ0U08yc1Bo?=
 =?utf-8?B?WFpkZXNIMjUwOHdPMDNpWEhoaUZNYW5vR2lKU09TeDBIdlNVOGE3Z29RYUdt?=
 =?utf-8?B?VWFnTjNSbmNLVjk4ejlLSkluOUxXOW14ZFJZZExGRnNFUkhLenYrWWl0ay9p?=
 =?utf-8?B?bEFMMEErSmRxSmRudEN0OFZMZXB0R3dhUUVITXA4R0QzOXl3TG5GVXVyWGNt?=
 =?utf-8?B?aW9vZlYzY0kyaHFQRlplZFRoUVJoQlgzTTdKY0lkTDdNSmlCSXVSMjRQOWpL?=
 =?utf-8?B?SkxvZFpDVW9XY3lkb0x5RDk1SFM0c0FidFliOUtTbEl0WktqMU5SSGJRN2JI?=
 =?utf-8?B?UU85cjFIQTYxdmFLYXBMUlN6bWpHbmVzMk1nQzlweXZ6OUZIalRRc3pzZThk?=
 =?utf-8?B?ZzNFRWJzSUZGRXo4WUNjMHZUeUMxT1BrNUhuNkhsWW9DeVlTUFBxRnkxVzB2?=
 =?utf-8?B?MFRDcnFXQTFFa2k2dlVSd2g4U2Vaa3FWb1A2Rk00aGJzdEhQQmc3TXFXUWpn?=
 =?utf-8?B?aXBpUTFieHczOGRZb0w3bGpyUTJlTjloNHVEbUQ0TG1PQVhRSEdiUnZyUjA3?=
 =?utf-8?B?d04zdVlWeUFta1U3ZEIxeEFpRytGRlFmVVIvZzZCT1FIZnhRM3hMbklXOXFG?=
 =?utf-8?B?eUlVbzBTWThDZDJ6UnQ2dXpQTUhLbVZkMDRVVUdaeVM4STAvZ0tycWlQVTVo?=
 =?utf-8?B?MlN2NTY4Q1ZFd3luaUZuUFZpR3FZdnJwYVl4R3Nwck5jTmk4OXdLRWI3YUJJ?=
 =?utf-8?B?Qlk2UDU0L2xzWjJaTkxRNHpZdFpNSlZQMk9WK2xncWxXelk3RlJuMFE2elNv?=
 =?utf-8?B?ZE9zOXZXdnk2RXh5dkpJelI1SmdQRFdDZ3pGZnBWcUM3c1M3TDdnRmJPQnZP?=
 =?utf-8?B?bkZ5eDVFM09wQWswOVRpTy9mQlNWOWJaZHUwRkpsR1FjalVyeVJlSVRSSU1z?=
 =?utf-8?B?TkhFcG9WKzRyKy9ZM3JQc1U3b0JQR3pvRFJLSWJaOXJ0UEpwNGFVR2Y1eXkz?=
 =?utf-8?B?VW5Yb2ZPZUY5Q2ZHYWFYM2JxWisvd1ByQ0lZNlphOUtjdzdZSkpjMFg5dm1U?=
 =?utf-8?B?WmVUYTVlYXJqTjhRMS81djlvSXJvbDAwTFA4VWxXZGpyN2x6N2RTWmxGWmtk?=
 =?utf-8?B?VWVQd05IT01pZklWMWJkV2lpQlMzQmk0YTBLdkt1ME14ZjN3VS9WYjRlNWZk?=
 =?utf-8?B?UDlQUExoYUVpYkhQR3oya0JmRmJ0K29hN2pVdEY0K0xMemdxYWtLRVFNUitv?=
 =?utf-8?B?MGNZc0UwNjc1QnhmR0M0dkhEVzBQODR5bW1pM2JFbzdJSUJCWWlIODJ3dVc5?=
 =?utf-8?B?c3AvY1l2dzVubExCR3VBcVluYzJIb01DaXpvNFNwd25VNGx2ZUQvOWJyZ2Zw?=
 =?utf-8?Q?SiM9oQqRNn+jNhS73F/6KpkQ82L9e4NPVoDn1nD?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a0da1ff-8306-4d6c-e9a2-08d917642d1d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2021 05:42:07.1515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o/gFu6lqHRp0fFTNnG/GL0tbNxkcqL7iEAl4XppNgJHyImwwhl78BeLu3+8gMlocposI7scbm5mNgPYmoM0QRJgdxkQUPXIyZsV+O3/pJxo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4798
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9984 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105150040
X-Proofpoint-GUID: id4DHdj2SwadxrkSHPg1mMq9_Cpf9L6D
X-Proofpoint-ORIG-GUID: id4DHdj2SwadxrkSHPg1mMq9_Cpf9L6D
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9984 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 priorityscore=1501
 phishscore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105150040
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/13/21 4:46 PM, Darrick J. Wong wrote:
> On Wed, May 12, 2021 at 09:14:01AM -0700, Allison Henderson wrote:
>> This patch adds a helper function xfs_attr_set_fmt.  This will help
>> isolate the code that will require state management from the portions
>> that do not.  xfs_attr_set_fmt returns 0 when the attr has been set and
>> no further action is needed.  It returns -EAGAIN when shortform has been
>> transformed to leaf, and the calling function should proceed the set the
>> attr in leaf form.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
>> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> Er... can't you combine patches 3 and 4 into a single patch that
> renames xfs_attr_set_shortform -> xfs_attr_set_fmt and drops the
> **leafbp parameter?  Smushing the two together it's a bit more obvious
> what's really changing here (which really isn't that much!) so:
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> (Though I think I would like the two combined for v19.  But let's see
> what I think of the whole series by the time I reach the end, eh? :) )
So... did your feelings change much by the end of the set?  I have to 
admit, looking at the combination of these two patches, the diff does 
not look particularly attractive.  During all our refactoring efforts, I 
think we did a little bit of a circle between these two.

Rather than sending out a v19 with a poor patch that will most certainly 
result in a v20... how about I slap them together, and send them out in 
an RFC explaining what it is?  That way people can look at it and we can 
discuss what we really want to keep.  Because from looking at the diff, 
there's really only a few bits of functional changes, that would 
probably be appropriate to lump in with patch 11 if everyone is in 
agreement.  Then possibly just drop 3 and 4?

Allison


> 
> --D
> 
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 79 ++++++++++++++++++++++++++++--------------------
>>   1 file changed, 46 insertions(+), 33 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 32133a0..1a618a2 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -236,6 +236,48 @@ xfs_attr_is_shortform(
>>   		ip->i_afp->if_nextents == 0);
>>   }
>>   
>> +STATIC int
>> +xfs_attr_set_fmt(
>> +	struct xfs_da_args	*args)
>> +{
>> +	struct xfs_buf          *leaf_bp = NULL;
>> +	struct xfs_inode	*dp = args->dp;
>> +	int			error2, error = 0;
>> +
>> +	/*
>> +	 * Try to add the attr to the attribute list in the inode.
>> +	 */
>> +	error = xfs_attr_try_sf_addname(dp, args);
>> +	if (error != -ENOSPC) {
>> +		error2 = xfs_trans_commit(args->trans);
>> +		args->trans = NULL;
>> +		return error ? error : error2;
>> +	}
>> +
>> +	/*
>> +	 * It won't fit in the shortform, transform to a leaf block.
>> +	 * GROT: another possible req'mt for a double-split btree op.
>> +	 */
>> +	error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
>> +	if (error)
>> +		return error;
>> +
>> +	/*
>> +	 * Prevent the leaf buffer from being unlocked so that a
>> +	 * concurrent AIL push cannot grab the half-baked leaf buffer
>> +	 * and run into problems with the write verifier.
>> +	 */
>> +	xfs_trans_bhold(args->trans, leaf_bp);
>> +	error = xfs_defer_finish(&args->trans);
>> +	xfs_trans_bhold_release(args->trans, leaf_bp);
>> +	if (error) {
>> +		xfs_trans_brelse(args->trans, leaf_bp);
>> +		return error;
>> +	}
>> +
>> +	return -EAGAIN;
>> +}
>> +
>>   /*
>>    * Set the attribute specified in @args.
>>    */
>> @@ -244,8 +286,7 @@ xfs_attr_set_args(
>>   	struct xfs_da_args	*args)
>>   {
>>   	struct xfs_inode	*dp = args->dp;
>> -	struct xfs_buf          *leaf_bp = NULL;
>> -	int			error2, error = 0;
>> +	int			error;
>>   
>>   	/*
>>   	 * If the attribute list is already in leaf format, jump straight to
>> @@ -254,36 +295,9 @@ xfs_attr_set_args(
>>   	 * again.
>>   	 */
>>   	if (xfs_attr_is_shortform(dp)) {
>> -		/*
>> -		 * Try to add the attr to the attribute list in the inode.
>> -		 */
>> -		error = xfs_attr_try_sf_addname(dp, args);
>> -		if (error != -ENOSPC) {
>> -			error2 = xfs_trans_commit(args->trans);
>> -			args->trans = NULL;
>> -			return error ? error : error2;
>> -		}
>> -
>> -		/*
>> -		 * It won't fit in the shortform, transform to a leaf block.
>> -		 * GROT: another possible req'mt for a double-split btree op.
>> -		 */
>> -		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
>> -		if (error)
>> -			return error;
>> -
>> -		/*
>> -		 * Prevent the leaf buffer from being unlocked so that a
>> -		 * concurrent AIL push cannot grab the half-baked leaf buffer
>> -		 * and run into problems with the write verifier.
>> -		 */
>> -		xfs_trans_bhold(args->trans, leaf_bp);
>> -		error = xfs_defer_finish(&args->trans);
>> -		xfs_trans_bhold_release(args->trans, leaf_bp);
>> -		if (error) {
>> -			xfs_trans_brelse(args->trans, leaf_bp);
>> +		error = xfs_attr_set_fmt(args);
>> +		if (error != -EAGAIN)
>>   			return error;
>> -		}
>>   	}
>>   
>>   	if (xfs_attr_is_leaf(dp)) {
>> @@ -317,8 +331,7 @@ xfs_attr_set_args(
>>   			return error;
>>   	}
>>   
>> -	error = xfs_attr_node_addname(args);
>> -	return error;
>> +	return xfs_attr_node_addname(args);
>>   }
>>   
>>   /*
>> -- 
>> 2.7.4
>>
