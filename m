Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 22 Oct 2008 19:51:59 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9N2pn8b019857
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 19:51:51 -0700
From: Niv Sardi <xaiki@sgi.com>
Subject: Re: [PATCH, RFC] Re: atime not written to disk
In-Reply-To: <20081022081710.GL18495@disturbed> (Dave Chinner's message of
	"Wed, 22 Oct 2008 19:17:10 +1100")
References: <48FD74CC.907@sgi.com> <48FD7B69.3090600@wm.jp.nec.com>
	<20081022081710.GL18495@disturbed>
Date: Thu, 23 Oct 2008 13:53:23 +1100
Message-ID: <ncctzb4nhss.fsf@itchy.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Utako Kusaka <u-kusaka@wm.jp.nec.com>
Cc: Timothy Shimmin <tes@sgi.com>, xfs <xfs@oss.sgi.com>

--=-=-=

Dave Chinner <david@fromorbit.com> writes:
[...]
> As I mentioned on IRC, Tim, the following patch fixes the above test
> case. It will make XFS behave like other filesystems w.r.t. atime,
> instead of defaulting to relatime-like behaviour. This will have
> performance impact unless ppl now add the relatime mount option.
 ^^^^^^^^^^^^^^^^^^^

I don't really like it, and don't think there is a real justification to
do it. Why not only do:


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline;
 filename=0001-Mark-core-as-dirty-when-atime-updated-needed-for-XFS.patch

>From 96be907a11f2cad0d6c8696737bb144b1275ce5a Mon Sep 17 00:00:00 2001
From: Niv Sardi <xaiki@debian.org>
Date: Thu, 23 Oct 2008 13:41:09 +1100
Subject: [PATCH] Mark core as dirty when atime updated needed for XFS inode

Currently we're not writting atime updates back to disk on unmount
if it's the only change that happened. One solution would be to implement
->dirty_inode() but that might be overkill and has a perf hit, instead
just tag as needed for update in reclaim()

Signed-off-by: Niv Sardi <xaiki@debian.org>
---
 fs/xfs/xfs_vnodeops.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index e257f65..828d398 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -2840,6 +2840,7 @@ int
 xfs_reclaim(
 	xfs_inode_t	*ip)
 {
+	struct inode	*inode = VFS_I(ip);
 
 	xfs_itrace_entry(ip);
 
@@ -2856,10 +2857,13 @@ xfs_reclaim(
 	ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0);
 
 	/*
-	 * Make sure the atime in the XFS inode is correct before freeing the
-	 * Linux inode.
+	 * Mark dirty and update atime only if different from the linux inode one.
 	 */
-	xfs_synchronize_atime(ip);
+	if (! timespec_equal(&inode->i_atime,
+			     (struct timespec *) &ip->i_d.di_atime)) {
+		xfs_synchronize_atime(ip);
+		ip->i_update_core = 1;
+	}
 
 	/*
 	 * If we have nothing to flush with this inode then complete the
-- 
1.5.6.2


--=-=-=


-- 
Niv Sardi

--=-=-=--
