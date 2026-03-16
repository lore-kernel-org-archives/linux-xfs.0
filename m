Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A7C379980;
	Mon, 16 Mar 2026 23:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773703744; cv=none; b=iYZs092B4MzdhQlMRQ37jl0qLWHLwEt7UIoluMr1bQMqnwkBw23NNe9Wux0ZxAmo2103Q3jW5HESP7pzsF542GsfbAyg47dLKxavMkfwoPgph+nly2+0tB2FmQS2PG7pjp8tHGXFcWPAvRRKEQlMI0oF2vyXwQPEQUl58Q620og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773703744; c=relaxed/simple;
	bh=ARgyHQxWQrqreln6LIuA3zis9wGJQ9i/kuXEKSFKKAo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=szsmLyJNudat0LOt9FFXDUFBnpogMqZ6lksD+Rpm9RyKY5yV7joqmaDm/c21sGYXiKvtBKf7/or5HFUWe77r/hy4+T+CibPn+IovMc7k7aZf3oB7/ZCWhx7l+UWwb8GR/+MrJ2UzilLGrOMGukzwixFmBKwpO47AiA0smwhLQQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MAM2ef1+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MAM2ef1+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F67C19421;
	Mon, 16 Mar 2026 23:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773703744;
	bh=ARgyHQxWQrqreln6LIuA3zis9wGJQ9i/kuXEKSFKKAo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MAM2ef1+yPonO8yqxo0TSmpkwUlsDWOLaVjzKtauTqHeQsY9ijJ8Jk1t/X440WqWO
	 jdgV7MN9llaYwN4JsN2m8a8pQk6JI4bitAQFtrX8z3urSJmchb/Qw+ySl3LVmNZF4b
	 JWlenbtIAJkvmvDnUeaCa9JZgMQell8qii0upIbBIcy8Usdb3S28vqq8cjs0qtvwwY
	 Tck6oexsjTqz/Ai7TbUpQHeqY890rqYVOkdMk9aCuwjHGodtRH3hezPQ10au7BAqVR
	 rQPdz+w4dZWvn8JtMLQbgwRf48+inK90WY1q8cWtV1HDCQ6sUYLhb+DOL6i/DV1TcA
	 ydES9qL/FX9eg==
Date: Mon, 16 Mar 2026 16:29:03 -0700
Subject: [PATCH 1/3] common: ignore stderr for the two new svcname helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <177370372686.2108664.121048853724965231.stgit@frogsfrogsfrogs>
In-Reply-To: <177370372656.2108664.15986990094116651469.stgit@frogsfrogsfrogs>
References: <177370372656.2108664.15986990094116651469.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If either utility doesn't support the --svcname switch, ignore the
error output and just return an empty string.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/xfs |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/common/xfs b/common/xfs
index f276325df8fbac..7d7afbb5160951 100644
--- a/common/xfs
+++ b/common/xfs
@@ -2311,7 +2311,7 @@ _xfs_healer() {
 # This is easy because xfs_healer has always supported --svcname.
 _xfs_healer_svcname()
 {
-	_xfs_healer --svcname "$@"
+	_xfs_healer --svcname "$@" 2>/dev/null
 }
 
 # Compute the xfs_scrub systemd service instance name for a given path.  This
@@ -2320,7 +2320,7 @@ _xfs_scrub_svcname()
 {
 	local ret
 
-	if ret="$($XFS_SCRUB_PROG --svcname "$@")"; then
+	if ret="$($XFS_SCRUB_PROG --svcname "$@" 2>/dev/null)"; then
 		echo "$ret"
 		return 0
 	fi

