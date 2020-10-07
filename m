Return-Path: <SRS0=AHt9=DO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40EA7C4363D
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 14:17:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7365212CC
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 14:17:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728265AbgJGORP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Oct 2020 10:17:15 -0400
Received: from sandeen.net ([63.231.237.45]:46156 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728177AbgJGORP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Oct 2020 10:17:15 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 1E983325D;
        Wed,  7 Oct 2020 09:16:15 -0500 (CDT)
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20201006191541.115364-1-preichl@redhat.com>
 <20201006191541.115364-5-preichl@redhat.com>
 <20201007012159.GA49547@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v9 4/4] xfs: replace mrlock_t with rw_semaphores
Message-ID: <066ebfa6-25a2-aee4-a01c-3803ef716361@sandeen.net>
Date:   Wed, 7 Oct 2020 09:17:13 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201007012159.GA49547@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/6/20 8:21 PM, Darrick J. Wong wrote:
> On Tue, Oct 06, 2020 at 09:15:41PM +0200, Pavel Reichl wrote:
>> Remove mrlock_t as it does not provide any extra value over
>> rw_semaphores. Make i_lock and i_mmaplock native rw_semaphores and
>> replace mr*() functions with native rwsem calls.
>>
>> Release the lock in xfs_btree_split() just before the work-queue
>> executing xfs_btree_split_worker() is scheduled and make
>> xfs_btree_split_worker() to acquire the lock as a first thing and
>> release it just before returning from the function. This it done so the
>> ownership of the lock is transfered between kernel threads and thus
>> lockdep won't complain about lock being held by a different kernel
>> thread.
>>
>> Signed-off-by: Pavel Reichl <preichl@redhat.com>
>> ---
>>  fs/xfs/libxfs/xfs_btree.c | 14 +++++++
>>  fs/xfs/mrlock.h           | 78 ---------------------------------------
>>  fs/xfs/xfs_inode.c        | 36 ++++++++++--------
>>  fs/xfs/xfs_inode.h        |  4 +-
>>  fs/xfs/xfs_iops.c         |  4 +-
>>  fs/xfs/xfs_linux.h        |  2 +-
>>  fs/xfs/xfs_super.c        |  6 +--
>>  7 files changed, 41 insertions(+), 103 deletions(-)
>>  delete mode 100644 fs/xfs/mrlock.h
>>
>> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
>> index 2d25bab68764..1d1bb8423688 100644
>> --- a/fs/xfs/libxfs/xfs_btree.c
>> +++ b/fs/xfs/libxfs/xfs_btree.c
>> @@ -2816,6 +2816,7 @@ xfs_btree_split_worker(
>>  	unsigned long		pflags;
>>  	unsigned long		new_pflags = PF_MEMALLOC_NOFS;
>>  
>> +	rwsem_acquire(&args->cur->bc_ino.ip->i_lock.dep_map, 0, 0, _RET_IP_);
> These calls also need a comment explaining just what they're doing.
> 
>>  	/*
>>  	 * we are in a transaction context here, but may also be doing work
>>  	 * in kswapd context, and hence we may need to inherit that state
>> @@ -2832,6 +2833,7 @@ xfs_btree_split_worker(
>>  	complete(args->done);
>>  
>>  	current_restore_flags_nested(&pflags, new_pflags);
>> +	rwsem_release(&args->cur->bc_ino.ip->i_lock.dep_map, _THIS_IP_);
> Note that as soon as you call complete(), xfs_btree_split can wake up
> and return, which means that *args could now point to reclaimed stack
> space.  This leads to crashes and memory corruption in generic/562 on
> a 1k block filesystem (though in principle this can happen anywhere):


What's the right way out of this; store *ip when we enter the function
and use that to get to the map, rather than args i guess?

Thanks,
-Eric
