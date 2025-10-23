Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3B31FDA
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761177998; cv=none; b=Wiez8/6RgMO/HR3ugeIBbOYE0E8Grn/59RVVemCAuxVnHoSUVXBoLPusodMwIh9EXuKKZY+TvfanSY6097tCgRLvxLcgu8j5/9kvXJ3H1lPSyb6bGHctDH2ldspdy3ILSSCID/57m33WIWDRZcqQOmSQWKQftpYvKQ8BGche0lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761177998; c=relaxed/simple;
	bh=7JOyNULUWw56RarLCAmSBTAXTiNGp5WC96+OzaAKaFI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RmVBxKTuOVKCIAVt7jtwO4HYAY7/KTZed/DAjEVh/lgHiIR8JQdelc3CjqlvVOUpmvrlLLiNr3V3YvqGs0f4lr0tzSzVv7DeKNFmJJycuOOI3opRfJhxvyM35FoLP7yCelzKVYwWFkxGnL58vGDnVqMiRh4Q/lPVvOSugJCh9rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U/a3huMJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U/a3huMJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A6DC4CEE7;
	Thu, 23 Oct 2025 00:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761177996;
	bh=7JOyNULUWw56RarLCAmSBTAXTiNGp5WC96+OzaAKaFI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=U/a3huMJsBjernMsXmDk59QLWi+kUMkzknD2Y1Yxjq3LBCGml2QNoRMpseqlt9nDF
	 bZ7sSdsFODI+meHWpb+czmoJA4tYlc0uVS2BIEwOptpbIHuzlul/gPuaHHle6UNN/Y
	 sKzrOagrzob/5zL8d5AR1squ4s76j2obhMC4qna9VlDw8CGzQKZ8+SNTZGM4DYfieo
	 wNi7gyv/DFwllFn+88jDm7Q+u2UUz+/n2/9u6uyzwAQR9N8jlWdIFkjJIQ/M4sPvxI
	 /Ehc8p25aypj2onySxpyFbHuAYZlc/v1gFiMNvKVdhDNt1pIDUQOUXOQs36B3wILdJ
	 OBq/NrGxdPOyg==
Date: Wed, 22 Oct 2025 17:06:36 -0700
Subject: [PATCH 04/26] xfs: report metadata health events through healthmon
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117747543.1028044.3682837109056262399.stgit@frogsfrogsfrogs>
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

Set up a metadata health event hook so that we can send events to
userspace as we collect information.  The unmount hook severs the weak
reference between the health monitor and the filesystem it's monitoring;
when this happens, we stop reporting events because there's no longer
any point.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/xfs_fs.h                  |   38 +++++
 libxfs/xfs_health.h              |    5 +
 libxfs/xfs_healthmon.schema.json |  315 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 358 insertions(+)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 4b642eea18b5ca..358abe98776d69 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -1008,17 +1008,52 @@ struct xfs_rtgroup_geometry {
 /* affects the whole fs */
 #define XFS_HEALTH_MONITOR_DOMAIN_MOUNT		(0)
 
+/* metadata health events */
+#define XFS_HEALTH_MONITOR_DOMAIN_FS		(1)
+#define XFS_HEALTH_MONITOR_DOMAIN_AG		(2)
+#define XFS_HEALTH_MONITOR_DOMAIN_INODE		(3)
+#define XFS_HEALTH_MONITOR_DOMAIN_RTGROUP	(4)
+
 /* Health monitor event types */
 
 /* status of the monitor itself */
 #define XFS_HEALTH_MONITOR_TYPE_RUNNING		(0)
 #define XFS_HEALTH_MONITOR_TYPE_LOST		(1)
 
+/* metadata health events */
+#define XFS_HEALTH_MONITOR_TYPE_SICK		(2)
+#define XFS_HEALTH_MONITOR_TYPE_CORRUPT		(3)
+#define XFS_HEALTH_MONITOR_TYPE_HEALTHY		(4)
+
+/* filesystem was unmounted */
+#define XFS_HEALTH_MONITOR_TYPE_UNMOUNT		(5)
+
 /* lost events */
 struct xfs_health_monitor_lost {
 	__u64	count;
 };
 
+/* fs/rt metadata */
+struct xfs_health_monitor_fs {
+	/* XFS_FSOP_GEOM_SICK_* flags */
+	__u32	mask;
+};
+
+/* ag/rtgroup metadata */
+struct xfs_health_monitor_group {
+	/* XFS_{AG,RTGROUP}_SICK_* flags */
+	__u32	mask;
+	__u32	gno;
+};
+
+/* inode metadata */
+struct xfs_health_monitor_inode {
+	/* XFS_BS_SICK_* flags */
+	__u32	mask;
+	__u32	gen;
+	__u64	ino;
+};
+
 struct xfs_health_monitor_event {
 	/* XFS_HEALTH_MONITOR_DOMAIN_* */
 	__u32	domain;
@@ -1036,6 +1071,9 @@ struct xfs_health_monitor_event {
 	 */
 	union {
 		struct xfs_health_monitor_lost lost;
+		struct xfs_health_monitor_fs fs;
+		struct xfs_health_monitor_group group;
+		struct xfs_health_monitor_inode inode;
 	} e;
 
 	/* zeroes */
diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index 39fef33dedc6a8..9ff3bf8ba4ed8f 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
@@ -336,4 +336,9 @@ void xfs_health_hook_del(struct xfs_mount *mp, struct xfs_health_hook *hook);
 void xfs_health_hook_setup(struct xfs_health_hook *hook, notifier_fn_t mod_fn);
 #endif /* CONFIG_XFS_LIVE_HOOKS */
 
+unsigned int xfs_healthmon_inode_mask(unsigned int sick_mask);
+unsigned int xfs_healthmon_rtgroup_mask(unsigned int sick_mask);
+unsigned int xfs_healthmon_perag_mask(unsigned int sick_mask);
+unsigned int xfs_healthmon_fs_mask(unsigned int sick_mask);
+
 #endif	/* __XFS_HEALTH_H__ */
diff --git a/libxfs/xfs_healthmon.schema.json b/libxfs/xfs_healthmon.schema.json
index 68762738b04191..dd78f1b71d587b 100644
--- a/libxfs/xfs_healthmon.schema.json
+++ b/libxfs/xfs_healthmon.schema.json
@@ -24,6 +24,18 @@
 		},
 		{
 			"$ref": "#/$events/lost"
+		},
+		{
+			"$ref": "#/$events/fs_metadata"
+		},
+		{
+			"$ref": "#/$events/rtgroup_metadata"
+		},
+		{
+			"$ref": "#/$events/perag_metadata"
+		},
+		{
+			"$ref": "#/$events/inode_metadata"
 		}
 	],
 
@@ -39,6 +51,156 @@
 			"description": "Number of events.",
 			"type": "integer",
 			"minimum": 1
+		},
+		"xfs_agnumber_t": {
+			"description": "Allocation group number",
+			"type": "integer",
+			"minimum": 0,
+			"maximum": 2147483647
+		},
+		"xfs_rgnumber_t": {
+			"description": "Realtime allocation group number",
+			"type": "integer",
+			"minimum": 0,
+			"maximum": 2147483647
+		},
+		"xfs_ino_t": {
+			"description": "Inode number",
+			"type": "integer",
+			"minimum": 1
+		},
+		"i_generation": {
+			"description": "Inode generation number",
+			"type": "integer"
+		}
+	},
+
+	"$comment": "Filesystem metadata event data are defined here.",
+	"$metadata": {
+		"status": {
+			"description": "Metadata health status",
+			"$comment": [
+				"One of:",
+				"",
+				" * sick:    metadata corruption discovered",
+				"            during a runtime operation.",
+				" * corrupt: corruption discovered during",
+				"            an xfs_scrub run.",
+				" * healthy: metadata object was found to be",
+				"            ok by xfs_scrub."
+			],
+			"enum": [
+				"sick",
+				"corrupt",
+				"healthy"
+			]
+		},
+		"fs": {
+			"description": [
+				"Metadata structures that affect the entire",
+				"filesystem.  Options include:",
+				"",
+				" * fscounters: summary counters",
+				" * usrquota:   user quota records",
+				" * grpquota:   group quota records",
+				" * prjquota:   project quota records",
+				" * quotacheck: quota counters",
+				" * nlinks:     file link counts",
+				" * metadir:    metadata directory",
+				" * metapath:   metadata inode paths"
+			],
+			"enum": [
+				"fscounters",
+				"grpquota",
+				"metadir",
+				"metapath",
+				"nlinks",
+				"prjquota",
+				"quotacheck",
+				"usrquota"
+			]
+		},
+		"perag": {
+			"description": [
+				"Metadata structures owned by allocation",
+				"groups on the data device.  Options include:",
+				"",
+				" * agf:        group space header",
+				" * agfl:       per-group free block list",
+				" * agi:        group inode header",
+				" * bnobt:      free space by position btree",
+				" * cntbt:      free space by length btree",
+				" * finobt:     free inode btree",
+				" * inobt:      inode btree",
+				" * rmapbt:     reverse mapping btree",
+				" * refcountbt: reference count btree",
+				" * inodes:     problems were recorded for",
+				"               this group's inodes, but the",
+				"               inodes themselves had to be",
+				"               reclaimed.",
+				" * super:      superblock"
+			],
+			"enum": [
+				"agf",
+				"agfl",
+				"agi",
+				"bnobt",
+				"cntbt",
+				"finobt",
+				"inobt",
+				"inodes",
+				"refcountbt",
+				"rmapbt",
+				"super"
+			]
+		},
+		"rtgroup": {
+			"description": [
+				"Metadata structures owned by allocation",
+				"groups on the realtime volume.  Options",
+				"include:",
+				"",
+				" * bitmap:     free space bitmap contents",
+				"               for this group",
+				" * summary:    realtime free space summary file",
+				" * rmapbt:     reverse mapping btree",
+				" * refcountbt: reference count btree",
+				" * super:      group superblock"
+			],
+			"enum": [
+				"bitmap",
+				"summary",
+				"refcountbt",
+				"rmapbt",
+				"super"
+			]
+		},
+		"inode": {
+			"description": [
+				"Metadata structures owned by file inodes.",
+				"Options include:",
+				"",
+				" * bmapbta:    attr fork",
+				" * bmapbtc:    cow fork",
+				" * bmapbtd:    data fork",
+				" * core:       inode record",
+				" * directory:  directory entries",
+				" * dirtree:    directory tree problems detected",
+				" * parent:     directory parent pointer",
+				" * symlink:    symbolic link target",
+				" * xattr:      extended attributes"
+			],
+			"enum": [
+				"bmapbta",
+				"bmapbtc",
+				"bmapbtd",
+				"core",
+				"directory",
+				"dirtree",
+				"parent",
+				"symlink",
+				"xattr"
+			]
 		}
 	},
 
@@ -124,6 +286,159 @@
 				"time_ns",
 				"domain"
 			]
+		},
+		"fs_metadata": {
+			"title": "Filesystem-wide metadata event",
+			"description": [
+				"Health status updates for filesystem-wide",
+				"metadata objects."
+			],
+			"type": "object",
+
+			"properties": {
+				"type": {
+					"$ref": "#/$metadata/status"
+				},
+				"time_ns": {
+					"$ref": "#/$defs/time_ns"
+				},
+				"domain": {
+					"const": "fs"
+				},
+				"structures": {
+					"type": "array",
+					"items": {
+						"$ref": "#/$metadata/fs"
+					},
+					"minItems": 1
+				}
+			},
+
+			"required": [
+				"type",
+				"time_ns",
+				"domain",
+				"structures"
+			]
+		},
+		"perag_metadata": {
+			"title": "Data device allocation group metadata event",
+			"description": [
+				"Health status updates for data device ",
+				"allocation group metadata."
+			],
+			"type": "object",
+
+			"properties": {
+				"type": {
+					"$ref": "#/$metadata/status"
+				},
+				"time_ns": {
+					"$ref": "#/$defs/time_ns"
+				},
+				"domain": {
+					"const": "perag"
+				},
+				"group": {
+					"$ref": "#/$defs/xfs_agnumber_t"
+				},
+				"structures": {
+					"type": "array",
+					"items": {
+						"$ref": "#/$metadata/perag"
+					},
+					"minItems": 1
+				}
+			},
+
+			"required": [
+				"type",
+				"time_ns",
+				"domain",
+				"group",
+				"structures"
+			]
+		},
+		"rtgroup_metadata": {
+			"title": "Realtime allocation group metadata event",
+			"description": [
+				"Health status updates for realtime allocation",
+				"group metadata."
+			],
+			"type": "object",
+
+			"properties": {
+				"type": {
+					"$ref": "#/$metadata/status"
+				},
+				"time_ns": {
+					"$ref": "#/$defs/time_ns"
+				},
+				"domain": {
+					"const": "rtgroup"
+				},
+				"group": {
+					"$ref": "#/$defs/xfs_rgnumber_t"
+				},
+				"structures": {
+					"type": "array",
+					"items": {
+						"$ref": "#/$metadata/rtgroup"
+					},
+					"minItems": 1
+				}
+			},
+
+			"required": [
+				"type",
+				"time_ns",
+				"domain",
+				"group",
+				"structures"
+			]
+		},
+		"inode_metadata": {
+			"title": "Inode metadata event",
+			"description": [
+				"Health status updates for inode metadata.",
+				"The inode and generation number describe the",
+				"file that is affected by the change."
+			],
+			"type": "object",
+
+			"properties": {
+				"type": {
+					"$ref": "#/$metadata/status"
+				},
+				"time_ns": {
+					"$ref": "#/$defs/time_ns"
+				},
+				"domain": {
+					"const": "inode"
+				},
+				"inumber": {
+					"$ref": "#/$defs/xfs_ino_t"
+				},
+				"generation": {
+					"$ref": "#/$defs/i_generation"
+				},
+				"structures": {
+					"type": "array",
+					"items": {
+						"$ref": "#/$metadata/inode"
+					},
+					"minItems": 1
+				}
+			},
+
+			"required": [
+				"type",
+				"time_ns",
+				"domain",
+				"inumber",
+				"generation",
+				"structures"
+			]
 		}
 	}
 }

