Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4097A7F3F
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2014 14:36:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2F5A28F8039
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2014 12:36:06 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 3fXBOu0LJTjulK5p for <xfs@oss.sgi.com>;
	Tue, 19 Aug 2014 12:36:05 -0700 (PDT)
Message-ID: <53F3A726.8080305@sandeen.net>
Date: Tue, 19 Aug 2014 14:36:06 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] xfs: add a few more verifier tests
References: <53F2C103.8030607@redhat.com>
In-Reply-To: <53F2C103.8030607@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

These were exposed by fsfuzzer runs; without them we fail
in various exciting and sometimes convoluted ways when we
encounter disk corruption.

Without the MAXLEVELS tests we tend to walk off the end of
an array in a loop like this:

        for (i = 0; i < cur->bc_nlevels; i++) {
                if (cur->bc_bufs[i])

Without the dirblklog test we try to allocate more memory
than we could possibly hope for and loop forever:

xfs_dabuf_map()
	nfsb = mp->m_dir_geo->fsbcount;
	irecs = kmem_zalloc(sizeof(irec) * nfsb, KM_SLEEP...

As for the logbsize check, that's the convoluted one.

If logbsize is specified at mount time, it's sanitized
in xfs_parseargs; in particular it makes sure that it's
not > XLOG_MAX_RECORD_BSIZE.
    
If not specified at mount time, it comes from the superblock
via sb_logsunit; this is limited to 256k at mkfs time as well;
it's copied into m_logbsize in xfs_finish_flags().
    
However, if for some reason the on-disk value is corrupt and
too large, nothing catches it.  It's a circuitous path, but
that size eventually finds its way to places that make the kernel
very unhappy, leading to oopses in xlog_pack_data() because we
use the size as an index into iclog->ic_data, but the array
is not necessarily that big.

Anyway - bounds checking when we read from disk is a good thing!

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
--


V2: un-obfuscate the btree level tests, removing negated comparisons, per
hch's suggestion.

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 4bffffe..eff3421 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2209,6 +2209,10 @@ xfs_agf_verify(
 	      be32_to_cpu(agf->agf_flcount) <= XFS_AGFL_SIZE(mp)))
 		return false;
 
+	if (be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) > XFS_BTREE_MAXLEVELS ||
+	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]) > XFS_BTREE_MAXLEVELS)
+		return false;
+
 	/*
 	 * during growfs operations, the perag is not fully initialised,
 	 * so we can't use it for any useful checking. growfs ensures we can't
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index b62771f..d213a2e 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2051,6 +2051,8 @@ xfs_agi_verify(
 	if (!XFS_AGI_GOOD_VERSION(be32_to_cpu(agi->agi_versionnum)))
 		return false;
 
+	if (be32_to_cpu(agi->agi_level) > XFS_BTREE_MAXLEVELS)
+		return false;
 	/*
 	 * during growfs operations, the perag is not fully initialised,
 	 * so we can't use it for any useful checking. growfs ensures we can't
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index ad525a5..8426e5e 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -279,11 +279,13 @@ xfs_mount_validate_sb(
 	    sbp->sb_blocklog < XFS_MIN_BLOCKSIZE_LOG			||
 	    sbp->sb_blocklog > XFS_MAX_BLOCKSIZE_LOG			||
 	    sbp->sb_blocksize != (1 << sbp->sb_blocklog)		||
+	    sbp->sb_dirblklog > XFS_MAX_BLOCKSIZE_LOG			||
 	    sbp->sb_inodesize < XFS_DINODE_MIN_SIZE			||
 	    sbp->sb_inodesize > XFS_DINODE_MAX_SIZE			||
 	    sbp->sb_inodelog < XFS_DINODE_MIN_LOG			||
 	    sbp->sb_inodelog > XFS_DINODE_MAX_LOG			||
 	    sbp->sb_inodesize != (1 << sbp->sb_inodelog)		||
+	    sbp->sb_logsunit > XLOG_MAX_RECORD_BSIZE			||
 	    sbp->sb_inopblock != howmany(sbp->sb_blocksize,sbp->sb_inodesize) ||
 	    (sbp->sb_blocklog - sbp->sb_inodelog != sbp->sb_inopblog)	||
 	    (sbp->sb_rextsize * sbp->sb_blocksize > XFS_MAX_RTEXTSIZE)	||

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
