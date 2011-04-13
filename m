Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3DKW5FU211750 for <xfs@oss.sgi.com>; Wed, 13 Apr 2011 15:32:05 -0500
Subject: Re: [PATCH 2/2] xfs: kick inode writeback when low on memory
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1302157196-1988-3-git-send-email-david@fromorbit.com>
References: <1302157196-1988-1-git-send-email-david@fromorbit.com>
	<1302157196-1988-3-git-send-email-david@fromorbit.com>
Date: Wed, 13 Apr 2011 15:33:42 -0500
Message-ID: <1302726822.2023.128.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Thu, 2011-04-07 at 16:19 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When the inode cache shrinker runs, we may have lots of dirty inodes queued up
> in the VFS dirty queues that have not been expired. The typical case for this
> with XFS is atime updates. The result is that a highly concurrent workload that
> copies files and then later reads them (say to verify checksums) dirties all
> the inodes again, even when relatime is used.
> 
> In a constrained memory environment, this results in a large number of dirty
> inodes using all of available memory and memory reclaim being unable to free
> them as dirty inodes areconsidered active. This problem was uncovered by Chris
> Mason during recent low memory stress testing.
> 
> The fix is to trigger VFS level writeback from the XFS inode cache shrinker if
> there isn't already writeback in progress. This ensures that when we enter a
> low memory situation we start cleaning inodes (via the flusher thread) on the
> filesystem immediately, thereby making it more likely that we will be able to
> evict those dirty inodes from the VFS in the near future.
> 
> The mechanism is not perfect - it only acts on the current filesystem, so if
> all the dirty inodes are on a different filesystem it won't help. However, it
> seems to be a valid assumption is that the filesystem with lots of dirty inodes
> is going to have the shrinker called very soon after the memory shortage
> begins, so this shouldn't be an issue.
> 
> The other flaw is that there is no guarantee that the flusher thread will make
> progress fast enough to clean the dirty inodes so they can be reclaimed in the
> near future. However, this mechanism does improve the resilience of the
> filesystem under the test conditions - instead of reliably triggering the OOM
> killer 20 minutes into the stress test, it took more than 6 hours before it
> happened.
> 
> This small addition definitely improves the low memory resilience of XFS on
> this type of workload, and best of all it has no impact on performance when
> memory is not constrained.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good to me.

Reviewed-by: Alex Elder <aelder@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
