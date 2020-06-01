Return-Path: <SRS0=XPcr=7O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99AE4C433E1
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Jun 2020 14:02:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 756222074B
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Jun 2020 14:02:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ob2R7RxF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726113AbgFAOCJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Jun 2020 10:02:09 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:32992 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726017AbgFAOCI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jun 2020 10:02:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591020127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3+LIsrrtvQr4E0eKC5XOwbvsLVshrjLE780ifsIlEkg=;
        b=Ob2R7RxFGBZKGICJjYy2tXorT5G/zBvkPEN1HeAu3d3dwdNKZbsCgkkXaUgzOIyG9N1GSQ
        l06wH2b7dJVbU5psvolAxI5tZjlbnXw6KbC7RCP1NepMBPg31nxQ3+53ZFx6CFo9azS0cW
        KzgZNFhW79/HV6c1ug5OJeoF5B3wZ00=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-o1OqPIrtPcSIKVwEmrFqZA-1; Mon, 01 Jun 2020 10:02:05 -0400
X-MC-Unique: o1OqPIrtPcSIKVwEmrFqZA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7CF2F801503
        for <linux-xfs@vger.kernel.org>; Mon,  1 Jun 2020 14:02:04 +0000 (UTC)
Received: from eorzea.redhat.com (unknown [10.40.194.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CB10E1BCBE
        for <linux-xfs@vger.kernel.org>; Mon,  1 Jun 2020 14:02:03 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: Bypass sb alignment checks when custom values are used
Date:   Mon,  1 Jun 2020 16:01:53 +0200
Message-Id: <20200601140153.200864-3-cmaiolino@redhat.com>
In-Reply-To: <20200601140153.200864-1-cmaiolino@redhat.com>
References: <20200601140153.200864-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch introduces a new mount flag: XFS_MOUNT_ALIGN that is set when
custom alignment values are set, making easier to identify when user
passes custom alignment options via mount command line.

Then use this flag to bypass on-disk alignment checks.

This is useful specifically for users which had filesystems created with
wrong alignment provided by buggy storage, which, after commit
fa4ca9c5574605, these filesystems won't be mountable anymore. But, using
custom alignment settings, there is no need to check those values, once
the alignment used will be the one provided during mount time, avoiding
the issues in the allocator caused by bad alignment values anyway. This
at least give a chance for users to remount their filesystems on newer
kernels, without needing to reformat it.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/libxfs/xfs_sb.c | 30 +++++++++++++++++++-----------
 fs/xfs/xfs_mount.h     |  2 ++
 fs/xfs/xfs_super.c     |  1 +
 3 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 4df87546bd40..72dae95a5e4a 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -360,19 +360,27 @@ xfs_validate_sb_common(
 		}
 	}
 
-	if (sbp->sb_unit) {
-		if (!xfs_sb_version_hasdalign(sbp) ||
-		    sbp->sb_unit > sbp->sb_width ||
-		    (sbp->sb_width % sbp->sb_unit) != 0) {
-			xfs_notice(mp, "SB stripe unit sanity check failed");
+	/*
+	 * Ignore superblock alignment checks if sunit/swidth mount options
+	 * were used or alignment turned off.
+	 * The custom alignment validation will happen later on xfs_mountfs()
+	 */
+	if (!(mp->m_flags & XFS_MOUNT_ALIGN) &&
+	    !(mp->m_flags & XFS_MOUNT_NOALIGN)) {
+		if (sbp->sb_unit) {
+			if (!xfs_sb_version_hasdalign(sbp) ||
+			    sbp->sb_unit > sbp->sb_width ||
+			    (sbp->sb_width % sbp->sb_unit) != 0) {
+				xfs_notice(mp, "SB stripe unit sanity check failed");
+				return -EFSCORRUPTED;
+			}
+		} else if (xfs_sb_version_hasdalign(sbp)) {
+			xfs_notice(mp, "SB stripe alignment sanity check failed");
+			return -EFSCORRUPTED;
+		} else if (sbp->sb_width) {
+			xfs_notice(mp, "SB stripe width sanity check failed");
 			return -EFSCORRUPTED;
 		}
-	} else if (xfs_sb_version_hasdalign(sbp)) {
-		xfs_notice(mp, "SB stripe alignment sanity check failed");
-		return -EFSCORRUPTED;
-	} else if (sbp->sb_width) {
-		xfs_notice(mp, "SB stripe width sanity check failed");
-		return -EFSCORRUPTED;
 	}
 
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 6552473ab117..3b650795fbc3 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -233,6 +233,8 @@ typedef struct xfs_mount {
 						   operations, typically for
 						   disk errors in metadata */
 #define XFS_MOUNT_DISCARD	(1ULL << 5)	/* discard unused blocks */
+#define XFS_MOUNT_ALIGN		(1ULL << 6)	/* Custom alignment set via
+						   mount */
 #define XFS_MOUNT_NOALIGN	(1ULL << 7)	/* turn off stripe alignment
 						   allocations */
 #define XFS_MOUNT_ATTR2		(1ULL << 8)	/* allow use of attr2 format */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 580072b19e8a..981e69845620 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1214,6 +1214,7 @@ xfs_fc_parse_param(
 		return 0;
 	case Opt_sunit:
 		mp->m_dalign = result.uint_32;
+		mp->m_flags |= XFS_MOUNT_ALIGN;
 		return 0;
 	case Opt_swidth:
 		mp->m_swidth = result.uint_32;
-- 
2.26.2

