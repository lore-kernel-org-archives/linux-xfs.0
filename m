Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B158830
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719883268; cv=none; b=cUdvkcNwvv0pAIpa4WmHTXMFEThSiTJazyYUL/pEN1cLxxp9gUeoQ9pX5HzeGztZqggjWjhRt7turyJZs63D339fL7aXrJp0/Uam8parqJLWE5kO6/d9VZQzFF9/Z0R7KeLuKg7QBjExkDY7nY70Q6dSMPDQyWBeuiPnmoL0akE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719883268; c=relaxed/simple;
	bh=+VixRE9pqsB5eW8ueESvKjr9fdo43XK2IoQ4eThEqo0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FTD9ilrE9lR1dWvUdSANvcfqWjxwtt7nR6rQBAzyuALbYhxwBXPbQHrW4yrJI6JH7t0jsquYn3cJFE/QymuMFeaVmuQOP4ABiuL7U5RNAx4IlzeB1mQTj9RJL4utl7ltb8EnJ7786aAMzRJFQydiS4PZKJcVmVQhLG1IDPj3JSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dZ0Ezn8P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dZ0Ezn8P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3114C116B1;
	Tue,  2 Jul 2024 01:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719883267;
	bh=+VixRE9pqsB5eW8ueESvKjr9fdo43XK2IoQ4eThEqo0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dZ0Ezn8Pzbt2++ZyWzZa1cWvsleduWFqlx6YMqFE6vy9sGgJk0gY7bhkK79gLZNaj
	 1wIWVsM+j4En3RM6A8OaQnCUXTOXAL86hzwsZKgb93EBP+TXpI409gESv9KFuAm+fV
	 b+Fowh2+1KnnHVJFL+nUYIKQBIWM9s0qAXiZnC5wg0MLFTyPGJ2kDtEAIN7bARAtMp
	 AbjG1gADYBieEnHbnhejk5iCEK3oW1cNTUDbuNrXE727Nb/WpE6zYQzMwYvU+9p0bg
	 1oeXOHC/GIxQhqMFiOP0dvqLFfBmSoez0N/xpJ+qgUtbyTvHrwBhrZTkdjyV+yOyhS
	 STQfDlGy8dM/A==
Date: Mon, 01 Jul 2024 18:21:07 -0700
Subject: [PATCH 2/5] xfs_spaceman: report directory tree corruption in the
 health information
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988122726.2012320.799724181764249157.stgit@frogsfrogsfrogs>
In-Reply-To: <171988122691.2012320.13207835630113271818.stgit@frogsfrogsfrogs>
References: <171988122691.2012320.13207835630113271818.stgit@frogsfrogsfrogs>
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

Report directories that are the source of corruption in the directory
tree.  While we're at it, add the documentation updates for the new
reporting flags and scrub type.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 man/man2/ioctl_xfs_bulkstat.2   |    3 +++
 man/man2/ioctl_xfs_fsbulkstat.2 |    3 +++
 spaceman/health.c               |    4 ++++
 3 files changed, 10 insertions(+)


diff --git a/man/man2/ioctl_xfs_bulkstat.2 b/man/man2/ioctl_xfs_bulkstat.2
index 3203ca0c5d27..b6d51aa43811 100644
--- a/man/man2/ioctl_xfs_bulkstat.2
+++ b/man/man2/ioctl_xfs_bulkstat.2
@@ -326,6 +326,9 @@ Symbolic link target.
 .TP
 .B XFS_BS_SICK_PARENT
 Parent pointers.
+.TP
+.B XFS_BS_SICK_DIRTREE
+Directory is the source of corruption in the directory tree.
 .RE
 .SH ERRORS
 Error codes can be one of, but are not limited to, the following:
diff --git a/man/man2/ioctl_xfs_fsbulkstat.2 b/man/man2/ioctl_xfs_fsbulkstat.2
index 3f059942a219..cd38d2fd6f26 100644
--- a/man/man2/ioctl_xfs_fsbulkstat.2
+++ b/man/man2/ioctl_xfs_fsbulkstat.2
@@ -239,6 +239,9 @@ Symbolic link target.
 .TP
 .B XFS_BS_SICK_PARENT
 Parent pointers.
+.TP
+.B XFS_BS_SICK_DIRTREE
+Directory is the source of corruption in the directory tree.
 .RE
 .SH RETURN VALUE
 On error, \-1 is returned, and
diff --git a/spaceman/health.c b/spaceman/health.c
index 6722babf5888..d88a7f6c6e53 100644
--- a/spaceman/health.c
+++ b/spaceman/health.c
@@ -165,6 +165,10 @@ static const struct flag_map inode_flags[] = {
 		.mask = XFS_BS_SICK_PARENT,
 		.descr = "parent pointers",
 	},
+	{
+		.mask = XFS_BS_SICK_DIRTREE,
+		.descr = "directory tree structure",
+	},
 	{0},
 };
 

