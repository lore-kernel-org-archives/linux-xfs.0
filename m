Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E49A8C1F
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178013; cv=none; b=PYuuMkdTEC4sXvKYDnB4gBni6LhDXQwYX8XNQdp5tYtDZ9WDNP2IrE/n243qUFpmV5xwoDRmqe7kyViWiL3zzYtNSiyHnIPRx6behRm1MnbiT74zN/lXqnbHpSknu6fGTT9J1UU3fCPWMNL18f9dWBcOtyrUxyjtV/H5QYhXe50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178013; c=relaxed/simple;
	bh=MyLd3vF32XonPQzCgK9lAXx982WePfmr1GmrPAxH7wY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A0hXGK1QtU/EjyBUW9z59l7TRzJ6r+HuAWWtRMw10jPATRtNOwRoY1ixllrAwHOER30MdHH8XmXe5XJEejgFj71hXZtg4I2DF2DZhG+lCzh85aH1JsCn1rtJ5R6aDMxxjEoozSYH+8bKcZhKs6a0hCDZSdXO6zZ+OyCLdrutPak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SgQvfiQI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SgQvfiQI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E58C4CEE7;
	Thu, 23 Oct 2025 00:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178012;
	bh=MyLd3vF32XonPQzCgK9lAXx982WePfmr1GmrPAxH7wY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SgQvfiQIYvO9Ocb0jNOxTDz5JDa7VsonobhLRhvFgNDMW7Hq0AI2slE960uTkIuXr
	 ULuyWkI2P3XbTXft25Va4p+MdLy9wfP1jobMWCsCEgoNNwguvM0JHbxOp48x4TvKGz
	 tmTyV0q82IDCUnj+VW7fjZhnq4antuHEr3kym8NZ0xaoEDSrOnSnGonAnqgZpONilf
	 1dLp5dF+AGsxXq8xcDmpzV2qBDn8ilwA0rKkWThqpZ+NJnOZz8Bv8d2D5jjJ+w8RUh
	 3DPuWkqCE7avs2Rrdb1LYlhQ2hfethdsCQ+cILBcdFRLmJybl9KsK00VNuW7doM9HC
	 d2dLkCim/oLwg==
Date: Wed, 22 Oct 2025 17:06:52 -0700
Subject: [PATCH 05/26] xfs: report shutdown events through healthmon
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117747562.1028044.13964896352426234592.stgit@frogsfrogsfrogs>
In-Reply-To: <176117747330.1028044.14577065342150898892.stgit@frogsfrogsfrogs>
References: <176117747330.1028044.14577065342150898892.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Set up a shutdown hook so that we can send notifications to userspace.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/xfs_fs.h                  |   18 +++++++++++
 libxfs/xfs_healthmon.schema.json |   62 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 80 insertions(+)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 358abe98776d69..918362a7294f27 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -1028,6 +1028,9 @@ struct xfs_rtgroup_geometry {
 /* filesystem was unmounted */
 #define XFS_HEALTH_MONITOR_TYPE_UNMOUNT		(5)
 
+/* filesystem shutdown */
+#define XFS_HEALTH_MONITOR_TYPE_SHUTDOWN	(6)
+
 /* lost events */
 struct xfs_health_monitor_lost {
 	__u64	count;
@@ -1054,6 +1057,20 @@ struct xfs_health_monitor_inode {
 	__u64	ino;
 };
 
+/* shutdown reasons */
+#define XFS_HEALTH_SHUTDOWN_META_IO_ERROR	(1u << 0)
+#define XFS_HEALTH_SHUTDOWN_LOG_IO_ERROR	(1u << 1)
+#define XFS_HEALTH_SHUTDOWN_FORCE_UMOUNT	(1u << 2)
+#define XFS_HEALTH_SHUTDOWN_CORRUPT_INCORE	(1u << 3)
+#define XFS_HEALTH_SHUTDOWN_CORRUPT_ONDISK	(1u << 4)
+#define XFS_HEALTH_SHUTDOWN_DEVICE_REMOVED	(1u << 5)
+
+/* shutdown */
+struct xfs_health_monitor_shutdown {
+	/* XFS_HEALTH_SHUTDOWN_* flags */
+	__u32	reasons;
+};
+
 struct xfs_health_monitor_event {
 	/* XFS_HEALTH_MONITOR_DOMAIN_* */
 	__u32	domain;
@@ -1074,6 +1091,7 @@ struct xfs_health_monitor_event {
 		struct xfs_health_monitor_fs fs;
 		struct xfs_health_monitor_group group;
 		struct xfs_health_monitor_inode inode;
+		struct xfs_health_monitor_shutdown shutdown;
 	} e;
 
 	/* zeroes */
diff --git a/libxfs/xfs_healthmon.schema.json b/libxfs/xfs_healthmon.schema.json
index dd78f1b71d587b..1657ccc482edff 100644
--- a/libxfs/xfs_healthmon.schema.json
+++ b/libxfs/xfs_healthmon.schema.json
@@ -36,6 +36,9 @@
 		},
 		{
 			"$ref": "#/$events/inode_metadata"
+		},
+		{
+			"$ref": "#/$events/shutdown"
 		}
 	],
 
@@ -204,6 +207,31 @@
 		}
 	},
 
+	"$comment": "Shutdown event data are defined here.",
+	"$shutdown": {
+		"reason": {
+			"description": [
+				"Reason for a filesystem to shut down.",
+				"Options include:",
+				"",
+				" * corrupt_incore: in-memory corruption",
+				" * corrupt_ondisk: on-disk corruption",
+				" * device_removed: device removed",
+				" * force_umount:   userspace asked for it",
+				" * log_ioerr:      log write IO error",
+				" * meta_ioerr:     metadata writeback IO error"
+			],
+			"enum": [
+				"corrupt_incore",
+				"corrupt_ondisk",
+				"device_removed",
+				"force_umount",
+				"log_ioerr",
+				"meta_ioerr"
+			]
+		}
+	},
+
 	"$comment": "Event types are defined here.",
 	"$events": {
 		"running": {
@@ -439,6 +467,40 @@
 				"generation",
 				"structures"
 			]
+		},
+		"shutdown": {
+			"title": "Abnormal Shutdown Event",
+			"description": [
+				"The filesystem went offline due to",
+				"unrecoverable errors."
+			],
+			"type": "object",
+
+			"properties": {
+				"type": {
+					"const": "shutdown"
+				},
+				"time_ns": {
+					"$ref": "#/$defs/time_ns"
+				},
+				"domain": {
+					"const": "mount"
+				},
+				"reasons": {
+					"type": "array",
+					"items": {
+						"$ref": "#/$shutdown/reason"
+					},
+					"minItems": 1
+				}
+			},
+
+			"required": [
+				"type",
+				"time_ns",
+				"domain",
+				"reasons"
+			]
 		}
 	}
 }

