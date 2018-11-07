Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:17964 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727031AbeKHI1n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Nov 2018 03:27:43 -0500
Date: Thu, 8 Nov 2018 09:55:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/2] xfs: fix panics seen with error injection
Message-ID: <20181107225505.GY19305@dastard>
References: <20181107201055.25883-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181107201055.25883-1-josef@toxicpanda.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-xfs@vger.kernel.org

On Wed, Nov 07, 2018 at 03:10:53PM -0500, Josef Bacik wrote:
> I have been trying to debug a xfs hang that happens sometimes when NBD
> disconnects, but when trying to do error injection the box just falls over right
> away with a panic trying to access an xfs_buf that has been freed.  I hit this
> consistently with the reproducer you can find here
> 
> https://github.com/josefbacik/debug-scripts/tree/master/xfs-hang
> 
> You need to have bcc installed, have the error injection stuff turned on, and
> just run
> 
> ./reproducer.sh

Oh, custom error injection, not the XFS error injection
infrastructure.

> You'll want to modify test.sh to point at wherever your fsstress is, and
> whatever device you want it to use.  It'll walk through functions injecting
> errors and usually craps out when it hits xfs_btree_log_recs.
> 
> What the script does is triggers on whatever function you are looking at
> (xfs_btree_log_recs for example) and then anything that dirties a xfs_buf in
> that path will save that xfs_buf for later. i

Ok, I see that xfs-log-paths.txt file that contains the trigger
functions contains basically every path that can modify a buffer.

> Then when we go to do
> xfs_buf_ioapply_map on that buf (which eventually calls submit_bio) we'll fail
> that bio.  Xfs errors out and things carry on.

IOWs, it shoots down every buffer write after a delay period.

Which basically is no different from just erroring out in
xfs_buf_iodone_callbacks() in buffer write IO completion. i.e.
there's no need to trigger on functions that modify the buffers,
because they all end up in the same function and error handling code
on IO completion.

In fact, we have error injection mechanisms in XFS that can be used
for this which are triggered by sysfs attributes on
CONFIG_XFS_DEBUG=y kernels. i.e:

$ ls -1 /sys/fs/xfs/vdb/errortag/
ag_resv_critical
bad_summary
bmap_finish_one
bmapifmt
btree_chk_lblk
btree_chk_sblk
buf_lru_ref
bulkstat
dareadbuf
diowrite
dirinovalid
drop_writes
force_repair
free_extent
iflush1
iflush2
iflush3
iflush4
iflush5
iflush6
itobp
iunlink
iunlinkrm
log_bad_crc
logiodone
log_item_pin
noerror
readagf
readagi
refcount_continue_update
refcount_finish_one
rmap_finish_one
stratcmpl
stratread
$

The injection tag of note is logiodone -  it fails log IO to
simulate log IO failure shutdowns.

static void
xlog_iodone(xfs_buf_t *bp)
{
        struct xlog_in_core     *iclog = bp->b_log_item;
        struct xlog             *l = iclog->ic_log;
        int                     aborted = 0;

        /*
         * Race to shutdown the filesystem if we see an error or the iclog is in
         * IOABORT state. The IOABORT state is only set in DEBUG mode to inject
         * CRC errors into log recovery.
         */
>>>>>    if (XFS_TEST_ERROR(bp->b_error, l->l_mp, XFS_ERRTAG_IODONE_IOERR) ||
	     iclog->ic_state & XLOG_STATE_IOABORT) {


So if you want to catch logged buffers that are being written to
error them out and hence test the error retry paths, then replicate
xlog_iodone injection into xfs_buf_iodone_callbacks(). All modified
buffers have this iodone function attached to them - it does all the
post-io completion error handling and log item cleaning. i.e. this
small change will basically do the same sort of testing:

void
xfs_buf_iodone_callbacks(
        struct xfs_buf          *bp)
{
        /*
         * If there is an error, process it. Some errors require us
         * to run callbacks after failure processing is done so we
         * detect that and take appropriate action.
         */
-	if (bp->b_error && xfs_buf_iodone_callback_error(bp))
+	if (XFS_TEST_ERROR(bp->b_error, bp->b_mount, XFS_ERRTAG_IODONE_IOERR) &&
+	    xfs_buf_iodone_callback_error(bp))
                return;

It would probably be better to add a separate "buffer_write" error
tag to sysfs so you don't shut down the filesystem by induced log Io
errors, but essentially this will do exactly what your custom error
injection is doing.

And, by using the built in error injection, you can write a fstest
to exercise the buffer write error handling....


> In my testing however it seems like we're dropping the ref on failed xfs_buf's
> prematurely, so they get freed before we're able to add them to the delwri list
> to be retried.  The 2/2 patch fixes this problem.  The 1/2 patch makes it
> possible for the reproducer to work, as it relies on being able to attach a
> kprobe/kretprobe at xfs_buf_ioapply_map.

Use the built in error injection, and there's no need for hacking
code just so you can place one-off debug probes.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
