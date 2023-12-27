Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A888BA37;
	Mon,  1 Jan 2024 00:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EDmdx5Rq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCFC1C433C8;
	Mon,  1 Jan 2024 00:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069959;
	bh=mdB+Uxa2e5yhzeSNhXfCPFMBacoKHyU4oNLy7VBB0yM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EDmdx5RqWqTI5wVeQUJGzeGO2P7dOfgRfYEJwemGu8wcdSG3y62NlCSjTFMWbAMrV
	 N071ql2Zyu3D1rd0uiMbMOlNWWzB1Nb0gGitJqIkPBSvDtGDJDWxP7+EqHI7U6pHef
	 DkIVLHnu6frO00LAb5/a1lQ4lLYyKmJiKWzadKoLJGNKDEomyWr1ftWu7wDIOzorhM
	 3NvkG+yKuR+zaQrB49R7GbZUAowHTpmLWG6+cIf2Y1pwKN6l/LRlvZe05R4rlouHUZ
	 OIkWTwbRgTJ7Mnwds8+HhizYKJyGhWiBG7K/W7q4qA7ZxS2SLItBR8Ivr+lovRRHgp
	 qShcczdfXXgIw==
Date: Sun, 31 Dec 2023 16:45:59 +9900
Subject: [PATCH 1/1] xfs/004: fix column extraction code
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, guan@eryu.me
Message-ID: <170405027527.1824048.12601330137480691520.stgit@frogsfrogsfrogs>
In-Reply-To: <170405027514.1824048.6297780130013618126.stgit@frogsfrogsfrogs>
References: <170405027514.1824048.6297780130013618126.stgit@frogsfrogsfrogs>
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

Now that the xfs_db freesp command prints a CDF of the free space
histograms, fix the pct column extraction code to handle the two
new columns by <cough> using awk.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/004 |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)


diff --git a/tests/xfs/004 b/tests/xfs/004
index f18316b333..2d55d18801 100755
--- a/tests/xfs/004
+++ b/tests/xfs/004
@@ -84,14 +84,17 @@ then
 fi
 
 # check the 'pct' field from freesp command is good
-perl -ne '
-	    BEGIN	{ $percent = 0; }
-	    /free/	&& next;	# skip over free extent size number
-	    if (/\s+(\d+\.\d+)$/) {
-		$percent += $1;
-	    }
-	    END	{ $percent += 0.5; print int($percent), "\n" }	# round up
-' <$tmp.xfs_db >$tmp.ans
+awk '
+{
+	if ($0 ~ /free/) {
+		next;
+	}
+
+	percent += $5;
+}
+END {
+	printf("%d\n", int(percent + 0.5));
+}' < $tmp.xfs_db > $tmp.ans
 ans="`cat $tmp.ans`"
 echo "Checking percent column yields 100: $ans"
 if [ "$ans" != 100 ]

