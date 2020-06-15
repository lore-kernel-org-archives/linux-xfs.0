Return-Path: <SRS0=I2eC=74=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65EFAC433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Jun 2020 20:53:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E6C920768
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Jun 2020 20:53:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZP1NcRTc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731693AbgFOUxy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Jun 2020 16:53:54 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:57205 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731688AbgFOUxx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Jun 2020 16:53:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592254431;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yVc8FVEHGw/fuRb0Dy/ArqZ1F92rZ6HzYhBb/pVuY9I=;
        b=ZP1NcRTcnL3+Q1RcZuSlfcNYZczlpINRgpHiERVBVh/fEqWIiUl5BzWKZMw7vmPzXF0dVI
        sZ5U0fWHI4J3IHzku9tqjcJjPcTEXbEl01OhsW1eemoBiyZvU2l+Qe/cf8RH2lWhvcFZZ1
        nc4WmHtBF6CIRQM79LZtfXwfcEd43rI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-jNzpBkjhOAaFaMp1q2b6ow-1; Mon, 15 Jun 2020 16:53:47 -0400
X-MC-Unique: jNzpBkjhOAaFaMp1q2b6ow-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C364C873402;
        Mon, 15 Jun 2020 20:53:45 +0000 (UTC)
Received: from llong.remote.csb (ovpn-117-41.rdu2.redhat.com [10.10.117.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C7BC25D9CD;
        Mon, 15 Jun 2020 20:53:38 +0000 (UTC)
Subject: Re: [PATCH 2/2] xfs: Fix false positive lockdep warning with
 sb_internal & fs_reclaim
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, Qian Cai <cai@lca.pw>,
        Eric Sandeen <sandeen@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20200615160830.8471-1-longman@redhat.com>
 <20200615160830.8471-3-longman@redhat.com> <20200615164351.GF11255@magnolia>
From:   Waiman Long <longman@redhat.com>
Organization: Red Hat
Message-ID: <2f03b074-4732-01e4-b0ff-482bb4bb44ce@redhat.com>
Date:   Mon, 15 Jun 2020 16:53:38 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200615164351.GF11255@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/15/20 12:43 PM, Darrick J. Wong wrote:
> On Mon, Jun 15, 2020 at 12:08:30PM -0400, Waiman Long wrote:
>> Depending on the workloads, the following circular locking dependency
>> warning between sb_internal (a percpu rwsem) and fs_reclaim (a pseudo
>> lock) may show up:
>>
>> ======================================================
>> WARNING: possible circular locking dependency detected
>> 5.0.0-rc1+ #60 Tainted: G        W
>> ------------------------------------------------------
>> fsfreeze/4346 is trying to acquire lock:
>> 0000000026f1d784 (fs_reclaim){+.+.}, at:
>> fs_reclaim_acquire.part.19+0x5/0x30
>>
>> but task is already holding lock:
>> 0000000072bfc54b (sb_internal){++++}, at: percpu_down_write+0xb4/0x650
>>
>> which lock already depends on the new lock.
>>    :
>>   Possible unsafe locking scenario:
>>
>>         CPU0                    CPU1
>>         ----                    ----
>>    lock(sb_internal);
>>                                 lock(fs_reclaim);
>>                                 lock(sb_internal);
>>    lock(fs_reclaim);
>>
>>   *** DEADLOCK ***
>>
>> 4 locks held by fsfreeze/4346:
>>   #0: 00000000b478ef56 (sb_writers#8){++++}, at: percpu_down_write+0xb4/0x650
>>   #1: 000000001ec487a9 (&type->s_umount_key#28){++++}, at: freeze_super+0xda/0x290
>>   #2: 000000003edbd5a0 (sb_pagefaults){++++}, at: percpu_down_write+0xb4/0x650
>>   #3: 0000000072bfc54b (sb_internal){++++}, at: percpu_down_write+0xb4/0x650
>>
>> stack backtrace:
>> Call Trace:
>>   dump_stack+0xe0/0x19a
>>   print_circular_bug.isra.10.cold.34+0x2f4/0x435
>>   check_prev_add.constprop.19+0xca1/0x15f0
>>   validate_chain.isra.14+0x11af/0x3b50
>>   __lock_acquire+0x728/0x1200
>>   lock_acquire+0x269/0x5a0
>>   fs_reclaim_acquire.part.19+0x29/0x30
>>   fs_reclaim_acquire+0x19/0x20
>>   kmem_cache_alloc+0x3e/0x3f0
>>   kmem_zone_alloc+0x79/0x150
>>   xfs_trans_alloc+0xfa/0x9d0
>>   xfs_sync_sb+0x86/0x170
>>   xfs_log_sbcount+0x10f/0x140
>>   xfs_quiesce_attr+0x134/0x270
>>   xfs_fs_freeze+0x4a/0x70
>>   freeze_super+0x1af/0x290
>>   do_vfs_ioctl+0xedc/0x16c0
>>   ksys_ioctl+0x41/0x80
>>   __x64_sys_ioctl+0x73/0xa9
>>   do_syscall_64+0x18f/0xd23
>>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
>>
>> This is a false positive as all the dirty pages are flushed out before
>> the filesystem can be frozen.
>>
>> Perhaps breaking the fs_reclaim pseudo lock into a per filesystem lock
>> may fix the issue. However, that will greatly complicate the logic and
>> may not be worth it.
>>
>> Another way to fix it is to disable the taking of the fs_reclaim
>> pseudo lock when in the freezing code path as a reclaim on the
>> freezed filesystem is not possible. By using the newly introduced
>> PF_MEMALLOC_NOLOCKDEP flag, lockdep checking is disabled in
>> xfs_trans_alloc() if XFS_TRANS_NO_WRITECOUNT flag is set.
>>
>> In the freezing path, there is another path where memory allocation
>> is being done without the XFS_TRANS_NO_WRITECOUNT flag:
>>
>>    xfs_fs_freeze()
>>    => xfs_quiesce_attr()
>>       => xfs_log_quiesce()
>>          => xfs_log_unmount_write()
>>             => xlog_unmount_write()
>>                => xfs_log_reserve()
>> 	         => xlog_ticket_alloc()
>>
>> In this case, we just disable fs reclaim for this particular 600 bytes
>> memory allocation.
>>
>> Without this patch, the command sequence below will show that the lock
>> dependency chain sb_internal -> fs_reclaim exists.
>>
>>   # fsfreeze -f /home
>>   # fsfreeze --unfreeze /home
>>   # grep -i fs_reclaim -C 3 /proc/lockdep_chains | grep -C 5 sb_internal
>>
>> After applying the patch, such sb_internal -> fs_reclaim lock dependency
>> chain can no longer be found. Because of that, the locking dependency
>> warning will not be shown.
>>
>> Suggested-by: Dave Chinner <david@fromorbit.com>
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>   fs/xfs/xfs_log.c   |  9 +++++++++
>>   fs/xfs/xfs_trans.c | 30 ++++++++++++++++++++++++++----
>>   2 files changed, 35 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
>> index 00fda2e8e738..33244680d0d4 100644
>> --- a/fs/xfs/xfs_log.c
>> +++ b/fs/xfs/xfs_log.c
>> @@ -830,8 +830,17 @@ xlog_unmount_write(
>>   	xfs_lsn_t		lsn;
>>   	uint			flags = XLOG_UNMOUNT_TRANS;
>>   	int			error;
>> +	unsigned long		pflags;
>>   
>> +	/*
>> +	 * xfs_log_reserve() allocates memory. This can lead to fs reclaim
>> +	 * which may conflicts with the unmount process. To avoid that,
>> +	 * disable fs reclaim for this allocation.
>> +	 */
>> +	current_set_flags_nested(&pflags, PF_MEMALLOC_NOFS);
>>   	error = xfs_log_reserve(mp, 600, 1, &tic, XFS_LOG, 0);
>> +	current_restore_flags_nested(&pflags, PF_MEMALLOC_NOFS);
>> +
>>   	if (error)
>>   		goto out_err;
>>   
>> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
>> index 3c94e5ff4316..ddb10ad3f51f 100644
>> --- a/fs/xfs/xfs_trans.c
>> +++ b/fs/xfs/xfs_trans.c
>> @@ -255,7 +255,27 @@ xfs_trans_alloc(
>>   	struct xfs_trans	**tpp)
>>   {
>>   	struct xfs_trans	*tp;
>> -	int			error;
>> +	int			error = 0;
>> +	unsigned long		pflags = -1;
>> +
>> +	/*
>> +	 * When XFS_TRANS_NO_WRITECOUNT is set, it means there are no dirty
>> +	 * data pages in the filesystem at this point.
> That's not true.  Look at the other callers of xfs_trans_alloc_empty.
Yes, I am aware of that. I can change it to check the freeze state.
>
> Also: Why not set PF_MEMALLOC_NOFS at the start of the freeze call
> chain?

I guess we can do that, but it eliminates a potential source for memory 
reclaim leading to freeze error when not much free memory is left. We 
can go this route if you think this is not a problem.

Cheers,
Longman

