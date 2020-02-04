Return-Path: <SRS0=4Qc2=3Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AED6C35247
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Feb 2020 22:20:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC63721582
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Feb 2020 22:20:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbgBDWUe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 17:20:34 -0500
Received: from sandeen.net ([63.231.237.45]:47926 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727534AbgBDWUe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Feb 2020 17:20:34 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id E21342542;
        Tue,  4 Feb 2020 16:20:32 -0600 (CST)
Subject: Re: [PATCH v2 2/7] xfs: Update checking excl. locks for ilock
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Pavel Reichl <preichl@redhat.com>, linux-xfs@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
References: <20200203175850.171689-1-preichl@redhat.com>
 <20200203175850.171689-3-preichl@redhat.com>
 <20200204062118.GB2910@infradead.org>
 <80f1173e-9181-c8cc-c06f-cbbfaa46a138@sandeen.net>
 <20200204210632.GL20628@dread.disaster.area>
From:   Eric Sandeen <sandeen@sandeen.net>
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <352ab46c-f5ed-33f4-9dfd-ecf540fb1017@sandeen.net>
Date:   Tue, 4 Feb 2020 16:20:32 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200204210632.GL20628@dread.disaster.area>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/4/20 3:06 PM, Dave Chinner wrote:
> On Tue, Feb 04, 2020 at 10:08:45AM -0600, Eric Sandeen wrote:
>> On 2/4/20 12:21 AM, Christoph Hellwig wrote:
>>>> -	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
>>>> +	ASSERT(xfs_is_ilocked(ip, XFS_ILOCK_EXCL));
>>>
>>> I think this is a very bad interface.  Either we keep our good old
>>> xfs_isilocked that just operates on the inode and lock flags, or
>>> we use something that gets the actual lock passed.  But an interface
>>> that encodes the lock in both the function called and the flags, and
>>> one that doesn't follow neither the XFS lock flags conventions nor
>>> the core kernel convention is just not very useful.
>>
>> I think this came out of Dave's suggestion on the previous patchset,
>> but I agree with you Chrisoph.  Even if there is a future reason to
>> split it out into a function for each type, I don't see a reason to
>> do it now, and this interface is awkward.
>>
>> I'd prefer to keep xfs_isilocked() with the current calling convention and
>> just change its internals to use lockdep.  Dave spotted a bug in the
>> current implementation, but I think that can be fixed.
>>
>> Splitting out the 3 lock testing functions seems to me like complexity
>> creep that doesn't need to be in this series.
>>
>> Dave, thoughts?
> 
> All I care about is that we get rid of the mrlock_t. I'm not
> interested in bikeshedding the details to death. I've put my 2c
> worth in, if you don't like it, then that's fine and I'm not going
> to get upset about that.

In the short term I'd suggest something like this. It keeps the helper,
but we don't have to change the callsites, and breaking out separate types
etc can be done after the mrlock removal patchset is done - in a separate
series if/when needed.

static inline bool
__xfs_rwsem_islocked(
        struct rw_semaphore     *rwsem,
        bool                    shared,
        bool                    excl)
{
        bool locked = false;

        if (!rwsem_is_locked(rwsem))
                return false;

        if (!debug_locks)
                return true;

        if (shared)
                locked = lockdep_is_held_type(rwsem, 0);

        if (excl)
                locked |= lockdep_is_held_type(rwsem, 1);

        return locked;
}

bool
xfs_isilocked(
        struct xfs_inode        *ip,
        uint                    lock_flags)
{       
        if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
                return __xfs_rwsem_islocked(&ip->i_lock.mr_lock,
                                (lock_flags & XFS_ILOCK_SHARED),
                                (lock_flags & XFS_ILOCK_EXCL));
        }
        if (lock_flags & (XFS_MMAPLOCK_EXCL|XFS_MMAPLOCK_SHARED)) {
                return __xfs_rwsem_islocked(&ip->i_mmlock.mr_lock,
                                (lock_flags & XFS_MMAPLOCK_SHARED),
                                (lock_flags & XFS_MMAPLOCK_EXCL));
        }
        if (lock_flags & (XFS_IOLOCK_EXCL|XFS_IOLOCK_SHARED)) {
                return __xfs_rwsem_islocked(&VFS_I(ip)->i_rwsem,
                                (lock_flags & XFS_IOLOCK_SHARED),
                                (lock_flags & XFS_IOLOCK_EXCL));
        }
}

That still has the problem/bug with the existing

	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL));

callsite since it doesn't actually test both types but again that is a separate
bugfix - it could be changed to accumulate a true/false state for all the flags
in the lock_flags argument in another bugfix patch.

-Eric
