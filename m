Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B42C2C77B73
	for <linux-xfs@archiver.kernel.org>; Tue,  2 May 2023 20:08:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbjEBUIu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 May 2023 16:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjEBUIq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 May 2023 16:08:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F871BD5;
        Tue,  2 May 2023 13:08:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C23F462878;
        Tue,  2 May 2023 20:08:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A53FC433D2;
        Tue,  2 May 2023 20:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683058115;
        bh=Kd3qyC5lxmDsr90OyCxPZaLyRlym3tPIV2Ycmv7Yab8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fR+4uwOT0uhZZzveLH7dSvxE9yDSIa8eIDIYxwZpd2MpXNZjbWSButFQ4Og1cmqA5
         UlYdGjqFv5hw/PYh4FNdvV/ybsAw6vWNQIz99C6P2x8ttypjtEjpaYPo935ptBwWwa
         aH5bCgOXuZ0Ivfe02NBs+BcKjvnSXL7jrzb9EEMdU3nZ1K7tkQwQqpz/OfFdd+QhOm
         zxN8xZF0vM/RKpLor+AuNbnG+9TU0K8Co5wt4QNU/e49c0BFohcrWxE8C1De31xgfF
         g2fFnJeYNZinSlw+F5RhfFi6+ZQ9Qmg78KduYuobKVseNSQBC7sdNh34IwSiOl48el
         xQQ7ZrvOZd67g==
Subject: [PATCH 5/7] fiemap-tester: holes can be backed by unwritten extents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 02 May 2023 13:08:34 -0700
Message-ID: <168305811472.331137.10386168929752413533.stgit@frogsfrogsfrogs>
In-Reply-To: <168305808594.331137.16455277063177572891.stgit@frogsfrogsfrogs>
References: <168305808594.331137.16455277063177572891.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Filesystem behavior is pretty open-ended for sparse ranges (i.e. holes)
of a file that have not yet been written to.  That space can remain
unmapped, it can be mapped to written space that has been zeroed, or it
can be mapped to unwritten extents.

This program trips over that last condition on XFS.  If the file is
located on a data device with a raid stripe geometry or on a realtime
device with a realtime extent size larger than 1 filesystem block, it's
possible for unwritten areas to be backed by unwritten preallocations or
unwritten rt blocks, respectively.

Fix the test to skip unwritten extents here.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 src/fiemap-tester.c |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/src/fiemap-tester.c b/src/fiemap-tester.c
index 3db24daa79..7e9f9fe8c1 100644
--- a/src/fiemap-tester.c
+++ b/src/fiemap-tester.c
@@ -375,6 +375,13 @@ check_hole(struct fiemap *fiemap, int fd, __u64 logical_offset, int blocksize)
 		if (logical_offset + blocksize < start)
 			break;
 
+		/*
+		 * Filesystems are allowed to fill in holes with preallocated
+		 * unwritten extents
+		 */
+		if (extent->fe_flags & FIEMAP_EXTENT_UNWRITTEN)
+			continue;
+
 		if (logical_offset >= start &&
 		    logical_offset < end) {
 

