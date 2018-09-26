Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37082 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726914AbeI0DkG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Sep 2018 23:40:06 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id ADA3C2B37
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 16:24:23 -0500 (CDT)
Subject: [PATCH 1/2] scrub: remove redundant debug test
From: Eric Sandeen <sandeen@sandeen.net>
References: <05122b65-0a26-c36f-1efb-78591497ed90@sandeen.net>
Message-ID: <61fa5fe2-0ad9-80b2-f009-68a37682468d@sandeen.net>
Date: Wed, 26 Sep 2018 16:25:12 -0500
MIME-Version: 1.0
In-Reply-To: <05122b65-0a26-c36f-1efb-78591497ed90@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

From: Eric Sandeen <sandeen@redhat.com>

debug_tweak_on() already tests for debug.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 076a86a..33b83a5 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -425,7 +425,7 @@ run_scrub_phases(
 	unsigned int		nr_threads;
 	int			rshift;
 
-	if (debug && debug_tweak_on("XFS_SCRUB_PHASE"))
+	if (debug_tweak_on("XFS_SCRUB_PHASE"))
 		debug_phase = atoi(getenv("XFS_SCRUB_PHASE"));
 
 	/* Run all phases of the scrub tool. */
