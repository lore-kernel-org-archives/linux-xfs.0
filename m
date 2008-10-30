Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 29 Oct 2008 22:38:49 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9U5caCI001181
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 22:38:37 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5A2311B691D8
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 22:38:36 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id SL6biFrGbb52jAYF for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 22:38:36 -0700 (PDT)
Date: Thu, 30 Oct 2008 16:38:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: assertion failure with latest xfs
Message-ID: <20081030053833.GO17077@disturbed>
References: <49003EFF.4090404@sgi.com> <20081023173149.GA30316@infradead.org> <20081023222126.GA18495@disturbed> <4907B1B3.4020008@sgi.com> <20081029032941.GG4985@disturbed> <49091BFC.3000503@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49091BFC.3000503@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

On Thu, Oct 30, 2008 at 01:29:16PM +1100, Lachlan McIlroy wrote:
> Dave Chinner wrote:
>> On Wed, Oct 29, 2008 at 11:43:31AM +1100, Lachlan McIlroy wrote:
>>> Dave Chinner wrote:
>>>> Hmmmm - there's also another bug in xfs_iget_cache_hit() - we don't
>>>> drop the reference we got if we found an unlinked inode after the
>>>> igrab() (the ENOENT case). I'll fix that as well.
>>>>
>>>> Patch below that I'm currently running through xfsqa.
>>> I gave this patch a go and it still asserted at the same place running
>>> the same test.
>>
>> Can you put more inode trace points in so that we can see where the
>> extra reference is coming from?
>
> xfs_sync_inodes_ag() found the inode before it was completely
> initialised.
>
> --> itrace @ 0xffff880078d67800/0xffff880073563e40
> ref @fs/xfs/xfs_inode.c:863(xfs_inode_alloc+0x205) i_count = 1
>   cpu = 2 pid = 9938   ra = xfs_iread+0x29
> exit from xfs_iget.alloc i_count = 1
>   cpu = 2 pid = 9938   ra = xfs_trans_iget+0x205
> ref @fs/xfs/xfs_iget.c:218(xfs_iget+0x585) i_count = 1
>   cpu = 2 pid = 9938   ra = xfs_trans_iget+0x205
> ref @fs/xfs/xfs_iget.c:305(xfs_iget+0x643) i_count = 1
>   cpu = 2 pid = 9938   ra = xfs_trans_iget+0x205
> ref @fs/xfs/linux-2.6/xfs_sync.c:113(xfs_sync_inodes_ag+0x118) i_count = 1
>   cpu = 3 pid = 9953   ra = xfs_sync_inodes+0x68
> ref @fs/xfs/linux-2.6/xfs_iops.c:780(xfs_setup_inode+0x2c) i_count = 2
>   cpu = 2 pid = 9938   ra = xfs_ialloc+0x5d8

Ah - ok, that makes sense now. That should be trivial to fix up;
we just need to avoid XFS_INEW() inodes in xfs_sync_inodes_ag()
and probably also in xfs_qm_dqrele_all(), and that will mean
the assert needs to be removed as well.

Patch soon.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
