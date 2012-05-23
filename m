Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4N9S0ow128298 for <xfs@oss.sgi.com>; Wed, 23 May 2012 04:28:00 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	5rcPPuYsWYHRSoET for <xfs@oss.sgi.com>;
	Wed, 23 May 2012 02:27:59 -0700 (PDT)
Date: Wed, 23 May 2012 19:27:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/10] xfs: discontiguous buffer support a.k.a. die
	xfs_dabuf die
Message-ID: <20120523092746.GM25351@dastard>
References: <1335249220-22274-1-git-send-email-david@fromorbit.com>
	<20120516174042.GJ16099@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120516174042.GJ16099@sgi.com>
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

On Wed, May 16, 2012 at 12:40:42PM -0500, Ben Myers wrote:
> Hey Dave,
> 
> Looks like there are some additional test failures due to this patchset.  Here
> some output from a bisect I did yesterday, running only the tests which failed
> on the machine where I noticed this.

So what the configuration you are testing on here?

....
> 
> # git describe
> v3.4-rc2-54-g1307bbd

That's mostly meaningless to me - you've got a 3.4-rc2 kernel with
54 local commits in it.

> from patches/series:
> # normal: (there's my baseline on this machine.  I noticed a larger number of test failures on another test box and brought that series over here)
> #Failures: 030 178 230 231 232 233 250 274
> #Failed 8 of 198 tests
......
> 
> xfs-fix-delalloc-quota-accounting-on-failure.patch
> xfs-fix-memory-reclaim-deadlock-on-agi-buffer.patch
> xfs-add-trace-points-for-log-forces.patch
> xfs-separate-buffer-indexing-from-block-map.patch
> xfs-convert-internal-buffer-functions-to-pass-maps.patch
> xfs-add-discontiguous-buffer-map-interface.patch
> xfs-add-discontiguous-buffer-support-to-transactions.patch
> 
> # ^^^ bisect 1, went ok.  
> #    030 050 085 086 087 121 128 179 182 200 230 231 232 233 235
> #    Failures: 030 230 231 232 233
> #    Failed 5 of 15 tests


> # ^^^ bisect 4, making sure it's good
> #Ran: 030 050 085 086 087 121 128 179 182 200 230 231 232 233 235
> #Failures: 030 230 231 232 233
> #Failed 5 of 15 tests
> 
> xfs-struct-xfs_buf_log_format-isn-t-variable-sized.patch
> 
> # ^^^ bisect 5, crashed.  (consistently)
> 
> xfs-support-discontiguous-buffers-in-the.patch
> 
> # ^^^ bisect 6
> #Ran: 030 050 085 086 087 121 128 179 182 200 230 231 232 233 235
> #Failures: 030 085 086 087 121 179 182 200 230 231 232 233
> #Failed 12 of 15 tests

So, 085 086 087 121 179 182 200 are all log recovery tests.....

So what are the failures? This doesn't tell me anything about why
these have failed, and the last set of test runs I did before
posting this series showed:

Failures: 030 050 073 249 250 263
Failed 6 of 197 tests

Which is standard for my 4k filesystem block size testing.

> Looks like there is a problem in
> xfs-struct-xfs_buf_log_format-isn-t-variable-sized.patch,

Given the crashes, this is the likely cause of the problem.
Especially as the version of the patch in this series is missing a
critical hunk compared to the local patch I have been testing which
would cause memcpy() to fall off the end of allocated memory
buffers....

--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -240,15 +240,14 @@ xfs_buf_item_format(
               (bip->bli_flags & XFS_BLI_STALE));
 
        /*
-        * The size of the base structure is the size of the
-        * declared structure plus the space for the extra words
-        * of the bitmap.  We subtract one from the map size, because
-        * the first element of the bitmap is accounted for in the
-        * size of the base structure.
+        * Base size is the actual size of the ondisk structure - it reflects
+        * the actual size of the dirty bitmap rather than the size of the in
+        * memory structure. The xfs_buf_log_format size is the maximum,
+        * subtract the unused part of the bitmap from it.
         */
-       base_size =
-               (uint)(sizeof(xfs_buf_log_format_t) +
-                      ((bip->bli_format.blf_map_size - 1) * sizeof(uint)));
+       base_size = sizeof(struct xfs_buf_log_format) -
+                   ((XFS_BLF_DATAMAP_SIZE - bip->bli_format.blf_map_size) *
+                                                               sizeof(uint));
        vecp->i_addr = &bip->bli_format;
        vecp->i_len = base_size;
        vecp->i_type = XLOG_REG_TYPE_BFORMAT;


I'll retest the series and repost it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
