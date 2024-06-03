Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37132139587
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 18:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717441146; cv=none; b=Mw1hk2eXW/OIF1YgHEX0I4UUdB/9lpxoOnz3/DUm/lYuUgcpj9ybkfkZqTKdlsSrSClEf5jkebsgGzRvL3+3xfpajDt/cvJ6QN+N2cazP2VzJvs0pZopICFrjUzLg3DFHYLQnWNqn7qjjma4oYP+tP+EfT32nCQnnovWS12CwPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717441146; c=relaxed/simple;
	bh=3yDl2/7nyBG+dbytDepTZTr+ZuCj50SqYg2duQmQ+P8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tWmQx8IZGmaTVnMmCRIHjeqF3RdqexHgeX13PpN2ifhT9EEmRY00vwTu2thEOCseeBq78QBv3RkAa4JCBFM9EfHdJJtRSQz1czQRJEtrYRkzIsfyOhORiLMld/dSXPvfdbC3CSOf59JResnVVFZUMtFN4JsC8XXh8cMzIolxyJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mJk4XCdD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mJk4XCdD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B26C2BD10;
	Mon,  3 Jun 2024 18:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717441146;
	bh=3yDl2/7nyBG+dbytDepTZTr+ZuCj50SqYg2duQmQ+P8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mJk4XCdDRfJglmKaGTxn1nThpwuxAYJDAYQhMpOj4OgyAGvnMWEftwQSN3caB5oyG
	 fTD/jy/Sn8FJM6x3+uGSEZvmYkwDrpQP0GHb7wamITp5L6UMmeinSj9PqoxFcIT/Gn
	 dzeDQ1QT5qRyQDZyPqsXsilvh11b2XJeTRy/tmGBflcc1ODFRZ91on+6f/IzQUJS7o
	 xwFU5t2xp1E/zDaI/5HCUq6AT2MkxmZqB2oLov84/h4ZPLJkbOnHCrbhQZVDcZ5Gyf
	 EzlcBWoGeA2enQEyh6ZrH+q5R+udSaFFEAWroNI4cHYrweSIbyVUBSzMHhFast/3Eu
	 KwWaarSQqyFOA==
Date: Mon, 03 Jun 2024 11:59:05 -0700
Subject: [PATCH 027/111] xfs: update health status if we get a clean bill of
 health
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744039776.1443973.17387346283529970854.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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

Source kernel commit: a1f3e0cca41036c3c66abb6a2ed8fedc214e9a4c

If scrub finds that everything is ok with the filesystem, we need a way
to tell the health tracking that it can let go of indirect health flags,
since indirect flags only mean that at some point in the past we lost
some context.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_fs.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index b5c8da7e6..ca1b17d01 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -714,9 +714,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_FSCOUNTERS 24	/* fs summary counters */
 #define XFS_SCRUB_TYPE_QUOTACHECK 25	/* quota counters */
 #define XFS_SCRUB_TYPE_NLINKS	26	/* inode link counts */
+#define XFS_SCRUB_TYPE_HEALTHY	27	/* everything checked out ok */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	27
+#define XFS_SCRUB_TYPE_NR	28
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1u << 0)

