Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Oct 2008 17:45:26 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9T0jDZE018338
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 17:45:14 -0700
Message-ID: <4907B1B3.4020008@sgi.com>
Date: Wed, 29 Oct 2008 11:43:31 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: assertion failure with latest xfs
References: <49003EFF.4090404@sgi.com> <20081023173149.GA30316@infradead.org> <20081023222126.GA18495@disturbed>
In-Reply-To: <20081023222126.GA18495@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, Lachlan McIlroy <lachlan@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Thu, Oct 23, 2008 at 01:31:49PM -0400, Christoph Hellwig wrote:
>> On Thu, Oct 23, 2008 at 07:08:15PM +1000, Lachlan McIlroy wrote:
>>> Just encountered this after pulling in the latest changes.  We are trying to
>>> initialise an inode that should have an i_count of 1 but instead it is 2.  I
>>> was running XFSQA test 167 when it happened.
>> I think the assert is incorrect.  The inode has been added to the radix
>> tree in xfs_iget_cache_miss, and starting from that point an igrab can
>> kick in from the sync code and bump the refcount.
> 
> Actually, it was put there for a reason. The generic code doesn't
> allow new inodes to be found in the cache until the I_LOCK flag is
> cleared. This is done by calling wait_on_inode() after a successful
> lookup (which waits on I_LOCK) and unlock_new_inode() clears the
> I_LOCK|I_NEW bits and wakes anyone who was waiting on that inode via
> wake_up_inode().  So the assert was put there to catch potential
> races in lookup where a second process does a successful igrab()
> before the inode is fully initialised.
> 
> I think the race is in dealing with cache hits and recycling a
> XFS_IRECLAIMABLE inode. We set the XFS_INEW flag there under
> the radix tree read lock, which means we can have parallel lookups
> on the same inode that goes:
> 
> 	thread 1				thread 2
> 	test XFS_INEW
> 		-> not set
> 	test XFS_IRECLAIMABLE
> 		-> set
> 						test XFS_INEW
> 							-> not set
> 	set XFS_INEW
> 	clear XFS_IRECLAIMABLE
> 						test XFS_IRECLAIMABLE
> 							-> not set
> 	xfs_setup_inode()
> 		-> i_state = I_NEW|I_LOCK
> 						igrab(inode)
> 							-> I_CLEAR not set
> 							-> refcount = 2
> 		-> inode_add_to_lists
> 		-> assert(refcount == 1)
> 		.....
> 		-> clear XFS_INEW
> 		-> unlock_new_inode()
> 			-> clear I_NEW|I_LOCK
> 
> I thought I'd handled this race with the ordering of setting/clearing
> XFS_INEW/XFS_IRECLAIMABLE. Clearly not. I'll add a comment to this
> ordering because it is key to actually detecting the race condition
> so we can handle it.
> 
> Hmmmm - there's also another bug in xfs_iget_cache_hit() - we don't
> drop the reference we got if we found an unlinked inode after the
> igrab() (the ENOENT case). I'll fix that as well.
> 
> Patch below that I'm currently running through xfsqa.

I gave this patch a go and it still asserted at the same place running
the same test.
