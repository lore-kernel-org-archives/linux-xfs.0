Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F381CBE5A
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882705; cv=none; b=uuCKvUoVv7U5ivhdWa49zGNQccToDNz6HmYbTdzOxiIYK4tF007ToNXpEr1bLQp2Y/QNMS0KqjIov5G7pReaAltZ/IQHAMWg0geg4wt/6ovENhCoshDhItnBcSJzchJf5CNXzwNrCSmuaog8c/Gahc7keGwTZ62tf3pXbPOMPzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882705; c=relaxed/simple;
	bh=kM0sA3rB2LBZtgEhnYrAPe2vtkHPzHg+8/hQeQoXnXk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YXgCW8hIcs+MhD21GyjTkrRvRBYSGDPnRUFtuaVBtbmRYo8SzVOAJdD/GWFJPm98XmqPC2lXjoKE+qBtGB19+O6IhjYNgK46e3gSRdzxnla+uZDonyqU7mFXziYbkcrbOTDs1iciQ4nBwDHWgDuwn2c96N3RcP0E3Kr2DCN9qLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WILGoIo1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WILGoIo1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A507C116B1;
	Tue,  2 Jul 2024 01:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882704;
	bh=kM0sA3rB2LBZtgEhnYrAPe2vtkHPzHg+8/hQeQoXnXk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WILGoIo1JDn1QYNd25nAOk5R9UQITgkIoU1WodHMheWzHQS8hjBLgMTS2keqGfb+Y
	 Q72yyP9io9xXsb6kI5QWBLogmQRhtzHuytrwQigRx9SbaBpFgmx6LkhCwxytI3W6zc
	 yZc/Wc3pO3wauyqp0RnrsKbR2VNjRD6soc3Z5ESAcTomFLooRwdFDW2307NiXIfKME
	 llGn3Gt5vH0rgN6XMkwYCV3Q0TFdWmk3cesrXD+b/iZ/AY0MQbNnjpkB8OuLtL2vCT
	 D05SLTlvy7CFpNZ/iuDfaQtIxeEzPh0s+JfSCdJ6ZJm6wmW9c8yY4LIGsb8lf0dLUy
	 zxWFvTXk+W9dg==
Date: Mon, 01 Jul 2024 18:11:44 -0700
Subject: [PATCH 04/24] man: document the XFS_IOC_GETPARENTS ioctl
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com, hch@lst.de
Message-ID: <171988121124.2009260.4591726766214900623.stgit@frogsfrogsfrogs>
In-Reply-To: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs>
References: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs>
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

Document how this new ioctl works.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 man/man2/ioctl_xfs_getparents.2 |  212 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 212 insertions(+)
 create mode 100644 man/man2/ioctl_xfs_getparents.2


diff --git a/man/man2/ioctl_xfs_getparents.2 b/man/man2/ioctl_xfs_getparents.2
new file mode 100644
index 000000000000..5bb9b96a0c95
--- /dev/null
+++ b/man/man2/ioctl_xfs_getparents.2
@@ -0,0 +1,212 @@
+.\" Copyright (c) 2019-2024 Oracle.  All rights reserved.
+.\"
+.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
+.\" SPDX-License-Identifier: GPL-2.0-or-later
+.\" %%%LICENSE_END
+.TH IOCTL-XFS-GETPARENTS 2 2024-04-09 "XFS"
+.SH NAME
+ioctl_xfs_getparents \- query XFS directory parent information
+.SH SYNOPSIS
+.br
+.B #include <xfs/xfs_fs.h>
+.PP
+.BI "int ioctl(int " fd ", XFS_IOC_GETPARENTS, struct xfs_getparents *" arg );
+.PP
+.BI "int ioctl(int " fd ", XFS_IOC_GETPARENTS_BY_HANDLE, struct xfs_getparents_by_handle *" arg );
+.SH DESCRIPTION
+This command is used to retrieve the directory parent pointers of either the
+currently opened file or a file handle.
+Parent pointers point upwards in the directory tree from a child file towards a
+parent directories.
+Each entry in a parent directory must have a corresponding parent pointer in
+the child.
+
+Calling programs should allocate a large memory buffer and initialize a header
+of the following form:
+.PP
+.in +4n
+.nf
+struct xfs_getparents {
+	struct xfs_attrlist_cursor  gp_cursor;
+	__u16                       gp_iflags;
+	__u16                       gp_oflags;
+	__u32                       gp_bufsize;
+	__u64                       __pad;
+	__u64                       gp_buffer;
+};
+
+struct xfs_getparents {
+	struct xfs_handle           gph_handle;
+	struct xfs_getparents       gph_request;
+};
+.fi
+.in
+
+.PP
+The field
+.I gp_cursor
+tracks the progress of iterating through the parent pointers.
+Calling programs must initialize this to zero before the first system call
+and must not touch it after that.
+
+.PP
+The field
+.I gp_iflags
+control the behavior of the query operation and provide more information
+about the outcome of the operation.
+There are no input flags currently defined; this field must be zero.
+
+.PP
+The field
+.I gp_oflags
+contains information about the query itself.
+Possibly output flags are:
+.RS 0.4i
+.TP
+.B XFS_GETPARENTS_OFLAG_ROOT
+The file queried was the root directory.
+.TP
+.B XFS_GETPARENTS_OFLAG_DONE
+There are no more parent pointers to query.
+.RE
+
+.PP
+The field
+.I __pad
+must be zero.
+
+.PP
+The field
+.I gp_bufsize
+should be set to the size of the buffer, in bytes.
+
+.PP
+The field
+.I gp_buffer
+should point to an output buffer for the parent pointer records.
+
+Parent pointer records are returned in the following form:
+.PP
+.in +4n
+.nf
+
+struct xfs_getparents_rec {
+	struct xfs_handle           gpr_parent;
+	__u16                       gpr_reclen;
+	char                        gpr_name[];
+};
+.fi
+.in
+
+.PP
+The field
+.I gpr_parent
+is a file handle that can be used to open the parent directory.
+
+.PP
+The field
+.I gpr_reclen
+will be set to the number of bytes used by this parent record.
+
+.PP
+The array
+.I gpr_name
+will be set to a NULL-terminated byte sequence representing the filename
+stored in the parent pointer.
+If the name is a zero-length string, the file queried has no parents.
+
+.SH SAMPLE PROGRAM
+Calling programs should allocate a large memory buffer, initialize the head
+structure to zeroes, set gp_bufsize to the size of the buffer, and call the
+ioctl.
+The XFS_GETPARENTS_OFLAG_DONE flag will be set in gp_flags when there are no
+more parent pointers to be read.
+The below code is an example of XFS_IOC_GETPARENTS usage:
+
+.nf
+#include <stdio.h>
+#include <string.h>
+#include <errno.h>
+#include <xfs/linux.h>
+#include <xfs/xfs.h>
+#include <xfs/xfs_types.h>
+#include <xfs/xfs_fs.h>
+
+int main() {
+	struct xfs_getparents gp = { };
+	struct xfs_getparents_rec *gpr;
+	int error, fd;
+
+	gp.gp_buffer = (uintptr_t)malloc(65536);
+	if (!gp.gp_buffer) {
+		perror("malloc");
+		return 1;
+	}
+	gp->gp_bufsize = 65536;
+
+	fd = open("/mnt/test/foo.txt", O_RDONLY | O_CREAT);
+	if (fd  == -1)
+		return errno;
+
+	do {
+		error = ioctl(fd, XFS_IOC_GETPARENTS, gp);
+		if (error)
+			return error;
+
+		for (gpr = xfs_getparents_first_rec(&gp);
+		     gpr != NULL;
+		     gpr = xfs_getparents_next_rec(&gp, gpr)) {
+			if (gpr->gpr_name[0] == 0)
+				break;
+
+			printf("inode		= %llu\\n",
+					gpr->gpr_parent.ha_fid.fid_ino);
+			printf("generation	= %u\\n",
+					gpr->gpr_parent.ha_fid.fid_gen);
+			printf("name		= \\"%s\\"\\n\\n",
+					gpr->gpr_name);
+		}
+	} while (!(gp.gp_flags & XFS_GETPARENTS_OFLAG_DONE));
+
+	return 0;
+}
+.fi
+
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
+One or more of the arguments specified is invalid.
+.TP
+.B EMSGSIZE
+The record buffer was not large enough to store even a single record.
+.TP
+.B ENOMEM
+Not enough memory to retrieve parent pointers.
+.TP
+.B EOPNOTSUPP
+Repairs of the requested metadata object are not supported.
+.TP
+.B EROFS
+Filesystem is read-only and a repair was requested.
+.TP
+.B ESHUTDOWN
+Filesystem is shut down due to previous errors.
+.TP
+.B EIO
+An I/O error was encountered while performing the query.
+.SH CONFORMING TO
+This API is specific to XFS filesystem on the Linux kernel.
+.SH SEE ALSO
+.BR ioctl (2)

