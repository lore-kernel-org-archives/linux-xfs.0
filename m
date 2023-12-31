Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7B1BE47
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="slgtvjFn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6708CC433C8;
	Sun, 31 Dec 2023 21:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058918;
	bh=C3J/Q4GWNrWYJg2uL1nZWH4bvge7X0BQGurHwy+MAdc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=slgtvjFnnHTdL6YAhTFGjU4H0qgRUKJ9dR0CGSlAZF+Jfl5fwY7yx+bhZ5oxh9dAZ
	 0TEU4sO6b38gvCh8piwoDjykf6iuVNScmxbF1KOawkJkmJyiIVntZXivdtco+BzehY
	 +SlfneVzFW0MbI48UZABx54f815c96wv/ONBWs95YQT2h9ilJxpLB28neQLpPfVBB+
	 1KfGS9oyOnbzInbnQCyc2d5EF/1rjXGJs4d/n5iYiy2TY1JNANjZSXcyyGKiIlyuu7
	 GUD5pdUHdkrrBAMt5gwiC3tryJjLtnggNzHt9DJjB70AYsuRrRdZMZ5tNtPPukjdN8
	 2OX9ZtkUY4xaw==
Date: Sun, 31 Dec 2023 13:41:57 -0800
Subject: [PATCH 39/39] xfs: enable realtime rmap btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404850530.1764998.3532838319012354252.stgit@frogsfrogsfrogs>
In-Reply-To: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
References: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_super.c |    6 ------
 1 file changed, 6 deletions(-)


diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 4a3119a48ef08..fbfd2963b2e2c 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1741,12 +1741,6 @@ xfs_fs_fill_super(
 		}
 	}
 
-	if (xfs_has_rmapbt(mp) && mp->m_sb.sb_rblocks) {
-		xfs_alert(mp,
-	"reverse mapping btree not compatible with realtime device!");
-		error = -EINVAL;
-		goto out_filestream_unmount;
-	}
 
 	if (xfs_has_parent(mp))
 		xfs_warn(mp,

