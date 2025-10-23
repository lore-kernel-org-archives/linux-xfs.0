Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C375D27E
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178075; cv=none; b=E+ZPFF5vKoi0Cdwe3Nx4Y/tQow5bM7iIVxkWMb4NC/Cd4RTnMRtkNyN5wEmBJ6z3kTeEYoyHMQO3pNY6I423IGVO0gY0mi+38fnBHJfI4IyXvzJyr8EpEvehEn+yOOuoj4j8P0fXgSCUjAWdDnxvGx0m9Wjii2GexhbPUHZIlMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178075; c=relaxed/simple;
	bh=jwRqzDxNj3n0jG6JlM3fpDv1NAAMdd/yM4risfxJquA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jax8J79mdgqMFABGZRCS04N6GCzfJb4pO9ObhJmBLpEzILptMKlomEczASpJXlS8Dp7EpJeOZtp0UukD9CDlK6nLBJOcYHDtYVx25m5dhTsXo3Lh/vKpeT40aaJ90mYkYDZjYi0BYp4yuwF1Y5X6+iAAdixVj2JiiLIX4lEpccA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hBIvIvTg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hBIvIvTg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03ADCC4CEFF;
	Thu, 23 Oct 2025 00:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178075;
	bh=jwRqzDxNj3n0jG6JlM3fpDv1NAAMdd/yM4risfxJquA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hBIvIvTgPsQLWtE4VS6meW1/kfrGhTISghrE2dNjBZx0PBk1X0YA2b5oDtOU83m/g
	 yd9P8rMLOL2w6IPG5YYN8POcrrTXWH5ifBDz94vRqANB8AcCfBUeY7adVITMAmWSAP
	 J2gfnnN0gp4DvMe4V34lkQgqbSjFadk9q17udYg0KZHrMWFSJefNYHCwXR1X2YLaGM
	 cbUgGXB1ULbbSEnZhmMWXm138+xkhiFVGtJQaT77P5vGCRbdJ63MtpoiK972rT0323
	 ulZoUV/GDTZd704fxntm439GHcuFy5RsNgwvswGJE265mv0UJbiF6PLGhPheWzfnRO
	 aOy2KfgsI8Ngg==
Date: Wed, 22 Oct 2025 17:07:54 -0700
Subject: [PATCH 09/26] xfs: add media error reporting ioctl
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117747637.1028044.17354352745244273774.stgit@frogsfrogsfrogs>
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

Add a new privileged ioctl so that xfs_scrub can report media errors to
the kernel for further processing.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/xfs_fs.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index b5a00ef6ce5fb9..5d35d67b10e153 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -1158,6 +1158,21 @@ struct xfs_health_samefs {
 	__u32		flags;	/* zero for now */
 };
 
+/* Report a media error */
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
@@ -1199,6 +1214,7 @@ struct xfs_health_samefs {
 #define XFS_IOC_RTGROUP_GEOMETRY _IOWR('X', 65, struct xfs_rtgroup_geometry)
 #define XFS_IOC_HEALTH_MONITOR	_IOW ('X', 68, struct xfs_health_monitor)
 #define XFS_IOC_HEALTH_SAMEFS	_IOW ('X', 69, struct xfs_health_samefs)
+#define XFS_IOC_MEDIA_ERROR	_IOW ('X', 70, struct xfs_media_error)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s

