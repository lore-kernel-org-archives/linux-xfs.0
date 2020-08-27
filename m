Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 998B4C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 19:37:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8091C2087E
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 19:37:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgH0ThT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 15:37:19 -0400
Received: from sandeen.net ([63.231.237.45]:46048 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726250AbgH0ThT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 Aug 2020 15:37:19 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 77CBF2AEA
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 14:37:05 -0500 (CDT)
From:   Eric Sandeen <sandeen@sandeen.net>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] mkfs.xfs: remove comment about needed future work
Message-ID: <3a5c9483-954d-e045-7ebe-645250d61efe@sandeen.net>
Date:   Thu, 27 Aug 2020 14:37:17 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove comment about the need to sync this function with the
kernel; that was mostly taken care of with:

7b7548052 ("mkfs: use libxfs to write out new AGs")

There's maybe a little more samey-samey that we could do here,
but it's not egregiously cut & pasted as it was before.

Signed-off-by: Eric Sandeen <sandeen2redhat.com>
---

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index a687f385..874e40da 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3418,11 +3418,6 @@ prepare_devices(
 
 }
 
-/*
- * XXX: this code is mostly common with the kernel growfs code.
- * These initialisations should be pulled into libxfs to keep the
- * kernel/userspace header initialisation code the same.
- */
 static void
 initialise_ag_headers(
 	struct mkfs_params	*cfg,

