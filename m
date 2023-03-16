Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6639C6FD1F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:35:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbjCPTfx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbjCPTfw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:35:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA4237569;
        Thu, 16 Mar 2023 12:35:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE0E0B82290;
        Thu, 16 Mar 2023 19:35:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93CEBC433EF;
        Thu, 16 Mar 2023 19:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678995347;
        bh=+oG739zRtC1Ww7JydqKwueXkqT2Ctph6E9tcHgrZz9s=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=k9G9cCb2NWS1Pk87DDAHrrZ8g+OV0QWJIFUppiks3xkG/aMwVPQDqeeIkDrt9PUku
         +6fYHTJI8hvbvAehnJpZ8CS2Bi3r/rDs3ke8DIodHxhJTsYgyJmeRal3rc3oV+NIMR
         F0xht2RpRJBoNdINpzBPjSkvLJIuj2RY7qXxfQEtus3mV2lcmf1uYXjriITRTxLq/M
         TA43BuZ5UEH8G7FpA4rmHpSf+gH400apulQOOrOL64j5CRifMWl8K/kmXkLl9sYhxk
         Bb8YB4RxTnE1PvnUof3P26ILkk6Y9F3DedfHbjqWLqLUjNK8WmFRcc6JVkPUsURIim
         j4WYF9j12fO6Q==
Date:   Thu, 16 Mar 2023 12:35:47 -0700
Subject: [PATCH 11/14] common/parent: add license and copyright
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <167899417800.17926.13328960872448972377.stgit@frogsfrogsfrogs>
In-Reply-To: <167899417650.17926.7405859750613330339.stgit@frogsfrogsfrogs>
References: <167899417650.17926.7405859750613330339.stgit@frogsfrogsfrogs>
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
index a0ba7d927a..2d52404c39 100644
--- a/common/parent
+++ b/common/parent
@@ -1,3 +1,6 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022-2023, Oracle and/or its affiliates.  All Rights Reserved.
 #
 # Parent pointer common functions
 #

