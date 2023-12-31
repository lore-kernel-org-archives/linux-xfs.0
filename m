Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70E6C2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SVcOcPNt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC8EFC433C8;
	Sun, 31 Dec 2023 23:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064641;
	bh=PNZOvuxfRJKsSH8KYVp8vohgpN3yLM8M+GnA2crUh/s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SVcOcPNt4PvibH6pzkcBh+hRtE3pUtRTJv6kQBcK9bhSb76UIWnKCFEW+09s1hXvE
	 xd3ax5jtCMkVyXgzFWYjuUq7FxcaHUjlqoQ+5mtNOgfzXY50nOCXge2LMK/96QNagc
	 1EZsFO7kKCdpUsFHvFPMva5PEinQVyUUBiEGU4qxsfldlKS2GcVCH5eR64M+AB9QZj
	 DvdJ7nS69ciwoWZjwOwqhr7tRiIVGxXgH5ed4Tyyd4o7Nn5swd/hWYSdctDbyT7CVC
	 w6eH6ctojtab0lD0jsJOTrRFG/ltKO9YahasHGFTus4otaxgDowSQI13+A5IpZKIjo
	 jIbNCQ23/BNaQ==
Date: Sun, 31 Dec 2023 15:17:21 -0800
Subject: [PATCH 15/18] xfs_repair: update ondisk parent pointer records
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405007062.1805510.1229066115957563747.stgit@frogsfrogsfrogs>
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

Update the ondisk parent pointer records as necessary.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    2 +
 repair/pptr.c            |   89 ++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 88 insertions(+), 3 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 1aa2d9f0679..d5662c42f2b 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -187,9 +187,11 @@
 #define xfs_parent_irec_from_disk	libxfs_parent_irec_from_disk
 #define xfs_parent_irec_hashname	libxfs_parent_irec_hashname
 #define xfs_parent_lookup		libxfs_parent_lookup
+#define xfs_parent_set			libxfs_parent_set
 #define xfs_parent_start		libxfs_parent_start
 #define xfs_parent_hashcheck		libxfs_parent_hashcheck
 #define xfs_parent_namecheck		libxfs_parent_namecheck
+#define xfs_parent_unset		libxfs_parent_unset
 #define xfs_parent_valuecheck		libxfs_parent_valuecheck
 #define xfs_parent_verify_irec		libxfs_parent_verify_irec
 #define xfs_perag_get			libxfs_perag_get
diff --git a/repair/pptr.c b/repair/pptr.c
index 21b15ab80ea..7f65ae1aac3 100644
--- a/repair/pptr.c
+++ b/repair/pptr.c
@@ -686,6 +686,48 @@ load_file_pptr_name(
 			name, file_pptr->namelen);
 }
 
+/* Add an on disk parent pointer to a file. */
+static int
+add_file_pptr(
+	struct xfs_inode		*ip,
+	const struct ag_pptr		*ag_pptr,
+	const unsigned char		*name)
+{
+	struct xfs_parent_name_irec	pptr_rec = {
+		.p_ino			= ag_pptr->parent_ino,
+		.p_gen			= ag_pptr->parent_gen,
+		.p_namelen		= ag_pptr->namelen,
+	};
+	struct xfs_parent_scratch	scratch;
+	int				error;
+
+	memcpy(pptr_rec.p_name, name, ag_pptr->namelen);
+	libxfs_parent_irec_hashname(ip->i_mount, &pptr_rec);
+	error = -libxfs_parent_lookup(NULL, ip, &pptr_rec, &scratch);
+	if (!error || error != ENOATTR)
+		return error;
+	return -libxfs_parent_set(ip, ip->i_ino, &pptr_rec, &scratch);
+}
+
+/* Remove an on disk parent pointer from a file. */
+static int
+remove_file_pptr(
+	struct xfs_inode		*ip,
+	const struct file_pptr		*file_pptr,
+	const unsigned char		*name)
+{
+	struct xfs_parent_name_irec	pptr_rec = {
+		.p_ino			= file_pptr->parent_ino,
+		.p_gen			= file_pptr->parent_gen,
+		.p_namelen		= file_pptr->namelen,
+	};
+	struct xfs_parent_scratch	scratch;
+
+	memcpy(pptr_rec.p_name, name, file_pptr->namelen);
+	libxfs_parent_irec_hashname(ip->i_mount, &pptr_rec);
+	return -libxfs_parent_unset(ip, ip->i_ino, &pptr_rec, &scratch);
+}
+
 /* Remove all pptrs from @ip. */
 static void
 clear_all_pptrs(
@@ -742,7 +784,16 @@ add_missing_parent_ptr(
 				name);
 	}
 
-	/* XXX actually do the work */
+	error = add_file_pptr(ip, ag_pptr, name);
+	if (error)
+		do_error(
+ _("adding ino %llu pptr (ino %llu gen 0x%x name '%.*s') failed: %s\n"),
+			(unsigned long long)ip->i_ino,
+			(unsigned long long)ag_pptr->parent_ino,
+			ag_pptr->parent_gen,
+			ag_pptr->namelen,
+			name,
+			strerror(error));
 }
 
 /* Remove @file_pptr from @ip. */
@@ -784,7 +835,16 @@ remove_incorrect_parent_ptr(
 			file_pptr->namelen,
 			name);
 
-	/* XXX actually do the work */
+	error = remove_file_pptr(ip, file_pptr, name);
+	if (error)
+		do_error(
+ _("removing ino %llu pptr (ino %llu gen 0x%x name '%.*s') failed: %s\n"),
+			(unsigned long long)ip->i_ino,
+			(unsigned long long)file_pptr->parent_ino,
+			file_pptr->parent_gen,
+			file_pptr->namelen,
+			name,
+			strerror(error));
 }
 
 /*
@@ -856,7 +916,30 @@ compare_parent_ptrs(
 			ag_pptr->namelen,
 			name1);
 
-	/* XXX do the work */
+	if (ag_pptr->parent_gen != file_pptr->parent_gen ||
+	    ag_pptr->namehash   != file_pptr->namehash) {
+		error = remove_file_pptr(ip, file_pptr, name2);
+		if (error)
+			do_error(
+ _("erasing ino %llu pptr (ino %llu gen 0x%x name '%.*s') failed: %s\n"),
+				(unsigned long long)ip->i_ino,
+				(unsigned long long)file_pptr->parent_ino,
+				file_pptr->parent_gen,
+				file_pptr->namelen,
+				name2,
+				strerror(error));
+	}
+
+	error = add_file_pptr(ip, ag_pptr, name1);
+	if (error)
+		do_error(
+ _("updating ino %llu pptr (ino %llu gen 0x%x name '%.*s') failed: %s\n"),
+			(unsigned long long)ip->i_ino,
+			(unsigned long long)ag_pptr->parent_ino,
+			ag_pptr->parent_gen,
+			ag_pptr->namelen,
+			name1,
+			strerror(error));
 }
 
 static int

