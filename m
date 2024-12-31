Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18601B0438
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688925; cv=none; b=kbeV240F7tr9IlNBypug7amB2dwa+iMU5GhaaJ7V1kp94xjney3D+Px1+v28aKy+3BEKIjKx1S0YWdYANLx8L4+motXIt2BrRSReu1AAxnf8kB9RfuWL2KT4wHf4FP3f9KRxag4+ZxVed+1JGPARwF8mJJ0VpQCJ/bYTJYeaKGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688925; c=relaxed/simple;
	bh=0ajwX3aP3pHkycP3D1qP6bba4/io8MZyRaW2T07LiFY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t8iM7XjdHQzWZNdwy/UU/X61Rg8/rF2AjewFslzRa7BL34seKZGDSCE3u0CY4AeUwrnncEawqLaqURBNXbwQ4HnBPcfHAOwLEp1pK8or09ZnGJzq0rRHJPm8fPNndN97oxmkwXmXi+inyDLbkGygYVK/9j0ZTtGMgN0hlEV3dPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L1pgrVPE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L1pgrVPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F7CC4CED2;
	Tue, 31 Dec 2024 23:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688925;
	bh=0ajwX3aP3pHkycP3D1qP6bba4/io8MZyRaW2T07LiFY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=L1pgrVPEd+f3vxFOCt25Kxvn39P7zq8UFE0xGD0bY+guhvNL5YApM4Kj1T4YBZRb5
	 pITw6CaLzv/oOpKKsqGKfpEcNWtE21bUmnzVAxBWqz5yAqKF9VBSJbd9CrjoV3zeyh
	 p89aZWY5K05ag4HVWHw68nDSHmY3xWhm/BmOTiT6ubhwQcDXUfGJfq4zWCY8Zqz48Y
	 dI2hieUN/0JJ6H3Lso8NzjyjknDqVgMOMBJHjpsRIQuDFaBTlNJHXOLHTIMQ/R9X8C
	 H4amlQDVAaV9VkhN97FgQkHW8lmlojyuAc76YqAWwHxwOsa1VG3HyQ444SM3VOE1Wv
	 pzPy8nQtiLhuQ==
Date: Tue, 31 Dec 2024 15:48:45 -0800
Subject: [PATCH 04/21] xfs: report metadata health events through healthmon
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568778520.2710211.13592512550036762462.stgit@frogsfrogsfrogs>
In-Reply-To: <173568778426.2710211.10173859713748230492.stgit@frogsfrogsfrogs>
References: <173568778426.2710211.10173859713748230492.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_healthmon.schema.json |  328 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 328 insertions(+)


diff --git a/libxfs/xfs_healthmon.schema.json b/libxfs/xfs_healthmon.schema.json
index 9772efe25f193d..154ea0228a3615 100644
--- a/libxfs/xfs_healthmon.schema.json
+++ b/libxfs/xfs_healthmon.schema.json
@@ -18,6 +18,18 @@
 	"oneOf": [
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
 
@@ -27,6 +39,169 @@
 			"title": "Time of Event",
 			"description": "Timestamp of the event, in nanoseconds since the Unix epoch.",
 			"type": "integer"
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
+				" * xattr:      extended attributes",
+				"",
+				"These are set when an inode record repair had",
+				"to drop the corresponding data structure to",
+				"get the inode back to a consistent state.",
+				"",
+				" * bmapbtd_zapped",
+				" * bmapbta_zapped",
+				" * directory_zapped",
+				" * symlink_zapped"
+			],
+			"enum": [
+				"bmapbta",
+				"bmapbta_zapped",
+				"bmapbtc",
+				"bmapbtd",
+				"bmapbtd_zapped",
+				"core",
+				"directory",
+				"directory_zapped",
+				"dirtree",
+				"parent",
+				"symlink",
+				"symlink_zapped",
+				"xattr"
+			]
 		}
 	},
 
@@ -58,6 +233,159 @@
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

