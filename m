Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Oct 2008 22:38:56 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9O5cI5Q009557
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 22:38:20 -0700
From: Niv Sardi <xaiki@sgi.com>
Subject: Re: [PATCH, RFC] Re: atime not written to disk
References: <48FD74CC.907@sgi.com> <48FD7B69.3090600@wm.jp.nec.com>
	<20081022081710.GL18495@disturbed>
	<ncctzb4nhss.fsf@itchy.melbourne.sgi.com>
	<20081023042053.GY18495@disturbed>
Date: Fri, 24 Oct 2008 16:37:59 +1100
In-Reply-To: <20081023042053.GY18495@disturbed> (Dave Chinner's message of
	"Thu, 23 Oct 2008 15:20:53 +1100")
Message-ID: <nccmygumu2w.fsf@itchy.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Utako Kusaka <u-kusaka@wm.jp.nec.com>
Cc: Timothy Shimmin <tes@sgi.com>, xfs <xfs@oss.sgi.com>

Dave Chinner <david@fromorbit.com> writes:

> On Thu, Oct 23, 2008 at 01:53:23PM +1100, Niv Sardi wrote:
>> Dave Chinner <david@fromorbit.com> writes:
>> [...]
>> > As I mentioned on IRC, Tim, the following patch fixes the above test
>> > case. It will make XFS behave like other filesystems w.r.t. atime,
>> > instead of defaulting to relatime-like behaviour. This will have
>> > performance impact unless ppl now add the relatime mount option.
>>  ^^^^^^^^^^^^^^^^^^^
>> 
>> I don't really like it, and don't think there is a real justification to
>> do it.
>
> You probably missed the context of that patch (which I mentioned on
> IRC to Tim).

Thank you for the refresh.

> That was that it is part of a larger patch set that tracks dirty state
> in the XFS inode radix tree. In that case, the ->dirty_inode callout
> is used to set a tag in the per-ag inode radix tree. I want to
> do it this way so there is a single place that the dirty tag
> is set, whether it is due to an unlogged change (XFS or VFS) or
> a transaction commit....

So, to refrase, you have a patchset, that will use that callback better,
and then we will not need the patch you actually sent ? why not wait for
that patchset, this is not exactly a critical bug…

> Also, if you read the referenced thread, Christoph made the comment
> that the VFS was not letting us know that the inode had been dirtied and
> that we really needed to know about that.  The patch I sent isn't
> intended to do this, not as a fix for atime updates...

>> Why not only do:
[…]
> This doesn't avoid the performance problem - it simply shifts it to
> the reclaim code.  Think about it - you traverse a million inodes
> stat()ing them all (the nightly backup). Instead of having the now
> dirty inodes written back as you go along, you wait until memory
> reclaim turfs them out to mark them dirty and then write them back.
> This means memory reclaim goes *much slower* because reclaiming the
> memory now has to wait for I/O to complete.

yep, I just read the code, do we have a way to know that we are
unmounting ? maybe the good way to do it is to only write atime on
unmount ? the call trace is:

 [xfs]xfs_fs_clear_inode+0xd4
 clear_inode+0x7d
 dispose_list+0x5b
 invalidate_inodes+0xe0
 generic_shutdown_super+0x3a
 kill_block_super+0x15
 deactivate_super+0x62
 mntput_no_expire+0xe9
 sys_umount+0x2d1

So it doesn't look obvious to me, but sure there is a way to know if
we're in umount right ?

I'm concerned about the overhead, with your patch, that we'll be
writting things even if nothing has changed, not sure about how many
times ->dirty_inodes is called and such. I don't like the idea to slow
things down for everyone or force people to use realtime

Cheers,
-- 
Niv Sardi
