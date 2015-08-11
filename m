Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8A6327F61
	for <xfs@oss.sgi.com>; Tue, 11 Aug 2015 17:50:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 738E08F8039
	for <xfs@oss.sgi.com>; Tue, 11 Aug 2015 15:50:01 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	EaZIznipe6MEHH9r for <xfs@oss.sgi.com>;
	Tue, 11 Aug 2015 15:49:59 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1ZPIMh-0005YL-2g
	for xfs@oss.sgi.com; Wed, 12 Aug 2015 08:49:51 +1000
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1ZPIMh-0004Oy-1x
	for xfs@oss.sgi.com; Wed, 12 Aug 2015 08:49:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 8/8] xfs: bufferheads are not needed in ->writepage
Date: Wed, 12 Aug 2015 08:49:48 +1000
Message-Id: <1439333388-16452-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1439333388-16452-1-git-send-email-david@fromorbit.com>
References: <1439333388-16452-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

TO get rid of bufferheads from the writepage path, we have to get
rid of the bufferhead chaining that is done in the ioends to keep
track of the blocks under IO. We also mark the page clean indirectly
through bufferhead IO completion callbacks.

To move away from bufferheads, we need to track bios rather than
bufferheads, and on ioend completion we need to mark pages clean
directly. This makes it "interesting" for filesystems with sub-page
block size, because the bufferheads are used to track sub-page dirty
state. That is, only when all the bufferheads are clean is the page
marked clean. For now, we will ignore the sub-page block
size problem and address the block size = page size configuration
first. Once the bio/page handling infrastructure is in place we can
add support of sub-page block sizes.

Right now an xfs_ioend tracks a sequential region via a bufferhead
chain that is, at IO submission, converted to bios and then
submitted. A single xfs_ioend may require multiple bios to be
submitted, and so the ioend keeps a reference count of the number of
bios it needs completions from before it can process the IO
completion of the bufferhead chain across that region.

As such, we have a dual layer IO submission/completion process.
Assumming block size = page size, what we have is this:

pages		+-+-+-+-+-+-+-+-+-+
bufferhead	+-+-+-+-+-+-+-+-+-+
xfs_ioend	+eeeeeee+eeeeeeeee+
bios		+bbb+bbb+bbbbbb+bb+

So IO submission looks like:

	- .writepage is given a page
	- XFS creates an ioend or pulls the existing one from the
	  writepage context,
	- XFS walks the bufferheads on the page and adds the
	  bufferheads to it.
	- XFS will chains ioends together when some kind of IO
	  discontiguity occurs
	- When all the page walks are complete, XFS "submits" the
	  ioend
	- XFS walks the bufferheads, marking them as under async
	  writeback
	- XFS walks the bufferheads again, building bios from the
	  pages backing the bufferheads. When bios are too large to
	  have more pages added to them or there is a discontinuity
	  in the IO mapping, the bio is submitted and anew one is
	  started.

On IO completion:

	- xfs grabs the ioend from the bio, drops the bio and
	  decrements the reference count on the ioend.
	- ioend reference count goes to zero, runs endio callbacks
	  (e.g. size update, unwritten extent conversion).
	- ioend is destroyed
	- destroy walks bufferhead chain on ioend, calling
	  bufferhead IO completion
	- bufferhead IO completion calls page_end_writeback
	  appropriately.

IOWs, the xfs_ioend is really a mapping layer between bufferheads
and bios, and the bufferheads kind of hide us from pages in the
IO submission path.

To get rid of bufferheads, we have to get rid of the dependency on
bufferhead chaining for building bios and marking pages clean on IO
completion. What we really want is this:

pages		+-+-+-+-+-+-+-+-+-+
xfs_ioend	+eeeeeee+eeeeeeeee+
bios		+bbb+bbb+bbbbbb+bb+

And for us to be able to hold on to the bios being completed until
they are all done before we start ioend processing. It looks like we
can use chaining via the bi_private field (i.e. a single linked
list) to attach all the bios to the ioend prior to submission, we
replace that with a reference count and apointer to the ioend during
submission, and then rebuild the chain during IO completion.  We
then don't drop the bio references until we destroy the ioend, after
we've walked all the pages held by the bios and ended writeback on
them.

This will also handle sub-page block sizes that may require multiple
bios to clean a page as long as submission always creates page
granularity ioends.

Hence IO submission should look like:

	- .writepage is given a page
	- XFS creates an ioend or pulls the existing one from the
	  writepage context
	- XFS grabs the iomap from from the wpc or gets a new one
	- XFS checks page is adjacent to previous. Yes, checks
	  mapping is valid.  No to either, grabs new iomap, create
	  new bio, chain bio to ioend.  Then add page to bio,
	  mark page as under io.
	- When all the page walks are complete, XFS "submits" the
	  ioend
	- XFS walks the bio chain, removing them, taking references
	  to the ioend, bi_private = ioend, and then submitting i
	  them in order.

On IO completion:

	- xfs grabs the ioend for the bio, chains the bio back to
	  the ioend. Stashes the error in the ioend. drops the
	  refernce to the ioend.
	- ioend reference count goes to zero, runs endio callbacks
	  (e.g. size update, unwritten extent conversion).
	- ioend is destroyed
	- destroy walks the bio chain, calling page_end_writeback()
	  on the pages within, dropping bio references to free them.

Simples, yes?

In a few patches time, writepage will no longer have any bufferheads
in it. However, until we get rid of bufferheads completely, we still
need to make sure their state reflects the page state. Hence as a
stop-gap measure, the ioend bio submission and destruction will need
to walk the buffers on the pages and change their state
appropriately. This will be a wart on the side that will get removed
when bufferheads are removed from the other buffered IO paths in
XFS.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_aops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 08a0205..e52eb0e 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -36,6 +36,7 @@
 #include <linux/pagevec.h>
 #include <linux/writeback.h>
 
+
 /*
  * structure owned by writepages passed to individual writepage calls
  */
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
