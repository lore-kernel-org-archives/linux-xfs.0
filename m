Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44298F5B
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609890; cv=none; b=ZFU0L2RUIietLiPq+nRv41EGX6mXjMttEv4DuL0QyKsLqGGFpbozNMf9Pt3Piyx4RRBkoMZHkGW7dfuxkLDCo5y7p+2WSRzhtVfNMdnBrd6mPSe5hhxjeF8LE0XR/i8IKApsap09CayEhWY8XqL14eS5D2kcJztnERun4KFQwas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609890; c=relaxed/simple;
	bh=QRa9B3M4oK5gYnXrpx0qTmQZN45e/xJvtIjy3MNS1Ww=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r2nrpowSTtCK4DgbLnsgZjwI6hRnPCmJGOIJX1jwajnEUMVwTlqBtiV/oSpoFCtRJONDMESpnTVl16UBGRiUiyj4uLha6+uYoXKDTFKzOPmGMNE6xlmycqnjGTxbtmG0dzgmr1vI7d8OnuDyYcCUXiPyC3hZ+oR0ar3hSNTbjoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o8ZwrRZF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o8ZwrRZF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75351C4CEC6;
	Fri, 11 Oct 2024 01:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609890;
	bh=QRa9B3M4oK5gYnXrpx0qTmQZN45e/xJvtIjy3MNS1Ww=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=o8ZwrRZF/jw00e0njWFUyW19J4uc8KCnwR7n+VVC4jvsAgAoEFgWuHdWMXcDmnZv1
	 UmIfqWveP3Rby3ri2YVNdKEyUHh1nyOmtK6enu4u4fllRQq/3BofxHev+5eTarjbB7
	 JItLx1JCMGwlKIHya2Nl4EBV2BwrwEo3tORM8z+fU1qfGtB98UboxmtwFJWTviyg6k
	 EAj2m0OidkHLmIXmjUK/atzoRANU7M6pJZCBNqjmkv90FUxFPSOjwUkJPHGrCMdRL9
	 PGiXjUbxA0/bymqodnmY273KttWtszgA9fGl0lfjQwqwqThHzSQcroNhVCT5ruAuoQ
	 E3rRtdioAnHKg==
Date: Thu, 10 Oct 2024 18:24:49 -0700
Subject: [PATCH 01/43] man: document the rt group geometry ioctl
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860655380.4184637.10690824516884287025.stgit@frogsfrogsfrogs>
In-Reply-To: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
References: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
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

Document the new ioctl that retrieves realtime allocation group geometry
information.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 man/man2/ioctl_xfs_rtgroup_geometry.2 |  103 +++++++++++++++++++++++++++++++++
 1 file changed, 103 insertions(+)
 create mode 100644 man/man2/ioctl_xfs_rtgroup_geometry.2


diff --git a/man/man2/ioctl_xfs_rtgroup_geometry.2 b/man/man2/ioctl_xfs_rtgroup_geometry.2
new file mode 100644
index 00000000000000..10788b1f65d233
--- /dev/null
+++ b/man/man2/ioctl_xfs_rtgroup_geometry.2
@@ -0,0 +1,103 @@
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
+	__u32  rg_capacity;
+	__u32  rg_sick;
+	__u32  rg_checked;
+	__u32  rg_flags;
+	__u64  rg_reserved[13];
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
+.I rg_capacity
+The capacity of the realtime group is returned in this field, in units of
+filesystem blocks.  This value is smaller or equal to rq_length.
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

