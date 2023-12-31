Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73CD2C127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ppe+RdEW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41AE9C433C8;
	Sun, 31 Dec 2023 22:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063297;
	bh=XATPJKcf5uevdtzySLIyWQlXhBsV3vZjT89AHaEmWfg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ppe+RdEW8Sm8PTmdN+iF7MKCZmEjWq6OkNis6MLCoM2Fc+RwFgY9XDtI4hBD6RSE4
	 x5r2IBqMqkr9PO7BRqWuNEf5qF9Dz0t0wn+dhcYbXEg6NeYo9oDKJKecNGCN5MkezO
	 LutA41/qxWcWgAd0UhgurqJb3dpNnoi0J3Z+YtFXWKDRaipBFc4fUZ1AN3vjLQKBAo
	 u6GtCci+T0VUL74NLpM35fiUF4DrL2dvvDAX4H5VFF9dX0i1LKAojY23C3U3JcxO5Y
	 T8ruLgEvf1S/gkMmhirqRiF7L6p76QYnwokkLcUE6DT+yE/V9s6deSpET8w9uxwvFq
	 h+vPB6h+ofnCg==
Date: Sun, 31 Dec 2023 14:54:56 -0800
Subject: [PATCH 1/4] xfs_scrub_all: fix argument passing when invoking
 xfs_scrub manually
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170405002269.1801148.13653507616866096035.stgit@frogsfrogsfrogs>
In-Reply-To: <170405002254.1801148.6324602186356936873.stgit@frogsfrogsfrogs>
References: <170405002254.1801148.6324602186356936873.stgit@frogsfrogsfrogs>
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

Currently, xfs_scrub_all will try to invoke xfs_scrub with argv[1] being
"-n -x".  This of course is recognized by C getopt as a weird looking
string, not two individual arguments, and causes the child process to
exit with complaints about CLI usage.

What we really want is to split the string into a proper array and then
add them to the xfs_scrub command line.  The code here isn't strictly
correct, but as @scrub_args@ is controlled by us in the Makefile, it'll
do for now.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/xfs_scrub_all.in |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index d7d36e1bdb0..671d588177a 100644
--- a/scrub/xfs_scrub_all.in
+++ b/scrub/xfs_scrub_all.in
@@ -123,7 +123,9 @@ def run_scrub(mnt, cond, running_devs, mntdevs, killfuncs):
 				return
 
 		# Invoke xfs_scrub manually
-		cmd=['@sbindir@/xfs_scrub', '@scrub_args@', mnt]
+		cmd = ['@sbindir@/xfs_scrub']
+		cmd += '@scrub_args@'.split()
+		cmd += [mnt]
 		ret = run_killable(cmd, None, killfuncs, \
 				lambda proc: proc.terminate())
 		if ret >= 0:

