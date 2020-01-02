Return-Path: <SRS0=76Wm=2X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C70CC2D0C2
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jan 2020 18:41:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C96EB21582
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jan 2020 18:41:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e+7/9PLu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbgABSla (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Jan 2020 13:41:30 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:32207 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727951AbgABSla (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Jan 2020 13:41:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577990487;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ab29eiOf5rCBzfzo0NudRqfVJUQsrfjBWEmuZyT1adY=;
        b=e+7/9PLuwkxi+wvbvC+dvgvPNIT+0bclfgcM4K6nj1bQjqL6QhDTf6GNWrKy/v69zGyg80
        lGtCISUIiRAKQzIA0/MIJjG/t4XmVDRt/EvCxe4RnWim5IbDx4EHzV1l8c5Rzqj7KTAdNM
        pla/iU5naw6zrK12r4ycqtFgMKMrjaA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-xwMoJwzMNS-9qr64cm_Mpw-1; Thu, 02 Jan 2020 13:41:26 -0500
X-MC-Unique: xwMoJwzMNS-9qr64cm_Mpw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 87538DBE5;
        Thu,  2 Jan 2020 18:41:24 +0000 (UTC)
Received: from llong.remote.csb (dhcp-17-59.bos.redhat.com [10.18.17.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 970EA5C553;
        Thu,  2 Jan 2020 18:41:21 +0000 (UTC)
Subject: Re: [PATCH] xfs: Fix false positive lockdep warning with sb_internal
 & fs_reclaim
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, Qian Cai <cai@lca.pw>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>
References: <20200102155208.8977-1-longman@redhat.com>
 <24F33D67-E975-48E1-A285-0D0129CC3033@lca.pw>
 <20200102182435.GB1508633@magnolia>
From:   Waiman Long <longman@redhat.com>
Organization: Red Hat
Message-ID: <2eea17a5-a9b7-29e0-62bc-15cdb676abcd@redhat.com>
Date:   Thu, 2 Jan 2020 13:41:20 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200102182435.GB1508633@magnolia>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/2/20 1:24 PM, Darrick J. Wong wrote:
> On Thu, Jan 02, 2020 at 11:19:51AM -0500, Qian Cai wrote:
>>
>>> On Jan 2, 2020, at 10:52 AM, Waiman Long <longman@redhat.com> wrote:
>>>
>>> Depending on the workloads, the following circular locking dependency
>>> warning between sb_internal (a percpu rwsem) and fs_reclaim (a pseudo
>>> lock) may show up:
>>>
>>> ======================================================
>>> WARNING: possible circular locking dependency detected
>>> 5.0.0-rc1+ #60 Tainted: G        W
>>> ------------------------------------------------------
>>> fsfreeze/4346 is trying to acquire lock:
>>> 0000000026f1d784 (fs_reclaim){+.+.}, at:
>>> fs_reclaim_acquire.part.19+0x5/0x30
>>>
>>> but task is already holding lock:
>>> 0000000072bfc54b (sb_internal){++++}, at: percpu_down_write+0xb4/0x650
>>>
>>> which lock already depends on the new lock.
>>>  :
>>> Possible unsafe locking scenario:
>>>
>>>       CPU0                    CPU1
>>>       ----                    ----
>>>  lock(sb_internal);
>>>                               lock(fs_reclaim);
>>>                               lock(sb_internal);
>>>  lock(fs_reclaim);
>>>
>>> *** DEADLOCK ***
>>>
>>> 4 locks held by fsfreeze/4346:
>>> #0: 00000000b478ef56 (sb_writers#8){++++}, at: percpu_down_write+0xb4/0x650
>>> #1: 000000001ec487a9 (&type->s_umount_key#28){++++}, at: freeze_super+0xda/0x290
>>> #2: 000000003edbd5a0 (sb_pagefaults){++++}, at: percpu_down_write+0xb4/0x650
>>> #3: 0000000072bfc54b (sb_internal){++++}, at: percpu_down_write+0xb4/0x650
>>>
>>> stack backtrace:
>>> Call Trace:
>>> dump_stack+0xe0/0x19a
>>> print_circular_bug.isra.10.cold.34+0x2f4/0x435
>>> check_prev_add.constprop.19+0xca1/0x15f0
>>> validate_chain.isra.14+0x11af/0x3b50
>>> __lock_acquire+0x728/0x1200
>>> lock_acquire+0x269/0x5a0
>>> fs_reclaim_acquire.part.19+0x29/0x30
>>> fs_reclaim_acquire+0x19/0x20
>>> kmem_cache_alloc+0x3e/0x3f0
>>> kmem_zone_alloc+0x79/0x150
>>> xfs_trans_alloc+0xfa/0x9d0
>>> xfs_sync_sb+0x86/0x170
>>> xfs_log_sbcount+0x10f/0x140
>>> xfs_quiesce_attr+0x134/0x270
>>> xfs_fs_freeze+0x4a/0x70
>>> freeze_super+0x1af/0x290
>>> do_vfs_ioctl+0xedc/0x16c0
>>> ksys_ioctl+0x41/0x80
>>> __x64_sys_ioctl+0x73/0xa9
>>> do_syscall_64+0x18f/0xd23
>>> entry_SYSCALL_64_after_hwframe+0x49/0xbe
>>>
>>> According to Dave Chinner:
>>>
>>>  Freezing the filesystem, after all the data has been cleaned. IOWs
>>>  memory reclaim will never run the above writeback path when
>>>  the freeze process is trying to allocate a transaction here because
>>>  there are no dirty data pages in the filesystem at this point.
>>>
>>>  Indeed, this xfs_sync_sb() path sets XFS_TRANS_NO_WRITECOUNT so that
>>>  it /doesn't deadlock/ by taking freeze references for the
>>>  transaction. We've just drained all the transactions
>>>  in progress and written back all the dirty metadata, too, and so the
>>>  filesystem is completely clean and only needs the superblock to be
>>>  updated to complete the freeze process. And to do that, it does not
>>>  take a freeze reference because calling sb_start_intwrite() here
>>>  would deadlock.
>>>
>>>  IOWs, this is a false positive, caused by the fact that
>>>  xfs_trans_alloc() is called from both above and below memory reclaim
>>>  as well as within /every level/ of freeze processing. Lockdep is
>>>  unable to describe the staged flush logic in the freeze process that
>>>  prevents deadlocks from occurring, and hence we will pretty much
>>>  always see false positives in the freeze path....
>>>
>>> Perhaps breaking the fs_reclaim pseudo lock into a per filesystem lock
>>> may fix the issue. However, that will greatly complicate the logic and
>>> may not be worth it.
>>>
>>> Another way to fix it is to disable the taking of the fs_reclaim
>>> pseudo lock when in the freezing code path as a reclaim on the freezed
>>> filesystem is not possible as stated above. This patch takes this
>>> approach by setting the __GFP_NOLOCKDEP flag in the slab memory
>>> allocation calls when the filesystem has been freezed.
>>>
>>> Without this patch, the command sequence below will show that the lock
>>> dependency chain sb_internal -> fs_reclaim exists.
>>>
>>> # fsfreeze -f /home
>>> # fsfreeze --unfreeze /home
>>> # grep -i fs_reclaim -C 3 /proc/lockdep_chains | grep -C 5 sb_internal
>>>
>>> After applying the patch, such sb_internal -> fs_reclaim lock dependency
>>> chain can no longer be found. Because of that, the locking dependency
>>> warning will not be shown.
>> There was an attempt to fix this in the past, but Dave rejected right
>> away for any workaround in xfs and insisted to make lockdep smarter
>> instead. No sure your approach will make any difference this time.
>> Good luck.
> /me wonders if you can fix this by having the freeze path call
> memalloc_nofs_save() since we probably don't want to be recursing into
> the fs for reclaim while freezing it?  Probably not, because that's a
> bigger hammer than we really need here.  We can certainly steal memory
> from other filesystems that aren't frozen.
>
> It doesn't solve the key issue that lockdep isn't smart enough to know
> that we can't recurse into the fs that's being frozen and therefore
> there's no chance of deadlock.

Lockdep only looks at all the possible locking chains to see if a
circular deadlock is possible. It doesn't have the smart to understand
filesystem internals. The problem here is caused by the fact that
fs_reclaim is a global pseudo lock that is acquired whenever there is a
chance that FS reclaim can happen. As I said in the commit log, it may
be possible to fix that by breaking up fs_reclaim into a set of
per-filesystem pseudo locks, but that will add quite a bit of complexity
to the code. That is why I don't want to go this route. This patch is
the least invasive that I can think of to address the problem without
inhibiting other valid lockdep checking.

Cheers,
Longman

