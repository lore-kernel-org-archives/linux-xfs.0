Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17973C140
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SbRVoiSC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD29AC433C8;
	Sun, 31 Dec 2023 22:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063390;
	bh=bef/VAWmXTcpxMpdr133BX+3Q5UdsvxafD5alMxKIus=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SbRVoiSCBscgRmGLxGSLkoq4yhdtLhKDdMgqLuZE/U8b6JhwW6GFwQ2H+S2aXz8GI
	 Xe8x6DArS/LniG5ipA7L3NrCLG51z/DbD6nhx32+0cGOIsh4QUVDdz3MKGB7QrPUXr
	 gko9z/8L2TQCVvu1bU5SO4dorVu76DoWnWsmQN81uTmt5wymNK7xEmSRE+BcTnLRPR
	 9AZeEQv816ZTzGNgPOQt9Jz4kmpJ9OkA5TMYyTQOQHBA5+IMUO2qCaTmZi+2KOTtmP
	 xLIhwiJkLsqcFrtC5sY1RqyB5LJPRfYzMzdITGpzzh4pSx378jDHTbKjyPmvjz89t1
	 AUjAAIb7XSmUg==
Date: Sun, 31 Dec 2023 14:56:30 -0800
Subject: [PATCH 3/6] xfs_scrub: use dynamic users when running as a systemd
 service
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Helle Vaanzinn <glitsj16@riseup.net>, Christoph Hellwig <hch@lst.de>,
 linux-xfs@vger.kernel.org
Message-ID: <170405002646.1801298.12765558589919362203.stgit@frogsfrogsfrogs>
In-Reply-To: <170405002602.1801298.14531646183046394491.stgit@frogsfrogsfrogs>
References: <170405002602.1801298.14531646183046394491.stgit@frogsfrogsfrogs>
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

Five years ago, systemd introduced the DynamicUser directive that
allocates a new unique user/group id, runs a service with those ids, and
deletes them after the service exits.  This is a good replacement for
User=nobody, since it eliminates the threat of nobody-services messing
with each other.

Make this transition ahead of all the other security tightenings that
will land in the next few patches, and add credits for the people who
suggested the change and reviewed it.

Link: https://0pointer.net/blog/dynamic-users-with-systemd.html
Suggested-by: Helle Vaanzinn <glitsj16@riseup.net>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub@.service.in |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/scrub/xfs_scrub@.service.in b/scrub/xfs_scrub@.service.in
index 7306e173ebe..504d3606985 100644
--- a/scrub/xfs_scrub@.service.in
+++ b/scrub/xfs_scrub@.service.in
@@ -17,7 +17,6 @@ ProtectHome=read-only
 PrivateTmp=no
 AmbientCapabilities=CAP_SYS_ADMIN CAP_FOWNER CAP_DAC_OVERRIDE CAP_DAC_READ_SEARCH CAP_SYS_RAWIO
 NoNewPrivileges=yes
-User=nobody
 Environment=SERVICE_MODE=1
 ExecStart=@sbindir@/xfs_scrub @scrub_args@ %f
 SyslogIdentifier=%N
@@ -31,3 +30,6 @@ Nice=19
 # Create the service underneath the scrub background service slice so that we
 # can control resource usage.
 Slice=system-xfs_scrub.slice
+
+# Dynamically create a user that isn't root
+DynamicUser=true

