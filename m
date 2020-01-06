Return-Path: <SRS0=XUqT=23=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F122C33C8C
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jan 2020 16:12:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC49C2081E
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jan 2020 16:12:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Nv9ar04e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgAFQMp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jan 2020 11:12:45 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:22680 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726569AbgAFQMp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jan 2020 11:12:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578327163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=otQR14ZHAEs5fZRWhXMbTMZbPkYmSvrTy7oLISGg8bE=;
        b=Nv9ar04efWP1/7GA4IbbY+OIBoNVLdt6JVTHHtPjiejhHbR6Bmzr1RO/emSUlrf0Jx/rBl
        Ylf62z2nlsLKKq0tNIrKz6eYEo1PNlQFCbD9oh1MU/jWiYxHIy7/6ZfBI1/q7Mn3LXgcg4
        pX5x7t/5m7tJhtdSFyH/WBavFGoSdv8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-Ah9XhzbZODCT764vK5zSAw-1; Mon, 06 Jan 2020 11:12:38 -0500
X-MC-Unique: Ah9XhzbZODCT764vK5zSAw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4302D1083947;
        Mon,  6 Jan 2020 16:12:37 +0000 (UTC)
Received: from llong.remote.csb (dhcp-17-59.bos.redhat.com [10.18.17.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5920F10842A9;
        Mon,  6 Jan 2020 16:12:33 +0000 (UTC)
Subject: Re: [PATCH] xfs: Fix false positive lockdep warning with sb_internal
 & fs_reclaim
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qian Cai <cai@lca.pw>, Eric Sandeen <sandeen@redhat.com>
References: <20200102155208.8977-1-longman@redhat.com>
 <20200104023657.GA23128@dread.disaster.area>
From:   Waiman Long <longman@redhat.com>
Organization: Red Hat
Message-ID: <922bff4b-a463-11db-f969-d268462802a1@redhat.com>
Date:   Mon, 6 Jan 2020 11:12:32 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200104023657.GA23128@dread.disaster.area>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/3/20 9:36 PM, Dave Chinner wrote:
> On Thu, Jan 02, 2020 at 10:52:08AM -0500, Waiman Long wrote:
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
>>   :
>>  Possible unsafe locking scenario:
>>
>>        CPU0                    CPU1
>>        ----                    ----
>>   lock(sb_internal);
>>                                lock(fs_reclaim);
>>                                lock(sb_internal);
>>   lock(fs_reclaim);
>>
>>  *** DEADLOCK ***
>>
>> 4 locks held by fsfreeze/4346:
>>  #0: 00000000b478ef56 (sb_writers#8){++++}, at: percpu_down_write+0xb4/0x650
>>  #1: 000000001ec487a9 (&type->s_umount_key#28){++++}, at: freeze_super+0xda/0x290
>>  #2: 000000003edbd5a0 (sb_pagefaults){++++}, at: percpu_down_write+0xb4/0x650
>>  #3: 0000000072bfc54b (sb_internal){++++}, at: percpu_down_write+0xb4/0x650
>>
>> stack backtrace:
>> Call Trace:
>>  dump_stack+0xe0/0x19a
>>  print_circular_bug.isra.10.cold.34+0x2f4/0x435
>>  check_prev_add.constprop.19+0xca1/0x15f0
>>  validate_chain.isra.14+0x11af/0x3b50
>>  __lock_acquire+0x728/0x1200
>>  lock_acquire+0x269/0x5a0
>>  fs_reclaim_acquire.part.19+0x29/0x30
>>  fs_reclaim_acquire+0x19/0x20
>>  kmem_cache_alloc+0x3e/0x3f0
>>  kmem_zone_alloc+0x79/0x150
>>  xfs_trans_alloc+0xfa/0x9d0
>>  xfs_sync_sb+0x86/0x170
>>  xfs_log_sbcount+0x10f/0x140
>>  xfs_quiesce_attr+0x134/0x270
>>  xfs_fs_freeze+0x4a/0x70
>>  freeze_super+0x1af/0x290
>>  do_vfs_ioctl+0xedc/0x16c0
>>  ksys_ioctl+0x41/0x80
>>  __x64_sys_ioctl+0x73/0xa9
>>  do_syscall_64+0x18f/0xd23
>>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>>
>> According to Dave Chinner:
>>
>>   Freezing the filesystem, after all the data has been cleaned. IOWs
>>   memory reclaim will never run the above writeback path when
>>   the freeze process is trying to allocate a transaction here because
>>   there are no dirty data pages in the filesystem at this point.
>>
>>   Indeed, this xfs_sync_sb() path sets XFS_TRANS_NO_WRITECOUNT so that
>>   it /doesn't deadlock/ by taking freeze references for the
>>   transaction. We've just drained all the transactions
>>   in progress and written back all the dirty metadata, too, and so the
>>   filesystem is completely clean and only needs the superblock to be
>>   updated to complete the freeze process. And to do that, it does not
>>   take a freeze reference because calling sb_start_intwrite() here
>>   would deadlock.
>>
>>   IOWs, this is a false positive, caused by the fact that
>>   xfs_trans_alloc() is called from both above and below memory reclaim
>>   as well as within /every level/ of freeze processing. Lockdep is
>>   unable to describe the staged flush logic in the freeze process that
>>   prevents deadlocks from occurring, and hence we will pretty much
>>   always see false positives in the freeze path....
>>
>> Perhaps breaking the fs_reclaim pseudo lock into a per filesystem lock
>> may fix the issue. However, that will greatly complicate the logic and
>> may not be worth it.
> ANd it won't work, because now we'll just get lockedp warnings on
> the per-fs reclaim lockdep context.

It may or may not work depending on how we are going to break it up. I
haven't thought through that alternative yet as I am expecting that it
will be a bigger change if we decide to go this route.


>
>> Another way to fix it is to disable the taking of the fs_reclaim
>> pseudo lock when in the freezing code path as a reclaim on the freezed
>> filesystem is not possible as stated above. This patch takes this
>> approach by setting the __GFP_NOLOCKDEP flag in the slab memory
>> allocation calls when the filesystem has been freezed.
> IOWs, "fix" it by stating that "lockdep can't track freeze
> dependencies correctly"?
The lockdep code has a singular focus on spotting possible deadlock
scenarios from a locking point of view. The freeze dependency has to be
properly translated into appropriate locking sequences to make lockdep
work correctly. I would say that the use of a global fs_reclaim pseudo
lock is not a perfect translation and so it has exception cases we need
to handle.
>
> In the past we have just used KM_NOFS for that, because
> __GFP_NOLOCKDEP didn't exist. But that has just been a nasty hack
> because lockdep isn't capable of understanding allocation context
> constraints because allocation contexts are much more complex than a
> "lock"....
>
>
>> --- a/fs/xfs/kmem.h
>> +++ b/fs/xfs/kmem.h
>> @@ -20,6 +20,12 @@ typedef unsigned __bitwise xfs_km_flags_t;
>>  #define KM_MAYFAIL	((__force xfs_km_flags_t)0x0008u)
>>  #define KM_ZERO		((__force xfs_km_flags_t)0x0010u)
>>  
>> +#ifdef CONFIG_LOCKDEP
>> +#define KM_NOLOCKDEP	((__force xfs_km_flags_t)0x0020u)
>> +#else
>> +#define KM_NOLOCKDEP	((__force xfs_km_flags_t)0)
>> +#endif
> Nope. We are getting rid of kmem_alloc wrappers and all the
> associated flags, not adding new ones. Part of that process is
> identifying all the places we currently use KM_NOFS to "shut up
> lockdep" and converting them to explicit __GFP_NOLOCKDEP flags.
>
> So right now, this change needs to be queued up behind the API
> changes that are currently in progress...

That is fine. I can wait and post a revised patch after that. Who is
going to make these changes?


>> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
>> index f6006d94a581..b1997649ecd8 100644
>> --- a/fs/xfs/xfs_log.c
>> +++ b/fs/xfs/xfs_log.c
>> @@ -454,7 +454,8 @@ xfs_log_reserve(
>>  	XFS_STATS_INC(mp, xs_try_logspace);
>>  
>>  	ASSERT(*ticp == NULL);
>> -	tic = xlog_ticket_alloc(log, unit_bytes, cnt, client, permanent, 0);
>> +	tic = xlog_ticket_alloc(log, unit_bytes, cnt, client, permanent,
>> +			mp->m_super->s_writers.frozen ? KM_NOLOCKDEP : 0);
> This is pretty nasty. Having to spew conditional code like this
> across every allocation that could be done in freeze conditions is
> a non-starter.
>
> We already have a flag to tell us we are doing a transaction in a
> freeze state, so use that to turn off lockdep. That is:

OK.


>>  	*ticp = tic;
>>  
>>  	xlog_grant_push_ail(log, tic->t_cnt ? tic->t_unit_res * tic->t_cnt
>> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
>> index 3b208f9a865c..c0e42e4f5b77 100644
>> --- a/fs/xfs/xfs_trans.c
>> +++ b/fs/xfs/xfs_trans.c
>> @@ -262,8 +262,14 @@ xfs_trans_alloc(
>>  	 * Allocate the handle before we do our freeze accounting and setting up
>>  	 * GFP_NOFS allocation context so that we avoid lockdep false positives
>>  	 * by doing GFP_KERNEL allocations inside sb_start_intwrite().
>> +	 *
>> +	 * To prevent false positive lockdep warning of circular locking
>> +	 * dependency between sb_internal and fs_reclaim, disable the
>> +	 * acquisition of the fs_reclaim pseudo-lock when the superblock
>> +	 * has been frozen or in the process of being frozen.
>>  	 */
>> -	tp = kmem_zone_zalloc(xfs_trans_zone, 0);
>> +	tp = kmem_zone_zalloc(xfs_trans_zone,
>> +		mp->m_super->s_writers.frozen ? KM_NOLOCKDEP : 0);
>>  	if (!(flags & XFS_TRANS_NO_WRITECOUNT))
>>  		sb_start_intwrite(mp->m_super);
> This code here should be setting PF_GFP_NOLOCKDEP state to turn off
> lockdep for all allocations in this context, similar to the way we
> use memalloc_nofs_save/restore so that all nested allocations
> inherit GFP_NOFS state...

Sure.

Thanks for the comments.

Cheers,
Longman

