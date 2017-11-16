Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39697 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932650AbdKPBWr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Nov 2017 20:22:47 -0500
Subject: [PATCH 4/5] common/rc: check dmesg for UBSAN errors
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 15 Nov 2017 17:22:44 -0800
Message-ID: <151079536403.25590.10714807892659246320.stgit@magnolia>
In-Reply-To: <151079533937.25590.1037061486182471724.stgit@magnolia>
References: <151079533937.25590.1037061486182471724.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If the UBSAN complains about bad behavior, we should capture the dmesg
so that developers can inspect it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/rc |    1 +
 1 file changed, 1 insertion(+)


diff --git a/common/rc b/common/rc
index c700102..cb83918 100644
--- a/common/rc
+++ b/common/rc
@@ -3328,6 +3328,7 @@ _check_dmesg()
 	     -e "INFO: possible circular locking dependency detected" \
 	     -e "general protection fault:" \
 	     -e "BUG .* remaining" \
+	     -e "UBSAN:" \
 	     $seqres.dmesg
 	if [ $? -eq 0 ]; then
 		_dump_err "_check_dmesg: something found in dmesg (see $seqres.dmesg)"

