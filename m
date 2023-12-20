Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247C647A42
	for <linux-xfs@vger.kernel.org>; Wed, 20 Dec 2023 17:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="onWXTp6W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD25C433C8;
	Wed, 20 Dec 2023 17:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703092395;
	bh=/JZJ9GIDtgP+AaF5zw/YMXajP/VlPneSbUv0FVIzQvY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=onWXTp6WhLH1qrAHP4esiS4rbsgFzXBdEi16PCkIZZQDPoz+L+RmeRmASYmX82xzx
	 Valv6Fayu25U70RiZc1OTZKFdFbd0jLY2IqszOJrEuJWWUpY80iisQsXCpFdyVTNIX
	 JnibIk7IvBOc+tZPREU4CVv22QubnEJKmxK74qClgWt23Be0e02k6BMiOrhVbIzQNH
	 HuaOnkc9hHFxG8KJs5bB+t39PHYza6bcMOmRZIGWUCh3mneu8vzcww65ssW3uWo0wN
	 GyJCNITT6oWL5c89No7CyHI1HeDEpY4L644ZeYMNbw+dEGQGu1a5cMgITSSXzNwBVg
	 FNI3k+ZSKerDw==
Date: Wed, 20 Dec 2023 09:13:15 -0800
Subject: [PATCH 2/6] xfs_mdrestore: fix uninitialized variables in mdrestore
 main
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <170309218743.1607943.8915548696227576851.stgit@frogsfrogsfrogs>
In-Reply-To: <170309218716.1607943.7868749567386210342.stgit@frogsfrogsfrogs>
References: <170309218716.1607943.7868749567386210342.stgit@frogsfrogsfrogs>
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

Coverity complained about the "is fd a file?" flags being uninitialized.
Clean this up.

Coverity-id: 1554270
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chandan Babu R <chandanbabu@kernel.org>
---
 mdrestore/xfs_mdrestore.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)


diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 2de177c6..5dfc4234 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -472,11 +472,11 @@ main(
 	union mdrestore_headers	headers;
 	FILE			*src_f;
 	char			*logdev = NULL;
-	int			data_dev_fd;
-	int			log_dev_fd;
+	int			data_dev_fd = -1;
+	int			log_dev_fd = -1;
 	int			c;
-	bool			is_data_dev_file;
-	bool			is_log_dev_file;
+	bool			is_data_dev_file = false;
+	bool			is_log_dev_file = false;
 
 	mdrestore.show_progress = false;
 	mdrestore.show_info = false;
@@ -561,7 +561,6 @@ main(
 	/* check and open data device */
 	data_dev_fd = open_device(argv[optind], &is_data_dev_file);
 
-	log_dev_fd = -1;
 	if (mdrestore.external_log)
 		/* check and open log device */
 		log_dev_fd = open_device(logdev, &is_log_dev_file);

