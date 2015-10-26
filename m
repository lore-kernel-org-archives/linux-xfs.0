Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2E8817F67
	for <xfs@oss.sgi.com>; Mon, 26 Oct 2015 01:53:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C1704AC002
	for <xfs@oss.sgi.com>; Sun, 25 Oct 2015 23:53:42 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id ORKbvqge6sbhhmE5 (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 25 Oct 2015 23:53:40 -0700 (PDT)
Date: Mon, 26 Oct 2015 15:53:40 +0900 (KST)
From: Jiri Kosina <jikos@kernel.org>
Subject: [PATCH] xfs: clear PF_NOFREEZE for xfsaild kthread
Message-ID: <alpine.LNX.2.00.1510261552160.8998@pobox.suse.cz>
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

From: Jiri Kosina <jkosina@suse.cz>

Since xfsaild has been converted to kthread in 0030807c, it calls 
try_to_freeze() during every AIL push iteration. It however doesn't set 
itself as freezable, and therefore this try_to_freeze() will never do 
anything.

Before (hopefully eventually) kthread freezing gets converted to fileystem 
freezing, we'd rather mark xfsaild freezable (as it can generate I/O 
during suspend).

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 fs/xfs/xfs_trans_ail.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 1098cf4..06d1a29 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -497,6 +497,7 @@ xfsaild(
 	long		tout = 0;	/* milliseconds */
 
 	current->flags |= PF_MEMALLOC;
+	set_freezable();
 
 	while (!kthread_should_stop()) {
 		if (tout && tout <= 20)
-- 
Jiri Kosina
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
