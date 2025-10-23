Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27E0BA45
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178043; cv=none; b=fKJH3HG29+XEMHRjzCc7+afiYPNawBm08E+ssDpws80k9SiStD3tlhlaBlEvnkl5MV4nLaX8EDhOUJ01QniLfsnxpqsYN1nVGVq4eQUAZV4BbLPATo+4PZ39e8ZLCBLQvi8EIT4lFLctjZGsJK+FMAcTq2artHrG/TYCnWWmVQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178043; c=relaxed/simple;
	bh=Z8KHE6D13XuKuAi3jCV6dzJmIc5SCF3YAui7kxHqeX0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yb4SsSKh4lgL/a7VVjtu52M1O+Aw1XudOm7Fpm4LKG7gQM+KjJ00/Hq6TV6XlQbs/kwQZ02dPpxnTSFJ5KDl2SBp4TmNhDM6TwnRxjMrPDMR4JAVoA+TSLwU4w9T0HTixAo5TFaWtUjhnJMb7CBJ0uftvRjZcONOgZYYOQ6b5/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xe7A3wX1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xe7A3wX1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB870C4CEE7;
	Thu, 23 Oct 2025 00:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178043;
	bh=Z8KHE6D13XuKuAi3jCV6dzJmIc5SCF3YAui7kxHqeX0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Xe7A3wX1eNMri8rIKNFWjuHnEXD2D6g6gwL+0TiBrtw8TJ3gzUl+U7LEcJQxJkWba
	 3eXTp0eAnIdOYzRm+jBZ4u5i3y55G6o2US/Bwye2pu5C0J4XO22mSkr7510Kdw8XuT
	 Xk5g04vyyDFPnA3hNbbv9UH/3Fn50bY7OGjv9cGydbm7CxQgMpcVgr4KnAvsaqczoW
	 Vh2KvJuhm2j+i7mQvFrlTXD+CUrXrOstU2SKnrG0ughirnxlwMOsr0DZ20jC401+1X
	 eRJTbCVS4zE2ymAkDDkcZO3O/pFRhPeiRlLTByii9lTLeCWWXFWdL2lBcG/ih3BmBj
	 TvbF0/9hhwWZQ==
Date: Wed, 22 Oct 2025 17:07:23 -0700
Subject: [PATCH 07/26] xfs: report file io errors through healthmon
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117747599.1028044.2095258030837173826.stgit@frogsfrogsfrogs>
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

Set up a file io error event hook so that we can send events about read
errors, writeback errors, and directio errors to userspace.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/xfs_fs.h                  |   18 +++++++++
 libxfs/xfs_healthmon.schema.json |   77 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 95 insertions(+)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index a551b1d5d0db58..87e915baa875d6 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -1019,6 +1019,9 @@ struct xfs_rtgroup_geometry {
 #define XFS_HEALTH_MONITOR_DOMAIN_RTDEV		(6)
 #define XFS_HEALTH_MONITOR_DOMAIN_LOGDEV	(7)
 
+/* file range events */
+#define XFS_HEALTH_MONITOR_DOMAIN_FILERANGE	(8)
+
 /* Health monitor event types */
 
 /* status of the monitor itself */
@@ -1039,6 +1042,12 @@ struct xfs_rtgroup_geometry {
 /* media errors */
 #define XFS_HEALTH_MONITOR_TYPE_MEDIA_ERROR	(7)
 
+/* file range events */
+#define XFS_HEALTH_MONITOR_TYPE_BUFREAD		(8)
+#define XFS_HEALTH_MONITOR_TYPE_BUFWRITE	(9)
+#define XFS_HEALTH_MONITOR_TYPE_DIOREAD		(10)
+#define XFS_HEALTH_MONITOR_TYPE_DIOWRITE	(11)
+
 /* lost events */
 struct xfs_health_monitor_lost {
 	__u64	count;
@@ -1079,6 +1088,14 @@ struct xfs_health_monitor_shutdown {
 	__u32	reasons;
 };
 
+/* file range events */
+struct xfs_health_monitor_filerange {
+	__u64	pos;
+	__u64	len;
+	__u64	ino;
+	__u32	gen;
+};
+
 /* disk media errors */
 struct xfs_health_monitor_media {
 	__u64	daddr;
@@ -1107,6 +1124,7 @@ struct xfs_health_monitor_event {
 		struct xfs_health_monitor_inode inode;
 		struct xfs_health_monitor_shutdown shutdown;
 		struct xfs_health_monitor_media media;
+		struct xfs_health_monitor_filerange filerange;
 	} e;
 
 	/* zeroes */
diff --git a/libxfs/xfs_healthmon.schema.json b/libxfs/xfs_healthmon.schema.json
index d3b537a040cb83..fb696dfbbfd044 100644
--- a/libxfs/xfs_healthmon.schema.json
+++ b/libxfs/xfs_healthmon.schema.json
@@ -42,6 +42,9 @@
 		},
 		{
 			"$ref": "#/$events/media_error"
+		},
+		{
+			"$ref": "#/$events/file_ioerror"
 		}
 	],
 
@@ -79,6 +82,16 @@
 			"description": "Inode generation number",
 			"type": "integer"
 		},
+		"off_t": {
+			"description": "File position, in bytes",
+			"type": "integer",
+			"minimum": 0
+		},
+		"size_t": {
+			"description": "File operation length, in bytes",
+			"type": "integer",
+			"minimum": 1
+		},
 		"storage_devs": {
 			"description": "Storage devices in a filesystem",
 			"_comment": [
@@ -260,6 +273,26 @@
 		}
 	},
 
+	"$comment": "File IO event data are defined here.",
+	"$fileio": {
+		"types": {
+			"description": [
+				"File I/O operations.  One of:",
+				"",
+				" * readahead: reads into the page cache.",
+				" * writeback: writeback of dirty page cache.",
+				" * directio_read:   O_DIRECT reads.",
+				" * directio_owrite: O_DIRECT writes."
+			],
+			"enum": [
+				"readahead",
+				"writeback",
+				"directio_read",
+				"directio_write"
+			]
+		}
+	},
+
 	"$comment": "Event types are defined here.",
 	"$events": {
 		"running": {
@@ -566,6 +599,50 @@
 				"daddr",
 				"bbcount"
 			]
+		},
+		"file_ioerror": {
+			"title": "File I/O error",
+			"description": [
+				"A read or a write to a file failed.  The",
+				"inode, generation, pos, and len fields",
+				"describe the range of the file that is",
+				"affected."
+			],
+			"type": "object",
+
+			"properties": {
+				"type": {
+					"$ref": "#/$fileio/types"
+				},
+				"time_ns": {
+					"$ref": "#/$defs/time_ns"
+				},
+				"domain": {
+					"const": "filerange"
+				},
+				"inumber": {
+					"$ref": "#/$defs/xfs_ino_t"
+				},
+				"generation": {
+					"$ref": "#/$defs/i_generation"
+				},
+				"pos": {
+					"$ref": "#/$defs/off_t"
+				},
+				"length": {
+					"$ref": "#/$defs/size_t"
+				}
+			},
+
+			"required": [
+				"type",
+				"time_ns",
+				"domain",
+				"inumber",
+				"generation",
+				"pos",
+				"length"
+			]
 		}
 	}
 }

