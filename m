Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C631B0425;
	Tue, 31 Dec 2024 23:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735689551; cv=none; b=R6Zyb235lH91lRWILgkE5kqTVKkR/ixItuBPQO7IXPOzCY8aXNyN1Q+GQmxVniTbMgPe8R4lxFn2diuJVvqn03JoHAoLma1MycO57B4cDERRiiHdeqzAQ6+QGxZ73sphieYjrbSPtigaEnQJ9ZnJLvhQiMUgAT8K4vkNq1l+sv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735689551; c=relaxed/simple;
	bh=iSScAvNdHqMUTwgPTPaGeVKe6/XwKCggP3xoifBhOmk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gMXX+ktLZGehKCWRv/xRcxU/tRKXk1jJreAZjckwN8AX2jXg+BAa61nsqPrVARXfZ1uPJ6y6Z/cb9nNLiK48vVGE9j0oe2gczQe5m4ZX9raz6OJgJauB6mOMAmEunUoV7zDJw1Y5Z87DX/76w02zht4NcpzJ/RsKJnNp2AB7zAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eaDXkzGx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eaDXkzGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41160C4CED2;
	Tue, 31 Dec 2024 23:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735689551;
	bh=iSScAvNdHqMUTwgPTPaGeVKe6/XwKCggP3xoifBhOmk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eaDXkzGxYUaLJe7UIucIUt7pu8YzIGaqsUwyaliYcDxDFn7pjIv9kEmk1WoGGe0xN
	 Z1BPjJmJuObCbMKUOyd5stgUZiv7vsfVBz+k4GQkyFBp795l1qBuieAL23iNKUDp2K
	 xvRty3Na/jKOzQRVEj07nse24yoBZf9uifm6h9+ydXwC+AnjuRryhYbWOxb/IajceN
	 uAG23W8McEtxXbQdR1Y7glk4nPYAwnNoj1V+ABdV/KN6lRdxLsnw9WsNjYJRbNrREa
	 YEFGe6q/NZ7QkSfUgW4IJKJrsATp0sWhveXPfiO53TVzNspDbon3Sl3tUrDf68b2n4
	 IjiityCN/mxnw==
Date: Tue, 31 Dec 2024 15:59:10 -0800
Subject: [PATCH 3/3] xfs/1856: add rtreflink upgrade to test matrix
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173568783594.2712510.7403029231349064861.stgit@frogsfrogsfrogs>
In-Reply-To: <173568783548.2712510.6440569474290843546.stgit@frogsfrogsfrogs>
References: <173568783548.2712510.6440569474290843546.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add realtime reflink to the features that this test will try to
upgrade.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/1856 |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/1856 b/tests/xfs/1856
index 8e3213da752348..9b776493f0486f 100755
--- a/tests/xfs/1856
+++ b/tests/xfs/1856
@@ -215,11 +215,12 @@ MKFS_OPTIONS="$(qerase_mkfs_options)"
 # upgrade don't spread failure to the rest of the tests.
 FEATURES=()
 if rt_configured; then
-	# rmap wasn't added to rt devices until after metadir
+	# rmap & reflink weren't added to rt devices until after metadir
 	check_repair_upgrade finobt && FEATURES+=("finobt")
 	check_repair_upgrade inobtcount && FEATURES+=("inobtcount")
 	check_repair_upgrade bigtime && FEATURES+=("bigtime")
 	supports_metadir && check_repair_upgrade rmapbt && FEATURES+=("rmapbt")
+	supports_metadir && check_repair_upgrade reflink && FEATURES+=("reflink")
 else
 	check_repair_upgrade finobt && FEATURES+=("finobt")
 	check_repair_upgrade rmapbt && FEATURES+=("rmapbt")

