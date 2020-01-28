Return-Path: <SRS0=UJS8=3R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60CAAC2D0DB
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jan 2020 18:00:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 380392173E
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jan 2020 18:00:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbgA1SAk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jan 2020 13:00:40 -0500
Received: from sandeen.net ([63.231.237.45]:45462 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726294AbgA1SAk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 28 Jan 2020 13:00:40 -0500
Received: from Lucys-MacBook-Air.local (erlite [10.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id ACFAE2AC5;
        Tue, 28 Jan 2020 12:00:39 -0600 (CST)
Subject: Re: [PATCH 1/4] xfs: change xfs_isilocked() to always use lockdep()
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200128145528.2093039-1-preichl@redhat.com>
 <20200128145528.2093039-2-preichl@redhat.com>
 <20200128164200.GP3447196@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <29f9dea6-1b02-c7a5-43ef-f7f5657f3b8f@sandeen.net>
Date:   Tue, 28 Jan 2020 12:00:37 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200128164200.GP3447196@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/28/20 10:42 AM, Darrick J. Wong wrote:
> On Tue, Jan 28, 2020 at 03:55:25PM +0100, Pavel Reichl wrote:
>> mr_writer is obsolete and the information it contains is accesible
>> from mr_lock.
>>
>> Signed-off-by: Pavel Reichl <preichl@redhat.com>
>> ---
>>   fs/xfs/xfs_inode.c | 8 ++++++--
>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>> index c5077e6326c7..32fac6152dc3 100644
>> --- a/fs/xfs/xfs_inode.c
>> +++ b/fs/xfs/xfs_inode.c
>> @@ -352,13 +352,17 @@ xfs_isilocked(
>>   {
>>   	if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
>>   		if (!(lock_flags & XFS_ILOCK_SHARED))
>> -			return !!ip->i_lock.mr_writer;
>> +			return !debug_locks ||
>> +				lockdep_is_held_type(&ip->i_lock.mr_lock, 0);
> 
> Why do we reference debug_locks here directly?  It looks as though that
> variable exists to shut up lockdep assertions WARN_ONs, but
> xfs_isilocked is a predicate (and not itself an assertion), so why can't
> we 'return lockdep_is_held_type(...);' directly?
> 
> (He says scowling at his own RVB in 6552321831dce).

yes that's the answer to why /this/ patch does that ;)

We seem to not be the only ones but who knows if this is cargo cult or?

8 i915/gem/i915_gem_object. i915_gem_object_lookup_rc   66 
WARN_ON(debug_locks && !lock_is_held(&rcu_lock_map));

l include/net/sock.h        sock_owned_by_me          1573 
WARN_ON_ONCE(!lockdep_sock_is_held(sk) && debug_locks);

I'd be inclined to accept this as the current way xfs_isilocked handles
the lockdep tests, and if it's wrong or unnecessary that's another patch.

-Eric

> --D
> 
>>   		return rwsem_is_locked(&ip->i_lock.mr_lock);
>>   	}
>>   
>>   	if (lock_flags & (XFS_MMAPLOCK_EXCL|XFS_MMAPLOCK_SHARED)) {
>>   		if (!(lock_flags & XFS_MMAPLOCK_SHARED))
>> -			return !!ip->i_mmaplock.mr_writer;
>> +			return !debug_locks ||
>> +				lockdep_is_held_type(
>> +					&ip->i_mmaplock.mr_lock,
>> +					0);
>>   		return rwsem_is_locked(&ip->i_mmaplock.mr_lock);
>>   	}
>>   
>> -- 
>> 2.24.1
>>
> 

