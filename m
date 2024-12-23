Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C266613FEE
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992000; cv=none; b=XsDmmO+6dCgQ2n/HL50gkCjq6Zbg7PQFlRGXL0uMW6wSrKIvPeuiEncYiLli0POpsJohJSFfzWInsyadu3+LyvFmQFnktZEGsfNtvNlUUrpB9f31n5kfDxVW17IVaqou/lBzniGmTia1DEekiw3Vj/L8/f6YSI7VWYmroqfRbbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992000; c=relaxed/simple;
	bh=5QYfq8ebbqKiVYePV1+9Nje+i146QwvQC96WY6BIXAY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t7IOhzsfNgk/WBd/nmksMQV87BhWP7FS4jTZcVU3xL2zkmUejoVxsCvNrBu9Ugo0mb/BtD9vRIILO+zy23bOlET4QW9Xo3Nc3LOAbNQI2803MOEjM1TpMnfEFUx5h7mYrd7h9VgdWnSOZjO4sVOVuFVrB9FWYVnMQXew6kUwkn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=njm5Be1M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="njm5Be1M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A0B0C4CED3;
	Mon, 23 Dec 2024 22:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992000;
	bh=5QYfq8ebbqKiVYePV1+9Nje+i146QwvQC96WY6BIXAY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=njm5Be1M46EQUJTPAIsSxHbuicfduP8FrgGR62mtYSH6nj4FhUhzZpiy+wspDP5Tb
	 Ky6bf8CqVyFGTOsO7j81XZEQ6CnapjLnP0Oi18k/T2fip2fFWEWm3ICS9aIE4WEBZQ
	 j2vypJOBe77VX7UkGnSkKgjr4X9QqZPh3RQMh3chFbPYjruD27gN/31Es2L1G5UZ2U
	 +xuv6okzhCo4pXnDJ2QODtoGcb7EmwIDdWuS1xRovq3loY6BhNUcvbf0Z0Up/jvAS6
	 xr00LwOcff0rHaKw9QTqsvhqbeN4S8mdPQksOeu8w6a+3djqZuYl93vZvS2cQENq0+
	 NcUHy0+DWqFmQ==
Date: Mon, 23 Dec 2024 14:13:19 -0800
Subject: [PATCH 06/51] man: document the rt group geometry ioctl
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498943895.2297565.14103923834622796991.stgit@frogsfrogsfrogs>
In-Reply-To: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
References: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Document the new ioctl that retrieves realtime allocation group geometry
information.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 man/man2/ioctl_xfs_rtgroup_geometry.2 |   99 +++++++++++++++++++++++++++++++++
 1 file changed, 99 insertions(+)
 create mode 100644 man/man2/ioctl_xfs_rtgroup_geometry.2


diff --git a/man/man2/ioctl_xfs_rtgroup_geometry.2 b/man/man2/ioctl_xfs_rtgroup_geometry.2
new file mode 100644
index 00000000000000..c4b0de94453558
--- /dev/null
+++ b/man/man2/ioctl_xfs_rtgroup_geometry.2
@@ -0,0 +1,99 @@
+.\" Copyright (c) 2022-2024 Oracle.  All rights reserved.
+.\"
+.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
+.\" SPDX-License-Identifier: GPL-2.0-or-later
+.\" %%%LICENSE_END
+.TH IOCTL-XFS-RTGROUP-GEOMETRY 2 2022-08-18 "XFS"
+.SH NAME
+ioctl_xfs_rtgroup_geometry \- query XFS realtime group geometry information
+.SH SYNOPSIS
+.br
+.B #include <xfs/xfs_fs.h>
+.PP
+.BI "int ioctl(int " fd ", XFS_IOC_RTGROUP_GEOMETRY, struct xfs_rtgroup_geometry *" arg );
+.SH DESCRIPTION
+This XFS ioctl retrieves the geometry information for a given realtime group.
+The geometry information is conveyed in a structure of the following form:
+.PP
+.in +4n
+.nf
+struct xfs_rtgroup_geometry {
+	__u32  rg_number;
+	__u32  rg_length;
+	__u32  rg_sick;
+	__u32  rg_checked;
+	__u32  rg_flags;
+	__u32  rg_reserved[27];
+};
+.fi
+.in
+.TP
+.I rg_number
+The caller must set this field to the index of the realtime group that the
+caller wishes to learn about.
+.TP
+.I rg_length
+The length of the realtime group is returned in this field, in units of
+filesystem blocks.
+.I rg_flags
+The caller can set this field to change the operational behavior of the ioctl.
+Currently no flags are defined, so this field must be zero.
+.TP
+.IR rg_reserved " and " rg_pad
+All reserved fields will be set to zero on return.
+.PP
+The fields
+.IR rg_sick " and " rg_checked
+indicate the relative health of various realtime group metadata:
+.IP \[bu] 2
+If a given sick flag is set in
+.IR rg_sick ,
+then that piece of metadata has been observed to be damaged.
+The same bit will be set in
+.IR rg_checked .
+.IP \[bu]
+If a given sick flag is set in
+.I rg_checked
+and is not set in
+.IR rg_sick ,
+then that piece of metadata has been checked and is not faulty.
+.IP \[bu]
+If a given sick flag is not set in
+.IR rg_checked ,
+then no conclusion can be made.
+.PP
+The following flags apply to these fields:
+.RS 0.4i
+.TP
+.B XFS_RTGROUP_GEOM_SICK_SUPER
+Realtime group superblock.
+.TP
+.B XFS_RTGROUP_GEOM_SICK_BITMAP
+Realtime bitmap for this group.
+.TP
+.B XFS_RTGROUP_GEOM_SICK_SUMMARY
+Realtime summary for this group.
+.RE
+.SH RETURN VALUE
+On error, \-1 is returned, and
+.I errno
+is set to indicate the error.
+.PP
+.SH ERRORS
+Error codes can be one of, but are not limited to, the following:
+.TP
+.B EFSBADCRC
+Metadata checksum validation failed while performing the query.
+.TP
+.B EFSCORRUPTED
+Metadata corruption was encountered while performing the query.
+.TP
+.B EINVAL
+The specified realtime group number is not valid for this filesystem.
+.TP
+.B EIO
+An I/O error was encountered while performing the query.
+.SH CONFORMING TO
+This API is specific to XFS filesystem on the Linux kernel.
+.SH SEE ALSO
+.BR ioctl (2)

