Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D332E2DF3
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 18:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774291450; cv=none; b=CcJjSFquE9pqT0ymbkixnvJHR3bB6Ei4ob1wPw+QdjsVaVO7D08uQ9WyNSS77l5o/BxWLQwwd+KdihB55O5ihIuxBGlvtdjAteTvjpel6ItQzk5JTCMFqHPr/X2lNRw+PfYPgnlmtVa78nvgYcjySLZzSMNkRJ+I1EOhpCM/lng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774291450; c=relaxed/simple;
	bh=6KoVoYq4sYmDcG7ROkguWGneUGT7Iz7ptsYCHsozxxY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JdRUZZ2iEXVaMAhQTjPAjG0uR8OP4PeYQFFvbS0yfY06DYF+Hr8EJVaZJBizaJWRFuouoJ5tZTK2aw/N7TJCu3kgh13LYIHfWRzFqpcm71B9rZbW0zhXnkiC4OWuJ9AZqC/rz/bww2BkAUXCOMW9haQTdJRaGrD+qO1xT5fFc8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UctJE5rk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UctJE5rk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92FEEC2BC87;
	Mon, 23 Mar 2026 18:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774291450;
	bh=6KoVoYq4sYmDcG7ROkguWGneUGT7Iz7ptsYCHsozxxY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UctJE5rkboDw5aFWFt3PZMeIFzjskN4grhUAS3jC+oE0dRT7+E/bIRreu9D7xqMQB
	 8JSdMAyrJWLvwctAelUzgmrnHmlyTLYyFY+dwwaBKi61ARoc61Ka5+2KYb8KLURyvl
	 MpallG5rzPGFNl+lpfEKVuk0VCtjqaq6qJ2RVCp7uEYzY69c6JNzxL2YfaEVAIUhhc
	 yo8btF2oWft+z637k05WUM7TuejgWy4UPxctjNB0muDoraZAIxTQ8SVe2gUfZ6wD5g
	 i3/IGYPGiFNqkpO/DblpzCCj16ANQDHgK2K/+mg0Lig8PLCvHPRkcP2/3W/0bELFc9
	 L3fAg0yovditQ==
Date: Mon, 23 Mar 2026 11:44:10 -0700
Subject: [PATCH 11/40] xfs: convey file I/O errors to the health monitor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177429120940.2266274.4136999699737559379.stgit@frogsfrogsfrogs>
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

Source kernel commit: dfa8bad3a8796ce1ca4f1d15158e2ecfb9c5c014

Connect the fserror reporting to the health monitor so that xfs can send
events about file I/O errors to the xfs_healer daemon.  These events are
entirely informational because xfs cannot regenerate user data, so
hopefully the fsnotify I/O error event gets noticed by the relevant
management systems.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 38aeb1b0d87b5e..4ec1b2aede976f 100644
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
@@ -1039,6 +1042,17 @@ struct xfs_rtgroup_geometry {
 /* media errors */
 #define XFS_HEALTH_MONITOR_TYPE_MEDIA_ERROR	(7)
 
+/* pagecache I/O to a file range failed */
+#define XFS_HEALTH_MONITOR_TYPE_BUFREAD		(8)
+#define XFS_HEALTH_MONITOR_TYPE_BUFWRITE	(9)
+
+/* direct I/O to a file range failed */
+#define XFS_HEALTH_MONITOR_TYPE_DIOREAD		(10)
+#define XFS_HEALTH_MONITOR_TYPE_DIOWRITE	(11)
+
+/* out of band media error reported for a file range */
+#define XFS_HEALTH_MONITOR_TYPE_DATALOST	(12)
+
 /* lost events */
 struct xfs_health_monitor_lost {
 	__u64	count;
@@ -1079,6 +1093,15 @@ struct xfs_health_monitor_shutdown {
 	__u32	reasons;
 };
 
+/* file range events */
+struct xfs_health_monitor_filerange {
+	__u64	pos;
+	__u64	len;
+	__u64	ino;
+	__u32	gen;
+	__u32	error;
+};
+
 /* disk media errors */
 struct xfs_health_monitor_media {
 	__u64	daddr;
@@ -1107,6 +1130,7 @@ struct xfs_health_monitor_event {
 		struct xfs_health_monitor_inode inode;
 		struct xfs_health_monitor_shutdown shutdown;
 		struct xfs_health_monitor_media media;
+		struct xfs_health_monitor_filerange filerange;
 	} e;
 
 	/* zeroes */

