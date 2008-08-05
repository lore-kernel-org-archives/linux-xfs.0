Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Aug 2008 00:45:24 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m757jBaV015389
	for <xfs@oss.sgi.com>; Tue, 5 Aug 2008 00:45:11 -0700
Message-ID: <489806C2.7020200@sgi.com>
Date: Tue, 05 Aug 2008 17:52:34 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] Move vn_iowait() earlier in the reclaim path
References: <4897F691.6010806@sgi.com> <20080805073711.GA21635@disturbed>
In-Reply-To: <20080805073711.GA21635@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, xfs@oss.sgi.com, xfs-dev <xfs-dev@sgi.com>

Dave Chinner wrote:
> On Tue, Aug 05, 2008 at 04:43:29PM +1000, Lachlan McIlroy wrote:
>> Currently by the time we get to vn_iowait() in xfs_reclaim() we have already
>> gone through xfs_inactive()/xfs_free() and recycled the inode.  Any I/O
> 
> xfs_free()? What's that?
Sorry that should have been xfs_ifree() (we set the inode's mode to
zero in there).

> 
>> completions still running (file size updates and unwritten extent conversions)
>> may be working on an inode that is no longer valid.
> 
> The linux inode does not get freed until after ->clear_inode
> completes, hence it is perfectly valid to reference it anywhere
> in the ->clear_inode path.
The problem I see is an assert in xfs_setfilesize() fail:

	ASSERT((ip->i_d.di_mode & S_IFMT) == S_IFREG);

The mode of the XFS inode is zero at this time.

> 
> My bet is that you are seeing I/O completion mark an inode dirty
> that is being freed. ie.  Calling mark_inode_dirty_sync() in the I/O
> completion blindly assumes that the linux inode is still valid, 
> when it may be in the 'being freed' path. e.g. we can put it back on the
> superblock dirty list just before it gets freed for real...
> 
> I came across this about a week ago when tracking down a QA failure
> with a combined linux/XFS inode patch. The fix is to make I/O
> completion call xfs_mark_inode_dirty_sync() so we check that this
> linux inode not in the process of being freed before we try to
> mark it dirty.
> 
> Cheers,
> 
> Dave.
