Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98EDC19CC13
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725301403; cv=none; b=BfnNJLROPBQ/zfQcENjhMLdN+Hi4ZAQ9KLgHGv1P1D3FaQuZ4lM1BTQoH2jt5PimkiOKUud02w+pda/bDxxuy8SYjtH7FymRFOfF3Fy2t28GyS6aAEi/+f9ZXHfpMgyAE9zVm6PST19NJYkOkIC8ovNBPWfmbMfzoUUxLL5vuMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725301403; c=relaxed/simple;
	bh=3aXwgQgjWvfhf6ybbBvm/dEtiVoedmXMSGUbLjzNM2s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ifO3LsMqS0x8H+VysfOTIZJdkgAzg6XsdGuOvO7hfQ8AjmwvwiJwobMRlGUJC09xxKxD9AQu5vPUP0VTKOMD2alz2jP7ybrf2h2BOopWzK9HW3bJNtF6CUk1JFLM7jpvsjm4arPJ3yCTfkYmM76Lo2dR/H83ytAJPcKt0AMR3D4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QvjJeWno; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QvjJeWno"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AEAFC4CEC2;
	Mon,  2 Sep 2024 18:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725301403;
	bh=3aXwgQgjWvfhf6ybbBvm/dEtiVoedmXMSGUbLjzNM2s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QvjJeWnoi04v9dUHGpg1kIsWEotrYvhesc9HngGvOMRd/429AKiOXyQ0bHs20iLOe
	 54AVRKF+VAbJ8I9tF5YplUQb2F1rtEMzYJMVEQaZo4knRa/wgTBcoJF1zAmoBiiHBP
	 kt5T1VutxBDDT+J8U+j58fPkLGyQExFdxzV5+O7Gp8o+x0nQjyMptabFAIF2ZcZCtk
	 our4h74I4rvJCNkQWdBcu0KjhGJL/jO6d0OIds4Mav7/elsJwWPiWhkaCKRIHR1LSe
	 HcffdlKcmXj8PWmo6Omy8U4+B987HHjDEcZ4pbzcli19Yo27/zrUSFncQxqJoqkmgb
	 3L5siGCNFU5sQ==
Date: Mon, 02 Sep 2024 11:23:22 -0700
Subject: [PATCH 1/3] xfs: validate inumber in xfs_iget
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <172530105323.3324987.17852010194613598900.stgit@frogsfrogsfrogs>
In-Reply-To: <172530105300.3324987.5977059243804546726.stgit@frogsfrogsfrogs>
References: <172530105300.3324987.5977059243804546726.stgit@frogsfrogsfrogs>
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

Actually use the inumber validator to check the argument passed in here.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_icache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index cf629302d48e..887d2a01161e 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -755,7 +755,7 @@ xfs_iget(
 	ASSERT((lock_flags & (XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED)) == 0);
 
 	/* reject inode numbers outside existing AGs */
-	if (!ino || XFS_INO_TO_AGNO(mp, ino) >= mp->m_sb.sb_agcount)
+	if (!xfs_verify_ino(mp, ino))
 		return -EINVAL;
 
 	XFS_STATS_INC(mp, xs_ig_attempts);

