Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EEEE27F5D
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2015 16:56:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D13888F8040
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2015 14:56:19 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	mXLTSNkyzxBR7AIH for <xfs@oss.sgi.com>;
	Tue, 18 Aug 2015 14:56:17 -0700 (PDT)
Date: Wed, 19 Aug 2015 07:56:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH block/for-linus] writeback: fix syncing of I_DIRTY_TIME
	inodes
Message-ID: <20150818215611.GD3902@dastard>
References: <20150812101204.GE17933@dhcp-13-216.nay.redhat.com>
	<20150813004435.GN3902@dastard>
	<20150813224415.GG4496@mtj.duckdns.org>
	<20150814111408.GB8710@quack.suse.cz>
	<20150817200254.GG21075@mtj.duckdns.org>
	<20150818091603.GA12317@quack.suse.cz>
	<20150818174718.GA15739@mtj.duckdns.org>
	<20150818195439.GB15739@mtj.duckdns.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150818195439.GB15739@mtj.duckdns.org>
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
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>, Eryu Guan <eguan@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, axboe@fb.com, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, kernel-team@fb.com

On Tue, Aug 18, 2015 at 12:54:39PM -0700, Tejun Heo wrote:
> Hello,
> 
> On Tue, Aug 18, 2015 at 10:47:18AM -0700, Tejun Heo wrote:
> > Hmm... the only possibility I can think of is tot_write_bandwidth
> > being zero when it shouldn't be.  I've been staring at the code for a
> > while now but nothing rings a bell.  Time for another debug patch, I
> > guess.
> 
> So, I can now reproduce the bug (it takes a lot of trials but lowering
> the number of tested files helps quite a bit) and instrumented all the
> early exit paths w/o the fix patch.  bdi_has_dirty_io() and
> wb_has_dirty_io() are never out of sync with the actual dirty / io
> lists even when the test 048 fails, so the bug at least is not caused
> by writeback skipping due to buggy bdi/wb_has_dirty_io() result.
> Whenever it skips, all the lists are actually empty (verified while
> holding list_lock).
> 
> One suspicion I have is that this could be a subtle timing issue which
> is being exposed by the new short-cut path.  Anything which adds delay
> seems to make the issue go away.  Dave, does anything ring a bell?

No, it doesn't. The data writeback mechanisms XFS uses are all
generic. It marks inodes I_DIRTY_PAGES and lets the generic code
take care of everything else. Yes, we do delayed allocation during
writeback, and we log the inode size updates during IO completion,
so if inode sizes are not getting updated, then Occam's Razor
suggests that writeback is not happening.

I'd suggest looking at some of the XFS tracepoints during the test:

tracepoint			trigger
xfs_file_buffered_write		once per write syscall
xfs_file_sync			once per fsync per inode
xfs_vm_writepage		every ->writepage call
xfs_setfilesize			every IO completion that updates inode size

And it's probably best to also include all the writeback
tracepoints, too, for context. That will tell you what inodes and
what part of them are getting written back and when....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
