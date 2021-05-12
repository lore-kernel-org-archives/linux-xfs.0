Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77BC8C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 02:01:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41CB3613AA
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 02:01:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbhELCCz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 May 2021 22:02:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:49244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230280AbhELCCz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 May 2021 22:02:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01FA4610EA;
        Wed, 12 May 2021 02:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620784908;
        bh=kinM7C0LmXrsdhExmdtvm6AYJNahDP+OdN/yzlFtOIs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MV3IpPQOXeS4+u5PZoBbUw/YfMFgPD9AMQg/o6+0iRBmvgaRPXWuA5unY37n9hxjH
         pjoS2u4yEkT1TuE2GvL0yfVenw2NB8LyynOwxfu0PgktClLnLQ5APgoMUhvpy7nuyQ
         1gwv2dwzt/p9Cc13nQpyWIMdGsOaViys/p0bEpZe3he//Gd5+IFJ92qnGd2JRw/Ds2
         qgvW1KQQU4ORu799ZyOEG1Up8aDGn8aRAzDfllzU5daKTHAl+GxQCgYkmNSU8urcnZ
         6bmgYG6JuomRFXnjubpq3ABCvySjzVGo7N5ViyhsOzYG44ldJvfRirN9F28TP4Bbq8
         KvjzlawVXc5eQ==
Subject: [PATCH 1/8] xfs/122: add entries for structures added to 5.13
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 11 May 2021 19:01:45 -0700
Message-ID: <162078490538.3302755.11517881840628679922.stgit@magnolia>
In-Reply-To: <162078489963.3302755.9219127595550889655.stgit@magnolia>
References: <162078489963.3302755.9219127595550889655.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add a new entry for a structure that was changed in 5.13.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/122.out |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index f229465a..7607f0a5 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -99,6 +99,7 @@ sizeof(struct xfs_inumbers) = 24
 sizeof(struct xfs_inumbers_req) = 64
 sizeof(struct xfs_legacy_timestamp) = 8
 sizeof(struct xfs_log_dinode) = 176
+sizeof(struct xfs_log_legacy_timestamp) = 8
 sizeof(struct xfs_map_extent) = 32
 sizeof(struct xfs_phys_extent) = 16
 sizeof(struct xfs_refcount_key) = 4

