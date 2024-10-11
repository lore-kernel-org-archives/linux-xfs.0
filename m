Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D718BE5
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610031; cv=none; b=D+uYDyjUUwzzr4H9Drkye3NI/5YWK83sfNEK8/Q6tTrk3AaZ/WmNbqwSAnH5JbrQfPiAVwyxJTmWGroJI3U6ZLXjJoZG4Nkw7jmQEW6bEr/y7eVgH9ZEF1hyhjRiRxWNj/DRI6H5BaGOx+zitdPOjfgqtg7+pG8RdBuHi3d/oDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610031; c=relaxed/simple;
	bh=QXahV97qDgAt1NZ9kPgNGM91ETNwmgwd0et8VYonVeQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gc6ZHcksvkMXJN8FcbaAfDAEDh82jGY4aAj2c3F7m4vCjZBXOC9SKE6Md9Fq/8r6pRBpzwFW12L7ApXm9CBRQgVlgk7XJsUfPHORr4zKXtVMYcarZwDtsRJwhh7CcKSBYaUgU9Qd8EZONuq56uv38ROAGmNZVaIBFqXaLNv0iWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZUFLL9+H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZUFLL9+H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB7F5C4CEC5;
	Fri, 11 Oct 2024 01:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610030;
	bh=QXahV97qDgAt1NZ9kPgNGM91ETNwmgwd0et8VYonVeQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZUFLL9+HksjVxwkU1Dl52Vgug9KMuIxhLgQn9NkGmkvGRD58wa1Wwyh5TiIAdNsli
	 rTxA9ieJqFXMIFmuBBC+GIeuMtS7dZxWKInmoIAlGF5h6IdwFO5epVzPbLCwDo1UZj
	 3Qe6CmfkBtdJfhOHZ/LuPSTijh/6hSwr16G8J1jMe3xaZhXOygxH+GrPa4r3G94W5C
	 X9ZNnjUYN23mureHrAs5t+AWVJGrIJn3amRj2Wr/CCkkewrkshSjv6PrxUD95oTe9d
	 oGL0rDqwt5Z03FG088e2rz3HnmgANYnzR7eATer4Xt/fc/2ZyHpZv3flW3Cfbc/Mdu
	 0fSmdW1X/wKZQ==
Date: Thu, 10 Oct 2024 18:27:10 -0700
Subject: [PATCH 10/43] xfs_repair: refactor offsetof+sizeof to offsetofend
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860655519.4184637.13120804354601383664.stgit@frogsfrogsfrogs>
In-Reply-To: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
References: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
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

Replace this open-coded logic with the kernel's offsetofend macro before
we start adding more in the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs.h     |   15 +++++++++++++++
 repair/agheader.c |   21 +++++++--------------
 2 files changed, 22 insertions(+), 14 deletions(-)


diff --git a/include/xfs.h b/include/xfs.h
index e97158c8d223f5..a2f159a586ee71 100644
--- a/include/xfs.h
+++ b/include/xfs.h
@@ -38,8 +38,23 @@ extern int xfs_assert_largefile[sizeof(off_t)-8];
 #define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
 #endif
 
+/**
+ * sizeof_field() - Report the size of a struct field in bytes
+ *
+ * @TYPE: The structure containing the field of interest
+ * @MEMBER: The field to return the size of
+ */
 #define sizeof_field(TYPE, MEMBER) sizeof((((TYPE *)0)->MEMBER))
 
+/**
+ * offsetofend() - Report the offset of a struct field within the struct
+ *
+ * @TYPE: The type of the structure
+ * @MEMBER: The member within the structure to get the end offset of
+ */
+#define offsetofend(TYPE, MEMBER) \
+	(offsetof(TYPE, MEMBER)	+ sizeof_field(TYPE, MEMBER))
+
 #include <xfs/xfs_types.h>
 /* Include deprecated/compat pre-vfs xfs-specific symbols */
 #include <xfs/xfs_fs_compat.h>
diff --git a/repair/agheader.c b/repair/agheader.c
index 5d4ca26cfb6155..daadacd1c43634 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -358,26 +358,19 @@ secondary_sb_whack(
 	 * size is the size of data which is valid for this sb.
 	 */
 	if (xfs_sb_version_hasmetadir(sb))
-		size = offsetof(struct xfs_dsb, sb_metadirino)
-			+ sizeof(sb->sb_metadirino);
+		size = offsetofend(struct xfs_dsb, sb_metadirino);
 	else if (xfs_sb_version_hasmetauuid(sb))
-		size = offsetof(struct xfs_dsb, sb_meta_uuid)
-			+ sizeof(sb->sb_meta_uuid);
+		size = offsetofend(struct xfs_dsb, sb_meta_uuid);
 	else if (xfs_sb_version_hascrc(sb))
-		size = offsetof(struct xfs_dsb, sb_lsn)
-			+ sizeof(sb->sb_lsn);
+		size = offsetofend(struct xfs_dsb, sb_lsn);
 	else if (xfs_sb_version_hasmorebits(sb))
-		size = offsetof(struct xfs_dsb, sb_bad_features2)
-			+ sizeof(sb->sb_bad_features2);
+		size = offsetofend(struct xfs_dsb, sb_bad_features2);
 	else if (xfs_sb_version_haslogv2(sb))
-		size = offsetof(struct xfs_dsb, sb_logsunit)
-			+ sizeof(sb->sb_logsunit);
+		size = offsetofend(struct xfs_dsb, sb_logsunit);
 	else if (xfs_sb_version_hassector(sb))
-		size = offsetof(struct xfs_dsb, sb_logsectsize)
-			+ sizeof(sb->sb_logsectsize);
+		size = offsetofend(struct xfs_dsb, sb_logsectsize);
 	else /* only support dirv2 or more recent */
-		size = offsetof(struct xfs_dsb, sb_dirblklog)
-			+ sizeof(sb->sb_dirblklog);
+		size = offsetofend(struct xfs_dsb, sb_dirblklog);
 
 	/* Check the buffer we read from disk for garbage outside size */
 	for (ip = (char *)sbuf->b_addr + size;

