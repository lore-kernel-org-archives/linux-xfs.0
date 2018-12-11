Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:44506 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726134AbeLKUgd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Dec 2018 15:36:33 -0500
Subject: Re: [PATCH] mkfs: fix symlink target if_bytes computation for
 protofile
References: <a7246562-e851-dfc4-ea3f-3b4dd64aca5b@redhat.com>
 <ca4c95cc-c8c5-c876-9ca4-a50794a4bb4f@sandeen.net>
 <20181211190256.GV24487@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <c1d6a79d-19c6-1257-f08b-b2cf1c308738@sandeen.net>
Date: Tue, 11 Dec 2018 14:36:32 -0600
MIME-Version: 1.0
In-Reply-To: <20181211190256.GV24487@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, Zorro Lang <zlang@redhat.com>

On 12/11/18 1:02 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When creating a local format symlink, we expect the target buffer in the
> data fork to have enough space to contain the null, but we also expect
> if_bytes to reflect the length of the target /not/ including the null.
> If we don't adjust if_bytes down by one byte, we can run off into
> uninitialized memory.  Fix this, which should clean up the spurious
> xfs/019 failures for good.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Ugh.  Why do we even have protofiles?  I have never seen these in use
in real life.  Can we just deprecate this half-baked crap?  :/

You suggested on IRC that we just use xfs_init_local fork; I had looked
at that when I did the first patch and for some reason didn't use it,
but looking again it seems ... ok.  I hate how all of this stuff is
re-implemented in the protofile crap code and it seems like we can't
re-use too many of the libxfs functions directly but may as well use
this if we can, right?

=========

mkfs: don't open code local fork setup in protofile code

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index ad5d65de..c3792e12 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -149,5 +149,6 @@
 #define xfs_dir_get_ops			libxfs_dir_get_ops
 #define xfs_default_ifork_ops		libxfs_default_ifork_ops
 #define xfs_fs_geometry			libxfs_fs_geometry
+#define xfs_init_local_fork		libxfs_init_local_fork
 
 #endif /* __LIBXFS_API_DEFS_H__ */
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 103795f1..3bba4917 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -237,13 +237,7 @@ newfile(
 	flags = 0;
 	mp = ip->i_mount;
 	if (symlink && len <= XFS_IFORK_DSIZE(ip)) {
-		/* Copy the name's trailing NULL as well */
-		libxfs_idata_realloc(ip, len + 1, XFS_DATA_FORK);
-		if (buf)
-			memmove(ip->i_df.if_u1.if_data, buf, len + 1);
-		ip->i_d.di_size = len;
-		ip->i_df.if_flags &= ~XFS_IFEXTENTS;
-		ip->i_df.if_flags |= XFS_IFINLINE;
+		libxfs_init_local_fork(ip, XFS_DATA_FORK, buf, len);
 		ip->i_d.di_format = XFS_DINODE_FMT_LOCAL;
 		flags = XFS_ILOG_DDATA;
 	} else if (len > 0) {
