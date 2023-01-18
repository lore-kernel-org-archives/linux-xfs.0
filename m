Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD84BC00A5A
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 00:58:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjARA6h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Jan 2023 19:58:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjARA6R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Jan 2023 19:58:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75544F768
        for <linux-xfs@vger.kernel.org>; Tue, 17 Jan 2023 16:45:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11E39615A7
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 00:45:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BEFBC433D2;
        Wed, 18 Jan 2023 00:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674002705;
        bh=ApJXi3hN8zIzHDL4KwqIjokFRqXN2ItECVNABbU9eiY=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=kbMwc39nLxwqztYazLClaUBMBTPLwYWDTMoYe6EIBWVbfJcWBOLKXjwSKClVPM+wv
         22enUOLCh0D7kUJIKTsnDCNrBOOISJzUwQ9x+3witsun6AT9hMAUq4DC1umha40FLC
         yT5NiP7i2NgtPS9bJFH9E+cLoPcdIXUyJn30yzdxTWVdRqZFzX+IaqMfXr5+g5qq1F
         CkiZEgfXukdqfLExHO5LDe5AOTFB/RoiQgQBWT6FRDKEThgUYMlZXVaismwiPW1gXf
         YFgNiSyGeG+EHDdYA9ES0kcKxgERaVtjCmnP/6QPW9J13yIia/zNDcskfko43b4Y2k
         lPioiMlAPIBSQ==
Date:   Tue, 17 Jan 2023 16:45:05 -0800
Subject: [PATCH 2/3] design: document the large extent count ondisk format
 changes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com,
        allison.henderson@oracle.com
Message-ID: <167400163305.1925795.9512359158912946568.stgit@magnolia>
In-Reply-To: <167400163279.1925795.1487663139527842585.stgit@magnolia>
References: <167400163279.1925795.1487663139527842585.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Update the ondisk format documentation to discuss the larger maximum
extent counts that were added in 2022.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 .../allocation_groups.asciidoc                     |    4 +
 .../XFS_Filesystem_Structure/ondisk_inode.asciidoc |   61 ++++++++++++++++++--
 2 files changed, 58 insertions(+), 7 deletions(-)


diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
index 7ee5d561..c64b4fad 100644
--- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
+++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
@@ -454,6 +454,10 @@ xref:Timestamps[timestamps] for more information.
 The filesystem is not in operable condition, and must be run through
 xfs_repair before it can be mounted.
 
+| +XFS_SB_FEAT_INCOMPAT_NREXT64+ |
+Large file fork extent counts.  This greatly expands the maximum number of
+space mappings allowed in data and extended attribute file forks.
+
 |=====
 
 *sb_features_log_incompat*::
diff --git a/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc b/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
index 1922954e..34c06487 100644
--- a/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
+++ b/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
@@ -84,14 +84,41 @@ struct xfs_dinode_core {
      __uint32_t                di_nlink;
      __uint16_t                di_projid;
      __uint16_t                di_projid_hi;
-     __uint8_t                 di_pad[6];
-     __uint16_t                di_flushiter;
+     union {
+          /* Number of data fork extents if NREXT64 is set */
+          __be64               di_big_nextents;
+
+          /* Padding for V3 inodes without NREXT64 set. */
+          __be64               di_v3_pad;
+
+          /* Padding and inode flush counter for V2 inodes. */
+          struct {
+               __u8            di_v2_pad[6];
+               __be16          di_flushiter;
+          };
+     };
      xfs_timestamp_t           di_atime;
      xfs_timestamp_t           di_mtime;
      xfs_timestamp_t           di_ctime;
      xfs_fsize_t               di_size;
      xfs_rfsblock_t            di_nblocks;
      xfs_extlen_t              di_extsize;
+     union {
+          /*
+           * For V2 inodes and V3 inodes without NREXT64 set, this
+           * is the number of data and attr fork extents.
+           */
+          struct {
+               __be32          di_nextents;
+               __be16          di_anextents;
+          } __packed;
+
+          /* Number of attr fork extents if NREXT64 is set. */
+          struct {
+               __be32          di_big_anextents;
+               __be16          di_nrext64_pad;
+          } __packed;
+     } __packed;
      xfs_extnum_t              di_nextents;
      xfs_aextnum_t             di_anextents;
      __uint8_t                 di_forkoff;
@@ -162,7 +189,7 @@ When the number exceeds 65535, the inode is converted to v2 and the link count
 is stored in +di_nlink+.
 
 *di_uid*::
-Specifies the owner's UID of the inode. 
+Specifies the owner's UID of the inode.
 
 *di_gid*::
 Specifies the owner's GID of the inode.
@@ -181,10 +208,17 @@ Specifies the high 16 bits of the owner's project ID in v2 inodes, if the
 +XFS_SB_VERSION2_PROJID32BIT+ feature is set; and zero otherwise.
 
 *di_pad[6]*::
-Reserved, must be zero.
+Reserved, must be zero.  Only exists for v2 inodes.
 
 *di_flushiter*::
-Incremented on flush.
+Incremented on flush.  Only exists for v2 inodes.
+
+*di_v3_pad*::
+Must be zero for v3 inodes without the NREXT64 flag set.
+
+*di_big_nextents*::
+Specifies the number of data extents associated with this inode if the NREXT64
+flag is set.  This allows for up to 2^48^ - 1 extent mappings.
 
 *di_atime*::
 
@@ -231,10 +265,19 @@ file is written to beyond allocated space, XFS will attempt to allocate
 additional disk space based on this value.
 
 *di_nextents*::
-Specifies the number of data extents associated with this inode.
+Specifies the number of data extents associated with this inode if the NREXT64
+flag is not set.  Supports up to 2^31^ - 1 extents.
 
 *di_anextents*::
-Specifies the number of extended attribute extents associated with this inode.
+Specifies the number of extended attribute extents associated with this inode
+if the NREXT64 flag is not set.  Supports up to 2^15^ - 1 extents.
+
+*di_big_anextents*::
+Specifies the number of extended attribute extents associated with this inode
+if the NREXT64 flag is set.  Supports up to 2^32^ - 1 extents.
+
+*di_nrext64_pad*::
+Must be zero if the NREXT64 flag is set.
 
 *di_forkoff*::
 Specifies the offset into the inode's literal area where the extended attribute
@@ -336,6 +379,10 @@ This inode shares (or has shared) data blocks with another inode.
 For files, this is the extent size hint for copy on write operations; see
 +di_cowextsize+ for details.  For directories, the value in +di_cowextsize+
 will be copied to all newly created files and directories.
+| +XFS_DIFLAG2_NREXT64+		|
+Files with this flag set may have up to (2^48^ - 1) extents mapped to the data
+fork and up to (2^32^ - 1) extents mapped to the attribute fork.  This flag
+requires the +XFS_SB_FEAT_INCOMPAT_NREXT64+ feature to be enabled.
 |=====
 
 *di_cowextsize*::

