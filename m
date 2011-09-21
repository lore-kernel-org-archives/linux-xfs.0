Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8LBgswk138499 for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 06:42:54 -0500
Date: Wed, 21 Sep 2011 21:42:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [xfs-masters] xfs deadlock in stable kernel 3.0.4
Message-ID: <20110921114237.GP15688@dastard>
References: <4E75B660.1030502@profihost.ag> <20110918230245.GF15688@dastard>
	<4E78665E.8030409@profihost.ag>
	<20110920160226.GA25542@infradead.org>
	<4E78CBF4.1030505@profihost.ag>
	<20110920172455.GA30757@infradead.org>
	<4E78CEFD.9030603@profihost.ag>
	<20110920223047.GA13758@infradead.org>
	<20110921021133.GM15688@dastard> <4E7994D3.5020103@profihost.ag>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E7994D3.5020103@profihost.ag>
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
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: Christoph Hellwig <hch@infradead.org>, "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Sep 21, 2011 at 09:40:03AM +0200, Stefan Priebe - Profihost AG wrote:
> Am 21.09.2011 04:11, schrieb Dave Chinner:
> >Also, what phase do you see it hanging in? the random stat phase is
> >terribly slow on spinning disks, so if I can avoid that it woul dbe
> >nice....
> Creating or deleting files. never in the stat phase.

Ok, I got a hang in the random delete phase. Not sure what is wrong
yet, but inode reclaim is trying to reclaim inodes but failing, and
the AIL is trying to push items but failing. Hence the tail of the
log is not being moved forward and new transactions are being
blocked until log space bcomes available.

The AIl is particularly interesting. the number of pushes being
executed is precisely 50/s, and precisely 5000 items/s are being
scanned. All those items are pinned, so the "stuck" processing is
what is triggering this pattern.

Thing is, all the items are aparently pinned - I see that stat
incrementing at 5,000/s. It's here:

                case XFS_ITEM_PINNED:
                        XFS_STATS_INC(xs_push_ail_pinned);
                        stuck++;
                        flush_log = 1;
                        break;

so we should have the flush_log variable set. However, this code:

        if (flush_log) {
                /*
                 * If something we need to push out was pinned, then
                 * push out the log so it will become unpinned and
                 * move forward in the AIL.
                 */
                XFS_STATS_INC(xs_push_ail_flush);
                xfs_log_force(mp, 0);
        }

never seems to execute. I don't see the xs_push_ail_flush stat
increase, nor the log force counter increase, either. Hence the
pinned items are not getting unpinned, and progress is not being
made. Background inode reclaim is not making progress, either,
because it skips pinned inodes.

The AIL code is clearly cycling - the push counter is increasing,
and the run numbers match the stuck code precisely (aborts at 100
stuck items a cycle). The question is now why isn't the log force
being triggered.

Given this, just triggering a log force is shoul dget everything
moving again. Running "echo 2 > /proc/sys/vm/drop_caches" gets inode
reclaim running in sync mode, which causes pinned inodes to trigger
a log force. And once I've done this, everything starts running
again.

So, the log force not triggering in the AIL code looks to be the
problem. That, I simply cannot explain right now - it makes no sense
but that is what all the stats and trace events point to. I need to
do more investigation.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
