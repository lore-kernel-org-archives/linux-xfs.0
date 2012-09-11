Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8BGk8l8122618 for <xfs@oss.sgi.com>; Tue, 11 Sep 2012 11:46:08 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Gyjm3i1vHkL0F23C for
	<xfs@oss.sgi.com>; Tue, 11 Sep 2012 09:47:12 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q8BGlB6k001471
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 11 Sep 2012 12:47:12 -0400
Received: from andromeda.usersys.redhat.com (ovpn-113-109.phx2.redhat.com
	[10.3.113.109])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q8BGl72d007466
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 11 Sep 2012 12:47:10 -0400
Date: Tue, 11 Sep 2012 13:47:06 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH v5] Stop xfs_do_force_shutdown / messages fron
	xfs_log_force if filesystem is already shutdown.
Message-ID: <20120911164706.GA15252@andromeda.usersys.redhat.com>
References: <76577fa31ab2aa750994c1bc6a1b6f44beb03116.1347002369.git.rprabhu@wnohang.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <76577fa31ab2aa750994c1bc6a1b6f44beb03116.1347002369.git.rprabhu@wnohang.net>
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
To: xfs@oss.sgi.com

Hi, particularly, these messages are annoying to me too, and it's great to see
this patch, have some comments though.

> This is to prevent xfs_log_force from printing error message continuously (due
> to xfs_sync and others) till umount if the disk has been forcefully unplugged.
> 
> This is to prevent messages like these from being displayed repeatedly.
> 
> [ 3873.009329] XFS (sdb3): xfs_log_force: error 5 returned.
> 
> Note, that even after xfs_do_force_shutdown has been called, xfs_log_force
> doesn't stop till the filesystem has been unmounted (and it keeps printing
> "error 5 returned" to kernel log). Also, xfs_do_force_shutdown is called
> repeatedly on an already shutdown filesystem through xfs_fs_sync_fs.
> 
> To fix this, added condition over XFS_FORCED_SHUTDOWN to xfs_log_force and
> xfs_fs_sync_fs.
> 
> To simulate it, mount an xfs filesystem located on external disk, and then pull
> the power to the disk.
> 
> Now, the dmesg looks,
> 
> [  268.307303] XFS (sdb2): xfs_do_force_shutdown(0x1) called from line 1031 of file fs/xfs/xfs_buf.c.  Return address = 0xffffffff8127c13a
> [  268.307318] XFS (sdb2): I/O Error Detected. Shutting down filesystem
> [  268.307323] XFS (sdb2): Please umount the filesystem and rectify the problem(s)
> 

To be honest this commit message looks a little confusing to me, I'd prefer
something a little more direct and clear, but this is just my humble opinion.

I'd say something like:

Prevents xfs_log_force from print continuously error messages after filesystem
has been shutdown:

[ 3873.009329] XFS (sdb3): xfs_log_force: error 5 returned.

> ---
> 
> Version 1: Removed calling xfs_syncd_stop from xfs_sync_worker.
> Version 2: Removed calling xfs_fs_writable in xfs_sync_worker and xfs_flush_worker.
> Version 3: Removed calling xfs_syncd_stop in xfs_bwrite.
> Version 4: Added return statements to xfs_log_force and xfs_fs_sync_fs.
> Version 5: As per suggestion, added xfs_warn to xfs_fs_sync_fs and removed EIO
> return in xfs_log_force
> 
>  Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
>  Tested-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
> ---
>  fs/xfs/xfs_log.c   | 5 ++++-
>  fs/xfs/xfs_super.c | 5 +++++
>  2 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 7f4f937..161c925 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -3002,7 +3002,10 @@ xfs_log_force(
>  
>  	trace_xfs_log_force(mp, 0);
>  	error = _xfs_log_force(mp, flags, NULL);
> -	if (error)
> +	/*
> +	 * Avoid warning when the filesystem has already shutdown.
> +	 */
> +	if (error && !XFS_FORCED_SHUTDOWN(mp))
>  		xfs_warn(mp, "%s: error %d returned.", __func__, error);
>  }
>  
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index bdaf4cb..ebafc99 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -943,6 +943,11 @@ xfs_fs_sync_fs(
>  	if (!wait)
>  		return 0;
>  
> +	if (XFS_FORCED_SHUTDOWN(mp)) {
> +		xfs_warn(mp, "Sync called: filesystem already shutdown");
> +		return XFS_ERROR(EIO);
> +	}
> +

Looks like this will keep printing error messages every time a sync() happens,
either via flusher threads or manually by user once xfs_fs_sync_fs() will
still be called for it.

I would suggest to add some static variable here to check if the filesystem has
been already shutted down before print the message again, to also avoid message
flooding due xfs_fs_sync_fs() calls although I'm not sure another people will
agree with it.

Despit my comments, this looks good for me

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

-- 
--Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
