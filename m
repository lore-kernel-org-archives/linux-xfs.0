Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2A030E84B
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 18:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774291435; cv=none; b=CBeiCaTrLOTp794lea+f8rEzjVgY8VWkT6OlRyc+jQqQ9OGSUhUbyoF4fdGBECizTQZiTvvegq6/0QJn7GyE5iPtLlgXE5Vi29LO6xI0dE9gyxrYNXf0pLi2I3YWDQ5mZU5bR890pO6svxiYqYXjsoMNXL1WITV1ZfZWJqy2A8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774291435; c=relaxed/simple;
	bh=oJmQ7nliGKSrTP1D9rU3lLs5QxiIlUTxs9c65jsu2WI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gOFi2Z20QKe8CuQ7JkLxeQ+viFLHsdUmKMj1nEdqttlylAGkv5hezyryBqdoJUH2n++iPDgtpYvAJ5OPWgGah49xuHf4iCmwwrwmGF5ArqToqJIkSdidmCbIjgO00hE52cxVG7OM3J6OzZYU2ruqpJjrNiQRJ1HbXBS4rXyjHhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gnbh7D4F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gnbh7D4F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF8C6C2BCB5;
	Mon, 23 Mar 2026 18:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774291435;
	bh=oJmQ7nliGKSrTP1D9rU3lLs5QxiIlUTxs9c65jsu2WI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Gnbh7D4F6e7OUE2BXwIBSXRH4sD0ni/xhR+TPUCZdDXL50OCmrSKFxzGeVEU0woeX
	 tpbYwQH+ekYypF54GNa3W5NOzpxuqKAWFBEZpTaYvTZKtpugbSuNiIGtEW7GDjqyz4
	 1FDhEHGIRiCQoIqnwG1fbG2px1vF63qdZghKPt3sRGizYaOOo/3v71T6qDmQ3hFVWc
	 xXs5ozpAEVB4tmfS5xI6OV8GOgT8aeBl/QyTVajB+Y+RiNzqtcbWtHkH6VY4NgtzGX
	 o+QhAcEVffRsJVzyk6+LGg6i+4+NBI8qDPhQNLlYDlMXv8OH6n8S3CwBGWdWGdAK6a
	 Pc0PRWJqK43Sw==
Date: Mon, 23 Mar 2026 11:43:54 -0700
Subject: [PATCH 10/40] xfs: convey externally discovered fsdax media errors to
 the health monitor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177429120921.2266274.3187515471813761508.stgit@frogsfrogsfrogs>
In-Reply-To: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
References: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: e76e0e3fc9957a5183ddc51dc84c3e471125ab06

Connect the fsdax media failure notification code to the health monitor
so that xfs can send events about that to the xfs_healer daemon.

Later on we'll add the ability for the xfs_scrub media scan (phase 6) to
report the errors that it finds to the kernel so that those are also
logged by xfs_healer.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index c8f7011a7ef8ef..38aeb1b0d87b5e 100644
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

