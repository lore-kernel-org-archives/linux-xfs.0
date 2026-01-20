Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8CA54418D8;
	Tue, 20 Jan 2026 14:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768919102; cv=none; b=hsH2sSqJdeg5M8856AJV22IZX4JxdNoENYNGbzSZNCpMxKyr/lCz+Td7LmhjcAqjTEcs6frCEqE6kk9zS33GgfWC9W6OzUcOcg7Kk5EltIHZzgaSdRpKUoUkI4pDck7txuw6hZcESnyXE2QcQKfbnbsnHOGTi9ILpv9HytgRSPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768919102; c=relaxed/simple;
	bh=Kj+ayzVWTGTE/9UqBMu9SybvI6joLEnV2BfTwDGEXeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=on/EKZTAurszx1ykTk5DeK7Gzz50MEg8WC/J3rRUN3cx4yqXLshRxVEYdLSIVhIeXdltMc/LzHvfC7mftuRwcVGemYSixxxBfuirRvFgx6n4JkyhCPCnqASxpr0N7E1bbuMjptIrYwDGtZbLr1dKTnrpZiA6C0M1mj2TuMYXULA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s/je07vZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s/je07vZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5289BC2BC86;
	Tue, 20 Jan 2026 14:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768919102;
	bh=Kj+ayzVWTGTE/9UqBMu9SybvI6joLEnV2BfTwDGEXeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s/je07vZvwWeUsEcL3pK2dq3aVqLffh4qFlMyLlUCKE8hawIvdbjZJt30XhnbF//2
	 erjd0BRlrqdAF9s3wu/EkgU0TKHfOJnaq1SB6a6I1ZhZOuxxR+QfTHWFaTxN3gA/P1
	 ah55TDLpIRvWLwu3iuQv/XKeXIhvfIKR/oDUWb6oiVUSSvJ+uqJipzOwlDBNCNCs8U
	 +9yPMKyAL2GuI0plUdIU7u8nV3+O+TlrZBXu9eoKwOQkVydHdRT9Y5e1JzVoIz0iSC
	 WoY3Fif28wm0ty+pFiIe2o6qO4Fw5KILbeq8QTUrojePTpFoDTvkaDBvQojGrvKVLM
	 O49yJiwm9S4QA==
From: Chuck Lever <cel@kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>
Cc: <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	<linux-nfs@vger.kernel.org>,
	linux-f2fs-devel@lists.sourceforge.net,
	hirofumi@mail.parknet.co.jp,
	linkinjeon@kernel.org,
	sj1557.seo@samsung.com,
	yuezhang.mo@sony.com,
	almaz.alexandrovich@paragon-software.com,
	slava@dubeyko.com,
	glaubitz@physik.fu-berlin.de,
	frank.li@vivo.com,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	cem@kernel.org,
	sfrench@samba.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	trondmy@kernel.org,
	anna@kernel.org,
	jaegeuk@kernel.org,
	chao@kernel.org,
	hansg@kernel.org,
	senozhatsky@chromium.org,
	Chuck Lever <chuck.lever@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH v6 08/16] xfs: Report case sensitivity in fileattr_get
Date: Tue, 20 Jan 2026 09:24:31 -0500
Message-ID: <20260120142439.1821554-9-cel@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260120142439.1821554-1-cel@kernel.org>
References: <20260120142439.1821554-1-cel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chuck Lever <chuck.lever@oracle.com>

Upper layers such as NFSD need to query whether a filesystem is
case-sensitive. Report case sensitivity via the FS_XFLAG_CASEFOLD
flag in xfs_fileattr_get(). XFS always preserves case. XFS is
case-sensitive by default, but supports ASCII case-insensitive
lookups when formatted with the ASCIICI feature flag.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/xfs/xfs_ioctl.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index f0417c4d1fca..da98d4422b02 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -516,6 +516,13 @@ xfs_fileattr_get(
 	xfs_fill_fsxattr(ip, XFS_DATA_FORK, fa);
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
+	/*
+	 * FS_XFLAG_CASEFOLD indicates case-insensitive lookups with
+	 * case preservation. This matches ASCIICI behavior: lookups
+	 * fold ASCII case while filenames remain stored verbatim.
+	 */
+	if (xfs_has_asciici(ip->i_mount))
+		fa->fsx_xflags |= FS_XFLAG_CASEFOLD;
 	return 0;
 }
 
-- 
2.52.0

