Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Aug 2008 19:08:15 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7Q289YB014363
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2008 19:08:09 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 39A64FBBE61
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2008 19:09:32 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id z2jjpBHDieHbqICW for <xfs@oss.sgi.com>; Mon, 25 Aug 2008 19:09:32 -0700 (PDT)
Date: Tue, 26 Aug 2008 12:09:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS_BUF_ORDERED instead of XFS_BUF_ISORDERED?
Message-ID: <20080826020927.GV5706@disturbed>
References: <48B32E36.7060305@houseofnate.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B32E36.7060305@houseofnate.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Nathaniel W. Turner" <nate@houseofnate.net>
Cc: xfs@oss.sgi.com

On Mon, Aug 25, 2008 at 06:12:06PM -0400, Nathaniel W. Turner wrote:
> Hi folks,
>
> While doing a little light reading, I noticed the following in  
> fs/xfs/xfs_log.c:1011 (in the 2.6.26.3 Linux kernel tree).  Am I missing  
> something, or should XFS_BUF_ORDERED be replaced with XFS_BUF_ISORDERED  
> in this check?

Yes, it is wrong. Well spotted. I guess this shows that I was right
when I complained about needing this untestable barrier handling
code in every filesystem....

Patch below.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


XFS: Fix barrier status change detection

The current code in xlog_iodone() uses the wrong macro
to check if the barrier has been cleared due to an EOPNOTSUPP
error form the lower layer.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_log.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index ccba14e..ff2ac20 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1009,7 +1009,7 @@ xlog_iodone(xfs_buf_t *bp)
 	 * layer, it means the underlyin device no longer supports
 	 * barrier I/O. Warn loudly and turn off barriers.
 	 */
-	if ((l->l_mp->m_flags & XFS_MOUNT_BARRIER) && !XFS_BUF_ORDERED(bp)) {
+	if ((l->l_mp->m_flags & XFS_MOUNT_BARRIER) && !XFS_BUF_ISORDERED(bp)) {
 		l->l_mp->m_flags &= ~XFS_MOUNT_BARRIER;
 		xfs_fs_cmn_err(CE_WARN, l->l_mp,
 				"xlog_iodone: Barriers are no longer supported"
