Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA571BA45
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761177982; cv=none; b=jxwFH6EGFE/LG4Uomc9yv3FdkRgfhpREOx5XAhEjnjuJe6Ex+Eef9qN0SwwNwoDToqB5DUs9UfDqJgmwsaXhA3aA4hHO6q5jP0OB493vq08xl69uwyjdKLZdtBM5BykfO0uVO0g9axvl2TcO6MMzTZlTRWotB0cZnBi9ybae5tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761177982; c=relaxed/simple;
	bh=0CFvmNk2rdPts6BB/hU3TBxihnuVl4+i8sjxsr/u5Yk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JGF+l0ckayBx9a2Gq5pIqQqooDiTdVAjz+sVC8Zna5AgIULLHYMr0yqdc2k+9CNjT46FU/kViJnyGIe7mGEiYj653ALGBMzTf/Eons/00x/zWvqIPiWsN9O9nf+S+NMm/8mc2uJZNGgCZd7cZL+E721HhzNShVCx6A4Gw/74xCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V/sAb6Xz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V/sAb6Xz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47BC2C4CEE7;
	Thu, 23 Oct 2025 00:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761177981;
	bh=0CFvmNk2rdPts6BB/hU3TBxihnuVl4+i8sjxsr/u5Yk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=V/sAb6XzYQOH/zb2B/Pw0s7dkcQovNP9sRsb38w1NNJjeZiZBspD2jpEtU5eVB7bU
	 y2MCF6RqyYerBnoOmlT/2lX+PuhYHZuH7TOh+GWpfQIAoHnd32BTarEviky1myqrSi
	 alMPXZ8D45k1Z3qNe4rQK4ZiHMbPdD0H1gu0Dt+YYybIXW0PY9RdTHvprNjiaPzSxI
	 PCfoLu+DQdbuqJ89uwm57DNKy0yDk0oa7uH/N4PYbbEPFNULyruERheSUVReUI0TTO
	 V1KHSS/b00XBfoH4hwDjXDD9eTJrXWHaK57Os/GPoZgoOJSKkQ2ctA9EYpVYuVDKZw
	 ftWRpd6Z/2Zwg==
Date: Wed, 22 Oct 2025 17:06:20 -0700
Subject: [PATCH 03/26] xfs: create event queuing, formatting,
 and discovery infrastructure
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117747524.1028044.9686267308441307302.stgit@frogsfrogsfrogs>
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

Create the basic infrastructure that we need to report health events to
userspace.  We need a compact form for recording critical information
about an event and queueing them; a means to notice that we've lost some
events; and a means to format the events into something that userspace
can handle.

Here, we've chosen json to export information to userspace.  The
structured key-value nature of json gives us enormous flexibility to
modify the schema of what we'll send to userspace because we can add new
keys at any time.  Userspace can use whatever json parsers are available
to consume the events and will not be confused by keys they don't
recognize.

Note that we do NOT allow sending json back to the kernel, nor is there
any intent to do that.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/xfs_fs.h                  |   50 +++++++++++++++
 libxfs/xfs_healthmon.schema.json |  129 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 179 insertions(+)
 create mode 100644 libxfs/xfs_healthmon.schema.json


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index dba7896f716092..4b642eea18b5ca 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -1003,6 +1003,45 @@ struct xfs_rtgroup_geometry {
 #define XFS_RTGROUP_GEOM_SICK_RMAPBT	(1U << 3)  /* reverse mappings */
 #define XFS_RTGROUP_GEOM_SICK_REFCNTBT	(1U << 4)  /* reference counts */
 
+/* Health monitor event domains */
+
+/* affects the whole fs */
+#define XFS_HEALTH_MONITOR_DOMAIN_MOUNT		(0)
+
+/* Health monitor event types */
+
+/* status of the monitor itself */
+#define XFS_HEALTH_MONITOR_TYPE_RUNNING		(0)
+#define XFS_HEALTH_MONITOR_TYPE_LOST		(1)
+
+/* lost events */
+struct xfs_health_monitor_lost {
+	__u64	count;
+};
+
+struct xfs_health_monitor_event {
+	/* XFS_HEALTH_MONITOR_DOMAIN_* */
+	__u32	domain;
+
+	/* XFS_HEALTH_MONITOR_TYPE_* */
+	__u32	type;
+
+	/* Timestamp of the event, in nanoseconds since the Unix epoch */
+	__u64	time_ns;
+
+	/*
+	 * Details of the event.  The primary clients are written in python
+	 * and rust, so break this up because bindgen hates anonymous structs
+	 * and unions.
+	 */
+	union {
+		struct xfs_health_monitor_lost lost;
+	} e;
+
+	/* zeroes */
+	__u64	pad[2];
+};
+
 struct xfs_health_monitor {
 	__u64	flags;		/* flags */
 	__u8	format;		/* output format */
@@ -1010,6 +1049,17 @@ struct xfs_health_monitor {
 	__u64	pad2[2];	/* zeroes */
 };
 
+/* Return all health status events, not just deltas */
+#define XFS_HEALTH_MONITOR_VERBOSE	(1ULL << 0)
+
+#define XFS_HEALTH_MONITOR_ALL		(XFS_HEALTH_MONITOR_VERBOSE)
+
+/* Return events in a C structure */
+#define XFS_HEALTH_MONITOR_FMT_CSTRUCT	(0)
+
+/* Return events in JSON format */
+#define XFS_HEALTH_MONITOR_FMT_JSON	(1)
+
 /*
  * ioctl commands that are used by Linux filesystems
  */
diff --git a/libxfs/xfs_healthmon.schema.json b/libxfs/xfs_healthmon.schema.json
new file mode 100644
index 00000000000000..68762738b04191
--- /dev/null
+++ b/libxfs/xfs_healthmon.schema.json
@@ -0,0 +1,129 @@
+{
+	"$comment": [
+		"SPDX-License-Identifier: GPL-2.0-or-later",
+		"Copyright (c) 2024-2025 Oracle.  All Rights Reserved.",
+		"Author: Darrick J. Wong <djwong@kernel.org>",
+		"",
+		"This schema file describes the format of the json objects",
+		"readable from the fd returned by the XFS_IOC_HEALTHMON",
+		"ioctl."
+	],
+
+	"$schema": "https://json-schema.org/draft/2020-12/schema",
+	"$id": "https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/fs/xfs/libxfs/xfs_healthmon.schema.json",
+
+	"title": "XFS Health Monitoring Events",
+
+	"$comment": "Events must be one of the following types:",
+	"oneOf": [
+		{
+			"$ref": "#/$events/running"
+		},
+		{
+			"$ref": "#/$events/unmount"
+		},
+		{
+			"$ref": "#/$events/lost"
+		}
+	],
+
+	"$comment": "Simple data types are defined here.",
+	"$defs": {
+		"time_ns": {
+			"title": "Time of Event",
+			"description": "Timestamp of the event, in nanoseconds since the Unix epoch.",
+			"type": "integer"
+		},
+		"count": {
+			"title": "Count of events",
+			"description": "Number of events.",
+			"type": "integer",
+			"minimum": 1
+		}
+	},
+
+	"$comment": "Event types are defined here.",
+	"$events": {
+		"running": {
+			"title": "Health Monitoring Running",
+			"$comment": [
+				"The health monitor is actually running."
+			],
+			"type": "object",
+
+			"properties": {
+				"type": {
+					"const": "running"
+				},
+				"time_ns": {
+					"$ref": "#/$defs/time_ns"
+				},
+				"domain": {
+					"const": "mount"
+				}
+			},
+
+			"required": [
+				"type",
+				"time_ns",
+				"domain"
+			]
+		},
+		"unmount": {
+			"title": "Filesystem Unmounted",
+			"$comment": [
+				"The filesystem was unmounted."
+			],
+			"type": "object",
+
+			"properties": {
+				"type": {
+					"const": "unmount"
+				},
+				"time_ns": {
+					"$ref": "#/$defs/time_ns"
+				},
+				"domain": {
+					"const": "mount"
+				}
+			},
+
+			"required": [
+				"type",
+				"time_ns",
+				"domain"
+			]
+		},
+		"lost": {
+			"title": "Health Monitoring Events Lost",
+			"$comment": [
+				"Previous health monitoring events were",
+				"dropped due to memory allocation failures",
+				"or queue limits."
+			],
+			"type": "object",
+
+			"properties": {
+				"type": {
+					"const": "lost"
+				},
+				"count": {
+					"$ref": "#/$defs/count"
+				},
+				"time_ns": {
+					"$ref": "#/$defs/time_ns"
+				},
+				"domain": {
+					"const": "mount"
+				}
+			},
+
+			"required": [
+				"type",
+				"count",
+				"time_ns",
+				"domain"
+			]
+		}
+	}
+}

