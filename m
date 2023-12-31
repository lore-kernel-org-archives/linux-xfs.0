Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC02C147
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nZ48XxSY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B94C433C7;
	Sun, 31 Dec 2023 23:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064063;
	bh=QJ3Y0j53gKPFV9Fl7UmlOxaUtJFBjIcj9V0+qaakKOs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nZ48XxSYEsUCElWiL9+4vPKPr3Y48LZsQDgOXOKxd27KM5GqHlcUyTTY+Gi1z4397
	 haRWWVcL1MlC5UojxOdIMsVi+xGsPsJywGhRfL5QIdDicaUO9O7CXSQk52RgeMEyBx
	 3tK8XTSY/JWu371qCjIYEDqaszV9Mz7ygBQEe3FoHFF7pxk+zVORI3tw+ZkBMqckN2
	 EVOKPFACqiaL5+OJ6Rm+Ha6plTn7KpJ7gkom0c3pvJqDZqgxKEe6D+3bUDHvkNWW5N
	 2LHpSrf58D6VickNZk9IMLbwbiLAMhzdAFpZd0ZhewVYTFTtYKCA877UstsLWduRm9
	 PGakFHMI0bwnw==
Date: Sun, 31 Dec 2023 15:07:42 -0800
Subject: [PATCH 10/32] xfs: pass the attr value to put_listent when possible
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405006236.1804688.15967255303269704822.stgit@frogsfrogsfrogs>
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

From: Allison Henderson <allison.henderson@oracle.com>

Pass the attr value to put_listent when we have local xattrs or
shortform xattrs.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.h    |    5 +++--
 libxfs/xfs_attr_sf.h |    1 +
 2 files changed, 4 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 4a4d45a96dd..0204f62298c 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -47,8 +47,9 @@ struct xfs_attrlist_cursor_kern {
 
 
 /* void; state communicated via *context */
-typedef void (*put_listent_func_t)(struct xfs_attr_list_context *, int,
-			      unsigned char *, int, int);
+typedef void (*put_listent_func_t)(struct xfs_attr_list_context *context,
+		int flags, unsigned char *name, int namelen, void *value,
+		int valuelen);
 
 struct xfs_attr_list_context {
 	struct xfs_trans	*tp;
diff --git a/libxfs/xfs_attr_sf.h b/libxfs/xfs_attr_sf.h
index 37578b369d9..c6e259791bc 100644
--- a/libxfs/xfs_attr_sf.h
+++ b/libxfs/xfs_attr_sf.h
@@ -24,6 +24,7 @@ typedef struct xfs_attr_sf_sort {
 	uint8_t		flags;		/* flags bits (see xfs_attr_leaf.h) */
 	xfs_dahash_t	hash;		/* this entry's hash value */
 	unsigned char	*name;		/* name value, pointer into buffer */
+	void		*value;
 } xfs_attr_sf_sort_t;
 
 #define XFS_ATTR_SF_ENTSIZE_MAX			/* max space for name&value */ \

