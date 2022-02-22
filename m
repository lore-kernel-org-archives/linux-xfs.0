Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07FDDC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Feb 2022 11:19:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbiBVLTq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Feb 2022 06:19:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbiBVLTp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Feb 2022 06:19:45 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60122.outbound.protection.outlook.com [40.107.6.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEBAAFD3E
        for <linux-xfs@vger.kernel.org>; Tue, 22 Feb 2022 03:19:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n2R9CQqDoDlfsEgehxP2GXBVQ2FyAV00uiJr/8FUVKkKqNvVD6a2IhzQP7BfXTkKTOfF4j6PEGn6hiqjBsOhUCz5h5my7N2e1OOJCiVghc5w88qB0inp1nbXE86HxC+evOw/+Jzoy1NWcRDkXXERzmMAU1b8hL5/o9/9w6QRhcL/WW8Zs4cUgfpgJOuUlnpV2nRboZqzxNBjWZXxHVuScI6+64RdPILfg1fN0pJTktUVnjFMk3cKk3wpDdELhXd6DB58YsUrD2CsYmdkZoVdFG72/9N5Ltmqzbedm/Ut416yy7xcQhsliY6S6sN1AmCa4Czvqv2RuE/yHbm6R9juLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=leCCozg4M2IseTt47oTRVklj00vRfo4+fJiBL8xgO5g=;
 b=U3gJCOeyhxvxU/mPysn+I5kub6o7wrn2Y49VuWnokK+OshnaY22KBDAGKZkfnRETdEj0mrrZxcRdlg4LvL5+iNeVKRCH0SroVTuJN6O7iKfSP5/SXtxYcQXRTLOefNSrxVpk5EVvTEudZ5ObLv2LgGmvbb/INzbwIGq3vAlmgMFMxDayg6EszaX+rdOtT2vj3bEPAHwYE5PQb4Brdkyr3wUQpNVJf3+3h9AXLA9c4ODEZnbzv4/Dd4P1tuxsgdfxXMBvgeEiLjS0gAj/vejoIHIvQfBoS8vXQtzMKV0Qfl3xFnks7evycqp68HUuyI/X2+HC2xIQIPQhuph0MPS9EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=leCCozg4M2IseTt47oTRVklj00vRfo4+fJiBL8xgO5g=;
 b=wjyhi4Ezf67cSPLCIJcX4ScLENBOjwUIj302JKZNHyt+g9jIjOQr8cH8Gok2OrLCZJMdYubCQH2ckAlMlpOXGIr3FvFTxWYpyUSTuS2HVGycmRd8r6T/b4+Jd0XaBzPRtVPQSPuWpFqF06QGesgLuS+2KvC868EmbjZHZJrDEuQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from AM8PR08MB5732.eurprd08.prod.outlook.com (2603:10a6:20b:1d4::16)
 by AS1PR08MB7500.eurprd08.prod.outlook.com (2603:10a6:20b:4db::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Tue, 22 Feb
 2022 11:19:18 +0000
Received: from AM8PR08MB5732.eurprd08.prod.outlook.com
 ([fe80::6934:1cfe:5b49:dec2]) by AM8PR08MB5732.eurprd08.prod.outlook.com
 ([fe80::6934:1cfe:5b49:dec2%3]) with mapi id 15.20.4995.027; Tue, 22 Feb 2022
 11:19:18 +0000
Message-ID: <bdfa9081-1994-95f9-6feb-6710d34b33a1@virtuozzo.com>
Date:   Tue, 22 Feb 2022 14:19:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH] xfs: do not clear S_ISUID|S_ISGID for idmapped mounts
Content-Language: en-US
To:     Christian Brauner <brauner@kernel.org>,
        Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
References: <20220221182218.748084-1-andrey.zhadchenko@virtuozzo.com>
 <20220222083340.GA5899@lst.de> <20220222102405.mmqlzimwabz7v67d@wittgenstein>
From:   Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
In-Reply-To: <20220222102405.mmqlzimwabz7v67d@wittgenstein>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0412.eurprd06.prod.outlook.com
 (2603:10a6:20b:461::6) To AM8PR08MB5732.eurprd08.prod.outlook.com
 (2603:10a6:20b:1d4::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dbced722-c7df-41ce-bdad-08d9f5f52ad8
X-MS-TrafficTypeDiagnostic: AS1PR08MB7500:EE_
X-Microsoft-Antispam-PRVS: <AS1PR08MB75007D2AEA6E0FFC8DF4CA7DE13B9@AS1PR08MB7500.eurprd08.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wtHuaKh5N0oZR4/gLrLA76L9xYLdRZZVac90JShr6jYWHEvnmoLt55w8cj7QeaxOr5qebhGfmu+n87CHBhVJajkmX/Ao7kogjLKhfetK7quv2HGJEIiuSO6LXSQJp+cf7Mrb95e7H7mmXNruIV61aDoWTXL/LPLOe6HdQONLeH86tZQSaC1XUhWYQnWCWOSMl+p9IqepFCK8gO+HNGO4d5G25WKJ0MOSTmeAnm0ZADZo94kyCbJMkRaQpBgfEJsCXS39wQHSSvaLY+unuTbLHNcFOufcJNpsKpGvUwJDDux+XY6hOk2r2ehF7oefL60AxvZ9Kly/9u9zQobqRyuPZxBwqYaenYjIQIq76eCJBXMv7CVGrTrdMSOIXNsu04MY/VXmXyK+T27WHzJxM2AosO4zUV6zSiMpo+dBpLYYVCeLmWC+tHCsIU2FgbWLYFkNwbqXaaEDJra/G5Ra4R3qrRNEJPaxSOvM0Zldij/H1yGaBMT6YtvdfaBL5pyRhzojssn6K2oR4Ow3cCWEEvMEHPXmPMHr+rBHLJqbBC2hFQGh29eqjVJ+lrkB8bSHHqH39tJ8nwM9COkDGBbixfIY2/rfOCOw5grOC5pmIONLY57LF2Rh8nY68TLqDPRPZ4r+qj5/PdiS72Het5ljF/hxd4NTuQxuWLMVcxpmGwzruZ4DO7/4Y7qaRIGMem/h2qNUQNCjOtTjBgtEdfhvEfh6j3LFuVe0QBxHM6meAVSYPs2w4sWFDSiOYAJVulW+Vt6TF8iaZbYdU1bD3cG0MdW2+XZaobzCigKd/x9rlS3hROVyQDdpV+U6XIqvM+/Wn+IA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR08MB5732.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(26005)(6512007)(508600001)(2616005)(186003)(31696002)(86362001)(38100700002)(53546011)(83380400001)(316002)(31686004)(8936002)(44832011)(110136005)(5660300002)(66556008)(66476007)(6486002)(66946007)(2906002)(8676002)(36756003)(966005)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZnhVM1hRc1JnRE5yaTVMM0xLZFIxaEdYZ3dsaWxVREZVMmZEYk1YbjVHS1pn?=
 =?utf-8?B?b3g5RjUzVUVNdmttcFVTVWJVNHNGMTRXdlIxa1RFTm1HaUZTcjI4QS96RXQ2?=
 =?utf-8?B?dXV6SDFVWFlxaFRXaDJkWkpYdm1JUWFhMmZTVjF4QXlZaWNEcGpVbk0zajdy?=
 =?utf-8?B?cVhTbmdGclVoUHR5cjJEM3Fla0QyWWEybzBqd0NzV3gwWHYyck9BUCt2V0ln?=
 =?utf-8?B?QTZOOFdaQjVpUis2Y3R6WUFNUlFzdmVOdFZ0VUhjUkdvNld5M3BGVFVqdzlT?=
 =?utf-8?B?NXcxYWc0WXlMK245SVkvbTVEb2poUnJvQnVZUlpmTHhCNFFEb1FHYkF0OHZs?=
 =?utf-8?B?TnY0RWFVZWU1VlI2OFNqTzZJRjVOZGY0ZXI1WGpuMEdsVU9ycXlOcllqT2VF?=
 =?utf-8?B?TVA2RG9id0JoMzJvNyt1U2Jmd2xpMGJGTGV6T2hUSkx1VVh0QnphTFptT1lL?=
 =?utf-8?B?a3lEMU41LzlucTZGelhFYjhyZEhYazQrSWlzUVVwUWZxZ3cvai9jQVZUanR4?=
 =?utf-8?B?UTFPZzYvQU50NS9wUXlSd1VhbEw1OTdIUFBuRXl3RnBJeWFYd2dmeEhpWHdT?=
 =?utf-8?B?bkk5UjhxUDQvRXEyRi82SEtVb3dPeEJLSUplWGFwTGdpemNHdkl5S0JGN0xt?=
 =?utf-8?B?TUxJS09qZi9UWGRYNnJSek0yMFpLQlROdk9aeGJTVElVTnEwVEpmRjZDb0JS?=
 =?utf-8?B?QnljT2FwT2ZURDhKNTlOenFESDZza3k3VUZNZndEWjhLNXBlRnVMajA3ZElN?=
 =?utf-8?B?RGhtQ2tUQUlZQ0hTbmpUYWZiZzVGUjA2UDZsN2l2Nm5meDRiUGYwODVUNGN3?=
 =?utf-8?B?YTI1SEY2dktMakN6U1dwRFMxYlM0eWxqalphRmNqbGU5REN6LzVJWkg1WU91?=
 =?utf-8?B?YXFzRm1HQXFpcUxxVVlFenFTcjY2R2VYS2lXc2pWQ2VGRURzWCticTFRd2F0?=
 =?utf-8?B?UTBubDEzVWs2NStEYnBJaHZTSndyWFd2SHFZbXZUbkRxWjNSKzJaRVhFWVRi?=
 =?utf-8?B?OThiRVZtWk03RnE5ZERXdGtySjhySkhQMVg3NExlWjBXc2p4T2sxL0NkUlhz?=
 =?utf-8?B?cGVOZnd6TDZSMTJUSlcrUzFlL1lDZlhqSU9Fay8wTlRueWtVa0dYN3gwZENu?=
 =?utf-8?B?M25NUjVOZkZ1V0U1UEE2cm9VVElpdGo2ME4xRlE1UnpnZ0pqL21jUVRIL292?=
 =?utf-8?B?bWNNY3o4SnIrRVF2SUt1UkxWL0w4YkNxckNEMlROd2ZyV0htTVpjbjdrYkdI?=
 =?utf-8?B?bHcxMFQvc3p1dVNCWnlDQ3VLZ1NKSHRndnlXb2JEaUJhZXFJRE5LaDY3T2xx?=
 =?utf-8?B?RTcrMGxuVjI4MHlOYnlHekEzcldlNm5RemsveWxHRzg0ZG1TT25hK1YzUU1O?=
 =?utf-8?B?bWZnWTV1c2RBQlAxU1hPN3krZkg1NWNWVlhrT1RmUDIxbEQzQ2U2Z1RTREww?=
 =?utf-8?B?NGt0SEplRHRacVpTcU9wR2NzR1NWSVBKeDNJdWtCcFJ2UHJ1Rm53MnA0ejNl?=
 =?utf-8?B?Y1VBMXY2Sm10V2t4eDB2VG9QWkZoWFh2MGNSN28rQVArS1ZZNWtqTm8wQzk4?=
 =?utf-8?B?ZEtRSXFQTVJ2WXNEU3dEQS95WG1zcWcyblg5Nm9teDFkUFEyUU5sa2xsTERC?=
 =?utf-8?B?RjB0TzA5VDlhR1VxRisvZGF3cXhUWVVKb29LZUd0d21UdklHN2NmOVhSazRI?=
 =?utf-8?B?Qm56OHlJb25iWDY2TmVFV3g5WGkxZ3lYaW1hVExLUHhIWmxpeDh6TW1mNlkr?=
 =?utf-8?B?ZU52SzZveUEvUTNyNURjR2pYK0s4SEtQbUJacXZxcFhBS1MrdFgwSWxPWTZZ?=
 =?utf-8?B?QWxMN3lSRWp1eHVDNDlLZjRXQXczVHpnSUVETkRHdDR0N3J5b3dBVVdVK3JT?=
 =?utf-8?B?MGNpYzdudjE3VC9FN0JPOE12ZDc2ZmZKNnY3eVFqazZ5aEJqVTh1YXJMcUdT?=
 =?utf-8?B?VDZzNGVmblU0VnB2YkZNUjEvOUJmY3VhZVJvRWZDWmxBdW9NTFRxQ2duUXFw?=
 =?utf-8?B?bnNUQzRGSHo3d3crWFVvUWFHZzR6blVSc3R3RmNFdTZHdDMzb2dNUC9IdEJs?=
 =?utf-8?B?NGhrTzU3ci9vdzhVVGdwRWhTOUZldHROZExrMnVvWmF3bFdzWXlVejJtUHpU?=
 =?utf-8?B?RFdDL2Uzc2VPb3ZNY2FOUGRkTVJYWmc0VGpuNWVJRkhNY3ZTT3RHblBzN0Ez?=
 =?utf-8?B?Vi9OTUFvbnVWODExSFRzNFlVdUFYWUMzYU5TTVV6bVlmbjdqOU9xWjNRNG1G?=
 =?utf-8?B?Q2s5SzhMaTFEOUlsTUk3ZTUwTTdRPT0=?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbced722-c7df-41ce-bdad-08d9f5f52ad8
X-MS-Exchange-CrossTenant-AuthSource: AM8PR08MB5732.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 11:19:18.5838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uxd4g2xVngfU78fQ4zjgTITwhOEOky/IdLUUT9i7ym/9h9PgLsTG9QygnGkNE+VGC6J70qStvEGAYBQl/5vE1vexTxslLPGprE0rPStONPw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR08MB7500
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/22/22 13:24, Christian Brauner wrote:
> On Tue, Feb 22, 2022 at 09:33:40AM +0100, Christoph Hellwig wrote:
>> On Mon, Feb 21, 2022 at 09:22:18PM +0300, Andrey Zhadchenko wrote:
>>> xfs_fileattr_set() handles idmapped mounts correctly and do not drop this
>>> bits.
>>> Unfortunately chown syscall results in different callstask:
>>> i_op->xfs_vn_setattr()->...->xfs_setattr_nonsize() which checks if process
>>> has CAP_FSETID capable in init_user_ns rather than mntns userns.
>>
>> Can you add an xfstests the exercises this path?
>>
>> The fix itself looks good:
>>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> So for anything other than directories the s{g,u}id bits are cleared on
> every chown in notify_change() by the vfs; even for the root user (Also
> documented on chown(2) manpage).

Only exception - chown preserves setgid bit set on a 
non-group-executable file (also documented there) but do not take root 
privileges into account at vfs level.

> 
> So the only scenario were this change would be relevant is for
> directories afaict:
> 
> 1. So ext4 has the behavior:
> 
>     ubuntu@f2-vm|~
>     > mkdir suid.dir
>     ubuntu@f2-vm|~
>     > perms ./suid.dir
>     drwxrwxr-x 775 (1000:1000) ./suid.dir
>     ubuntu@f2-vm|~
>     > chmod u+s ./suid.dir/
>     ubuntu@f2-vm|~
>     > perms ./suid.dir
>     drwsrwxr-x 4775 (1000:1000) ./suid.dir
>     ubuntu@f2-vm|~
>     > chmod g+s ./suid.dir/
>     ubuntu@f2-vm|~
>     > perms ./suid.dir
>     drwsrwsr-x 6775 (1000:1000) ./suid.dir
>     ubuntu@f2-vm|~
>     > chown 1000:1000 ./suid.dir/
>     ubuntu@f2-vm|~
>     > perms ./suid.dir/
>     drwsrwsr-x 6775 (1000:1000) ./suid.dir/
>     
>     meaning that both s{g,u}id bits are retained for directories. (Just to
>     make this explicit: changing {g,u}id to the same {g,u}id still ends up
>     calling into the filesystem.)
> 
> 2. Whereas xfs currently has:
> 
>     brauner@wittgenstein|~
>     > mkdir suid.dir
>     brauner@wittgenstein|~
>     > perms ./suid.dir
>     drwxrwxr-x 775 ./suid.dir
>     brauner@wittgenstein|~
>     > chmod u+s ./suid.dir/
>     brauner@wittgenstein|~
>     > perms ./suid.dir
>     drwsrwxr-x 4775 ./suid.dir
>     brauner@wittgenstein|~
>     > chmod g+s ./suid.dir/
>     brauner@wittgenstein|~
>     > perms ./suid.dir
>     drwsrwsr-x 6775 ./suid.dir
>     brauner@wittgenstein|~
>     > chown 1000:1000 ./suid.dir/
>     brauner@wittgenstein|~
>     > perms ./suid.dir/
>     drwxrwxr-x 775 ./suid.dir/
>     
>     meaning that both s{g,u}id bits are cleared for directories.
> 
> Since the vfs will always ensure that s{g,u}id bits are stripped for
> anything that isn't a directory in the vfs:
> - ATTR_KILL_S{G,U}ID is raised in chown_common():
> 
> 	if (!S_ISDIR(inode->i_mode))
> 		newattrs.ia_valid |=
> 			ATTR_KILL_SUID | ATTR_KILL_SGID | ATTR_KILL_PRIV;
> 
> - and then in notify_change() we'll get the bits stripped and ATTR_MODE
>    raised:
> 
> 	if (ia_valid & ATTR_KILL_SUID) {
> 		if (mode & S_ISUID) {
> 			ia_valid = attr->ia_valid |= ATTR_MODE;
> 			attr->ia_mode = (inode->i_mode & ~S_ISUID);
> 		}
> 	}
> 	if (ia_valid & ATTR_KILL_SGID) {
> 		if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP)) {

So SGID is not killed if there is no S_IXGRP (yet no capability check)

Actually I do not really understand why do kernel expects filesystems to 
further apply restrictions with CAP_FSETID. Why not kill it here since 
we have all info?

> 			if (!(ia_valid & ATTR_MODE)) {
> 				ia_valid = attr->ia_valid |= ATTR_MODE;
> 				attr->ia_mode = inode->i_mode;
> 			}
> 			attr->ia_mode &= ~S_ISGID;
> 		}
> 	}
> 
> we can change this codepath to just mirror setattr_copy() or switch
> fully to setattr_copy() (if feasible).
> 
> Because as of right now the code seems to imply that the xfs code itself
> is responsible for stripping s{g,u}id bits for all files whereas it is
> the vfs that does it for any non-directory. So I'd propose to either try
> and switch that code to setattr_copy() or to do open-code the
> setattr_copy() check:
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index b79b3846e71b..ff55b31521a2 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -748,9 +748,13 @@ xfs_setattr_nonsize(
>                   * The set-user-ID and set-group-ID bits of a file will be
>                   * cleared upon successful return from chown()
>                   */
> -               if ((inode->i_mode & (S_ISUID|S_ISGID)) &&
> -                   !capable(CAP_FSETID))
> -                       inode->i_mode &= ~(S_ISUID|S_ISGID);
> +               if (iattr->ia_valid & ATTR_MODE) {
> +                       umode_t mode = iattr->ia_mode;
> +                       if (!in_group_p(i_gid_into_mnt(mnt_userns, inode)) &&
> +                           !capable_wrt_inode_uidgid(mnt_userns, inode, CAP_FSETID))
> +                               mode &= ~S_ISGID;
> +                       inode->i_mode = mode;
> +               }
> 
>                  /*
>                   * Change the ownerships and register quota modifications
> 
> which aligns xfs with ext4 and any other filesystem. Any thoughts on
> this?
> 
> For @Andrey specifically: the tests these should go into:
> 
> https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/tree/src/idmapped-mounts/idmapped-mounts.c
> 
> Note that there are already setgid inheritance tests and set*id
> execution tests in there.
> You should be able to copy a lot of code from them. Could you please add
> the test I sketched above and ideally also a test that the set{g,u}id
> bits are stripped during chown for regular files?
Thanks for the link. To clarify what tests and result you expect:
- for directory chown we expect to preserve s{g,u}id
- for regfile chown we expect to preserve S_ISGID only if S_IXGRP is 
absent and CAP_FSETID is present

JFYI: I found out this problem while running LTP (specifically 
syscalls/chown02 test) on idmapped XFS. Maybe I will be able to find 
more, who knows.
