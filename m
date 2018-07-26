Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48566 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728308AbeGZCUT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Jul 2018 22:20:19 -0400
Subject: Re: [PATCH 04/10] xfs_scrub: schedule and manage
 optimizations/repairs to the filesystem
References: <153006766483.20121.9285982017465570544.stgit@magnolia>
 <153006769063.20121.7477051095164391421.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <1e05bca4-1d65-af25-e6b2-c6e721cf5a42@sandeen.net>
Date: Wed, 25 Jul 2018 18:06:00 -0700
MIME-Version: 1.0
In-Reply-To: <153006769063.20121.7477051095164391421.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 6/26/18 7:48 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Teach xfs_scrub to remember scrub requests that failed (or indicated
> that optimization is a possibility) as action items.  Depending on the
> circumstances, certain items are acted upon immediately (e.g. metadata
> that needs to be healthy in order to finish the scan, or files that are
> already open) or deferred until later.  Expand the repair phase to
> deal with the deferred actions.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  man/man8/xfs_scrub.8 |   38 ++++++-
>  scrub/Makefile       |    2 
>  scrub/phase1.c       |    7 +
>  scrub/phase2.c       |   59 ++++++++++
>  scrub/phase3.c       |   42 +++++--
>  scrub/phase4.c       |   76 +++++++++++++
>  scrub/repair.c       |  286 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  scrub/repair.h       |   42 +++++++
>  scrub/scrub.c        |  130 ++++++++++++++++-------
>  scrub/scrub.h        |   42 +++++--
>  scrub/xfs_scrub.c    |   44 +++++++-
>  scrub/xfs_scrub.h    |    1 
>  12 files changed, 690 insertions(+), 79 deletions(-)
>  create mode 100644 scrub/repair.c
>  create mode 100644 scrub/repair.h
> 
> 
> diff --git a/man/man8/xfs_scrub.8 b/man/man8/xfs_scrub.8
> index 680ef72b..18948a4e 100644
> --- a/man/man8/xfs_scrub.8
> +++ b/man/man8/xfs_scrub.8
> @@ -1,6 +1,6 @@
>  .TH xfs_scrub 8
>  .SH NAME
> -xfs_scrub \- check the contents of a mounted XFS filesystem
> +xfs_scrub \- check and repair the contents of a mounted XFS filesystem
>  .SH SYNOPSIS
>  .B xfs_scrub
>  [
> @@ -108,10 +108,40 @@ Optimizations supported by this program include, but are not limited to:
>  Instructing the underlying storage to discard unused extents via the
>  .B TRIM
>  ioctl.
> +.IP \[bu]
> +Updating secondary superblocks to match the primary superblock.
> +.IP \[bu]
> +Turning off shared block write checks for files that no longer share blocks.
>  .SH REPAIRS
> -This program currently does not support making any repairs.
> -Corruptions can only be fixed by unmounting the filesystem and running
> -.BR xfs_repair (8).
> +Repairs are performed by calling into the kernel.
> +This limits the scope of repair activities to rebuilding primary data
> +structures from secondary data structures, or secondary structures from
> +primary structures.
> +The existence of secondary data structures may require features that can
> +only be turned on from
> +.BR mkfs.xfs (8).
> +If errors cannot be repaired, the filesystem must be
> +unmounted and
> +.BR xfs_repair (8)
> +run.
> +Repairs supported by the kernel include, but are not limited to:
> +.IP \[bu] 2
> +Reconstructing extent allocation data.
> +.IP \[bu]
> +Rebuilding free space information.
> +.IP \[bu]
> +Rebuilding inode indexes.
> +.IP \[bu]
> +Fixing minor corruptions of inode records.
> +.IP \[bu]
> +Recalculating reference count information.
> +.IP \[bu]
> +Reconstructing reverse mapping data from primary extent allocation data.
> +.IP \[bu]
> +Scheduling a quotacheck for the next mount.
> +.PP
> +If corrupt metadata is successfully repaired, this program will log that
> +a repair has succeeded instead of a corruption report.

for 4.18 I think we should only list what's possible, right?
But, um, what is currently possible in 4.18?

Maybe I'll just add a "may include ..." and a "depending on the capabilities
of the running kernel" to give us some wiggle room.

As for the rest, um, seems ok AFAICT (which isn't that far).  Minor nit:

...

>  static void
>  report_outcome(
>  	struct scrub_ctx	*ctx)
> @@ -525,9 +555,16 @@ report_outcome(
>  	 * setting up the scrub and we actually saw corruptions.  Warnings
>  	 * are not corruptions.
>  	 */
> -	if (ctx->scrub_setup_succeeded && total_errors > 0)
> -		fprintf(stderr, _("%s: Unmount and run xfs_repair.\n"),
> -				ctx->mntpoint);
> +	if (ctx->scrub_setup_succeeded && total_errors > 0) {
> +		char		*msg;
> +
> +		if (ctx->mode == SCRUB_MODE_DRY_RUN)
> +			msg = _("%s: Re-run xfs_scrub without -n.\n");

"... to repair?"

Is it possible that we found something that can't actually be repaired
online, and so they'll get:

# xfs_scrub -n
"Re-run xfs_scrub without -n"
# xfs_scrub
"Unmount and run xfs_repair."
#

Maybe that's ok ... there's no way to keep track of which found problems
are repairable by the running kernel, is there?

-Eric
