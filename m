Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C2912B171
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jul 2024 05:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720676634; cv=none; b=DBMEK2V7uYN/N9y9hfGgToOGPVMJ9mXSDPFUBYpJT1KBzQe0EWSCEv3pflkeVst9hKPevay9et8e0yJTCi4afCEGx0PSKJM4q7H9DK3724V5YhbcE57xW6ES1udDqhzOZF73c8Q4nY6Btm4M/evTPZkws4Y+wVXjohDz3Z+/Jrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720676634; c=relaxed/simple;
	bh=LzoHxBHVne+sPY21yTnWgf+Y6Nwal/dCPPGmuDf/NF8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=KYBb4LhqhdEwc+l/aNjj+TTnaSnFQ059e6wwpJQBVUiUjoC7ngTHuslrEEhZeK3mYR/e5332+at7HZYJlRMt/7TmdLSnCnX9CT4+0PDML2hrFD+j9W4E0RUQku4Q1mc01RLKy4wfu9R/4PXAzTUAFCBmIfhqlxD8L9VGtgOmYCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o/55dv9m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o/55dv9m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A5C1C116B1;
	Thu, 11 Jul 2024 05:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720676634;
	bh=LzoHxBHVne+sPY21yTnWgf+Y6Nwal/dCPPGmuDf/NF8=;
	h=Date:From:To:Cc:Subject:From;
	b=o/55dv9mArn+CXPJWYQJ3iFlt/EY8OljkBasMTQogFqXs2fIjJRyAn64XfpwuUt/B
	 CNojUzs9abAXemdJy+HhxYu9AqWWhRer4T2YKf1dIG+ZE2hMR8yX+TED/BSGIkqxRd
	 NQ2osHoxNRsmpSYfnmLO13WmFAvLM3Ke6dhBf1YCwFP9LedYbYUmHVv4wR5o/Hs9cl
	 x2adcTUnmaD/YwxSCB9i2U2ut8iM2LJrjlranR82LGRG+5zHXMNSVcJ+/UKTks4SWo
	 gX5l6NduRVIHOK/ZVP5wo5yE0mZ24yaNCe2hYPCBQZ49yJghFSrfTlQoPsHqA5bKnz
	 2MCuC3d7mtkBg==
Date: Wed, 10 Jul 2024 22:43:53 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: fix file_path handling in tracepoints
Message-ID: <20240711054353.GM612460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Since file_path() takes the output buffer as one of its arguments, we
might as well have it format directly into the tracepoint's char array
instead of wasting stack space.

Fixes: 3934e8ebb7cc6 ("xfs: create a big array data structure")
Fixes: 5076a6040ca16 ("xfs: support in-memory buffer cache targets")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202403290419.HPcyvqZu-lkp@intel.com/
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/trace.h |   10 ++++------
 fs/xfs/xfs_trace.h   |   10 ++++------
 2 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 92ef4cdc486e9..c886d5d0eb021 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -959,18 +959,16 @@ TRACE_EVENT(xfile_create,
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(unsigned long, ino)
-		__array(char, pathname, 256)
+		__array(char, pathname, MAXNAMELEN)
 	),
 	TP_fast_assign(
-		char		pathname[257];
 		char		*path;
 
 		__entry->ino = file_inode(xf->file)->i_ino;
-		memset(pathname, 0, sizeof(pathname));
-		path = file_path(xf->file, pathname, sizeof(pathname) - 1);
+		path = file_path(xf->file, __entry->pathname, MAXNAMELEN);
 		if (IS_ERR(path))
-			path = "(unknown)";
-		strncpy(__entry->pathname, path, sizeof(__entry->pathname));
+			strncpy(__entry->pathname, "(unknown)",
+					sizeof(__entry->pathname));
 	),
 	TP_printk("xfino 0x%lx path '%s'",
 		  __entry->ino,
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 56c8333a470bb..0dfb698a43aa4 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4715,20 +4715,18 @@ TRACE_EVENT(xmbuf_create,
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(unsigned long, ino)
-		__array(char, pathname, 256)
+		__array(char, pathname, MAXNAMELEN)
 	),
 	TP_fast_assign(
-		char		pathname[257];
 		char		*path;
 		struct file	*file = btp->bt_file;
 
 		__entry->dev = btp->bt_mount->m_super->s_dev;
 		__entry->ino = file_inode(file)->i_ino;
-		memset(pathname, 0, sizeof(pathname));
-		path = file_path(file, pathname, sizeof(pathname) - 1);
+		path = file_path(file, __entry->pathname, MAXNAMELEN);
 		if (IS_ERR(path))
-			path = "(unknown)";
-		strncpy(__entry->pathname, path, sizeof(__entry->pathname));
+			strncpy(__entry->pathname, "(unknown)",
+					sizeof(__entry->pathname));
 	),
 	TP_printk("dev %d:%d xmino 0x%lx path '%s'",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
