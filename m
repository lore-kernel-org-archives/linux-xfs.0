Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6OBwSSp206979 for <xfs@oss.sgi.com>; Sun, 24 Jul 2011 06:58:29 -0500
Received: from mail.ud10.udmedia.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6419C1BA4EB5
	for <xfs@oss.sgi.com>; Sun, 24 Jul 2011 04:58:27 -0700 (PDT)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id cGDtRjTLMxiK4gyQ for
	<xfs@oss.sgi.com>; Sun, 24 Jul 2011 04:58:27 -0700 (PDT)
Date: Sun, 24 Jul 2011 13:58:26 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [PATCH v2] xfs: Fix wrong return value of xfs_file_aio_write
Message-ID: <20110724115826.GB1626@x4.trippels.de>
References: <1309370716-12235-1-git-send-email-josef@redhat.com>
	<20110723180942.GA1616@x4.trippels.de>
	<4E2B2E88.8080006@redhat.com>
	<20110723203824.GB1652@x4.trippels.de>
	<20110723220212.GA1648@x4.trippels.de>
	<20110724111625.GA12658@infradead.org>
	<20110724115420.GA1626@x4.trippels.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110724115420.GA1626@x4.trippels.de>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: jack@suse.cz, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, Josef Bacik <josef@redhat.com>

(This time with with a proper signoff.)


The fsync prototype change commit 02c24a82187d accidentally overwrote
the ssize_t return value of xfs_file_aio_write with 0 for SYNC type
writes. Fix this by checking if an error occured when calling
xfs_file_fsync and only change the return value in this case.
In addition xfs_file_fsync actually returns a normal negative error, so
fix this, too.

Signed-off-by: Markus Trippelsdorf <markus@trippelsdorf.de>
---
 fs/xfs/linux-2.6/xfs_file.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index cca00f4..825390e 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -881,11 +881,14 @@ xfs_file_aio_write(
 	/* Handle various SYNC-type writes */
 	if ((file->f_flags & O_DSYNC) || IS_SYNC(inode)) {
 		loff_t end = pos + ret - 1;
+		int error;
 
 		xfs_rw_iunlock(ip, iolock);
-		ret = -xfs_file_fsync(file, pos, end,
+		error = xfs_file_fsync(file, pos, end,
 				      (file->f_flags & __O_SYNC) ? 0 : 1);
 		xfs_rw_ilock(ip, iolock);
+		if (error)
+			ret = error;
 	}
 
 out_unlock:
-- 
Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
