Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DABE6524AF5;
	Tue, 29 Sep 2026 13:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790686992; cv=none; b=e2PpD9VwNmsfIQHWyOZKF1I9QeR4pUPwPgYxVUQ7AkDTBF7l1E3XROxbFNsdQKsSXbdiX2VOvgw7EUcgb3EK1hE1ZJbS1qfUU0gE3/i6QyVDl3FzAS33KY4nEm2/6L07e32YAD+7HTJWvK6/IxjR3A6ZW9YN6YApN9QMpQjAokQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790686992; c=relaxed/simple;
	bh=VtOw5N31T8xP21wUlIXeDcqLw8rt2VBD4LmguCozRwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SnSvooAL+yosVD/TRil0PCqnmDQDWV47g3eFeBpeZKg6efRe4thPBFBJfmOzjdotbBYug74/3j+QFs2LifSHJwrnNHG4qFoZvsj9Q1uIdVZdWf25YRafXU0Ra7Pi6vgOJfTvUO6myUFCgbSpSLJXyaAUVMtLEZhOaGpsdA8f1Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WJvH2KeB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WJvH2KeB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A081F00893;
	Tue, 29 Sep 2026 13:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790686990;
	bh=efnEf8xKXg0tOZAhuiyF54hsVYsfL6R99fCzLM7J8zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WJvH2KeBHoEFv0+VM9+caOW7vC228AhCCx4hKD87GBO2YiZNcHJmfihrLSq0PRBOQ
	 1TkPW7QodPdNSV+CgdOU149Q3//v/SpqFt6nfRsPvPaV+T/vm2DfvT6jWzFm5/m4WK
	 P4NSCkjO3yBj17den91JYGPjp47eTdzGBhwadtShxzJoVzOJQIn1QUVNOlahGqXi64
	 pP7jzebCuuYsiWfWg2za7SwGjx3JiXUpym53KyXDN5nSRsVN2P5uMGO8zRW/yBGQ49
	 fgCCiH2EGhRjOPaIyCnaZQjoKllxGfWBhq/2WGOLGgBLhvWNXJYMRKcQSv1s+IgxaG
	 FXQGdRO0Q6eJg==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Alejandro Colomar <alx@kernel.org>,
	linux-man@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	linux-api@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	djwong@kernel.org
Subject: [PATCH v5 1/3] man/man2: introduce man page for struct file_attr
Date: Tue, 29 Sep 2026 15:02:30 +0200
Message-ID: <20260929130234.3547891-2-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260916115141.3500780-1-aalbersh@kernel.org>
References: <20260916115141.3500780-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add manual pages for struct file_attr used by file_getattr() and
file_setattr() syscalls.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Link: https://lore.kernel.org/all/20250630-xattrat-syscall-v6-0-c4e3bc35227b@kernel.org/
---
 man/man2type/file_attr.2type | 153 +++++++++++++++++++++++++++++++++++
 1 file changed, 153 insertions(+)
 create mode 100644 man/man2type/file_attr.2type

diff --git a/man/man2type/file_attr.2type b/man/man2type/file_attr.2type
new file mode 100644
index 000000000000..3a1aabbc9e7d
--- /dev/null
+++ b/man/man2type/file_attr.2type
@@ -0,0 +1,153 @@
+.\" Copyright, the authors of the Linux man-pages project
+.\"
+.\" SPDX-License-Identifier: Linux-man-pages-copyleft
+.\"
+.TH file_attr 2type (date) "Linux man-pages (unreleased)"
+.SH NAME
+file_attr \- describe filesystem file attributes to get or set
+.SH SYNOPSIS
+.EX
+.B #include <linux/fs.h>
+.P
+.B struct file_attr {
+.BR "    u64  fa_xflags;" "     /* Extended flags */"
+.BR "    u32  fa_extsize;" "    /* Extent size hint */"
+.BR "    u32  fa_nextents;" "   /* Number of extents (read-only) */"
+.BR "    u32  fa_projid;" "     /* Project identifier */"
+.BR "    u32  fa_cowextsize;" " /* CoW extent size hint */"
+.B };
+.EE
+.SH DESCRIPTION
+Describes filesystem file attributes
+for use with the
+.BR file_getattr (2)
+and
+.BR file_setattr (2)
+system calls.
+.P
+The fields are as follows:
+.TP
+.I fa_xflags
+This field contains file attribute flags.
+It is a bit mask consisting of zero or more of the
+.B FS_XFLAG_*
+flags.
+Refer to the section
+.B FLAGS
+below for a list of all flags.
+.TP
+.I fa_extsize
+Extent size allocator hint in bytes.
+This value suggests a preferred extent size
+for new allocations to this file.
+.TP
+.I fa_nextents
+Number of data extents in the file (read-only).
+This field is filled in by
+.BR file_getattr (2)
+and is ignored by
+.BR file_setattr (2).
+.TP
+.I fa_projid
+Project identifier.
+Used by quota systems
+.BR quotactl (2)
+to group related files.
+.TP
+.I fa_cowextsize
+Copy-on-Write (CoW) extent size hint in bytes.
+This value suggests a preferred extent size
+for CoW operations.
+.SH FLAGS
+Flags can be:
+.RS
+.TP
+.B FS_XFLAG_REALTIME
+Data is stored in a realtime volume.
+.TP
+.B FS_XFLAG_IMMUTABLE
+File cannot be modified.
+.TP
+.B FS_XFLAG_APPEND
+All writes must append to the end of the file.
+.TP
+.B FS_XFLAG_SYNC
+All writes are synchronous.
+.TP
+.B FS_XFLAG_NOATIME
+Do not update file access time on reads.
+.TP
+.B FS_XFLAG_NODUMP
+Do not include file in backups.
+.TP
+.B FS_XFLAG_DAX
+Use Direct Access (DAX) for I/O operations.
+.TP
+.B FS_XFLAG_NODEFRAG
+Exclude this file from defragmentation operations.
+.TP
+.B FS_XFLAG_FILESTREAM
+Use filestream allocator for this file.
+.TP
+.B FS_XFLAG_EXTSIZE
+Use the extent size hint from the
+.I fa_extsize
+field.
+.TP
+.B FS_XFLAG_COWEXTSIZE
+Use the CoW extent size hint from the
+.I fa_cowextsize
+field.
+.RE
+.P
+Directory only flags:
+.RS
+.TP
+.B FS_XFLAG_RTINHERIT
+New files created in this directory inherit the realtime flag.
+.TP
+.B FS_XFLAG_NOSYMLINKS
+Disallow creation of symbolic links in this directory.
+.TP
+.B FS_XFLAG_EXTSZINHERIT
+New files created in this directory inherit the extent size hint.
+.TP
+.B FS_XFLAG_PROJINHERIT
+New files created in this directory inherit the project identifier.
+.RE
+.P
+The following flags are read-only:
+.RS
+.TP
+.B FS_XFLAG_PREALLOC
+File has preallocated extents.
+.TP
+.B FS_XFLAG_HASATTR
+File has extended attributes.
+.TP
+.B FS_XFLAG_VERITY
+File has fs-verity enabled.
+.TP
+.B FS_XFLAG_CASEFOLD
+The filesystem performs case-insensitive lookups (file and directory name
+comparisons ignore case).
+.TP
+.B FS_XFLAG_CASENONPRESERVING
+The filesystem does not preserve the case of file and directory names.
+.RE
+.P
+Not all filesystems support all flags.
+Setting unsupported flags may result in an
+.B EINVAL
+or
+.B EOPNOTSUPP
+error.
+.SH HISTORY
+.SS Linux v6.17
+This structure is introduced.
+.SS Linux v7.2
+The FS_XFLAG_CASEFOLD and FS_XFLAG_CASENONPRESERVING are introduced to enable
+upper layers, such as NFSD, to retrieve case sensitivity information.
+.SH SEE ALSO
+.BR file_getattr (2),
+.BR file_setattr (2)
-- 
2.55.0

