Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AE1387CA0
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 12:40:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 11E8CAC005
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 10:40:18 -0700 (PDT)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com
	[74.125.82.53]) by cuda.sgi.com with ESMTP id DacamuThv0oMQB3v
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 12 Apr 2016 10:40:15 -0700 (PDT)
Received: by mail-wm0-f53.google.com with SMTP id u206so37847586wme.1
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 10:40:15 -0700 (PDT)
From: Shyam Kaushik <shyam@zadarastorage.com>
References: <23e35813cb097c7b15686852500cbf97@mail.gmail.com>
	<20160412082759.GI9088@dastard>
In-Reply-To: <20160412082759.GI9088@dastard>
MIME-Version: 1.0
Date: Tue, 12 Apr 2016 23:10:13 +0530
Message-ID: <5e9c99552ae829dce9eb574d72085323@mail.gmail.com>
Subject: RE: [PATCH] xfs: Abort intent log item in xfs_iflush() upon error to
	get buf
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
Cc: xfs@oss.sgi.com

Hi Dave,

Your patch needs a minor correction.

At start of xfs_iflush() either we must initialize "bp = NULL" or else
xfs_imap_to_bp() when it hits an error need to set "*bpp = NULL".
Otherwise with your patch we are having an uninitialized bp that
corrupt_out is trying to do xfs_buf_relse().

I included the above minor change & confirmed your patch works great. So
pls go ahead & formalize it. Thanks!

--Shyam

-----Original Message-----
From: Dave Chinner [mailto:david@fromorbit.com]
Sent: 12 April 2016 13:58
To: Shyam Kaushik
Cc: xfs@oss.sgi.com
Subject: Re: [PATCH] xfs: Abort intent log item in xfs_iflush() upon error
to get buf

On Tue, Apr 12, 2016 at 12:27:30PM +0530, Shyam Kaushik wrote:
> Looking at xfs_iflush(). If an IO fails, it is supposed to unlock the
> inode by calling xfs_iflush_abort(), which will also remove it from
> the AIL. This can also happen on reclaim of a dirty inode, and if so
> we'll still reclaim the inode because reclaim assumes xfs_iflush()
> cleans up properly. Which, apparently, it doesn't.
>
> Fix xfs_iflush() buf get failure to remove intent log item.
>
> Discovered-by: Dave Chinner <dchinner at redhat.com>
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 96f606d..85414a6 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3374,8 +3374,9 @@ xfs_iflush(
>         error = xfs_imap_to_bp(mp, NULL, &ip->i_imap, &dip, &bp,
> XBF_TRYLOCK,
>                                0);
>         if (error || !bp) {
> -               xfs_ifunlock(ip);
> -               return error;
> +               if (!bp)
> +                       error = -EIO;
> +               goto abort_out;

So that will trigger a failure whenever the underlying buffer is
busy (i.e. returns -EAGAIN with bp NULL), not just when an IO
or corruption error occurs. The hammer is too big. ;)

Great proof of concept, though, as your testing results tell us you
have found the root cause of the bug. The patch I wrote earlier
today takes the EAGAIN case into account - I'm currently testing it,
and have attached it below. Can you run it through your error
testing, please, Shyam?

I'll update all the reported-by, etc attributions before I post it
for proper review.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: xfs_iflush_cluster fails to abort on error

From: Dave Chinner <dchinner@redhat.com>

When a failure due to an inode buffer occurs, the error handling
fails to abort the inode writeback correctly. This can result in the
inode being reclaimed whilst still in the AIL, leading to
use-after-free situations as well as filesystems that cannot be
unmounted as the inode log items left in the AIL never get removed.

Fix this by ensuring fatal errors from xfs_imap_to_bp() result in
the inode flush being aborted correctly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 5b84bbc..e1a8020 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3378,14 +3378,22 @@ xfs_iflush(
 	}

 	/*
-	 * Get the buffer containing the on-disk inode.
+	 * Get the buffer containing the on-disk inode. We are doing a
try-lock
+	 * operation here, so we may get  an EAGAIN error. In that case,
we
+	 * simply want to return with the inode still dirty.
+	 *
+	 * If we get any other error, we effectively have a corruption
situation
+	 * and we cannot flush the inode, so we treat it the same as
failing
+	 * xfs_iflush_int().
 	 */
 	error = xfs_imap_to_bp(mp, NULL, &ip->i_imap, &dip, &bp,
XBF_TRYLOCK,
 			       0);
-	if (error || !bp) {
+	if (error == -EAGAIN) {
 		xfs_ifunlock(ip);
 		return error;
 	}
+	if (error)
+		goto corrupt_out;

 	/*
 	 * First flush out the inode that xfs_iflush was called with.
@@ -3413,7 +3421,8 @@ xfs_iflush(
 	return 0;

 corrupt_out:
-	xfs_buf_relse(bp);
+	if (bp)
+		xfs_buf_relse(bp);
 	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 cluster_corrupt_out:
 	error = -EFSCORRUPTED;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
