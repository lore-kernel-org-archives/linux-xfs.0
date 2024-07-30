Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61ACCD528
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722301124; cv=none; b=Xb3SWqFxJu/MmJtlHmDVkU5p+GEoecf0Lt6uUAE1vpnHOwRIdnuSvamV4SvUoUzM5bXx385xi8qIgozEnMrLDsH4WZH5Dhb8yl/qwJmPwJMNeu1WCBk27FjaAlc/IkdVyv+GjC3QhfXOvuaWzKiVb9XK7/u8HUk5Wp+AFwXblgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722301124; c=relaxed/simple;
	bh=5SdjwVqRD08+aXCh9lrFYzDFhWkLBydV4p9swI4HNjc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J2x8vGHEhU+9Sp6D/sJ6T8zbRdcxWz8tSr2bWcHq+oS+GnftBCrAk0ufnFeljI/ahFoqo1o1Zd+noLshEqH8SMPpqvQhYK1MXNwXw8oL1tn6xKWjXEePn0uCRO/TLQIrsDr5+D+Pc7pHrJaDa6AGGog7ryfIyhc4Cee3IS+Kh/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tv7N5kMQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tv7N5kMQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A768C32786;
	Tue, 30 Jul 2024 00:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722301124;
	bh=5SdjwVqRD08+aXCh9lrFYzDFhWkLBydV4p9swI4HNjc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tv7N5kMQq2rk5RnZ6YDu2IOY4uRM3IYHRxn2y8QilOHa1311CU5MbjeXku7do67Zl
	 D/NH3NkmkAA3zTJG/TTEcdds98Q2B6ftm3C7Ma1psBGRKn4Ub3d/XriGRhwrFVHgCM
	 yv4vV1DP8OI2wUquXb0KGpg8aJKTs/AhGWLb96qw8hZiwVRCcUHSzNKVRLGSbMLG9p
	 M+ZkLNgK2VnArTByjezFU8Vd1hamONPrlp6KYlwUi2o1mumVlxJpkUlagw4S04rXef
	 TQsv+4e7bz2UpYBMaIEhpxwjdo6QpI7coRzDcgNC6xSc2QsCbVGw8ytZhTkTAbTxpw
	 OxqPyppBho3jw==
Date: Mon, 29 Jul 2024 17:58:43 -0700
Subject: [PATCH 4/5] xfs_scrub: require primary superblock repairs to complete
 before proceeding
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229845602.1345742.11240664872191396236.stgit@frogsfrogsfrogs>
In-Reply-To: <172229845539.1345742.12185001279081616156.stgit@frogsfrogsfrogs>
References: <172229845539.1345742.12185001279081616156.stgit@frogsfrogsfrogs>
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

Phase 2 of the xfs_scrub program calls the kernel to check the primary
superblock before scanning the rest of the filesystem.  Though doing so
is a no-op now (since the primary super must pass all checks as a
prerequisite for mounting), the goal of this code is to enable future
kernel code to intercept an xfs_scrub run before it actually does
anything.  If this some day involves fixing the primary superblock, it
seems reasonable to require that /all/ repairs complete successfully
before moving on to the rest of the filesystem.

Unfortunately, that's not what xfs_scrub does now -- primary super
repairs that fail are theoretically deferred to phase 4!  So make this
mandatory.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/phase2.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/scrub/phase2.c b/scrub/phase2.c
index 80c77b287..2d49c604e 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -174,7 +174,8 @@ phase2_func(
 	ret = scrub_primary_super(ctx, &alist);
 	if (ret)
 		goto out_wq;
-	ret = action_list_process_or_defer(ctx, 0, &alist);
+	ret = action_list_process(ctx, -1, &alist,
+			XRM_FINAL_WARNING | XRM_NOPROGRESS);
 	if (ret)
 		goto out_wq;
 

