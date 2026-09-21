Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC98D234994
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 06:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789971441; cv=none; b=V63Dt9HN5zc6Fcyz/f0hj6M1Wkbb8XMmvwWUcrFP/dPT2GZeIHJIZhXbZuZRa9VfiqNQaLdIBI1mXWUnbEMakjLdm/ZSop7ofiMQEOBHdub+VlrYn7qXX6xwoawkPPlA3tC3hWhpTCGKdmDi9ZwAu6Mt0rmiCRo47ZJ1y8Kj6A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789971441; c=relaxed/simple;
	bh=qEcdyA+vgeUlgq4hhK45y5+oGrMaCu1jMmesnl49h4g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S6cPWBnm+xKGwtBwkK8tmtF9uvAm8XuXIYhIttGyv2O8vrDS8V6c5E1ZCKoRr2RMpDP0a/F9d/5GsAw4hIQ47N2QNC+NsTyi/TjiLh9nKpzu5nog8D3yZnG9gqtVDQtquoFB1FN0lvrddIZuklEQ+ecLgGvT2EtRhabJYiDn6Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YBXe0Akc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YBXe0Akc"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1F6391F000FF;
	Mon, 21 Sep 2026 06:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789971440;
	bh=lUlWW5CnxE0Xi5pY/YJ9Ikinti0qXFy9+lItngP6bEQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=YBXe0AkclHKBYnZQjoGzfm2u7Bfl5TmxMzeRb8qKhsBpBTbI/c+s0sNqPOn/8OIdw
	 KfJs6Xmc0hi3SNtm1xZWzw8/3ISR15N/MqXuFuwQiDdh/ZGpYXEBs0mdigqO1+cZfH
	 58AoJjOP4QhHww6k5F6K0wggkRiqLS9HJtMUI/D2qj31yP4Yo/5esSHS+qj2szLGYz
	 AnY23dClgdjY8BmCpqyknE+a0D/xCbAfZxWrgzXg+OiDa0Ei4S/TDSFa9jD3pxg/YM
	 xHzs7MVZnfvmlsxod33iwMFABjammMboY8fa2lwvYyT90y8kZBRK9YW26SF2SKVgt7
	 u4S97sOEhA3Qg==
Date: Sun, 20 Sep 2026 23:17:19 -0700
Subject: [PATCH 09/14] xfs: add missing healthmon trace strings
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <178996120742.181988.4615087468034246498.stgit@frogsfrogsfrogs>
In-Reply-To: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
References: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
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

