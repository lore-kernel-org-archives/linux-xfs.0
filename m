Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D08C2D4
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q6Uop+PG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E7A3C433C7;
	Sun, 31 Dec 2023 23:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064657;
	bh=85/hQWIGySIIlclKTASSALb0nTB4ItlQ0MrtxXZM0EI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=q6Uop+PGqKd7EM9yW7IlE6MW4PmFOxpxhLGkKUANkiWKekX3O94qKqEx52QQZe+FH
	 rcAkmHFs083nj5fZLjDNHhwHSPaJOYm8enyfsPzWMadFqdGEdipEtUEEUNyWeIY/GB
	 Y4ANDKjWLJBGyrL3YNRxBIxT8g0TyjVjq0I1hVyrFX3cdgsXWwJ3XzCo5fuOfvhN4T
	 KcNAVH652IFRQgkW0rQtvzCKr9hmBTlcBt5GDTNfwBQhy+qPC94bqtoetgfRxjcFRe
	 JSEn6CvY0cu+B8WjGZOYD1v57fsqV+ETuu8Izz2PeRS2WxzAu8N0ajE9uhperDSHSj
	 Gh2MfjZzoiR6g==
Date: Sun, 31 Dec 2023 15:17:36 -0800
Subject: [PATCH 16/18] xfs_repair: wipe ondisk parent pointers when there are
 none
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405007076.1805510.11795128880302636556.stgit@frogsfrogsfrogs>
In-Reply-To: <170405006850.1805510.11145262768706358018.stgit@frogsfrogsfrogs>
References: <170405006850.1805510.11145262768706358018.stgit@frogsfrogsfrogs>
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

Erase all the parent pointers when there aren't any found by the
directory entry scan.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/pptr.c |   41 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 38 insertions(+), 3 deletions(-)


diff --git a/repair/pptr.c b/repair/pptr.c
index 7f65ae1aac3..46a214f205e 100644
--- a/repair/pptr.c
+++ b/repair/pptr.c
@@ -731,8 +731,13 @@ remove_file_pptr(
 /* Remove all pptrs from @ip. */
 static void
 clear_all_pptrs(
-	struct xfs_inode	*ip)
+	struct xfs_inode	*ip,
+	struct file_scan	*fscan)
 {
+	struct xfs_slab_cursor	*cur;
+	struct file_pptr	*file_pptr;
+	int			error;
+
 	if (no_modify) {
 		do_warn(_("would delete unlinked ino %llu parent pointers\n"),
 				(unsigned long long)ip->i_ino);
@@ -741,7 +746,37 @@ clear_all_pptrs(
 
 	do_warn(_("deleting unlinked ino %llu parent pointers\n"),
 			(unsigned long long)ip->i_ino);
-	/* XXX actually do the work */
+
+	error = -init_slab_cursor(fscan->file_pptr_recs, NULL, &cur);
+	if (error)
+		do_error(_("init ino %llu pptr cursor failed: %s\n"),
+				(unsigned long long)ip->i_ino,
+				strerror(error));
+
+	while ((file_pptr = pop_slab_cursor(cur)) != NULL) {
+		unsigned char	name[MAXNAMELEN];
+
+		error = load_file_pptr_name(fscan, file_pptr, name);
+		if (error)
+			do_error(
+  _("loading incorrect name for ino %llu parent pointer (ino %llu gen 0x%x namecookie 0x%llx) failed: %s\n"),
+					(unsigned long long)ip->i_ino,
+					(unsigned long long)file_pptr->parent_ino,
+					file_pptr->parent_gen,
+					(unsigned long long)file_pptr->name_cookie,
+					strerror(error));
+
+		error = remove_file_pptr(ip, file_pptr, name);
+		if (error)
+			do_error(
+ _("wiping ino %llu pptr (ino %llu gen 0x%x) failed: %s\n"),
+				(unsigned long long)ip->i_ino,
+				(unsigned long long)file_pptr->parent_ino,
+				file_pptr->parent_gen,
+				strerror(error));
+	}
+
+	free_slab_cursor(&cur);
 }
 
 /* Add @ag_pptr to @ip. */
@@ -1010,7 +1045,7 @@ crosscheck_file_parent_ptrs(
 		 * file.
 		 */
 		if (fscan->nr_file_pptrs > 0)
-			clear_all_pptrs(ip);
+			clear_all_pptrs(ip, fscan);
 
 		return;
 	}

