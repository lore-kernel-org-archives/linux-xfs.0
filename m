Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D955C147
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h87wRCk7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43BD0C433C8;
	Sun, 31 Dec 2023 22:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063250;
	bh=6v0ycd1HXesL1JaU4nwmBJrbzYmRgjWRJm5ZakbR1KE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=h87wRCk7imsiRDO7FZYMVrHuYny75Pk2jR/R/xh80oc5Daao7tW5zJ2PcaQvLIzTs
	 9LFgu/jxbQvmROyzWxF9HndXw3SvbWf/wKd8p5UfD8F15iYdv8n7bALPDewuYaau3p
	 86BytIOADhiDt5LFWsViyWM6oXl+8dALwc/TLvuXdYUX6mJPRzbWxNBLE2babWKHCo
	 8k8Eg4Wp7yWtGPdzRul5SYkIqX4XIzLqwZQ3xqq3hfv/BA9/ScQdF9lQ4Pqo063QLx
	 JGxOUuknWUAKc+cAqcDMMBJwwrLjcuPxzx9iOTdhcPAyGO4WBjisjVyfgWmboMI+H+
	 99KD1mr5E9yCw==
Date: Sun, 31 Dec 2023 14:54:09 -0800
Subject: [PATCH 7/9] xfs_scrub_fail: advise recipients not to reply
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405001937.1800712.9925405322044646768.stgit@frogsfrogsfrogs>
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

Advise recipients of the service failure emails that they should not try
to reply to the automated service message.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub_fail.in |    1 +
 1 file changed, 1 insertion(+)


diff --git a/scrub/xfs_scrub_fail.in b/scrub/xfs_scrub_fail.in
index baa9d32d94c..5dffb541798 100755
--- a/scrub/xfs_scrub_fail.in
+++ b/scrub/xfs_scrub_fail.in
@@ -31,6 +31,7 @@ Content-Transfer-Encoding: 8bit
 Content-Type: text/plain; charset=UTF-8
 
 So sorry, the automatic xfs_scrub of ${mntpoint} on ${hostname} failed.
+Please do not reply to this mesage.
 
 A log of what happened follows:
 ENDL

