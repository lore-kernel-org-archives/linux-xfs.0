Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D23184
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734051792; cv=none; b=Tw86fh0w3LtnZEjP8IIdbdJKV08aQbPhoCOoUqOZPe/EszE+1opd/xInVcE82IxhD1xpKqmft6k/un+0+pkmO+5KjmES7T99QQVdIYF440ahk6O2TsM6jFiBY8w25UEg2olWiNF1wvzc+DqcIy9t52pVbeBdlvymMPFyaSRsfHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734051792; c=relaxed/simple;
	bh=naIcdYq6hKI8G/wHjLHHiLjYTPVCLYcaTYmNvrp/pBE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o+AUQTjVbfBvsgyX4YeQ2fdkOW/8PxiGtCjuO8KchOSPNzvL+9pL7hKV1z27TukDymdm4wWgP2O2C+Xu0fGb+blOZTYlcgKmnex0ZSEYc3axP8TCEo0r2tEMnLM3q+9DlVR3Nct2+2ap6aJpVLb0fCKrSYcjYH82SfUYGF0nMMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DPnjCyd7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DPnjCyd7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F008EC4CECE;
	Fri, 13 Dec 2024 01:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734051792;
	bh=naIcdYq6hKI8G/wHjLHHiLjYTPVCLYcaTYmNvrp/pBE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DPnjCyd7fS9O1QreRVqNW+QMuZyURc9t/IE4bYkWMA1HHmJ6GyYSP8JPzwuiY+iVI
	 m0QEUi/dmiUs/stRMyjtDrPY/GsQ2+KeZHA1/fkwjqiC+D5JIsM+UKIWmELY3jK9rM
	 udHbvgghb0OgmSyvF4Fsqwuu5HO8tzkxdaPvk5OkzYWT8QcVh7P+1ViCFWRlIBWxwL
	 hEjzQZDV9LjAg1gA6YEMBe/oqXqFj8kjcG/cFs5l7n65aPeptkZwZhf/GfKIdkiU9D
	 0RxWuW9Mfs72jp0+wTQWySlghgMIp098eae0k4dfTuX4SaehqLa6ndyQn25iAZiDnf
	 dwLZllmgCsANQ==
Date: Thu, 12 Dec 2024 17:03:11 -0800
Subject: [PATCH 10/37] xfs: pretty print metadata file types in error messages
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405123485.1181370.4679130203707005497.stgit@frogsfrogsfrogs>
In-Reply-To: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create a helper function to turn a metadata file type code into a
printable string, and use this to complain about lockdep problems with
rtgroup inodes.  We'll use this more in the next patch.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_metafile.h |   17 +++++++++++++++++
 fs/xfs/libxfs/xfs_rtgroup.c  |    3 ++-
 2 files changed, 19 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_metafile.h b/fs/xfs/libxfs/xfs_metafile.h
index 8d8f08a6071c23..9df8619d5fb1a9 100644
--- a/fs/xfs/libxfs/xfs_metafile.h
+++ b/fs/xfs/libxfs/xfs_metafile.h
@@ -6,6 +6,23 @@
 #ifndef __XFS_METAFILE_H__
 #define __XFS_METAFILE_H__
 
+static inline const char *
+xfs_metafile_type_str(enum xfs_metafile_type metatype)
+{
+	static const struct {
+		enum xfs_metafile_type	mtype;
+		const char		*name;
+	} strings[] = { XFS_METAFILE_TYPE_STR };
+	unsigned int	i;
+
+	for (i = 0; i < ARRAY_SIZE(strings); i++) {
+		if (strings[i].mtype == metatype)
+			return strings[i].name;
+	}
+
+	return NULL;
+}
+
 /* All metadata files must have these flags set. */
 #define XFS_METAFILE_DIFLAGS	(XFS_DIFLAG_IMMUTABLE | \
 				 XFS_DIFLAG_SYNC | \
diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index a79b734e70440d..9e5fdc0dc55cef 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -282,7 +282,8 @@ xfs_rtginode_ilock_print_fn(
 	const struct xfs_inode *ip =
 		container_of(m, struct xfs_inode, i_lock.dep_map);
 
-	printk(KERN_CONT " rgno=%u", ip->i_projid);
+	printk(KERN_CONT " rgno=%u metatype=%s", ip->i_projid,
+			xfs_metafile_type_str(ip->i_metatype));
 }
 
 /*

