Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n850Klox253845 for <xfs@oss.sgi.com>; Fri, 4 Sep 2009 19:20:57 -0500
Received: from coco.kroah.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3BED442BEC8
	for <xfs@oss.sgi.com>; Fri,  4 Sep 2009 17:21:22 -0700 (PDT)
Received: from coco.kroah.org (kroah.org [198.145.64.141]) by cuda.sgi.com
	with ESMTP id lJtLpJ6HvXPsaDV5 for <xfs@oss.sgi.com>;
	Fri, 04 Sep 2009 17:21:22 -0700 (PDT)
Message-Id: <20090905001455.686767014@mini.kroah.org>
Date: Fri, 04 Sep 2009 17:14:29 -0700
From: Greg KH <gregkh@suse.de>
Subject: [patch 54/71] xfs: fix spin_is_locked assert on uni-processor builds
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline;
	filename=xfs-fix-spin_is_locked-assert-on-uni-processor-builds.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
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
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com, akpm@linux-foundation.org, torvalds@linux-foundation.org, stable-review@kernel.org, alan@lxorguk.ukuu.org.uk

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Christoph Hellwig <hch@infradead.org>

upstream commit a8914f3a6d72c97328597a556a99daaf5cc288ae

Without SMP or preemption spin_is_locked always returns false,
so we can't do an assert with it.  Instead use assert_spin_locked,
which does the right thing on all builds.


Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Eric Sandeen <sandeen@sandeen.net>
Reported-by: Johannes Engel <jcnengel@googlemail.com>
Tested-by: Johannes Engel <jcnengel@googlemail.com>
Signed-off-by: Felix Blyakher <felixb@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/xfs_log.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3180,7 +3180,7 @@ try_again:
 STATIC void
 xlog_state_want_sync(xlog_t *log, xlog_in_core_t *iclog)
 {
-	ASSERT(spin_is_locked(&log->l_icloglock));
+	assert_spin_locked(&log->l_icloglock);
 
 	if (iclog->ic_state == XLOG_STATE_ACTIVE) {
 		xlog_state_switch_iclogs(log, iclog, 0);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
