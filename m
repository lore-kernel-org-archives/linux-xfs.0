Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 217BBC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:52:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236274AbiLaCwX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:52:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236243AbiLaCwW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:52:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FCF812093
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:52:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBC3461BCB
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:52:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25511C433EF;
        Sat, 31 Dec 2022 02:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455141;
        bh=zfEhwN2+aNJEd7zNms8OQVYQqlpfr4YlOCMe0fXvCac=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cJJ61S1jO8eqybmw4iYjjjajxVjVrV5G3vaLUGWxMKXdJNsmbJ0ctSvSxdJj0ubbY
         +j9vDu4PWfLs9plKXDYorxBANk0QXu1AIioN+8LnXiALJHsC5/RTCmGaNSbcxX28yf
         cjT8Rcea3rzYBawqdrltAXohY4Q6k5iVSzrlACpZ0nJh/9kHg5S+1Dc5aZLDX+4uoi
         7uMa/ej4Q76XFQvl8oXfDpoWbK+SIzFgm4SjcPOf+lTeZbKnDOKUVr0SLU5r43zXf2
         YLsHW4k6ByKlgqeWpU5s2JVc+saeOIqkx9oUeHAuW5dmVirKs1X2brKFbgR8nOpJIF
         NViCGjUVUMKjg==
Subject: [PATCH 38/41] xfs_repair: reserve per-AG space while rebuilding rt
 metadata
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:00 -0800
Message-ID: <167243880097.732820.15941997691812634120.stgit@magnolia>
In-Reply-To: <167243879574.732820.4725863402652761218.stgit@magnolia>
References: <167243879574.732820.4725863402652761218.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Realtime metadata btrees can consume quite a bit of space on a full
filesystem.  Since the metadata are just regular files, we need to
make the per-AG reservations to avoid overfilling any of the AGs while
rebuilding metadata.  This avoids the situation where a filesystem comes
straight from repair and immediately trips over not having enough space
in an AG.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/libxfs.h |    1 +
 repair/phase6.c  |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)


diff --git a/include/libxfs.h b/include/libxfs.h
index 0b255e2c104..b1e499569ac 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -88,6 +88,7 @@ struct iomap;
 #include "xfs_rtbitmap.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtrmap_btree.h"
+#include "xfs_ag_resv.h"
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/repair/phase6.c b/repair/phase6.c
index d5381e1eddc..8828f7f72b9 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -3813,10 +3813,43 @@ reset_rt_metadata_inodes(
 	}
 }
 
+static int
+reserve_ag_blocks(
+	struct xfs_mount	*mp)
+{
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+	int			error = 0;
+	int			err2;
+
+	mp->m_finobt_nores = false;
+
+	for_each_perag(mp, agno, pag) {
+		err2 = -libxfs_ag_resv_init(pag, NULL);
+		if (err2 && !error)
+			error = err2;
+	}
+
+	return error;
+}
+
+static void
+unreserve_ag_blocks(
+	struct xfs_mount	*mp)
+{
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+
+	for_each_perag(mp, agno, pag)
+		libxfs_ag_resv_free(pag);
+}
+
 void
 phase6(xfs_mount_t *mp)
 {
 	ino_tree_node_t		*irec;
+	bool			reserve_perag;
+	int			error;
 	int			i;
 
 	orphanage_ino = 0;
@@ -3854,6 +3887,17 @@ phase6(xfs_mount_t *mp)
 		do_warn(_("would reinitialize metadata root directory\n"));
 	}
 
+	reserve_perag = xfs_has_realtime(mp) && !no_modify;
+	if (reserve_perag) {
+		error = reserve_ag_blocks(mp);
+		if (error) {
+			if (error != ENOSPC)
+				do_warn(
+	_("could not reserve per-AG space to rebuild realtime metadata"));
+			reserve_perag = false;
+		}
+	}
+
 	if (need_rbmino)  {
 		if (!no_modify)  {
 			if (need_rbmino > 0)
@@ -3892,6 +3936,9 @@ _("        - resetting contents of realtime bitmap and summary inodes\n"));
 		}
 	}
 
+	if (reserve_perag)
+		unreserve_ag_blocks(mp);
+
 	reattach_metadir_quota_inodes(mp);
 
 	mark_standalone_inodes(mp);

