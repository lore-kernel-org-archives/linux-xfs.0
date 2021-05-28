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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EE73C4708B
	for <linux-xfs@archiver.kernel.org>; Fri, 28 May 2021 00:54:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C3036124C
	for <linux-xfs@archiver.kernel.org>; Fri, 28 May 2021 00:54:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235396AbhE1Az7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 20:55:59 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50838 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbhE1Az6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 May 2021 20:55:58 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14S0s3RX096306;
        Fri, 28 May 2021 00:54:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=LqKPDzV+R/pR6n/7ePzoBZ2fL+uSsZ0zDkl1kIjviTc=;
 b=DX6m80ddEQLEKZTv/PNbDpOJ3B+pHibmU2MtJdyhegxWI8wofI0CgCJOgEann1sxzaK7
 oQNjw5Cd0wh27AXSz2JZ1xDmPofluSl45cl9P3QrLqeQRGCKPk5LgrShq8gz4r1YMhP2
 y4cwWPjIGwVZsxZDdt0wgN8jKsAuFAqVTbd3loM0oTsdCIxK/wbQo5XwAQSm+7ZSBN5x
 p/oTH4sDROzZApVC4MrpfwARM3nSDCW5wR2lWDtAuRUNQWMU5YOOxT4HKzEuGcuILzRM
 t0nkVhvPyTdmHrW+xotw+prB5IVBi+mmW/SBifO5Egzyj0yN7Q2afaIxpu+LE9yfvIAj Rg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 38q3q9555c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 May 2021 00:54:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14S0jlpr047971;
        Fri, 28 May 2021 00:54:20 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by userp3030.oracle.com with ESMTP id 38pq2wy477-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 May 2021 00:54:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KrOJDyJFZmLPatkjdbrTb2hXHhbM6PXCdDzsTxGqTVk1cPx08KDYHlbwTz7Ifon/8TlyVyyYl711SumpzSkrbNafz8Fv2WzX+4ptzEw5DpPOgPxid3qxQKI5CT3dsC7oLRIx/8hfKF6IAwnyKjC3CHNPKUaWSkAiGneUlPev0h5j9xhHP5ZWPZtSs6Wr4BgXNOaHUag0YXVpfxEdu+X74GYGhnHjmo8txu2KIILej79aS2Pr28JZU7hlY3xYcgAq3S/P5v52NEI9jhJZbT0TCC2YDmncQU0yLNzoJuIltGJR1+XUOl8bArAANoz1v+UYEFj1CjW6jo/aFuOKh7COSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LqKPDzV+R/pR6n/7ePzoBZ2fL+uSsZ0zDkl1kIjviTc=;
 b=MvLNLgcywDhiCM6zXUUmwLO9YC1qPz789RCFLJHCHjmGcvw56KwVZxlMncUOPRj9cuha/wJEVqZuImnuazAPoO9o0AzWvKENAzB80A6yUMgcpu6hxe5aBTd5C/v5R4qSvbUKX56n4VnyKR2F9ZHH/CQlXBYzkx2BSpYjwtM7VbzWZiIyiy5zo/3y09GZFnFYzck9opzkPEodMoa/5fQ7L0TVl3nvkb7R9g5JhZ3rASrhatIQFiE7fgJJpDbjn4IyveTJ08kP6TjwnjaiuKOySFc0hKSupBw2+xYDVNJsWF3PHZPd4pTWnAjgCb2bVL7JPAamBraxF7Tm8EbMeTD8fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LqKPDzV+R/pR6n/7ePzoBZ2fL+uSsZ0zDkl1kIjviTc=;
 b=B8ZKIcVj2VQWOKCH6kkQxvy1BurHO4h/LDGHOuk8+/HsU2BT+ouB6x1JBG/nUUw/2TiNZXEfIFKhLrcJy3g6zy5V+PxHpJXLrfSwiT2hY554+nD1OoT8nE8kgqotelOMeMXdeo0lpcJ+aLbOptRY6HlNvPHwqUsD6G+g5V6742Y=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4510.namprd10.prod.outlook.com (2603:10b6:a03:2d6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Fri, 28 May
 2021 00:54:18 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4173.022; Fri, 28 May 2021
 00:54:18 +0000
Subject: Re: [PATCH 02/39] xfs: separate CIL commit record IO
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20210519121317.585244-1-david@fromorbit.com>
 <20210519121317.585244-3-david@fromorbit.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <c0874e25-42f4-bcd5-dcf4-f728cc6741ad@oracle.com>
Date:   Thu, 27 May 2021 17:54:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210519121317.585244-3-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: SJ0PR03CA0189.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::14) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.210.54) by SJ0PR03CA0189.namprd03.prod.outlook.com (2603:10b6:a03:2ef::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Fri, 28 May 2021 00:54:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: afd789d9-14cf-418c-897f-08d921731f61
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4510:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4510474AECAAF37BE6698DB195229@SJ0PR10MB4510.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: brd6feYBg9JHKMJd7OHl45QvWUV6vcF4+hE7TN4IvD6eATZL6agVgtIB4g6sQc02sE54m71p7opL3hKBnzBLifrZi5yt+UeaUUU0bSpXlno/J/l3z1xPja/tS4UQAMFG7FB8XbdFj2O4qSvUTHhJWgjnfCTnAP+U9mXGJa56K2oOn3GgO78gx2Zgv1C6wLy9Nw5u+NNDrQ9J4C8YZOefly0pCIyVh8u/QFpSGQ+gVlHQGjaZhNe3IzlBKM2HWfBqlA5B2qkm5BA84JpU7UVpcMVTU5ozETZBk6Dxxd1YSc1OYFJ5JZfu19jtdhAHCR2sRjS/V80N9iECI24jInUc5sTAXwTzz7rhImVLPaWU0WqhC8cwND5rIjWhqcDBdzG2E+W8WlOZkKziOg6UK3A4urtAE8WnxJ+G/xegf4qyfCoXe+KBpsFUpJN0aFngRGddGBZCMUyCqVI7Pb5h237k0GWcogD2zBx3d3IxEyu8n0tadkGlVgwR1qr9hMeQzz7DBS+DcNj/veqvya91P+/DNWdXo+WCKWi4qXvMcz315JR1ft59tXWQ2hmLxNt9co/EXO3FzF3Qfwu0akCaxBcd+9rSoz15nTMW2vALWOR/lNt/ZY0Qk10Ta6PkDeaEkOb0+/eGNvy8Nhz5lN9kzJ3stRU302Wc/VNWqOPo/VtqYMn/OwVvSny8qY/5nynGiWG58TKLiYJs7K6LFdTdjpoc8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(366004)(39860400002)(396003)(5660300002)(26005)(44832011)(31686004)(36756003)(316002)(478600001)(2616005)(16576012)(956004)(16526019)(2906002)(83380400001)(38100700002)(38350700002)(52116002)(86362001)(8936002)(31696002)(6486002)(8676002)(66556008)(66946007)(53546011)(186003)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aTc3NG1iN2FabzVsTEhvSnhOMUJUM3RTVy9pUTk3OHF5eHE0VUQza0Rhbk1s?=
 =?utf-8?B?R0o5VUZ2d0YwcnJGVVFkdnFhWGh3bythU1JJRkFBY3BTNDkzRGJLbGF2Unk2?=
 =?utf-8?B?S2ZhYy93WUh1NjA3anQ3R3F0Q3ZVVFBvL0NsRGY0NHVvSXpIMG1YUkNtR1Bk?=
 =?utf-8?B?ZWhCZXM3WnNyb1JPVHlFemlrMTlLc0dHbUlnQmxtR01kSlplTVpmKzd5aElB?=
 =?utf-8?B?YXpaZUZKdlhLbnlmWGdJNDRkWWVHb3ZNR3pvWUk0QTNuZnNCelVUSHYzT2Ex?=
 =?utf-8?B?d3NJLzJUVFBXVy9jY2RBeFdhcFhxNHJpSkN1S1pxQlMwMXZjQ0FyRmI3QjRy?=
 =?utf-8?B?VnpReWJFTEUxWUs2QXAyK3dzTGYwWnFCVVBPbnNJZ2RFaWVxQU5pNVo3c25t?=
 =?utf-8?B?Z2FabkhLTW1KZkFPMEVuelR4TVZUNXRiZEUrSnIvRnpPQUZGZEQ0ZGMyNzAz?=
 =?utf-8?B?bTByZ0ZuMjFCNzByWVZLbHpGU21BdzhNYk1tSjJpaUtzdUtHeXBHOWlROWkx?=
 =?utf-8?B?OG5HRUIyTFlwdlhxcHlQQWNuNnRta1pYMG9KZHlpZzUrdnNCbGJRemRBUE04?=
 =?utf-8?B?cXlucm1YcWdxditkV0o0M0ZEYVNaMmUyaDBmQjY4Sms3cG5vR0h2U01kc0Vm?=
 =?utf-8?B?Qkx0V0JiNXEyRDcybXRyRUtuN1o5NWlLOWxRdzJoWDh3OHBVbVVpR0tFdzl5?=
 =?utf-8?B?NjZ6TmI3eFZGYjh4aHZxcHBRclROcGF0YlZhd0JBd045c2VPK3JoaUZ4cjJj?=
 =?utf-8?B?U2NXd2lsaWlBcnFZTGpPdEtmUHh5TTJEVjBKbFlpdURzYW44aE9PdElKRllJ?=
 =?utf-8?B?VXFLd3g5OTlNckdNNVUremJUalUyY2F6a3NvSEx2ZnN1Tk9QNllBQVlmdDI1?=
 =?utf-8?B?U2R4VUI2ZktGSWtLTVJUK2ZmYjFyUXBWVVB1T1lGTGtKSDUreTAzZHBUYUxv?=
 =?utf-8?B?U2tSYXdQclByVG9VK0p4eTczUkk1QWc4S0xEVXhpc2M3SldlcThyeFAxYVdq?=
 =?utf-8?B?Ty85Y2d0dVE3M3dhY1pKOFZpeGgvQ1c0YVZLeW5qMElJLzc5RlJTdGU4TVVn?=
 =?utf-8?B?ZWp1eHUzTzVSREFtdFQwd0t5NjJNbVdnU0F2d3hjRjhMcTlxTlg1UTNtaVpw?=
 =?utf-8?B?YjAvMGkwdm9EMDFTenlhWGJ3d3ltUytZN2lER0RhUTVURUprYzBxYlhDT3o1?=
 =?utf-8?B?ZUUwTDIrc3dqRUY0QWppTUx4YnkwdDBSZzFWaDJydXU3aDdzOUs3TlVrLzRJ?=
 =?utf-8?B?MUpXYklLQzhMWFhNVWNuekJlWHltUzVMSklmVEpQVnc1UUJLWnZFcXc4MjM4?=
 =?utf-8?B?NHdzcTZ5MFNmNUVocERJT29icGl1Wm1EU0pyOU1ta1BNVFpTaldONHh1enlx?=
 =?utf-8?B?K3cvTFZ6dWkyQ0FJY1hWRnlOOWlNWjJDS0JRckQ5K1oyS3J2Y2ZXWlc2ZVI3?=
 =?utf-8?B?SzlCSEV4VWVudENlbkVla3BrNi9MbkVndjRFY0xtK2RaZ2p0amtoSWI5U0s0?=
 =?utf-8?B?WmJiRi9mV3FFRnNZbFlyeWRlMU9Id2c1Wk1mZUJESi9JSTRjSmlMV2pvVXM5?=
 =?utf-8?B?bkM4Q3hTQjE0NjZFRllFYm0wallRTCtrNDVqSkMvUVlZekR2aHczYXUyZkF2?=
 =?utf-8?B?Y3hvTjRuaVZtZTBEVzAzd2RpOXp4TXM2RGQ0RjdDS0tXRTIwdEQ4OUttOGw3?=
 =?utf-8?B?MmM0U3R1dzgxMng1OHkzR295b0lNNG5Ybk96RHNrVkJWd3BOOUdIYndPelM5?=
 =?utf-8?Q?NNkVRGzNDi2dYkVtYXRMJOBQOTf/JmWQk+hMBbw?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afd789d9-14cf-418c-897f-08d921731f61
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 00:54:18.2152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FgqoQ1qbY9hcQMmq3cvL0RYwcXxrIAskLILva/ItDXMzCZiEHkAxkCytcYXAoDjt3jt7uMQs7BZzOQWpfLBLxCdUgL4voNK8L9G7yCDi8x8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4510
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9997 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105280003
X-Proofpoint-GUID: ei3abbkxvoREMSLlm1pZ9O6uAxtHFUtr
X-Proofpoint-ORIG-GUID: ei3abbkxvoREMSLlm1pZ9O6uAxtHFUtr
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9997 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105280004
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/19/21 5:12 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> To allow for iclog IO device cache flush behaviour to be optimised,
> we first need to separate out the commit record iclog IO from the
> rest of the checkpoint so we can wait for the checkpoint IO to
> complete before we issue the commit record.
> 
> This separation is only necessary if the commit record is being
> written into a different iclog to the start of the checkpoint as the
> upcoming cache flushing changes requires completion ordering against
> the other iclogs submitted by the checkpoint.
> 
> If the entire checkpoint and commit is in the one iclog, then they
> are both covered by the one set of cache flush primitives on the
> iclog and hence there is no need to separate them for ordering.
> 
> Otherwise, we need to wait for all the previous iclogs to complete
> so they are ordered correctly and made stable by the REQ_PREFLUSH
> that the commit record iclog IO issues. This guarantees that if a
> reader sees the commit record in the journal, they will also see the
> entire checkpoint that commit record closes off.
> 
> This also provides the guarantee that when the commit record IO
> completes, we can safely unpin all the log items in the checkpoint
> so they can be written back because the entire checkpoint is stable
> in the journal.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
Ok, makes sense
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_log.c      | 8 +++++---
>   fs/xfs/xfs_log_cil.c  | 9 +++++++++
>   fs/xfs/xfs_log_priv.h | 2 ++
>   3 files changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 0e563ff8cd3b..4cd5840e953a 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -786,10 +786,12 @@ xfs_log_mount_cancel(
>   }
>   
>   /*
> - * Wait for the iclog to be written disk, or return an error if the log has been
> - * shut down.
> + * Wait for the iclog and all prior iclogs to be written disk as required by the
> + * log force state machine. Waiting on ic_force_wait ensures iclog completions
> + * have been ordered and callbacks run before we are woken here, hence
> + * guaranteeing that all the iclogs up to this one are on stable storage.
>    */
> -static int
> +int
>   xlog_wait_on_iclog(
>   	struct xlog_in_core	*iclog)
>   		__releases(iclog->ic_log->l_icloglock)
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index b0ef071b3cb5..1e5fd6f268c2 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -870,6 +870,15 @@ xlog_cil_push_work(
>   	wake_up_all(&cil->xc_commit_wait);
>   	spin_unlock(&cil->xc_push_lock);
>   
> +	/*
> +	 * If the checkpoint spans multiple iclogs, wait for all previous
> +	 * iclogs to complete before we submit the commit_iclog.
> +	 */
> +	if (ctx->start_lsn != commit_lsn) {
> +		spin_lock(&log->l_icloglock);
> +		xlog_wait_on_iclog(commit_iclog->ic_prev);
> +	}
> +
>   	/* release the hounds! */
>   	xfs_log_release_iclog(commit_iclog);
>   	return;
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 037950cf1061..ee7786b33da9 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -584,6 +584,8 @@ xlog_wait(
>   	remove_wait_queue(wq, &wait);
>   }
>   
> +int xlog_wait_on_iclog(struct xlog_in_core *iclog);
> +
>   /*
>    * The LSN is valid so long as it is behind the current LSN. If it isn't, this
>    * means that the next log record that includes this metadata could have a
> 
