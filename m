Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65F6378D9A;
	Tue, 15 Sep 2026 05:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789450720; cv=none; b=aJxp9hFSRYjmO1ubmf+qIQh+dGk1en6ZCTkWCpFBnYjLH8+P1c3+igvArnYJgoU4XWPR7b4kFkMdu1fZ7LlwRY/LB6PslRR1Ck2bQXZXvu/uB3y/kQgY1bwWAFpuUk/xWqicjRkuGBBsSAhH5INgiNyEKODy6gSeK+1WR8fIkKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789450720; c=relaxed/simple;
	bh=giqgBnGzHZ5SeonDmd+wnwBNqkGqo7xW8bNnhXWvffQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sc9wtMXYBqvkPqdC5/rNDclKvRYQr5egMzRE+Ogw6tu3mH3KEKlX702c0Ncee2ZLeqKHJiYcF7HO0YI6uvAJCxev7CK37IsU/O88mufXzlhveh64+7eMlPO8JQi8+nsN8k/wKD0IMpHX93nOtUgNalR1cHaASbfHGDX0MZU0oOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f0hVjUo/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f0hVjUo/"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4DFFE1F000FF;
	Tue, 15 Sep 2026 05:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789450719;
	bh=O6mhLfKqMpzzHRGdNydZEVXMprYKwrRuiq+CtWTiQ44=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=f0hVjUo/e/4J0fgzJ4IeAABI5Cw6g0haEse5XW3os7jps9bnrAbZwMpVLc7dw8KHo
	 to0koDcAGkCOo0vvbtl86YFfZd3gvRM3c+vIrzFen5xsWzXvXJ9JhvJjIfIdlfmUyE
	 qn+AHllha8AtQ7Wl7VSdINwXvIR87bbttRI01fSykTYut4cH1pVmpvoY2dNVgQc7/I
	 H7LNd1i97f4PZZw6Nb3fTV2Jdmn0V2PwKQsSpHfGw9pXLHM0BSyYqtOr0XK0MQo0PO
	 d2HUMEQIUCFmOPWye2jyJZGAMIRLiYc3FwJhh2G0ef88a/ZZZp+2pRzaCAj7K0J5O1
	 MpERgBptmXeOQ==
Date: Mon, 14 Sep 2026 22:38:38 -0700
Subject: [PATCH 08/11] xfs: fix cursor and pointer handling when recovering
 iunlink buckets
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178945048669.3061055.10490235412243530399.stgit@frogsfrogsfrogs>
In-Reply-To: <178945048435.3061055.16384804993810925544.stgit@frogsfrogsfrogs>
References: <178945048435.3061055.16384804993810925544.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM pointed out a bug in xlog_recover_iunlink_bucket:

1. We don't null out prev_ip after releasing it, which can lead to UAF
   problems if the inodegc flush call in the loop fails.

at which point I noticed even more bugs:

2. If the inodegc flush inside the loop fails, we also leak @ip.

3. We set prev_agino to agino having already advanced agino, which
   results in inodes with i_prev_unlinked set to itself.

4. If we exit the bottom of the loop with prev_ip set, then prev_ip
   aliases ip and we also set its i_prev_unlinked to itself.

Bugs 3 and 4 introduce loops into the unlinked list, though these loops
don't surface because we immediately flush each unlinked inode after
loading it.

Fix all of these issues.

Cc: <stable@vger.kernel.org> # v6.0
Fixes: 04755d2e5821b3 ("xfs: refactor xlog_recover_process_iunlinks()")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/xfs_log_recover.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index e7e49529658be3..cf0d610265fe76 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2736,12 +2736,13 @@ xlog_recover_iunlink_bucket(
 {
 	struct xfs_mount	*mp = pag_mount(pag);
 	struct xfs_inode	*prev_ip = NULL;
-	struct xfs_inode	*ip;
 	xfs_agino_t		prev_agino, agino;
 	int			error = 0;
 
 	agino = be32_to_cpu(agi->agi_unlinked[bucket]);
 	while (agino != NULLAGINO) {
+		struct xfs_inode	*ip;
+
 		error = xfs_iget(mp, NULL, xfs_agino_to_ino(pag, agino), 0, 0,
 				&ip);
 		if (error)
@@ -2750,11 +2751,11 @@ xlog_recover_iunlink_bucket(
 		ASSERT(VFS_I(ip)->i_nlink == 0);
 		ASSERT(VFS_I(ip)->i_mode != 0);
 		xfs_iflags_clear(ip, XFS_IRECOVERY);
-		agino = ip->i_next_unlinked;
 
 		if (prev_ip) {
 			ip->i_prev_unlinked = prev_agino;
 			xfs_irele(prev_ip);
+			prev_ip = NULL;
 
 			/*
 			 * Ensure the inode is removed from the unlinked list
@@ -2766,18 +2767,20 @@ xlog_recover_iunlink_bucket(
 			 * complete.
 			 */
 			error = xfs_inodegc_flush(mp);
-			if (error)
-				break;
+			if (error) {
+				xfs_irele(ip);
+				return error;
+			}
 		}
 
 		prev_agino = agino;
+		agino = ip->i_next_unlinked;
 		prev_ip = ip;
 	}
 
 	if (prev_ip) {
 		int	error2;
 
-		ip->i_prev_unlinked = prev_agino;
 		xfs_irele(prev_ip);
 
 		error2 = xfs_inodegc_flush(mp);

