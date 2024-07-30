Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0F07464
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302394; cv=none; b=gRskHIMdjaVA4DBEBWLrSO4xTn2o+jDqXrIQTnhJ8887wDHC3e5qsifanvMAskywDrvu37+1zLqZ1uYD6x5zg5XL2qy1/CvDSpbKvr5Yq9zTd5ooxgxKU7rgSfsb7i2wS1mNYKuwoLZUoQY1Opxgkadb2mvI0t3CB3P/CSV+iGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302394; c=relaxed/simple;
	bh=RhhyMRqaEYAnm2ZnRcy/eX75A+hLp9yb1Kfttgf7g9Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b9/lxwigufaOnbPVc4vQCMRVq/ykMBILARSF3e2U3a+8tOjI5RV/u7N1NZJxoZvhCCd8809CLEAChsqN3fcPnd2Y98EbAXY/3Uf2QPRt7msqoWamntEDEtTj+XihEHDCsDA6UGV2zQi2+ZBln3n8TEqoOOsh5d8LN1HU75HF9lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cQxn70ks; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cQxn70ks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2458FC32786;
	Tue, 30 Jul 2024 01:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302394;
	bh=RhhyMRqaEYAnm2ZnRcy/eX75A+hLp9yb1Kfttgf7g9Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cQxn70ksMLluUi8M1T/oS1jBnBxidGaBGHCTRUgW5Lh0gzq4e67EGchxl9G+Fi9tW
	 ixTV2wkFBi0jI7USuB3bBypM7uLdXwHeJ/wmpzyyHUsSufbdyzUKzAN9yAIsCla+TP
	 UB0vs10fm8nwmp400Ru8dOYDq+eXTXjN3wR5U21ox2XkeKkeh9OETs/3guzBhaU8fn
	 6bNYOOdDesvWMn4guIA+Of7rk+z6IcSyW+D4XLIGyI2U4dJ/Go6Ob/OFom4UZk+q8u
	 hW14FZYb5u34VpFWpo2Qa0QvXyRqpllPOaJzpsyKHjQjHGpb0xsN16hHtfU1QHrA/z
	 C9zTxipHi46BQ==
Date: Mon, 29 Jul 2024 18:19:53 -0700
Subject: [PATCH 04/24] man: document the XFS_IOC_GETPARENTS ioctl
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
 catherine.hoang@oracle.com, allison.henderson@oracle.com
Message-ID: <172229850576.1350924.12431569238530084877.stgit@frogsfrogsfrogs>
In-Reply-To: <172229850491.1350924.499207407445096350.stgit@frogsfrogsfrogs>
References: <172229850491.1350924.499207407445096350.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 man/man2/ioctl_xfs_getparents.2 |  212 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 212 insertions(+)
 create mode 100644 man/man2/ioctl_xfs_getparents.2


diff --git a/man/man2/ioctl_xfs_getparents.2 b/man/man2/ioctl_xfs_getparents.2
new file mode 100644
index 000000000..5bb9b96a0
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

