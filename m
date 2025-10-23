Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D6C8821
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178028; cv=none; b=g1TwsoUUe/m3D4LLsM5J3tfosmKYL2hF3j01eWcIznF4CllJrUeq6gPkA9JW7DAHvsNmwBBmbxiVGWs4wOtmJnKrnHYl3E+Ewhh3Q362ZmGclf0n0UrUoqlKJfEUVvAMUNh9Pp4ddotcAX4bLGQL4mJXWGiF7g8VXQREaIJQHDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178028; c=relaxed/simple;
	bh=JIo0gARYIJNLPoZXmcMa4R2SSKd1mMZmFnwJ7MpG5gc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R60ijdbT1QRgkSs8LXhOGfzwZc+u6Nuo+SFluoFZRNgBPf59oQBJ2eqNlNXQqeCaWhXvs3H8C5n5EZPJiziPInfczSkRtYWAzMSMCwacbQRS4pjSz+ZqOleLmVYB/KZQus6a6yf52b2bSqUJPg+rgjU94mtMvyIbPXAj9KaL/Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BLgd2sJv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BLgd2sJv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E6CC4CEE7;
	Thu, 23 Oct 2025 00:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178028;
	bh=JIo0gARYIJNLPoZXmcMa4R2SSKd1mMZmFnwJ7MpG5gc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BLgd2sJvKX6uEHWMxBNqsEzNYBsWk8ivt84n8P4dv/Mm78YtEM8YxopHt1fJMsfSq
	 +4cd9+5RVq2SgQBarV6CN1MP2rgHEkwlA91J8yN3kzBIJK0/MpjzwLi61QUmj8ZCUe
	 EBMteW2eJuZ5QP2hwU40/oNof8HcDStvdk9KEN5r2OAWH4slV8oh7LqvC4EWytqV6R
	 tPI/5GHK70ZnCSqKOPsvcW/uhUqwv/LF7Pj+HVP7ivqeq1saYd40fbww6s9JBvQtBJ
	 R23E8H+eajCU4g6qpXWuSLqNk2p5pat/V/fmk6vfijfrydfA6bCr5ICWrYgP/yF6Gp
	 PBeA5ggUxXK+g==
Date: Wed, 22 Oct 2025 17:07:07 -0700
Subject: [PATCH 06/26] xfs: report media errors through healthmon
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117747581.1028044.18121221561102681819.stgit@frogsfrogsfrogs>
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

Now that we have hooks to report media errors, connect this to the
health monitor as well.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/xfs_fs.h                  |   15 +++++++++
 libxfs/xfs_healthmon.schema.json |   65 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 80 insertions(+)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 918362a7294f27..a551b1d5d0db58 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -1014,6 +1014,11 @@ struct xfs_rtgroup_geometry {
 #define XFS_HEALTH_MONITOR_DOMAIN_INODE		(3)
 #define XFS_HEALTH_MONITOR_DOMAIN_RTGROUP	(4)
 
+/* disk events */
+#define XFS_HEALTH_MONITOR_DOMAIN_DATADEV	(5)
+#define XFS_HEALTH_MONITOR_DOMAIN_RTDEV		(6)
+#define XFS_HEALTH_MONITOR_DOMAIN_LOGDEV	(7)
+
 /* Health monitor event types */
 
 /* status of the monitor itself */
@@ -1031,6 +1036,9 @@ struct xfs_rtgroup_geometry {
 /* filesystem shutdown */
 #define XFS_HEALTH_MONITOR_TYPE_SHUTDOWN	(6)
 
+/* media errors */
+#define XFS_HEALTH_MONITOR_TYPE_MEDIA_ERROR	(7)
+
 /* lost events */
 struct xfs_health_monitor_lost {
 	__u64	count;
@@ -1071,6 +1079,12 @@ struct xfs_health_monitor_shutdown {
 	__u32	reasons;
 };
 
+/* disk media errors */
+struct xfs_health_monitor_media {
+	__u64	daddr;
+	__u64	bbcount;
+};
+
 struct xfs_health_monitor_event {
 	/* XFS_HEALTH_MONITOR_DOMAIN_* */
 	__u32	domain;
@@ -1092,6 +1106,7 @@ struct xfs_health_monitor_event {
 		struct xfs_health_monitor_group group;
 		struct xfs_health_monitor_inode inode;
 		struct xfs_health_monitor_shutdown shutdown;
+		struct xfs_health_monitor_media media;
 	} e;
 
 	/* zeroes */
diff --git a/libxfs/xfs_healthmon.schema.json b/libxfs/xfs_healthmon.schema.json
index 1657ccc482edff..d3b537a040cb83 100644
--- a/libxfs/xfs_healthmon.schema.json
+++ b/libxfs/xfs_healthmon.schema.json
@@ -39,6 +39,9 @@
 		},
 		{
 			"$ref": "#/$events/shutdown"
+		},
+		{
+			"$ref": "#/$events/media_error"
 		}
 	],
 
@@ -75,6 +78,31 @@
 		"i_generation": {
 			"description": "Inode generation number",
 			"type": "integer"
+		},
+		"storage_devs": {
+			"description": "Storage devices in a filesystem",
+			"_comment": [
+				"One of:",
+				"",
+				" * datadev: filesystem device",
+				" * logdev:  external log device",
+				" * rtdev:   realtime volume"
+			],
+			"enum": [
+				"datadev",
+				"logdev",
+				"rtdev"
+			]
+		},
+		"xfs_daddr_t": {
+			"description": "Storage device address, in units of 512-byte blocks",
+			"type": "integer",
+			"minimum": 0
+		},
+		"bbcount": {
+			"description": "Storage space length, in units of 512-byte blocks",
+			"type": "integer",
+			"minimum": 1
 		}
 	},
 
@@ -501,6 +529,43 @@
 				"domain",
 				"reasons"
 			]
+		},
+		"media_error": {
+			"title": "Media Error",
+			"description": [
+				"A storage device reported a media error.",
+				"The domain element tells us which storage",
+				"device reported the media failure.  The",
+				"daddr and bbcount elements tell us where",
+				"inside that device the failure was observed."
+			],
+			"type": "object",
+
+			"properties": {
+				"type": {
+					"const": "media"
+				},
+				"time_ns": {
+					"$ref": "#/$defs/time_ns"
+				},
+				"domain": {
+					"$ref": "#/$defs/storage_devs"
+				},
+				"daddr": {
+					"$ref": "#/$defs/xfs_daddr_t"
+				},
+				"bbcount": {
+					"$ref": "#/$defs/bbcount"
+				}
+			},
+
+			"required": [
+				"type",
+				"time_ns",
+				"domain",
+				"daddr",
+				"bbcount"
+			]
 		}
 	}
 }

