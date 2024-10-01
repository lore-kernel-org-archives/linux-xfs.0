Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25B71C6889;
	Tue,  1 Oct 2024 16:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727801352; cv=none; b=pKvwO0KRXQX6e8wcxDVhRSOlZjkbPEzKhvDlQB/GSbgdvg8g14KISW3LIYHcjHiQuHu3GkM6HgnIFACornOPsNmm+E8L5fsA8CWZf06Cy3hs7HaxjGI1U6JQ7Kx+Q8OosqjVRceeO2OX9Hbf7yShoXXmrTbIowIXt5feOxE0XdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727801352; c=relaxed/simple;
	bh=RQTyOsoGonmabDOeTs0M+j+msYfmmA6j9u8xpsJFEtw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pps23tBYbhbFPK+OeeLcy+ioOijgCOdSHj3lAhFIg/rWdTcXAIBTjPDEo+qaaFf2LcS1g2wTZZFlr7CCXIFZJPskP5yg6KjjwW2KYeRUeZ5V8rlggIwZUaro2Kk1ibAS2YYPngBpZCDz3PsikGjFlmqKm0/KZoAWd1XC5ym0yIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BNSouaM8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BNSouaM8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FBFAC4CEC6;
	Tue,  1 Oct 2024 16:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727801352;
	bh=RQTyOsoGonmabDOeTs0M+j+msYfmmA6j9u8xpsJFEtw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BNSouaM832Pw1UiOtx/JIzAojzB+7aYAv1/6K4QCWq0oYQFsEhX7sbivhRwpJcS8a
	 BB9mE4Pdp7hIFisZF4Yn0kzvKPRLpdNYuuP9uMLq0ko/7sby1bfpxMvwVrFZZuF8rw
	 487Xyt78YXUbXF8GcCMZX5u1xA/4UV54Jj7ml/fHstKs/XlLc3zAiYS9Gl8eIJrxZg
	 pwmBMHzlG1Vm7HsbGzm0aqtEsK0bUlfGQZtt7oumot7WsKUl/SeTe5XO7ppGp7TTB5
	 45dN5ZiBzJWztVtJQ2UWmnA/298jMDg20V4S4rQbt8VBkNhYzBGVvwgJlCXPtDS5Wd
	 zsF3WmXnC4SOg==
Date: Tue, 01 Oct 2024 09:49:11 -0700
Subject: [PATCH 1/2] src/fiexchange.h: add the start-commit/commit-range
 ioctls
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <172780126034.3586479.14747488978575659943.stgit@frogsfrogsfrogs>
In-Reply-To: <172780126017.3586479.18209378224774919872.stgit@frogsfrogsfrogs>
References: <172780126017.3586479.18209378224774919872.stgit@frogsfrogsfrogs>
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

Add these two ioctls as well, since they're a part of the file content
exchange functionality.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 m4/package_xfslibs.m4 |    2 ++
 src/fiexchange.h      |   26 ++++++++++++++++++++++++++
 src/global.h          |    4 ++++
 3 files changed, 32 insertions(+)


diff --git a/m4/package_xfslibs.m4 b/m4/package_xfslibs.m4
index 5604989e34..ec7b91986c 100644
--- a/m4/package_xfslibs.m4
+++ b/m4/package_xfslibs.m4
@@ -100,7 +100,9 @@ AC_DEFUN([AC_NEED_INTERNAL_XFS_IOC_EXCHANGE_RANGE],
 #include <xfs/xfs.h>
     ]], [[
          struct xfs_exchange_range obj;
+         struct xfs_commit_range obj2;
          ioctl(-1, XFS_IOC_EXCHANGE_RANGE, &obj);
+         ioctl(-1, XFS_IOC_COMMIT_RANGE, &obj2);
     ]])],[AC_MSG_RESULT(yes)],
          [need_internal_xfs_ioc_exchange_range=yes
           AC_MSG_RESULT(no)])
diff --git a/src/fiexchange.h b/src/fiexchange.h
index 02eb0027d1..b9eb2a7e26 100644
--- a/src/fiexchange.h
+++ b/src/fiexchange.h
@@ -26,6 +26,30 @@ struct xfs_exchange_range {
 	__u64		flags;		/* see XFS_EXCHANGE_RANGE_* below */
 };
 
+/*
+ * Using the same definition of file2 as struct xfs_exchange_range, commit the
+ * contents of file1 into file2 if file2 has the same inode number, mtime, and
+ * ctime as the arguments provided to the call.  The old contents of file2 will
+ * be moved to file1.
+ *
+ * Returns -EBUSY if there isn't an exact match for the file2 fields.
+ *
+ * Filesystems must be able to restart and complete the operation even after
+ * the system goes down.
+ */
+struct xfs_commit_range {
+	__s32		file1_fd;
+	__u32		pad;		/* must be zeroes */
+	__u64		file1_offset;	/* file1 offset, bytes */
+	__u64		file2_offset;	/* file2 offset, bytes */
+	__u64		length;		/* bytes to exchange */
+
+	__u64		flags;		/* see XFS_EXCHANGE_RANGE_* below */
+
+	/* opaque file2 metadata for freshness checks */
+	__u64		file2_freshness[5];
+};
+
 /*
  * Exchange file data all the way to the ends of both files, and then exchange
  * the file sizes.  This flag can be used to replace a file's contents with a
@@ -53,5 +77,7 @@ struct xfs_exchange_range {
 					 XFS_EXCHANGE_RANGE_FILE1_WRITTEN)
 
 #define XFS_IOC_EXCHANGE_RANGE	     _IOW ('X', 129, struct xfs_exchange_range)
+#define XFS_IOC_START_COMMIT	     _IOR ('X', 130, struct xfs_commit_range)
+#define XFS_IOC_COMMIT_RANGE	     _IOW ('X', 131, struct xfs_commit_range)
 
 #endif /* _LINUX_FIEXCHANGE_H */
diff --git a/src/global.h b/src/global.h
index fc48d82e03..fbc0a0b5e1 100644
--- a/src/global.h
+++ b/src/global.h
@@ -12,6 +12,7 @@
 #ifdef NEED_INTERNAL_XFS_IOC_EXCHANGE_RANGE
 /* Override struct xfs_exchange_range in xfslibs */
 # define xfs_exchange_range		sys_xfs_exchange_range
+# define xfs_commit_range		sys_xfs_commit_range
 #endif
 
 #ifdef HAVE_XFS_XFS_H
@@ -20,7 +21,10 @@
 
 #ifdef NEED_INTERNAL_XFS_IOC_EXCHANGE_RANGE
 # undef xfs_exchange_range
+# undef xfs_commit_range
 # undef XFS_IOC_EXCHANGE_RANGE
+# undef XFS_IOC_START_COMMIT
+# undef XFS_IOC_COMMIT_RANGE
 #endif
 
 #ifdef HAVE_XFS_LIBXFS_H

