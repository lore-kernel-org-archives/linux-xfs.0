Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Aug 2008 22:19:47 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m765JhSt008561
	for <xfs@oss.sgi.com>; Tue, 5 Aug 2008 22:19:44 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2C31D362967
	for <xfs@oss.sgi.com>; Tue,  5 Aug 2008 22:20:57 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id TvYSxN30Ik3Yah9p for <xfs@oss.sgi.com>; Tue, 05 Aug 2008 22:20:57 -0700 (PDT)
Date: Wed, 6 Aug 2008 15:20:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Move vn_iowait() earlier in the reclaim path
Message-ID: <20080806052053.GU6119@disturbed>
References: <4897F691.6010806@sgi.com> <20080805073711.GA21635@disturbed> <489806C2.7020200@sgi.com> <20080805084220.GF21635@disturbed> <48990C4E.9070102@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48990C4E.9070102@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs@oss.sgi.com, xfs-dev <xfs-dev@sgi.com>

On Wed, Aug 06, 2008 at 12:28:30PM +1000, Lachlan McIlroy wrote:
> Dave Chinner wrote:
>> On Tue, Aug 05, 2008 at 05:52:34PM +1000, Lachlan McIlroy wrote:
>>> Dave Chinner wrote:
>>>> On Tue, Aug 05, 2008 at 04:43:29PM +1000, Lachlan McIlroy wrote:
>>>>> Currently by the time we get to vn_iowait() in xfs_reclaim() we have already
>>>>> gone through xfs_inactive()/xfs_free() and recycled the inode.  Any I/O
>>>> xfs_free()? What's that?
>>> Sorry that should have been xfs_ifree() (we set the inode's mode to
>>> zero in there).
>>>
>>>>> completions still running (file size updates and unwritten extent conversions)
>>>>> may be working on an inode that is no longer valid.
>>>> The linux inode does not get freed until after ->clear_inode
>>>> completes, hence it is perfectly valid to reference it anywhere
>>>> in the ->clear_inode path.
>>> The problem I see is an assert in xfs_setfilesize() fail:
>>>
>>> 	ASSERT((ip->i_d.di_mode & S_IFMT) == S_IFREG);
>>>
>>> The mode of the XFS inode is zero at this time.
>>
>> Ok, so the question has to be why is there I/O still in progress
>> after the truncate is supposed to have already occurred and the
>> vn_iowait() in xfs_itruncate_start() been executed.
>>
>> Something doesn't add up here - you can't be doing I/O on a file
>> with no extents or delalloc blocks, hence that means we should be
>> passing through the truncate path in xfs_inactive() before we
>> call xfs_ifree() and therefore doing the vn_iowait()..
>>
>> Hmmmm - the vn_iowait() is conditional based on:
>>
>>         /* wait for the completion of any pending DIOs */
>>         if (new_size < ip->i_size)
>>                 vn_iowait(ip);
>>
>> We are truncating to zero (new_size == 0), so the only case where
>> this would not wait is if ip->i_size == 0. Still - I can't see
>> how we'd be doing I/O on an inode with a zero i_size. I suspect
>> ensuring we call vn_iowait() if newsize == 0 as well would fix
>> the problem. If not, there's something much more subtle going
>> on here that we should understand....
>
> If we make the vn_iowait() unconditional we might re-introduce the
> NFS exclusivity bug that killed performance.  That was through
> xfs_release()->xfs_free_eofblocks()->xfs_itruncate_start().

It won't reintroduce that problem because ->clear_inode()
is not called on every NFS write operation.

> So if we leave the above code as is then we need another
> vn_iowait() in xfs_inactive() to catch any remaining workqueue
> items that we didn't wait for in xfs_itruncate_start().

How do we have any new *data* I/O at all in progress at this point?
That does not explain why we need an additional vn_iowait() call.
All I see from this is a truncate race that has somethign to do with
the vn_iowait() call being conditional.

That is, if we truncate to zero, then the current code in
xfs_itruncate_start() should wait unconditinally for *all* I/O to
complete because, by definition, all that I/O is beyond the new EOF
and we have to wait for it to complete before truncating the file.
Seeing as we are in ->clear_inode(), no new data I/O can start
while we are deep in this code, hence we should not be seeing
I/O completions after the truncate starts and vn_iowait() has
completed.

Hence we need to know, firstly, if the truncate code has been
called; Secondly, what the value of i_size and i_new_size was when
the truncate was started and, finally, whether ip->i_iocount was
non-zero when the truncate was run.  That is, we need to gather
enough data to determine whether we should have waited in the
truncate but didn't.

If either the vn_iowait() in the truncate path is not sufficient, or
the truncate code is not being called, there is *some other bug*
that we don't yet understand.  Adding an unconditional vn_iowait()
appear to me to be fixing a symptom, not the underlying cause of
the problem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
