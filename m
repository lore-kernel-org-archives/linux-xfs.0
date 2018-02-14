Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55564 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S967706AbeBNNJl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Feb 2018 08:09:41 -0500
Date: Wed, 14 Feb 2018 08:09:39 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2] xfs: byte range buffer dirty region tracking
Message-ID: <20180214130939.GA42785@bfoster.bfoster>
References: <20180201010514.30233-1-david@fromorbit.com>
 <20180205003415.dn6elcqb4kae3xle@destitution>
 <20180206162141.GA3862@bfoster.bfoster>
 <20180212024138.GB6778@dastard>
 <20180212142619.GA33694@bfoster.bfoster>
 <20180212211824.GC6778@dastard>
 <20180213131525.GA38210@bfoster.bfoster>
 <20180213220220.GF6778@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180213220220.GF6778@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Feb 14, 2018 at 09:02:20AM +1100, Dave Chinner wrote:
> On Tue, Feb 13, 2018 at 08:15:26AM -0500, Brian Foster wrote:
> > On Tue, Feb 13, 2018 at 08:18:24AM +1100, Dave Chinner wrote:
> > > On Mon, Feb 12, 2018 at 09:26:19AM -0500, Brian Foster wrote:
> > > > :/ So it seems to
> > > > me this breaks a technically valid case in weird/subtle ways. For
> > > > example, why assert about last == 0, but then go on to add the range
> > > > anyways, explicitly not size it correctly, but then format it as if
> > > > nothing is wrong? If it were really wrong/invalid (which I don't think
> > > > it is), why not put the check in the log side and skip adding the range
> > > > rather than add it, skip sizing it, and then format it.
> > > 
> > > So what you're really concerned about is that I put asserts into the
> > > code to catch broken development code, but then allow production
> > > systems through without caring whether it works correctly because
> > > that boundary condition will never occur during runtime on
> > > production systems?
> > 
> > No. As already mentioned in my previous mail, I care little about the
> > asserts. Asserts can easily be removed if they turn out to be bogus.
> > Wrong asserts tend to have little negative effect on production users
> > because along with only affecting debug kernels, they'd have to be
> > fairly rare to slip through our testing. So I'm perfectly _happy_ to be
> > cautious with regard to asserts.
> > 
> > What I care much more about is not leaving latent bugs around in the
> > code. IMO, there is very rarely good enough justification to knowingly
> > commit buggy/fragile code to the kernel,
> 
> Hold on a minute!
> 
> I'm not asking anyone to commit buggy or fragile code. I've already
> fixed the off-by-one problems you've pointed out, and all I was
> trying to do was understand what you saw wrong with the asserts to
> catch a "should never happen" condition so I could change it in a
> way that you'd find acceptible.
> 
> There's no need to shout and rant at me....
> 

I pointed out the first-byte logging case looked broken. Rather than
indicate you're fixing that one way or another (as you had done for the
other issues we've found), you argued that "nobody does that" or "should
never happen."

Sorry for the rant and/or whether I've misinterpreted your comment, but
I have no way to read that other than an attempt to justify the problem,
particularly when in comparison every other issue was clearly noted that
it would be fixed. Also note that I think you've slightly misinterpreted
my fragile code comment to be harsher than intended (or I didn't express
my position clearly...). I'm simply trying to explain why I'll likely
not ack this patch unless that problem is fixed (e.g., because I
consider it fragile, independent of current behavior of outside
contexts).

I'll try to restate my position more distinctly/clearly... I consider
this patch broken so long as it doesn't handle the set of valid inputs
defined by xfs_trans_log_buf() correctly, as the current code does. I
expect any first <= last range to DTRT and ensure the associated chunk
of the buffer is logged.

> > ... having said all that and having already wasted more time on this
> > than it would have taken for you to just fix the patch, I'll end my rant
> > with this splat[1]. It demonstrates the "boundary condition" that "will
> > never occur during runtime on production systems" (production system
> > level output included for extra fun ;P).
> 
> This is a pre-existing bug in xlog_cil_insert_format_items()
> that my change has exposed:
> 
>                 /* Skip items that do not have any vectors for writing */
> 		if (!shadow->lv_niovecs && !ordered)
> 			continue;
> 
> The code I added triggers this (niovecs == 0), and that now gives
> us the case where we have a dirty log item descriptor
> (XFS_LID_DIRTY) without a log vector attached to item->li_lv.
> Then in xlog_cil_insert_items():
> 
>                 /* Skip items which aren't dirty in this transaction. */
>                 if (!(lidp->lid_flags & XFS_LID_DIRTY))
>                         continue;
> 
>                 /*
>                  * Only move the item if it isn't already at the tail. This is
>                  * to prevent a transient list_empty() state when reinserting
>                  * an item that is already the only item in the CIL.
>                  */
>                 if (!list_is_last(&lip->li_cil, &cil->xc_cil))
>                         list_move_tail(&lip->li_cil, &cil->xc_cil);
> 
> 
> We put that "clean" log item on the CIL because XFS_LID_DIRTY is
> set, and then when we push the CIL in xlog_cil_push(), we trip over
> a dirty log item without a log vector when chaining log vectors to
> pass to the log writing code here:
> 
>         while (!list_empty(&cil->xc_cil)) {
>                 struct xfs_log_item     *item;
> 
>                 item = list_first_entry(&cil->xc_cil,
>                                         struct xfs_log_item, li_cil);
>                 list_del_init(&item->li_cil);
>                 if (!ctx->lv_chain)
>                         ctx->lv_chain = item->li_lv;
>                 else
>                         lv->lv_next = item->li_lv;       <<<<<<<<<
>  >>>>>>>>       lv = item->li_lv;
>                 item->li_lv = NULL;
>                 num_iovecs += lv->lv_niovecs;
>         }
> 
> i.e. lv ends up null part way through the log item chain we are
> processing and the next loop iteration fails.
> 

Ok, I hadn't traced through the actual crash. The above all sounds sane
to me...

> IOWs, the bug isn't in the patch I wrote - it has uncovered a
> latent bug added years ago for a condition that had never, ever been
> exercised until now.
> 

Note that I agree you're probably right that there is a bug worth fixing
in the CIL code to not crash in this case. The crash is just a symptom,
however. There's still a bug in this patch because the buffer needs to
be logged.

IOW, the purpose of this test is to demonstrate that the "should never
happen" case argued above "actually can happen."

> Brian, can you now give me all the details of what you were doing to
> produce this and turn on CONFIG_XFS_DEBUG so that it catches the
> zero length buffer that was logged when it happens?  That way I can
> test a fix for this bug and that the buffer range logging exercises
> this case properly...
> 

Yep. It's a specially crafted symlink creation on a small FSB, v4
filesystem with fragmented free space. We log symlink buffers on v4
filesystems without any header, so the buffer content is not dictated by
any internal fs metadata format. If the link target is large enough to
span multiple blocks and free space is fragmented such that those blocks
are discontiguous, we can end up logging (solely) the first byte of the
last buffer of the link target.

This is actually reproducible on demand so I'll just append a basic
recipe rather than collect the debug data and whatnot..

Brian

--- 8< ---

dev=<dev>
mnt=/mnt

sym=`for i in $(seq 0 512); do echo -n a; done`

mkfs.xfs -f -mcrc=0 -bsize=512 -dsize=25m $dev
mount $dev $mnt

dd if=/dev/zero of=$mnt/spc1
~/xfstests-dev/src/punch-alternating $mnt/spc1
dd if=/dev/zero of=$mnt/spc2
xfs_io -c "fpunch 5m 25m" $mnt/spc2

for i in $(seq 0 2); do
        ln -s $sym $mnt/link.$i
        xfs_io -c fsync $mnt
done

umount $mnt
