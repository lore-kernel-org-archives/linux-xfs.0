Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54D2FC433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:18:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D85361A21
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:18:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237403AbhCXSST (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 14:18:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:42182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237409AbhCXSRt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Mar 2021 14:17:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03AD061A1B;
        Wed, 24 Mar 2021 18:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616609869;
        bh=PHW+itKasNwhXdRfgi2Gjc8ifs0k0rN7tW4G1vIzC5o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eP84X45BsvH/SKvFLNZNLj7/xrh1kAHD5nvlOGmuxPAt647ElsBNIz4hYsOza4uXD
         b1PpmyggjpCnz7pLsCrP4WVJCisk9gC6C5cQu028gM9Z+3OcUWmQiOTieznCJ88X7H
         xGK96BppVD/X45kQHz/mnqOOPi6DZHq/3hEvrCEd42/ztgUgP2iAc9kqNTCWYzxlsn
         jVW+/0QM3+Vj1w/cX9rlxukwz6M1GFWZccE6hniqjTC9ww0GeiU9gwayYs7YCwhTTi
         T6vTR415ErAQKFNyFDVd9Yd1jG7zD4sVOtZk1VMDmjCOW0T1dl/6NCCxT7+iOgZI3H
         32T/5/S2HFXiQ==
Date:   Wed, 24 Mar 2021 11:17:48 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        hch@infradead.org
Subject: [PATCH v1.1 3/3] common/populate: change how we describe cached
 populated images
Message-ID: <20210324181748.GK1670408@magnolia>
References: <161647318241.3429609.1862044070327396092.stgit@magnolia>
 <161647319905.3429609.14862078528489327236.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161647319905.3429609.14862078528489327236.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The device name of a secondary storage device isn't all that important,
but the size is.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v1.1: fix variable names
---
 common/populate |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/common/populate b/common/populate
index c01b7e0e..d484866a 100644
--- a/common/populate
+++ b/common/populate
@@ -808,13 +808,23 @@ _fill_fs()
 _scratch_populate_cache_tag() {
 	local extra_descr=""
 	local size="$(blockdev --getsz "${SCRATCH_DEV}")"
+	local logdev_sz="none"
+	local rtdev_sz="none"
+
+	if [ "${USE_EXTERNAL}" = "yes" ] && [ -n "${SCRATCH_LOGDEV}" ]; then
+		logdev_sz="$(blockdev --getsz "${SCRATCH_LOGDEV}")"
+	fi
+
+	if [ "${USE_EXTERNAL}" = "yes" ] && [ -n "${SCRATCH_RTDEV}" ]; then
+		rtdev_sz="$(blockdev --getsz "${SCRATCH_RTDEV}")"
+	fi
 
 	case "${FSTYP}" in
 	"ext4")
-		extra_descr="LOGDEV ${SCRATCH_LOGDEV} USE_EXTERNAL ${USE_EXTERNAL}"
+		extra_descr="LOGDEV_SIZE ${logdev_sz}"
 		;;
 	"xfs")
-		extra_descr="LOGDEV ${SCRATCH_LOGDEV} USE_EXTERNAL ${USE_EXTERNAL} RTDEV ${SCRATCH_RTDEV}"
+		extra_descr="LOGDEV_SIZE ${logdev_sz} RTDEV_SIZE ${rtdev_sz}"
 		_populate_xfs_qmount_option
 		if echo "${MOUNT_OPTIONS}" | grep -q 'usrquota'; then
 			extra_descr="${extra_descr} QUOTAS"
