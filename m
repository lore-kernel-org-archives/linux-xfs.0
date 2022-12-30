Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD48FC3DA7A
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:29:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236404AbiLaD33 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:29:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236402AbiLaD32 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:29:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE94164B7;
        Fri, 30 Dec 2022 19:29:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8981861CCF;
        Sat, 31 Dec 2022 03:29:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE28DC433D2;
        Sat, 31 Dec 2022 03:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672457367;
        bh=IV0aamgy4K0DdVxkPbzMs+YOg0ijFukhh1Z1mfiSy+A=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bJbjHp/ioS11tae/SBs9ojzvxOHD6m95+7AAyHqroYhnjWbz4/+x8h0jw7C4a2WIQ
         0jAZZBGDUQgd48gBrO/ZRFCpmoZPJAXtAqJSDN3GOOTOg0/evzpqkK0TopFXj+taTL
         YYpP4FzXhKf36MQpSSArU9KZy9id9Uv9K6tZfSsln4l+SdOcoD6wMVq++ZhmMbv8dy
         9A2GJx/pA5KNwEdFsxWW/qExpo7MMKPpYv6DkDMtj5eQrV1WI0Q1C1quYGdlBM3ddE
         pV8HJdTX5oJG9XTSVTgQBmPqEXbKEYUNH4LPxLGUlBYPTSEpdvIbkBC/OUZDC5LIax
         xXeArdjB95kVA==
Subject: [PATCH 1/1] xfs/122: update for vectored scrub
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:21:12 -0800
Message-ID: <167243887202.741937.5299206600338829783.stgit@magnolia>
In-Reply-To: <167243887190.741937.14206419277494972578.stgit@magnolia>
References: <167243887190.741937.14206419277494972578.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add the two new vectored scrub structures.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/122.out |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 3239a655f9..43461e875c 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -126,6 +126,8 @@ sizeof(struct xfs_rtsb) = 104
 sizeof(struct xfs_rud_log_format) = 16
 sizeof(struct xfs_rui_log_format) = 16
 sizeof(struct xfs_scrub_metadata) = 64
+sizeof(struct xfs_scrub_vec) = 16
+sizeof(struct xfs_scrub_vec_head) = 24
 sizeof(struct xfs_swap_extent) = 64
 sizeof(struct xfs_sxd_log_format) = 16
 sizeof(struct xfs_sxi_log_format) = 80

