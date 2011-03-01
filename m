Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p216umQT183209 for <xfs@oss.sgi.com>; Tue, 1 Mar 2011 00:56:48 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9F3AA30603E
	for <xfs@oss.sgi.com>; Mon, 28 Feb 2011 22:59:37 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id dbKcQFxzXVTIYBj2 for <xfs@oss.sgi.com>;
	Mon, 28 Feb 2011 22:59:37 -0800 (PST)
Message-ID: <4D6C9958.2040607@sandeen.net>
Date: Tue, 01 Mar 2011 00:59:36 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] xfs: zero proper structure size for geometry calls
References: <4D6C28A5.60905@mnsu.edu> <4D6C4DEE.6020902@sandeen.net>
In-Reply-To: <4D6C4DEE.6020902@sandeen.net>
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
To: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, Eugene Teo <eugeneteo@kernel.org>, xfs@oss.sgi.com

commit 493f3358cb289ccf716c5a14fa5bb52ab75943e5 added:

+       memset(geo, 0, sizeof(*geo)); 

but unfortunately we're dealing with a cast pointer here, and
the caller may actually have a smaller structure on the stack.
Zeroing out more leads to stack corruption traps:

Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: f87aca93

Pid: 262, comm: xfs_fsr Not tainted 2.6.38-rc6-493f3358cb2+ #1
Call Trace:

[<c12991ac>] ? panic+0x50/0x150
[<c102ed71>] ? __stack_chk_fail+0x10/0x18
[<f87aca93>] ? xfs_ioc_fsgeometry_v1+0x56/0x5d [xfs] 

Fix this by zeroing out the structure in the callers, where we know
the actual size.

Reported-by: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Use sizeof (variable) not sizeof (type)

diff --git a/fs/xfs/linux-2.6/xfs_ioctl.c b/fs/xfs/linux-2.6/xfs_ioctl.c
index f5e2a19..871e5f0 100644
--- a/fs/xfs/linux-2.6/xfs_ioctl.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -698,6 +698,7 @@ xfs_ioc_fsgeometry_v1(
 	xfs_fsop_geom_v1_t	fsgeo;
 	int			error;
 
+	memset(&fsgeo, 0, sizeof(fsgeo));
 	error = xfs_fs_geometry(mp, (xfs_fsop_geom_t *)&fsgeo, 3);
 	if (error)
 		return -error;
@@ -715,6 +716,7 @@ xfs_ioc_fsgeometry(
 	xfs_fsop_geom_t		fsgeo;
 	int			error;
 
+	memset(&fsgeo, 0, sizeof(fsgeo));
 	error = xfs_fs_geometry(mp, &fsgeo, 4);
 	if (error)
 		return -error;
diff --git a/fs/xfs/linux-2.6/xfs_ioctl32.c b/fs/xfs/linux-2.6/xfs_ioctl32.c
index b3486df..f25d38e 100644
--- a/fs/xfs/linux-2.6/xfs_ioctl32.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl32.c
@@ -73,6 +73,7 @@ xfs_compat_ioc_fsgeometry_v1(
 	xfs_fsop_geom_t		  fsgeo;
 	int			  error;
 
+	memset(&fsgeo, 0, sizeof(fsgeo));
 	error = xfs_fs_geometry(mp, &fsgeo, 3);
 	if (error)
 		return -error;
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 85668ef..cec89dd 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -53,9 +53,6 @@ xfs_fs_geometry(
 	xfs_fsop_geom_t		*geo,
 	int			new_version)
 {
-
-	memset(geo, 0, sizeof(*geo));
-
 	geo->blocksize = mp->m_sb.sb_blocksize;
 	geo->rtextsize = mp->m_sb.sb_rextsize;
 	geo->agblocks = mp->m_sb.sb_agblocks;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
