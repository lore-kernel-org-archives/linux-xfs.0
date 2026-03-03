Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A586E12CDA5
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772498405; cv=none; b=sZ6hDiVkdRE1hw4svmA2vjBJpf263Q1601tIZvmh91zSTsGOKXb8omvM/XgbvEus5XFRtoiLPouHDJRW3rYdnvYkKWIUQ4ErOOfrH4TgS7sJyEALuaFNZs/b8NQbSfVv0PNWp/FU/JGHOsZFMqcW5xkMwhHn6bB71zetMECcsrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772498405; c=relaxed/simple;
	bh=U6JwgIvpaaF/Uojsx3K5GT/h9F8BGMwj7zTKu1cwnGw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fo3K3EC8iFZxsndq7F1YK+R/1JgdqQVK/O8OBnGjspAFOapEEkbhzLrZfxXaoUGZbY8HsduHAwkiUl/OCeCTck709bTtASipU1RcVsAvsx1cKv3whVOaQ2ishWOOOfOJOL2ZAWwid94ONVKJqdYnG662PJSSGbuux9vmRwXAmCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rMp/9EKr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rMp/9EKr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85499C19423;
	Tue,  3 Mar 2026 00:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772498405;
	bh=U6JwgIvpaaF/Uojsx3K5GT/h9F8BGMwj7zTKu1cwnGw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rMp/9EKr23OMdmXJDW9jvAa/0KnkJHeiz8uSoDlC6zbXwClPA9ZiQAoFLOcjF6H5x
	 WQbgcVNU/q/0BIlRC/Ri3mZ4/XCK7WgisPaWMOqfcrehfrdkPTz77FqnYgVwCSVlQg
	 9tRRr3SLcIunyGQrWOlkM8KTslpizV+p6Of2zwfwnBthG9GTIuY2aE13zz6T2C2cBt
	 vnnmzBuhOqEWmkTdtwMwtcfb/z77RSF7oClkfbC9zxtj8QqH0vVmNkKBGAfHiY5/jO
	 qmbkhEmKGd+cpdFldVoHkJHMLDDhKuTFjIh4kFwG92OGfMEAYzXfHgr9Zny67dclFb
	 eef5M3yK8nDBw==
Date: Mon, 02 Mar 2026 16:40:05 -0800
Subject: [PATCH 24/26] mkfs: enable online repair if all backrefs are enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177249783730.482027.15356275256378511742.stgit@frogsfrogsfrogs>
In-Reply-To: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If all backreferences are enabled in the filesystem, then enable online
repair by default if the user didn't supply any other autofsck setting.
Users might as well get full self-repair capability if they're paying
for the extra metadata.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |    9 +++++++++
 1 file changed, 9 insertions(+)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index a11994027c2df1..87bdf0e22b96f8 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -6289,6 +6289,15 @@ main(
 	if (mp->m_sb.sb_agcount > 1)
 		rewrite_secondary_superblocks(mp);
 
+	/*
+	 * If the filesystem has full backreferences and the user didn't
+	 * express an autofsck preference, enable online repair because they
+	 * might as well get some useful functionality from the extra metadata.
+	 */
+	if (cli.autofsck == FSPROP_AUTOFSCK_UNSET &&
+	    cli.sb_feat.rmapbt && cli.sb_feat.parent_pointers)
+		cli.autofsck = FSPROP_AUTOFSCK_REPAIR;
+
 	if (cli.autofsck != FSPROP_AUTOFSCK_UNSET)
 		set_autofsck(mp, &cli);
 

