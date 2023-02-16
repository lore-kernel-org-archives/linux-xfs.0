Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA89EC636D6
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:16:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbjBPVQc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:16:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbjBPVQb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:16:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A125497CA;
        Thu, 16 Feb 2023 13:16:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A35C60C0D;
        Thu, 16 Feb 2023 21:16:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06D2FC433EF;
        Thu, 16 Feb 2023 21:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676582187;
        bh=lZeu151/C8sqrWxXC2GqnNNkUbimGDQJU0K+MctVoC8=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=tDiWNDNm4A6rjnWrQK6MJkx7rRcHELZK8E76SHiArGxF6cfLgpOMDUr17WYGu/tH9
         CjFSYxOQBGecrbMypG4wNFxraffANH6T6KCiasuTEVcR6Ekk9ZphfuCNrWsBk+Lfgn
         PG8wVpHzw5HWJU+kbzlKvvNreupUHZBeijv/gqrsttNuLyYLjDT1XNEd23ubb5du3q
         wE1E5SeFzow8uZRuhKf/6D9md3XZrJn4i6TiG9KMZPmQcc1PvkWulrGrnbyLF4qVBs
         3r8X/ncf9gio8RgaGz/GTjJZv4XNHAS5N6oYrZQwI6zXm+MiKFCvrEzFbWpcXCMss2
         xXbgUx/oDuJew==
Date:   Thu, 16 Feb 2023 13:16:26 -0800
Subject: [PATCH 11/14] common/parent: add license and copyright
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <167657884634.3481377.10605904646292444361.stgit@magnolia>
In-Reply-To: <167657884480.3481377.14824439551809919632.stgit@magnolia>
References: <167657884480.3481377.14824439551809919632.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add the necessary licensing and copyright tags to the new file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/parent |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/common/parent b/common/parent
index a0ba7d927a..a734a8017d 100644
--- a/common/parent
+++ b/common/parent
@@ -1,3 +1,6 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022, Oracle and/or its affiliates.  All Rights Reserved.
 #
 # Parent pointer common functions
 #

