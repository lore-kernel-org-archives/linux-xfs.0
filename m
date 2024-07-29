Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E19584D34
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jul 2024 19:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722280796; cv=none; b=HZkWnF4threfTmN0rp2Q5XIV/5n/CJF8RqF9YrlFt+TUqTwNJD4JK2VnACt4tTXLBoZ+blM4tOHHPpoMV3LAuq1Rbysn/LTi6fad3AmXlRrehbhgV3owZg8XQoORyczS2zoQRop9adfR5hkG1Up3BFM4ZwRG1Xz9O0K0skIAkyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722280796; c=relaxed/simple;
	bh=3uTVSbRHgsssPozBWf2HQiXR0gAGuluC9YvcTdkzUv4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ZF7v46EQHP1sNRQjpILsjLWHG20F2/D70A6Kt1W1X5Tl0tTMTTFGoJsl9Coq4WBKz4BBdVNGvKa9etpPIRJ6ASYlatJzDOBup4sxRSyDlKMEb6/zHMXUa1yFSd4T9Qz2xuUCRneS3GWMeYImZcqsmMDSPpomwrDr5v9UBAgmQTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cBLqjCr9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cBLqjCr9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C50C32786;
	Mon, 29 Jul 2024 19:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722280795;
	bh=3uTVSbRHgsssPozBWf2HQiXR0gAGuluC9YvcTdkzUv4=;
	h=Date:From:To:Cc:Subject:From;
	b=cBLqjCr9p8S5EyNA+5CglkRWAWH6ITTyHnc9Xz7UlVK6idvz4mbqW04EmEWRmz1Pv
	 GrZ0PyTeAEbKbgTVgIOgn0Os2v9CfO3di6sgwqpKanFM42aW1hP5EXEFZzAgTaHRXP
	 gqkFoPoq63n/KLKqRvSOfglbz3b85zeJbLTXPodoTegpdf7IiaXZffE5lxm4uLUzLv
	 Eui/zA8+kqqttzTklLGymNYC2+X1SWCHBESPQXlvBmx6Lrj6BGXmY5JkVH6j01M4IL
	 cVbkEU57THOO6zwPtCVJvYKDEg+CCndj79U5bzzA8vXFApT55X3PPXEwJ+Hz5XLXp7
	 RQg3krnAwhGeg==
Date: Mon, 29 Jul 2024 12:19:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Santiago Kraus <santiago_kraus@yahoo.com>,
	tobias.powalowski@googlemail.com, xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs_repair: don't crash on -vv
Message-ID: <20240729191955.GC6374@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

A user reported a crash in xfs_repair when they run it with -vv
specified on the command line.  Ultimately this harks back to xfs_m in
main() containing uninitialized stack contents, and inadequate null
checks.  Fix both problems in one go.

Reported-by: Santiago Kraus <santiago_kraus@yahoo.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/progress.c   |    2 +-
 repair/xfs_repair.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/repair/progress.c b/repair/progress.c
index 07cf4e4f2baf..74e7a671962e 100644
--- a/repair/progress.c
+++ b/repair/progress.c
@@ -394,7 +394,7 @@ timestamp(
 	time_t			now;
 	struct tm		*tmp;
 
-	if (verbose > 1 && mp && mp->m_ddev_targp)
+	if (verbose > 1 && mp && mp->m_ddev_targp && mp->m_ddev_targp->bcache)
 		cache_report(stderr, "libxfs_bcache", mp->m_ddev_targp->bcache);
 
 	now = time(NULL);
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 39884015300a..e325d61f1036 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -1029,7 +1029,7 @@ main(int argc, char **argv)
 	xfs_mount_t	*temp_mp;
 	xfs_mount_t	*mp;
 	struct xfs_buf	*sbp;
-	xfs_mount_t	xfs_m;
+	struct xfs_mount xfs_m = { };
 	struct xlog	log = {0};
 	char		*msgbuf;
 	struct xfs_sb	psb;
