Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB46BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="smB0sAZz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B464FC433C8;
	Sun, 31 Dec 2023 21:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057274;
	bh=yuxitJKmNE6kzC/BTpKYgLpaMk2ZrhkKGnacxtLAnkA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=smB0sAZzslvZx264fyGbzQV38c4RvbSnnZ+nXEKztgn+UmPZsGaNvrJ6D3MTGjEYz
	 2owJLPAVnE7kZxvW/FfRPPBVKAu7cfX9ORfGsEhunWGpE7iodytMg/Z8LPL44GZu0O
	 /q5BuhZOVHh6VhL8H+2STXN5fQct8I5THsTI+Iw8reIlaeTb5kktAdan8BIhfPSsar
	 +jceeTDB85458h9AjRJSVGFQdaGz+7/SWYVmKMv7D0pJDoaHQyOpejoxxggPOTesbQ
	 Scc/swjpkawrUX32H1LIy92FTEHM/1wB514oitzwSBibqxS/kGy25irmqirnXTxNnt
	 9Jwezyb6owQGg==
Date: Sun, 31 Dec 2023 13:14:34 -0800
Subject: [PATCH 32/32] xfs: enable metadata directory feature
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404845381.1760491.7131898468384621664.stgit@frogsfrogsfrogs>
In-Reply-To: <170404844790.1760491.7084433932242910678.stgit@frogsfrogsfrogs>
References: <170404844790.1760491.7084433932242910678.stgit@frogsfrogsfrogs>
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

Enable the metadata directory feature.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 7596b9286988e..0636ca97622dd 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -398,7 +398,8 @@ xfs_sb_has_ro_compat_feature(
 		 XFS_SB_FEAT_INCOMPAT_BIGTIME| \
 		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR| \
 		 XFS_SB_FEAT_INCOMPAT_NREXT64| \
-		 XFS_SB_FEAT_INCOMPAT_PARENT)
+		 XFS_SB_FEAT_INCOMPAT_PARENT | \
+		 XFS_SB_FEAT_INCOMPAT_METADIR)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool

