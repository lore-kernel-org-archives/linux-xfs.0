Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60029C07E95
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jul 2021 01:26:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43C946113B
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jul 2021 01:26:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381524AbhGTAbi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Jul 2021 20:31:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:41960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1381233AbhGTA3x (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Jul 2021 20:29:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA3B461181;
        Tue, 20 Jul 2021 01:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626743354;
        bh=Zprt2tY43kp5tFNaM73vJU/jSBiiiXwPjoDNecZd1Ak=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DhxCgOxBRWT8Zr/BfmwV+tpT6qZpVyAkxTgtE3Q5uHIuLtobYabaqTtB7hIqHt9C3
         GhkmXoMKPt6J6o5Y4Bz1llxHM93WLxPn+cYBMVqsLHwrhQs1E5D1mxeo+mlkI2Fyyy
         2zi1qcbwHO9H47/DIl31u5UA01v7DS5fT8f51QxWFka1bea8lhFbegGFLBf/AcPObd
         KiRtmjij2EkJGlCV7TRuuS/0n9XZP/lL+wnuv7ToBd4Qpt0Wh400YS/g1oKRD0HJ+D
         Z5NHujoYcbEG6z6ocivzY6cWINuXvwiy4JjIf+MsuHs5ZLEvoU7QkIPvvqboICaGJD
         jNK2/TxrHEMmw==
Subject: [PATCH 2/3] dmerror: export configuration so that subprograms don't
 have to reinit
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        tytso@mit.edu
Date:   Mon, 19 Jul 2021 18:09:13 -0700
Message-ID: <162674335368.2651055.3174851724980962325.stgit@magnolia>
In-Reply-To: <162674334277.2651055.14927938006488444114.stgit@magnolia>
References: <162674334277.2651055.14927938006488444114.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Export the dmerror configuration variables so that subprograms don't
have to reinitialize the configuration in their own subprograms before
calling the helpers.  In the next patch (where we allow dmerror for log
and rt devices) it will become important to avoid these
reinitializations.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/dmerror |    8 +++++---
 src/dmerror    |   13 +++++--------
 2 files changed, 10 insertions(+), 11 deletions(-)


diff --git a/common/dmerror b/common/dmerror
index 6f1bef09..7f6800c0 100644
--- a/common/dmerror
+++ b/common/dmerror
@@ -10,11 +10,11 @@ _dmerror_setup()
 
 	local blk_dev_size=`blockdev --getsz $dm_backing_dev`
 
-	DMERROR_DEV='/dev/mapper/error-test'
+	export DMERROR_DEV='/dev/mapper/error-test'
 
-	DMLINEAR_TABLE="0 $blk_dev_size linear $dm_backing_dev 0"
+	export DMLINEAR_TABLE="0 $blk_dev_size linear $dm_backing_dev 0"
 
-	DMERROR_TABLE="0 $blk_dev_size error $dm_backing_dev 0"
+	export DMERROR_TABLE="0 $blk_dev_size error $dm_backing_dev 0"
 }
 
 _dmerror_init()
@@ -42,6 +42,8 @@ _dmerror_cleanup()
 	$DMSETUP_PROG resume error-test > /dev/null 2>&1
 	$UMOUNT_PROG $SCRATCH_MNT > /dev/null 2>&1
 	_dmsetup_remove error-test
+
+	unset DMERROR_DEV DMLINEAR_TABLE DMERROR_TABLE
 }
 
 _dmerror_load_error_table()
diff --git a/src/dmerror b/src/dmerror
index c34d1a9a..cde2b428 100755
--- a/src/dmerror
+++ b/src/dmerror
@@ -5,15 +5,12 @@
 . ./common/config
 . ./common/dmerror
 
-_dmerror_setup
+if [ -z "$DMERROR_DEV" ]; then
+	echo "Caller should have run _dmerror_init."
+	exit 1
+fi
 
 case $1 in
-cleanup)
-	_dmerror_cleanup
-	;;
-init)
-	_dmerror_init
-	;;
 load_error_table)
 	_dmerror_load_error_table
 	;;
@@ -21,7 +18,7 @@ load_working_table)
 	_dmerror_load_working_table
 	;;
 *)
-	echo "Usage: $0 {init|cleanup|load_error_table|load_working_table}"
+	echo "Usage: $0 {load_error_table|load_working_table}"
 	exit 1
 	;;
 esac

