Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2E58C07E9C
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 00:21:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADD3C61CAD
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 00:21:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbhGGAYJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jul 2021 20:24:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229873AbhGGAYI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Jul 2021 20:24:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DEEA619B9;
        Wed,  7 Jul 2021 00:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625617289;
        bh=wGU90Unr0g1HSxXhPYJwFr3DMSyFOBLmzQzyrlTUh00=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=igRqwbYF1sbyM1fhVJKt1T+vMkPsmLC5OT5+s7YFGEcNT6APetTRscVrL99y+lJAz
         0333gJ8TsrTvXWcTtOd1mnZP5rtP/FJoJHzVleE2W3mjufj2wgkMFftiWbCLnNjB1p
         DehjbqXmAN7Luit6PYC7cmFibneUb17DY3ddTnrzC+Qq2BbZP/xNxtr+yfh2s5T++Y
         khwTFLJogNpDtKTV2eN5TTU5ol/jm1OLz413RkENiDkXziQ0aU0uEdM20HMGNbsQvy
         Q8uNnATjbj6HBBaMzNkJiz/H9Z9OetOXAkEs9phJkY5npYsGLZnQD9n1xRItrUcpTg
         1wUxgQGQU8XyA==
Subject: [PATCH 4/8] dmthin: erase the metadata device properly before
 starting
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 06 Jul 2021 17:21:28 -0700
Message-ID: <162561728893.543423.5093723938379703860.stgit@locust>
In-Reply-To: <162561726690.543423.15033740972304281407.stgit@locust>
References: <162561726690.543423.15033740972304281407.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Every now and then I see the following failure when running generic/347:

--- generic/347.out
+++ generic/347.out.bad
@@ -1,2 +1,2 @@
 QA output created by 347
-=== completed
+failed to create dm thin pool device

Accompanied by the following dmesg spew:

device-mapper: thin metadata: sb_check failed: blocknr 7016996765293437281: wanted 0
device-mapper: block manager: superblock validator check failed for block 0
device-mapper: thin metadata: couldn't read superblock
device-mapper: table: 253:2: thin-pool: Error creating metadata object
device-mapper: ioctl: error adding target to table

7016996765293437281 is of course the magic number 0x6161616161616161,
which are stale ondisk contents left behind by previous tests that wrote
known tests patterns to files on the scratch device.  This is a bit
surprising, since _dmthin_init supposedly zeroes the first 4k of the
thin pool metadata device before initializing the pool.  Or does it?

dd if=/dev/zero of=$DMTHIN_META_DEV bs=4096 count=1 &>/dev/null

Herein lies the problem: the dd process writes zeroes into the page
cache and exits.  Normally the block layer will flush the page cache
after the last file descriptor is closed, but once in a while the
terminating dd process won't be the only process in the system with an
open file descriptor!

That process is of course udev.  The write() call from dd triggers a
kernel uevent, which starts udev.  If udev is running particularly
slowly, it'll still be running an instant later when dd terminates,
thereby preventing the page cache flush.  If udev is still running a
moment later when we call dmsetup to set up the thin pool, the pool
creation will issue a bio to read the ondisk superblock.  This read
isn't coherent with the page cache, so it sees old disk contents and the
test fails even though we supposedly formatted the metadata device.

Fix this by explicitly flushing the page cache after writing the zeroes.

Fixes: 4b52fffb ("dm-thinp helpers in common/dmthin")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/dmthin |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)


diff --git a/common/dmthin b/common/dmthin
index 3b1c7d45..91147e47 100644
--- a/common/dmthin
+++ b/common/dmthin
@@ -113,8 +113,12 @@ _dmthin_init()
 	_dmsetup_create $DMTHIN_DATA_NAME --table "$DMTHIN_DATA_TABLE" || \
 		_fatal "failed to create dm thin data device"
 
-	# Zap the pool metadata dev
-	dd if=/dev/zero of=$DMTHIN_META_DEV bs=4096 count=1 &>/dev/null
+	# Zap the pool metadata dev.  Explicitly fsync the zeroes to disk
+	# because a slow-running udev running concurrently with dd can maintain
+	# an open file descriptor.  The block layer only flushes the page cache
+	# on last close, which means that the thin pool creation below will
+	# see the (stale) ondisk contents and fail.
+	dd if=/dev/zero of=$DMTHIN_META_DEV bs=4096 count=1 conv=fsync &>/dev/null
 
 	# Thin pool
 	# "start length thin-pool metadata_dev data_dev data_block_size low_water_mark"

