Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DABE47F54
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2015 01:12:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AD0688F8050
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2015 23:12:29 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id JhEGawskNQwzJB1G (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 19 Aug 2015 23:12:28 -0700 (PDT)
Date: Thu, 20 Aug 2015 14:12:24 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH block/for-linus] writeback: fix syncing of I_DIRTY_TIME
	inodes
Message-ID: <20150820061224.GG17933@dhcp-13-216.nay.redhat.com>
References: <20150812101204.GE17933@dhcp-13-216.nay.redhat.com>
	<20150813004435.GN3902@dastard>
	<20150813224415.GG4496@mtj.duckdns.org>
	<20150814111408.GB8710@quack.suse.cz>
	<20150817200254.GG21075@mtj.duckdns.org>
	<20150818091603.GA12317@quack.suse.cz>
	<20150818174718.GA15739@mtj.duckdns.org>
	<20150818195439.GB15739@mtj.duckdns.org>
	<20150818215611.GD3902@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150818215611.GD3902@dastard>
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
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, axboe@fb.com, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com

On Wed, Aug 19, 2015 at 07:56:11AM +1000, Dave Chinner wrote:
> On Tue, Aug 18, 2015 at 12:54:39PM -0700, Tejun Heo wrote:
> > Hello,
> > 
> > On Tue, Aug 18, 2015 at 10:47:18AM -0700, Tejun Heo wrote:
> > > Hmm... the only possibility I can think of is tot_write_bandwidth
> > > being zero when it shouldn't be.  I've been staring at the code for a
> > > while now but nothing rings a bell.  Time for another debug patch, I
> > > guess.
> > 
> > So, I can now reproduce the bug (it takes a lot of trials but lowering
> > the number of tested files helps quite a bit) and instrumented all the
> > early exit paths w/o the fix patch.  bdi_has_dirty_io() and
> > wb_has_dirty_io() are never out of sync with the actual dirty / io
> > lists even when the test 048 fails, so the bug at least is not caused
> > by writeback skipping due to buggy bdi/wb_has_dirty_io() result.
> > Whenever it skips, all the lists are actually empty (verified while
> > holding list_lock).
> > 
> > One suspicion I have is that this could be a subtle timing issue which
> > is being exposed by the new short-cut path.  Anything which adds delay
> > seems to make the issue go away.  Dave, does anything ring a bell?
> 
> No, it doesn't. The data writeback mechanisms XFS uses are all
> generic. It marks inodes I_DIRTY_PAGES and lets the generic code
> take care of everything else. Yes, we do delayed allocation during
> writeback, and we log the inode size updates during IO completion,
> so if inode sizes are not getting updated, then Occam's Razor
> suggests that writeback is not happening.
> 
> I'd suggest looking at some of the XFS tracepoints during the test:
> 
> tracepoint			trigger
> xfs_file_buffered_write		once per write syscall
> xfs_file_sync			once per fsync per inode
> xfs_vm_writepage		every ->writepage call
> xfs_setfilesize			every IO completion that updates inode size

I gave the tracepoints a try, but my root fs is xfs so I got many
noises. I'll try to install a new vm with ext4 as root fs. But I'm not
sure if the new vm could reproduce the failure, will see.

BTW, I guess xfs_vm_writepage should be xfs_writepage, and xfs_file_sync
should be xfs_file_fsync?

Thanks,
Eryu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
