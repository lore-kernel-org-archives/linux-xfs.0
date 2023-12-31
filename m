Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B4AC2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="euMzbnG3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEDC5C433C7;
	Sun, 31 Dec 2023 23:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066157;
	bh=gVE66MjBOl5jAYoXNtswRcMW4Tn1kwCUJj5jwAqeKSA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=euMzbnG3HsmZQGUUhuT746u5aOqj8qRg34c8nEYMri5pYGLwlNA1ZKGjeixuvnofU
	 uiP5Dcy7044yNM9MhW3qacAeYrn37TIwBd5NT6FNhaO4Z+EcvoMR3gHYJQRTnqBvsZ
	 fg11cbKeQLG3Ujv8mPTzTFJlNFbgBNKLHmsOVzak6pWo+21XCR9NBxoWdr5ZE39+23
	 eWxRhyJvzBmyvK6awVJ8IKzbj8cAozRnFZgDHXJABWj1kj9b9FjNICeEixGqFG2IqR
	 6DqnHq9E0hKSTgUlL8ZpqKUKUkjl1A9F8KU//r9H2Wx9Ua3MJUP2wuCeBsjT4dcq0p
	 ZhcP7PCKl6DFw==
Date: Sun, 31 Dec 2023 15:42:37 -0800
Subject: [PATCH 50/58] xfs_repair: adjust keep_fsinos to handle metadata
 directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010614.1809361.4904828130415486810.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
References: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
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

On a filesystem with metadata directories, we only want to automatically
mark the two root directories present because those are the only two
statically allocated inode numbers -- the rt summary inode is now just a
regular file in a directory.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase5.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)


diff --git a/repair/phase5.c b/repair/phase5.c
index d7bacb18b84..983f2169228 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -421,13 +421,14 @@ static void
 keep_fsinos(xfs_mount_t *mp)
 {
 	ino_tree_node_t		*irec;
-	int			i;
 
 	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino),
 			XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rootino));
 
-	for (i = 0; i < 3; i++)
-		set_inode_used(irec, i);
+	set_inode_used(irec, 0);	/* root dir */
+	set_inode_used(irec, 1);	/* rt bitmap or metadata dir root */
+	if (!xfs_has_metadir(mp))
+		set_inode_used(irec, 2);	/* rt summary */
 }
 
 static void

