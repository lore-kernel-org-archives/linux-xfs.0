Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 887C77CA0
	for <xfs@oss.sgi.com>; Thu, 22 Sep 2016 20:40:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3E4BA30404E
	for <xfs@oss.sgi.com>; Thu, 22 Sep 2016 18:40:02 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id cEPSq1gXmu9vGNAJ for <xfs@oss.sgi.com>;
	Thu, 22 Sep 2016 18:39:59 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 1D0982B51
	for <xfs@oss.sgi.com>; Thu, 22 Sep 2016 20:39:38 -0500 (CDT)
Subject: Re: [PATCH] xfs: quiesce the filesystem after recovery on readonly
	mount
References: <1474589500-13584-1-git-send-email-david@fromorbit.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <af65b5ae-2ff8-c344-0e04-cbbef3efe197@sandeen.net>
Date: Thu, 22 Sep 2016 20:39:58 -0500
MIME-Version: 1.0
In-Reply-To: <1474589500-13584-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 9/22/16 7:11 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Recently we've had a number of reports where log recovery on a v5
> filesystem has reported corruptions that looked to be caused by
> recovery being re-run over the top of an already-recovered
> metadata. This has uncovered a bug in recovery (fixed elsewhere)
> but the vector that caused this was largely unknown.
> 
> A kdump test started tripping over this problem - the system
> would be crashed, the kdump kernel and environment would boot and
> dump the kernel core image, and then the system would reboot. After
> reboot, the root filesystem was triggering log recovery and
> corruptions were being detected. The metadumps indicated the above
> log recovery issue.
> 
> What is happening is that the kdump kernel and environment is
> mounting the root device read-only to find the binaries needed to do
> it's work. The result of this is that it is running log recovery.
> However, because there were unlinked files and EFIs to be processed
> by recovery, the completion of phase 1 of log recovery could not
> mark the log clean. And because it's a read-only mount, the unmount
> process does not write records to the log to mark it clean, either.
> Hence on the next mount of the filesystem, log recovery was run
> again across all the metadata that had already been recovered and
> this is what triggered corruption warnings.
> 
> To avoid this problem, we need to ensure that a read-only mount
> always updates the log when it completes the second phase of
> recovery. We already handle this sort of issue with rw->ro remount
> transitions, so the solution is as simple as quiescing the
> filesystem at the appropriate time during the mount process. This
> results in the log being marked clean so the mount behaviour
> recorded in the logs on repeated RO mounts will change (i.e. log
> recovery will no longer be run on every mount until a RW mount is
> done). This is a user visible change in behaviour, but it is
> harmless.

Excellent idea :)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_mount.c | 14 ++++++++++++++
>  fs/xfs/xfs_super.c |  2 +-
>  fs/xfs/xfs_super.h |  1 +
>  3 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index faeead6..56e85a6 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -934,6 +934,20 @@ xfs_mountfs(
>  	}
>  
>  	/*
> +	 * Now the log is fully replayed, we can transition to full read-only
> +	 * mode for read-only mounts. This will sync all the metadata and clean
> +	 * the log so that the recovery we just performed does not have to be
> +	 * replayed again on the next mount.
> +	 *
> +	 * We use the same quiesce mechanism as the rw->ro remount, as they are
> +	 * semantically identical operations.
> +	 */
> +	if ((mp->m_flags & (XFS_MOUNT_RDONLY|XFS_MOUNT_NORECOVERY)) ==
> +							XFS_MOUNT_RDONLY) {
> +		xfs_quiesce_attr(mp);
> +	}
> +
> +	/*
>  	 * Complete the quota initialisation, post-log-replay component.
>  	 */
>  	if (quotamount) {
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 3409753..2d092f9 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1137,7 +1137,7 @@ xfs_restore_resvblks(struct xfs_mount *mp)
>   * Note: xfs_log_quiesce() stops background log work - the callers must ensure
>   * it is started again when appropriate.
>   */
> -static void
> +void
>  xfs_quiesce_attr(
>  	struct xfs_mount	*mp)
>  {
> diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
> index 529bce9..b6418ab 100644
> --- a/fs/xfs/xfs_super.h
> +++ b/fs/xfs/xfs_super.h
> @@ -61,6 +61,7 @@ struct xfs_mount;
>  struct xfs_buftarg;
>  struct block_device;
>  
> +extern void xfs_quiesce_attr(struct xfs_mount *mp);
>  extern void xfs_flush_inodes(struct xfs_mount *mp);
>  extern void xfs_blkdev_issue_flush(struct xfs_buftarg *);
>  extern xfs_agnumber_t xfs_set_inode_alloc(struct xfs_mount *,
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
