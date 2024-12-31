Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4C529415
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688988; cv=none; b=LFPlR/BKypJ8fpyW7WHbKGgUNgb0NLWgxkwjQJgAJwQlUYkQaMMP0gzPqJ/stTQz1H0TKVJIAgCd01La2s6VRdnIgs1Bu4hhJJi4sAzZ8DK+gv+qc2OsOqqlFe3jqsx0v5eypvn2zz1P/Q+SkYywWEYatQT4NKXAzqUjA8vwIgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688988; c=relaxed/simple;
	bh=aqtbj/Vcn3WV64upJKt3peMvkPC3KrxDUaYpu98rQr0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WB3gYr5ndPrsLlPYcEgx9EDb2fGkfxv7eUP5/ZgcEEcK6SRe5z+0uCjyM9JXOMCOsN29N7Y9l09W4iRK7fxei8PCNJYswDvT9AQ10KtONplbcSutOUcRb+sTAapB5GWbvk5tNTZuYSGV/zdHSO953oOXkEcxi19q4r55TvB+0s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lhx4YM9u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lhx4YM9u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4497EC4CED2;
	Tue, 31 Dec 2024 23:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688988;
	bh=aqtbj/Vcn3WV64upJKt3peMvkPC3KrxDUaYpu98rQr0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lhx4YM9ukH93678ePRyTLIrJVi1ZFGaj3Pggy5YGRsMBwyk5OTDxB0+hRW1FTK6mS
	 nkOEbUv0jh/Q/CMPzuvpoOjtSiMOco4EPvwyxdB5uqIRL4myWIAmJveJhhhxQDlrsQ
	 oJSdiQ2kz2BvGnOZ2soeUBAIBgQ3uTdtwC47M2S6Te9SNLhA8tE5wnCFMi/5SrGzRk
	 0pZ2oz5rspN1I+plp1OKKpegi0JNtvRqZxKmXC9MUQLiEMS5Avs6wn01o2ct4wvEnM
	 WemTc28DQW5ceERmjeHUHTvUUKP5oR+RmndVzVjy94HiKz46KOZ+w1IOeEwpiuD1B1
	 JuRTjOT8FRwag==
Date: Tue, 31 Dec 2024 15:49:47 -0800
Subject: [PATCH 08/21] xfs: add media error reporting ioctl
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568778582.2710211.12839545225156178670.stgit@frogsfrogsfrogs>
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

Add a new privileged ioctl so that xfs_scrub can report media errors to
the kernel for further processing.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/xfs_fs.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index d7404e6efd866d..32e552d40b1bf5 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -1115,6 +1115,20 @@ struct xfs_health_monitor {
 /* Return events in JSON format */
 #define XFS_HEALTH_MONITOR_FMT_JSON	(1)
 
+struct xfs_media_error {
+	__u64	flags;		/* flags */
+	__u64	daddr;		/* disk address of range */
+	__u64	bbcount;	/* length, in 512b blocks */
+	__u64	pad;		/* zero */
+};
+
+#define XFS_MEDIA_ERROR_DATADEV	(1)	/* data device */
+#define XFS_MEDIA_ERROR_LOGDEV	(2)	/* external log device */
+#define XFS_MEDIA_ERROR_RTDEV	(3)	/* realtime device */
+
+/* bottom byte of flags is the device code */
+#define XFS_MEDIA_ERROR_DEVMASK	(0xFF)
+
 /*
  * ioctl commands that are used by Linux filesystems
  */
@@ -1157,6 +1171,7 @@ struct xfs_health_monitor {
 #define XFS_IOC_GETFSREFCOUNTS	_IOWR('X', 66, struct xfs_getfsrefs_head)
 #define XFS_IOC_MAP_FREESP	_IOW ('X', 67, struct xfs_map_freesp)
 #define XFS_IOC_HEALTH_MONITOR	_IOW ('X', 68, struct xfs_health_monitor)
+#define XFS_IOC_MEDIA_ERROR	_IOW ('X', 69, struct xfs_media_error)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s

