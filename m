Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D180C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 16:03:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352023AbiEEQHd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 12:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353854AbiEEQHd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 12:07:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5190356F95
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 09:03:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04490B82DEE
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 16:03:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB2D0C385A8;
        Thu,  5 May 2022 16:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651766630;
        bh=/eUn46AWC+l3J2mRhHiUj+wbZ/z5zCB1RhogO3c842A=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WRGQ9Azv9l8PhZoE0lysjUH9Fh3FSjhzSsj/Zp2CYRjzcAJQnu+zwJ7wMR19E1Uf8
         Es7UtVnK1YONL5QdvrDcjopxb4WlNUi7zH2zujxC+0EuP5z61c0/li+X46cfnt64uJ
         7KAtK2SYUSMoHtLm6b8oBAhUoW+Wjcc7EIGvf414IJLONtRatPPVBU/MVCKc+VbUea
         dI2Nyq0dnUlov5ALNEEczsmrxEVJ7vr2H10VXlUE6vqyrp9/+NE+qLdNOe4yMXGcb4
         H21JUvQZmnZGvw5ZvN8l/f4AEX1ThuH6mf7ba4KyvZwhQBLrDD+jSYOC4cfxprHRR3
         vbZxHsMKKIRyg==
Subject: [PATCH 2/3] debian: bump compat level to 11
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 May 2022 09:03:50 -0700
Message-ID: <165176663020.246788.2313882264959489186.stgit@magnolia>
In-Reply-To: <165176661877.246788.7113237793899538040.stgit@magnolia>
References: <165176661877.246788.7113237793899538040.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Increase the compat level to 11 since we're now getting warnings about
level 9 being obsolescent.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 debian/compat |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/debian/compat b/debian/compat
index ec635144..b4de3947 100644
--- a/debian/compat
+++ b/debian/compat
@@ -1 +1 @@
-9
+11

