Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 92EAE29DF8
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2014 15:54:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2E912AC002
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2014 13:54:25 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	GUA6rXPkceo3PbaS for <xfs@oss.sgi.com>;
	Mon, 28 Apr 2014 13:54:23 -0700 (PDT)
Date: Tue, 29 Apr 2014 06:54:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: test for shut down fs in xfs_dir_fsync()
Message-ID: <20140428205420.GB18672@dastard>
References: <535E8344.2070209@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <535E8344.2070209@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Boris Ranto <branto@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Apr 28, 2014 at 11:35:16AM -0500, Eric Sandeen wrote:
> Similar to xfs_file_fsync(), I think xfs_dir_fsync() needs
> to test for a shut down fs, lest we go down paths we'll
> never be able to complete; Boris reported that during some
> stress tests he had threads stuck in xlog_cil_force_lsn
> via xfs_dir_fsync().
> 
> [ 3663.361709] sfsuspend-par   D ffff88042f0b4540     0  3981   3947 0x00000080
> 
> [ 3663.394472] Call Trace:
> [ 3663.397199]  [<ffffffff815f1889>] schedule+0x29/0x70
> [ 3663.402743]  [<ffffffffa01feda5>] xlog_cil_force_lsn+0x185/0x1a0 [xfs]
> [ 3663.416249]  [<ffffffffa01fd3af>] _xfs_log_force_lsn+0x6f/0x2f0 [xfs]
> [ 3663.429271]  [<ffffffffa01a339d>] xfs_dir_fsync+0x7d/0xe0 [xfs]
> [ 3663.435873]  [<ffffffff811df8c5>] do_fsync+0x65/0xa0
> [ 3663.441408]  [<ffffffff811dfbc0>] SyS_fsync+0x10/0x20
> [ 3663.447043]  [<ffffffff815fc7d9>] system_call_fastpath+0x16/0x1b

Wow, I believe it's taken this long for us to notice that we can't
break out of xlog_cil_force_lsn() if we fail on xlog_write()
from a CIL push.

I'd say that xlog_cil_force_lsn() needs log shutdown checks before
it goes to sleep in xlog_wait()....

> Reported-by: Boris Ranto <branto@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> NB: While I've not asked Boris to test this yet, it seems
> clear (?) that dir_fsync should behave the same as
> file_fsync() in the face of a shut-down fs.
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 4c749ab..2b94362 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -146,6 +146,9 @@ xfs_dir_fsync(
>  
>  	trace_xfs_dir_fsync(ip);
>  
> +	if (XFS_FORCED_SHUTDOWN(mp))
> +		return -XFS_ERROR(EIO);
> +

That won't hurt, but it won't fix the problem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
