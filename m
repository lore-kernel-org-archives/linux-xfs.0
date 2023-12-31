Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0357C127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bbSTdDWL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F545C433C8;
	Sun, 31 Dec 2023 22:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063234;
	bh=b+0C0e5XmYv1OCQ+CwwSoggYs1V3mFnPe6XJ5h5E7oY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bbSTdDWLy0n1jOU9+2wCDw8EFoNWvz0pNMPdLosq6ARx1ApxrekUtGrHsbkcM02id
	 dKtcK4/sGJlbmiiY+AxJT6tvBUZZrqTHPt55DdiLxUPpE3GwG4XnBqgLJOy/v/JcCT
	 NBW8TiNgQsJukRT3A0+pGVQQVcVMiyPifTBLsPc3vaCSQ3XOxDOZtFyj8mPcKu1KQw
	 UOUNeRBZkEJjD4REMf4F16vV+CCfkGlKKDt1WIuYg1Q7TbvLQQQWmWRY+q3eP2Vx7J
	 saU3x1whlc2HwljbSQIYASa2R68NI3xPcqcBp2HdTIAVtAGHla5AaS1sfwBXaFIjXq
	 xKwco9EL1+CFg==
Date: Sun, 31 Dec 2023 14:53:54 -0800
Subject: [PATCH 6/9] xfs_scrub_fail: add content type header to failure emails
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405001924.1800712.10812613070481678255.stgit@frogsfrogsfrogs>
In-Reply-To: <170405001841.1800712.6745668619742020884.stgit@frogsfrogsfrogs>
References: <170405001841.1800712.6745668619742020884.stgit@frogsfrogsfrogs>
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

Add content type and encoding metadata so that these emails display
correctly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub_fail.in |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/scrub/xfs_scrub_fail.in b/scrub/xfs_scrub_fail.in
index d3275f9897c..baa9d32d94c 100755
--- a/scrub/xfs_scrub_fail.in
+++ b/scrub/xfs_scrub_fail.in
@@ -27,6 +27,8 @@ scrub_svc="$(systemd-escape --template "@scrub_svcname@" --path "${mntpoint}")"
 To: $1
 From: <xfs_scrub@${hostname}>
 Subject: xfs_scrub failure on ${mntpoint}
+Content-Transfer-Encoding: 8bit
+Content-Type: text/plain; charset=UTF-8
 
 So sorry, the automatic xfs_scrub of ${mntpoint} on ${hostname} failed.
 

