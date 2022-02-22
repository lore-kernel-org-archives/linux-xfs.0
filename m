Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9749FC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Feb 2022 14:54:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbiBVOyj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Feb 2022 09:54:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiBVOyi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Feb 2022 09:54:38 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80104.outbound.protection.outlook.com [40.107.8.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C570210C513
        for <linux-xfs@vger.kernel.org>; Tue, 22 Feb 2022 06:54:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I83Mace18o8fuG7AFq1pxYh3tk9Co92O47T/2OUnCMouBr0Pz4+KAHvgP2Fmdwg75fgOFKqQvyC5+3wALmN7VCbLyY9AGq4yQuqYxmnGVatz9cz17j+9I0I3Tl6ZmRe1J8M2zkRlbtgbPzekeYJEfUFwLxXQd5yoYlDNdoX47180aNYAV5HMt92fMVV1/77I4m8patNFpVuLb1xeA5zaBAz7V/uIf1JzlI6qoQPmUhJ9b/sT/qiE/rtmDIwS9VTpdMgASolz5s7kzNSwP/yHGXTXOhSEsfu5j0aYLEJqLf3YDISN+Q7bDADnD0Q7x5TIOQ9IM3gJhEl031FL1xmQLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fr+CeNaj6jNFLVoUrxFxLLwT7MmlFfjEPB4Xy2wifTE=;
 b=eW6mZC3LhdfUP9kJExvdbRC/haAN+vt4yO3QS4zGeo3IQXil00GMMqIFGjj/oxRbr47Wvx8p3Sf2QOpTIng7Ngv3Kc2BzpccUJ5dsc232Fz9cFiStHUO4rkpDUYHU1uThxVskZLS4U730PcxujVUzDEAanN2NEXLcxqAXn3iAu8GRrc6WZmbCeGMHJHdPIzNQkixfcSYWvWeBH3nCuIe6lc/ox78HIqBXHdf80i6bs+Wcn8LU/Jy/1uEdda6eVJdvVH83nxG7cwbfW6dGBTnq9xkQIW7Z9DAL+vqSl3LxmntOnz3Je5S27HQLRsmD/j8O560V8sE3E52aFv1uHSkGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fr+CeNaj6jNFLVoUrxFxLLwT7MmlFfjEPB4Xy2wifTE=;
 b=wlbDuSsj1bJ9ACQlzXQ+GsQi1E7o06ipBMvA7gbVpMXVjt3OYyGPozcwNupw6Pp+6iJltenwbZGMWIchpfU/V+2nthy9vMpPUY+5sffc/JtqkDx4IT+8r0/v3AV9MYjimAPrIBJhX9I0DegS/gX5ShLkHWWDolnkzqYmk9zINFk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from AM8PR08MB5732.eurprd08.prod.outlook.com (2603:10a6:20b:1d4::16)
 by AM8PR08MB6548.eurprd08.prod.outlook.com (2603:10a6:20b:314::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Tue, 22 Feb
 2022 14:54:10 +0000
Received: from AM8PR08MB5732.eurprd08.prod.outlook.com
 ([fe80::6934:1cfe:5b49:dec2]) by AM8PR08MB5732.eurprd08.prod.outlook.com
 ([fe80::6934:1cfe:5b49:dec2%3]) with mapi id 15.20.4995.027; Tue, 22 Feb 2022
 14:54:09 +0000
Message-ID: <48bcd8ac-f9e5-a83c-604c-5af602cb362a@virtuozzo.com>
Date:   Tue, 22 Feb 2022 17:54:07 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH] xfs: do not clear S_ISUID|S_ISGID for idmapped mounts
Content-Language: en-US
To:     Christian Brauner <brauner@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        djwong@kernel.org
References: <20220221182218.748084-1-andrey.zhadchenko@virtuozzo.com>
 <20220222083340.GA5899@lst.de> <20220222102405.mmqlzimwabz7v67d@wittgenstein>
 <bdfa9081-1994-95f9-6feb-6710d34b33a1@virtuozzo.com>
 <20220222122331.ijeapomur76h7xf6@wittgenstein>
 <20220222123656.433l67bxhv3s2vbo@wittgenstein>
From:   Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
In-Reply-To: <20220222123656.433l67bxhv3s2vbo@wittgenstein>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0229.eurprd06.prod.outlook.com
 (2603:10a6:20b:45e::18) To AM8PR08MB5732.eurprd08.prod.outlook.com
 (2603:10a6:20b:1d4::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e5c9e65a-1326-46e8-d7e2-08d9f6132e86
X-MS-TrafficTypeDiagnostic: AM8PR08MB6548:EE_
X-Microsoft-Antispam-PRVS: <AM8PR08MB65485A8843258F55D4EFDA26E13B9@AM8PR08MB6548.eurprd08.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yt2gcG2CM+4A/5optwH66oAxfDFVJ1CNLT4vg0ohhIazR2+l3LyFTEHH9cIvEwyI8rh/mw/ymwRnLbzg4IPY+lFK6+VaaKgfUfMzocImUhIFw16jNYNyS00USNyuT0UlvNsNP2rdncIvMOWCL3JLH72nY01HpXEtETUOlfyeLwpgUzGrYkFquBKuam7yBKfgojLT4fQqKNNJMgyoJpn/jJsgNypkxKRfjxxRUb6heBW54qU0kt1hZ8trd4oKuhGFXB87KgHuWxOHYVXflfIx7XmN3ThIYXpjUyJjTtm0tQodLuln/yTzACZjGU9H7jLkTJhseAIQ78t3rc5USOajSzz7D/QVCCxjgpJX6WHNHUY4lKh/faj0l9fkXliDpNlZaqN4KusnzfjGiGjTj37LBsMGpxGYGxzFaduHdkF02Mg8MAI3m3O+QyfNj4d9jddZl3gEncRd1qWE071PKxfBR7RtvAi4B1bSFoIoVLDcfikKBVngm006iQJCj3owC2Ie39IBIdVkCvxjxw3SSrVj7sQtGFKYF6yUwdGyKhz/+dWs0fmAsVLgKn2PyyUp/XH41NaNrXv4N/wtfA3Md3MnZtvLSOhr7ZCC9Ne/L2niu9sKprICHZJvCxXvHnQUKEu3cUP6nSAGt2NS7mdTDOs/vCplJzLniy2Uhut9eD0I6ZbG1UD9rx3ijeUZ+rnUufze2q1DVxMyYAytHOb46/UaCPtaF/WGYdwYssy/8xBC5utIahzp+7lpKpuL9EF90wQCMn3080BqK9LGgalol9iExg+r6joPsQfKvBbuS5xRtxBwGD9ogA18tzYmgTt7RrOW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR08MB5732.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(4326008)(8676002)(53546011)(66946007)(186003)(31686004)(36756003)(66556008)(38100700002)(26005)(66476007)(508600001)(6486002)(966005)(6512007)(8936002)(86362001)(5660300002)(316002)(2616005)(44832011)(30864003)(6916009)(31696002)(83380400001)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WHdINU5yb2UycEd3N3FEazNkb1ltaEZOVkJlaU9OaEZ6Qy9rODczdTdiU1Fn?=
 =?utf-8?B?aVhGb1BGZ2xrY2h5OWdvNUlTaVc0amVUMHBhNEM5bDdBL2pJeEdzQk1HZDY1?=
 =?utf-8?B?WlZ0bjI3MklZNVREUDcrVUo2YmRqdWt1b0xtV3FpVk15K0gvUmRqdkx2V0FT?=
 =?utf-8?B?TmM1WTRrZFArbnNqWE9tUEw2UmZOWWE5d3ozT2FSZGZuZ2xISGNDdTlxando?=
 =?utf-8?B?RldOczYrNkxXbkxkdGFERWkrL0pOVG13c0xLZ2lEUERtNU95c29ueElwcVl6?=
 =?utf-8?B?eHRxb05EYXpCMVlKZ3ZtMndhb3FSaDRJaGVQLzM4UitIODIrazN2N3MwUG1o?=
 =?utf-8?B?eVpSNi94M2NveFkxZ3BGTzBGRWxXUVpDYTl3azlOWFVianNSNlRLZHRGazdZ?=
 =?utf-8?B?QWl0L0M1M3R2aEtJVllIOG4xMU16bmxiNUFBbDk3dUREcnZMS0R5Wlo3blI3?=
 =?utf-8?B?ZlErSWtiZm51dVlja25kTml0UlVtc0F1ZW41TmtXQkdHcXNQVzM2aWlveG1R?=
 =?utf-8?B?NWR1S0QxWVVRZHpmclJxYlYzb29zRVcxS2M0bHlPdm92Y29jL0RTaFN3c0lp?=
 =?utf-8?B?MTFhY1l0VHZZRFVHUU1ITW1BdEhHQlVBYnpRMkJhL2YwZmxteVJMSnVOQ0VF?=
 =?utf-8?B?WDBvWG5BYWtHdCs2UVh6Qk84cWNBSm1heUx4Qm52b3pJbEJ6VWNXWW1KdXpz?=
 =?utf-8?B?RUpSVDFWS21SZUV2OHVBb2M1Y0ZCQnhMRFNYMDlHUERKR1JNSHBjSWlhemR5?=
 =?utf-8?B?cVIvZ25HMHd4K1NuZWxTZDFmWXduWCtsSExXMzdWbk16MEZMcGlrejJ0bzVN?=
 =?utf-8?B?b0Q5RnFobXF3S2NwcTNFUFRyVUZUNjR5dFhUbDdCV0pTZ0JBWFBtT3RHckJv?=
 =?utf-8?B?NUhJcFdpbmRoZmZlQjU3ZnB4NmY1N1dQR0VCZjE5dDhjTkhQbHU4bjZFTVAw?=
 =?utf-8?B?dmVHdVBqRzhYSmEzdGNxM21xV3pYK0szN1h4bUk0NENraGZDbGI3c1k1ek9a?=
 =?utf-8?B?SUpDRDU2YmlMU1hHVEJBS1luc0h5UEYzblVqdWI0MjBTYWE3QUViYkRZZmVR?=
 =?utf-8?B?aFdSckViVTR6NUlBcjJUOGhEaEZmbXVSUUxDQWlZRkFhcGs0OEJmcVdvMEJn?=
 =?utf-8?B?dzNqOFVCSmc2b3pTM0dTbVJvOFBqNFdlMi80UFRPR05EVmwzSUdZNXpOYjVq?=
 =?utf-8?B?ZVFENnR0R1VPUGNlc3JLZkY4N1NzMTNsZDlOZ3hUUGUzTkZNZEFHRVJIQ2Jx?=
 =?utf-8?B?TzkxUko2NEsyb0xQbG1yQjhTNGR2TE84ODVUQ3JheTRYdnpjTWl4OFdCZ0Uz?=
 =?utf-8?B?UDg3eUo0eUkvTksvZzBCYTRFZFFOWW4ydEVxbnVhRzFtcTJxVTkyNm1FamFQ?=
 =?utf-8?B?V001aldNZnpZZzB6ZGI5SlhiMUFoK2xVZzkxejJvaDdJN1ZEZmN1TUJNK3VK?=
 =?utf-8?B?dTgrdTBQcGtHZU1FN3E5Zjg4V01nVFlvN0ErUkx1cjcrOGVnKzh6QytjUEpu?=
 =?utf-8?B?N1lIRUhSQ1pNUkFDK1M4anlZRkZEM1VFZ0Rya2JLaEJnbk1TcW9yTkRUOHFP?=
 =?utf-8?B?TFp5RkJpdDJCTzR0RlpaNVRnSi9vZVY1RURxZlVDV3pTWHFBVmVnVnBPc3FT?=
 =?utf-8?B?RFlJYXRRMFZMTkhHYXlHcmlQbzArOVN4VWkzZHJrY3pMTGhVVXNsMHpwNXp2?=
 =?utf-8?B?NHdpYS9hRXB3TndSMGdpZ1l6STRTRnJFUkZQNER0VDNsaUM3RWxJYmViK2Fh?=
 =?utf-8?B?NEhFR3VIWi9WUVZJZGhqU3JraktEdUViNWVLSEJtTGh3dTNsLytHdVg0ekl1?=
 =?utf-8?B?cEZnL082OFNCOFdMZWZKcWNKMEZLYmZ1L3N1RktmRXFkbXlrR09sVndpR09p?=
 =?utf-8?B?VCtwaTRnSHN4NWlDSk9uMzhkdHhmV2hicmQ5L0p6MERkTExKd2w5M0wvd3JN?=
 =?utf-8?B?bWJ0UlJqSi85MkZhQzh3UmRMYWhTcGVYVEc0M2w2YUN3RkdWdVN3MzN1c0Fn?=
 =?utf-8?B?SzRpRTgyaGNodVUwWmg4NnlLVzJTQW9rUGw5WTJXMDRQTlBqRDRSeDI5UkZD?=
 =?utf-8?B?YmYwVHBzZlB2eHp0aGZ1YUpwK09xWi9zMTV0Z2VHaDh2QWRyR2c3QjduVXVN?=
 =?utf-8?B?QlZBYmQ1eXNzMm1PdTJISHVXZmZWeXpvRmJka3J4bGo3SmJxd0hQQmRtVUxG?=
 =?utf-8?B?UytXWEF3SW10UEhCb09jVFBsUlQxNlBXKzUxWTYzOGtWVnVRUExuL1lGYjQr?=
 =?utf-8?B?bWFIVDNIVHNOd1UybmFBd096MFFBPT0=?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5c9e65a-1326-46e8-d7e2-08d9f6132e86
X-MS-Exchange-CrossTenant-AuthSource: AM8PR08MB5732.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 14:54:09.7848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TLctnBCFAe5aqFIqGj6KtKemk1d5ONKyXui3fUnmX6KvhbLvcdFv/WNPwgQAynEi//rxuFtDhgd1T9oS2h5dvT8YkadDoyfLdrCzjEWYw5Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6548
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/22/22 15:36, Christian Brauner wrote:
> On Tue, Feb 22, 2022 at 01:23:31PM +0100, Christian Brauner wrote:
>> On Tue, Feb 22, 2022 at 02:19:16PM +0300, Andrey Zhadchenko wrote:
>>> On 2/22/22 13:24, Christian Brauner wrote:
>>>> On Tue, Feb 22, 2022 at 09:33:40AM +0100, Christoph Hellwig wrote:
>>>>> On Mon, Feb 21, 2022 at 09:22:18PM +0300, Andrey Zhadchenko wrote:
>>>>>> xfs_fileattr_set() handles idmapped mounts correctly and do not drop this
>>>>>> bits.
>>>>>> Unfortunately chown syscall results in different callstask:
>>>>>> i_op->xfs_vn_setattr()->...->xfs_setattr_nonsize() which checks if process
>>>>>> has CAP_FSETID capable in init_user_ns rather than mntns userns.
>>>>>
>>>>> Can you add an xfstests the exercises this path?
>>>>>
>>>>> The fix itself looks good:
>>>>>
>>>>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>>>>
>>>> So for anything other than directories the s{g,u}id bits are cleared on
>>>> every chown in notify_change() by the vfs; even for the root user (Also
>>>> documented on chown(2) manpage).
>>>
>>> Only exception - chown preserves setgid bit set on a non-group-executable
>>> file (also documented there) but do not take root privileges into account at
>>> vfs level.
>>>
>>>>
>>>> So the only scenario were this change would be relevant is for
>>>> directories afaict:
>>>>
>>>> 1. So ext4 has the behavior:
>>>>
>>>>      ubuntu@f2-vm|~
>>>>      > mkdir suid.dir
>>>>      ubuntu@f2-vm|~
>>>>      > perms ./suid.dir
>>>>      drwxrwxr-x 775 (1000:1000) ./suid.dir
>>>>      ubuntu@f2-vm|~
>>>>      > chmod u+s ./suid.dir/
>>>>      ubuntu@f2-vm|~
>>>>      > perms ./suid.dir
>>>>      drwsrwxr-x 4775 (1000:1000) ./suid.dir
>>>>      ubuntu@f2-vm|~
>>>>      > chmod g+s ./suid.dir/
>>>>      ubuntu@f2-vm|~
>>>>      > perms ./suid.dir
>>>>      drwsrwsr-x 6775 (1000:1000) ./suid.dir
>>>>      ubuntu@f2-vm|~
>>>>      > chown 1000:1000 ./suid.dir/
>>>>      ubuntu@f2-vm|~
>>>>      > perms ./suid.dir/
>>>>      drwsrwsr-x 6775 (1000:1000) ./suid.dir/
>>>>      meaning that both s{g,u}id bits are retained for directories. (Just to
>>>>      make this explicit: changing {g,u}id to the same {g,u}id still ends up
>>>>      calling into the filesystem.)
>>>>
>>>> 2. Whereas xfs currently has:
>>>>
>>>>      brauner@wittgenstein|~
>>>>      > mkdir suid.dir
>>>>      brauner@wittgenstein|~
>>>>      > perms ./suid.dir
>>>>      drwxrwxr-x 775 ./suid.dir
>>>>      brauner@wittgenstein|~
>>>>      > chmod u+s ./suid.dir/
>>>>      brauner@wittgenstein|~
>>>>      > perms ./suid.dir
>>>>      drwsrwxr-x 4775 ./suid.dir
>>>>      brauner@wittgenstein|~
>>>>      > chmod g+s ./suid.dir/
>>>>      brauner@wittgenstein|~
>>>>      > perms ./suid.dir
>>>>      drwsrwsr-x 6775 ./suid.dir
>>>>      brauner@wittgenstein|~
>>>>      > chown 1000:1000 ./suid.dir/
>>>>      brauner@wittgenstein|~
>>>>      > perms ./suid.dir/
>>>>      drwxrwxr-x 775 ./suid.dir/
>>>>      meaning that both s{g,u}id bits are cleared for directories.
>>>>
>>>> Since the vfs will always ensure that s{g,u}id bits are stripped for
>>>> anything that isn't a directory in the vfs:
>>>> - ATTR_KILL_S{G,U}ID is raised in chown_common():
>>>>
>>>> 	if (!S_ISDIR(inode->i_mode))
>>>> 		newattrs.ia_valid |=
>>>> 			ATTR_KILL_SUID | ATTR_KILL_SGID | ATTR_KILL_PRIV;
>>>>
>>>> - and then in notify_change() we'll get the bits stripped and ATTR_MODE
>>>>     raised:
>>>>
>>>> 	if (ia_valid & ATTR_KILL_SUID) {
>>>> 		if (mode & S_ISUID) {
>>>> 			ia_valid = attr->ia_valid |= ATTR_MODE;
>>>> 			attr->ia_mode = (inode->i_mode & ~S_ISUID);
>>>> 		}
>>>> 	}
>>>> 	if (ia_valid & ATTR_KILL_SGID) {
>>>> 		if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP)) {
>>>
>>> So SGID is not killed if there is no S_IXGRP (yet no capability check)
>>>
>>> Actually I do not really understand why do kernel expects filesystems to
>>> further apply restrictions with CAP_FSETID. Why not kill it here since we
>>> have all info?
>>
>> Some filesystems do treat the sgid behavior of directories special (some
>> network filesystems do where they send that information to the server
>> before updating the inode afair). So I'd rather not do that in there as
>> we're risking breaking expectations and it's a very sensitive change.
>>
>> Plus, the logic is encapsulated in the vfs generic setattr_copy() helper
>> which nearly all filesystems call.
>>
>>>
>>>> 			if (!(ia_valid & ATTR_MODE)) {
>>>> 				ia_valid = attr->ia_valid |= ATTR_MODE;
>>>> 				attr->ia_mode = inode->i_mode;
>>>> 			}
>>>> 			attr->ia_mode &= ~S_ISGID;
>>>> 		}
>>>> 	}
>>>>
>>>> we can change this codepath to just mirror setattr_copy() or switch
>>>> fully to setattr_copy() (if feasible).
>>>>
>>>> Because as of right now the code seems to imply that the xfs code itself
>>>> is responsible for stripping s{g,u}id bits for all files whereas it is
>>>> the vfs that does it for any non-directory. So I'd propose to either try
>>>> and switch that code to setattr_copy() or to do open-code the
>>>> setattr_copy() check:

I did some more research on it and seems like modes are already stripped 
enough.

notify_change() -> inode->i_op->setattr() -> xfs_vn_setattr() -> 
xfs_vn_change_ok() -> prepare_setattr()
which has the following:
         if (!in_group_p((ia_valid & ATTR_GID) ? attr->ia_gid :
                          i_gid_into_mnt(mnt_userns, inode)) &&
              !capable_wrt_inode_uidgid(mnt_userns, inode, CAP_FSETID))
                  attr->ia_mode &= ~S_ISGID;

After xfs_vn_change_ok() xfs_setattr_nonsize() is finally called and 
additionally strips sgid and suid.

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 09211e1d08ad..7fda5ff3ef17 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -767,16 +767,6 @@ xfs_setattr_nonsize(
                 gid = (mask & ATTR_GID) ? iattr->ia_gid : igid;
                 uid = (mask & ATTR_UID) ? iattr->ia_uid : iuid;

-               /*
-                * CAP_FSETID overrides the following restrictions:
-                *
-                * The set-user-ID and set-group-ID bits of a file will be
-                * cleared upon successful return from chown()
-                */
-               if ((inode->i_mode & (S_ISUID|S_ISGID)) &&
-                   !capable(CAP_FSETID))
-                       inode->i_mode &= ~(S_ISUID|S_ISGID);
-
                 /*
                  * Change the ownerships and register quota modifications
                  * in the transaction.


root@debian:/mnt/xfs# unshare -U --map-root
root@debian:/mnt/xfs# touch testfile
root@debian:/mnt/xfs# chmod g+s testfile
root@debian:/mnt/xfs# ls -la testfile
-rw-r-Sr-- 1 root root 0 Feb 22 14:46 testfile
root@debian:/mnt/xfs# chown 0:0 testfile
root@debian:/mnt/xfs# ls -la testfile
-rw-r-Sr-- 1 root root 0 Feb 22 14:46 testfile
root@debian:/mnt/xfs#

root@debian:/mnt/xfs# mkdir testdir
root@debian:/mnt/xfs# chmod u+s testdir
root@debian:/mnt/xfs# chmod u+g testdir
root@debian:/mnt/xfs#
root@debian:/mnt/xfs# ls -la
total 4
drwxr-xr-x 4 root root   50 Feb 22 14:47 .
drwxr-xr-x 4 root root 4096 Feb 22 13:45 ..
drwsr-sr-x 2 root root    6 Feb 22 14:42 test1
drwsr-xr-x 2 root root    6 Feb 22 14:47 testdir
-rw-r-Sr-- 1 root root    0 Feb 22 14:46 testfile
root@debian:/mnt/xfs# chown 0:0 testdir
root@debian:/mnt/xfs# ls -la
total 4
drwxr-xr-x 4 root root   50 Feb 22 14:47 .
drwxr-xr-x 4 root root 4096 Feb 22 13:45 ..
drwsr-sr-x 2 root root    6 Feb 22 14:42 test1
drwsr-xr-x 2 root root    6 Feb 22 14:47 testdir
-rw-r-Sr-- 1 root root    0 Feb 22 14:46 testfile

>>>>
>>>> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
>>>> index b79b3846e71b..ff55b31521a2 100644
>>>> --- a/fs/xfs/xfs_iops.c
>>>> +++ b/fs/xfs/xfs_iops.c
>>>> @@ -748,9 +748,13 @@ xfs_setattr_nonsize(
>>>>                    * The set-user-ID and set-group-ID bits of a file will be
>>>>                    * cleared upon successful return from chown()
>>>>                    */
>>>> -               if ((inode->i_mode & (S_ISUID|S_ISGID)) &&
>>>> -                   !capable(CAP_FSETID))
>>>> -                       inode->i_mode &= ~(S_ISUID|S_ISGID);
>>>> +               if (iattr->ia_valid & ATTR_MODE) {
>>>> +                       umode_t mode = iattr->ia_mode;
>>>> +                       if (!in_group_p(i_gid_into_mnt(mnt_userns, inode)) &&
>>>> +                           !capable_wrt_inode_uidgid(mnt_userns, inode, CAP_FSETID))
>>>> +                               mode &= ~S_ISGID;
>>>> +                       inode->i_mode = mode;
>>>> +               }
>>>>
>>>>                   /*
>>>>                    * Change the ownerships and register quota modifications
>>>>
>>>> which aligns xfs with ext4 and any other filesystem. Any thoughts on
>>>> this?
>>>>
>>>> For @Andrey specifically: the tests these should go into:
>>>>
>>>> https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/tree/src/idmapped-mounts/idmapped-mounts.c
>>>>
>>>> Note that there are already setgid inheritance tests and set*id
>>>> execution tests in there.
>>>> You should be able to copy a lot of code from them. Could you please add
>>>> the test I sketched above and ideally also a test that the set{g,u}id
>>>> bits are stripped during chown for regular files?
>>> Thanks for the link. To clarify what tests and result you expect:
>>> - for directory chown we expect to preserve s{g,u}id
>>> - for regfile chown we expect to preserve S_ISGID only if S_IXGRP is absent
>>> and CAP_FSETID is present
>>
>> So specifically for chown():
>> 1. if regfile
>>     -> strip suid bit unconditionally
>>     -> strip sgid bit if inode has sgid bit and file is group-executable
>> 2. if directory
>>     -> strip sgid bit if inode's gid is neither among the caller's groups
>>        nor is the caller capable wrt to that inode
>> The behavior described in 2. is encoded in the vfs generic
>> setattr_copy() helper. And that is what we should see.
>>
>> The behavior of ext4 and btrfs is what we should see afaict as both use
>> setattr_copy().
>>
>>>
>>> JFYI: I found out this problem while running LTP (specifically
>>> syscalls/chown02 test) on idmapped XFS. Maybe I will be able to find more,
>>> who knows.
>>
>> Hm, if you look above, then you can see that the failure (or difference
>> in behavior) you're reporting is independent of idmapped mounts. An
>> ext4 directory shows different behavior than an xfs directory on a
>> regular system without any idmapped mounts used. So I'm not clear how
>> that's specifically related to idmapped mounts yet.

I guess my commit message is pretty poor. Initially I found out that 
chown() on idmapped xfs (+userns) drops sgid unconditionally on 
regfiles. I did not thought about directories at all. It is good that 
you pointed it out.
The problem is indeed independent from idmapping. However I thought this 
belonged to it since most of the checks were updated with idmapped 
series. Thanks for the explanation

> 
> So for example, in order to cause the sgid bit stripped while it should
> be preserved if xfs were to use setattr_copy() I can simply do:
> 
> brauner@wittgenstein|~/src/git/linux/ltp/testcases/kernel/syscalls/chown|master %=
>> unshare -U --map-root
> root@wittgenstein|~/src/git/linux/ltp/testcases/kernel/syscalls/chown|master %=
>> PATH=$PATH:$PWD ./chown02
> tst_memutils.c:157: TWARN: Can't adjust score, even with capabilities!?
> tst_test.c:1455: TINFO: Timeout per run is 0h 05m 00s
> chown02.c:45: TPASS: chown(testfile1, 0, 0) passed
> chown02.c:45: TPASS: chown(testfile2, 0, 0) passed
> chown02.c:57: TFAIL: testfile2: wrong mode permissions 0100700, expected 0102700
> 
> Summary:
> passed   2
> failed   1
> broken   0
> skipped  0
> warnings 1
> 
> There's no idmapped mounts here in play. The caller simply has been
> placed in a new user namespace and thus they fail the current
> capable(CAP_FSETID) check which will cause xfs to strip the sgid bit >
> Now trying the same with ext4:
> 
> ubuntu@f2-vm:~/src/git/linux/ltp/testcases/kernel/syscalls/chown$ unshare -U --map-root
> root@f2-vm:~/src/git/linux/ltp/testcases/kernel/syscalls/chown# PATH=$PATH:$PWD ./chown02
> tst_memutils.c:157: TWARN: Can't adjust score, even with capabilities!?
> tst_test.c:1455: TINFO: Timeout per run is 0h 05m 00s
> chown02.c:45: TPASS: chown(testfile1, 0, 0) passed
> chown02.c:45: TPASS: chown(testfile2, 0, 0) passed
> 
> Summary:
> passed   2
> failed   0
> broken   0
> skipped  0
> warnings 1
> 
> it passes since ext4 uses setattr_copy() and thus the capability is
> checked for in the caller's user namespace.
> 
>>
>> Fwiw, one part in your commit message is a bit misleading:
>>
>>>>>> has CAP_FSETID capable in init_user_ns rather than mntns userns.
>>
>> that's not what capable_wrt_to_inode_uidgid() does. What it does is to
>> check whether the caller is capable in their current user namespace.
>> That's how capable_wrt_to_inode_uidgid() has always worked.
>> The mnt_userns is only used to idmap the inode's {g,u}id. So if the
>> caller has CAP_FSETID in its current userns and the inode's {g,u}id have
>> a valid mapping in the mnt's userns the caller is considered privileged
>> over that inode.
>>
