Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AFAE13A3F7
	for <linux-xfs@vger.kernel.org>; Tue, 19 May 2026 04:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779164286; cv=none; b=K3rw12SOyjqop27WkPqEZd+4QvRPf8UhYPbyivtDW1cQD0Vpxs0iCnHHvbk5OQY+zB2G/pdZ70L4b3EJF75cc6V/0Oo9B4ydIf5Ri3QxYuQo2OaLti38oa8Dn6iKhZaHVgPCv+hbAQO99DsuOdJg5cP+ttCuzoTeaSaK3k06Tes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779164286; c=relaxed/simple;
	bh=iU6JeKQQ2LkNfghRx32rT8cDbCX+dCXSMgMJHIm6p2c=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=GL4KRtlMmawQMO/BPyGOA62ar3/c8Ppn0oEZ+1RMbyH+ej/3HvZY7SgQQV1VGdv2b2UmPtzq94MAr4LGYP6PG1OhPMHstNwdq83UVXNmKG66A9EQ4+GHvrQUSESiMSUzeCYKBuFs3Z3+M7FWFf0h6SrmyphO3UrOi2DR+voQ9r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V95LVf8s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V95LVf8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA25C2BCB3;
	Tue, 19 May 2026 04:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779164285;
	bh=iU6JeKQQ2LkNfghRx32rT8cDbCX+dCXSMgMJHIm6p2c=;
	h=Date:From:To:Cc:Subject:From;
	b=V95LVf8sZXpYGR1Fh/cN4ScTEB8aZKBoos7f6hKe5U7Tovlo5MuKvkjeW0J+GC3lW
	 YcLjYg924A1UKP/O0fni/Y8zIZxqYyQ1nRX2qYNjRbEDFuDZrEXtbefsoQW79/If8f
	 j+g91u4xYOtZKzmYUQuYxj5+1/9hfqqY9P5C7Nc2IcxRiwfTv8iJ0KsgxmRBYTYmXs
	 63UYtWgalGS3VdTq+XazlQjon6SX6DVH+inETc3mHEd6BVsggxFlPi9FwRGYAFBVDG
	 dp15G7euZoADBMEAs7/oA3xt8HmC3L8J+AGmfV3lnMJ53NwWagJZeYcvZT0CSz+a1S
	 x+uyOti1QbrQw==
Date: Mon, 18 May 2026 21:18:05 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, ailiop@suse.com
Subject: [PATCH] xfs_healer: fix missing HAVE_LISTMOUNT flag and stubs
Message-ID: <20260519041805.GF9555@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

xfs/666 regressed with a broken xfs_healer_start that can't actually
walk the mount namespace with listmount and statmount.  The new stubs
are wrapped with HAVE_LISTMOUNT, but this cflag is not added in healer/
Makefile even if the build system has HAVE_LISTMOUNT set.

Also fix the stubs to return error correctly -- the wrappers follow C
library behavior.

Fixes: b30356f25335eb ("libfrog: add fallback stubs for libfrog_statmount and fstatmount")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libfrog/statmount.h |    6 ++++--
 healer/Makefile     |    4 ++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/libfrog/statmount.h b/libfrog/statmount.h
index 13aaad3a99dca1..b12e6d52ea5749 100644
--- a/libfrog/statmount.h
+++ b/libfrog/statmount.h
@@ -107,12 +107,14 @@ int libfrog_fstatmount(int fd, uint64_t statmount_flags,
 static inline int libfrog_statmount(uint64_t mnt_id, int mnt_ns_fd, uint64_t statmount_flags,
 		struct statmount *smbuf, size_t smbuf_size)
 {
-	return -ENOSYS;
+	errno = ENOSYS;
+	return -1;
 }
 static inline int libfrog_fstatmount(int fd, uint64_t statmount_flags,
 		struct statmount *smbuf, size_t smbuf_size)
 {
-	return -ENOSYS;
+	errno = ENOSYS;
+	return -1;
 }
 #endif
 
diff --git a/healer/Makefile b/healer/Makefile
index 19255f6537ae9c..b35e310cf0a220 100644
--- a/healer/Makefile
+++ b/healer/Makefile
@@ -21,6 +21,10 @@ xfs_healer.h
 
 CFLAGS+=-DXFS_SCRUB_SVCNAME=\"$(XFS_SCRUB_SVCNAME)\"
 
+ifeq ($(HAVE_LISTMOUNT),yes)
+CFLAGS += -DHAVE_LISTMOUNT
+endif
+
 LLDLIBS += $(LIBHANDLE) $(LIBFROG) $(LIBURCU) $(LIBPTHREAD)
 LTDEPENDENCIES += $(LIBHANDLE) $(LIBFROG)
 LLDFLAGS = -static
