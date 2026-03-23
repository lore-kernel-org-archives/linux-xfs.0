Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33ABB303CA0
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 18:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774291388; cv=none; b=ombmdFQPp+cHvKdYaa6ky4Hy3RVT1iOVbD/T0a0jSzRgMMHv+m0qIuqfqOBaItKiWuSBXcKJoaw3Il5PF9EizoziB9h4E4oicVCCmRW6kaPLeo43nZfmNs2YpZg/s5ZvEZoeD1BGERGY/rBllLz3zNW6W61BrZxsNUbkROTUK/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774291388; c=relaxed/simple;
	bh=vm0krgKEvvnXD6KhvV5D/ZKuRRUSBwMNBCRtfYHyaKY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kbvFSSTcB3PUNdf8yocWARXM3c/asMI+i3RRk7HvRImz7a11iJWOdWMaPLQo8Lvg66yQuoEECFQNr+FV/nPg4oz//q+ZEgdvuABjkUw+z/m+LxIk+Hmsdp0rSLr/HkcKu0q7o87l5VTJoghKPWsJ8/ZrGGtFlWTqpvim81gVw/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NP1cpYwK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NP1cpYwK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C51AEC4CEF7;
	Mon, 23 Mar 2026 18:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774291387;
	bh=vm0krgKEvvnXD6KhvV5D/ZKuRRUSBwMNBCRtfYHyaKY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NP1cpYwKIaXXAfUS6sRZGLgsphovWO0ZDBHWQP5SFbaw5DR9ezWLkBlqHFJFNMvYK
	 Kb0t3sZaPWEPiBKbpGAYWzgh1p3rqKjxzQkxwPgMxnsomDXH+1JNeo571Xsclh3Rrx
	 NrRA8IGaL46nTw0Am/Rg5HYkg8PTxZMBy4UMEyIOzETPE50azDByL47ule95q0aXgm
	 a0llyLhAQSD/SGVmxhc605i4UWNQPXJRRJYQCvp3rGg1QLu5eOGy8ZlVcSJXvkefGW
	 RHYSxUTX4qAlJ4qETkVGP7jqAUipeIkQOqEibymOAWW61zx9M/eiroEiSQSfK91MVH
	 8l9GodajdqZow==
Date: Mon, 23 Mar 2026 11:43:07 -0700
Subject: [PATCH 07/40] xfs: convey filesystem unmount events to the health
 monitor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177429120866.2266274.17634337612297621057.stgit@frogsfrogsfrogs>
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

Source kernel commit: 25ca57fa3624cae9c6b5c6d3fc7f38318ca1402e

In xfs_healthmon_unmount, send events to xfs_healer so that it knows
that nothing further can be done for the filesystem.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 22b86bc888de5a..59de6ab69fb319 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -1014,6 +1014,9 @@ struct xfs_rtgroup_geometry {
 #define XFS_HEALTH_MONITOR_TYPE_RUNNING		(0)
 #define XFS_HEALTH_MONITOR_TYPE_LOST		(1)
 
+/* filesystem was unmounted */
+#define XFS_HEALTH_MONITOR_TYPE_UNMOUNT		(2)
+
 /* lost events */
 struct xfs_health_monitor_lost {
 	__u64	count;

