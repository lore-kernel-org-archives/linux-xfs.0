Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 21BA07F54
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 15:37:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 90B12AC005
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 13:37:20 -0700 (PDT)
Received: from mail-ig0-f170.google.com (mail-ig0-f170.google.com
	[209.85.213.170]) by cuda.sgi.com with ESMTP id
	YDctsiePTW5lF4ry (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Aug 2015 13:37:18 -0700 (PDT)
Received: by igcse8 with SMTP id se8so23399248igc.1
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 13:37:18 -0700 (PDT)
Subject: Re: [PATCH v2 block/for-linus] writeback: sync_inodes_sb() must write
	out I_DIRTY_TIME inodes and always call wait_sb_inodes()
References: <20150812101204.GE17933@dhcp-13-216.nay.redhat.com>
	<20150813004435.GN3902@dastard> <20150813224415.GG4496@mtj.duckdns.org>
	<20150825181152.GA26785@mtj.duckdns.org>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <55DCD1FD.6070809@kernel.dk>
Date: Tue, 25 Aug 2015 14:37:17 -0600
MIME-Version: 1.0
In-Reply-To: <20150825181152.GA26785@mtj.duckdns.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.com>
Cc: Eryu Guan <eguan@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, axboe@fb.com, linux-fsdevel@vger.kernel.org, kernel-team@fb.com

On 08/25/2015 12:11 PM, Tejun Heo wrote:
> e79729123f63 ("writeback: don't issue wb_writeback_work if clean")
> updated writeback path to avoid kicking writeback work items if there
> are no inodes to be written out; unfortunately, the avoidance logic
> was too aggressive and broke sync_inodes_sb().
>
> * sync_inodes_sb() must write out I_DIRTY_TIME inodes but I_DIRTY_TIME
>    inodes dont't contribute to bdi/wb_has_dirty_io() tests and were
>    being skipped over.
>
> * inodes are taken off wb->b_dirty/io/more_io lists after writeback
>    starts on them.  sync_inodes_sb() skipping wait_sb_inodes() when
>    bdi_has_dirty_io() breaks it by making it return while writebacks
>    are in-flight.
>
> This patch fixes the breakages by
>
> * Removing bdi_has_dirty_io() shortcut from bdi_split_work_to_wbs().
>    The callers are already testing the condition.
>
> * Removing bdi_has_dirty_io() shortcut from sync_inodes_sb() so that
>    it always calls into bdi_split_work_to_wbs() and wait_sb_inodes().
>
> * Making bdi_split_work_to_wbs() consider the b_dirty_time list for
>    WB_SYNC_ALL writebacks.
>
> Kudos to Eryu, Dave and Jan for tracking down the issue.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Fixes: e79729123f63 ("writeback: don't issue wb_writeback_work if clean")
> Link: http://lkml.kernel.org/g/20150812101204.GE17933@dhcp-13-216.nay.redhat.com
> Reported-and-bisected-by: Eryu Guan <eguan@redhat.com>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Jan Kara <jack@suse.com>
> Cc: Ted Ts'o <tytso@google.com>

Added for 4.2.

-- 
Jens Axboe

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
