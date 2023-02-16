Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 696FAC61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:55:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbjBPVzg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:55:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbjBPVzf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:55:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C667690
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:55:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA392B829C3
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:53:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 660C1C4339B;
        Thu, 16 Feb 2023 21:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676584396;
        bh=9W5wvr++jX/4xX41z1NoPfZVAcC545x/5KcOP97K1f0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WX6dVnnotX1F5LGbCiuaH05vC+JP66aALD0MYhHQB3pYGAKLg+uxEiESF/ZFjSgDg
         O+sIqoB0LZtql6G4kOxVxgraBPIL1VBZ/nWKFaIsx7ILWiaqVq5R661f5Pd3pTxWnd
         JBHgptIbz1Nz4Prsqx0Vk2h0yNJluOiQYFYKP61iDlGfTRMqyOwGGfc5UA4LGoMIun
         zDcwQYh4HHJvMXl8q4ZigajM0R6UN2iAS20SjvTJm8NqGpEfL0hJs6SrPa4UTizTFi
         wys8cpeOFkZqbf2tvVlCZ2ITuxG98fbpu5qxnDdOJXiHeueZN1ugyi5s8Xfe42uxfC
         1URXFjLyt5AOA==
Subject: [PATCH 5/5] mkfs: substitute slashes with spaces in protofiles
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, daan.j.demeyer@gmail.com
Date:   Thu, 16 Feb 2023 13:53:15 -0800
Message-ID: <167658439591.3590000.1501103007888420501.stgit@magnolia>
In-Reply-To: <167658436759.3590000.3700844510708970684.stgit@magnolia>
References: <167658436759.3590000.3700844510708970684.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

A user requested the ability to specify directory entry names in a
protofile that have spaces in them.  The protofile format itself does
not allow spaces (yay 1973-era protofiles!) but it does allow slashes.
Slashes aren't allowed in directory entry names, so we'll permit this
one gross hack.

/
0 0
d--775 1000 1000
: Descending path /code/t/fstests
 get/isk.sh   ---775 1000 1000 /code/t/fstests/getdisk.sh
$

Will produce "get isk.h" in the root directory.

Requested-by: Daan De Meyer <daan.j.demeyer@gmail.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/proto.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)


diff --git a/mkfs/proto.c b/mkfs/proto.c
index 68ecdbf3632..bf8de0189db 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -171,6 +171,27 @@ getstr(
 	return NULL;
 }
 
+/* Extract directory entry name from a protofile. */
+static char *
+getdirentname(
+	char	**pp)
+{
+	char	*p = getstr(pp);
+	char	*c = p;
+
+	if (!p)
+		return NULL;
+
+	/* Replace slash with space because slashes aren't allowed. */
+	while (*c) {
+		if (*c == '/')
+			*c = ' ';
+		c++;
+	}
+
+	return p;
+}
+
 static void
 rsvfile(
 	xfs_mount_t	*mp,
@@ -580,7 +601,7 @@ parseproto(
 			rtinit(mp);
 		tp = NULL;
 		for (;;) {
-			name = getstr(pp);
+			name = getdirentname(pp);
 			if (!name)
 				break;
 			if (strcmp(name, "$") == 0)

