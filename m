Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608BB3AFCE6;
	Mon, 12 Oct 2026 05:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791784686; cv=none; b=auimUKR5DoYEhm5SltjBWltWvM7HvG+lH5bHhCoDt1crrKE2EPutaC+OyNsaqaeZBFACkyXeugns59kvY+DOPwoaJ8bwVF2jnYYYeLPb5x3QlqhtMLxT8yqHEEUhXN7LL+QO9NAsPuqPfdOMzmNwvXBI/rGZyZSrXJVf6OPLL5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791784686; c=relaxed/simple;
	bh=8KMMNSDFzS626+f8lX9vaEgMFhLSkdhqb4ChBbJIjqE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hswSoB/W5OUtKnpj8MK9qRdZRONww/Fgxp/ya4sN9REDf7bUCruRlUwR6pqOi/jf24LNS2rg+5FbwF7wvQQ21YepQ5kOQRH9uu4EcOpkVfOhbVlQq2wiRXxWMHkNR66Px2gLqydPti7xCHKxR2hfrWyLnRRRykWhZf6xPY0a38w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PbM6M+os; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PbM6M+os"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 288141F0089B;
	Mon, 12 Oct 2026 05:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791784685;
	bh=2C/DBpnq4Jn2D9xHhN6MiL/ZmhQ8Opq5HbD3EeO2AR8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=PbM6M+osHUHLAjNleucv4rth0+q64RMoNFLag7hTRbpgseaVfqJ/idjReIWsVF0Ch
	 my85YYTUtKwvw/qqoHAtYOwrnQQHQOarpiY1iXnWe/X4d6bhouCxNDSawl3W4IkUgI
	 rQOiGp/8ksNvYJnHZ9ckYdcuX728BgY7UFoDTVTOpLzaYZYodwPbdjRpsQj38kLm6Q
	 ePKoKl+edzftqHpet7nqYehj/3vmIyHcD8SR0VR0KqVuRSn7EydevUB3dian5TT65s
	 LU5UNbIyn5OYeaz559vkZMnUYYkkEK4CDB/VNnXuVJypFA57ODiemkH1H9Z5yPXErX
	 XFWWkxHbxJsyw==
Date: Sun, 11 Oct 2026 22:58:04 -0700
Subject: [PATCH 09/12] xfs: clear set[ug]id mode bits when zapping attr fork
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179178065389.1058326.15301245615537747127.stgit@frogsfrogsfrogs>
In-Reply-To: <179178065114.1058326.9639488899319330972.stgit@frogsfrogsfrogs>
References: <179178065114.1058326.9639488899319330972.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM observes that zapping a file's attr fork could result in ACLs
being removed from the file.  Because we have no idea what we're
deleting, we should clear the setuid and setgid bits in addition to the
access mode bits so that nobody can access the file.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: e744cef2060559 ("xfs: zap broken inode forks")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/inode_repair.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 4b719ad64ace8c..25e71e7d472f36 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1313,7 +1313,12 @@ xrep_dinode_zap_afork(
 	 */
 	if (dip->di_format != XFS_DINODE_FMT_BTREE)
 		dip->di_forkoff = 0;
-	dip->di_mode = cpu_to_be16(mode & ~0777);
+
+	/*
+	 * Zapping the attr fork could remove ACLs, so we clear suid/sgid and
+	 * all access mode bits.
+	 */
+	dip->di_mode = cpu_to_be16(mode & ~(S_ISUID | S_ISGID | 0777));
 	dip->di_uid = 0;
 	dip->di_gid = 0;
 }

