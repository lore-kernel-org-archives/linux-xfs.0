Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9BC7ZLU108443 for <xfs@oss.sgi.com>; Thu, 11 Oct 2012 07:07:35 -0500
Message-ID: <5076B6DF.3090308@sgi.com>
Date: Thu, 11 Oct 2012 07:09:03 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 00/19] xfs: buffer read verifier infrastructure
References: <1349754670-32009-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1349754670-32009-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 10/08/12 22:50, Dave Chinner wrote:
> Hi folks,
>
> This is the next step along the road to metadata CRC checking. What
> the series does is add an iodone callback to most metadata buffer
> read operations that is only executed when the buffer is physically
> read from disk.  Read operations that hit the cache do no trigger a
> verification, as CRCs only protect the on-disk metadata and the
> in-memory buffer can be changed at any time after it is read without
> recalculating the CRC of the buffer.
>
> Hence we need infrastructure that only triggers verification as a
> result of a physical read IO. We can do that easily enough via the
> existing b_iodone callback infrastructure. This callback is
> currently only used by writes, and callbacks clear themselves from
> the buffer b_iodone function pointer once they are run. By following
> this same usage pattern, we can attach a verifier callback to the
> buffer when it is first read from disk and clear it from the
> b_iodone callback once it has been executed, preserving the existing
> behaviour for buffers that are cached in memory.
>
> To do this, we nee dto add a verifier function to all the buffer
> read functions that can be attached to the buffer if we are going to
> execute a physical read to fill the buffer. The iodone callback is
> only passed the buffer, so the only context for verification we have
> is the function being called.
>
> Hence the initial verifier functions simply check the buffer for
> valid contents according to the type that is expected in the buffer.
> In future, more targetted verifiers could be implmented to verify
> that buffers are in certain states or with certain constraints, but
> that is not a focus of this patch set.
>
> If a verifier function detects an inconsistency or corruption, the
> only way it can pass that error to waiters is via placing an error
> on the buffer itself via xfs_buf_ioerror(). A validation error
> should set the error to EFSCORRUPTED, so that a validation error can
> be distinguished from an IO failure, which will result in an EIO
> being set on the buffer. Once processing is complete, the iodone
> function is cleared and the next stage of ioend processing is
> triggered by calling xfs_buf_ioend(). This is typically done like
> this:
>
> void verifier_fn(struct xfs_buf *bp)
> {
> 	// check buffer
>
> 	if (!buf_ok) {
> 		xfs_error_report();
> 		xfs_buf_ioerror(bp, EFSCORRUPTED);
> 	}
>
> 	bp->b_iodone = NULL;
> 	xfs_buf_ioend(bp);
> }
>
>
> Hence callers that are returned a buffer need to check the buffer
> for a validation error before using it. If special error handling
> for a validation error is necessary, it needs to catch a
> EFSCORRUPTED error. In most cases (e.g.  xfs_trans_read_buf_map())
> this checking is already done, so there's relatively few places that
> need modifications to their error handling to handle this.
>
>
> The verifiers still emit error reports with stack traces, but they
> are probably less useful than they were because the stack trace will
> simply point to the IO completion stack. It is an open question as
> to whether the error report should be in the verifier or issued by
> the waiting context - I'm happy to have reports in the waiting
> context in the places where there isn't already an error report if
> necessary.
>
> The next step in this process (i.e. the next patch set) is to add a
> pre-write callback to verify the contents of the buffer just before
> it is issued to disk.  This will allow us to verify that detectable
> in-memory corruption is not being propagated to disk, and will use
> the same verifier function as the read code.  Once these verifiers
> are in place, the infrastructure for enabling CRC validation of
> metadata buffers will be in place.
>
> These write verifiers will initially be identical to these read
> verifiers, but once CRC verification and calculation is added, the
> callbacks will be different but the verifier identical.
>
> It should be noted that this patch set does not quite cover all
> metadata types - remote attribute and symlink blocks are not
> currently handled because there is no way to validate those buffers
> are good or bad because all they contain is user data. Verifiers for
> these types of metadata buffers will be added when CRC protection is
> added to these types.
>
> Comments, flames and rants about how to do this better are welcome :)
>
> Cheers,
>
> Dave.
>
> PS: you can now see how I found the bug fixed in the first patch. ;)
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


"Don't shoot me, I am only the piano player" -Joe Walsh

I put in the series on top of the previous worker mover series.
I know this is sketchy in details. I get one of the below on xfstest
076:

  1) XFS: Assertion failed: atomic_read(&bp->b_hold) > 0
     from [PATCH 02/14] xfs: rationalise xfs_mount_wq users
  2) filesystem hang. One process is in inode reclaim waiting on
     the superblock buffer lock, and the umount doing the same.

I need to convert my machines for internal use for the rest of the week.
I hit one or the other 100% time with test 076.

--Mark.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
