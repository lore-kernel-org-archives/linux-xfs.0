Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA65BlaF029670 for <xfs@oss.sgi.com>; Mon, 5 Nov 2012 23:11:48 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	csHxaJ2E6GG4ntq3 for <xfs@oss.sgi.com>;
	Mon, 05 Nov 2012 21:13:42 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TVbTk-0006RA-Nq
	for xfs@oss.sgi.com; Tue, 06 Nov 2012 16:13:36 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TVbTk-0004W1-Dj
	for xfs@oss.sgi.com; Tue, 06 Nov 2012 16:13:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 00/22 V4] xfs: metadata verifiers
Date: Tue,  6 Nov 2012 16:13:11 +1100
Message-Id: <1352178813-17216-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi folks,

Fourth version of the buffer verifier series. The read verifier
infrastructure is described here:

http://oss.sgi.com/archives/xfs/2012-10/msg00146.html

The second version with write verifiers is described here:

http://oss.sgi.com/archives/xfs/2012-10/msg00280.html

This version add write verifiers to all buffers that aren't directly
read (i.e. via xfs_buf_get*() interfaces), and drops the log
recovery verifiers from the series as it really needs more buffer
item format flags to do relaibly.

The seris is just about ready to go - it passes all of xfstests here
except for 070. With the addition of the getbuf write verifiers,
this series is now detecting a corrupt xfs_da_node buffer being
written to disk.  It appears to be a new symptom of known problem,
as tracing indicates that the test is triggering the same double
split/join pattern as described here:

http://oss.sgi.com/archives/xfs/2012-03/msg00347.html

There are signs that test 117 might also trigger the situation - it
is hitting the double leaf split code as well, but not following it
up with a join so it hasn't triggered the bad write (yet!).

This is a pre-existing corruption, that the above post took 3 solid
days of debugging to understand enough to write that description.
I'm kind of glad I did right it now, because it was a great
refresher.  However, it might take me another 3 days to did the
problem out, and I'd really like to get this code into the dev tree
ASAP.

Cheers,

Dave.

--

Changes in version 4:
- fixed function names in agf/agi verifier corruption output
- fixed xfs_da_node verify function (use && instead of ||)
- dropped log recovery verifier patch as the recovery of remote
  symlink buffers cannot be distinguished from other metadata magic
  numbers. Will be re-introduced when the CRC format change is made
- added write verifiers for newly allocated buffers.
- all the bug fixes have been moved to a separate series that needs
  to be applied first (some are already in the dev tree).

Changes in version 3:
- update agfl verfier commit to mention debug checks are being done
  unconditionally now.
- fixed agfl verifier null point crash when invalid block numbers
  are found
- ifdef'd out agfl verifier checks as they are not reliable because
  mkfs does not initialise the full AGFL to known values.
- fixed quiet mount flag handling for superblock verification.
- directorry -> directory
- convert to struct buf_ops method of attaching verifiers to the
  buffer. This provides a much cleaner abstraction and simpler
  future expansion of operations on the buffer. It removes a great
  deal of code that is repeated through all the verifiers, too, by
  separating them from buffer IO completion processing.
- add initial support for log write verifiers

  Log write verifiers are, in general, identical to the existing
  verifiers. There are only a small number of modifications
  necessary, mainly due to log recovery occurring before certain
  in-memory structures are initialised (e.g. the struct xfs_perag).
  Write verifiers that need different checks during recovery do so
  via detection of the XLOG_ACTIVE_RECOVERY flag on the log.

  Log recovery does not do read verification of the buffers at this
  point in time, mainly due to the fact we don't know what the
  contents of the buffer is before we read it - the buffer logging
  is generic and content unaware. However, almost all metadata has
  magic numbers in it, so after the changes have been replayed into
  the buffer we can snoop the magic number out of the buffer and
  attach the appropriate verifier before it is written back. Hence
  we should catch gross corruptions introduced by recovery errors.

Changes in Version 2:

- fixed use of xfs_dir2_db_t instead of xfs_dablk_t in directory and
  attr read functions (found when testing xfstests --large-fs on a
  500TB fs and attribute block numbers went beyond 32 bits). This
  mistake was copy-n-pasted several times.
- fixed use of "int map_type" instead of "xfs_daddr_t mappedbno" in
  directory and attr read functions.
- fixed incorrect logic in xfs_dir2_block_verify where a failed
  block check would not clear the block_ok flag correctly
- invalidate allocbt->freelist buffers so they don't get written
  after being freed and while still on the freelist
- added initial suppor for write verifiers.

  Write verifiers are similar to read verifiers, the are simply
  called just prior to issuing the IO on the buffer. The buffer is
  locked at this point, so we are guaranteed an unchanging buffer
  to work from.

  The initial write verifiers are simply the same as the read
  verifiers, except they don't have the ioend processing in them. A
  failure of the write verifier will cause the filesystem to shut
  down as writing invalid metadata to disk is a bad thing. The write
  verifier for the alloc btree blocks was what discovered the
  writing of freed allocbt blocks to disk from the free list.

  Eventually, the metadata CRC will be calculated in the write
  verifier after validating that the buffer contents are valid.

This is the next step along the road to metadata CRC checking. What
the series does is add an iodone callback to most metadata buffer
read operations that is only executed when the buffer is physically
read from disk.  Read operations that hit the cache do no trigger a
verification, as CRCs only protect the on-disk metadata and the
in-memory buffer can be changed at any time after it is read without
recalculating the CRC of the buffer.

Hence we need infrastructure that only triggers verification as a
result of a physical read IO. We can do that easily enough via the
existing b_iodone callback infrastructure. This callback is
currently only used by writes, and callbacks clear themselves from
the buffer b_iodone function pointer once they are run. By following
this same usage pattern, we can attach a verifier callback to the
buffer when it is first read from disk and clear it from the
b_iodone callback once it has been executed, preserving the existing
behaviour for buffers that are cached in memory.

To do this, we nee dto add a verifier function to all the buffer
read functions that can be attached to the buffer if we are going to
execute a physical read to fill the buffer. The iodone callback is
only passed the buffer, so the only context for verification we have
is the function being called.

Hence the initial verifier functions simply check the buffer for
valid contents according to the type that is expected in the buffer.
In future, more targetted verifiers could be implmented to verify
that buffers are in certain states or with certain constraints, but
that is not a focus of this patch set.

If a verifier function detects an inconsistency or corruption, the
only way it can pass that error to waiters is via placing an error
on the buffer itself via xfs_buf_ioerror(). A validation error
should set the error to EFSCORRUPTED, so that a validation error can
be distinguished from an IO failure, which will result in an EIO
being set on the buffer. Once processing is complete, the iodone
function is cleared and the next stage of ioend processing is
triggered by calling xfs_buf_ioend(). This is typically done like
this:

void verifier_fn(struct xfs_buf *bp)
{
	// check buffer

	if (!buf_ok) {
		xfs_error_report();
		xfs_buf_ioerror(bp, EFSCORRUPTED);
	}

	bp->b_iodone = NULL;
	xfs_buf_ioend(bp);
}


Hence callers that are returned a buffer need to check the buffer
for a validation error before using it. If special error handling
for a validation error is necessary, it needs to catch a
EFSCORRUPTED error. In most cases (e.g.  xfs_trans_read_buf_map())
this checking is already done, so there's relatively few places that
need modifications to their error handling to handle this.


The verifiers still emit error reports with stack traces, but they
are probably less useful than they were because the stack trace will
simply point to the IO completion stack. It is an open question as
to whether the error report should be in the verifier or issued by
the waiting context - I'm happy to have reports in the waiting
context in the places where there isn't already an error report if
necessary.

The next step in this process (i.e. the next patch set) is to add a
pre-write callback to verify the contents of the buffer just before
it is issued to disk.  This will allow us to verify that detectable
in-memory corruption is not being propagated to disk, and will use
the same verifier function as the read code.  Once these verifiers
are in place, the infrastructure for enabling CRC validation of
metadata buffers will be in place.

These write verifiers will initially be identical to these read
verifiers, but once CRC verification and calculation is added, the
callbacks will be different but the verifier identical.

It should be noted that this patch set does not quite cover all
metadata types - remote attribute and symlink blocks are not
currently handled because there is no way to validate those buffers
are good or bad because all they contain is user data. Verifiers for
these types of metadata buffers will be added when CRC protection is
added to these types.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
