Return-Path: <SRS0=guuR=DN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB377C4363D
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 13:54:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97BC720789
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 13:54:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725942AbgJFNyc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Oct 2020 09:54:32 -0400
Received: from sandeen.net ([63.231.237.45]:37064 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbgJFNyc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Oct 2020 09:54:32 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id B002848C697;
        Tue,  6 Oct 2020 08:53:33 -0500 (CDT)
To:     Pavel Reichl <preichl@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20201005213852.233004-1-preichl@redhat.com>
 <20201005213852.233004-5-preichl@redhat.com>
 <20201006041426.GH49547@magnolia>
 <1796931d-fe5d-2d81-e5bc-2369f89a4688@redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v8 4/4] xfs: replace mrlock_t with rw_semaphores
Message-ID: <6079f146-e4e9-2b6f-4a9f-b18f840f924b@sandeen.net>
Date:   Tue, 6 Oct 2020 08:54:30 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <1796931d-fe5d-2d81-e5bc-2369f89a4688@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/6/20 5:50 AM, Pavel Reichl wrote:
> 
> 
> On 10/6/20 6:14 AM, Darrick J. Wong wrote:
>> On Mon, Oct 05, 2020 at 11:38:52PM +0200, Pavel Reichl wrote:
>>> Remove mrlock_t as it does not provide any extra value over
>>> rw_semaphores. Make i_lock and i_mmaplock native rw_semaphores and
>>> replace mr*() functions with native rwsem calls.
>>>
>>> Release the lock in xfs_btree_split() just before the work-queue
>>> executing xfs_btree_split_worker() is scheduled and make
>>> xfs_btree_split_worker() to acquire the lock as a first thing and
>>> release it just before returning from the function. This it done so the
>>> ownership of the lock is transfered between kernel threads and thus
>>> lockdep won't complain about lock being held by a different kernel
>>> thread.
>>>
>>> Signed-off-by: Pavel Reichl <preichl@redhat.com>
>>> ---
>>>  fs/xfs/libxfs/xfs_btree.c | 10 +++++
>>>  fs/xfs/mrlock.h           | 78 ---------------------------------------
>>>  fs/xfs/xfs_inode.c        | 36 ++++++++++--------
>>>  fs/xfs/xfs_inode.h        |  4 +-
>>>  fs/xfs/xfs_iops.c         |  4 +-
>>>  fs/xfs/xfs_linux.h        |  2 +-
>>>  fs/xfs/xfs_super.c        |  6 +--
>>>  7 files changed, 37 insertions(+), 103 deletions(-)
>>>  delete mode 100644 fs/xfs/mrlock.h
>>>
>>> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
>>> index 2d25bab68764..d798d288eed1 100644
>>> --- a/fs/xfs/libxfs/xfs_btree.c
>>> +++ b/fs/xfs/libxfs/xfs_btree.c
>>> @@ -2816,6 +2816,7 @@ xfs_btree_split_worker(
>>>  	unsigned long		pflags;
>>>  	unsigned long		new_pflags = PF_MEMALLOC_NOFS;
>>>  
>>> +	rwsem_acquire(&args->cur->bc_ino.ip->i_lock.dep_map, 0, 0, _RET_IP_);
>>>  	/*
>>>  	 * we are in a transaction context here, but may also be doing work
>>>  	 * in kswapd context, and hence we may need to inherit that state
>>> @@ -2832,6 +2833,7 @@ xfs_btree_split_worker(
>>>  	complete(args->done);
>>>  
>>>  	current_restore_flags_nested(&pflags, new_pflags);
>>> +	rwsem_release(&args->cur->bc_ino.ip->i_lock.dep_map, _THIS_IP_);
>>>  }
>>>  
>>>  /*
>>> @@ -2863,8 +2865,16 @@ xfs_btree_split(
>>>  	args.done = &done;
>>>  	args.kswapd = current_is_kswapd();
>>>  	INIT_WORK_ONSTACK(&args.work, xfs_btree_split_worker);
>>> +
>>> +	/* Release the lock so it can be acquired in the kernel thread which
>>
>> Strange comment style.
> 
> OK, I'll try to think about something better, but ideas are welcome :-).


	/*
	 * Typical multi-line XFS comments are like this, with no
	 * comment text on the opening or closing lines
	 */

	/* Single-line comments are fine like this though */

-Eric
