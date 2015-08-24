Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6C0A87F37
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 13:10:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 44BAB304032
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 11:10:46 -0700 (PDT)
Received: from mail-qk0-f178.google.com (mail-qk0-f178.google.com
	[209.85.220.178]) by cuda.sgi.com with ESMTP id
	rbqxGgubx153uGiU (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Aug 2015 11:10:41 -0700 (PDT)
Received: by qkbm65 with SMTP id m65so79689249qkb.2
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 11:10:41 -0700 (PDT)
Date: Mon, 24 Aug 2015 14:10:38 -0400
From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH block/for-linus] writeback: fix syncing of I_DIRTY_TIME
	inodes
Message-ID: <20150824181038.GA28944@mtj.duckdns.org>
References: <20150817200254.GG21075@mtj.duckdns.org>
	<20150818091603.GA12317@quack.suse.cz>
	<20150818174718.GA15739@mtj.duckdns.org>
	<20150818195439.GB15739@mtj.duckdns.org>
	<20150818215611.GD3902@dastard>
	<20150820061224.GG17933@dhcp-13-216.nay.redhat.com>
	<20150820143626.GI17933@dhcp-13-216.nay.redhat.com>
	<20150820143735.GJ17933@dhcp-13-216.nay.redhat.com>
	<20150820165537.GA2044@mtj.duckdns.org>
	<20150820230451.GT714@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150820230451.GT714@dastard>
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
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>, Eryu Guan <eguan@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, axboe@fb.com, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, kernel-team@fb.com

Hello, Dave.

On Fri, Aug 21, 2015 at 09:04:51AM +1000, Dave Chinner wrote:
> > Maybe I'm misunderstanding the code but all xfs_writepage() calls are
> > from unbound workqueues - the writeback workers - while
> > xfs_setfilesize() are from bound workqueues, so I wondered why that
> > was and looked at the code and the setsize functions are run off of a
> > separate work item which is queued from the end_bio callback and I
> > can't tell who would be waiting for them.  Dave, what am I missing?
> 
> xfs_setfilesize runs transactions, so it can't be run from IO
> completion context as it needs to block (i.e. on log space or inode
> locks). It also can't block log IO completion, nor metadata Io
> completion, as only log IO completion can free log space, and the
> inode lock might be waiting on metadata buffer IO completion (e.g.
> during delayed allocation). Hence we have multiple IO completion
> workqueues to keep these things separated and deadlock free. i.e.
> they all get punted to a workqueue where they are then processed in
> a context that can block safely.

I'm still a bit confused.  What prevents the following from happening?

1. io completion of last dirty page of an inode and work item for
   xfs_setfilesize() is queued.

2. inode removed from dirty list.

3. __sync_filesystem() invokes sync_inodes_sb().  There are no dirty
   pages, so it finishes.

4. xfs_fs_sync_fs() is called which calls _xfs_log_force() but the
   work item from #1 hasn't run yet, so the size update isn't written
   out.

5. Crash.

Is it that _xfs_log_force() waits for the setfilesize transaction
created during writepage?

Thanks.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
