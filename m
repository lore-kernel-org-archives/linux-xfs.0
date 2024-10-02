Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED826FB0
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831490; cv=none; b=kUZLlHxM4wXhuFN0oUSKvNiUY7T45QjGlCmE9Q1v/Rv40AHnc5LsrZM3BBqnaDclRiHANjOMDqsrwjNImNMEDRlxXyT8H/4+Hzb5jbJn1g+7/JCMSyCMzJ5ZzKuaPik6dyxzXHxHvmyp6YIMc+2BbBkNvAm4HjEqpm5GrL+V00I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831490; c=relaxed/simple;
	bh=dhWj5VhQH+zH6sfABZA/E4qZ9AzlMSfv6oxQbkX2fCs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u7iVsEn208rNvRltqBhgFsTG/qFJ/xhmuTWWe1TzJ9azSUgqQpD4+h3GZnR6D5NiwnMvh0OtcLC85M61zuQZcyhhClOhHxvEHFYeUIh/Aw1LxuTtbN5XwnVY6ewiF8W2FAwfXsJ15nZSycRJWuCCAvHf8TokRi+rvNCDRDZiADI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sWxObT/B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sWxObT/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA8B6C4CEC6;
	Wed,  2 Oct 2024 01:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831489;
	bh=dhWj5VhQH+zH6sfABZA/E4qZ9AzlMSfv6oxQbkX2fCs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sWxObT/Bs8ox8PqtWCi6JTwd676iXDHkSVPVZ9ulEu6h8O5t1Ei5w3/SOWUoLun2t
	 XNKV6SyPw2vK5VE9hFfc+fyL+2g0sK4QAVrapcgykUnmsJVRtI7snx0T6KlkwuObMo
	 k9Q11xkDgcYEG/YKEnr5ecM7ivW/msnX4P+iH71cMX1Ghcq543enbwpetfapCOh9p1
	 l0mmGk7JQ70lPMVkvJnckuW4lZrK56eZfR0HFrnJGyrMD+veUstQ7STeuMiDMLeHk0
	 Chrph1f+yMAY8dcxth2dgPxSc908uL4SzykCH+QQxu0uTUaPdDRV4cUx6VzKCSTIVW
	 SNh91mnmrvLtA==
Date: Tue, 01 Oct 2024 18:11:29 -0700
Subject: [PATCH 14/64] libxfs: when creating a file in a directory,
 set the project id based on the parent
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172783101992.4036371.12940733887668033364.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
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

When we're creating a file as a child of an existing directory, use
xfs_get_initial_prid to have the child inherit the project id of the
directory if the directory has PROJINHERIT set, just like the kernel
does.  This fixes mkfs project id propagation with -d projinherit=X when
protofiles are in use.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/inode.c           |    3 +++
 libxfs/libxfs_api_defs.h |    1 +
 2 files changed, 4 insertions(+)


diff --git a/libxfs/inode.c b/libxfs/inode.c
index 132cf990d..d022b41b6 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -121,6 +121,9 @@ libxfs_icreate(
 			inode->i_mode |= S_ISGID;
 	}
 
+	if (pip)
+		ip->i_projid = libxfs_get_initial_prid(pip);
+
 	ip->i_disk_size = 0;
 	ip->i_df.if_nextents = 0;
 	ASSERT(ip->i_nblocks == 0);
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index df316727b..a507904f2 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -166,6 +166,7 @@
 #define xfs_free_extent_later		libxfs_free_extent_later
 #define xfs_free_perag			libxfs_free_perag
 #define xfs_fs_geometry			libxfs_fs_geometry
+#define xfs_get_initial_prid		libxfs_get_initial_prid
 #define xfs_highbit32			libxfs_highbit32
 #define xfs_highbit64			libxfs_highbit64
 #define xfs_ialloc_calc_rootino		libxfs_ialloc_calc_rootino

