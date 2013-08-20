Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A97577FC3
	for <xfs@oss.sgi.com>; Tue, 20 Aug 2013 03:17:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6819C30407A
	for <xfs@oss.sgi.com>; Tue, 20 Aug 2013 01:17:01 -0700 (PDT)
Received: from mail-qa0-f45.google.com (mail-qa0-f45.google.com
	[209.85.216.45]) by cuda.sgi.com with ESMTP id mgGgEGtG5eYS3BRR
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 20 Aug 2013 01:17:00 -0700 (PDT)
Received: by mail-qa0-f45.google.com with SMTP id l18so2332665qak.4
	for <xfs@oss.sgi.com>; Tue, 20 Aug 2013 01:16:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1376313607-28133-12-git-send-email-david@fromorbit.com>
References: <1376313607-28133-1-git-send-email-david@fromorbit.com>
	<1376313607-28133-12-git-send-email-david@fromorbit.com>
Date: Tue, 20 Aug 2013 16:16:59 +0800
Message-ID: <CAEH94Lie4UoVBicXohLwOVMWtcuu+fNnkBhK+QV8kV+k0AaB0A@mail.gmail.com>
Subject: Re: ***** SUSPECTED SPAM ***** [RFD 11/17] xfs: factor xfs_create to
	prepare for O_TMPFILE
From: Zhi Yong Wu <zwu.kernel@gmail.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfstests <xfs@oss.sgi.com>

HI,

I'd like to pick off this item and its following 2 items, please avoid
the duplicated work, thanks.

[RFD 11/17] xfs: factor xfs_create to prepare for O_TMPFILE,
[RFD 12/17] xfs: add tmpfile methods
[RFD 13/17] xfs: allow linkat() on O_TMPFILE files

On Mon, Aug 12, 2013 at 9:20 PM, Dave Chinner <david@fromorbit.com> wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> O_TMPFILE support requires allocating an inode that is not attached to the
> a current namespace - it's anonymous. The current inode allocation code runs
> through xfs_create() which requires a parent inode and a name to be passed to
> it. for O_TMPFILE, we do not have a parent inode or a name so we cannot use
> the same calling conventions as xfs_create() to allocate a inode.
>
> In this case, the inode is anonymous, so it is a property of the allocation
> group it is allocated to, not the namespace. Hence all we really need to pass
> from the VFS is a struct xfs_mount and the struct xfs_inode pointer that we
> return the allocated inode in.
>
> The allocation of the inode requires a different log reservation to mkdir/create
> as there is no directory modification taking place, though we still need to
> reserve/account quotas appropriately. We do not need to check if we can add the
> entry to the directory, either.
>
> Hence the majority of the inode allocation code is similar to that in
> xfs_create, and so can be factored out of xfs_create() and reused.
>
> The fact that a parent inode does not exist follows into xfs_dir_ialloc() and
> xfs_ialloc(), too. xfs_dir_ialloc() does not actually use the parent inode, just
> passes it through to xfs_ialloc(). xfs_ialloc() can handle a null parent inode,
> but it results in a target inode number of 0 and so allocation will always
> target AG 0, This will effectively serialise O_TMPFILE allocation and removal.
>
> Hence we should separate the parent inode from the allocation target inode all
> the way down to xfs_dialloc() while factoring this code. This will allow us to
> use a separate AG rotor to direct allocation of temporary files around different
> AGs, allowing them to the allocated and removed concurrently.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_iops.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 96dda62..9c20a2c 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -112,6 +112,7 @@ xfs_cleanup_inode(
>         iput(inode);
>  }
>
> +/* how much of this does tmpfile need? */
>  STATIC int
>  xfs_vn_mknod(
>         struct inode    *dir,
> --
> 1.8.3.2
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



-- 
Regards,

Zhi Yong Wu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
