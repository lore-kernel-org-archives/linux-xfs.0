Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35724 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731419AbeISSeQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 Sep 2018 14:34:16 -0400
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 1/2] mkfs: discard only after all validations
Date: Wed, 19 Sep 2018 14:56:16 +0200
Message-Id: <20180919125617.28048-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: sandeen@sandeen.net, Jan Tulak <jtulak@redhat.com>

Discard should happen only when everything has been validated, just
before we start writing to the device. If it happens earlier, it is
possible that mkfs will abort, but managed to already wipe data. This
patch moves the discard to the latest possible moment.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 mkfs/xfs_mkfs.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 2e53c1e8..81d9859a 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2389,8 +2389,7 @@ _("log stripe unit (%d bytes) is too large (maximum is 256KiB)\n"
 static void
 open_devices(
 	struct mkfs_params	*cfg,
-	struct libxfs_xinit	*xi,
-	bool			discard)
+	struct libxfs_xinit	*xi)
 {
 	uint64_t		sector_mask;
 
@@ -2419,8 +2418,16 @@ open_devices(
 	xi->dsize &= sector_mask;
 	xi->rtsize &= sector_mask;
 	xi->logBBsize &= (uint64_t)-1 << (max(cfg->lsectorlog, 10) - BBSHIFT);
+}
 
-
+static void
+discard_data(
+	struct libxfs_xinit	*xi,
+	bool			discard)
+{
+	/*
+	 * This function has to be called after libxfs has been initialized.
+	 */
 	if (!discard)
 		return;
 
@@ -3901,7 +3908,7 @@ main(
 	/*
 	 * Open and validate the device configurations
 	 */
-	open_devices(&cfg, &xi, (discard && !dry_run));
+	open_devices(&cfg, &xi);
 	validate_datadev(&cfg, &cli);
 	validate_logdev(&cfg, &cli, &logfile);
 	validate_rtdev(&cfg, &cli, &rtfile);
@@ -3952,6 +3959,11 @@ main(
 			exit(0);
 	}
 
+	/*
+	 * All values have been validated, discard the old device layout.
+	 */
+	discard_data(&xi, (discard && !dry_run));
+
 	/*
 	 * we need the libxfs buffer cache from here on in.
 	 */
-- 
2.18.0
