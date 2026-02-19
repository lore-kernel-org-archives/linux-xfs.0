Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1FB2E2DF2
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 06:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771480953; cv=none; b=GegV+fzNO2Qmp/VWvNEWBhOQfSZK6WO2uZL9wTUVJm1rDAV+7ST5UaaS0hNlRQ6W1TbRmZfoPHA5OG6soq0hfy4jokpa0oMLd0RBnpKOKzwnmenvnUaR6wuhkQE2ddA0j2JSTOVQXur8Rin2A9yBqwqheOMoYlGd51QgvFWY6yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771480953; c=relaxed/simple;
	bh=CbkgLJEewH+PqoJTmcEDVABEcGBweyYNzhHk54Ll3m4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FTWC8o7bk1VU5yTPWACyX/9Kz1ypLRpNAaMk9lEkL+NnFayolPXvZshxevwz9kQvB/xPRIhNfcO/ANiByv481/DeVSZlc821fanpB3UoxN/6lbLhjC4hlCkYXIodtlnC9JT+juTX9DIxhTRE9wPpnxeJ6Lo1f9dgdH6GZmuO24o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EIqm8Nzu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EIqm8Nzu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E959C4CEF7;
	Thu, 19 Feb 2026 06:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771480953;
	bh=CbkgLJEewH+PqoJTmcEDVABEcGBweyYNzhHk54Ll3m4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EIqm8Nzu6tOnkMfFB8HsXmOyVW1gArDoGDLrZIWqZR68dtQMNuZRqXCQbpFivELii
	 6BpBtGmjigm5pgfP9idU6aKjAs/3146efKpnfYY+SzpK3q2TReqPboA/zZ0/SVzAs0
	 GRsZ2LclFiYQhABJaJ40WImJ6OrqLz9+oTNfbi76n8/SlM8Ohrk7NR8jxJO2nHIKxG
	 MzSH6JMoeUUyjZw9WKE1S/iT4ktkShl5TzqMfDpFpE0c01cKa+qrFxEn6DO3SG6+6p
	 5Yois/zQWcoyuygo56N8T7xO6f567dFICEonjqjiBBge/LiC+cDmIo8ZII2G8t3En0
	 oEDsqP8fEj4gQ==
Date: Wed, 18 Feb 2026 22:02:32 -0800
Subject: [PATCH 1/2] fsnotify: drop unused helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: amir73il@gmail.com, jack@suse.cz, linux-xfs@vger.kernel.org,
 brauner@kernel.org
Message-ID: <177145925776.402132.12925789451998493951.stgit@frogsfrogsfrogs>
In-Reply-To: <177145925746.402132.684963065354931952.stgit@frogsfrogsfrogs>
References: <177145925746.402132.684963065354931952.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Remove this helper now that all users have been converted to
fserror_report_metadata as of 7.0-rc1.

Cc: jack@suse.cz
Cc: amir73il@gmail.com
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 include/linux/fsnotify.h |   13 -------------
 1 file changed, 13 deletions(-)


diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 28a9cb13fbfa38..079c18bcdbde68 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -495,19 +495,6 @@ static inline void fsnotify_change(struct dentry *dentry, unsigned int ia_valid)
 		fsnotify_dentry(dentry, mask);
 }
 
-static inline int fsnotify_sb_error(struct super_block *sb, struct inode *inode,
-				    int error)
-{
-	struct fs_error_report report = {
-		.error = error,
-		.inode = inode,
-		.sb = sb,
-	};
-
-	return fsnotify(FS_ERROR, &report, FSNOTIFY_EVENT_ERROR,
-			NULL, NULL, NULL, 0);
-}
-
 static inline void fsnotify_mnt_attach(struct mnt_namespace *ns, struct vfsmount *mnt)
 {
 	fsnotify_mnt(FS_MNT_ATTACH, ns, mnt);

