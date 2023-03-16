Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A69DC6FD1F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 04:48:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjCPEsz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 00:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCPEsy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 00:48:54 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C4F45D764
        for <linux-xfs@vger.kernel.org>; Wed, 15 Mar 2023 21:48:52 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id o6-20020a17090a9f8600b0023f32869993so187650pjp.1
        for <linux-xfs@vger.kernel.org>; Wed, 15 Mar 2023 21:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678942132;
        h=in-reply-to:subject:cc:to:from:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Iaa/8QQO9he9EiKA7674zLhKnW2ym1LUqwyv8Kvf2B4=;
        b=UPIt/U+61KyUHXGOn7NffjdG6muMdW3AXqWi1C+eOKvOu7M+iMcPrQo2jqxJecDf6p
         Cp2RMl2LoZc2y82NJ/zKKVe7CEZ0SdNS+wwfRPrhTaQqU41Z7vV/n0EV6mQD6KKLD5j3
         p0TXMOFnfiCn9C/blVDMCL9YJhT9oXeAzreEnXYc4OSTXdNEnl8FqrfXHyS00nWy2ZWC
         fR9eAvwfH6hh/OhE0jIA/BPv1bTosuB3YBwJlgblWoql85v4qN+Id5EjWfFKdN3BMvlI
         mkGoRmuVXjFnyp0dRQ9QeG8Zy1TJVNcVduTpJHDWOZe5PqDY7urEfmvYXRMXIM7Kk8YW
         HrFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678942132;
        h=in-reply-to:subject:cc:to:from:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Iaa/8QQO9he9EiKA7674zLhKnW2ym1LUqwyv8Kvf2B4=;
        b=Wo0SFw7wdgOOgciuNDVP4TV+CNwRf1JyooX8vGebL5pwyZhzvZOtN3Uzpm+rlPORlW
         EiBLrrjyUul0gxPaDtoqjy6qVdrqjD/djL9EvIU7hxIPVRvBzxDhZ2UO2jOO8IUSTK5m
         NDkYGXF3cx6Lo3VXWRpUg1Wz/B/itJ27KyqbkKMk3eUX6RJr3XGE15WQDmY4kr4pA5Ka
         YpLfqGUIUOkXtnF0uFbxp9KKjYlFWjcc2Gu/E6CapYea8399IqV+OOoYg3GysSJBccPO
         xBHetmxWbVuwRhi3fXKQgqmG+mYKfrMZ/IuQhK3NqCN3ZBYzWjhaZDDcPcExSofTrH4Q
         4x6Q==
X-Gm-Message-State: AO0yUKWa2J9aw8GD4uMRopI+yLcjIBYrqXRFp/xpAorW7QehjMg4KQKI
        ZE0B0h0rIqdkUUm44bw7ns8=
X-Google-Smtp-Source: AK7set9FIMcXkAhrdYXLmKg3ZMpS3MXKwolDHqK2q0pF4wSN/2iXQwKLpeWQBHsbMQ7JiWe+oYkcIQ==
X-Received: by 2002:a05:6a20:1449:b0:cb:7a74:d6f with SMTP id a9-20020a056a20144900b000cb7a740d6fmr1804749pzi.9.1678942131806;
        Wed, 15 Mar 2023 21:48:51 -0700 (PDT)
Received: from rh-tp ([2406:7400:63:469f:1474:7c59:3a57:aab6])
        by smtp.gmail.com with ESMTPSA id e4-20020a62ee04000000b00587fda4a260sm4362075pfi.9.2023.03.15.21.48.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 21:48:51 -0700 (PDT)
Date:   Thu, 16 Mar 2023 10:18:45 +0530
Message-Id: <87y1nx713m.fsf@doe.com>
From:   Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        shrikanth hegde <sshegde@linux.vnet.ibm.com>,
        dchinner@redhat.com, linux-xfs@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        ojaswin@linux.ibm.com
Subject: Re: xfs: system fails to boot up due to Internal error xfs_trans_cancel
In-Reply-To: <20230310002907.GO360264@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:

> On Thu, Mar 09, 2023 at 07:56:06PM +0530, Ritesh Harjani wrote:
>> Hi Darrick,
>>
>> Please find the information collected from the system. We added some
>> debug logs and looks like it is exactly what is happening which you
>> pointed out.
>>
>> We added a debug kernel patch to get more info from the system which
>> you had requested [1]
>>
>> 1. We first breaked into emergency shell where root fs is first getting
>> mounted on /sysroot as "ro" filesystem. Here are the logs.
>>
>> [  OK  ] Started File System Check on /dev/mapper/rhel_ltcden3--lp1-root.
>>          Mounting /sysroot...
>> [    7.203990] SGI XFS with ACLs, security attributes, quota, no debug enabled
>> [    7.205835] XFS (dm-0): Mounting V5 Filesystem 7b801289-75a7-4d39-8cd3-24526e9e9da7
>> [   ***] A start job is running for /sysroot (15s / 1min 35s)[   17.439377] XFS (dm-0): Starting recovery (logdev: internal)
>> [  *** ] A start job is running for /sysroot (16s / 1min 35s)[   17.771158] xfs_log_mount_finish: Recovery needed is set
>> [   17.771172] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:0
>> [   17.771179] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:1
>> [   17.771184] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:2
>> [   17.771190] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:3
>> [   17.771196] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:4
>> [   17.771201] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:5
>> [   17.801033] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:6
>> [   17.801041] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:7
>> [   17.801046] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:8
>> [   17.801052] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:9
>> [   17.801057] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:10
>> [   17.801063] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:11
>> [   17.801068] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:12
>> [   17.801272] xlog_recover_iunlink_bucket: bucket: 13, agino: 3064909, ino: 3064909, iget ret: 0, previno:18446744073709551615, prev_agino:4294967295
>>
>> <previno, prev_agino> is just <-1 %ull and -1 %u> in above. That's why
>> the huge value.
>
> That's NULLFSINO and NULLAGINO respectively. That's the indication
> that this is the last inode on the chain and that the recovery loop
> should terminate at this inode.
>
> Nothing looks wrong to me there.

Yes, that's right.

>
>
>> 2. Then these are the logs from xfs_repair -n /dev/dm-0
>> Here you will notice the same agi 3064909 in bucket 13 (from phase-2) which got also
>> printed in above xlog_recover_iunlink_ag() function.
>>
>> switch_root:/# xfs_repair -n /dev/dm-0
>> Phase 1 - find and verify superblock...
>> Phase 2 - using internal log
>>         - zero log...
>>         - scan filesystem freespace and inode maps...
>> agi unlinked bucket 13 is 3064909 in ag 0 (inode=3064909)
>>         - found root inode chunk
>> Phase 3 - for each AG...
>>         - scan (but don't clear) agi unlinked lists...
>>         - process known inodes and perform inode discovery...
>>         - agno = 0
>>         - agno = 1
>>         - agno = 2
>>         - agno = 3
>>         - process newly discovered inodes...
>> Phase 4 - check for duplicate blocks...
>>         - setting up duplicate extent list...
>>         - check for inodes claiming duplicate blocks...
>>         - agno = 0
>>         - agno = 2
>>         - agno = 1
>>         - agno = 3
>> No modify flag set, skipping phase 5
>> Phase 6 - check inode connectivity...
>>         - traversing filesystem ...
>>         - traversal finished ...
>>         - moving disconnected inodes to lost+found ...
>> Phase 7 - verify link counts...
>> would have reset inode 3064909 nlinks from 4294967291 to 2
>
> And there's the problem. The link count, as an signed int, is -5.
> It got reset to 2 probably because it was moved to lost+found due to
> having a non-zero link count. Not sure how it got to -5 and I
> suspect we'll never really know. However, I think that's irrelevant
> because if we fix the problem with unlink recovery failing to
> register an unlink recovery error from inodegc we'll intentionally
> leak the inode and it won't ever be a problem again.
>
>
>> No modify flag set, skipping filesystem flush and exiting.
>>
>>
>> 3. Then we exit from the shell for the system to continue booting.
>> Here it will continue.. Just pasting the logs where the warning gets
>> generated and some extra logs are getting printed for the same inode
>> with our patch.
>>
>>
>> it continues
>> ================
>> [  587.999113] ------------[ cut here ]------------
>> [  587.999121] WARNING: CPU: 48 PID: 2026 at fs/xfs/xfs_inode.c:1839 xfs_iunlink_lookup+0x58/0x80 [xfs]
>
> Yeah, that happens because we failed to recover the unlinked inode,
> we don't feed errors that occur in inodegc back to the unlink
> recovery code, so it didn't clear the AGI bucket when we failed to
> remove the inode from the unlinked list in inodegc. Hence it goes to
> add the new inode to the start of unlinked list, and doesn't find the
> broken, unrecovered inode that the bucket points to in cache.
>
> IOWs, we fix the problem with feeding back errors from inodegc to
> iunlink recovery, and this specific issue will go away.
>
>> I can spend some more time to debug and understand on how to fix this.
>> But thought of sharing this info meanwhile and see if there are any
>> pointers on how to fix this in kernel.
>
> I suspect that we need to do something like gather an error in
> xfs_inodegc_flush() like we do for gathering the error in
> xfs_btree_split() from the offloaded xfs_btree_split_worker()...
>

Thanks Dave for pointers. I haven't yet started looking into it.
Once I get few other things off my plate. I can start looking into this.

-ritesh
