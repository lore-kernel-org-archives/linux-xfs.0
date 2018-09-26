Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37244 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726107AbeI0DmW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Sep 2018 23:42:22 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id D3F992B37
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 16:26:38 -0500 (CDT)
Subject: [PATCH 2/2] xfsprogs: document environment variables
From: Eric Sandeen <sandeen@sandeen.net>
References: <05122b65-0a26-c36f-1efb-78591497ed90@sandeen.net>
Message-ID: <959fd8f0-b03d-decd-3048-e1c7d88051fa@sandeen.net>
Date: Wed, 26 Sep 2018 16:27:27 -0500
MIME-Version: 1.0
In-Reply-To: <05122b65-0a26-c36f-1efb-78591497ed90@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

From: Eric Sandeen <sandeen@redhat.com>

Document the various environment variables used in the code,
almost all are for debugging.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/doc/README-env-vars.txt b/doc/README-env-vars.txt
new file mode 100644
index 0000000..eec59a8
--- /dev/null
+++ b/doc/README-env-vars.txt
@@ -0,0 +1,26 @@
+Several environment variables are used within the code, primarily for
+for debugging purposes; they are documented here.  In most cases simply
+setting the environment variable enables the behavior, but in some
+cases the value assigned influences behavior as well, as noted below.
+
+General
+-------
+LIBXFS_LEAK_CHECK            -- warn and exit(1) if zone-allocated memory
+                                is leaked at exit.
+xfs_fsr
+-------
+FSRXFSTEST                   -- enable -C nfrag in theory coalesces into
+                                nfrag extents.  Doesn't work.
+xfs_scrub
+---------
+Known debug tweaks (pass -d and set the environment variable):
+XFS_SCRUB_FORCE_ERROR        -- pretend all metadata is corrupt
+XFS_SCRUB_FORCE_REPAIR       -- repair all metadata even if it's ok
+XFS_SCRUB_NO_KERNEL          -- pretend there is no kernel ioctl
+XFS_SCRUB_NO_SCSI_VERIFY     -- disable SCSI VERIFY (if present)
+XFS_SCRUB_PHASE              -- run only this scrub phase
+XFS_SCRUB_THREADS            -- start exactly this number of threads
+
+Available even in non-debug mode:
+SERVICE_MODE                 -- compress all error codes to 1 for LSB
+                                service action compliance
