Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77BE1C35666
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 20:28:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53B342072C
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 20:28:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgBUU2N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 15:28:13 -0500
Received: from sandeen.net ([63.231.237.45]:54586 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726483AbgBUU2M (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 21 Feb 2020 15:28:12 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 1D6A92A77;
        Fri, 21 Feb 2020 14:27:53 -0600 (CST)
Subject: Re: [PATCH v5 1/4] xfs: Refactor xfs_isilocked()
To:     Pavel Reichl <preichl@redhat.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
References: <20200214185942.1147742-1-preichl@redhat.com>
 <20200217133521.GD31012@infradead.org> <20200219044821.GK9506@magnolia>
 <20200219184019.GA10588@infradead.org>
 <CAJc7PzWVnV+ny_13rZVjEq_GMYWQciH_hWm+OXkw-OFQtn-zDg@mail.gmail.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <febec3d8-297b-9f67-b113-a068199a84e4@sandeen.net>
Date:   Fri, 21 Feb 2020 14:28:10 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAJc7PzWVnV+ny_13rZVjEq_GMYWQciH_hWm+OXkw-OFQtn-zDg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/21/20 11:49 AM, Pavel Reichl wrote:
> On Wed, Feb 19, 2020 at 7:40 PM Christoph Hellwig <hch@infradead.org> wrote:
>>
>> On Tue, Feb 18, 2020 at 08:48:21PM -0800, Darrick J. Wong wrote:
>>>>> +static inline bool
>>>>> +__xfs_rwsem_islocked(
>>>>> + struct rw_semaphore     *rwsem,
>>>>> + bool                    shared,
>>>>> + bool                    excl)
>>>>> +{
>>>>> + bool locked = false;
>>>>> +
>>>>> + if (!rwsem_is_locked(rwsem))
>>>>> +         return false;
>>>>> +
>>>>> + if (!debug_locks)
>>>>> +         return true;
>>>>> +
>>>>> + if (shared)
>>>>> +         locked = lockdep_is_held_type(rwsem, 0);
>>>>> +
>>>>> + if (excl)
>>>>> +         locked |= lockdep_is_held_type(rwsem, 1);
>>>>> +
>>>>> + return locked;
>>>>
>>>> This could use some comments explaining the logic, especially why we
>>>> need the shared and excl flags, which seems very confusing given that
>>>> a lock can be held either shared or exclusive, but not neither and not
>>>> both.
>>>
>>> Yes, this predicate should document that callers are allowed to pass in
>>> shared==true and excl==true when the caller wants to assert that either
>>> lock type (shared or excl) of a given lock class (e.g. iolock) are held.
>>
>> Looking at the lockdep_is_held_type implementation, and our existing
>> code for i_rwsem I really don't see the point of the extra shared
>> check.  Something like:
>>
>> static inline bool
>> __xfs_rwsem_islocked(
>>         struct rw_semaphore     *rwsem,
>>         bool                    excl)
>> {
>>         if (rwsem_is_locked(rwsem)) {
>>                 if (debug_locks && excl)
>>                         return lockdep_is_held_type(rwsem, 1);
>>                 return true;
>>         }
>>
>>         return false;
>> }
>>
>> should be all that we really need.
>>
> 
> You don't see the point of extra shared check, but if we want to check
> that the semaphore is locked for reading and not writing? Having the
> semaphore locked for writing would make the code safe from race
> condition but could be a performance hit, right?

So, I raised this question with Pavel but I think maybe it was borne
of my misunderstanding.

Ok let me think this through.  Today we have:

int
xfs_isilocked(
        xfs_inode_t             *ip,
        uint                    lock_flags)
{
        if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
                if (!(lock_flags & XFS_ILOCK_SHARED))
                        return !!ip->i_lock.mr_writer;
                return rwsem_is_locked(&ip->i_lock.mr_lock);
        }
        ....

If we assert xfs_isilocked(ip, XFS_ILOCK_SHARED) I guess we /already/ get a positive
result if the inode is actually locked XFS_ILOCK_EXCL.  So perhaps Christoph's
suggestion really just keeps implementing what we already have today.

It might be a reasonable question re: whether we ever want to know that we are locked
shared and NOT locked exclusive, but we can't do that today, so I guess it shouldn't
complicate this patchset.

... do I have this right?

Thanks,
-Eric
