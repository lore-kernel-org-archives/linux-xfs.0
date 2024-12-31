Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F66B29415
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688910; cv=none; b=EtPsfGLeLUEIQwGogzl86uMyZ3TfjfiKQWQRgIM2IKGBkn55ElcLjAYE0gcsx+aleawwiLHMLU6cZaU8Gl335c2EfJXRc8RKhXknPSojDi6VE+whMPU6c+x1sxha+J7jyqpNB6IL0ajtcDDQVIroxG6ygcSawN6Dlxvk7PGG21o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688910; c=relaxed/simple;
	bh=8EGJJzbC0XxVzJc7BB3Pqu3pNodKRp+heFCIKYA8HyY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=njaghgIC7yNRaDu/6A+ZMYYjAP1W4Dq8OAJuaQUyK7YQXiihyA3JG1QVd8j/O1AnZJrwMNszy1MdVl5lC/uRrTxnYzY62aZHbD4f0fOtzNKOoviYvGq43qgXL59Xwi91jM84Bi1kgbvEeWlvQzp6RXzj/QgXEt470iF7LhxDdzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kMxiEWdA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kMxiEWdA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9787C4CED2;
	Tue, 31 Dec 2024 23:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688909;
	bh=8EGJJzbC0XxVzJc7BB3Pqu3pNodKRp+heFCIKYA8HyY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kMxiEWdAVVOvM+eyJMwDG8qWXEKry6mWi+fsYXcMkSs8QULQJpOZpbk8UrdvNAFkC
	 ue/M+76Bc4VhzNibdNY3FxStp2h8/r0PIhd0CARbTFoZ9AsRcUcdEKRrdvwjg/2uFO
	 KJgnifXioZdyLBhn0zzcutyBOOVkM5vCvOQfRR7xlS2YbBGpo0Efws0Mjfs1se1tO7
	 VuFkaXcaxE1GVUHWzx8X3BGMtsi0zylBy8tNfFrwU06zXUanLb+lvo+a8YsaXXf59/
	 p4/Mvk5G0w0zV/czf/EjO8jpBN0n05LdcdC+4m/AmDpspQWCyfzebho/pF39V60/rF
	 rtNxtrlO65ubg==
Date: Tue, 31 Dec 2024 15:48:29 -0800
Subject: [PATCH 03/21] xfs: create event queuing, formatting,
 and discovery infrastructure
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568778505.2710211.7052481015987415232.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_fs.h                  |    8 +++++
 libxfs/xfs_healthmon.schema.json |   63 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+)
 create mode 100644 libxfs/xfs_healthmon.schema.json


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index d1a81b02a1a3f3..d7404e6efd866d 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -1107,6 +1107,14 @@ struct xfs_health_monitor {
 	__u64	pad2[2];	/* zeroes */
 };
 
+/* Return all health status events, not just deltas */
+#define XFS_HEALTH_MONITOR_VERBOSE	(1ULL << 0)
+
+#define XFS_HEALTH_MONITOR_ALL		(XFS_HEALTH_MONITOR_VERBOSE)
+
+/* Return events in JSON format */
+#define XFS_HEALTH_MONITOR_FMT_JSON	(1)
+
 /*
  * ioctl commands that are used by Linux filesystems
  */
diff --git a/libxfs/xfs_healthmon.schema.json b/libxfs/xfs_healthmon.schema.json
new file mode 100644
index 00000000000000..9772efe25f193d
--- /dev/null
+++ b/libxfs/xfs_healthmon.schema.json
@@ -0,0 +1,63 @@
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
+		}
+	},
+
+	"$comment": "Event types are defined here.",
+	"$events": {
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
+		}
+	}
+}

