Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B60E9C433C1
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 04:21:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8405C619AE
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 04:21:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbhCWEU3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Mar 2021 00:20:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229464AbhCWET7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Mar 2021 00:19:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A11A6198E;
        Tue, 23 Mar 2021 04:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616473199;
        bh=CZb3ZIvrFD4xXviq3uk8k4wTqG9BYGXiirhmTUr59jQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=o87J1y2aiRxPFYXOY20xhQrnnwA9W+g33aJYirOszpiuY7MxvCYdBZ13YEedgkvPM
         EydMWc24SiJ11g819nP3k28oULF9n/znzv7agEPm0QLEwfZUSxh9iUAPNG1hyH3Dvb
         Bj/kHUZ6SazIZa/wz0OS39VT/Q7WG/6NLacJKcESxuX1c8P46CHi02aDr0zdqF2tUf
         PDFUtj6t7zm+U/LFEcxT5jAr2rOCXF+hB6aM2BY5TZ0ahLULCrD7JlkEfRWYcZCQ5O
         h29wjKutBpt3IewY8KusmuPgFOyGmtXHCkyH6CRkOybeQNnR/qDgScwFp24+C33WVK
         ktVpqhMWexDhg==
Subject: [PATCH 3/3] common/populate: change how we describe cached populated
 images
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 22 Mar 2021 21:19:59 -0700
Message-ID: <161647319905.3429609.14862078528489327236.stgit@magnolia>
In-Reply-To: <161647318241.3429609.1862044070327396092.stgit@magnolia>
References: <161647318241.3429609.1862044070327396092.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The device name of a secondary storage device isn't all that important,
but the size is.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/populate |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)


diff --git a/common/populate b/common/populate
index c01b7e0e..94bf5ce9 100644
--- a/common/populate
+++ b/common/populate
@@ -808,13 +808,23 @@ _fill_fs()
 _scratch_populate_cache_tag() {
 	local extra_descr=""
 	local size="$(blockdev --getsz "${SCRATCH_DEV}")"
+	local logdev="none"
+	local rtdev="none"
+
+	if [ "${USE_EXTERNAL}" = "yes" ] && [ -n "${SCRATCH_LOGDEV}" ]; then
+		logdev="$(blockdev --getsz "${SCRATCH_LOGDEV}")"
+	fi
+
+	if [ "${USE_EXTERNAL}" = "yes" ] && [ -n "${SCRATCH_RTDEV}" ]; then
+		rtdev="$(blockdev --getsz "${SCRATCH_RTDEV}")"
+	fi
 
 	case "${FSTYP}" in
 	"ext4")
-		extra_descr="LOGDEV ${SCRATCH_LOGDEV} USE_EXTERNAL ${USE_EXTERNAL}"
+		extra_descr="LOGDEV_SIZE ${logdev}"
 		;;
 	"xfs")
-		extra_descr="LOGDEV ${SCRATCH_LOGDEV} USE_EXTERNAL ${USE_EXTERNAL} RTDEV ${SCRATCH_RTDEV}"
+		extra_descr="LOGDEV_SIZE ${logdev} RTDEV_SIZE ${rtdev}"
 		_populate_xfs_qmount_option
 		if echo "${MOUNT_OPTIONS}" | grep -q 'usrquota'; then
 			extra_descr="${extra_descr} QUOTAS"

