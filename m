Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA5FC2CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Un7Tm6be"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 261DDC433C8;
	Sun, 31 Dec 2023 23:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065079;
	bh=RF9wCQELraQFLuywDb0roDavCsKcdbgGpisU90LX0B4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Un7Tm6bevP/QfspoQRt3bzGBfTwqb8igjm22lWNjT2ZOYEIIRkAk26LHXJGDY2ks0
	 nUsCK9UisvPcAoUCFj+PhlRmzq5+ztrWGS3i2nZJ0ekm1KAz8f5EagRsQxWGJFAXZ4
	 Zz1CCjXfTdfbs7OnMjrp2uxw9fUveolBHLqocEBVVPVoDKJplWPH6mgj2n/a9OLz/k
	 kyBjuH/Tbh996FIRcEuYkwA9AwFbK/d04HpYz3kBeOMKgh8MLGtKfgb6Exuzz95vVu
	 YT+YD2+fA3vNdfLOMD9s9VGPHsV0sfRnbp8DiF7CQr0X/YP2gEz9Z2wI7TmmcEsNki
	 XKOpObc2JuOLg==
Date: Sun, 31 Dec 2023 15:24:38 -0800
Subject: [PATCH 09/28] libxfs: set access time when creating files
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405009296.1808635.1629152361024973407.stgit@frogsfrogsfrogs>
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

Set the access time on files that we're creating, to match the behavior
of the kernel.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/inode.c b/libxfs/inode.c
index 8a2f7dfff4d..a29c1500776 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -91,7 +91,8 @@ libxfs_icreate(
 	struct xfs_inode	*pip = args->pip;
 	struct xfs_inode	*ip;
 	unsigned int		flags;
-	int			times = XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
+	int			times = XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG |
+					XFS_ICHGTIME_ACCESS;
 	int			error;
 
 	error = libxfs_iget(tp->t_mountp, tp, ino, XFS_IGET_CREATE, &ip);

