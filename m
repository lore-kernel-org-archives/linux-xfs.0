Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56448 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759214AbdKQU2g (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Nov 2017 15:28:36 -0500
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [fstests PATCH v4 1/4] common/rc: add _scratch_has_mount_option()
Date: Fri, 17 Nov 2017 13:28:25 -0700
Message-Id: <20171117202828.25472-2-ross.zwisler@linux.intel.com>
In-Reply-To: <20171117202828.25472-1-ross.zwisler@linux.intel.com>
References: <20171117202828.25472-1-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests <fstests@vger.kernel.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Dan Williams <dan.j.williams@intel.com>, Amir Goldstein <amir73il@gmail.com>

Allow tests to inquire about whether a mount option is set, rather than
just disallowing it via _exclude_scratch_mount_option().

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Amir Goldstein <amir73il@gmail.com>
---
 common/rc | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/common/rc b/common/rc
index 0cda9da..701b1ff 100644
--- a/common/rc
+++ b/common/rc
@@ -3105,6 +3105,16 @@ _exclude_scratch_mount_option()
 	done
 }
 
+_scratch_has_mount_option()
+{
+	local mnt_opts=$(_normalize_mount_options)
+
+	if echo $mnt_opts | grep -qw "$1"; then
+		return 0
+	fi
+	return 1
+}
+
 _require_atime()
 {
 	_exclude_scratch_mount_option "noatime"
-- 
2.9.5

