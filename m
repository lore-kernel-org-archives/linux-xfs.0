Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5EF117F50
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 13:43:36 -0500 (CDT)
Message-ID: <522A2257.1060801@sgi.com>
Date: Fri, 06 Sep 2013 13:43:35 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 50/55] xfs: di_flushiter considered harmful
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
	<1378332359-14737-51-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-51-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 09/04/13 17:05, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> When we made all inode updates transactional, we no longer needed
> the log recovery detection for inodes being newer on disk than the
> transaction being replayed - it was redundant as replay of the log
> would always result in the latest version of the inode woul dbe on
> disk. It was redundant, but left in place because it wasn't
> considered to be a problem.
>
> However, with the new "don't read inodes on create" optimisation,
> flushiter has come back to bite us. Essentially, the optimisation
> made always initialises flushiter to zero in the create transaction,
> and so if we then crash and run recovery and the inode already on
> disk has a non-zero flushiter it will skip recovery of that inode.
> As a result, log recovery does the wrong thing and we end up with a
> corrupt filesystem.
>
> Because we have to support old kernel to new kernl upgrades, we
> can't just get rid of the flushiter support in log recovery as we
> might be upgrading from a kernel that doesn't have fully transaction
> inode updates.  Unfortunately, for v4 superblocks there is no way to
> guarantee that log recovery knows about this fact.
>
> We cannot add a new inode format flag to say it's a "special inode
> create" because it won't be understood by older kernels and so
> recovery could do the wrong thing on downgrade. We cannot specially
> detect the combination of zero mode/non-zero flushiter on disk to
> non-zero mode, zero flushiter in the log item during recovery
> because wrapping of the flushiter can result in false detection.
>
> Hence that makes this "don't use flushiter" optimisation limited to
> a disk format that guarantees that we don't need it. And that means
> the only fix here is to limit the "no read IO on create"
> optimisation to version 5 superblocks....
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

user space portion of kernel commit e60896
Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
