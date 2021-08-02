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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC47EC4338F
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 08:33:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF8BA61057
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 08:33:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232783AbhHBIdp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Aug 2021 04:33:45 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:57086 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232758AbhHBIdo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Aug 2021 04:33:44 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1728QoVv010193;
        Mon, 2 Aug 2021 08:33:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=9gu1KRC4Lb5c0hUbdNPVGXKvu5Z0f6bnV8qxZ1iQ1lY=;
 b=CD5KR/yiG0HxSDG34mEnFEZvunUYXWeNUSZrJu7bGyWjmXsWtPtMhEG50u2fi2+ZRLKx
 vuqxsM3pjRYEjqAvghPxZ1S5kOBIx7V85QatPejTVGlftfB0elZGnJThNZ24vVf7Sll9
 DVjGz1mwf6+/iRhoN6YqmU65GwPt+xLYrdH5H6ufHqKr5A4JkOOynJm6kpD7d8AmOWlJ
 WGNZ2QvM491vGbvsvWQaOP0hfQ3nJiocXuVV+lT2OnKu58JaJweyYPzgD9SA3+XQMDoY
 63mSxZcQZDdgrCdq8sDz1CbtvDy+XTD4uLOlJvXlJle6YC9GNgbi+HtiLiWhGNHKxSlY zg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=9gu1KRC4Lb5c0hUbdNPVGXKvu5Z0f6bnV8qxZ1iQ1lY=;
 b=dnYDi2PrpHHu2gR+1629hvHQxtUnGkrT5uAj4tcSVnfTXD+ISadCVreri6kYuny8fGxD
 jZTyAcCIgvprVl3Zas24njbFG/a2u+Vl46lyPzIDsNpRPhUSZDrDh8tb3QYV0WCj+3vq
 kTkDlAv35YXolBaSocL2V3cclqsYC8zPSusjHAFzsSO5imCP34EVCM/yCpeLpogjqemK
 iNcKxk3cbWwx6XSgMjnL4hpdk+3J3ekc14M1Ucm3aMPViTyFZqqUsj3zOzCbPszB/L4O
 5KmFRws1qfds1z454fSScJp4sgzYpxcxKlEHKsMWgQgG813JVdsW1o3i7mwHclEVo6cZ 1A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a6cntg2ye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Aug 2021 08:33:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1728Q3LD036946;
        Mon, 2 Aug 2021 08:33:33 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by aserp3030.oracle.com with ESMTP id 3a4vjbmks5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Aug 2021 08:33:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K9GTdNFiTHUoI/qvUou1IjHGCSzK/xPVqxf2Z+SrAU/C8ku7Vwr94KBjlI55nlw+ZNpKVX6lUNSnLfPyuJ4tiJOvgbFPjtChmWYxMHuTtAgiVU5e/Bx3rvSUn6Xrj5kpJOjTGkdvUnuuOqsFBOas6BCb5IW9RWo6B4KKpCbBPdWkTAEHBPK6bXHKiTGmxgOfRe1wDmB3cinDRz+jhbWI23hSVXoM/5uUcV4OcXM1g1JZSjQjFtAP9AdfWATHczO3l8S/JiUMv7nYXA6nfDAVOswu4qR0BuQz8Xx2R74mQ6TocOzSHQ5LVKxV+8IluP+QIJzy1jGmZyn6GkYkhkiTLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9gu1KRC4Lb5c0hUbdNPVGXKvu5Z0f6bnV8qxZ1iQ1lY=;
 b=VHnaawizuX4Z2LrPTet061KWQZRUZu+N3jGgO64m5E0ubyOTB6vo0j2qE0zCC8d9DgGQX6PDwiNBsRUn5rviR/UOCuY/2/5hWd230Bd9vCgaXhsfKQdCHvMibgRFqDJTif+86GkkXPbD12Ey7Cn19rf40ZpMwbgPF2AjEowPR7CaXZ/Nji8s/m7xtz48Cih3/fXUQAMsrzF2XJakb+ydq6rdDb6cclTrJjIjnHq4kDMM4ahIan18nEtAuIue6R1U1sYP4GYrEnFYllk32NDl4DVHUZ8D6lfYQNrEJZ6nxdgWiSwi3OUYfLocT89TtQudWGOHFUQ/wF3H9VV0u/h/gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9gu1KRC4Lb5c0hUbdNPVGXKvu5Z0f6bnV8qxZ1iQ1lY=;
 b=Bst5s4ytizrRv05OAMsTcGFYy+UscMDZs3f122GFffFpHwAMfV1J33VAKAM+THSGWkJ8CTyNZRkgjZ1BM4EqayWcFpPAJZoBRp0tJKgn5VrprVFbdYURuLdnkO6G+3QTDkuzH0v0EemJSh8YfUuH6KS6+LlKQixdYj09Rm+VP+Y=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB5485.namprd10.prod.outlook.com (2603:10b6:a03:3ab::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Mon, 2 Aug
 2021 08:33:31 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%9]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 08:33:31 +0000
Subject: Re: [PATCH v22 13/16] xfs: Add delayed attributes error tag
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210727062053.11129-1-allison.henderson@oracle.com>
 <20210727062053.11129-14-allison.henderson@oracle.com>
 <871r7co7aw.fsf@garuda>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <833bcfd1-0104-7b9f-bf5f-70bec4568ff3@oracle.com>
Date:   Mon, 2 Aug 2021 01:33:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <871r7co7aw.fsf@garuda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH0PR07CA0036.namprd07.prod.outlook.com
 (2603:10b6:510:e::11) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.167] (67.1.112.125) by PH0PR07CA0036.namprd07.prod.outlook.com (2603:10b6:510:e::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Mon, 2 Aug 2021 08:33:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 09499d17-ccee-4056-f376-08d9559035be
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5485:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5485BDD3DE28DE06C9F3F70195EF9@SJ0PR10MB5485.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g5fXn/H5X2qQXjylSWIiSHh4Sh5a5HI+3Uv6wlYnqsQXThzUate0NRSA30pn7jG6Tj5BmKRSRezqTd7LXhl9uyc3Str2afYTNJ9dXKbdT9mW22gu/bVzHe2Oo3iSk13vS4abPw84x/aotT48LZfhQLT5BhCHw+jDEXhGzn5idXlSr468fZ8tvuHojajsl6rdyVtJ9lXzQ8qezhOX8RgM7kyo958R1P7/jVC8KC4jkNsdNnMVDy1Sfkuu4mHV8X01ITbzSZrFJfoeEjNK/YfOC80xodpVF0fb+ahQCb9kZaQzgFlg27SZqGbLXhu+qrPF45ztx35EmJjQK7dtpd6cJlvKM7ND79ENH7e8Ef+X42jU+ZdmzQUTXVFQOxXrRMufw9IjHBd964kuPK1UCtqNrAXdWcO1/KhDThODbk5mV+69dsABOl79M0U+r1tiyHGpJDsAaHfXlz2p6TR55fIrpqdTLutjQvaeRvPuzBiDWTpzXrybYglQcO5Eg/BxC67uzLF/XWdyRFV05WB9GI06aEUrIwmlaJgLY/l8Om+v5yW0PYAjHyE5fXeGgy7Wz+Hrvke4EcA08yokYJwm70g/FebJC/Vb8bWiKAePULQhDwXN51lGIUEck+9efocdPUnJXdimH4CdMkbeimsoPkr/fcZePPfM9m47sI1T3oRk9yUrr64MFnOQpgtCM5RLKPelRxPNkp4Ep8rBNQDlKkeGOhW3aWWtPipLzZInebjtnMoJy9bc6pwJLPJ2zllOzTPQY+w73vD/DeuhZXAQ36g7eQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(366004)(39860400002)(376002)(136003)(44832011)(4326008)(8936002)(36756003)(6486002)(86362001)(66556008)(38100700002)(38350700002)(66476007)(8676002)(316002)(2906002)(16576012)(31696002)(66946007)(31686004)(53546011)(956004)(2616005)(26005)(5660300002)(186003)(52116002)(6916009)(478600001)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NHVmYk4yYjd0cTBGU09rRTh1ZzdzeTJSRTBjQitZalZNUG1vbzVnci9GSWlt?=
 =?utf-8?B?bFBqb1RrL2hOM3NhMk42RllZZldod3dzclNXeTU0MEk2R1dIY05lWnVxWE9Z?=
 =?utf-8?B?YlVhcGtzeFlrTGJreTNwMTcvaENTUFVTSStCK2ZzczhGNlJmc1Rtenpibm4y?=
 =?utf-8?B?bGo2YVVGdjJ3N3Riek5SWTZCWjVNTHZESDBYNkJMM3V2UUJGUXhxdVNvYVow?=
 =?utf-8?B?REhCZXhiVHIwWXJFRFo1V0RHU2IweWVJanpBRTQ5OEJuQ2tIc1g5cjF4bk11?=
 =?utf-8?B?c1FUa09OaGlQY1V3SElFRXJmVi9MV3hjV2s4ZEQxQWdiV3gyUXpzMHVucW9E?=
 =?utf-8?B?R25LWGV2aklnM1JBK0ZXSUsrYk8yakhTZHdDa1V1aFJyNENTK2U4T0p0amRn?=
 =?utf-8?B?Zmg5aHh2T0dnOWdteGJWNFYzUmlaRU45OVhld2lsZVFWNG9Odjd2ZDIyZHJ0?=
 =?utf-8?B?NEU4TERka0NHenE3OWtsRUFuSEovZHUxNzloYWRvUlcyRUdNTjZNR3Zod2pS?=
 =?utf-8?B?cjR2cUQ0aTlKNkJQc2NJTGIrMUZoSDZuSXBTTUdBVkZEbGo4VlZ4SVo1UHAx?=
 =?utf-8?B?MWhmVFB2RGVIUDJzVThqdFZCaVVSOVd3NXRESms5WmFIbWdUZThCc2E0M1JF?=
 =?utf-8?B?eWpYYUNXSlNZcmpEOE1ObGJHbndHNXVvWTNPYnR0UmNKNHJ3ZHNJSWNkM3Ar?=
 =?utf-8?B?OVA5MXpLOUd5NFNSdWMwVTB1b0RJendDM2ozYjZFQnc0ODdqSG5TZDQvWklh?=
 =?utf-8?B?ZGpjb3hEN2lFNXY1T0lIY05VOFBGRFQ5T0crVlBBa2NEaGltY1o0cS9OV3Yr?=
 =?utf-8?B?RVJKK0F3ZjNZdWtJTmgydTNrWU1vMjNLU255QWZnNVhWVG9kNHNZREZQczRQ?=
 =?utf-8?B?djNwd1ljVW1YNjc4bGEvUWRESFFLWE9WVlFPY3VkRlRvVGUyVUVPVjJsekky?=
 =?utf-8?B?T3FkRGdWUkJmbW84RnZleUVSTHZNMGwyVGxvYVA2cVI1SXZTd290a3A2TkpL?=
 =?utf-8?B?V3A0Z2R4cUIzWENMVFV4L1ZzSGozWHJRTEZ3dEJOYzA1ZTNkaC9YTUhCMGJF?=
 =?utf-8?B?Y3Zoeng0VTdRcnB0SGZKZlVLemN6OTViZUJuYkRqbWY3TmpNQy9iT2tOZEE1?=
 =?utf-8?B?aFF0NUI5UURZNXhHaDRkdGQyc3ptK0wvMjhlanR4THpTM1o4UEFXU0tMTk5o?=
 =?utf-8?B?QUVNQkRUejBBb2d2S0hhOVhsTWswNlllQmtBMmJ3Zk43UEpwSmpJOGxJWDN3?=
 =?utf-8?B?ZjdjSnVMUGZVQTVYUzIwTHNhWlFzY01uSFNVR1BadXVaQytRMlk3RzJBTjRv?=
 =?utf-8?B?QnBTV3grY2Q4RUhBL3hNUmFXYk01Vzl4QThtQmVaTlc1T0JZZ2ZZVklOZVZ2?=
 =?utf-8?B?SDJqd25JREZESU1Dd0NHUEVXUlZ0Wng4Z0J0WENNQVdsMXZPb1FKT3lSQVBP?=
 =?utf-8?B?S1RoeHR2cGxpSEN5eDBHRk5VeG04VS9VcjI5YXM5V1dCaUYvYVkrYVlFK01i?=
 =?utf-8?B?MG9GQjNxa2hCenBUaDdtTEV3VjYvNVJzNXNLdENPVnVxdDhIYWF0cStWUldp?=
 =?utf-8?B?b3F1cUtVNjVoM0hpc3k1SHhKck5PY3BwdklEcVljRGhZZEVJTXVWS2lsZHd0?=
 =?utf-8?B?SGJMcTVpdHQyT3dLQ3BVOWpIOXE2VVAyajNBUGxQYmFNclZWR1VOaGJJSmRJ?=
 =?utf-8?B?cW51SEVUL01xbFJnb1VrMkpDa3hwbUFqY1pCbEg0Unlyd20xOXYvMTAwODFP?=
 =?utf-8?Q?ohejU67G0guffrR4SeeMXzg3nDdf1Yw2ghVmGdf?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09499d17-ccee-4056-f376-08d9559035be
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2021 08:33:31.6158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WScS+lmCVxbcOQvft/gAgrDS/8nFUj9gSN0hTlwiQnXYSKLJQTxkf8NGdGjGISFXITf6n24cNRAl/ctwDIrpU5/TpoELaf5+DWc7jDsdA8E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5485
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10063 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108020059
X-Proofpoint-ORIG-GUID: pHfe8ThJvlmYUcHQPnep9Y9VpXqqUaFn
X-Proofpoint-GUID: pHfe8ThJvlmYUcHQPnep9Y9VpXqqUaFn
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 8/1/21 8:27 PM, Chandan Babu R wrote:
> On 27 Jul 2021 at 11:50, Allison Henderson wrote:
>> This patch adds an error tag that we can use to test delayed attribute
>> recovery and replay
>>
> 
> Looks good to me.
> 
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Thank you!

Allison
> 
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_errortag.h | 4 +++-
>>   fs/xfs/xfs_attr_item.c       | 7 +++++++
>>   fs/xfs/xfs_error.c           | 3 +++
>>   3 files changed, 13 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
>> index a23a52e..46f359c 100644
>> --- a/fs/xfs/libxfs/xfs_errortag.h
>> +++ b/fs/xfs/libxfs/xfs_errortag.h
>> @@ -59,7 +59,8 @@
>>   #define XFS_ERRTAG_REDUCE_MAX_IEXTENTS			36
>>   #define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
>>   #define XFS_ERRTAG_AG_RESV_FAIL				38
>> -#define XFS_ERRTAG_MAX					39
>> +#define XFS_ERRTAG_DELAYED_ATTR				39
>> +#define XFS_ERRTAG_MAX					40
>>   
>>   /*
>>    * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
>> @@ -103,5 +104,6 @@
>>   #define XFS_RANDOM_REDUCE_MAX_IEXTENTS			1
>>   #define XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT		1
>>   #define XFS_RANDOM_AG_RESV_FAIL				1
>> +#define XFS_RANDOM_DELAYED_ATTR				1
>>   
>>   #endif /* __XFS_ERRORTAG_H_ */
>> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
>> index 12a0151..2efd94f 100644
>> --- a/fs/xfs/xfs_attr_item.c
>> +++ b/fs/xfs/xfs_attr_item.c
>> @@ -34,6 +34,7 @@
>>   #include "xfs_inode.h"
>>   #include "xfs_quota.h"
>>   #include "xfs_trans_space.h"
>> +#include "xfs_errortag.h"
>>   #include "xfs_error.h"
>>   #include "xfs_log_priv.h"
>>   #include "xfs_log_recover.h"
>> @@ -296,6 +297,11 @@ xfs_trans_attr_finish_update(
>>   	if (error)
>>   		return error;
>>   
>> +	if (XFS_TEST_ERROR(false, args->dp->i_mount, XFS_ERRTAG_DELAYED_ATTR)) {
>> +		error = -EIO;
>> +		goto out;
>> +	}
>> +
>>   	switch (op) {
>>   	case XFS_ATTR_OP_FLAGS_SET:
>>   		args->op_flags |= XFS_DA_OP_ADDNAME;
>> @@ -310,6 +316,7 @@ xfs_trans_attr_finish_update(
>>   		break;
>>   	}
>>   
>> +out:
>>   	/*
>>   	 * Mark the transaction dirty, even on error. This ensures the
>>   	 * transaction is aborted, which:
>> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
>> index ce3bc1b..eca5e34 100644
>> --- a/fs/xfs/xfs_error.c
>> +++ b/fs/xfs/xfs_error.c
>> @@ -57,6 +57,7 @@ static unsigned int xfs_errortag_random_default[] = {
>>   	XFS_RANDOM_REDUCE_MAX_IEXTENTS,
>>   	XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT,
>>   	XFS_RANDOM_AG_RESV_FAIL,
>> +	XFS_RANDOM_DELAYED_ATTR,
>>   };
>>   
>>   struct xfs_errortag_attr {
>> @@ -170,6 +171,7 @@ XFS_ERRORTAG_ATTR_RW(buf_ioerror,	XFS_ERRTAG_BUF_IOERROR);
>>   XFS_ERRORTAG_ATTR_RW(reduce_max_iextents,	XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
>>   XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
>>   XFS_ERRORTAG_ATTR_RW(ag_resv_fail, XFS_ERRTAG_AG_RESV_FAIL);
>> +XFS_ERRORTAG_ATTR_RW(delayed_attr,	XFS_ERRTAG_DELAYED_ATTR);
>>   
>>   static struct attribute *xfs_errortag_attrs[] = {
>>   	XFS_ERRORTAG_ATTR_LIST(noerror),
>> @@ -211,6 +213,7 @@ static struct attribute *xfs_errortag_attrs[] = {
>>   	XFS_ERRORTAG_ATTR_LIST(reduce_max_iextents),
>>   	XFS_ERRORTAG_ATTR_LIST(bmap_alloc_minlen_extent),
>>   	XFS_ERRORTAG_ATTR_LIST(ag_resv_fail),
>> +	XFS_ERRORTAG_ATTR_LIST(delayed_attr),
>>   	NULL,
>>   };
> 
> 
