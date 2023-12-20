Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5C04778C
	for <linux-xfs@vger.kernel.org>; Wed, 20 Dec 2023 17:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q1hYnDyt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01925C433C7;
	Wed, 20 Dec 2023 17:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703092380;
	bh=tFjEws6hWw+GCEo4t7CVPfkBb0K0+hQN6f8PBjx75jU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Q1hYnDyty3vr6lWplw7BIzuo6xKJiFtb3yjX6Ruk6jb9X7soMf7S/dBQJLxAhSjqu
	 lP3hFixizzrSITywzbXyEj1uC3Nyz31KwNXwlqmHoLkpkoIjcehsBxvhUnYXQeNRyP
	 ABLvjNfzAGTd+b//Sp5XklaXtm2r+MkDqj4KtnWQMTeLyvxfJnn2BkAzAqjyqDTzM6
	 M3u+J24sADkhUAArJBgAvVrAXtUTLN3F2fhg849OgeCFxXVLrLwMuSRJxUDPjWxf3T
	 VaLHG5ho/B4fU03Gz8TL+O0Ohs0B28K86nkYzdiv3KKOyFGYqVMWHrwJLmrEmODf5k
	 yaH/4GpdHMp3A==
Date: Wed, 20 Dec 2023 09:12:59 -0800
Subject: [PATCH 1/6] xfs_metadump.8: update for external log device options
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <170309218731.1607943.10604489832510609658.stgit@frogsfrogsfrogs>
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

Update the documentation to reflect that we can metadump external log
device contents.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chandan Babu R <chandanbabu@kernel.org>
---
 man/man8/xfs_mdrestore.8 |    6 +++++-
 man/man8/xfs_metadump.8  |    7 +++++--
 2 files changed, 10 insertions(+), 3 deletions(-)


diff --git a/man/man8/xfs_mdrestore.8 b/man/man8/xfs_mdrestore.8
index 6e7457c0..f60e7b56 100644
--- a/man/man8/xfs_mdrestore.8
+++ b/man/man8/xfs_mdrestore.8
@@ -14,6 +14,10 @@ xfs_mdrestore \- restores an XFS metadump image to a filesystem image
 .br
 .B xfs_mdrestore
 .B \-i
+[
+.B \-l
+.I logdev
+]
 .I source
 .br
 .B xfs_mdrestore \-V
@@ -52,7 +56,7 @@ Shows metadump information on stdout.  If no
 is specified, exits after displaying information.  Older metadumps man not
 include any descriptive information.
 .TP
-.B \-l " logdev"
+.BI \-l " logdev"
 Metadump in v2 format can contain metadata dumped from an external log.
 In such a scenario, the user has to provide a device to which the log device
 contents from the metadump file are copied.
diff --git a/man/man8/xfs_metadump.8 b/man/man8/xfs_metadump.8
index 1732012c..496b5926 100644
--- a/man/man8/xfs_metadump.8
+++ b/man/man8/xfs_metadump.8
@@ -132,8 +132,11 @@ is stdout.
 .TP
 .BI \-l " logdev"
 For filesystems which use an external log, this specifies the device where the
-external log resides. The external log is not copied, only internal logs are
-copied.
+external log resides.
+If the v2 metadump format is selected, the contents of the external log will be
+copied to the metadump.
+The v2 metadump format will be selected automatically if this option is
+specified.
 .TP
 .B \-m
 Set the maximum size of an allowed metadata extent.  Extremely large metadata

