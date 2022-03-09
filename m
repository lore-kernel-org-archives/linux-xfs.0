Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D62AC433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Mar 2022 23:01:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233602AbiCIXCf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Mar 2022 18:02:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiCIXCe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Mar 2022 18:02:34 -0500
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30133.outbound.protection.outlook.com [40.107.3.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D411066F6
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 15:01:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bVGAgxiiz6DaFozMyBxNuebTc4/cIxgqNPnajU9oHomsLnF5F/tuQGbIRNF2Gmjui1kMdeY06TIErSbj7RkX4gI+Kh+RXoY7LKZkiJGqJbmp6oXrmIKT6Wze8RALBn72fzDzl3nedD92lp6Sg5jbKNa+lLJBeI4a16BakoWHkTnkKIKY2ORs0UDeT9MkLus+ikcbi5uNbdOqE4qHAHI/l2PdzVPL7KL/LIMqwKAGypvDH1omNX2iPmWobcwtm2VijzQgyTa3VSaeTxaxBI0juio0S85LMACgOYF7NreVSY5R7oeiQ3uvlHrTtTpRNqarhWIiHSnHyAAmfOLBh65Dag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cb2BDJb2aGtwrlBTGOa0EkkjRsmrhvDBC6BEWKOSoFY=;
 b=ZEaOyWDVpNuhGeKMZ3DYUWXTV6lI4mWQMXW5bEvET626E7ZNuwW19ExZCmkglF/iphZy8z150Pv5FkMzWRmU8m43556t3CK5mts9vite56hx/RkfTX8p/o5MEpx2QVCMOYJ1RTeuWb0fT2uYJwq1Bs3i1voltyB/WG4NxbMJz0Qvy5n56nU0l0VhDWcnXNFUN8IlqGKICmO4eqdzhhx3ueokMRZbW0MeP+MrvFrPpTN3Rk6YK+C+MLWcpPx8Sz8sHIcYaWTGw8j0yELgWJUOrs5gz+PrnkZScEKM4mF6ESwq+b5XAAKHgzCvJtP4p3OWBXL68oamnbJw6Qc8mVQmJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cb2BDJb2aGtwrlBTGOa0EkkjRsmrhvDBC6BEWKOSoFY=;
 b=iMWDrPJGYLhwxQDLKxguLH/v0hcOkQlHy3WLDxBKiGgZ/j2rjS3hkFiYset6A7PxSKUt1rZ6iUV3dRRFN7sLGe6PLFTq1Z7r6tWpYHOi6xU5p84SM8IKx7k3wbnfjMKerOv2x+G3wJmASugT1G+iGxZGN0J4Mgevd+kIwOFWOpA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from AM8PR08MB5732.eurprd08.prod.outlook.com (2603:10a6:20b:1d4::16)
 by AM0PR08MB4563.eurprd08.prod.outlook.com (2603:10a6:208:131::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 9 Mar
 2022 23:01:32 +0000
Received: from AM8PR08MB5732.eurprd08.prod.outlook.com
 ([fe80::e499:c76:211e:ba0b]) by AM8PR08MB5732.eurprd08.prod.outlook.com
 ([fe80::e499:c76:211e:ba0b%4]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 23:01:32 +0000
Message-ID: <8aa8a6d8-109e-99dd-d904-268df6058447@virtuozzo.com>
Date:   Thu, 10 Mar 2022 02:01:29 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
From:   Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
Subject: Re: [PATCHSET 0/2] xfs: use setattr_copy to set VFS file attributes
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fdmanana@kernel.org, brauner@kernel.org,
        david@fromorbit.com, hch@lst.de
References: <164685372611.495833.8601145506549093582.stgit@magnolia>
Content-Language: en-US
In-Reply-To: <164685372611.495833.8601145506549093582.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1P18901CA0007.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:801::17) To AM8PR08MB5732.eurprd08.prod.outlook.com
 (2603:10a6:20b:1d4::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 725ce7a3-c9eb-4db5-dc44-08da0220c0eb
X-MS-TrafficTypeDiagnostic: AM0PR08MB4563:EE_
X-Microsoft-Antispam-PRVS: <AM0PR08MB4563C5378F9083253C40D4D1E10A9@AM0PR08MB4563.eurprd08.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IcvVXiI/zBJGFnmY+XRW8XAaCbr/SlQ577PLNg9uHTiq861Tn98KuZbh1qq4Q02DpQs/e4QfqzFXI5icsBm5Jfb8c/M7jfsHPzV79LcArVJo4dfXnbv5BBuekAhHqg9MMw+u88F/FFXKuTcrW9BJkFxEvkyl5bLB24Rpz2nPgDmNXPBV/g7n+XHmA/zjXPH1sSXeoNLkRckg64f4lGmtyVq9f/J3NE27D2HQer4mUGog1hNqydLTYmTyBRJ5ENx7jdL8tULReKBtao30wkKwPOL5sThf3cye8aQEEVf7hM/n1rR7mbWnQUt8gjIzODqqtYOZdzjumM4k9CnSMP1+5bXRQyLI4bXIibU5HCMfH9fbDmIYnBO8y+qcjQwK8T+HCWFeiBxmDJvF0KT9j88iP2jTK3DOtHEm3Rbcq+TJV3PepSDa1tjMkVmRjVv7lkfoIKRg8/4nm9U09WOFgUouMzLheje9uYCUvazERP4ozfIAvG2xktpF8Rw0EgDs+4GQl27NVBtW4sqUdYJll7CtSbnlN3frRxjN+nMHM9pLvGwBuX8Kxro3vj9khp7p1uAkuam+4OyGs9raoXNm2M92il19BlynLxOts7wUxXYpPs4CtfYPn/mSMe9If9ikpeWf28wiNol0Y4tj0gQSZzpck9r5T6h0KhpSLonT05mp4IEk0AXX1+/oGGws6pQiqmhCvA3aOxyrcofH5VXFsKRyk3rqwTSFsI4N6kR8r/NzLYd2yaaE8tF6cJbnRNgBZ9mxWA9HOlCI9Ekmh2jGjbLgksTqZ/cjhnOYcwtsBu0d48p5Qv9tidnJ5hVWzGc7AKqyex/barREytkqeprjK1w1RzkgqYpAW89ujCILI+di5F4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR08MB5732.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(966005)(31696002)(86362001)(83380400001)(66556008)(66946007)(8676002)(66476007)(4326008)(6916009)(36756003)(316002)(2906002)(8936002)(44832011)(5660300002)(6512007)(2616005)(6506007)(6666004)(53546011)(26005)(186003)(508600001)(6486002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T1FZQ2FWNlVIUU9OU1lhcHRQcGtiYnA3WjlUc2NYeWowakR2OGd6bnpxMFlG?=
 =?utf-8?B?d2Fsd3BYU0tNb25yREtGR3ZMd1RTNkFJdGtuOWE2YWo5VURxUlVSbk1YcDA4?=
 =?utf-8?B?VEh6VUlFWGYyYk51cFNibjdqZms1QjZoV1lhbzFBa3lHOS9hc2JpeEc4L1kv?=
 =?utf-8?B?Y082TVFYVHFRNW55SVpxRDFjeXZKemVqODlHaXMvOEVRVno5ckk4ZVI1aHdF?=
 =?utf-8?B?eGV4cHMxcGYzYXFvOG55UGZoem1tUlZvK2lMY2FyNGFpMVhjMHdjaVFiSEQv?=
 =?utf-8?B?TW5UbDI4OTR2UzV3S0RLSTRYM2FaSzNtaHVydWljWmdoR1FkR2xVM2o2SEh0?=
 =?utf-8?B?OEphV0YvTnpoWDN3VE51RytGVmNubVJwa0ZVdDlMQ1FITmdjaUViUXZlRlpo?=
 =?utf-8?B?YVpiN1BaRXc1TTh4SGlVUitqYTBGUW9IbUptZUhBL0FRam85QlNJblZmdm5m?=
 =?utf-8?B?RXFxMHVqL2IrNGxjTmMzOW5VNXM1TnBiMFZ5TVVNOGwyZTJmRm9NSERvc3F2?=
 =?utf-8?B?NmZRaFNQTDlNRjJTS1ZGRmhPOUxhL01kRExvNm9NU3Q0MlQxSWd1dmloSUZH?=
 =?utf-8?B?UitJZXpkOFMxMW1ZWnloRG5DOXA1QmUyYmxCTFdCRHhhMXoxSTByUnFFb01a?=
 =?utf-8?B?MlRObm02UTUzVlpnM2NJZGRGMFBGQjRnbzhrR1pQa3lYVGU4WXRQUkxQcGdB?=
 =?utf-8?B?dGtkaGRlaytCQXp2djJzWEFML1p5TGQxVUVPRHZtZ2hzTzY1amRnRGdVcmxM?=
 =?utf-8?B?cXlKZ2Q4b0lVTnFjbG4xaU5rL2svZ0VFWmNPWHp6bitxRnJWWVdLZnRZRm1s?=
 =?utf-8?B?K3ZJWU5hMVZOY0dWKzRzaDJMNkt5SkxmQXJsdWQ4bWF3dktIUU9kVHZuMmM5?=
 =?utf-8?B?YVNyUy9aOWQ4UWN1UWlxbDNsT21xT2NtQmxTeDJXajQ5SDQyd0FHalF1bTVl?=
 =?utf-8?B?clF3VHhjejhVQUo3SHdhRzVlVkdNZGdKV3dOdlhqVmw5aGlwQ2tqOFpHTmVQ?=
 =?utf-8?B?VnBWc1YxdTMxdzk0Q244dHZycGw5YUMyYnJnY0d5eTFKWjhmZ2NYWTN1UWNv?=
 =?utf-8?B?SmVWN2FaMjFqZlI4ZFFIRnZ2SXk0ZUZDd2ltV2ZDMjV2ZUIycFk4Vy94Y2NH?=
 =?utf-8?B?b2xVVGVzNENJSXRibFlOTFlzb0N0cUJKZXBFRlA4eERyQjRyTTJkV1RpaHFV?=
 =?utf-8?B?a3pET0E0amNMZWdBSE9TTUdpNjl4ZG9YbjYwaG5seUVnNTNUR2llZFJEeWtv?=
 =?utf-8?B?dVFPZVFROVJhNzlNdjgxeWIyYk5xWGtsUHkzTWJNUTZYcDBla2dLTlgrbE5z?=
 =?utf-8?B?UG1WRmdvVGVxMFEyOVM3cVFlYXR6VnBGUm1hYmFKNWR4c1E4S09oa0dueG85?=
 =?utf-8?B?VDFUMVlnaTBLM2RXdjRxdklObjlUSW5jTkc4TXI3SlordEdXV0t3ZmdpTEkr?=
 =?utf-8?B?clFiVGNTcHdxVVZqMTFwcGdjUG1STGptN2VvOUxSb1FMbmoxckR0QzZkZUMr?=
 =?utf-8?B?a29BT3BsLzlacDJaSlZ1bTlScFp5aWVzUUVLZHdiUjJYcVBDcnhNQU50MHIv?=
 =?utf-8?B?dldMeE5SYkJNeXF3U0d0Um1OcGVXZmt5bTJPSGYrNXRzQTNSR1BTSkFOSjNj?=
 =?utf-8?B?L1drbUhPQi9kK1dqaW93RnRrcVNQd0IzV1B2dW96TFh3VTcvUFhnVlhzWkJD?=
 =?utf-8?B?WlVCRG5CZ0w4MkV3NktiS2xycVZQNTFab055d0hZNjhxTHprZTZzRElsVmZ3?=
 =?utf-8?B?M0dtMzlBK1NGYmMzQXNaYTVlbVlySDdVeFRYS1o5ZkptRm00VXliMndZTm1I?=
 =?utf-8?B?MlczT2N5eUtRaCtCemZwNStMTnVpYk1WeExqVjI2eTJtY092UGNZeFJUbjV2?=
 =?utf-8?B?NVhiTVdDVVJQN2NKN2pXS0xhVThDYkRTQ3pWcStlbm42ci9vazZleE5pTyt0?=
 =?utf-8?B?ZTVtK294TTJ1M29DbFd6UEpZWHpRSHBLL25PdERXMW5OMFh3RStmWVNaNFBu?=
 =?utf-8?B?eTQwY05HRW5TWHNlckw3VUp1cWlsTmdiS2pvQXVHaXk4cTVyYWZFbDZ0MGlQ?=
 =?utf-8?B?a0crSFA1bW5kZ2lsVjIyNCtGZ2lYS3NZSHV3MCswR1E4VERUN0g5T0RseE91?=
 =?utf-8?B?TmdtV3IxSnBKdUNvZU04blN4ODFvWGhlT3hKdmZ6eTdFRXZaUlRTZkkvQ3dP?=
 =?utf-8?B?clFOVFAxNzlGbDdiajZ4RW9DaEVDYXJtVTAzUnNkcVlFaXRhM1d6VHZCaEg1?=
 =?utf-8?B?ZnRCU2dWL1JiTStsRklKUDBVVld3PT0=?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 725ce7a3-c9eb-4db5-dc44-08da0220c0eb
X-MS-Exchange-CrossTenant-AuthSource: AM8PR08MB5732.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 23:01:32.6800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aVe+HDU/iKPDsuGIFTuNFPOBLaZlkJ996d7CRujRxyOj6GvBeowvhqMnoMMsk7zu0VXjkc+IfRI1gMnEjo5QN+L7/f5aGh/svHcv7LV5erg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB4563
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 3/9/22 22:22, Darrick J. Wong wrote:
> Hi all,
> 
> A few weeks ago, Filipe Manana reported[1] that the new generic/673 test
> fails on btrfs because btrfs is more aggressive about dropping the
> setgid bit when reflinking into a file.  After some more digging, we
> discovered that btrfs calls the VFS helpers to handle updating VFS
> inode attributes, whereas XFS has open-coded logic dating from ~1997
> that have not been kept up to date.
> 
> A few days later, Andrey Zhadchenko reported[2] that XFS can mistakenly
> clear S_ISUID and S_ISGID on idmapped mounts.  After further discussion,
> it was pointed out that the VFS already handles all these fiddly file
> mode changes, and that it was the XFS implementation that is out of
> date.
> 
> Both of these reports resolve to the same cause, which is that XFS needs
> to call setattr_copy to update i_mode instead of doing it directly.
> This series replaces all of our bespoke code with VFS calls to fix the
> problem and reduce the size of the codebase by ~70 lines.
> 
> [1] https://lore.kernel.org/linux-xfs/CAL3q7H47iNQ=Wmk83WcGB-KBJVOEtR9+qGczzCeXJ9Y2KCV25Q@mail.gmail.com/
> [2] https://lore.kernel.org/linux-xfs/20220221182218.748084-1-andrey.zhadchenko@virtuozzo.com/
> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D
> 
> kernel git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=setattr-copy-5.18
> ---
>   fs/xfs/xfs_iops.c |  116 +++++++++++------------------------------------------
>   fs/xfs/xfs_pnfs.c |    3 +
>   2 files changed, 25 insertions(+), 94 deletions(-)
> 

Thanks for fixing this. I will soon send a corresponding tests to 
xfstests - it's almost done.

Also while you are at it, what do you think of the following?

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index fdab467c034f..871576723145 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1436,17 +1436,6 @@ xfs_fileattr_set(

         if (!fa->fsx_valid)
                 goto skip_xattr;
-       /*
-        * Change file ownership.  Must be the owner or privileged. 
CAP_FSETID
-        * overrides the following restrictions:
-        *
-        * The set-user-ID and set-group-ID bits of a file will be 
cleared upon
-        * successful return from chown()
-        */
-
-       if ((VFS_I(ip)->i_mode & (S_ISUID|S_ISGID)) &&
-           !capable_wrt_inode_uidgid(mnt_userns, VFS_I(ip), CAP_FSETID))
-               VFS_I(ip)->i_mode &= ~(S_ISUID|S_ISGID);

         /* Change the ownerships and register project quota 
modifications */
         if (ip->i_projid != fa->fsx_projid) {


xfs_fileattr_set() also may clear S_ISUID|S_ISGID for FS_IOC_FSSETXATTR 
and FS_IOC_SETFLAGS ioctls.
For example, setting projid definitely do clear it for not CAP_FSETID 
users. I wonder if it is documented and intentional? ext4 do not touch 
this bits, but I have no idea if it should
