Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0J0Tjps141434 for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 18:29:46 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8A2D611F8B49
	for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 16:30:44 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	TSfjKlHmeFgInpUl for <xfs@oss.sgi.com>;
	Mon, 18 Jan 2010 16:30:44 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11706924-1927428
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 11:00:43 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NX1zW-0003Dy-Io
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 11:30:42 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NX1zL-0003W9-UI
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 11:30:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/8] xfs: xfs_buf_iomove() doesn't care about signedness
Date: Tue, 19 Jan 2010 11:30:23 +1100
Message-Id: <1263861026-13448-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1263861026-13448-1-git-send-email-david@fromorbit.com>
References: <1263861026-13448-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

xfs_buf_iomove() uses xfs_caddr_t as it's parameter types, but it doesn't
care about the signedness of the variables as it is just copying the
data. Change the prototype to use void * so that we don't get sign
warnings at call sites.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |    2 +-
 fs/xfs/linux-2.6/xfs_buf.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 158fad4..efd745b 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -1443,7 +1443,7 @@ xfs_buf_iomove(
 	xfs_buf_t		*bp,	/* buffer to process		*/
 	size_t			boff,	/* starting buffer offset	*/
 	size_t			bsize,	/* length to copy		*/
-	caddr_t			data,	/* data address			*/
+	void			*data,	/* data address			*/
 	xfs_buf_rw_t		mode)	/* read/write/zero flag		*/
 {
 	size_t			bend, cpoff, csize;
diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index 9a29d18..4f2ad66 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -243,7 +243,7 @@ extern void xfs_buf_ioend(xfs_buf_t *,	int);
 extern void xfs_buf_ioerror(xfs_buf_t *, int);
 extern int xfs_buf_iorequest(xfs_buf_t *);
 extern int xfs_buf_iowait(xfs_buf_t *);
-extern void xfs_buf_iomove(xfs_buf_t *, size_t, size_t, xfs_caddr_t,
+extern void xfs_buf_iomove(xfs_buf_t *, size_t, size_t, void *,
 				xfs_buf_rw_t);
 
 static inline int xfs_buf_iostrategy(xfs_buf_t *bp)
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
