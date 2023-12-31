Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34787C147
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nfOw874l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99B2C433C8;
	Sun, 31 Dec 2023 22:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062186;
	bh=Cz/CmfUNHSHRdaxYFhDnP6yMI3jv2z9NR2h+F9MmWSw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nfOw874lZbKjXuQS7D2TPhjMDGBnJp9im1xXg17fMqRtC6dAuC9vK77AZrF4p+BST
	 +//b6WVJbLg6HdPEhlpPL8k5IE2gtrQcg6hxze7KQ/ul7cYf33Ey8jIYvUNCEhTm6r
	 8TKMsIOwWHmjIIBiTONN+t2Qh/RDFidLiapCmwP0v654ffXEo4tnhmQiRVIEL7mewJ
	 sGKvYSJLlHdaNj8wMSPE8fSN0WHOhG3PDG2LVm1TdTfJ3KRp/vfJKS0EvwiTW8KVsH
	 BODPXm3mflU8JddG9yuf7YdaeLQpF/NyC9EmOV4jA2bWWvngMC5wDaEQJwpZzpgE4I
	 yGxA/DaIsKjCw==
Date: Sun, 31 Dec 2023 14:36:26 -0800
Subject: [PATCH 4/4] xfs: pin inodes that would otherwise overflow link count
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404998345.1797172.12807191836564310136.stgit@frogsfrogsfrogs>
In-Reply-To: <170404998289.1797172.11188208357520292150.stgit@frogsfrogsfrogs>
References: <170404998289.1797172.11188208357520292150.stgit@frogsfrogsfrogs>
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

The VFS inc_nlink function does not explicitly check for integer
overflows in the i_nlink field.  Instead, it checks the link count
against s_max_links in the vfs_{link,create,rename} functions.  XFS
sets the maximum link count to 2.1 billion, so integer overflows should
not be a problem.

However.  It's possible that online repair could find that a file has
more than four billion links, particularly if the link count got
corrupted while creating hardlinks to the file.  The di_nlinkv2 field is
not large enough to store a value larger than 2^32, so we ought to
define a magic pin value of ~0U which means that the inode never gets
deleted.  This will prevent a UAF error if the repair finds this
situation and users begin deleting links to the file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/util.c       |    3 ++-
 libxfs/xfs_format.h |    6 ++++++
 repair/incore_ino.c |    3 ++-
 3 files changed, 10 insertions(+), 2 deletions(-)


diff --git a/libxfs/util.c b/libxfs/util.c
index 11978529ed6..03191ebcd08 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -252,7 +252,8 @@ libxfs_bumplink(
 
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
 
-	inc_nlink(inode);
+	if (inode->i_nlink != XFS_NLINK_PINNED)
+		inc_nlink(inode);
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 }
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 7861539ab8b..ec25010b577 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -912,6 +912,12 @@ static inline uint xfs_dinode_size(int version)
  */
 #define	XFS_MAXLINK		((1U << 31) - 1U)
 
+/*
+ * Any file that hits the maximum ondisk link count should be pinned to avoid
+ * a use-after-free situation.
+ */
+#define	XFS_NLINK_PINNED	(~0U)
+
 /*
  * Values for di_format
  *
diff --git a/repair/incore_ino.c b/repair/incore_ino.c
index 0dd7a2f060f..b0b41a2cc5c 100644
--- a/repair/incore_ino.c
+++ b/repair/incore_ino.c
@@ -108,7 +108,8 @@ void add_inode_ref(struct ino_tree_node *irec, int ino_offset)
 		nlink_grow_16_to_32(irec);
 		/*FALLTHRU*/
 	case sizeof(uint32_t):
-		irec->ino_un.ex_data->counted_nlinks.un32[ino_offset]++;
+		if (irec->ino_un.ex_data->counted_nlinks.un32[ino_offset] != XFS_NLINK_PINNED)
+			irec->ino_un.ex_data->counted_nlinks.un32[ino_offset]++;
 		break;
 	default:
 		ASSERT(0);

