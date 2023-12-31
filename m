Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D76C140
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CkmV6BLl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A0AC433C7;
	Sun, 31 Dec 2023 23:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064172;
	bh=eD6hId5iVU7eKY6ieu3rVkUF4f+CTaSLVtQrswWg7bY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CkmV6BLl0+g/xP0Ow8flLfBIGZFBCMn2iAeWhoUWemKuMi33wOLWha7ptk/by6uXb
	 e+0hThsFtNGHu+qFlOGJtitAKKDnqSOFQ3a6JK2E8M+J+Nj8CXtXxqQ1H1I9u3RS2o
	 /25XIjHK9EvmwxDCQVuJOiUKPIGmS23itLr9PXETffXFjfFSVzmySnSWGdZbvtdNyd
	 XxcB8x2JhGTLrkwV0YXahEYTYR5unU3SIlh+Ohw9Rd46ovY2lYZZzu0xYARMEJaNgq
	 khj/Tv+j/S+N73lvhlptbWmisQL1mhuDLwo0TeI/K5IpPJIhSEckUnRh8XaKLsJiLQ
	 5cEr3aeYD3ESw==
Date: Sun, 31 Dec 2023 15:09:32 -0800
Subject: [PATCH 17/32] libfrog: detect looping paths when walking directory
 parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405006328.1804688.14864529372800053315.stgit@frogsfrogsfrogs>
In-Reply-To: <170405006077.1804688.8762482665401724622.stgit@frogsfrogsfrogs>
References: <170405006077.1804688.8762482665401724622.stgit@frogsfrogsfrogs>
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

Detect loops when we're walking directory parent pointers so that we
don't loop infinitely.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/getparents.c |    3 +++
 libfrog/paths.c      |   16 ++++++++++++++++
 libfrog/paths.h      |    2 ++
 3 files changed, 21 insertions(+)


diff --git a/libfrog/getparents.c b/libfrog/getparents.c
index 016fe3f026d..fa4e4a1c9c0 100644
--- a/libfrog/getparents.c
+++ b/libfrog/getparents.c
@@ -148,6 +148,9 @@ handle_walk_ppath_rec(
 	if (rec->p_flags & PARENT_IS_ROOT)
 		return wpi->fn(wpi->mntpt, wpi->path, wpi->arg);
 
+	if (path_will_loop(wpi->path, rec->p_ino))
+		return 0;
+
 	ret = path_component_change(wpli->pc, rec->p_name,
 				strlen((char *)rec->p_name), rec->p_ino);
 	if (ret)
diff --git a/libfrog/paths.c b/libfrog/paths.c
index b3c5236990e..9ba2a2f313b 100644
--- a/libfrog/paths.c
+++ b/libfrog/paths.c
@@ -734,3 +734,19 @@ path_walk_components(
 
 	return 0;
 }
+
+/* Will this path contain a loop if we add this inode? */
+bool
+path_will_loop(
+	const struct path_list	*path_list,
+	uint64_t		ino)
+{
+	struct path_component	*pc;
+
+	list_for_each_entry(pc, &path_list->p_head, pc_list) {
+		if (pc->pc_ino == ino)
+			return true;
+	}
+
+	return false;
+}
diff --git a/libfrog/paths.h b/libfrog/paths.h
index 6be74c42b07..895171aa342 100644
--- a/libfrog/paths.h
+++ b/libfrog/paths.h
@@ -83,4 +83,6 @@ typedef int (*path_walk_fn_t)(const char *name, uint64_t ino, void *arg);
 int path_walk_components(const struct path_list *path, path_walk_fn_t fn,
 		void *arg);
 
+bool path_will_loop(const struct path_list *path, uint64_t ino);
+
 #endif	/* __LIBFROG_PATH_H__ */

