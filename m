Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4GHaCWg031939 for <xfs@oss.sgi.com>; Wed, 16 May 2012 12:36:13 -0500
Date: Wed, 16 May 2012 12:40:42 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 00/10] xfs: discontiguous buffer support a.k.a. die
	xfs_dabuf die
Message-ID: <20120516174042.GJ16099@sgi.com>
References: <1335249220-22274-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1335249220-22274-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hey Dave,

Looks like there are some additional test failures due to this patchset.  Here
some output from a bisect I did yesterday, running only the tests which failed
on the machine where I noticed this.

# git describe
v3.4-rc2-54-g1307bbd

from patches/series:
# normal: (there's my baseline on this machine.  I noticed a larger number of test failures on another test box and brought that series over here)
#Failures: 030 178 230 231 232 233 250 274
#Failed 8 of 198 tests

xfs-fix-delalloc-quota-accounting-on-failure.patch
xfs-fix-memory-reclaim-deadlock-on-agi-buffer.patch
xfs-add-trace-points-for-log-forces.patch
xfs-separate-buffer-indexing-from-block-map.patch
xfs-convert-internal-buffer-functions-to-pass-maps.patch
xfs-add-discontiguous-buffer-map-interface.patch
xfs-add-discontiguous-buffer-support-to-transactions.patch

# ^^^ bisect 1, went ok.  
#    030 050 085 086 087 121 128 179 182 200 230 231 232 233 235
#    Failures: 030 230 231 232 233
#    Failed 5 of 15 tests

# ^^^ bisect 4, making sure it's good
#Ran: 030 050 085 086 087 121 128 179 182 200 230 231 232 233 235
#Failures: 030 230 231 232 233
#Failed 5 of 15 tests

xfs-struct-xfs_buf_log_format-isn-t-variable-sized.patch

# ^^^ bisect 5, crashed.  (consistently)

xfs-support-discontiguous-buffers-in-the.patch

# ^^^ bisect 6
#Ran: 030 050 085 086 087 121 128 179 182 200 230 231 232 233 235
#Failures: 030 085 086 087 121 179 182 200 230 231 232 233
#Failed 12 of 15 tests

xfs-use-multiple-irec-xfs-buf-support-in-dabuf.patch

# ^^^ bisect 3, (still no good)
#Ran: 030 050 085 086 087 121 128 179 182 200 230 231 232 233 235
#Failures: 030 085 086 087 121 179 182 200 230 231 232 233
#Failed 12 of 15 tests

#xfs-remove-struct-xfs_dabuf-and-infrastructure.patch
#xfs-factor-buffer-reading-from-xfs_dir2_leaf_getdents.patch
#fs-xfs-xfs_dinode.h-fix-comments-of-xfs_dinode_t.patch
#fix-wrong-flag-assert-in-xfs_attr_shortform_getvalue.patch

# ^^^ bisect 2, not good (I ran only the tests which failed on the other test box)
#    030 050 085 086 087 121 128 179 182 200 230 231 232 233 235
#    Failures: 030 085 086 087 121 179 182 200 230 231 232 233
#    Failed 12 of 15 tests

Looks like there is a problem in
xfs-struct-xfs_buf_log_format-isn-t-variable-sized.patch,
and/or
xfs-support-discontiguous-buffers-in-the.patch.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
