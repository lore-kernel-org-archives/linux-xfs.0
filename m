Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q56HfjHZ246635 for <xfs@oss.sgi.com>; Wed, 6 Jun 2012 12:41:45 -0500
Message-ID: <4FCF9655.3070300@sgi.com>
Date: Wed, 06 Jun 2012 12:41:41 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: Still seeing hangs in xlog_grant_log_space
References: <CAH4wwdGWHSZoveLJMxu5pjr22NEEeW7oG8TS+snoM8RY=ZeRmg@mail.gmail.com>
	<CADLDEKsGtsw-rrSOE7gY4T81u+p41b34ixv0B7Dh07afJ73n2w@mail.gmail.com>
	<CAH4wwdFu7DEkHFZ5Bf7_PtLPsG0hUyUDoov03q=82R6t+QkERg@mail.gmail.com>
	<20120605235447.GF22848@dastard> <4FCF5DB9.2000808@redhat.com>
In-Reply-To: <4FCF5DB9.2000808@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On 06/06/12 08:40, Brian Foster wrote:

>
> Hi guys,
>
> I've been reproducing a similar stall in my testing of the 're-enable
> xfsaild idle mode' patch/thread that only occurs for me in the xfs tree.
> I was able to do a bisect from rc2 down to commit 43ff2122, though the
> history of this issue makes me wonder if this commit just makes the
> problem more reproducible as opposed to introducing it. Anyways, the
> characteristics I observe so far:
>
> - Task blocked for more than 120s message in xlog_grant_head_wait(). I
> see xfs_sync_worker() in my current bt, but I'm pretty sure I've seen
> the same issue without it involved.
> - The AIL is not empty/idle. It spins with a relatively small and
> constant number of entries (I've seen ~8-40). These items are all always
> marked as "flushing."
> - Via crash, all the inodes in the ail appear to be marked as stale
> (i.e. li_cb == xfs_istale_done). The inode flags are
> XFS_ISTALE|XFS_IRECLAIMABLE|XFS_IFLOCK.
> - The iflock in particular is why the ail marks these items 'flushing'
> and why nothing seems to proceed any further (xfsaild just waits for
> these to complete). I can kick the fs back into action with a 'sync.'
>
> It looks like we only mark in inode stale when an inode cluster is
> freed, so I repeated this test with 'ikeep' and cannot reproduce. I'm
> not sure if anybody is testing for this in recent kernels (Mark?), but
> if so I'd be curious if ikeep has any effect on your test (BTW, this is
> still the looping 273 xfstest).
>
> It seems like there could be some kind of race here with inodes being
> marked stale, but also appears that either completion (xfs_istale_done()
> or xfs_iflush_done()) should release the flush lock. I'll see if I can
> trace it further and get anything useful...
>
> Brian
>

I am looking at several instances of the log hang on Linux 3.4rc2.

The problem was originally reported on Linux 2.6.38-8.

The perl script to recreate this problem is very similar to xfstest 273.
I use that because it avoids all the filesystem mount/unmount that
happen between the test 273 loops. You can build the log size that you
want to test, create the directories and let it run until it hangs.

I will look at the AIL entries in my current hangs. The problem is the
filesystem can be made to hang with a completely empty AIL.

Sometimes the flusher is hung trying to write out pages. I will go and
see if this just happened to fire after a hang, or if the pages are
important.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
