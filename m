Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547F6BE47
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zl+7kcaI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2198BC433C7;
	Sun, 31 Dec 2023 20:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055898;
	bh=nbN1rt5S0ystaD32BxN8VfSLW+xRGWiG+F/zo2rCsok=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Zl+7kcaIUzFt3YvHfgxjjHJANywptq+4xKi2lWRp6/Ecef1r0ITs2mZZOxsU54Ixj
	 wUF8oIsONg5NM4Mvr7vMNrFR9MYjW0uWElJy6UDyWJB4qxBOSByMk6WWsD3lODNrjX
	 eZNQJ2hkpa+uuFYK4qf1wiSvGbEOgHZ0+KYHI34pSumn7D+Z6DAStknU3ciJEFk/zj
	 V8jOO0EwicwT4f6cQkWCuw8GKlkoqYtWU/+fWHi730e6ChMI4dDw+3BT0yAvFA6doz
	 9J2Aojswh3ozW6jYVmfVRTlUth/dCUzymnUtxooRkQCDOck7ncvm2AnN4QyETqypqW
	 sYD3BeBDAKefA==
Date: Sun, 31 Dec 2023 12:51:37 -0800
Subject: [PATCH 12/18] xfs: Filter XFS_ATTR_PARENT for getfattr
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 catherine.hoang@oracle.com, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <170404841232.1756905.15803071363377442128.stgit@frogsfrogsfrogs>
In-Reply-To: <170404840995.1756905.18018727013229504371.stgit@frogsfrogsfrogs>
References: <170404840995.1756905.18018727013229504371.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Allison Henderson <allison.henderson@oracle.com>

Parent pointers returned to the get_fattr tool cause errors since
the tool cannot parse parent pointers.  Fix this by filtering parent
parent pointers from xfs_xattr_put_listent.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_xattr.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 12405e4a70c1b..483685dbaaceb 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -259,6 +259,9 @@ xfs_xattr_put_listent(
 
 	ASSERT(context->count >= 0);
 
+	if (flags & XFS_ATTR_PARENT)
+		return;
+
 	if (flags & XFS_ATTR_ROOT) {
 #ifdef CONFIG_XFS_POSIX_ACL
 		if (namelen == SGI_ACL_FILE_SIZE &&

