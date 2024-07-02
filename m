Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7158D4C8B
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719883330; cv=none; b=UWwaoa8n6YKAobylI4ZtykPy2xoAu3nsleG8DJcUaJYZpXfF6s/G3wrGHi5/5fVtVhJLlaXV58/59yQq9+myJBrisK1xGuUo1GFuAke8zXhx+dEtOnf/BIqyZypncIDAagpr1aWokTZDdFESuSVebapaxvHmPii3MQYktXnBrjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719883330; c=relaxed/simple;
	bh=ZO+JaNXEBq+GFNbfyYmu4DcvX4GvCZvAErILJiLrQJ4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bQhvF7L8owRhAnIFpb0Jr3HQny3sPslXfnAoJp3c94vE4pSeg866bC1MDupl3HZzKNUnPpbNxFgVekDDXf8wExMC3LTeusQhdENp/xLW/aCXxH4fbZoWaVkXAJXsi3DIcZrymhsYTIxJE61TENW76+E365NHQ/EGWmEJRqa39qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ObpPNq4w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ObpPNq4w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3612EC116B1;
	Tue,  2 Jul 2024 01:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719883330;
	bh=ZO+JaNXEBq+GFNbfyYmu4DcvX4GvCZvAErILJiLrQJ4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ObpPNq4wzubzklpm1Cy2wW6fwN+LU6aWFwpY1cRSPMTOwcN2oucNyNmnNb7lMC3HC
	 I9d4XBKJ2TNp3zERCBIWz6hfm3+hOtb3kcdtz7XD5Z9wvLmLsl9R9jEAVZWTlBORF/
	 +C1QeqUzce9Lx475mwGIUN0UdwadhZH/Nx+s3XOGJ3AicTv9V/pa0FYK2/6tyNCPde
	 RfebMW02B0K+JMKDhHdj1DoKcbODQDl50uwvPZ5dbqo4xk+bQeOkjxai/KdF6s1xMN
	 Uy03onGdDwrci58YV7Ve6jvByolpByv1EeWucMnKz7Xay8XP5mD7BZbDGfTJ5hrKv2
	 OoC7SMzMRADJA==
Date: Mon, 01 Jul 2024 18:22:09 -0700
Subject: [PATCH 01/10] man: document vectored scrub mode
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988123150.2012546.15521264443878817076.stgit@frogsfrogsfrogs>
In-Reply-To: <171988123120.2012546.17403096510880884928.stgit@frogsfrogsfrogs>
References: <171988123120.2012546.17403096510880884928.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add a manpage to document XFS_IOC_SCRUBV_METADATA.  From the kernel
patch:

Introduce a variant on XFS_SCRUB_METADATA that allows for a vectored
mode.  The caller specifies the principal metadata object that they want
to scrub (allocation group, inode, etc.) once, followed by an array of
scrub types they want called on that object.  The kernel runs the scrub
operations and writes the output flags and errno code to the
corresponding array element.

A new pseudo scrub type BARRIER is introduced to force the kernel to
return to userspace if any corruptions have been found when scrubbing
the previous scrub types in the array.  This enables userspace to
schedule, for example, the sequence:

 1. data fork
 2. barrier
 3. directory

If the data fork scrub is clean, then the kernel will perform the
directory scrub.  If not, the barrier in 2 will exit back to userspace.

The alternative would have been an interface where userspace passes a
pointer to an empty buffer, and the kernel formats that with
xfs_scrub_vecs that tell userspace what it scrubbed and what the outcome
was.  With that the kernel would have to communicate that the buffer
needed to have been at least X size, even though for our cases
XFS_SCRUB_TYPE_NR + 2 would always be enough.

Compared to that, this design keeps all the dependency policy and
ordering logic in userspace where it already resides instead of
duplicating it in the kernel. The downside of that is that it needs the
barrier logic.

When running fstests in "rebuild all metadata after each test" mode, I
observed a 10% reduction in runtime due to fewer transitions across the
system call boundary.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 man/man2/ioctl_xfs_scrubv_metadata.2 |  171 ++++++++++++++++++++++++++++++++++
 1 file changed, 171 insertions(+)
 create mode 100644 man/man2/ioctl_xfs_scrubv_metadata.2


diff --git a/man/man2/ioctl_xfs_scrubv_metadata.2 b/man/man2/ioctl_xfs_scrubv_metadata.2
new file mode 100644
index 000000000000..532916756df5
--- /dev/null
+++ b/man/man2/ioctl_xfs_scrubv_metadata.2
@@ -0,0 +1,171 @@
+.\" Copyright (c) 2023-2024 Oracle.  All rights reserved.
+.\"
+.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
+.\" SPDX-License-Identifier: GPL-2.0-or-later
+.\" %%%LICENSE_END
+.TH IOCTL-XFS-SCRUBV-METADATA 2 2024-05-21 "XFS"
+.SH NAME
+ioctl_xfs_scrubv_metadata \- check a lot of XFS filesystem metadata
+.SH SYNOPSIS
+.br
+.B #include <xfs/xfs_fs.h>
+.PP
+.BI "int ioctl(int " dest_fd ", XFS_IOC_SCRUBV_METADATA, struct xfs_scrub_vec_head *" arg );
+.SH DESCRIPTION
+This XFS ioctl asks the kernel driver to examine several pieces of filesystem
+metadata for errors or suboptimal metadata.
+Multiple scrub types can be invoked to target a single filesystem object.
+See
+.BR ioctl_xfs_scrub_metadata (2)
+for a discussion of metadata validation, and documentation of the various
+.B XFS_SCRUB_TYPE
+and
+.B XFS_SCRUB_FLAGS
+values referenced below.
+
+The types and location of the metadata to scrub are conveyed as a vector with
+a header of the following form:
+.PP
+.in +4n
+.nf
+
+struct xfs_scrub_vec_head {
+	__u64 svh_ino;
+	__u32 svh_gen;
+	__u32 svh_agno;
+	__u32 svh_flags;
+	__u16 svh_rest_us;
+	__u16 svh_nr;
+	__u64 svh_reserved;
+	__u64 svh_vectors;
+};
+.fi
+.in
+.PP
+The field
+.IR svh_ino ,
+.IR svh_gen ,
+and
+.IR svh_agno
+correspond to the
+.IR sm_ino ,
+.IR sm_gen ,
+and
+.IR sm_agno
+fields of the regular scrub ioctl.
+Exactly one filesystem object can be specified in a single call.
+The kernel will proceed with each vector in
+.I svh_vectors
+until progress is no longer possible.
+
+The field
+.I svh_rest_us
+specifies an amount of time to pause between each scrub invocation to give
+the system a chance to process other requests.
+
+The field
+.I svh_nr
+specifies the number of vectors in the
+.I svh_vectors
+array.
+
+The field
+.I svh_vectors
+is a pointer to an array of
+.B struct xfs_scrub_vec
+structures.
+
+.PP
+The field
+.I svh_reserved
+must be zero.
+
+Each vector has the following form:
+.PP
+.in +4n
+.nf
+
+struct xfs_scrub_vec {
+	__u32 sv_type;
+	__u32 sv_flags;
+	__s32 sv_ret;
+	__u32 sv_reserved;
+};
+.fi
+.in
+
+.PP
+The fields
+.I sv_type
+and
+.I sv_flags
+indicate the type of metadata to check and the behavioral changes that
+userspace will permit of the kernel.
+The
+.I sv_flags
+field will be updated upon completion of the scrub call.
+See the documentation of
+.B XFS_SCRUB_TYPE_*
+and
+.B XFS_SCRUB_[IO]FLAG_*
+values in
+.BR ioctl_xfs_scrub_metadata (2)
+for a detailed description of their purpose.
+
+.PP
+If a vector's
+.I sv_type
+field is set to the value
+.BR XFS_SCRUB_TYPE_BARRIER ,
+the kernel will stop processing vectors and return to userspace if a scrubber
+flags corruption by setting one of the
+.B XFS_SCRUB_OFLAG_*
+values in
+.I sv_flags
+or
+returns an operation error in
+.IR sv_ret .
+Otherwise, the kernel returns only after processing all vectors.
+
+The
+.I sv_ret
+field is set to the return value of the scrub function.
+See the RETURN VALUE
+section of the
+.BR ioctl_xfs_scrub_metadata (2)
+manual page for more information.
+
+The
+.B sv_reserved
+field must be zero.
+
+.SH RETURN VALUE
+On error, \-1 is returned, and
+.I errno
+is set to indicate the error.
+.PP
+.SH ERRORS
+Error codes can be one of, but are not limited to, the following:
+.TP
+.B EINVAL
+One or more of the arguments specified is invalid.
+.TP
+.B EINTR
+The operation was interrupted.
+.TP
+.B ENOMEM
+There was not sufficient memory to perform the scrub or repair operation.
+.TP
+.B EFAULT
+A memory fault was encountered while reading or writing the vector.
+.SH CONFORMING TO
+This API is specific to XFS filesystem on the Linux kernel.
+.SH NOTES
+These operations may block other filesystem operations for a long time.
+A calling process can stop the operation by being sent a fatal
+signal, but non-fatal signals are blocked.
+.SH SEE ALSO
+.BR ioctl (2)
+.BR ioctl_xfs_scrub_metadata (2)
+.BR xfs_scrub (8)
+.BR xfs_repair (8)

