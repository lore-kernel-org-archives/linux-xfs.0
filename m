Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B285538B
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529989; cv=none; b=ZYIRFe7owvp5L9JrHGi/DVuBtzjne46zxP1Xb1VnFpy0rmeiXcbBuS+WRUYgfp7i527jjAM0RtISHuTKrBq17+4joahfWIMU+ZI6Z1Ddrhx9nh+2MY6q0tvxOB2llWYSWXijPF/Qwm3ldNGEd427yMm1SJ8BU5tD069I7vuJKAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529989; c=relaxed/simple;
	bh=rOVSsT4xQGezcJFxNDr9TZDUFzC54kDcvThlxQJ+EZM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D6mLgK/3EJ7vfqBfgl7GZSsBovcCrrhtVD0JFJbMG6Qv9oPyFg4fp1DVEIiCSt4AaPXEG5fQgLTNdlJY2g0gjWQ0jB33fTaALiF7Bjye+nBMuH6URHeBXEaz94K9c2fEOuIk66+YwWGP8QTF4ETwJqvZrL6PW/wS+VuR154xW54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BZDmU/Zc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BZDmU/Zc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480F2C4CED1;
	Sat,  7 Dec 2024 00:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529989;
	bh=rOVSsT4xQGezcJFxNDr9TZDUFzC54kDcvThlxQJ+EZM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BZDmU/Zc9cAV3Zvok2UV9cRCy91DVyycVaWh8HqLaNkpLvzE0YmJ04IK/OGeVYgpQ
	 zo+IDucmrTe3PSlCdfbDl0zWl2yJVoiGUUBq+5m/I8DsfTFE5sJgZpGTbi2W37LMo5
	 v50726kDNi6DOXVFuhEbNi6G+4BmxCtqOVzWXkxO00wNdKVx21rm3zhWzLimHHBHl9
	 WwBUdZ+khdTtiFvkI7pXBRcHAeq1I+qO2NTJXBPJGK47UtpibMEPG07awB1gVuWlcb
	 AKD02W3VGXf2NMtyrXiv3KZQZ0BKZKDVVVu0++dNHQYVcQj3PJk+0Ys9x1i5wuTLts
	 ZosfXDfeP3O2w==
Date: Fri, 06 Dec 2024 16:06:28 -0800
Subject: [PATCH 06/50] man: document the rt group geometry ioctl
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352752037.126362.17032439118208843597.stgit@frogsfrogsfrogs>
In-Reply-To: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
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

