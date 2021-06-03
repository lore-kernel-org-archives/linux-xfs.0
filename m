Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 477ECC47096
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 22:29:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E5F8613F1
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 22:29:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbhFCWbf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Jun 2021 18:31:35 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52960 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbhFCWbf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jun 2021 18:31:35 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 153MKars035056;
        Thu, 3 Jun 2021 22:29:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=AHjVHC3y3/e7ZFdHwyay4NjFsOjrZE2wCKJSTSwCxeg=;
 b=CAZkC6tynTOKxlHri2EWzxITZMzoMcS4aew4Eh2KRe63RbCMQajaHiOQH7PCJuK6oHSr
 K38eHjIpDaWdl8gH5Y3wuh//KjTvummSAYDLRcf95MJw+7naDQr/La2PcFgTklnZfeYb
 4DgF5aeEwuiR+taI9Yv8ROdIKNgWkiYvS+iE8bvnNwSPBSU2FTM6CxIWe1A9pKSnufXi
 90lY3QFO8JEzOgTPKHWr46qSVMIHXqqLq21Pwc9bylpfl4aTGU4ByiS0WhuIQtUX3Ttn
 Oj2ZI+EfgqxKZLv7437h7fFMUWcuhMeahn4laGwppapxM2vsF/pdCdpF4/+JDjfHVX+p iA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 38ud1smj2f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jun 2021 22:29:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 153MK7Wh031487;
        Thu, 3 Jun 2021 22:29:48 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by userp3030.oracle.com with ESMTP id 38uaqypcry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jun 2021 22:29:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TfM8y6RDoPr8g8QMJ1b3GFYFKHX1duj+K6DjV3G76M0XB2d+tVWG6xxiB2dfn5MLoXsg590NB/jXSUgGvZlRpYpIT2GGwSW2/HF/fQL8lEsd2eNoiZwAV5bGzFD6Hx+6fJvRNsrHgxMOc7SheggKsQkuQzSzkRl3ghmRuAZeWsRC0+3OyGU4lLJX3u4liTk/kn34KrFWHYIxUwKhBH1EIXbAo02YkwaigTQYEJxHTL9NCPuyCjYrLKA2eEn6qEkK+mnk6y/yZxuUEXXKNbVskKIChYmm7O9JsiN8u1jPJwaLvXWlxXES+/rAsnRTeQZi//PaqsbEOTKzPHIHp0u+Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AHjVHC3y3/e7ZFdHwyay4NjFsOjrZE2wCKJSTSwCxeg=;
 b=DqQ8TuJa7ZlfQb4ylZITtCQfMxWD6apmSOBQRaWQLVZSVk43H3sFZWie1xMoo8tbBNkdhjrzHZo97YM6O1EyTcpNefNVpilga9FP71pzAK0s2xA6h7RMZyDkjvY2fAYaVNsKpP/YBdPY6Wco3Q4sxCPYOojOdPe2lnT7p6PXoHwKIZe5qiwSVJH7kn5IIO+DcpvA7iZaIfneOduw/xUF9Ae5gdT4IoX6T3bHWsWA6e1EVdHiMM7CHoYQpdT+NE+vJ9gAd2LDKQ9l2mIWbOEyQoReZY5dmBOxaiSDDoskZLQPko3CIc/RPWpylXtqQeV5DRIl+oCoXsvG8rbj1CcLuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AHjVHC3y3/e7ZFdHwyay4NjFsOjrZE2wCKJSTSwCxeg=;
 b=l8pLr7mX4wSCWCftDICiyfzBRE+F1ECgPNkxrLuxT4w9aai+CitNIdPn3oBDKEkwfk+oDHgnPI0V8XCwbizjpOKuAVFFmLGvUeUcP14r6BpxBuH/zL8kxnqslxVGyj3hLi+gVqg23HVs9LyqRR5slVpYhUWg3vzu2X3Ac4itcOY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2712.namprd10.prod.outlook.com (2603:10b6:a02:b3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Thu, 3 Jun
 2021 22:29:45 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728%5]) with mapi id 15.20.4195.023; Thu, 3 Jun 2021
 22:29:45 +0000
Subject: Re: [PATCH 08/39] xfs: Fix CIL throttle hang when CIL space used
 going backwards
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20210603052240.171998-1-david@fromorbit.com>
 <20210603052240.171998-9-david@fromorbit.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <15087e77-b553-ef41-8298-1b1a45f5acae@oracle.com>
Date:   Thu, 3 Jun 2021 15:29:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210603052240.171998-9-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: BY5PR17CA0067.namprd17.prod.outlook.com
 (2603:10b6:a03:167::44) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.210.54) by BY5PR17CA0067.namprd17.prod.outlook.com (2603:10b6:a03:167::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22 via Frontend Transport; Thu, 3 Jun 2021 22:29:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d05e9bb7-27cd-42dd-414e-08d926df16d2
X-MS-TrafficTypeDiagnostic: BYAPR10MB2712:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2712295CCD6DA5E2B1441E8C953C9@BYAPR10MB2712.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fRJOjj3rj2/DEqWE1ahU/BHWn1YzrRIkGnZY8Yd4rZw1iWj4dVB0sPfTeAjKrtut/0HPiJCquc3fWSe94HiHd0RZHhGB28QJSinvDRVQM1QNxAXLWmqUK+uYp+WDEtwU3J3JGk7TD0ZlYlkCGtrghk+GBdUda50gU///zbb/77Kl/Msj/NAj6p4H9Oq0Vol+YWZ1HFS3RpvUqYVkIW04sfQlfyjS0yGlmMFE5LSz2M/q6HU2h9pxwEM6bzeau/606nJmn25qUw4BWkbArTQJAEwMoOe2XfVHNCk7cbKn4P8Va07RSjELtGilkC59HBQJizVDFFze7RlTe8fVDBpPphVApxOhVGNeuA2iCzS1BjczWEpFtw4/qon9FeWFMFznTCSkwbD5xER1MWUKc0PBbsCURnD8o35QbrqrOR0fFFJicGU1ypU/gtkfW3OmG/YkuyuireRO+CBpBkhs9PqYsmyexkphtyMwgSkTPKXO3sf3qELu3c+IETIIMzg4oPqbV/1NLqp+TL1e7DDpKISxrmDZTL+Tzss0/X3gsaUKy8mhWp3m1ls7ENPH75l4FP+Jf3udfh4cLFVqI/PpKCRuoP+Osvp0mPiOG3abbX6jXvW09dXqDW9b2tlM9iSWWkdXN0PJAxOA8C7D7trsnLs25zaQo/euULhwVlrKnh7LCtp9MLOh/aemoCfCQQT0VrJshh0ltiuyw+fowF7OgxrrmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(396003)(366004)(136003)(346002)(16576012)(316002)(30864003)(66946007)(36756003)(44832011)(8676002)(31686004)(83380400001)(66476007)(5660300002)(66556008)(186003)(26005)(16526019)(38100700002)(38350700002)(956004)(86362001)(31696002)(2616005)(8936002)(478600001)(2906002)(6486002)(52116002)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TVZFbGUxakJFT1RYRXUwa1FORVpUWUlqaTJuRjR1RTZ3Q2wwK01JRFZ6a20x?=
 =?utf-8?B?MUc0bUdUeXp3L2FGek5aVkNTdVdhN2tYMDR5MDlQUC9pZyswMzBveEd4VFNp?=
 =?utf-8?B?eXowM2hraDJVekZuOGVacTdmWi9vK3oxT0JDdG5JN1FvU2YrTjlHeVlFZ2lj?=
 =?utf-8?B?dE5OYjlOUXFhWEM5c0RXWTJiblA1bTl2TnR4SVdMOXNRcHFXM25RN2U2bkFl?=
 =?utf-8?B?Nm84dFlsUTdVR1JMNkJMOUlNMnFBRmJzL3VkTFozNzJrYzF0ZE5uMGN6V2J4?=
 =?utf-8?B?ejdyNXo4N3A4RXh1dWZJYiswM3NYSUhTUTN4K2txaFRHcXphVk9QOEZ5M2lH?=
 =?utf-8?B?am1yOWJGNG9WN204YjJ0V2trZStIYU80Q1lHODBWNyt6L2Nhc3NxbGp3YXpu?=
 =?utf-8?B?aFpnc21SVlZnV1I5dDRwaW1pbUJKQUpkU3dyalZta3ppSHFLK1VJUitGbDNa?=
 =?utf-8?B?LzZUN0JRZTZBL081blQySjNBMDRpRnFrRnN2TStXcmVlazM5aEhOSjVKVmtI?=
 =?utf-8?B?SDJoWmpOM3Vaem05Z0ZzajA4MERqa2Z3L3JzYWh6RE5rMXVmeVFKd0pCbjdo?=
 =?utf-8?B?UkhlRTQ3M2hIa08zTC9hU3lkcHVCMVphaWErUGUybE1aejBxQ0w0TDNJYkRX?=
 =?utf-8?B?MWg5djZzSEZXeHd4U3QydWs5bkx5dmZ0ZG1wTkxCdjBTL2N4Q0ZpTDU4Rm9Y?=
 =?utf-8?B?eGJ5UWZQQnI1ekhXaHdRYWtGRmkySUJFQWIvYitkVDYyUkY3TkVJNFBPL3lz?=
 =?utf-8?B?TndLWGJkUXN2T0RGSVpJSWl2aHNHTEhVTE1CZ2ppNXJpNzRsRkUzVjBYTTNq?=
 =?utf-8?B?YmFtcnpERzVvaGEvQTdPL0RRaEZTbjVHdno5VjlWWUxqNmMyekxIZTBLMk5D?=
 =?utf-8?B?a3NoYklRZDU1WERRZGJTdmozd0szdFRCVWZOMFZmcTNtT00xUit6QjlQbmc1?=
 =?utf-8?B?WjNpWGhhRGVzOEFKZ1ZjNE5ib2U2RDlNcHppRm9vYlpCczBuWEFhTG50b0pJ?=
 =?utf-8?B?SCs3ZWFmdXp0ay9TdjhsWkc5alJrQzlYVFJKT0k0YThLSzVGMFRkNTh6QmJa?=
 =?utf-8?B?ck5qMWhJZXVJNUFtMDJUd1R1WCtnWGFNK1o0REwyYi90dFZmQnVVczdobWVM?=
 =?utf-8?B?bGs0WTY4Umh3TEU4RU90dTV4NGhEL01XcVpFZ2Jxcy83TjF1UUJaYlJobCtt?=
 =?utf-8?B?WTYveXJWN0gveHBwUXNNK3RhdXhQbE1pVmVWU2tvQ2JIME5kYXAyalFkOTI5?=
 =?utf-8?B?aTBOSHp6QkwxYzRGQTBpc1M4TVZ5VHd0SE03R2hPaFhmNlVGM0liN0svb1No?=
 =?utf-8?B?MzJMWUhHZjQybkF3bi9sQWpacFNoZFVQS0J5VkN5REJMc0VvVkRrcnpJYUdP?=
 =?utf-8?B?ZnB5YTVvdlljTjhITG9PVDRhcitoZDFNb1U3TzhXYW5FenlUdnBiLy9tdlRW?=
 =?utf-8?B?b2hDRi9Ea2RKdzlSR3lwK3IwdUNYV0cycjMwb1pERHpnZVZmR0VTdkI1TFlX?=
 =?utf-8?B?ZFkxTXNibHNtL25nMkNWdmQ2bEhrSW8wVFV1RVZuUDE3bnB2MXdlNklaa2pZ?=
 =?utf-8?B?UDBhT0FFYjhuMHRWNHB2NzIvVld5VTJOdm14dTJSNWVQZzVHZDVuaGJEcXdj?=
 =?utf-8?B?bDh3WHEwTE55SlRjVUdQWFVoNkdPaS9zcFBsZ2hNZmI2Qk80YlRxYkE2Nllp?=
 =?utf-8?B?eVFmVngyeFp3M0E1TjFFclVtVkZIbEd2RkRWUkZpZi9zZ1htY2FaVnd2cXlu?=
 =?utf-8?Q?e8Ymw0fbTb3a3/P07up4KN/RzdRr7GHs4Q+VrI8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d05e9bb7-27cd-42dd-414e-08d926df16d2
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 22:29:45.2842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3fosFyTIPnPllprKLPQoV6bRHw0z98uxrsaj7njTI56/KMe+N0m+iAf+EPdOxkmuJtIL2I/yvWZKmwp5K+2sS+tNhV2ttIfHXZ3TyHkqR7k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2712
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10004 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106030148
X-Proofpoint-ORIG-GUID: oWX59Q1UI034q3P2K62EAkm0Q_ncnyPw
X-Proofpoint-GUID: oWX59Q1UI034q3P2K62EAkm0Q_ncnyPw
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10004 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 suspectscore=0 phishscore=0 lowpriorityscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 spamscore=0 impostorscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106030148
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 6/2/21 10:22 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> A hang with tasks stuck on the CIL hard throttle was reported and
> largely diagnosed by Donald Buczek, who discovered that it was a
> result of the CIL context space usage decrementing in committed
> transactions once the hard throttle limit had been hit and processes
> were already blocked.  This resulted in the CIL push not waking up
> those waiters because the CIL context was no longer over the hard
> throttle limit.
> 
> The surprising aspect of this was the CIL space usage going
> backwards regularly enough to trigger this situation. Assumptions
> had been made in design that the relogging process would only
> increase the size of the objects in the CIL, and so that space would
> only increase.
> 
> This change and commit message fixes the issue and documents the
> result of an audit of the triggers that can cause the CIL space to
> go backwards, how large the backwards steps tend to be, the
> frequency in which they occur, and what the impact on the CIL
> accounting code is.
> 
> Even though the CIL ctx->space_used can go backwards, it will only
> do so if the log item is already logged to the CIL and contains a
> space reservation for it's entire logged state. This is tracked by
> the shadow buffer state on the log item. If the item is not
> previously logged in the CIL it has no shadow buffer nor log vector,
> and hence the entire size of the logged item copied to the log
> vector is accounted to the CIL space usage. i.e.  it will always go
> up in this case.
> 
> If the item has a log vector (i.e. already in the CIL) and the size
> decreases, then the existing log vector will be overwritten and the
> space usage will go down. This is the only condition where the space
> usage reduces, and it can only occur when an item is already tracked
> in the CIL. Hence we are safe from CIL space usage underruns as a
> result of log items decreasing in size when they are relogged.
> 
> Typically this reduction in CIL usage occurs from metadata blocks
> being free, such as when a btree block merge occurs or a directory
> enter/xattr entry is removed and the da-tree is reduced in size.
> This generally results in a reduction in size of around a single
> block in the CIL, but also tends to increase the number of log
> vectors because the parent and sibling nodes in the tree needs to be
> updated when a btree block is removed. If a multi-level merge
> occurs, then we see reduction in size of 2+ blocks, but again the
> log vector count goes up.
> 
> The other vector is inode fork size changes, which only log the
> current size of the fork and ignore the previously logged size when
> the fork is relogged. Hence if we are removing items from the inode
> fork (dir/xattr removal in shortform, extent record removal in
> extent form, etc) the relogged size of the inode for can decrease.
> 
> No other log items can decrease in size either because they are a
> fixed size (e.g. dquots) or they cannot be relogged (e.g. relogging
> an intent actually creates a new intent log item and doesn't relog
> the old item at all.) Hence the only two vectors for CIL context
> size reduction are relogging inode forks and marking buffers active
> in the CIL as stale.
> 
> Long story short: the majority of the code does the right thing and
> handles the reduction in log item size correctly, and only the CIL
> hard throttle implementation is problematic and needs fixing. This
> patch makes that fix, as well as adds comments in the log item code
> that result in items shrinking in size when they are relogged as a
> clear reminder that this can and does happen frequently.
> 
> The throttle fix is based upon the change Donald proposed, though it
> goes further to ensure that once the throttle is activated, it
> captures all tasks until the CIL push issues a wakeup, regardless of
> whether the CIL space used has gone back under the throttle
> threshold.
> 
> This ensures that we prevent tasks reducing the CIL slightly under
> the throttle threshold and then making more changes that push it
> well over the throttle limit. This is acheived by checking if the
> throttle wait queue is already active as a condition of throttling.
> Hence once we start throttling, we continue to apply the throttle
> until the CIL context push wakes everything on the wait queue.
> 
> We can use waitqueue_active() for the waitqueue manipulations and
> checks as they are all done under the ctx->xc_push_lock. Hence the
> waitqueue has external serialisation and we can safely peek inside
> the wait queue without holding the internal waitqueue locks.
> 
> Many thanks to Donald for his diagnostic and analysis work to
> isolate the cause of this hang.
> 
> Reported-and-tested-by: Donald Buczek <buczek@molgen.mpg.de>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Ok, makes sense.  Thanks for all the commentary
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_buf_item.c   | 37 ++++++++++++++++++-------------------
>   fs/xfs/xfs_inode_item.c | 14 ++++++++++++++
>   fs/xfs/xfs_log_cil.c    | 22 +++++++++++++++++-----
>   3 files changed, 49 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index fb69879e4b2b..14d1fefcbf4c 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -74,14 +74,12 @@ xfs_buf_item_straddle(
>   }
>   
>   /*
> - * This returns the number of log iovecs needed to log the
> - * given buf log item.
> + * Return the number of log iovecs and space needed to log the given buf log
> + * item segment.
>    *
> - * It calculates this as 1 iovec for the buf log format structure
> - * and 1 for each stretch of non-contiguous chunks to be logged.
> - * Contiguous chunks are logged in a single iovec.
> - *
> - * If the XFS_BLI_STALE flag has been set, then log nothing.
> + * It calculates this as 1 iovec for the buf log format structure and 1 for each
> + * stretch of non-contiguous chunks to be logged.  Contiguous chunks are logged
> + * in a single iovec.
>    */
>   STATIC void
>   xfs_buf_item_size_segment(
> @@ -168,11 +166,8 @@ xfs_buf_item_size_segment(
>   }
>   
>   /*
> - * This returns the number of log iovecs needed to log the given buf log item.
> - *
> - * It calculates this as 1 iovec for the buf log format structure and 1 for each
> - * stretch of non-contiguous chunks to be logged.  Contiguous chunks are logged
> - * in a single iovec.
> + * Return the number of log iovecs and space needed to log the given buf log
> + * item.
>    *
>    * Discontiguous buffers need a format structure per region that is being
>    * logged. This makes the changes in the buffer appear to log recovery as though
> @@ -182,7 +177,11 @@ xfs_buf_item_size_segment(
>    * what ends up on disk.
>    *
>    * If the XFS_BLI_STALE flag has been set, then log nothing but the buf log
> - * format structures.
> + * format structures. If the item has previously been logged and has dirty
> + * regions, we do not relog them in stale buffers. This has the effect of
> + * reducing the size of the relogged item by the amount of dirty data tracked
> + * by the log item. This can result in the committing transaction reducing the
> + * amount of space being consumed by the CIL.
>    */
>   STATIC void
>   xfs_buf_item_size(
> @@ -199,9 +198,9 @@ xfs_buf_item_size(
>   	ASSERT(atomic_read(&bip->bli_refcount) > 0);
>   	if (bip->bli_flags & XFS_BLI_STALE) {
>   		/*
> -		 * The buffer is stale, so all we need to log
> -		 * is the buf log format structure with the
> -		 * cancel flag in it.
> +		 * The buffer is stale, so all we need to log is the buf log
> +		 * format structure with the cancel flag in it as we are never
> +		 * going to replay the changes tracked in the log item.
>   		 */
>   		trace_xfs_buf_item_size_stale(bip);
>   		ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
> @@ -216,9 +215,9 @@ xfs_buf_item_size(
>   
>   	if (bip->bli_flags & XFS_BLI_ORDERED) {
>   		/*
> -		 * The buffer has been logged just to order it.
> -		 * It is not being included in the transaction
> -		 * commit, so no vectors are used at all.
> +		 * The buffer has been logged just to order it. It is not being
> +		 * included in the transaction commit, so no vectors are used at
> +		 * all.
>   		 */
>   		trace_xfs_buf_item_size_ordered(bip);
>   		*nvecs = XFS_LOG_VEC_ORDERED;
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 6764d12342da..5a2dd33020e2 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -28,6 +28,20 @@ static inline struct xfs_inode_log_item *INODE_ITEM(struct xfs_log_item *lip)
>   	return container_of(lip, struct xfs_inode_log_item, ili_item);
>   }
>   
> +/*
> + * The logged size of an inode fork is always the current size of the inode
> + * fork. This means that when an inode fork is relogged, the size of the logged
> + * region is determined by the current state, not the combination of the
> + * previously logged state + the current state. This is different relogging
> + * behaviour to most other log items which will retain the size of the
> + * previously logged changes when smaller regions are relogged.
> + *
> + * Hence operations that remove data from the inode fork (e.g. shortform
> + * dir/attr remove, extent form extent removal, etc), the size of the relogged
> + * inode gets -smaller- rather than stays the same size as the previously logged
> + * size and this can result in the committing transaction reducing the amount of
> + * space being consumed by the CIL.
> + */
>   STATIC void
>   xfs_inode_item_data_fork_size(
>   	struct xfs_inode_log_item *iip,
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 9d2fa8464289..903617e6d054 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -670,9 +670,14 @@ xlog_cil_push_work(
>   	ASSERT(push_seq <= ctx->sequence);
>   
>   	/*
> -	 * Wake up any background push waiters now this context is being pushed.
> +	 * As we are about to switch to a new, empty CIL context, we no longer
> +	 * need to throttle tasks on CIL space overruns. Wake any waiters that
> +	 * the hard push throttle may have caught so they can start committing
> +	 * to the new context. The ctx->xc_push_lock provides the serialisation
> +	 * necessary for safely using the lockless waitqueue_active() check in
> +	 * this context.
>   	 */
> -	if (ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log))
> +	if (waitqueue_active(&cil->xc_push_wait))
>   		wake_up_all(&cil->xc_push_wait);
>   
>   	/*
> @@ -944,7 +949,7 @@ xlog_cil_push_background(
>   	ASSERT(!list_empty(&cil->xc_cil));
>   
>   	/*
> -	 * don't do a background push if we haven't used up all the
> +	 * Don't do a background push if we haven't used up all the
>   	 * space available yet.
>   	 */
>   	if (cil->xc_ctx->space_used < XLOG_CIL_SPACE_LIMIT(log)) {
> @@ -968,9 +973,16 @@ xlog_cil_push_background(
>   
>   	/*
>   	 * If we are well over the space limit, throttle the work that is being
> -	 * done until the push work on this context has begun.
> +	 * done until the push work on this context has begun. Enforce the hard
> +	 * throttle on all transaction commits once it has been activated, even
> +	 * if the committing transactions have resulted in the space usage
> +	 * dipping back down under the hard limit.
> +	 *
> +	 * The ctx->xc_push_lock provides the serialisation necessary for safely
> +	 * using the lockless waitqueue_active() check in this context.
>   	 */
> -	if (cil->xc_ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log)) {
> +	if (cil->xc_ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log) ||
> +	    waitqueue_active(&cil->xc_push_wait)) {
>   		trace_xfs_log_cil_wait(log, cil->xc_ctx->ticket);
>   		ASSERT(cil->xc_ctx->space_used < log->l_logsize);
>   		xlog_wait(&cil->xc_push_wait, &cil->xc_push_lock);
> 
