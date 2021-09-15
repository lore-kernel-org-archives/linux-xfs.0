Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5ED0C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:07:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FF97600D4
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:07:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbhIOXId (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:08:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232733AbhIOXIc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:08:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 415BE606A5;
        Wed, 15 Sep 2021 23:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747233;
        bh=Ju9vUVjU5nStXnqGVgXphPS7+dHFsj054rirUGWxINE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=eE1SRXArZiB5dvA2eOkHtk3Moc4xa56CXwjkJlMJ2ZpUq4L5cbhr8CHmK8pCIcu7c
         X6uA0IkRtXOW+N1gSKIRPLHGiNEBkOKOAju0QUb68tLI+l2e9szjnRImaTzSeZKYNJ
         OHt2g65liWBoWiIahMKs43DnVp1QI5+YKnVocmYOmJM6qfoJnSqBLxUGsK70ViwFyY
         eujGJugEsNjUuQmrkQuRmcB5l3wZ818vYpPA2OF+bYO4udJnjAmSTmdUTJqtZBbsIF
         WTjeqsCcEfmaW8koYwrrnXv8//vOZpqcBUPEbY9BgDNoabilohLkGJNwuQU8xTpeXP
         o55qdXqwt5Drg==
Subject: [PATCH 07/61] misc: convert utilities to use "fallthrough;"
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:07:13 -0700
Message-ID: <163174723300.350433.15350947081757255516.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we have a macro to virtualize switch statement fallthroughs for
lazy compiler linters, we might as well spread it elsewhere.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/type.c           |    2 +-
 growfs/xfs_growfs.c |    6 +++---
 repair/dinode.c     |   18 +++++++++---------
 repair/phase4.c     |    4 ++--
 repair/scan.c       |    4 ++--
 scrub/inodes.c      |    2 +-
 scrub/repair.c      |    2 +-
 scrub/scrub.c       |    8 ++++----
 8 files changed, 23 insertions(+), 23 deletions(-)


diff --git a/db/type.c b/db/type.c
index 572ac6d6..f8d8b555 100644
--- a/db/type.c
+++ b/db/type.c
@@ -307,7 +307,7 @@ handle_text(
 {
 	switch (action) {
 	case DB_FUZZ:
-		/* fall through */
+		fallthrough;
 	case DB_WRITE:
 		dbprintf(_("text writing/fuzzing not supported.\n"));
 		break;
diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
index d45ba703..683961f6 100644
--- a/growfs/xfs_growfs.c
+++ b/growfs/xfs_growfs.c
@@ -78,7 +78,7 @@ main(int argc, char **argv)
 		switch (c) {
 		case 'D':
 			dsize = strtoll(optarg, NULL, 10);
-			/* fall through */
+			fallthrough;
 		case 'd':
 			dflag = 1;
 			break;
@@ -91,7 +91,7 @@ main(int argc, char **argv)
 			break;
 		case 'L':
 			lsize = strtoll(optarg, NULL, 10);
-			/* fall through */
+			fallthrough;
 		case 'l':
 			lflag = 1;
 			break;
@@ -107,7 +107,7 @@ main(int argc, char **argv)
 			break;
 		case 'R':
 			rsize = strtoll(optarg, NULL, 10);
-			/* fall through */
+			fallthrough;
 		case 'r':
 			rflag = 1;
 			break;
diff --git a/repair/dinode.c b/repair/dinode.c
index 1fd20954..f39ab2dc 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -531,7 +531,7 @@ _("Fatal error: inode %" PRIu64 " - blkmap_set_ext(): %s\n"
 				do_warn(
 _("%s fork in ino %" PRIu64 " claims free block %" PRIu64 "\n"),
 					forkname, ino, (uint64_t) b);
-				/* fall through ... */
+				fallthrough;
 			case XR_E_INUSE1:	/* seen by rmap */
 			case XR_E_UNKNOWN:
 				break;
@@ -543,7 +543,7 @@ _("%s fork in ino %" PRIu64 " claims free block %" PRIu64 "\n"),
 			case XR_E_INO1:
 			case XR_E_INUSE_FS1:
 				do_warn(_("rmap claims metadata use!\n"));
-				/* fall through */
+				fallthrough;
 			case XR_E_FS_MAP:
 			case XR_E_INO:
 			case XR_E_INUSE_FS:
@@ -1674,9 +1674,9 @@ _("directory inode %" PRIu64 " has bad size %" PRId64 "\n"),
 		}
 		break;
 
-	case XR_INO_CHRDEV:	/* fall through to FIFO case ... */
-	case XR_INO_BLKDEV:	/* fall through to FIFO case ... */
-	case XR_INO_SOCK:	/* fall through to FIFO case ... */
+	case XR_INO_CHRDEV:
+	case XR_INO_BLKDEV:
+	case XR_INO_SOCK:
 	case XR_INO_FIFO:
 		if (process_misc_ino_types(mp, dino, lino, type))
 			return 1;
@@ -1751,8 +1751,8 @@ _("bad attr fork offset %d in dev inode %" PRIu64 ", should be %d\n"),
 			return 1;
 		}
 		break;
-	case XFS_DINODE_FMT_LOCAL:	/* fall through ... */
-	case XFS_DINODE_FMT_EXTENTS:	/* fall through ... */
+	case XFS_DINODE_FMT_LOCAL:
+	case XFS_DINODE_FMT_EXTENTS:
 	case XFS_DINODE_FMT_BTREE:
 		if (dino->di_forkoff >= (XFS_LITINO(mp) >> 3)) {
 			do_warn(
@@ -1908,7 +1908,7 @@ process_inode_data_fork(
 			totblocks, nextents, dblkmap, XFS_DATA_FORK,
 			check_dups);
 		break;
-	case XFS_DINODE_FMT_DEV:	/* fall through */
+	case XFS_DINODE_FMT_DEV:
 		err = 0;
 		break;
 	default:
@@ -1946,7 +1946,7 @@ process_inode_data_fork(
 				dirty, totblocks, nextents, dblkmap,
 				XFS_DATA_FORK, 0);
 			break;
-		case XFS_DINODE_FMT_DEV:	/* fall through */
+		case XFS_DINODE_FMT_DEV:
 			err = 0;
 			break;
 		default:
diff --git a/repair/phase4.c b/repair/phase4.c
index 191b4842..eb043002 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -317,7 +317,7 @@ phase4(xfs_mount_t *mp)
 				do_warn(
 				_("unknown block state, ag %d, blocks %u-%u\n"),
 					i, j, j + blen - 1);
-				/* fall through .. */
+				fallthrough;
 			case XR_E_UNKNOWN:
 			case XR_E_FREE:
 			case XR_E_INUSE:
@@ -349,7 +349,7 @@ phase4(xfs_mount_t *mp)
 			do_warn(
 	_("unknown rt extent state, extent %" PRIu64 "\n"),
 				bno);
-			/* fall through .. */
+			fallthrough;
 		case XR_E_UNKNOWN:
 		case XR_E_FREE1:
 		case XR_E_FREE:
diff --git a/repair/scan.c b/repair/scan.c
index 2c25af57..52de8a04 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -732,7 +732,7 @@ _("%s freespace btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 							     XR_E_FREE);
 						break;
 					}
-					/* fall through */
+					fallthrough;
 				default:
 					do_warn(
 	_("block (%d,%d-%d) multiply claimed by %s space tree, state - %d\n"),
@@ -911,7 +911,7 @@ _("in use block (%d,%d-%d) mismatch in %s tree, state - %d,%" PRIx64 "\n"),
 		if (xfs_sb_version_hasreflink(&mp->m_sb) &&
 		    !XFS_RMAP_NON_INODE_OWNER(owner))
 			break;
-		/* fall through */
+		fallthrough;
 	default:
 		do_warn(
 _("unknown block (%d,%d-%d) mismatch on %s tree, state - %d,%" PRIx64 "\n"),
diff --git a/scrub/inodes.c b/scrub/inodes.c
index cc73da7f..80af8a74 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -204,7 +204,7 @@ _("Changed too many times during scan; giving up."));
 			}
 			case ECANCELED:
 				error = 0;
-				/* fall thru */
+				fallthrough;
 			default:
 				goto err;
 			}
diff --git a/scrub/repair.c b/scrub/repair.c
index 2c1644c3..1ef6372e 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -133,7 +133,7 @@ action_list_find_mustfix(
 			alist->nr--;
 			list_move_tail(&aitem->list, &immediate_alist->list);
 			immediate_alist->nr++;
-			/* fall through */
+			fallthrough;
 		case XFS_SCRUB_TYPE_BNOBT:
 		case XFS_SCRUB_TYPE_CNTBT:
 		case XFS_SCRUB_TYPE_REFCNTBT:
diff --git a/scrub/scrub.c b/scrub/scrub.c
index aec2d5d5..a4b7084e 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -164,7 +164,7 @@ _("Filesystem is shut down, aborting."));
 		 * and the other two should be reported via sm_flags.
 		 */
 		str_liberror(ctx, error, _("Kernel bug"));
-		/* fall through */
+		fallthrough;
 	default:
 		/* Operational error. */
 		str_errno(ctx, descr_render(&dsc));
@@ -316,7 +316,7 @@ scrub_meta_type(
 		ret = scrub_save_repair(ctx, alist, &meta);
 		if (ret)
 			return ret;
-		/* fall through */
+		fallthrough;
 	case CHECK_DONE:
 		return 0;
 	default:
@@ -741,7 +741,7 @@ _("Filesystem is shut down, aborting."));
 		if (is_unoptimized(&oldm) ||
 		    debug_tweak_on("XFS_SCRUB_FORCE_REPAIR"))
 			return CHECK_DONE;
-		/* fall through */
+		fallthrough;
 	case EINVAL:
 		/* Kernel doesn't know how to repair this? */
 		str_corrupt(ctx, descr_render(&dsc),
@@ -761,7 +761,7 @@ _("Read-only filesystem; cannot make changes."));
 		/* Don't care if preen fails due to low resources. */
 		if (is_unoptimized(&oldm) && !needs_repair(&oldm))
 			return CHECK_DONE;
-		/* fall through */
+		fallthrough;
 	default:
 		/*
 		 * Operational error.  If the caller doesn't want us

