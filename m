Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAK76tSU118067 for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 01:06:56 -0600
Received: from mail-ea0-f181.google.com (mail-ea0-f181.google.com
	[209.85.215.181]) by cuda.sgi.com with ESMTP id
	RFxwPvisu8bkPWJM (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 19 Nov 2012 23:09:04 -0800 (PST)
Received: by mail-ea0-f181.google.com with SMTP id k14so827411eaa.26
	for <xfs@oss.sgi.com>; Mon, 19 Nov 2012 23:09:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121119235306.GX14281@dastard>
References: <CAPVoSvSM9=hictqwT2rzZA-fU_XSwd-_FRzW_J+HQYj7iohTWQ@mail.gmail.com>
	<20121029222613.GU29378@dastard>
	<CAPVoSvQATjAVu-D477mrr6K9d0FeY7sH27cH-zNBYMJcRoUY0Q@mail.gmail.com>
	<CAPVoSvRks32ZM7n6U8but-vEj622TEFqAFdxXqS_6mRxyv=0Ew@mail.gmail.com>
	<CAPVoSvSKn2FuBhMF+3U1ueuEzBqL4CFTYFGXqGczTa42PgMjRw@mail.gmail.com>
	<20121118235105.GT14281@dastard>
	<CAPVoSvR+Gk6ggSZ6=ZMpyvwhosjd4BSGsUqRT=txkzGDGLMTPw@mail.gmail.com>
	<20121119235306.GX14281@dastard>
Date: Tue, 20 Nov 2012 08:09:02 +0100
Message-ID: <CAPVoSvRnA3UNkirza72veCPih0ngY9U09hG4UOa2TU4meX5Pog@mail.gmail.com>
Subject: Re: Hang in XFS reclaim on 3.7.0-rc3
From: Torsten Kaiser <just.for.lkml@googlemail.com>
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
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Tue, Nov 20, 2012 at 12:53 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Nov 19, 2012 at 07:50:06AM +0100, Torsten Kaiser wrote:
> So, both lockdep thingy's are the same:

I suspected this, but as the reports where slightly different I
attached bith of them, as I couldn't decide witch one was the
better/simpler report to debug this.

>> [110926.972482] =========================================================
>> [110926.972484] [ INFO: possible irq lock inversion dependency detected ]
>> [110926.972486] 3.7.0-rc4 #1 Not tainted
>> [110926.972487] ---------------------------------------------------------
>> [110926.972489] kswapd0/725 just changed the state of lock:
>> [110926.972490]  (sb_internal){.+.+.?}, at: [<ffffffff8122b268>] xfs_trans_alloc+0x28/0x50
>> [110926.972499] but this lock took another, RECLAIM_FS-unsafe lock in the past:
>> [110926.972500]  (&(&ip->i_lock)->mr_lock/1){+.+.+.}
>
> Ah, what? Since when has the ilock been reclaim unsafe?
>
>> [110926.972500] and interrupts could create inverse lock ordering between them.
>> [110926.972500]
>> [110926.972503]
>> [110926.972503] other info that might help us debug this:
>> [110926.972504]  Possible interrupt unsafe locking scenario:
>> [110926.972504]
>> [110926.972505]        CPU0                    CPU1
>> [110926.972506]        ----                    ----
>> [110926.972507]   lock(&(&ip->i_lock)->mr_lock/1);
>> [110926.972509]                                local_irq_disable();
>> [110926.972509]                                lock(sb_internal);
>> [110926.972511]                                lock(&(&ip->i_lock)->mr_lock/1);
>> [110926.972512]   <Interrupt>
>> [110926.972513]     lock(sb_internal);
>
> Um, that's just bizzare. No XFS code runs with interrupts disabled,
> so I cannot see how this possible.
>
> .....
>
>
>        [<ffffffff8108137e>] mark_held_locks+0x7e/0x130
>        [<ffffffff81081a63>] lockdep_trace_alloc+0x63/0xc0
>        [<ffffffff810e9dd5>] kmem_cache_alloc+0x35/0xe0
>        [<ffffffff810dba31>] vm_map_ram+0x271/0x770
>        [<ffffffff811e1316>] _xfs_buf_map_pages+0x46/0xe0
>        [<ffffffff811e222a>] xfs_buf_get_map+0x8a/0x130
>        [<ffffffff81233ab9>] xfs_trans_get_buf_map+0xa9/0xd0
>        [<ffffffff8121bced>] xfs_ialloc_inode_init+0xcd/0x1d0
>
> We shouldn't be mapping buffers there, there's a patch below to fix
> this. It's probably the source of this report, even though I cannot
> lockdep seems to be off with the fairies...

I also tried to understand what lockdep was saying, but
Documentation/lockdep-design.txt is not too helpful.
I think 'CLASS'-ON-R / -ON-W means that this lock was 'ON' / held
while 'CLASS' (HARDIRQ, SOFTIRQ, RECLAIM_FS) happend and that makes
this lock unsafe for these contexts. IN-'CLASS'-R / -W seems to be
'lock taken in context 'CLASS'.
A note that 'CLASS'-ON-? means 'CLASS'-unsafe in there would be helpful to me...

Wrt. above interrupt output: I think lockdep doesn't really know about
RECLAIM_FS and threats it as another interrupt. I think that output
should have been something like this:
        CPU0                    CPU1
        ----                    ----
   lock(&(&ip->i_lock)->mr_lock/1);
                                <Allocation enters reclaim>
                                lock(sb_internal);
                                lock(&(&ip->i_lock)->mr_lock/1);
   <Allocation enters reclaim>
     lock(sb_internal);

Entering reclaim on CPU1 would mean that CPU1 would not enter reclaim
again, so the reclaim-'interrupt' would be disabled.
And instead of interrupts disrupting the normal codeflow on CPU0 it
would be 'interrupted' be instead of doing a normal allocation, it
would 'interrupt' the allocation to reclaim memory.
print_irq_lock_scenario() would need to be taught to print a slightly
different message for reclaim-'interrupts'.

I will try your patch, but as I do not have a reliable reproducer to
create this lockdep report, I can't really verify if this fixes it.
But I will definitely mail you, if it happens again with this patch.

Thanks, Torsten

> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
> xfs: inode allocation should use unmapped buffers.
>
> From: Dave Chinner <dchinner@redhat.com>
>
> Inode buffers do not need to be mapped as inodes are read or written
> directly from/to the pages underlying the buffer. This fixes a
> regression introduced by commit 611c994 ("xfs: make XBF_MAPPED the
> default behaviour").
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_ialloc.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
> index 2d6495e..a815412 100644
> --- a/fs/xfs/xfs_ialloc.c
> +++ b/fs/xfs/xfs_ialloc.c
> @@ -200,7 +200,8 @@ xfs_ialloc_inode_init(
>                  */
>                 d = XFS_AGB_TO_DADDR(mp, agno, agbno + (j * blks_per_cluster));
>                 fbuf = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
> -                                        mp->m_bsize * blks_per_cluster, 0);
> +                                        mp->m_bsize * blks_per_cluster,
> +                                        XBF_UNMAPPED);
>                 if (!fbuf)
>                         return ENOMEM;
>                 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
