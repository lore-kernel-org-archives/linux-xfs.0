Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C3B3C1D78
	for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 05:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790143168; cv=none; b=mrzQ0DR1vKyes1UEPAim1iyfpJwyc/3Z+K222dVdOWGlx4bSTHV8KoyJOnViJRkBP59WyHmhKpX/aLEK6L1SHVNu90BHProvBJZRlu266Z9UadlJT0PISaJfQbFApayV24J5xuRfH6iH1PAhz+OUq7HFOrMYdJySTxi3kWkhBzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790143168; c=relaxed/simple;
	bh=DmG2n6oIwRsuhVcPcJFqYUoqx5fedoFhfFUAJepdpfc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fbhuZmooME2L/mfEv+Q3n5Xlow2FTN+HHYCZADXkOpxoVgMbCrayA2kd8qG8oVaTUEuaDxOjGhV3zGY/kngXp6lDQBCjPf/a8BboxNG4R7M9HksznqwxHLvGtJLnHhKiPE7Dg0D/I0wokMVpRhFVDDLMaVrjOGTLjl46Mt4O9a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bl7/ZVSd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bl7/ZVSd"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 078761F000FF;
	Wed, 23 Sep 2026 05:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790143167;
	bh=wYVmrSkKmuN4jQSYjwloLdzhNSjb/JvScfWmfCIC9ao=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=bl7/ZVSdPDbxnTlsQtMQJrdGxQziA6ChFxeQXUGLhiOfK4HcZB/+GccaVtqawPuXm
	 Ev2PwKeq/sRxEOCEYt1Qi9dWDjCk0+Ekmx0zrRe3tnNI+aJc3CwchMRn/ErxYfeLfB
	 JiC9IRtw76s+AizCqJ38EEi9/wchuLYMsLn+t2hoBItvOaCetQMSDwW2FVPP6XvfHK
	 H+BP5OItKJjj2zMGFUEtfgogLBmGDYcrE2qB5vnyIImKe913qkJrF1Kl+L6goc4rO6
	 DnTu1/bGdx4vxs4cDOfxwLH1+krcXtt7o6UOPJpWHTua+AEG6WntrJxmxo3w82TpIq
	 gma+EvyGVhZgA==
Date: Tue, 22 Sep 2026 22:59:26 -0700
Subject: [PATCH 08/13] xfs: add missing healthmon trace strings
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <179014159098.1874904.13076642072455118144.stgit@frogsfrogsfrogs>
In-Reply-To: <179014158847.1874904.13591868745136552281.stgit@frogsfrogsfrogs>
References: <179014158847.1874904.13591868745136552281.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that we don't have trace strings for all known healthmon
types and domains.  Fix that.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_trace.h |   28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 6aa379c2cf0cd1..0fc8927339b588 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -6030,32 +6030,54 @@ DEFINE_HEALTHMON_EVENT(xfs_healthmon_detach);
 DEFINE_HEALTHMON_EVENT(xfs_healthmon_report_unmount);
 
 #define XFS_HEALTHMON_TYPE_STRINGS \
+	{ XFS_HEALTHMON_RUNNING,	"run" }, \
 	{ XFS_HEALTHMON_LOST,		"lost" }, \
 	{ XFS_HEALTHMON_UNMOUNT,	"unmount" }, \
+	{ XFS_HEALTHMON_SHUTDOWN,	"shutdown" }, \
 	{ XFS_HEALTHMON_SICK,		"sick" }, \
 	{ XFS_HEALTHMON_CORRUPT,	"corrupt" }, \
 	{ XFS_HEALTHMON_HEALTHY,	"healthy" }, \
-	{ XFS_HEALTHMON_SHUTDOWN,	"shutdown" }
+	{ XFS_HEALTHMON_MEDIA_ERROR,	"media" }, \
+	{ XFS_HEALTHMON_BUFREAD,	"bufread" }, \
+	{ XFS_HEALTHMON_BUFWRITE,	"bufwrite" }, \
+	{ XFS_HEALTHMON_DIOREAD,	"dioread" }, \
+	{ XFS_HEALTHMON_DIOWRITE,	"diowrite" }, \
+	{ XFS_HEALTHMON_DATALOST,	"datalost" }
 
 #define XFS_HEALTHMON_DOMAIN_STRINGS \
 	{ XFS_HEALTHMON_MOUNT,		"mount" }, \
 	{ XFS_HEALTHMON_FS,		"fs" }, \
 	{ XFS_HEALTHMON_AG,		"ag" }, \
 	{ XFS_HEALTHMON_INODE,		"inode" }, \
-	{ XFS_HEALTHMON_RTGROUP,	"rtgroup" }
+	{ XFS_HEALTHMON_RTGROUP,	"rtgroup" }, \
+	{ XFS_HEALTHMON_DATADEV,	"datadev" }, \
+	{ XFS_HEALTHMON_RTDEV,		"rtdev" }, \
+	{ XFS_HEALTHMON_LOGDEV,		"logdev" }, \
+	{ XFS_HEALTHMON_FILERANGE,	"filerange" }
 
+TRACE_DEFINE_ENUM(XFS_HEALTHMON_RUNNING);
 TRACE_DEFINE_ENUM(XFS_HEALTHMON_LOST);
-TRACE_DEFINE_ENUM(XFS_HEALTHMON_SHUTDOWN);
 TRACE_DEFINE_ENUM(XFS_HEALTHMON_UNMOUNT);
+TRACE_DEFINE_ENUM(XFS_HEALTHMON_SHUTDOWN);
 TRACE_DEFINE_ENUM(XFS_HEALTHMON_SICK);
 TRACE_DEFINE_ENUM(XFS_HEALTHMON_CORRUPT);
 TRACE_DEFINE_ENUM(XFS_HEALTHMON_HEALTHY);
+TRACE_DEFINE_ENUM(XFS_HEALTHMON_MEDIA_ERROR);
+TRACE_DEFINE_ENUM(XFS_HEALTHMON_BUFREAD);
+TRACE_DEFINE_ENUM(XFS_HEALTHMON_BUFWRITE);
+TRACE_DEFINE_ENUM(XFS_HEALTHMON_DIOREAD);
+TRACE_DEFINE_ENUM(XFS_HEALTHMON_DIOWRITE);
+TRACE_DEFINE_ENUM(XFS_HEALTHMON_DATALOST);
 
 TRACE_DEFINE_ENUM(XFS_HEALTHMON_MOUNT);
 TRACE_DEFINE_ENUM(XFS_HEALTHMON_FS);
 TRACE_DEFINE_ENUM(XFS_HEALTHMON_AG);
 TRACE_DEFINE_ENUM(XFS_HEALTHMON_INODE);
 TRACE_DEFINE_ENUM(XFS_HEALTHMON_RTGROUP);
+TRACE_DEFINE_ENUM(XFS_HEALTHMON_DATADEV);
+TRACE_DEFINE_ENUM(XFS_HEALTHMON_RTDEV);
+TRACE_DEFINE_ENUM(XFS_HEALTHMON_LOGDEV);
+TRACE_DEFINE_ENUM(XFS_HEALTHMON_FILERANGE);
 
 DECLARE_EVENT_CLASS(xfs_healthmon_event_class,
 	TP_PROTO(const struct xfs_healthmon *hm,

