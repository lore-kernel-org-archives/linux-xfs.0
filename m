Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6727F9;
	Mon,  1 Jan 2024 01:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gSJr19cm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00D2C433C8;
	Mon,  1 Jan 2024 01:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070992;
	bh=NsIOAnrzdlE+bWwF2Rc+7zi1weKTWm0JBf8hj+ENiS4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gSJr19cmlat1JvkEdanqOu8A6oEy9KgwDYs3kaAtP6yK8BksYQowljBUGo4uSjylC
	 /7/S04yBbGKELmzztwk+1sL3ZguFRa7/pdjAz9xdmw+1evA31wKKsSiufXPqSzzCUJ
	 aNp2bntM2Ro1ZacgFR0YZDL5jUQplcEOt69VixenkEAi7/1vj6m69Bu2WQox1HX1/0
	 XiSVlFHfgVKGL6LyIyJ51xEgHJH/hbbto6YHoePmucV7cgLQQQawt7HL7b9WG3DO3v
	 +rMHxtghlitm04GOKK1vdxmvkAqIl3WQoNkxH2tGE0iW+/nKjyF/qCAoMTN/Xi7QG9
	 9dsSg4ShMvbbQ==
Date: Sun, 31 Dec 2023 17:03:12 +9900
Subject: [PATCH 7/9] xfs/856: add rtreflink upgrade to test matrix
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405032108.1827358.4212368779476095141.stgit@frogsfrogsfrogs>
In-Reply-To: <170405032011.1827358.11723561661069109569.stgit@frogsfrogsfrogs>
References: <170405032011.1827358.11723561661069109569.stgit@frogsfrogsfrogs>
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

Add realtime reflink to the features that this test will try to
upgrade.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/1856 |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/1856 b/tests/xfs/1856
index 8453d9bff2..4126c28e5d 100755
--- a/tests/xfs/1856
+++ b/tests/xfs/1856
@@ -205,12 +205,13 @@ post_exercise()
 # upgrade don't spread failure to the rest of the tests.
 FEATURES=()
 if rt_configured; then
-	# rmap wasn't added to rt devices until after metadir and rtgroups
+	# reflink & rmap weren't added to rt devices until after metadir and rtgroups
 	check_repair_upgrade finobt && FEATURES+=("finobt")
 	check_repair_upgrade inobtcount && FEATURES+=("inobtcount")
 	check_repair_upgrade bigtime && FEATURES+=("bigtime")
 	check_repair_upgrade metadir && FEATURES+=("metadir")
 	supports_rtgroups && check_repair_upgrade rmapbt && FEATURES+=("rmapbt")
+	supports_rtgroups && check_repair_upgrade reflink && FEATURES+=("reflink")
 else
 	check_repair_upgrade finobt && FEATURES+=("finobt")
 	check_repair_upgrade rmapbt && FEATURES+=("rmapbt")

