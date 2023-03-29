Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CD54C761A6
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Mar 2023 00:58:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjC2A6T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Mar 2023 20:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjC2A6S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Mar 2023 20:58:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96BF719B1;
        Tue, 28 Mar 2023 17:58:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C68D61A21;
        Wed, 29 Mar 2023 00:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2FAC433D2;
        Wed, 29 Mar 2023 00:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680051496;
        bh=JCJB0mfkCICRzc3ydZ+FdB85+bN7patQ8AJ1SWFkHwo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=q5O95SraFBszxtM45D/5pp6ABbL7CbHEaUf8ZAL7R/idVy19Nm6rvrDQ0tQJNe3r6
         vJwFj28pXJRWiV+cttgJlvjP7jT0c9zEi+HCoMp2eFwtXtGtRuhb+xtA+lzoR6N3rK
         ObyenLC0vGzWzsuSU1FQj6auNmKYdLJ7PHDgd6lYnXaX1yw3hThYGcQJ7fSu3KDwT4
         058Uobq2taq8vn+eeWpZk4DlS0lmdmdcfoS0d7GhuzLFXlcltf+/PjiGNyefZ/qXzi
         sd+FnQcjh/XcFIlVO09MBdDTxIqRBp10TWHtHxUFAUbqQdxcrRjzQkv8nv5pwNEDDm
         aBZhpgMJl0IaQ==
Subject: [PATCH 2/3] xfs/242: fix _filter_bmap for xfs_io bmap that does rt
 file properly
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 28 Mar 2023 17:58:16 -0700
Message-ID: <168005149606.4147931.15638466274918510566.stgit@frogsfrogsfrogs>
In-Reply-To: <168005148468.4147931.1986862498548445502.stgit@frogsfrogsfrogs>
References: <168005148468.4147931.1986862498548445502.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

xfsprogs commit b1faed5f787 ("xfs_io: fix bmap command not detecting
realtime files with xattrs") fixed the xfs_io bmap output to display
realtime file columns for realtime files with xattrs.  As a result, the
data and unwritten flags are in column 5 and not column 7.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/punch |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/common/punch b/common/punch
index 3b8be21a2a..9e730404e2 100644
--- a/common/punch
+++ b/common/punch
@@ -188,6 +188,7 @@ _filter_hole_fiemap()
 	_coalesce_extents
 }
 
+# Column 7 for datadev files and column 5 for rtdev files
 #     10000 Unwritten preallocated extent
 #     01000 Doesn't begin on stripe unit
 #     00100 Doesn't end   on stripe unit
@@ -200,6 +201,13 @@ _filter_bmap()
 			print $1, $2, $3;
 			next;
 		}
+		$5 ~ /1[01][01][01][01]/ {
+			print $1, $2, "unwritten";
+			next;
+		}
+		$5 ~ /0[01][01][01][01]/ {
+			print $1, $2, "data"
+		}
 		$7 ~ /1[01][01][01][01]/ {
 			print $1, $2, "unwritten";
 			next;

