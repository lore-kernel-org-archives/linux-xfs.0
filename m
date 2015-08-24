Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D43F77F37
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 09:51:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 76435AC005
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 07:51:55 -0700 (PDT)
Received: from mail-qk0-f170.google.com (mail-qk0-f170.google.com
	[209.85.220.170]) by cuda.sgi.com with ESMTP id
	TN8prRKLwjZh81xB (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Aug 2015 07:51:54 -0700 (PDT)
Received: by qkbm65 with SMTP id m65so69484121qkb.2
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 07:51:53 -0700 (PDT)
Date: Mon, 24 Aug 2015 10:51:50 -0400
From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH block/for-linus] writeback: fix syncing of I_DIRTY_TIME
	inodes
Message-ID: <20150824145150.GA10029@mtj.duckdns.org>
References: <20150818174718.GA15739@mtj.duckdns.org>
	<20150818195439.GB15739@mtj.duckdns.org>
	<20150818215611.GD3902@dastard>
	<20150821102053.GL17933@dhcp-13-216.nay.redhat.com>
	<20150822003025.GS3902@dastard>
	<20150822044609.GM17933@dhcp-13-216.nay.redhat.com>
	<20150824011123.GA714@dastard>
	<20150824031816.GO17933@dhcp-13-216.nay.redhat.com>
	<20150824062425.GU3902@dastard>
	<20150824091959.GA2936@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150824091959.GA2936@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>, Eryu Guan <eguan@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, axboe@fb.com, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, kernel-team@fb.com

Hello, Jan.

On Mon, Aug 24, 2015 at 11:19:59AM +0200, Jan Kara wrote:
> > which shows unmount being the next writeback event queued and
> > executed after the IO completions have come in (that missed the
> > log). What is missing is the specific queue/exec events for
> > sync_sb_inodes() from the sync code for each filesystem.
> 
> Bah, I see the problem and indeed it was introduced by commit e79729123f639
> "writeback: don't issue wb_writeback_work if clean". The problem is that
> we bail out of sync_inodes_sb() if there is no dirty IO. Which is wrong
> because we have to wait for any outstanding IO (i.e. call wait_sb_inodes())
> regardless of dirty state! And that also explains why Tejun's patch fixes
> the problem because it backs out the change to the exit condition in
> sync_inodes_sb().

Dang, I'm an idiot sandwich.

> So Tejun's patch from this thread is indeed fixing the real problem but the
> comment in sync_inodes_sb() should be fixed to mention wait_sb_inodes()
> must be called in all cases... Tejun, will you fixup the comment please?

Will post an updated patch.  Kudos to Eryu and Dave for chasing it
down.

Thanks a lot.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
