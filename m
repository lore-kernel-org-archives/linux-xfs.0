Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2346155C97
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772496807; cv=none; b=p7Mqps5ggw92NYsmzgSoeMCyy7LnBdzxvAroq8znkCkWpAz/YXT0vTd27qCgCwLf2Js99Pz3OhEQ2poEN7pe/xtrmiQBgwcAdkVdv8RD7UHuJa+ofrixUdabu9lzmF1Atd35O6aUlFadPUxxDB1XeZ75yRIFkknrcTpCYR3CEDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772496807; c=relaxed/simple;
	bh=vm0krgKEvvnXD6KhvV5D/ZKuRRUSBwMNBCRtfYHyaKY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AjgcQejZdM7cNyKsdycJgPVI+7xlbucAh1wtn7fXi3RWV3eO8LR4mhEs4GM2BrsZ1woVKF+7xyfFWJU7hTRecD1S2e7GsyRLQ4DeM9l8fGUTKWeaQxe6WmaU0dayi0m8E/laudGf/TgKgFg5G6kL+DpLcD4bHCICopHZXzlrl80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mljvic9/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mljvic9/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EAA5C19423;
	Tue,  3 Mar 2026 00:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772496807;
	bh=vm0krgKEvvnXD6KhvV5D/ZKuRRUSBwMNBCRtfYHyaKY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mljvic9/h1v5ZYYt+pYaTuaWZQzozYzpPJE4KJHIxA6F7CwEJDkj5UQ+4D2F9xUca
	 uW6ZptjJPNmgie81TALv5FwIdRpw5iFpjT1ZFfMLCnYJZQGXlqUCatVCtxzM80RXSN
	 T+2mE8XU+RXeS0CrVxFFZ4iAphZQ25xIAMt8EqE6otGGmMosAx/Zbg7PLvTv2trmHU
	 oRt0RYTMcecgBNboap6One7dnUby1XqM1OsOad6Fk3ZkroNUTKh0X8lJxKhB5Ly1tN
	 RDc5t0exSujcyuy7MmHRTDoTengdJ6VzN/R2Qixs9fhAVtibCU35s+MoYKaD3rtO77
	 Fk2Hnw+rBxGYQ==
Date: Mon, 02 Mar 2026 16:13:27 -0800
Subject: [PATCH 05/36] xfs: convey filesystem unmount events to the health
 monitor
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177249637868.457970.14925252668853432066.stgit@frogsfrogsfrogs>
In-Reply-To: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
References: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
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

