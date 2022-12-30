Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29DBCC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:00:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236186AbiLaDAL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:00:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236248AbiLaDAJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:00:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EFC2192B4
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:00:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFD9561D11
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:00:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27DD7C433D2;
        Sat, 31 Dec 2022 03:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455608;
        bh=J5udDvvG5WCvsY74x7ui+GX2AtFY4PzbFsy9mvQs6Ug=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=U2B81fyipaBvXgpnTrqEyAM6DhKrr/gPxbYsSIEq1k3bQcpaDwRBak/gxbObZug/v
         dvfYjW4pHjdq0tT06BfuYgGpC5W5xq309Hj4fk90PZQhPI2dNdRAr4zS890f0H+Y2R
         Sj22rFinn8gDe0AXOXQ2ftlKWJqSTpRYj55T9BJ6D0/CYu8CYoWyIQcCpsUrYnh+2t
         kBgF6AGfELECSJ95ULu+9S7VD/0tte0tn09ZLKdpQPnsI0Pkks39zvrSUoe9ykF1PQ
         1XzftpRVDTu3lMSw+TkaG/jAKeIqhUc8aWnxmkw7kblSc1UR7uykavvtJNsGr/NV7A
         WtK79HLzCMEAA==
Subject: [PATCH 23/41] libfrog: enable scrubbing of the realtime refcount data
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:10 -0800
Message-ID: <167243881074.734096.10287365084919820406.stgit@magnolia>
In-Reply-To: <167243880752.734096.171910706541747310.stgit@magnolia>
References: <167243880752.734096.171910706541747310.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add a new entry so that we can scrub the rtrefcountbt.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/scrub.c |    5 +++++
 scrub/repair.c  |    1 +
 2 files changed, 6 insertions(+)


diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index 6f12ec72b22..c3cf5312f80 100644
--- a/libfrog/scrub.c
+++ b/libfrog/scrub.c
@@ -164,6 +164,11 @@ const struct xfrog_scrub_descr xfrog_scrubbers[XFS_SCRUB_TYPE_NR] = {
 		.descr	= "realtime reverse mapping btree",
 		.group	= XFROG_SCRUB_GROUP_RTGROUP,
 	},
+	[XFS_SCRUB_TYPE_RTREFCBT] = {
+		.name	= "rtrefcountbt",
+		.descr	= "realtime reference count btree",
+		.group	= XFROG_SCRUB_GROUP_RTGROUP,
+	},
 };
 #undef DEP
 
diff --git a/scrub/repair.c b/scrub/repair.c
index 3e00db7a2fd..cd652dc85a1 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -424,6 +424,7 @@ repair_item_difficulty(
 		case XFS_SCRUB_TYPE_RTBITMAP:
 		case XFS_SCRUB_TYPE_RTSUM:
 		case XFS_SCRUB_TYPE_RGSUPER:
+		case XFS_SCRUB_TYPE_RTREFCBT:
 			ret |= REPAIR_DIFFICULTY_PRIMARY;
 			break;
 		}

