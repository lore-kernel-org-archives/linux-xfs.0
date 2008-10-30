Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 29 Oct 2008 19:31:09 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9U2UuqO017836
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 19:30:57 -0700
Message-ID: <49091BFC.3000503@sgi.com>
Date: Thu, 30 Oct 2008 13:29:16 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: assertion failure with latest xfs
References: <49003EFF.4090404@sgi.com> <20081023173149.GA30316@infradead.org> <20081023222126.GA18495@disturbed> <4907B1B3.4020008@sgi.com> <20081029032941.GG4985@disturbed>
In-Reply-To: <20081029032941.GG4985@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Wed, Oct 29, 2008 at 11:43:31AM +1100, Lachlan McIlroy wrote:
>> Dave Chinner wrote:
>>> Hmmmm - there's also another bug in xfs_iget_cache_hit() - we don't
>>> drop the reference we got if we found an unlinked inode after the
>>> igrab() (the ENOENT case). I'll fix that as well.
>>>
>>> Patch below that I'm currently running through xfsqa.
>> I gave this patch a go and it still asserted at the same place running
>> the same test.
> 
> Can you put more inode trace points in so that we can see where the
> extra reference is coming from?

xfs_sync_inodes_ag() found the inode before it was completely
initialised.

--> itrace @ 0xffff880078d67800/0xffff880073563e40
ref @fs/xfs/xfs_inode.c:863(xfs_inode_alloc+0x205) i_count = 1
   cpu = 2 pid = 9938   ra = xfs_iread+0x29
exit from xfs_iget.alloc i_count = 1
   cpu = 2 pid = 9938   ra = xfs_trans_iget+0x205
ref @fs/xfs/xfs_iget.c:218(xfs_iget+0x585) i_count = 1
   cpu = 2 pid = 9938   ra = xfs_trans_iget+0x205
ref @fs/xfs/xfs_iget.c:305(xfs_iget+0x643) i_count = 1
   cpu = 2 pid = 9938   ra = xfs_trans_iget+0x205
ref @fs/xfs/linux-2.6/xfs_sync.c:113(xfs_sync_inodes_ag+0x118) i_count = 1
   cpu = 3 pid = 9953   ra = xfs_sync_inodes+0x68
ref @fs/xfs/linux-2.6/xfs_iops.c:780(xfs_setup_inode+0x2c) i_count = 2
   cpu = 2 pid = 9938   ra = xfs_ialloc+0x5d8
