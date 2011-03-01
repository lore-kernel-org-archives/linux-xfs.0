Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p211U75Z168241 for <xfs@oss.sgi.com>; Mon, 28 Feb 2011 19:30:07 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9ECB81579D5A
	for <xfs@oss.sgi.com>; Mon, 28 Feb 2011 17:32:54 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id FKaX6TfhUCw28cps for <xfs@oss.sgi.com>;
	Mon, 28 Feb 2011 17:32:54 -0800 (PST)
Message-ID: <4D6C4CC5.5030909@sandeen.net>
Date: Mon, 28 Feb 2011 19:32:53 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: kernel panic - stack-protector: kernel stack is corrupted in:
	f87aca93
References: <4D6C28A5.60905@mnsu.edu> <4D6C372E.6030105@sandeen.net>
	<4D6C45EE.80203@mnsu.edu>
In-Reply-To: <4D6C45EE.80203@mnsu.edu>
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
To: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
Cc: xfs@oss.sgi.com

On 2/28/11 7:03 PM, Jeffrey Hundstad wrote:
> Sadly, I didn't have the vmlinux file around anymore.  I'll be glad to recreate it when I get in tomorrow.  However, I have revered commit 3a3675b7f23f83ca8c67c9c2b6edf707fd28d1ba and the problem seems to have vanished.  I'm guessing the stack at this point is a little to fragile for a memset.  The patch is:

Ok, no worries, if the below commit is the culprit for sure, that's enough...

So, whoopsies.

STATIC int
xfs_ioc_fsgeometry_v1(
        xfs_mount_t             *mp,
        void                    __user *arg)
{
        xfs_fsop_geom_v1_t      fsgeo;
        int                     error;

        error = xfs_fs_geometry(mp, (xfs_fsop_geom_t *)&fsgeo, 3);

what we really have is an xfs_fsop_geom_v1_t, but cast to a xfs_fsop_geom_t.

xfs_fs_geometry() zeroes it out to the tune of sizeof (xfs_fsop_geom_t)

the latter is bigger, with the addition of

	__u32           logsunit;

so we overwrite memory that's not ours.  :(  Seems like we should zero
in the callers, when we know how much is really on the stack.  I'll follow
up with a patch; pity this one was fast-tracked for security, I think :(

-Eric



> 
> commit 3a3675b7f23f83ca8c67c9c2b6edf707fd28d1ba
> Author: Dan Rosenberg <drosenberg@vsecurity.com>
> Date:   Mon Feb 14 13:45:28 2011 +0000
> 
>     xfs: prevent leaking uninitialized stack memory in FSGEOMETRY_V1
> 
>     The FSGEOMETRY_V1 ioctl (and its compat equivalent) calls out to
>     xfs_fs_geometry() with a version number of 3.  This code path does not
>     fill in the logsunit member of the passed xfs_fsop_geom_t, leading to
>     the leaking of four bytes of uninitialized stack data to potentially
>     unprivileged callers.
> 
>     v2 switches to memset() to avoid future issues if structure members
>     change, on suggestion of Dave Chinner.
> 
>     Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
>     Reviewed-by: Eugene Teo <eugeneteo@kernel.org>
>     Signed-off-by: Alex Elder <aelder@sgi.com>
> 
> diff --git b/fs/xfs/xfs_fsops.c a/fs/xfs/xfs_fsops.c
> index cec89dd..85668ef 100644
> --- b/fs/xfs/xfs_fsops.c
> +++ a/fs/xfs/xfs_fsops.c
> @@ -53,6 +53,9 @@ xfs_fs_geometry(
>         xfs_fsop_geom_t         *geo,
>         int                     new_version)
>  {
> +
> +       memset(geo, 0, sizeof(*geo));
> +
>         geo->blocksize = mp->m_sb.sb_blocksize;
>         geo->rtextsize = mp->m_sb.sb_rextsize;
>         geo->agblocks = mp->m_sb.sb_agblocks;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
