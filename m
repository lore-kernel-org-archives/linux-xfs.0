Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D42ABA45
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G+kzWlrb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E26C433C7;
	Sun, 31 Dec 2023 22:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062390;
	bh=vei+qV6JcPrizFGOVqw2QfZzFxT4QPGzKKNq9mown1Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=G+kzWlrbZkkU6tbq5EyQ2vJ6IQ/Fb7EITO62BDTNRrOPEkiXR2FSyskHM+8hQMTWs
	 H+rJriXbNtQWfuy8ZQl5M7WNyRBs969wvYho02UuD4ZfOekqLEnKf0i1OFOMTKc5+s
	 VJqUndCI5RMNujWzD1U0/2avhpvy/FKPLW4ibn9nkp94cuHVErfjCSEunyWOjgHNLR
	 pPitYQaugEbn27ScoYF8xPnPmCS8As2nSNy3gTDRp9omRfvo/WfA/wnRs+L8EIRcOi
	 /+/DfGNpcR3rzPd5FB3B2951zFPHBPFu99XoP4hqVTzvlKO6oZreDG4yw1XM+5Kt2y
	 qHd0K10Va4Usg==
Date: Sun, 31 Dec 2023 14:39:50 -0800
Subject: [PATCH 6/8] xfs_scrub: any inconsistency in metadata should trigger
 difficulty warnings
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404999114.1797544.6397356360236587838.stgit@frogsfrogsfrogs>
In-Reply-To: <170404999029.1797544.5974682335470417611.stgit@frogsfrogsfrogs>
References: <170404999029.1797544.5974682335470417611.stgit@frogsfrogsfrogs>
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

Any inconsistency in the space metadata can be a sign that repairs will
be difficult, so set off the warning if there were cross referencing
problems too.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/repair.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/scrub/repair.c b/scrub/repair.c
index 33a8031103c..30817d268d6 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -319,7 +319,9 @@ action_list_difficulty(
 	unsigned int			ret = 0;
 
 	list_for_each_entry_safe(aitem, n, &alist->list, list) {
-		if (!(aitem->flags & XFS_SCRUB_OFLAG_CORRUPT))
+		if (!(aitem->flags & (XFS_SCRUB_OFLAG_CORRUPT |
+				      XFS_SCRUB_OFLAG_XCORRUPT |
+				      XFS_SCRUB_OFLAG_XFAIL)))
 			continue;
 
 		switch (aitem->type) {

