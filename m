Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8101841
	for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2023 02:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g2BQCh7w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5E5C433C8;
	Thu,  7 Dec 2023 02:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701916949;
	bh=GM0fzN9Pa1Bnvr/bRB0pI8dyYt0K7S03d1dWcgR07t4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=g2BQCh7wwRnsqUZfTJhn9HdkCAJ8zoyaE7bXzrr8KSwT6O3mqcF7nLEwe5vkPc8AU
	 SxEAKDhc/hgNPlm2l4lKiTFL3QXDhvkv/jGzBJpNYhH36FN0bbSCW0NUcmt+MPg0io
	 jziI1JzwVXKL5kTqeqeFAZYpodfJ2fcenCLsvSKi63UwGulzoW/bnBj0Y64uZtptfc
	 TOzjkj9mvZTNoE82IZhcnZfTeoBchVAK1jP/cZyIht0SK62I0WnWTX4Z3Iiz02k5Wd
	 WztflMHDhz6E4Mkm7fUfT/uI9C+soxszwDQH08wi2NEMFPbbD6c2pGH5EilNwDsInf
	 BkgWmD+Cw1lQQ==
Date: Wed, 06 Dec 2023 18:42:29 -0800
Subject: [PATCH 3/9] xfs: add missing nrext64 inode flag check to scrub
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170191666156.1182270.4515850685074017228.stgit@frogsfrogsfrogs>
In-Reply-To: <170191666087.1182270.4104947285831369542.stgit@frogsfrogsfrogs>
References: <170191666087.1182270.4104947285831369542.stgit@frogsfrogsfrogs>
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

Add this missing check that the superblock nrext64 flag is set if the
inode flag is set.

Fixes: 9b7d16e34bbeb ("xfs: Introduce XFS_DIFLAG2_NREXT64 and associated helpers")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/inode.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 7e97db8255c63..6c40f3e020eae 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -342,6 +342,10 @@ xchk_inode_flags2(
 	if (xfs_dinode_has_bigtime(dip) && !xfs_has_bigtime(mp))
 		goto bad;
 
+	/* no large extent counts without the filesystem feature */
+	if ((flags2 & XFS_DIFLAG2_NREXT64) && !xfs_has_large_extent_counts(mp))
+		goto bad;
+
 	return;
 bad:
 	xchk_ino_set_corrupt(sc, ino);

