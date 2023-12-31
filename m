Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39881C2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LE04+we0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9870C433C8;
	Sun, 31 Dec 2023 23:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065094;
	bh=5mS5JGKDPW1yd8gpEIgPx1KwTXn923lJfTkFYJ5w6iI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LE04+we0RLZ0FdI0mgB0lCMXG+gpggoJXThQVhz7JmD7IOfIg79v9zzRbi0goP6j7
	 q7XlQpPlInQyPMN5bZK2obcdd7yw+Mv7Q09mls90P0Mrb4cOkyWLhDmuAfUCNqqTWX
	 YUqJMozjXUtsLoZ3TycyCtVCU0WlUjeARM6mvrarV8TiycAZ/4Y/FD0Lc+BGm8YK1w
	 j+rCktw6nveZEYyV3uFbPClWliaHaz45QUHzlt/DM5e1wE7iLjiheLD1jiF0rK1Rio
	 jAozmJn7m/u5yAGselHzMxR3TctlqN0AxndQz+p28WIdBTYpzBmfWk1OD4dHNRjarw
	 saGdC7BIYck0w==
Date: Sun, 31 Dec 2023 15:24:54 -0800
Subject: [PATCH 10/28] libxfs: when creating a file in a directory,
 set the project id based on the parent
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405009310.1808635.8313663052383951910.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009159.1808635.10158480820888604007.stgit@frogsfrogsfrogs>
References: <170405009159.1808635.10158480820888604007.stgit@frogsfrogsfrogs>
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
 libxfs/inode.c           |    1 +
 libxfs/libxfs_api_defs.h |    1 +
 2 files changed, 2 insertions(+)


diff --git a/libxfs/inode.c b/libxfs/inode.c
index a29c1500776..e34b8e4b194 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -263,6 +263,7 @@ libxfs_dir_ialloc(
 		.pip		= dp,
 		.uid		= make_kuid(cr->cr_uid),
 		.gid		= make_kgid(cr->cr_gid),
+		.prid		= dp ? libxfs_get_initial_prid(dp) : 0,
 		.nlink		= nlink,
 		.rdev		= rdev,
 		.mode		= mode,
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 3455c014832..575bf45a211 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -151,6 +151,7 @@
 #define xfs_free_perag			libxfs_free_perag
 #define xfs_fs_geometry			libxfs_fs_geometry
 #define xfs_get_projid			libxfs_get_projid
+#define xfs_get_initial_prid		libxfs_get_initial_prid
 #define xfs_highbit32			libxfs_highbit32
 #define xfs_highbit64			libxfs_highbit64
 #define xfs_ialloc_calc_rootino		libxfs_ialloc_calc_rootino

