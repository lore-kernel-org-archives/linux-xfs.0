Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D6AC8CB
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OMjAeViX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E80EC433C7;
	Sun, 31 Dec 2023 23:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063844;
	bh=VGRR26XY3Xz9Fu3YgLsTbbKHBaIVN0wOWNudO3uHACc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OMjAeViXT1lbXx9WC8toi+pjGvVNdmH9rkZmScJfOKr1+RgmWPmHfLanFTeTLpZ2P
	 i03FgVBuB/cCEf5XbQvLBEH9HH5Z+SUc/Sy1NhF/JvApJQO+oN50cqowXS5vvnvTxa
	 183A0VQ4Q2sk2siigAS5eVgef08hoD44xRwHdNZ8gk5w49MyaDyVeTgjFoDaMXF+g4
	 Ic/Wuld/+tQS/sG1z78Hh25G4yfeiZY2vwiya+tW7QWWi1Gal94wuuVV+ujzDFJIdq
	 VDFDRCDVS9U2ZnOFpvrWO+4Oq4S2U5m7YXCaPHaT4qrpqgS5CA/XwmMa+R8R8U69qQ
	 1YwHEQHz8mvCg==
Date: Sun, 31 Dec 2023 15:04:04 -0800
Subject: [PATCH 07/11] xfs: log NVLOOKUP xattr removal operations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405005690.1804370.16319420051060800903.stgit@frogsfrogsfrogs>
In-Reply-To: <170405005590.1804370.14232373294131770998.stgit@frogsfrogsfrogs>
References: <170405005590.1804370.14232373294131770998.stgit@frogsfrogsfrogs>
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

If high level code wants to do a deferred xattr remove operation with
the NVLOOKUP flag set, we need to push this through the log.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.c       |    2 ++
 libxfs/xfs_log_format.h |    1 +
 2 files changed, 3 insertions(+)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 3f9c504e755..c38048536af 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -902,6 +902,8 @@ xfs_attr_defer_add(
 		new->xattri_dela_state = xfs_attr_init_replace_state(args);
 		break;
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
+		if (args->op_flags & XFS_DA_OP_NVLOOKUP)
+			new->xattri_op_flags = XFS_ATTRI_OP_FLAGS_NVREMOVE;
 		new->xattri_dela_state = xfs_attr_init_remove_state(args);
 		break;
 	default:
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index d4531060b6b..bf648b75194 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -1043,6 +1043,7 @@ struct xfs_icreate_log {
 #define XFS_ATTRI_OP_FLAGS_SET		1	/* Set the attribute */
 #define XFS_ATTRI_OP_FLAGS_REMOVE	2	/* Remove the attribute */
 #define XFS_ATTRI_OP_FLAGS_REPLACE	3	/* Replace the attribute */
+#define XFS_ATTRI_OP_FLAGS_NVREMOVE	4	/* Remove attr w/ vlookup */
 #define XFS_ATTRI_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
 
 /*

