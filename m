Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83C14C6FA9D
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Mar 2023 16:05:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbjCAQFq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Mar 2023 11:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjCAQFq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Mar 2023 11:05:46 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D6D3B0E0
        for <linux-xfs@vger.kernel.org>; Wed,  1 Mar 2023 08:05:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5E9C7CE1D53
        for <linux-xfs@vger.kernel.org>; Wed,  1 Mar 2023 16:05:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE06C433EF;
        Wed,  1 Mar 2023 16:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677686734;
        bh=0HMDhhkhJugUhFUbXgV/Hh1tTHmLnWIsAxmqV5nsMFk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DVxDnAPUNc63XVXtQzE6ieKy2EJO9n57BTcz3tcpUnYw3jzCBPhZGnKnHcjrSakKf
         XPeoHL3dHjhFCoF2Kw/CFsdslbP1q4ReXboH+l+89mi1/JAs1j4ucgolSfDwr1KnDj
         snIhp4nVaXIWFy2iSSfe4xMrN/f9mx0FGrbr3MhqHcBWZbT5XSMREbBpMwNekcSc4H
         Z+smYQPJLFtiEw/4sAVfGBiXGJ7HZllouO4u9XJVwVQv04mo8csyFHe6CAL40qKQNy
         lErGyNFfFZtdSKlKmiRqGPbokTuSOBQq5/FHmEnaqDuhAzunKrq2eelFqVwOrzon6H
         EqETEygQnOUmg==
Subject: [PATCH 1/3] mkfs: check dirent names when reading protofile
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, daan.j.demeyer@gmail.com
Date:   Wed, 01 Mar 2023 08:05:34 -0800
Message-ID: <167768673411.4130726.18042131075742150245.stgit@magnolia>
In-Reply-To: <167768672841.4130726.1758921319115777334.stgit@magnolia>
References: <167768672841.4130726.1758921319115777334.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The protofile parser in mkfs does not check directory entry names when
populating the filesystem.  The libxfs directory code doesn't check them
either, since they depend on the Linux VFS to sanitize incoming names.
If someone puts a slash in the first (name) column in the protofile,
this results in a successful format and xfs_repair -n immediately
complains.

Screen the names that are being read from the protofile.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/proto.c |    6 ++++++
 1 file changed, 6 insertions(+)


diff --git a/mkfs/proto.c b/mkfs/proto.c
index 68ecdbf3632..7e3fc1b8134 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -326,6 +326,12 @@ newdirent(
 	int	error;
 	int	rsv;
 
+	if (!libxfs_dir2_namecheck(name->name, name->len)) {
+		fprintf(stderr, _("%.*s: invalid directory entry name\n"),
+				name->len, name->name);
+		exit(1);
+	}
+
 	rsv = XFS_DIRENTER_SPACE_RES(mp, name->len);
 
 	error = -libxfs_dir_createname(tp, pip, name, inum, rsv);

