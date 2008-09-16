Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 15 Sep 2008 23:20:50 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8G6KmsT008202
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 23:20:48 -0700
Message-ID: <48CF5293.7000608@sgi.com>
Date: Tue, 16 Sep 2008 16:30:43 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] Re-dirty pages on I/O error
References: <48C8D8CD.7050508@sgi.com> <20080913041930.GC5811@disturbed> <48CDD4EE.8040105@sgi.com> <20080916040125.GN5811@disturbed>
In-Reply-To: <20080916040125.GN5811@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Mon, Sep 15, 2008 at 01:22:22PM +1000, Lachlan McIlroy wrote:
>> Dave Chinner wrote:
>>> So we keep dirty pages around that we can't write back?
>> Yes.
>>
>>> If we are in a low memory situation and the block device
>>> has gone bad, that will prevent memory reclaim from making
>>> progress.
>> How do you differentiate "gone bad" from temporarily unavailable?
> 
> The only "temporary" error you can get in writeback is a path
> failure. IIRC, XVM will give an ENODEV on a path failure, but
> I don't think that dm-multipath does. Other than that, a write
> failure is unrecoverable. Any other error is permanent....
> 
>>> i.e. if we have a bad disk, a user can now take down the system
>>> by running it out of clean memory....
>> I'm sure there's many ways a malicious user could already do that.
> 
> That's no excuse for introducing a new way of taking down the
> system when a disk fails. Error handling in linux is bad enough
> without intentionally preventing the system from recovering from
> I/O errors...
> 
>> Would you rather have data corruption?
> 
> Data corruption as a result of an I/O error? What else can we
> be expected to do? Log the error and continue onwards....
> 
> Face it - if the drive is dead then we can't write the data
> anywhere, so keeping it around and potentially killing the system
> completely makes even less sense.  At some point we *have to give
> up* on data we can't write back....
> 
>> We've allowed the write() to succeed.  We've accepted the data.
>> We have an obligation to write it do disk.  Either we keep trying
>> in the face of errors or we take down the filesystem.
> 
> It's write-behind buffering. We give best effort, not guaranteed
> writeback. If the system crashes, that data is lost. If we get an
> I/O error, that data is lost. If the application cares, it uses
> fsync and it gets the error and can handle it.
> 
> .....
> 
>> The EAGAIN case can be exceptioned.  The error we are getting here
>> is ENOSPC because xfs_trans_reserve() is failing. 
> 
> <sigh>
> 
> Please - put that detail in the patch description. I'm getting a
> little tired of having to draw out the reasons for your patches
> one little bit at a time.
I intentionally left out that detail because that's not what I'm trying
to fix here.  Discarding data arbitrarily is wrong and needs to be fixed
regardless of the error.  I've already mentioned what the cause of the
ENOSPC is earlier in this thread.

> 
> So: why is xfs_trans_reserve() failing? Aren't all the transactions
> in the writeback path marked as XFS_TRANS_RESERVE? That allows the
> transaction reserve to succeed when at ENOSPC by dipping into the
> reserved blocks. Did we run out of reserved blocks (i.e. the reserve
> pool is not big enough)? Or is there some other case that leads to
> ENOSPC in the writeback path that we've never considered before?

Yes, xfs_trans_reserve() is failing, it is marked XFS_TRANS_RESERVE
and we ran out of the reserved pool.  We've tried bumping the pool
from 1024 blocks to 16384 blocks and we can still cause it to fail
so we'll need to make the default even higher.  This ENOSPC error is
not necessarily a permanent error and in this case we shouldn't
discard the page.
