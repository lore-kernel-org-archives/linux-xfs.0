Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDF38C3DA7D
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:55:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235605AbiL3Wzr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:55:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235490AbiL3Wzr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:55:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF2A6F7;
        Fri, 30 Dec 2022 14:55:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B07561AC4;
        Fri, 30 Dec 2022 22:55:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F92C433EF;
        Fri, 30 Dec 2022 22:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440945;
        bh=Y2Jx8eIWENFg14c1hFYXP1NthflUe0vjDug5mZu7fgQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ime3PQjmDArfhzcEu1B2JZEWLjrCFywv+tAMDA1wRwlSFrsec2Rq7Flf16uXhOxJH
         KS3GbI8mRz+8LgtHLhRwf+jEBYWlbEVRhHbWOmYFEfsvl0H/rzLIrRSMzeaHqB8/k4
         WuR8WWWZFSp/yZAt5Xb48yVoE6Up0PoFjESYy+WlpHDj5QVKVYHGNUV61sHzNlnM98
         6mAWFhJIuHHqVx2khg8ySYW951D3BxZIn5jGXe+7vzO39i+Lo3jz8f4Q8Yc2Z5btYG
         qxakjO697oecX9ujcSePQj3htVrb9w/YotYTEi+gOdM2QzZhfjdqNavOjN2tCnZb7A
         1tKtt5XK5+kRg==
Subject: [PATCH 06/16] fuzzy: explicitly check for common/inject in
 _require_xfs_stress_online_repair
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:12:53 -0800
Message-ID: <167243837380.694541.16030787606766361808.stgit@magnolia>
In-Reply-To: <167243837296.694541.13203497631389630964.stgit@magnolia>
References: <167243837296.694541.13203497631389630964.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In _require_xfs_stress_online_repair, make sure that the test has
sourced common/inject before we try to call its functions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/common/fuzzy b/common/fuzzy
index 94a6ce85a3..de9e398984 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -382,6 +382,8 @@ _require_xfs_stress_scrub() {
 _require_xfs_stress_online_repair() {
 	_require_xfs_stress_scrub
 	_require_xfs_io_command "repair"
+	command -v _require_xfs_io_error_injection &>/dev/null || \
+		_notrun 'xfs repair stress test requires common/inject'
 	_require_xfs_io_error_injection "force_repair"
 	_require_freeze
 }

