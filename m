Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49964 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727265AbfBLCRw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Feb 2019 21:17:52 -0500
Subject: [PATCH 1/2] inject: skip tests when knob dir exists but knob doesn't
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 11 Feb 2019 18:17:48 -0800
Message-ID: <154993786856.2062.15965021741779968907.stgit@magnolia>
In-Reply-To: <154993786231.2062.8490515215533507881.stgit@magnolia>
References: <154993786231.2062.8490515215533507881.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If the XFS error injection knob directory exists but the knob itself
doesn't, then we know that this kernel doesn't support the knob and
can skip the test.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/inject |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/common/inject b/common/inject
index 903fb379..984ec209 100644
--- a/common/inject
+++ b/common/inject
@@ -62,6 +62,13 @@ _require_xfs_io_error_injection()
 	knob="$(_find_xfs_mountdev_errortag_knob "${TEST_DEV}" "${type}")"
 	test -w "${knob}" && return
 
+	# If the directory containing the sysfs error injection knob exists
+	# but the knob itself isn't usable, this kernel doesn't know about
+	# the knob.  Skip the test.
+	if [ -d "$(dirname "${knob}")" ]; then
+		_notrun "XFS error injection $type unknown on this kernel."
+	fi
+
 	# NOTE: We can't actually test error injection here because xfs
 	# hasn't always range checked the argument to xfs_errortag_add.
 	# We also don't want to trip an error before we're ready to deal
