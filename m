Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729673126B9
	for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 04:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773895235; cv=none; b=bd6lpk7kgs/1DE+qYCiB6FdKF9ZzZXpC7mS6pmHpS/z8zTJTfevc51BOb7c3h4P0oyt05Of4UbrKKD6fM/tgEifHd19//hIR4tdsAjMdNFrfyEqyotIUZKII79IWYSBnumucYLhHENR7g17UGP62WlM8WD3SiPsYtX09GSlE/+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773895235; c=relaxed/simple;
	bh=w1PdPjvoBJA3X/OdFeTHIssl6xegSLHIaXrr87yL6Y8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rle0k45lLf0xkPgjbYEU2b31KgCVWTDse4tpnO9urPtAPri/wefu8ao4zdbgVSErNs4rOx/tRLQEpNfvYHumAdleb/Y8AJbsyWp7CXrTqGT+7n8U/b905kd30efb9Uc4HgPTxVhr7zhyLAeVnNDE2YROk23z4hAnLI/cpjFjXjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XUdbORyl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XUdbORyl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0915DC19425;
	Thu, 19 Mar 2026 04:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773895235;
	bh=w1PdPjvoBJA3X/OdFeTHIssl6xegSLHIaXrr87yL6Y8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XUdbORylNLUzoeB5aNyuuf8lpd+52dC3hiWm5UZIi5rdCjGAF7aGuyScfq0jRJulc
	 gslu+ZS9y+/SLDp/iDh7unOhl9ALp7+nKvpGmG1dnehZo9GPaTqO59RGnsKPZ0afjJ
	 Cjysa9BVHtJ43dxySuAWGjWlInl0nS1ZhHZe041tBz4e1OJgYQAAEcFZKC5axL3JOz
	 L4Qfrpd4r3Md90WRwUFxRAENQB/qqqlAc3uR5fRxq+5S4p78ODYgLZkDV7MVRKRUqy
	 AK1xklZxO105iL0i762zeGleEZjWfiRspLJL7AYZ/jl5QXcPUN/5cMF5kQMYDkAX1Q
	 pGrwWtpkisTow==
Date: Wed, 18 Mar 2026 21:40:34 -0700
Subject: [PATCH 07/26] man2: document the media verification ioctl
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177389506274.3680139.3846886624031032571.stgit@frogsfrogsfrogs>
In-Reply-To: <177389506017.3680139.913759001427336891.stgit@frogsfrogsfrogs>
References: <177389506017.3680139.913759001427336891.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Document XFS_IOC_VERIFY_MEDIA, which is a new ioctl for xfs_scrub to
perform media scans on the disks underneath the filesystem.  This will
enable media errors to be reported to xfs_healer and fsnotify.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 man/man2/ioctl_xfs_verify_media.2 |  185 +++++++++++++++++++++++++++++++++++++
 1 file changed, 185 insertions(+)
 create mode 100644 man/man2/ioctl_xfs_verify_media.2


diff --git a/man/man2/ioctl_xfs_verify_media.2 b/man/man2/ioctl_xfs_verify_media.2
new file mode 100644
index 00000000000000..bd0d4579f5a364
--- /dev/null
+++ b/man/man2/ioctl_xfs_verify_media.2
@@ -0,0 +1,185 @@
+.\" Copyright (c) 2025-2026, Oracle.  All rights reserved.
+.\"
+.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
+.\" SPDX-License-Identifier: GPL-2.0+
+.\" %%%LICENSE_END
+.TH IOCTL-XFS-VERIFY-MEDIA 2 2026-01-09 "XFS"
+.SH NAME
+ioctl_xfs_verify_media \- verify the media of the devices backing XFS
+.SH SYNOPSIS
+.br
+.B #include <xfs/xfs_fs.h>
+.PP
+.BI "int ioctl(int " fd ", XFS_IOC_VERIFY_MEDIA, struct xfs_verify_media *" arg );
+.SH DESCRIPTION
+Verify the media of a storage device backing an XFS filesystem.
+If errors are found, report the error to the kernel so that it can generate
+health events for the health monitoring system and fsnotify.
+The verification request is conveyed in a structure of the following form:
+.PP
+.in +4n
+.nf
+struct xfs_verify_error {
+	__u32	me_dev;
+	__u32	me_flags;
+	__u64	me_start_daddr;
+	__u64	me_end_daddr;
+	__u32	me_ioerror;
+	__u32	me_pad;
+};
+.fi
+.in
+.PP
+The field
+.I me_pad
+must be zero.
+.PP
+The field
+.I me_ioerror
+will be set if the ioctl returns success.
+.PP
+The fields
+.I me_start_daddr
+and
+.I me_end_daddr
+are the range of the storage device to verify.
+Both values must be in units of 512-byte blocks.
+The
+.I me_start_daddr
+field is inclusive, and the
+.I me_end_daddr
+field is exclusive.
+If
+.I me_end_daddr
+is larger than the size of the device, the kernel will set it to the size of
+the device.
+
+If the system call returns success and any part of the storage device range was
+successfully verified, the
+.I me_start_daddr
+field will be updated to reflect the successful verification.
+If after this update the
+.I me_start_daddr
+is equal to
+.IR me_end_daddr ,
+then the entire range was verified successfully.
+
+If not, then a media error was encountered and the caller should generate a
+series of secondary calls to this ioctl with smaller ranges to discover the
+exact location and type of media error.
+The type of media error will be written to the
+.I me_ioerror
+field.
+
+.PP
+The field
+.I me_dev
+must be one of the following values:
+.RS 0.4i
+.TP
+.B XFS_DEV_DATA
+Verify the data device.
+.TP
+.B XFS_DEV_LOG
+Verify the external log device.
+.TP
+.B XFS_DEV_RT
+Verify the realtime device.
+.RE
+.PP
+The field
+.I me_flags
+is a bitmask of one of the following values:
+.RS 0.4i
+.TP
+.B XFS_VERIFY_MEDIA_REPORT
+Report all media errors to fsnotify.
+.RE
+
+The
+.IR me_max_io_size
+field, if nonzero, will be used as advice for the maximum size of the IO to
+send to the device.
+
+The
+.I me_rest_us
+field will cause the kernel to pause for this many microseconds between IO
+requests.
+
+.SH RETURN VALUE
+On runtime error, \-1 is returned, and
+.I errno
+is set to indicate the error.
+If 0 is returned, then
+.I start_daddr
+or
+.I ioerror
+will be updated.
+.PP
+.SH ERRORS
+Error codes can be one of, but are not limited to, the following:
+.TP
+.B EPERM
+The calling process does not have sufficient privilege.
+.TP
+.B EINVAL
+One or more of the arguments specified is invalid.
+.TP
+.B EFAULT
+The
+.I arg
+structure could not be copied into the kernel.
+.TP
+.B ENODEV
+The device is not present.
+.TP
+.B ENOMEM
+There was not enough memory to perform the verification.
+
+.SH I/O ERRORS
+The
+.I ioerror
+field could be set to one of the following:
+.TP
+.B 0
+The verification I/O succeeded.
+.TP
+.B EOPNOTSUPP
+.TP
+.B ETIMEDOUT
+The kernel timed out the verification I/O command.
+.TP
+.B ENOLINK
+The transportation link to the storage device was down temporarily.
+.TP
+.B EREMOTEIO
+The storage target controller suffered a critical error.
+.TP
+.B ENODATA
+The storage target media suffered a critical error.
+.TP
+.B EILSEQ
+Storage protection metadata did not validate successfully.
+.TP
+.B ENOMEM
+There was not enough memory to allocate an I/O request.
+.TP
+.B ENODEV
+The storage device is offline.
+.TP
+.B ETIME
+The storage device timed out the I/O command.
+.TP
+.B EINVAL
+The I/O request was rejected by the device for being invalid.
+.TP
+.B EIO
+An I/O error occurred but no specific details are available.
+.RE
+.PP
+This list is not exhaustive and may grow in the future.
+
+.SH CONFORMING TO
+This API is specific to XFS filesystem on the Linux kernel.
+.SH SEE ALSO
+.BR ioctl_xfs_health_monitor (2)

