Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3618E7F84
	for <linux-xfs@oss.sgi.com>; Tue, 12 Feb 2013 00:56:08 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 091F48F8035
	for <linux-xfs@oss.sgi.com>; Mon, 11 Feb 2013 22:56:07 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	cBTS43PLSQTM4lAo for <linux-xfs@oss.sgi.com>;
	Mon, 11 Feb 2013 22:56:06 -0800 (PST)
Date: Tue, 12 Feb 2013 17:55:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Hung in D state during fclose
Message-ID: <20130212065545.GC10731@dastard>
References: <loom.20130212T071115-446@post.gmane.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <loom.20130212T071115-446@post.gmane.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Norman Cheung <norman.cheung@kla-tencor.com>
Cc: linux-xfs@oss.sgi.com

On Tue, Feb 12, 2013 at 06:17:04AM +0000, Norman Cheung wrote:
> I am not sure if this forum is the same as xfs@oss.sgi.com, if so, my apology 
> for double posting.  I appreciate in sight or work around on this.
> 
> Every 3 - 4 days, my application will hang in D state at file close.  And 
> shortly after that flush (from a different partition) is locked in D state 
> also.  
> 
> My application runs continuously, 5 threads are writing data at a rate of 
> 1.5M/sec to 5 different XFS partitions.  Each of these partitions is a 2 disk 
> RAID 0. In addition, I have other threads consuming 100% CPU at all time, and 
> most of these threads are tied to its own CPU.
> 
> There are 5 data writing threads are also set to run in specific CPU (one CPU  
> per  thread), with priority set to high (-2).  The data writing pattern is: 
> each disk writing thread will write a file  1.5 Gig. Then the thread will 
> pause for about 3 minutes. Hence we have 5 files of 1.5Gig each after one 
> processing cycle.  And we keep 5 sets and delete the older ones.
> 
> After about 300 - 800 cycle, one or two of these disk writing threads will go 
> into D state.  And within a second flush of another partition will show up in 
> D state.  then after 15 minutes of no activities, the parent task will lower 
> the priority of all threads (to noraml 20) and abort the threads.  In all 
> cases, lowering the priority will get threads out of D states.  I have also 
> tried running the disk writing threads with normal priority (20).  Same 
> hangs.  Also the fclose of all 5 files to 5 different partitions happens 
> around the same time.
> 
> Thanks in advance,
> 
> Norman 
> 
> 
> Below is the sysrq for the 2 offending threads.
> 
> 1. the disk writing thread hung in fclose
> 
> 
> Tigris_IMC.exe  D 0000000000000000     0  4197   4100 0x00000000
> ffff881f3db921c0 0000000000000086 0000000000000000 ffff881f42eb8b80
> ffff880861419fd8 ffff880861419fd8 ffff880861419fd8 ffff881f3db921c0
> 0000000000080000 0000000000000000 00000000000401e0 00000000061805c1 Call Trace:
> [<ffffffff810d89ed>] ? zone_statistics+0x9d/0xa0 [<ffffffffa0402682>] ? 
> xfs_iomap_write_delay+0x172/0x2b0 [xfs] [<ffffffff813c7e35>] ? 
> rwsem_down_failed_common+0xc5/0x150
> [<ffffffff811f32a3>] ? call_rwsem_down_write_failed+0x13/0x20
> [<ffffffff813c74ec>] ? down_write+0x1c/0x1d [<ffffffffa03fba8e>] ? 
> xfs_ilock+0x7e/0xa0 [xfs] [<ffffffffa041b64b>] ? __xfs_get_blocks+0x1db/0x3d0 
> [xfs] [<ffffffff81103340>] ? kmem_cache_alloc+0x100/0x130 
> [<ffffffff8113fa2e>] ? alloc_page_buffers+0x6e/0xe0 [<ffffffff81141cdf>] ? 
> __block_write_begin+0x1cf/0x4d0 [<ffffffffa041b850>] ? 
> xfs_get_blocks_direct+0x10/0x10 [xfs] [<ffffffffa041b850>] ? 
> xfs_get_blocks_direct+0x10/0x10 [xfs] [<ffffffff8114226b>] ? 
> block_write_begin+0x4b/0xa0 [<ffffffffa041b8fb>] ? 
> xfs_vm_write_begin+0x3b/0x70 [xfs] [<ffffffff810c0258>] ? 
> generic_file_buffered_write+0xf8/0x250
> [<ffffffffa04207b5>] ? xfs_file_buffered_aio_write+0xc5/0x130 [xfs] 
> [<ffffffffa042099c>] ? xfs_file_aio_write+0x17c/0x2a0 [xfs] 
> [<ffffffff81115b28>] ? do_sync_write+0xb8/0xf0 [<ffffffff8119daa4>] ? 
> security_file_permission+0x24/0xc0
> [<ffffffff8111630a>] ? vfs_write+0xaa/0x190 [<ffffffff81116657>] ? 
> sys_write+0x47/0x90 [<ffffffff813ce412>] ? system_call_fastpath+0x16/0x1b

Can you please post non-mangled traces? these have all the lines run
together and then wrapped by you mailer....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
