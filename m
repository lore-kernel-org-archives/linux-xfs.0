Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54683C14C
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jr75AeAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28602C433C7;
	Sun, 31 Dec 2023 22:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063469;
	bh=A7A6K/bWy6ztg0hX9qBn9q9a03hbUDOQBge6R5AOGHc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jr75AeAg4KT5v2eZ6b5anYbCQU4voEPdR52oNXzYELzn60CeRVF0qgDqXE2Ws0kPv
	 UrJC/sprztwziOZqLG+QU4rdQiF5o/kXof6IZtOFqgiQYav0iCzztoJXpsk8GUGNLC
	 wftGF3GqIyQ4POxKCGEDwHnlWZGlJ+kdInXdgDRsH9WAgmMGIQio+Jw7mRcQSLGT90
	 yoOPMTdIo22ZvvezioeYfl3VYga9PIt7GFoipxu7Qc7QnzYFXlDG4p061fABi4XLNx
	 H+MQ9aBhaJ1TCk3siYm+0NDZTS2B3gjw+Oo2T+6TbxIHYJrTBJVsG+4bkJ+jW9Jjwh
	 bL9TglYdoJskQ==
Date: Sun, 31 Dec 2023 14:57:48 -0800
Subject: [PATCH 2/6] xfs_scrub_all: remove journalctl background process
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405003007.1801496.11295356371270620868.stgit@frogsfrogsfrogs>
In-Reply-To: <170405002977.1801496.15279364480135878968.stgit@frogsfrogsfrogs>
References: <170405002977.1801496.15279364480135878968.stgit@frogsfrogsfrogs>
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

Now that we only start systemd services if we're running in service
mode, there's no need for the background journalctl process that only
ran if we had started systemd services in non-service mode.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub_all.in |   14 --------------
 1 file changed, 14 deletions(-)


diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index f27251fa543..fc7a2e637ef 100644
--- a/scrub/xfs_scrub_all.in
+++ b/scrub/xfs_scrub_all.in
@@ -261,17 +261,6 @@ def main():
 
 	fs = find_mounts()
 
-	# Tail the journal if we ourselves aren't a service...
-	journalthread = None
-	if 'SERVICE_MODE' not in os.environ:
-		try:
-			cmd=['journalctl', '--no-pager', '-q', '-S', 'now', \
-					'-f', '-u', 'xfs_scrub@*', '-o', \
-					'cat']
-			journalthread = subprocess.Popen(cmd)
-		except:
-			pass
-
 	# Schedule scrub jobs...
 	running_devs = set()
 	killfuncs = set()
@@ -308,9 +297,6 @@ def main():
 	while len(killfuncs) > 0:
 		wait_for_termination(cond, killfuncs)
 
-	if journalthread is not None:
-		journalthread.terminate()
-
 	# See the service mode comments in xfs_scrub.c for why we do this.
 	if 'SERVICE_MODE' in os.environ:
 		time.sleep(2)

