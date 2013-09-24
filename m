Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7033C7F3F
	for <xfs@oss.sgi.com>; Tue, 24 Sep 2013 12:14:49 -0500 (CDT)
Date: Tue, 24 Sep 2013 12:14:46 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 5/5] xfs: log recovery lsn ordering needs uuid check
Message-ID: <20130924171446.GG1935@sgi.com>
References: <1380002476-18839-1-git-send-email-david@fromorbit.com>
	<1380002476-18839-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1380002476-18839-6-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 24, 2013 at 04:01:16PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> After a fair number of xfstests runs, xfs/182 started to fail
> regularly with a corrupted directory - a directory read verifier was
> failing after recovery because it found a block with a XARM magic
> number (remote attribute block) rather than a directory data block.
> 
> The first time I saw this repeated failure I did /something/ and the
> problem went away, so I was never able to find the underlying
> problem. Test xfs/182 failed again today, and I found the root
> cause before I did /something else/ that made it go away.
> 
> Tracing indicated that the block in question was being correctly
> logged, the log was being flushed by sync, but the buffer was not
> being written back before the shutdown occurred. Tracing also
> indicated that log recovery was also reading the block, but then
> never writing it before log recovery invalidated the cache,
> indicating that it was not modified by log recovery.
> 
> More detailed analysis of the corpse indicated that the filesystem
> had a uuid of "a4131074-1872-4cac-9323-2229adbcb886" but the XARM
> block had a uuid of "8f32f043-c3c9-e7f8-f947-4e7f989c05d3", which
> indicated it was a block from an older filesystem. The reason that
> log recovery didn't replay it was that the LSN in the XARM block was
> larger than the LSN of the transaction being replayed, and so the
> block was not overwritten by log recovery.
> 
> Hence, log recovery cant blindly trust the magic number and LSN in
> the block - it must verify that it belongs to the filesystem being
> recovered before using the LSN. i.e. if the UUIDs don't match, we
> need to unconditionally recovery the change held in the log.
			  recover
 
> This patch was first tested on a block device that was repeatedly
> causing xfs/182 to fail with the same failure on the same block with
> the same directory read corruption signature (i.e. XARM block). It
> did not fail, and hasn't failed since.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good to me.
Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
