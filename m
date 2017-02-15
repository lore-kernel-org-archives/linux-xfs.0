Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from special.m3.smtp.beget.ru ([5.101.158.90]:30595 "EHLO
        special.m3.smtp.beget.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750719AbdBOQwS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Feb 2017 11:52:18 -0500
Reply-To: apolyakov@beget.ru
Subject: Re: [Bug 192981] New: page allocation stalls
References: <bug-192981-27@https.bugzilla.kernel.org/>
 <20170123135111.13ac3e47110de10a4bd503ef@linux-foundation.org>
 <8f450abd-4e05-92d3-2533-72b05fea2012@beget.ru>
 <20170215160538.GA62565@bfoster.bfoster>
From: Alexander Polakov <apolyakov@beget.ru>
Message-ID: <a055abbf-a471-d111-9491-dc5b00208228@beget.ru>
Date: Wed, 15 Feb 2017 19:52:13 +0300
MIME-Version: 1.0
In-Reply-To: <20170215160538.GA62565@bfoster.bfoster>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-mm@kvack.org, linux-xfs@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org

On 02/15/2017 07:05 PM, Brian Foster wrote:
> You're in inode reclaim, blocked on a memory allocation for an inode
> buffer required to flush a dirty inode. I suppose this means that the
> backing buffer for the inode has already been reclaimed and must be
> re-read, which ideally wouldn't have occurred before the inode is
> flushed.
>
>> But it cannot get memory, because it's low (?). So it stays blocked.
>>
>> Other processes do the same but they can't get past the mutex in
>> xfs_reclaim_inodes_nr():
>>
> ...
>> Which finally leads to "Kernel panic - not syncing: Out of memory and no
>> killable processes..." as no process is able to proceed.
>>
>> I quickly hacked this:
>>
>> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
>> index 9ef152b..8adfb0a 100644
>> --- a/fs/xfs/xfs_icache.c
>> +++ b/fs/xfs/xfs_icache.c
>> @@ -1254,7 +1254,7 @@ struct xfs_inode *
>>         xfs_reclaim_work_queue(mp);
>>         xfs_ail_push_all(mp->m_ail);
>>
>> -       return xfs_reclaim_inodes_ag(mp, SYNC_TRYLOCK | SYNC_WAIT,
>> &nr_to_scan);
>> +       return 0; // xfs_reclaim_inodes_ag(mp, SYNC_TRYLOCK | SYNC_WAIT,
>> &nr_to_scan);
>>  }
>>
>
> So you've disabled inode reclaim completely...

I don't think this is correct. I disabled direct / kswapd reclaim.
XFS uses background worker for async reclaim:

http://lxr.free-electrons.com/source/fs/xfs/xfs_icache.c#L178
http://lxr.free-electrons.com/source/fs/xfs/xfs_super.c#L1534

Confirmed by running trace-cmd on a patched kernel:

# trace-cmd record -p function -l xfs_reclaim_inodes -l xfs_reclaim_worker
# # trace-cmd report
CPU 0 is empty
CPU 2 is empty
CPU 3 is empty
CPU 5 is empty
CPU 8 is empty
CPU 10 is empty
CPU 11 is empty
cpus=16
     kworker/12:2-31208 [012] 106450.590216: function: 
xfs_reclaim_worker
     kworker/12:2-31208 [012] 106450.590226: function: 
xfs_reclaim_inodes
     kworker/12:2-31208 [012] 106450.756879: function: 
xfs_reclaim_worker
     kworker/12:2-31208 [012] 106450.756882: function: 
xfs_reclaim_inodes
     kworker/12:2-31208 [012] 106450.920212: function: 
xfs_reclaim_worker
     kworker/12:2-31208 [012] 106450.920215: function: 
xfs_reclaim_inodes
     kworker/12:2-31208 [012] 106451.083549: function: 
xfs_reclaim_worker
     kworker/12:2-31208 [012] 106451.083552: function: 
xfs_reclaim_inodes
     kworker/12:2-31208 [012] 106451.246882: function: 
xfs_reclaim_worker
     kworker/12:2-31208 [012] 106451.246885: function: 
xfs_reclaim_inodes
     kworker/12:2-31208 [012] 106451.413546: function: 
xfs_reclaim_worker
     kworker/12:2-31208 [012] 106451.413548: function: 
xfs_reclaim_inodes
     kworker/12:2-31208 [012] 106451.580215: function: 
xfs_reclaim_worker
     kworker/12:2-31208 [012] 106451.580217: function: 
xfs_reclaim_inodes
     kworker/12:2-31208 [012] 106451.743549: function: 
xfs_reclaim_worker
     kworker/12:2-31208 [012] 106451.743550: function: 
xfs_reclaim_inodes
     kworker/12:2-31208 [012] 106451.906882: function: 
xfs_reclaim_worker
     kworker/12:2-31208 [012] 106451.906885: function: 
xfs_reclaim_inodes
     kworker/12:2-31208 [012] 106452.070216: function: 
xfs_reclaim_worker
     kworker/12:2-31208 [012] 106452.070219: function: 
xfs_reclaim_inodes
      kworker/7:0-14419 [007] 106454.730218: function: 
xfs_reclaim_worker
      kworker/7:0-14419 [007] 106454.730227: function: 
xfs_reclaim_inodes
      kworker/1:0-14025 [001] 106455.340221: function: 
xfs_reclaim_worker
      kworker/1:0-14025 [001] 106455.340225: function: 
xfs_reclaim_inodes

> The bz shows you have non-default vm settings such as
> 'vm.vfs_cache_pressure = 200.' My understanding is that prefers
> aggressive inode reclaim, yet the code workaround here is to bypass XFS
> inode reclaim. Out of curiousity, have you reproduced this problem using
> the default vfs_cache_pressure value (or if so, possibly moving it in
> the other direction)?

Yes, we've tried that, it had about 0 influence.

-- 
Alexander Polakov | system software engineer | https://beget.com
