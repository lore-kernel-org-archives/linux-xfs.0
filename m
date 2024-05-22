Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9BED5234
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 02:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346298; cv=none; b=NHwrg1QXcqS+KQpgg3WvyE2VtyuXe7s6fl8edeG0XofrNv9RpF7Rw+pXI6KNjCj3rldmL9KN9V8Raf7ADNXyFiQr99A25Pk9gTxEfnADIKP7PhnGwLF3g6QGPPlC64ttA6gt01j+JUJnXkjvVwSOePBVjWkE+vfPi4/eIGKqEEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346298; c=relaxed/simple;
	bh=doJoRmqz/2VhLjd+LMuMLqMY8fgplUSMVXJLEAF+VtA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ucET+UK0GMxiZlU6bUsODOtJK1+aoCSoYaBwpeFfmm7t3dE3/3cAVqFJOrSirun401BAm3x/yq4vF3O9U8Vsb4ER33wvDIQuUgtjYwLNSf1J8Xe+yB0kqAQ4aNjz8uEHH++6VBMPe5qfqdSZme7/XGxrETnV7wv9VfzxVB3QH4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IfsyfODQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IfsyfODQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D93DC32789;
	Wed, 22 May 2024 02:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346298;
	bh=doJoRmqz/2VhLjd+LMuMLqMY8fgplUSMVXJLEAF+VtA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IfsyfODQVaHM/QuLPlZYor1lVDvZYafffYh4MErUP0sl2CeSuSSqBCmgd6PzxWW+T
	 wqgx/NJ0eBf58Ydv+TU83Q3xHweJ97joIw3LZmSTpCDK4HaUNrcP0JphHjrH+sb17a
	 vMlPEzLpa8OsGV/q19CtxiHgmNEpgJHWJFStpQA3Uq1buNmuclbN1RmutnsKZvh6rh
	 F8DZdoGL23oKdeP87gdiv2pCAKJI1tn3qq/knOAPv5Z8BD5hVL69KntsS4iWy/QgIF
	 nvo3eB7BjvfCSsNEEZgO5uRBvJR0qUYMFbZHTa5m4wlo7GP503A5w1F7PuhKUdJWsE
	 TOWf42xkJ0mgQ==
Date: Tue, 21 May 2024 19:51:38 -0700
Subject: [PATCH 011/111] xfs: create a macro for decoding ftypes in
 tracepoints
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634531876.2478931.4833372321578602962.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
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

Source kernel commit: 3c79e6a87221e063064e3680946a8b4bcd9fe78d

Create the XFS_DIR3_FTYPE_STR macro so that we can report ftype as
strings instead of numbers in tracepoints.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_da_format.h |   11 +++++++++++
 1 file changed, 11 insertions(+)


diff --git a/libxfs/xfs_da_format.h b/libxfs/xfs_da_format.h
index 24f9d1461..060e5c96b 100644
--- a/libxfs/xfs_da_format.h
+++ b/libxfs/xfs_da_format.h
@@ -159,6 +159,17 @@ struct xfs_da3_intnode {
 
 #define XFS_DIR3_FT_MAX			9
 
+#define XFS_DIR3_FTYPE_STR \
+	{ XFS_DIR3_FT_UNKNOWN,	"unknown" }, \
+	{ XFS_DIR3_FT_REG_FILE,	"file" }, \
+	{ XFS_DIR3_FT_DIR,	"directory" }, \
+	{ XFS_DIR3_FT_CHRDEV,	"char" }, \
+	{ XFS_DIR3_FT_BLKDEV,	"block" }, \
+	{ XFS_DIR3_FT_FIFO,	"fifo" }, \
+	{ XFS_DIR3_FT_SOCK,	"sock" }, \
+	{ XFS_DIR3_FT_SYMLINK,	"symlink" }, \
+	{ XFS_DIR3_FT_WHT,	"whiteout" }
+
 /*
  * Byte offset in data block and shortform entry.
  */

