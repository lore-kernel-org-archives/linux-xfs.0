Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA33Etnv234295 for <xfs@oss.sgi.com>; Fri, 2 Nov 2012 22:14:55 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	QfSRwPHx2REz7A5m for <xfs@oss.sgi.com>;
	Fri, 02 Nov 2012 20:16:47 -0700 (PDT)
Date: Sat, 3 Nov 2012 14:16:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: status of userspace release
Message-ID: <20121103031644.GG29378@dastard>
References: <20121025151501.GV1377@sgi.com> <20121102055102.GY29378@dastard>
	<20121102185923.GG9783@sgi.com> <20121102230334.GA29378@dastard>
	<20121103001639.GD29378@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121103001639.GD29378@dastard>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Sat, Nov 03, 2012 at 11:16:39AM +1100, Dave Chinner wrote:
> I say this, because this is the first thing I noticed when having a
> look at a test 287 failure:
> 
> 7 10s ... - output mismatch (see 287.out.bad)
> --- 287.out     2012-10-05 11:38:08.000000000 +1000
> +++ 287.out.bad 2012-11-03 10:55:15.000000000 +1100
> @@ -2,22 +2,24 @@
>  No 32bit project quotas:
>  projid = 1234
>  projid = 0
> +xfs_quota: cannot set project on /mnt/scratch/pquota/32bit: Invalid argument
>  With 32bit project quota support:
>  projid = 1234
> -projid = 2123456789
> +projid = 0
> +xfs_quota: cannot set project on /mnt/scratch/restore/pquota/32bitv2: Invalid argument
>  The restored file system + one additional file:
>  projid = 1234
> -projid = 2123456789
> -projid = 2123456789
> +projid = 0
> +projid = 0
>  These two values of 16bit project quota ids shall be the same
> -core.projid_lo = 1234
> +core.projid_lo = 0
>  core.projid_hi = 0
>  core.projid_lo = 1234
>  core.projid_hi = 0
>  These three values of 32bit project quota ids shall be the same
> -core.projid_lo = 24853
> -core.projid_hi = 32401
> -core.projid_lo = 24853
> -core.projid_hi = 32401
> -core.projid_lo = 24853
> -core.projid_hi = 32401
> +core.projid_lo = 0
> +core.projid_hi = 0
> +core.projid_lo = 0
> +core.projid_hi = 0
> +core.projid_lo = 0
> +core.projid_hi = 0
> 
> Here's what's curious - this is failing on the 17TB filesystem, but
> is not failing on 10-20GB filesystems. There seems to be a pattern
> here....

This is caused by a longstanding bug in xfs_db. The fix below should
be included in the release, I think...

Cheers,

Dave
-- 
Dave Chinner
david@fromorbit.com

xfs_db: flush devices before exiting

From: Dave Chinner <dchinner@redhat.com>

Test 287 uses xfs_db to change 32-bit project ID support while the
filesystem is unmounted. On a large filesystem the test was failing
due to the mount not seeing the feature bit in the superblock.

xfs_db uses a different address space to the filesystem when it is
mounted by the kernel, so the only way to keep them coherent is to
ensure that all buffered data is written to disk before the other
entity tries to read it. xfs_db uses buffered IO, but does not close
the devices when it exits, thereby leaving changes it has written in
the block device cache rather than on disk. Hence when the kernel
tries to mount the filesystem, it reads what is on disk and does not
see xfs_db's changes.

Fix this by ensuring that xfs_db flushes it's changes to disk before
it exits by caling libxfs_device_close(). This fsyncs the data and
flushes the caches to ensure that it is present on disk before
xfs_db exits.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/init.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/db/init.c b/db/init.c
index 2a5ef2b..2a31cb8 100644
--- a/db/init.c
+++ b/db/init.c
@@ -170,7 +170,7 @@ main(
 	}
 	if (cmdline) {
 		xfree(cmdline);
-		return exitcode;
+		goto close_devices;
 	}
 
 	while (!done) {
@@ -181,5 +181,13 @@ main(
 			done = command(c, v);
 		doneline(input, v);
 	}
+
+close_devices:
+	if (x.ddev)
+		libxfs_device_close(x.ddev);
+	if (x.logdev && x.logdev != x.ddev)
+		libxfs_device_close(x.logdev);
+	if (x.rtdev)
+		libxfs_device_close(x.rtdev);
 	return exitcode;
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
