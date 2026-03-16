Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9BD146D5A;
	Mon, 16 Mar 2026 23:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773703776; cv=none; b=IO1n7MH8QdIXoB7O9XCsr1ZAW7k7j217VlE46+bs91XgNltwA0dR7EMqxSTYam9SC50YO0bM6gd2xLf62hU4t42Gy1W6OaHg82mW0mG9WMf51+ZSpVcJ6JvKVy0TalE6O9VNNn3t3/XUpZb78qWzfe5032mcQDM6D0z/tVr2CS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773703776; c=relaxed/simple;
	bh=Stn/Zq2j6RZ8PpxwgBoL+fzFgZZy/WllIJ5y6a9fNlQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p9OtuzDsYixJE2xPT4LKsvBLTcoXAD7zRLEOn9hMN9g+kgtj3vPrNUh3iOxfRZ28fhpe/BEBwNRkO6ce/WeZwZ+wNIMqEbDSCnmbYV6HFBd942cO6vX/4h3b4z/c1n9Jmzezvv/SjLNEwxGdkd24spc/imM7MpPUWouZ0rhjr7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AtwVQNAe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AtwVQNAe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBECDC19421;
	Mon, 16 Mar 2026 23:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773703775;
	bh=Stn/Zq2j6RZ8PpxwgBoL+fzFgZZy/WllIJ5y6a9fNlQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AtwVQNAe+j9dQgMxEBJ+YgeSC1tUzud9stUY5h9UIwWEvHdb0PYBihsM07Yv8e3u5
	 fc75R9+MaoKpvw8L4iKv9njgktDOKojMhHA0iJ2TODiOCs/VPQ5sx43QP7lOOAAf76
	 pc6ZQjYBJpUzbXQ5q7eAD/mY+ku9wamDbbM30xH8kL5QX+wd+GUkfCOHrO1U/Eq+FG
	 OaTBXyQl9b6Kk631XPWHzk9jZa65XCmuZBDG4bjPML+hJYNgbrV1OO/QjcpzK4LWXs
	 ummrk2hmhvi+OkboJ4ksm194CcV/z/s+39vmoiIgQsA3i3IrY/voGn0+9ui2LU95Gj
	 QN++g2K/NakzA==
Date: Mon, 16 Mar 2026 16:29:35 -0700
Subject: [PATCH 3/3] xfs/805: adjust for new autofsck fsproperty defaults
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <177370372722.2108664.4085087401055083414.stgit@frogsfrogsfrogs>
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

Now that mkfs will set autofsck=repair for filesystems that have both
reverse space mappings and file parent pointers enabled, let's stop
testing the "no autofsck option at all" scenario to avoid problems with
older mkfs.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/805     |    7 +------
 tests/xfs/805.out |    1 -
 2 files changed, 1 insertion(+), 7 deletions(-)


diff --git a/tests/xfs/805 b/tests/xfs/805
index ae8f8a1ab7cf44..cb57561a1bafd7 100755
--- a/tests/xfs/805
+++ b/tests/xfs/805
@@ -37,13 +37,9 @@ filter_inum()
 }
 
 testme() {
-	local mkfs_args=('-f')
 	local value="$1"
 	test -n "$value" && value="=$value"
-
-	if [ $# -gt 0 ]; then
-		mkfs_args+=('-m' "autofsck$value")
-	fi
+	local mkfs_args=('-f' '-m' "autofsck$value")
 
 	echo "testing ${mkfs_args[*]}" >> $seqres.full
 
@@ -54,7 +50,6 @@ testme() {
 }
 
 testme ''
-testme
 testme none
 testme check
 testme optimize
diff --git a/tests/xfs/805.out b/tests/xfs/805.out
index 3d22f1b208e3e9..6224d70c4b1d7e 100644
--- a/tests/xfs/805.out
+++ b/tests/xfs/805.out
@@ -1,6 +1,5 @@
 QA output created by 805
 autofsck=repair
-failed to get attr xfs:autofsck on inode XXX: No data available
 autofsck=none
 autofsck=check
 autofsck=optimize

