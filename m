Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4333B5842
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 03:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773114262; cv=none; b=br8n7G2/FEHkjeWtHW+6IRtqDOPjNQosoW0WF9wfufg22LlI/rlrIXl2yLtwJPUbW1xtjpLLfS7xiI57j9uKWDvCoYKB2o8915+BrOWqq7YsY1PODcrvdzLxLMC9KWeLl0GEiO0IN5uzG5LhQIeQNOEOe7HPLfPU+mwYvPG8R9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773114262; c=relaxed/simple;
	bh=w1PdPjvoBJA3X/OdFeTHIssl6xegSLHIaXrr87yL6Y8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WgvDjp02YIVy9SZpNhBwas0P3WnnlAJHJZ52Zi8VLSenuZdRcPhiCEaFTkOFvGUPDtUQXt0UDAWS5nZF1bMrStgUZCWqix+sWCQP0LWgYlZO1sZPLegA3PgsSbxEcMgR7Pw8KHZPjD8bxiuJUyCvA/geJ+C6EdOtjGFtOnO5md4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q1BSCMIS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q1BSCMIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC6A9C4CEF7;
	Tue, 10 Mar 2026 03:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773114261;
	bh=w1PdPjvoBJA3X/OdFeTHIssl6xegSLHIaXrr87yL6Y8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=q1BSCMISK/ZGjh61gU9tyC1wB9htFq3p/Mu7knwxvFezjjUr21j9Pl3Ag/f7FuqC5
	 oNbjm/9XEAo8FwVmibc1OYGrBGCzV+RHC+4W0QHl8Xa8YWxe722bZlM2X/pmsiRbDG
	 s0ZHgevTwn4K3dShodZeM/F1eJFVVa/tnQLCZBnF44Ut0u7jMn+BQ25TDFcM17inHX
	 DwA9trsp/srBhj45cn+3NOnVS5lmFAhjUJFQa9DX9XnAzGgFeQjI7G05iQ2SfInbuh
	 aL1O/8BwsLKhuQQCQndDfuMrK9fUhen7QBJ1y3I02dIq/qgQlAbT/hejgbn775GLvA
	 zqDclf9TddEiA==
Date: Mon, 09 Mar 2026 20:44:21 -0700
Subject: [PATCH 07/28] man2: document the media verification ioctl
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177311401592.1183235.9634589817546832432.stgit@frogsfrogsfrogs>
In-Reply-To: <177311401331.1183235.13382695982141268952.stgit@frogsfrogsfrogs>
References: <177311401331.1183235.13382695982141268952.stgit@frogsfrogsfrogs>
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

