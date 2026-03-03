Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B4B1891A9
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772496902; cv=none; b=aIE1tt1YckGU/os6wZpbsCyGkNmHibYxrKGVTbX+FYnMeln9jc5REQTJ38oyPXXZKfI++uLD/bkNQtUDhLVCWyMLzdC7fByhR1OFp7wAf6tVL+2jlybRFXhk6+iZdHUQV5TVAV5C0pQhhUCfyhQNSyXgMcS0wwCTCpW4fC4CO4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772496902; c=relaxed/simple;
	bh=ofsKgAB98Gv+bkWu1JcZMV6ksBg39qhcg/63zIU40XM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ra7OjVGVP6TOyG4ax29Xq64d0Bz1oVVup2S2mBrKDSe7fypnmXFBqou3wroTCXmabldQMAUcdJyDb07GqHqu0MfcN5zWcerTyguB4bjQryog+1eKg+1fGxeFHFkkghNGL066tx9STDH4F+4pNZdULuJgilccqTM5QHkBlwsD/fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MsqvbUVY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MsqvbUVY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72316C19423;
	Tue,  3 Mar 2026 00:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772496901;
	bh=ofsKgAB98Gv+bkWu1JcZMV6ksBg39qhcg/63zIU40XM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MsqvbUVYjthwTR2eKF9oFjtLjsLKfmU62bVI5Up16184QQpOZXpGNQq4pan4ugb5f
	 JUcXfH5ulG987OWzpliIXTDrKiumLeMzBbsR32R7VvMlgVav4GLTINp+hSxy3x9V9g
	 jyyMXf0ha+2ItrZ6J5VrpCqugeHrrp2hD91NGsrCi8VmgsaWkY3wsaxZofiFaLl7OS
	 0IQiGeaw9Q5s4eYENEb24qlMPxOogWtb1Q/CetA+vOLkYwoRmhSyAvRwkBCJJpK4Ko
	 OChxR6EyQ7IU1O3Zu53Y3258ZR8L/1kPiIgYWBJMMdjEfHsZjbu5jbWq9jI3S/vBIg
	 2fcfzNHktgpJg==
Date: Mon, 02 Mar 2026 16:15:01 -0800
Subject: [PATCH 11/36] xfs: add media verification ioctl
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177249637978.457970.2157001000924066861.stgit@frogsfrogsfrogs>
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

Source kernel commit: b8accfd65d31f25b9df15ec2419179b6fa0b21d5

Add a new privileged ioctl so that xfs_scrub can ask the kernel to
verify the media of the devices backing an xfs filesystem, and have any
resulting media errors reported to fsnotify and xfs_healer.

To accomplish this, the kernel allocates a folio between the base page
size and 1MB, and issues read IOs to a gradually incrementing range of
one of the storage devices underlying an xfs filesystem.  If any error
occurs, that raw error is reported to the calling process.  If the error
happens to be one of the ones that the kernel considers indicative of
data loss, then it will also be reported to xfs_healthmon and fsnotify.

Driving the verification from the kernel enables xfs (and by extension
xfs_scrub) to have precise control over the size and error handling of
IOs that are issued to the underlying block device, and to emit
notifications about problems to other relevant kernel subsystems
immediately.

Note that the caller is also allowed to reduce the size of the IO and
to ask for a relaxation period after each IO.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index a01303c5de6ce6..d165de607d179e 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -1160,6 +1160,34 @@ struct xfs_health_file_on_monitored_fs {
 	__u32		flags;	/* zero for now */
 };
 
+/* Verify the media of the underlying devices */
+struct xfs_verify_media {
+	__u32	me_dev;		/* I: XFS_DEV_{DATA,LOG,RT} */
+	__u32	me_flags;	/* I: XFS_VERIFY_MEDIA_* */
+
+	/*
+	 * IO: inclusive start of disk range to verify, in 512b blocks.
+	 * Will be adjusted upwards as media verification succeeds.
+	 */
+	__u64	me_start_daddr;
+
+	/*
+	 * IO: exclusive end of the disk range to verify, in 512b blocks.
+	 * Can be adjusted downwards to match device size.
+	 */
+	__u64	me_end_daddr;
+
+	__u32	me_ioerror;	/* O: I/O error (positive) */
+	__u32	me_max_io_size;	/* I: maximum IO size in bytes */
+
+	__u32	me_rest_us;	/* I: rest time between IOs, usecs */
+	__u32	me_pad;		/* zero */
+};
+
+#define XFS_VERIFY_MEDIA_REPORT	(1 << 0)	/* report to fsnotify */
+
+#define XFS_VERIFY_MEDIA_FLAGS	(XFS_VERIFY_MEDIA_REPORT)
+
 /*
  * ioctl commands that are used by Linux filesystems
  */
@@ -1202,6 +1230,8 @@ struct xfs_health_file_on_monitored_fs {
 #define XFS_IOC_HEALTH_MONITOR	_IOW ('X', 68, struct xfs_health_monitor)
 #define XFS_IOC_HEALTH_FD_ON_MONITORED_FS \
 				_IOW ('X', 69, struct xfs_health_file_on_monitored_fs)
+#define XFS_IOC_VERIFY_MEDIA	_IOWR('X', 70, struct xfs_verify_media)
+
 /*
  * ioctl commands that replace IRIX syssgi()'s
  */

