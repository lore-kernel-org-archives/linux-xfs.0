Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1EDgxEQ134547 for <xfs@oss.sgi.com>; Mon, 14 Feb 2011 07:43:00 -0600
Received: from mx1.vsecurity.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6407015621D7
	for <xfs@oss.sgi.com>; Mon, 14 Feb 2011 05:45:32 -0800 (PST)
Received: from mx1.vsecurity.com (mx1.vsecurity.com [209.67.252.12]) by
	cuda.sgi.com with ESMTP id wEHGeEfxccVKgReC for
	<xfs@oss.sgi.com>; Mon, 14 Feb 2011 05:45:32 -0800 (PST)
Subject: [PATCH v2] xfs: prevent leaking uninitialized stack memory in
	FSGEOMETRY_V1
From: Dan Rosenberg <drosenberg@vsecurity.com>
In-Reply-To: <20110214114629.GA13052@dastard>
References: <1297347904.13370.9.camel@dan>  <20110214114629.GA13052@dastard>
Date: Mon, 14 Feb 2011 08:45:28 -0500
Message-ID: <1297691128.1857.4.camel@dan>
Mime-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>, aelder@sgi.com, xfs-masters@oss.sgi.com, xfs@oss.sgi.com
Cc: security@kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org

The FSGEOMETRY_V1 ioctl (and its compat equivalent) calls out to
xfs_fs_geometry() with a version number of 3.  This code path does not
fill in the logsunit member of the passed xfs_fsop_geom_t, leading to
the leaking of four bytes of uninitialized stack data to potentially
unprivileged callers.

v2 switches to memset() to avoid future issues if structure members
change, on suggestion of Dave Chinner.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
---
 fs/xfs/xfs_fsops.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index cec89dd..85668ef 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -53,6 +53,9 @@ xfs_fs_geometry(
 	xfs_fsop_geom_t		*geo,
 	int			new_version)
 {
+
+	memset(geo, 0, sizeof(*geo));
+
 	geo->blocksize = mp->m_sb.sb_blocksize;
 	geo->rtextsize = mp->m_sb.sb_rextsize;
 	geo->agblocks = mp->m_sb.sb_agblocks;


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
