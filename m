Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Aug 2008 19:21:15 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m762LAmv005245
	for <xfs@oss.sgi.com>; Tue, 5 Aug 2008 19:21:11 -0700
Message-ID: <48990C4E.9070102@sgi.com>
Date: Wed, 06 Aug 2008 12:28:30 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] Move vn_iowait() earlier in the reclaim path
References: <4897F691.6010806@sgi.com> <20080805073711.GA21635@disturbed> <489806C2.7020200@sgi.com> <20080805084220.GF21635@disturbed>
In-Reply-To: <20080805084220.GF21635@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, xfs@oss.sgi.com, xfs-dev <xfs-dev@sgi.com>

Dave Chinner wrote:
> On Tue, Aug 05, 2008 at 05:52:34PM +1000, Lachlan McIlroy wrote:
>> Dave Chinner wrote:
>>> On Tue, Aug 05, 2008 at 04:43:29PM +1000, Lachlan McIlroy wrote:
>>>> Currently by the time we get to vn_iowait() in xfs_reclaim() we have already
>>>> gone through xfs_inactive()/xfs_free() and recycled the inode.  Any I/O
>>> xfs_free()? What's that?
>> Sorry that should have been xfs_ifree() (we set the inode's mode to
>> zero in there).
>>
>>>> completions still running (file size updates and unwritten extent conversions)
>>>> may be working on an inode that is no longer valid.
>>> The linux inode does not get freed until after ->clear_inode
>>> completes, hence it is perfectly valid to reference it anywhere
>>> in the ->clear_inode path.
>> The problem I see is an assert in xfs_setfilesize() fail:
>>
>> 	ASSERT((ip->i_d.di_mode & S_IFMT) == S_IFREG);
>>
>> The mode of the XFS inode is zero at this time.
> 
> Ok, so the question has to be why is there I/O still in progress
> after the truncate is supposed to have already occurred and the
> vn_iowait() in xfs_itruncate_start() been executed.
> 
> Something doesn't add up here - you can't be doing I/O on a file
> with no extents or delalloc blocks, hence that means we should be
> passing through the truncate path in xfs_inactive() before we
> call xfs_ifree() and therefore doing the vn_iowait()..
> 
> Hmmmm - the vn_iowait() is conditional based on:
> 
>         /* wait for the completion of any pending DIOs */
>         if (new_size < ip->i_size)
>                 vn_iowait(ip);
> 
> We are truncating to zero (new_size == 0), so the only case where
> this would not wait is if ip->i_size == 0. Still - I can't see
> how we'd be doing I/O on an inode with a zero i_size. I suspect
> ensuring we call vn_iowait() if newsize == 0 as well would fix
> the problem. If not, there's something much more subtle going
> on here that we should understand....

If we make the vn_iowait() unconditional we might re-introduce the
NFS exclusivity bug that killed performance.  That was through
xfs_release()->xfs_free_eofblocks()->xfs_itruncate_start().
So if we leave the above code as is then we need another
vn_iowait() in xfs_inactive() to catch any remaining workqueue
items that we didn't wait for in xfs_itruncate_start().

In that case the last call to vn_iowait() should be inside
xfs_inactive() after the truncate but before the call to
xfs_ifree().
