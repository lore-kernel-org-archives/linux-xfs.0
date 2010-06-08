Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o580aRGG179674 for <xfs@oss.sgi.com>; Mon, 7 Jun 2010 19:36:27 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 265763A05EF
	for <xfs@oss.sgi.com>; Mon,  7 Jun 2010 17:38:58 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	2eShLUAb0g8XWOHE for <xfs@oss.sgi.com>;
	Mon, 07 Jun 2010 17:38:58 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/6] writeback: tracing and fixes V4
Date: Tue,  8 Jun 2010 10:38:01 +1000
Message-Id: <1275957487-23633-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi Linus,

Can you please consider this patch series for 2.6.35? If you don't
want the tracing at this stage of the release process, I can redo
the series with just the bug fixes. However, given the regularity
with which we break the writeback code in subtle ways, the tracing
is probably just as important as the bug fixes.

---

This series contains the initial writeback tracing patches from
Jens, as well as the extensions I added to provide visibility into
writeback control structures as the are used by the writeback code.
The visibility given is sufficient to understand what is happening
in the writeback path - what path is writing data, what path is
blocking on congestion, etc, and to determine the differences in
behaviour for different sync modes and calling contexts. This
tracing really needs to be integrated into mainline so that anyone
can improve the tracing as they use it to track down problems in our
convoluted writeback paths.

The remaining patches are fixes to problems that the new tracing
highlighted.

Version 4:
- converted strncpy to strlcpy
- remove stale information from commit message for nr_to_write fixup.

Version 3:
- added comment to tracepoint creation to explain the unusual
  placement of the tracepoint header file include.
- separated out ->writepage tracepoint addition into it's own patch.
- dropped ext4 write_cache_pages separation as it is now in mainline.
- removed ext4 tracing references to wbc->no_nrwrite_index_update as they
  weren't removed in mainline.
- fixed commit message for write_cache_pages patch
- added more information to commit message for sync hold-off fixup.

Version 2:
- included ext4 write_cache_pages separation patch from Ted Ts'o.
- moved CREATE_TRACE_POINTS into fs-writeback.c as suggested by
  Christoph Hellwig.
- moved include of trace/events/writeback.h until after structure
  definitions in fs-writeback.c
- manually revert changes made to write_cache_pages() in
  17bc6c30cf6bfffd816bdc53682dd46fc34a2cf4 that caused the
  regression.  This restores the convention that if the fs writes
  back more than a single page, it subtracts (nr_written - 1) from
  wbc->nr_to_write, as suggested by Andrew Morton.
- added patch to prevent sync from looping in write_cache_pages
  chasing a moving tail when an appending write workload is running
  concurrently with sync.

---
 fs/fs-writeback.c                |   50 ++++++--
 fs/xfs/linux-2.6/xfs_aops.c      |    8 --
 include/linux/writeback.h        |    9 --
 include/trace/events/ext4.h      |    5 +-
 include/trace/events/writeback.h |  252 ++++++++++++++++++++++++++++++++++++++
 mm/backing-dev.c                 |    3 +
 mm/page-writeback.c              |   35 ++++--
 7 files changed, 321 insertions(+), 41 deletions(-)


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
