Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01DFD2EC0A2
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 18:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774291357; cv=none; b=qPMqVbPpClNntAXhF1yDt2sMG8se0pYEJ3lxzVEFv36j3kv0Kx3l8LnX7LI9L1VULpZwnQPsvrMqVpUbShrEDLE8U9D5h/UJbfNnxdFipRNGZuV3GopGYDjfX2hEflUJGmQqrtik5ICwWQTVQX9SGAl6NsWOaPB1P1bIWDcS0Nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774291357; c=relaxed/simple;
	bh=EP2OYme2W0t2CEqTpWazQZBZRcj42xfvJo+Xjy3bSQs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FosCrpS3Dueuo14lmoW/P4TtjKszq1eu/zHQCkdueHRKO0xGWloDn/O3bhteEKOzeESFPsk3gqEMysGvtK46c3fd3eUegsPU6FeOg9sHDpciEDiHu0M2Q/26D56L46O9LZBTCLqtNWj8Dff6tEgfV4GRyh9o4RxQWJRIiZ+rP7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GzaEB8wH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GzaEB8wH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ED9BC2BC87;
	Mon, 23 Mar 2026 18:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774291356;
	bh=EP2OYme2W0t2CEqTpWazQZBZRcj42xfvJo+Xjy3bSQs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GzaEB8wHaUr6Uguc9R/G+ZQciH6uU7tpJf+wzwpAm7QVlPwSeSSn2DBqwy83mX8EK
	 0sVn+pNsUKWZ6MwcblMHqpJuA8mcnVRH+2JmM/BpKqxUgbyPa3kgf6Qnj1ZSw6vkEA
	 hF26N0CNBXSHAFzB+HFJtV6MKJsTpTqtumYu9QxrrdNrl+0UNgSsyrJPV8Qjjw+994
	 3Qimo7AanhVgcE29sL1cTU0hnsbvC6L62IjocAJf7qfu20+Ol7h2+4uGVwoqXu3zSX
	 b0Ojigtwla1ko52+KP0/MHW0RBw+aUf7KBru+LmROa9pOSNZa6StMxMd/1jkO68nws
	 wBdMk3WzwODfw==
Date: Mon, 23 Mar 2026 11:42:36 -0700
Subject: [PATCH 05/40] xfs: start creating infrastructure for health
 monitoring
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177429120830.2266274.3712061244694288958.stgit@frogsfrogsfrogs>
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

Source kernel commit: a48373e7d35a89f6f9b39f0d0da9bf158af054ee

Start creating helper functions and infrastructure to pass filesystem
health events to a health monitoring file.  Since this is an
administrative interface, we only support a single health monitor
process per filesystem, so we don't need to use anything fancy such as
notifier chains (== tons of indirect calls).

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 12463ba766da05..c58e55b3df4099 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -1003,6 +1003,12 @@ struct xfs_rtgroup_geometry {
 #define XFS_RTGROUP_GEOM_SICK_RMAPBT	(1U << 3)  /* reverse mappings */
 #define XFS_RTGROUP_GEOM_SICK_REFCNTBT	(1U << 4)  /* reference counts */
 
+struct xfs_health_monitor {
+	__u64	flags;		/* flags */
+	__u8	format;		/* output format */
+	__u8	pad[23];	/* zeroes */
+};
+
 /*
  * ioctl commands that are used by Linux filesystems
  */
@@ -1042,6 +1048,7 @@ struct xfs_rtgroup_geometry {
 #define XFS_IOC_GETPARENTS_BY_HANDLE _IOWR('X', 63, struct xfs_getparents_by_handle)
 #define XFS_IOC_SCRUBV_METADATA	_IOWR('X', 64, struct xfs_scrub_vec_head)
 #define XFS_IOC_RTGROUP_GEOMETRY _IOWR('X', 65, struct xfs_rtgroup_geometry)
+#define XFS_IOC_HEALTH_MONITOR	_IOW ('X', 68, struct xfs_health_monitor)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s

