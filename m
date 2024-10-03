Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2685748D;
	Thu,  3 Oct 2024 21:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727991436; cv=none; b=n27UpOI87FlEsSzw2a65J2omUYxVN3DJb58pDRod1xvQpC/GCi9kUb+x9lzzEKgowjB49b8zEFf934+rVXit+okJcJGMjFo5e9eBmquNhVk/Bee/PB/qg82PTNUr07nXtFR63z099ySx+5RUEh4q5dhzbvjq/ywDwdj6r3ScB7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727991436; c=relaxed/simple;
	bh=JfEo9mJvBwCQGNJhYIJAP82kyzmqEaHc9LUkun9bYDU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ChzIJKBJ6kfbY6Ou9I0+0ardmcm6Juxg4Z/W+kbB+Q3V9MOL6zsxofuTCB9dmu9m5bCH9CL+ife45WOSoyivhYbgSpUv3cS0n4Vor5EVew6U/IQ6PoGlRkO+l/B8OUUn/5KzmVAxq85k18S3QCNjV9NzpgYy3X/RZRLLh6uhss8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mp8AlnPr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mp8AlnPr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75647C4CEC5;
	Thu,  3 Oct 2024 21:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727991435;
	bh=JfEo9mJvBwCQGNJhYIJAP82kyzmqEaHc9LUkun9bYDU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Mp8AlnPrx6Fwo5vnu7r83cs4kNQFxbR/1pE/06dOzW7IsmS1eyp4HiIaCRuIkBOVP
	 jLxAVVwNWiQh5L2MPjgYrsmY4tReGZd3/zR/q7fGKUeB6XXMs8SMvDsPYhwLzjEJNG
	 JULSFSqzYbhJo2maNoPvRjjRJk8jZ9uZ4geiuCnzN/Ra/xhAXff52eW7w60n4RFaNy
	 y2Gv12h348qjJBlX4wCAodPfnI03NsmfjYv9jdwQhlmII929I7eLZ1u9j5KYCVYLyj
	 jmNGHRgX+vZuVdxOYAtiffMDDwQyGlJvyNT8+8WtxsYVm37BwCeZ0DBqm3ZZ5Dx3On
	 2zNPl4wGG8ppQ==
Date: Thu, 3 Oct 2024 14:37:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	Brian Foster <bfoster@redhat.com>
Subject: [PATCH] fsstress: add support for FALLOC_FL_UNSHARE_RANGE
Message-ID: <20241003213714.GH21840@frogsfrogsfrogs>
References: <172780126017.3586479.18209378224774919872.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172780126017.3586479.18209378224774919872.stgit@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

Teach fsstress to try to unshare file blocks on filesystems, seeing how
the recent addition to fsx has uncovered a lot of bugs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 ltp/fsstress.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index b8d025d3a0..8cd45c7a85 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -139,6 +139,7 @@ typedef enum {
 	OP_TRUNCATE,
 	OP_UNLINK,
 	OP_UNRESVSP,
+	OP_UNSHARE,
 	OP_URING_READ,
 	OP_URING_WRITE,
 	OP_WRITE,
@@ -246,6 +247,7 @@ void	punch_f(opnum_t, long);
 void	zero_f(opnum_t, long);
 void	collapse_f(opnum_t, long);
 void	insert_f(opnum_t, long);
+void	unshare_f(opnum_t, long);
 void	read_f(opnum_t, long);
 void	readlink_f(opnum_t, long);
 void	readv_f(opnum_t, long);
@@ -339,6 +341,7 @@ struct opdesc	ops[OP_LAST]	= {
 	[OP_TRUNCATE]	   = {"truncate",      truncate_f,	2, 1 },
 	[OP_UNLINK]	   = {"unlink",	       unlink_f,	1, 1 },
 	[OP_UNRESVSP]	   = {"unresvsp",      unresvsp_f,	1, 1 },
+	[OP_UNSHARE]	   = {"unshare",       unshare_f,	1, 1 },
 	[OP_URING_READ]	   = {"uring_read",    uring_read_f,	-1, 0 },
 	[OP_URING_WRITE]   = {"uring_write",   uring_write_f,	-1, 1 },
 	[OP_WRITE]	   = {"write",	       write_f,		4, 1 },
@@ -3767,6 +3770,7 @@ struct print_flags falloc_flags [] = {
 	{ FALLOC_FL_COLLAPSE_RANGE, "COLLAPSE_RANGE"},
 	{ FALLOC_FL_ZERO_RANGE, "ZERO_RANGE"},
 	{ FALLOC_FL_INSERT_RANGE, "INSERT_RANGE"},
+	{ FALLOC_FL_UNSHARE_RANGE, "UNSHARE_RANGE"},
 	{ -1, NULL}
 };
 
@@ -4469,6 +4473,16 @@ insert_f(opnum_t opno, long r)
 #endif
 }
 
+void
+unshare_f(opnum_t opno, long r)
+{
+#ifdef HAVE_LINUX_FALLOC_H
+# ifdef FALLOC_FL_UNSHARE_RANGE
+	do_fallocate(opno, r, FALLOC_FL_UNSHARE_RANGE);
+# endif
+#endif
+}
+
 void
 read_f(opnum_t opno, long r)
 {
