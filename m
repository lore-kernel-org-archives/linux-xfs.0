Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAJNp4gi070748 for <xfs@oss.sgi.com>; Mon, 19 Nov 2012 17:51:04 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	74CGdNNLZXfNNTcS for <xfs@oss.sgi.com>;
	Mon, 19 Nov 2012 15:53:11 -0800 (PST)
Date: Tue, 20 Nov 2012 10:53:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Hang in XFS reclaim on 3.7.0-rc3
Message-ID: <20121119235306.GX14281@dastard>
References: <CAPVoSvSM9=hictqwT2rzZA-fU_XSwd-_FRzW_J+HQYj7iohTWQ@mail.gmail.com>
	<20121029222613.GU29378@dastard>
	<CAPVoSvQATjAVu-D477mrr6K9d0FeY7sH27cH-zNBYMJcRoUY0Q@mail.gmail.com>
	<CAPVoSvRks32ZM7n6U8but-vEj622TEFqAFdxXqS_6mRxyv=0Ew@mail.gmail.com>
	<CAPVoSvSKn2FuBhMF+3U1ueuEzBqL4CFTYFGXqGczTa42PgMjRw@mail.gmail.com>
	<20121118235105.GT14281@dastard>
	<CAPVoSvR+Gk6ggSZ6=ZMpyvwhosjd4BSGsUqRT=txkzGDGLMTPw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPVoSvR+Gk6ggSZ6=ZMpyvwhosjd4BSGsUqRT=txkzGDGLMTPw@mail.gmail.com>
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
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Mon, Nov 19, 2012 at 07:50:06AM +0100, Torsten Kaiser wrote:
> On Mon, Nov 19, 2012 at 12:51 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Sun, Nov 18, 2012 at 04:29:22PM +0100, Torsten Kaiser wrote:
> >> On Sun, Nov 18, 2012 at 11:24 AM, Torsten Kaiser
> >> <just.for.lkml@googlemail.com> wrote:
> >> > On Tue, Oct 30, 2012 at 9:37 PM, Torsten Kaiser
> >> > <just.for.lkml@googlemail.com> wrote:
> >> >> I will keep LOCKDEP enabled on that system, and if there really is
> >> >> another splat, I will report back here. But I rather doubt that this
> >> >> will be needed.
> >> >
> >> > After the patch, I did not see this problem again, but today I found
> >> > another LOCKDEP report that also looks XFS related.
> >> > I found it twice in the logs, and as both were slightly different, I
> >> > will attach both versions.
> >>
> >> > Nov  6 21:57:09 thoregon kernel: [ 9941.104353] 3.7.0-rc4 #1 Not tainted
> >> > Nov  6 21:57:09 thoregon kernel: [ 9941.104355] inconsistent
> >> > {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
> >> > Nov  6 21:57:09 thoregon kernel: [ 9941.104430]        CPU0
> >> > Nov  6 21:57:09 thoregon kernel: [ 9941.104431]        ----
> >> > Nov  6 21:57:09 thoregon kernel: [ 9941.104432]   lock(&(&ip->i_lock)->mr_lock);
> >> > Nov  6 21:57:09 thoregon kernel: [ 9941.104433]   <Interrupt>
> >> > Nov  6 21:57:09 thoregon kernel: [ 9941.104434]
> >> > lock(&(&ip->i_lock)->mr_lock);
> >> > Nov  6 21:57:09 thoregon kernel: [ 9941.104435]
> >> > Nov  6 21:57:09 thoregon kernel: [ 9941.104435]  *** DEADLOCK ***
> >>
> >> Sorry! Copied the wrong report. Your fix only landed in -rc5, so my
> >> vanilla -rc4 did (also) report the old problem again.
> >> And I copy&pasted that report instead of the second appearance of the
> >> new problem.
> >
> > Can you repost it with line wrapping turned off? The output simply
> > becomes unreadable when it wraps....
> >
> > Yeah, I know I can put it back together, but I've got better things
> > to do with my time than stitch a couple of hundred lines of debug
> > back into a readable format....
> 
> Sorry about that, but I can't find any option to turn that off in Gmail.

Seems like you can't, as per Documentation/email-clients.txt

> I have added the reports as attachment, I hope thats OK for you.

Encoded as text, so it does.

So, both lockdep thingy's are the same:

> [110926.972482] =========================================================
> [110926.972484] [ INFO: possible irq lock inversion dependency detected ]
> [110926.972486] 3.7.0-rc4 #1 Not tainted
> [110926.972487] ---------------------------------------------------------
> [110926.972489] kswapd0/725 just changed the state of lock:
> [110926.972490]  (sb_internal){.+.+.?}, at: [<ffffffff8122b268>] xfs_trans_alloc+0x28/0x50
> [110926.972499] but this lock took another, RECLAIM_FS-unsafe lock in the past:
> [110926.972500]  (&(&ip->i_lock)->mr_lock/1){+.+.+.}

Ah, what? Since when has the ilock been reclaim unsafe?

> [110926.972500] and interrupts could create inverse lock ordering between them.
> [110926.972500] 
> [110926.972503] 
> [110926.972503] other info that might help us debug this:
> [110926.972504]  Possible interrupt unsafe locking scenario:
> [110926.972504] 
> [110926.972505]        CPU0                    CPU1
> [110926.972506]        ----                    ----
> [110926.972507]   lock(&(&ip->i_lock)->mr_lock/1);
> [110926.972509]                                local_irq_disable();
> [110926.972509]                                lock(sb_internal);
> [110926.972511]                                lock(&(&ip->i_lock)->mr_lock/1);
> [110926.972512]   <Interrupt>
> [110926.972513]     lock(sb_internal);

Um, that's just bizzare. No XFS code runs with interrupts disabled,
so I cannot see how this possible.

.....


       [<ffffffff8108137e>] mark_held_locks+0x7e/0x130
       [<ffffffff81081a63>] lockdep_trace_alloc+0x63/0xc0
       [<ffffffff810e9dd5>] kmem_cache_alloc+0x35/0xe0
       [<ffffffff810dba31>] vm_map_ram+0x271/0x770
       [<ffffffff811e1316>] _xfs_buf_map_pages+0x46/0xe0
       [<ffffffff811e222a>] xfs_buf_get_map+0x8a/0x130
       [<ffffffff81233ab9>] xfs_trans_get_buf_map+0xa9/0xd0
       [<ffffffff8121bced>] xfs_ialloc_inode_init+0xcd/0x1d0

We shouldn't be mapping buffers there, there's a patch below to fix
this. It's probably the source of this report, even though I cannot
lockdep seems to be off with the fairies...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: inode allocation should use unmapped buffers.

From: Dave Chinner <dchinner@redhat.com>

Inode buffers do not need to be mapped as inodes are read or written
directly from/to the pages underlying the buffer. This fixes a
regression introduced by commit 611c994 ("xfs: make XBF_MAPPED the
default behaviour").

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_ialloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 2d6495e..a815412 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -200,7 +200,8 @@ xfs_ialloc_inode_init(
 		 */
 		d = XFS_AGB_TO_DADDR(mp, agno, agbno + (j * blks_per_cluster));
 		fbuf = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
-					 mp->m_bsize * blks_per_cluster, 0);
+					 mp->m_bsize * blks_per_cluster,
+					 XBF_UNMAPPED);
 		if (!fbuf)
 			return ENOMEM;
 		/*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
