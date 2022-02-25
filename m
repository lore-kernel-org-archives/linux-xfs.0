Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D67A7C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Feb 2022 10:42:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237427AbiBYKnI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Feb 2022 05:43:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233931AbiBYKnH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Feb 2022 05:43:07 -0500
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50118.outbound.protection.outlook.com [40.107.5.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3A00182D99
        for <linux-xfs@vger.kernel.org>; Fri, 25 Feb 2022 02:42:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oz7LoMl2SGSY8pEQNgCFWxjafZqF24hC3zi5Co7/ORhODivtMmcWn+IPQrTPumd6Qb27M8B3ImRgcdBubr/1zrhuY3JqDfVWWYoz6AYMAB5m83hT8tZR/lM70gSdcD7UjRtIbvNltHoKAwvPYNGix2w5IIvvxvAcvrv+sIgLQYuMoDt7v9BIJLTkT9DrEzEEEjN3dgZ9bMedIa/lAhPQLZwRIn/hjQowa3IrYUxJgRLe6sXvQrE9dyykHLQHpHJyqGYOtPrrZHZ20zWMNUUB/wmbryACBSXUKF+3TX8QS+fWx94NoA62VK20DLskhc9TpktRrtb7sGo6D37WaV/yQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PXLKkZQRu9T+jE7beq4JMHwhMmZmIIWxBaaFvbaenA4=;
 b=kqsZLvBzFKY+jBJto04ALzya08MSBN5w9Ldhaed+wiJ6kNOIfakB+0Wm139UqcANyiwVvOGYlWkxL0RglrHickAhsJpHh9zWJ2iDpSC44l+I3eiDd10U3bLEJUyNaXL/lad6hxT0ZQPxD/VTgOgYSz2QVeLg5FE9KudSRXmZsTSJB5h0diGSJqaNV29h1GOEk1KQsS/1uYyGUkZ5iaxdEEsLYgsgZFRaE0hHsfqYXq09kUG4z+tPRqT+YKszS0VoAxe8oEN81u0DvlQyBCfQOPUzs9/0aFFMqxUA5slHntIRHOP12cCas5tLr1xF8PhecZ3jLKxMVovO9M5Edx4nIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PXLKkZQRu9T+jE7beq4JMHwhMmZmIIWxBaaFvbaenA4=;
 b=CgfLLc0xPp8yc7IMMoAeU+kPADovAUcYIDVFBhdRS8+HEnu388I8TS1RiPgDASQqvbxom4H09ZXkZ17iF1s2kzi+o5kfAs5NdulmaZYGcs1Fa5ZpRZ8JyzN/wdXEBDiRLU9Mghn5BBqyyHuTZwce7AYh7QTAPW3aK1Y7nGZRmMs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from AM8PR08MB5732.eurprd08.prod.outlook.com (2603:10a6:20b:1d4::16)
 by DB6PR0801MB1798.eurprd08.prod.outlook.com (2603:10a6:4:3c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.19; Fri, 25 Feb
 2022 10:42:30 +0000
Received: from AM8PR08MB5732.eurprd08.prod.outlook.com
 ([fe80::6934:1cfe:5b49:dec2]) by AM8PR08MB5732.eurprd08.prod.outlook.com
 ([fe80::6934:1cfe:5b49:dec2%4]) with mapi id 15.20.5017.025; Fri, 25 Feb 2022
 10:42:30 +0000
Message-ID: <e7cbc35c-386b-3323-0cef-da1ebf358f1a@virtuozzo.com>
Date:   Fri, 25 Feb 2022 13:42:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH] xfs: do not clear S_ISUID|S_ISGID for idmapped mounts
Content-Language: en-US
To:     Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, christian.brauner@ubuntu.com, hch@lst.de
References: <20220221182218.748084-1-andrey.zhadchenko@virtuozzo.com>
 <20220225015738.GP8313@magnolia>
 <20220225094517.cd7ukcczezhspdq5@wittgenstein>
From:   Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
In-Reply-To: <20220225094517.cd7ukcczezhspdq5@wittgenstein>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0036.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::18) To AM8PR08MB5732.eurprd08.prod.outlook.com
 (2603:10a6:20b:1d4::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9bc689f1-c460-4b96-ea94-08d9f84b85d1
X-MS-TrafficTypeDiagnostic: DB6PR0801MB1798:EE_
X-Microsoft-Antispam-PRVS: <DB6PR0801MB1798DBD857C1E65764390937E13E9@DB6PR0801MB1798.eurprd08.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GpSbo0jkp8XXWMwVbmM3cvMbMR6t5LZ6Mw2Kd7Uh2fowmoohe4sSOX5BMrcc4Pn/OqendBBE6iKtYZeB6pGSvtAVDtGhqj3pgUNzV29voIFM60VG8v+hu5x7oURvamq2vn06rMmy9jHN5HRwck3KmtQD1+HGXxm564XwapzkxYi6GVz+3/deweo5x+OIzmn8prmMh3IXuC4xeWFP3YtSodsFOM3hpG4gQStAZWPvTwvCLRuRv29yFjSkVpc0SUsVIByf04+uF8mCW4cQdtT/v3isXEKimfUFvJMYXJYV2Bsmn9oZOLTzePBQWJQE1q0IT81Kpd5vyOgZUSBWo+05Y6vLN/K4yNPLQaO+1EVrp8aj5Kc20aIClENCQ8MzLB9ms82LbAVKxmeUCI81q0CYqZBZzuIaaNKctT1dANfS867DGtH0hnAeusymTMT2x/FKMud8JVOuVE/ol8H771Toe5lM1a4+7RZbwmYBBVSIb8uYL6XI7VM0hGFr8rEUEDX/4N2SEl4kWZNl03+0KxfQ749yr7dZBbItb8jTw9TvgMi0ldoUgNNf7IAcAJENV3FaPn40jUb8aRjXiIoXWzwjxqmvgz1hEvk4AP9N6kufRPL95PBhss5HgV3wmGeYfriKnY6mKLApz9FzEiiR8aE6+kdqT8/YErieZRHgvbFCSH0v6z/ONdCVMkugSHgddICXOKdma7x+EaHHyu25hvT8vu1e+CJUb+c7y4fFp8ffEW8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR08MB5732.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(2906002)(38100700002)(31696002)(53546011)(36756003)(2616005)(4326008)(6486002)(6512007)(508600001)(5660300002)(110136005)(26005)(8936002)(44832011)(8676002)(6506007)(316002)(6666004)(31686004)(186003)(66476007)(66556008)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M1d1M2hzK0tzNWNXa0J2QWM3cDBsN0tBbUlrMTQ1UG5XVkRpRU1OOElqOFJO?=
 =?utf-8?B?Q1ZYd1hlcENoNTllWTBSaUI5RnFIL0dUTHMrVDZaQjBoSDUrMmwvWjJ1TXNJ?=
 =?utf-8?B?VDlOdmt3dzQzRVRVL09DdkZ5LytKSDR3VHRDVERvSjNndFIvMkNMYmR2UnhP?=
 =?utf-8?B?MzVveWtFNis3cWtnd2hkR2ZtQXhqeDVXOTlpMWFPYmpza09jbG1FRjN2bzNu?=
 =?utf-8?B?RWV1YXhKWk9oUFNyNmJhZWtNWFBUZzduMVFnc2l6S3BkaTVVK2JiNVBVQllC?=
 =?utf-8?B?ZEI5bk01bVpWNnhxNG5PclVWMkxuUHhCTWI1ZzduWmdob3JzS1l4bWJMcm03?=
 =?utf-8?B?Y2k0WkhDZ08xN2xlRkNxdHFuU0lMNFZERk43MHZIbkp2cVNyc1oxbHp6TjhO?=
 =?utf-8?B?eGFOZ2JiTGhNRzc2aGsyZ2k3cXVIVmhpRWNndE1pbnJVS05pMnVjV0JNNlRw?=
 =?utf-8?B?Q3NtWE5oTkdWL3Fua1pmSXYyVHhibm5ObmY0d3dCSlBzSG1JTnhWcmZSVVJF?=
 =?utf-8?B?UWtSOTBVNGJqcjJPN0R3YUNaTWxXNzQ1SlJHcnFBb2lOZWdkT1FGOEtibkgy?=
 =?utf-8?B?YkR3VVB5dmdad1NYdkR3UTRuMDh1a1dudGQ2N1dSNWJ5M3U3bVBFbFpWcm93?=
 =?utf-8?B?WUNJYXFYaUNGZG5yMm9YZTdBSWJLODQyY2s5TUFnNS9qMFhEVEdlcVFZVFEr?=
 =?utf-8?B?amd6ZlhlZDVyMjUrcDNDeFNMSExlVnUzb1c2K3YwZDhPc2IrcnBzQ0J6bllN?=
 =?utf-8?B?eVl2VEYwVld5WjhBTGNoVE9Qc0p0akRIcmtmSXdxNDZoNmRxQTNEYWtTeUUy?=
 =?utf-8?B?ZVh5eFVsWWZqUnA0WGZGUXVyTERyemxPaE9VTDJvL1hzVE5FMjl6NDJQWmpQ?=
 =?utf-8?B?UVFOTW5pdHNjVXg3dmM1RWYydzJhTWVvRE1Sa2xRK2Y0U1hINVBVNzVPbHdM?=
 =?utf-8?B?OWpUYUJ6MHFpeC9vZ25sOWlITGxwVEM1UGp4azVnR1BVdDczUDZjK1Z2ci9j?=
 =?utf-8?B?Uy9SVUFjY1pNcEllVkF6TWNYc290Q25rOUZrTTZWREhKYTN4VFZVb1Q5dUxv?=
 =?utf-8?B?TlkrV281cEtVSG00MTE3ZG5KSjZLaUo3TXR2LzFkS05SZGUybEgwMFRaenRR?=
 =?utf-8?B?dEt6MmpoRERicERteU55UzZCaWpkajEwUE9nWDhVck1uRGVZMjdJbWl4anRi?=
 =?utf-8?B?dWIyUk5vQmI0dEtiTVpEa0J3d09KSmtoekpzenNCcGl3a2FvdE5FNTErdFZl?=
 =?utf-8?B?TjNJMEtVL2F6OU5hOE5XTXFJU2oxZ2xQb01CZnhWd0xjMnZ0U1lGdXJBYUJs?=
 =?utf-8?B?UzZFek4xVnR3OVdUQStPNkhHcVQ1cE9kbzU1ZFZWN0tCWEZEbUVETWUzMGtB?=
 =?utf-8?B?Z2ZMc0FWSVp1eWRTOEJtR0xtd1pOQVlEVGs2ZzlkaW01VjlvbzkwOFo0NVhH?=
 =?utf-8?B?Ym1hZGxuK3NrUElycXAzYWxSdEFDbUNhUTBGUmV1cE5lYlU4SmQvWEMxdCtE?=
 =?utf-8?B?czhiZzQ2RUNUd1VMc0JlSkpVQ0ZyVTd6c3NQTGswdjRvRUdvekpuVmJ1N0p0?=
 =?utf-8?B?a1QrNDVIMnNEMU05SG9MV0VVTVZkdDQ1azJCbUlTOTFFWFVxVk1WZFJWOTgx?=
 =?utf-8?B?RmoycjFWUXdYdHpMamV5RnBlUHppS3BDbGFRYkd2MmwvSzBMNnpKQnBPREpO?=
 =?utf-8?B?SmY3SlE4YXpZN2Z4RUgveVNuNEs3QllkZWJqRG94aDZWa085ZXJ5OElBalVu?=
 =?utf-8?B?a1BwMGppM2RZME5ySVZuOWFSNnJmamFoMzFKc0xCWlFiMmFLTWNteTRuV2Fo?=
 =?utf-8?B?Ym53TURsSnZST3FWUE55cS95TkZOZkhlZ1ZpKzdLRmRkVHdXeDdsVjh1aTVY?=
 =?utf-8?B?ckR3bG9xTDAzc0htckZBdDBtenZEMUZHK3o2OTg5bFp5WkdtSXQvNUMvblEx?=
 =?utf-8?B?S2lEdXh5MGRkOXI5TGp0RHVuYTlkNTdBbnYvclVsclhqZmJ1STVIcHlIN3Jw?=
 =?utf-8?B?dVBhek10ZWhGVURpbnVaQXRuUFdLU2NITnlxOHNueXhIbVNSVWhKdno4R2du?=
 =?utf-8?B?d09PbE5wYlJiNEcxQUxJYzk3YkloZ2Nqd1IvTVlzWEk1b1UvQUV1T1l2S2RW?=
 =?utf-8?B?UWhHOXF3bDNzZ2RpYUtyWG1BbjZCQjdpbDc4MFdacnFDOFhGQkdReTVBc3FY?=
 =?utf-8?B?ejBaUFYrOWxnc3VDd0xIcElyK3ZBS050ZEFpVVVOSExBeHBSdGljSzRQcEty?=
 =?utf-8?B?K2t4eVVkbmNFb0Y2N3BkcG80amlnPT0=?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bc689f1-c460-4b96-ea94-08d9f84b85d1
X-MS-Exchange-CrossTenant-AuthSource: AM8PR08MB5732.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 10:42:30.3497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bEvCzKDfQPD4hbLq4yeFY4vFCOhXx1Wl72IgY/ZB/it2F+RxPxsL9VnernisUwSNRGnUl9Loh1ey2Deds9FOg1XmcYoY4U7kd3zWTII7IGw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0801MB1798
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/25/22 12:45, Christian Brauner wrote:
> On Thu, Feb 24, 2022 at 05:57:38PM -0800, Darrick J. Wong wrote:
>> On Mon, Feb 21, 2022 at 09:22:18PM +0300, Andrey Zhadchenko wrote:
>>> xfs_fileattr_set() handles idmapped mounts correctly and do not drop this
>>> bits.
>>> Unfortunately chown syscall results in different callstask:
>>> i_op->xfs_vn_setattr()->...->xfs_setattr_nonsize() which checks if process
>>> has CAP_FSETID capable in init_user_ns rather than mntns userns.
>>>
>>> Signed-off-by: Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
>>
>> LGTM...
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> Darrick, could I ask you to please wait with applying.
> The correct fix for this is either to simply remove the check here
> altogether as we figured out in the thread or to switch to a generic vfs
> helper setattr_copy().
> Andrey will send a new patch in the not too distant future afaict
> including tests.

Yes, please do not apply this patch for now. I am currently working on 
next version, however it is postponed a bit due to my personal affairs.
Also I intend to add a second patch for xfs_fileattr_set() since it has 
the similar flaw - it may drop S_ISUID|S_ISGID for directories and may 
not drop S_ISUID for executable files.
I expect to send patches next week alongside with new xfstests.
