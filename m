Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAN0g6Yc182918 for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 18:42:07 -0600
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 220E826FB6E
	for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 16:42:05 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id kWCn2cQdyVPWncE6 for <xfs@oss.sgi.com>;
	Tue, 22 Nov 2011 16:42:05 -0800 (PST)
Message-Id: <20111123002408.631967363@clark.kroah.org>
Date: Tue, 22 Nov 2011 16:23:50 -0800
From: Greg KH <gregkh@suse.de>
Subject: [43/53] xfs: fix error handling for synchronous writes
In-Reply-To: <20111123002419.GA8531@kroah.com>
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
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>, akpm@linux-foundation.org, Ajeet Yadav <ajeet.yadav.77@gmail.com>, torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@infradead.org>

If removed storage while synchronous buffer write underway,
"xfslogd" hangs.

Detailed log http://oss.sgi.com/archives/xfs/2011-07/msg00740.html

Related work bfc60177f8ab509bc225becbb58f7e53a0e33e81
"xfs: fix error handling for synchronous writes"

Given that xfs_bwrite actually does the shutdown already after
waiting for the b_iodone completion and given that we actually
found that calling xfs_force_shutdown from inside
xfs_buf_iodone_callbacks was a major contributor the problem
it better to drop this call.

Signed-off-by: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/xfs/xfs_buf_item.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1023,7 +1023,6 @@ xfs_buf_iodone_callbacks(
 	XFS_BUF_UNDELAYWRITE(bp);
 
 	trace_xfs_buf_error_relse(bp, _RET_IP_);
-	xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
 
 do_callbacks:
 	xfs_buf_do_callbacks(bp);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
