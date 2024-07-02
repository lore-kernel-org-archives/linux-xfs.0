Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04834A20
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719883237; cv=none; b=GnNglsekHOVqE0dREGdXe7slNK96w+mX5CI0LoxTSetHmId+CKztcNPfELY0EO7WrqA7ZsausMAp+poo9lPXRwkHmZaRjq0oTFGlzOPDhPI8WAXw3lyQXdSQHow1JRL53cAr+gQ7oaF9/01NNxR9hHQK1oIKvXeZ/HJeUdpPLpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719883237; c=relaxed/simple;
	bh=hXeDFFPLdsOFsiXDyS5BzKNrXOnC+gvIs6cLwSHF21M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FmpId5T7AcHK1DI2lQAFzioTSiR2UpWPe/ctQLz1SiTfceiIdgGclOs37/8htjK5LytQBEgTFeq6YSC0zb08bjLDWyvZ8AYfGmbr9eSV8Qf9akK2oh2vdT4KzRpGrYMlxdPny5TWVoznYObziNSpOCXca7qJi+LfYgX90tqMxk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VKHiMe43; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VKHiMe43"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE88C116B1;
	Tue,  2 Jul 2024 01:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719883236;
	bh=hXeDFFPLdsOFsiXDyS5BzKNrXOnC+gvIs6cLwSHF21M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VKHiMe43y+AX+SjLm3rJHQjwIQCofzaYIRnJnx1SEAc+F48c+1JUCflxgegCTiNC9
	 o0+9tz+uSfwXKjeA5kxHYwQjqaplUd2rBsqDHoB/yciJCNvgL7XChOr4HIU7scLP4Q
	 P51GhADpKGbNEu9lDLx+CUcqcvOwzqONVP8uPPQbdPSZH+nSoF+J84FX8wJXfhHuUk
	 a9GwomfyblONGcMiREdkvEIgiJpRcgdIFRsTMIds3u25RmjLFxGOba3f1PdMpWLuCh
	 ZsXaIYKH/RdHWPtJ4xQXeTCbFG9VTcHAUi4xsi64/LKEsMa8e+HL1J4wLZVtaiMl6r
	 EebA6LzJ0gxSw==
Date: Mon, 01 Jul 2024 18:20:36 -0700
Subject: [PATCH 12/12] xfs_repair: wipe ondisk parent pointers when there are
 none
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com, hch@lst.de
Message-ID: <171988122352.2010218.17899349898608092894.stgit@frogsfrogsfrogs>
In-Reply-To: <171988122147.2010218.8997075209577453030.stgit@frogsfrogsfrogs>
References: <171988122147.2010218.8997075209577453030.stgit@frogsfrogsfrogs>
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
index 94d6d834627c..8ec6a51d2c3d 100644
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

