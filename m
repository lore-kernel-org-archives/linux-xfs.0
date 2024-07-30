Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4803C881E
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302926; cv=none; b=KnvMXg+BHR/B8ra/R23y9/23bVRKlA7lF7BFw2lEJ7OChXi7hKNTaaqmN9r38wEVkqhGcEDufYSTgw2y/vsmtOXGoVbBGL+83NmBHd6LDqGY1OqFX252BHT16PhHJ+QgP0jjcl3tIfJMGD9W/0wGisrETCkOD1v8SBtx0GNYHDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302926; c=relaxed/simple;
	bh=B05Bsxy/CNfQQUMk/nwB8TbTiqiQFfzCa/rVhDIKkRw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XRx6Fxuke9fenm3wyqUwEvFMcc9wsXiTJiIhDvqpF2BvlS+sBxw+0sbsZMycMwmnRM0uX/hQUnqkfhzVFOH7R6Uw8FE31hUb3DDEQTu0OOWnCuHY1lrv7fmyo5HiiYgd9zJTJVF5ezmtiokMZY80HH7Gzo8h+yOAIa7gtfcTdFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=USMbk3JM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="USMbk3JM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22714C32786;
	Tue, 30 Jul 2024 01:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302926;
	bh=B05Bsxy/CNfQQUMk/nwB8TbTiqiQFfzCa/rVhDIKkRw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=USMbk3JMc2Bi3z5ypJX7S8eGQg40m5/WI9ouM0IjwDr+N0E6MW5iwpqu8nRp1qKIm
	 82eKqd1kb/77Z8iTOpVGDQbBulIrbP215Tf5EROxfKLeFKVNkZp0ktddK0WC59S5Zb
	 0GI15KA/SCD89rq86RHrJnFoPhS+uXA9MdX+mC8OFzShUL8e913V52am3UnaMRXrvo
	 6pbAxoCeypUA2hFIfFg5NUgaBoIRvZG/UaEqlzKdaJ1xgZJEE3fUQB+0cnr6b7w6jY
	 bQT9TFeJ2xAIsToKn7+Urt7YDY4S+WM/YQsnHRExpb6/qkeX/QeBm6gwjGTA9qMn/U
	 fJDPh+3k5J84g==
Date: Mon, 29 Jul 2024 18:28:45 -0700
Subject: [PATCH 12/12] xfs_repair: wipe ondisk parent pointers when there are
 none
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
 catherine.hoang@oracle.com, allison.henderson@oracle.com
Message-ID: <172229851640.1352527.8340902280666804954.stgit@frogsfrogsfrogs>
In-Reply-To: <172229851481.1352527.11812121319440135994.stgit@frogsfrogsfrogs>
References: <172229851481.1352527.11812121319440135994.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/pptr.c |   41 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 38 insertions(+), 3 deletions(-)


diff --git a/repair/pptr.c b/repair/pptr.c
index 94d6d8346..8ec6a51d2 100644
--- a/repair/pptr.c
+++ b/repair/pptr.c
@@ -714,8 +714,13 @@ remove_file_pptr(
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
@@ -724,7 +729,37 @@ clear_all_pptrs(
 
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
@@ -1028,7 +1063,7 @@ crosscheck_file_parent_ptrs(
 		 * file.
 		 */
 		if (fscan->nr_file_pptrs > 0)
-			clear_all_pptrs(ip);
+			clear_all_pptrs(ip, fscan);
 
 		return;
 	}

